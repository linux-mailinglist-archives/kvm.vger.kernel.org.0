Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FE2430B04
	for <lists+kvm@lfdr.de>; Sun, 17 Oct 2021 19:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344332AbhJQRFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Oct 2021 13:05:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33434 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344313AbhJQRF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Oct 2021 13:05:29 -0400
Message-ID: <20211017152048.666354328@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634490198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=xYHQDcA+typvnH6OkaDBbBQWfWQCBtHPVVuP5M7U0xg=;
        b=zaiEM7ZlF6+rDLr5+WJLafFQkfyZn0nhmqTBi4I5jvvjdwhk5b9Bt2czGkCJZALDWfSiyL
        oQXR3LDRhpG7/IPZZMzYZCGb+i4AKntM6egHEev6zKYPTrgEgl6MD7Kw/kHCRT2xI/ScfL
        TQLkdf2bWYHOMCzBfP4vCI9vkyXq4Nhr6EfeAWJ5D9IHN1JR3gR3kfqHA8/173GYqguGQf
        HIepo2hpAIkE9pHx5C+wVUT9+f6y1PKIb/J30xy+NV00tUAoWhtgP7QG2X8ETAbxgFcrcS
        MLBw7FhPmjiQp5iHnYd1x5Y4jOlFI0WowpKGU4sL2OnR3qWZrZZIsFpkoxDeSQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634490198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=xYHQDcA+typvnH6OkaDBbBQWfWQCBtHPVVuP5M7U0xg=;
        b=vKjqDvudrnPm1GGlXbXYNUq87uCtfqAz/gGquXv95AbdMM0/zdBXVEYM6LDokVKBXFvZI6
        6+WDLp35lNbWfdBg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, "Nakajima, Jun" <jun.nakajima@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [patch 3/4] x86/kvm: Convert FPU handling to a single swap buffer
References: <20211017151447.829495362@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 17 Oct 2021 19:03:17 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the upcoming AMX support it's necessary to do a proper integration with
KVM. Currently KVM allocates two FPU structs which are used for saving the user
state of the vCPU thread and restoring the guest state when entering
vcpu_run() and doing the reverse operation before leaving vcpu_run().

With the new fpstate mechanism this can be reduced to one extra buffer by
swapping the fpstate pointer in current::thread::fpu. This makes the
upcoming support for AMX and XFD simpler because then fpstate information
(features, sizes, xfd) are always consistent and it does not require any
nasty workarounds.

Convert the KVM FPU code over to this new scheme.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/api.h  |  4 +-
 arch/x86/include/asm/kvm_host.h |  7 +---
 arch/x86/kernel/fpu/core.c      | 16 ++++----
 arch/x86/kvm/svm/svm.c          |  7 +--
 arch/x86/kvm/x86.c              | 88 +++++++++++-------------------------------
 5 files changed, 40 insertions(+), 82 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 3b018140b3ae..239909a95368 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -140,8 +140,8 @@ extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
 extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest, u64 restore_mask);
 extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
 
-extern int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
-extern void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf, unsigned int size, u32 pkru);
+extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
+extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
 
 static inline void fpstate_set_confidential(struct fpu_guest *gfpu)
 {
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..eb0d69bb2fc6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -691,11 +691,10 @@ struct kvm_vcpu_arch {
 	 *
 	 * Note that while the PKRU state lives inside the fpu registers,
 	 * it is switched out separately at VMENTER and VMEXIT time. The
-	 * "guest_fpu" state here contains the guest FPU context, with the
+	 * "guest_fpstate" state here contains the guest FPU context, with the
 	 * host PRKU bits.
 	 */
-	struct fpu *user_fpu;
-	struct fpu *guest_fpu;
+	struct fpu_guest guest_fpu;
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
@@ -1685,8 +1684,6 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
-void kvm_free_guest_fpu(struct kvm_vcpu *vcpu);
-
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index d4c16bb37144..60681dc8a725 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -271,10 +271,10 @@ void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask)
 }
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
 
-void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf,
-			       unsigned int size, u32 pkru)
+void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
+				    unsigned int size, u32 pkru)
 {
-	struct fpstate *kstate = fpu->fpstate;
+	struct fpstate *kstate = gfpu->fpstate;
 	union fpregs_state *ustate = buf;
 	struct membuf mb = { .p = buf, .left = size };
 
@@ -287,12 +287,12 @@ void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf,
 		ustate->xsave.header.xfeatures = XFEATURE_MASK_FPSSE;
 	}
 }
