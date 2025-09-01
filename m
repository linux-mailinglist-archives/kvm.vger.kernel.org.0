Return-Path: <kvm+bounces-56517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FEEB3ECEE
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 19:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DB6016C985
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 17:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A72320A1F;
	Mon,  1 Sep 2025 17:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0dAOoHf0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0574320A03;
	Mon,  1 Sep 2025 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756746349; cv=fail; b=HJ1iI0eW81yyBrVJ9zqWM5r3W6NFMKhYJFQrp1UqacuAeVmfReFWSOOYtU4B4DwaiDl51oAf3cazi2QjY0Ny1XkIj09GmkxSVW+f1oNdBtfTG3v8U/ffAvOBHrrTjlTW2fQUJ3z8DK4P8B4ZZBwQYlMRNk48FWg/1WWJ0Yh9Ml8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756746349; c=relaxed/simple;
	bh=3szuD/gS97y7IfVn1WELhaVzpI2hoeA6UpbdpjtUU10=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a/4Mh+6v9dz4Opxo2vChaDW0obKrn0aqDG86/Akm+aUZxupSHprYXML1HXVPGFMDUe4n+dEo3k6/Rd0TzB3hArlobSf15uQuKZgYaveWG0Q2siMbKRQq5sNfqD45iyPePkVQ2XAquvEbSHPrceO+iVYC9eFC2fBPtotkGezcCiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0dAOoHf0; arc=fail smtp.client-ip=40.107.236.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=riPfWPnjYIRTkFpGCzGmDuX9STJXCnZX9CyKZ5sXmxeH3OFnUbVeyx6sKWup83EAWtB7SUGr83lWLxQUA3bscxZKGIUtHJGIxeqwKGkE0Ni7PIBlxuDwav9VPF/5mvS61IacwnjZxYC5Ur714INK3kjBB/M8/NVxoEudTnWwsMkGBzFjmsDV9Pq3N17W1ksYd1s7oKiembgEQft5wjPbwdIWhuARfi1geK9VY5tLIpu2dZ5AjlHJvzKpObdsPWTWDCsWWW74iSPXzRUotIJywY/9zEEZD7VtnzIZJjyR92KW+HlpKbhMUuvi92g0VD4Gp6x9nf9krV31BU5HiXhdGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSqwalCyctqqPKzCX/flTjJxElQ5ia51rxPwOUwezmo=;
 b=qzAF6KRGeCprp9r7xzpVOwzWIItZObMtECxyDc/kdTb0ItEroLpg6Cquv/IC0xwGg9zi6DPXjEZ9TK0b/+SnxYi4S0sL3uHnw9tJlR5StVhP1EVexzDQJr2Qw2Nb42wiAu1ssihVtMzedPrpojDx0SXb//443EoY/7HjjwBcjjgck3Lkr77w0qSVwr+KHkXbrX03b35RLIW9u1asDIxsnccQ9toKtk+BMS7oL38s/wyyoMJoQkFwCZAUcuTWkeW3RJA+IR3nfAtn3WzOC+dYVDLio6B/PjyNzRgrP1oTBUp7mPcaGyDsv8vIpp1oKXIu2J0BtHYObz4JwBvIQYcC6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSqwalCyctqqPKzCX/flTjJxElQ5ia51rxPwOUwezmo=;
 b=0dAOoHf01CbwsSBNRaVMQCO/fjKVGZ6fZlGfMj+I5bz/uoKKdB1jPs2XrOTQ/jlFM+eXFtvG5GLCbGt1rAEX0Wxj1aHXji5WhsCfS5+6UAFPYiE7I9C5e3IOnAMbcjzhhhG3ADAG/ATtPFDThSCIQbY+Pu3QRtcnvNrF+gVEeTQ=
