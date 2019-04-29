Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B833FDE9C
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfD2JDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:03:05 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58467 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbfD2JDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 05:03:05 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44szFy1GMmz9s70; Mon, 29 Apr 2019 19:03:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556528582; bh=sxBs5f2HGQdQNFhRNiQfs5t44wTz5Lif+P0dTyX3h/g=;
        h=Date:From:To:Cc:Subject:From;
        b=Za1JOrgGLuDNYc5JG+LLBc11XaCQG7SiPcmJnz3+2gGcCRlC5RKm8E6jUsXI1Ki41
         +ACl6AP6NAP2nDdPnUfGsfc8wP8nDJmBlL8tt6XwccMNKuDKHy1pBzlQCRN23+RwEX
         FiM6GsTzlDt426nhlieslUcwtv+WCWmvdIOkMIlHoVvnvmxEAltMJGELJg4AXJQ/4d
         JcmoGzFYwxyjehkbAuJKajSFVSlxH9UOawqei19bPulSvYs004ydxakhpOJMNtI7jf
         QizNI964/PcoSH5xmHXaKi9APM0W1jqQZ4uweffghp4kaz4swX21IEb4VJgEQ6cCfz
         Mj6XD4QB6/twQ==
Date:   Mon, 29 Apr 2019 18:57:45 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Handle virtual mode in XIVE VCPU
 push code
Message-ID: <20190429085745.GA17146@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

The code in book3s_hv_rmhandlers.S that pushes the XIVE virtual CPU
context to the hardware currently assumes it is being called in real
mode, which is usually true.  There is however a path by which it can
be executed in virtual mode, in the case where indep_threads_mode = N.
A virtual CPU executing on an offline secondary thread can take a
hypervisor interrupt in virtual mode and return from the
kvmppc_hv_entry() call after the kvm_secondary_got_guest label.
It is possible for it to be given another vcpu to execute before it
gets to execute the stop instruction.  In that case it will call
kvmppc_hv_entry() for the second VCPU in virtual mode, and the XIVE
vCPU push code will be executed in virtual mode.  The result in that
case will be a host crash due to an unexpected data storage interrupt
caused by executing the stdcix instruction in virtual mode.

This fixes it by adding a code path for virtual mode, which uses the
virtual TIMA pointer and normal load/store instructions.

[paulus@ozlabs.org - wrote patch description]

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 36 +++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 5df137d..3f19f8b 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -944,17 +944,27 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 
 #ifdef CONFIG_KVM_XICS
 	/* We are entering the guest on that thread, push VCPU to XIVE */
-	ld	r10, HSTATE_XIVE_TIMA_PHYS(r13)
-	cmpldi	cr0, r10, 0
-	beq	no_xive
 	ld	r11, VCPU_XIVE_SAVED_STATE(r4)
 	li	r9, TM_QW1_OS
+	lwz	r8, VCPU_XIVE_CAM_WORD(r4)
+	li	r7, TM_QW1_OS + TM_WORD2
+	mfmsr	r0
+	andi.	r0, r0, MSR_DR		/* in real mode? */
+	beq	2f
+	ld	r10, HSTATE_XIVE_TIMA_VIRT(r13)
+	cmpldi	cr1, r10, 0
+	beq     cr1, no_xive
+	eieio
+	stdx	r11,r9,r10
+	stwx	r8,r7,r10
+	b	3f
+2:	ld	r10, HSTATE_XIVE_TIMA_PHYS(r13)
+	cmpldi	cr1, r10, 0
+	beq	cr1, no_xive
 	eieio
 	stdcix	r11,r9,r10
-	lwz	r11, VCPU_XIVE_CAM_WORD(r4)
-	li	r9, TM_QW1_OS + TM_WORD2
-	stwcix	r11,r9,r10
-	li	r9, 1
+	stwcix	r8,r7,r10
+3:	li	r9, 1
 	stb	r9, VCPU_XIVE_PUSHED(r4)
 	eieio
 
@@ -973,12 +983,16 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	 * on, we mask it.
 	 */
 	lbz	r0, VCPU_XIVE_ESC_ON(r4)
-	cmpwi	r0,0
-	beq	1f
-	ld	r10, VCPU_XIVE_ESC_RADDR(r4)
+	cmpwi	cr1, r0,0
+	beq	cr1, 1f
 	li	r9, XIVE_ESB_SET_PQ_01
+	beq	4f			/* in real mode? */
+	ld	r10, VCPU_XIVE_ESC_VADDR(r4)
+	ldx	r0, r10, r9
+	b	5f
+4:	ld	r10, VCPU_XIVE_ESC_RADDR(r4)
 	ldcix	r0, r10, r9
-	sync
+5:	sync
 
 	/* We have a possible subtle race here: The escalation interrupt might
 	 * have fired and be on its way to the host queue while we mask it,
-- 
2.7.4

