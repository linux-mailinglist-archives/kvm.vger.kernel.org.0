Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1F88B50A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 12:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbfHMKJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 06:09:28 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:60443 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728788AbfHMKJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 06:09:27 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4677jc3qj4z9sNf; Tue, 13 Aug 2019 20:09:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1565690964; bh=kZgv7OR1P+GqwOWODTl3Aikjw+eWl5ULVpu3MPDq2CE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rZz1qy06Jp2CooaZg+BV2Z5CDoKuGYcoUwQ8BjUZeoAt5QEmVEDBxf81r9SDiELux
         FlVg0JDBqDQ0+FVQpVf2Y9bbYnE37TmuRwDdIdCISgYNvolhTBO51T2bJzxI5mfUxV
         /sEuNDHY/+6UUZbNUyqs2ds0VBdh1pHmgvXrz26tprCyGte01BpbYLjaJjcYmdZIyO
         tQ1tdHfHe1g9NAsYhqBHuujqMutOqlw+m0Mozb5hC7KIba8/4cxzNaT/ja4bPSs4R1
         yAFPI0S/foqmH1q1Hr7tCl/sLla0tjeLsOXZ7NzTBJHaItGMCOAvkmv2Lyv99GU9AD
         27VsL8ZaMr0wQ==
Date:   Tue, 13 Aug 2019 20:01:00 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     linuxppc-dev@ozlabs.org, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH v2 2/3] KVM: PPC: Book3S HV: Don't push XIVE context when not
 using XIVE device
Message-ID: <20190813100100.GC9567@blackberry>
References: <20190813095845.GA9567@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190813095845.GA9567@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At present, when running a guest on POWER9 using HV KVM but not using
an in-kernel interrupt controller (XICS or XIVE), for example if QEMU
is run with the kernel_irqchip=off option, the guest entry code goes
ahead and tries to load the guest context into the XIVE hardware, even
though no context has been set up.

To fix this, we check that the "CAM word" is non-zero before pushing
it to the hardware.  The CAM word is initialized to a non-zero value
in kvmppc_xive_connect_vcpu() and kvmppc_xive_native_connect_vcpu(),
and is now cleared in kvmppc_xive_{,native_}cleanup_vcpu.

Cc: stable@vger.kernel.org # v4.11+
Reported-by: C�dric Le Goater <clg@kaod.org>
Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  2 ++
 arch/powerpc/kvm/book3s_xive.c          | 11 ++++++++++-
 arch/powerpc/kvm/book3s_xive_native.c   |  3 +++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 2e7e788..07181d0 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -942,6 +942,8 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	ld	r11, VCPU_XIVE_SAVED_STATE(r4)
 	li	r9, TM_QW1_OS
 	lwz	r8, VCPU_XIVE_CAM_WORD(r4)
+	cmpwi	r8, 0
+	beq	no_xive
 	li	r7, TM_QW1_OS + TM_WORD2
 	mfmsr	r0
 	andi.	r0, r0, MSR_DR		/* in real mode? */
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 09f838a..586867e 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -67,8 +67,14 @@ void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu)
 	void __iomem *tima = local_paca->kvm_hstate.xive_tima_virt;
 	u64 pq;
 
-	if (!tima)
+	/*
+	 * Nothing to do if the platform doesn't have a XIVE
+	 * or this vCPU doesn't have its own XIVE context
+	 * (e.g. because it's not using an in-kernel interrupt controller).
+	 */
+	if (!tima || !vcpu->arch.xive_cam_word)
 		return;
+
 	eieio();
 	__raw_writeq(vcpu->arch.xive_saved_state.w01, tima + TM_QW1_OS);
 	__raw_writel(vcpu->arch.xive_cam_word, tima + TM_QW1_OS + TM_WORD2);
@@ -1146,6 +1152,9 @@ void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
 	/* Disable the VP */
 	xive_native_disable_vp(xc->vp_id);
 
+	/* Clear the cam word so guest entry won't try to push context */
+	vcpu->arch.xive_cam_word = 0;
+
 	/* Free the queues */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		struct xive_q *q = &xc->queues[i];
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 368427f..11b91b4 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -81,6 +81,9 @@ void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu)
 	/* Disable the VP */
 	xive_native_disable_vp(xc->vp_id);
 
+	/* Clear the cam word so guest entry won't try to push context */
+	vcpu->arch.xive_cam_word = 0;
+
 	/* Free the queues */
 	for (i = 0; i < KVMPPC_XIVE_Q_COUNT; i++) {
 		kvmppc_xive_native_cleanup_queue(vcpu, i);
-- 
2.7.4

