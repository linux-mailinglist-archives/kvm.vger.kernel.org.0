Return-Path: <kvm+bounces-40572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F0FA58C40
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD2F47A34AA
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0274B5AE;
	Mon, 10 Mar 2025 06:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vUv5vujx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB5A29D0B
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 06:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741589150; cv=fail; b=QeAXzpTMHp8gIV2Q/cYDGvMKOg9CRpSNODCdSSx3TESSSJ93auChIpmsaHBIybrQll4UkYzl2ycXhX+IVLJXWmBV5O4m7MZWFcxex7iPchCzhzkIks99UFEeNnHCmJ9iWHJHph/As6vVGeBFHkwPC5fbqOgUbZzJ2b3mnKyeSXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741589150; c=relaxed/simple;
	bh=hxmTJ/e0sDCF9tLDqRpBD34u4urE7AXNJlfPxVTN1rk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AopEm0/XRcAIgBm5aPQc9urg+xgLMe9Ocxgwb2cNUV5Ltw57rs28a/uTPXSYi15P/N68crgeb1j1NjhMNgiPpPLUyax7r0lfQ+uhpGL5RUps6yR3ZDBYouDpnujduXEbLrjpmXKDSMM/eQ4/t4TNMQyhF4SlLNZHwasi1Wh8WFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vUv5vujx; arc=fail smtp.client-ip=40.107.220.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QyvKJ1+ORWYpKrBwP72mDEcyJwU1+N1pVTu3m1KuwIa1KSohKxO46pjFj2IS1oPmCY4SG6H910Lsz+lNq6MrSe6tilijr3+jFJvnznerMXpa8mbwKBGT1KCNtLXVskdic8DuZ5v0dLkifmHblXZTHOWFr4VmbwgA4queOhdNvdCZYNfRT6qSqQ0CXBCC93sTCdMyrb7wmB0BTSKd5Fwjcdzmfq4j9z2m0qJ0/qR10Jb8R+BSd8GarDDaprmJxHubJbraF4KQna2yrTYTBR6bN1KOP1T7PCh7aE/eE3BGXPlEDfU8emyiDSREh8zV/5AYiT1hg016oi43iUNZgrfx+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6eW2G8YIGdAMGsSMQhDYxsWTz/7JZ+/Ln7NTmwJKUO4=;
 b=YKe3ntHudiV/s8ULRTIXsgsN1BKSHe/stfcSYrN6EPxzwhGTweqghXuTyLAXWJZJ0ZtguVWIF6/47d2BwOAK4StOukUHHnME7c3o0WYJFccgseoaQGv+Fw9ogFmULwhro2sS0nDerym1lOgA/PC5PDhwpRkJtNVpW1+WIDxdjiJMInHN1AygCkb2llbSRFr+5h1I/VIsQrzBYQzv4DSxNBIq6F3nurEcmHZEeW7ik5a/hAUKF0GwUMIkBdP8ahq60IAtvHwF4BJtgt6CNB++gVybG7/XHetr3sP5iwNQWaoKkR/xjI5xPx0Qz+rxpXuJaudef9scG/2sV1Fgcwm1rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eW2G8YIGdAMGsSMQhDYxsWTz/7JZ+/Ln7NTmwJKUO4=;
 b=vUv5vujxeUigVFu2WvavH2+vxeAtOy41Piugm73isAs3tHkeClCznKUr5L7UU/RUUB4fpP8Z8T+WHRfR2CvJCGH/zn3I2FM5A20x94AzY34hjnpmp4NvK4LZiCMDw12OEFN3n76PYeba5RAOWyOVYg+zF6+LbZl0+QHRLjmsPq4=
Received: from BN0PR08CA0010.namprd08.prod.outlook.com (2603:10b6:408:142::11)
 by BN7PPF915F74166.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 06:45:44 +0000
