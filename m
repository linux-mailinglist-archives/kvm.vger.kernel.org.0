Return-Path: <kvm+bounces-55598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84725B33858
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 09:58:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48F3B17A8CF
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 07:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADBFC28A73A;
	Mon, 25 Aug 2025 07:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x+HV6j1v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2076.outbound.protection.outlook.com [40.107.102.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B041298CD5;
	Mon, 25 Aug 2025 07:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108728; cv=fail; b=P6wf4+18f6y8QVQxD8no8sMiBJICgaR0f6hsBjExq5XEaunyJavOKzGy+pFPzL0RXlj8Uzp2wyjSbbXJAOLY1XsZvEst2PTWyGvkol/JjLVwwYUf8ALwcNnoXIlr0vjrBn8CCzwT9I7EWLpDeAjVvAO0UFx7FICfcmB2aFmTrT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108728; c=relaxed/simple;
	bh=WWbxSL58gdBeD7Sxhop7RhyL6asxEywztE5EYaKUqvM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TQUee/8q4xB4NW4tICDM3OzENjGJjpEyWhSHeN0OIygaK2P2VgZfb+SIHNqHavVYXCTly5oyCpEXxj+OW3VxIufoPkKpkdNepApNY8fS+oxUIFp8YZkTvXfUuUaI/aTmTgjbTxboUJObRRP1buil6z6uCREdoTWCxkjg9OoCMwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x+HV6j1v; arc=fail smtp.client-ip=40.107.102.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B6PL+4AiFf4f91cXGzJEFbw9Kk3sA6xkHNXyb6cq5JgaZltTEWmyqqkovzJgRA/HTXNOPw9p17Ro4hRbktPblaHXjOUiVnZJInMIAM6240SHjLrq3C8ZlvF+vhueRKrYa0MmS3okU1h92IAOIBZ9avftVeog6YSCjDaXw14xbWeEY2pXqQ642vq2kzm60RcNq1+k5i2FRhwdF75xxg7QiIIY8f9ZX/y1gQJKVrFwbcfeHdMY0pzPA/w9uhrYdIflYjQu/W6IusYZhRhmf6nzU5opk6UGgFiVWR0/qHPK5Mw3kuq2g2uN0LPO71WRnblZZ/5ZIaZTR9rS+VaqWTAVZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLfPbvuIUrIFzBcuZcUpA2Kkj3g/ZlFe3P3mbNMz9mQ=;
 b=qZh7f2Z0Li5EKFIujF77qTQLNXVsiE/hb5N73WUpT6ckEuwulH1/JlfK4K0hiHfBaIrCa6QJTxaCNYgM5iYJtAHf1ih0IjYK8KpX04Byh74bPxBaZ9d/vU2Fvm5SlPHkkLTdzLvRiwPGBCLmEkFf84ztwVmaJ61PW/K9n18hVA62XK5YuE1cy7GDEWGC5k4oy/tUQsQ54DCDpDZGM9JK1J8HokYZkx5fkS+VfvzVmxDnM9h2GbWV1y9KOW9M/u0+xyQcnej4SJpH977JzwXDUYvTsiynbpAvObFRfpfxU4S9Ib5eJ9e3lCyU2zsGloxQlLLNpnQ+Oj2l3PRaUwsaeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLfPbvuIUrIFzBcuZcUpA2Kkj3g/ZlFe3P3mbNMz9mQ=;
 b=x+HV6j1vfd7U3d/TNHaM55Qb4bIze8Nghpc8Q/2FaaUQno3k/OTQ5ZRnzWVUF+LURM3Tttfj5Ewq1BoGmwur3W6STB2wvEGofMw0KIUvexfZqlX9absmFr1p3FtYpoSIiRUX5HoSzXbW8Ol+juiK7WRzgzg9FXSPu79at0+6S/c=
Received: from SA1P222CA0103.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::7)
 by CH3PR12MB7619.namprd12.prod.outlook.com (2603:10b6:610:14b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 07:58:43 +0000
Received: from SA2PEPF00003AE9.namprd02.prod.outlook.com
 (2603:10b6:806:3c5:cafe::96) by SA1P222CA0103.outlook.office365.com
 (2603:10b6:806:3c5::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 07:58:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AE9.mail.protection.outlook.com (10.167.248.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 25 Aug 2025 07:58:43 +0000
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:58:35 -0500
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
	Naveen N Rao <naveen@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v4 2/4] x86/cpu/topology: Always try cpu_parse_topology_ext() on AMD/Hygon
Date: Mon, 25 Aug 2025 07:57:30 +0000
Message-ID: <20250825075732.10694-3-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE9:EE_|CH3PR12MB7619:EE_
X-MS-Office365-Filtering-Correlation-Id: 246f030a-015a-4f5f-d055-08dde3ad3634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wphEsZ3Llq7OtS+BPr189DAV1YGFcijvoLP6KeLi4/XxDAavNq21yFO1fgTR?=
 =?us-ascii?Q?zn6Cj6mLdCGUGRUeuMrm3wJOb7IS6Au0jiAhSAP8Fn0JrsdN7LOp89A2+5gW?=
 =?us-ascii?Q?0xch/MGqHHO2AzeXttJXsGrRpPT1n/z4CO6s652OGsR6NO0/xbRCJMASKX4U?=
 =?us-ascii?Q?Of1jGdsfRTXeJ4H1iFUx2FUUZ1gNjAV8HXORSNYnY/xmFNbWXTyEFJZ7d5Jm?=
 =?us-ascii?Q?mTBMpfsSJSNTHU1CUp41NGIcw9eamXHLHjT/bjZYy0BJtMliG7ReaCEvNChk?=
 =?us-ascii?Q?gHxehdMHuVVHp9cpZR62g9BTienteUI9C3YmODSBzR6rVFpfaIZYDX9YGoeJ?=
 =?us-ascii?Q?A+WiHEAt6DFm2B+qrFMRVCdwZFVUWBBxQlwv38TwZyYUDrTgaT3syhYbCb5q?=
 =?us-ascii?Q?4oWhU/7wnzoftOo74RlQ4Yb9RU3QdsNiW+NiQni1ayxoZ5kJWS0M6lpWntQj?=
 =?us-ascii?Q?BxEmE08ioYjQaQNoBlkXFa2AvhRhaKf8lrxSOqGAYzYqHYRAd5iY6XIUo+BN?=
 =?us-ascii?Q?dxamZVVfU9RbSg6HkxFGltD7rWN807bSA61znpun2xw6ubCgA5w9HeQ8thyW?=
 =?us-ascii?Q?zo0IUU+uTcpoTMxtER7o7WM6MRe8CLdbX/Az6LS4m6sYbnyx4RYdU0zXqKSW?=
 =?us-ascii?Q?x8KfPew1v5QF+2kSgTHFGtnlHBXLvYQpGzRKagQrpGIwAPIxNeKiHVnAFnw8?=
 =?us-ascii?Q?KTsxjGZoWif4f2hb7RFRu8p1zcnjZYnBtPsG3hMyn5VhjA2AXvsu15STz8bL?=
 =?us-ascii?Q?js18il+B9iYRJk8hoZ87lRtQ0TV5CgLQ+xyv3tGvaXKJ8J9NyWcQLQb0kdrM?=
 =?us-ascii?Q?E4SeA5PoVAdygLAr5/F1YMHcZTtGL0725zbrhtIgZDr+qaQIwPveK6uRMcfb?=
 =?us-ascii?Q?rgWEW3+qVuG9uiD+aDi8m6n1erqOmM01vFUwvzbE+jSOqGTVwOzQoS28BjdB?=
 =?us-ascii?Q?BEhRt1tDMTa3vqoQR5YrBhehGWsvCGzPSHAcvPmpuqbJWYjJoeinLFwS9lKc?=
 =?us-ascii?Q?BwBWxCISsvX1pkVjzZK/J0OfbUGbnN5NDwFTEeg1FrXwdo5qgbN7liSYnyYT?=
 =?us-ascii?Q?KeSyzP1Ki+qqc74F3wooZla0CXoov5uISQJZ1dnNB1ms5POO5HfRuMjmmaaF?=
 =?us-ascii?Q?s+ra/mc/QMEPzO1lYJ7gqdu7NfGwVReIXWCNPkKsBipQVwfCvtRZZcOWUCxj?=
 =?us-ascii?Q?SAzDCQDLiAEKZ0RXJqXX/pFfHUQxseFriPSmDSkY12zlBkXdEc8UijCPKjQN?=
 =?us-ascii?Q?b78eIA2tkkDXO9u8lwcgaOEPIBs8pRyLAUAAR/e/dnMBrOjUoF53eNDaUlqh?=
 =?us-ascii?Q?wqwmFzHSP3fhDei0uTaF+hVDpbRnDa2DKyefFJtTEwe+BPZUe9oDLyNFuQbp?=
 =?us-ascii?Q?4SdYQvnXgn0kGjxh/X9h+ps6v51Iwn0G60ymmQ5YzIIVKueNgA9hzHiKxF6m?=
 =?us-ascii?Q?tWqmE7C+mi/wfuKx7HWGfWZRdF1+QdRqAOf2TVdPaFNimVfGta903j1tgr+R?=
 =?us-ascii?Q?9KIiS/O6U48cPtcg7GXWV2dMyA/Tic3DZc1nMYWuLXXbdkTWJo7WGQdB3g?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 07:58:43.4020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 246f030a-015a-4f5f-d055-08dde3ad3634
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7619

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

Cc: stable@vger.kernel.org # Only v6.9 and above
Link: https://lore.kernel.org/lkml/1529686927-7665-1-git-send-email-suravee.suthikulpanit@amd.com/ [1]
Link: https://lore.kernel.org/lkml/20080818181435.523309000@linux-os.sc.intel.com/ [2]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 [3]
Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Fixes: 3986a0a805e6 ("x86/CPU/AMD: Derive CPU topology from CPUID function 0xB when available")
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v3..v4:

o Quoted relevant section of the PPR justifying the changes.

o Moved this patch up ahead.

o Cc'd stable and made a note that backports should target v6.9 and
  above since this depends on the x86 topology rewrite.
---
 arch/x86/kernel/cpu/topology_amd.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index 827dd0dbb6e9..4e3134a5550c 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -175,18 +175,14 @@ static void topoext_fixup(struct topo_scan *tscan)
 
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
 	 * get SMT and CORE shift from leaf 0xb first, then try to
 	 * get the CORE shift from leaf 0x8000_0008.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_TOPOEXT))
-		has_topoext = cpu_parse_topology_ext(tscan);
+	bool has_topoext = cpu_parse_topology_ext(tscan);
 
 	if (cpu_feature_enabled(X86_FEATURE_AMD_HTR_CORES))
 		tscan->c->topo.cpu_type = cpuid_ebx(0x80000026);
-- 
2.34.1


