Return-Path: <kvm+bounces-29376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90B689AA0A6
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:58:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6A7BB233EF
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9AFF19DF66;
	Tue, 22 Oct 2024 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EaLk2+Sy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADAC19D080
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594598; cv=none; b=AzgOZhpp7PB+ywkvLV+Z6brSiv3U3kYAr3K9zJSE6FVWgY/WsvOaoeDzUMW6KJAi6EB/1wDZOvWi2DfNd/UqKjCME4S0GnjaLGjGKv2bEdgd2Payn8XGkWCnXs2DrmdAWJwqGqaYoxeY2ZNERWO6MGDlTdeGy71ugZaJUeKN3eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594598; c=relaxed/simple;
	bh=gx7elASkKACRM34GNEWipezg+FLNYL4fWbpRkWi7xsk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tW8HxbN8VZ2rHnIqP1rSF18OdsWmBZ4kPV8mH7kww/JjkerM4QqpY+NjhMEcBF9//HYR5Vp9WESOnMICfrX8QryU/Gjvu52Wmllo2f6D+AykhaY/eW6RAN16PYTPkgW4KBt7p6s2rChcNrIOdQJ9VFYlYf5aUgvPC2cPxUYuMM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EaLk2+Sy; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cb15b84544so3238027a12.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594595; x=1730199395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1RT2huJ5JZoTziBJ4jD+CCwuEKWgio+GHjHj5uuvtc=;
        b=EaLk2+SyoYx73S57iiWYF9rSx8ubLMYu24E2j+fPy8eGnlG3tuhYo/0Z9kJy2YLBL1
         04e6G5xUv0L0glsrIfQPd73PqrLk5tC08vg1v8KXbsz5HKPyEEnfW+Oz/8P41Qf8AiKm
         9UyNAarw/GykvPilTIqm/zMfAjk2NwCMFy3pUU5m4tGM+wPWk0bF8el6R/GuJrtT7Xq8
         vquTyaG+FvpZB8vSgqJ6x/7xcWLELSJa14Du8ylpX/ZKyn2qbOgZWZbyFjk0FmYiKmOn
         J211YB+kobX95+5I99hXIP5qxFPi3ckk6C3YOX56cnJL2+NlnzLye+/WPvFJxOiZJM1R
         wn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594595; x=1730199395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A1RT2huJ5JZoTziBJ4jD+CCwuEKWgio+GHjHj5uuvtc=;
        b=ZB4d82hkkXesJrNPqmQqQx8R3+tUEJcPn4zdQg6kRQfUSrKHXoVDA5kx1mZTRmzRas
         3KoGb6/SV/xEIuyjJDyEaQHLds5uGaz3se0jSiPCTdL/ccPbZEWU2YoyVNRlrhUSh0Rl
         OteWyK9vTAFyG9w9nkntp1litUBiYJOjej3I4f1zNb9S/+geRj+wlsuuxgW0ZXuxkCRC
         Q21IJQi2eW15M5EUk/kp+Vy/PCnUzlgxCYfUKAJMKU0QO5jIdGHyC0mk4QrZpYF5rOLQ
         LfT1J7dXzBdD4sxNI2tGmNgCZktBSxF2H3P+DqBGK8QE+hLdb9+PQHSwNvw+As8U20oo
         gBJw==
X-Forwarded-Encrypted: i=1; AJvYcCVNWTmlPxlr0O1sSz7CihQWcweKqW+oObbyTZNQwD/wFAMKewXql9dMT5mS1xeJT3hxqE4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy324e00hzzcRNUaQdPlQRmt1IJPkAvSttZ1LQmHpI58b0fq/0F
	exdB8L8KzagvH6bhOhux3ZcJfbX4O2MDZTkb37zP4UUQ5j5usB78QTt8fVRGJPY=
