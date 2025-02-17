Return-Path: <kvm+bounces-38359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B764A38011
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB8211889C94
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3343A217647;
	Mon, 17 Feb 2025 10:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a2yegLcv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01C4216613
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739787795; cv=fail; b=CyMgxtxmOpgHr+ut8U19p0SlyVso8JdFzadpguUb32Wqjs/LznrtwF59VCY+8GQWJfTmYyurPF9fthLeCUSPRjsFcJg3tid7qNwQI2wzLIbjtnCCBfjB+5dDGe7lZnX6ka16yDkYJ2srduophREiDQvcoYff7Y6skiPhddhwU/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739787795; c=relaxed/simple;
	bh=QG5zevDIhwe4+0Id/B3NSRHaTwQAqL2R9qfa4MDxlGg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hTA6Kbw8uLH1oHabD4qI4YfqwFdYwloUz7bs79YszQxd33g4wtFB4DXH2FV5EkPybehUr8EX3upjA/xZZx1OMREZj09R1OaFO0/V9iDfy5XtWey3LLw8wfzPsAg1ZsJyATEPNHpVq2RSFrruAFUa67c/+w/MV1eSNhkP24FPj90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a2yegLcv; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F8fiMueK3c9NQ5lwqigR/MZ4ywYprttVYkqm2hWPvpPAyUXISsw85U3RREyVvqfrEfPaCdle7YRwCT7VgojJprvi05KhdurQzIhTOYTGuOKUukphy7hIqTJRNL8DharbgNsn4nCkMch0ZgG76waqoyTK6ermJEC+44BeLz1vDJRVKv92Tuvq4yW7H4A5fS6/1KsnEbSvtjlWLOzQXefK/qo9fat4FQU2z+GKpfxH6dDCFCYLqYiHXiVSA9Ia6Zq2Vl9QlL79qk7Fjl66xu1smSY84weM1fTa8JNcGiWTRNaCpbgG8zSbnQoYZZJ4OJ6YX95mOjFEHFPmJU+6u1sS9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oEO1mg1bJN2w/hQQzqBbQjERuWM8ythJbGKngoG25QE=;
 b=rpFWkdDfVQ5Mk0LQ2ql9RuD37UGsgulGCGLr5MtUCKtVCH9gYcAqgW/XL4zPtVzF/x93OewK7W0lOCv0XxZq9Ogn8gyaRpGcZvTk132i32wINyHoX2gY3w9OVnsiAnWU5XOBHXkwztxqmrmDjc2QrUsvCiqycf41p1w18fDGQ9zgGWqjso9iBdVo8cNcNXoway0hCE82LXrO0WBYNInwtB5TebMW7qlQz35qsbDpC0Zz0h/rgkOugMO02g8jqblotcRg9FLXXPgZtgA1FEvkaJiRZo9jxygRRUsUoGhm59wSJc0tVr4Di1PB7kzNWVd1WHW1BnDZW6YwoVa6HC+ncw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEO1mg1bJN2w/hQQzqBbQjERuWM8ythJbGKngoG25QE=;
 b=a2yegLcvetkIhSBdRuMFAW5Gr9P8g1F4d19EauOlVrU4ON3gczMZS6pEx28i4Y5mfSZHXxM4b4bGmMsk570uuvya5OqgcNZixn1AsB779RXRnZcQOdhXBoNixlykfwmSydYAFSZIWu2rHbeMa8AP2er4QWm4H0D9wzCV/zds4fw=
