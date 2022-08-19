Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2E959A4D5
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354800AbiHSRl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 13:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351162AbiHSRlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 13:41:21 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B49112D2B5
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 10:01:06 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3360c0f0583so85746797b3.2
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 10:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=CDNK9YkpNGlxlyBZ2YxDzM8xmW01u0Wu64T9WjuFBTk=;
        b=j0sFKnXi/LPGT4C1SFhRfHMG7/87rqOhRdkSlRxle1mRJChc777XIVB+SD9DCuO+Bu
         QB22VA/rt76EKR/kgMKToMQs1olKW9vnYjdYyvYl8FcrjW7dKkTVdIvY9vtcj/SgCCNr
         UruuAhTr5unOsdyPAmoRS2wtr8dYNRx8eqP4wTi9OIhnboJPhvSa0eiYl2ecKO4dHYTu
         71dh1Da6IfoVaJXPs6VfG7K2dtyrshvujZCqik0TW55vf/OmeQwCqRz8VAsmxU99TOn8
         ueUTGA8O5zBQGJb7yBczz0RDw9Nl20Vuu9wTlwpNKQtzZOIz1EABGpfgiDnhQus1JJ/X
         ZP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=CDNK9YkpNGlxlyBZ2YxDzM8xmW01u0Wu64T9WjuFBTk=;
        b=zEQvxdKDq4u7k1fS94oRbbW6iLN7PIfG+ehwg2TUl0ZlusDEA8ha0SWNjYSBmu0orO
         b6dk2WY4swiaMQwMarNN2DDfBczAH1cZbvtRmpTbXE0mCkiUsU/AtstIc1Wj/dOq1fBo
         iShRb1p2Pq6L0zRLRPnMDR+lZg7SebzXHcocHHZxe3leMUd1KDla3rZiDNDfue2jfHBe
         GkMWm7iDx3gwkd5difAznXrhlwFauskZt11CoYMkcbP4S4DyDipyBZCCEV1RRx3yhtVq
         C/lVtaob8lXnk+2L7bkknqi29JDf/PreUiLFi1xDTn7KqgHb35AAe8nH3YaJEbo1b/Mf
         G73w==
X-Gm-Message-State: ACgBeo1rKeBOHMEvy6zRJrA+FaWtN58Py+33DDVAygHBqF75fmvUbeIc
        2eKZn6V48m+9XzKF7qamqf/kskMThySOu8/OsbQ=
X-Google-Smtp-Source: AA6agR6a9YfEGUF9s8iC8djMUtPeCPODLAgQpl4BhmDBwqGlNp8wFhsfeoqJTrqRLF7U4UKkuzxUvQ3xr+EFtRR5rfY=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:4752:6cab:cd5c:55be])
 (user=ndesaulniers job=sendgmr) by 2002:a81:60a:0:b0:31f:8a7f:9108 with SMTP
 id 10-20020a81060a000000b0031f8a7f9108mr8652842ywg.152.1660928465264; Fri, 19
 Aug 2022 10:01:05 -0700 (PDT)
Date:   Fri, 19 Aug 2022 10:00:53 -0700
Message-Id: <20220819170053.2686006-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Developer-Key: i=ndesaulniers@google.com; a=ed25519; pk=lvO/pmg+aaCb6dPhyGC1GyOCvPueDrrc8Zeso5CaGKE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1660928453; l=9277;
 i=ndesaulniers@google.com; s=20211004; h=from:subject; bh=t44R6sdxLtxBwPVSgPSFzzi2z62lGpooItOuAneZT3I=;
 b=B/oJCH80q6OcVMPTvT+iOH052FcWLYcfLDI5XDzqjpspyoIETOAlMfbWyMq2eqNY1NgV38FZyw4u
 0CBZ7/G4AhW7w8425WmOtV8fsyc1CHCZeC/ka41k/xfevIHFd5wJ
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH] Kconfig: eradicate CC_HAS_ASM_GOTO
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GCC has supported asm goto since 4.5, and Clang has since version 9.0.0.
The minimum supported versions of these tools for the build according to
Documentation/process/changes.rst are 5.1 and 11.0.0 respectively.

Remove the feature detection script, Kconfig option, and clean up some
fallback code that is no longer supported.

The removed script was also testing for a GCC specific bug that was
fixed in the 4.7 release.

The script was also not portable; users of Dash shell reported errors
when it was invoked.

Link: https://lore.kernel.org/lkml/CAK7LNATSr=BXKfkdW8f-H5VT_w=xBpT2ZQcZ7rm6JfkdE+QnmA@mail.gmail.com/
Link: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48637
Reported-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 Documentation/kbuild/kconfig-language.rst |  4 ++--
 arch/Kconfig                              |  3 +--
 arch/um/include/asm/cpufeature.h          |  4 ++--
 arch/x86/Makefile                         |  4 ----
 arch/x86/include/asm/cpufeature.h         |  4 ++--
 arch/x86/include/asm/rmwcc.h              | 19 +------------------
 arch/x86/kvm/emulate.c                    |  2 +-
 init/Kconfig                              |  4 ----
 scripts/gcc-goto.sh                       | 22 ----------------------
 tools/arch/x86/include/asm/rmwcc.h        | 21 ---------------------
 10 files changed, 9 insertions(+), 78 deletions(-)
 delete mode 100755 scripts/gcc-goto.sh

