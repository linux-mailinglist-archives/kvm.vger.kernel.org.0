Return-Path: <kvm+bounces-56640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E73B41028
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B761948188D
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7374327B331;
	Tue,  2 Sep 2025 22:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r48kXq3M"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2066.outbound.protection.outlook.com [40.107.212.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EC527A123;
	Tue,  2 Sep 2025 22:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852926; cv=fail; b=fayaQV6UPhMZ6tt5zu/sa/wjqTIxbrRlhw1GIhld6RtETjD1tYyfMQePehMejxQoUCyUBJzoAKKrKicZGaQ8PHklwJAVm1hDThUTpripu/YqG0EF9Wz0UHKZlSwQKSJxFUV8iGAwsNeQm2XZ/wRcwzukU0n2ddgjubWvtlvjn5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852926; c=relaxed/simple;
	bh=tRVJUn4TyUBxl4C+k/xVX2pOTRgDgNso3/+WKnqNemg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rjGJ0xMHsQbX1gQuLzRLZmm/5fs/Jo/9KWSwcNsAOUCDx54iPs4JK9Lh9Pk1L+DAZXFo/6swA6mxpHPP5m/pILSsNs4fg4VyBQt07JJvdXhgGAx62j7AbGAnzZcF+AADy06mNKD6um1LAN2ILElan7NtJJZrwKSaqNsl/dUVHfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r48kXq3M; arc=fail smtp.client-ip=40.107.212.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SmlawuyUflRHVZxoKBRkywk8cZVaCaUgHWtUu26FaXi/RsxFBa8U3QHCPtlPDrWyJqwPaxM5HAMkPI7yJXKFnNjjjMPTzSDK/GEz1P7F9yagpRFaYADt7toH5tqE/jCgVvbUmif3mNJ7Z9FXo0AZKK9uzhyxvQdmyXzmOC/z5lDslpjJi0eDAeyl9iRX+NtbS93lpU1Ht7Pg0Dla2neu7cuSkJ6M+QHyoZLbZbs4Ujz8bGxSW9qGEjj45nCIxA8Bt80Xnx6kAmPAumKATk6PoisigY/ds1Up9+ExWZ39Mz5m5PcWCWNSGC5nmngyhd5aDwVS8U5uGbJTGKtWxFKgQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGbnuW2/Z6L8vIUhsmmaE1bwx88Z6bz2TimxrguZXj4=;
 b=gCWA1WMaLum9qHoQ0OWjmCbakwvFKK0tQA02f/qvEo92hFzfPx7gxkSR1O52YQ0brz6aJo2g0J29YRlWDZgEv4I49zFcVNtJFgsfKOGoXh2E8YSXtWKyc+lfAaRiuOw/B+vZ5AMImixl/ijMCRzzjvYpUNdPCtuZ1XMK1/SryewB4hRaEd7EbC+iHFp6cBagtXIZT7vciMIs91oq3MGLYSuKMun+omBlcLpCSwACIxR/q31JvpWTz2RMPAz+34ApXj0e6WYiWJEvM1MO+AaT4arraWiCg7YARx3UFYlP2tclBFPOndDf/sSTrc+sI1O2eKeOtYZiOHoKieYh8rO5pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGbnuW2/Z6L8vIUhsmmaE1bwx88Z6bz2TimxrguZXj4=;
 b=r48kXq3MVvN/4/rSwTmxSK2rUeB8Z04OxKhYZSD2jWUlddOS3+3s+dh2ITkbhlFM4SRItbE7KnCAwAyyf2d/t0v1FBgnlChgosfd2sNNojgmH8Ph5o46DohqtatMQeuu7iH8bxDSsvAdZM/9f/gsrHTPyxwRtlhGUa0oxP+3Arg=
