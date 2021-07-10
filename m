Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7A53C3493
	for <lists+kvm@lfdr.de>; Sat, 10 Jul 2021 15:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhGJNMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jul 2021 09:12:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:49951 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231250AbhGJNLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jul 2021 09:11:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="209793905"
X-IronPort-AV: E=Sophos;i="5.84,229,1620716400"; 
   d="scan'208";a="209793905"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2021 06:09:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,229,1620716400"; 
   d="scan'208";a="488742356"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2021 06:09:06 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v7 05/26] x86/fpu/xstate: Add new variables to indicate dynamic XSTATE buffer size
Date:   Sat, 10 Jul 2021 06:02:52 -0700
Message-Id: <20210710130313.5072-6-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210710130313.5072-1-chang.seok.bae@intel.com>
References: <20210710130313.5072-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The XSTATE per-task buffer is in preparation to be dynamic for user states.
Introduce new size variables to indicate the minimum and maximum size of
the buffer. The value is determined at boot-time.

Instead of adding them as newly exported, introduce helper functions to
access them as well as the user buffer size.

No functional change. Those sizes have no difference, as the buffer is not
dynamic yet.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v6:
* Massage the code comment.

Changes from v5:
* Made the new variables __ro_after_init for the new base code.
* Fixed the init_fpstate size for memset().

Changes from v3:
* Added as a new patch to add the variables along with new helpers.
  (Borislav Petkov)
---
 arch/x86/include/asm/fpu/xstate.h |  9 ++++
 arch/x86/include/asm/processor.h  | 10 +---
 arch/x86/kernel/fpu/core.c        | 26 +++++++---
 arch/x86/kernel/fpu/init.c        | 26 ++++------
 arch/x86/kernel/fpu/regset.c      |  2 +-
 arch/x86/kernel/fpu/signal.c      | 26 ++++++----
 arch/x86/kernel/fpu/xstate.c      | 83 +++++++++++++++++++++++++------
 arch/x86/kernel/process.c         |  7 +++
 arch/x86/kvm/x86.c                |  5 +-
 9 files changed, 133 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index bc4cba62906b..d722e774a9f9 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -136,6 +136,15 @@ extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 extern void __init update_regset_xstate_info(unsigned int size,
 					     u64 xstate_mask);
 
+enum xstate_config {
+	XSTATE_MIN_SIZE,
+	XSTATE_MAX_SIZE,
+	XSTATE_USER_SIZE
+};
+
+extern unsigned int get_xstate_config(enum xstate_config cfg);
+void set_xstate_config(enum xstate_config cfg, unsigned int value);
+
 void *get_xsave_addr(struct fpu *fpu, int xfeature_nr);
 int xfeature_size(int xfeature_nr);
 int copy_uabi_from_kernel_to_xstate(struct fpu *fpu, const void *kbuf);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index f3020c54e2cb..505f596d1046 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -459,9 +459,6 @@ DECLARE_PER_CPU(struct irq_stack *, hardirq_stack_ptr);
 DECLARE_PER_CPU(struct irq_stack *, softirq_stack_ptr);
 #endif	/* !X86_64 */
 
