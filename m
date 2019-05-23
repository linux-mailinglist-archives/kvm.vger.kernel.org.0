Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3678D27AD0
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 12:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbfEWKfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 06:35:33 -0400
Received: from foss.arm.com ([217.140.101.70]:43060 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730555AbfEWKfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 06:35:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6D45A78;
        Thu, 23 May 2019 03:35:32 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 932363F718;
        Thu, 23 May 2019 03:35:30 -0700 (PDT)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 05/15] arm64: KVM: add access handler for SPE system registers
Date:   Thu, 23 May 2019 11:34:52 +0100
Message-Id: <20190523103502.25925-6-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523103502.25925-1-sudeep.holla@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SPE Profiling Buffer owning EL is configurable and when MDCR_EL2.E2PB
is configured to provide buffer ownership to EL1, the control registers
are trapped.

Add access handlers for the Statistical Profiling Extension(SPE)
Profiling Buffer controls registers. This is need to support profiling
using SPE in the guests.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 13 ++++++++++++
 arch/arm64/kvm/sys_regs.c         | 35 +++++++++++++++++++++++++++++++
 include/kvm/arm_spe.h             | 15 +++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 611a4884fb6c..559aa6931291 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -147,6 +147,19 @@ enum vcpu_sysreg {
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
 
+	/* Statistical Profiling Extension Registers */
+
+	PMSCR_EL1,
+	PMSICR_EL1,
+	PMSIRR_EL1,
+	PMSFCR_EL1,
+	PMSEVFR_EL1,
+	PMSLATFR_EL1,
+	PMSIDR_EL1,
+	PMBLIMITR_EL1,
+	PMBPTR_EL1,
+	PMBSR_EL1,
+
 	/* Performance Monitors Registers */
 	PMCR_EL0,	/* Control Register */
 	PMSELR_EL0,	/* Event Counter Selection Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 857b226bcdde..dbf5056828d3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -646,6 +646,30 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 }
 
+static bool access_pmsb_val(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
+	else
+		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+
+	return true;
+}
+
+static void reset_pmsb_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	if (!kvm_arm_support_spe_v1()) {
+		__vcpu_sys_reg(vcpu, r->reg) = 0;
+		return;
+	}
+
+	if (r->reg == PMSIDR_EL1)
+		__vcpu_sys_reg(vcpu, r->reg) = read_sysreg_s(SYS_PMSIDR_EL1);
+	else
+		__vcpu_sys_reg(vcpu, r->reg) = 0;
+}
+
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
@@ -1513,6 +1537,17 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
+	{ SYS_DESC(SYS_PMSCR_EL1), access_pmsb_val, reset_pmsb_val, PMSCR_EL1 },
+	{ SYS_DESC(SYS_PMSICR_EL1), access_pmsb_val, reset_pmsb_val, PMSICR_EL1 },
+	{ SYS_DESC(SYS_PMSIRR_EL1), access_pmsb_val, reset_pmsb_val, PMSIRR_EL1 },
+	{ SYS_DESC(SYS_PMSFCR_EL1), access_pmsb_val, reset_pmsb_val, PMSFCR_EL1 },
+	{ SYS_DESC(SYS_PMSEVFR_EL1), access_pmsb_val, reset_pmsb_val, PMSEVFR_EL1},
+	{ SYS_DESC(SYS_PMSLATFR_EL1), access_pmsb_val, reset_pmsb_val, PMSLATFR_EL1 },
+	{ SYS_DESC(SYS_PMSIDR_EL1), access_pmsb_val, reset_pmsb_val, PMSIDR_EL1 },
+	{ SYS_DESC(SYS_PMBLIMITR_EL1), access_pmsb_val, reset_pmsb_val, PMBLIMITR_EL1 },
+	{ SYS_DESC(SYS_PMBPTR_EL1), access_pmsb_val, reset_pmsb_val, PMBPTR_EL1 },
+	{ SYS_DESC(SYS_PMBSR_EL1), access_pmsb_val, reset_pmsb_val, PMBSR_EL1 },
+
 	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
 	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, NULL, PMINTENSET_EL1 },
 
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
index 8c96bdfad6ac..2440ff02f747 100644
--- a/include/kvm/arm_spe.h
+++ b/include/kvm/arm_spe.h
@@ -8,6 +8,7 @@
 
 #include <uapi/linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/cpufeature.h>
 
 struct kvm_spe {
 	int irq;
@@ -15,4 +16,18 @@ struct kvm_spe {
 	bool created; /* SPE KVM instance is created, may not be ready yet */
 };
 
+#ifdef CONFIG_KVM_ARM_SPE
+
+static inline bool kvm_arm_support_spe_v1(void)
+{
+	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+
+	return !!cpuid_feature_extract_unsigned_field(dfr0,
+						      ID_AA64DFR0_PMSVER_SHIFT);
+}
+#else
+
+#define kvm_arm_support_spe_v1()	(false)
+#endif /* CONFIG_KVM_ARM_SPE */
+
 #endif /* __ASM_ARM_KVM_SPE_H */
-- 
2.17.1

