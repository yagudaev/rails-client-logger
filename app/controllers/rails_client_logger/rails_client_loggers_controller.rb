module RailsClientLogger
  class RailsClientLoggersController < ApplicationController
    def log
      if %w(debug info warn error fatal).include?(params[:level].to_s)
        level = params[:level].to_s.to_sym
        Rails.logger.send(level, params[:message])
        ExceptionNotifier.notify_exception(params[:message]) if level == :fatal or level == :error
        head :ok
      else
        head :bad_request
      end
    end

    def log_params
      params.permit(:level, :message)
    end
  end
end
