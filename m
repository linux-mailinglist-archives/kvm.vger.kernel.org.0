Return-Path: <kvm+bounces-56518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E2AB3ECF6
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 19:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E35A3B181B
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 17:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BDDF30649C;
	Mon,  1 Sep 2025 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cVkPB7Hv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66452DF142;
	Mon,  1 Sep 2025 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756746375; cv=fail; b=Ds9RXRz1npJZqD+uO3CITCqDb5ztk48o4qfW3j1sIQegSwqYXBV3oxP1HU/dMe2GNnfwWGCGAmKq5YLZvZoD4h68JZDumVWCkQcsSJde07RVF55Wy2sudvN2IXSOpeBwkR0rzUSdu2H1M/M8qdPhEyGp3mHVOECjSlyjuqzC8Pg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756746375; c=relaxed/simple;
	bh=CCKWjVvCdYphPJJ3Na3b0XKQ++z5AdH6q21rOqGNU7w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igCRmcplKzgBOM7/tVuVY+2h5wK7DUpH3PgHQ+id0idIJCr6HWKh4HTNMu71mY7R+jNIMV1HrqP3KT0BRMrLb8jj6kmpy3WE513VVGxOhJXuCNsoyV3GhgRzSAqPW83ATyPh4NGIAhteYzvU2zc+DDlqiSWFbUxWB2ObHhytoWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cVkPB7Hv; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EGhg/xtwtUSCgExUCVSJb/1CBZVWcihxiU4NcakglbaVOU9kS+2WNKPKAa89KYU+A4vfQ2nXSEku5HoJlPJGAsQ4mNcfQjNLRQ3iM7zgw3S/hO6jwC27a7Vyn37RVcYyLZEPk+QO6mRxaaFtxNYrYLFauHNkhAOpq5JcfKlCNHlkF0/isbUybST4IfBJDB4xFF4X63vc8GoojMsIazEw17B/23TUG30lnyciFk5Ham2TJcVo/lRG8BaobW+ti+SBFLgpV7bucvRWR9b/cs4bpiyyIW8D0km/KKfvyRh+I1oKNtHYmOvZXfzP6jZoQYKnDH/i42ue2NV7RXNFihf0qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/tO0xscO0CNlc5Kg9InXFZ4eZzqHRayicYwB6cvy2fM=;
 b=P/hKFYHzkJkkxtz6y1LX4oejiplSgtEORYbif0PS2kSiuFuNrPk2eh5drIDwYNpwjB8SDJztXpLPRPcEoLgYAc3WFecXHbL07x3NZdG3EFyRGhUwn+kylgP2yRshn6Sc8P+HdpOU9vSIv8QXUTlIDqD1Ahs6U8dpjJnrRx6iYjJpCY63q7DNAVmPlsqSSvj2c1080UIGyOkeZohtYv0gKex4BZ9j8jB5Vs50f23pCusIQ/qX1YYDr5CKls79YS0vQjEDZrpuW3NXAUCpDHU1DSesbSGlRPIbNB9Bg/IvvMduWNQ+Ba0EywG8UPj7berigaNG7wm+OgvATNGWHROzFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tO0xscO0CNlc5Kg9InXFZ4eZzqHRayicYwB6cvy2fM=;
 b=cVkPB7HvFkTWTJnp/BAeknx++2RyADCMV4JLToYXW3kx8AntUbMIhuKyc62QF8LpkHyX2xrExvvV5NMrHjvuugI5FHdxURTXSFAmv6Fq8cNUKCA4jtgbFTELJEghT6tig7UMkkD8iPmYL4Wi9N9jmAC23Z4GNVLlzmr9xgHXrzw=
