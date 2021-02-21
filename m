Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB22320CF0
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 20:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhBUTCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 14:02:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:2045 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230206AbhBUTCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 14:02:25 -0500
IronPort-SDR: /kKcnz+YFXJnS56yPr9MS9L3HU0Ea1x0GMN1KVIDUjHw4XRIza1wQaFLdifDP3HUFRUsQvxOlV
 rIHcBKFE/7Bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="184382824"
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="184382824"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2021 11:01:27 -0800
IronPort-SDR: +TZ5FY2bPtSLhvgm1OpabPFyD83SIwsAiejzjqLGQ+Ch+7NCjvMgRhgSIAl0gJnHevLFVsQ/3K
 Vwwduy7rHi0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="429792096"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Feb 2021 11:01:26 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v4 06/22] x86/fpu/xstate: Add new variables to indicate dynamic xstate buffer size
Date:   Sun, 21 Feb 2021 10:56:21 -0800
Message-Id: <20210221185637.19281-7-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210221185637.19281-1-chang.seok.bae@intel.com>
References: <20210221185637.19281-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The xstate per-task buffer is in preparation to be dynamic for user states.
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
Changes from v3:
* Added as a new patch to add the variables along with new helpers.
  (Borislav Petkov)
---
 arch/x86/include/asm/fpu/xstate.h |  9 ++++
 arch/x86/include/asm/processor.h  | 10 +---
 arch/x86/kernel/fpu/core.c        | 24 +++++++---
 arch/x86/kernel/fpu/init.c        | 26 ++++-------
 arch/x86/kernel/fpu/regset.c      |  4 +-
 arch/x86/kernel/fpu/signal.c      | 27 ++++++-----
 arch/x86/kernel/fpu/xstate.c      | 78 ++++++++++++++++++++++++-------
 arch/x86/kernel/process.c         |  7 +++
 arch/x86/kvm/x86.c                |  5 +-
 9 files changed, 129 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 6ce8350672c2..1fba2ca15874 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -102,6 +102,15 @@ extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
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
 const void *get_xsave_field_ptr(int xfeature_nr);
 int using_compacted_format(void);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c20a52b5534b..f70228312790 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -477,9 +477,6 @@ DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 DECLARE_PER_CPU(struct irq_stack *, softirq_stack_ptr);
 #endif	/* X86_64 */
 
-extern unsigned int fpu_kernel_xstate_size;
-extern unsigned int fpu_user_xstate_size;
-
 struct perf_event;
 
 struct thread_struct {
@@ -545,12 +542,7 @@ struct thread_struct {
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
index 5775e64b0172..043fdba8431c 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -198,21 +198,30 @@ static inline void fpstate_init_fstate(struct fregs_state *fp)
 void fpstate_init(struct fpu *fpu)
 {
 	union fpregs_state *state;
+	unsigned int size;
+	u64 mask;
 
-	if (fpu)
+	if (fpu) {
 		state = &fpu->state;
-	else
+		/* The dynamic user states are not prepared yet. */
+		mask = xfeatures_mask_all & ~xfeatures_mask_user_dynamic;
+		size = get_xstate_config(XSTATE_MIN_SIZE);
+	} else {
 		state = &init_fpstate;
+		mask = xfeatures_mask_all;
+		size = get_xstate_config(XSTATE_MAX_SIZE);
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
@@ -235,8 +244,11 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
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
 	 * If the FPU registers are not current just memcpy() the state.
@@ -248,7 +260,7 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 	 */
 	fpregs_lock();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&dst_fpu->state, &src_fpu->state, fpu_kernel_xstate_size);
+		memcpy(&dst_fpu->state, &src_fpu->state, get_xstate_config(XSTATE_MIN_SIZE));
 
 	else if (!copy_fpregs_to_fpstate(dst_fpu))
 		copy_kernel_to_fpregs(dst_fpu);
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 74e03e3bc20f..f63765b7a83c 100644
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
-unsigned int fpu_kernel_xstate_size;
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
+	unsigned int size;
 
 	WARN_ON_FPU(!on_boot_cpu);
 	on_boot_cpu = 0;
@@ -203,17 +197,17 @@ static void __init fpu__init_system_xstate_size_legacy(void)
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
+	set_xstate_config(XSTATE_MIN_SIZE, size);
+	set_xstate_config(XSTATE_MAX_SIZE, size);
+	set_xstate_config(XSTATE_USER_SIZE, size);
 }
 
 /*
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 5e13e58d11d4..6a025fa26a7e 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -99,7 +99,7 @@ int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
 		/*
 		 * Copy the xstate memory layout.
 		 */
-		return membuf_write(&to, xsave, fpu_user_xstate_size);
+		return membuf_write(&to, xsave, get_xstate_config(XSTATE_USER_SIZE));
 	}
 }
 
