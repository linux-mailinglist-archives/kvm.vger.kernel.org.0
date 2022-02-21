Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183B64BD6ED
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 08:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346273AbiBUHdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 02:33:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346252AbiBUHcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 02:32:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E745C5FC9;
        Sun, 20 Feb 2022 23:32:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRvJPhZU7IQ3R75KFRYaorbpUnQf8puadR4yDCpBzWU3WxW5wDaMGSoKqpwCSPhNjUaQvNXth8myNR5Mi74/TuMU2A8qEfypYYa2XWKAAV9NVkwJ1Ky1iJd+Ulzao1obhCrJwul40/CyDc9pB+Lrz+tRxLHbsMNmcocHwXoVqg7GwaVkatFZIzN4s8kpFaZKR0ugaJShH0lSkc1Z4I3WFRjJWwKyftLHdNcYp5+ctN/rqQbPR18vnT3rr4FVIG6ojksYuokCUXEQyz7JQF9J1DqcO2d/CzdpRIxClMArCWocYJsNf1hZd6kUFtMdVx+WDHHE/iM3ZDBOACoLQinFWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EG8FqGss6EGGYrNu4VjNR1eqZlEyoEJpDyxuvYKAn+k=;
 b=VsxXZDmptZyueyqF8wRF78N1e3fFr9YzmDLo7Q823HfClzheDcAvLVXmDFUATWB2/M9f2kUrrg10Sz/kbRGhxfMhfMngb2cf/ORUoikRbk8xM2OfdYmrTo0ZrZaljVZMRkTXpKYDMOLBK+wwhRp4QTR5j8k7JezjeaS8iIsGKLub3NWgMHojpj2+PeNoVFRDqGk/u9OElXxugyoTPpOdcXQrCk+eJucrqY1ms0g9dX/1eVlgY+A4stnqmphK2zsL7X3p9EolhP9ovdzI2eCJ2AlD1h0zuQSxGsucmDe9dsOxCXkbYkvvuUdjtzdkpMbIPH9qvRVve7ObBFkZJVnY0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EG8FqGss6EGGYrNu4VjNR1eqZlEyoEJpDyxuvYKAn+k=;
 b=VtoS4ObhaT34CJ13hW6HMwTW6y5c2DIfrsH7zKdJFV1VRQoVJbHo/VL5Vb8oKJ6iJKdqNrhWVntu0u61wCozHhlPHtghmU5fkzMbgVutyKJKqTcaC5B/Wbm6S7+vH4S2cqAPtGk9iYjCEg5sRRNCBWnrpdWp23NOvdUnDSmdzr0=
