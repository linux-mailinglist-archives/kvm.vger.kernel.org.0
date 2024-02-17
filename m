Return-Path: <kvm+bounces-8952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B7A8858D67
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 06:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFCA31C21163
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 05:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71FC1CAA5;
	Sat, 17 Feb 2024 05:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQ1ZkXyf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82D61CD03;
	Sat, 17 Feb 2024 05:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708149312; cv=none; b=PjnZaCIMakIAmRIML+qQTyfz/eKscBoF4z+sq3TKqiZ7RDGjYRSP9hBY6G2KS/X5F/SIa4so3YixHrUEzUdjWtfkTv3x0bO7M2u1UZ5tzG6kCVB4rEoXQDuVGxf7X2ii/YQ+lSBfFDIvBMEd4RGcw8QfYf5vZvvSIMVXE+QgGVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708149312; c=relaxed/simple;
	bh=zRUd7yREBkG9fojxxpCwFR+ZH4UPtylxuQpNSInrd68=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HNa4zHUtq7dmRe/2OikHNdlzktRz1XnMPd2pdMJdhG1FO2+EUz4PLhD0nbNABOopGh/acX82VVu6H4XhiQ/T893EokADftqk7smeUngD+s809xA02qAN+npncmULMXBf8qXUz/2bT5AcXgsX7IYN4mKhFuDbCQ61HT8qWbiC8ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQ1ZkXyf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D62C433F1;
	Sat, 17 Feb 2024 05:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708149311;
	bh=zRUd7yREBkG9fojxxpCwFR+ZH4UPtylxuQpNSInrd68=;
	h=From:To:Cc:Subject:Date:From;
	b=uQ1ZkXyfKjkIl/6pdVqjIvudxuvRkWyWIwOXR/WWo0YsF6v6M7SJL+fae1/uDSQvs
	 WZDiQ9uHCPFPVQxZyB7d/x5mwp2AVUDTeGlCP+3h6eSe1Y0LucWaoQU8sxuAx+OGm/
	 RqFMmNTyWTq4odftpgr/xigJNpCUYM7A9KU2q7l4BmKEL3xO1uJjUfpjS21xkFctgf
	 PeUSlVnTzhYcLwV6hRQGwUYL3lXbFbnf7Jis5Ppuae7pYtZKz5cGsM1s/QmfG1S0OJ
	 oR2C/CTzB9yTT2Dv4aj/4rX/pv6zkS47Rjo9K4iVtavrKTpLv55g4o2VaRBg+VXXXX
	 Bcrq0zmq1DyPw==
From: Masahiro Yamada <masahiroy@kernel.org>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 1/2] kbuild: change tool coverage variables to take the path relative to $(obj)
Date: Sat, 17 Feb 2024 14:55:03 +0900
Message-Id: <20240217055504.2059803-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 54b8ae66ae1a ("kbuild: change *FLAGS_<basetarget>.o to take the
path relative to $(obj)") changed the syntax of per-file compiler flags.

The situation is the same for the following variables:

  OBJECT_FILES_NON_STANDARD_<basetarget>.o
  GCOV_PROFILE_<basetarget>.o
  KASAN_SANITIZE_<basetarget>.o
  KMSAN_SANITIZE_<basetarget>.o
  KMSAN_ENABLE_CHECKS_<basetarget>.o
  UBSAN_SANITIZE_<basetarget>.o
  KCOV_INSTRUMENT_<basetarget>.o
  KCSAN_SANITIZE_<basetarget>.o
  KCSAN_INSTRUMENT_BARRIERS_<basetarget>.o

The <basetarget> is the filename of the target with its directory and
suffix stripped.

This syntax comes into a trouble when two files with the same basename
appear in one Makefile, for example:

  obj-y += dir1/foo.o
  obj-y += dir2/foo.o
  OBJECT_FILES_NON_STANDARD_foo.o := y

OBJECT_FILES_NON_STANDARD_foo.o is applied to both dir1/foo.o and
dir2/foo.o. This syntax is not flexbile enough to handle cases where
one of them is a standard object, but the other is not.

It is more sensible to use the relative path to the Makefile, like this:

  obj-y += dir1/foo.o
  OBJECT_FILES_NON_STANDARD_dir1/foo.o := y
  obj-y += dir2/foo.o
  OBJECT_FILES_NON_STANDARD_dir2/foo.o := y

To maintain the current behavior, I made adjustments to two Makefiles:

 - arch/x86/entry/vdso/Makefile, which compiles vclock_gettime.o and
   vdso32/vclock_gettime.o

 - arch/x86/kvm/Makefile, which compiles vmx/vmenter.o and svm/vmenter.o

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 arch/x86/entry/vdso/Makefile |  2 ++
 arch/x86/kvm/Makefile        |  3 ++-
 scripts/Makefile.build       |  2 +-
 scripts/Makefile.lib         | 16 ++++++++--------
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 7a97b17f28b7..148adfdb2325 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -9,7 +9,9 @@ include $(srctree)/lib/vdso/Makefile
 # Sanitizer runtimes are unavailable and cannot be linked here.
 KASAN_SANITIZE			:= n
 KMSAN_SANITIZE_vclock_gettime.o := n
+KMSAN_SANITIZE_vdso32/vclock_gettime.o	:= n
 KMSAN_SANITIZE_vgetcpu.o	:= n
+KMSAN_SANITIZE_vdso32/vgetcpu.o	:= n
 
 UBSAN_SANITIZE			:= n
 KCSAN_SANITIZE			:= n
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 475b5fa917a6..a88bb14266b6 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -4,7 +4,8 @@ ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
 ifeq ($(CONFIG_FRAME_POINTER),y)
-OBJECT_FILES_NON_STANDARD_vmenter.o := y
+OBJECT_FILES_NON_STANDARD_vmx/vmenter.o := y
+OBJECT_FILES_NON_STANDARD_svm/vmenter.o := y
 endif
 
 include $(srctree)/virt/kvm/Makefile.kvm
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 4971f54c855e..256db2a0e984 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -214,7 +214,7 @@ endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
 # 'OBJECT_FILES_NON_STANDARD_foo.o := 'y': skip objtool checking for a file
 # 'OBJECT_FILES_NON_STANDARD_foo.o := 'n': override directory skip for a file
 
-is-standard-object = $(if $(filter-out y%, $(OBJECT_FILES_NON_STANDARD_$(basetarget).o)$(OBJECT_FILES_NON_STANDARD)n),y)
+is-standard-object = $(if $(filter-out y%, $(OBJECT_FILES_NON_STANDARD_$(target-stem).o)$(OBJECT_FILES_NON_STANDARD)n),y)
 
 $(obj)/%.o: objtool-enabled = $(if $(is-standard-object),$(if $(delay-objtool),$(is-single-obj-m),y))
 
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index b35d39022a30..328c0d77ed48 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -154,7 +154,7 @@ _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(target-stem).lds)
 #
 ifeq ($(CONFIG_GCOV_KERNEL),y)
 _c_flags += $(if $(patsubst n%,, \
-		$(GCOV_PROFILE_$(basetarget).o)$(GCOV_PROFILE)$(CONFIG_GCOV_PROFILE_ALL)), \
+		$(GCOV_PROFILE_$(target-stem).o)$(GCOV_PROFILE)$(CONFIG_GCOV_PROFILE_ALL)), \
 		$(CFLAGS_GCOV))
 endif
 
