Return-Path: <kvm+bounces-55601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74AE8B33861
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 10:00:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66E6D3A9219
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 07:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE21229A9E9;
	Mon, 25 Aug 2025 07:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TmeEKIKR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2EB2882CC;
	Mon, 25 Aug 2025 07:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108776; cv=fail; b=IWwhVEuxtdqLex/vFx7NLtg/zwOpACremFiipgpiYi0vCmH9RRJmWg4aj4ZXujsasB7jmY2WsImbyjuzBqfYijRNQRRRoYBWG0BgxHktpDnT9F+R0d1uRJKPL5gOqzD3ncHTgesRb/WiL09FxdWRDoniuYnXJycDizSpebOTkVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108776; c=relaxed/simple;
	bh=oCSOd0UZMCeZx9UYiHXNUmCohaHZEkEMRYpnvpKNziU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ePpD0LRmWOu2MLXRaNZ1DJgUB11fQaJ6WQE4NN41cURDJNEOJdE/8O2GBP+hjmlauJENdSxurmfgpoI8fA2DA4SFe0hidfQB6//c12P7LrYZ9qPSvTM2xFXtD1IqaJjcrhAUVgU6xmxDSysRzZHn+MIJiv4rpfJSFGTf/qbXs7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TmeEKIKR; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QE6R6fIzm6eFYD+rg1BHB8G01RCkGSdxJo9qaou2jb2nNWfW1PkmOyOrd9Gqx59P0W/dJJheHHOdPInE4MdKgvDO8x/wzxcBRRxqqtntNQcU7wgHGm7vR1IrzThsLbz8WOeHRGkBhkg4JphURcWby5qN0Xm5RZ/9Y8/1XzCCiQ5qP6tjiK6tbgKwRg+su+CHBKoKl/lTz8gpUz4wgg6eJK5rozYen65YN/QI4eawnOqlkW0/zX+OYJ7pKL4+z4As6cA/pmSx7kF+Ki7c0sCtNhqvpKiin1mRt7X8kb0HPqOfKjMWCgnzN3sncCFTfzoM8oXytKuayvQDt26IAlz+sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lRbghsKVs0lpJg1ARh1Iadc/dB60vONZAJDJ73+hVw=;
 b=nncOYM/zaWsUggctFubMYOvPUtqZNaLKfVe/4atUcAjt1hX3Oq+CSXmbN/0+Mab5fj2Pj6TBIbNVULThI+XqCc0VfOy6ABvNVvHGv5OsoZXx6ozxpEqPQX55MPurL3Qs9foasZNCEbt8WjZa857kZPyowzSCLqdA3z3rqniAz43H1tspzE+OH2yw6pJp2o8wsrknMFQdDL6ByrtWXBEHGghfq+cIb4jfUw3R1MXM2A58KGNAEIubeHi6WdMk+jFadiQeRFl1sye9Yr7wesd2P4vlndZc2/GgSouD8a2pGVJ9kYejJ0lABG687o1mUQIdMZC6u3ji1LJlYV9juCCl5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lRbghsKVs0lpJg1ARh1Iadc/dB60vONZAJDJ73+hVw=;
 b=TmeEKIKRVNhJcxvu0QqliDxr2AnUWcFhxkDAduN2nrfpeI5d8e6xs7vcDof2v5ENXkxQMWbR8ZMMPsXy4hMoo33rgGpaexr1QJ0EOn1oyLOlLnOjIukj26dBB2TRibcnmFNErlU32A+GA3gAT/RK/IpUb2KooEEwd6RNHUaaw88=
