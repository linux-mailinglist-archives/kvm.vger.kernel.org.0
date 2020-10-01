Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD40280896
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 22:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgJAUmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 16:42:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:58716 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgJAUmw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 16:42:52 -0400
IronPort-SDR: bzJm7NXfutW+pKYPqPIIQDENBNJR/JGmR1gYq0GOmxVtmgYlkA9fQAGOfGhP6mHP7dBH/KjAns
 PTLg0W8K7i5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="160170713"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="160170713"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 13:42:52 -0700
IronPort-SDR: XvABefGlMnfU14ZroFxEz2vm+mSLXNyejep8HVTiYSja4asGEQM6YGmNLk9JaYZuQ42KkCpfLu
 QpJVTpUTWWpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="351297044"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2020 13:42:51 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [RFC PATCH 06/22] x86/fpu/xstate: Outline dynamic xstate area size in the task context
Date:   Thu,  1 Oct 2020 13:38:57 -0700
Message-Id: <20201001203913.9125-7-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001203913.9125-1-chang.seok.bae@intel.com>
References: <20201001203913.9125-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The xstate area size in task->fpu used to be fixed at runtime. To
accommodate dynamic user states, introduce variables for representing the
maximum and default (as minimum) area sizes.

do_extra_xstate_size_checks() is ready to calculate both sizes, which can
be compared with CPUID. CPUID can immediately provide the maximum size. The
code needs to rewrite XCR0 registers to get the default size that excludes
the dynamic parts. It is not always straightforward especially when
inter-dependency exists between state component bits. To make it simple,
the code double-checks the maximum size only.

No functional change as long as the kernel does not support the dynamic
area.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 arch/x86/include/asm/processor.h | 10 ++-----
 arch/x86/kernel/fpu/core.c       |  6 ++--
 arch/x86/kernel/fpu/init.c       | 33 ++++++++++++----------
 arch/x86/kernel/fpu/signal.c     |  2 +-
 arch/x86/kernel/fpu/xstate.c     | 48 +++++++++++++++++++++-----------
 arch/x86/kernel/process.c        |  6 ++++
 arch/x86/kvm/x86.c               |  2 +-
 7 files changed, 65 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 97143d87994c..f5f83aa1b90f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -477,7 +477,8 @@ DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 DECLARE_PER_CPU(struct irq_stack *, softirq_stack_ptr);
 #endif	/* X86_64 */
 
-extern unsigned int fpu_kernel_xstate_size;
+extern unsigned int fpu_kernel_xstate_default_size;
+extern unsigned int fpu_kernel_xstate_max_size;
 extern unsigned int fpu_user_xstate_size;
 
 struct perf_event;
@@ -551,12 +552,7 @@ struct thread_struct {
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
index 39ddb22c143b..875620fdfe61 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -206,7 +206,7 @@ void fpstate_init(struct fpu *fpu)
 		return;
 	}
 
-	memset(state, 0, fpu_kernel_xstate_size);
+	memset(state, 0, fpu_kernel_xstate_default_size);
 
 	if (static_cpu_has(X86_FEATURE_XSAVES))
 		fpstate_init_xstate(&state->xsave, xfeatures_mask_all);
@@ -233,7 +233,7 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 	 * Don't let 'init optimized' areas of the XSAVE area
 	 * leak into the child task:
 	 */
-	memset(&dst_fpu->state.xsave, 0, fpu_kernel_xstate_size);
+	memset(&dst_fpu->state.xsave, 0, fpu_kernel_xstate_default_size);
 
 	/*
 	 * If the FPU registers are not current just memcpy() the state.
@@ -245,7 +245,7 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 	 */
 	fpregs_lock();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&dst_fpu->state, &src_fpu->state, fpu_kernel_xstate_size);
+		memcpy(&dst_fpu->state, &src_fpu->state, fpu_kernel_xstate_default_size);
 
 	else if (!copy_fpregs_to_fpstate(dst_fpu))
 		copy_kernel_to_fpregs(dst_fpu);
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 4e89a2698cfb..ee6499075a89 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -131,13 +131,17 @@ static void __init fpu__init_system_generic(void)
 }
 
 /*
- * Size of the FPU context state. All tasks in the system use the
- * same context size, regardless of what portion they use.
- * This is inherent to the XSAVE architecture which puts all state
- * components into a single, continuous memory block:
+ * Size of the maximum FPU context state. It is inherent to the XSAVE architecture
+ * which puts all state components into a single, continuous memory block:
  */
