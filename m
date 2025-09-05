Return-Path: <kvm+bounces-56918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F555B465B4
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FC401D20881
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4222FA0E9;
	Fri,  5 Sep 2025 21:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="obDGNJr1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699DF2F657F;
	Fri,  5 Sep 2025 21:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108158; cv=fail; b=St/5gefZc6rupqeZULU3i+8MIToaZy2u7cBVtBjVm86xAYqASNDkUh+BceFvtF243fvJ7db4zpmOEDEHor6mtXVO6+0GxkvtcvGTE1PxgYKfZ2Q0+yAJdGt/FmJUENOvtAyNsGWjdHBH6tuwHYnN6qNhRPXDPWf8hxfyCjPwl9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108158; c=relaxed/simple;
	bh=y7Y2joKxgkzc3K7n3uRHkbUqOz89YeTpHh4j0DHOU+E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EX3ux6sA/Lg1BnbLi2zt4wc2RWKsiCizoQP10i8Fwt3CaBBx60tqFrcqYKeJVVQERPuVRUtRNeL4DPwejZvUf/NPUgJksF0EP8dhsAwZ1yuq+YU7YRNg9BAXDuI3VmZuwh7ukklyTfmKRsiEefGbc2X7r+4QriN9csYatXzhG7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=obDGNJr1; arc=fail smtp.client-ip=40.107.220.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iti1PhxemzPCNYmnqgMsTu0fpOVnj8NMmS8sh3RyEKMPLYha+blhezx2B3I3yEFtewk5nTMtIl88BU64vlcA0IOjP9bzVbTwiWTD1FFdjyFzPnhh73dleByKd2uLdP9SniqZ/gX5a6RD0opxf/bn5tSmEcXRa84G9LV+5kT+ehnBSuBb5ScY4vCC/hN6i+bvzrdEgFcJU/6+tWHUXSa6/0uq5FSeG8NwKX53lQT2rs7aWmcbNrpT0jzH3jCwzpw8Bk3g+mivH/TFTZ11gLfCB3U87g3UeVKgznbB7a69uZhy3VQ1k2xj4yAP/qu+Zo1ZZS4+BQVAsopv1iumKHrrPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIjEhjoTSmNEdbSfnQVMcHhKMCJLqYCH63WKq2CtQOY=;
 b=wIJyzPLbHln2N6eomGT1O3JzBEhnpeLHYoglpxmFYanuIXpFax4ly61TwMjqX5PkGBK8kGm8RBizGsbEwFAn/QqLOuxC6CdRIApFpAHtyRrmNTdNiJBPDKsufZ+24Y5g5/nugY5vo8CUAh8juCthxYX2sk+tEqHRWTMKs+sGo6los47EfhE+ESNyehAB4LVZCnw7LjLcCIVYl+PzGFuiiq2ELdgFlwmH209h88XR/inl7iMKjqgNwOos27iKVZ54Se5gox0PmgbDoVvDU73NJCoYleWQBEMFKaDuVINBYbCBN8MFhWu633vLbmn2seKQD1bzfT05eEZ1UcBT5Hnasw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIjEhjoTSmNEdbSfnQVMcHhKMCJLqYCH63WKq2CtQOY=;
 b=obDGNJr1PvJdbnufgKTsdB0sXiN5HGxhjL4299qdZE5tFoZxNsISuuGRWAu+o9rSjDkLR7CN8Ne9zpgZPPmDZ0Dj81uJl95FlMAMYV7lXX5imBnIp+ExkIfV8KEDl0xZhwGR/c0kXwCdCPrTJLJvYoDUE/jnUCMvrcdOOWxFhdY=
