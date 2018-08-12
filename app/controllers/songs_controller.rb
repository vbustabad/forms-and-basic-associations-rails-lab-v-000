class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
  end

  def create
    genre = Genre.find_or_create_by(name: params[:song][:genre_name])
    @song = Song.new(title: params[:song][:title], artist_name: params[:song][:artist_name], genre: genre, note_contents: params[:song][:note_contents][])

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  def artist_name=(name)
    self.artist = Artist.find_or_create_by(name: name)
  end

  def artist_name
     self.artist ? self.artist.name : nil
  end

  def genre_name=(name)
    self.genre = Genre.find_or_create_by(name: name)
  end

  def genre_name
     self.genre ? self.genre.name : nil
  end

  def note_contents=(contents)
    contents.each do |content|
      note = Note.find(content)
      self.notes << note
    end
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :genre_id, note_contents: [])
  end
end
