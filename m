Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D107DD7D1
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2019 11:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfJSJzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Oct 2019 05:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfJSJzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Oct 2019 05:55:39 -0400
Received: from big-swifty.lan (78.163-31-62.static.virginmediabusiness.co.uk [62.31.163.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6253F222D2;
        Sat, 19 Oct 2019 09:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571478938;
        bh=/BHwWAb8kea1kN6CGDZVKU3zOASIcTMHmEllourGtwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nt2VeCabzxc0pbTpxeH9OCZsa/doEDq5b0S3kx1dh0zgew5lOfs0BZSS10XrMJGxF
         ATKHsPCMXuH64Z+pzkieG6fJbLo0A/4ZqJ2mp2HtoB4jQL2UqhS5kgpzDnWKhh0a7t
         E3o9P/0JxOICBWnkSwABYA1U25SPUUnH7DRQ+jno=
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH v2 4/5] arm64: KVM: Prevent speculative S1 PTW when restoring vcpu context
Date:   Sat, 19 Oct 2019 10:55:20 +0100
Message-Id: <20191019095521.31722-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191019095521.31722-1-maz@kernel.org>
References: <20191019095521.31722-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When handling erratum 1319367, we must ensure that the page table
walker cannot parse the S1 page tables while the guest is in an
inconsistent state. This is done as follows:

On guest entry:
- TCR_EL1.EPD{0,1} are set, ensuring that no PTW can occur
- all system registers are restored, except for TCR_EL1 and SCTLR_EL1
- stage-2 is restored
- SCTLR_EL1 and TCR_EL1 are restored

On guest exit:
- SCTLR_EL1.M and TCR_EL1.EPD{0,1} are set, ensuring that no PTW can occur
- stage-2 is disabled
- All host system registers are restored

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/switch.c    | 31 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c | 35 ++++++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 69e10b29cbd0..5765b17c38c7 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -118,6 +118,20 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 	}
 
 	write_sysreg(val, cptr_el2);
+
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
+		struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+
+		isb();
+		/*
+		 * At this stage, and thanks to the above isb(), S2 is
+		 * configured and enabled. We can now restore the guest's S1
+		 * configuration: SCTLR, and only then TCR.
+		 */
+		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+		isb();
+		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
+	}
 }
 
 static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
@@ -156,6 +170,23 @@ static void __hyp_text __deactivate_traps_nvhe(void)
 {
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
+		u64 val;
+
+		/*
+		 * Set the TCR and SCTLR registers in the exact opposite
+		 * sequence as __activate_traps_nvhe (first prevent walks,
+		 * then force the MMU on). A generous sprinkling of isb()
+		 * ensure that things happen in this exact order.
+		 */
+		val = read_sysreg_el1(SYS_TCR);
+		write_sysreg_el1(val | TCR_EPD1_MASK | TCR_EPD0_MASK, SYS_TCR);
+		isb();
+		val = read_sysreg_el1(SYS_SCTLR);
+		write_sysreg_el1(val | SCTLR_ELx_M, SYS_SCTLR);
+		isb();
+	}
+
 	__deactivate_traps_common();
 
 	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 7ddbc849b580..fb97547bfa79 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -117,12 +117,26 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
-	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+
+	if (!cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
+		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
+	} else	if (!ctxt->__hyp_running_vcpu) {
+		/*
+		 * Must only be done for guest registers, hence the context
+		 * test. We'recoming from the host, so SCTLR.M is already
+		 * set. Pairs with __activate_traps_nvhe().
+		 */
+		write_sysreg_el1((ctxt->sys_regs[TCR_EL1] |
+				  TCR_EPD1_MASK | TCR_EPD0_MASK),
+				 SYS_TCR);
+		isb();
+	}
+
 	write_sysreg(ctxt->sys_regs[ACTLR_EL1],		actlr_el1);
 	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	SYS_CPACR);
 	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
 	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
-	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
 	write_sysreg_el1(ctxt->sys_regs[ESR_EL1],	SYS_ESR);
 	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL1],	SYS_AFSR0);
 	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL1],	SYS_AFSR1);
@@ -135,6 +149,23 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
 	write_sysreg(ctxt->sys_regs[TPIDR_EL1],		tpidr_el1);
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367) &&
+	    ctxt->__hyp_running_vcpu) {
+		/*
+		 * Must only be done for host registers, hence the context
+		 * test. Pairs with __deactivate_traps_nvhe().
+		 */
+		isb();
+		/*
+		 * At this stage, and thanks to the above isb(), S2 is
+		 * deconfigured and disabled. We can now restore the host's
+		 * S1 configuration: SCTLR, and only then TCR.
+		 */
+		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+		isb();
+		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
+	}
+
 	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
 	write_sysreg_el1(ctxt->gp_regs.elr_el1,		SYS_ELR);
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],SYS_SPSR);
-- 
2.20.1

