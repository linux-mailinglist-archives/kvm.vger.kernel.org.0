Return-Path: <kvm+bounces-18834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAB28FC0DF
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 02:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93EA91C21093
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 00:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDAC257B;
	Wed,  5 Jun 2024 00:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LtzKqItQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5306E184E
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 00:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717547918; cv=none; b=uth8kcw6XZGxBL3XvHXVQXN7wMuNpLfpI0fhPvZK01y8OQRpKg5pGGaWem5p4Cpqfm4FKBNpoH2XwzaxRF2A1vv6CcapiSTEbOpFx/ZpLAASprz9dyekOBdyAtVsQO5KO5FTg9JaoYdNS+t8OUlNdfmBJ/9NbgmRXh68l1ckTSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717547918; c=relaxed/simple;
	bh=vWzCQnOshQOQ1TjojndRNQASMjH9CSgFqec7WiLUBos=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=RVlcyTOL1JaJ75ep3IXUT4R2lq9To6hHYqUFSENtR0+grBXf/OVv2e1UlgzZrstLcnTR+/JpgzxKD9L4Jo+BttpJWNk5FhxwrQalR3VKetiq5ONr10YEkKag+/f2VjYT/EwqbQ3OHzlFGiN6j2wMBYmt69YeWdLU60ozR3hjL8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LtzKqItQ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6f8ec7e054dso4313569b3a.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 17:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717547915; x=1718152715; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OeDY5Cif12f+vyu0PiWYIm2AeAW01GI9U1hwHKDI8vo=;
        b=LtzKqItQph6ub0/NMrToBDBUndH1C74eOuSWtBAK+YatfyP41QHKYhEgRApIXCiKl7
         ufF4IUUs8hZeA9OQDO+/IOFbblQN5bxqqBF2LH3VXpH1uwsGQU6qjNA4138dGl4t5sAW
         WEDMARilq7mb9Oibm/6r3lmPSmXeAgtk1Xqs+gMWTdO+Ygrat8ONztfbedo2FyChJd7U
         gSOyLYS9wLAO/Rt2EeibqUyzU15K7IKso93pP2SWsJ1gSsC4H3k7li3hR0jPzOSh/ysg
         +vwgX7Mzr6JsluLuQRC2HuRLrNa8S8CPObd0IUPmZ3mKHtvBQ69Shv/M1SPKudOoCUiv
         MAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717547915; x=1718152715;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OeDY5Cif12f+vyu0PiWYIm2AeAW01GI9U1hwHKDI8vo=;
        b=U7vjV41OIsqjczenmi6pDgP/1v9b7gb6k+eUprtvjULiPIIadGCvXWtPHsDXytIRsl
         T37Exh82ogFltRODN2x6yCmonwSELwkSpa/g9PFau16+jLNoWgPamkgbfcgqNaNf7rPJ
         D553BR7TBgFpLbCSFEniIUkWgQwlaad4hKY5eNF+09BYXkNud5YKkgxfBTrc1uBRsM7S
         IWlAUKB5ZhE1IGl/NGZs/ACwZB+4qXHGjUTQVcFYCYJoZgy7WD/tnyK3XS3DEKiiPayl
         v2pKg+FXt2Nn3Fnd0a4G6Y9bJL/WSKBSx8EcGiX6ITV/6VWMBVw6POFxQbKh4e59V00r
         iZcQ==
X-Gm-Message-State: AOJu0YwxXrz+oQ6VPydp9rUzZMI+6WVWdHHbIGSTFbMp6cPlWRDTCbsK
	opw7GK5qOu0NjuqnAKGAt8i+bqUx2QTMA2L/hsj0OuSHlfb5+Uw7HzWoTQ==
X-Google-Smtp-Source: AGHT+IEQk+TguzTYrcCzlkR/j3uVvPt+6j037RxosgwkeHCbg05GXo97JgZKIjrRfH84Gflg1avDdw==
X-Received: by 2002:a05:6a20:551a:b0:1b1:f3d6:18c0 with SMTP id adf61e73a8af0-1b2b6ed7fe1mr1283810637.19.1717547915349;
        Tue, 04 Jun 2024 17:38:35 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242ae96c5sm7818771b3a.97.2024.06.04.17.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 17:38:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 10:38:29 +1000