@@ -117,7 +117,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	/*
 	 * A whole standard-format XSAVE buffer is needed:
 	 */
-	if ((pos != 0) || (count < fpu_user_xstate_size))
+	if ((pos != 0) || (count < get_xstate_config(XSTATE_USER_SIZE)))
 		return -EFAULT;
 
 	xsave = &fpu->state.xsave;
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 0d6deb75c507..3a2d8665b9a3 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -35,7 +35,7 @@ static inline int check_for_xstate(struct fxregs_state __user *buf,
 	/* Check for the first magic field and other error scenarios. */
 	if (fx_sw->magic1 != FP_XSTATE_MAGIC1 ||
 	    fx_sw->xstate_size < min_xstate_size ||
-	    fx_sw->xstate_size > fpu_user_xstate_size ||
+	    fx_sw->xstate_size > get_xstate_config(XSTATE_USER_SIZE) ||
 	    fx_sw->xstate_size > fx_sw->extended_size)
 		return -1;
 
@@ -98,7 +98,7 @@ static inline int save_xstate_epilog(void __user *buf, int ia32_frame)
 		return err;
 
 	err |= __put_user(FP_XSTATE_MAGIC2,
-			  (__u32 __user *)(buf + fpu_user_xstate_size));
+			  (__u32 __user *)(buf + get_xstate_config(XSTATE_USER_SIZE)));
 
 	/*
 	 * Read the xfeatures which we copied (directly from the cpu or
@@ -135,7 +135,7 @@ static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf)
 	else
 		err = copy_fregs_to_user((struct fregs_state __user *) buf);
 
-	if (unlikely(err) && __clear_user(buf, fpu_user_xstate_size))
+	if (unlikely(err) && __clear_user(buf, get_xstate_config(XSTATE_USER_SIZE)))
 		err = -EFAULT;
 	return err;
 }
@@ -196,7 +196,7 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 	fpregs_unlock();
 
 	if (ret) {
-		if (!fault_in_pages_writeable(buf_fx, fpu_user_xstate_size))
+		if (!fault_in_pages_writeable(buf_fx, get_xstate_config(XSTATE_USER_SIZE)))
 			goto retry;
 		return -EFAULT;
 	}
@@ -290,13 +290,13 @@ static int copy_user_to_fpregs_zeroing(void __user *buf, u64 xbv, int fx_only)
 static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 {
 	struct user_i387_ia32_struct *envp = NULL;
-	int state_size = fpu_kernel_xstate_size;
 	int ia32_fxstate = (buf != buf_fx);
 	struct task_struct *tsk = current;
 	struct fpu *fpu = &tsk->thread.fpu;
 	struct user_i387_ia32_struct env;
 	u64 user_xfeatures = 0;
 	int fx_only = 0;
+	int state_size;
 	int ret = 0;
 
 	ia32_fxstate &= (IS_ENABLED(CONFIG_X86_32) ||
@@ -330,6 +330,9 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 			state_size = fx_sw_user.xstate_size;
 			user_xfeatures = fx_sw_user.xfeatures;
 		}
+	} else {
+		/* The buffer cannot be dynamic without using XSAVE. */
+		state_size = get_xstate_config(XSTATE_MIN_SIZE);
 	}
 
 	if ((unsigned long)buf_fx % 64)
