Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32C542AE94
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 23:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhJLVR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 17:17:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58420 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbhJLVR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 17:17:27 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634073324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qGhYUU4PHqVJauASorElxOKLAG5bEMxQ+CpOTI3+RsI=;
        b=fKNggHZvcGPtxJAtQCJ3dnoyzVtmBN4tahLERFruoxNxJqFesIEai5rSFGMehdRfUTZXJe
        +Fql1tijZKw84/0EbNtqfytwBIt3vqrQ4aPnM9U0zXqq12LDjMOG/uJ6/wmZRtSU3QaTCu
        S81pWa/oiXzOnU0lI0THFU98kfl6HJ0tTSR9VcfCIwACSyCIdaYS7RZoDjyIHXRG92TNaI
        HMU29wND8i1dkUBXLKodvxuk9c9blCHxypi2uuku2Z9aLsLt19syrOOkzX+8VfIYsqH9HB
        hvItk5Rf1vf4CsKwLYU28QU+GVS0aGO4XpEuNqifCSTtUT5dj7oHmS3Lap8idA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634073324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qGhYUU4PHqVJauASorElxOKLAG5bEMxQ+CpOTI3+RsI=;
        b=LS1QIsnFHEksYaCDDOZ2hvkYxuf+hk5dtjmY+d/Co7upain9ujGe/P/wWhKT2cRdy5a9R5
        esPpTsRV6cUxQ1DQ==
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 00/31] x86/fpu: Preparatory cleanups for AMX support
 (part 1)
In-Reply-To: <20211011215813.558681373@linutronix.de>
References: <20211011215813.558681373@linutronix.de>
Date:   Tue, 12 Oct 2021 23:15:23 +0200
Message-ID: <87o87u9c7o.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12 2021 at 01:59, Thomas Gleixner wrote:
>
> The current series (#1) is based on:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/fpu
>
> and also available from git:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git x86/fpu-1

I've updated the git branch with the review comments which came in today
addressed.

The full stack is rebased on top of that along with a few other fixes.

The delta patch to the current part-1 series is below.

I'm going to wait a bit before sending out a V2 to give people time to
react. Though I'm planning to send out part-2 based on the current state
soonish.

Thanks,

        tglx
---
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 4cf54d8ce17d..5ac5e4596b53 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -130,13 +130,13 @@ static inline void fpstate_init_soft(struct swregs_state *soft) {}
 /* State tracking */
 DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 
-/* FPSTATE related functions which are exported to KVM */
+/* fpstate-related functions which are exported to KVM */
 extern void fpu_init_fpstate_user(struct fpu *fpu);
 
 /* KVM specific functions */
 extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
 
-extern int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
-extern void fpu_copy_vcpu_to_kvm_uabi(struct fpu *fpu, void *buf, unsigned int size, u32 pkru);
+extern int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
+extern void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf, unsigned int size, u32 pkru);
 
 #endif /* _ASM_X86_FPU_API_H */
diff --git a/arch/x86/include/asm/fpu/sched.h b/arch/x86/include/asm/fpu/sched.h
index 99a8820e8cc4..cdb78d590c86 100644
--- a/arch/x86/include/asm/fpu/sched.h
+++ b/arch/x86/include/asm/fpu/sched.h
@@ -11,7 +11,7 @@
 
 extern void save_fpregs_to_fpstate(struct fpu *fpu);
 extern void fpu__drop(struct fpu *fpu);
-extern int  fpu_clone(struct task_struct *dst, unsigned long clone_flags);
+extern int  fpu_clone(struct task_struct *dst);
 extern void fpu_flush_thread(void);
 
 /*
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 1c5e753ba3f1..ac540a7d410e 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -184,7 +184,7 @@ void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask)
 }
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
 
-void fpu_copy_vcpu_to_kvm_uabi(struct fpu *fpu, void *buf,
+void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf,
 			       unsigned int size, u32 pkru)
 {
 	union fpregs_state *kstate = &fpu->state;
@@ -196,12 +196,14 @@ void fpu_copy_vcpu_to_kvm_uabi(struct fpu *fpu, void *buf,
 					  XSTATE_COPY_XSAVE);
 	} else {
 		memcpy(&ustate->fxsave, &kstate->fxsave, sizeof(ustate->fxsave));
+		/* Make it restorable on a XSAVE enabled host */
+		ustate->xsave.header.xfeatures = XFEATURE_MASK_FPSSE;
 	}
 }
-EXPORT_SYMBOL_GPL(fpu_copy_vcpu_to_kvm_uabi);
+EXPORT_SYMBOL_GPL(fpu_copy_fpstate_to_kvm_uabi);
 
-int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0,
-			      u32 *vpkru)
+int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0,
+				 u32 *vpkru)
 {
 	union fpregs_state *kstate = &fpu->state;
 	const union fpregs_state *ustate = buf;
@@ -234,7 +236,7 @@ int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0,
 	xstate_init_xcomp_bv(&kstate->xsave, xfeatures_mask_uabi());
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fpu_copy_kvm_uabi_to_vcpu);
+EXPORT_SYMBOL_GPL(fpu_copy_kvm_uabi_to_fpstate);
 #endif /* CONFIG_KVM */
 
 void kernel_fpu_begin_mask(unsigned int kfpu_mask)
