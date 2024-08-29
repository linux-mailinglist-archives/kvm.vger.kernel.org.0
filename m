Return-Path: <kvm+bounces-25325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79D3F9639F7
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 07:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFA2FB22EC9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 05:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051BB1537DB;
	Thu, 29 Aug 2024 05:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FuCCwNo5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9351C14D70E
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 05:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724909902; cv=fail; b=NFQDyd6d6LKBuQlpXNhb9Y3TvgNNPnATKL4KRxY8aYObX7Fyy8ktjgO+Dj4dgq3KgfoB4ILq+UlFqS9BzVS3+Co+A1eP5RpkSX9xNgovm02gh1WmqJX5QrSv/6b9gwaTpEyWA32fuujyAhz+Af8T7N4CdG+rWIwerBmIKFGIoKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724909902; c=relaxed/simple;
	bh=GdwIDX2hfk6ypHPImZPUlbg9Oi1WXLbO7WZtTZIRpZU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dQicoXYh5pR5nzQwb5/6rfgOTRYR0w2sXVAOBmaRXQXvdkUdgkvcQg7hsllcraH4i5NFuxbZ6rn/gVnVWD8f1Hy74zirWPk01KlbBrWYyNJ5ZguhzTtjc14Huu0+1QwLlz8++jMkRtC/bBZQgTdca32cfpWenY8jcpIgbooxokc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FuCCwNo5; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gdviWw1q7bYUkZxHARhrMZiqZq/gQ5X98zcqOHLL+7CGSx5Ud/frQz9SiwhfS3WeBHJzpIXqJGBOvCSWGJH30UY7I686Ugvvf49xNnds+NLYTB9BtBpXIMMF10X3gHJqGIivezrNcMi1zCUQhDVCjo4dDMK+U4awz553JSFFtU5gzqGgWCwhvEeWEJLnoQOWeKiuE8nS0PBDbmqv09JTb25Z51t8fLgDgbbjHMY5eFAZQDWDvV8mHXLJyvCLI4K8+FFxUF9q1OH4CtbXQzCecd3wdSdku9uMtukpibrQ/WYP42TBTZNpLZueb1WcO243xWhwI/MxH68YY3xYzR4QdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pL6EJyMNDPteOsgaKkXoHTpK+xZI8jWwDdT32xB+j3E=;
 b=W39S75nYskntGnkY0GVCSajKOODvu9bZRjsIb+qKMeZNeiYuOilLD3RicU4Wfdk77ZienO9lVqROoA/KEaV4+X9DWb3U+qmU2aQ1WHAAXssmQqf6N92vXd2qfiRDD+6z6Lvjey3LEKOkrmKVHM1jYPPOKRaNtTagh6ejiAFvfPos8F/5fjQwFOhlqIDmLTQSGOZMVySCRPyqhKwzK6on1CYPoEG62fZZs6imG3f4qLNev8NtKghYs/cmmmpBQNppuZdXajodISTEJeEdm8Uy3ZFmA1HiwdNrrEeXxZpFgSZdmFMpRnmNsLQqtD3V0kS2QbAoI+6EnQuQo0JtIidESg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pL6EJyMNDPteOsgaKkXoHTpK+xZI8jWwDdT32xB+j3E=;
 b=FuCCwNo5woPf/DGVSXbxKLWZ8D9MK/Lqza/ags0mKCjmhorJdDwBe/GnlM0kQ6OX7PEnFN+MMREO46HZA865tGseSyPc5s5XSNGiJgq2P7yH+5FGrwchd2pj2We3L6duJ+iRqPTOcqbU0Ivun802aTaySXamIQhpBhYM9bGZmo0=
