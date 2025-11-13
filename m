Return-Path: <kvm+bounces-62980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BB546C55EA1
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ADBC14E467F
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0B3320A01;
	Thu, 13 Nov 2025 06:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S2awM+d6"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012053.outbound.protection.outlook.com [40.107.209.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAA2320380;
	Thu, 13 Nov 2025 06:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763014793; cv=fail; b=QfAItUMBU9gn7L/DDsDQDoe6+0M0Qr/3JEXdJLzh5fKF3/dnZW/EaTkjnPHPM8sKA4Whqc8FlerA/hcs71sE89yyOWACGi/ZyY8XNNXZrOpQjwdTFSy5cUlNmCIB2OSFlajgb/51vqLHirljoVBFPWCU3a7sGYeZxrBqK4dlBGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763014793; c=relaxed/simple;
	bh=7HrY2Y78nY/aUpKH3MQyQRYv7nu13IkwV66xK99BCP4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bjjp9EiMiFDk21VvJPk2vGwgLKWJNKhybv4PbarFhanHw0v2JPUnpXbX4Deo0EBf7zJ6h7lqxPBv7HNVMm3R1ZjGHUkRFWWRKzD93wocS/xYTVZqWFY9gcJ0ufvT+yPX+s4uHiBJ2ZvOoHle0cy8L8YzRM5yyx5ILVQqmRhYxoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S2awM+d6; arc=fail smtp.client-ip=40.107.209.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fiH0hA3n2IuvTddWswr1pCkPU9mlyEmX1VHmFPElZaJ6hhR3wqnA38wSPNb+qCr5zR0MPB3/j+oHJN0VBZ4qZ1iLQif3hpzs6CmdP1UsCVPEgYX7H4DL6dRix8lnJ/BHcjUe8ferMeMLz+zSJpQZFXs8W4itYHhGrPoH6uIChbwDIo/1wMLa7V3hEQQIPekAKlZoD5hirThtuvjo/EiRtusFQojYTxPcKgh/hdpaBj+gwHIC1edv+IN5fvBIiCVfqyy57IPFEZFyHxoGOB9Mn0h9CQ6y8lXBkquudhvS3jJPZ1ABWHbBcHC5r9nB7ffZh357RZhJR+vd/N1Aa2yUaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/APn2eodms4av0YtzjF6ztToMYnvKBFJK/A8Gt1AFV4=;
 b=HWuojwNqek8o0F6UCOslkcX2rJGHsB89aGlI4OhzzKVbb7x8UHtJswlol3LhMOSa3ySq8vXwTUOTYQAlFKm3K5mPBWAXOEfmJLdO+49HIrO0ztOqOvExAnW2x6OGLYuJAsKf3teXteXaX/5SY+aHzgUKRTiOEBBfgt5VP/cljETYwQYIiRvqePP0FbFRIhvDKjOCovslqKOrQ3WkIT1a2NxpVfjFt1DQTm/CmmTSNoPtedKWut7+V9Mv0kGjjN8UZo8m07UWagmYD/Ankc8zVI6LAW8O8gEKAXaLZ03tJL+zgdtA0AzRcuWmQ1bDVNfnHmC7rg46k7JNJkLJwmofRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/APn2eodms4av0YtzjF6ztToMYnvKBFJK/A8Gt1AFV4=;
 b=S2awM+d6Sv0lNfsopjH9xd9J+Y50c+i4oX7tMdwGeswY8Jg7SkyXidgXAKueZ7AzJKOlIGJXqeeqF8LQcQLgklgsO0OogDRwwjcrdhDSFwmZ7VqMwSdeboMXXuzK6fVHupSMfzt5kCt07yYGW9xE75cNt7pIEWx+6FWwcy67+bI=
