# --------------------------------------------------------------------------
# ---------------------------------- SETTINGS ------------------------------
# --------------------------------------------------------------------------

set preset_search_terms to "cyclocross, cx bike, gravel bike, adidas 10, reebok 10"

set browser to "Firefox"
# set browser to "Google Chrome"

set default_days to ""
set default_max_price to ""

set city_search_urls to {"https://www.facebook.com/marketplace/adelaide/search", "https://www.facebook.com/marketplace/perth/search", "https://www.facebook.com/marketplace/109177059102294/search", "https://www.facebook.com/marketplace/brisbane/search", "https://www.facebook.com/marketplace/sydney/search", "https://www.facebook.com/marketplace/melbourne/search"}

# --------------------------------------------------------------------------
# -------------------------- CODE THAT RUNS THE THING ----------------------
# --------------------------------------------------------------------------

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars


set search_terms_input_string to display dialog "What do you want to search for?" default answer preset_search_terms
set search_terms_string to text returned of search_terms_input_string

set AppleScript's text item delimiters to ", "
set the search_terms_list to every text item of the search_terms_string
set AppleScript's text item delimiters to ""


set params to "?"

set max_price_input to display dialog "Whats the max price to search for (blank for no max)?" default answer default_max_price
set max_price to text returned of max_price_input

if (max_price) � "" then set params to params & "maxPrice=" & max_price & "&"

set num_days_input to display dialog "How many days since posted do you want to check (blank for all dates)?" default answer default_days
set num_days to text returned of num_days_input

if (num_days) � "" then set params to params & "daysSinceListed=" & num_days & "&"


with timeout of 3600 seconds
	repeat with search_term in search_terms_list
		set theDialogText to "Click Continue to proceed to the search for '" & search_term & "'"
		with timeout of 3600 seconds
			display dialog theDialogText buttons {"End", "Skip", "Continue"} default button "Continue" cancel button "End"
		end timeout
		repeat 1 times
			if the button returned of the result is "Skip" then exit repeat
			repeat with location_url in city_search_urls
				set this_url to replace_chars(location_url & params & "query=" & search_term, " ", "%20")
				tell application browser
					activate
					open location this_url
				end tell
				delay 0.1
			end repeat
		end repeat
	end repeat
end timeout
with timeout of 3600 seconds
	display alert "Searches complete"
end timeout