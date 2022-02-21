Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F794BD71E
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 08:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346278AbiBUHdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 02:33:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346245AbiBUHdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 02:33:07 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9D1AE5F;
        Sun, 20 Feb 2022 23:32:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftFgSLxqQQ7mRHwBkPIG9eAgQQ8RGrnt+n5s+54QF6BRy1T6X2LJuDkK8WsD0C3rvyeAasDvYRxMfsnwpjPeR7ECYBr9RKzjDaENsdf1bhWKcSGUO9BiwmtuydfiifEbWtp4rJE0LwMRvVvFvieZGJ8SXWRo1C6RTSrd0ocfK6ATTWTwCiis8zU/Ofxu5bS5I1C/r7Ackcbc1l1jMFIm9rv8tcpDOgriMQ/Ikk12Nnjt/HM4Cb2yY3MeKpnSTZCQ7pLK1apSxSVXjKOEyPocx3HzfLKPSO1SQavU0rJnLJSCejVs2GrcGTq1XcZrZjp/M6hEBTes4ZFtVROPCbqXRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHJLSnrh8JKgCGFK481RScnF0FkxClmg6QBlRegZT64=;
 b=a0ibxEkaq7Z2DROrDn1J5Ci2LGqfHgwD5ywbGkrD4aiJZo1DinN2Npibw8ONLapR4qycW8ETdhdEPpO5ivWe46w+fJacmtQPQsLVrxQc57NPccx/vrmnNCvtBJqHllg2jEzJU2kqLOJ62P/W8M3UlNp4CGI7PRyz5iHVSos2BUACrC6h3/aRIU8ckVQMBWjzpeL6MGhSBGtOhCBbb5n4dEn2wQFJXEPTmflGyZS4tSc94aniaSzS0mT60lMdwD9eJcejGgl8DC4IJpJUb8JSgGNW238Tm6xbxcMo2V8GvOf4gXuvK6pbaZUJTRhLEvf4fHu8gTBRM4HHnmaN2T/UaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHJLSnrh8JKgCGFK481RScnF0FkxClmg6QBlRegZT64=;
 b=n+kzUOpZAxgEa7FyO7pSaaFw3cRTg00ZisNiHgSv4cblxVDrVi3uTDNz3bwbAGcjuJVZeXrhjYSNP1lIurYVB/ORYaKnbyhfvBiGWcOP+MtzAavWfl13ZVB3OveijDLaqFXyhJxcMe6t+Y+P5jZXQP0RF+bcR6uJ++9ZbZ1RSZs=
