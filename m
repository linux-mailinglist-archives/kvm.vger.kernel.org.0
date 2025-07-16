Return-Path: <kvm+bounces-52574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2307AB06DAA
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C2421AA58D9
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 06:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963E228640D;
	Wed, 16 Jul 2025 06:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pbCykRhM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2225D27A444
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 06:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752646153; cv=fail; b=XOz2YGr1N+vM+HfAyNs2YyZDxXj5Im1IUcnUaqUKagrZ2obpErI8oFtqgL6TFJEIXEteczQE2ZCvusozbSit07BtqQjCB6kEGzN6gpzbZa8nNahsRYmbTYeTQyLJAw91AMmTHeuQOpYjCoCYIyFivXjgDgOWSV1wBIrUtVonKRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752646153; c=relaxed/simple;
	bh=aj31oL8li+Qaimtjg+vVEOUmUcymawoC6cC5MShFAzw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VdX0m1lujhBCIJiuYE2UM7tN76GUJCBPl3QuWXv0ZDnie/IVous17VXDEibSPfg2uZGnAlWvnqwoomeAWTxv5epH1wfp2p4SC2Xsmi0dEAa3FrCfQB4WeIISdRcAmBn5oNjear6P1NXCqttPDPg5//EH7/hoGqnyiL7i+q/op/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pbCykRhM; arc=fail smtp.client-ip=40.107.223.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=th0EenBivSBu3tUeTQcjYtNHf8za/0aaVD/jhdwov3Km2cO+sNBTugGSDQj4I8DeKFW40Xb2H5Mgj4QWdnZoRBORkbFNW4OsnYOmVx2zMoaJY8lkixdRgkUMV0AuO1PDlevJoaAHgE0VfRcrwwTijy1BRt4Lt+5zU9/lJDEdxPAkmXOVx3TY8I3XKY7rwjj9Iy7uDqVAsbW/1D76SsGnLgmxjYSnCkBL9i632Ksq2Ndhy4Mptjt/Dt6D/hVCw10A6FbScBCTi3jLfS+8Q9xIriVHkTFsqYuWx9rz+UEjz7SgqWnLjOyRpyInZ2nLb603Jw6EZakBXm0aELpHH7nOCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZK6z2BUs9ywgx9C0YOz/BRSKfeWZxK2aItMJwORMqE=;
 b=p0GoDfPgoAHdhyUXAVzP6lHvXtOAt8BNhDWDurSpPcCamEfriDKz1RIvVytlvv+jn+Qzngwd/1Fxr71JUgNPWejOKyhbxc7a10Zy3Ghz9zOiKZWnRT97kyG1lBFBHsfewWGjf2SO2hC+fw2V7cXtp958/kW/tcC7AqOzxJjTVVZbTGSeE8yNVrIk5woUivuWTyKA2nfXyuWrBY0omysYx+S6tVQ58R3z9qKs1je10F+GZZKZe3XNZAT/tmiOiPyhDhhZJuFMxqzgV0KCSbqUui8hYByoOqQOW34G3DuAXZ05bbFVApmaiDMyg0t5Ci+w5YB71j5apW0ZkUnJ55tIwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZK6z2BUs9ywgx9C0YOz/BRSKfeWZxK2aItMJwORMqE=;
 b=pbCykRhMYXGmjErgZpiLLQz7i7OpI21132jwbeajC0NfJtHke7zZS+1Scuqfd+O+cfNe4r5DFJ4LtQ/CqhWufLmKChEqth9ZF6qUeeZkZkc/EdtFHNKXKXfzez+QZHO6R6vvahkYdbhPOq2jY0t4M/vRKytTdWeFe/dW3kOabWw=
