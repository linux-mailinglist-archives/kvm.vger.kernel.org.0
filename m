Return-Path: <kvm+bounces-56516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 011DEB3ECE9
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 19:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4BCC7AC4A9
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 17:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFEB5320A0E;
	Mon,  1 Sep 2025 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jl6ar1YI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B182EC093;
	Mon,  1 Sep 2025 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756746330; cv=fail; b=UTujHGL4OFmHv8XWfS+nnHKPQUjSYLJ7CIQ6UECgsamftVe81PXFUAaJFpfHIAYIxQzXC03TjCygFxCAz/IkViHhuM1ykFgVKAY/MIv/3TdNO1vfyqBv3XzrcRvwRFSboycnqLMAB1jKWd2QRlVHppeOlw5tX8V+Vvm7xRLbnJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756746330; c=relaxed/simple;
	bh=tCj3io+qFtqAw9nPIR4o18EbCofK0eHZTbckD2650tk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nf9pLifmYsDDf0esWYkK5n1bmeq1T6sYYR2OJ46iATUH2j6ADAyBr9i2tnm8fJjqfOxb8U4cMym1XzRfnxj3eJFKp+tBhPR8sknPxCXq9fypEojYGtb9ozfP7uwj3KKRwe+MV0klrRHgxCAi/ZWWew2UzIeYF3dZ0Hqcj4TxeP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jl6ar1YI; arc=fail smtp.client-ip=40.107.244.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t2Xt2hxQiMsBqJ/ZGbZS/SXZzhT9Bjkk6lrjGc5D/LlvFeP2byMAUcakW91ApjFYr215X+xl7sSNQD8CrpwpSDJKgr98bLFT3boKk4OWjGrN4y3bpizga9RLXdTFE098FO2VVbWtxopN05BfftXJKyoIq3oGkMFAHfg2OfiSk6LOgLJ7RmaGjqbOiu+D7ynuLrvUhEmaxp2LsRoPQaVDWmy/CH4vTKpM1WiLMvgENBK4OKb9dSRmrD+9bItcVrQK6mHzKJBqskxftBxL2wyasnOZn3IVPGQ3q88w/FzjrJkYNTXjfhWeVAI6dhFcJ8B02LZdg89fNFc5F2R4zeH7Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g67+snDWidgrFUtRguvPu9bEEB3z9QFen2ZN+1WmWto=;
 b=JzrIFRObyQZ0aG1HSQ+IIE1C+ltY42P6MzHMM/hvgaL5yftQyBlosNq7psihrNs/umvcz0faSIj/GcpuMNR71uL172DpcDcngNVD9cmsz/bKUuNWJWUTLXXDQQDueCRjb6NwNQYm95JZbXMf7pqmSIWsL80tYngzMlvIPzPVJOh1oi7JztYCXSMl06VEglYVcLeVjGtsiKQnbUY3tFg7YkgeB24O70+B7G7caVsu3VQLd0eDRF1rQe+aqzYJzdIzmVKkP6gQRuqhTuhO9oqC5f1eyyJBMuMuVSoT6E+YxdB0X/AVLZud4NE42dfFQW+xkUkD+RWntUmHA+Q9NYed/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g67+snDWidgrFUtRguvPu9bEEB3z9QFen2ZN+1WmWto=;
 b=Jl6ar1YITcxdHnqF1W2Fu1MkzP/HRIIlfX/NP6DhUmKERs2ZY9JiwQPeTG69bJEpfcijEhQ5CaXL88uyELmovIpEBTGAAZi5ipFVoyL5313IRp7rO97LydeEp+UYRcZ2y5il7ygKdSyc4iVxoxVqnaTVFxLw266KXGw0VR6yYQ8=
