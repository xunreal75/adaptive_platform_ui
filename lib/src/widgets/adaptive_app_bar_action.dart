import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

/// Spacer type for toolbar items (iOS 26+ only)
enum ToolbarSpacerType {
  /// No spacer
  none,

  /// Fixed 12pt space - groups items within same section
  fixed,

  /// Flexible space - separates item groups (pushes next items to opposite side)
  flexible,
}

/// An app bar action that can be displayed in AdaptiveScaffold
///
/// - On iOS 26+: Uses iosSymbol (SF Symbol) in native UIToolbar
/// - On iOS < 26: Uses icon (IconData) in CupertinoNavigationBar
/// - On Android: Uses icon (IconData) in Material AppBar
class AdaptiveAppBarAction {
  const AdaptiveAppBarAction({
    this.iosSymbol,
    this.icon,
    this.iconWidget,
    this.title,
    required this.onPressed,
    this.spacerAfter = ToolbarSpacerType.none,
    this.prominent = false,
    this.tintColor,
    this.badge,
    this.indicator = false,
    this.badgeBackgroundColor,
    this.badgeForegroundColor,
  }) : assert(
         iosSymbol != null || icon != null || iconWidget != null || title != null,
         'At least one of iosSymbol, icon, iconWidget, or title must be provided',
       );

  /// SF Symbol name for iOS 26+ ONLY (e.g., 'info.circle', 'plus.circle')
  /// - iOS 26+: Uses UIImage(systemName:) in native UIBarButtonItem
  /// - iOS <26: NOT used, use icon parameter instead
  /// - Android: NOT used, use icon parameter instead
  final String? iosSymbol;

  /// Icon for iOS <26 and Android (e.g., Icons.info, CupertinoIcons.info)
  /// - iOS 26+: NOT used (iosSymbol takes priority)
  /// - iOS <26: Used for CupertinoButton
  /// - Android: Used for IconButton
  final IconData? icon;

  /// Custom icon widget for iOS <26 and Android (e.g., SvgPicture.asset)
  /// If provided, this widget is used instead of the icon parameter.
  final Widget? iconWidget;

  /// Text title for the action (optional)
  /// If provided along with icons, title takes precedence
  final String? title;

  /// Callback when the action is tapped
  final VoidCallback onPressed;

  /// Add spacer after this action in iOS 26+ toolbar
  /// - `none`: No spacer (default)
  /// - `fixed`: 12pt fixed space - groups items within same section
  /// - `flexible`: Flexible space - separates item groups (e.g., left vs right groups)
  ///
  /// Example: For Undo/Redo on left and Markup/More on right:
  /// ```dart
  /// actions: [
  ///   AdaptiveAppBarAction(iosSymbol: 'arrow.uturn.backward', ...),
  ///   AdaptiveAppBarAction(iosSymbol: 'arrow.uturn.forward', ..., spacerAfter: ToolbarSpacerType.flexible),
  ///   AdaptiveAppBarAction(iosSymbol: 'pencil', ...),
  ///   AdaptiveAppBarAction(iosSymbol: 'ellipsis', ...),
  /// ]
  /// ```
  final ToolbarSpacerType spacerAfter;

  /// Display this action with a prominent glass background (iOS 26+ only)
  /// - iOS 26+: Uses UIBarButtonItem.Style.prominent for a tinted glass bubble
  /// - iOS <26 / Android: Ignored
  final bool prominent;

  /// Per-action tint color (iOS 26+ only)
  /// Overrides the global AdaptiveAppBar.tintColor for this specific action.
  /// Useful for highlighting individual buttons (e.g., green call button).
  /// - iOS <26 / Android: Ignored
  final Color? tintColor;

  /// Badge text for iOS 26+ toolbar actions.
  /// - null: no badge
  /// - non-null: show badge text
  /// - iOS <26 / Android: Ignored
  final String? badge;

  /// Show a dot indicator when [badge] is null (iOS 26+ only).
  /// Defaults to false.
  /// - true + badge == null: show indicator
  /// - false + badge == null: no badge/indicator
  /// - iOS <26 / Android: Ignored
  final bool indicator;

  /// Badge background color for iOS 26+ toolbar actions.
  /// Applied to native `item.badge?.backgroundColor`.
  final Color? badgeBackgroundColor;

  /// Badge foreground/text color for iOS 26+ toolbar actions.
  /// Applied to native `item.badge?.foregroundColor`.
  final Color? badgeForegroundColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdaptiveAppBarAction &&
        other.iosSymbol == iosSymbol &&
        other.icon == icon &&
        other.iconWidget == iconWidget &&
        other.title == title &&
        other.prominent == prominent &&
        other.tintColor == tintColor &&
        other.badge == badge &&
        other.indicator == indicator &&
        other.badgeBackgroundColor == badgeBackgroundColor &&
        other.badgeForegroundColor == badgeForegroundColor;
  }

  @override
  int get hashCode => Object.hash(
        iosSymbol,
        icon,
        iconWidget,
        title,
        prominent,
        tintColor,
        badge,
        indicator,
        badgeBackgroundColor,
        badgeForegroundColor,
      );

  /// Convert action to map for native platform channel (iOS 26+ only)
  Map<String, dynamic> toNativeMap() {
    return {
      if (iosSymbol != null) 'icon': iosSymbol!,
      if (title != null) 'title': title!,
      'spacerAfter': spacerAfter.index, // 0=none, 1=fixed, 2=flexible
      if (prominent) 'prominent': true,
      if (tintColor != null) 'tint': tintColor!.toARGB32(),
      if (badge != null) 'badge': badge,
      if (indicator) 'indicator': true,
      if (badgeBackgroundColor != null)
        'badgeBackgroundColor': badgeBackgroundColor!.toARGB32(),
      if (badgeForegroundColor != null)
        'badgeForegroundColor': badgeForegroundColor!.toARGB32(),
    };
  }
}