Received: from MN0P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::10)
 by CH1PPF9C964DBFE.namprd12.prod.outlook.com (2603:10b6:61f:fc00::61e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 1 Sep
 2025 17:06:09 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:531:cafe::b) by MN0P222CA0009.outlook.office365.com
 (2603:10b6:208:531::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Mon,
 1 Sep 2025 17:06:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 17:06:09 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 12:06:05 -0500
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 1 Sep
 2025 10:05:57 -0700
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
Subject: [PATCH v5 3/4] x86/msr-index: Define AMD64_CPUID_FN_EXT MSR
Date: Mon, 1 Sep 2025 17:04:17 +0000
Message-ID: <20250901170418.4314-4-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|CH1PPF9C964DBFE:EE_
X-MS-Office365-Filtering-Correlation-Id: b69e1f3c-eafa-4e3b-5887-08dde979d89d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/l9oA0ZiyqDh9xgjdJW9y1DKDV2jvmPxZ8/j87DtM9T8fS5zXJi7os3RD32g?=
 =?us-ascii?Q?TeU91875p1vYnov3UiTAR8YKHA6ddhUW6ncDcRrx9J3GbHQXHEvYb1HDNsu8?=
 =?us-ascii?Q?MR8gW0DjWoEa8nQD1Z13IY5HT5Mo4/jf6zayUZM/6av1JHo2fl3cc0fS5BGt?=
 =?us-ascii?Q?9KVjQXyhji9+muEE0FAlA5wH+XL716bxqrM/1bovARMTdKM4vWOGKrUGiy8J?=
 =?us-ascii?Q?9rVe7lI0FO3VytCGgH/jMzZJtxqLO1T3tIaZO8lQsvlErt3oT5ULPKMAuWd7?=
 =?us-ascii?Q?Cm6J2Q+pz9ytyo9nDqqQx6P9vFkpbq3BdS4XBPToqkSvlNTDTh7/yMX7TkiO?=
 =?us-ascii?Q?OusH6uP07BtBGUyaz/auFoqZDfcOkOryFQ4jE3OLjAp+0s1CoSfIA6lzcWZy?=
 =?us-ascii?Q?SDh2VItQNTOs2kOyBzGwe4WXMe6oz3xfmUVMIBEf0dPDIZKK6R8ajy8P07mF?=
 =?us-ascii?Q?YBIPCcoynbCHRyYbaPw5gjG9rzBWk9WQ6KDG+xdrmXnUtb/KBQykWqK+yrFs?=
 =?us-ascii?Q?UllIjWKTw5vrILuV80rPnEtfZQSjo9sYkYiF/JXILO1YIOaalx8hrPENEB6Y?=
 =?us-ascii?Q?zRGCfkSkHREO3iUQ/C3HQjDd+GjwX67O5JaS7BdAmTg3cEzSAUIKaFC8Ke71?=
 =?us-ascii?Q?EIIFr61LrBXgx9kqijJcveInsaY8jlcSwpBCPzSohcJtzQCPi0NOMtz53xV5?=
 =?us-ascii?Q?ZDrLn8HreJMjO+Cyy++B/lIPCR/S/KGfo4pDN8Sd6z2JwaK0o2G+cAossuDK?=
 =?us-ascii?Q?xZ2F3ViDr8p591zCIP5/Xo2wpdOPW2zPWmWMpnS+VNP+2TXgzBUqI4Wh7XWC?=
 =?us-ascii?Q?iinG6K7wDPj98YHUFflGPNs/WwaQeZqXSxbqYqCgbAUuGgp2UbSeFJfqy5xQ?=
 =?us-ascii?Q?a7PN4eYi5xVmnDplYfiGkU82mPVxkj1xtpj349rgTCd6/9DEOOvnQfk1pVKu?=
 =?us-ascii?Q?vDttwghgZtlx+m2z7fM8YIFJlNtP5WqDlArB/BOZMug0E0JL2VHzfsnHotB5?=
 =?us-ascii?Q?DY2C/jGOIbxQ7QG91wzAWt/NKyGjDSuPkvwaQwE+4XA3PbArzj+KXZbLkpFW?=
 =?us-ascii?Q?Nax7EjpuaA/IypcSDaNX0s3ox1G274Ez/VZdqN3nf+lNr+cKu/X5CVHAUobv?=
 =?us-ascii?Q?S5kP6Uj9uMdlAyRa+dZ5ynfcTsviWmHSXr7rRiPCkYmSo7OlNJbhQ8FWm4+r?=
 =?us-ascii?Q?IXFNpzvU7OTl390CLmKYoyhGrhgvuNUxLwhndl0wMA711J8V6B5l3I6ugQEa?=
 =?us-ascii?Q?3SWfR/0wcFWOQZDScXZ20u2HAaOtWloKIgIOWCkPO79UNMZvG1h93h+8xQH6?=
 =?us-ascii?Q?7wFj7bT4l8bYQ0h24sjM7erjUsSjZjRxjWfir6J8eSAbC3p2d46uLi1Zfeep?=
 =?us-ascii?Q?dUqrqwTC7av7dl3DssLymsHghfzBU6oNDO5QX/U7CdbIU7FqnDZtgZWtH1uQ?=
 =?us-ascii?Q?ky2LS9DPWmKzdHfJGw9e2vs25FBgV01s0Mn5iz+aJld+kL6CasTdDhJ2iDNZ?=
 =?us-ascii?Q?kLOodvNWHUyZqr7Wcf7bTA4aa6lyls5P2CwQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 17:06:09.0540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b69e1f3c-eafa-4e3b-5887-08dde979d89d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF9C964DBFE

Explicitly define the AMD64_CPUID_FN_EXT MSR used to toggle the extended
features. Also define and use the bits necessary for an old TOPOEXT
fixup on AMD Family 0x15 processors.

No functional changes intended.

Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v4..v5:

o No changes.
---
 arch/x86/include/asm/msr-index.h   | 5 +++++
 arch/x86/kernel/cpu/topology_amd.c | 7 ++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index f627196eb796..176ca7040139 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -633,6 +633,11 @@
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
index 7ebd4a15c561..07510647a378 100644
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