@@ -344,7 +346,7 @@ EXPORT_SYMBOL_GPL(fpu_init_fpstate_user);
 #endif
 
 /* Clone current's FPU state on fork */
-int fpu_clone(struct task_struct *dst, unsigned long clone_flags)
+int fpu_clone(struct task_struct *dst)
 {
 	struct fpu *src_fpu = &current->thread.fpu;
 	struct fpu *dst_fpu = &dst->thread.fpu;
@@ -363,11 +365,9 @@ int fpu_clone(struct task_struct *dst, unsigned long clone_flags)
 
 	/*
 	 * No FPU state inheritance for kernel threads and IO
-	 * worker threads. Neither CLONE_THREAD needs a copy
-	 * of the FPU state.
+	 * worker threads.
 	 */
-	if (clone_flags & CLONE_THREAD ||
-	    dst->flags & (PF_KTHREAD | PF_IO_WORKER)) {
+	if (dst->flags & (PF_KTHREAD | PF_IO_WORKER)) {
 		/* Clear out the minimal state */
 		memcpy(&dst_fpu->state, &init_fpstate,
 		       init_fpstate_copy_size());
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 6e729060beb3..b022df95a302 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1195,15 +1195,13 @@ int copy_sigframe_from_user_to_xstate(struct xregs_state *xsave,
 	return copy_uabi_to_xstate(xsave, NULL, ubuf);
 }
 
-static bool validate_xsaves_xrstors(u64 mask)
+static bool validate_independent_components(u64 mask)
 {
 	u64 xchk;
 
 	if (WARN_ON_FPU(!cpu_feature_enabled(X86_FEATURE_XSAVES)))
 		return false;
-	/*
-	 * Validate that this is a independent compoment.
-	 */
+
 	xchk = ~xfeatures_mask_independent();
 
 	if (WARN_ON_ONCE(!mask || mask & xchk))
@@ -1222,13 +1220,13 @@ static bool validate_xsaves_xrstors(u64 mask)
  * buffer should be zeroed otherwise a consecutive XRSTORS from that buffer
  * can #GP.
  *
- * The feature mask must be a subset of the independent features
+ * The feature mask must be a subset of the independent features.
  */
 void xsaves(struct xregs_state *xstate, u64 mask)
 {
 	int err;
 
-	if (!validate_xsaves_xrstors(mask))
+	if (!validate_independent_components(mask))
 		return;
 
 	XSTATE_OP(XSAVES, xstate, (u32)mask, (u32)(mask >> 32), err);
@@ -1246,13 +1244,13 @@ void xsaves(struct xregs_state *xstate, u64 mask)
  * Proper usage is to restore the state which was saved with
  * xsaves() into @xstate.
  *
- * The feature mask must be a subset of the independent features
+ * The feature mask must be a subset of the independent features.
  */
 void xrstors(struct xregs_state *xstate, u64 mask)
 {
 	int err;
 
-	if (!validate_xsaves_xrstors(mask))
+	if (!validate_independent_components(mask))
 		return;
 
 	XSTATE_OP(XRSTORS, xstate, (u32)mask, (u32)(mask >> 32), err);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 83a34fd828d5..5cd82082353e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -154,7 +154,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 	frame->flags = X86_EFLAGS_FIXED;
 #endif
 
-	fpu_clone(p, clone_flags);
+	fpu_clone(p);
 
 	/* Kernel thread ? */
 	if (unlikely(p->flags & PF_KTHREAD)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac02945756ec..f7826148edc9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4701,9 +4701,9 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 	if (!vcpu->arch.guest_fpu)
 		return;
 
-	fpu_copy_vcpu_to_kvm_uabi(vcpu->arch.guest_fpu, guest_xsave->region,
-				  sizeof(guest_xsave->region),
-				  vcpu->arch.pkru);
+	fpu_copy_fpstate_to_kvm_uabi(vcpu->arch.guest_fpu, guest_xsave->region,
+				     sizeof(guest_xsave->region),
+				     vcpu->arch.pkru);
 }
 
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
@@ -4712,9 +4712,9 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 	if (!vcpu->arch.guest_fpu)
 		return 0;
 
-	return fpu_copy_kvm_uabi_to_vcpu(vcpu->arch.guest_fpu,
-					 guest_xsave->region,
-					 supported_xcr0, &vcpu->arch.pkru);
+	return fpu_copy_kvm_uabi_to_fpstate(vcpu->arch.guest_fpu,
+					    guest_xsave->region,
+					    supported_xcr0, &vcpu->arch.pkru);
 }
 
 static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
@@ -9787,8 +9787,8 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * Guest with protected state have guest_fpu == NULL which makes
-	 * the swap only safe the host state. Exclude PKRU from restore as
+	 * Guests with protected state have guest_fpu == NULL which makes
+	 * the swap only save the host state. Exclude PKRU from restore as
 	 * it is restored separately in kvm_x86_ops.run().
 	 */
 	fpu_swap_kvm_fpu(vcpu->arch.user_fpu, vcpu->arch.guest_fpu,
@@ -9800,7 +9800,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * Guest with protected state have guest_fpu == NULL which makes
+	 * Guests with protected state have guest_fpu == NULL which makes
 	 * swap only restore the host state.
 	 */
 	fpu_swap_kvm_fpu(vcpu->arch.guest_fpu, vcpu->arch.user_fpu, ~0ULL);
