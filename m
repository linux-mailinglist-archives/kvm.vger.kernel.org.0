Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0771842E5FF
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhJOBTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234923AbhJOBS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD7CC061753;
        Thu, 14 Oct 2021 18:16:26 -0700 (PDT)
Message-ID: <20211015011539.513368075@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=YOsuXSwjrU2Xe+XUzIe+v3+7OEw3Rf70pPuAaXgwdN0=;
        b=iluDAH7IL4qbK2xWxif4Zy62SmPZHPRCduuk69SWswKfqQa4rTlUlqZrb/9o4rHHjylrkq
        40njIXRsxjGHDq8C4AUcgKU9vCCB/+3vuTFZsUc8u18z/9YwJofDxArM9UgRq+JcKHHXVr
        nOg2x1MNAhhr8+HuvDKI0cmTDFJ+esCIr1CZkH1O4PHGVyA8xGXveZAvyvSmsOPrEiwgxT
        5ClwTvcfEJLNRf2aeDO34AhpipOEZHnU20aa3m6jkfJVS3tRUi/gGC0N3lUvs6O/PXrFu7
        sn3vpzT5X1zGlDR2uF1THGBd/LuvH6EauLQ9RVKWJOj3j1L1TwFuvphRtNv5Gw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=YOsuXSwjrU2Xe+XUzIe+v3+7OEw3Rf70pPuAaXgwdN0=;
        b=h+2GJgZfnlMIzE2om1wsOxe3mdH3yQhYiZsk7HPcx9H1g9sE2TtOkKoX6WQxbXIo2sNGFv
        4SSFBBNAlQdzN+Bg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 20/30] x86/fpu: Move os_xsave() and os_xrstor() to core
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:24 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nothing outside the core code needs these.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/internal.h | 165 +-----------------------------------
 arch/x86/include/asm/fpu/xstate.h   |   6 +-
 arch/x86/kernel/fpu/signal.c        |   1 +-
 arch/x86/kernel/fpu/xstate.h        | 174 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 175 insertions(+), 171 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 3ad2ae73efa5..b68f9940489f 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -161,171 +161,6 @@ static inline void fxsave(struct fxregs_state *fx)
 		asm volatile("fxsaveq %[fx]" : [fx] "=m" (*fx));
 }
 
