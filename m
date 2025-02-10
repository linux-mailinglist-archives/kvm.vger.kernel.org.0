Return-Path: <kvm+bounces-37684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC87BA2E78C
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 10:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C84A161E74
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 09:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E1C1C4A24;
	Mon, 10 Feb 2025 09:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JkKdkd+e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66DB1C4A17
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 09:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739179378; cv=fail; b=VHqZM3Q40RXery0Ua5FRczDvlf6M4V6tJQnReElyO34ICr1c1hZeK2SInNtWYoaOWEQln4zKU7bTS97WJcYexIp4NZ/yaAnK4qKk9H+C/ZCF1DQvHkaEe4uKz4D1Dhl6SpWshmE0OhhCFGKYqhabTL3OOSN1hnUE0ZItAoQduTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739179378; c=relaxed/simple;
	bh=VthUpfrvKQ8s/AiaD0mKK30whEG0xsK2rh9DJ5jTbzw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1zSwzVhjUHM3UsTozuWkR6PTmRVDA8exCMHVmragjqbgzK1YrSFVIUJay+pYx9XzieUQWQOoQZJGAZm2Hn0w4trfuSuc7WveZqNrx1TFWi3ivWH8ZxFanLaHGY1IwR30BR2vvU3VrNXPQO+4F/NRqn6/0yO/R69KMjfK7av0yU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JkKdkd+e; arc=fail smtp.client-ip=40.107.101.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lJWrckhsShULhPlfCriQABC5H6yLSoBSMuV1MpwGQf1awVE/Zr1uDd9C1+5I2PcfqHCxocWY7IEB4hGmcv5rZM5tu6HMjzeWH5NYgYtLuS50LttMBgsF59qOTj/xpwb/HZo8Nhy0maYOCv6HIDesVaErnirFBzPKaz2ufJMk3D056yHhIhnDh0aF1AsaEX8zOjLhND2hJS5u0831A2jePB16B9tyrG3LXErq58jeGcQwcMMRNGk3zYJ7vrt6qRQDxXtVw15tU+j3svHBAeSBMmZY/wMEYskXXdXKx/i1KKF7QAvlCKmOFl6mj+JHsrEfKLSq2eHF+/2H5ivbUcmCKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIO9Kq+lO3SP2enn4fTWFX5aC6sZC1lkXzo4DF5Ajyk=;
 b=NHH9FZPYlQ27bqD7JS4tZAe73wEGxE5iVVsaGNiNzO5R23MifL0nvAl5m4W/+oWm+cFv1LAcDVw6Z/tCrrJ04lmqu7Bm7qUz0ZtzNks/T3QQVwQLvw9QpVrl70/XbwsKZ8dsEyqszwwGcN/Mcy+yf++wXtfRHZTZxxG3LKNG6xyHkEfu1f5cqz9NQbseQ7QTUgN8pVRfTi/dItC3LpZZwBmOo3LEheGVunxIQBG+tcgApFpFevTFKpmLsd6A3K3Ysh1JxVa8IH/p0gSNblaE6FNXAY1PYIrD4fh4RtkVNMiPxCIUICD/tpqq5E51eP3Y8TI8pW0hZO1KSM0bLtUyrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIO9Kq+lO3SP2enn4fTWFX5aC6sZC1lkXzo4DF5Ajyk=;
 b=JkKdkd+eqL//KWNN871aoYQVJvVJlaOi664teVSkh7RfQ6rlZwG9LZxLbFqvErNe4p9HydqboEI0EJMrbQTk+AWvHkBqu32+mwNseGRMBpSZ26ws8Y/QVZWIkvAfmuWzYWNPkj+5ZCd0tn7f9LbaTyumIvuIeNcj6uvPGbCBh4c=
Received: from MW4PR04CA0172.namprd04.prod.outlook.com (2603:10b6:303:85::27)
 by DM4PR12MB9070.namprd12.prod.outlook.com (2603:10b6:8:bc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.16; Mon, 10 Feb
 2025 09:22:53 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:303:85:cafe::4b) by MW4PR04CA0172.outlook.office365.com
 (2603:10b6:303:85::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Mon,
 10 Feb 2025 09:22:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Mon, 10 Feb 2025 09:22:53 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Feb
 2025 03:22:49 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v2 2/4] KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC enabled guests
