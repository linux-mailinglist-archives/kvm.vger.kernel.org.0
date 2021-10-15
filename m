Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2659042E5DC
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbhJOBS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:26 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46394 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbhJOBSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:15 -0400
Message-ID: <20211015011538.897664678@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=9mP6eQkXKYOSl75/3hJBuuCyR+HyUFavq+clkqMZqqQ=;
        b=Z9S7hBzZjC1ZW6j2qBaNa/11Ee0Kvjra2L43wxgCIPqGvUZlboKMz3gYkx6mNeS7KIuaKs
        E1yBrkmpVcgaLaM/yC0TxjYSck5AK7HPbcMg7brGFY4HueI4n61M28cIQFbBgdVx4ICCoi
        iE4Ukqw3OP8pZxjM/nQ0KtJMcZNC4w49WCsDl4De8vwlmqxJ5MCFj9P89WzpuQeopIHRcA
        L9RQJ+TAVLcNeCeyonn9t5MLgIA/t28SzPj5cz58TPSnbZzaTPtzsN2VIlEp9Q0xY1Tra6
        ekJ9C9Mfaa930xtQXExlTwNB6XKLJ2cqZC5kHUZDBlJ9gaTJ/YStxN3D6IT0nw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=9mP6eQkXKYOSl75/3hJBuuCyR+HyUFavq+clkqMZqqQ=;
        b=XU4b8NrsvZnO7ohwIWu8kEBzsl+iFS0csTDXAHNt3EwsS6KfmuEhyAzI224RJbRlXBtEmB
        xv1Lw1YjXpbFsmBg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 09/30] x86/fpu: Cleanup xstate xcomp_bv initialization
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:07 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No point in having this duplicated all over the place with needlessly
different defines.

Provide a proper initialization function which initializes user buffers
properly and make KVM use it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/internal.h |  4 +++-
 arch/x86/kernel/fpu/core.c          | 35 +++++++++++++++++++----------------
 arch/x86/kernel/fpu/init.c          |  6 +++---
 arch/x86/kernel/fpu/xstate.c        |  8 +++-----
 arch/x86/kernel/fpu/xstate.h        | 18 ++++++++++++++++++
 arch/x86/kvm/x86.c                  | 11 +++--------
 6 files changed, 49 insertions(+), 33 deletions(-)
 create mode 100644 arch/x86/kernel/fpu/xstate.h
---
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 1503750534f7..df57f1af3a4c 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -80,7 +80,9 @@ static __always_inline __pure bool use_fxsr(void)
 
 extern union fpregs_state init_fpstate;
 
-extern void fpstate_init(union fpregs_state *state);
+extern void fpstate_init_user(union fpregs_state *state);
+extern void fpu_init_fpstate_user(struct fpu *fpu);
+
 #ifdef CONFIG_MATH_EMULATION
 extern void fpstate_init_soft(struct swregs_state *soft);
 #else
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 9a6b195a8a00..0789f0c3dca9 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -16,6 +16,8 @@
 #include <linux/hardirq.h>
 #include <linux/pkeys.h>
 
+#include "xstate.h"
+
 #define CREATE_TRACE_POINTS
 #include <asm/trace/fpu.h>
 
@@ -203,15 +205,6 @@ void fpu_sync_fpstate(struct fpu *fpu)
 	fpregs_unlock();
 }
 
-static inline void fpstate_init_xstate(struct xregs_state *xsave)
-{
-	/*
-	 * XRSTORS requires these bits set in xcomp_bv, or it will
-	 * trigger #GP:
-	 */
-	xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT | xfeatures_mask_all;
-}
-
 static inline unsigned int init_fpstate_copy_size(void)
 {
 	if (!use_xsave())
@@ -238,23 +231,33 @@ static inline void fpstate_init_fstate(struct fregs_state *fp)
 	fp->fos = 0xffff0000u;
 }
 
