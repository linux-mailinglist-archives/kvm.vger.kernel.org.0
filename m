Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19E325BBFC
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 09:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgICHzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 03:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgICHzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 03:55:47 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30506C061244;
        Thu,  3 Sep 2020 00:55:47 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BhtQm5Y36z9sTS; Thu,  3 Sep 2020 17:55:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1599119744; bh=jRwtZaqyDLSCz72Xr7M2N9uVo/tZDt0H0qRqtsza/Bc=;
        h=Date:From:To:Cc:Subject:From;
        b=pQ/e8HC6ttrrnnRVFDykJdAHgfhg36bjgP6Wg1KB2tP5ohAubzxIR/G0qXcX1xnBt
         WJikdvk39Hf4BmUy8MLo32+kdDA7l5Qmg0cbh4fDGR25LzGG5qpDF77EzPfe6QUSwO
         C1J9MO75Ljay2m9y+4t9ez0Hl+S/G570GguS0LaPoRjDyDKPblhakRYPXrRC2kGTUA
         ZDVU+/NesBfxA6gFh67qGVqGBUXbsqR4yll7ZvcRjRnMmmtiCiuCz+GkvrrwrQi8ld
         OLaASjb5S4buRUdpkzuLHgjJaT5ZecRtwKDQjfmFOWZQwy/HVDzTYDMn8E8oir5vV2
         cJr01SGGMO7rA==
Date:   Thu, 3 Sep 2020 17:55:40 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Cc:     David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] KVM: PPC: Book3S HV: Set LPCR[HDICE] before writing HDEC
Message-ID: <20200903075540.GI272502@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

POWER8 and POWER9 machines have a hardware deviation where generation
of a hypervisor decrementer exception is suppressed if the HDICE bit
in the LPCR register is 0 at the time when the HDEC register
decrements from 0 to -1.  When entering a guest, KVM first writes the
HDEC register with the time until it wants the CPU to exit the guest,
and then writes the LPCR with the guest value, which includes
HDICE = 1.  If HDEC decrements from 0 to -1 during the interval
between those two events, it is possible that we can enter the guest
with HDEC already negative but no HDEC exception pending, meaning that
no HDEC interrupt will occur while the CPU is in the guest, or at
least not until HDEC wraps around.  Thus it is possible for the CPU to
keep executing in the guest for a long time; up to about 4 seconds on
POWER8, or about 4.46 years on POWER9 (except that the host kernel
hard lockup detector will fire first).

To fix this, we set the LPCR[HDICE] bit before writing HDEC on guest
entry.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_hv.c            | 14 ++++++++++++--
 arch/powerpc/kvm/book3s_hv_interrupts.S |  9 ++++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4ba06a2..f1d841d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3442,9 +3442,19 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	unsigned long host_psscr = mfspr(SPRN_PSSCR);
 	unsigned long host_pidr = mfspr(SPRN_PID);
 
+	/*
+	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
+	 * so set HDICE before writing HDEC.
+	 */
+	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr | LPCR_HDICE);
+	isync();
+
 	hdec = time_limit - mftb();
-	if (hdec < 0)
+	if (hdec < 0) {
+		mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
+		isync();
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
+	}
 	mtspr(SPRN_HDEC, hdec);
 
 	if (vc->tb_offset) {
@@ -3572,7 +3582,7 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	dec = mfspr(SPRN_DEC);
 	tb = mftb();
-	if (dec < 512)
+	if (dec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 	local_paca->kvm_hstate.dec_expires = dec + tb;
 	if (local_paca->kvm_hstate.dec_expires < time_limit)
diff --git a/arch/powerpc/kvm/book3s_hv_interrupts.S b/arch/powerpc/kvm/book3s_hv_interrupts.S
index 59822cb..327417d 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupts.S
+++ b/arch/powerpc/kvm/book3s_hv_interrupts.S
@@ -58,13 +58,16 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	/*
 	 * Put whatever is in the decrementer into the
 	 * hypervisor decrementer.
+	 * Because of a hardware deviation in P8 and P9,
+	 * we need to set LPCR[HDICE] before writing HDEC.
 	 */
-BEGIN_FTR_SECTION
 	ld	r5, HSTATE_KVM_VCORE(r13)
 	ld	r6, VCORE_KVM(r5)
 	ld	r9, KVM_HOST_LPCR(r6)
-	andis.	r9, r9, LPCR_LD@h
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
+	ori	r8, r9, LPCR_HDICE
+	mtspr	SPRN_LPCR, r8
+	isync
+	andis.	r0, r9, LPCR_LD@h
 	mfspr	r8,SPRN_DEC
 	mftb	r7
 BEGIN_FTR_SECTION
-- 
2.7.4