-extern unsigned int fpu_kernel_xstate_size;
-extern unsigned int fpu_user_xstate_size;
-
 struct perf_event;
 
 struct thread_struct {
@@ -536,12 +533,7 @@ struct thread_struct {
 };
 
 /* Whitelist the FPU state from the task_struct for hardened usercopy. */
-static inline void arch_thread_struct_whitelist(unsigned long *offset,
-						unsigned long *size)
-{
-	*offset = offsetof(struct thread_struct, fpu.state);
-	*size = fpu_kernel_xstate_size;
-}
+extern void arch_thread_struct_whitelist(unsigned long *offset, unsigned long *size);
 
 static inline void
 native_load_sp0(unsigned long sp0)
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 6bc8ad4a3bd7..fc01aa6f967e 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -231,21 +231,30 @@ static inline void fpstate_init_fstate(struct fregs_state *fp)
 void fpstate_init(struct fpu *fpu)
 {
 	union fpregs_state *state;
+	unsigned int size;
+	u64 mask;
 
-	if (likely(fpu))
+	if (likely(fpu)) {
 		state = &fpu->state;
-	else
+		/* The dynamic user states are not prepared yet. */
+		mask = xfeatures_mask_all & ~xfeatures_mask_user_dynamic;
+		size = get_xstate_config(XSTATE_MIN_SIZE);
+	} else {
 		state = &init_fpstate;
+		mask = xfeatures_mask_all;
+		size = sizeof(init_fpstate);
+	}
 
 	if (!static_cpu_has(X86_FEATURE_FPU)) {
 		fpstate_init_soft(&state->soft);
 		return;
 	}
 
-	memset(state, 0, fpu_kernel_xstate_size);
+	memset(state, 0, size);
 
 	if (static_cpu_has(X86_FEATURE_XSAVES))
-		fpstate_init_xstate(&state->xsave, xfeatures_mask_all);
+		fpstate_init_xstate(&state->xsave, mask);
+
 	if (static_cpu_has(X86_FEATURE_FXSR))
 		fpstate_init_fxstate(&state->fxsave);
 	else
@@ -268,8 +277,11 @@ int fpu_clone(struct task_struct *dst)
 	/*
 	 * Don't let 'init optimized' areas of the XSAVE area
 	 * leak into the child task:
+	 *
+	 * The child does not inherit the dynamic states. So,
+	 * the xstate buffer has the minimum size.
 	 */
-	memset(&dst_fpu->state.xsave, 0, fpu_kernel_xstate_size);
+	memset(&dst_fpu->state.xsave, 0, get_xstate_config(XSTATE_MIN_SIZE));
 
 	/*
 	 * If the FPU registers are not owned by current just memcpy() the
@@ -278,7 +290,7 @@ int fpu_clone(struct task_struct *dst)
 	 */
 	fpregs_lock();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&dst_fpu->state, &src_fpu->state, fpu_kernel_xstate_size);
+		memcpy(&dst_fpu->state, &src_fpu->state, get_xstate_config(XSTATE_MIN_SIZE));
 
 	else
 		save_fpregs_to_fpstate(dst_fpu);
@@ -337,7 +349,7 @@ static inline void restore_fpregs_from_init_fpstate(u64 features_mask)
 static inline unsigned int init_fpstate_copy_size(void)
 {
 	if (!use_xsave())
-		return fpu_kernel_xstate_size;
+		return get_xstate_config(XSTATE_MIN_SIZE);
 
 	/* XSAVE(S) just needs the legacy and the xstate header part */
 	return sizeof(init_fpstate.xsave);
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index e14c72bc8706..10e2a95916aa 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -129,15 +129,6 @@ static void __init fpu__init_system_generic(void)
 	fpu__init_system_mxcsr();
 }
 
-/*
- * Size of the FPU context state. All tasks in the system use the
- * same context size, regardless of what portion they use.
- * This is inherent to the XSAVE architecture which puts all state
- * components into a single, continuous memory block:
- */
-unsigned int fpu_kernel_xstate_size __ro_after_init;
-EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
-
 /* Get alignment of the TYPE. */
 #define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
 
@@ -167,8 +158,10 @@ static void __init fpu__init_task_struct_size(void)
 	/*
 	 * Add back the dynamically-calculated register state
 	 * size.
+	 *
+	 * Use the minimum size as embedded to task_struct.
 	 */
-	task_size += fpu_kernel_xstate_size;
+	task_size += get_xstate_config(XSTATE_MIN_SIZE);
 
 	/*
 	 * We dynamically size 'struct fpu', so we require that
@@ -193,6 +186,7 @@ static void __init fpu__init_task_struct_size(void)
 static void __init fpu__init_system_xstate_size_legacy(void)
 {
 	static int on_boot_cpu __initdata = 1;
+	unsigned int xstate_size;
 
 	WARN_ON_FPU(!on_boot_cpu);
 	on_boot_cpu = 0;
@@ -203,17 +197,17 @@ static void __init fpu__init_system_xstate_size_legacy(void)
 	 */
 
 	if (!boot_cpu_has(X86_FEATURE_FPU)) {
-		fpu_kernel_xstate_size = sizeof(struct swregs_state);
+		xstate_size = sizeof(struct swregs_state);
 	} else {
 		if (boot_cpu_has(X86_FEATURE_FXSR))
-			fpu_kernel_xstate_size =
-				sizeof(struct fxregs_state);
+			xstate_size = sizeof(struct fxregs_state);
 		else
-			fpu_kernel_xstate_size =
-				sizeof(struct fregs_state);
+			xstate_size = sizeof(struct fregs_state);
 	}
 
-	fpu_user_xstate_size = fpu_kernel_xstate_size;
+	set_xstate_config(XSTATE_MIN_SIZE, xstate_size);
+	set_xstate_config(XSTATE_MAX_SIZE, xstate_size);
+	set_xstate_config(XSTATE_USER_SIZE, xstate_size);
 }
 
 /* Legacy code to initialize eager fpu mode. */
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 49dd307003ec..8dea3730620e 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -149,7 +149,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	/*
 	 * A whole standard-format XSAVE buffer is needed:
 	 */
