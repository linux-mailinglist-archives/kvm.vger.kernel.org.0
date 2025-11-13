Return-Path: <kvm+bounces-62982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AEEDC55EA4
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C7F994E51FF
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870B0320A20;
	Thu, 13 Nov 2025 06:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xObv1VJB"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010030.outbound.protection.outlook.com [40.93.198.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3F7320387;
	Thu, 13 Nov 2025 06:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763014828; cv=fail; b=PpbDs4bcEHH8hbawTm//2iWpHx9T4gIGfxOgVBvr1kvo2cusaYW+m3/j0H2CBuK4qOQgs0bjC/NTBCYlMjG5zQGmTUZsYyrHm9DJVomUfwQNGnNmmRrOZoajksevY3SFt4tJBBq+Skrh2CyU8JETXXiyG7l6eGtCXBDsC1kW39U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763014828; c=relaxed/simple;
	bh=FLtpibC0Mkbtx7g1Eh3ksBf0Q3+iKwTIJxYkcrtyRws=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K749EIbi+tVi0iZPN8V6Yl1WyFefWK/PVEsMyrfE33JKUM0fUnqO4LqeBSGW5mEFUZPm9UZFeu+n9K+yPVc83AlrfXEf/U/Ke9+b3ZKEGjdk3EJ1gjvpMTTWjc3gzIPHLPra5Ip+IuKraIbupbRGOYJRJjIWzaVJyR5U0eyVFlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xObv1VJB; arc=fail smtp.client-ip=40.93.198.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8gl4jVbkng6nNs6vfU15x28oCAO3WUe7MSXL+SmNXjbSvGtdMU8RtWpUY2ZCH4Pu2KSAyDCxDsWk1ZMXJ51tezh52KZv88Sd8uDhPYBXOft8cYaaaI0FSfjbTh7NkyHZBnba+iKQJNYTupu8wCoNpz5fcXYZUPB5AlDs6D8vchgSIBrrkk8CtIadYuiKmyL/67IZT5L0Tn3XsHXTo3Hxbe154SqwTbGbEuIscwUFraUkhjA9Vq2CiAjT0KdVcnsmW8V1yqOjy2he2PHJ688VDJh8nboOEzBOaI2d/M9sVrunI/py58WpBnzRQq/OmD1PoTCV5frS9sHCXL0l3qV+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Z0BYoOcAL1TpF7YSW/tmYT0ytc4e4xev67CXDnQ8aQ=;
 b=HGu+MTwZ/5SaEqxWn20bFg7lyDi9FxrQ/CEYAe1SGGU4A8kInlj/HKkJJHcd6EBtPZ9boRj8ElU//YIb0h71EmD3LuZRaceZDiy+FXF5NLH1EMHsgRS8HEODzQ9ASXOVKdU1v5F1SBt71Wd4WCS3LRUpZcLLkfTQRjcIZ59tNTHBrSMAeZZLWPY3RnF76x5qs0Hzfk2n75PaPPzAMuneB2Sk34AOwkf5QV+I8nrU2wDZS2y068VmcJiKR7Y4P6PpWT0NtqWqg2gqZSXGXvoNzqwDIPVIecvsoZ7/Wc+zD7iGNTt/WVCcYUbo9rSLDxWsu130Zp5I27tw8vS7Bp40Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Z0BYoOcAL1TpF7YSW/tmYT0ytc4e4xev67CXDnQ8aQ=;
 b=xObv1VJBamR/bToLcNwzftESvPICkCe6tvf4fN8dibpNeYFwitFNySu9AZj0D7HBIo2PN1b8ngfYe7l9I7ExtXbrSfU2dqZaSXNJEc1fimI9QJvTD+97SteVoDdaT/dzfKjakzzp5KhvNisQuS4ooFEP+mT2XAIxz3OAKBMmY/4=