Received: from DM6PR13CA0039.namprd13.prod.outlook.com (2603:10b6:5:134::16)
 by MWHPR12MB1229.namprd12.prod.outlook.com (2603:10b6:300:11::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 07:32:28 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::7) by DM6PR13CA0039.outlook.office365.com
 (2603:10b6:5:134::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Mon, 21 Feb 2022 07:32:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 07:32:27 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 21 Feb
 2022 01:32:18 -0600
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
Subject: [PATCH 1/3] x86/pmu: Add INTEL_ prefix in some Intel specific macros
Date:   Mon, 21 Feb 2022 13:01:38 +0530
Message-ID: <20220221073140.10618-2-ravi.bangoria@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: eafdf28d-c2ff-4e36-1ba8-08d9f50c4fee
X-MS-TrafficTypeDiagnostic: MWHPR12MB1229:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB122914CDFFD75120F1851D83E03A9@MWHPR12MB1229.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbbwjTW7jGktezNIUk+KeIJPCSpJ+pxcpI4OB71d0OrTXqaBEn65mGD77NOmueR9a1Mealo+/sX5IdFjJAy8p7XyHFlb+1MYG3wG8rABWnNhvfZCm7eIEaCWlh500/t1WpOS4ez37fCKEY6XsoAS6FJoNJnt6XBjulehBi492IYJHnJImmTkNmzWogN0nbwWxfcEI+PxQ8saxuLOWf+c8dO6McXx+KubBrGn6oRraqvFs2jpqdsxoGSqaxv56lPff6wXJfk6008pkTAyeZa9uZUgDbQQccDtWTReiKSYmo9xtCz/iq8jKkiXkQ/U1n4GxSzSlBvuyM0Is8sLq27TvulUCzbTCOkzMC/7YqeatJRSOnxu5EyYH38DvIkb343GJsGVYk8TOYgY/B5sOTDlexnc8/TLq/yQ2V/fP7BWbOhPnXrnU9Hq0V+2rvYgCGeOdEb2Rv6JYUWRWdsMTXBOOZjvNlsJH+89DNLSSBDs91JmkOOlkbu4bK/StMK23wWzKq3MrkeFfiN8e9x2lehJHrTJBV9JccZG/diV9naL186OwnG9NZDtEX4RtXTe1/f/4uzhvS1PFZfqUrryNxmbViCyFYvtQADM5lxqzZ2dM6MdasKMWbUGf07MPMOGtMlMZEJXer6hDL1w2echoBYgsv0Jrn3GuZ+sH5G4ra1F4LtEyxCv0hazfuG26eGmocqHryPO4o3FZ73Vi264LQJ/sQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36860700001)(7696005)(6666004)(508600001)(5660300002)(36756003)(8936002)(44832011)(7416002)(2906002)(82310400004)(70206006)(70586007)(86362001)(8676002)(4326008)(54906003)(16526019)(2616005)(83380400001)(40460700003)(81166007)(316002)(6916009)(426003)(356005)(336012)(1076003)(186003)(26005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 07:32:27.8115
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eafdf28d-c2ff-4e36-1ba8-08d9f50c4fee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1229
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace:
  s/HSW_IN_TX/INTEL_HSW_IN_TX/
  s/HSW_IN_TX_CHECKPOINTED/INTEL_HSW_IN_TX_CHECKPOINTED/
  s/ICL_EVENTSEL_ADAPTIVE/INTEL_ICL_EVENTSEL_ADAPTIVE/
  s/ICL_FIXED_0_ADAPTIVE/INTEL_ICL_FIXED_0_ADAPTIVE/

No functionality changes.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/events/intel/core.c      | 12 ++++++------
 arch/x86/events/intel/ds.c        |  2 +-
 arch/x86/events/perf_event.h      |  2 +-
 arch/x86/include/asm/perf_event.h | 12 ++++++------
 arch/x86/kvm/pmu.c                | 14 +++++++-------
 arch/x86/kvm/vmx/pmu_intel.c      |  2 +-
 6 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a3c7ca876aeb..9a72fd8ddab9 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2359,7 +2359,7 @@ static inline void intel_pmu_ack_status(u64 ack)
 
 static inline bool event_is_checkpointed(struct perf_event *event)
 {
-	return unlikely(event->hw.config & HSW_IN_TX_CHECKPOINTED) != 0;
+	return unlikely(event->hw.config & INTEL_HSW_IN_TX_CHECKPOINTED) != 0;
 }
 
 static inline void intel_set_masks(struct perf_event *event, int idx)
@@ -2717,8 +2717,8 @@ static void intel_pmu_enable_fixed(struct perf_event *event)
 	mask = 0xfULL << (idx * 4);
 
 	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip) {
-		bits |= ICL_FIXED_0_ADAPTIVE << (idx * 4);
-		mask |= ICL_FIXED_0_ADAPTIVE << (idx * 4);
+		bits |= INTEL_ICL_FIXED_0_ADAPTIVE << (idx * 4);
+		mask |= INTEL_ICL_FIXED_0_ADAPTIVE << (idx * 4);
 	}
 
 	rdmsrl(hwc->config_base, ctrl_val);
@@ -4000,14 +4000,14 @@ static int hsw_hw_config(struct perf_event *event)
 		return ret;
 	if (!boot_cpu_has(X86_FEATURE_RTM) && !boot_cpu_has(X86_FEATURE_HLE))
 		return 0;
-	event->hw.config |= event->attr.config & (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED);
+	event->hw.config |= event->attr.config & (INTEL_HSW_IN_TX|INTEL_HSW_IN_TX_CHECKPOINTED);
 
 	/*
 	 * IN_TX/IN_TX-CP filters are not supported by the Haswell PMU with
 	 * PEBS or in ANY thread mode. Since the results are non-sensical forbid
 	 * this combination.
 	 */
-	if ((event->hw.config & (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED)) &&
+	if ((event->hw.config & (INTEL_HSW_IN_TX|INTEL_HSW_IN_TX_CHECKPOINTED)) &&
 	     ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) ||
 	      event->attr.precise_ip > 0))
 		return -EOPNOTSUPP;
@@ -4050,7 +4050,7 @@ hsw_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
 	c = intel_get_event_constraints(cpuc, idx, event);
 
 	/* Handle special quirk on in_tx_checkpointed only in counter 2 */