Received: from SA9PR13CA0009.namprd13.prod.outlook.com (2603:10b6:806:21::14)
 by CY1PR12MB9699.namprd12.prod.outlook.com (2603:10b6:930:108::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 07:59:30 +0000
Received: from SA2PEPF00003AE8.namprd02.prod.outlook.com
 (2603:10b6:806:21:cafe::4b) by SA9PR13CA0009.outlook.office365.com
 (2603:10b6:806:21::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Mon,
 25 Aug 2025 07:59:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AE8.mail.protection.outlook.com (10.167.248.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 25 Aug 2025 07:59:30 +0000
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:59:22 -0500
From: K Prateek Nayak <kprateek.nayak@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Mario Limonciello
	<mario.limonciello@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
	Naveen N Rao <naveen@kernel.org>
Subject: [PATCH v4 4/4] x86/msr-index: Define AMD64_CPUID_FN_EXT MSR
Date: Mon, 25 Aug 2025 07:57:32 +0000
Message-ID: <20250825075732.10694-5-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825075732.10694-1-kprateek.nayak@amd.com>
References: <20250825075732.10694-1-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE8:EE_|CY1PR12MB9699:EE_
X-MS-Office365-Filtering-Correlation-Id: f9e534c2-de57-45f0-5a50-08dde3ad5248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d1V4cRtTZRS2nDBSf4z+5Mql97o+1fOpWd4ARWsAccYDrG64VwH65mXJlm0+?=
 =?us-ascii?Q?cBVxSj+MXmw0kJrRmlowNI0mQwezeTH55gyWJbYSBAgOKg0UNNnf8kViFLN5?=
 =?us-ascii?Q?YaULu4atDUA9CqflA8V27cmi7dcokvm8qE0h0aOTeew3vRg9/ux7knfDG4Yk?=
 =?us-ascii?Q?NqOkURz6yh+8H9Fp+Df0V+nJa6sP9CA9ooNX9xp/JhOgRgX670qgDI+/5Qei?=
 =?us-ascii?Q?yPYicp9VAXDaabKmbQyFzaJ/Uzq4QmCdokokerPaIcIOATcO6wqs5w/G+3Xh?=
 =?us-ascii?Q?E12ssIAi1MawWZbSpO24fgk7QG4eyIQDrg6ibb5QmzWxdjKNBFXJYCSziE8B?=
 =?us-ascii?Q?PfDkFD8yokr4Fo5kUb6TORydz6JsNvyYUaYz8UM/4TpWRCB02Ed9Mey2Ijzu?=
 =?us-ascii?Q?/5PnOT3GWnosJmCREKjcOz2zew3epYTwd1bw6Tb1DcE0aUxSPwJgxaIqnLlS?=
 =?us-ascii?Q?wFPYFSke26e5QkULY+8i6RD197gbpkF4nwkBT0H/anAgdoiHeRsFDs8S5h7K?=
 =?us-ascii?Q?QVr5Tw88kHKm9/19kaWNlJ4DJVL7shc3s0ocyUYN888wB4nOtCdVt3PS/gHj?=
 =?us-ascii?Q?bbVs1ph9ElDDrqb+yhdysXUL06ejqVo7vEPFd5HllPzOe40KUC5oVfIq61s4?=
 =?us-ascii?Q?ozo6IP7I/W6erg/h42lr/SLNxqWs6GQfA/FWeIVwZnJtIJNEqpKtkH83fMRJ?=
 =?us-ascii?Q?gJtPCVATATakV/QjJkcVtJhj7uQj7+aXcvmeZQ9AInzoP1+7wqrEzOMa19YC?=
 =?us-ascii?Q?XKGCS+qsAxKId4JCw3JzEzEuhuVTwgb3qIUgBYwwOkYo6OmKKs+/GaD9OySf?=
 =?us-ascii?Q?gu4pfjpi8dGeFzZYj/MI0HgGqifMUNVkhVdvAylDpY1j8Y2ytja63RdP7CbJ?=
 =?us-ascii?Q?RM9dTCc/cK0RsjZxPPKF//48sFPzQo5+AXTt8W0/6IrDD7xrNquwz7xSSN9Y?=
 =?us-ascii?Q?duj4e1RBWaM0rtfq6Ju2XpbApDOPA6Hp5LF6gYGQYDbzYnRLJ3WNSXCk9/0F?=
 =?us-ascii?Q?mxQIq7D4HN+eCGuwO27WxZsoYTGmiYzS3XJnJTfGnBuRGq9ge0C9uhJQa7lO?=
 =?us-ascii?Q?qFivrCj5yIMHtns31KwqIQyPL7AijqRQWcbCCD2Np04M/JdjVrd3+WqRnPUn?=
 =?us-ascii?Q?TyN8ZZ6bHCUmgrAyiv9L22PyLYeM9WjM2S9+jv9btAE2n1Jqt8M8SgODF8aP?=
 =?us-ascii?Q?a3IKF/VbtSk45pH9MctMWiXqy0QlE7VyhqaQzG5Ih22qe/C8q46T3fBv+PxB?=
 =?us-ascii?Q?PWZ7udLXBfFNgp39M/tpLn358QnAM4+hdA1QRX61pL+XgQcZmsmtchckw/Mh?=
 =?us-ascii?Q?1tqyoYVZemNSPkZeFaOtspvDyeswZQjwPXvF5ujm1s/nmqHYPt/Xl5LHZtCK?=
 =?us-ascii?Q?vyVvzEEdFAsAAetsSxaK79BCPCA4m/G9VRToGwdLfBIShLKrVIbfMOdbfmQr?=
 =?us-ascii?Q?1dFWOfm0WHjlUYtcOYArWyE85IBajPAtCs4XCdsN7uc3l2YniqAfwu1rU980?=
 =?us-ascii?Q?HEZQkkC69/HbtfOFQekgOBRYHbhJe34cc7UA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 07:59:30.5098
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e534c2-de57-45f0-5a50-08dde3ad5248
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9699

Explicitly define the AMD64_CPUID_FN_EXT MSR used to toggle the extended
features. Also define and use the bits necessary for an old TOPOEXT
fixup on AMD Family 0x15 processors.

No functional changes intended.

Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v3..v4:

o Moved this to Patch 4. No changes to diff.
---
 arch/x86/include/asm/msr-index.h   | 5 +++++
 arch/x86/kernel/cpu/topology_amd.c | 7 ++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b65c3ba5fa14..e194287177db 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -631,6 +631,11 @@
 #define MSR_AMD_PPIN			0xc00102f1
 #define MSR_AMD64_CPUID_FN_7		0xc0011002
 #define MSR_AMD64_CPUID_FN_1		0xc0011004
+
+#define MSR_AMD64_CPUID_FN_EXT				0xc0011005
+#define MSR_AMD64_CPUID_FN_EXT_TOPOEXT_ENABLED_BIT	54
+#define MSR_AMD64_CPUID_FN_EXT_TOPOEXT_ENABLED		BIT_ULL(MSR_AMD64_CPUID_FN_EXT_TOPOEXT_ENABLED_BIT)
+
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
 #define MSR_AMD64_TW_CFG		0xc0011023
diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index 12ece07b407b..6e8186f05cde 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -163,11 +163,12 @@ static void topoext_fixup(struct topo_scan *tscan)
 	    c->x86 != 0x15 || c->x86_model < 0x10 || c->x86_model > 0x6f)
 		return;
 
-	if (msr_set_bit(0xc0011005, 54) <= 0)
+	if (msr_set_bit(MSR_AMD64_CPUID_FN_EXT,
+			MSR_AMD64_CPUID_FN_EXT_TOPOEXT_ENABLED_BIT) <= 0)
 		return;
 
-	rdmsrq(0xc0011005, msrval);
-	if (msrval & BIT_64(54)) {
+	rdmsrq(MSR_AMD64_CPUID_FN_EXT, msrval);
+	if (msrval & MSR_AMD64_CPUID_FN_EXT_TOPOEXT_ENABLED) {
 		set_cpu_cap(c, X86_FEATURE_TOPOEXT);
 		pr_info_once(FW_INFO "CPU: Re-enabling disabled Topology Extensions Support.\n");
 	}
-- 
2.34.1