-	if (pos != 0 || count != fpu_user_xstate_size)
+	if (pos != 0 || count != get_xstate_config(XSTATE_USER_SIZE))
 		return -EFAULT;
 
 	if (!kbuf) {
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index bec8c8046888..63f000988fa6 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -36,7 +36,7 @@ static inline int check_xstate_in_sigframe(struct fxregs_state __user *fxbuf,
 	/* Check for the first magic field and other error scenarios. */
 	if (fx_sw->magic1 != FP_XSTATE_MAGIC1 ||
 	    fx_sw->xstate_size < min_xstate_size ||
-	    fx_sw->xstate_size > fpu_user_xstate_size ||
+	    fx_sw->xstate_size > get_xstate_config(XSTATE_USER_SIZE) ||
 	    fx_sw->xstate_size > fx_sw->extended_size)
 		goto setfx;
 
@@ -107,7 +107,7 @@ static inline int save_xstate_epilog(void __user *buf, int ia32_frame)
 		return err;
 
 	err |= __put_user(FP_XSTATE_MAGIC2,
-			  (__u32 __user *)(buf + fpu_user_xstate_size));
+			  (__u32 __user *)(buf + get_xstate_config(XSTATE_USER_SIZE)));
 
 	/*
 	 * Read the xfeatures which we copied (directly from the cpu or
@@ -144,7 +144,7 @@ static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf)
 	else
 		err = fnsave_to_user_sigframe((struct fregs_state __user *) buf);
 
-	if (unlikely(err) && __clear_user(buf, fpu_user_xstate_size))
+	if (unlikely(err) && __clear_user(buf, get_xstate_config(XSTATE_USER_SIZE)))
 		err = -EFAULT;
 	return err;
 }
@@ -205,7 +205,7 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 	fpregs_unlock();
 
 	if (ret) {
-		if (!fault_in_pages_writeable(buf_fx, fpu_user_xstate_size))
+		if (!fault_in_pages_writeable(buf_fx, get_xstate_config(XSTATE_USER_SIZE)))
 			goto retry;
 		return -EFAULT;
 	}
@@ -304,12 +304,12 @@ static int restore_fpregs_from_user(void __user *buf, u64 xrestore,
 static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 			     bool ia32_fxstate)
 {
-	int state_size = fpu_kernel_xstate_size;
 	struct task_struct *tsk = current;
 	struct fpu *fpu = &tsk->thread.fpu;
 	struct user_i387_ia32_struct env;
 	u64 user_xfeatures = 0;
 	bool fx_only = false;
+	int state_size;
 	int ret;
 
 	if (use_xsave()) {
@@ -323,6 +323,8 @@ static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 		state_size = fx_sw_user.xstate_size;
 		user_xfeatures = fx_sw_user.xfeatures;
 	} else {
+		/* The buffer cannot be dynamic without using XSAVE. */
+		state_size = get_xstate_config(XSTATE_MIN_SIZE);
 		user_xfeatures = XFEATURE_MASK_FPSSE;
 	}
 