-unsigned int fpu_kernel_xstate_size;
-EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
+unsigned int fpu_kernel_xstate_max_size;
+
+/*
+ * Size of the initial FPU context state. All tasks in the system use this context
+ * size by default.
+ */
+unsigned int fpu_kernel_xstate_default_size;
+EXPORT_SYMBOL_GPL(fpu_kernel_xstate_default_size);
 
 /* Get alignment of the TYPE. */
 #define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
@@ -167,9 +171,9 @@ static void __init fpu__init_task_struct_size(void)
 
 	/*
 	 * Add back the dynamically-calculated register state
-	 * size.
+	 * size by default.
 	 */
-	task_size += fpu_kernel_xstate_size;
+	task_size += fpu_kernel_xstate_default_size;
 
 	/*
 	 * We dynamically size 'struct fpu', so we require that
@@ -194,6 +198,7 @@ static void __init fpu__init_task_struct_size(void)
 static void __init fpu__init_system_xstate_size_legacy(void)
 {
 	static int on_boot_cpu __initdata = 1;
+	unsigned int size;
 
 	WARN_ON_FPU(!on_boot_cpu);
 	on_boot_cpu = 0;
@@ -204,17 +209,17 @@ static void __init fpu__init_system_xstate_size_legacy(void)
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
+	fpu_kernel_xstate_default_size = size;
+	fpu_kernel_xstate_max_size = size;
+	fpu_user_xstate_size = size;
 }
 
 /*
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 6f3bcc7dab80..4fcd2caa63d3 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -289,8 +289,8 @@ static int copy_user_to_fpregs_zeroing(void __user *buf, u64 xbv, int fx_only)
 
 static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 {
+	int state_size = fpu_kernel_xstate_default_size;
 	struct user_i387_ia32_struct *envp = NULL;
-	int state_size = fpu_kernel_xstate_size;
 	int ia32_fxstate = (buf != buf_fx);
 	struct task_struct *tsk = current;
 	struct fpu *fpu = &tsk->thread.fpu;
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index bf2b09bf9b38..6e0d8a9699ed 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -623,13 +623,20 @@ static void check_xstate_against_struct(int nr)
  */
 static void do_extra_xstate_size_checks(void)
 {
-	int paranoid_xstate_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
+	int paranoid_min_size, paranoid_max_size;
 	int i;
 
+	paranoid_min_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
+	paranoid_max_size = paranoid_min_size;
+
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
@@ -639,23 +646,32 @@ static void do_extra_xstate_size_checks(void)
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
+	fpu_kernel_xstate_default_size = paranoid_min_size;
 }
 
 
@@ -740,27 +756,27 @@ static bool is_supported_xstate_size(unsigned int test_xstate_size)
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
 
+	/* Ensure we have the default space: */
+	if (!is_supported_xstate_size(fpu_kernel_xstate_default_size))
+		return -EINVAL;
+
 	/*
 	 * User space is always in standard format.
 	 */
@@ -865,7 +881,7 @@ void __init fpu__init_system_xstate(void)
 
 	pr_info("x86/fpu: Enabled xstate features 0x%llx, context size is %d bytes, using '%s' format.\n",
 		xfeatures_mask_all,
-		fpu_kernel_xstate_size,
+		fpu_kernel_xstate_max_size,
 		boot_cpu_has(X86_FEATURE_XSAVES) ? "compacted" : "standard");
 	return;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ba4593a913fa..43d38bd09fb1 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -96,6 +96,12 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	return fpu__copy(dst, src);
 }
 
+void arch_thread_struct_whitelist(unsigned long *offset, unsigned long *size)
+{
+	*offset = offsetof(struct thread_struct, fpu.state);
+	*size = fpu_kernel_xstate_default_size;
+}
+
 /*
  * Free thread data structures etc..
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 192d52ff5b8c..ecec6418ccca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8848,7 +8848,7 @@ static void kvm_save_current_fpu(struct fpu *fpu)
 	 */
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		memcpy(&fpu->state, &current->thread.fpu.state,
-		       fpu_kernel_xstate_size);
+		       fpu_kernel_xstate_default_size);
 	else
 		copy_fpregs_to_fpstate(fpu);
 }
-- 
2.17.1