Received: from BN9PR03CA0331.namprd03.prod.outlook.com (2603:10b6:408:f6::6)
 by DS4PR12MB9746.namprd12.prod.outlook.com (2603:10b6:8:2a4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 22:41:58 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:408:f6:cafe::70) by BN9PR03CA0331.outlook.office365.com
 (2603:10b6:408:f6::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Tue,
 2 Sep 2025 22:41:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:41:57 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:41:57 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:41:55 -0700
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<babu.moger@amd.com>, <dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
Subject: [PATCH v9 02/10] x86/resctrl: Add SDCIAE feature in the command line options
Date: Tue, 2 Sep 2025 17:41:24 -0500
Message-ID: <f3aae4014bb65145dcbc0064214324133fe568b0.1756851697.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1756851697.git.babu.moger@amd.com>
References: <cover.1756851697.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|DS4PR12MB9746:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fd3a94a-0023-4420-d178-08ddea71ec9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OOQIDvi/itO00mbeDXc8iZasZamHsMtPdFphYMep8UA7PfhnN5u1VT3w+gBO?=
 =?us-ascii?Q?YBSQxzLb5BoDm1nvPDxr4zgrDiWKBd7jKX6T4NuDR17+5pK20F5OiYFXITAB?=
 =?us-ascii?Q?Ox7VONCIcGA5OThMP0lJurvAUI0jSx33O2Nj7gerTa+9zXkZjf6/2wfLqzdq?=
 =?us-ascii?Q?qsDi0ATAc0R33rhExqY4yNfyJ8Oms3iFqtMCc923BsVTL6QKXg6BlvdNf1Y7?=
 =?us-ascii?Q?w5LQUsOVFlWZDOI7p+zl78bZUKwslkkOTJsPQMxsEM1TONVG9IWW6xlioQAQ?=
 =?us-ascii?Q?Rfp/67a1P+I8gezUArzRGS6q8IydCKocFuE7dedV9ZJwSC9kyb//9qikj7VQ?=
 =?us-ascii?Q?snRocWGtnrhDIm3+KN+zadoPUuLl9kyfaIFKCIFkehZi8wMubKFMteJmHA2n?=
 =?us-ascii?Q?h/vIaFXw79LZ/NxtmFhzmZdjT86+/rq2YMhXfI8aGrnQM+r6qpQe6I48umTK?=
 =?us-ascii?Q?QUzP2iRZKStOcncyrFf1+OIw4ht/x+t+0Yv5K+wXshQnt7ldGiNWsl37PtNM?=
 =?us-ascii?Q?aaX4yGhsshflwgRdRnZCCpuezZCVzEPcYOAf3YG48x+lOosua46/e7vdU0qx?=
 =?us-ascii?Q?oztpM31Gw9Q1sCQq3hd0GIBQhGY5CtbK7EXsLqAFUdLpRZ7fMVC+LUscwIyX?=
 =?us-ascii?Q?PUK+uTmYUB5VsN5um4Ebhr9n4aUknhOFlLV6LOQr5KzlZnUNPu6EmSSO3ohd?=
 =?us-ascii?Q?ARSzCAaYQcZARC+9s4FnmYR3CYRVyIBSMYhFJKK7Y3cJiMA1+xopLPz4q4cZ?=
 =?us-ascii?Q?ghVtrV5A5CliXRDNMe81utzx3S3QpuLEhhsGDkanRm0HQe/YW4ZKqR3OvZxT?=
 =?us-ascii?Q?SuDnj08sPaffSwybJN4dpT1/+8ZRdrlRHkcuzqZ/4KGLmkTkt2+b3bTrg0QT?=
 =?us-ascii?Q?+hxIgd02DjSjAi2x5yZ6oLtoz87VDZN9UBsn1VqoWjQRtChOylH+BIItY9r2?=
 =?us-ascii?Q?KJvzdWbbDeuXoBPNnUZOJnpXHPGl9n5c8mQhExmhbMZPwYmONLlx9ReTmyI2?=
 =?us-ascii?Q?8wco4SpLjGBc9V3kXiU3uYiJjgXkncpGrERy178qheOTQ4Ek3mizL16pZnly?=
 =?us-ascii?Q?GA/wwQX+U1+1F6PTgrRBpDbYmMM44A+YnvxwrvT0A5C7vNPlAoAJshWAXylq?=
 =?us-ascii?Q?gQ9gKbM4wVpZ7d4sdfzwLADH85E9qRvBwqZwY5rHT9rHI6gXS7kGkyJe0ji/?=
 =?us-ascii?Q?5KMeIajUkliycMGYOy8GVzpIn19A28+GtIIWECilOf0QIM0s4kGIH+eQRM9g?=
 =?us-ascii?Q?wO64ZnehE1RYCVU02Ofy96hynOkPvYi3XHRmjKaaWmzSdDCk1b1ZO78RcS6l?=
 =?us-ascii?Q?CVYQqtpNGcTAlyWb2Q6JjzXiCvReaA6zpxIwSdd4WIk2RimMjIVenZlvU+mv?=
 =?us-ascii?Q?StLPacD/sRh1Fo9niMwfNqKvIXuGKTh9QCjvhJyAW/cacHIrvzJKDUzhDMxz?=
 =?us-ascii?Q?YVmj7G5KPvX9bSa7qsONNVY2DHqw1Dio1h0vd57qyf7Yi6dJGdxy9533MhYB?=
 =?us-ascii?Q?I2KWGJSFkE1+T7cYoI9d9XEpAae4UoJqZ2xA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:41:57.7966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd3a94a-0023-4420-d178-08ddea71ec9c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9746

Add the command line option to enable or disable the new resctrl feature
L3 Smart Data Cache Injection Allocation Enforcement (SDCIAE).

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v9: Minor changelog update.
    Fixed the tabs in SMBA and BMEC lines.

v8: Updated Documentation/filesystems/resctrl.rst.

v7: No changes.

v6: No changes.

v5: No changes.

v4: No changes.

v3: No changes.

v2: No changes.
---
 .../admin-guide/kernel-parameters.txt         |  2 +-
 Documentation/filesystems/resctrl.rst         | 21 ++++++++++---------
 arch/x86/kernel/cpu/resctrl/core.c            |  2 ++
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 747a55abf494..398136902e23 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6154,7 +6154,7 @@
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
-			mba, smba, bmec.
+			mba, smba, bmec, sdciae.
 			E.g. to turn on cmt and turn off mba use:
 				rdt=cmt,!mba
 
diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index c7949dd44f2f..4866a8a4189f 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -17,16 +17,17 @@ AMD refers to this feature as AMD Platform Quality of Service(AMD QoS).
 This feature is enabled by the CONFIG_X86_CPU_RESCTRL and the x86 /proc/cpuinfo
 flag bits:
 
-===============================================	================================
-RDT (Resource Director Technology) Allocation	"rdt_a"
-CAT (Cache Allocation Technology)		"cat_l3", "cat_l2"
-CDP (Code and Data Prioritization)		"cdp_l3", "cdp_l2"
-CQM (Cache QoS Monitoring)			"cqm_llc", "cqm_occup_llc"
-MBM (Memory Bandwidth Monitoring)		"cqm_mbm_total", "cqm_mbm_local"
-MBA (Memory Bandwidth Allocation)		"mba"
-SMBA (Slow Memory Bandwidth Allocation)         ""
-BMEC (Bandwidth Monitoring Event Configuration) ""
-===============================================	================================
+=============================================================== ================================
+RDT (Resource Director Technology) Allocation			"rdt_a"
+CAT (Cache Allocation Technology)				"cat_l3", "cat_l2"
+CDP (Code and Data Prioritization)				"cdp_l3", "cdp_l2"
+CQM (Cache QoS Monitoring)					"cqm_llc", "cqm_occup_llc"
+MBM (Memory Bandwidth Monitoring)				"cqm_mbm_total", "cqm_mbm_local"
+MBA (Memory Bandwidth Allocation)				"mba"
+SMBA (Slow Memory Bandwidth Allocation)				""
+BMEC (Bandwidth Monitoring Event Configuration)			""
+SDCIAE (Smart Data Cache Injection Allocation Enforcement)	""
+=============================================================== ================================
 
 Historically, new features were made visible by default in /proc/cpuinfo. This
 resulted in the feature flags becoming hard to parse by humans. Adding a new
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 187d527ef73b..f6d84882cc4e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -707,6 +707,7 @@ enum {
 	RDT_FLAG_MBA,
 	RDT_FLAG_SMBA,
 	RDT_FLAG_BMEC,
+	RDT_FLAG_SDCIAE,
 };
 
 #define RDT_OPT(idx, n, f)	\
@@ -732,6 +733,7 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
 	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
 	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
 	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
+	RDT_OPT(RDT_FLAG_SDCIAE,    "sdciae",	X86_FEATURE_SDCIAE),
 };
 #define NUM_RDT_OPTIONS ARRAY_SIZE(rdt_options)
 
-- 
2.34.1