Received: from BY3PR05CA0058.namprd05.prod.outlook.com (2603:10b6:a03:39b::33)
 by PH7PR12MB7331.namprd12.prod.outlook.com (2603:10b6:510:20e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Wed, 16 Jul
 2025 06:09:07 +0000
Received: from SJ1PEPF000026C5.namprd04.prod.outlook.com
 (2603:10b6:a03:39b:cafe::87) by BY3PR05CA0058.outlook.office365.com
 (2603:10b6:a03:39b::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.17 via Frontend Transport; Wed,
 16 Jul 2025 06:09:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000026C5.mail.protection.outlook.com (10.167.244.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 06:09:06 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 16 Jul
 2025 01:09:01 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>,
	<kai.huang@intel.com>
Subject: [PATCH v9 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Date: Wed, 16 Jul 2025 11:38:36 +0530
Message-ID: <20250716060836.2231613-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250716060836.2231613-1-nikunj@amd.com>
References: <20250716060836.2231613-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C5:EE_|PH7PR12MB7331:EE_
X-MS-Office365-Filtering-Correlation-Id: 7524f08f-ea24-4383-cd91-08ddc42f45e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fG4dup+SUBhnpDcxbuHJCC6zyFEt32Zsf5wz3pT4zt3wIGAPFJQ0SIVxpHJ5?=
 =?us-ascii?Q?v5/JA/gGRT7ccBTjxQolhGfijTx4CLiC+c4MbYPlohWtgal+QyfuVuvPQGU5?=
 =?us-ascii?Q?rrfxumYk0WnynhiSTvQMRkysub92lbTGyRyNJ4cTH5Rr1VHR7B9RdZAIaV05?=
 =?us-ascii?Q?XX8lcSkNCyOdxRKKTdfoM+MFweiSJGU42JgbvI0B3FmJbxAwTTN0XbHspBW2?=
 =?us-ascii?Q?xoxvsBoVCrYL0w3ZQ58Qp3AJorXcBux6XzZNZOcNIKcZbqCatzQxFffvaFGX?=
 =?us-ascii?Q?1Tz9y/ohHhe5OPWXZ2hIo7GQ1vS1MwRwXtCODXA90SNoFsp+edM7ymPnWYIo?=
 =?us-ascii?Q?D9MYs0/17qNN6pB2MzDPxg4qgSSYupfZofEERs7/d1EeLpM7Tu+UvZJImzKS?=
 =?us-ascii?Q?X87wCG0g1l+5VMvzQdBZwxJVUU7FmnypqP+kjeIbdkaDgNNMfvwMoOtWVQ79?=
 =?us-ascii?Q?eQ5X3omk0m2wqI1mwzM5TYJllhg5nUl+Wy9SczEmpUgAKnQCTvnJdfWX9Hdz?=
 =?us-ascii?Q?1DqScpGZjKLkFl2rsd7CS5M3/V9t1gJjlmACmMvFzM4hmd5xmjsgr5VBm6k4?=
 =?us-ascii?Q?eCGFxdM9FA8Hpz4Rf/vh0gwlZ+Rg25o0nJ45bMq8l/ZJWb5ar3esPpHNi+xd?=
 =?us-ascii?Q?qrDrvVmlpkXBNCrAGj/4w6W/R4ReteiTniXug+GSJ568ilIKU1LMaL9GdmtF?=
 =?us-ascii?Q?B590R3+91sr5qTFIwY0yuHa6Cz6ejqYCmlYJf1lzEYzXyT4Kt60MAyQ1iTg5?=
 =?us-ascii?Q?gVPGhPa3AP6UIitmT+2cTaLqgcvcPuxUOt0VgGykviskcYBWfYCBRztEDtVS?=
 =?us-ascii?Q?hWwkn/1dp6OdVxZVHOleH8B5b9rv5hxXs7dUA8tpQV6ghvQHVm/IUS3JnpoA?=
 =?us-ascii?Q?NhGg1VVZPTioRD5in6pRq0EFQ0IWLfH6IBLYHFSLA6J+NBdTekuTj6wAi67n?=
 =?us-ascii?Q?Zp8xTES4XBmWwlj3wKzBDG8Pm8RxyJw472qlS8OUA13+ut1Buo+pvlMQP/hF?=
 =?us-ascii?Q?2jEgD+vbLKtky05w3Hm8CQRLaAmFjULceb7gQgBgOyPR2YsbXUf0OzYW+L8P?=
 =?us-ascii?Q?j++CIp0EOx5w6hk7mlWhfFzm79Sg//pr7kYeja1G5XR49i+7qEUKzPZ8G0fM?=
 =?us-ascii?Q?ggqxk4i5G5vNlh8JLuGiqb8hvWLdBWeoDT1/YQCH+B02p6BFSiLyiVO+xnE8?=
 =?us-ascii?Q?j/Hokx254vEWSQ8jmYGqkckJebq+ZlLyDOG5SH4mNArRVChVH60QzT885Gjq?=
 =?us-ascii?Q?0J7fJHJCFcf1QJBWZhjdQqLHNnW5g5rZJp5xlWbGv9U1CKXFqs3lorOL99DQ?=
 =?us-ascii?Q?k309IYskJxjgIWpSCS0PPt8HnVkOo5AiypsiI2j4Ymo+U+O6oMqLcYH+iNN1?=
 =?us-ascii?Q?4vd9KMrxwHOIsMoY4xcyY6T05hXMkRdbtXXfEZWWWLaM7AXvRHALUQZbxUBd?=
 =?us-ascii?Q?HcDEl8qdG7kS2YCVi00RWtrrrXQiNDHOWNRVDov4RI2L5VZWQzWbTkFrwLC8?=
 =?us-ascii?Q?C9CIkR6dI264F8Q1YoYLiYwTo3U+IULSGxgi?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 06:09:06.9980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7524f08f-ea24-4383-cd91-08ddc42f45e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7331

Add support for Secure TSC, allowing userspace to configure the Secure TSC
feature for SNP guests. Use the SNP specification's desired TSC frequency
parameter during the SNP_LAUNCH_START command to set the mean TSC
frequency in KHz for Secure TSC enabled guests.

Always use kvm->arch.arch.default_tsc_khz as the TSC frequency that is
passed to SNP guests in the SNP_LAUNCH_START command.  The default value
is the host TSC frequency.  The userspace can optionally change the TSC
frequency via the KVM_SET_TSC_KHZ ioctl before calling the
SNP_LAUNCH_START ioctl.

Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
guest's effective frequency in MHZ when Secure TSC is enabled for SNP
guests. Disable interception of this MSR when Secure TSC is enabled. Note
that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
hypervisor context.

Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

---

I have incorporated changes from Sean to prevent the setting of SecureTSC
for non-SNP guests. I have added his 'Co-developed-by' acknowledgment, but
I have not yet included his 'Signed-off-by'. I will leave that for him to
add.
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  2 ++
 arch/x86/kvm/svm/svm.h     |  2 ++
 4 files changed, 32 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..17f6c3fedeee 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -299,6 +299,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
 
 #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 97843a5383be..2e36ef962434 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -147,6 +147,14 @@ static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
 	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
 }
 
+bool snp_secure_tsc_enabled(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
+		!WARN_ON_ONCE(!sev_snp_guest(kvm));
+}
+
 /* Must be called with the sev_bitmap_lock held */
 static bool __sev_recycle_asids(unsigned int min_asid, unsigned int max_asid)
 {
@@ -416,6 +424,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (data->flags)
 		return -EINVAL;
 
+	if (!snp_active)
+		valid_vmsa_features &= ~SVM_SEV_FEAT_SECURE_TSC;
+
 	if (data->vmsa_features & ~valid_vmsa_features)
 		return -EINVAL;
 
@@ -2196,6 +2207,16 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
+
+	if (snp_secure_tsc_enabled(kvm)) {
+		if (WARN_ON(!kvm->arch.default_tsc_khz)) {
+			rc = -EINVAL;
+			goto e_free_context;
+		}
+
+		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
+	}
+
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
 	if (rc) {
@@ -3086,6 +3107,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }
 
 void sev_hardware_unsetup(void)
@@ -4456,6 +4480,9 @@ void sev_es_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID));
 
+	if (snp_secure_tsc_enabled(vcpu->kvm))
+		svm_disable_intercept_for_msr(vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_R);
+
 	/*
 	 * For SEV-ES, accesses to MSR_IA32_XSS should not be intercepted if
 	 * the host/guest supports its use.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..a81bf83ccb52 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1317,6 +1317,8 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 
 	svm->guest_state_loaded = false;
 
+	vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(vcpu->kvm);
+
 	return 0;
 
 error_free_vmsa_page:
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b9d168e0c8..acb00e0fd564 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -869,6 +869,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
 void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
+bool snp_secure_tsc_enabled(struct kvm *kvm);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -905,6 +906,7 @@ static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 	return NULL;
 }
 static inline void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa) {}
+static inline bool snp_secure_tsc_enabled(struct kvm *kvm) { return false; }
 #endif
 
 /* vmenter.S */
-- 
2.43.0


