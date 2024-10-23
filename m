Return-Path: <kvm+bounces-29497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D90BE9AC955
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:44:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95DCD2868CB
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF9F1AB501;
	Wed, 23 Oct 2024 11:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oFFktXOQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9450D1AB6C4
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683851; cv=none; b=AqAVn9IY7BlZ26zyHhONGm5BW6OG4AQQLYz3ea8IuWzjgMPfxXZ8+flsknDdAh6SxqWnQI+ecaoTFNmXzGseS8ZHsBGOAB5rf8re1l6lPng//DqWi3V+5eqNZSJh4eNXn00KQfmQeLuzVxLLmiept3wDlyJ4BPt17bUwe3R2iqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683851; c=relaxed/simple;
	bh=gx7elASkKACRM34GNEWipezg+FLNYL4fWbpRkWi7xsk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tKZfMOxyccGbFVJrWCITCUu7Q3GiSW0nVJIUg9/Ki5sZTr/Kk9Sdp0mRmaTJoNdnd0jQn8YN0xjoTfIBqffxroZBVsI27CqtkexVZijVeHs+E8uuBlVgQewbDvXABK14NrbqyYz72/NKolR6OEGWpdnuWaiDcdg5+sE4J6OaBbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oFFktXOQ; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539d9fffea1so6324297e87.2
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683848; x=1730288648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1RT2huJ5JZoTziBJ4jD+CCwuEKWgio+GHjHj5uuvtc=;
        b=oFFktXOQ/ojcyuo9pofFp6fwnh4Yb1692/BAYaxoWPcWh9d703EoJSDofRKZS4Yz84
         XOPaLZGHBgjqxvL9rqejhX2FvMfRDMutDy5IA7tZCvfQsXT39tWzI6xHaxW48gliYJnD
         ZHvx2n774GJXC4L51RWkUx25Y678c9VhaJo446oxlmt5lhhxaYU0j2KCKFj/2vKqoQGK
         isEu9uqif9wGeVpjAVlSRwSB+BnoINEzu1j66i9QOC5Q4eQ0ujvcsLywIbtphg543XWb
         PjdlQbYov2awGGDcyzhBIK5wW5Ap1QVPAWYsf7TMY/OWcevM8DXrhmfDZE0N9rF34X3e
         A/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683848; x=1730288648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A1RT2huJ5JZoTziBJ4jD+CCwuEKWgio+GHjHj5uuvtc=;
        b=n6CRxYwjCA7PYuynIJpnFuR5Asbg/mkdEYI+EqENG5GZ0ugLBXO8W6IpE1ku1NOqvd
         gHEwKUrVXDs3AZ1M33toz966OiRuMm4UrYuQjxRt0YMy8B8h2MXwmAQXc8VbyUH3YXrK
         rvcjx/qwzUsInhBaWPvvFRVas1G6pp44Csc/wtWqY68XefLMNtwk8T0W4V1biY22iU7E
         YLXmRUdunEjwyJTCwOJg6aqJfxq1ktrV0y2n9nCyB61Nip+facPIMaGFhiBnAWxifsv/
         Cx+7vrbQZyJBbpC87YXf21WGvt0hkWphjWNlef1XmxSJzr8fXXIcQIlWj57Tx8/O2TVv
         sRaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx+dooQcoc9P8yxjzOulIe2iVoO1GzZdzxHhVs3F2FkX43ELy6q5bF308OcI/LZTbO8TA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUXKmf1ViLkQhOY4D83JZOo1SNugpUp9gHvlZDFLLTts232NQc
	KJYw9GqCsrz8VR/JR2AjUFW4YoyFfDO8zle9aUq0EUQnF8qKrscc/yOLOthhbkI=
X-Google-Smtp-Source: AGHT+IETgBNh0DknbhC9Ao3EX1ccEbaAu/WRXZEm4OtaqSUPGIbyjDwlX/z+4aePDDFewBzHV61pag==
X-Received: by 2002:a05:6512:3b87:b0:539:e873:6e2 with SMTP id 2adb3069b0e04-53b1a31d89dmr1220513e87.8.1729683846016;
        Wed, 23 Oct 2024 04:44:06 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66a6d798sm4478915a12.50.2024.10.23.04.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:44:04 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 9B1C55FC19;
	Wed, 23 Oct 2024 12:34:08 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	devel@lists.libvirt.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Beraldo Leal <bleal@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 17/18] contrib/plugins: remove Makefile for contrib/plugins
Date: Wed, 23 Oct 2024 12:34:05 +0100
Message-Id: <20241023113406.1284676-18-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241023113406.1284676-1-alex.bennee@linaro.org>
References: <20241023113406.1284676-1-alex.bennee@linaro.org>
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