Received: from DM5PR20CA0004.namprd20.prod.outlook.com (2603:10b6:3:93::14) by
 MWHPR1201MB2493.namprd12.prod.outlook.com (2603:10b6:300:ec::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.25; Mon, 21 Feb
 2022 07:32:37 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:93:cafe::f1) by DM5PR20CA0004.outlook.office365.com
 (2603:10b6:3:93::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12 via Frontend
 Transport; Mon, 21 Feb 2022 07:32:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 07:32:37 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 21 Feb
 2022 01:32:30 -0600
From:   Ravi Bangoria <ravi.bangoria@amd.com>
To:     <pbonzini@redhat.com>
CC:     <ravi.bangoria@amd.com>, <seanjc@google.com>,
        <jmattson@google.com>, <dave.hansen@linux.intel.com>,
        <peterz@infradead.org>, <alexander.shishkin@linux.intel.com>,
        <eranian@google.com>, <daviddunn@google.com>, <ak@linux.intel.com>,
        <kan.liang@linux.intel.com>, <like.xu.linux@gmail.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kim.phillips@amd.com>,
        <santosh.shukla@amd.com>
Subject: [PATCH 3/3] KVM: x86/pmu: Segregate Intel and AMD specific logic
Date:   Mon, 21 Feb 2022 13:01:40 +0530
Message-ID: <20220221073140.10618-4-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221073140.10618-1-ravi.bangoria@amd.com>
References: <20220221073140.10618-1-ravi.bangoria@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 196231f9-3bf2-4168-82df-08d9f50c559d
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2493:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB2493698516C081E90F917D93E03A9@MWHPR1201MB2493.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dpMV+h5YmF9zxNc0bpWFTp/6NB5VVpPb6ZkAKRfbx4oyZOfYo4X6RkoKvcKszKtNFWqTH7QzT5RtsUR48urYm4wmQXyXNOybuN3DZLec/avLmGULL7I+6ndHaOtTurRSPcYCpQ4UZvh1NVpoYnnkwFDXSOPjEAYuiSduGbkdI9cEDepmQ+uvYDe7ZNRqp4bgJPVqutvwemLRgMNYoDU7XuvxyXwvjHiUBnfLLQ7OywYm+sPNmx4sMaNKomBo6d6XjYGYAQoK+cskk4nhvAA1j8LSprtJ766R/oB6xLyhZzx14zgvA9rCsAZuuT7jMiBsZuHZ/Qm+4ZQcVo6IvLAtk33XHx8cc29XlrsnX3qfB0XcE6RWhwUpGDeKzOQkRoLvkp7u39lFfJDNiQJUSDu6IwP31urob349twkLEFLeozuP9Uzu+3nzRL5jSX34vo+RDLkNh73mPpxT62q/A7vsbDUQThhLrfmNnn/ll1wSSA5+NO3JvtNTwvQ+jMMmj7ZZCoLufnQBSevmTrxa91IzWVwPRDhblhFNoc3Fn36I6TEfwtakUQ35lQT5yRsQOIA9IAioLX3ND1JS6Eq2w09kDzmmWXYScd0TSL8NQrpzTq/oPz9WVQmc7DIWcidBHoYyf+z+3kq+xCmJw3xuy8VCSWhUF1bfdCmgD086+CfsvNHp5SIJ8ImFWsxK4RH40Pwr4RtAvcL3yTjKnDg/sX/KJg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(54906003)(6916009)(1076003)(8936002)(26005)(7416002)(16526019)(186003)(5660300002)(70206006)(70586007)(83380400001)(4326008)(8676002)(356005)(82310400004)(426003)(316002)(44832011)(86362001)(336012)(81166007)(508600001)(7696005)(36756003)(6666004)(40460700003)(2906002)(2616005)(36860700001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 07:32:37.3497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 196231f9-3bf2-4168-82df-08d9f50c559d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HSW_IN_TX* bits are used in generic code which are not supported on
AMD. Worse, these bits overlap with AMD EventSelect[11:8] and hence
using HSW_IN_TX* bits unconditionally in generic code is resulting in
unintentional pmu behavior on AMD. For example, if EventSelect[11:8]
is 0x2, pmc_reprogram_counter() wrongly assumes that
HSW_IN_TX_CHECKPOINTED is set and thus forces sampling period to be 0.

Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kvm/pmu.c           | 66 +++++++++++++++++++++++-------------
 arch/x86/kvm/pmu.h           |  4 +--
 arch/x86/kvm/svm/pmu.c       |  6 +++-
 arch/x86/kvm/vmx/pmu_intel.c |  4 +--
 4 files changed, 51 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 4a70380f2287..b91dbede87b3 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -97,7 +97,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  u64 config, bool exclude_user,
 				  bool exclude_kernel, bool intr,
-				  bool in_tx, bool in_tx_cp)
+				  bool in_tx, bool in_tx_cp, bool is_intel)
 {
 	struct perf_event *event;
 	struct perf_event_attr attr = {
@@ -116,16 +116,18 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
-	if (in_tx)
-		attr.config |= INTEL_HSW_IN_TX;
-	if (in_tx_cp) {
-		/*
-		 * INTEL_HSW_IN_TX_CHECKPOINTED is not supported with nonzero
-		 * period. Just clear the sample period so at least
-		 * allocating the counter doesn't fail.
-		 */
-		attr.sample_period = 0;
-		attr.config |= INTEL_HSW_IN_TX_CHECKPOINTED;
+	if (is_intel) {
+		if (in_tx)
+			attr.config |= INTEL_HSW_IN_TX;
+		if (in_tx_cp) {
+			/*
+			 * INTEL_HSW_IN_TX_CHECKPOINTED is not supported with nonzero
+			 * period. Just clear the sample period so at least
+			 * allocating the counter doesn't fail.
+			 */
+			attr.sample_period = 0;
+			attr.config |= INTEL_HSW_IN_TX_CHECKPOINTED;
+		}
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
@@ -179,13 +181,14 @@ static int cmp_u64(const void *a, const void *b)
 	return *(__u64 *)a - *(__u64 *)b;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
+void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel, bool is_intel)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	bool allow_event = true;
+	u64 eventsel_mask;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
@@ -210,18 +213,31 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	if (!allow_event)
 		return;
 
-	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
-			  ARCH_PERFMON_EVENTSEL_INV |
-			  ARCH_PERFMON_EVENTSEL_CMASK |
-			  INTEL_HSW_IN_TX |
-			  INTEL_HSW_IN_TX_CHECKPOINTED))) {
+	eventsel_mask = ARCH_PERFMON_EVENTSEL_EDGE |
+			ARCH_PERFMON_EVENTSEL_INV |
+			ARCH_PERFMON_EVENTSEL_CMASK;
+	if (is_intel) {
+		eventsel_mask |= INTEL_HSW_IN_TX | INTEL_HSW_IN_TX_CHECKPOINTED;
+	} else {
+		/*
+		 * None of the AMD generalized events has EventSelect[11:8]
+		 * set so far.
+		 */
+		eventsel_mask |= (0xFULL << 32);
+	}
+
+	if (!(eventsel & eventsel_mask)) {
 		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
 	}
 
-	if (type == PERF_TYPE_RAW)
-		config = eventsel & AMD64_RAW_EVENT_MASK;
+	if (type == PERF_TYPE_RAW) {
+		if (is_intel)
+			config = eventsel & X86_RAW_EVENT_MASK;
+		else
+			config = eventsel & AMD64_RAW_EVENT_MASK;
+	}
 
 	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
 		return;
@@ -234,11 +250,12 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
 			      eventsel & ARCH_PERFMON_EVENTSEL_INT,
 			      (eventsel & INTEL_HSW_IN_TX),
-			      (eventsel & INTEL_HSW_IN_TX_CHECKPOINTED));
+			      (eventsel & INTEL_HSW_IN_TX_CHECKPOINTED),
+			      is_intel);
 }
 EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