-/* These macros all use (%edi)/(%rdi) as the single memory argument. */
-#define XSAVE		".byte " REX_PREFIX "0x0f,0xae,0x27"
-#define XSAVEOPT	".byte " REX_PREFIX "0x0f,0xae,0x37"
-#define XSAVES		".byte " REX_PREFIX "0x0f,0xc7,0x2f"
-#define XRSTOR		".byte " REX_PREFIX "0x0f,0xae,0x2f"
-#define XRSTORS		".byte " REX_PREFIX "0x0f,0xc7,0x1f"
-
-/*
- * After this @err contains 0 on success or the trap number when the
- * operation raises an exception.
- */
-#define XSTATE_OP(op, st, lmask, hmask, err)				\
-	asm volatile("1:" op "\n\t"					\
-		     "xor %[err], %[err]\n"				\
-		     "2:\n\t"						\
-		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FAULT_MCE_SAFE)	\
-		     : [err] "=a" (err)					\
-		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
-		     : "memory")
-
-/*
- * If XSAVES is enabled, it replaces XSAVEOPT because it supports a compact
- * format and supervisor states in addition to modified optimization in
- * XSAVEOPT.
- *
- * Otherwise, if XSAVEOPT is enabled, XSAVEOPT replaces XSAVE because XSAVEOPT
- * supports modified optimization which is not supported by XSAVE.
- *
- * We use XSAVE as a fallback.
- *
- * The 661 label is defined in the ALTERNATIVE* macros as the address of the
- * original instruction which gets replaced. We need to use it here as the
- * address of the instruction where we might get an exception at.
- */
-#define XSTATE_XSAVE(st, lmask, hmask, err)				\
-	asm volatile(ALTERNATIVE_2(XSAVE,				\
-				   XSAVEOPT, X86_FEATURE_XSAVEOPT,	\
-				   XSAVES,   X86_FEATURE_XSAVES)	\
-		     "\n"						\
-		     "xor %[err], %[err]\n"				\
-		     "3:\n"						\
-		     ".pushsection .fixup,\"ax\"\n"			\
-		     "4: movl $-2, %[err]\n"				\
-		     "jmp 3b\n"						\
-		     ".popsection\n"					\
-		     _ASM_EXTABLE(661b, 4b)				\
-		     : [err] "=r" (err)					\
-		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
-		     : "memory")
-
-/*
- * Use XRSTORS to restore context if it is enabled. XRSTORS supports compact
- * XSAVE area format.
- */
-#define XSTATE_XRESTORE(st, lmask, hmask)				\
-	asm volatile(ALTERNATIVE(XRSTOR,				\
-				 XRSTORS, X86_FEATURE_XSAVES)		\
-		     "\n"						\
-		     "3:\n"						\
-		     _ASM_EXTABLE_TYPE(661b, 3b, EX_TYPE_FPU_RESTORE)	\
-		     :							\
-		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
-		     : "memory")
-
-/*
- * Save processor xstate to xsave area.
- *
- * Uses either XSAVE or XSAVEOPT or XSAVES depending on the CPU features
- * and command line options. The choice is permanent until the next reboot.
- */
-static inline void os_xsave(struct xregs_state *xstate)
-{
-	u64 mask = xfeatures_mask_all;
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-	int err;
-
-	WARN_ON_FPU(!alternatives_patched);
-
-	XSTATE_XSAVE(xstate, lmask, hmask, err);
-
-	/* We should never fault when copying to a kernel buffer: */
-	WARN_ON_FPU(err);
-}
-
-/*
- * Restore processor xstate from xsave area.
- *
- * Uses XRSTORS when XSAVES is used, XRSTOR otherwise.
- */
-static inline void os_xrstor(struct xregs_state *xstate, u64 mask)
-{
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-
-	XSTATE_XRESTORE(xstate, lmask, hmask);
-}
-
-/*
- * Save xstate to user space xsave area.
- *
- * We don't use modified optimization because xrstor/xrstors might track
- * a different application.
- *
- * We don't use compacted format xsave area for backward compatibility for
- * old applications which don't understand the compacted format of the
- * xsave area.
- *
- * The caller has to zero buf::header before calling this because XSAVE*
- * does not touch the reserved fields in the header.
- */
-static inline int xsave_to_user_sigframe(struct xregs_state __user *buf)
-{
-	/*
-	 * Include the features which are not xsaved/rstored by the kernel
-	 * internally, e.g. PKRU. That's user space ABI and also required
-	 * to allow the signal handler to modify PKRU.
-	 */
-	u64 mask = xfeatures_mask_uabi();
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-	int err;
-
-	stac();
-	XSTATE_OP(XSAVE, buf, lmask, hmask, err);
-	clac();
-
-	return err;
-}
-
-/*
- * Restore xstate from user space xsave area.
- */
-static inline int xrstor_from_user_sigframe(struct xregs_state __user *buf, u64 mask)
-{
-	struct xregs_state *xstate = ((__force struct xregs_state *)buf);
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-	int err;
-
-	stac();
-	XSTATE_OP(XRSTOR, xstate, lmask, hmask, err);
-	clac();
-
-	return err;
-}
-
-/*
- * Restore xstate from kernel space xsave area, return an error code instead of
- * an exception.
- */
-static inline int os_xrstor_safe(struct xregs_state *xstate, u64 mask)
-{
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-	int err;
-
-	if (cpu_feature_enabled(X86_FEATURE_XSAVES))
-		XSTATE_OP(XRSTORS, xstate, lmask, hmask, err);
-	else
-		XSTATE_OP(XRSTOR, xstate, lmask, hmask, err);
-
-	return err;
-}
-
 extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
 
 extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 109dfcc75299..b8cebc0ee420 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -78,12 +78,6 @@
 				      XFEATURE_MASK_INDEPENDENT | \
 				      XFEATURE_MASK_SUPERVISOR_UNSUPPORTED)
 
-#ifdef CONFIG_X86_64
-#define REX_PREFIX	"0x48, "
-#else
-#define REX_PREFIX
-#endif
-
 extern u64 xfeatures_mask_all;
 
 static inline u64 xfeatures_mask_supervisor(void)
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 404bbb4a0f60..1a409328aead 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -17,6 +17,7 @@
 #include <asm/trace/fpu.h>
 
 #include "internal.h"
+#include "xstate.h"
 
 static struct _fpx_sw_bytes fx_sw_reserved __ro_after_init;
 static struct _fpx_sw_bytes fx_sw_reserved_ia32 __ro_after_init;
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 81f4202781ac..ae61baa97682 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -18,4 +18,178 @@ static inline void xstate_init_xcomp_bv(struct xregs_state *xsave, u64 mask)
 extern void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
 				      u32 pkru_val, enum xstate_copy_mode copy_mode);
 
