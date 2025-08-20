Return-Path: <kvm+bounces-55138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D82B2DFFB
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 751B87AEE59
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 14:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AC432038D;
	Wed, 20 Aug 2025 14:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KzW5VBpZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A1326E17F;
	Wed, 20 Aug 2025 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701506; cv=fail; b=OisDEOe6mic+CLStwca6Fc8sakz6MyYGri6vxC/LuwupttL62s4dLI9RSgkrtmtvMFg6fPrnZJRdze0F+Pw6bNVCRz54DfbwLbq3Huv6DbvSTbAVis+wIFYblztBOlYTbGocfSZF9s9fpdLvDLeW8VW1tbgadYQT/z4VH5GqnkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701506; c=relaxed/simple;
	bh=W/+f9nW2cFw5UAoIeUgGL1mgUONNv4OIx5zkJm6ZYaQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n/9ggHxIcQ1Nh2XdQS6NLzvREPFK8zZzXVfp0Fwv/QAnoLtV3q1iMecSEtyM/RGs1w2uZv8lghAH4zB7TW3Kpwge2vn+kBwJiQATn1xj5J/YKaEC62/1s7oeRaureuHVAc6cdGDESLmlrMn/Yd23O17lZ+yRwsN6zwKrg4edOkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KzW5VBpZ; arc=fail smtp.client-ip=40.107.244.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JjRMG8ugDnusXoFF2VErrngOb9SyoVGfuKDJH0Ia0MJKD6VTBA8eNPgPXR/hKH6bz7jhBmbjnJ1neQD1/6/6h/60WD0t6hrozLLh1nZibaGSTXVLOtlilxW2MQtw8u6saSNIV/LulZ0t4I2FfTOKdSpIv0+XD1f5uEbvuV7rI0eBtZfQAj94AxEjWro1Ihl6/v/RBWuRk/XmCv9CLnBayRiTr+DUF64k4Quki0lJ1P94FPnj5v0WEwgKf1eNsP0roB9RI8eGPufASSlC941LYfESnUsSwrPH6ak+QREjiYdeLD+1pzVd5TGYSPosDSHJOgIyzjsWXea5vzWWzGvD0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0spiDAxsBXNDWG1LpJx1QCKvy5FBgFsnOUNQ8RfWKUk=;
 b=wWCQgnN5Lsyu/eZQnsDINUbe8p6+fwlnD3WF2jr8H+gn4QnteOIqz7BtB8zUxzYc+IIqGpWn3J2Q9NCXCRatZTRU380XFHI5u1qaYS7rmx6qWBj2DsJgB1DoWCuGOMhBNSxIq+VU6Bh0OIwOpL2E76sn4zJPNYsYk3xe/olQGFxPCRCuAafS87boVMbN7lrKryJY/5+3/76cxsaYicBdUCoL0F/0uDL95gLsNXv9m0QWWVkOmEnmY+ZaVcmS0zWpd9FuQ27uCqT5MLgguHCGE/BQs0CQH2aSfgX0oZv0KgZPW6Bgq2yB25F9/G7ETfQqTPYOAQV9qt5i8m/0KNMrwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0spiDAxsBXNDWG1LpJx1QCKvy5FBgFsnOUNQ8RfWKUk=;
 b=KzW5VBpZq5cY7fpSSEzH65vin8zPW7AK3S9cRTrLUm0EvdYAIKbWc5Nee2wbXxQ8wZW+AQWH2xauDCXvAm+2d+hrApEXIDr0I9GMjYCrXdt+31zgRdNo2jubRngxEbUpn584J0KPnAbf1evJmus+X37r8VippGiQl3c4GBtQaoo=
