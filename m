Return-Path: <kvm+bounces-54866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B45C1B29950
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 08:05:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96175174E61
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 06:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27AB42727E9;
	Mon, 18 Aug 2025 06:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fi/vL1b5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564F52701D9;
	Mon, 18 Aug 2025 06:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755497132; cv=fail; b=h2skyxVW+DXlTa2ycehD6kbX7ljlJ1NFSIiyeZiiLV+JhOcCq+wNw0AdYk9YRHSzaz2rycDOKpQzrkSjBl0gKZ8C+JI/Z0MvEswJHY3E952imB2ybPAXad4Sur07P0kCa5EK1yS3C9ht0CIA4MB2b63RX5MvRX/jKrCyIqJ6lVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755497132; c=relaxed/simple;
	bh=PnOFrV7gtqK5WSfQKpQs8AhH5Br4i9ZWIJqgybdDDTY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BvrN0pfj9h4VHjt7+mSq9NrkLSrdO6LdU+KLLBmj4L+5DIn7xqAT9yJKzEcZOuYXK8ct0EE1vlXw/f1Rz8RSd1m3WjV8QuPxyg9TuOW3gUy1fL0zLrwuD8tPZBdFjZIwfbRDofija2uP2wvFGIb/wctomwl0kSjAFRJx3JRtbjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fi/vL1b5; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MrQ5giA6vFcG63Ux1QACLZjXJlegyDHRyAjqzV6zE6QbswPFDgj5mOAt7W1+Gov8ePsMqz+dCdypD0Z5VaN/ZwADfPdURmPCrLpI+v7rT9H1dsI7k7qr0F1+Iagd3ipuA+T1FhyKjYojWfirp/uDjp67J8uZJJyAA/ZD4Bs7LJ2YxvY8n6guAeFAC22QlhTqy67OtXr1g5iVMrXj+NzV3TVpTa/fMJ+Ml0JgXF4EMOc2CSy85o5xh6FCW5a7KHqThGqq2KAkRaHv6GnZgEzLiaCFzQoAdwOnxGOiyqYCcU1LwFOGFnE6gzkEgoKs0j8cy/pAwsllJhnratFCdOgkug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Im2w6CHU67TEcCxrg/eSXyIzxnI/edkPOAfOyz+chQ=;
 b=BTnN62+oE6CvY0g2GVVWodzpdt/yqB4DxCII36Yd6ulKMPjk+OxT4vdx0/uMgUFq40+yJ4ZL6HghdHR45KT7JPiV2wygaKW84MccvJevAkjL/cV6wPzF1txVAZBiT3T3DbViZO6RXGHgeN7j/TYqx7rxOanYrdPuoeLPnwCjEUHiCd00FB6kUQIpbZL9Kyd8LAf7NmLl98ddKZWuyFqZnDlf5HJOhONBajsHbmCvrsrM3y4aVZtKDJsm7En9m3WffdqVXymDS7DTLXwLiPq2ipvrVcAzrJENLRfrOpfHx1l3SJEPfZf+pdyT/iGl2Fu3Vt8xqh5q93VSxmfkP8hgAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Im2w6CHU67TEcCxrg/eSXyIzxnI/edkPOAfOyz+chQ=;
 b=fi/vL1b5kenh+67EfKt82qAZv+0DUypI6oJzkAmN9Y4AnNGGYscnEUBUxFd+zUouU41cR7SBKbsx54pHiUqn4DwKNyQKS27kx/kIYZDeCVbr3ebDIyouId3bNXIHaEVXArf1HA+ygC4oFTftkQ8sgS8UvdgwV6O/NMvsi4Guqzo=
