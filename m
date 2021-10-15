Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6217942E5EF
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhJOBTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:12 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46540 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbhJOBSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:33 -0400
Message-ID: <20211015011539.572439164@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=wXFplKFyHNdFHd3/9/YWUtmQO4eBbjH9eqMp16wPlfU=;
        b=A/b7ncCMGUYi5yC9LWyL4KO8atI9nwwtWtvuRn4gWw8b0HfjYYob5iX2xpz3zMZ83d3anp
        Mll/SHVJeGZ+o6EkqxE7BN/9+vhzpGT8yd2fzqLhdhVL7VL0H0WHAWqoaz3yvtPGKG9ylC
        pFUre5CjMEoYsBk/wP9i2vOVFKL/7K2VGtS8HOtUYaoROx3kYYa+w7uVzJYoBCBVVeoLKF
        o0pc66/f4SWPO3xacTcZOazu9LCjzrA1JK59XnGiqDknH5GhCHYinEBWMbLjkwHqG4m1BS
        ZManKdtx5AqltOCSAZVr5qFgyHdu1yaTijKaAipIevHU76rvSISDXLHTXESXTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=wXFplKFyHNdFHd3/9/YWUtmQO4eBbjH9eqMp16wPlfU=;
        b=VXXCdriXRD3Yrw1bLFf66Jd7PAskNQk55Ii8lq13nZlAcq3E34Rm/X/Vta0s0L+rlwdk3k
        dCLSigv9qouRYoDg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 21/30] x86/fpu: Move legacy ASM wrappers to core
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:26 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nothing outside the core code requires them.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/internal.h | 101 +-----------------------------------
 arch/x86/kernel/fpu/core.c          |   1 +-
 arch/x86/kernel/fpu/legacy.h        | 108 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/fpu/signal.c        |   1 +-
 arch/x86/kernel/fpu/xstate.c        |   1 +-
 5 files changed, 111 insertions(+), 101 deletions(-)
 create mode 100644 arch/x86/kernel/fpu/legacy.h
---
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index b68f9940489f..7722aadc3278 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -60,107 +60,6 @@ extern void fpstate_init_soft(struct swregs_state *soft);
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
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 058df2643999..45ad0baa0128 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -18,6 +18,7 @@
 #include <linux/pkeys.h>
 
 #include "internal.h"
+#include "legacy.h"
 #include "xstate.h"
 
 #define CREATE_TRACE_POINTS
diff --git a/arch/x86/kernel/fpu/legacy.h b/arch/x86/kernel/fpu/legacy.h
new file mode 100644
index 000000000000..2ff36b0f79e9
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
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 1a409328aead..873b65ca22ed 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -17,6 +17,7 @@
 #include <asm/trace/fpu.h>
 
 #include "internal.h"
+#include "legacy.h"
 #include "xstate.h"
 
 static struct _fpx_sw_bytes fx_sw_reserved __ro_after_init;
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index b712c06cbbfb..246a7fea06b1 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -20,6 +20,7 @@
 #include <asm/tlbflush.h>
 
 #include "internal.h"
+#include "legacy.h"
 #include "xstate.h"
 
 #define for_each_extended_xfeature(bit, mask)				\