Received: from BN9PR03CA0889.namprd03.prod.outlook.com (2603:10b6:408:13c::24)
 by CH3PR12MB9394.namprd12.prod.outlook.com (2603:10b6:610:1cf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 17:05:22 +0000
Received: from MN1PEPF0000ECD7.namprd02.prod.outlook.com
 (2603:10b6:408:13c:cafe::8c) by BN9PR03CA0889.outlook.office365.com
 (2603:10b6:408:13c::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 17:05:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 MN1PEPF0000ECD7.mail.protection.outlook.com (10.167.242.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 17:05:21 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 12:05:21 -0500
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 1 Sep
 2025 10:05:07 -0700
From: K Prateek Nayak <kprateek.nayak@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, <x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
	<babu.moger@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>, <stable@vger.kernel.org>, "Naveen N
 Rao" <naveen@kernel.org>
Subject: [PATCH v5 1/4] x86/cpu/topology: Always try cpu_parse_topology_ext() on AMD/Hygon
Date: Mon, 1 Sep 2025 17:04:15 +0000
Message-ID: <20250901170418.4314-2-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250901170418.4314-1-kprateek.nayak@amd.com>
References: <20250901170418.4314-1-kprateek.nayak@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD7:EE_|CH3PR12MB9394:EE_
X-MS-Office365-Filtering-Correlation-Id: 73624e75-417e-474e-2497-08dde979bc88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ng9vRDmxlz2f7rzqOm1AW+LxxuiTtgBD1g5moywXeiTneHA8anmMZRM3j2oQ?=
 =?us-ascii?Q?BisVnJ5ThYPnFpYYLHGU/0OKFqeDJMAegwcI49VJsvPLWPjAm3ueDe/wxl9p?=
 =?us-ascii?Q?R6g8Mo9wknkrPVVcblPFSD11JjkU3AgbC2KCgf3c2KyNCV2x1lJNf4kki1x1?=
 =?us-ascii?Q?x1NFF0cz5r+2StE6Pzt9hmbgjVDoxHEWfFaq/c/dyBN4TQOLf+YhU6fEUnXf?=
 =?us-ascii?Q?hdtTVW8dQxgyuFj0FhHSn3KqNfHxQq9WVcFc2l5DM0pFoueesvCvAtfBDGwa?=
 =?us-ascii?Q?g/bRp8ybPw+M2c04uK3gw5dp37MaoMtGZdARLPImY2eFRswCkyJbFoQ+PawY?=
 =?us-ascii?Q?X9pzY6rRXEl7uNHCQPdkdmIBhG6unRe4f++irLr+bQ04hCH5J2lN9YoTGwKg?=
 =?us-ascii?Q?7pcwDCZqpVT5ABWfo5LEK4Y5OZpOuuq3UiaESvXHC0vrfRJTTAty8M9sR2xE?=
 =?us-ascii?Q?VDifW1iH+34FFTWbmyjQRSAgOvTBsGbt5HJghiO22afbnvf51KoiX0mdp7RC?=
 =?us-ascii?Q?VVyj9SkgzDyTOzRgPzvPcBgwlXAv5eMduvGg1VVCAhRsqcZfNlhoWijyb5c2?=
 =?us-ascii?Q?dl1WAZqV48ryfyDJA6ZtphwDIKGErvHBrmKEaltV4lwPyElFh+Pi7RdBq1/7?=
 =?us-ascii?Q?PiHo6aQU0c3NQ1KtSHsT9eBq5+0lngC1QC9RD2H7foj/1UgmbI0+9pMhY0iz?=
 =?us-ascii?Q?eXh0zfwza0K+znAVJYBrJCnCZ0ISKNw/u+qMjA/mGj8Fc/FDawsYeuHFlIQv?=
 =?us-ascii?Q?N1dIvVGDKYy2odUmhO1RyEGkboUItfHCcH01FEzB+1vBYAxKLisFiY/B4gO0?=
 =?us-ascii?Q?9ggl93FyK6eRZT0MwJeaWbmHjjFjmjkLhg5Apw1l8QEJ99r6wLqgNBFwxGw+?=
 =?us-ascii?Q?qbXYBZIVzMGoFBLCx9iCUwTs3Xlq+1TSktDAPYioBA5WxI/u1/mdI0rmJytZ?=
 =?us-ascii?Q?lugA2a2WOwu7eeQ7tGAbuLM8y5QEFAGCVJ5W6F7cXpm9UXw/c0b0+F8zPe/W?=
 =?us-ascii?Q?DV6AqbT9oYOxm4WgK5ySIduqY72aB/brIEvf+to9k5uNTfsH2VYAYo92ooaZ?=
 =?us-ascii?Q?00QxzUXRa3LN8kvmkxrEyJyelXnpKmYf5UNNUFXMabCs1p61Tr9t2/DoJ3bs?=
 =?us-ascii?Q?xPAFYG3N4owAXFEZf1C91T3IqtTUV5Hh9VLJWS1duTVPA9gzEkvyyegcY7S4?=
 =?us-ascii?Q?miC22i/T293jYGc7SsWBmUI/HWuupUPnSq/lY5liVEzu3cUMNup68DiJsnRt?=
 =?us-ascii?Q?0THQoMTHj5mdtCuhG0elEQkqYVsJGAFcLp9fv5aE5B7D1zafmQOVSrUgAcEp?=
 =?us-ascii?Q?9vXU+vZnm/tLJlr6q7CD1pR+qWqc14gx8AP2WP8DzLG1Arxp0iY5ewP3Xk/X?=
 =?us-ascii?Q?r5bizRVRWiX8FxP3X26PTLfju3UlOV4cJb+80eK/E4OS1OalGYQs2lCV676E?=
 =?us-ascii?Q?bhIWuUaJpb8cWfaU+4zuZvKNJw9981gnh1h6hftmEegc1MgggCmaQ4N4nbDy?=
 =?us-ascii?Q?9idDBjV5iGQwa93WHdeYvR0V5vMKzDLMLqsbUK0wCgKc/vQpwhweFMIkgA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 17:05:21.9369
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73624e75-417e-474e-2497-08dde979bc88
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9394

Support for parsing the topology on AMD/Hygon processors using CPUID
leaf 0xb was added in commit 3986a0a805e6 ("x86/CPU/AMD: Derive CPU
topology from CPUID function 0xB when available"). In an effort to keep
all the topology parsing bits in one place, this commit also introduced
a pseudo dependency on the TOPOEXT feature to parse the CPUID leaf 0xb.

TOPOEXT feature (CPUID 0x80000001 ECX[22]) advertises the support for
Cache Properties leaf 0x8000001d and the CPUID leaf 0x8000001e EAX for
"Extended APIC ID" however support for 0xb was introduced alongside the
x2APIC support not only on AMD [1], but also historically on x86 [2].

Similar to 0xb, the support for extended CPU topology leaf 0x80000026
too does not depend on the TOPOEXT feature.

The support for these leaves is expected to be confirmed by ensuring
"leaf <= {extended_}cpuid_level" and then parsing the level 0 of the
respective leaf to confirm EBX[15:0] (LogProcAtThisLevel) is non-zero as
stated in the definition of "CPUID_Fn0000000B_EAX_x00 [Extended Topology
Enumeration] (Core::X86::Cpuid::ExtTopEnumEax0)" in Processor
Programming Reference (PPR) for AMD Family 19h Model 01h Rev B1 Vol1 [3]
Sec. 2.1.15.1 "CPUID Instruction Functions".

This has not been a problem on baremetal platforms since support for
TOPOEXT (Fam 0x15 and later) predates the support for CPUID leaf 0xb
(Fam 0x17[Zen2] and later), however, for AMD guests on QEMU, "x2apic"
feature can be enabled independent of the "topoext" feature where QEMU
expects topology and the initial APICID to be parsed using the CPUID
leaf 0xb (especially when number of cores > 255) which is populated
independent of the "topoext" feature flag.

Unconditionally call cpu_parse_topology_ext() on AMD and Hygon
processors to first parse the topology using the XTOPOLOGY leaves
(0x80000026 / 0xb) before using the TOPOEXT leaf (0x8000001e).

While at it, break down the single large comment in parse_topology_amd()
to better highlight the purpose of each CPUID leaf.

Cc: stable@vger.kernel.org # Only v6.9 and above; Depends on x86 topology rewrite
Link: https://lore.kernel.org/lkml/1529686927-7665-1-git-send-email-suravee.suthikulpanit@amd.com/ [1]
Link: https://lore.kernel.org/lkml/20080818181435.523309000@linux-os.sc.intel.com/ [2]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 [3]
Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Fixes: 3986a0a805e6 ("x86/CPU/AMD: Derive CPU topology from CPUID function 0xB when available")
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v4..v5:

o Made a note on only targeting versions >= v6.9 for stable backports
  since the fix depends on the x86 topology rewrite. (Boris)

o Renamed "has_topoext" to "has_xtopology". (Boris)

o Broke down the large comment in parse_topology_amd() to better
  highlight the purpose of each leaf and the overall parsing flow.
  (Boris)
---
 arch/x86/kernel/cpu/topology_amd.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index 827dd0dbb6e9..c79ebbb639cb 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -175,27 +175,30 @@ static void topoext_fixup(struct topo_scan *tscan)
 
 static void parse_topology_amd(struct topo_scan *tscan)
 {
-	bool has_topoext = false;
-
 	/*
-	 * If the extended topology leaf 0x8000_001e is available
-	 * try to get SMT, CORE, TILE, and DIE shifts from extended
+	 * Try to get SMT, CORE, TILE, and DIE shifts from extended
 	 * CPUID leaf 0x8000_0026 on supported processors first. If
 	 * extended CPUID leaf 0x8000_0026 is not supported, try to
-	 * get SMT and CORE shift from leaf 0xb first, then try to
-	 * get the CORE shift from leaf 0x8000_0008.
+	 * get SMT and CORE shift from leaf 0xb. If either leaf is
+	 * available, cpu_parse_topology_ext() will return true.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_TOPOEXT))
-		has_topoext = cpu_parse_topology_ext(tscan);
+	bool has_xtopology = cpu_parse_topology_ext(tscan);
 
 	if (cpu_feature_enabled(X86_FEATURE_AMD_HTR_CORES))
 		tscan->c->topo.cpu_type = cpuid_ebx(0x80000026);
 
-	if (!has_topoext && !parse_8000_0008(tscan))
+	/*
+	 * If XTOPOLOGY leaves (0x26/0xb) are not available, try to
+	 * get the CORE shift from leaf 0x8000_0008 first.
+	 */
+	if (!has_xtopology && !parse_8000_0008(tscan))
 		return;
 
-	/* Prefer leaf 0x8000001e if available */
-	if (parse_8000_001e(tscan, has_topoext))
+	/*
+	 * Prefer leaf 0x8000001e if available to get the SMT shift and
+	 * the initial APIC ID if XTOPOLOGY leaves are not available.
+	 */
+	if (parse_8000_001e(tscan, has_xtopology))
 		return;
 
 	/* Try the NODEID MSR */
-- 
2.34.1


