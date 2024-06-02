Return-Path: <kvm+bounces-18584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 760D48D7555
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 14:26:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E67A281E17
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2024 12:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974E73A29C;
	Sun,  2 Jun 2024 12:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8ZepK7h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E34238394
	for <kvm@vger.kernel.org>; Sun,  2 Jun 2024 12:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717331181; cv=none; b=pVbUZHJSC3fd7SRzisFobUV6K5h30xj4uRZrEhCfkWReIlk0NuF3+TavcKY0aHy418RJBDGsbZE78vQkh+k6rqOz7hUO5D17HGuyAZIag90GsHdxDh0lanmFshiSkstUiReTqI75nRpHssdeBRV10Ua+45vKEjJNZivGv9WcZQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717331181; c=relaxed/simple;
	bh=qURXh813MSuEBp/XtJ53Wo6vpZIosba6kX2yz1Y7SJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncXAb9mpQ6U//uqqNwHhq2sr6yVyQf3L1c5/iifypZD4XIdtTPRI247dcA7LQutyu7GH5xzAwi5tsOQ9m0EfnVE5BBmL+iDakeR0BLO9h8Y1PlugIlXrH7t6NC/4mN6RQjt78390kDMTY3EDXK+ZUfzxqDbpyBAPaofHV5AIxEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b8ZepK7h; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f63642ab8aso16604135ad.3
        for <kvm@vger.kernel.org>; Sun, 02 Jun 2024 05:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717331179; x=1717935979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hiyKAfB2OU/NwrNnJ5dy03JAEMCwXVvnhLc/exyt8Iw=;
        b=b8ZepK7hd6WFwKsq00v6Mufd2Y6o1Vl9oYed8OAwEodh22m8qtf9mhrzbcOldG4hjf
         8uZxiAYR2Lxon08eK8sXz3QdBshirXLvfVBMEAXCnZGJlccs2nXfTr5YrRfOr0qXn1kZ
         Iy34EYkTKfAhQflngLiW1t005JTkXBojulqxGTTHytphBjYNw9vaxwuR7AXO3/P9uhwe
         mBpxq9dh4dWKJWLSBCrk4IJTSZyAey2ddqGcA/1heKYePDI8HAEjHOSZnoQC6nOY0yx8
         +79XQxuOW9MqUxanQUXVJJFF44rYGx08ZGz8XSGSF3kWGPajpvxBwQgPpO8F3IWTYttW
         KMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717331179; x=1717935979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hiyKAfB2OU/NwrNnJ5dy03JAEMCwXVvnhLc/exyt8Iw=;
        b=OeeKDHHR/9BmL1QqrnZiG2tCwyu7fXDuuWTdV0IUV7KxIojTLItunWbIY26P/ELCfA
         yRxF7zAHejEtqtJ58lFZIoIiK2lmG3ZsZod7BQgrJw9/bnCXmjpluMTKCK63KucJGY26
         cEpihy8qafkVNCQOU4Ff5dRXMZutaWda0mPK8/76PFaTPUzsMvwblqbiWxdRBZxDr/o5
         lJF4JEO1iuTAk5IxJ/Gqxq1PZfr87tz6k1EKUZsWo8pldX4zOGQp8vvEs+1KwMEMUG9l
         lWYpGyV/950B+HnMo9C1Fj2gIxVTU6Y2HbSVmydcXjll3yHszBXO3t2bU7AFw4CcSups
         JlGA==
X-Forwarded-Encrypted: i=1; AJvYcCXE7mYFIsjQ/WFxdnZEJQ6chTaJOYSscOt2ifTnKAfEu/gq3Sjlv/GG/bZ5KZfmytQQsggp5eFI0AETjF6pkQPZk2St
X-Gm-Message-State: AOJu0YxEMHv8JosnY2/5yNQEE+HuZ/rYJU++rjKmCMKzNEa82wcBMXjq
	cCCwwTh5Pqi99tQyyz1kCfBYVCIQMYZR6+4uocLk6n8kfHMN3cpZ
