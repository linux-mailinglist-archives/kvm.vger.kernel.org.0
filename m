Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32673C71A9
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 15:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbhGMOB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236613AbhGMOB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 10:01:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D297061279;
        Tue, 13 Jul 2021 13:59:06 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m3IwD-00D5p8-3e; Tue, 13 Jul 2021 14:59:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>, kernel-team@android.com
Subject: [PATCH 1/3] KVM: arm64: Narrow PMU sysreg reset values to architectural requirements
Date:   Tue, 13 Jul 2021 14:58:58 +0100
Message-Id: <20210713135900.1473057-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210713135900.1473057-1-maz@kernel.org>
References: <20210713135900.1473057-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A number of the PMU sysregs expose reset values that are not in
compliant with the architecture (set bits in the RES0 ranges,
for example).

This in turn has the effect that we need to pointlessly mask
some register when using them.

Let's start by making sure we don't have illegal values in the
shadow registers at reset time. This affects all the registers
that dedicate one bit per counter, the counters themselves,
PMEVTYPERn_EL0 and PMSELR_EL0.

Reported-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 46 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f6f126eb6ac1..95ccb8f45409 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -603,6 +603,44 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 n, mask;
+
+	/* No PMU available, any PMU reg may UNDEF... */
+	if (!kvm_arm_support_pmu_v3())
+		return;
+
+	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
+	n &= ARMV8_PMU_PMCR_N_MASK;
+
+	reset_unknown(vcpu, r);
+
+	mask = BIT(ARMV8_PMU_CYCLE_IDX);
+	if (n)
+		mask |= GENMASK(n - 1, 0);
+
+	__vcpu_sys_reg(vcpu, r->reg) &= mask;
+}
+
+static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	reset_unknown(vcpu, r);
+	__vcpu_sys_reg(vcpu, r->reg) &= GENMASK(31, 0);
+}
+
+static void reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	reset_unknown(vcpu, r);
+	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_EVTYPE_MASK;
+}
+
+static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	reset_unknown(vcpu, r);
+	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
+}
+
 static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 pmcr, val;
@@ -944,16 +982,18 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
 #define PMU_SYS_REG(r)						\
-	SYS_DESC(r), .reset = reset_unknown, .visibility = pmu_visibility
+	SYS_DESC(r), .reset = reset_pmu_reg, .visibility = pmu_visibility
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
 	{ PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),				\
+	  .reset = reset_pmevcntr,					\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
 #define PMU_PMEVTYPER_EL0(n)						\
 	{ PMU_SYS_REG(SYS_PMEVTYPERn_EL0(n)),				\
+	  .reset = reset_pmevtyper,					\
 	  .access = access_pmu_evtyper, .reg = (PMEVTYPER0_EL0 + n), }
 
 static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
@@ -1595,13 +1635,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
 	  .access = access_pmswinc, .reg = PMSWINC_EL0 },
 	{ PMU_SYS_REG(SYS_PMSELR_EL0),
-	  .access = access_pmselr, .reg = PMSELR_EL0 },
+	  .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
 	{ PMU_SYS_REG(SYS_PMCEID0_EL0),
 	  .access = access_pmceid, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMCEID1_EL0),
 	  .access = access_pmceid, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMCCNTR_EL0),
-	  .access = access_pmu_evcntr, .reg = PMCCNTR_EL0 },
+	  .access = access_pmu_evcntr, .reset = reset_unknown, .reg = PMCCNTR_EL0 },
 	{ PMU_SYS_REG(SYS_PMXEVTYPER_EL0),
 	  .access = access_pmu_evtyper, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMXEVCNTR_EL0),
-- 
2.30.2

