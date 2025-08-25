Return-Path: <kvm+bounces-55600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8444AB3385F
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 09:59:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 462B317DC69
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 07:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BE2299AAC;
	Mon, 25 Aug 2025 07:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Q+JVsll"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB86299948;
	Mon, 25 Aug 2025 07:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108752; cv=fail; b=eB2z9eK+sfGdPD9YNo4ijB5DKjEp2g/Xjwj0h4mBNYqESC4vhklZokKqcdV6DhIWrMNqre1jPbjeLgSCjo8jdOZUlTwnNDixIWIR1RQKHqcFaFIqzR11+DdSh5tFL+7Lle5aexNgmk+Azc6pB2YD09It9dYOkLJQxK9kSAERWwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108752; c=relaxed/simple;
	bh=L5+uVN31hRzaA/zbGYKAtkfYCNMLge1sgCPnlkkvHjw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=di+/DshGPMH288bSOt3Nd1QB/SKDihSM4sP+ggOKnMkYAFhZoVCTNXpd8oVnht1/FLtYF3lL4f9ynP9SAAvzOtKwWTiQjLoI27/cTqHIaNF39qCgKK/z1Mt8ePQpysfyk2jpX/Zngsf+CuLmUJdjalhz7IqyYPKE9/2mC8jyuqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Q+JVsll; arc=fail smtp.client-ip=40.107.244.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dl9EiXaRhD9/Uf6DuQeyrr2Jnt2K5KcUjZ54ycUHMloRrVzlzz5XjkXRslL5ylGb1Aqp8akcD47TDHrfE6Di9Rp1SPYNKQrIn2w0zMAlnwoHdp5jKLgi6h4GfOIxnjM0PiMoNmWPWT7wUypqBK4dThdGzWVOGjU+SttlcSZU6IAOYPWXCW4meVGs2GnmDxw5OZXrkzFp+UafMXA0yN7OXrCqDVdZ22hSQ1y8gHP367YS7gu2sqnfxzpqBlin/YQJMv313pXpa84tjwesYV4e8pRqmO8GPKWEWlb14UBDC0nZ6jeS5treuO6I+z22SIKoahl7mUDZHt8KlFDd+Ff1yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtrHpCjGoEbUNiOEpV0kwYhmbyV8IoSdfZrj+65ppWY=;
 b=ZSpd9Hqp9JMOo8mYOGt6EWsMFlzv+MlgDXse/dtZUgCKPyJ/dQGFwJk/E1QiuM7Dm0QP70yORYd/NLLr9SUVeDABhzYMKjYo433QfrSsKuFWNQeWCebB9bxeTkVlp0kngTcGlz3Y9Q/ZSa7tIODAzVx+wUsLJTdKMNhES+OjKNPApikMJrzy2IDkaqFDbeXFgtjAdgE69M01qFOwntMlya4t2InE5xfTaQf0hvzsIx30MsCER+n7TLSkVA/8v8LkiofFrWmGIpGSecYF1Kxacjc6ftd34X8R9ffkYGJLyj1l3m+nJG+XMKwBben2Hi9gCFxRN4nCGNZlQIgZjXGHyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtrHpCjGoEbUNiOEpV0kwYhmbyV8IoSdfZrj+65ppWY=;
 b=4Q+JVsllHNqO/8E2MrtXBCmuCf33Zzls70P+UqlS6hXMOARl4lw9oPRrvbeKRsZcAAU0LIsOsliU+GnjyuwC+QNHtWIVudJHviaVaxAXk0pquS8gmVvcr8ejYdDQIhK/+rznsRxBV5AHT0vvZH0Gl/TakiwKuTGMaLc7W0IMnzk=
