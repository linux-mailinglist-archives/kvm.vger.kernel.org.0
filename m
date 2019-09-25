Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC869BDCE7
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 13:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391027AbfIYLUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 07:20:02 -0400
Received: from foss.arm.com ([217.140.110.172]:46910 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391014AbfIYLUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 07:20:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 640D91596;
        Wed, 25 Sep 2019 04:20:01 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B51B3F694;
        Wed, 25 Sep 2019 04:20:00 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH 4/5] arm64: KVM: Prevent speculative S1 PTW when restoring vcpu context
Date:   Wed, 25 Sep 2019 12:19:40 +0100
Message-Id: <20190925111941.88103-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925111941.88103-1-maz@kernel.org>
References: <20190925111941.88103-1-maz@kernel.org>
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
 arch/arm64/kvm/hyp/switch.c    | 31 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c | 14 ++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index e6adb90c12ae..4df47d013bec 100644
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
index 7ddbc849b580..adabdceacc10 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -117,12 +117,22 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
-	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+
+	/* Must only be done for guest registers, hence the context test */
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367) &&
+	    !ctxt->__hyp_running_vcpu) {
+		write_sysreg_el1(ctxt->sys_regs[TCR_EL1] |
+				 TCR_EPD1_MASK | TCR_EPD0_MASK,	SYS_TCR);
+		isb();
+	} else {
+		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
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
-- 
2.20.1

