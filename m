Return-Path: <kvm+bounces-54869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4178FB29956
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 08:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BEFD4E0A98
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 06:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AD66271455;
	Mon, 18 Aug 2025 06:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g+P2S8I8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5549B17A300;
	Mon, 18 Aug 2025 06:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755497202; cv=fail; b=A2Sro1k1NnTaUuenH1Nijbyl8td8IjkFhzl52KTxVOIf5CV77+1T7zBOxnGMnTeltK5DSfM4TQUuizhhXk+uVh4Tvfhbb6/weWzIw/J5B0LvHbeFUBk46oQceHrT3BKO47VI4kc90pg3yuuWD1tedbnQBOJY7qYgW03JJiyo4gY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755497202; c=relaxed/simple;
	bh=IToSl09U36HY3Gkc5jEjV1iOxR3K3o0BM7XLFV72Pr4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=awmh1SdgjHp4/SO1mj3G7wfdE2XfKMT2CcVTb7EWO7L3nWPjnfHlcPsgVxoey1PwD6mItIK04YbRRZE4fNnGI3LVoShlDeBmSza+K2+h2vdcas7oL3R0AZKf52xhNe5y94lENGbkYq0ULekUlaRClddLvz6pyxK2v45uID3gIDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g+P2S8I8; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RfmVJO/H4K+dOEnPpCgXwLb5lLARE3rNEFUBxnAMHTw6LGdISiS8E0wFsjUPjj+Q4Pigp52FZtks3Ky032ZkwOGyEu0RSHz2wfQU2VtPxEF4NBpOAca2ZzgQ6x2fJuRDoEYO6HDjN8yDNVN/7qUzbMKPsuhgqrvKcj7u4p9eCiI3Bll+pMTa3Of+1obp81W5bSiSDMF+8icoLlPuiBkOywyeiwjLNWu/0pQmXFGKA0h+gxb8I9/ODgOcdcaedFNhgoGbctrsPlrsNGFSkcvDN+Ewvl0cjyifKZ4llyUR75Lgc15EejXv5SmL+GtC+fi+uwVPiuJmLbZt+OlRnQ2JUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H99iRj2k3u8wEPNCZX/+WBAR51QMckHj454E+pz31Ow=;
 b=ZPW3SwpWSqgsdeenCX8NSx938TX6GvqykQZuNEVAusI60KbobYK5IhTkieYqmcW2j9MFMKACYuF64XG4FUlSrWGw3SR70f4UazaOInMOWf4dg90DQu5m6xBgVCGKOigrAZx91x17z7Ed/zb/O7+61FDp5W36im/yikxzADVkVcnMiDCt7emC1w5WoA3Rafw3Nfx6p9MbGOcg/muSNZTUlhyusywy7oCaPaInAVOu+J2eUGpBOZn+ZOdw07FFYYRx9Iljep3jNfzFc+lLBrKruIl+RyYAH5QDTC/rAeAP2NBaSYvi5Xo6VZyIO04oA05GrQcjvDvGjaxBfHxPYJRtBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H99iRj2k3u8wEPNCZX/+WBAR51QMckHj454E+pz31Ow=;
 b=g+P2S8I8E8hSH2avWUD1wyxEVKb12zQ4BztXTaofLa06SIHsEaLFeNAvgI8i2qlth8KLfQyr2WY4Hh7UC7c0poCRozCbTq1SbwpqQAKSvUgBuQJ2GN0Yt1sG9thr1FgxFupcC46dnqx0BhTN7Doi94bmsHzw2lwy/Efzgxcd1W4=
Received: from SA9PR13CA0027.namprd13.prod.outlook.com (2603:10b6:806:21::32)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Mon, 18 Aug
 2025 06:06:36 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:806:21:cafe::68) by SA9PR13CA0027.outlook.office365.com
 (2603:10b6:806:21::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.12 via Frontend Transport; Mon,
 18 Aug 2025 06:06:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 06:06:36 +0000
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 01:06:29 -0500
From: K Prateek Nayak <kprateek.nayak@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
	<babu.moger@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH v3 4/4] x86/cpu/topology: Check for X86_FEATURE_XTOPOLOGY instead of passing has_topoext
