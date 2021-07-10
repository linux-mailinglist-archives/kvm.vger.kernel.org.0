Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3493C3491
	for <lists+kvm@lfdr.de>; Sat, 10 Jul 2021 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhGJNLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jul 2021 09:11:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:46545 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhGJNLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jul 2021 09:11:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="206812198"
X-IronPort-AV: E=Sophos;i="5.84,229,1620716400"; 
   d="scan'208";a="206812198"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2021 06:09:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,229,1620716400"; 
   d="scan'208";a="488742366"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2021 06:09:07 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v7 07/26] x86/fpu/xstate: Convert the struct fpu 'state' field to a pointer
Date:   Sat, 10 Jul 2021 06:02:54 -0700
Message-Id: <20210710130313.5072-8-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210710130313.5072-1-chang.seok.bae@intel.com>
References: <20210710130313.5072-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The XSTATE per-task buffer is embedded into struct fpu. The field 'state'
represents the buffer. When the dynamic user state is in use, the buffer
may be dynamically allocated.

Convert the 'state' field to point either to the embedded buffer or to the
dynamically-allocated buffer. Also, add a new field to represent the
embedded buffer.

The initial task sets it before dealing with soft FPU. Make sure that every
FPU state has a valid pointer value on its creation.

No functional change.

Suggested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v5:
* Tightened up task size calculation (previously, it could over-calculate)
* Adjusted the changelog.

Changes from v4:
* Fixed KVM's user_fpu and guest_fpu to initialize the 'state' field correctly.
* Massaged the changelog.

Changes from v3:
* Added as a new patch to simplify the buffer access. (Borislav Petkov)
---
 arch/x86/include/asm/fpu/internal.h |  2 +-
 arch/x86/include/asm/fpu/types.h    | 29 ++++++++++++++++++++------
 arch/x86/include/asm/trace/fpu.h    |  4 ++--
 arch/x86/kernel/fpu/core.c          | 32 +++++++++++++++--------------
 arch/x86/kernel/fpu/init.c          |  8 +++++---
 arch/x86/kernel/fpu/regset.c        | 24 +++++++++++-----------
 arch/x86/kernel/fpu/signal.c        | 24 +++++++++++-----------
 arch/x86/kernel/fpu/xstate.c        |  8 ++++----
 arch/x86/kernel/process.c           |  2 +-
 arch/x86/kvm/x86.c                  | 22 +++++++++++---------
 arch/x86/math-emu/fpu_aux.c         |  2 +-
 arch/x86/math-emu/fpu_entry.c       |  4 ++--
 arch/x86/math-emu/fpu_system.h      |  2 +-
 13 files changed, 93 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index c7a64e2806a9..d2fc19c0e457 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -484,7 +484,7 @@ static inline void fpregs_restore_userregs(void)
 		 */
 		mask = xfeatures_mask_restore_user() |
 			xfeatures_mask_supervisor();
-		__restore_fpregs_from_fpstate(&fpu->state, mask);
+		__restore_fpregs_from_fpstate(fpu->state, mask);
 
 		fpregs_activate(fpu);
 		fpu->last_cpu = cpu;
diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index f5a38a5f3ae1..c7826708f27f 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -339,13 +339,30 @@ struct fpu {
 	/*
 	 * @state:
 	 *
-	 * In-memory copy of all FPU registers that we save/restore
-	 * over context switches. If the task is using the FPU then
-	 * the registers in the FPU are more recent than this state
-	 * copy. If the task context-switches away then they get
-	 * saved here and represent the FPU state.
+	 * A pointer to indicate the in-memory copy of all FPU registers
+	 * that are saved/restored over context switches.
+	 *
+	 * Initially @state points to @__default_state. When dynamic states
+	 * get used, a memory is allocated for the larger state copy and
+	 * @state is updated to point to it. Then, the state in ->state
+	 * supersedes and invalidates the state in @__default_state.
+	 *
+	 * In general, if the task is using the FPU then the registers in
+	 * the FPU are more recent than the state copy. If the task
+	 * context-switches away then they get saved in ->state and
+	 * represent the FPU state.
+	 */
+	union fpregs_state		*state;
+
+	/*
+	 * @__default_state:
+	 *
+	 * Initial in-memory copy of all FPU registers that saved/restored
+	 * over context switches. When the task is switched to dynamic
+	 * states, this copy is replaced with the new in-memory copy in
+	 * ->state.
 	 */
-	union fpregs_state		state;
+	union fpregs_state		__default_state;
 	/*
 	 * WARNING: 'state' is dynamically-sized.  Do not put
 	 * anything after it here.
diff --git a/arch/x86/include/asm/trace/fpu.h b/arch/x86/include/asm/trace/fpu.h
index 879b77792f94..ef82f4824ce7 100644
--- a/arch/x86/include/asm/trace/fpu.h
+++ b/arch/x86/include/asm/trace/fpu.h
@@ -22,8 +22,8 @@ DECLARE_EVENT_CLASS(x86_fpu,
 		__entry->fpu		= fpu;
 		__entry->load_fpu	= test_thread_flag(TIF_NEED_FPU_LOAD);
 		if (boot_cpu_has(X86_FEATURE_OSXSAVE)) {
-			__entry->xfeatures = fpu->state.xsave.header.xfeatures;
-			__entry->xcomp_bv  = fpu->state.xsave.header.xcomp_bv;
+			__entry->xfeatures = fpu->state->xsave.header.xfeatures;
+			__entry->xcomp_bv  = fpu->state->xsave.header.xcomp_bv;
 		}
 	),
 	TP_printk("x86/fpu: %p load: %d xfeatures: %llx xcomp_bv: %llx",
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index fc01aa6f967e..e12f18439fd4 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -99,19 +99,19 @@ EXPORT_SYMBOL(irq_fpu_usable);
 void save_fpregs_to_fpstate(struct fpu *fpu)
 {
 	if (likely(use_xsave())) {
-		os_xsave(&fpu->state.xsave);
+		os_xsave(&fpu->state->xsave);
 
 		/*
 		 * AVX512 state is tracked here because its use is
 		 * known to slow the max clock speed of the core.
 		 */
-		if (fpu->state.xsave.header.xfeatures & XFEATURE_MASK_AVX512)
+		if (fpu->state->xsave.header.xfeatures & XFEATURE_MASK_AVX512)
 			fpu->avx512_timestamp = jiffies;
 		return;
 	}
 
 	if (likely(use_fxsr())) {
-		fxsave(&fpu->state.fxsave);
+		fxsave(&fpu->state->fxsave);
 		return;
 	}
 
@@ -119,8 +119,8 @@ void save_fpregs_to_fpstate(struct fpu *fpu)
 	 * Legacy FPU register saving, FNSAVE always clears FPU registers,
 	 * so we have to reload them from the memory state.
 	 */
-	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->state.fsave));
-	frstor(&fpu->state.fsave);
+	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->state->fsave));
+	frstor(&fpu->state->fsave);
 }
 EXPORT_SYMBOL(save_fpregs_to_fpstate);
 