-	if (event->hw.config & HSW_IN_TX_CHECKPOINTED) {
+	if (event->hw.config & INTEL_HSW_IN_TX_CHECKPOINTED) {
 		if (c->idxmsk64 & (1U << 2))
 			return &counter2_constraint;
 		return &emptyconstraint;
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 2e215369df4a..9f1c419f401d 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1225,7 +1225,7 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 		cpuc->pebs_enabled |= 1ULL << 63;
 
 	if (x86_pmu.intel_cap.pebs_baseline) {
-		hwc->config |= ICL_EVENTSEL_ADAPTIVE;
+		hwc->config |= INTEL_ICL_EVENTSEL_ADAPTIVE;
 		if (cpuc->pebs_data_cfg != cpuc->active_pebs_data_cfg) {
 			wrmsrl(MSR_PEBS_DATA_CFG, cpuc->pebs_data_cfg);
 			cpuc->active_pebs_data_cfg = cpuc->pebs_data_cfg;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 150261d929b9..e789b390d90c 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -410,7 +410,7 @@ struct cpu_hw_events {
  *  The other filters are supported by fixed counters.
  *  The any-thread option is supported starting with v3.
  */
-#define FIXED_EVENT_FLAGS (X86_RAW_EVENT_MASK|HSW_IN_TX|HSW_IN_TX_CHECKPOINTED)
+#define FIXED_EVENT_FLAGS (X86_RAW_EVENT_MASK|INTEL_HSW_IN_TX|INTEL_HSW_IN_TX_CHECKPOINTED)
 #define FIXED_EVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, (1ULL << (32+n)), FIXED_EVENT_FLAGS)
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8fc1b5003713..002e67661330 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -30,10 +30,10 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
-#define HSW_IN_TX					(1ULL << 32)
-#define HSW_IN_TX_CHECKPOINTED				(1ULL << 33)
-#define ICL_EVENTSEL_ADAPTIVE				(1ULL << 34)
-#define ICL_FIXED_0_ADAPTIVE				(1ULL << 32)
+#define INTEL_HSW_IN_TX					(1ULL << 32)
+#define INTEL_HSW_IN_TX_CHECKPOINTED			(1ULL << 33)
+#define INTEL_ICL_EVENTSEL_ADAPTIVE			(1ULL << 34)
+#define INTEL_ICL_FIXED_0_ADAPTIVE			(1ULL << 32)
 
 #define AMD64_EVENTSEL_INT_CORE_ENABLE			(1ULL << 36)
 #define AMD64_EVENTSEL_GUESTONLY			(1ULL << 40)
@@ -79,8 +79,8 @@
 	 ARCH_PERFMON_EVENTSEL_CMASK | 		\
 	 ARCH_PERFMON_EVENTSEL_ANY | 		\
 	 ARCH_PERFMON_EVENTSEL_PIN_CONTROL | 	\
-	 HSW_IN_TX | 				\
-	 HSW_IN_TX_CHECKPOINTED)
+	 INTEL_HSW_IN_TX |			\
+	 INTEL_HSW_IN_TX_CHECKPOINTED)
 #define AMD64_RAW_EVENT_MASK		\
 	(X86_RAW_EVENT_MASK          |  \
 	 AMD64_EVENTSEL_EVENT)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b1a02993782b..4a70380f2287 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -117,15 +117,15 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
 	if (in_tx)
-		attr.config |= HSW_IN_TX;
+		attr.config |= INTEL_HSW_IN_TX;
 	if (in_tx_cp) {
 		/*
-		 * HSW_IN_TX_CHECKPOINTED is not supported with nonzero
+		 * INTEL_HSW_IN_TX_CHECKPOINTED is not supported with nonzero
 		 * period. Just clear the sample period so at least
 		 * allocating the counter doesn't fail.
 		 */
 		attr.sample_period = 0;
-		attr.config |= HSW_IN_TX_CHECKPOINTED;
+		attr.config |= INTEL_HSW_IN_TX_CHECKPOINTED;
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
@@ -213,8 +213,8 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
 			  ARCH_PERFMON_EVENTSEL_INV |
 			  ARCH_PERFMON_EVENTSEL_CMASK |
-			  HSW_IN_TX |
-			  HSW_IN_TX_CHECKPOINTED))) {
+			  INTEL_HSW_IN_TX |
+			  INTEL_HSW_IN_TX_CHECKPOINTED))) {
 		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
@@ -233,8 +233,8 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
 			      eventsel & ARCH_PERFMON_EVENTSEL_INT,
-			      (eventsel & HSW_IN_TX),
-			      (eventsel & HSW_IN_TX_CHECKPOINTED));
+			      (eventsel & INTEL_HSW_IN_TX),
+			      (eventsel & INTEL_HSW_IN_TX_CHECKPOINTED));
 }
 EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 466d18fc0c5d..7c64792a9506 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -534,7 +534,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
 	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
-		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
+		pmu->reserved_bits ^= INTEL_HSW_IN_TX|INTEL_HSW_IN_TX_CHECKPOINTED;
 
 	bitmap_set(pmu->all_valid_pmc_idx,
 		0, pmu->nr_arch_gp_counters);
-- 
2.27.0