diff --git a/Documentation/kbuild/kconfig-language.rst b/Documentation/kbuild/kconfig-language.rst
index 7fb398649f51..858ed5d80def 100644
--- a/Documentation/kbuild/kconfig-language.rst
+++ b/Documentation/kbuild/kconfig-language.rst
@@ -525,8 +525,8 @@ followed by a test macro::
 If you need to expose a compiler capability to makefiles and/or C source files,
 `CC_HAS_` is the recommended prefix for the config option::
 
-  config CC_HAS_ASM_GOTO
-	def_bool $(success,$(srctree)/scripts/gcc-goto.sh $(CC))
+  config CC_HAS_FOO
+	def_bool $(success,$(srctree)/scripts/cc-check-foo.sh $(CC))
 
 Build as module only
 ~~~~~~~~~~~~~~~~~~~~
diff --git a/arch/Kconfig b/arch/Kconfig
index f330410da63a..5dbf11a5ba4e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -53,7 +53,6 @@ config KPROBES
 config JUMP_LABEL
 	bool "Optimize very unlikely/likely branches"
 	depends on HAVE_ARCH_JUMP_LABEL
-	depends on CC_HAS_ASM_GOTO
 	select OBJTOOL if HAVE_JUMP_LABEL_HACK
 	help
 	 This option enables a transparent branch optimization that
@@ -1361,7 +1360,7 @@ config HAVE_PREEMPT_DYNAMIC_CALL
 
 config HAVE_PREEMPT_DYNAMIC_KEY
 	bool
-	depends on HAVE_ARCH_JUMP_LABEL && CC_HAS_ASM_GOTO
+	depends on HAVE_ARCH_JUMP_LABEL
 	select HAVE_PREEMPT_DYNAMIC
 	help
 	   An architecture should select this if it can handle the preemption
diff --git a/arch/um/include/asm/cpufeature.h b/arch/um/include/asm/cpufeature.h
index 19cd7ed6ec3c..94ff93ce20de 100644
--- a/arch/um/include/asm/cpufeature.h
+++ b/arch/um/include/asm/cpufeature.h
@@ -65,11 +65,11 @@ extern void setup_clear_cpu_cap(unsigned int bit);
 
 #define setup_force_cpu_bug(bit) setup_force_cpu_cap(bit)
 
-#if defined(__clang__) && !defined(CONFIG_CC_HAS_ASM_GOTO)
+#if defined(__clang__) && __clang_major__ < 9
 
 /*
  * Workaround for the sake of BPF compilation which utilizes kernel
- * headers, but clang does not support ASM GOTO and fails the build.
+ * headers, but clang < 9 does not support ASM GOTO and fails the build.
  */
 #ifndef __BPF_TRACING__
 #warning "Compiler lacks ASM_GOTO support. Add -D __BPF_TRACING__ to your compiler arguments"
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 7854685c5f25..bafbd905e6e7 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -286,10 +286,6 @@ vdso_install:
 
 archprepare: checkbin
 checkbin:
-ifndef CONFIG_CC_HAS_ASM_GOTO
-	@echo Compiler lacks asm-goto support.
-	@exit 1
-endif
 ifdef CONFIG_RETPOLINE
 ifeq ($(RETPOLINE_CFLAGS),)
 	@echo "You are building kernel with non-retpoline compiler." >&2
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index ea34cc31b047..29951da819ca 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -155,11 +155,11 @@ extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
 
 #define setup_force_cpu_bug(bit) setup_force_cpu_cap(bit)
 
-#if defined(__clang__) && !defined(CONFIG_CC_HAS_ASM_GOTO)
+#if defined(__clang__) && __clang_major__ < 9
 
 /*
  * Workaround for the sake of BPF compilation which utilizes kernel
- * headers, but clang does not support ASM GOTO and fails the build.
+ * headers, but clang < 9 does not support ASM GOTO and fails the build.
  */
 #ifndef __BPF_TRACING__
 #warning "Compiler lacks ASM_GOTO support. Add -D __BPF_TRACING__ to your compiler arguments"
diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
index 8a9eba191516..c82f1b334207 100644
--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
@@ -11,9 +11,7 @@
 
 #define __CLOBBERS_MEM(clb...)	"memory", ## clb
 
