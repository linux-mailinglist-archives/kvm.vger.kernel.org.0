Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD50B429A10
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbhJLAId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbhJLAIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:24 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9458C061749;
        Mon, 11 Oct 2021 17:06:23 -0700 (PDT)
Message-ID: <20211011223611.607783558@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=7L/7euo9n/CNBdDDKwpcc2W3IjYL9EGRwYmm+UwXFxU=;
        b=isjfMHPFjDEa6xhr0K+gQrJX1Gwoow/eYK+kLazePctS3q+ANPbSHopk3BDaVW0hUXTcrF
        OloG8mV3nJ6YX9JGTGzCHYkzzL8U3hfy5gQXBVFXsW/RTisF/WWct1UXQ1m6AE9aNKFyRt
        JDhux3qBz7xKtkY629LCLgM1dYtHJfYPDDQW99YUMnzqw1R4MHJyr188L4/divhn5eDxby
        p+6pLVismcmo0iLFkjytBNi0lClTIPVa5W1qANdxMw1fsie6TIT5FxL+9WqYRzwhy/AQgG
        UFy7bDV2JKfSHLMpa6mScUjcAMO5Z2gyfilMZ9vABl525G9A5UucK2KxVihphQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=7L/7euo9n/CNBdDDKwpcc2W3IjYL9EGRwYmm+UwXFxU=;
        b=Strfvt3v+WsA35ZLLcwQQ8moVj1Ub/IGyGOQ8SPNILKYLF/upykI0ahriTLPG5X8yU3Jwu
        pVTGRs/spe4jwwAQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 22/31] x86/fpu: Move legacy ASM wrappers to core
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:31 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nothing outside the core code requires them.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/internal.h |  101 ---------------------------------
 arch/x86/kernel/fpu/core.c          |    1 
 arch/x86/kernel/fpu/legacy.h        |  108 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/fpu/signal.c        |    1 
 arch/x86/kernel/fpu/xstate.c        |    1 
 5 files changed, 111 insertions(+), 101 deletions(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -60,107 +60,6 @@ extern void fpstate_init_soft(struct swr
 static inline void fpstate_init_soft(struct swregs_state *soft) {}
 #endif
 
-/*
- * Returns 0 on success or the trap number when the operation raises an
- * exception.
- */
-#define user_insn(insn, output, input...)				\
-({									\
-	int err;							\
-									\
-	might_fault();							\
-									\
-	asm volatile(ASM_STAC "\n"					\
-		     "1: " #insn "\n"					\
-		     "2: " ASM_CLAC "\n"				\
-		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FAULT_MCE_SAFE)	\
-		     : [err] "=a" (err), output				\
-		     : "0"(0), input);					\
-	err;								\
-})
-
-#define kernel_insn_err(insn, output, input...)				\
-({									\
-	int err;							\
-	asm volatile("1:" #insn "\n\t"					\
-		     "2:\n"						\
-		     ".section .fixup,\"ax\"\n"				\
-		     "3:  movl $-1,%[err]\n"				\
-		     "    jmp  2b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : [err] "=r" (err), output				\
-		     : "0"(0), input);					\
-	err;								\
-})
-
-#define kernel_insn(insn, output, input...)				\
-	asm volatile("1:" #insn "\n\t"					\
-		     "2:\n"						\
-		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FPU_RESTORE)	\
-		     : output : input)
-
-static inline int fnsave_to_user_sigframe(struct fregs_state __user *fx)
-{
-	return user_insn(fnsave %[fx]; fwait,  [fx] "=m" (*fx), "m" (*fx));
-}
-
-static inline int fxsave_to_user_sigframe(struct fxregs_state __user *fx)
-{
-	if (IS_ENABLED(CONFIG_X86_32))
-		return user_insn(fxsave %[fx], [fx] "=m" (*fx), "m" (*fx));
-	else
-		return user_insn(fxsaveq %[fx], [fx] "=m" (*fx), "m" (*fx));
-
-}
-
-static inline void fxrstor(struct fxregs_state *fx)
-{
-	if (IS_ENABLED(CONFIG_X86_32))
-		kernel_insn(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
-	else
-		kernel_insn(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
-}
-
-static inline int fxrstor_safe(struct fxregs_state *fx)
-{
-	if (IS_ENABLED(CONFIG_X86_32))
-		return kernel_insn_err(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
-	else
-		return kernel_insn_err(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
-}
-
-static inline int fxrstor_from_user_sigframe(struct fxregs_state __user *fx)
-{
-	if (IS_ENABLED(CONFIG_X86_32))
-		return user_insn(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
-	else
-		return user_insn(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
-}
-
-static inline void frstor(struct fregs_state *fx)
-{
-	kernel_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
-}
-
-static inline int frstor_safe(struct fregs_state *fx)
-{
-	return kernel_insn_err(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
-}
-
-static inline int frstor_from_user_sigframe(struct fregs_state __user *fx)
-{
-	return user_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
-}
-
-static inline void fxsave(struct fxregs_state *fx)
-{
-	if (IS_ENABLED(CONFIG_X86_32))
-		asm volatile( "fxsave %[fx]" : [fx] "=m" (*fx));
-	else
-		asm volatile("fxsaveq %[fx]" : [fx] "=m" (*fx));
-}
-
 extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
 
 extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -18,6 +18,7 @@
 #include <linux/pkeys.h>
 
 #include "internal.h"
+#include "legacy.h"
 #include "xstate.h"
 
 #define CREATE_TRACE_POINTS
--- /dev/null
+++ b/arch/x86/kernel/fpu/legacy.h
@@ -0,0 +1,108 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __X86_KERNEL_FPU_LEGACY_H
+#define __X86_KERNEL_FPU_LEGACY_H
+
+#include <asm/fpu/types.h>
+
+/*
+ * Returns 0 on success or the trap number when the operation raises an
+ * exception.
+ */
+#define user_insn(insn, output, input...)				\
+({									\
+	int err;							\
+									\
+	might_fault();							\
+									\
+	asm volatile(ASM_STAC "\n"					\
+		     "1: " #insn "\n"					\
+		     "2: " ASM_CLAC "\n"				\
+		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FAULT_MCE_SAFE)	\
+		     : [err] "=a" (err), output				\
+		     : "0"(0), input);					\
+	err;								\
+})
+
+#define kernel_insn_err(insn, output, input...)				\
+({									\
+	int err;							\
+	asm volatile("1:" #insn "\n\t"					\
+		     "2:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "3:  movl $-1,%[err]\n"				\
+		     "    jmp  2b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 3b)				\
+		     : [err] "=r" (err), output				\
+		     : "0"(0), input);					\
+	err;								\
+})
+
+#define kernel_insn(insn, output, input...)				\
+	asm volatile("1:" #insn "\n\t"					\
+		     "2:\n"						\
+		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FPU_RESTORE)	\
+		     : output : input)
+
+static inline int fnsave_to_user_sigframe(struct fregs_state __user *fx)
+{
+	return user_insn(fnsave %[fx]; fwait,  [fx] "=m" (*fx), "m" (*fx));
+}
+
+static inline int fxsave_to_user_sigframe(struct fxregs_state __user *fx)
+{
+	if (IS_ENABLED(CONFIG_X86_32))
+		return user_insn(fxsave %[fx], [fx] "=m" (*fx), "m" (*fx));
+	else
+		return user_insn(fxsaveq %[fx], [fx] "=m" (*fx), "m" (*fx));
+
+}
+
+static inline void fxrstor(struct fxregs_state *fx)
+{
+	if (IS_ENABLED(CONFIG_X86_32))
+		kernel_insn(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+	else
+		kernel_insn(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
+}
+
+static inline int fxrstor_safe(struct fxregs_state *fx)
+{
+	if (IS_ENABLED(CONFIG_X86_32))
+		return kernel_insn_err(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+	else
+		return kernel_insn_err(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
+}
+
+static inline int fxrstor_from_user_sigframe(struct fxregs_state __user *fx)
+{
+	if (IS_ENABLED(CONFIG_X86_32))
+		return user_insn(fxrstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+	else
+		return user_insn(fxrstorq %[fx], "=m" (*fx), [fx] "m" (*fx));
+}
+
+static inline void frstor(struct fregs_state *fx)
+{
+	kernel_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+}
+
+static inline int frstor_safe(struct fregs_state *fx)
+{
+	return kernel_insn_err(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+}
+
+static inline int frstor_from_user_sigframe(struct fregs_state __user *fx)
+{
+	return user_insn(frstor %[fx], "=m" (*fx), [fx] "m" (*fx));
+}
+
+static inline void fxsave(struct fxregs_state *fx)
+{
+	if (IS_ENABLED(CONFIG_X86_32))
+		asm volatile( "fxsave %[fx]" : [fx] "=m" (*fx));
+	else
+		asm volatile("fxsaveq %[fx]" : [fx] "=m" (*fx));
+}
+
+#endif
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -17,6 +17,7 @@
 #include <asm/trace/fpu.h>
 
 #include "internal.h"
+#include "legacy.h"
 #include "xstate.h"
 
 static struct _fpx_sw_bytes fx_sw_reserved __ro_after_init;
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -20,6 +20,7 @@
 #include <asm/tlbflush.h>
 
 #include "internal.h"
+#include "legacy.h"
 #include "xstate.h"
 
 #define for_each_extended_xfeature(bit, mask)				\