Received: from CY8PR10CA0022.namprd10.prod.outlook.com (2603:10b6:930:4f::23)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Thu, 13 Nov
 2025 06:19:47 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:930:4f:cafe::94) by CY8PR10CA0022.outlook.office365.com
 (2603:10b6:930:4f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 06:19:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 06:19:47 +0000
Received: from sindhu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 22:19:41 -0800
From: Sandipan Das <sandipan.das@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Kan Liang
	<kan.liang@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, "Manali
 Shukla" <manali.shukla@amd.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
	"Ananth Narayan" <ananth.narayan@amd.com>, Sandipan Das
	<sandipan.das@amd.com>
Subject: [RFC PATCH 4/7] KVM: x86/pmu: Add support for hardware virtualized PMUs
Date: Thu, 13 Nov 2025 11:48:24 +0530
Message-ID: <b83d93a3e677fecdbdd2c159e85de4bca2165b79.1762960531.git.sandipan.das@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762960531.git.sandipan.das@amd.com>
References: <cover.1762960531.git.sandipan.das@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: 448ed4e1-184d-494a-bd95-08de227ca4e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0/dtl2ovqcnDZbJrdYA35dgIjuGiJ3/jXcst+b0lp+OiAa7tT5ZY6KVRmILX?=
 =?us-ascii?Q?Lp+LlWZzr5aR4kTp+dCm1xzB7CxvWSgGufBg67NQRnhPotJbcSJLaidtqGbV?=
 =?us-ascii?Q?eXehDaFhx4SpDeXVsMZvlci4Ki87rlmCf3M5/UbdbbRhedxVK+DFQJWQ0juj?=
 =?us-ascii?Q?knsLgxSeb5FKA4TGWkTATlFXBU4qiBZkvYr2rmk4dAF+HtsWYChjMsYSdpT1?=
 =?us-ascii?Q?Dj7sztjUmVwlM6WUnGbRxSx8MEnh+vntQPqBYaWU3Fx/SqG10xDK+MgqoQU7?=
 =?us-ascii?Q?I3rpdsd5+jw48jE2/t/ejWFZ2GCL6qPtkA5m3VesKO+BF1sKAyf/Gzko1lDV?=
 =?us-ascii?Q?6SA76mSGD767VSyPp4OUsD5ckbtW6BOU8wi/5VAd9tw0bKiQ9jmSMWCjoU8M?=
 =?us-ascii?Q?i8EZWV9TIcmiW7WzTMElEcTPPu3rM6j2ux3eKlaWFKrtl53Ibu00XL/EleWu?=
 =?us-ascii?Q?iqKvz5iyafBDqSi44mFpJieJRKf8ws6afEPxdHpdIhUlraBF+YY2JfGY0hJs?=
 =?us-ascii?Q?ozk08XlNiM98MylC7BeAzTqBKfuWlh0knk/p+9PinuB0LLA1vGF3gclp/msh?=
 =?us-ascii?Q?ccBGKA4MLWZtZijQD2TO6ytz4AL8yd8tCcomdkIsRkoai4z7kOlyDx5sLD/1?=
 =?us-ascii?Q?MweM3zoOqX0ATz+wz/29uHIV6doT4+pI45ysDB0zcQqHHywj4BF4CtZ2m6f8?=
 =?us-ascii?Q?2sgXDLBsPQVxvM/ONdn5bu72E13Dx6OWQenTke+aox5MlOv66YPYdGrLA65d?=
 =?us-ascii?Q?/5owOZAvhT4Rafh8USpldDOUAWDTwM08uz+QY4Bw/WMgWJ41CIm7Tp6wSpuV?=
 =?us-ascii?Q?tNwTDRBdoppovIscGib13XhZoMOXAp+vwe0fUCs2CV22UYYFWIVQJL6xrkDD?=
 =?us-ascii?Q?AbRTnbiCEYz0kRnrZb00RykVKo7P/tCIE6m6nwqos/T8vFTvPd6rGPkELkN6?=
 =?us-ascii?Q?mXzeCbfHXHAvDdl3EhxWW/VGyObs6ElDY1X5knuQ1Icg36zc8oNUY9YftVXo?=
 =?us-ascii?Q?eft8CrGRMYzqd8NfPOPbdsBIKm5zKkexwRqfKWLYv6M5T/ZjRJkbYkAKRE1o?=
 =?us-ascii?Q?eWbek4aQ53fkgCQVWC5dAiA9nIEX+lIZ0/hBk/eGoe4i9WcC88QMcTzEW7B9?=
 =?us-ascii?Q?KKI8DCVklUEDVVIiYxJUv/rpfMebETU7x8hjt71A97qoza0m/v3p+HUUjWDr?=
 =?us-ascii?Q?A1uAaniooySinaviaGGnf2Dczjx6U5A0GQHbs8mwmVriHh5rNjGBItvcOJub?=
 =?us-ascii?Q?U5C2QtVnDLTotQyBZJddMkL05kHkBI9UwhaGwING6eyBOaSE57mUoqeQSkgj?=
 =?us-ascii?Q?nMTcAUvyQKiZ3HgLRzbx3vcQDju1UD4865uj33f+Y0N2e4Xw1tsl8rT3xlnY?=
 =?us-ascii?Q?WdSj1rWmd3cELwH1YbsEx7jvw9UZjLVMbawinUPLSoywLaup/l5vvYs8Qy7u?=
 =?us-ascii?Q?qLkjO9Hx7ymP7XvJ2F8TQBCRbdZ6fr17tHLwhbm75fh4ItJf+Sn5Q2V+KHTv?=
 =?us-ascii?Q?pBnqJrcnR3uqxozYUCCvvL//QtZ5mQi6iT9u9IgVj9qFZAactHWDgXC8HXt6?=
 =?us-ascii?Q?P4Dm/nFQxl8+Qox0voQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 06:19:47.0381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 448ed4e1-184d-494a-bd95-08de227ca4e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

Extend the Mediated PMU framework to support hardware virtualized PMUs.
The key differences with Mediated PMU are listed below.
  * Hardware saves and restores the guest PMU state on world switches.
  * The guest PMU state is saved in vendor-specific structures (such as
    VMCB or VMCS) instead of struct kvm_pmu.
  * Hardware relies on interrupt virtualization (such as VNMI or AVIC)
    to notify guests about counter overflows instead of receiving
    interrupts in host context after switching the delivery mode in
    LVTPC and then injecting them back in to the guest (KVM_REQ_PMI).

Parts of the original PMU load and put functionality are reused as the
active host events still need to be scheduled in and out in preparation
for world switches.

Event filtering and instruction emulation require the ability to change
the guest PMU state in software. Since struct kvm_pmu no longer has the
correct state, make use of host-initiated MSR accesses for accessing
MSR states directly from vendor-specific structures.

RDPMC is intercepted for legacy guests which do not have access to all
counters. Host-initiated MSR accesses are also used in such cases to
read the latest counter value from vendor-specific structures.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/kvm/pmu.c           | 94 +++++++++++++++++++++++++++++-------
 arch/x86/kvm/pmu.h           |  6 +++
 arch/x86/kvm/svm/pmu.c       |  1 +
 arch/x86/kvm/vmx/pmu_intel.c |  1 +
 arch/x86/kvm/x86.c           |  4 ++
 arch/x86/kvm/x86.h           |  1 +
 6 files changed, 89 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0e5048ae86fa..1453fb3a60a2 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -168,6 +168,43 @@ void kvm_handle_guest_mediated_pmi(void)
 	kvm_make_request(KVM_REQ_PMI, vcpu);
 }
 
