Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4268C75300A
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 05:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbjGNDjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 23:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbjGNDjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 23:39:11 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B490726B1
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 20:39:08 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R2HHG72HTzVjhr;
        Fri, 14 Jul 2023 11:37:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 14 Jul 2023 11:39:02 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <maz@kernel.org>, <oliver.upton@linux.dev>, <james.morse@arm.com>
CC:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2] KVM: arm64: Fix the name of sys_reg_desc related to PMU
Date:   Fri, 14 Jul 2023 11:38:40 +0800
Message-ID: <1689305920-170523-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For those PMU system registers defined in sys_reg_descs[], use macro
PMU_SYS_REG() / PMU_PMEVCNTR_EL0 / PMU_PMEVTYPER_EL0 to define them, and
later two macros call macro PMU_SYS_REG() actually.
Currently the input parameter of PMU_SYS_REG() is another macro which is
calculation formula of the value of system registers, so for example, if 
we want to "SYS_PMINTENSET_EL1" as the name of sys register, actually 
the name we get is as following:
(((3) << 19) | ((0) << 16) | ((9) << 12) | ((14) << 8) | ((1) << 5))
The name of system register is used in some tracepoints such as 
trace_kvm_sys_access(), if not set correctly, we need to analyze the
inaccurate name to get the exact name (which also is inconsistent with 
other system registers), and also the inaccurate name occupies more space.

To fix the issue, use the name as a input parameter of PMU_SYS_REG like
MTE_REG or EL2_REG.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 arch/arm64/kvm/sys_regs.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bd34318..0af5f2f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1115,18 +1115,19 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ SYS_DESC(SYS_DBGWCRn_EL1(n)),					\
 	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
-#define PMU_SYS_REG(r)						\
-	SYS_DESC(r), .reset = reset_pmu_reg, .visibility = pmu_visibility
+#define PMU_SYS_REG(name)						\
+	SYS_DESC(SYS_##name), .reset = reset_pmu_reg,			\
+	.visibility = pmu_visibility
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
-	{ PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),				\
+	{ PMU_SYS_REG(PMEVCNTRn_EL0(n)),				\
 	  .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,		\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
 #define PMU_PMEVTYPER_EL0(n)						\
-	{ PMU_SYS_REG(SYS_PMEVTYPERn_EL0(n)),				\
+	{ PMU_SYS_REG(PMEVTYPERn_EL0(n)),				\
 	  .reset = reset_pmevtyper,					\
 	  .access = access_pmu_evtyper, .reg = (PMEVTYPER0_EL0 + n), }
 
@@ -2115,9 +2116,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
 	/* PMBIDR_EL1 is not trapped */
 
-	{ PMU_SYS_REG(SYS_PMINTENSET_EL1),
+	{ PMU_SYS_REG(PMINTENSET_EL1),
 	  .access = access_pminten, .reg = PMINTENSET_EL1 },
-	{ PMU_SYS_REG(SYS_PMINTENCLR_EL1),
+	{ PMU_SYS_REG(PMINTENCLR_EL1),
 	  .access = access_pminten, .reg = PMINTENSET_EL1 },
 	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
 
@@ -2164,41 +2165,41 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
-	{ PMU_SYS_REG(SYS_PMCR_EL0), .access = access_pmcr,
+	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
 	  .reset = reset_pmcr, .reg = PMCR_EL0 },
-	{ PMU_SYS_REG(SYS_PMCNTENSET_EL0),
+	{ PMU_SYS_REG(PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
-	{ PMU_SYS_REG(SYS_PMCNTENCLR_EL0),
+	{ PMU_SYS_REG(PMCNTENCLR_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
-	{ PMU_SYS_REG(SYS_PMOVSCLR_EL0),
+	{ PMU_SYS_REG(PMOVSCLR_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 	/*
 	 * PM_SWINC_EL0 is exposed to userspace as RAZ/WI, as it was
 	 * previously (and pointlessly) advertised in the past...
 	 */
-	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
+	{ PMU_SYS_REG(PMSWINC_EL0),
 	  .get_user = get_raz_reg, .set_user = set_wi_reg,
 	  .access = access_pmswinc, .reset = NULL },
-	{ PMU_SYS_REG(SYS_PMSELR_EL0),
+	{ PMU_SYS_REG(PMSELR_EL0),
 	  .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
-	{ PMU_SYS_REG(SYS_PMCEID0_EL0),
+	{ PMU_SYS_REG(PMCEID0_EL0),
 	  .access = access_pmceid, .reset = NULL },
-	{ PMU_SYS_REG(SYS_PMCEID1_EL0),
+	{ PMU_SYS_REG(PMCEID1_EL0),
 	  .access = access_pmceid, .reset = NULL },
-	{ PMU_SYS_REG(SYS_PMCCNTR_EL0),
+	{ PMU_SYS_REG(PMCCNTR_EL0),
 	  .access = access_pmu_evcntr, .reset = reset_unknown,
 	  .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr},
-	{ PMU_SYS_REG(SYS_PMXEVTYPER_EL0),
+	{ PMU_SYS_REG(PMXEVTYPER_EL0),
 	  .access = access_pmu_evtyper, .reset = NULL },
-	{ PMU_SYS_REG(SYS_PMXEVCNTR_EL0),
+	{ PMU_SYS_REG(PMXEVCNTR_EL0),
 	  .access = access_pmu_evcntr, .reset = NULL },
 	/*
 	 * PMUSERENR_EL0 resets as unknown in 64bit mode while it resets as zero
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
-	{ PMU_SYS_REG(SYS_PMUSERENR_EL0), .access = access_pmuserenr,
+	{ PMU_SYS_REG(PMUSERENR_EL0), .access = access_pmuserenr,
 	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
-	{ PMU_SYS_REG(SYS_PMOVSSET_EL0),
+	{ PMU_SYS_REG(PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
@@ -2354,7 +2355,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * PMCCFILTR_EL0 resets as unknown in 64bit mode while it resets as zero
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
-	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
+	{ PMU_SYS_REG(PMCCFILTR_EL0), .access = access_pmu_evtyper,
 	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
 
 	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
-- 
2.8.1

