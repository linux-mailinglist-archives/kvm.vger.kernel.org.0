Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42F842E5E4
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhJOBSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46450 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbhJOBSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:20 -0400
Message-ID: <20211015011539.134065207@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=rBWYhc5n/8kp/duF9LKTPxmhxOYdYSqco7mavwH2s5o=;
        b=TEBo2C9VZaONZ6EkPt4AxZ3OnxYEpT00DEQiMJiVi6EMKc2EdnDHxozYyf9CS6Fc64JTFq
        MYCTInBR08CD4ROk2alkX6/tb/8r+1OiOUfswk6T8ZSKSwH407MSgZ6+Hn0fc0F3KlqGH9
        bbOCwtBM0MtAukvN5ewrslCUDhXDGlGgK4ZA7lBj6/5Ctf5D4bPCX54Z0tHoc81/2Gx+RD
        GhKLj8ZbEMmqV63mttoRFAHoTG3k/Y/TUp+Zr1P4m1MqmP69q1AdiBf8GSfzUVzAEsABeF
        dAO0gMx+DVP43UDonx9nVnhPUTSpVz6PRtqXpx7Ren5oLOEGsdtIfNVZWZtiMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=rBWYhc5n/8kp/duF9LKTPxmhxOYdYSqco7mavwH2s5o=;
        b=KbOBAChsm0nbJC5Dms91A5WVjjDKzplgjsvhKsLPgOwFHu5rjJLrdmtBkIwg1Ge2gWW3Xr
        PoZp+jxHxUWOXcBg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 13/30] x86/fpu: Replace KVMs home brewed FPU copy from user
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:13 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Copying a user space buffer to the memory buffer is already available in
the FPU core. The copy mechanism in KVM lacks sanity checks and needs to
use cpuid() to lookup the offset of each component, while the FPU core has
this information cached.

Make the FPU core variant accessible for KVM and replace the home brewed
mechanism.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>

---
 arch/x86/include/asm/fpu/api.h |  2 +-
 arch/x86/kernel/fpu/core.c     | 38 +++++++++++++++++++++-
 arch/x86/kernel/fpu/xstate.c   |  3 +--
 arch/x86/kvm/x86.c             | 74 +------------------------------------------
 4 files changed, 43 insertions(+), 74 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index d2b8603a9c7e..77a732ea4cda 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -116,4 +116,6 @@ extern void fpu_init_fpstate_user(struct fpu *fpu);
 /* KVM specific functions */
 extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
 
+extern int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
+
 #endif /* _ASM_X86_FPU_API_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 023bfe857907..65fc87760011 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -174,7 +174,43 @@ void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask)
 	fpregs_unlock();
 }
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
-#endif
+
+int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0,
+				 u32 *vpkru)
+{
+	union fpregs_state *kstate = &fpu->state;
+	const union fpregs_state *ustate = buf;
+	struct pkru_state *xpkru;
+	int ret;
+
+	if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
+		if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
+			return -EINVAL;
+		if (ustate->fxsave.mxcsr & ~mxcsr_feature_mask)
+			return -EINVAL;
+		memcpy(&kstate->fxsave, &ustate->fxsave, sizeof(ustate->fxsave));
+		return 0;
+	}
+
+	if (ustate->xsave.header.xfeatures & ~xcr0)
+		return -EINVAL;
+
+	ret = copy_uabi_from_kernel_to_xstate(&kstate->xsave, ustate);
+	if (ret)
+		return ret;
+
+	/* Retrieve PKRU if not in init state */
+	if (kstate->xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
+		xpkru = get_xsave_addr(&kstate->xsave, XFEATURE_PKRU);
+		*vpkru = xpkru->pkru;
+	}
+
+	/* Ensure that XCOMP_BV is set up for XSAVES */
+	xstate_init_xcomp_bv(&kstate->xsave, xfeatures_mask_uabi());
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fpu_copy_kvm_uabi_to_fpstate);
+#endif /* CONFIG_KVM */
 
 void kernel_fpu_begin_mask(unsigned int kfpu_mask)
 {
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 68355605ca75..eeeb807b9717 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1134,8 +1134,7 @@ static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
 
 /*
  * Convert from a ptrace standard-format kernel buffer to kernel XSAVE[S]
- * format and copy to the target thread. This is called from
- * xstateregs_set().
+ * format and copy to the target thread. Used by ptrace and KVM.
  */
 int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9fda03162bd..81dd70be631f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4695,8 +4695,6 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
-
 static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 {
 	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
@@ -4740,50 +4738,6 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 	}
 }
 
-static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
-{
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
-	u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
-	u64 valid;
-
-	/*
-	 * Copy legacy XSAVE area, to avoid complications with CPUID
-	 * leaves 0 and 1 in the loop below.
-	 */
-	memcpy(xsave, src, XSAVE_HDR_OFFSET);
-
-	/* Set XSTATE_BV and possibly XCOMP_BV.  */
-	xsave->header.xfeatures = xstate_bv;
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		xsave->header.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
-
-	/*
-	 * Copy each region from the non-compacted offset to the
-	 * possibly compacted offset.
-	 */
-	valid = xstate_bv & ~XFEATURE_MASK_FPSSE;
-	while (valid) {
-		u32 size, offset, ecx, edx;
-		u64 xfeature_mask = valid & -valid;
-		int xfeature_nr = fls64(xfeature_mask) - 1;
-
-		cpuid_count(XSTATE_CPUID, xfeature_nr,
-			    &size, &offset, &ecx, &edx);
-
-		if (xfeature_nr == XFEATURE_PKRU) {
-			memcpy(&vcpu->arch.pkru, src + offset,
-			       sizeof(vcpu->arch.pkru));
-		} else {
-			void *dest = get_xsave_addr(xsave, xfeature_nr);
-
-			if (dest)
-				memcpy(dest, src + offset, size);
-		}
-
-		valid -= xfeature_mask;
-	}
-}
-
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
@@ -4802,37 +4756,15 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 	}
 }
 
-#define XSAVE_MXCSR_OFFSET 24
-
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					struct kvm_xsave *guest_xsave)
 {
-	u64 xstate_bv;
-	u32 mxcsr;
-
 	if (!vcpu->arch.guest_fpu)
 		return 0;
 
-	xstate_bv = *(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
-	mxcsr = *(u32 *)&guest_xsave->region[XSAVE_MXCSR_OFFSET / sizeof(u32)];
-
-	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
-		/*
-		 * Here we allow setting states that are not present in
-		 * CPUID leaf 0xD, index 0, EDX:EAX.  This is for compatibility
-		 * with old userspace.
-		 */
-		if (xstate_bv & ~supported_xcr0 || mxcsr & ~mxcsr_feature_mask)
-			return -EINVAL;
-		load_xsave(vcpu, (u8 *)guest_xsave->region);
-	} else {
-		if (xstate_bv & ~XFEATURE_MASK_FPSSE ||
-			mxcsr & ~mxcsr_feature_mask)
-			return -EINVAL;
-		memcpy(&vcpu->arch.guest_fpu->state.fxsave,
-			guest_xsave->region, sizeof(struct fxregs_state));
-	}
-	return 0;
+	return fpu_copy_kvm_uabi_to_fpstate(vcpu->arch.guest_fpu,
+					    guest_xsave->region,
+					    supported_xcr0, &vcpu->arch.pkru);
 }
 
 static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,