+static __always_inline u32 fixed_counter_msr(u32 idx)
+{
+	return kvm_pmu_ops.FIXED_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
+}
+
+static __always_inline u32 gp_counter_msr(u32 idx)
+{
+	return kvm_pmu_ops.GP_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
+}
+
+static __always_inline u32 gp_eventsel_msr(u32 idx)
+{
+	return kvm_pmu_ops.GP_EVENTSEL_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
+}
+
+static void kvm_pmu_get_msr_state(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+{
+	struct msr_data msr_info;
+
+	msr_info.index = index;
+	msr_info.host_initiated = true;
+
+	KVM_BUG_ON(kvm_pmu_call(get_msr)(vcpu, &msr_info), vcpu->kvm);
+	*data = msr_info.data;
+}
+
+static void kvm_pmu_set_msr_state(struct kvm_vcpu *vcpu, u32 index, u64 data)
+{
+	struct msr_data msr_info;
+
+	msr_info.data = data;
+	msr_info.index = index;
+	msr_info.host_initiated = true;
+
+	KVM_BUG_ON(kvm_pmu_call(set_msr)(vcpu, &msr_info), vcpu->kvm);
+}
+
 static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -520,19 +557,22 @@ static bool pmc_is_event_allowed(struct kvm_pmc *pmc)
 
 static void kvm_mediated_pmu_refresh_event_filter(struct kvm_pmc *pmc)
 {
-	bool allowed = pmc_is_event_allowed(pmc);
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	struct kvm_vcpu *vcpu = pmc->vcpu;
 
 	if (pmc_is_gp(pmc)) {
 		pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
-		if (allowed)
+		if (pmc_is_event_allowed(pmc))
 			pmc->eventsel_hw |= pmc->eventsel &
 					    ARCH_PERFMON_EVENTSEL_ENABLE;
+
+		if (kvm_vcpu_has_virtualized_pmu(vcpu))
+			kvm_pmu_set_msr_state(vcpu, gp_eventsel_msr(pmc->idx), pmc->eventsel_hw);
 	} else {
 		u64 mask = intel_fixed_bits_by_idx(pmc->idx - KVM_FIXED_PMC_BASE_IDX, 0xf);
 
 		pmu->fixed_ctr_ctrl_hw &= ~mask;
-		if (allowed)
+		if (pmc_is_event_allowed(pmc))
 			pmu->fixed_ctr_ctrl_hw |= pmu->fixed_ctr_ctrl & mask;
 	}
 }
@@ -740,6 +780,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	    kvm_is_cr0_bit_set(vcpu, X86_CR0_PE))
 		return 1;
 
