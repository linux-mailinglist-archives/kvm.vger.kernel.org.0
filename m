Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6432D42AC4C
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 20:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbhJLSq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 14:46:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57634 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbhJLSqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 14:46:55 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634064033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KW+IJ7OIyygtO/OUib0E/8GQRDwfz133sFxAz7WGAxc=;
        b=if4AgnZt3vh78PzErZ4D+P8AL4EAGFPgHqgITlTOjCtWExcVjyr+WRGutjEkhGdAXGI3Tf
        8bEBavF4jCqR92er3KEb/7PR2JGmzw08HTtArGN92IcY6YL9SspWR1FSeWWYKAOoSgq3n/
        B+rdjCvnVfjy3FbKkzohq9r8ONHxRFKo00fcuLeNlFbxeirt085rcheR4Czi1nPKYGrTYw
        NvtDZB/JQ26kslfqDrVp5pIWf/fnUFCVJ+NjFOGATbTCznkiEaI/8/wxuNGvT4vbRqDl0B
        Dx68Uwly/S5e6/4G0q7WeY6B+IrBbLld+JdO8KyWv6UWmNWnpXWlLt9bA1kpzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634064033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KW+IJ7OIyygtO/OUib0E/8GQRDwfz133sFxAz7WGAxc=;
        b=Kd4INlPzpimcW+3qnVdzxma4uFCdRF49G8PXqO/bBZxtq+FMdI0w2Q1OxHLA2OBChJNnI3
        5w81b0QJQyGwkkBw==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org
Subject: [patch V2 16/31] x86/fpu: Replace KVMs home brewed FPU copy to user
In-Reply-To: <87fst6b0f5.ffs@tglx>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.249593446@linutronix.de>
 <0d222978-014a-cdcb-f8aa-5b3179cb0809@redhat.com> <87fst6b0f5.ffs@tglx>
Date:   Tue, 12 Oct 2021 20:40:32 +0200
Message-ID: <87zgre9jdr.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to the copy from user function the FPU core has this already
implemented with all bells and whistles.

Get rid of the duplicated code and use the core functionality.

The memset(0) of the buffer is not required as it is already allocated
with kzalloc() at the call site.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
V2: Add the missing xsave header assignment in the !XSAVE path
    and explain the memset(0) removal in the changelog - Paolo
    Rename the function and fix subject - Borislav
---
 arch/x86/include/asm/fpu/api.h |    1 
 arch/x86/kernel/fpu/core.c     |   18 +++++++++++++
 arch/x86/kvm/x86.c             |   56 ++---------------------------------------
 3 files changed, 22 insertions(+), 53 deletions(-)

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
