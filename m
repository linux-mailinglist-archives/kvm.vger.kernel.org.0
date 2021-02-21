Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA7E320CF3
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 20:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhBUTDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 14:03:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:2045 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230469AbhBUTCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 14:02:44 -0500
IronPort-SDR: aGM8miW3VbQUOu7/u5cH/QUaYMNpEMoSFSMQWOa/XaB8LHBmPtnxV2tGPpwe8hkxH7uGwSb8L1
 SA675bW3KHHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="184382827"
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="184382827"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2021 11:01:28 -0800
IronPort-SDR: IqATZu8D38l3AJo11y1gcfDB4EDG0MF75OYMMTQZNml+9mbwGNmT/FahRKoVTXzXgo2hFJ7fju
 ijO/QWC+2K9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="429792103"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Feb 2021 11:01:27 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v4 08/22] x86/fpu/xstate: Convert the struct fpu 'state' field to a pointer
Date:   Sun, 21 Feb 2021 10:56:23 -0800
Message-Id: <20210221185637.19281-9-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210221185637.19281-1-chang.seok.bae@intel.com>
References: <20210221185637.19281-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The xstate per-task buffer is embedded into struct fpu. And the field
'state' represents the buffer. When the dynamic user states in use, the
buffer may be dynamically allocated.

Convert the 'state' field to point either the embedded buffer or the
dynamically-allocated buffer. Add a new field to represent the embedded
buffer.

Every child process will set the pointer on its creation. And the initial
task sets it before dealing with soft FPU.

No functional change.

Suggested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v3:
* Added as a new patch to simplify the buffer access. (Borislav Petkov)
---
 arch/x86/include/asm/fpu/internal.h |  6 +++---
 arch/x86/include/asm/fpu/types.h    | 27 +++++++++++++++++++++------
 arch/x86/include/asm/trace/fpu.h    |  4 ++--
 arch/x86/kernel/fpu/core.c          | 26 ++++++++++++++------------
 arch/x86/kernel/fpu/init.c          |  6 ++++--
 arch/x86/kernel/fpu/regset.c        | 22 +++++++++++-----------
 arch/x86/kernel/fpu/signal.c        | 22 +++++++++++-----------
 arch/x86/kernel/fpu/xstate.c        | 18 +++++++++---------
 arch/x86/kernel/process.c           |  2 +-
 arch/x86/kvm/x86.c                  | 18 +++++++++---------
 arch/x86/math-emu/fpu_aux.c         |  2 +-
 arch/x86/math-emu/fpu_entry.c       |  4 ++--
 arch/x86/math-emu/fpu_system.h      |  2 +-
 13 files changed, 89 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index b34d0d29e4b8..46cb51ef4d17 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -199,9 +199,9 @@ static inline int copy_user_to_fregs(struct fregs_state __user *fx)
 static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 {
 	if (IS_ENABLED(CONFIG_X86_32))
-		asm volatile( "fxsave %[fx]" : [fx] "=m" (fpu->state.fxsave));
+		asm volatile( "fxsave %[fx]" : [fx] "=m" (fpu->state->fxsave));
 	else
-		asm volatile("fxsaveq %[fx]" : [fx] "=m" (fpu->state.fxsave));
+		asm volatile("fxsaveq %[fx]" : [fx] "=m" (fpu->state->fxsave));
 }
 
 /* These macros all use (%edi)/(%rdi) as the single memory argument. */