+/* XSAVE/XRSTOR wrapper functions */
+
+#ifdef CONFIG_X86_64
+#define REX_PREFIX	"0x48, "
+#else
+#define REX_PREFIX
+#endif
+
+/* These macros all use (%edi)/(%rdi) as the single memory argument. */
+#define XSAVE		".byte " REX_PREFIX "0x0f,0xae,0x27"
+#define XSAVEOPT	".byte " REX_PREFIX "0x0f,0xae,0x37"
+#define XSAVES		".byte " REX_PREFIX "0x0f,0xc7,0x2f"
+#define XRSTOR		".byte " REX_PREFIX "0x0f,0xae,0x2f"
+#define XRSTORS		".byte " REX_PREFIX "0x0f,0xc7,0x1f"
+
+/*
+ * After this @err contains 0 on success or the trap number when the
+ * operation raises an exception.
+ */
+#define XSTATE_OP(op, st, lmask, hmask, err)				\
+	asm volatile("1:" op "\n\t"					\
+		     "xor %[err], %[err]\n"				\
+		     "2:\n\t"						\
+		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FAULT_MCE_SAFE)	\
+		     : [err] "=a" (err)					\
+		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
+		     : "memory")
+
+/*
+ * If XSAVES is enabled, it replaces XSAVEOPT because it supports a compact
+ * format and supervisor states in addition to modified optimization in
+ * XSAVEOPT.
+ *
+ * Otherwise, if XSAVEOPT is enabled, XSAVEOPT replaces XSAVE because XSAVEOPT
+ * supports modified optimization which is not supported by XSAVE.
+ *
+ * We use XSAVE as a fallback.
+ *
+ * The 661 label is defined in the ALTERNATIVE* macros as the address of the
+ * original instruction which gets replaced. We need to use it here as the
+ * address of the instruction where we might get an exception at.
+ */
+#define XSTATE_XSAVE(st, lmask, hmask, err)				\
+	asm volatile(ALTERNATIVE_2(XSAVE,				\
+				   XSAVEOPT, X86_FEATURE_XSAVEOPT,	\
+				   XSAVES,   X86_FEATURE_XSAVES)	\
+		     "\n"						\
+		     "xor %[err], %[err]\n"				\
+		     "3:\n"						\
+		     ".pushsection .fixup,\"ax\"\n"			\
+		     "4: movl $-2, %[err]\n"				\
+		     "jmp 3b\n"						\
+		     ".popsection\n"					\
+		     _ASM_EXTABLE(661b, 4b)				\
+		     : [err] "=r" (err)					\
+		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
+		     : "memory")
+
+/*
+ * Use XRSTORS to restore context if it is enabled. XRSTORS supports compact
+ * XSAVE area format.
+ */
+#define XSTATE_XRESTORE(st, lmask, hmask)				\
+	asm volatile(ALTERNATIVE(XRSTOR,				\
+				 XRSTORS, X86_FEATURE_XSAVES)		\
+		     "\n"						\
+		     "3:\n"						\
+		     _ASM_EXTABLE_TYPE(661b, 3b, EX_TYPE_FPU_RESTORE)	\
+		     :							\
+		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
+		     : "memory")
+
+/*
+ * Save processor xstate to xsave area.
+ *
+ * Uses either XSAVE or XSAVEOPT or XSAVES depending on the CPU features
+ * and command line options. The choice is permanent until the next reboot.
+ */
+static inline void os_xsave(struct xregs_state *xstate)
+{
+	u64 mask = xfeatures_mask_all;
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err;
+
+	WARN_ON_FPU(!alternatives_patched);
+
+	XSTATE_XSAVE(xstate, lmask, hmask, err);
+
+	/* We should never fault when copying to a kernel buffer: */
+	WARN_ON_FPU(err);
+}
+
+/*
+ * Restore processor xstate from xsave area.
+ *
+ * Uses XRSTORS when XSAVES is used, XRSTOR otherwise.
+ */
+static inline void os_xrstor(struct xregs_state *xstate, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
+	XSTATE_XRESTORE(xstate, lmask, hmask);
+}
+
+/*
+ * Save xstate to user space xsave area.
+ *
+ * We don't use modified optimization because xrstor/xrstors might track
+ * a different application.
+ *
+ * We don't use compacted format xsave area for backward compatibility for
+ * old applications which don't understand the compacted format of the
+ * xsave area.
+ *
+ * The caller has to zero buf::header before calling this because XSAVE*
+ * does not touch the reserved fields in the header.
+ */
+static inline int xsave_to_user_sigframe(struct xregs_state __user *buf)
+{
+	/*
+	 * Include the features which are not xsaved/rstored by the kernel
+	 * internally, e.g. PKRU. That's user space ABI and also required
+	 * to allow the signal handler to modify PKRU.
+	 */
+	u64 mask = xfeatures_mask_uabi();
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err;
+
+	stac();
+	XSTATE_OP(XSAVE, buf, lmask, hmask, err);
+	clac();
+
+	return err;
+}
+
+/*
+ * Restore xstate from user space xsave area.
+ */
+static inline int xrstor_from_user_sigframe(struct xregs_state __user *buf, u64 mask)
+{
+	struct xregs_state *xstate = ((__force struct xregs_state *)buf);
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err;
+
+	stac();
+	XSTATE_OP(XRSTOR, xstate, lmask, hmask, err);
+	clac();
+
+	return err;
+}
+
+/*
+ * Restore xstate from kernel space xsave area, return an error code instead of
+ * an exception.
+ */
+static inline int os_xrstor_safe(struct xregs_state *xstate, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err;
+
+	if (cpu_feature_enabled(X86_FEATURE_XSAVES))
+		XSTATE_OP(XRSTORS, xstate, lmask, hmask, err);
+	else
+		XSTATE_OP(XRSTOR, xstate, lmask, hmask, err);
+
+	return err;
+}
+
+
 #endif

