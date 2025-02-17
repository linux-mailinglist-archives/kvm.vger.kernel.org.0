Return-Path: <kvm+bounces-38357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79942A3800F
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F368189907D
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E749E216E2C;
	Mon, 17 Feb 2025 10:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0dToy0Ly"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7973D215F5F
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739787789; cv=fail; b=u8QMfK4Nm3YnwdcBdAioHzwjqtIu37KFqkGT1Vz6yyiYh8CFG+yHqYIfQci+emU0EKZW467p7T311d5H8x19hoYuaA2WRxa04VoXnc4amQqF7t4Tt9l/2Vg/prhRHC8CNhMgpdgaADM39Yz9Ib/o8zK3KgdNWzKEIR2jO/2ijXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739787789; c=relaxed/simple;
	bh=MsccPwj+LqbrdmxYSUg0DzFJimy48ppHFBXW48hPHyc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qurVdC7cpbmzEVfepRjZKHHgbl9xWTLMDafmv2I1ltETHFI74S8TBz4eqTCM9xG9EC4MJ7vj1IlgbPiNLKJPaam8ybpIq0MPGkKV+zOflWythjTaAXoGpF5a5WnTsmsRtjgQua4xYK/gXDlzJhSbmT//iJAKvFSHisglopxqcdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0dToy0Ly; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkqMGBqf1WduX0N7E0w/nqGBOAYuU2brgRoz6eMLz43qyXl+wjORThvXaXfe8mmtTB2XRAB8Myxpq6Za5c88u55La4wbv3zWzUs59Uv1MluiUE7NhXhASq0DMgMzE0u1GpbSUmDs8Edep6nY+dAJK0GA7g8U7g3fPXGteJYVQzPz2ycPJd1HrqwXuubELX1uBzCR/FKMyFvdXRi52BCIxbnAgkK86Vn35Up5LhpJGXMMTBuym61FLH21tHZYteD0bio/JW92aDVl5rAAi7G2iVOJge3M6fI9roCbO8wLso1Y2QfrbFF2JQqh1UK8FmgYCHe84Xd2pG6VPkitb3hleg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pU0OcvzR/Q86MgudJIiZUYS4RrHR3symfIAo+HDbWX0=;
 b=H5mXNTTl9Qh1Tqgpw4V5TE1jER8qAbfrDmDpkn3LX0wdMH8Gksy4E5oozzkiUna6DhWMmY8wDV/GMpHyB8lb2WrDiLGX9WO3Pyt9WTucOMkVhfZ0mqnHIUDLYFDeJDbg+klSIQlv8pLQL4HJ2LsricwxVfyxlu1iJQ55PiK5dB7fd31VApkXEoUziMvzZ2CyhpdsGrPgmyXSFAo/gvkLMxEaOzDaA+ZCb3Gpdi9B+vui4mwb74UxdTGHssJJ6AAGZTxBZU2aTBBH0btq17Hi/OkFErGaDzkvlpvPtl2nvXksG3QLzQvQPf3hlCK4ljJwouYNm6jxD4WcvE1NiiQE4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pU0OcvzR/Q86MgudJIiZUYS4RrHR3symfIAo+HDbWX0=;
 b=0dToy0Lybg9XMVMW2rPlV39/oZfJkdS94ctS09tNUp90dAcfFeoQYxILUKqmvZuB2UrYQSBBtp9b4RJupX1BUl1+QUj/bJ+1oisylPm8VerqqL6mv3L0w45jR43Wy3A9qxU6/f9w0CQiGGi65gqquRPwP8lHqi0OXt37DrXd0vM=
Received: from DM6PR10CA0026.namprd10.prod.outlook.com (2603:10b6:5:60::39) by
 DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.18; Mon, 17 Feb 2025 10:23:03 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:5:60:cafe::58) by DM6PR10CA0026.outlook.office365.com
 (2603:10b6:5:60::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.17 via Frontend Transport; Mon,
 17 Feb 2025 10:23:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Mon, 17 Feb 2025 10:23:03 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Feb
 2025 04:23:00 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v3 3/5] KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests
Date: Mon, 17 Feb 2025 15:52:35 +0530
Message-ID: <20250217102237.16434-4-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|DS0PR12MB7726:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ab31a34-bbc7-4da4-d452-08dd4f3d0fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GeTpM/0GVi6CtzP8batCopRlv5LXKjc5vYR7SZaSPQI1OdDeH1b/G50+S/1A?=
 =?us-ascii?Q?up6ShxQTAFkT+192MOLniMiFgTTqFlBQzPqfNnC/UByNlsdmCMAxIiRYu1Kv?=
 =?us-ascii?Q?4y+ij/sAPZOGEr7JrDP+TtaWB4P6DdmkYJt5bWV5WeYjTswemJiDkLUM3vxl?=
 =?us-ascii?Q?aimEWnAMgwj6nmevoQN22lXPN8+VBWQbdy4FpWw8mBcT38jezLMxHMVIATdE?=
 =?us-ascii?Q?jrO2dYq2x9+MicKtwul/eCRxF69bbq1l0TuQZyyeZLB7zYg6aiBoDCxpeiDI?=
 =?us-ascii?Q?IXeTLnJBoHTRkoT4mJHIbVC7t5SAJyVEDwy4JboTm1hKlTGX/LIsh/GaJCYP?=
 =?us-ascii?Q?1FOWySM7Hc0Eh9gGRH4wZfZ2x2njs81sXswu4YFGu/A8vtwx7h/2rDLIQ0R3?=
 =?us-ascii?Q?9zuvbQD0QOBEnPJA+aJeXL4u6bh41nuwLWPSSYF3przWarb9NYJhgHE1H24D?=
 =?us-ascii?Q?bekSU09w6LFcDT4npUu3EKmHlCqO3i+KnlCrFy0m81YOIGWDBQaULzMjaWrh?=
 =?us-ascii?Q?/jb8CVi5XK1haJ3pOWqyGMxTGD12TIWqpsBiRQbTu77gjzGL6dQnpzQIMM0e?=
 =?us-ascii?Q?PrACVawwyQRjyTGxZDPqpBlBzCPJRfkiZFVOz4QK8p1n5BXFrNieGbkzqP87?=
 =?us-ascii?Q?T/pk7eTYz+QXTmmY6NqFDQ6UINh0S3HGOskZw+a0At+2QxyLhpvmcEJWuzkX?=
 =?us-ascii?Q?Kjax1CTvXLq8wvjLv0nkV4OpeIo/9VR+c4BH3gyRfRC991Xyn1w3rGcLH12K?=
 =?us-ascii?Q?sV7xfTbx5j3jwa1V73xm2GDZ/A67LZhqfPaf3o3FYhinHDcvw6JybEAUcfSs?=
 =?us-ascii?Q?LA2ipcI8BOEU2KmHXOjlJa2Pxb1ipQczsJqJB3zgnMZJTiCPpaRrxsTD3Beh?=
 =?us-ascii?Q?OCFaFxI6iAsr2VEF+HnmqCT6yeOH0fFltq7CM2fy71edSBUb4WYziQnI6rY0?=
 =?us-ascii?Q?hC19SAv2ZvsqYiCp416tPslbPNi/j+obPHOXiJQFf9EuBOaecxn7BheFrwa2?=
 =?us-ascii?Q?8NmwII4QcufRh8Dy/4VarHYV3yC85LiOHuY0KK2tn2O91vD02/216jw2YSwp?=
 =?us-ascii?Q?JQjjUHbmfUvZLPuYm5dxGwt6ryOjcBMN/qehBp2o/5eukO+VuNCRS+mNOo3f?=
 =?us-ascii?Q?/L9E6YPDWB8eUrP/GSx4o7iIKLWlTtVzSDK9mqDflVXEG4oaDJGGIhVFT59W?=
 =?us-ascii?Q?bhOvssnFdgSvg00LY01Ba74eFrY2Af3GlXY4R763b4ZhsDnpEOSH6wiNQEzH?=
 =?us-ascii?Q?zmkT0TBgQLpR+n2pc32PJpbTcogk5XWvIKISdxnWMsyMiCWfxWkZkizjrS24?=
 =?us-ascii?Q?m52IqJMwQ/fJ+VCYwbXwhLZfEXGaDqRR5rR/c6kXdDZjEHQAQ2Nj+Xkgt1R3?=
 =?us-ascii?Q?umggRTuILokknElE9x0R6ukj4kPoAmJOKdliMz1PcSB/0/yhvxlq6xV+fpFB?=
 =?us-ascii?Q?wVoTj98vk/am3zkPsaNq0DLxHW7wgRpuLWFXAScWXO01KHYPT5Gjz47YL3b2?=
 =?us-ascii?Q?4cyrTRjJWKKsbFM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 10:23:03.3336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab31a34-bbc7-4da4-d452-08dd4f3d0fdd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7726

Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
guest's effective frequency in MHZ when Secure TSC is enabled for SNP
guests. Disable interception of this MSR when Secure TSC is enabled. Note
that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
hypervisor context.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     |  2 ++
 arch/x86/kvm/svm/svm.c     |  1 +
 arch/x86/kvm/svm/svm.h     | 11 ++++++++++-
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e2fac21471f5..a04346068c60 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -289,6 +289,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
 
 #define SVM_SEV_FEAT_INT_INJ_MODES		\
 	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 74525651770a..7875bb14a2b1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -843,6 +843,8 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->dr6  = svm->vcpu.arch.dr6;
 
 	save->sev_features = sev->vmsa_features;
+	if (snp_secure_tsc_enabled(vcpu->kvm))
+		set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_GUEST_TSC_FREQ, 1, 1);
 
 	/*
 	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b8aa0f36850f..93cf508f983c 100644
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
index 5b159f017055..7335af2ab1df 100644
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


