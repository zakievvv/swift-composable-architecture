import Foundation

#if canImport(AppKit)
  import AppKit
#endif
#if canImport(UIKit)
  import UIKit
#endif
#if canImport(WatchKit)
  import WatchKit
#endif

@_spi(Internals)
public var willResignNotificationName: Notification.Name? {
  #if os(iOS) || os(tvOS) || os(visionOS)
    return UIApplication.willResignActiveNotification
  #elseif os(macOS)
    return NSApplication.willResignActiveNotification
  #elseif os(watchOS)
    return WKExtension.applicationWillResignActiveNotification
  #else
    return nil
  #endif
}

// The original `let = { ... }()` form runs the closure at module-init
// time on a nonisolated context. Swift 6.4 (Xcode 27) rejects that on
// watchOS because `WKExtension.applicationWillEnterForegroundNotification`
// is `@MainActor`-isolated:
//   error: main actor-isolated default value in a nonisolated context
// Convert to computed properties (matching `willResignNotificationName`'s
// pattern above) so each access opens its own evaluation context where
// the actor isolation requirement can be satisfied or elided.
@_spi(Internals)
public var willEnterForegroundNotificationName: Notification.Name? {
  #if os(iOS) || os(tvOS) || os(visionOS)
    return UIApplication.willEnterForegroundNotification
  #elseif os(macOS)
    return NSApplication.willBecomeActiveNotification
  #elseif os(watchOS)
    return WKExtension.applicationWillEnterForegroundNotification
  #else
    return nil
  #endif
}

@_spi(Internals)
public var willTerminateNotificationName: Notification.Name? {
  #if os(iOS) || os(tvOS) || os(visionOS)
    return UIApplication.willTerminateNotification
  #elseif os(macOS)
    return NSApplication.willTerminateNotification
  #else
    return nil
  #endif
}

var canListenForResignActive: Bool {
  willResignNotificationName != nil
}