-void fpstate_init(union fpregs_state *state)
+/*
+ * Used in two places:
+ * 1) Early boot to setup init_fpstate for non XSAVE systems
+ * 2) fpu_init_fpstate_user() which is invoked from KVM
+ */
+void fpstate_init_user(union fpregs_state *state)
 {
-	if (!static_cpu_has(X86_FEATURE_FPU)) {
+	if (!cpu_feature_enabled(X86_FEATURE_FPU)) {
 		fpstate_init_soft(&state->soft);
 		return;
 	}
 
-	memset(state, 0, fpu_kernel_xstate_size);
+	xstate_init_xcomp_bv(&state->xsave, xfeatures_mask_uabi());
 
-	if (static_cpu_has(X86_FEATURE_XSAVES))
-		fpstate_init_xstate(&state->xsave);
-	if (static_cpu_has(X86_FEATURE_FXSR))
+	if (cpu_feature_enabled(X86_FEATURE_FXSR))
 		fpstate_init_fxstate(&state->fxsave);
 	else
 		fpstate_init_fstate(&state->fsave);
 }
-EXPORT_SYMBOL_GPL(fpstate_init);
+
+#if IS_ENABLED(CONFIG_KVM)
+void fpu_init_fpstate_user(struct fpu *fpu)
+{
+	fpstate_init_user(&fpu->state);
+}
+EXPORT_SYMBOL_GPL(fpu_init_fpstate_user);
+#endif
 
 /* Clone current's FPU state on fork */
 int fpu_clone(struct task_struct *dst)
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 86bc9759fc8b..37f872630a0e 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -121,10 +121,10 @@ static void __init fpu__init_system_mxcsr(void)
 static void __init fpu__init_system_generic(void)
 {
 	/*
-	 * Set up the legacy init FPU context. (xstate init might overwrite this
-	 * with a more modern format, if the CPU supports it.)
+	 * Set up the legacy init FPU context. Will be updated when the
+	 * CPU supports XSAVE[S].
 	 */
-	fpstate_init(&init_fpstate);
+	fpstate_init_user(&init_fpstate);
 
 	fpu__init_system_mxcsr();
 }
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index d6b5f2266143..259951d1eec5 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -15,10 +15,10 @@
 #include <asm/fpu/internal.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/regset.h>
-#include <asm/fpu/xstate.h>
 
 #include <asm/tlbflush.h>
-#include <asm/cpufeature.h>
+
+#include "xstate.h"
 
 /*
  * Although we spell it out in here, the Processor Trace
@@ -389,9 +389,7 @@ static void __init setup_init_fpu_buf(void)
 	setup_xstate_features();
 	print_xstate_features();
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		init_fpstate.xsave.header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
-						     xfeatures_mask_all;
+	xstate_init_xcomp_bv(&init_fpstate.xsave, xfeatures_mask_all);
 
 	/*
 	 * Init all the features state with header.xfeatures being 0x0
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
new file mode 100644
index 000000000000..0789a04ee705
--- /dev/null
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __X86_KERNEL_FPU_XSTATE_H
+#define __X86_KERNEL_FPU_XSTATE_H
+
+#include <asm/cpufeature.h>
+#include <asm/fpu/xstate.h>
+
+static inline void xstate_init_xcomp_bv(struct xregs_state *xsave, u64 mask)
+{
+	/*
+	 * XRSTORS requires these bits set in xcomp_bv, or it will
+	 * trigger #GP:
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_XSAVES))
+		xsave->header.xcomp_bv = mask | XCOMP_BV_COMPACTED_FORMAT;
+}
+
+#endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..743f522ed293 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10612,14 +10612,6 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 
 static void fx_init(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->arch.guest_fpu)
-		return;
-
-	fpstate_init(&vcpu->arch.guest_fpu->state);
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
-			host_xcr0 | XSTATE_COMPACTION_ENABLED;
-
 	/*
 	 * Ensure guest xcr0 is valid for loading
 	 */
@@ -10704,6 +10696,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		pr_err("kvm: failed to allocate vcpu's fpu\n");
 		goto free_user_fpu;
 	}
+
+	fpu_init_fpstate_user(vcpu->arch.user_fpu);
+	fpu_init_fpstate_user(vcpu->arch.guest_fpu);
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);