Received: from PH8P222CA0025.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:2d7::16)
 by DM4PR12MB7575.namprd12.prod.outlook.com (2603:10b6:8:10d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 06:20:22 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:510:2d7:cafe::75) by PH8P222CA0025.outlook.office365.com
 (2603:10b6:510:2d7::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 06:20:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 06:20:21 +0000
Received: from sindhu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 22:20:14 -0800
From: Sandipan Das <sandipan.das@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Kan Liang
	<kan.liang@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, "Manali
 Shukla" <manali.shukla@amd.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
	"Ananth Narayan" <ananth.narayan@amd.com>, Sandipan Das
	<sandipan.das@amd.com>
Subject: [RFC PATCH 6/7] KVM: SVM: Add support for PMC virtualization
Date: Thu, 13 Nov 2025 11:48:26 +0530
Message-ID: <317238617cb03dd3d4712c1e9d9424ce20a72053.1762960531.git.sandipan.das@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|DM4PR12MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: 57e25c05-6727-42c2-e3d8-08de227cb99c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rvYNeiWhzyq/DMHsGht7XxkXL/W/4GY2Wg1R+oVRiUvOKkQtk6vAMlKKJKIt?=
 =?us-ascii?Q?uTosT1m0OvDO/VhQb28/r79snAAMK+gKCYVpDQ+x/4Chr9tZZgFmM3zmv6e3?=
 =?us-ascii?Q?cJkM/D7RmeozcBRgoQ9FyZcdIj++DLwwrAHVmNjHo2WJTmBUY01+2pTQZ7Gm?=
 =?us-ascii?Q?jcFrAKndEVRy4LMkXYUvElHWzDgl3GfDuPe311i/jxCHItc1iQwFnBAo3hnp?=
 =?us-ascii?Q?ghlrnRLqJwS8/n8D8j8TXMWKWAHJ+p+NwaroBEfFx+0IHTJcslESPQytY1CA?=
 =?us-ascii?Q?p2/5CRKGI9W/TUdFafTqcZvNoiPhQkBhpTrwhcrlvghUIBaBx17jcG5+fMak?=
 =?us-ascii?Q?WepL7p8/VN6nMQhbot+UsvqSW4ny3SYditEyAwAdNfhGYQF1045SqV+1BZRl?=
 =?us-ascii?Q?kEz+ijqfvezwgZFC4z5Cu/ALrZHRoF4YF8Yq4Yb7sbvb8y/5lAFk/dSUN5/j?=
 =?us-ascii?Q?mnxDHNKaUanC0t21QPWVppyCP9hFyT1xFVkUnOUKbM5b5H2hzPf1YNX1MDQY?=
 =?us-ascii?Q?IG9DpmTlWY3SKRqsCP4YucAT1tH3ULUCblrVl8UJL8ChKq5hpr4pi2C3hRtd?=
 =?us-ascii?Q?o9+3aSMcvke6PXr76iLD1+9AG9WqqYWFE8Rap5MpyiRR6BY9ubUyX/MF6LA3?=
 =?us-ascii?Q?TVex4Z6BN8YMi/nyoJutzdMS0q1HzpqI2AQK40YrQRWQcAWN+W1wnJi5zB1n?=
 =?us-ascii?Q?wbBnJKsC0cyf6v/ZBEw12UP+Ss1nNxCMm+ZB71NGM/FCBjMzdcdjMh/QvjCX?=
 =?us-ascii?Q?mdAdhUZzv3JL+CrHltYYNp1y23R9fp0hH3T7OG7ar0sa6p3etQAtcBdc2iQM?=
 =?us-ascii?Q?vjINUml1FKh+Kp8alhANMdj6qAzvKJIpdaZEOwm/75kusKOqlBCrg7Ouug7Z?=
 =?us-ascii?Q?0dKOKcWSi2mZmQgQWduqAaVo9IIhzExSNF014a32zLaiHjgsbGHJjtM4Kx+H?=
 =?us-ascii?Q?67Q11ORMBuvGMUNWluRUAfeD3LvKxWdwf9a+6Yxwl5UmjTgLTqQP7EdvT7hY?=
 =?us-ascii?Q?zS/KtDWQ1a8feEem89roJT+w7d2+JpB/nhGssqghr1lIo+qXzg5l4jqM2rzp?=
 =?us-ascii?Q?F8/QEu0DXyqhaXX7/26i+eNiNzLZ0ybujaz3yicMt38AyFXIxRmGToEbSV2F?=
 =?us-ascii?Q?fihH+/50vA9suLkftfcG04jZVlBvZWK6+Gq2FkOweXVe9ZW/SkvPagFouNft?=
 =?us-ascii?Q?BMQ/bk46yRZ0noQbz08lpHujsvfgtQ/n38SI+SLlsXtgPG6Fy+4WmQZtYh7r?=
 =?us-ascii?Q?4jjYB5srPoq79K0aAreKvWJm6Z0ZA9xZK3Rzvp+4AFk2PNdIXv/gnOTqF6ma?=
 =?us-ascii?Q?iQtTwVlC+3s9L6jHiTzD+c12tc/46VAxN2aqnfK6jCJMOYjZBT7jdvz4JlyB?=
 =?us-ascii?Q?lxBk54uFlNd+VGIQUcfXeRbHcyS9AzkJvGE4gVs5VXlIPy6kxVFpH8/UpO7n?=
 =?us-ascii?Q?owsYrXDMbv44lUS/SyIbqph+s5G/T+FGdK/EN61fvN0FJOujNrthTD0o9ArM?=
 =?us-ascii?Q?DmPXJn8klhJDUTte3iIDGICH4bF0hIF3mYnFs9a4UXLFKRVIrMFRV2cFT+pK?=
 =?us-ascii?Q?o8lZI1z1Q+wwOKtv+wk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 06:20:21.7671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57e25c05-6727-42c2-e3d8-08de227cb99c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7575

Make use of the extended Mediated PMU framework to introduce support for
PMC virtualization (X86_FEATURE_PERFCTR_VIRT). Since the guest PMU state
is saved in the VMCB State Save Area, extend the MSR access PMU ops to
handle host-initiated requests from code responsible for event filtering
and incrementing counters due to instruction emulation.

The underlying implementation depends on the availability of either VNMI
or AVIC for guest interrupt delivery. Synthesized overflows like those
resulting from incrementing counters in software due to instruction
emulation are still injected through the KVM_REQ_PMI path.

If both VNMI and AVIC are enabled, the hardware automatically chooses
AVIC. The advantage of using AVIC is that it lets the guest change the
delivery mode in the LVTPC. Unlike AVIC, VNMI ignores the LVTPC, as APIC
is emulated, and will always present the overflow interrupts as NMIs.
This is demonstrated by some failures in KUT's x86/pmu test.

The feature is enabled by default if the host supports it and also has
Mediated PMU enabled but it can also be switched manually using the new
"vpmc" parameter for the kvm_amd module.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/include/asm/svm.h |   1 +
 arch/x86/kvm/svm/pmu.c     | 100 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  52 +++++++++++++++++++
 arch/x86/kvm/svm/svm.h     |   1 +
 4 files changed, 154 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index a80df935b580..adc30a9f950f 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -221,6 +221,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
+#define PMC_VIRTUALIZATION_ENABLE_MASK BIT_ULL(3)
 
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 8a32e1a9c07d..63d177df4daf 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -124,12 +124,50 @@ static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	return amd_msr_idx_to_pmc(vcpu, msr);
 }
 