Date: Mon, 10 Feb 2025 14:52:28 +0530
Message-ID: <20250210092230.151034-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250210092230.151034-1-nikunj@amd.com>
References: <20250210092230.151034-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|DM4PR12MB9070:EE_
X-MS-Office365-Filtering-Correlation-Id: c5c50ec7-3fc8-4ba9-337e-08dd49b47f1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RweQOqj8zGRLrZYih5ma2xWUDYKjhm+Wo2vLhPL4qZZzVtgBkyVMcKsRiuN1?=
 =?us-ascii?Q?MOuyO8xe6cLQ3N7R5CvJOQ7tgnJOhU2eqrcanULMkHvUq65Vqgum06/Wt2fS?=
 =?us-ascii?Q?XV1Tr8UJP137mu8rQvFPUM4bjp1a+ht5MadnA24XHp45HG+CYkJaaovi0NET?=
 =?us-ascii?Q?wDmy8pnXTe+CqKvwGhqLgthx5yIrTWyUxZmKIZ0K22UyJgNXOfGYKg2i7cpf?=
 =?us-ascii?Q?/n/CLIPiI3sdZKVc9E1lewIW6/DoweCQn1PpB+yaT0ostGxT7JEBoN8RvFR1?=
 =?us-ascii?Q?/XOU7rz8syCMSBDwagQiqj8hmo42eCFHx6k+uKUeK6a9OEACGQuzV1sUvpqC?=
 =?us-ascii?Q?GrUOQmlurCMGL6kv2assqPrlkm7HKrcUmUK2Hzp9tLCGPCexJ71Ta2jkpglQ?=
 =?us-ascii?Q?++mfixByrEsgHadNCzP5rENvxSQ0Ovvd+4zxDfgsvOIJk0EVqjOdZsrTSHRX?=
 =?us-ascii?Q?e9NvVEu/XmakSdiUfHPU3cgi+bSkESSc6cVlm0lL4T2446w+doGuGy9amq/L?=
 =?us-ascii?Q?sdx4o0TLHmsKVU7rT2OLBsJaGZG9mZRWWYfDLfhTNziBgvFMsS/04T8qeVy+?=
 =?us-ascii?Q?2udhxbXNmdDIOFv3y5tAeN+TE6DsUCMXGuq2ksnUeIMYfofgk9YEcCRKv8Hw?=
 =?us-ascii?Q?gtbxr/FdfiU0u3UKwi1/MPqApY7IG5aNYE6Q5CKtbyMTuIo2WOUJw8eHWDM7?=
 =?us-ascii?Q?BT7x310V+Sqa4qGhG07b0bVsW2k1oASBmhCFP7uNBbW1i8F3cHw8S+7sSuT5?=
 =?us-ascii?Q?AtdAdQze41So5Y3qOJ/ID09fqeuSFRnQQAI6inrisKFNgLSRWtwb2Ud4kBjE?=
 =?us-ascii?Q?5Ws8IuyTch8HDjDT7QsGik4h7Uf1a9oNo2ZItStmVOSScAVozhNlVaCVVAUT?=
 =?us-ascii?Q?2iSkPSjiKioVb2djd58Ar3WkMXebTZquaVqVkPwBISozvv+ABWDTgjeMIEDb?=
 =?us-ascii?Q?VMZojCfliFGn9fipWYCrGBssQllKL39OPKpGFeaQ6y8D8l6YCo9a5LtHf9d2?=
 =?us-ascii?Q?BYXX5PcZDOr2XNJZ9DAFfU82u8ut498cGb/0A3u7G1CpxYXUP8Tjg+szs9HE?=
 =?us-ascii?Q?y3QgQ2eRjlShif+14OZDTE21DmjJWzOc4SRMq65p8GAbdSRP608kTZgG+Ss3?=
 =?us-ascii?Q?QURoQTxfY+Q/msx44I3LVtwU8iYgp0yM6m6m3I7mjkCcSJwmLGRSrrVmHapX?=
 =?us-ascii?Q?/aeurHNYGHfz7XtArqjxkYTUcZDci/jIQghsLJ1+xotVRIBwAdJZwYcn8Upx?=
 =?us-ascii?Q?47uVjNGK+tmr8ydcthwjk0mDDXhB3INxYR62nqIvaKtaPpt4Bs/MSWhRt88t?=
 =?us-ascii?Q?sJgcME0Swp2YYnatyKr6gFzcsSrOStFPTVzbsfvLf2y+Gx9aq9gZc5DSaduA?=
 =?us-ascii?Q?1fWWCWu+g6XSwNhVmuLfkmIhnoZV4co+ikAAJLy4j5Qy0WnLjcDsOj2TbDl3?=
 =?us-ascii?Q?uawyhw0pLvNvoV+XbZRV02ImJYenhUjvedYVegoYFBl+vNE+t06Fam2f8rlg?=
 =?us-ascii?Q?eO19tPpKY+Q2BCY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 09:22:53.0280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c50ec7-3fc8-4ba9-337e-08dd49b47f1a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9070

Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns guest
effective frequency in MHZ when secure TSC is enabled for SNP guests.
Disable interception of this MSR when Secure TSC is enabled. Note that
GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
hypervisor context.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     |  2 ++
 arch/x86/kvm/svm/svm.c     |  1 +
 arch/x86/kvm/svm/svm.h     | 14 +++++++++++++-
 4 files changed, 17 insertions(+), 1 deletion(-)

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
index a2a794c32050..0a1fd5c034e2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -849,6 +849,8 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->dr6  = svm->vcpu.arch.dr6;
 
 	save->sev_features = sev->vmsa_features;
+	if (snp_secure_tsc_enabled(vcpu->kvm))
+		set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_GUEST_TSC_FREQ, 1, 1);
 
 	/*
 	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a..d7a0428aa2ae 100644
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
index 9d7cdb8fbf87..8ef582c463e0 100644
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
@@ -385,6 +385,18 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 #define sev_snp_guest(kvm) false
 #endif
 
+static inline bool snp_secure_tsc_enabled(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
+	       !WARN_ON_ONCE(!sev_snp_guest(kvm));
+#else
+	return false;
+#endif
+}
+
 static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
 {
 	return svm->sev_es.ghcb_registered_gpa == val;
-- 
2.43.0