Message-Id: <D1RNX51NOJV5.31CE9AGI74SKP@gmail.com>
Cc: <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 3/4] build: Make build output pretty
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, "Thomas Huth"
 <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-4-npiggin@gmail.com>
 <448757a4-46c8-4761-bc51-32ee39f39b97@redhat.com>
 <20240603-20454ab2bca28b2a4b119db6@orel>
In-Reply-To: <20240603-20454ab2bca28b2a4b119db6@orel>

On Mon Jun 3, 2024 at 6:56 PM AEST, Andrew Jones wrote:
> On Mon, Jun 03, 2024 at 10:26:50AM GMT, Thomas Huth wrote:
> > On 02/06/2024 14.25, Nicholas Piggin wrote:
> > > Unless make V=3D1 is specified, silence make recipe echoing and print
> > > an abbreviated line for major build steps.
> > >=20
> > > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > > ---
> > >   Makefile                | 14 ++++++++++++++
> > >   arm/Makefile.common     |  7 +++++++
> > >   powerpc/Makefile.common | 11 +++++++----
> > >   riscv/Makefile          |  5 +++++
> > >   s390x/Makefile          | 18 +++++++++++++++++-
> > >   scripts/mkstandalone.sh |  2 +-
> > >   x86/Makefile.common     |  5 +++++
> > >   7 files changed, 56 insertions(+), 6 deletions(-)
> >=20
> > The short lines look superfluous in verbose mode, e.g.:
> >=20
> >  [OBJCOPY] s390x/memory-verify.bin
> > objcopy -O binary  s390x/memory-verify.elf s390x/memory-verify.bin
> >=20
> > Could we somehow suppress the echo lines in verbose mode, please?
> >=20
> > For example in the SLOF project, it's done like this:
> >=20
> > https://gitlab.com/slof/slof/-/blob/master/make.rules?ref_type=3Dheads#=
L48
> >=20
> > By putting the logic into $CC and friends, you also don't have to add
> > "@echo" statements all over the place.
>
> And I presume make will treat the printing and compiling as one unit, so
> parallel builds still get the summary above the error messages when
> compilation fails. The way this patch is now a parallel build may show
> the summary for the last successful build and then error messages for
> a build that hasn't output its summary yet, which can be confusing.
>
> So I agree that something more like SLOF's approach would be better.

Hmm... kbuild type commands is a pretty big patch. I like it though.
Thoughts?

Thanks,
Nick

---

diff --git a/Makefile b/Makefile
index 5b7998b79..56052107f 100644
--- a/Makefile
+++ b/Makefile
@@ -53,6 +53,34 @@ EFI_CFLAGS +=3D -fPIC
 EFI_LDFLAGS :=3D -Bsymbolic -shared -nostdlib
 endif