@@ -427,7 +427,7 @@ static inline void __copy_kernel_to_fpregs(union fpregs_state *fpstate, u64 mask
 
 static inline void copy_kernel_to_fpregs(struct fpu *fpu)
 {
-	union fpregs_state *fpstate = &fpu->state;
+	union fpregs_state *fpstate = fpu->state;
 
 	/*
 	 * AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception is
diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index f5a38a5f3ae1..dcd28a545377 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -339,13 +339,28 @@ struct fpu {
 	/*
 	 * @state:
 	 *
-	 * In-memory copy of all FPU registers that we save/restore
-	 * over context switches. If the task is using the FPU then
-	 * the registers in the FPU are more recent than this state
-	 * copy. If the task context-switches away then they get
-	 * saved here and represent the FPU state.
+	 * A pointer to indicate the in-memory copy of all FPU registers that are
+	 * saved/restored over context switches.
+	 *
+	 * Initially @state points to @__default_state. When dynamic states get
+	 * used, a memory is allocated for the larger state copy and @state is
+	 * updated to point to it. Then, the state in ->state supersedes and
+	 * invalidates the state in @__default_state.
+	 *
+	 * In general, if the task is using the FPU then the registers in the FPU
+	 * are more recent than the state copy. If the task context-switches away
+	 * then they get saved in ->state and represent the FPU state.
+	 */
+	union fpregs_state		*state;
+
+	/*
+	 * @__default_state:
+	 *
+	 * Initial in-memory copy of all FPU registers that saved/restored
+	 * over context switches. When the task is switched to dynamic states,
+	 * this copy is replaced with the new in-memory copy in ->state.
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
index 043fdba8431c..60a581aa0be8 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -95,13 +95,13 @@ EXPORT_SYMBOL(irq_fpu_usable);
 int copy_fpregs_to_fpstate(struct fpu *fpu)
 {
 	if (likely(use_xsave())) {
-		copy_xregs_to_kernel(&fpu->state.xsave);
+		copy_xregs_to_kernel(&fpu->state->xsave);
 
 		/*
 		 * AVX512 state is tracked here because its use is
 		 * known to slow the max clock speed of the core.
 		 */
-		if (fpu->state.xsave.header.xfeatures & XFEATURE_MASK_AVX512)
+		if (fpu->state->xsave.header.xfeatures & XFEATURE_MASK_AVX512)
 			fpu->avx512_timestamp = jiffies;
 		return 1;
 	}
@@ -115,7 +115,7 @@ int copy_fpregs_to_fpstate(struct fpu *fpu)
 	 * Legacy FPU register saving, FNSAVE always clears FPU registers,
 	 * so we have to mark them inactive:
 	 */
-	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->state.fsave));
+	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->state->fsave));
 
 	return 0;
 }
@@ -202,7 +202,7 @@ void fpstate_init(struct fpu *fpu)
 	u64 mask;
 
 	if (fpu) {
-		state = &fpu->state;
+		state = fpu->state;
 		/* The dynamic user states are not prepared yet. */
 		mask = xfeatures_mask_all & ~xfeatures_mask_user_dynamic;
 		size = get_xstate_config(XSTATE_MIN_SIZE);
@@ -241,6 +241,8 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 
 	WARN_ON_FPU(src_fpu != &current->thread.fpu);
 
+	dst_fpu->state = &dst_fpu->__default_state;
+
 	/*
 	 * Don't let 'init optimized' areas of the XSAVE area
 	 * leak into the child task:
@@ -248,7 +250,7 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 	 * The child does not inherit the dynamic states. So,
 	 * the xstate buffer has the minimum size.
 	 */
-	memset(&dst_fpu->state.xsave, 0, get_xstate_config(XSTATE_MIN_SIZE));
+	memset(&dst_fpu->state->xsave, 0, get_xstate_config(XSTATE_MIN_SIZE));
 
 	/*
 	 * If the FPU registers are not current just memcpy() the state.
@@ -260,7 +262,7 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 	 */
 	fpregs_lock();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&dst_fpu->state, &src_fpu->state, get_xstate_config(XSTATE_MIN_SIZE));
+		memcpy(dst_fpu->state, src_fpu->state, get_xstate_config(XSTATE_MIN_SIZE));
 
 	else if (!copy_fpregs_to_fpstate(dst_fpu))
 		copy_kernel_to_fpregs(dst_fpu);