+static int amd_virtualized_pmu_get_msr(struct kvm_vcpu *vcpu,
+				       struct msr_data *msr_info)
+{
+	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	u32 msr = msr_info->index;
+
+	/* MSR_PERF_CNTR_GLOBAL_* */
+	switch (msr) {
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
+		msr_info->data = save->perf_cntr_global_status;
+		return 0;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+		msr_info->data = save->perf_cntr_global_control;
+		return 0;
+	}
+
+	/* MSR_PERFCTRn */
+	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
+	if (pmc) {
+		msr_info->data = save->pmc[pmc->idx].perf_ctr;
+		return 0;
+	}
+
+	/* MSR_EVNTSELn */
+	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
+	if (pmc) {
+		msr_info->data = save->pmc[pmc->idx].perf_ctl;
+		return 0;
+	}
+
+	return 1;
+}
+
 static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 
+	if (msr_info->host_initiated && kvm_vcpu_has_virtualized_pmu(vcpu))
+		return amd_virtualized_pmu_get_msr(vcpu, msr_info);
+
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
@@ -146,6 +184,44 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+static int amd_virtualized_pmu_set_msr(struct kvm_vcpu *vcpu,
+				       struct msr_data *msr_info)
+{
+	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	u32 msr = msr_info->index;
+	u64 data = msr_info->data;
+
+	/* MSR_PERF_CNTR_GLOBAL_* */
+	switch (msr) {
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
+		save->perf_cntr_global_status = data;
+		return 0;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+		save->perf_cntr_global_control = data;
+		return 0;
+	}
+
+	/* MSR_PERFCTRn */
+	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
+	if (pmc) {
+		data &= pmc_bitmask(pmc);
+		save->pmc[pmc->idx].perf_ctr = data;
+		return 0;
+	}
+
+	/* MSR_EVNTSELn */
+	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
+	if (pmc) {
+		data &= ~pmu->reserved_bits;
+		save->pmc[pmc->idx].perf_ctl = data;
+		return 0;
+	}
+
+	return 1;
+}
+
 static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -153,6 +229,9 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 
+	if (msr_info->host_initiated && kvm_vcpu_has_virtualized_pmu(vcpu))
+		return amd_virtualized_pmu_set_msr(vcpu, msr_info);
+
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
@@ -167,6 +246,8 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			pmc->eventsel = data;
 			pmc->eventsel_hw = (data & ~AMD64_EVENTSEL_HOSTONLY) |
 					   AMD64_EVENTSEL_GUESTONLY;