Received: from DM6PR02CA0058.namprd02.prod.outlook.com (2603:10b6:5:177::35)
 by CY8PR12MB8314.namprd12.prod.outlook.com (2603:10b6:930:7b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Mon, 17 Feb
 2025 10:23:09 +0000
Received: from DS3PEPF000099DE.namprd04.prod.outlook.com
 (2603:10b6:5:177:cafe::27) by DM6PR02CA0058.outlook.office365.com
 (2603:10b6:5:177::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.17 via Frontend Transport; Mon,
 17 Feb 2025 10:23:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DE.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Mon, 17 Feb 2025 10:23:09 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Feb
 2025 04:23:05 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v3 5/5] KVM: SVM: Enable Secure TSC for SNP guests
Date: Mon, 17 Feb 2025 15:52:37 +0530
Message-ID: <20250217102237.16434-6-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250217102237.16434-1-nikunj@amd.com>
References: <20250217102237.16434-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DE:EE_|CY8PR12MB8314:EE_
X-MS-Office365-Filtering-Correlation-Id: 8637a658-79f9-41c3-86fe-08dd4f3d136a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y/mBzlZXpbuY/dZiKCMgB3o0YTtst+PzXRksGM7JusICKxgyqGFKuHtl1spg?=
 =?us-ascii?Q?7skx66hfXqEznKFpAkYSBST5IY9PKT46mOlKxJCJGm3jlX/xuDyXrOYFaGrp?=
 =?us-ascii?Q?D1OoSJZ6V/+2oWDfLGtJ9159OzGdVSP9DNmt/zGGe+Iu7v5mLRJxU1WJJpIv?=
 =?us-ascii?Q?VxGo7pifjd2ymNSyg722U2J4eP6nd+oelBfoQutbwhlkH9RpACDxnISpQX6F?=
 =?us-ascii?Q?Wt4IwVrphdJAeA9uBdqduvIC0t0vUFIgwTxVJWeIj1PYd357rFhDLopeCN8n?=
 =?us-ascii?Q?0yLnmpe05yR7mqNNUbHY3L9M7Ho6bvO9v5NqJlHuPnAdVdRv+sutH5tbZUlu?=
 =?us-ascii?Q?YsLvcDE53NAM7vLus4D7oK1c0AdgkV9PXbXcq+qYlGFQjcNumlq+8Ej9snUY?=
 =?us-ascii?Q?bxkTKSA49aXp5suxUBf+CcpVVys13U/RM86YregqoCsU6xYk+fmG6tiqZmeR?=
 =?us-ascii?Q?FCrqEYLyPiO8mCqyx1j8W+JxiolH2Lgs/tl+x28DLamf9SSJkXV/Ff9WRaqN?=
 =?us-ascii?Q?xWEWG7ZixDekphPMZCZyzDvqk9q3uEp4ohJ/xCqPej1z6uMDeZ2bhlxspyBh?=
 =?us-ascii?Q?FCs9KjipsjJGJun7v7UoW5oV7CN/RpWIkGVRrnosbfgcsXp4N+y8lidNUIsS?=
 =?us-ascii?Q?c6PLz7r6E3nu3/Yi5bAVq47VH+sxHyd4duhaCl4zguJdog3BQzv7j4emL+SZ?=
 =?us-ascii?Q?9QnBppngaunbYt2TUKsaWdsDjbFZ0zQthCdZYFw1ICbAKqb/97uyDim5QEJD?=
 =?us-ascii?Q?HarDXDwPrbtT/ULbs0cQdQe0ra43v3tmLll0adlM0btiu3mnxdIa04BpIhlC?=
 =?us-ascii?Q?lgWb8INymE+FX3O1F/NPqNFq/R6tU9L0yRpIkzGy8ujmvLsjFO5W3PwPmGPs?=
 =?us-ascii?Q?cUYS0dcx3b8L9h5rwM6nJMCMHu+KTKjACeo2m980T0up+vBKr7+gc/013MRu?=
 =?us-ascii?Q?rJHbYgyZ3eZWhQ4qUBW8t2vcb4f+viz9ZTzFnfIheTBupAmgmrPhfdA/XqxZ?=
 =?us-ascii?Q?FWPf/Efeg90YLxz2gTBFvtMbvXODfK7dCIlPi0v0An2vh+cK+41iN2ImxArA?=
 =?us-ascii?Q?aqw+7tLTLMPAE+JFiq3/7AYZGFXLCd0+ZK+FY25B8CnWtQ8Xiah14Iv1YZj5?=
 =?us-ascii?Q?aXfAG/NAerQ676OmXarFbU1CxaY/FzUuooB+/RkN2yISWPBPBayprI4ykT2E?=
 =?us-ascii?Q?LMuWJDt3cKqrIS/eHZrJ8fdFMJFqkRUsdztip0XhoHMi+8LD56t0SDbZ7MDS?=
 =?us-ascii?Q?j6vWsHOBQJaUFuUpecHDuwQqM92WYU9ZqkeQB2858K1wVHqnaszUfXU5FHuo?=
 =?us-ascii?Q?l1b5OgMKWik99j7PgPXsMnygB672UWOPgrmTnTIxdjc3I4cM98AQnK3XL68J?=
 =?us-ascii?Q?kg/OLg9kwto0aVvYhCHNniLHY3dBy96Z+akbKrTjOefMbyygu9hkNWzvLs6w?=
 =?us-ascii?Q?WlncoULcH9B+/Dkpbh3ZpoHyYTqUfGQhiPD46QNS0UHgDXQKj8yI+8Qo/D1w?=
 =?us-ascii?Q?hD82QAuNKjadWR4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 10:23:09.2732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8637a658-79f9-41c3-86fe-08dd4f3d136a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8314

From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>

Add support for Secure TSC, allowing userspace to configure the Secure TSC
feature for SNP guests. Use the SNP specification's desired TSC frequency
parameter during the SNP_LAUNCH_START command to set the mean TSC
frequency in KHz for Secure TSC enabled guests. If the frequency is not
specified by the VMM, default to tsc_khz.

Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |  3 ++-
 arch/x86/kvm/svm/sev.c          | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9e75da97bce0..87ed9f77314d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -836,7 +836,8 @@ struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
 	__u16 flags;
-	__u8 pad0[6];
+	__u8 pad0[2];
+	__u32 desired_tsc_khz;
 	__u64 pad1[4];
 };
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7875bb14a2b1..0b2112360844 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2207,6 +2207,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
+
+	if (snp_secure_tsc_enabled(kvm)) {
+		u32 user_tsc_khz = params.desired_tsc_khz;
+
+		/* Use tsc_khz if the VMM has not provided the TSC frequency */
+		if (!user_tsc_khz)
+			user_tsc_khz = tsc_khz;
+
+		start.desired_tsc_khz = user_tsc_khz;
+
+		/* Set the arch default TSC for the VM*/
+		kvm->arch.default_tsc_khz = user_tsc_khz;
+	}
+
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
 	if (rc) {
@@ -2929,6 +2943,9 @@ void __init sev_set_cpu_caps(void)
 	if (sev_snp_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
+
+		if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+			kvm_cpu_cap_set(X86_FEATURE_SNP_SECURE_TSC);
 	}
 }
 
@@ -3061,6 +3078,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }
 
 void sev_hardware_unsetup(void)
-- 
2.43.0