Received: from SA1P222CA0060.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::10)
 by BY1PR12MB8448.namprd12.prod.outlook.com (2603:10b6:a03:534::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 07:59:08 +0000
Received: from SA2PEPF00003AE7.namprd02.prod.outlook.com
 (2603:10b6:806:2c1:cafe::92) by SA1P222CA0060.outlook.office365.com
 (2603:10b6:806:2c1::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 07:59:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AE7.mail.protection.outlook.com (10.167.248.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 25 Aug 2025 07:59:07 +0000
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:58:59 -0500
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
Subject: [PATCH v4 3/4] x86/cpu/topology: Check for X86_FEATURE_XTOPOLOGY instead of passing has_topoext
Date: Mon, 25 Aug 2025 07:57:31 +0000
Message-ID: <20250825075732.10694-4-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE7:EE_|BY1PR12MB8448:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d78a4e7-aa71-4ab8-a14f-08dde3ad44ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vDYOGE73Tb+Q41C8aURhMZfdv2FZyQYfkETUFbqW7XNYjkJgbwMHUU1v92vN?=
 =?us-ascii?Q?jhNHpW6vpDNTnqIsK2WbslF2sVbvWh8ArMaRgoCtfPRqRPgqVF9+DlazTWMD?=
 =?us-ascii?Q?kPdCLSFtbLCPlKifCucED7xyrXUSJWCJNFajRHteEpg+sujNrAucE8286CzS?=
 =?us-ascii?Q?8xfBkVo/+mMIa7HNEiDBeKvWe/Ixm5GgJF9ddOt0hwwB9mB9+n1kofemTGK7?=
 =?us-ascii?Q?5WOeO2LVqxySquTAdTfv9m3lPWP1KRvkJI/RfKEzyAplkSG+AWsrPEFf0C5w?=
 =?us-ascii?Q?80H3R0ZEVbk0MHxLtYr+q62hUvtceFv+iE4VI/66H72eJsrow55J5mh8HvPa?=
 =?us-ascii?Q?SScTHJE5SYriZ8e9xndmtGan2UxKK08b/W+R6g0OfwxUCSjsF+gTIaBoKHrJ?=
 =?us-ascii?Q?X3ohF0egLfsYOyyT73mN3O8YxaoDoIaSINBTL4hW0rLmgk97NrgmCxeixn3l?=
 =?us-ascii?Q?JpWDi882Zn+Q+BXnJsFC8sMIlWptwGTd9/vpvPoZo28GkjlPZvhYUBrfDGT6?=
 =?us-ascii?Q?sA+y6mMFr+JCRQhkXQNVj3ITOC4QXwrj3XWLFO/VppyQ7Q2Y9ZOkpbaN1Ldn?=
 =?us-ascii?Q?G8qGzwiqyg8JlcUajLchNtDU40k4YyOIlElsCsMHpu3Ya4xDmeEym9gzr/we?=
 =?us-ascii?Q?O9EhLsxlEEFpaDudEk3g8nLIDZswN455Tr+q9GtAPXB70DKWsUeX1zlvwBxu?=
 =?us-ascii?Q?qIrTOw0BDGnLMYu/8G3k6sxV5jWlIl0+ItkaD23CncOgTLSFvUCkbSkyJthy?=
 =?us-ascii?Q?eq4QmXpnpLYh19ZPjksa30bWO6VkS9Xm2BnzTRIjF7szSIcMHzmj/nWN4RDd?=
 =?us-ascii?Q?h2pPBL0/1bAhYwPSlnZZxoAswRLKyguJGWk2oxYTVEz+DXaN0Mz+BWRjhx+K?=
 =?us-ascii?Q?bSC2/DCKvq7dljiDB8RtolQtf1abr35soNSvFh17BwBYzvqgwh4OMkf/GZz1?=
 =?us-ascii?Q?5BoyZV5BWSLHdE7mnkhbM6AkCRFDjAx+EWoEopkJQHeclNl4MUkfsWxWmKvs?=
 =?us-ascii?Q?Mrr0NRgVI2g9B/Jc9ng62eBXRA7gWD/PohO2o8eA8WhA2TWtxz+jgzrElZX/?=
 =?us-ascii?Q?GH4uVI4kJy5h3t0v/3NddEYpzU3iy/MSdxSkJB7q2gqKLj7RNbDi4BsKSYUh?=
 =?us-ascii?Q?Yz4TeCHmdfPf/9Bc8FXunPpkD/u+WdQQQ6SOg2bVNBZvnGCD938xsboDXlAI?=
 =?us-ascii?Q?9aGhvIDdis2nVk1ed/XJ2N2puoygxYFLHtBPYI/Be/p18e5mGqAGxZU86AHd?=
 =?us-ascii?Q?lbRTOLLqXfSusobq2ACQurCBPMjUU9DW0oXCwWf0XAoiP9adudw0L5Rzl5FU?=
 =?us-ascii?Q?c55brWQIZYTkyU7qTKGRuPVrGUZkAmcQ3of88PzPKW2tSiQQeT9NBDP0wd7A?=
 =?us-ascii?Q?3rlstjNQnGOU5Y4SO/hp/KEq36awMPa1SNfZx7k+XMztyFGE07yGjTDnAhUZ?=
 =?us-ascii?Q?iaGhpb4NOVNllU0v3C3qhn20ry+NNC8G8gJTbE/mwc8HIXvHHpNSDwcHuAAo?=
 =?us-ascii?Q?PKjvYaaszqVAgN3d9AZZLzBTSo+4oyOnJqXV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 07:59:07.8787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d78a4e7-aa71-4ab8-a14f-08dde3ad44ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8448

cpu_parse_topology_ext() sets X86_FEATURE_XTOPOLOGY before returning
true if any of the XTOPOLOGY leaf (0x80000026 / 0xb) could be parsed
successfully.

Instead of storing and passing around this return value using
"has_topoext" in parse_topology_amd(), check for X86_FEATURE_XTOPOLOGY
instead in parse_8000_001e() to simplify the flow.

No functional changes intended.

Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v3..v4:

o Moved this to Patch 3. No changes to diff.
---
 arch/x86/kernel/cpu/topology_amd.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index 4e3134a5550c..12ece07b407b 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -59,7 +59,7 @@ static void store_node(struct topo_scan *tscan, u16 nr_nodes, u16 node_id)
 	tscan->amd_node_id = node_id;
 }
 
-static bool parse_8000_001e(struct topo_scan *tscan, bool has_topoext)
+static bool parse_8000_001e(struct topo_scan *tscan)
 {
 	struct {
 		// eax
@@ -85,7 +85,7 @@ static bool parse_8000_001e(struct topo_scan *tscan, bool has_topoext)
 	 * If leaf 0xb/0x26 is available, then the APIC ID and the domain
 	 * shifts are set already.
 	 */
-	if (!has_topoext) {
+	if (!cpu_feature_enabled(X86_FEATURE_XTOPOLOGY)) {
 		tscan->c->topo.initial_apicid = leaf.ext_apic_id;
 
 		/*
@@ -175,6 +175,9 @@ static void topoext_fixup(struct topo_scan *tscan)
 
 static void parse_topology_amd(struct topo_scan *tscan)
 {
+	if (cpu_feature_enabled(X86_FEATURE_AMD_HTR_CORES))
+		tscan->c->topo.cpu_type = cpuid_ebx(0x80000026);
+
 	/*
 	 * Try to get SMT, CORE, TILE, and DIE shifts from extended
 	 * CPUID leaf 0x8000_0026 on supported processors first. If
@@ -182,16 +185,11 @@ static void parse_topology_amd(struct topo_scan *tscan)
 	 * get SMT and CORE shift from leaf 0xb first, then try to
 	 * get the CORE shift from leaf 0x8000_0008.
 	 */
-	bool has_topoext = cpu_parse_topology_ext(tscan);
-
-	if (cpu_feature_enabled(X86_FEATURE_AMD_HTR_CORES))
-		tscan->c->topo.cpu_type = cpuid_ebx(0x80000026);
-
-	if (!has_topoext && !parse_8000_0008(tscan))
+	if (!cpu_parse_topology_ext(tscan) && !parse_8000_0008(tscan))
 		return;
 
 	/* Prefer leaf 0x8000001e if available */
-	if (parse_8000_001e(tscan, has_topoext))
+	if (parse_8000_001e(tscan))
 		return;
 
 	/* Try the NODEID MSR */
-- 
2.34.1