@@ -235,7 +235,7 @@ void fpstate_init(struct fpu *fpu)
 	u64 mask;
 
 	if (likely(fpu)) {
-		state = &fpu->state;
+		state = fpu->state;
 		/* The dynamic user states are not prepared yet. */
 		mask = xfeatures_mask_all & ~xfeatures_mask_user_dynamic;
 		size = get_xstate_config(XSTATE_MIN_SIZE);
@@ -274,6 +274,8 @@ int fpu_clone(struct task_struct *dst)
 	if (!cpu_feature_enabled(X86_FEATURE_FPU))
 		return 0;
 
+	dst_fpu->state = &dst_fpu->__default_state;
+
 	/*
 	 * Don't let 'init optimized' areas of the XSAVE area
 	 * leak into the child task:
@@ -281,7 +283,7 @@ int fpu_clone(struct task_struct *dst)
 	 * The child does not inherit the dynamic states. So,
 	 * the xstate buffer has the minimum size.
 	 */
-	memset(&dst_fpu->state.xsave, 0, get_xstate_config(XSTATE_MIN_SIZE));
+	memset(&dst_fpu->state->xsave, 0, get_xstate_config(XSTATE_MIN_SIZE));
 
 	/*
 	 * If the FPU registers are not owned by current just memcpy() the
@@ -290,7 +292,7 @@ int fpu_clone(struct task_struct *dst)
 	 */
 	fpregs_lock();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&dst_fpu->state, &src_fpu->state, get_xstate_config(XSTATE_MIN_SIZE));
+		memcpy(dst_fpu->state, src_fpu->state, get_xstate_config(XSTATE_MIN_SIZE));
 
 	else
 		save_fpregs_to_fpstate(dst_fpu);
@@ -377,7 +379,7 @@ static void fpu_reset_fpstate(void)
 	 * user space as PKRU is eagerly written in switch_to() and
 	 * flush_thread().
 	 */
-	memcpy(&fpu->state, &init_fpstate, init_fpstate_copy_size());
+	memcpy(fpu->state, &init_fpstate, init_fpstate_copy_size());
 	set_thread_flag(TIF_NEED_FPU_LOAD);
 	fpregs_unlock();
 }
@@ -404,7 +406,7 @@ void fpu__clear_user_states(struct fpu *fpu)
 	 */
 	if (xfeatures_mask_supervisor() &&
 	    !fpregs_state_valid(fpu, smp_processor_id())) {
-		os_xrstor(&fpu->state.xsave, xfeatures_mask_supervisor());
+		os_xrstor(&fpu->state->xsave, xfeatures_mask_supervisor());
 	}
 
 	/* Reset user states in registers. */
@@ -486,11 +488,11 @@ int fpu__exception_code(struct fpu *fpu, int trap_nr)
 		 * fully reproduce the context of the exception.
 		 */
 		if (boot_cpu_has(X86_FEATURE_FXSR)) {
-			cwd = fpu->state.fxsave.cwd;
-			swd = fpu->state.fxsave.swd;
+			cwd = fpu->state->fxsave.cwd;
+			swd = fpu->state->fxsave.swd;
 		} else {
-			cwd = (unsigned short)fpu->state.fsave.cwd;
-			swd = (unsigned short)fpu->state.fsave.swd;
+			cwd = (unsigned short)fpu->state->fsave.cwd;
+			swd = (unsigned short)fpu->state->fsave.swd;
 		}
 
 		err = swd & ~cwd;
@@ -504,7 +506,7 @@ int fpu__exception_code(struct fpu *fpu, int trap_nr)
 		unsigned short mxcsr = MXCSR_DEFAULT;
 
 		if (boot_cpu_has(X86_FEATURE_XMM))
-			mxcsr = fpu->state.fxsave.mxcsr;
+			mxcsr = fpu->state->fxsave.mxcsr;
 
 		err = ~(mxcsr >> 7) & mxcsr;
 	}
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 10e2a95916aa..3e4e14ca723b 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -31,10 +31,12 @@ static void fpu__init_cpu_generic(void)
 		cr0 |= X86_CR0_EM;
 	write_cr0(cr0);
 
+	current->thread.fpu.state = &current->thread.fpu.__default_state;
+
 	/* Flush out any pending x87 state: */
 #ifdef CONFIG_MATH_EMULATION
 	if (!boot_cpu_has(X86_FEATURE_FPU))
-		fpstate_init_soft(&current->thread.fpu.state.soft);
+		fpstate_init_soft(&current->thread.fpu.state->soft);
 	else
 #endif
 		asm volatile ("fninit");
