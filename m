Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654F42E1F35
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 17:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgLWQDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 11:03:02 -0500
Received: from mga12.intel.com ([192.55.52.136]:48999 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbgLWQDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 11:03:02 -0500
IronPort-SDR: VDQgBICvMupD1fSOUAAasvocVcoif4cBwtTdblA5ypMZeTkv4v5nXmBdBCYQLQQT6L92tAxwwd
 5vzvbF6U3clw==
X-IronPort-AV: E=McAfee;i="6000,8403,9844"; a="155241876"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="155241876"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2020 08:01:39 -0800
IronPort-SDR: Qlf3g2aVJOVUy5Ml8iiitsAGRO93PqzqTpGOmMnjANOubh3N2af2ayBOXAvLGUdRDKzo08ReWR
 5tnOw12qmw7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="458027949"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2020 08:01:39 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v3 06/21] x86/fpu/xstate: Calculate and remember dynamic xstate buffer sizes
Date:   Wed, 23 Dec 2020 07:57:02 -0800
Message-Id: <20201223155717.19556-7-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223155717.19556-1-chang.seok.bae@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The xstate buffer is currently in-line with static size. To accommodate
dynamic user xstates, introduce variables to represent the maximum and
minimum buffer sizes.

do_extra_xstate_size_checks() calculates the maximum xstate size and sanity
checks it with CPUID. It calculates the static in-line buffer size by
excluding the dynamic user states from the maximum xstate size.

No functional change, until the kernel enables dynamic buffer support.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v2:
* Updated the changelog with task->fpu removed. (Boris Petkov)
* Renamed the in-line size variable.
* Updated some code comments.
---
 arch/x86/include/asm/processor.h | 10 +++----
 arch/x86/kernel/fpu/core.c       |  6 ++---
 arch/x86/kernel/fpu/init.c       | 36 ++++++++++++++++---------
 arch/x86/kernel/fpu/signal.c     |  2 +-
 arch/x86/kernel/fpu/xstate.c     | 46 +++++++++++++++++++++-----------
 arch/x86/kernel/process.c        |  6 +++++
 arch/x86/kvm/x86.c               |  2 +-
 7 files changed, 67 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 82a08b585818..c9c608f8af91 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -477,7 +477,8 @@ DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 DECLARE_PER_CPU(struct irq_stack *, softirq_stack_ptr);
 #endif	/* X86_64 */
 
-extern unsigned int fpu_kernel_xstate_size;
+extern unsigned int fpu_kernel_xstate_min_size;
+extern unsigned int fpu_kernel_xstate_max_size;
 extern unsigned int fpu_user_xstate_size;
 
 struct perf_event;
@@ -545,12 +546,7 @@ struct thread_struct {
 };
 
 /* Whitelist the FPU state from the task_struct for hardened usercopy. */
-static inline void arch_thread_struct_whitelist(unsigned long *offset,
-						unsigned long *size)
-{
-	*offset = offsetof(struct thread_struct, fpu.state);
-	*size = fpu_kernel_xstate_size;
-}
+extern void arch_thread_struct_whitelist(unsigned long *offset, unsigned long *size);
 
 /*
  * Thread-synchronous status.
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 20925cae2a84..1a428803e6b2 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -206,7 +206,7 @@ void fpstate_init(struct fpu *fpu)
 		return;
 	}
 
-	memset(state, 0, fpu_kernel_xstate_size);
+	memset(state, 0, fpu_kernel_xstate_min_size);
 
 	if (static_cpu_has(X86_FEATURE_XSAVES))
 		fpstate_init_xstate(&state->xsave, xfeatures_mask_all);
@@ -233,7 +233,7 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 	 * Don't let 'init optimized' areas of the XSAVE area
 	 * leak into the child task:
 	 */
-	memset(&dst_fpu->state.xsave, 0, fpu_kernel_xstate_size);
+	memset(&dst_fpu->state.xsave, 0, fpu_kernel_xstate_min_size);
 
 	/*
 	 * If the FPU registers are not current just memcpy() the state.
@@ -245,7 +245,7 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 	 */
 	fpregs_lock();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&dst_fpu->state, &src_fpu->state, fpu_kernel_xstate_size);