@@ -396,7 +398,7 @@ static void fpu__clear(struct fpu *fpu, bool user_only)
 	if (user_only) {
 		if (!fpregs_state_valid(fpu, smp_processor_id()) &&
 		    xfeatures_mask_supervisor())
-			copy_kernel_to_xregs(&fpu->state.xsave,
+			copy_kernel_to_xregs(&fpu->state->xsave,
 					     xfeatures_mask_supervisor());
 		copy_init_fpstate_to_fpregs(xfeatures_mask_user());
 	} else {
@@ -478,11 +480,11 @@ int fpu__exception_code(struct fpu *fpu, int trap_nr)
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
@@ -496,7 +498,7 @@ int fpu__exception_code(struct fpu *fpu, int trap_nr)
 		unsigned short mxcsr = MXCSR_DEFAULT;
 
 		if (boot_cpu_has(X86_FEATURE_XMM))
-			mxcsr = fpu->state.fxsave.mxcsr;
+			mxcsr = fpu->state->fxsave.mxcsr;
 
 		err = ~(mxcsr >> 7) & mxcsr;
 	}
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index f63765b7a83c..f2fcdcc979e7 100644
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
@@ -170,7 +172,7 @@ static void __init fpu__init_task_struct_size(void)
 	 * you hit a compile error here, check the structure to
 	 * see if something got added to the end.
 	 */
-	CHECK_MEMBER_AT_END_OF(struct fpu, state);
+	CHECK_MEMBER_AT_END_OF(struct fpu, __default_state);
 	CHECK_MEMBER_AT_END_OF(struct thread_struct, fpu);
 	CHECK_MEMBER_AT_END_OF(struct task_struct, thread);
 
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 6a025fa26a7e..ee27df4caed6 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -37,7 +37,7 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 	fpu__prepare_read(fpu);
 	fpstate_sanitize_xstate(fpu);
 
-	return membuf_write(&to, &fpu->state.fxsave, sizeof(struct fxregs_state));
+	return membuf_write(&to, &fpu->state->fxsave, sizeof(struct fxregs_state));
 }
 
 int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
@@ -54,19 +54,19 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	fpstate_sanitize_xstate(fpu);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &fpu->state.fxsave, 0, -1);
+				 &fpu->state->fxsave, 0, -1);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
 	 */
-	fpu->state.fxsave.mxcsr &= mxcsr_feature_mask;
+	fpu->state->fxsave.mxcsr &= mxcsr_feature_mask;
 
 	/*
 	 * update the header bits in the xsave header, indicating the
 	 * presence of FP and SSE state.
 	 */
 	if (boot_cpu_has(X86_FEATURE_XSAVE))
-		fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
+		fpu->state->xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
 
 	return ret;
 }
@@ -80,7 +80,7 @@ int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!boot_cpu_has(X86_FEATURE_XSAVE))
 		return -ENODEV;
 
-	xsave = &fpu->state.xsave;
+	xsave = &fpu->state->xsave;
 
 	fpu__prepare_read(fpu);
 
@@ -120,7 +120,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	if ((pos != 0) || (count < get_xstate_config(XSTATE_USER_SIZE)))
 		return -EFAULT;
 
-	xsave = &fpu->state.xsave;
+	xsave = &fpu->state->xsave;
 
 	fpu__prepare_write(fpu);
 
@@ -224,7 +224,7 @@ static inline u32 twd_fxsr_to_i387(struct fxregs_state *fxsave)
 void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
-	struct fxregs_state *fxsave = &tsk->thread.fpu.state.fxsave;
+	struct fxregs_state *fxsave = &tsk->thread.fpu.state->fxsave;
 	struct _fpreg *to = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *from = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -297,7 +297,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 		return fpregs_soft_get(target, regset, to);
 
 	if (!boot_cpu_has(X86_FEATURE_FXSR)) {
-		return membuf_write(&to, &fpu->state.fsave,
+		return membuf_write(&to, &fpu->state->fsave,
 				    sizeof(struct fregs_state));
 	}
 
@@ -328,7 +328,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 
 	if (!boot_cpu_has(X86_FEATURE_FXSR))
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-					  &fpu->state.fsave, 0,
+					  &fpu->state->fsave, 0,
 					  -1);
 
 	if (pos > 0 || count < sizeof(env))