-void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
+void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx, bool is_intel)
 {
 	unsigned en_field = ctrl & 0x3;
 	bool pmi = ctrl & 0x8;
@@ -270,24 +287,25 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 			      kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
-			      pmi, false, false);
+			      pmi, false, false, is_intel);
 }
 EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 {
 	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
+	bool is_intel = !strncmp(kvm_x86_ops.name, "kvm_intel", 9);
 
 	if (!pmc)
 		return;
 
 	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc, pmc->eventsel);
+		reprogram_gp_counter(pmc, pmc->eventsel, is_intel);
 	else {
 		int idx = pmc_idx - INTEL_PMC_IDX_FIXED;
 		u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
 
-		reprogram_fixed_counter(pmc, ctrl, idx);
+		reprogram_fixed_counter(pmc, ctrl, idx, is_intel);
 	}
 }
 EXPORT_SYMBOL_GPL(reprogram_counter);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..610a4cbf85a4 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -140,8 +140,8 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
-void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
+void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel, bool is_intel);
+void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx, bool is_intel);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 5aa45f13b16d..9ad63e940883 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -140,6 +140,10 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 
 static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
 {
+	/*
+	 * None of the AMD generalized events has EventSelect[11:8] set.
+	 * Hence 8 bit event_select works for now.
+	 */
 	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
@@ -265,7 +269,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data == pmc->eventsel)
 			return 0;
 		if (!(data & pmu->reserved_bits)) {
-			reprogram_gp_counter(pmc, data);
+			reprogram_gp_counter(pmc, data, false);
 			return 0;
 		}
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7c64792a9506..ba1fbd37f608 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -50,7 +50,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 			continue;
 
 		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
-		reprogram_fixed_counter(pmc, new_ctrl, i);
+		reprogram_fixed_counter(pmc, new_ctrl, i, true);
 	}
 
 	pmu->fixed_ctr_ctrl = data;
@@ -444,7 +444,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (data == pmc->eventsel)
 				return 0;
 			if (!(data & pmu->reserved_bits)) {
-				reprogram_gp_counter(pmc, data);
+				reprogram_gp_counter(pmc, data, true);
 				return 0;
 			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-- 
2.27.0