@@ -153,7 +155,7 @@ static void __init fpu__init_task_struct_size(void)
 	 * Subtract off the static size of the register state.
 	 * It potentially has a bunch of padding.
 	 */
-	task_size -= sizeof(((struct task_struct *)0)->thread.fpu.state);
+	task_size -= sizeof(((struct task_struct *)0)->thread.fpu.__default_state);
 
 	/*
 	 * Add back the dynamically-calculated register state
@@ -170,7 +172,7 @@ static void __init fpu__init_task_struct_size(void)
 	 * you hit a compile error here, check the structure to
 	 * see if something got added to the end.
 	 */
-	CHECK_MEMBER_AT_END_OF(struct fpu, state);
+	CHECK_MEMBER_AT_END_OF(struct fpu, __default_state);
 	CHECK_MEMBER_AT_END_OF(struct thread_struct, fpu);
 	CHECK_MEMBER_AT_END_OF(struct task_struct, thread);
 
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 8dea3730620e..73d7d7b489fe 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -74,8 +74,8 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 	sync_fpstate(fpu);
 
 	if (!use_xsave()) {
-		return membuf_write(&to, &fpu->state.fxsave,
-				    sizeof(fpu->state.fxsave));
+		return membuf_write(&to, &fpu->state->fxsave,
+				    sizeof(fpu->state->fxsave));
 	}
 
 	copy_xstate_to_uabi_buf(to, target, XSTATE_COPY_FX);
@@ -110,15 +110,15 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	fpu_force_restore(fpu);
 
 	/* Copy the state  */
-	memcpy(&fpu->state.fxsave, &newstate, sizeof(newstate));
+	memcpy(&fpu->state->fxsave, &newstate, sizeof(newstate));
 
 	/* Clear xmm8..15 */
-	BUILD_BUG_ON(sizeof(fpu->state.fxsave.xmm_space) != 16 * 16);
-	memset(&fpu->state.fxsave.xmm_space[8], 0, 8 * 16);
+	BUILD_BUG_ON(sizeof(fpu->state->fxsave.xmm_space) != 16 * 16);
+	memset(&fpu->state->fxsave.xmm_space[8], 0, 8 * 16);
 
 	/* Mark FP and SSE as in use when XSAVE is enabled */
 	if (use_xsave())
-		fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
+		fpu->state->xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
 
 	return 0;
 }