+			if (kvm_vcpu_has_virtualized_pmu(vcpu))
+				pmc->eventsel_hw = data;
 			kvm_pmu_request_counter_reprogram(pmc);
 		}
 		return 0;
@@ -228,6 +309,24 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void amd_pmu_reset(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
+	int i;
+
+	if (!kvm_vcpu_has_virtualized_pmu(vcpu))
+		return;
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		save->pmc[i].perf_ctl = 0;
+		save->pmc[i].perf_ctr = 0;
+	}
+
+	save->perf_cntr_global_control = 0;
+	save->perf_cntr_global_status = 0;
+}
+
 static bool amd_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_pmu)
 {
 	return host_pmu->version >= 2;
@@ -268,6 +367,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.set_msr = amd_pmu_set_msr,
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
+	.reset = amd_pmu_reset,
 
 	.is_mediated_pmu_supported = amd_pmu_is_mediated_pmu_supported,
 	.mediated_load = amd_mediated_pmu_load,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2797c3ab7854..425462f10266 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -180,6 +180,9 @@ module_param(vnmi, bool, 0444);
 
 module_param(enable_mediated_pmu, bool, 0444);
 
+bool vpmc = true;
+module_param(vpmc, bool, 0444);
+
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
@@ -1263,6 +1266,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.bus_lock_detection_enabled)
 		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
 
+	if (vpmc)
+		control->virt_ext |= PMC_VIRTUALIZATION_ENABLE_MASK;
+
 	if (sev_guest(vcpu->kvm))
 		sev_init_vmcb(svm);
 
@@ -3467,6 +3473,30 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "excp_from:", save->last_excp_from,
 	       "excp_to:", save->last_excp_to);
 
+	if (kvm_vcpu_has_virtualized_pmu(vcpu)) {
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "perf_ctl0:", save->pmc[0].perf_ctl,
+		       "perf_ctr0:", save->pmc[0].perf_ctr);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "perf_ctl1:", save->pmc[1].perf_ctl,
+		       "perf_ctr1:", save->pmc[1].perf_ctr);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "perf_ctl2:", save->pmc[2].perf_ctl,
+		       "perf_ctr2:", save->pmc[2].perf_ctr);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "perf_ctl3:", save->pmc[3].perf_ctl,
+		       "perf_ctr3:", save->pmc[3].perf_ctr);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "perf_ctl4:", save->pmc[4].perf_ctl,
+		       "perf_ctr4:", save->pmc[4].perf_ctr);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "perf_ctl5:", save->pmc[5].perf_ctl,
+		       "perf_ctr5:", save->pmc[5].perf_ctr);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "perf_cntr_global_control:", save->perf_cntr_global_control,
+		       "perf_cntr_global_status:", save->perf_cntr_global_status);
+	}
+
 	if (sev_es_guest(vcpu->kvm)) {
 		struct sev_es_save_area *vmsa = (struct sev_es_save_area *)save;
 
@@ -4273,6 +4303,15 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 
 	amd_clear_divider();
 
+	/*
+	 * The save slot for PerfCntrGlobalCtl is of Swap Type C which means
+	 * that on VM-Exit, the state of this MSR is reset i.e. all counter
+	 * enable bits are set. According to the APM, the next VMRUN will fail
+	 * with a VMEXIT_INVALID_PMC error code unless it is cleared.
+	 */
+	if (kvm_vcpu_has_virtualized_pmu(vcpu))
+		wrmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
+
 	if (sev_es_guest(vcpu->kvm))
 		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted,
 				      sev_es_host_save_area(sd));
@@ -5506,6 +5545,19 @@ static __init int svm_hardware_setup(void)
 	if (!enable_pmu)
 		pr_info("PMU virtualization is disabled\n");
 
+	enable_virtualized_pmu = enable_mediated_pmu && kvm_pmu_cap.virtualized;
+
+	/*
+	 * Virtualized PMCs do not raise host interrupts on overflow. Instead,
+	 * they require either VNMI or AVIC as an interrupt delivery mechanism
+	 * for guests.
+	 */
+	vpmc = vpmc && (vnmi || avic) && enable_virtualized_pmu;
+	if (vpmc)
+		pr_info("PMC virtualization supported\n");
+	else
+		enable_virtualized_pmu = false;
+
 	svm_set_cpu_caps();
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b9d168e0c8..346bbbbd0882 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -51,6 +51,7 @@ extern bool intercept_smi;
 extern bool x2avic_enabled;
 extern bool vnmi;
 extern int lbrv;
+extern bool vpmc;
 
 /*
  * Clean bits in VMCB.
-- 
2.43.0