X-Google-Smtp-Source: AGHT+IF1f6TILcJ1kTQ+3f6Mh/mgA9FBUgr8fy3ZI3PhzPZjFejlVpYAXsMzKAEl2nJgnwTnRo4S2w==
X-Received: by 2002:a17:903:11c5:b0:1f2:f090:b2c1 with SMTP id d9443c01a7336-1f636ff5266mr66782755ad.14.1717331179218;
        Sun, 02 Jun 2024 05:26:19 -0700 (PDT)
Received: from wheely.local0.net (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6703f7673sm7834145ad.210.2024.06.02.05.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 05:26:18 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 3/4] build: Make build output pretty
Date: Sun,  2 Jun 2024 22:25:57 +1000
Message-ID: <20240602122559.118345-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240602122559.118345-1-npiggin@gmail.com>
References: <20240602122559.118345-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unless make V=1 is specified, silence make recipe echoing and print
an abbreviated line for major build steps.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 Makefile                | 14 ++++++++++++++
 arm/Makefile.common     |  7 +++++++
 powerpc/Makefile.common | 11 +++++++----
 riscv/Makefile          |  5 +++++
 s390x/Makefile          | 18 +++++++++++++++++-
 scripts/mkstandalone.sh |  2 +-
 x86/Makefile.common     |  5 +++++
 7 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 5b7998b79..cbb2fdbf1 100644
--- a/Makefile
+++ b/Makefile
@@ -9,6 +9,11 @@ include config.mak
 # Set search path for all sources
 VPATH = $(SRCDIR)
 
+V=0
+ifeq ($V, 0)
+.SILENT:
+endif
+
 libdirs-get = $(shell [ -d "lib/$(1)" ] && echo "lib/$(1) lib/$(1)/asm")
 ARCH_LIBDIRS := $(call libdirs-get,$(ARCH_LIBDIR)) $(call libdirs-get,$(TEST_DIR))
 OBJDIRS := $(ARCH_LIBDIRS)
@@ -95,11 +100,13 @@ autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
 LDFLAGS += -nostdlib $(no_pie) -z noexecstack
 
 $(libcflat): $(cflatobjs)
+	@echo " [AR]      $@"
 	$(AR) rcs $@ $^
 
 include $(LIBFDT_srcdir)/Makefile.libfdt
 $(LIBFDT_archive): CFLAGS += -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -Wno-sign-compare
 $(LIBFDT_archive): $(addprefix $(LIBFDT_objdir)/,$(LIBFDT_OBJS))
+	@echo " [AR]      $@"
 	$(AR) rcs $@ $^
 
 libfdt_clean: VECHO = echo " "
@@ -112,7 +119,12 @@ libfdt_clean: SHAREDLIB_EXT = so
 directories:
 	@mkdir -p $(OBJDIRS)
 
+%.o: %.c
+	@echo " [CC]      $@"
+	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
 %.o: %.S