-EXPORT_SYMBOL_GPL(fpu_copy_fpstate_to_kvm_uabi);
+EXPORT_SYMBOL_GPL(fpu_copy_guest_fpstate_to_uabi);
 
-int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0,
-				 u32 *vpkru)
+int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
+				   u64 xcr0, u32 *vpkru)
 {
-	struct fpstate *kstate = fpu->fpstate;
+	struct fpstate *kstate = gfpu->fpstate;
 	const union fpregs_state *ustate = buf;
 	struct pkru_state *xpkru;
 	int ret;
@@ -323,7 +323,7 @@ int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0,
 	xstate_init_xcomp_bv(&kstate->regs.xsave, fpu_user_cfg.max_features);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fpu_copy_kvm_uabi_to_fpstate);
+EXPORT_SYMBOL_GPL(fpu_copy_uabi_to_guest_fpstate);
 #endif /* CONFIG_KVM */
 
 void kernel_fpu_begin_mask(unsigned int kfpu_mask)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 05e8d4d27969..d027e8473ace 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -36,6 +36,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
 #include <asm/traps.h>
+#include <asm/fpu/api.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
@@ -1346,10 +1347,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		/*
 		 * SEV-ES guests maintain an encrypted version of their FPU
 		 * state which is restored and saved on VMRUN and VMEXIT.
-		 * Free the fpu structure to prevent KVM from attempting to
-		 * access the FPU state.
+		 * Mark vcpu->arch.guest_fpu->fpstate as scratch so it won't
+		 * do xsave/xrstor on it.
 		 */
-		kvm_free_guest_fpu(vcpu);
+		fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	}
 
 	err = avic_init_vcpu(svm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f085371ddd12..df36c8c195b0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -295,8 +295,6 @@ u64 __read_mostly host_xcr0;
 u64 __read_mostly supported_xcr0;
 EXPORT_SYMBOL_GPL(supported_xcr0);
 
-static struct kmem_cache *x86_fpu_cache;
-
 static struct kmem_cache *x86_emulator_cache;
 
 /*
@@ -4698,23 +4696,24 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
-	if (!vcpu->arch.guest_fpu)
+	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return;
 
-	fpu_copy_fpstate_to_kvm_uabi(vcpu->arch.guest_fpu, guest_xsave->region,
-				     sizeof(guest_xsave->region),
-				     vcpu->arch.pkru);
+	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
+				       guest_xsave->region,
+				       sizeof(guest_xsave->region),
+				       vcpu->arch.pkru);
 }
 
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					struct kvm_xsave *guest_xsave)
 {
-	if (!vcpu->arch.guest_fpu)
+	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return 0;
 
-	return fpu_copy_kvm_uabi_to_fpstate(vcpu->arch.guest_fpu,
-					    guest_xsave->region,
-					    supported_xcr0, &vcpu->arch.pkru);
+	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
+					      guest_xsave->region,
+					      supported_xcr0, &vcpu->arch.pkru);
 }
 
 static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
@@ -8287,18 +8286,11 @@ int kvm_arch_init(void *opaque)
 	}
 
 	r = -ENOMEM;
-	x86_fpu_cache = kmem_cache_create("x86_fpu", sizeof(struct fpu),
-					  __alignof__(struct fpu), SLAB_ACCOUNT,
-					  NULL);
-	if (!x86_fpu_cache) {
-		printk(KERN_ERR "kvm: failed to allocate cache for x86 fpu\n");
-		goto out;
-	}
 
 	x86_emulator_cache = kvm_alloc_emulator_cache();
 	if (!x86_emulator_cache) {
 		pr_err("kvm: failed to allocate cache for x86 emulator\n");
-		goto out_free_x86_fpu_cache;
+		goto out;
 	}
 
 	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
@@ -8336,8 +8328,6 @@ int kvm_arch_init(void *opaque)
 	free_percpu(user_return_msrs);
 out_free_x86_emulator_cache:
 	kmem_cache_destroy(x86_emulator_cache);
-out_free_x86_fpu_cache:
-	kmem_cache_destroy(x86_fpu_cache);
 out:
 	return r;
 }
@@ -8364,7 +8354,6 @@ void kvm_arch_exit(void)
 	kvm_mmu_module_exit();
 	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_emulator_cache);
-	kmem_cache_destroy(x86_fpu_cache);
 #ifdef CONFIG_KVM_XEN
 	static_key_deferred_flush(&kvm_xen_enabled);
 	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
@@ -9787,23 +9776,17 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * Guests with protected state have guest_fpu == NULL which makes
-	 * the swap only save the host state. Exclude PKRU from restore as
-	 * it is restored separately in kvm_x86_ops.run().
+	 * Exclude PKRU from restore as restored separately in
+	 * kvm_x86_ops.run().
 	 */
-	fpu_swap_kvm_fpu(vcpu->arch.user_fpu, vcpu->arch.guest_fpu,
-			 ~XFEATURE_MASK_PKRU);
+	fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, true, ~XFEATURE_MASK_PKRU);
 	trace_kvm_fpu(1);
 }
 
 /* When vcpu_run ends, restore user space FPU context. */
 static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * Guests with protected state have guest_fpu == NULL which makes