X-Google-Smtp-Source: AGHT+IH8FwAH1RdgvHht2IWETizlhtV8RNte8pvJdWVu1cT97HP0xl8CflJaCO4tn8KeVgLbDH6oBA==
X-Received: by 2002:a17:907:6d0b:b0:a77:c30c:341 with SMTP id a640c23a62f3a-a9a694c71b9mr1507028066b.0.1729594595306;
        Tue, 22 Oct 2024 03:56:35 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912ee04asm324230166b.61.2024.10.22.03.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:30 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 4FCF95FC47;
	Tue, 22 Oct 2024 11:56:16 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	devel@lists.libvirt.org,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Riku Voipio <riku.voipio@iki.fi>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 19/20] contrib/plugins: remove Makefile for contrib/plugins
Date: Tue, 22 Oct 2024 11:56:13 +0100
Message-Id: <20241022105614.839199-20-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241022105614.839199-1-alex.bennee@linaro.org>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Now replaced by meson build.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Message-Id: <20240925204845.390689-3-pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 configure                | 18 ---------
 Makefile                 | 10 -----
 contrib/plugins/Makefile | 87 ----------------------------------------
 3 files changed, 115 deletions(-)
 delete mode 100644 contrib/plugins/Makefile

diff --git a/configure b/configure
index 7dd3400ccb..101ca9ace9 100755
--- a/configure
+++ b/configure
@@ -1073,7 +1073,6 @@ if test "$plugins" != "no" && test $host_bits -eq 64; then
         plugins="no"
     else
         plugins=yes
-        subdirs="$subdirs contrib/plugins"
     fi
 fi
 
@@ -1704,7 +1703,6 @@ LINKS="$LINKS .gdbinit scripts" # scripts needed by relative path in .gdbinit
 LINKS="$LINKS tests/avocado tests/data"
 LINKS="$LINKS tests/qemu-iotests/check tests/qemu-iotests/Makefile"
 LINKS="$LINKS python"
-LINKS="$LINKS contrib/plugins/Makefile "
 for f in $LINKS ; do
     if [ -e "$source_path/$f" ]; then
         symlink "$source_path/$f" "$f"
@@ -1790,22 +1788,6 @@ if test "$default_targets" = "yes"; then
   echo "CONFIG_DEFAULT_TARGETS=y" >> $config_host_mak
 fi
 
-# contrib/plugins configuration
-echo "# Automatically generated by configure - do not modify" > contrib/plugins/$config_host_mak
-echo "SRC_PATH=$source_path/contrib/plugins" >> contrib/plugins/$config_host_mak
-echo "PKG_CONFIG=${pkg_config}" >> contrib/plugins/$config_host_mak
-echo "CC=$cc $CPU_CFLAGS" >> contrib/plugins/$config_host_mak
-echo "CFLAGS=${CFLAGS-$default_cflags} $EXTRA_CFLAGS" >> contrib/plugins/$config_host_mak
-if test "$host_os" = windows; then
-  echo "DLLTOOL=$dlltool" >> contrib/plugins/$config_host_mak
-fi
-if test "$host_os" = darwin; then
-  echo "CONFIG_DARWIN=y" >> contrib/plugins/$config_host_mak
-fi
-if test "$host_os" = windows; then
-  echo "CONFIG_WIN32=y" >> contrib/plugins/$config_host_mak
-fi
-
 # tests/tcg configuration
 mkdir -p tests/tcg
 echo "# Automatically generated by configure - do not modify" > tests/tcg/$config_host_mak
diff --git a/Makefile b/Makefile
index 917c9a34d1..b65b0bd41a 100644
--- a/Makefile
+++ b/Makefile
@@ -187,11 +187,6 @@ SUBDIR_RULES=$(foreach t, all clean distclean, $(addsuffix /$(t), $(SUBDIRS)))
 $(SUBDIR_RULES):
 	$(call quiet-command,$(MAKE) $(SUBDIR_MAKEFLAGS) -C $(dir $@) V="$(V)" TARGET_DIR="$(dir $@)" $(notdir $@),)
 
-ifneq ($(filter contrib/plugins, $(SUBDIRS)),)
-.PHONY: plugins
-plugins: contrib/plugins/all
-endif
-
 .PHONY: recurse-all recurse-clean
 recurse-all: $(addsuffix /all, $(SUBDIRS))
 recurse-clean: $(addsuffix /clean, $(SUBDIRS))
