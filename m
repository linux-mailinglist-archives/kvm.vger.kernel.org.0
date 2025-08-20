Return-Path: <kvm+bounces-55210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0D6B2E6FD
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 22:50:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B968C1CC0764
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 20:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B3D2D6E5E;
	Wed, 20 Aug 2025 20:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yKQD1N/H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999502D3739;
	Wed, 20 Aug 2025 20:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755723045; cv=fail; b=hhzeWml/f2gL25DCY3H3vFbv6MBrwxjcWRB53tkyitZNowT0daadQG5FZG40uIIT26MGCNyi41LNGGazHZEY7sR65Vup5Ngw5KK4BQ0QDzJFlwtE+eXw+TRhj/hC8u0sUUM5C9egY0qmEjQbLe7oWyytx8w0TKLTJFnepyLj9js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755723045; c=relaxed/simple;
	bh=t7aj6QSNTobeQGKqx/cphviByEwJDJ74eVRzVirhpf0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hJ9Ut83ZtlLz8pTYgOk+usCFHe5st/7QMrqpmFjRuLVA8ssW/HiM181msA4nOknhRAa9yMWo9gjkAGlu3KBrIv5gfe/pXv7BXOYQ9s1cC0/i48pVldR4n+qu8a/usnHnBTAAC2KAlqm0LG+1IHIoMLI6LOOTAz9wOvJjNhADbuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yKQD1N/H; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yfLP5ypNjQMLbAzStNJgQ0JN2e8f1SOtEMsId02qBx32J1krQrzTsyWvzaNYYStJefqzTqfpAK8+5CsmUXKYWu3XmrRgdusjAo8M2Ww2D+fEf6KRRlCYL8BMX0nQI/fu8lrQ6zmRRm4RhVsmznfRb+5ynGRo7zSS5OqCrf7aQVj+aO17WOyKdhXWVCDqvSQ4sYqnIsnqojJDDdwhMK/KFZFfGLDPwKwo6KTpKrG+P9BnrGARyKUJAozOCFpan23Mik8QsGAeQHF2e2AE6YvPV5fCcj9rwHwW++XMTeJb3kRbqINWsQVVlq8P3JGsEOBvGFa+Fb9yZJDxClgMREZ7YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2IQtzLshUQphNTW7bWPasReC3PCAxvBVaq18tF634tE=;
 b=eBVqTUT6u9l52gcFlYD9ngFLoyXnKccqC4wQCN7qBSQC1rBG7GpHfsQmMxhaqeJ2KEeik3PQ2tEbUEwy3p/hbq4p+xCEis5jJ59HxLd8YMPaZcfbOYrHzytpG0XkrT6XDUzWLY2jA+mtA4b7xvoMzoZr9LJLbL/BHyHDqGYv6tIIJ5UQCnB+h+jRSVb+PF/x+50TNHkPrUgdUgoK2bxzLHvpRaDuUoCdtkG6Kcj5BOgAfUiE6zufZpExKhR8bfoNADLU5/uNRV8lsr6BrLikA1IgZg1H7z852MbKkxAq3zooCc/ybvg59F+nkYa3qdjz4f8F1sEhlI4/mQkbF56prA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2IQtzLshUQphNTW7bWPasReC3PCAxvBVaq18tF634tE=;
 b=yKQD1N/HzRbqh8+OSe2ak2hzUJptJycNumXadrVQ+ETqS3HJfTnYPaiPnK1O4mLaM08EY1MKQm7AKMsrq7cG3QxP2/GE7HJe8DcF29anDOnAS9lBXh8FWWTYpEM7k+7xUY+/0EM/C3omBWboRnPODrZEPkraZY7/qGxs1mldEjg=