@@ -469,8 +472,9 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 
 static inline int xstate_sigframe_size(void)
 {
-	return use_xsave() ? fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE :
-			fpu_user_xstate_size;
+	int size = get_xstate_config(XSTATE_USER_SIZE);
+
+	return use_xsave() ? size + FP_XSTATE_MAGIC2_SIZE : size;
 }
 
 /*
@@ -514,19 +518,20 @@ fpu__alloc_mathframe(unsigned long sp, int ia32_frame,
  */
 void fpu__init_prepare_fx_sw_frame(void)
 {
-	int size = fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE;
+	int xstate_size = get_xstate_config(XSTATE_USER_SIZE);
+	int ext_size = xstate_size + FP_XSTATE_MAGIC2_SIZE;
 
 	fx_sw_reserved.magic1 = FP_XSTATE_MAGIC1;
-	fx_sw_reserved.extended_size = size;
+	fx_sw_reserved.extended_size = ext_size;
 	fx_sw_reserved.xfeatures = xfeatures_mask_user();
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
index 43940828d1a3..16379c368714 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -72,12 +72,50 @@ static unsigned int xstate_sizes[XFEATURE_MAX]   = { [ 0 ... XFEATURE_MAX - 1] =
 static unsigned int xstate_comp_offsets[XFEATURE_MAX] = { [ 0 ... XFEATURE_MAX - 1] = -1};
 static unsigned int xstate_supervisor_only_offsets[XFEATURE_MAX] = { [ 0 ... XFEATURE_MAX - 1] = -1};
 
-/*
- * The XSAVE area of kernel can be in standard or compacted format;
- * it is always in standard format for user mode. This is the user
- * mode standard format size used for signal and ptrace frames.
+/**
+ * struct fpu_xstate_buffer_config - xstate per-task buffer configuration
+ * @min_size, @max_size:	The size of the kernel buffer. It is variable with the dynamic user
+ *				states. Every task has the minimum buffer by default. It can be
+ *				expanded to the max size.  The two sizes are the same when using the
+ *				standard format.
+ * @user_size:			The size of the userspace buffer. The buffer is always in the
+ *				standard format. It is used for signal and ptrace frames.
  */
-unsigned int fpu_user_xstate_size;
+struct fpu_xstate_buffer_config {
+	unsigned int min_size, max_size;
+	unsigned int user_size;
+};
+
+static struct fpu_xstate_buffer_config buffer_config __read_mostly;
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
@@ -659,7 +697,7 @@ static void do_extra_xstate_size_checks(void)
 		 */
 		paranoid_xstate_size += xfeature_size(i);
 	}
-	XSTATE_WARN_ON(paranoid_xstate_size != fpu_kernel_xstate_size);
+	XSTATE_WARN_ON(paranoid_xstate_size != get_xstate_config(XSTATE_MAX_SIZE));
 }
 
 
@@ -754,21 +792,29 @@ static int __init init_xstate_size(void)
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
+	/* Ensure the minimum size fits in the statically-alocated buffer: */
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
 
@@ -859,7 +905,7 @@ void __init fpu__init_system_xstate(void)
 	 * Update info used for ptrace frames; use standard-format size and no
 	 * supervisor xstates:
 	 */
-	update_regset_xstate_info(fpu_user_xstate_size, xfeatures_mask_user());
+	update_regset_xstate_info(get_xstate_config(XSTATE_USER_SIZE), xfeatures_mask_user());
 
 	fpu__init_prepare_fx_sw_frame();
 	setup_init_fpu_buf();
@@ -869,7 +915,7 @@ void __init fpu__init_system_xstate(void)
 
 	pr_info("x86/fpu: Enabled xstate features 0x%llx, context size is %d bytes, using '%s' format.\n",
 		xfeatures_mask_all,
-		fpu_kernel_xstate_size,
+		get_xstate_config(XSTATE_MAX_SIZE),
 		boot_cpu_has(X86_FEATURE_XSAVES) ? "compacted" : "standard");
 	return;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 145a7ac0c19a..2070ae35ccbc 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -96,6 +96,13 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	return fpu__copy(dst, src);
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
index dd9565d12d81..5c70a4270157 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9271,10 +9271,13 @@ static void kvm_save_current_fpu(struct fpu *fpu)
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
 		copy_fpregs_to_fpstate(fpu);
 }
-- 
2.17.1

