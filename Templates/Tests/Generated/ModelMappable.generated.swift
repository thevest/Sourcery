// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// https://github.com/SwiftGen/StencilSwiftKit/blob/master/Documentation/tag-set.md
// https://github.com/kylef/Stencil
// https://cdn.rawgit.com/krzysztofzablocki/Sourcery/master/docs/index.html

import Foundation

private typealias Timestamp = UInt64

private struct Formatter {
  static let iso8601: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    return formatter
  }()
}

extension String {
  fileprivate var dateFromISO8601: Date? {
    // "Mar 22, 2017, 10:22 AM"
    return Formatter.iso8601.date(from: self)
  }
}

extension Date {
  fileprivate var iso8601: String {
    return Formatter.iso8601.string(from: self)
  }

  fileprivate static func fromTimestamp(_ timestamp: Timestamp) -> Date {
    return Date(timeIntervalSince1970: Double(timestamp) / 1000)
  }

  fileprivate var asTimestamp: Timestamp {
    return UInt64(1000 * timeIntervalSince1970)
  }
}











// MARK: ExampleModel Mappable
struct ExampleModel: Codable {
  let string: String
  let bool: Bool
  let someVariable: Double
  let someBoolThatsAnInt: Bool
  let someDateString: Date
  let whenItEndsInID: String
  // MARK: ExampleModel CodingKeys
  private enum CodingKeys: String, CodingKey {
    case string = "string"
    case bool = "bool"
    case someVariable = "some_variable_with_a_long_key"
    case someBoolThatsAnInt = "some_bool_thats_an_int"
    case someDateString = "some_date_string"
    case whenItEndsInID = "when_it_ends_in_uuid"
  }
  // MARK: ExampleModel Decodable
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    someBoolThatsAnInt = try container.decodeIfPresent(Int.self, forKey: .someBoolThatsAnInt) == 1
    if
      let someDateString = try container.decodeIfPresent(String.self, forKey: .someDateString),
      let date = someDateString.dateFromISO8601 {
      self.someDateString = date
    } else {
      self.someDateString = Date()
    }
    string = try container.decodeIfPresent(String.self, forKey: .string) ?? ""
    bool = try container.decodeIfPresent(Bool.self, forKey: .bool) ?? false
    someVariable = try container.decodeIfPresent(Double.self, forKey: .someVariable) ?? 0
    whenItEndsInID = try container.decodeIfPresent(String.self, forKey: .whenItEndsInID) ?? ""
  }
  // MARK: ExampleModel Encodable
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(string, forKey: .string)
    try container.encode(bool, forKey: .bool)
    try container.encode(someVariable, forKey: .someVariable)
    try container.encode(someBoolThatsAnInt ? 1 : 0, forKey: .someBoolThatsAnInt)
    try container.encode(someDateString.iso8601, forKey: .someDateString)
    try container.encode(whenItEndsInID, forKey: .whenItEndsInID)
  }
  // MARK: ExampleModel Dictionary
  func asDictionary() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary["string"] = string
    dictionary["bool"] = bool
    dictionary["someVariable"] = someVariable
    dictionary["someBoolThatsAnInt"] = someBoolThatsAnInt
    dictionary["someDateString"] = someDateString.asTimestamp
    dictionary["whenItEndsInID"] = whenItEndsInID
    return dictionary
  }
}