@@ -165,29 +165,29 @@ endif
 ifeq ($(CONFIG_KASAN),y)
 ifneq ($(CONFIG_KASAN_HW_TAGS),y)
 _c_flags += $(if $(patsubst n%,, \
-		$(KASAN_SANITIZE_$(basetarget).o)$(KASAN_SANITIZE)y), \
+		$(KASAN_SANITIZE_$(target-stem).o)$(KASAN_SANITIZE)y), \
 		$(CFLAGS_KASAN), $(CFLAGS_KASAN_NOSANITIZE))
 endif
 endif
 
 ifeq ($(CONFIG_KMSAN),y)
 _c_flags += $(if $(patsubst n%,, \
-		$(KMSAN_SANITIZE_$(basetarget).o)$(KMSAN_SANITIZE)y), \
+		$(KMSAN_SANITIZE_$(target-stem).o)$(KMSAN_SANITIZE)y), \
 		$(CFLAGS_KMSAN))
 _c_flags += $(if $(patsubst n%,, \
-		$(KMSAN_ENABLE_CHECKS_$(basetarget).o)$(KMSAN_ENABLE_CHECKS)y), \
+		$(KMSAN_ENABLE_CHECKS_$(target-stem).o)$(KMSAN_ENABLE_CHECKS)y), \
 		, -mllvm -msan-disable-checks=1)
 endif
 
 ifeq ($(CONFIG_UBSAN),y)
 _c_flags += $(if $(patsubst n%,, \
-		$(UBSAN_SANITIZE_$(basetarget).o)$(UBSAN_SANITIZE)$(CONFIG_UBSAN_SANITIZE_ALL)), \
+		$(UBSAN_SANITIZE_$(target-stem).o)$(UBSAN_SANITIZE)$(CONFIG_UBSAN_SANITIZE_ALL)), \
 		$(CFLAGS_UBSAN))
 endif
 
 ifeq ($(CONFIG_KCOV),y)
 _c_flags += $(if $(patsubst n%,, \
-	$(KCOV_INSTRUMENT_$(basetarget).o)$(KCOV_INSTRUMENT)$(CONFIG_KCOV_INSTRUMENT_ALL)), \
+	$(KCOV_INSTRUMENT_$(target-stem).o)$(KCOV_INSTRUMENT)$(CONFIG_KCOV_INSTRUMENT_ALL)), \
 	$(CFLAGS_KCOV))
 endif
 
@@ -197,12 +197,12 @@ endif
 #
 ifeq ($(CONFIG_KCSAN),y)
 _c_flags += $(if $(patsubst n%,, \
-	$(KCSAN_SANITIZE_$(basetarget).o)$(KCSAN_SANITIZE)y), \
+	$(KCSAN_SANITIZE_$(target-stem).o)$(KCSAN_SANITIZE)y), \
 	$(CFLAGS_KCSAN))
 # Some uninstrumented files provide implied barriers required to avoid false
 # positives: set KCSAN_INSTRUMENT_BARRIERS for barrier instrumentation only.
 _c_flags += $(if $(patsubst n%,, \
-	$(KCSAN_INSTRUMENT_BARRIERS_$(basetarget).o)$(KCSAN_INSTRUMENT_BARRIERS)n), \
+	$(KCSAN_INSTRUMENT_BARRIERS_$(target-stem).o)$(KCSAN_INSTRUMENT_BARRIERS)n), \
 	-D__KCSAN_INSTRUMENT_BARRIERS__)
 endif
 
-- 
2.40.1