+		memcpy(&dst_fpu->state, &src_fpu->state, fpu_kernel_xstate_min_size);
 
 	else if (!copy_fpregs_to_fpstate(dst_fpu))
 		copy_kernel_to_fpregs(dst_fpu);
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 74e03e3bc20f..5dac97158030 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -130,13 +130,20 @@ static void __init fpu__init_system_generic(void)
 }
 
 /*
- * Size of the FPU context state. All tasks in the system use the
- * same context size, regardless of what portion they use.
- * This is inherent to the XSAVE architecture which puts all state
- * components into a single, continuous memory block:
+ * Size of the minimally allocated FPU context state. All threads have this amount
+ * of xstate buffer at minimum.
+ *
+ * This buffer is inherent to the XSAVE architecture which puts all state components
+ * into a single, continuous memory block:
+ */
+unsigned int fpu_kernel_xstate_min_size;
+EXPORT_SYMBOL_GPL(fpu_kernel_xstate_min_size);
+
+/*
+ * Size of the maximum FPU context state. When using the compacted format, the buffer
+ * can be dynamically expanded to include some states up to this size.
  */
-unsigned int fpu_kernel_xstate_size;
-EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
+unsigned int fpu_kernel_xstate_max_size;
 
 /* Get alignment of the TYPE. */
 #define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
@@ -167,8 +174,10 @@ static void __init fpu__init_task_struct_size(void)
 	/*
 	 * Add back the dynamically-calculated register state
 	 * size.
+	 *
+	 * Use the minimum size as in-lined to the task_struct.
 	 */
-	task_size += fpu_kernel_xstate_size;
+	task_size += fpu_kernel_xstate_min_size;
 
 	/*
 	 * We dynamically size 'struct fpu', so we require that
@@ -193,6 +202,7 @@ static void __init fpu__init_task_struct_size(void)
 static void __init fpu__init_system_xstate_size_legacy(void)
 {
 	static int on_boot_cpu __initdata = 1;
+	unsigned int size;
 
 	WARN_ON_FPU(!on_boot_cpu);
 	on_boot_cpu = 0;
@@ -203,17 +213,17 @@ static void __init fpu__init_system_xstate_size_legacy(void)
 	 */
 
 	if (!boot_cpu_has(X86_FEATURE_FPU)) {
-		fpu_kernel_xstate_size = sizeof(struct swregs_state);
+		size = sizeof(struct swregs_state);
 	} else {
 		if (boot_cpu_has(X86_FEATURE_FXSR))
-			fpu_kernel_xstate_size =
-				sizeof(struct fxregs_state);
+			size = sizeof(struct fxregs_state);
 		else
-			fpu_kernel_xstate_size =
-				sizeof(struct fregs_state);
+			size = sizeof(struct fregs_state);
 	}
 
