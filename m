Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7E42C435
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238285AbhJMO6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:58:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35376 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238266AbhJMO55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:57 -0400
Message-ID: <20211013145323.129699950@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=2dk3RFW57oZ1plO2S379FVF9hIdOzs/SDlm1jedIkxI=;
        b=hWlR56gSJYet3XS5orxABZGLITqCdj7Lz3mF19iu0xxnfbU8+RzJZ91evS+5dMC8IkJVVf
        Uh2YRPlRUnyS8G8aJQN68zJvlg9adXpPS4bis7oshXre8UkangeWXUEsO49PJ9hHH8RzWq
        uReV3Y8LNJL+ymPZ86No75KCapyhClxd8/lFPN2YK/0c4pHo55+7IUt8tpI8wDUAeoxe1D
        Iw8Z91Z1e1XD/GWhB5e6ibaXgen5sQgjgw+0uVzdrNTLHrnNDJI00MV2TEATrCsG0IDn2/
        4sWh/zVUY10Zmrg6RjdD3/dJvw0HRFWSR+4arn+spax0PMmuzEJdZryNNtnWbA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=2dk3RFW57oZ1plO2S379FVF9hIdOzs/SDlm1jedIkxI=;
        b=tbjFO9G3q0MKsPXMMtifenpU3IW72cyC6XmLBoXOpWs102dYLtbdlSuxCk5AquncHX9tGH
        kG/XsXawE82s++Aw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 18/21] x86/fpu: Use fpstate in fpu_copy_kvm_uabi_to_fpstate()
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:52 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Straight forward conversion. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -205,7 +205,7 @@ EXPORT_SYMBOL_GPL(fpu_copy_fpstate_to_kv
 int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0,
 				 u32 *vpkru)
 {
-	union fpregs_state *kstate = &fpu->fpstate->regs;
+	struct fpstate *kstate = fpu->fpstate;
 	const union fpregs_state *ustate = buf;
 	struct pkru_state *xpkru;
 	int ret;
@@ -215,25 +215,25 @@ int fpu_copy_kvm_uabi_to_fpstate(struct
 			return -EINVAL;
 		if (ustate->fxsave.mxcsr & ~mxcsr_feature_mask)
 			return -EINVAL;
-		memcpy(&kstate->fxsave, &ustate->fxsave, sizeof(ustate->fxsave));
+		memcpy(&kstate->regs.fxsave, &ustate->fxsave, sizeof(ustate->fxsave));
 		return 0;
 	}
 
 	if (ustate->xsave.header.xfeatures & ~xcr0)
 		return -EINVAL;
 
-	ret = copy_uabi_from_kernel_to_xstate(&kstate->xsave, ustate);
+	ret = copy_uabi_from_kernel_to_xstate(&kstate->regs.xsave, ustate);
 	if (ret)
 		return ret;
 
 	/* Retrieve PKRU if not in init state */
-	if (kstate->xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
-		xpkru = get_xsave_addr(&kstate->xsave, XFEATURE_PKRU);
+	if (kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU) {
+		xpkru = get_xsave_addr(&kstate->regs.xsave, XFEATURE_PKRU);
 		*vpkru = xpkru->pkru;
 	}
 
 	/* Ensure that XCOMP_BV is set up for XSAVES */
-	xstate_init_xcomp_bv(&kstate->xsave, xfeatures_mask_uabi());
+	xstate_init_xcomp_bv(&kstate->regs.xsave, xfeatures_mask_uabi());
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fpu_copy_kvm_uabi_to_fpstate);

