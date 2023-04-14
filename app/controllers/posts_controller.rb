class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  load_and_authorize_resource
  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.includes(:comments)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @author = User.find(params[:user_id])
    @post = @author.posts.new(post_params)

    if @post.save
      redirect_to user_path(id: @post.author_id), notice: 'Post was successfully created'

    else
      render :new, alert: 'Error ccurred while creating the post'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @author = @post.author
    @author.decrement!(:post_counter)
    @post.destroy!
    redirect_to user_posts_path(id: @author.id), notice: 'Post was deleted successfully!'
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
