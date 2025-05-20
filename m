Return-Path: <kvm+bounces-47057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 769ADABCBE3
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 02:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01BAA3BD71D
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 00:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE73282FA;
	Tue, 20 May 2025 00:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uzqgLw31"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFB3335C7;
	Tue, 20 May 2025 00:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747699389; cv=fail; b=GIfnG3lcDJuREBymv4BNoJS8fbokNhKmxWZRfXxhXc1QoVa+QWVgOAGAxAN/iLsTVDRkl0yPjUTt2adreO2YhUvANf6W7+xDmdIjNdtjalQFgBO0US8flQu0MGIjvwsXYGbgoI6LI3TWHLSf8YvZ4y10Nbus+3NrAwwJQXbFiOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747699389; c=relaxed/simple;
	bh=BaNzUTImRzdPjBturwi/5uz0NwWkgavQbTPx2vz7VqY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RVcg5JeaW2mwk/DblkoAPxcayWezGbV4sTw/d8wg3CpF/o/meUWFjoV/a4inh9ZpNYXbYls7lL6T/3Bu6cwbMmeRyS3JL6gg2mu6M93La5LgXhWxALh4CwEKUK5iX7ylGwUbyeKjc7+wEYqeWNLiHcwlyH+t3ln1CrHkEPwkdUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uzqgLw31; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hDn9Yy7IMH8qpl5ausOGJlWfI6NpeGwAtqXCA1I9sv4U4dnsVmNCzsqBpA1ts61sr60LHAxZnm+T3QekyoQQhgmxr7kkdZdIpWev0oAemjwW99HTqxEi3fzhjDbE183ZqeFIImPXWedQbLkNmQ39xr2IKd0DzhDRT2d8PzlWAel1kSate1OhvoyB2nCtYAgdkygs7WgtoWiy6ODi44hiPir5bTCmiem/9E8CIiJq/Smx257+m6IyxC9pMmsQcNJFv4IIncsMsYXb7oXRk8YlHIvAPhaBCY7xcOiwQv4Q+DUdqKJH66bFHxOixyIHLGM5OD2MuVc9FFMy9g+9DvX7gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqqNuGg2xxDWvpxqCX9OYUfVnJDf8MFJJeN4KOt7hLQ=;
 b=Mp9K89cwKa478ITEcbOQMMyFEI9KkQCTTKodxVR0USA36evuVD27/UBDUw9AaHM4EwNsd7fbD+S7g6RYjWhrh5Wn7A1DgA55+IdrqkQXq3zZSvRvh56IVKW50nWBZKnt623puyERNnr9ibERcmoeqc24CSlOi9z7JlNOdfImSfeAJFD2ktstX+vu9sJpj+1UXahiU/DbVW+lggQtSBy2OtwHoftmVfn0zY9oafPB0LkVO6DUVve23RQ7xM7XYXl25xdxxIfLAJQF3sPwyaWb7eeO1cA8KbgaEhjbS4pSM4Or+pPGZ0NvVeeyoBLISQflI9L7eZY0kn0aLf/UXn0RcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqqNuGg2xxDWvpxqCX9OYUfVnJDf8MFJJeN4KOt7hLQ=;
 b=uzqgLw31fAhBX+Dp0CjQn5DRZ92Y1qwhiPRlaDxIPH1+Dgf2TP4gnPef0yQJ3PD2/5ert8I1MfaXHewub/3BFUJupqzRrwAGXzCZP9oVAfgW6zA3EewfMqgM5ZGBZQFBQpOg7kUsghcyAsJdk1ud1nZStQQUAm21MGF6ka87D4c=
Received: from SJ0PR05CA0085.namprd05.prod.outlook.com (2603:10b6:a03:332::30)
 by SJ5PPF1C7838BF6.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Tue, 20 May
 2025 00:02:59 +0000