@@ -418,8 +420,9 @@ static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 }
 static inline int xstate_sigframe_size(void)
 {
-	return use_xsave() ? fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE :
-			fpu_user_xstate_size;
+	int xstate_size = get_xstate_config(XSTATE_USER_SIZE);
+
+	return use_xsave() ? xstate_size + FP_XSTATE_MAGIC2_SIZE : xstate_size;
 }
 
 /*
@@ -514,19 +517,20 @@ unsigned long fpu__get_fpstate_size(void)
  */
 void fpu__init_prepare_fx_sw_frame(void)
 {
-	int size = fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE;
+	int xstate_size = get_xstate_config(XSTATE_USER_SIZE);
+	int ext_size = xstate_size + FP_XSTATE_MAGIC2_SIZE;
 
 	fx_sw_reserved.magic1 = FP_XSTATE_MAGIC1;
-	fx_sw_reserved.extended_size = size;
+	fx_sw_reserved.extended_size = ext_size;
 	fx_sw_reserved.xfeatures = xfeatures_mask_uabi();
-	fx_sw_reserved.xstate_size = fpu_user_xstate_size;
+	fx_sw_reserved.xstate_size = xstate_size;
 
 	if (IS_ENABLED(CONFIG_IA32_EMULATION) ||
 	    IS_ENABLED(CONFIG_X86_32)) {
 		int fsave_header_size = sizeof(struct fregs_state);
 
 		fx_sw_reserved_ia32 = fx_sw_reserved;
-		fx_sw_reserved_ia32.extended_size = size + fsave_header_size;
+		fx_sw_reserved_ia32.extended_size = ext_size + fsave_header_size;
 	}
 }
 
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 1d76afc29f19..cfcb0c29e5e4 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -77,12 +77,51 @@ static unsigned int xstate_comp_offsets[XFEATURE_MAX] __ro_after_init =
 static unsigned int xstate_supervisor_only_offsets[XFEATURE_MAX] __ro_after_init =
 	{ [ 0 ... XFEATURE_MAX - 1] = -1};
 
-/*
- * The XSAVE area of kernel can be in standard or compacted format;
- * it is always in standard format for user mode. This is the user
- * mode standard format size used for signal and ptrace frames.
+/**
+ * struct fpu_xstate_buffer_config - xstate buffer configuration
+ * @max_size:			The CPUID-enumerated all-feature "maximum" size
+ *				for xstate per-task buffer.
+ * @min_size:			The size to fit into the statically-allocated
+ *				buffer. With dynamic states, this buffer no longer
+ *				contains all the enabled state components.
+ * @user_size:			The size of user-space buffer for signal and
+ *				ptrace frames, in the non-compacted format.
  */
-unsigned int fpu_user_xstate_size __ro_after_init;
+struct fpu_xstate_buffer_config {
+	unsigned int min_size, max_size;
+	unsigned int user_size;
+};
+
+static struct fpu_xstate_buffer_config buffer_config __ro_after_init;
+
+unsigned int get_xstate_config(enum xstate_config cfg)
+{
+	switch (cfg) {
+	case XSTATE_MIN_SIZE:
+		return buffer_config.min_size;
+	case XSTATE_MAX_SIZE:
+		return buffer_config.max_size;
+	case XSTATE_USER_SIZE:
+		return buffer_config.user_size;
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(get_xstate_config);
+
+void set_xstate_config(enum xstate_config cfg, unsigned int value)
+{
+	switch (cfg) {
+	case XSTATE_MIN_SIZE:
+		buffer_config.min_size = value;
+		break;
+	case XSTATE_MAX_SIZE:
+		buffer_config.max_size = value;
+		break;
+	case XSTATE_USER_SIZE:
+		buffer_config.user_size = value;
+	}
+}
 
 /*
  * Return whether the system supports a given xfeature.
@@ -595,7 +634,11 @@ static void do_extra_xstate_size_checks(void)
 		 */
 		paranoid_xstate_size += xfeature_size(i);
 	}
-	XSTATE_WARN_ON(paranoid_xstate_size != fpu_kernel_xstate_size);
+	/*
+	 * The size accounts for all the possible states reserved in the
+	 * per-task buffer.  Check against the maximum size.
+	 */
+	XSTATE_WARN_ON(paranoid_xstate_size != get_xstate_config(XSTATE_MAX_SIZE));
 }
 
 
