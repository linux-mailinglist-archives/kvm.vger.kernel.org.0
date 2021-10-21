Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913F6436574
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhJUPPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:15:04 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60788 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbhJUPO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 11:14:56 -0400
Date:   Thu, 21 Oct 2021 15:12:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634829159;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gEny/5/aqNnXTXSVx5cZRgB+ia503beZnahJAVlS+E0=;
        b=sUoddpBCYtYg4vtkKIRdwYZwOGKfDPV3SUNkNBKa7Rkpr9EEiTktAqp44IsFTMvl2t8rSe
        uoNZ16+cJAeLEz2F+p2F8IeRAz15KIyE2W3TPzLKsiJAwn8TDPx9xC8Zq5JLbVrQi4LGzk
        9OYm7XWZFOG9laEHqRqcF8HkVORFzJLyw38Vmeg3X+Beht2r5pKffYhmnLCrtHe7CkNti0
        c3Kj+EUKbe0aceLCG8tplRFVilbzDRFnNl+nc7YOtPKF7vJ/LGzenS6HEq/j5qpmQS58l+
        u/ad3Vh/HcDav5YRwtQEowdD812XGN3Rh6gAjvLXz5yowub15ymfuUirHPhJ5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634829159;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gEny/5/aqNnXTXSVx5cZRgB+ia503beZnahJAVlS+E0=;
        b=4Rxd8oh4Jb3mdw0bGu1DRcvd3RN4FGaAYf7AicLmbq/NMwi0XEhPjyWZyfIrMGOjjTwE8P
        S7PWbW8FVTORUbAw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/fpu] x86/fpu: Replace KVMs home brewed FPU copy to user
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211015011539.244101845@linutronix.de>
References: <20211015011539.244101845@linutronix.de>
MIME-Version: 1.0
Message-ID: <163482915831.25758.11984661683158416047.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following commit has been merged into the x86/fpu branch of tip:

Commit-ID:     bf5d00470787067ff27593c6a097b5eb6e01168e
Gitweb:        https://git.kernel.org/tip/bf5d00470787067ff27593c6a097b5eb6e01168e
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Fri, 15 Oct 2021 03:16:17 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 20 Oct 2021 22:17:17 +02:00

x86/fpu: Replace KVMs home brewed FPU copy to user

Similar to the copy from user function the FPU core has this already
implemented with all bells and whistles.

Get rid of the duplicated code and use the core functionality.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: kvm@vger.kernel.org
Link: https://lkml.kernel.org/r/20211015011539.244101845@linutronix.de
---
 arch/x86/include/asm/fpu/api.h |  1 +-
 arch/x86/kernel/fpu/core.c     | 18 +++++++++++-
 arch/x86/kvm/x86.c             | 56 +--------------------------------
 3 files changed, 22 insertions(+), 53 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 9263d70..5ac5e45 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -137,5 +137,6 @@ extern void fpu_init_fpstate_user(struct fpu *fpu);
 extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
 
 extern int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
+extern void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf, unsigned int size, u32 pkru);
 
 #endif /* _ASM_X86_FPU_API_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 79f2e8d..ac540a7 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -184,6 +184,24 @@ void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask)
 }
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
 
+void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf,
+			       unsigned int size, u32 pkru)
+{
+	union fpregs_state *kstate = &fpu->state;
+	union fpregs_state *ustate = buf;
+	struct membuf mb = { .p = buf, .left = size };
+
+	if (cpu_feature_enabled(X86_FEATURE_XSAVE)) {
+		__copy_xstate_to_uabi_buf(mb, &kstate->xsave, pkru,
+					  XSTATE_COPY_XSAVE);
+	} else {
+		memcpy(&ustate->fxsave, &kstate->fxsave, sizeof(ustate->fxsave));
+		/* Make it restorable on a XSAVE enabled host */
+		ustate->xsave.header.xfeatures = XFEATURE_MASK_FPSSE;
+	}
+}
+EXPORT_SYMBOL_GPL(fpu_copy_fpstate_to_kvm_uabi);
+
 int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0,
 				 u32 *vpkru)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cdc19b1..a18d467 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4702,65 +4702,15 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
-{
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
-	u64 xstate_bv = xsave->header.xfeatures;
-	u64 valid;
-
-	/*
-	 * Copy legacy XSAVE area, to avoid complications with CPUID
-	 * leaves 0 and 1 in the loop below.
-	 */
-	memcpy(dest, xsave, XSAVE_HDR_OFFSET);
-
-	/* Set XSTATE_BV */
-	xstate_bv &= vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FPSSE;
-	*(u64 *)(dest + XSAVE_HDR_OFFSET) = xstate_bv;
-
-	/*
-	 * Copy each region from the possibly compacted offset to the
-	 * non-compacted offset.
-	 */
-	valid = xstate_bv & ~XFEATURE_MASK_FPSSE;
-	while (valid) {
-		u32 size, offset, ecx, edx;
-		u64 xfeature_mask = valid & -valid;
-		int xfeature_nr = fls64(xfeature_mask) - 1;
-		void *src;
-
-		cpuid_count(XSTATE_CPUID, xfeature_nr,
-			    &size, &offset, &ecx, &edx);
-
-		if (xfeature_nr == XFEATURE_PKRU) {
-			memcpy(dest + offset, &vcpu->arch.pkru,
-			       sizeof(vcpu->arch.pkru));
-		} else {
-			src = get_xsave_addr(xsave, xfeature_nr);
-			if (src)
-				memcpy(dest + offset, src, size);
-		}
-
-		valid -= xfeature_mask;
-	}
-}
-
 static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 					 struct kvm_xsave *guest_xsave)
 {
 	if (!vcpu->arch.guest_fpu)
 		return;
 
-	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
-		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
-		fill_xsave((u8 *) guest_xsave->region, vcpu);
-	} else {
-		memcpy(guest_xsave->region,
-			&vcpu->arch.guest_fpu->state.fxsave,
-			sizeof(struct fxregs_state));
-		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] =
-			XFEATURE_MASK_FPSSE;
-	}
+	fpu_copy_fpstate_to_kvm_uabi(vcpu->arch.guest_fpu, guest_xsave->region,
+				     sizeof(guest_xsave->region),
+				     vcpu->arch.pkru);
 }
 
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