Received: from MWH0EPF000989E7.namprd02.prod.outlook.com
 (2603:10b6:a03:332:cafe::66) by SJ0PR05CA0085.outlook.office365.com
 (2603:10b6:a03:332::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.10 via Frontend Transport; Tue,
 20 May 2025 00:02:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E7.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Tue, 20 May 2025 00:02:59 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 19 May
 2025 19:02:56 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<herbert@gondor.apana.org.au>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <rostedt@goodmis.org>
CC: <x86@kernel.org>, <thuth@redhat.com>, <ardb@kernel.org>,
	<gregkh@linuxfoundation.org>, <john.allen@amd.com>, <davem@davemloft.net>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
Subject: [PATCH v4 5/5] KVM: SEV: Add SEV-SNP CipherTextHiding support
Date: Tue, 20 May 2025 00:02:47 +0000
Message-ID: <e663930ca516aadbd71422af66e6939dd77e7b06.1747696092.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1747696092.git.ashish.kalra@amd.com>
References: <cover.1747696092.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E7:EE_|SJ5PPF1C7838BF6:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d912732-340d-4839-01bb-08dd9731ae64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|1800799024|376014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Zea+Md+zU0PAs6p4UQtqODtQXMdEMqmdiG6zmeyJC6/YChR6gwo8i9xukO09?=
 =?us-ascii?Q?TtV3HTm44yiYLl9e7zcqsoe3CUopC1B4kalNL/rKFyTgGhEH119oxcBvkmXq?=
 =?us-ascii?Q?d2utlNl3bKv/1AU/0NJ7jUoV1FeJuItntKvFnn55+rdUnuJZiHhCHuuy20IX?=
 =?us-ascii?Q?G9MKKQ+qvXWlIfQ0+c3B7IpA2hzVa6oAiwFN0uLgf7InHBwudgPWnUsE3Taz?=
 =?us-ascii?Q?+2aSuu8UxvjPECSoXXN9Bu1FnL5bOJrRBnA8/JaIK/tLCq/aAOtp5WLzrOGH?=
 =?us-ascii?Q?ja3uNIQ/TJwW0Muy87FunnO8NvhAfmiiYoI/XHKCTQxMpfBtM640Oi1U5K0x?=
 =?us-ascii?Q?vz5BLRl61XEBaZRilRfwWC/ck4aIrfvDF9cSBMerQQelZ7Wkth84ROCVCJxZ?=
 =?us-ascii?Q?dliUa2IrbT2MS029SnFwCxTYANliQ/Mz5fMr4DvjWuJ8yH1O5ZdzL2b+LZtr?=
 =?us-ascii?Q?5bfq64s3IMHLxqmm0AsAvaExkc0q2sOapN7TA4QBQ0hSKMrlavNBetMSUyMN?=
 =?us-ascii?Q?pf9Z01ISnm68Qeru5eVYOMLey/WyauGDsGy5JUDGmETc20240BY9naZoZQNn?=
 =?us-ascii?Q?TxueJHTx2v/uc8nto+J5ziQhg8CCiVeLJq+GUqHNtqA1Jepy5Yi9cbswkv9j?=
 =?us-ascii?Q?wJW7jjIZnRawJGqqwYQMqscvii5pFBLk/6/WO0ECouQ6MdkxFd7SG7Ksc823?=
 =?us-ascii?Q?9byrS1+rK1kGFHneBoVQRjQOo/DZwCFupc5o2CaJAo2ZmKRW0bipg5McJOVv?=
 =?us-ascii?Q?WWouQvKawwJ7/MIMvkgaaAc6/eDRciphQ+kqoKGOhfSTxe3zdtBWlU4Opybb?=
 =?us-ascii?Q?DEoWteLJ0QW85jJYP7pOmn6TWTfgp7E6uQGBGPGYixTsVTEP1ZcwZBVX/XT2?=
 =?us-ascii?Q?g/TOZMUrziuqeEvCHP2FBN0asJQ6WGkmKcKOpkx003HlEQEiKUhGE/Ez6Szd?=
 =?us-ascii?Q?2buAeBEHYIRceoo5nRUXWt2gta5T/dV36kTk31EjfF/XBVd61UxxBjRFCzyn?=
 =?us-ascii?Q?8gHh7ld84mHXndK6Vd6fbJbRGvhvEACooxhpG/OWK84YpmrOu6kk/BZTDMm+?=
 =?us-ascii?Q?0Ni8CdsYauO2JTb6kKBdEuqiR6KFur+EDRlVlr25qbSRbZcaII/+GFPDey3d?=
 =?us-ascii?Q?v4wCQVcZQdjen73nIQOPq1Qu2+m8cczEwqtYkHMT036Ekg1vLdDeH0ToELqn?=
 =?us-ascii?Q?SyzkJB1bThRjXQsB4zVIvg9Y+Jpog3fUbJf/VNhvriSpCbNHPh5jq72H3MOE?=
 =?us-ascii?Q?NUySE5YjBN+p1LnX76yB0ia0aEoHF6AFg2vhG93lr7TA/Bq1kly2T4Kf6S1M?=
 =?us-ascii?Q?8yesJMjH7sWnPfTbR70byEgKcA+URAE+ihCN96jNi4aNhze61EgteWvAO4uW?=
 =?us-ascii?Q?jjklc1E5Hd/fHZ4zcx9vIFknRCROwgFhnCDZ6DkqjfFXUE0/BvUYKuCDlLo9?=
 =?us-ascii?Q?pW1pYdvTWpGcXAheRUrwr2zSoiQSmDWq0FUf0r4GBsHcxpDCWUQg09wVEO7h?=
 =?us-ascii?Q?a49VglfD9Lkt4JN6zUUPm3glcKWUWzN/9GDpolgMpFlRfBCpq9HA6zKzNQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(1800799024)(376014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 00:02:59.0076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d912732-340d-4839-01bb-08dd9731ae64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1C7838BF6

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext of
SNP guest private memory. Instead of reading ciphertext, the host reads
will see constant default values (0xff).

The SEV ASID space is basically split into legacy SEV and SEV-ES+.
CipherTextHiding further partitions the SEV-ES+ ASID space into SEV-ES
and SEV-SNP.

Add new module parameter to the KVM module to enable CipherTextHiding
support and a user configurable system-wide maximum SNP ASID value. If
the module parameter value is -1 then the ASID space is equally
divided between SEV-SNP and SEV-ES guests.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../admin-guide/kernel-parameters.txt         | 10 ++++++
 arch/x86/kvm/svm/sev.c                        | 31 +++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1e5e76bba9da..2cddb2b5c59d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2891,6 +2891,16 @@
 			(enabled). Disable by KVM if hardware lacks support
 			for NPT.
 
+	kvm-amd.ciphertext_hiding_nr_asids=
+			[KVM,AMD] Enables SEV-SNP CipherTextHiding feature and
+			controls show many ASIDs are available for SEV-SNP guests.
+			The ASID space is basically split into legacy SEV and
+			SEV-ES+. CipherTextHiding feature further splits the
+			SEV-ES+ ASID space into SEV-ES and SEV-SNP.
+			If the value is -1, then it is used as an auto flag
+			and splits the ASID space equally between SEV-ES and
+			SEV-SNP ASIDs.
+
 	kvm-arm.mode=
 			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
 			operation.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 383db1da8699..68dcb13d98f2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,6 +59,10 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+static int ciphertext_hiding_nr_asids;
+module_param(ciphertext_hiding_nr_asids, int, 0444);
+MODULE_PARM_DESC(max_snp_asid, "  Number of ASIDs available for SEV-SNP guests when CipherTextHiding is enabled");
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -200,6 +204,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 	/*
 	 * The min ASID can end up larger than the max if basic SEV support is
 	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 * Similarly for SEV-ES guests the min ASID can end up larger than the
+	 * max when CipherTextHiding is enabled, effectively disabling SEV-ES
+	 * support.
 	 */
 
 	if (min_asid > max_asid)
@@ -2955,6 +2962,7 @@ void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
 	struct sev_platform_init_args init_args = {0};
+	bool snp_cipher_text_hiding = false;
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -3052,6 +3060,27 @@ void __init sev_hardware_setup(void)
 	if (min_sev_asid == 1)
 		goto out;
 
+	/*
+	 * The ASID space is basically split into legacy SEV and SEV-ES+.
+	 * CipherTextHiding feature further partitions the SEV-ES+ ASID space
+	 * into ASIDs for SEV-ES and SEV-SNP guests.
+	 */
+	if (ciphertext_hiding_nr_asids && sev_is_snp_ciphertext_hiding_supported()) {
+		/* Do sanity checks on user-defined ciphertext_hiding_nr_asids */
+		if (ciphertext_hiding_nr_asids != -1 &&
+		    ciphertext_hiding_nr_asids >= min_sev_asid) {
+			pr_info("ciphertext_hiding_nr_asids module parameter invalid, limiting SEV-SNP ASIDs to %d\n",
+				 min_sev_asid);
+			ciphertext_hiding_nr_asids = min_sev_asid - 1;
+		}
+
+		min_sev_es_asid = ciphertext_hiding_nr_asids == -1 ? (min_sev_asid - 1) / 2 :
+				  ciphertext_hiding_nr_asids + 1;
+		max_snp_asid = min_sev_es_asid - 1;
+		snp_cipher_text_hiding = true;
+		pr_info("SEV-SNP CipherTextHiding feature support enabled\n");
+	}
+
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
@@ -3092,6 +3121,8 @@ void __init sev_hardware_setup(void)
 	 * Do both SNP and SEV initialization at KVM module load.
 	 */
 	init_args.probe = true;
+	if (snp_cipher_text_hiding)
+		init_args.snp_max_snp_asid = max_snp_asid;
 	sev_platform_init(&init_args);
 }
 
-- 
2.34.1