@@ -283,7 +283,7 @@ static void __convert_from_fxsr(struct user_i387_ia32_struct *env,
 void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
-	__convert_from_fxsr(env, tsk, &tsk->thread.fpu.state.fxsave);
+	__convert_from_fxsr(env, tsk, &tsk->thread.fpu.state->fxsave);
 }
 
 void convert_to_fxsr(struct fxregs_state *fxsave,
@@ -326,7 +326,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 		return fpregs_soft_get(target, regset, to);
 
 	if (!cpu_feature_enabled(X86_FEATURE_FXSR)) {
-		return membuf_write(&to, &fpu->state.fsave,
+		return membuf_write(&to, &fpu->state->fsave,
 				    sizeof(struct fregs_state));
 	}
 
@@ -337,7 +337,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 		copy_xstate_to_uabi_buf(mb, target, XSTATE_COPY_FP);
 		fx = &fxsave;
 	} else {
-		fx = &fpu->state.fxsave;
+		fx = &fpu->state->fxsave;
 	}
 
 	__convert_from_fxsr(&env, target, fx);
@@ -366,16 +366,16 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	fpu_force_restore(fpu);
 
 	if (cpu_feature_enabled(X86_FEATURE_FXSR))
-		convert_to_fxsr(&fpu->state.fxsave, &env);
+		convert_to_fxsr(&fpu->state->fxsave, &env);
 	else
-		memcpy(&fpu->state.fsave, &env, sizeof(env));
+		memcpy(&fpu->state->fsave, &env, sizeof(env));
 
 	/*
 	 * Update the header bit in the xsave header, indicating the
 	 * presence of FP.
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_XSAVE))
-		fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_FP;
+		fpu->state->xsave.header.xfeatures |= XFEATURE_MASK_FP;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 63f000988fa6..2f35aada2007 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -67,13 +67,13 @@ static inline int check_xstate_in_sigframe(struct fxregs_state __user *fxbuf,
 static inline int save_fsave_header(struct task_struct *tsk, void __user *buf)
 {
 	if (use_fxsr()) {
-		struct xregs_state *xsave = &tsk->thread.fpu.state.xsave;
+		struct xregs_state *xsave = &tsk->thread.fpu.state->xsave;
 		struct user_i387_ia32_struct env;
 		struct _fpstate_32 __user *fp = buf;
 
 		fpregs_lock();
 		if (!test_thread_flag(TIF_NEED_FPU_LOAD))
-			fxsave(&tsk->thread.fpu.state.fxsave);
+			fxsave(&tsk->thread.fpu.state->fxsave);
 		fpregs_unlock();
 
 		convert_from_fxsr(&env, tsk);
@@ -294,7 +294,7 @@ static int restore_fpregs_from_user(void __user *buf, u64 xrestore,
 	 * been restored from a user buffer directly.
 	 */
 	if (test_thread_flag(TIF_NEED_FPU_LOAD) && xfeatures_mask_supervisor())
-		os_xrstor(&fpu->state.xsave, xfeatures_mask_supervisor());
+		os_xrstor(&fpu->state->xsave, xfeatures_mask_supervisor());
 
 	fpregs_mark_activate();
 	fpregs_unlock();
@@ -365,7 +365,7 @@ static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 		 * the right place in memory. It's ia32 mode. Shrug.
 		 */
 		if (xfeatures_mask_supervisor())
-			os_xsave(&fpu->state.xsave);
+			os_xsave(&fpu->state->xsave);
 		set_thread_flag(TIF_NEED_FPU_LOAD);
 	}
 	__fpu_invalidate_fpregs_state(fpu);
@@ -377,21 +377,21 @@ static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 		if (ret)
 			return ret;
 	} else {
-		if (__copy_from_user(&fpu->state.fxsave, buf_fx,
-				     sizeof(fpu->state.fxsave)))
+		if (__copy_from_user(&fpu->state->fxsave, buf_fx,
+				     sizeof(fpu->state->fxsave)))
 			return -EFAULT;
 
 		/* Reject invalid MXCSR values. */
-		if (fpu->state.fxsave.mxcsr & ~mxcsr_feature_mask)
+		if (fpu->state->fxsave.mxcsr & ~mxcsr_feature_mask)
 			return -EINVAL;
 
 		/* Enforce XFEATURE_MASK_FPSSE when XSAVE is enabled */
 		if (use_xsave())
-			fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
+			fpu->state->xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
 	}
 
 	/* Fold the legacy FP storage */
-	convert_to_fxsr(&fpu->state.fxsave, &env);
+	convert_to_fxsr(&fpu->state->fxsave, &env);
 
 	fpregs_lock();
 	if (use_xsave()) {
@@ -406,10 +406,10 @@ static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 		 */
 		u64 mask = user_xfeatures | xfeatures_mask_supervisor();
 
-		fpu->state.xsave.header.xfeatures &= mask;
-		ret = os_xrstor_safe(&fpu->state.xsave, xfeatures_mask_all);
+		fpu->state->xsave.header.xfeatures &= mask;
+		ret = os_xrstor_safe(&fpu->state->xsave, xfeatures_mask_all);
 	} else {
-		ret = fxrstor_safe(&fpu->state.fxsave);
+		ret = fxrstor_safe(&fpu->state->fxsave);
 	}
 
 	if (likely(!ret))
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index d1c256dbe8c5..b86aa7eb421b 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -925,7 +925,7 @@ static void *__raw_xsave_addr(struct fpu *fpu, int xfeature_nr)
 	}
 
 	if (fpu)