@@ -307,11 +302,6 @@ help:
 	$(call print-help,cscope,Generate cscope index)
 	$(call print-help,sparse,Run sparse on the QEMU source)
 	@echo  ''
-ifneq ($(filter contrib/plugins, $(SUBDIRS)),)
-	@echo  'Plugin targets:'
-	$(call print-help,plugins,Build the example TCG plugins)
-	@echo  ''
-endif
 	@echo  'Cleaning targets:'
 	$(call print-help,clean,Remove most generated files but keep the config)
 	$(call print-help,distclean,Remove all generated files)
diff --git a/contrib/plugins/Makefile b/contrib/plugins/Makefile
deleted file mode 100644
index bbddd4800f..0000000000
--- a/contrib/plugins/Makefile
+++ /dev/null
@@ -1,87 +0,0 @@
-# -*- Mode: makefile -*-
-#
-# This Makefile example is fairly independent from the main makefile
-# so users can take and adapt it for their build. We only really
-# include config-host.mak so we don't have to repeat probing for
-# programs that the main configure has already done for us.
-#
-
-include config-host.mak
-
-TOP_SRC_PATH = $(SRC_PATH)/../..
-
-VPATH += $(SRC_PATH)
-
-NAMES :=
-NAMES += bbv
-NAMES += execlog
-NAMES += hotblocks
-NAMES += hotpages
-NAMES += howvec
-
-# The lockstep example communicates using unix sockets,
-# and can't be easily made to work on windows.
-ifneq ($(CONFIG_WIN32),y)
-NAMES += lockstep
-endif
-
-NAMES += hwprofile
-NAMES += cache
-NAMES += drcov
-NAMES += ips
-NAMES += stoptrigger
-NAMES += cflow
-
-ifeq ($(CONFIG_WIN32),y)
-SO_SUFFIX := .dll
-LDLIBS += $(shell $(PKG_CONFIG) --libs glib-2.0)
-else
-SO_SUFFIX := .so
-endif
-
-SONAMES := $(addsuffix $(SO_SUFFIX),$(addprefix lib,$(NAMES)))
-
-# The main QEMU uses Glib extensively so it is perfectly fine to use it
-# in plugins (which many example do).
-PLUGIN_CFLAGS := $(shell $(PKG_CONFIG) --cflags glib-2.0)
-PLUGIN_CFLAGS += -fPIC -Wall
-PLUGIN_CFLAGS += -I$(TOP_SRC_PATH)/include/qemu
-
-# Helper that honours V=1 so we get some output when compiling
-quiet-@ = $(if $(V),,@$(if $1,printf "  %-7s %s\n" "$(strip $1)" "$(strip $2)" && ))
-quiet-command = $(call quiet-@,$2,$3)$1
-
-# for including , in command strings
-COMMA := ,
-
-all: $(SONAMES)
-
-%.o: %.c
-	$(call quiet-command, \
-		$(CC) $(CFLAGS) $(PLUGIN_CFLAGS) -c -o $@ $<, \
-	        BUILD, plugin $@)
-
-ifeq ($(CONFIG_WIN32),y)
-lib%$(SO_SUFFIX): %.o win32_linker.o ../../plugins/libqemu_plugin_api.a
-	$(call quiet-command, \
-		$(CC) -shared -o $@ $^ $(LDLIBS), \
-		LINK, plugin $@)
-else ifeq ($(CONFIG_DARWIN),y)
-lib%$(SO_SUFFIX): %.o
-	$(call quiet-command, \
-		$(CC) -bundle -Wl$(COMMA)-undefined$(COMMA)dynamic_lookup -o $@ $^ $(LDLIBS), \
-		LINK, plugin $@)
-else
-lib%$(SO_SUFFIX): %.o
-	$(call quiet-command, \
-		$(CC) -shared -o $@ $^ $(LDLIBS), \
-		LINK, plugin $@)
-endif
-
-
-clean distclean:
-	rm -f *.o *$(SO_SUFFIX) *.d
-	rm -Rf .libs
-
-.PHONY: all clean
-.SECONDARY:
-- 
2.39.5