Received: from BY5PR13CA0036.namprd13.prod.outlook.com (2603:10b6:a03:180::49)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 06:05:26 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:a03:180:cafe::13) by BY5PR13CA0036.outlook.office365.com
 (2603:10b6:a03:180::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.12 via Frontend Transport; Mon,
 18 Aug 2025 06:05:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 06:05:25 +0000
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 01:05:16 -0500
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
Subject: [PATCH v3 1/4] x86/msr-index: Define AMD64_CPUID_FN_EXT MSR
Date: Mon, 18 Aug 2025 06:04:32 +0000
Message-ID: <20250818060435.2452-2-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|DM6PR12MB4267:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aedb652-d94b-4871-e96f-08ddde1d3991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UquGnuIDjJWBAiTQg/2k0d9oqz1pg+BjY+Ht1CraO+P8i31FCxMR0eo8juT2?=
 =?us-ascii?Q?a65Hr+F6wfBJw4aeATLRWV96LSDbeBYlxoHbDwPUhkolFEdSMrSTZ2z1zi+L?=
 =?us-ascii?Q?79A9m9Ydt93WQrfrn7M5qnPXXmNflGbzrZSyFicstfDAWCxV+ad6xAUzuKG/?=
 =?us-ascii?Q?t2qBMSAFS3SUYbVs77LJYHKBq0dxCLKqDGEZgq05ybe3ggt6TeH5u5DZ5nFM?=
 =?us-ascii?Q?0gv+kYq4XhP98k4HkTX3c/YivrfXS5KAi8sz87yaz6IMLh1isT61a7wjdfuQ?=
 =?us-ascii?Q?2btmHRO5Dcpewhk9eNmY1ELa9m81f2F8vW64LNFoqIYJsFQLLuwG88DX0rmI?=
 =?us-ascii?Q?TAx2vYZphJ8uAkKc3TkzK5cj/PUscr8o0hBFr865Ai8/nXiFwhw2IPwRTF3F?=
 =?us-ascii?Q?kfaHHnZul6QaaK7DWShCwMLjzBBhjClhLns83+1FwahVuLsydRjakFjKajFA?=
 =?us-ascii?Q?hLfS8QOgH/yzbMLU6sCPKLC+vTzd+0tMkIdIDzK7x0UDuT6mQmlyFHWcFWZ+?=
 =?us-ascii?Q?Os7QxJgzeHWZ3RgUngSvcmFE5uPlTSEwzJqv2SLNamL6M0k0mCsG1qovUrR9?=
 =?us-ascii?Q?cw84q87Qcb/3OuOoqrbCM/5nWq2VxmHzq+uN7g6/aGwWObv8nMaWLxtRSzfm?=
 =?us-ascii?Q?/1a+/YVG25LBdsvopQkIgpZzVOz+X3G1AtO2muyEbTkE3h5aJLMjXAF+fvLG?=
 =?us-ascii?Q?Azdg9W84is/81+qXhhsgtO3TabbB2Wu++5VhzBWIQKlYsWBGrv7AnKAIpsQa?=
 =?us-ascii?Q?SxMqaG+Bi18KXjce8xYR0U96b9o7bH+ICG5blWi5TMPPlTDwqF8kOMvenMoo?=
 =?us-ascii?Q?1n40bAmuekVnGRI3oG06Ds/F/g8g6ouJ79eHU2lXD2YUNXsxl97XDX9loU+s?=
 =?us-ascii?Q?99ppJwO11nl4QhSfJ2Be+oXsd2OK88zqNbegEm2QMEj8k5wG29mo95tFymgO?=
 =?us-ascii?Q?JC19+G87hYvE/LBp4rDrd2cnQo7UiZSrWUEFHMSVXFpHnpFw3x9TFwUoB6Qt?=
 =?us-ascii?Q?EMEF43KYffk0gWB3PHsBwd2Gz/Y2ILEnLJyaQfyPZNYxyj1ie8aPlugVb2yD?=
 =?us-ascii?Q?h/ADPM3bs2f+kLnSH486LyLln6jeauKCR58xe02CuJCb9reQ7hUtMRivRnAn?=
 =?us-ascii?Q?B1coUBwS41dQonN8YXfQmyn57BN4S4bRQu/Hw6OVvDPUuyYLTs6lD35L6qjB?=
 =?us-ascii?Q?TFDHDqne5hFtqAWm24JCz9lj7NeWGXpPIx74SoCQ9RX2xmTt/YSEZOJrFdKW?=
 =?us-ascii?Q?+fni2D6lV8sEKNtR7nfkVpSuFRQfeitU5KErvnnAKlWg1gEPRqq9GmGk9axH?=
 =?us-ascii?Q?RS+URfj5Hdol5i3kUJvu6xnc1Y0YOTWG9SRqXdSa/2HAz6wi6cWBapEEAw5z?=
 =?us-ascii?Q?58hCnH1E+08ufhaR0LIzcGP38I7RuWC8I/Rv8aNgbi7oM+yBqvd7obJG9siq?=
 =?us-ascii?Q?TagI2Qij01O6PqNdNyai46KwehrdvRyCTWt7U5xnGELMIAJJ4CyN1DXhjBeC?=
 =?us-ascii?Q?ZWDXzcnmgOGfuK3OPCkqirEwhPtk+zTZtJEc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 06:05:25.7109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aedb652-d94b-4871-e96f-08ddde1d3991
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267

Explicitly define the AMD64_CPUID_FN_EXT MSR used to toggle the extended
features. Also define and use the bits necessary an old TOPOEXT fixup on
AMD Family 0x15 processors.

No functional changes intended.

Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v2..v3:

o New patch.

Note: The definition of MSR_AMD64_CPUID_FN_EXT_TOPOEXT_ENABLED crosses
the 100 column limit and results in a checkpatch warning.

msr-index.h contains a couple more examples where the definitions with
very explicit naming crosses 100 columns and I've decided to retain the
same despite the warning.

If this needs to be changed, please let me know and I'll address it in
the next version.
---
 arch/x86/include/asm/msr-index.h   | 5 +++++
 arch/x86/kernel/cpu/topology_amd.c | 7 ++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2d5595bdfa27..7931f9b3250b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -630,6 +630,11 @@
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
index 843b1655ab45..bb00dc6433eb 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -158,11 +158,12 @@ static void topoext_fixup(struct topo_scan *tscan)
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


