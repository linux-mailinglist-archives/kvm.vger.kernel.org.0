Return-Path: <kvm+bounces-56648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70052B4103E
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8E1A189B72F
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2803D2EA738;
	Tue,  2 Sep 2025 22:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YdjLk/qi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13BD27FD74;
	Tue,  2 Sep 2025 22:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852994; cv=fail; b=OUOROMVbDEeioWSo+gCaHSB35FU3TkUIVhvA8pBD9vZKwIFk/cpP3aC++DKzucXSNRk3O+aml1PgGVv+rnY9MnWRGPS7WbmMpzMRJ1Vt7D5SPwnC9G6jgvfUNqkymf2gMbrnggTkMcyY1HGO8ltaEJLnNOfo31dRvc12PlKf/Ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852994; c=relaxed/simple;
	bh=xuymci9b5YUGIPTTq1d1RcSvkbRFReUrA5MNfAhUp8g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Geoob/dBVsZtpJUAM+kTjbn1Aat/cFSCI7sh0yDRwkUhi2l7P6PoKVOb4breu24dNezYlj6cMFesRLDmcN0ZuDVFngnnslfWPp2BxR7SOkDOpqU98in3IDazV/O403aMl8g0UCuHyLUtBAgtXk6OQEjdJFXJCuXfvtWi77W2uaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YdjLk/qi; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTh2CU8DUNp0S7/9RILnddepJW6iNCU2U96Kv1DiI1GBuco6eQf324p29BqJj1iQ8kj3MGlQPmmGTpPk4J8sj817M8ELo25eF22rKB7ufaAq5nP4NYqf39JQxdkZczXiFUtEJtaVXuNbddlqp8hOySUut2jHyjIXy9jQ/4knjeNZ9sxn4yf9MoE3fJG2waTT0i1GVDKTSL6r3MGXQqD9aGWj21QJ4cow56SU1jYs73/a8C+R6JDpi8JZ1JpixmQPCMbNbLze65XJSiAdkb2rd+4Uyw/4qwOa4owa0Ctpj8rifTsHIkdvrG3SVQ3Lvr65Gp7cfq1XOkRQa5TGID1qKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04xCRzPpRIgPN+SAv4elmf15jgV8kBUCxtipObJJePg=;
 b=oTpoHuQuSK95NOxkbxDyb+wNx+2tCdJ/8Upw1tsa9XjcR489vDTAXKKyx1zyFSagnU4l0wxO5QS7IPkwKnfQbdM65DFtX6uKZ8oVSTJIaHjIV8WeRC9f/lbsGqAg5pOwxOp/5FJt9Ck0ipYrUNHFuUh8W5ChtYio+H6QoEo3pRxoo/ZGVsNiUimiQd0vmf9Nir4/CTTa5cjqJKAq+YHO6IYKnA99ixsVQIsOAopoPkxasm2Bw5IxR6sg8Jm9hl/0pgBYUcpi8Cxtd/Emgcjpz5MLEun1kERZyi81BjA9MwnqswuBsPLPhBrfFkJo63yNVWoAZK2BT1qJ4Eq8gTeeNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04xCRzPpRIgPN+SAv4elmf15jgV8kBUCxtipObJJePg=;
 b=YdjLk/qiYsZFP06ijkKWe0jYI0yxhlhcc3DidxNraf/VYwBYj5lL4X/HeSHbtLptY1JE1gYPhLG6V4B0Wjjm0ir6nJA1dnRDzzXJD3ufig6cDJQR7xg6miRVCmOA9c2HLMxaOT8egyfSf2ecVlrRYQ289QA2iNnuX/7NwBXRnKU=