Received: from BN9PR03CA0643.namprd03.prod.outlook.com (2603:10b6:408:13b::18)
 by BY5PR12MB4068.namprd12.prod.outlook.com (2603:10b6:a03:203::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Mon, 1 Sep
 2025 17:05:44 +0000
Received: from BL6PEPF0001AB77.namprd02.prod.outlook.com
 (2603:10b6:408:13b:cafe::86) by BN9PR03CA0643.outlook.office365.com
 (2603:10b6:408:13b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 17:05:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB77.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 17:05:44 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 12:05:43 -0500
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 1 Sep
 2025 10:05:35 -0700
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
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH v5 2/4] x86/cpu/topology: Check for X86_FEATURE_XTOPOLOGY instead of passing has_xtopology
Date: Mon, 1 Sep 2025 17:04:16 +0000
Message-ID: <20250901170418.4314-3-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB77:EE_|BY5PR12MB4068:EE_
X-MS-Office365-Filtering-Correlation-Id: e1089548-6d61-446d-4c0a-08dde979c9ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YvGyOp8thKuoY4UJQU6v+nalSNU4MO23kju03Y+vDzVxSSvUjFb/5TFGLqWR?=
 =?us-ascii?Q?gAu8wX8A7If9eniM952UEP2FG7dsbFL3jv1qNHroK6VStAGun+P3go0eMMkI?=
 =?us-ascii?Q?6z+RM7/UPeS9sSki95b1pR3283BJf6pn+9IAbwI5ZKMKsBMOA5LqhcDLSoTK?=
 =?us-ascii?Q?oamaDADhAAhQdpcA1rNCieq7v3KnVAGv4u9DAk+nPO5HDQ43c0VpqCpTVSWK?=
 =?us-ascii?Q?s2wmXn6j29KyYMZ3OBg7UbacxzGykPTW+UnfwYGhtTbAtBmXShi3m6gTd4Vs?=
 =?us-ascii?Q?6OGc0caGloSHXCBZdS+sbFFHwCVtEWZ98FlxnqoRKrLadoWcVPMzW5L7TLjY?=
 =?us-ascii?Q?1DUkFOoYfOmI5CvGyP+efUiochlGcKwppKGU0q8JkPp08f6RRrndaRoXFfyT?=
 =?us-ascii?Q?+Tc8eJi8BrjxMsO5zH/isaVBN/iiYY0uA7aL/+ybjcnbiGkANErbtlxaEa6i?=
 =?us-ascii?Q?5j1tgvm4tWhGGPA8AmTRUvFKgx2VeHNHw6185DR5RUObOK0WzfEIDwL8S1gH?=
 =?us-ascii?Q?/P9BgnNHX3H2HBF1tmH0rX07Q9ly7HbRDIvfAzklIC796yNPhFTN8NO81F8Y?=
 =?us-ascii?Q?R5Ld874CZlokZrVyJ91u1R+r229yS2KyiYtQwlSdw63nlF+AzW0Kyp/FZVgD?=
 =?us-ascii?Q?0eeAfd0bEA8WE+nS/V3yWdj2wlWZt+QHXY4Z7Zrx5T2jv2+pWV3W/yQrciht?=
 =?us-ascii?Q?zsFckVa6dbRRUSvIuDbdcknq2F8bEIpvY1lr3aRyVNcsXJz8eGLPKWXjcHVe?=
 =?us-ascii?Q?k8+QzVb/eFnKdFMBxFnOuS00Y+NI+aCN/8sdFeqApGHxDWe5X6rbLWZMboOo?=
 =?us-ascii?Q?WepbKqTcP1xK/6y8xMmmxXnP5kpGWk1nmrPCSXyVeY25BIVJZZpuYrP2GDCJ?=
 =?us-ascii?Q?USYCRfCtBVEE8wt5TSM1HuUHVO2XlnuSgzNmg1JkB18C3k9KLtzkEfYrL4Mi?=
 =?us-ascii?Q?IDdw3aU1lxDXc62LgA1iyQ2ZdO64t0PpJYLK3HbFEnGH12nTTq1L8VziPGXw?=
 =?us-ascii?Q?ZykqmTYXu4hWAE3sQeGnGlIFe4ql+dfpDDxD3fuuBMJUANO8nlbzhH8oS2/k?=
 =?us-ascii?Q?Ku4/SVo1kBeEvovz2keZ0Vm6QWnuJ759ZJYe+jCzom4uv4F7TdCEi8S+olyL?=
 =?us-ascii?Q?mgGM0IQTUN9vBw7y/zL/M+ppSuzNrnF9VjNy+hxgBKBBRgfn9atDy45wA8Dy?=
 =?us-ascii?Q?SoUTfaodw3TwyEKJ+QiwgYFmOoZ4yFh4FgCfK7YNRCzEA47QOqGY0Oj7/KXF?=
 =?us-ascii?Q?b5iX4zVY/8T8yBLuOQA0YPxxwwGbdyST665TqRDgFG6QEWH76F7TzNWFVNtS?=
 =?us-ascii?Q?cyyw7+EK56u/aG6ypYJ6HjpuwluHFH7WUKWaU+yDo5Mpcx83/44nLdzPqDyx?=
 =?us-ascii?Q?/TPIqLiVqI1OD8pjbpAFt+SiA+aj5U82jr1wZgy9935VowFYd64JYIn7ddUH?=
 =?us-ascii?Q?J7ZPiLxgiSuQGvmlUSoBWufDxL7wHa6TuYW1usR4SzLHh0V4oJTL8MF7SdEe?=
 =?us-ascii?Q?NlIql4ejhmiCuhryfRlJe++TjrgHFT8d00zT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 17:05:44.0004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1089548-6d61-446d-4c0a-08dde979c9ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB77.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4068

cpu_parse_topology_ext() sets X86_FEATURE_XTOPOLOGY before returning
true if any of the XTOPOLOGY leaf (0x80000026 / 0xb) could be parsed
successfully.

Instead of storing and passing around this return value using
"has_xtopology" in parse_topology_amd(), check for X86_FEATURE_XTOPOLOGY
directly in parse_8000_001e() to simplify the flow.

No functional changes intended.

Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v4..v5:

o No functional changes. The diff is slightly altered as a result of
  modifying the comment in parse_topology_amd() in Patch 1.
---
 arch/x86/kernel/cpu/topology_amd.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index c79ebbb639cb..7ebd4a15c561 100644
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
@@ -175,30 +175,27 @@ static void topoext_fixup(struct topo_scan *tscan)
 
 static void parse_topology_amd(struct topo_scan *tscan)
 {
+	if (cpu_feature_enabled(X86_FEATURE_AMD_HTR_CORES))
+		tscan->c->topo.cpu_type = cpuid_ebx(0x80000026);
+
 	/*
 	 * Try to get SMT, CORE, TILE, and DIE shifts from extended
 	 * CPUID leaf 0x8000_0026 on supported processors first. If
 	 * extended CPUID leaf 0x8000_0026 is not supported, try to
 	 * get SMT and CORE shift from leaf 0xb. If either leaf is
 	 * available, cpu_parse_topology_ext() will return true.
-	 */
-	bool has_xtopology = cpu_parse_topology_ext(tscan);
-
-	if (cpu_feature_enabled(X86_FEATURE_AMD_HTR_CORES))
-		tscan->c->topo.cpu_type = cpuid_ebx(0x80000026);
-
-	/*
+	 *
 	 * If XTOPOLOGY leaves (0x26/0xb) are not available, try to
 	 * get the CORE shift from leaf 0x8000_0008 first.
 	 */
-	if (!has_xtopology && !parse_8000_0008(tscan))
+	if (!cpu_parse_topology_ext(tscan) && !parse_8000_0008(tscan))
 		return;
 
 	/*
 	 * Prefer leaf 0x8000001e if available to get the SMT shift and
 	 * the initial APIC ID if XTOPOLOGY leaves are not available.
 	 */
-	if (parse_8000_001e(tscan, has_xtopology))
+	if (parse_8000_001e(tscan))
 		return;
 
 	/* Try the NODEID MSR */
-- 
2.34.1


