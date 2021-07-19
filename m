Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA053CD4E7
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 14:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbhGSL7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 07:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236784AbhGSL7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 07:59:00 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B3D76113C;
        Mon, 19 Jul 2021 12:39:40 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m5SYc-00ED65-Sa; Mon, 19 Jul 2021 13:39:38 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, kernel-team@android.com,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v2 1/4] KVM: arm64: Narrow PMU sysreg reset values to architectural requirements
Date:   Mon, 19 Jul 2021 13:38:59 +0100
Message-Id: <20210719123902.1493805-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719123902.1493805-1-maz@kernel.org>
References: <20210719123902.1493805-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com, drjones@redhat.com, linux@arm.linux.org.uk, kernel-team@android.com, rmk+kernel@armlinux.org.uk
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A number of the PMU sysregs expose reset values that are not
compliant with the architecture (set bits in the RES0 ranges,
for example).

This in turn has the effect that we need to pointlessly mask
some register fields when using them.

Let's start by making sure we don't have illegal values in the
shadow registers at reset time. This affects all the registers
that dedicate one bit per counter, the counters themselves,
PMEVTYPERn_EL0 and PMSELR_EL0.

Reported-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 43 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f6f126eb6ac1..96bdfa0e68b2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -603,6 +603,41 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
+
+	/* No PMU available, any PMU reg may UNDEF... */
+	if (!kvm_arm_support_pmu_v3())
+		return;
+
+	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
+	n &= ARMV8_PMU_PMCR_N_MASK;
+	if (n)
+		mask |= GENMASK(n - 1, 0);
+
+	reset_unknown(vcpu, r);
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
@@ -944,16 +979,18 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
@@ -1595,13 +1632,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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