+	@echo " [AS]      $@"
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
 -include */.*.d */*/.*.d
@@ -123,6 +135,7 @@ standalone: all
 	@scripts/mkstandalone.sh
 
 install: standalone
+	@echo " [INSTALL] tests -> $(DESTDIR)"
 	mkdir -p $(DESTDIR)
 	install tests/* $(DESTDIR)
 
@@ -136,6 +149,7 @@ distclean: clean
 
 cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/asm-generic
 cscope:
+	@echo " [CSCOPE]"
 	$(RM) ./cscope.*
 	find -L $(cscope_dirs) -maxdepth 1 \
 		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
diff --git a/arm/Makefile.common b/arm/Makefile.common
index f828dbe01..9d6b31239 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -73,15 +73,18 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
 
 ifeq ($(CONFIG_EFI),y)
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
+	@echo " [CC]      $@"
 	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(@:.aux.o=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
 
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
 %.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o) %.aux.o
+	@echo " [LD]      $@"
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
 
 %.efi: %.so
+	@echo " [OBJCOPY] $@"
 	$(call arch_elf_check, $^)
 	$(OBJCOPY) --only-keep-debug $^ $@.debug
 	$(OBJCOPY) --strip-debug $^
@@ -93,22 +96,26 @@ ifeq ($(CONFIG_EFI),y)
 		-O binary $^ $@
 else
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
+	@echo " [CC]      $@"
 	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(@:.aux.o=.flat)\" -DAUXFLAGS=$(AUXFLAGS)
 
 %.elf: LDFLAGS += $(arch_LDFLAGS)
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o) %.aux.o
+	@echo " [LD]      $@"
 	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/arm/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
 
 %.flat: %.elf
+	@echo " [OBJCOPY] $@"
 	$(call arch_elf_check, $^)
 	$(OBJCOPY) -O binary $^ $@
 	@chmod a-x $@
 endif
 
 $(libeabi): $(eabiobjs)
+	@echo " [AR]      $@"
 	$(AR) rcs $@ $^
 
 arm_clean: asm_offsets_clean
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 68165fc25..b0af9fc00 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -51,31 +51,34 @@ cflatobjs += lib/powerpc/smp.o
 OBJDIRS += lib/powerpc
 
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
+	@echo " [LD]      $@"
 	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=\"$(@:.aux.o=.elf)\"
 
 FLATLIBS = $(libcflat) $(LIBFDT_archive)
 %.elf: CFLAGS += $(arch_CFLAGS)
 %.elf: LDFLAGS += $(arch_LDFLAGS) -pie -n
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/powerpc/flat.lds $(cstart.o) $(reloc.o) %.aux.o
+	@echo " [LD]      $@"
 	$(LD) $(LDFLAGS) -o $@ \
 		-T $(SRCDIR)/powerpc/flat.lds --build-id=none \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
-	@echo -n Checking $@ for unsupported reloc types...
 	@if $(OBJDUMP) -R $@ | grep R_ | grep -v R_PPC64_RELATIVE; then	\
+		@echo "Unsupported reloc types in $@"			\
 		false;							\
-	else								\
-		echo " looks good.";					\
 	fi
 
 $(TEST_DIR)/boot_rom.bin: $(TEST_DIR)/boot_rom.elf
-	dd if=/dev/zero of=$@ bs=256 count=1
+	@echo " [DD]      $@"
+	dd if=/dev/zero of=$@ bs=256 count=1 status=none
+	@echo " [OBJCOPY] $@"
 	$(OBJCOPY) -O binary $^ $@.tmp
 	cat $@.tmp >> $@
 	$(RM) $@.tmp
 
 $(TEST_DIR)/boot_rom.elf: CFLAGS = -mbig-endian
 $(TEST_DIR)/boot_rom.elf: $(TEST_DIR)/boot_rom.o
+	@echo " [LD]      $@"
 	$(LD) -EB -nostdlib -Ttext=0x100 --entry=start --build-id=none -o $@ $<
 	@chmod a-x $@
 
diff --git a/riscv/Makefile b/riscv/Makefile
index 919a3ebb5..ca33d4960 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -82,6 +82,7 @@ asm-offsets = lib/riscv/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
+	@echo " [CC]      $@"
 	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(notdir $(@:.aux.o=.$(exe)))\" -DAUXFLAGS=$(AUXFLAGS)
 
@@ -96,10 +97,12 @@ cflatobjs += lib/efi.o
 
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
 %.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o
+	@echo " [LD]      $@"
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
 
 %.efi: %.so
+	@echo " [OBJCOPY] $@"
 	$(call arch_elf_check, $^)
 	$(OBJCOPY) --only-keep-debug $^ $@.debug
 	$(OBJCOPY) --strip-debug $^
@@ -112,11 +115,13 @@ cflatobjs += lib/efi.o
 else
 %.elf: LDFLAGS += -pie -n -z notext
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o
+	@echo " [LD]      $@"
 	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/riscv/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
 
 %.flat: %.elf
+	@echo " [OBJCOPY] $@"
 	$(call arch_elf_check, $^)
 	$(OBJCOPY) -O binary $^ $@
 	@chmod a-x $@
diff --git a/s390x/Makefile b/s390x/Makefile
index 8603a523c..19c41a2ec 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -148,42 +148,54 @@ endif
 
 # the asm/c snippets %.o have additional generated files as dependencies
 $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
+	@echo " [CC]      $@"
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
 $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
+	@echo " [CC]      $@"
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
 $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
+	@echo " [LD]      $@"
 	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
+	@echo " [OBJCOPY] $@"
 	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
 	truncate -s '%4096' $@
 
 $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
+	@echo " [LD]      $@"
 	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
+	@echo " [OBJCOPY] $@"
 	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
 	truncate -s '%4096' $@
 
 %.hdr: %.gbin $(HOST_KEY_DOCUMENT)
+	@echo " [SEHDR  ] $@"
 	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
 
 .SECONDARY:
 %.gobj: %.gbin
+	@echo " [OBJCOPY] $@"
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
 
 .SECONDARY:
 %.hdr.obj: %.hdr
+	@echo " [OBJCOPY] $@"
 	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
 
 lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 %.lds: %.lds.S $(asm-offsets)
+	@echo " [CPP]     $@"
 	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
+	@echo " [CC]      $@"
 	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=\"$(@:.aux.o=.elf)\"
 
 .SECONDEXPANSION:
 %.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o %.aux.o
-	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
+	@echo " [CC]      $@"
+	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) || \
 		{ echo "Failure probably caused by missing definition of gen-se-header executable"; exit 1; }
 	@chmod a-x $@
@@ -192,9 +204,11 @@ lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 # 32 bytes of key material, uses existing one if available
 comm-key = $(TEST_DIR)/comm.key
 $(comm-key):
+	@echo " [DD]      $@"
 	dd if=/dev/urandom of=$@ bs=32 count=1 status=none
 
 %.bin: %.elf
+	@echo " [OBJCOPY] $@"
 	$(OBJCOPY) -O binary  $< $@
 
 # The genprotimg arguments for the cck changed over time so we need to
@@ -216,10 +230,12 @@ endif
 
 $(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: %.parmfile
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
+	@echo " [GENPROT] $@"
 	$(eval parmfile_args = $(if $(filter %.parmfile,$^),--parmfile $(filter %.parmfile,$^),))
 	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) --image $(filter %.bin,$^) -o $@
 
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
+	@echo " [CC]      $@"
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
 
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 2318a85f0..3307c25b1 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -94,7 +94,7 @@ function mkstandalone()
 	generate_test "$@" > $standalone
 
 	chmod +x $standalone
-	echo Written $standalone.
+	echo " [WRITE]   $standalone"
 }
 
 if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 4ae9a5579..96fb0660c 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -49,11 +49,13 @@ ifeq ($(CONFIG_EFI),y)
 .PRECIOUS: %.efi %.so
 
 %.so: %.o $(FLATLIBS) $(SRCDIR)/x86/efi/elf_x86_64_efi.lds $(cstart.o)
+	@echo " [LD]      $@"
 	$(LD) -T $(SRCDIR)/x86/efi/elf_x86_64_efi.lds $(EFI_LDFLAGS) -o $@ \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
 
 %.efi: %.so
+	@echo " [OBJCOPY] $@"
 	$(OBJCOPY) --only-keep-debug $^ $@.debug
 	$(OBJCOPY) --strip-debug $^
 	$(OBJCOPY) --add-gnu-debuglink=$@.debug $^
@@ -67,11 +69,13 @@ else
 
 %.elf: LDFLAGS += $(arch_LDFLAGS)
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
+	@echo " [LD]      $@"
 	$(LD) $(LDFLAGS) -T $(SRCDIR)/x86/flat.lds -o $@ \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
 
 %.flat: %.elf
+	@echo " [OBJCOPY] $@"
 	$(OBJCOPY) -O elf32-i386 $^ $@
 	@chmod a-x $@
 endif
@@ -104,6 +108,7 @@ test_cases: $(tests-common) $(tests)
 $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
 
 $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
+	@echo " [LD]      $@"
 	$(LD) -m elf_i386 -nostdlib -o $@ \
 	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
-- 
2.43.0


