class Song < ApplicationRecord
  @current_year = Time.now.year
  validates :title, presence: true
  #validates :released, inclusion: { in: %w(true false) }
  validates :release_year, presence: true, if: :released, numericality: { less_than_or_equal_to: Time.now.year }
  validates :artist_name, presence: true
  validate :no_title_repeat

  def no_title_repeat
    if title && songs_by_artist
      errors.add(:repeat_song_title, "#{self.artist_name} already released a song titled #{title} in #{self.release_year}")
    end
  end

  def songs_by_artist
    Song.where(artist_name: self.artist_name, release_year: self.release_year).size > 1
  end
end