Received: from SJ0PR03CA0073.namprd03.prod.outlook.com (2603:10b6:a03:331::18)
 by CH3PR12MB9313.namprd12.prod.outlook.com (2603:10b6:610:1ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 20 Aug
 2025 20:50:37 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:a03:331:cafe::e2) by SJ0PR03CA0073.outlook.office365.com
 (2603:10b6:a03:331::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 20:50:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 20:50:37 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 15:50:35 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <herbert@gondor.apana.org>
CC: <akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>,
	<michael.roth@amd.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v9 2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
Date: Wed, 20 Aug 2025 20:50:25 +0000
Message-ID: <95abc49edfde36d4fb791570ea2a4be6ad95fd0d.1755721927.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755721927.git.ashish.kalra@amd.com>
References: <cover.1755721927.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|CH3PR12MB9313:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cbf6a85-d941-43fe-05aa-08dde02b3749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sBBl3h0mSwzWS9eEg9nXkvsOGE27U9GKnofLzN/HZZyYXammljpLIsjATWlF?=
 =?us-ascii?Q?iY+AzpCiEGDnjkeO+jnq0lUsePBakAN/kAuCiJVOGLwNyaaCXTI3/Ws3ySom?=
 =?us-ascii?Q?8zw6bLtQcn1/EjmF3fyk44TkmkC6+bke16SzAeXxuJeFCpeQ6+dbVFbxl3h8?=
 =?us-ascii?Q?Zyz80bU95fvh3cAVjaBZ27OgPdjOimLpYkOz5gKqVuup+FUVNJnRwv0QyJ5d?=
 =?us-ascii?Q?SM1iY1EXwm46zaQVuzfsykkqjgqbSAASyxyKA4GSBYt+xqqpJNzrdATkeQeC?=
 =?us-ascii?Q?5eHtc2dqtib8k6HLIIgCDGiY1eTWZSLcrmXjenhUBTzrfGacYB2L+EM0LXk9?=
 =?us-ascii?Q?ZM4CC8S1048xJQDMTFTBPP88sIpvBWlVaJqect7vNUNy9HcKOwN9BgkmdCDL?=
 =?us-ascii?Q?C3Pzjmn2z/zDIAbgw3BSkMnA6D3vnTNqcc9B6rB+3yNNSRLGQCK1tFRfupCF?=
 =?us-ascii?Q?XUBRm6j5fsrFT1zXwQzuBFomfiKv/bG4xxmpdElOcLaBgeZ+u5jR/RWKRhzM?=
 =?us-ascii?Q?+xhcoSnHO7RdA03jFvxHzUwOSTYn0tYrAqsstoiu+OhsX0Q9B9uru6MXvVYl?=
 =?us-ascii?Q?cXUe5i6kLiKVShhAejCp69/JcgA1QW9PykiuPyzPZNVyGtA2ko5B2/gZMW7T?=
 =?us-ascii?Q?eemk8LVcxJyoenuDtCKy/Cse0q4ocQow30EtX8LOWNceD33TQ+EdxqVqFfC0?=
 =?us-ascii?Q?gtUxDNgD19TEbyOscNqSOEBBfQCxJeCP8VxJ2KBxagPquyb0g9YsBoVSYJqF?=
 =?us-ascii?Q?BwtNa0r2Mb3Cb1phJjMwPms/Je9a4x6jhTXFkUWb25deo5xpU29YZUVKaR6m?=
 =?us-ascii?Q?lM6bhP3c8iswETHuMflDMvsjK7XaYnDd3KdleE8SghsgZoP7vwDdS29T14kO?=
 =?us-ascii?Q?u6XeMdGykrfQST47zEdjR7Cr79mhGUnoAFvCSwkLbAug/cxBFf83vrLEpcGG?=
 =?us-ascii?Q?CqErFFmZcuEXAyBdZMGk6ldYb7K1XIs8+4f59ex0ljKuYq1DdrMtOS8DfCCQ?=
 =?us-ascii?Q?dKH4R4uxo08xy+vzaC4L4VwBXMy0dA4qtepUC5TBA9azOBNFf5kLIAawyIN4?=
 =?us-ascii?Q?1rDBUWm9o+oQn5FM8Jw9bPcpNntSYUXDbiEXiEIgBCGRvW/xGqtcrP9deWgk?=
 =?us-ascii?Q?G++DvW5exbAjYOIKjfgjBbQiBGqx8yWALwtp7WydTjEQRxMwK+Qcm66H2LEP?=
 =?us-ascii?Q?1z9OaAvw3IcX+V2BO3i0d2nWLm6cxlbREhQWrGIHwWjUvbtaJQXdrtrgWfe6?=
 =?us-ascii?Q?Rr5MXO4TdbEHnu+x6tlcCmICVO5zX0Lq0zxYAjc/J+Gq1fYjDXhOvCAV0vbI?=
 =?us-ascii?Q?gkyz5/zD+bikZibBv2YXIrp4mvXjgi5vFSOebzUMNO8kP+6ChgjlySQ+xsSY?=
 =?us-ascii?Q?v7qUEZvOkBDin/owqWLZzOito10oBE9xQ1q83x+U1eYo4aTnD/NGgdBxAfpm?=
 =?us-ascii?Q?PrUhkmcrpp2FFYlUkxPFVfcAt43e7HNpDtJiKqOcpVncxyZHi3yWUhmdFn8Y?=
 =?us-ascii?Q?QMVeLy59PzmCFe1yMg/YcuC3UmXO9ErZPQMlkG+epOOn7rmti35492D6gQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 20:50:37.0869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cbf6a85-d941-43fe-05aa-08dde02b3749
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9313

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext of
SNP guest private memory. Instead of reading ciphertext, the host reads
will see constant default values (0xff).

The SEV ASID space is split into SEV and SEV-ES/SEV-SNP ASID ranges.
Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
into separate ASID ranges for SEV-ES and SEV-SNP guests.

Add a new off-by-default kvm-amd module parameter to enable ciphertext
hiding and allow the admin to configure the SEV-ES and SEV-SNP ASID
ranges. Simply cap the maximum SEV-SNP ASID as appropriate, i.e. don't
reject loading KVM or disable ciphertest hiding for a too-big value, as
KVM's general approach for module params is to sanitize inputs based on
hardware/kernel support, not burn the world down. This also allows the
admin to use -1u to assign all SEV-ES/SNP ASIDs to SNP without needing
dedicated handling in KVM.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../admin-guide/kernel-parameters.txt         | 19 +++++++++++
 arch/x86/kvm/svm/sev.c                        | 32 ++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 729728280438..fd59d129ad8a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2957,6 +2957,25 @@
 			(enabled). Disable by KVM if hardware lacks support
 			for NPT.
 
+	kvm-amd.ciphertext_hiding_asids=
+			[KVM,AMD] Ciphertext hiding prevents disallowed accesses
+			to SNP private memory from reading ciphertext.  Instead,
+			reads will see constant default values (0xff).
+
+			If ciphertext hiding is enabled, the joint SEV-ES and SEV-SNP
+			ASID space is paritioned into separate SEV-ES and SEV-SNP
+			ASID ranges, with the SEV-SNP ASID range starting at 1.
+			For SEV-ES/SEV-SNP guests the maximum ASID is MIN_SEV_ASID-1,
+			where MIN_SEV_ASID value is discovered by CPUID
+			Fn8000_001F[EDX].
+
+			A non-zero value enables SEV-SNP ciphertext hiding and
+			adjusts the ASID ranges for SEV-ES and SEV-SNP guests.
+			KVM caps the number of SEV-SNP ASIDs at the maximum
+			possible value, e.g. specifying -1u will assign all
+			joint SEV-ES and SEV-SNP ASIDs to SEV-SNP and make
+			SEV-ES unusable.
+
 	kvm-arm.mode=
 			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
 			operation.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cd9ce100627e..5cad79ad1002 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,6 +59,9 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+static unsigned int nr_ciphertext_hiding_asids;
+module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 0444);
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -201,6 +204,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 	/*
 	 * The min ASID can end up larger than the max if basic SEV support is
 	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 * Similarly for SEV-ES guests the min ASID can end up larger than the
+	 * max when ciphertext hiding is enabled, effectively disabling SEV-ES
+	 * support.
 	 */
 	if (min_asid > max_asid)
 		return -ENOTTY;