Received: from SA1PR04CA0009.namprd04.prod.outlook.com (2603:10b6:806:2ce::25)
 by SJ2PR12MB9161.namprd12.prod.outlook.com (2603:10b6:a03:566::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 29 Aug
 2024 05:38:15 +0000
Received: from SN1PEPF0002636A.namprd02.prod.outlook.com
 (2603:10b6:806:2ce:cafe::69) by SA1PR04CA0009.outlook.office365.com
 (2603:10b6:806:2ce::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Thu, 29 Aug 2024 05:38:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636A.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Thu, 29 Aug 2024 05:38:14 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 Aug
 2024 00:38:10 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>
Subject: [RFC PATCH 3/5] KVM: SVM: Add GUEST_TSC_FREQ MSR
Date: Thu, 29 Aug 2024 11:07:46 +0530
Message-ID: <20240829053748.8283-4-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240829053748.8283-1-nikunj@amd.com>
References: <20240829053748.8283-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636A:EE_|SJ2PR12MB9161:EE_
X-MS-Office365-Filtering-Correlation-Id: cf8663f2-9962-4998-c644-08dcc7ecc725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l2cRSW4enP0dZFvJvyMiQk/0dpnEhXoh2aTCrUrhwATut9x7veJTUHL/l1oX?=
 =?us-ascii?Q?AWsABClLz8YDf8YAxk/JypJkFhL+AQqbnCFwfnqihBJ4rQsUV4xgApHMkrPj?=
 =?us-ascii?Q?GMTob8SMvy4McA8HMUcduQDwEvkuWhPGOsqhVp4VRcFn4Oh0g9duT2RMgGvS?=
 =?us-ascii?Q?JEUL6Udh4ixPE0SGpgdV6UfK2H2lBD95mQ7BuiUQ5PlWqc4wxCK2Pmr305/A?=
 =?us-ascii?Q?7FaNcqQ1ebWwDRHtfTWXj30R6lnVKy2bDbtlFcgmWJnxDNHbvGS7UWDGTEue?=
 =?us-ascii?Q?/GRrlPm8SmO1+RX3k9TBLB/gP1S0WBoEgEqYjW7VLojidRzuoif4UUQSFeVf?=
 =?us-ascii?Q?Ffuq9xrhYlqQUxJDPNsFBDy+N5cwJUVyAGddyOH22XmfDgpcF6IFLXhXh03X?=
 =?us-ascii?Q?PRoSLkKF+uUrP6xtTZ7oD9klHuo0UiBmizO+IIHSLdWcFdrc5numK2izqyQa?=
 =?us-ascii?Q?GiIeOosN6c0YMsbf9cyZnxyxTYVDCQw0zHIdYYDXgwCibe3wpOk4QT5yCHIa?=
 =?us-ascii?Q?h7lfY4t1xLfkngYxTOVWNiDyvVzg2Ud1QNn8K1kbOLWTCyesBTPQhNuqjtZC?=
 =?us-ascii?Q?e2eVKoNeO/MuECfzSbA/6BXwHq1EYx9xg1VfCd0VhmuOdSp5tkOj593SjKiG?=
 =?us-ascii?Q?a/g3rT4AerWLX7P174emqo8WBYlDPWom6qXt2EDiaFI18RO1vhRiX1czp+Bs?=
 =?us-ascii?Q?GRX1b+DuCrQ3KxYRTyUais1BC5nLdr0lRR+b+8g4Vy3xLNLD1HBhc5XBplLS?=
 =?us-ascii?Q?pfguBExgS8+Hvvasa/JPJBEwhL+SetPXthR6QSlrZ3/tv8wDyR9yoxCgKm3/?=
 =?us-ascii?Q?S4bsTx3LIgfgPFwlwfVoCfzPoHDgKp7j3sYJcB8fAJCaC5b7djehgLdajynV?=
 =?us-ascii?Q?z+7EUATncAp5ZGsqBLA2cF1ZdqSxnxk2EFP/qAuhsd+rOSEQpYnHRP7HnH+8?=
 =?us-ascii?Q?X+IreeJPgxiAzwqCNh1FdjUxa3r74jcljRMkjACRYWqmjmB3ZHL4Cn9vAERr?=
 =?us-ascii?Q?X72edavwV0f0ZU5XHy8ZKp1wUnDi5UK4NOe+tTg3ndswwsXXolyohe1PvgM8?=
 =?us-ascii?Q?0o92jsotzYNssFXKFWBd9GzdDX3hgmw8EJj1YtLxRr1/dEQZgM6SL3TtzsFk?=
 =?us-ascii?Q?Zeda5oQMOibuW+LOVvA0Udx3yHtfAiwo0SBSzO0MJRk54vkmq6l+uDWUXdAB?=
 =?us-ascii?Q?ddgh3PuZHyd6a6XUQVrkq8Kc8WLDmHnnwcjGSTZ66f2h/cjJ85P5ckVR/8qn?=
 =?us-ascii?Q?bCluG8JFzzzbHmlkX5jfaj6tqOhqpTXvWdWViTnYuuzR125DXNay3622h12W?=
 =?us-ascii?Q?69kcZbzE7QAZyJ8ql8jQ1dmfP8mHOOROuQJ9C+ijkthWHem/1loURVzuqd3b?=
 =?us-ascii?Q?wXGQB38ImuNAK74mobAvlocZHIWoXPta6IthRrSZMUX4tGeqZVPDaorv07EI?=
 =?us-ascii?Q?4A5N0HJdDvSHP29TF4yxPNf3n4HLU0/I?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 05:38:14.4774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8663f2-9962-4998-c644-08dcc7ecc725
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9161

TSC calculation in Secure TSC enabled guests uses a new read-only MSR
0xc0010134 (GUEST_TSC_FREQ). Add the GUEST_TSC_FREQ MSR and disable
the interception when secure TSC is enabled. Moreover, GUEST_TSC_FREQ
MSR is only available to the guest and is not accessible from hypervisor
context.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 arch/x86/kvm/svm/sev.c           | 2 ++
 arch/x86/kvm/svm/svm.c           | 1 +
 arch/x86/kvm/svm/svm.h           | 2 +-
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 82c6a4d350e0..b15635de1290 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -586,6 +586,7 @@
 #define MSR_AMD_PERF_CTL		0xc0010062
 #define MSR_AMD_PERF_STATUS		0xc0010063
 #define MSR_AMD_PSTATE_DEF_BASE		0xc0010064
+#define MSR_AMD64_GUEST_TSC_FREQ	0xc0010134
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD_PPIN_CTL		0xc00102f0
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ff82a644b174..9adab01d9003 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -851,6 +851,8 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->dr6  = svm->vcpu.arch.dr6;
 
 	save->sev_features = sev->vmsa_features;
+	if (save->sev_features & SVM_SEV_FEAT_SECURE_TSC)
+		set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_GUEST_TSC_FREQ, 1, 1);
 
 	/*
 	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d6f252555ab3..bf86410b2f43 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -142,6 +142,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_AMD64_GUEST_TSC_FREQ,		.always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 262b638dfcb8..9d4280d564e9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	48
+#define MAX_DIRECT_ACCESS_MSRS	49
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.34.1