-	fpu_user_xstate_size = fpu_kernel_xstate_size;
+	fpu_kernel_xstate_min_size = size;
+	fpu_kernel_xstate_max_size = size;
+	fpu_user_xstate_size = size;
 }
 
 /*
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 414a13427934..b6d2706b6886 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -289,8 +289,8 @@ static int copy_user_to_fpregs_zeroing(void __user *buf, u64 xbv, int fx_only)
 
 static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 {
+	int state_size = fpu_kernel_xstate_min_size;
 	struct user_i387_ia32_struct *envp = NULL;
-	int state_size = fpu_kernel_xstate_size;
 	int ia32_fxstate = (buf != buf_fx);
 	struct task_struct *tsk = current;
 	struct fpu *fpu = &tsk->thread.fpu;
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 6620d0a3caff..2012b17b1793 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -627,13 +627,18 @@ static void check_xstate_against_struct(int nr)
  */
 static void do_extra_xstate_size_checks(void)
 {
-	int paranoid_xstate_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
+	int paranoid_min_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
+	int paranoid_max_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 	int i;
 
 	for (i = FIRST_EXTENDED_XFEATURE; i < XFEATURE_MAX; i++) {
+		bool dynamic;
+
 		if (!xfeature_enabled(i))
 			continue;
 
+		dynamic = (xfeatures_mask_user_dynamic & BIT_ULL(i)) ? true : false;
+
 		check_xstate_against_struct(i);
 		/*
 		 * Supervisor state components can be managed only by
@@ -643,23 +648,32 @@ static void do_extra_xstate_size_checks(void)
 			XSTATE_WARN_ON(xfeature_is_supervisor(i));
 
 		/* Align from the end of the previous feature */
-		if (xfeature_is_aligned(i))
-			paranoid_xstate_size = ALIGN(paranoid_xstate_size, 64);
+		if (xfeature_is_aligned(i)) {
+			paranoid_max_size = ALIGN(paranoid_max_size, 64);
+			if (!dynamic)
+				paranoid_min_size = ALIGN(paranoid_min_size, 64);
+		}
 		/*
 		 * The offset of a given state in the non-compacted
 		 * format is given to us in a CPUID leaf.  We check
 		 * them for being ordered (increasing offsets) in
 		 * setup_xstate_features().
 		 */
-		if (!using_compacted_format())
-			paranoid_xstate_size = xfeature_uncompacted_offset(i);
+		if (!using_compacted_format()) {
+			paranoid_max_size = xfeature_uncompacted_offset(i);
+			if (!dynamic)
+				paranoid_min_size = xfeature_uncompacted_offset(i);
+		}
 		/*
 		 * The compacted-format offset always depends on where
 		 * the previous state ended.
 		 */
-		paranoid_xstate_size += xfeature_size(i);
+		paranoid_max_size += xfeature_size(i);
+		if (!dynamic)
+			paranoid_min_size += xfeature_size(i);
 	}
-	XSTATE_WARN_ON(paranoid_xstate_size != fpu_kernel_xstate_size);
+	XSTATE_WARN_ON(paranoid_max_size != fpu_kernel_xstate_max_size);
+	fpu_kernel_xstate_min_size = paranoid_min_size;
 }
 
 
@@ -744,27 +758,27 @@ static bool is_supported_xstate_size(unsigned int test_xstate_size)
 static int __init init_xstate_size(void)
 {
 	/* Recompute the context size for enabled features: */
-	unsigned int possible_xstate_size;
+	unsigned int possible_max_xstate_size;
 	unsigned int xsave_size;
 
 	xsave_size = get_xsave_size();
 
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		possible_xstate_size = get_xsaves_size_no_dynamic();
+		possible_max_xstate_size = get_xsaves_size_no_dynamic();
 	else
-		possible_xstate_size = xsave_size;
-
-	/* Ensure we have the space to store all enabled: */
-	if (!is_supported_xstate_size(possible_xstate_size))
-		return -EINVAL;
+		possible_max_xstate_size = xsave_size;
 
 	/*
 	 * The size is OK, we are definitely going to use xsave,
 	 * make it known to the world that we need more space.
 	 */
-	fpu_kernel_xstate_size = possible_xstate_size;
+	fpu_kernel_xstate_max_size = possible_max_xstate_size;
 	do_extra_xstate_size_checks();
 
+	/* Ensure we have the supported in-line space: */
+	if (!is_supported_xstate_size(fpu_kernel_xstate_min_size))
+		return -EINVAL;
+
 	/*
 	 * User space is always in standard format.
 	 */
@@ -869,7 +883,7 @@ void __init fpu__init_system_xstate(void)
 
 	pr_info("x86/fpu: Enabled xstate features 0x%llx, context size is %d bytes, using '%s' format.\n",
 		xfeatures_mask_all,
-		fpu_kernel_xstate_size,
+		fpu_kernel_xstate_max_size,
 		boot_cpu_has(X86_FEATURE_XSAVES) ? "compacted" : "standard");
 	return;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 145a7ac0c19a..326b16aefb06 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -96,6 +96,12 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	return fpu__copy(dst, src);
 }
 
+void arch_thread_struct_whitelist(unsigned long *offset, unsigned long *size)
+{
+	*offset = offsetof(struct thread_struct, fpu.state);
+	*size = fpu_kernel_xstate_min_size;
+}
+
 /*
  * Free thread data structures etc..
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a087bbf252b6..4aecfba04bd3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9220,7 +9220,7 @@ static void kvm_save_current_fpu(struct fpu *fpu)
 	 */
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		memcpy(&fpu->state, &current->thread.fpu.state,
-		       fpu_kernel_xstate_size);
+		       fpu_kernel_xstate_min_size);
 	else
 		copy_fpregs_to_fpstate(fpu);
 }
-- 
2.17.1

