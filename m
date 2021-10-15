Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB6642E5EB
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhJOBTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbhJOBSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52BEC061760;
        Thu, 14 Oct 2021 18:16:18 -0700 (PDT)
Message-ID: <20211015011539.244101845@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=DlvKqi0jmCE/KH+PUdpmqLIW5TpRgR26D2pqirU4Qm4=;
        b=goG7LKJk/nOsHyLLiWtn/5g2lKZZzKdP4EWYg9YgCZs8Bu7cEnJ3+Ys9gDVMMBlgoc7Ud9
        rE5CNO7TUtCzbHUv4o9HWh5hArj+01pTi/FGodhmCrg2X/Cnrru0QzxxaCMYJAD17B6vid
        g09iOUtHgzG6MfCjp7bJoA8uNLH1aIZaLi8jLPRe++ZnPlGJAMlH0dwm/kaJKsm2gEQ/KO
        ME51MK/gGqJL9BEEQ8B0hNd7DjVzNxyhmGCjKqM2RSfPyKSEsPe2UyX2h+77kICCp83n8P
        3SDduJ3nUhRo46ceP7/sJeaHui40CbkWsZEJwQv9IbkbDdJY1tfUxZJD0608yQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=DlvKqi0jmCE/KH+PUdpmqLIW5TpRgR26D2pqirU4Qm4=;
        b=TmJDR9JpvyidIUNlECYuVs5IZtWTaWZRIlAqMbB8M4litWm7ED8Ev9jlkb+uRoi5Ch88hF
        AIfOaEltVG4q2sDA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 15/30] x86/fpu: Replace KVMs home brewed FPU copy to user
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:17 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to the copy from user function the FPU core has this already
implemented with all bells and whistles.

Get rid of the duplicated code and use the core functionality.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
V2: Fix the non xsave path - Paolo
    Fix changelog, comments and function name - Boris, Paolo, Sean
---
 arch/x86/include/asm/fpu/api.h |    1 
 arch/x86/kernel/fpu/core.c     |   18 +++++++++++++
 arch/x86/kvm/x86.c             |   56 ++---------------------------------------
 3 files changed, 22 insertions(+), 53 deletions(-)
---
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -117,5 +117,6 @@ extern void fpu_init_fpstate_user(struct
 extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
 
 extern int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
+extern void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf, unsigned int size, u32 pkru);
 
 #endif /* _ASM_X86_FPU_API_H */
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -175,6 +175,24 @@ void fpu_swap_kvm_fpu(struct fpu *save,
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
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4695,65 +4695,15 @@ static int kvm_vcpu_ioctl_x86_set_debugr
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