@@ -336,14 +336,14 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &env, 0, -1);
 	if (!ret)
-		convert_to_fxsr(&target->thread.fpu.state.fxsave, &env);
+		convert_to_fxsr(&target->thread.fpu.state->fxsave, &env);
 
 	/*
 	 * update the header bit in the xsave header, indicating the
 	 * presence of FP.
 	 */
 	if (boot_cpu_has(X86_FEATURE_XSAVE))
-		fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_FP;
+		fpu->state->xsave.header.xfeatures |= XFEATURE_MASK_FP;
 	return ret;
 }
 
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 3a2d8665b9a3..9719241da034 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -58,7 +58,7 @@ static inline int check_for_xstate(struct fxregs_state __user *buf,
 static inline int save_fsave_header(struct task_struct *tsk, void __user *buf)
 {
 	if (use_fxsr()) {
-		struct xregs_state *xsave = &tsk->thread.fpu.state.xsave;
+		struct xregs_state *xsave = &tsk->thread.fpu.state->xsave;
 		struct user_i387_ia32_struct env;
 		struct _fpstate_32 __user *fp = buf;
 
@@ -216,7 +216,7 @@ sanitize_restored_user_xstate(struct fpu *fpu,
 			      struct user_i387_ia32_struct *ia32_env,
 			      u64 user_xfeatures, int fx_only)
 {
-	struct xregs_state *xsave = &fpu->state.xsave;
+	struct xregs_state *xsave = &fpu->state->xsave;
 	struct xstate_header *header = &xsave->header;
 
 	if (use_xsave()) {
@@ -253,7 +253,7 @@ sanitize_restored_user_xstate(struct fpu *fpu,
 		xsave->i387.mxcsr &= mxcsr_feature_mask;
 
 		if (ia32_env)
-			convert_to_fxsr(&fpu->state.fxsave, ia32_env);
+			convert_to_fxsr(&fpu->state->fxsave, ia32_env);
 	}
 }
 
@@ -366,7 +366,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 			 */
 			if (test_thread_flag(TIF_NEED_FPU_LOAD) &&
 			    xfeatures_mask_supervisor())
-				copy_kernel_to_xregs(&fpu->state.xsave,
+				copy_kernel_to_xregs(&fpu->state->xsave,
 						     xfeatures_mask_supervisor());
 			fpregs_mark_activate();
 			fpregs_unlock();
@@ -411,10 +411,10 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		if (using_compacted_format()) {
 			ret = copy_user_to_xstate(fpu, buf_fx);
 		} else {
-			ret = __copy_from_user(&fpu->state.xsave, buf_fx, state_size);
+			ret = __copy_from_user(&fpu->state->xsave, buf_fx, state_size);
 
 			if (!ret && state_size > offsetof(struct xregs_state, header))
-				ret = validate_user_xstate_header(&fpu->state.xsave.header);
+				ret = validate_user_xstate_header(&fpu->state->xsave.header);
 		}
 		if (ret)
 			goto err_out;
@@ -429,11 +429,11 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		 * Restore previously saved supervisor xstates along with
 		 * copied-in user xstates.
 		 */
-		ret = copy_kernel_to_xregs_err(&fpu->state.xsave,
+		ret = copy_kernel_to_xregs_err(&fpu->state->xsave,
 					       user_xfeatures | xfeatures_mask_supervisor());
 
 	} else if (use_fxsr()) {
-		ret = __copy_from_user(&fpu->state.fxsave, buf_fx, state_size);
+		ret = __copy_from_user(&fpu->state->fxsave, buf_fx, state_size);
 		if (ret) {
 			ret = -EFAULT;
 			goto err_out;
@@ -449,14 +449,14 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 			copy_kernel_to_xregs(&init_fpstate.xsave, init_bv);
 		}
 
-		ret = copy_kernel_to_fxregs_err(&fpu->state.fxsave);
+		ret = copy_kernel_to_fxregs_err(&fpu->state->fxsave);
 	} else {
-		ret = __copy_from_user(&fpu->state.fsave, buf_fx, state_size);
+		ret = __copy_from_user(&fpu->state->fsave, buf_fx, state_size);
 		if (ret)
 			goto err_out;
 
 		fpregs_lock();
-		ret = copy_kernel_to_fregs_err(&fpu->state.fsave);
+		ret = copy_kernel_to_fregs_err(&fpu->state->fsave);
 	}
 	if (!ret)
 		fpregs_mark_activate();
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index b7686f107f3a..8c067a7a0eec 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -185,14 +185,14 @@ static bool xfeature_is_supervisor(int xfeature_nr)
  */
 void fpstate_sanitize_xstate(struct fpu *fpu)
 {
-	struct fxregs_state *fx = &fpu->state.fxsave;
+	struct fxregs_state *fx = &fpu->state->fxsave;
 	int feature_bit;
 	u64 xfeatures;
 
 	if (!use_xsaveopt())
 		return;
 
-	xfeatures = fpu->state.xsave.header.xfeatures;
+	xfeatures = fpu->state->xsave.header.xfeatures;
 
 	/*
 	 * None of the feature bits are in init state. So nothing else
@@ -976,7 +976,7 @@ static void *__raw_xsave_addr(struct fpu *fpu, int xfeature_nr)
 	}
 
 	if (fpu)
-		xsave = &fpu->state.xsave;
+		xsave = &fpu->state->xsave;
 	else
 		xsave = &init_fpstate.xsave;
 
@@ -1019,7 +1019,7 @@ void *get_xsave_addr(struct fpu *fpu, int xfeature_nr)
 		  "get of unsupported state");
 
 	if (fpu)
-		xsave = &fpu->state.xsave;
+		xsave = &fpu->state->xsave;
 	else
 		xsave = &init_fpstate.xsave;
 
@@ -1167,7 +1167,7 @@ void copy_xstate_to_kernel(struct membuf to, struct fpu *fpu)
 	unsigned last = 0;
 	int i;
 
-	xsave = &fpu->state.xsave;
+	xsave = &fpu->state->xsave;
 
 	/*
 	 * The destination is a ptrace buffer; we put in only user xstates:
@@ -1232,7 +1232,7 @@ int copy_kernel_to_xstate(struct fpu *fpu, const void *kbuf)
 	if (validate_user_xstate_header(&hdr))
 		return -EINVAL;
 
-	xsave = &fpu->state.xsave;
+	xsave = &fpu->state->xsave;
 
 	for (i = 0; i < XFEATURE_MAX; i++) {
 		u64 mask = ((u64)1 << i);
@@ -1289,7 +1289,7 @@ int copy_user_to_xstate(struct fpu *fpu, const void __user *ubuf)
 	if (validate_user_xstate_header(&hdr))
 		return -EINVAL;
 
-	xsave = &fpu->state.xsave;
+	xsave = &fpu->state->xsave;
 
 	for (i = 0; i < XFEATURE_MAX; i++) {
 		u64 mask = ((u64)1 << i);
@@ -1348,7 +1348,7 @@ void copy_supervisor_to_kernel(struct fpu *fpu)
 	max_bit = __fls(xfeatures_mask_supervisor());
 	min_bit = __ffs(xfeatures_mask_supervisor());
 
-	xstate = &fpu->state.xsave;
+	xstate = &fpu->state->xsave;
 	lmask = xfeatures_mask_supervisor();
 	hmask = xfeatures_mask_supervisor() >> 32;
 	XSTATE_OP(XSAVES, xstate, lmask, hmask, err);
@@ -1535,7 +1535,7 @@ void update_pasid(void)
 		 * update the PASID state in the memory buffer here. The
 		 * PASID MSR will be loaded when returning to user mode.
 		 */
-		xsave = &fpu->state.xsave;
+		xsave = &fpu->state->xsave;
 		xsave->header.xfeatures |= XFEATURE_MASK_PASID;
 		ppasid_state = get_xsave_addr(fpu, XFEATURE_PASID);
 		/*
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2070ae35ccbc..c41116543a82 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -98,7 +98,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 
 void arch_thread_struct_whitelist(unsigned long *offset, unsigned long *size)
 {
-	*offset = offsetof(struct thread_struct, fpu.state);
+	*offset = offsetof(struct thread_struct, fpu.__default_state);
 	/* The buffer embedded in thread_struct has the minimum size. */
 	*size = get_xstate_config(XSTATE_MIN_SIZE);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5c70a4270157..c10122547ecd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4439,7 +4439,7 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 
 static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 {
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
+	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state->xsave;
 	u64 xstate_bv = xsave->header.xfeatures;
 	u64 valid;
 
@@ -4481,7 +4481,7 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 
 static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 {
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
+	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state->xsave;
 	u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
 	u64 valid;
 
@@ -4532,7 +4532,7 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 		fill_xsave((u8 *) guest_xsave->region, vcpu);
 	} else {
 		memcpy(guest_xsave->region,
-			&vcpu->arch.guest_fpu->state.fxsave,
+			&vcpu->arch.guest_fpu->state->fxsave,
 			sizeof(struct fxregs_state));
 		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] =
 			XFEATURE_MASK_FPSSE;
@@ -4566,7 +4566,7 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 		if (xstate_bv & ~XFEATURE_MASK_FPSSE ||
 			mxcsr & ~mxcsr_feature_mask)
 			return -EINVAL;
-		memcpy(&vcpu->arch.guest_fpu->state.fxsave,
+		memcpy(&vcpu->arch.guest_fpu->state->fxsave,
 			guest_xsave->region, sizeof(struct fxregs_state));
 	}
 	return 0;
@@ -9276,7 +9276,7 @@ static void kvm_save_current_fpu(struct fpu *fpu)
 	 * always has the minimum size.
 	 */
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&fpu->state, &current->thread.fpu.state,
+		memcpy(fpu->state, current->thread.fpu.state,
 		       get_xstate_config(XSTATE_MIN_SIZE));
 	else
 		copy_fpregs_to_fpstate(fpu);
@@ -9295,7 +9295,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	if (vcpu->arch.guest_fpu)
 		/* PKRU is separately restored in kvm_x86_ops.run. */
-		__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
+		__copy_kernel_to_fpregs(vcpu->arch.guest_fpu->state,
 					~XFEATURE_MASK_PKRU);
 
 	fpregs_mark_activate();
@@ -9832,7 +9832,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
+	fxsave = &vcpu->arch.guest_fpu->state->fxsave;
 	memcpy(fpu->fpr, fxsave->st_space, 128);
 	fpu->fcw = fxsave->cwd;
 	fpu->fsw = fxsave->swd;
@@ -9855,7 +9855,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
+	fxsave = &vcpu->arch.guest_fpu->state->fxsave;
 
 	memcpy(fxsave->st_space, fpu->fpr, 128);
 	fxsave->cwd = fpu->fcw;
@@ -9916,7 +9916,7 @@ static void fx_init(struct kvm_vcpu *vcpu)
 
 	fpstate_init(vcpu->arch.guest_fpu);
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
+		vcpu->arch.guest_fpu->state->xsave.header.xcomp_bv =
 			host_xcr0 | XSTATE_COMPACTION_ENABLED;
 
 	/*
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