+	if (kvm_vcpu_has_virtualized_pmu(pmc->vcpu))
+		kvm_pmu_get_msr_state(pmc->vcpu, gp_counter_msr(pmc->idx), &pmc->counter);
+
 	*data = pmc_read_counter(pmc) & mask;
 	return 0;
 }
@@ -974,6 +1017,9 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	    (kvm_pmu_has_perf_global_ctrl(pmu) || kvm_vcpu_has_mediated_pmu(vcpu)))
 		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
 
+	if (kvm_vcpu_has_virtualized_pmu(vcpu))
+		kvm_pmu_set_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_CTRL, pmu->global_ctrl);
+
 	if (kvm_vcpu_has_mediated_pmu(vcpu))
 		kvm_pmu_call(write_global_ctrl)(pmu->global_ctrl);
 
@@ -1099,6 +1145,11 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
 	if (bitmap_empty(event_pmcs, X86_PMC_IDX_MAX))
 		return;
 
+	if (kvm_vcpu_has_virtualized_pmu(vcpu)) {
+		kvm_pmu_get_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_CTRL, &pmu->global_ctrl);
+		kvm_pmu_get_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_STATUS, &pmu->global_status);
+	}
+
 	if (!kvm_pmu_has_perf_global_ctrl(pmu))
 		bitmap_copy(bitmap, event_pmcs, X86_PMC_IDX_MAX);
 	else if (!bitmap_and(bitmap, event_pmcs,
@@ -1107,11 +1158,21 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
+		if (kvm_vcpu_has_virtualized_pmu(vcpu))
+			kvm_pmu_get_msr_state(vcpu, gp_counter_msr(pmc->idx), &pmc->counter);
+
 		if (!pmc_is_event_allowed(pmc) || !cpl_is_matched(pmc))
 			continue;
 
 		kvm_pmu_incr_counter(pmc);
+
+		if (kvm_vcpu_has_virtualized_pmu(vcpu))
+			kvm_pmu_set_msr_state(vcpu, gp_counter_msr(pmc->idx), pmc->counter);
 	}
+
+	if (kvm_vcpu_has_virtualized_pmu(vcpu))
+		kvm_pmu_set_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_STATUS, pmu->global_status);
+
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 }
 
@@ -1270,21 +1331,6 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
-static __always_inline u32 fixed_counter_msr(u32 idx)
-{
-	return kvm_pmu_ops.FIXED_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
-}
-
-static __always_inline u32 gp_counter_msr(u32 idx)
-{
-	return kvm_pmu_ops.GP_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
-}
-
-static __always_inline u32 gp_eventsel_msr(u32 idx)
-{
-	return kvm_pmu_ops.GP_EVENTSEL_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
-}
-
 static void kvm_pmu_load_guest_pmcs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -1319,6 +1365,12 @@ void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_irqs_disabled();
 