Received: from BN2PEPF00004FC0.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::db) by BN0PR08CA0010.outlook.office365.com
 (2603:10b6:408:142::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.26 via Frontend Transport; Mon,
 10 Mar 2025 06:45:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FC0.mail.protection.outlook.com (10.167.243.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 06:45:44 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Mar
 2025 01:45:41 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v4 3/5] KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests
Date: Mon, 10 Mar 2025 12:15:20 +0530
Message-ID: <20250310064522.14100-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250310064522.14100-1-nikunj@amd.com>
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC0:EE_|BN7PPF915F74166:EE_
X-MS-Office365-Filtering-Correlation-Id: cd0e9ca9-1848-4c23-2311-08dd5f9f2ed8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xW3rp1x6Pg/UpFitdom7w7h353omRW6DnuzjSRHXWQrock91wC7KmaWb9DGE?=
 =?us-ascii?Q?VCchsBvZQXQU9vrrbb9/Ig/hZQv85ci3ax3caEWeb7Io0mWneE56RU9YrQO3?=
 =?us-ascii?Q?M70uWdYCfa/R9305pSglBDMoVlRFpyHtR0RqSqfRktYLUvkhB2GybSBlYrIb?=
 =?us-ascii?Q?mnUrFD5Fw6a/gy7sw+snL671jPwjQm9DQc5UEoVptHqpwNTZEw9oyQcZDzM3?=
 =?us-ascii?Q?vBTaLeS+xPFur1Wp21mm0JV3vpPkAOTN5YJmMfkmBEvtG5QTc1EQGEZeI1m/?=
 =?us-ascii?Q?oPxDiWePlCh8+HhhKuhT+DI+UocvTGMcQE7GRU27hVc9wt32T/mfwS2c3LYj?=
 =?us-ascii?Q?GxDzNHdrARoIMlELmJpykN6nPGblBs+peETDbhgU5E39yx/bLmlemZyQ19c9?=
 =?us-ascii?Q?iZqwyqw4z+o8XrTw4WtqsKUn0zGEquveDfjWxZNDmmA7K9bk9hf7LUq1pqfL?=
 =?us-ascii?Q?6oJ0YMuONT9pb+vsddZ73xNoEaokfgge1LI+upPgfSfs3ejqfp7jIUw/AlOd?=
 =?us-ascii?Q?mGREKLBp7YFyaxb9/NMOP7HOMxoQX/79/LLFNKGXco1tdh2vndGHwMq+rKOd?=
 =?us-ascii?Q?ipSJNdY8WiN6m3oxs9wacyT5sbsJOyEflwfDSThtw47fiwp9TJmL98YVcHFQ?=
 =?us-ascii?Q?Vyjn8HFdBpJEoTeSOjYWZ2TMVCEtmkCwp+M+hR36nwyNcFrwltNUSdVw1l9x?=
 =?us-ascii?Q?XtJ1KBGzFJXbshgusl4t3FEnnygG8oykPnwfcWHev8/JmEP0JoKhe7tVirLc?=
 =?us-ascii?Q?20GvVHQiYLGRFwYwaiu0O0PvLMWysyxlRBwbgvNVPuv7jQJTT9ibolgl4EVY?=
 =?us-ascii?Q?NpfYxxcX9Fb2ukzrLdQNGpDgC4WuWDBT+5poX6bIwkqbW4//Lb35G/FxMK7v?=
 =?us-ascii?Q?UQJA6Z878vKNGqGsRGoF7Nh/66V4eeINPzolznbz/QEVNvKh5Kh12tQllizH?=
 =?us-ascii?Q?oU6QVDPjPG76phpN/wAxrR9lq+tfovJWmhES/W3G6TVt+0VpfIo388IO4eP4?=
 =?us-ascii?Q?ar23lo01saz+t958q3D3iKcoqYkWeWqZ1v69c9HOfSjkI8LqboLlxVYBGHUi?=
 =?us-ascii?Q?HmjLz3vVtvPAUSemW8A/y0CtPbtXBXaX9+isCVHCeHkUEfzMXHBKI2GyS2IG?=
 =?us-ascii?Q?BgG1xT45LaPcxYZWQ9ZGUATgp65VkYD8dLUSCiXgNo4hePm2N2f+8Im7Vcve?=
 =?us-ascii?Q?YEKfnEGbbWpepn/KJDzW1hVeDrAaFiFVdNnBkMB+7T23aoh1S7ms6ToDT0vP?=
 =?us-ascii?Q?hTacAw7NptOFDOzhOR2Xs3jH8Nd5VsJUibmUQbtFOFTCwo7ipB7avH1xoZYZ?=
 =?us-ascii?Q?ZOcm9n2viv3qS+mSJwbFVnX3RjoZxkF3f8MhtTe5ZJFOgzqwcXr8pPsmaDPW?=
 =?us-ascii?Q?S/8BnUeBTWhYDSIISdtvPfYZSOQpQukv6j7lLXv1BSDith9lzIQD5SGFsXXC?=
 =?us-ascii?Q?3uUV+3Pzye6fR/wv1HFo+kDzBoOR2OkJFdvhiusEDUpXTsplRJyUChja1kTM?=
 =?us-ascii?Q?DNotzt6soUbRQwE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 06:45:44.6208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd0e9ca9-1848-4c23-2311-08dd5f9f2ed8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF915F74166

Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
guest's effective frequency in MHZ when Secure TSC is enabled for SNP
guests. Disable interception of this MSR when Secure TSC is enabled. Note
that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
hypervisor context.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     |  3 +++
 arch/x86/kvm/svm/svm.c     |  1 +
 arch/x86/kvm/svm/svm.h     | 11 ++++++++++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9b7fa99ae951..6ab66b80e751 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -290,6 +290,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..50263b473f95 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4504,6 +4504,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Clear intercepts on selected MSRs */
 	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
+
+	if (snp_secure_tsc_enabled(vcpu->kvm))
+		set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_GUEST_TSC_FREQ, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8abeab91d329..e65721db1f81 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -143,6 +143,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_AMD64_GUEST_TSC_FREQ,		.always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d4490eaed55d..711e21b7a3d0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	48
+#define MAX_DIRECT_ACCESS_MSRS	49
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -377,10 +377,19 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
 	       !WARN_ON_ONCE(!sev_es_guest(kvm));
 }
+
+static inline bool snp_secure_tsc_enabled(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
+		!WARN_ON_ONCE(!sev_snp_guest(kvm));
+}
 #else
 #define sev_guest(kvm) false
 #define sev_es_guest(kvm) false
 #define sev_snp_guest(kvm) false
+#define snp_secure_tsc_enabled(kvm) false
 #endif
 
 static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
-- 
2.43.0