=20
+quiet =3D quiet_
+quiet_echo =3D @echo $1
+Q =3D @
+ifeq ($V, 1)
+	quiet =3D
+	quiet_echo =3D
+	Q =3D
+endif
+
+cmd =3D @$(echo-cmd) $(cmd_$(1))
+echo-cmd =3D $(if $($(quiet)cmd_$(1)), echo ' $($(quiet)cmd_$(1))';)
+
+quiet_cmd_cc =3D [CC]      $@
+      cmd_cc =3D $(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+quiet_cmd_cpp =3D [CPP]     $@
+      cmd_cpp =3D $(CPP) $(CPPFLAGS) -P -C -o $@ $<
+
+quiet_cmd_as =3D [AS]      $@
+      cmd_as =3D $(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+
+# Link libs last
+quiet_cmd_ld =3D [LD]      $@
+      cmd_ld =3D $(LD) $(LDFLAGS) -o $@ $(filter %.o %.gobj, $^) $(filter =
%.a, $^)
+
+quiet_cmd_ar =3D [AR]      $@
+      cmd_ar =3D $(AR) rcs $@ $^
+
 #include architecture specific make rules
 include $(SRCDIR)/$(TEST_DIR)/Makefile
=20
@@ -95,14 +123,13 @@ autodepend-flags =3D -MMD -MP -MF $(dir $*).$(notdir $=
*).d
 LDFLAGS +=3D -nostdlib $(no_pie) -z noexecstack
=20
 $(libcflat): $(cflatobjs)
-	$(AR) rcs $@ $^
+	$(call cmd,ar)
=20
 include $(LIBFDT_srcdir)/Makefile.libfdt
 $(LIBFDT_archive): CFLAGS +=3D -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR=
)/lib/libfdt -Wno-sign-compare
 $(LIBFDT_archive): $(addprefix $(LIBFDT_objdir)/,$(LIBFDT_OBJS))
-	$(AR) rcs $@ $^
+	$(call cmd,ar)
=20
-libfdt_clean: VECHO =3D echo " "
 libfdt_clean: STD_CLEANFILES =3D *.o .*.d
 libfdt_clean: LIBFDT_dir =3D $(LIBFDT_objdir)
 libfdt_clean: SHAREDLIB_EXT =3D so
@@ -112,8 +139,11 @@ libfdt_clean: SHAREDLIB_EXT =3D so
 directories:
 	@mkdir -p $(OBJDIRS)
=20
+%.o: %.c
+	$(call cmd,cc)
+
 %.o: %.S
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+	$(call cmd,as)
=20
 -include */.*.d */*/.*.d
=20
@@ -123,23 +153,29 @@ standalone: all
 	@scripts/mkstandalone.sh
=20
 install: standalone
-	mkdir -p $(DESTDIR)
-	install tests/* $(DESTDIR)
+	$(call quiet_echo, " [INSTALL] tests -> $(DESTDIR)")
+	$(Q)mkdir -p $(DESTDIR)
+	$(Q)install tests/* $(DESTDIR)
=20
-clean: arch_clean libfdt_clean
-	$(RM) $(LIBFDT_archive)
-	$(RM) lib/.*.d $(libcflat) $(cflatobjs)
+#clean: arch_clean libfdt_clean
+clean:
+	$(call quiet_echo, " [CLEAN]")
+	$(Q)$(MAKE) --no-print-directory arch_clean libfdt_clean
+	$(Q)$(RM) $(LIBFDT_archive)
+	$(Q)$(RM) lib/.*.d $(libcflat) $(cflatobjs)
=20
 distclean: clean
-	$(RM) lib/asm lib/config.h config.mak $(TEST_DIR)-run msr.out cscope.* bu=
ild-head
-	$(RM) -r tests logs logs.old efi-tests
+	$(call quiet_echo, " [DISTCLEAN]")
+	$(Q)$(RM) lib/asm lib/config.h config.mak $(TEST_DIR)-run msr.out cscope.=
* build-head
+	$(Q)$(RM) -r tests logs logs.old efi-tests
=20
 cscope: cscope_dirs =3D lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIR=
S) lib/asm-generic
 cscope:
-	$(RM) ./cscope.*
-	find -L $(cscope_dirs) -maxdepth 1 \
+	$(Q)$(RM) ./cscope.*
+	$(Q)find -L $(cscope_dirs) -maxdepth 1 \
 		-name '*.[chsS]' -exec realpath --relative-base=3D$(CURDIR) {} \; | sort=
 -u > ./cscope.files
-	cscope -bk
+	$(call quiet_echo, " [CSCOPE]")
+	$(Q)cscope -bk
=20
 .PHONY: shellcheck
 shellcheck:
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 960880f1c..06e856ba1 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -52,4 +52,4 @@ tests +=3D $(TEST_DIR)/debug.$(exe)
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
=20
 arch_clean: arm_clean
-	$(RM) lib/arm64/.*.d
+	$(Q)$(RM) lib/arm64/.*.d
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 5f22c9b08..0def9a327 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -72,48 +72,47 @@ eabiobjs =3D lib/arm/eabi_compat.o
 FLATLIBS =3D $(libcflat) $(LIBFDT_archive) $(libeabi)
=20
 ifeq ($(CONFIG_EFI),y)
+%.aux.o: CFLAGS +=3D -DPROGNAME=3D\"$(@:.aux.o=3D.efi)\" -DAUXFLAGS=3D$(AU=
XFLAGS)
 $(tests-all:.$(exe)=3D.aux.o): $(SRCDIR)/lib/auxinfo.c
-	$(CC) $(CFLAGS) -c -o $@ $< \
-		-DPROGNAME=3D\"$(@:.aux.o=3D.efi)\" -DAUXFLAGS=3D$(AUXFLAGS)
+	$(call cmd,cc)
=20
-%.so: EFI_LDFLAGS +=3D -defsym=3DEFI_SUBSYSTEM=3D0xa --no-undefined
-%.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o) %.=
aux.o
-	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
-		$(filter %.o, $^) $(FLATLIBS)
+%.so: LDFLAGS =3D $(EFI_LDFLAGS) -defsym=3DEFI_SUBSYSTEM=3D0xa --no-undefi=
ned -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds
+%.so: %.o $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o) $(FLATLIBS) $(=
EFI_LIBS) %.aux.o
+	$(call cmd,ld)
=20
 %.efi: %.so
 	$(call arch_elf_check, $^)
-	$(OBJCOPY) --only-keep-debug $^ $@.debug
-	$(OBJCOPY) --strip-debug $^
-	$(OBJCOPY) --add-gnu-debuglink=3D$@.debug $^
-	$(OBJCOPY) \
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) --only-keep-debug $^ $@.debug
+	$(Q)$(OBJCOPY) --strip-debug $^
+	$(Q)$(OBJCOPY) --add-gnu-debuglink=3D$@.debug $^
+	$(Q)$(OBJCOPY) \
 		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
 		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
 		-j .reloc \
 		-O binary $^ $@
 else
+%.aux.o: CFLAGS +=3D -DPROGNAME=3D\"$(@:.aux.o=3D.flat)\" -DAUXFLAGS=3D$(A=
UXFLAGS)
 $(tests-all:.$(exe)=3D.aux.o): $(SRCDIR)/lib/auxinfo.c
-%.aux.o: $(SRCDIR)/lib/auxinfo.c
-	$(CC) $(CFLAGS) -c -o $@ $< \
-		-DPROGNAME=3D\"$(@:.aux.o=3D.flat)\" -DAUXFLAGS=3D$(AUXFLAGS)
+	$(call cmd,cc)
=20
-%.elf: LDFLAGS +=3D $(arch_LDFLAGS)
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o) %.aux.o
-	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/arm/flat.lds \
-		$(filter %.o, $^) $(FLATLIBS)
-	@chmod a-x $@
+%.elf: LDFLAGS +=3D $(arch_LDFLAGS) -T $(SRCDIR)/arm/flat.lds
+%.elf: %.o $(SRCDIR)/arm/flat.lds $(cstart.o) $(FLATLIBS) %.aux.o
+	$(call cmd,ld)
+	$(Q)@chmod a-x $@
=20
 %.flat: %.elf
 	$(call arch_elf_check, $^)
-	$(OBJCOPY) -O binary $^ $@
-	@chmod a-x $@
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) -O binary $^ $@
+	$(Q)chmod a-x $@
 endif
=20
 $(libeabi): $(eabiobjs)
-	$(AR) rcs $@ $^
+	$(call cmd,ar)
=20
 arm_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} $(libeabi) $(eabiobjs) \
+	$(Q)$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} $(libeabi) $(eabiobjs) =
\
 	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/arm/.*.d
=20
 generated-files =3D $(asm-offsets)
diff --git a/lib/libfdt/Makefile.libfdt b/lib/libfdt/Makefile.libfdt
index b6d8fc02d..3a1bc1128 100644
--- a/lib/libfdt/Makefile.libfdt
+++ b/lib/libfdt/Makefile.libfdt
@@ -13,6 +13,5 @@ LIBFDT_OBJS =3D $(LIBFDT_SRCS:%.c=3D%.o)
 LIBFDT_LIB =3D libfdt-$(DTC_VERSION).$(SHAREDLIB_EXT)
=20
 libfdt_clean:
-	@$(VECHO) CLEAN "(libfdt)"
-	rm -f $(STD_CLEANFILES:%=3D$(LIBFDT_dir)/%)
-	rm -f $(LIBFDT_dir)/$(LIBFDT_soname)
+	$(Q)rm -f $(STD_CLEANFILES:%=3D$(LIBFDT_dir)/%)
+	$(Q)rm -f $(LIBFDT_dir)/$(LIBFDT_soname)
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 3b219eee0..2fdf5bdae 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -52,37 +52,37 @@ cflatobjs +=3D lib/powerpc/smp.o
=20
 OBJDIRS +=3D lib/powerpc
=20
+%.aux.o: CFLAGS +=3D -DPROGNAME=3D\"$(@:.aux.o=3D.elf)\"
 $(tests-all:.elf=3D.aux.o): $(SRCDIR)/lib/auxinfo.c
-	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=3D\"$(@:.aux.o=3D.elf)\"
+	$(call cmd,cc)
=20
 FLATLIBS =3D $(libcflat) $(LIBFDT_archive)
 %.elf: CFLAGS +=3D $(arch_CFLAGS)
-%.elf: LDFLAGS +=3D $(arch_LDFLAGS) -pie -n
+%.elf: LDFLAGS +=3D $(arch_LDFLAGS) -pie -n --build-id=3Dnone -T $(SRCDIR)=
/powerpc/flat.lds
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/powerpc/flat.lds $(cstart.o) $(reloc.o) %=
.aux.o
-	$(LD) $(LDFLAGS) -o $@ \
-		-T $(SRCDIR)/powerpc/flat.lds --build-id=3Dnone \
-		$(filter %.o, $^) $(FLATLIBS)
-	@chmod a-x $@
-	@echo -n Checking $@ for unsupported reloc types...
+	$(call cmd,ld)
+	$(Q)chmod a-x $@
 	@if $(OBJDUMP) -R $@ | grep R_ | grep -v R_PPC64_RELATIVE; then	\
+		@echo "Unsupported reloc types in $@"			\
 		false;							\
-	else								\
-		echo " looks good.";					\
 	fi
=20
 $(TEST_DIR)/boot_rom.bin: $(TEST_DIR)/boot_rom.elf
-	dd if=3D/dev/zero of=3D$@ bs=3D256 count=3D1
-	$(OBJCOPY) -O binary $^ $@.tmp
-	cat $@.tmp >> $@
-	$(RM) $@.tmp
+	$(call quiet_echo, " [DD]      $@")
+	$(Q)dd if=3D/dev/zero of=3D$@ bs=3D256 count=3D1 status=3Dnone
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) -O binary $^ $@.tmp
+	$(Q)cat $@.tmp >> $@
+	$(Q)$(RM) $@.tmp
=20
 $(TEST_DIR)/boot_rom.elf: CFLAGS =3D -mbig-endian
+$(TEST_DIR)/boot_rom.elf: LDFLAGS =3D -EB -nostdlib -Ttext=3D0x100 --entry=
=3Dstart --build-id=3Dnone
 $(TEST_DIR)/boot_rom.elf: $(TEST_DIR)/boot_rom.o
-	$(LD) -EB -nostdlib -Ttext=3D0x100 --entry=3Dstart --build-id=3Dnone -o $=
@ $<
-	@chmod a-x $@
+	$(call cmd,ld)
+	$(Q)chmod a-x $@
=20
 powerpc_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf} $(TEST_DIR)/boot_rom.bin \
+	$(Q)$(RM) $(TEST_DIR)/*.{o,elf} $(TEST_DIR)/boot_rom.bin \
 	      $(TEST_DIR)/.*.d lib/powerpc/.*.d
=20
 generated-files =3D $(asm-offsets)
diff --git a/powerpc/Makefile.ppc64 b/powerpc/Makefile.ppc64
index a18a9628f..b10499229 100644
--- a/powerpc/Makefile.ppc64
+++ b/powerpc/Makefile.ppc64
@@ -27,4 +27,4 @@ tests =3D $(TEST_DIR)/spapr_vpa.elf
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
=20
 arch_clean: powerpc_clean
-	$(RM) lib/ppc64/.*.d
+	$(Q)$(RM) lib/ppc64/.*.d
diff --git a/riscv/Makefile b/riscv/Makefile
index eacca7ce1..f6fb9488a 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -81,9 +81,9 @@ CFLAGS +=3D -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt
 asm-offsets =3D lib/riscv/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
=20
+%.aux.o: CFLAGS +=3D -DPROGNAME=3D\"$(notdir $(@:.aux.o=3D.$(exe)))\" -DAU=
XFLAGS=3D$(AUXFLAGS)
 $(tests:.$(exe)=3D.aux.o): $(SRCDIR)/lib/auxinfo.c
-	$(CC) $(CFLAGS) -c -o $@ $< \
-		-DPROGNAME=3D\"$(notdir $(@:.aux.o=3D.$(exe)))\" -DAUXFLAGS=3D$(AUXFLAGS=
)
+	$(call cmd,cc)
=20
 ifeq ($(CONFIG_EFI),y)
 # avoid jump tables before all relocations have been processed
@@ -95,36 +95,37 @@ cflatobjs +=3D lib/efi.o
 .PRECIOUS: %.so
=20
 %.so: EFI_LDFLAGS +=3D -defsym=3DEFI_SUBSYSTEM=3D0xa --no-undefined
-%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) =
%.aux.o
-	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds \
-		$(filter %.o, $^) $(FLATLIBS)
+%.so: LDFLAGS =3D $(EFI_LDFLAGS) -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.ld=
s
+%.so: %.o $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o $(FL=
ATLIBS)
+	$(call cmd,ld)
=20
 %.efi: %.so
 	$(call arch_elf_check, $^)
-	$(OBJCOPY) --only-keep-debug $^ $@.debug
-	$(OBJCOPY) --strip-debug $^
-	$(OBJCOPY) --add-gnu-debuglink=3D$@.debug $^
-	$(OBJCOPY) \
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) --only-keep-debug $^ $@.debug
+	$(Q)$(OBJCOPY) --strip-debug $^
+	$(Q)$(OBJCOPY) --add-gnu-debuglink=3D$@.debug $^
+	$(Q)$(OBJCOPY) \
 		-j .text -j .sdata -j .data -j .rodata -j .dynamic -j .dynsym \
 		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
 		-j .reloc \
 		-O binary $^ $@
 else
-%.elf: LDFLAGS +=3D -pie -n -z notext
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o
-	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/riscv/flat.lds \
-		$(filter %.o, $^) $(FLATLIBS)
-	@chmod a-x $@
+%.elf: LDFLAGS +=3D -pie -n -z notext -T $(SRCDIR)/riscv/flat.lds
+%.elf: %.o $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o $(FLATLIBS)
+	$(call cmd,ld)
+	$(Q)@chmod a-x $@
=20
 %.flat: %.elf
 	$(call arch_elf_check, $^)
+	$(call quiet_echo, " [OBJCOPY] $@")
 	$(OBJCOPY) -O binary $^ $@
-	@chmod a-x $@
+	$(Q)@chmod a-x $@
 endif
=20
 generated-files =3D $(asm-offsets)
 $(tests:.$(exe)=3D.o) $(cstart.o) $(cflatobjs): $(generated-files)
=20
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} \
+	$(Q)$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} \
 	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/riscv/.*.d
diff --git a/s390x/Makefile b/s390x/Makefile
index 4c0c8085c..28d8a5b07 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -82,7 +82,7 @@ CFLAGS +=3D -O2
 CFLAGS +=3D -march=3DzEC12
 CFLAGS +=3D -mbackchain
 CFLAGS +=3D -fno-delete-null-pointer-checks
-LDFLAGS +=3D -Wl,--build-id=3Dnone
+LDFLAGS +=3D --build-id=3Dnone
=20
 # We want to keep intermediate files
 .PRECIOUS: %.o %.lds
@@ -148,54 +148,65 @@ endif
=20
 # the asm/c snippets %.o have additional generated files as dependencies
 $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+	$(call cmd,cc)
=20
 $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
+	$(call cmd,cc)
=20
+$(SNIPPET_DIR)/asm/%.gbin: LDFLAGS +=3D -T $(SNIPPET_DIR)/asm/flat.lds
 $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.=
lds
-	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
-	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j =
".bss" --set-section-flags .bss=3Dalloc,load,contents $@ $@
+	$(call cmd,ld)
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data"=
 -j ".bss" --set-section-flags .bss=3Dalloc,load,contents $@ $@
 	truncate -s '%4096' $@
=20
+$(SNIPPET_DIR)/c/%.gbin: LDFLAGS +=3D -T $(SNIPPET_DIR)/c/flat.lds
 $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $=
(SNIPPET_DIR)/c/flat.lds
-	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(F=
LATLIBS)
-	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j =
".bss" --set-section-flags .bss=3Dalloc,load,contents $@ $@
-	truncate -s '%4096' $@
+	$(call cmd,ld)
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data"=
 -j ".bss" --set-section-flags .bss=3Dalloc,load,contents $@ $@
+	$(Q)truncate -s '%4096' $@
=20
 %.hdr: %.gbin $(HOST_KEY_DOCUMENT)
-	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000=
000000000000 --psw-addr 0x4000 -o $@
+	$(call quiet_echo, " [SEHDR]   $@")
+	$(Q)$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x0000000000000042=
0000000000000000 --psw-addr 0x4000 -o $@
=20
 .SECONDARY:
 %.gobj: %.gbin
-	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
=20
 .SECONDARY:
 %.hdr.obj: %.hdr
-	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
=20
 lds-autodepend-flags =3D -MMD -MF $(dir $*).$(notdir $*).d -MT $@
+%.lds: CPPFLAGS +=3D $(lds-autodepend-flags)
 %.lds: %.lds.S $(asm-offsets)
-	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
+	$(call cmd,cpp)
=20
+%.aux.o: CFLAGS +=3D -DPROGNAME=3D\"$(@:.aux.o=3D.elf)\"
 $(tests:.elf=3D.aux.o): $(SRCDIR)/lib/auxinfo.c
-	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=3D\"$(@:.aux.o=3D.elf)\"
+	$(call cmd,cc)
=20
 .SECONDEXPANSION:
-%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(=
snippet-hdr-obj) %.o %.aux.o
-	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
-		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) || \
-		{ echo "Failure probably caused by missing definition of gen-se-header e=
xecutable"; exit 1; }
-	@chmod a-x $@
+%.elf: LDFLAGS +=3D -T $(SRCDIR)/s390x/flat.lds
+%.elf: $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o %=
.aux.o $(FLATLIBS) $(asmlib)
+	$(call cmd,ld)
+# XXX: some test for gen-se-header executable?
+	$(Q)@chmod a-x $@
=20
 # Secure Execution Customer Communication Key file
 # 32 bytes of key material, uses existing one if available
 comm-key =3D $(TEST_DIR)/comm.key
 $(comm-key):
-	dd if=3D/dev/urandom of=3D$@ bs=3D32 count=3D1 status=3Dnone
+	$(call quiet_echo, " [DD]      $@")
+	$(Q)dd if=3D/dev/urandom of=3D$@ bs=3D32 count=3D1 status=3Dnone
=20
 %.bin: %.elf
-	$(OBJCOPY) -O binary  $< $@
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) -O binary  $< $@
=20
 # The genprotimg arguments for the cck changed over time so we need to
 # figure out which argument to use in order to set the cck
@@ -221,14 +232,14 @@ endif
 $(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin: %.=
parmfile
 %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
 	$(eval parmfile_args =3D $(if $(filter %.parmfile,$^),--parmfile $(filter=
 %.parmfile,$^),))
-	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENP=
ROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_args) =
--image $(filter %.bin,$^) -o $@
+	$(call quiet_echo, " [GENPROT] $@")
+	$(Q)$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(=
GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF) $(parmfile_ar=
gs) --image $(filter %.bin,$^) -o $@
=20
 $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
-	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
-
+	$(call cmd,cc)
=20
 arch_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,h=
dr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
+	$(Q)$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*o=
bj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-=
key)
=20
 generated-files =3D $(asm-offsets)
 $(tests:.elf=3D.o) $(asmlib) $(cflatobjs): $(generated-files)
diff --git a/scripts/asm-offsets.mak b/scripts/asm-offsets.mak
index 7b64162dd..db5f741c8 100644
--- a/scripts/asm-offsets.mak
+++ b/scripts/asm-offsets.mak
@@ -16,7 +16,7 @@ define sed-y
 endef
=20
 define make_asm_offsets
-	(set -e; \
+	$(Q)(set -e; \
 	 echo "#ifndef __ASM_OFFSETS_H__"; \
 	 echo "#define __ASM_OFFSETS_H__"; \
 	 echo "/*"; \
@@ -29,16 +29,17 @@ define make_asm_offsets
 	 echo "#endif" ) > $@
 endef
=20
+$(asm-offsets:.h=3D.s): CFLAGS +=3D -fverbose-asm -S
 $(asm-offsets:.h=3D.s): $(asm-offsets:.h=3D.c)
-	$(CC) $(CFLAGS) -fverbose-asm -S -o $@ $<
+	$(call cmd,cc)
=20
 $(asm-offsets): $(asm-offsets:.h=3D.s)
 	$(call make_asm_offsets)
-	cp -f $(asm-offsets) lib/generated/
+	$(Q)cp -f $(asm-offsets) lib/generated/
=20
 OBJDIRS +=3D lib/generated
=20
 asm_offsets_clean:
-	$(RM) $(asm-offsets) $(asm-offsets:.h=3D.s) \
+	$(Q)$(RM) $(asm-offsets) $(asm-offsets:.h=3D.s) \
 	      $(addprefix lib/generated/,$(notdir $(asm-offsets)))
=20
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 2318a85f0..3307c25b1 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -94,7 +94,7 @@ function mkstandalone()
 	generate_test "$@" > $standalone
=20
 	chmod +x $standalone
-	echo Written $standalone.
+	echo " [WRITE]   $standalone"
 }
=20
 if [ "$ENVIRON_DEFAULT" =3D "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATA=
TXT" ]; then
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 4ae9a5579..7896fb6c9 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -48,32 +48,33 @@ FLATLIBS =3D lib/libcflat.a
 ifeq ($(CONFIG_EFI),y)
 .PRECIOUS: %.efi %.so
=20
-%.so: %.o $(FLATLIBS) $(SRCDIR)/x86/efi/elf_x86_64_efi.lds $(cstart.o)
-	$(LD) -T $(SRCDIR)/x86/efi/elf_x86_64_efi.lds $(EFI_LDFLAGS) -o $@ \
-		$(filter %.o, $^) $(FLATLIBS)
-	@chmod a-x $@
+%.so: LDFLAGS =3D $(EFI_LDFLAGS) -T $(SRCDIR)/x86/efi/elf_x86_64_efi.lds
+%.so: %.o $(SRCDIR)/x86/efi/elf_x86_64_efi.lds $(cstart.o) $(FLATLIBS)
+	$(call cmd,ld)
+	$(Q)@chmod a-x $@
=20
 %.efi: %.so
-	$(OBJCOPY) --only-keep-debug $^ $@.debug
-	$(OBJCOPY) --strip-debug $^
-	$(OBJCOPY) --add-gnu-debuglink=3D$@.debug $^
-	$(OBJCOPY) \
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) --only-keep-debug $^ $@.debug
+	$(Q)$(OBJCOPY) --strip-debug $^
+	$(Q)$(OBJCOPY) --add-gnu-debuglink=3D$@.debug $^
+	$(Q)$(OBJCOPY) \
 		-j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel \
 		-j .rela -j .reloc -S --target=3D$(FORMAT) $< $@
-	@chmod a-x $@
+	$(Q)chmod a-x $@
 else
 # We want to keep intermediate file: %.elf and %.o
 .PRECIOUS: %.elf %.o
=20
-%.elf: LDFLAGS +=3D $(arch_LDFLAGS)
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
-	$(LD) $(LDFLAGS) -T $(SRCDIR)/x86/flat.lds -o $@ \
-		$(filter %.o, $^) $(FLATLIBS)
-	@chmod a-x $@
+%.elf: LDFLAGS +=3D $(arch_LDFLAGS) -T $(SRCDIR)/x86/flat.lds
+%.elf: %.o $(SRCDIR)/x86/flat.lds $(cstart.o) $(FLATLIBS)
+	$(call cmd,ld)
+	$(Q)@chmod a-x $@
=20
 %.flat: %.elf
-	$(OBJCOPY) -O elf32-i386 $^ $@
-	@chmod a-x $@
+	$(call quiet_echo, " [OBJCOPY] $@")
+	$(Q)$(OBJCOPY) -O elf32-i386 $^ $@
+	$(Q)chmod a-x $@
 endif
=20
 tests-common =3D $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
@@ -103,9 +104,9 @@ test_cases: $(tests-common) $(tests)
=20
 $(TEST_DIR)/%.o: CFLAGS +=3D -std=3Dgnu99 -ffreestanding -I $(SRCDIR)/lib =
-I $(SRCDIR)/lib/x86 -I lib
=20
+$(TEST_DIR)/realmode.elf: LDFLAGS =3D -m elf_i386 -nostdlib -T $(SRCDIR)/$=
(TEST_DIR)/realmode.lds
 $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
-	$(LD) -m elf_i386 -nostdlib -o $@ \
-	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
+	$(call cmd,ld)
=20
 $(TEST_DIR)/realmode.o: bits =3D $(if $(call cc-option,-m16,""),16,32)
=20
@@ -124,7 +125,7 @@ $(TEST_DIR)/hyperv_stimer.$(bin): $(TEST_DIR)/hyperv.o
 $(TEST_DIR)/hyperv_connections.$(bin): $(TEST_DIR)/hyperv.o
=20
 arch_clean:
-	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
+	$(Q)$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
 	$(TEST_DIR)/.*.d lib/x86/.*.d \
 	$(TEST_DIR)/efi/*.o $(TEST_DIR)/efi/.*.d \
 	$(TEST_DIR)/*.so $(TEST_DIR)/*.efi $(TEST_DIR)/*.debug