-		xsave = &fpu->state.xsave;
+		xsave = &fpu->state->xsave;
 	else
 		xsave = &init_fpstate.xsave;
 
@@ -968,7 +968,7 @@ void *get_xsave_addr(struct fpu *fpu, int xfeature_nr)
 		  "get of unsupported state");
 
 	if (fpu)
-		xsave = &fpu->state.xsave;
+		xsave = &fpu->state->xsave;
 	else
 		xsave = &init_fpstate.xsave;
 
@@ -1060,7 +1060,7 @@ void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 			     enum xstate_copy_mode copy_mode)
 {
 	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
-	struct xregs_state *xsave = &tsk->thread.fpu.state.xsave;
+	struct xregs_state *xsave = &tsk->thread.fpu.state->xsave;
 	struct xregs_state *xinit = &init_fpstate.xsave;
 	struct xstate_header header;
 	unsigned int zerofrom;
@@ -1177,7 +1177,7 @@ static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
 static int copy_uabi_to_xstate(struct fpu *fpu, const void *kbuf,
 			       const void __user *ubuf)
 {
-	struct xregs_state *xsave = &fpu->state.xsave;
+	struct xregs_state *xsave = &fpu->state->xsave;
 	unsigned int offset, size;
 	struct xstate_header hdr;
 	u64 mask;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 9ad39e807fcf..534b9fb7e7ee 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -92,7 +92,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 
 void arch_thread_struct_whitelist(unsigned long *offset, unsigned long *size)
 {
-	*offset = offsetof(struct thread_struct, fpu.state);
+	*offset = offsetof(struct thread_struct, fpu.__default_state);
 	/* The buffer embedded in thread_struct has the minimum size. */
 	*size = get_xstate_config(XSTATE_MIN_SIZE);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 610a8c71e40e..c7c273899eb0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4685,7 +4685,7 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 
 static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 {
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
+	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state->xsave;
 	u64 xstate_bv = xsave->header.xfeatures;
 	u64 valid;
 
@@ -4728,7 +4728,7 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 
 static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 {
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
+	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state->xsave;
 	u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
 	u64 valid;
 
@@ -4781,7 +4781,7 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 		fill_xsave((u8 *) guest_xsave->region, vcpu);
 	} else {
 		memcpy(guest_xsave->region,
-			&vcpu->arch.guest_fpu->state.fxsave,
+			&vcpu->arch.guest_fpu->state->fxsave,
 			sizeof(struct fxregs_state));
 		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] =
 			XFEATURE_MASK_FPSSE;
@@ -4815,7 +4815,7 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 		if (xstate_bv & ~XFEATURE_MASK_FPSSE ||
 			mxcsr & ~mxcsr_feature_mask)
 			return -EINVAL;
-		memcpy(&vcpu->arch.guest_fpu->state.fxsave,
+		memcpy(&vcpu->arch.guest_fpu->state->fxsave,
 			guest_xsave->region, sizeof(struct fxregs_state));
 	}
 	return 0;
@@ -9889,7 +9889,7 @@ static void kvm_save_current_fpu(struct fpu *fpu)
 	 * always has the minimum size.
 	 */
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&fpu->state, &current->thread.fpu.state,
+		memcpy(fpu->state, current->thread.fpu.state,
 		       get_xstate_config(XSTATE_MIN_SIZE));
 	else
 		save_fpregs_to_fpstate(fpu);
@@ -9908,7 +9908,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	if (vcpu->arch.guest_fpu)
 		/* PKRU is separately restored in kvm_x86_ops.run. */
-		__restore_fpregs_from_fpstate(&vcpu->arch.guest_fpu->state,
+		__restore_fpregs_from_fpstate(vcpu->arch.guest_fpu->state,
 					~XFEATURE_MASK_PKRU);
 
 	fpregs_mark_activate();
@@ -9929,7 +9929,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu)
 		kvm_save_current_fpu(vcpu->arch.guest_fpu);
 
-	restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state);
+	restore_fpregs_from_fpstate(vcpu->arch.user_fpu->state);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
@@ -10518,7 +10518,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
+	fxsave = &vcpu->arch.guest_fpu->state->fxsave;
 	memcpy(fpu->fpr, fxsave->st_space, 128);
 	fpu->fcw = fxsave->cwd;
 	fpu->fsw = fxsave->swd;
@@ -10541,7 +10541,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
+	fxsave = &vcpu->arch.guest_fpu->state->fxsave;
 
 	memcpy(fxsave->st_space, fpu->fpr, 128);
 	fxsave->cwd = fpu->fcw;
@@ -10602,7 +10602,7 @@ static void fx_init(struct kvm_vcpu *vcpu)
 
 	fpstate_init(vcpu->arch.guest_fpu);
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
+		vcpu->arch.guest_fpu->state->xsave.header.xcomp_bv =
 			host_xcr0 | XSTATE_COMPACTION_ENABLED;
 
 	/*
@@ -10682,6 +10682,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		pr_err("kvm: failed to allocate userspace's fpu\n");
 		goto free_emulate_ctxt;
 	}
+	vcpu->arch.user_fpu->state = &vcpu->arch.user_fpu->__default_state;
 
 	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
 						 GFP_KERNEL_ACCOUNT);
@@ -10689,6 +10690,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		pr_err("kvm: failed to allocate vcpu's fpu\n");
 		goto free_user_fpu;
 	}
+	vcpu->arch.guest_fpu->state = &vcpu->arch.guest_fpu->__default_state;
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
diff --git a/arch/x86/math-emu/fpu_aux.c b/arch/x86/math-emu/fpu_aux.c
index 034748459482..51432a73024c 100644
--- a/arch/x86/math-emu/fpu_aux.c
+++ b/arch/x86/math-emu/fpu_aux.c
@@ -53,7 +53,7 @@ void fpstate_init_soft(struct swregs_state *soft)
 
 void finit(void)
 {
-	fpstate_init_soft(&current->thread.fpu.state.soft);
+	fpstate_init_soft(&current->thread.fpu.state->soft);
 }
 
 /*
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index 8679a9d6c47f..6ba56632170e 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -640,7 +640,7 @@ int fpregs_soft_set(struct task_struct *target,
 		    unsigned int pos, unsigned int count,
 		    const void *kbuf, const void __user *ubuf)
 {
-	struct swregs_state *s387 = &target->thread.fpu.state.soft;
+	struct swregs_state *s387 = &target->thread.fpu.state->soft;
 	void *space = s387->st_space;
 	int ret;
 	int offset, other, i, tags, regnr, tag, newtop;
@@ -691,7 +691,7 @@ int fpregs_soft_get(struct task_struct *target,
 		    const struct user_regset *regset,
 		    struct membuf to)
 {
-	struct swregs_state *s387 = &target->thread.fpu.state.soft;
+	struct swregs_state *s387 = &target->thread.fpu.state->soft;
 	const void *space = s387->st_space;
 	int offset = (S387->ftop & 7) * 10, other = 80 - offset;
 
diff --git a/arch/x86/math-emu/fpu_system.h b/arch/x86/math-emu/fpu_system.h
index 9b41391867dc..a6291ddfdda6 100644
--- a/arch/x86/math-emu/fpu_system.h
+++ b/arch/x86/math-emu/fpu_system.h
@@ -73,7 +73,7 @@ static inline bool seg_writable(struct desc_struct *d)
 	return (d->type & SEG_TYPE_EXECUTE_MASK) == SEG_TYPE_WRITABLE;
 }
 
-#define I387			(&current->thread.fpu.state)
+#define I387			(current->thread.fpu.state)
 #define FPU_info		(I387->soft.info)
 
 #define FPU_CS			(*(unsigned short *) &(FPU_info->regs->cs))
-- 
2.17.1