Date: Mon, 18 Aug 2025 06:04:35 +0000
Message-ID: <20250818060435.2452-5-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818060435.2452-1-kprateek.nayak@amd.com>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: b15fca18-3aeb-40b8-f3d3-08ddde1d6399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5Q1dPYSImqVhCK3W6s7wJP/MGUkxUg3CO7cBEn2TcI9A5n+ZlS6W0VGivlBQ?=
 =?us-ascii?Q?/3Wg764M0Fepy7TX5UFcbNXYom/RWaLSKoOFQmgUO2nq2Qk04Qyf+2SEYBU4?=
 =?us-ascii?Q?gb816Yse4qvfxw+oQuog2LOAh9tvcqRJ0YLwFcwgmTDH88J87p9/ev3xjoby?=
 =?us-ascii?Q?3CbAS6Pl3r4Kvb+8fK4vWetRrihAj85xOY0XH13ZZJlxo859D5BRpN6+Qelx?=
 =?us-ascii?Q?RYSuiZN2xkpKjt44rL0wxkE0VHtwthkpzOJ9bzlgA7DRwFibpVXyuVVrFzgH?=
 =?us-ascii?Q?wMGXLE3NPWoanHvJB/wzEk3X0GEB1NogFXzLQZX6ekaEz1a1SjP2p+TsiK6f?=
 =?us-ascii?Q?yomeI5NB/Vap785aQsZXjcaF4p8K27CxBzkjMJPmwWSwJfB32sxBxV3/r+RA?=
 =?us-ascii?Q?8w02GqjLLwLitx8z/FPxxI/s8acosaB7wNATJwvBSlDAJtWMTJjzvB6+NZLA?=
 =?us-ascii?Q?jSuF92H+Xo+n+ThkzU1OVltSwTYzfAsIyh2XdNUQW3eLRgT+96Q2fpL00/+n?=
 =?us-ascii?Q?nAt8rR2DGIGCtdMXOnFgFOHXYVESVWmhGI4u9nSJ4YNRFKF4Q91nLvhMGMR5?=
 =?us-ascii?Q?V+1FtDxadNcD0aqPseubpuaMUzOovNOunSLIHFlDtgHYgIq27EarpzLFLViC?=
 =?us-ascii?Q?SPKypkQYaETPiy0e22y6R83+oDmXEQuc7t5WNHVhqLHvwUgcfy2fj2RqzMCU?=
 =?us-ascii?Q?TuFgvkMxxJU+5Zt9YjJvSwZVV0Gna75k45sDwa1z58VyKw+eAbhxDbuhENxd?=
 =?us-ascii?Q?F/IoI1IMrjon0xxZit981sutnEXMjA/SVxyTv8nynaORSNJ+YHcSTJnaT7gi?=
 =?us-ascii?Q?Nhx/G1HaxPjhMIKzRuL9AiG2rBZxHTv2yUIDSi+Bm4m4rzCReM9SKGNR+Wgc?=
 =?us-ascii?Q?0Ixe1pnXFw7Ltyb1i0eMIFr4w524IkuEBpcDpMhB4WSuIDD6/7H+qdpqXq3L?=
 =?us-ascii?Q?gytUeWUeT47tsEeNq9NOjPjlmRt468X3fqoPaEg05K5F0TqVr77AdZ21bUH/?=
 =?us-ascii?Q?6qqPqf8U2vVj4WPMa7ixFbopllzWKOnKzV/fyCDo3RkES8Bg2H0Xq0BD/vbJ?=
 =?us-ascii?Q?L//9DsPw3XeuN/aGITQCIkC5GdSomcvmJP5Yls5pf1h/TuIWQVqAIfkwr65U?=
 =?us-ascii?Q?p4Vks34Z5HdMc+otunQENW1Qc7WnWvA6uT9MyxBwVp/D94pPGoRgYTxDQ4PY?=
 =?us-ascii?Q?L3jfeBGAx7umvfTXcVF1JNsPq66PDWJLnUEeUUMJJvWDOky9ubzjfp3TEC+2?=
 =?us-ascii?Q?apNoHMH+Za1JN5EqpHYW12055YObT4f/cvwUjuBmdaiZGS5GR8bWwMshp/OZ?=
 =?us-ascii?Q?MlqmeYyqSETXsddeYT2lVtlP0Ybnuy+w2vkWle1VU6Ww6LWzdgjDVaRVTdxn?=
 =?us-ascii?Q?MfC/ImKYT+3PJ7cnX/wPdNkLvlMT8EZeeu2nv1ycpSseunqlUiLJQIyZXnth?=
 =?us-ascii?Q?sC2kZjP/cFCHHLczF3pQkAtwuPD/GeVa28srjdj4v0R7aZvtus4gVC0Hwea4?=
 =?us-ascii?Q?ww2AnTSA5WO1sipPyO/2EpohVtE+TYcLs7kq?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 06:06:36.2203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b15fca18-3aeb-40b8-f3d3-08ddde1d6399
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067

cpu_parse_topology_ext() sets X86_FEATURE_XTOPOLOGY before returning
true if any of the XTOPOLOGY leaf could be parsed successfully.

Instead of storing and passing around this return value using
"has_topoext" in parse_topology_amd(), check for X86_FEATURE_XTOPOLOGY
instead in parse_8000_001e() to simplify the flow.

No functional changes intended.

Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v2..v3:

o Use cpu_feature_enabled() when checking for X86_FEATURE_XTOPOLOGY.
---
 arch/x86/kernel/cpu/topology_amd.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index 3d01675d94f5..138a09528083 100644
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
@@ -81,7 +81,7 @@ static bool parse_8000_001e(struct topo_scan *tscan, bool has_topoext)
 
 	cpuid_leaf(0x8000001e, &leaf);
 
-	if (!has_topoext) {
+	if (!cpu_feature_enabled(X86_FEATURE_XTOPOLOGY)) {
 		/*
 		 * Prefer initial_apicid parsed from XTOPOLOGY leaf
 		 * 0x8000026 or 0xb if available. Otherwise prefer the
@@ -179,6 +179,9 @@ static void topoext_fixup(struct topo_scan *tscan)
 
 static void parse_topology_amd(struct topo_scan *tscan)
 {
+	if (cpu_feature_enabled(X86_FEATURE_AMD_HTR_CORES))
+		tscan->c->topo.cpu_type = cpuid_ebx(0x80000026);
+
 	/*
 	 * Try to get SMT, CORE, TILE, and DIE shifts from extended
 	 * CPUID leaf 0x8000_0026 on supported processors first. If
@@ -186,16 +189,11 @@ static void parse_topology_amd(struct topo_scan *tscan)
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