-#if !defined(__GCC_ASM_FLAG_OUTPUTS__) && defined(CONFIG_CC_HAS_ASM_GOTO)
-
-/* Use asm goto */
+#ifndef __GCC_ASM_FLAG_OUTPUTS__
 
 #define __GEN_RMWcc(fullop, _var, cc, clobbers, ...)			\
 ({									\
@@ -27,21 +25,6 @@ cc_label:	c = true;						\
 	c;								\
 })
 
-#else /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CONFIG_CC_HAS_ASM_GOTO) */
-
-/* Use flags output or a set instruction */
-
-#define __GEN_RMWcc(fullop, _var, cc, clobbers, ...)			\
-({									\
-	bool c;								\
-	asm volatile (fullop CC_SET(cc)					\
-			: [var] "+m" (_var), CC_OUT(cc) (c)		\
-			: __VA_ARGS__ : clobbers);			\
-	c;								\
-})
-
-#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CONFIG_CC_HAS_ASM_GOTO) */
-
 #define GEN_UNARY_RMWcc_4(op, var, cc, arg0)				\
 	__GEN_RMWcc(op " " arg0, var, cc, __CLOBBERS_MEM())
 
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b4eeb7c75dfa..08613c65138d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -493,7 +493,7 @@ FOP_END;
 
 /*
  * XXX: inoutclob user must know where the argument is being expanded.
- *      Relying on CONFIG_CC_HAS_ASM_GOTO would allow us to remove _fault.
+ *      Using asm goto would allow us to remove _fault.
  */
 #define asm_safe(insn, inoutclob...) \
 ({ \
diff --git a/init/Kconfig b/init/Kconfig
index 80fe60fa77fb..532362fcfe31 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -70,11 +70,7 @@ config CC_CAN_LINK_STATIC
 	default $(success,$(srctree)/scripts/cc-can-link.sh $(CC) $(CLANG_FLAGS) $(USERCFLAGS) $(USERLDFLAGS) $(m64-flag) -static) if 64BIT
 	default $(success,$(srctree)/scripts/cc-can-link.sh $(CC) $(CLANG_FLAGS) $(USERCFLAGS) $(USERLDFLAGS) $(m32-flag) -static)
 
-config CC_HAS_ASM_GOTO
-	def_bool $(success,$(srctree)/scripts/gcc-goto.sh $(CC))
-
 config CC_HAS_ASM_GOTO_OUTPUT
-	depends on CC_HAS_ASM_GOTO
 	def_bool $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
 
 config CC_HAS_ASM_GOTO_TIED_OUTPUT
diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
deleted file mode 100755
index 8b980fb2270a..000000000000
--- a/scripts/gcc-goto.sh
+++ /dev/null
@@ -1,22 +0,0 @@
-#!/bin/sh
-# SPDX-License-Identifier: GPL-2.0
-# Test for gcc 'asm goto' support
-# Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
-
-cat << "END" | $@ -x c - -fno-PIE -c -o /dev/null
-int main(void)
-{
-#if defined(__arm__) || defined(__aarch64__)
-	/*
-	 * Not related to asm goto, but used by jump label
-	 * and broken on some ARM GCC versions (see GCC Bug 48637).
-	 */
-	static struct { int dummy; int state; } tp;
-	asm (".long %c0" :: "i" (&tp.state));
-#endif
-
-entry:
-	asm goto ("" :::: entry);
-	return 0;
-}
-END
diff --git a/tools/arch/x86/include/asm/rmwcc.h b/tools/arch/x86/include/asm/rmwcc.h
index fee7983a90b4..11ff975242ca 100644
--- a/tools/arch/x86/include/asm/rmwcc.h
+++ b/tools/arch/x86/include/asm/rmwcc.h
@@ -2,8 +2,6 @@
 #ifndef _TOOLS_LINUX_ASM_X86_RMWcc
 #define _TOOLS_LINUX_ASM_X86_RMWcc
 
-#ifdef CONFIG_CC_HAS_ASM_GOTO
-
 #define __GEN_RMWcc(fullop, var, cc, ...)				\
 do {									\
 	asm_volatile_goto (fullop "; j" cc " %l[cc_label]"		\
@@ -20,23 +18,4 @@ cc_label:								\
 #define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
 	__GEN_RMWcc(op " %1, " arg0, var, cc, vcon (val))
 
-#else /* !CONFIG_CC_HAS_ASM_GOTO */
-
-#define __GEN_RMWcc(fullop, var, cc, ...)				\
-do {									\
-	char c;								\
-	asm volatile (fullop "; set" cc " %1"				\
-			: "+m" (var), "=qm" (c)				\
-			: __VA_ARGS__ : "memory");			\
-	return c != 0;							\
-} while (0)
-
-#define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
-	__GEN_RMWcc(op " " arg0, var, cc)
-
-#define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
-	__GEN_RMWcc(op " %2, " arg0, var, cc, vcon (val))
-
-#endif /* CONFIG_CC_HAS_ASM_GOTO */
-
 #endif /* _TOOLS_LINUX_ASM_X86_RMWcc */
-- 
2.37.1.595.g718a3a8f04-goog

