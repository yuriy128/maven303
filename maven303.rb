require 'formula'

class Maven303 <Formula
  url 'http://archive.apache.org/dist/maven/binaries/apache-maven-3.0.3-bin.tar.gz'
  homepage 'http://maven.apache.org/'
  sha256 'b845479bd5d6d821210d3530c65da628a118abedd176492741e1d9bc5e400e2a'

  depends_on :java

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, Dir["conf/settings.xml"]
    
    prefix.install %w{ NOTICE.txt LICENSE.txt README.txt }
    libexec.install Dir['*']
    
        # Symlink binaries
    bin.mkpath
    ln_s "#{libexec}/bin/mvn", bin+"mvn"
    ln_s "#{libexec}/bin/mvnDebug", bin+"mvnDebug"
    ln_s "#{libexec}/bin/mvnyjp", bin+"mvnyjp"

    # Leave conf file in libexec. The mvn symlink will be resolved and the conf
    # file will be found relative to it
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?
      basename = file.basename
      next if basename.to_s == "m2.conf"
      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end
end
