Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EE6434C6C
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 15:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhJTNrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 09:47:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52994 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhJTNqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 09:46:54 -0400
Date:   Wed, 20 Oct 2021 13:44:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634737479;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nFNgeZzscnW/tca/1tnHPF5KkbniCKJhRvKK5e6aNOw=;
        b=X62muE6YRtpMq9hx4Xz6LQOSHYb0qjJG+qR5crwuxgPujgpPpevfzFM1KIoIPkx+DBcZtP
        JNfNB5ZODHb8hAifVfekJOzSaiVTgNTGGmqCuNQVzW372wxl8JWjkIGBvfrmOQlwD6DUCO
        E6sNjcKzQk6yeXadPdB3J/sx/NuuEueU0fNRkiYKEU8fM3t9mAZBJwdzE2bkpndaFWbYU7
        oae0DV/BvXfKgcCWaMFxHCqJ2ZICqO3Dd4T4YGMgNmAkwYGldBXk94mAX9cHrIJz10O37n
        v36PQhOzGXcEQwtsUCdLLXvkD54lSOsipou40WyAM7KyHGDwVlszYCrNzQbXmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634737479;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nFNgeZzscnW/tca/1tnHPF5KkbniCKJhRvKK5e6aNOw=;
        b=zTF9OBwDGmmCa0n5MCQ/+DJ/AqkEqTnEBQlU7WNT3dK8ugs9/P1zePkOj9s0b1Wj6vbFka
        qDFvoqwI9SowmfCA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/fpu] x86/fpu: Replace KVMs home brewed FPU copy from user
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211015011539.134065207@linutronix.de>
References: <20211015011539.134065207@linutronix.de>
MIME-Version: 1.0
Message-ID: <163473747821.25758.7935062231131744682.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following commit has been merged into the x86/fpu branch of tip:

Commit-ID:     ea4d6938d4c0761672ff6237964a20db3cb95cc1
Gitweb:        https://git.kernel.org/tip/ea4d6938d4c0761672ff6237964a20db3cb95cc1
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Fri, 15 Oct 2021 03:16:13 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 20 Oct 2021 15:27:27 +02:00

x86/fpu: Replace KVMs home brewed FPU copy from user

Copying a user space buffer to the memory buffer is already available in
the FPU core. The copy mechanism in KVM lacks sanity checks and needs to
use cpuid() to lookup the offset of each component, while the FPU core has
this information cached.

Make the FPU core variant accessible for KVM and replace the home brewed
mechanism.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: kvm@vger.kernel.org
Link: https://lkml.kernel.org/r/20211015011539.134065207@linutronix.de
---
 arch/x86/include/asm/fpu/api.h |  2 +-
 arch/x86/kernel/fpu/core.c     | 38 ++++++++++++++++-
 arch/x86/kernel/fpu/xstate.c   |  3 +-
 arch/x86/kvm/x86.c             | 74 +--------------------------------
 4 files changed, 43 insertions(+), 74 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index d2b8603..77a732e 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -116,4 +116,6 @@ extern void fpu_init_fpstate_user(struct fpu *fpu);
 /* KVM specific functions */
 extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
 
+extern int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
+
 #endif /* _ASM_X86_FPU_API_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 023bfe8..65fc877 100644
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
index 6835560..eeeb807 100644
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
index 66eea4e..cdc19b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4702,8 +4702,6 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
-
 static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 {
 	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
@@ -4747,50 +4745,6 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
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
@@ -4809,37 +4763,15 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
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