Received: from MW4PR03CA0276.namprd03.prod.outlook.com (2603:10b6:303:b5::11)
 by CY8PR12MB7585.namprd12.prod.outlook.com (2603:10b6:930:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 14:51:42 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:303:b5:cafe::21) by MW4PR03CA0276.outlook.office365.com
 (2603:10b6:303:b5::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 14:51:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 14:51:41 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 09:51:40 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <herbert@gondor.apana.org>
CC: <akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>,
	<michael.roth@amd.com>, <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v8 2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
Date: Wed, 20 Aug 2025 14:51:29 +0000
Message-ID: <bd3268e4c7a300db33a2cce373741f0e875474a6.1755700627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755700627.git.ashish.kalra@amd.com>
References: <cover.1755700627.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|CY8PR12MB7585:EE_
X-MS-Office365-Filtering-Correlation-Id: 64eacb54-a087-4edc-299a-08dddff91353
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CoxlWiCj2VX1B0fEc7eBEIfRNufrVvwNBQEN2aqgDugAXUKC7HBVZmX+CCUv?=
 =?us-ascii?Q?LCq+JZQeFvWQ2lNowVQ04n6ueR38aELcIaSyRaxxGbJKgTg3ikkjDUreLWwl?=
 =?us-ascii?Q?e/QWPG31/d6HX9aRclDCF1E8C9SCsjRNme4MdqyAt5gait1q6A2tjg95T6Ag?=
 =?us-ascii?Q?WteQafsbmfUCZP/V+Su6/rzBLaGeBpzc7qxTN6Fvx1VFPyPTtzHs42sATBx5?=
 =?us-ascii?Q?Ui/v2ngM6JHX2cI4l/0RDqGjacjRSMYcdJjdHEu+Yd/WeMLdLVJFZ4jrKCUN?=
 =?us-ascii?Q?Z2NqxNlfJuiE6bq1QN9I/92WEddWGSnfviCzpNiYvxC7GQGYUQ8Bqu/+jZtk?=
 =?us-ascii?Q?qwiEnSZ44sEIeg/VkV0rqXkI7uzXgNkNz38yv49e4pdRHof094DuUgVkX922?=
 =?us-ascii?Q?ZxwBKsJPOuHmALzm8oH++XvsKhmP9QtvL6OR6aBzfATXhXfDnIggfwhsXB6N?=
 =?us-ascii?Q?5oz1ZxcWKg+fu7l4cQd4L17nKmQp3sfX4JZW+jlWNj/B89psif5nB1305XTJ?=
 =?us-ascii?Q?fPGHpzaHtcFYNum3rs6lYuf87a2YRykvmLiCwQQwixZ3W3gj++xNWcpLwjGU?=
 =?us-ascii?Q?ZnaX8wsymCtw3Sl5qQgMopkRcNRrby8xMCc29oYSO7fm0Vo4oHtuyoh8zvh2?=
 =?us-ascii?Q?X7wPdpQzic4tMp58sKYEHM7nXEa4w3utJurCEbNh+QwXei45vVo6IBuVP5/k?=
 =?us-ascii?Q?HaVBWEkNXDjcxZmyj6dHoQEI1UXcxXM8SEAeom4Ta3t+Juyp7r85kZBkpAlQ?=
 =?us-ascii?Q?pS14E23ilXsGLS/IHkdwPhvtnJ9q+2Cm/J7wLzVSwrAJ6TfrIRQd+OaX38ts?=
 =?us-ascii?Q?q+F3i9zO4Vk01BP58c0u3sukRpgGTshlw+c/gO6mVacamljmMGPukqQJgbj9?=
 =?us-ascii?Q?nAyOXW2Ua+RL4EAaDw+LF0/2nVxOl/+o8K0YMaX1ICdEjsmY9L76yw+onWRN?=
 =?us-ascii?Q?NqXv88IGYgYp1VotjoS1g2wTGEX7cjUcGY7jomERY8qglMkUMWEOzvRLoene?=
 =?us-ascii?Q?bgKIWR0fyJtmLZrouVxrR3PaPD5kct14wNVHhNUlJQkyUXvili1htfsZMPE5?=
 =?us-ascii?Q?6ElYM/g8FydNC0DlcKbeOu4I31m9hBBpxVEDuXIg5Ci0Rb9FEJ5usI1iJMkS?=
 =?us-ascii?Q?0RqVlWj9vrS/E9wmsJX1dHF+5yB7cN7orQHeyTfz2db0qKlYNa3+npNJBWZ4?=
 =?us-ascii?Q?SHZOhJ4txmBUVf1oYqeGKG7YqE4YLy2RWpn9rSm5nJUdx68oorIwitJ9Elmh?=
 =?us-ascii?Q?5C+s3IHHNSMzmzjtYcxHHFQ2dmNKQu9AiiFMQ9cjkFz4GnxQsnjTky9ykRIh?=
 =?us-ascii?Q?/f+TIEospnKomHATrkSe6OcHOWafXcIG2gf8SYKNiW8DuyMQFwiq442xB/wC?=
 =?us-ascii?Q?nk9TBByoefqkQz+iAUiHfPqIYHqPy9hZ5c9+a+nlQsv/3LpDFJJQulmCBswl?=
 =?us-ascii?Q?gti3y8uomAXp1XLOoHjJh6iBMdHS9sBeVkA6CV4iNEovGwZ75UnonfXIL8Zx?=
 =?us-ascii?Q?EHHJKBz0z1TOy+bCp/nH9YzHKKjuoOAp3RrvKvZZKS7ZSoumqHhFy7M7oA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 14:51:41.9188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64eacb54-a087-4edc-299a-08dddff91353
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7585

From: Ashish Kalra <ashish.kalra@amd.com>

Ciphertext hiding prevents host accesses from reading the ciphertext of
SNP guest private memory. Instead of reading ciphertext, the host reads
will see constant default values (0xff).

The SEV ASID space is split into SEV and SEV-ES/SEV-SNP ASID ranges.
Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
into separate ASID ranges for SEV-ES and SEV-SNP guests.

Add new module parameter to the KVM module to enable ciphertext hiding
support and a user configurable system-wide maximum SNP ASID value. If
the module parameter value is '-1' then the complete SEV-ES/SEV-SNP
ASID space is allocated to SEV-SNP guests.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../admin-guide/kernel-parameters.txt         | 18 ++++++++
 arch/x86/kvm/svm/sev.c                        | 44 ++++++++++++++++++-
 2 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 729728280438..403fb346fc85 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2957,6 +2957,24 @@
 			(enabled). Disable by KVM if hardware lacks support
 			for NPT.
 
+	kvm-amd.ciphertext_hiding_asids=
+			[KVM,AMD] Ciphertext hiding prevents host accesses from reading
+			the ciphertext of SNP guest private memory. Instead of reading
+			ciphertext, the host will see constant default values (0xff).
+			The SEV ASID space is split into SEV and joint SEV-ES and SEV-SNP
+			ASID space. Ciphertext hiding further partitions the joint
+			SEV-ES/SEV-SNP ASID space into separate SEV-ES and SEV-SNP ASID
+			ranges with the SEV-SNP ASID range starting at 1. For SEV-ES/
+			SEV-SNP guests the maximum ASID available is MIN_SEV_ASID - 1
+			where MIN_SEV_ASID value is discovered by CPUID Fn8000_001F[EDX].
+
+			Format: { <unsigned int> | -1 }
+			A non-zero value enables SEV-SNP ciphertext hiding feature and sets
+			the ASID range available for SEV-SNP guests.
+			A Value of -1 assigns all ASIDs available in the joint SEV-ES
+			and SEV-SNP ASID range to SNP guests, effectively disabling
+			SEV-ES.
+
 	kvm-arm.mode=
 			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
 			operation.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cd9ce100627e..d3a3d017b361 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,6 +59,10 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+static int ciphertext_hiding_asids;
+module_param(ciphertext_hiding_asids, int, 0444);
+MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding for SEV-SNP guests and specify the number of ASIDs to use ('-1' to utilize all available SEV-SNP ASIDs");
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -201,6 +205,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 	/*
 	 * The min ASID can end up larger than the max if basic SEV support is
 	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 * Similarly for SEV-ES guests the min ASID can end up larger than the
+	 * max when ciphertext hiding is enabled, effectively disabling SEV-ES
+	 * support.
 	 */
 	if (min_asid > max_asid)
 		return -ENOTTY;
@@ -2955,6 +2962,32 @@ static bool is_sev_snp_initialized(void)
 	return initialized;
 }
 
+static bool check_and_enable_sev_snp_ciphertext_hiding(void)
+{
+	if (!ciphertext_hiding_asids)
+		return false;
+
+	if (!sev_is_snp_ciphertext_hiding_supported()) {
+		pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported\n");
+		return false;
+	}
+
+	/* Do sanity check on user-defined ciphertext_hiding_asids */
+	if (ciphertext_hiding_asids == -1) {
+		ciphertext_hiding_asids = min_sev_asid - 1;
+	} else if ((unsigned int)ciphertext_hiding_asids >= min_sev_asid) {
+		pr_warn("Module parameter ciphertext_hiding_asids (%d) invalid or exceeds or equals minimum SEV ASID (%u)\n",
+			ciphertext_hiding_asids, min_sev_asid);
+		return false;
+	}
+
+	max_snp_asid = ciphertext_hiding_asids;
+	min_sev_es_asid = max_snp_asid + 1;
+	pr_info("SEV-SNP ciphertext hiding enabled\n");
+
+	return true;
+}
+
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
@@ -3064,6 +3097,13 @@ void __init sev_hardware_setup(void)
 out:
 	if (sev_enabled) {
 		init_args.probe = true;
+		/*
+		 * The ciphertext hiding feature partitions the joint SEV-ES/SEV-SNP
+		 * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
+		 * the SEV-SNP ASID starting at 1.
+		 */
+		if (check_and_enable_sev_snp_ciphertext_hiding())
+			init_args.max_snp_asid = max_snp_asid;
 		if (sev_platform_init(&init_args))
 			sev_supported = sev_es_supported = sev_snp_supported = false;
 		else if (sev_snp_supported)
@@ -3078,7 +3118,9 @@ void __init sev_hardware_setup(void)
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