@@ -690,21 +733,29 @@ static int __init init_xstate_size(void)
 	else
 		possible_xstate_size = xsave_size;
 
-	/* Ensure we have the space to store all enabled: */
-	if (!is_supported_xstate_size(possible_xstate_size))
-		return -EINVAL;
-
 	/*
-	 * The size is OK, we are definitely going to use xsave,
-	 * make it known to the world that we need more space.
+	 * The size accounts for all the possible states reserved in the
+	 * per-task buffer.  Set the maximum with this value.
 	 */
-	fpu_kernel_xstate_size = possible_xstate_size;
+	set_xstate_config(XSTATE_MAX_SIZE, possible_xstate_size);
+
+	/* Perform an extra check for the maximum size. */
 	do_extra_xstate_size_checks();
 
+	/*
+	 * Set the minimum to be the same as the maximum. The dynamic
+	 * user states are not supported yet.
+	 */
+	set_xstate_config(XSTATE_MIN_SIZE, possible_xstate_size);
+
+	/* Ensure the minimum size fits in the statically-allocated buffer: */
+	if (!is_supported_xstate_size(get_xstate_config(XSTATE_MIN_SIZE)))
+		return -EINVAL;
+
 	/*
 	 * User space is always in standard format.
 	 */
-	fpu_user_xstate_size = xsave_size;
+	set_xstate_config(XSTATE_USER_SIZE, xsave_size);
 	return 0;
 }
 
@@ -800,7 +851,7 @@ void __init fpu__init_system_xstate(void)
 	 * Update info used for ptrace frames; use standard-format size and no
 	 * supervisor xstates:
 	 */
-	update_regset_xstate_info(fpu_user_xstate_size, xfeatures_mask_uabi());
+	update_regset_xstate_info(get_xstate_config(XSTATE_USER_SIZE), xfeatures_mask_uabi());
 
 	fpu__init_prepare_fx_sw_frame();
 	setup_init_fpu_buf();
@@ -820,7 +871,7 @@ void __init fpu__init_system_xstate(void)
 	print_xstate_offset_size();
 	pr_info("x86/fpu: Enabled xstate features 0x%llx, context size is %d bytes, using '%s' format.\n",
 		xfeatures_mask_all,
-		fpu_kernel_xstate_size,
+		get_xstate_config(XSTATE_MAX_SIZE),
 		boot_cpu_has(X86_FEATURE_XSAVES) ? "compacted" : "standard");
 	return;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d9463e3096b..9ad39e807fcf 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -90,6 +90,13 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	return fpu_clone(dst);
 }
 
+void arch_thread_struct_whitelist(unsigned long *offset, unsigned long *size)
+{
+	*offset = offsetof(struct thread_struct, fpu.state);
+	/* The buffer embedded in thread_struct has the minimum size. */
+	*size = get_xstate_config(XSTATE_MIN_SIZE);
+}
+
 /*
  * Free thread data structures etc..
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bd1e655dda9a..610a8c71e40e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9884,10 +9884,13 @@ static void kvm_save_current_fpu(struct fpu *fpu)
 	/*
 	 * If the target FPU state is not resident in the CPU registers, just
 	 * memcpy() from current, else save CPU state directly to the target.
+	 *
+	 * KVM does not support dynamic user states yet. Assume the buffer
+	 * always has the minimum size.
 	 */
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		memcpy(&fpu->state, &current->thread.fpu.state,
-		       fpu_kernel_xstate_size);
+		       get_xstate_config(XSTATE_MIN_SIZE));
 	else
 		save_fpregs_to_fpstate(fpu);
 }
-- 
2.17.1