@@ -3064,10 +3070,32 @@ void __init sev_hardware_setup(void)
 out:
 	if (sev_enabled) {
 		init_args.probe = true;
+
+		if (sev_is_snp_ciphertext_hiding_supported())
+			init_args.max_snp_asid = min(nr_ciphertext_hiding_asids,
+						     min_sev_asid - 1);
+
 		if (sev_platform_init(&init_args))
 			sev_supported = sev_es_supported = sev_snp_supported = false;
 		else if (sev_snp_supported)
 			sev_snp_supported = is_sev_snp_initialized();
+
+		if (sev_snp_supported)
+			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
+
+		/*
+		 * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
+		 * ASID range is partitioned into separate SEV-ES and SEV-SNP
+		 * ASID ranges, with the SEV-SNP range being [1..max_snp_asid]
+		 * and the SEV-ES range being [max_snp_asid..max_sev_es_asid].
+		 * Note, SEV-ES may effectively be disabled if all ASIDs from
+		 * the joint range are assigned to SEV-SNP.
+		 */
+		if (nr_ciphertext_hiding_asids) {
+			max_snp_asid = nr_ciphertext_hiding_asids;
+			min_sev_es_asid = max_snp_asid + 1;
+			pr_info("SEV-SNP ciphertext hiding enabled\n");
+		}
 	}
 
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -3078,7 +3106,9 @@ void __init sev_hardware_setup(void)
 			min_sev_asid, max_sev_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
-			str_enabled_disabled(sev_es_supported),
+			sev_es_supported ? min_sev_es_asid <= max_sev_es_asid ? "enabled" :
+										"unusable" :
+										"disabled",
 			min_sev_es_asid, max_sev_es_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
-- 
2.34.1