Received: from SJ0PR03CA0136.namprd03.prod.outlook.com (2603:10b6:a03:33c::21)
 by CY3PR12MB9656.namprd12.prod.outlook.com (2603:10b6:930:101::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Tue, 2 Sep
 2025 22:43:08 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:a03:33c:cafe::af) by SJ0PR03CA0136.outlook.office365.com
 (2603:10b6:a03:33c::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Tue,
 2 Sep 2025 22:43:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:43:07 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:43:06 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:43:04 -0700
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
Subject: [PATCH v9 10/10] fs/resctrl: Update bit_usage to reflect io_alloc
Date: Tue, 2 Sep 2025 17:41:32 -0500
Message-ID: <549a772b83461fb4cb7b6e8dabc60724cbe96ad0.1756851697.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|CY3PR12MB9656:EE_
X-MS-Office365-Filtering-Correlation-Id: cf7b3340-dc77-4a8a-ede0-08ddea721614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PN/3BIr+aPXpn8Kjrx7JG/+o227OW9HualDE9FAbU9jyYg8yMdO/8DX17lYf?=
 =?us-ascii?Q?aE0mHKdGSiv7DCREorKNtJ3Ay6Ol8fi52kTaLpCOKVXIiK1EtTD/URF+fTDV?=
 =?us-ascii?Q?xBSRy5s0VCZLINOQ5hBwveHTHFsbFxja6RQnmmVsii1tQVOGjJSFyVwOUbQ9?=
 =?us-ascii?Q?8tjcIYskzCFrCqDzmCs53XZLTRKKiZJJvovkRtW8nVZkevjarcfP2YJFAMu1?=
 =?us-ascii?Q?vm7ny9QFnlCEx9IV4LKFrxRH/sFmuUE6xUMxK2CtsfXOmRxhamui3OQVgMpq?=
 =?us-ascii?Q?cTKDVRzK5ES+EWV4Fi2xoULmWtg9naTPUhsDu5iQ1VhdFKT1UwxkaDeO+YeQ?=
 =?us-ascii?Q?iXPaPuNRzY8GbS13r5NGsRSTM7Zv/sOTkQwtuJF4uy0QWaIs1jTju/lKi8b6?=
 =?us-ascii?Q?rov5G5Qpwz2xU1uHspEQDMtHIkZ5wZnHWkTVDceaQmTUEgLR+lWAIwJr7N6J?=
 =?us-ascii?Q?/GP0sCu2cO+omErKI3N7dnxAeSSgYwO7hDZxnJ4vCtW8UrtRHRHCcYVMzd1T?=
 =?us-ascii?Q?lRF70S83wITQXIzTFLVwroSGUkV125qJKhibgsSy/CzmHUrh15s0NewE7dBl?=
 =?us-ascii?Q?YSL28MeNxdATaJP50XfsChWP9deRVPOWb1wEeD9KeO7Ri93ED81ZH1bzvHRu?=
 =?us-ascii?Q?fimzvqR0nW6h1mtcgUPP7H1jQY1RZ5KFvptaXukaYjhbWIGKsJgVWZUP/jix?=
 =?us-ascii?Q?z7r6arA50wrdWVClMsGH6TsvnGHPlR8WIQzQqd8tlymeMIe7e96v7/XIlFkH?=
 =?us-ascii?Q?meX/n5dRpHldGpIDL7wcYNoWjZ5kSYPFQ6m65e6vSg+1ugF1h+IwWXDpdF28?=
 =?us-ascii?Q?YX9v4T+xqBbjVKuCkt8q4v116sK8sf2g3bejFNhc8Y3W+FqA56sFkL7FH1Fq?=
 =?us-ascii?Q?8b62gUCbc1TFODpVbo7mdfNVhB6D8Nh1oAfUNdnFNfKZL6N6lrxOvzI62zkq?=
 =?us-ascii?Q?bWvzEDqoiFUsqlW3CTvgNNPTlkSKEIP8zFuCNKXIYWCUyGZSaNuzAt1z1Lxa?=
 =?us-ascii?Q?u+QPRL4sb008oV7tUa9BNS0jonLJtDv7FcqlziN9mRCLvIar/BfQlklOrP1B?=
 =?us-ascii?Q?dyz2djMpZOYm6y/jxgPNy4a+z0LeiV5IF0clq/ydI+0OzeS53gvUdcGLAzHM?=
 =?us-ascii?Q?Ls39avZY07GELCF/q8px1lx/jrjmsFW1jy9MzUNufuWe1CDT0W9fCtEJcGU4?=
 =?us-ascii?Q?ZBwuZACZDSq0SuKsRYnf+GvilqZ5J/vPsGfYQhNvqnEdw1EmuhBFKzZRhoWq?=
 =?us-ascii?Q?6ij7uv29hHcIt1wBmtNUmLsXupRnFk2GVWn5GZoOVddimMt7WpLrmKHv3K8m?=
 =?us-ascii?Q?YOQf804sphE8mppopHkSy47c4AwNy/nYU4TKMBMgLG6//4YlMom5wd+f/r2G?=
 =?us-ascii?Q?Oh9HqRZUn+Sw19gN8uIoK7Da8R9Eb76rThrleuClAgIJP+2FHfc2PMc3qHaS?=
 =?us-ascii?Q?zFEIQDUa1g1x3qEpzoFyA6UNhL98aHt1RLzZ7RQ4FemTFT//NnzC4rN1FaqP?=
 =?us-ascii?Q?bOOziQ5ihHBRiSfKmoRIj5ovKWqhs6kb4IbC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:43:07.2789
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7b3340-dc77-4a8a-ede0-08ddea721614
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9656

When the io_alloc feature is enabled, a portion of the cache can be
configured for shared use between hardware and software.

Update bit_usage representation to reflect the io_alloc configuration.
Revise the documentation for "shareable_bits" and "bit_usage" to reflect
the impact of io_alloc feature.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v9: Changelog update.
    Added code comments about CDP.
    Updated the "bit_usage" section of resctrl.rst for io_alloc.

v8: Moved the patch to last after all the concepts are initialized.
    Updated user doc resctrl.rst.
    Simplified the CDT check  in rdt_bit_usage_show() as CDP_DATA and CDP_CODE
    are in sync with io_alloc enabled.

v7: New patch split from earlier patch #5.
    Added resctrl_io_alloc_closid() to return max COSID.
---
 Documentation/filesystems/resctrl.rst | 35 ++++++++++++++++-----------
 fs/resctrl/ctrlmondata.c              |  2 +-
 fs/resctrl/internal.h                 |  2 ++
 fs/resctrl/rdtgroup.c                 | 21 ++++++++++++++--
 4 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 7e3eda324de5..72ea6f3f36bc 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -90,12 +90,19 @@ related to allocation:
 		must be set when writing a mask.
 
 "shareable_bits":
-		Bitmask of shareable resource with other executing
-		entities (e.g. I/O). User can use this when
-		setting up exclusive cache partitions. Note that
-		some platforms support devices that have their
-		own settings for cache use which can over-ride
-		these bits.
+		Bitmask of shareable resource with other executing entities
+		(e.g. I/O). Applies to all instances of this resource. User
+		can use this when setting up exclusive cache partitions.
+		Note that some platforms support devices that have their
+		own settings for cache use which can over-ride these bits.
+
+		When "io_alloc" is enabled, a portion of each cache instance can
+		be configured for shared use between hardware and software.
+		"bit_usage" should be used to see which portions of each cache
+		instance is configured for hardware use via "io_alloc" feature
+		because every cache instance can have its "io_alloc" bitmask
+		configured independently via io_alloc_cbm.
+
 "bit_usage":
 		Annotated capacity bitmasks showing how all
 		instances of the resource are used. The legend is:
@@ -109,16 +116,16 @@ related to allocation:
 			"H":
 			      Corresponding region is used by hardware only
 			      but available for software use. If a resource
-			      has bits set in "shareable_bits" but not all
-			      of these bits appear in the resource groups'
-			      schematas then the bits appearing in
-			      "shareable_bits" but no resource group will
-			      be marked as "H".
+			      has bits set in "shareable_bits" or "io_alloc_cbm"
+			      but not all of these bits appear in the resource
+			      groups' schematas then the bits appearing in
+			      "shareable_bits" or "io_alloc_cbm" but no
+			      resource group will be marked as "H".
 			"X":
 			      Corresponding region is available for sharing and
-			      used by hardware and software. These are the
-			      bits that appear in "shareable_bits" as
-			      well as a resource group's allocation.
+			      used by hardware and software. These are the bits
+			      that appear in "shareable_bits" or "io_alloc_cbm"
+			      as well as a resource group's allocation.
 			"S":
 			      Corresponding region is used by software
 			      and available for sharing.
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 791ecb559b50..1118054fdc2c 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -738,7 +738,7 @@ static int resctrl_io_alloc_init_cbm(struct resctrl_schema *s, u32 closid)
  * resource. Note that if Code Data Prioritization (CDP) is enabled, the number
  * of available CLOSIDs is reduced by half.
  */
-static u32 resctrl_io_alloc_closid(struct rdt_resource *r)
+u32 resctrl_io_alloc_closid(struct rdt_resource *r)
 {
 	if (resctrl_arch_get_cdp_enabled(r->rid))
 		return resctrl_arch_get_num_closid(r) / 2  - 1;
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 5467c3ad1b6d..98b87725508b 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -395,6 +395,8 @@ int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq,
 ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
 				   size_t nbytes, loff_t off);
 
+u32 resctrl_io_alloc_closid(struct rdt_resource *r);
+
 const char *rdtgroup_name_by_closid(int closid);
 
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ddac021c02d8..951d44d6f488 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1068,15 +1068,17 @@ static int rdt_bit_usage_show(struct kernfs_open_file *of,
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
-	hw_shareable = r->cache.shareable_bits;
 	list_for_each_entry(dom, &r->ctrl_domains, hdr.list) {
 		if (sep)
 			seq_putc(seq, ';');
+		hw_shareable = r->cache.shareable_bits;
 		sw_shareable = 0;
 		exclusive = 0;
 		seq_printf(seq, "%d=", dom->hdr.id);
 		for (i = 0; i < closids_supported(); i++) {
-			if (!closid_allocated(i))
+			if (!closid_allocated(i) ||
+			    (resctrl_arch_get_io_alloc_enabled(r) &&
+			     i == resctrl_io_alloc_closid(r)))
 				continue;
 			ctrl_val = resctrl_arch_get_config(r, dom, i,
 							   s->conf_type);
@@ -1104,6 +1106,21 @@ static int rdt_bit_usage_show(struct kernfs_open_file *of,
 				break;
 			}
 		}
+
+		/*
+		 * When the "io_alloc" feature is enabled, a portion of the cache
+		 * is configured for shared use between hardware and software.
+		 * Also, when CDP is enabled the CBMs of L3CODE and L3DATA are kept
+		 * in sync. So, the CBMs for "io_alloc" can be accessed through either
+		 * L3CODE or L3DATA.
+		 */
+		if (resctrl_arch_get_io_alloc_enabled(r)) {
+			ctrl_val = resctrl_arch_get_config(r, dom,
+							   resctrl_io_alloc_closid(r),
+							   s->conf_type);
+			hw_shareable |= ctrl_val;
+		}
+
 		for (i = r->cache.cbm_len - 1; i >= 0; i--) {
 			pseudo_locked = dom->plr ? dom->plr->cbm : 0;
 			hwb = test_bit(i, &hw_shareable);
-- 
2.34.1