+	/* Guest PMU state is restored by hardware at VM-Entry */
+	if (kvm_vcpu_has_virtualized_pmu(vcpu)) {
+		perf_load_guest_context(0);
+		return;
+	}
+
 	perf_load_guest_context(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
 
 	/*
@@ -1372,6 +1424,12 @@ void kvm_mediated_pmu_put(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_irqs_disabled();
 
+	/* Guest PMU state is saved by hardware at VM-Exit */
+	if (kvm_vcpu_has_virtualized_pmu(vcpu)) {
+		perf_put_guest_context();
+		return;
+	}
+
 	/*
 	 * Defer handling of PERF_GLOBAL_CTRL to vendor code.  On Intel, it's
 	 * atomically cleared on VM-Exit, i.e. doesn't need to be clear here.
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index a0cd42cbea9d..55f0679b522d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -47,6 +47,7 @@ struct kvm_pmu_ops {
 	const int MIN_NR_GP_COUNTERS;
 
 	const u32 PERF_GLOBAL_CTRL;
+	const u32 PERF_GLOBAL_STATUS;
 	const u32 GP_EVENTSEL_BASE;
 	const u32 GP_COUNTER_BASE;
 	const u32 FIXED_COUNTER_BASE;
@@ -76,6 +77,11 @@ static inline bool kvm_vcpu_has_mediated_pmu(struct kvm_vcpu *vcpu)
 	return enable_mediated_pmu && vcpu_to_pmu(vcpu)->version;
 }
 
+static inline bool kvm_vcpu_has_virtualized_pmu(struct kvm_vcpu *vcpu)
+{
+	return enable_virtualized_pmu && vcpu_to_pmu(vcpu)->version;
+}
+
 /*
  * KVM tracks all counters in 64-bit bitmaps, with general purpose counters
  * mapped to bits 31:0 and fixed counters mapped to 63:32, e.g. fixed counter 0
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index c03720b30785..8a32e1a9c07d 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -278,6 +278,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
 
 	.PERF_GLOBAL_CTRL = MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+	.PERF_GLOBAL_STATUS = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
 	.GP_EVENTSEL_BASE = MSR_F15H_PERF_CTL0,
 	.GP_COUNTER_BASE = MSR_F15H_PERF_CTR0,
 	.FIXED_COUNTER_BASE = 0,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 41a845de789e..9685af27c15c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -845,6 +845,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.MIN_NR_GP_COUNTERS = 1,
 
 	.PERF_GLOBAL_CTRL = MSR_CORE_PERF_GLOBAL_CTRL,
+	.PERF_GLOBAL_STATUS = MSR_CORE_PERF_GLOBAL_STATUS,
 	.GP_EVENTSEL_BASE = MSR_P6_EVNTSEL0,
 	.GP_COUNTER_BASE = MSR_IA32_PMC0,
 	.FIXED_COUNTER_BASE = MSR_CORE_PERF_FIXED_CTR0,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6bdf7ef0b535..750535a53a30 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -191,6 +191,10 @@ module_param(enable_pmu, bool, 0444);
 bool __read_mostly enable_mediated_pmu;
 EXPORT_SYMBOL_GPL(enable_mediated_pmu);
 
+/* Enable/disable hardware PMU virtualization. */
+bool __read_mostly enable_virtualized_pmu;
+EXPORT_SYMBOL_GPL(enable_virtualized_pmu);
+
 bool __read_mostly eager_page_split = true;
 module_param(eager_page_split, bool, 0644);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index bd1149768acc..8cca48d1eed7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -446,6 +446,7 @@ extern struct kvm_host_values kvm_host;
 
 extern bool enable_pmu;
 extern bool enable_mediated_pmu;
+extern bool enable_virtualized_pmu;
 
 /*
  * Get a filtered version of KVM's supported XCR0 that strips out dynamic
-- 
2.43.0


