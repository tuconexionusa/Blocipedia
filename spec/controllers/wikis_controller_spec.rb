require 'rails_helper'
include RandomData

RSpec.describe WikisController, type: :controller do

let(:my_user) { create(:user) }
let(:my_wiki) {create (:wiki) }

context "guest user not signed in" do

  describe "GET #show" do
    it "returns http success" do
      get :show, {id: my_wiki.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, {id: my_wiki.id}
      expect(response).to render_template :show
    end

    it "assigns my_wiki to @wiki" do
      get :show, {id: my_wiki.id}
      expect(assigns(:wiki)).to eq(my_wiki)
    end
  end

  describe "GET #new" do
    it "returns http redirect" do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST #create" do
    it "returns http redirect" do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET edit" do
     it "returns http redirect" do
       get :edit, {id: my_wiki.id,}
       expect(response).to redirect_to(new_user_session_path)
     end
  end

   describe "PUT update" do
      it "returns http redirect" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
        expect(response).to redirect_to(new_user_session_path)
       end
     end

   describe "DELETE destroy" do
       it "returns http redirect" do
         delete :destroy, {id: my_wiki.id}
         expect(response).to have_http_status(:redirect)
       end
     end
end

  context "Standard user with public wiki" do
    before do
      my_user.standard!
      sign_in(my_user)
      my_wiki.private = false
      my_wiki.save
    end

      describe "GET #edit" do

        it "returns http success" do
          get :edit, {id: my_wiki.id}
          expect(response).to have_http_status(:success)
        end

        it "renders the #edit view" do
          get :edit, {id: my_wiki.id}
          expect(response).to render_template :edit
        end

        it "assigs wiki to be updated to @wiki" do
          get :edit, {id: my_wiki.id}
          wiki_instance = assigns(:wiki)
            expect(wiki_instance.id).to eq my_wiki.id
            expect(wiki_instance.title).to eq my_wiki.title
            expect(wiki_instance.body).to eq my_wiki.body
        end
      end

      #it should render the show view

  end

  context "Standard user with private wiki" do
    before do
      my_user.standard!
      sign_in(my_user)
      my_wiki.private = true
      my_wiki.save
    end

    describe "GET #edit" do

      it "returns http redirect" do
        get :edit, {id: my_wiki.id}
        expect(response).to have_http_status(:redirect)
      end

      it "renders the #edit view" do
        get :edit, {id: my_wiki.id}
        expect(response).not_to render_template :edit
      end
    end
      #it should prevent me from creating private wikis
      #it should not render the show view
      #it should prevent me from editing private wikis
      #it should prevent me from updating private wikis
  end

  context "Premium user with private wiki" do
    before do
      my_user.premium!
      sign_in(my_user)
      my_wiki.private = true
      my_wiki.save
    end

    describe "GET #edit" do

      it "returns http success" do
        get :edit, {id: my_wiki.id}
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, {id: my_wiki.id}
        expect(response).to render_template :edit
      end
    end
      #it should render the show view
      #it should allow to edit private wikis
      #it should allow me to update private wikis
  end

context "Premium user with public wiki" do
     before do
       my_user.premium!
       sign_in(my_user)
       my_wiki.private = false
       my_wiki.save
     end

     describe "GET #index" do
       it "returns http success" do
         get :index
         expect(response).to have_http_status(:success)
       end

       it "assigns my_wiki to @wikis" do
         get :index
         expect(assigns(:wikis)).to eq([my_wiki])
       end
     end

      describe "GET #show" do
        it "returns http success" do
          get :show, {id: my_wiki.id}
          expect(response).to have_http_status(:success)
        end

        it "renders the #show view" do
          get :show, {id: my_wiki.id}
          expect(response).to render_template :show
        end

        it "assigns my_wiki to @wiki" do
          get :show, {id: my_wiki.id}
          expect(assigns(:wiki)).to eq(my_wiki)
        end
      end

      describe "GET #new" do
        it "returns http success" do
          get :new
          expect(response).to have_http_status(:success)
        end

        it "renders the #new view" do
          get :new
          expect(response).to render_template :new
        end

        it "instiantes @wiki" do
          get :new
          expect(assigns(:wiki)).not_to be_nil
        end
      end

      describe "POST #create" do
        it "increases the number of Wikis by 1" do
          expect{post :create, wiki: {user: my_user, title: RandomData.random_sentence, body: RandomData.random_paragraph}}.to change(Wiki, :count).by(1)
        end

        it "assigns the new wiki to @wiki" do
          post :create, wiki: {user: my_user, title: RandomData.random_sentence, body: RandomData.random_paragraph}
          expect(assigns(:wiki)).to eq Wiki.last
        end

        it "redirects to the new wiki" do
          post :create, wiki: {user: my_user, title: RandomData.random_sentence, body: RandomData.random_paragraph}
          expect(response).to redirect_to Wiki.last
        end
      end

      describe "GET #edit" do

        it "returns http success" do
          get :edit, {id: my_wiki.id}
          expect(response).to have_http_status(:success)
        end

        it "renders the #edit view" do
          get :edit, {id: my_wiki.id}
          expect(response).to render_template :edit
        end

        it "assigs wiki to be updated to @wiki" do
          get :edit, {id: my_wiki.id}
          wiki_instance = assigns(:wiki)
            expect(wiki_instance.id).to eq my_wiki.id
            expect(wiki_instance.title).to eq my_wiki.title
            expect(wiki_instance.body).to eq my_wiki.body
        end
      end

        describe "put update" do

          it "updates wikis with the expected attributes" do

            new_title = RandomData.random_sentence
            new_body = RandomData.random_paragraph

            put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body, user: my_user}

            updated_wiki = assigns(:wiki)
            expect(updated_wiki.id).to eq my_wiki.id
            expect(updated_wiki.title).to eq new_title
            expect(updated_wiki.body).to eq new_body
          end

          it "redirects to wikis view page" do

            new_title = RandomData.random_sentence
            new_body = RandomData.random_paragraph

            put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body, user: my_user}
            expect(response).to redirect_to my_wiki

          end
        end

        describe "DELETE destroy" do

          it "redirects to wikis index view" do
            delete :destroy, {id: my_wiki.id}
            expect(response).to redirect_to wikis_path
          end

          it "deletes the post" do
            delete :destroy, {id: my_wiki.id}
            count = Wiki.where({id: my_wiki.id}).size
            expect(count).to eq 0
          end
        end
     end
end