Received: from BN0PR03CA0024.namprd03.prod.outlook.com (2603:10b6:408:e6::29)
 by IA1PR12MB8539.namprd12.prod.outlook.com (2603:10b6:208:446::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 21:35:50 +0000
Received: from BN2PEPF000044AC.namprd04.prod.outlook.com
 (2603:10b6:408:e6:cafe::ed) by BN0PR03CA0024.outlook.office365.com
 (2603:10b6:408:e6::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.20 via Frontend Transport; Fri,
 5 Sep 2025 21:35:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF000044AC.mail.protection.outlook.com (10.167.243.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:35:49 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:35:49 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:35:47 -0700
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <babu.moger@amd.com>, <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
Subject: [PATCH v18 06/33] x86/resctrl: Add ABMC feature in the command line options
Date: Fri, 5 Sep 2025 16:34:05 -0500
Message-ID: <e1595037b15882dc861fab098c3d9325b7ce1735.1757108044.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1757108044.git.babu.moger@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AC:EE_|IA1PR12MB8539:EE_
X-MS-Office365-Filtering-Correlation-Id: 7105afc7-3046-4dba-61e9-08ddecc42edc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oP9T3NTdzP3l+vHhKzOqdmBgMYrn1hMtVGOVEkA4gmTmDfHrD59Dm/ipiHGD?=
 =?us-ascii?Q?8CC/WYPb5SeJVdr8km8xWRV+VaOHJnlP8QgiySoOsw8MTEhlcS1qx/Xt13q/?=
 =?us-ascii?Q?yKK8auO5zGbOrHBTu/+LOMiFG9azT4/W6AOoMNSvKHLi3u97a9/c39ohvxDE?=
 =?us-ascii?Q?vYOp/lk9OSy2NXJXEp54Q9adhAQ7R6/VOyl8WWOcwHOy3u4glNRfKU6AxmhA?=
 =?us-ascii?Q?D1NWto+NpKAsnxBNf9D1uEzKGnV0Bmw277LgrkUxYLqAjwGihxWT96yhPQKh?=
 =?us-ascii?Q?BJmDKUDoXLDmRk6E99J97hgY7jqVUkL7sZgW1H7A/gzn5kR2FsVaQF6YkcF3?=
 =?us-ascii?Q?q7D+yUrSR0i/fYRib3tt1G5xMm7VolFyaKeVAukZ1SovwNluCe7TsnnCgaLu?=
 =?us-ascii?Q?+ppOPM0nqCfL5fAJkdHJLTU0KIrC1MzzGWsi4ftykX4b/zJczlLHHQFop7+B?=
 =?us-ascii?Q?UgWAU23GEXgjnth+ro6tSZe77egSEkyRNYE9fYU8z9R+TD6SG7goGD2MrijK?=
 =?us-ascii?Q?sX1CgXIgrgbHEzPfVyGuxCCW+lBAH0qSgLMMYwsu/B913UFFEepZM7n8HHnm?=
 =?us-ascii?Q?OPr3XrTD0vk0vhxG+8UeZdpkF7x2XXX1SAZKvfOWY753piz4SXNZ54Le7z/B?=
 =?us-ascii?Q?AJGuympMeJqtAfY9ghGCf8PEOYc6WLlpCqAbXdtiM7SfHUhtvKcP0CwW6ILS?=
 =?us-ascii?Q?6gz1Eur/P2nfCRlYWla0M7ZxzzWyJc9wa2VW7rGRvzsCw83Vr8KsaoU5gMzv?=
 =?us-ascii?Q?oHyrPKyo+WZpKsY3AzWm823ck8aiHu8t4ZDTeefhSRLDdncnMeMAS5WeROWO?=
 =?us-ascii?Q?Ha3HxRPEAreJX4xucDD+IedlbQ5LVLZGtggHos6UWjatHK5S+LwEDnL9I6Ru?=
 =?us-ascii?Q?qBcxchIafy2tWEc9mCAw9edLTNPLNEoV/84nveP8Lr1Li59Gsb32n7MrMw8t?=
 =?us-ascii?Q?heKB+crKqyi1YcWyJwlQ9cg64MKPezbRY29nN6Xhr0rz6UsvEYxck/39LKem?=
 =?us-ascii?Q?d7sIv2fQLTtl5epV+z1/Oeg5J2bzhSAitrKN2mEbJERl6k28qTc5S2TbSBYB?=
 =?us-ascii?Q?f3oD/Bl78CsJQDDk6hA2+RNPPLgn1VB8VprPzxwBAdJlpUoGfjKBw8Npkoca?=
 =?us-ascii?Q?H8BX1FRZS46A3OfYq9uDd64/xzDVIk4wPJOY2jpAlEwFiTJfx9yxi1LV0K8B?=
 =?us-ascii?Q?q116WVj1QFUiJVwMloHu5jtJDwnC9KY4qMNAT0VVDLyWRLndTIy4hpcUbJEr?=
 =?us-ascii?Q?DFeMC98rB9y9anHESC+znXAvddDOzerT+kT5tvX984C5x2THa78So37oZsFE?=
 =?us-ascii?Q?0wPq4bfjMDggacMXir9dT9ZAQaMk2QZPrnzK8EJlxIbtErr5fnEnW6XJKKjQ?=
 =?us-ascii?Q?QrhyZiUv33KcHm/4SVAvUZOeRbznNFWokUk96VJqwYOFL66z8Hkc/dUJVbww?=
 =?us-ascii?Q?ZCtw72u7cJw4COTfvWP79nPiXlw6Ex2v7kuCyrwFV6i2rytziUtnXWX5yzLR?=
 =?us-ascii?Q?WrImt5iUmng12iiqfVDrqTfDGLlb8BJUTZea?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:35:49.9988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7105afc7-3046-4dba-61e9-08ddecc42edc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8539

Add a kernel command-line parameter to enable or disable the exposure of
the ABMC (Assignable Bandwidth Monitoring Counters) hardware feature to
resctrl.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: No changes.

v17: No changes.

v16: Added Reviewed-by tag.

v15: No changes.

v14: Slight changelog modification.

v13: Removed the Reviewed-by as the file resctrl.rst is moved to
     Documentation/filesystems/resctrl.rst. In that sense patch has changed.

v12: No changes.

v11: No changes.

v10: No changes.

v9: No code changes. Added Reviewed-by.

v8: Commit message update.

v7: No changes

v6: No changes

v5: No changes

v4: No changes

v3: No changes

v2: No changes
---
 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 Documentation/filesystems/resctrl.rst           | 1 +
 arch/x86/kernel/cpu/resctrl/core.c              | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 747a55abf494..5bab2eff81eb 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6154,7 +6154,7 @@
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
-			mba, smba, bmec.
+			mba, smba, bmec, abmc.
 			E.g. to turn on cmt and turn off mba use:
 				rdt=cmt,!mba
 
diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index c7949dd44f2f..c97fd77a107d 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -26,6 +26,7 @@ MBM (Memory Bandwidth Monitoring)		"cqm_mbm_total", "cqm_mbm_local"
 MBA (Memory Bandwidth Allocation)		"mba"
 SMBA (Slow Memory Bandwidth Allocation)         ""
 BMEC (Bandwidth Monitoring Event Configuration) ""
+ABMC (Assignable Bandwidth Monitoring Counters) ""
 ===============================================	================================
 
 Historically, new features were made visible by default in /proc/cpuinfo. This
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index fbf019c1ff11..b07b12a05886 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -711,6 +711,7 @@ enum {
 	RDT_FLAG_MBA,
 	RDT_FLAG_SMBA,
 	RDT_FLAG_BMEC,
+	RDT_FLAG_ABMC,
 };
 
 #define RDT_OPT(idx, n, f)	\
@@ -736,6 +737,7 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
 	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
 	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
 	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
+	RDT_OPT(RDT_FLAG_ABMC,	    "abmc",	X86_FEATURE_ABMC),
 };
 #define NUM_RDT_OPTIONS ARRAY_SIZE(rdt_options)
 
-- 
2.34.1