-	 * swap only restore the host state.
-	 */
-	fpu_swap_kvm_fpu(vcpu->arch.guest_fpu, vcpu->arch.user_fpu, ~0ULL);
+	fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, false, ~0ULL);
 	++vcpu->stat.fpu_reload;
 	trace_kvm_fpu(0);
 }
@@ -10384,12 +10367,12 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
-	if (!vcpu->arch.guest_fpu)
+	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return 0;
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu->fpstate->regs.fxsave;
+	fxsave = &vcpu->arch.guest_fpu.fpstate->regs.fxsave;
 	memcpy(fpu->fpr, fxsave->st_space, 128);
 	fpu->fcw = fxsave->cwd;
 	fpu->fsw = fxsave->swd;
@@ -10407,12 +10390,12 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
 	struct fxregs_state *fxsave;
 
-	if (!vcpu->arch.guest_fpu)
+	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return 0;
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu->fpstate->regs.fxsave;
+	fxsave = &vcpu->arch.guest_fpu.fpstate->regs.fxsave;
 
 	memcpy(fxsave->st_space, fpu->fpr, 128);
 	fxsave->cwd = fpu->fcw;
@@ -10473,15 +10456,6 @@ static void fx_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0 |= X86_CR0_ET;
 }
 
-void kvm_free_guest_fpu(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.guest_fpu) {
-		kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
-		vcpu->arch.guest_fpu = NULL;
-	}
-}
-EXPORT_SYMBOL_GPL(kvm_free_guest_fpu);
-
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
@@ -10536,22 +10510,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (!alloc_emulate_ctxt(vcpu))
 		goto free_wbinvd_dirty_mask;
 
-	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.user_fpu) {
-		pr_err("kvm: failed to allocate userspace's fpu\n");
-		goto free_emulate_ctxt;
-	}
-
-	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						 GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.guest_fpu) {
+	if (!fpu_alloc_guest_fpstate(&vcpu->arch.guest_fpu)) {
 		pr_err("kvm: failed to allocate vcpu's fpu\n");
-		goto free_user_fpu;
+		goto free_emulate_ctxt;
 	}
 
-	fpu_init_fpstate_user(vcpu->arch.user_fpu);
-	fpu_init_fpstate_user(vcpu->arch.guest_fpu);
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
@@ -10584,9 +10547,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 
 free_guest_fpu:
-	kvm_free_guest_fpu(vcpu);
-free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+	fpu_free_guest_fpstate(&vcpu->arch.guest_fpu);
 free_emulate_ctxt:
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 free_wbinvd_dirty_mask:
@@ -10635,8 +10596,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-	kvm_free_guest_fpu(vcpu);
+	fpu_free_guest_fpstate(&vcpu->arch.guest_fpu);
 
 	kvm_hv_vcpu_uninit(vcpu);
 	kvm_pmu_destroy(vcpu);
@@ -10688,8 +10648,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
-	if (vcpu->arch.guest_fpu && kvm_mpx_supported()) {
-		struct fpstate *fpstate = vcpu->arch.guest_fpu->fpstate;
+	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
+		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
 
 		/*
 		 * To avoid have the INIT path from kvm_apic_has_events() that be

