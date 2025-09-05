Return-Path: <kvm+bounces-56937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4BCB465EE
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:43:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE675177838
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12196303A3C;
	Fri,  5 Sep 2025 21:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hb7cBKtW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131AD303A28;
	Fri,  5 Sep 2025 21:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108345; cv=fail; b=S9BJaCXxYiTQixUqtuYf2mRf3cPuWhYTlMmtxqyBGwRHfXHbg9XLs9CsPuTAAJm0+wCHPP1ok6vYZutsowyfjfq4Ist9Jm1swoRLdmj5M0drODdDyjmgsIKypP6RtU5yfdKIER6awH/TDqrYyV7D9BJjyOCrCYA0gVITZmTUbPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108345; c=relaxed/simple;
	bh=5HFQcOFapvecFtMRvKge1SYZsE2I0w3OVTsfma82qVk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LqaLOdJJ224dDmAZeGZP9RPy1DMt9PDCjFLpii7ZceQ+/BQS72ui1Mom21hqoxgRri7whq8X/aRfiEh6AcQ3se9cw8CjhVrS5NL4pwWNqzE/V39HTl9dO005Vl1ZlbsDnCs3gaeHDh/2OQY4P4YkIypxhodVcjoFzzMUvGMFizE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hb7cBKtW; arc=fail smtp.client-ip=40.107.243.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RlIl5rEo23/DCsZeVpQPbfwbB1vY6j6fmfXy8HgsdH/FxAigEgkpPx3A/VR6zptCU7XjLtCMBrVTiaxXvDMztr13C2R/UWjLizfJy+hH57ZmebnY/+uETu7rX2ASDQaCvwSZsybFqot/qoRd4PjpjdLS0IsM2P1aPfHAiekljjLgM4WlIhFOCTEES5SYNdz8iYgnQ+HCHCls1iP8Re11qxJQBW0UTGEEiBYaHUHNmRdXvbEw1EOPqBTfZ4VV+Ylq1Ehbi41mF5qVODX1hNl/mP/6fFqxOTPYLbG7CxBv2vfVj4Za5j7EJRXgpLcsPGWQkNuykYW6+Xgs2+beTMwJDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u50fe7uweCrBIo2biTyH7dyxVonqnhP09G9Nq7QmUjk=;
 b=l0C+jMyd1ih7tSPwMg3jnYyDL7tD0Mu6Fs6kbIFFXmTvghsFMHbKkTjoR89kyFVHRBWwUEcAnZ6nBmw4ZfZJWfbNb8pFNPQrRkuxsyjzqBykm5UsJ/gkZ3KPEFlBtWpyTpIa0Jsa0TDxKD8uozPHl05lLOqTcBY4I+rTZGrKqGYWJw/JKlMBuIXzWXmHteVnHw3RWIaubh/t/ZNVYG9SGGEynb7A8hry8bgP1CQ1IX6UkEgoxReGPN/GgijSY696n6YYEZ8PdXOrpOnZYcgGyPYJt15lDdKH46O2yLDkj5xJzg63vafuENz6YMewmNaokro6+MmLy2T+7oCc7Ib/cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u50fe7uweCrBIo2biTyH7dyxVonqnhP09G9Nq7QmUjk=;
 b=Hb7cBKtWZAgSuDLqCJdhh/OP10cClOrLHeF88w7oeM58Q6SAoW0SZeAfayjGT6UlapRnLg542ACcuo/HMAezFkS08HK9/79+DlvGZPiLz38xfsgEcKAgrveKnODvsiZP8QuCWCmUeWmdlHTuhO/6B3LNDAc7LMKfukzsaf+6yHk=
Received: from DS7PR03CA0088.namprd03.prod.outlook.com (2603:10b6:5:3bb::33)
 by MN2PR12MB4454.namprd12.prod.outlook.com (2603:10b6:208:26c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 21:38:58 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:5:3bb:cafe::67) by DS7PR03CA0088.outlook.office365.com
 (2603:10b6:5:3bb::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Fri,
 5 Sep 2025 21:38:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:38:57 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:38:57 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:38:55 -0700
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
Subject: [PATCH v18 25/33] fs/resctrl: Provide interface to update the event configurations
Date: Fri, 5 Sep 2025 16:34:24 -0500
Message-ID: <1468bf627842614be7bb3d35c177b1022c39311e.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|MN2PR12MB4454:EE_
X-MS-Office365-Filtering-Correlation-Id: 90b5c925-4e1d-48ad-8c1f-08ddecc49ed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8jHbnluXh2q0zsCb2bt33ZGapECCYtE2NbDfnK/vQvyziLEISSBiqstzfa+v?=
 =?us-ascii?Q?lz9AZN7rxsYTBaU9HTK6gTeJEoK1KCN68smB0D7FQnqRazRY+o95sxPhr44d?=
 =?us-ascii?Q?+W5kzJboORiBUCQREkkxQuF50xndnORMD26o0Ly3pkk0I1ytveCq2M5HtWa+?=
 =?us-ascii?Q?VsU5+0Pm9HNSkaTyO681gTNr8s7RkoLykgCfe+dJHlsGZh0MqGWl5/xpW+Ma?=
 =?us-ascii?Q?FUdSmKytv7Qfl3dN8UqA0DocQlbLiM81kCgmbRKv1772+BQMPYboFGO7/Ygh?=
 =?us-ascii?Q?eOl7yvmw/ZLPH8N5LaGAMlPp93qPs1bIqkjRPsxhCf2wzB77R5BXdt+qpJNO?=
 =?us-ascii?Q?z73qdy5k7ej/5e+dpCiFNMu+GTpI06bFOXqHCvvataoCqi7eitMFYRTjOx5n?=
 =?us-ascii?Q?p3/TRzg3vGgtqOwA2pX6qBcxcFBG3eN2EnFPGIjrm5VxbfwCYJ3fP4OWGsI8?=
 =?us-ascii?Q?OiioMaEKlLf1C3E2/b3+Rcu7ORDRtWcfdroG/tDvabGYShNOadV7Ax2WilJ4?=
 =?us-ascii?Q?C0IoQXgN0gPm16ON9dcSecPekR3E+faw74R+cJB4DK3fTRRbD51EW2vHKKX7?=
 =?us-ascii?Q?j2Is/3BBqE2m//rhEP7h4VwwD6hA/ip10PeYMVj32mQ8YoMYXf5XU9BjbfMk?=
 =?us-ascii?Q?MhzKCGdxA5KwfaDpV9w/WLz533jUAbWp81K4dnncld6CWK9HUtr3R8x/VWww?=
 =?us-ascii?Q?a3tjSrYyINh+wX8VMQRSGGzRXW7t8XNzF9/0vPKb3JYVgbfc26Qs9kU6A93W?=
 =?us-ascii?Q?W9S22mdM6Lf0zDGz/JdbeaoCoEPHLK9gWmrtp3UWGGi33JWtV0a2xuICMxuK?=
 =?us-ascii?Q?iJoIsNStpHy/mPIOLTZJgFfzpzSv4SBHfijceTITBCCD5hJAtTPgdQVvxJyP?=
 =?us-ascii?Q?Ghq66/pzTrkWv8QHZiagi000l4A9gl/R0mNECdomG4+WHHJ7h93VytE4NnEL?=
 =?us-ascii?Q?KjiaCf19PWS8zZZgE/j8mitNYXCnq/d3lzlKKsbyXY/cv7ev/qnRD1vjTbH7?=
 =?us-ascii?Q?GwPNSg5Xt+d2rQ62rvT0MXL1tgr0pvgaPwFrtXXAz//glea3fDVk7zmvFlzq?=
 =?us-ascii?Q?HAoUI7TStaPuR90ZOghu12N+EPCQj15JUneVkTRy8icGlBDToT70CBS7ImAz?=
 =?us-ascii?Q?Fxkd151jYmBxbggxwnwVfeOfmUwmDZrV/fKmAH8IdUdcV3MV3RIVGV30bdAd?=
 =?us-ascii?Q?UFUdrvsgyh8rtiAP2J0mmYZdVFHu3PuVAQL7KqpAmKVjTUjtusBL0v3KHtqJ?=
 =?us-ascii?Q?kTwu4PLXbwO4KKXqFr2u6NNHCMk2vvzINd3zKkoMusPe1JxHvpbbyoldKkcU?=
 =?us-ascii?Q?F20K5ESZ4LhTxjk+PEPzlyx4vsF/7NWdR5twkhEJ4GRQrVwhN/zQDhFyEwS3?=
 =?us-ascii?Q?pOwA2Kpf7RuFBC1tPCIDr6Is42+0Qefaxy3eXPZTIV0VvBm/t7ArGEptItJM?=
 =?us-ascii?Q?n6di90thnjDJfwhvNW9upac2Zc58wMR9Mj74B+cyTXVf/blL3P192QcGW7HA?=
 =?us-ascii?Q?2u822ANnniGl7usXojl/yHFnTBYdlNGqntXe?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:38:57.7879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b5c925-4e1d-48ad-8c1f-08ddecc49ed1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4454

When "mbm_event" counter assignment mode is enabled, users can modify
the event configuration by writing to the 'event_filter' resctrl file.
The event configurations for mbm_event mode are located in
/sys/fs/resctrl/info/L3_MON/event_configs/.

Update the assignments of all CTRL_MON and MON resource groups when the
event configuration is modified.

Example:
$ mount -t resctrl resctrl /sys/fs/resctrl

$ cd /sys/fs/resctrl/

$ cat info/L3_MON/event_configs/mbm_local_bytes/event_filter
  local_reads,local_non_temporal_writes,local_reads_slow_memory

$ echo "local_reads,local_non_temporal_writes" >
  info/L3_MON/event_configs/mbm_total_bytes/event_filter

$ cat info/L3_MON/event_configs/mbm_total_bytes/event_filter
  local_reads,local_non_temporal_writes

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v18: Removed open code in rdtgroup_update_cntr_event(). Called
     rdtgroup_assign_cntr() directly.

v17: Minor changelog update.
     Cleared mbm_state on every assignment update.
     All the code moved monitor.c.

v16: Moved resctrl_process_configs() and event_filter_write()
     to fs/resctrl/monitor.c.
     Renamed resctrl_process_configs() -> resctrl_parse_mem_transactions().
     Few minor code commnet update.

v15: Updated changelog.
     Updated spacing in resctrl.rst.
     Corrected the name counter_configs -> event_configs.
     Changed the name rdtgroup_assign_cntr() > rdtgroup_update_cntr_event().
     Removed the code to check d->cntr_cfg[cntr_id].evt_cfg.
     Fixed the partial initialization of val in resctrl_process_configs().
     Passed mon_evt where applicable. The struct rdt_resource can be obtained from mon_evt::rid.

v14: Passed struct mon_evt where applicable instead of just the event type.
     Fixed few text corrections about memory trasaction type.
     Renamed few functions resctrl_group_assign() -> rdtgroup_assign_cntr()
     resctrl_update_assign() -> resctrl_assign_cntr_allrdtgrp()
     Removed few extra bases.

v13: Updated changelog for imperative mode.
     Added function description in the prototype.
     Updated the user doc resctrl.rst to address few feedback.
     Resolved conflicts caused by the recent FS/ARCH code restructure.
     The rdtgroup.c/monitor.c file has now been split between the FS and ARCH directories.

v12: New patch to modify event configurations.
---
 Documentation/filesystems/resctrl.rst |  12 +++
 fs/resctrl/internal.h                 |   3 +
 fs/resctrl/monitor.c                  | 114 ++++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                 |   3 +-
 4 files changed, 131 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index ddd95f1472e6..2e840ef26f68 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -343,6 +343,18 @@ with the following files:
 	  # cat /sys/fs/resctrl/info/L3_MON/event_configs/mbm_local_bytes/event_filter
 	  local_reads,local_non_temporal_writes,local_reads_slow_memory
 
+	Modify the event configuration by writing to the "event_filter" file within
+	the "event_configs" directory. The read/write "event_filter" file contains the
+	configuration of the event that reflects which memory transactions are counted by it.
+
+	For example::
+
+	  # echo "local_reads, local_non_temporal_writes" >
+	    /sys/fs/resctrl/info/L3_MON/event_configs/mbm_total_bytes/event_filter
+
+	  # cat /sys/fs/resctrl/info/L3_MON/event_configs/mbm_total_bytes/event_filter
+	   local_reads,local_non_temporal_writes
+
 "max_threshold_occupancy":
 		Read/write file provides the largest value (in
 		bytes) at which a previously used LLC_occupancy
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 7b1206fff116..5956570d49fc 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -407,6 +407,9 @@ void rdtgroup_unassign_cntrs(struct rdtgroup *rdtgrp);
 
 int event_filter_show(struct kernfs_open_file *of, struct seq_file *seq, void *v);
 
+ssize_t event_filter_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
+			   loff_t off);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 25fec9bf2d61..a4bbd45fc58a 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1194,6 +1194,120 @@ void rdtgroup_unassign_cntrs(struct rdtgroup *rdtgrp)
 					     &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
 }
 
+static int resctrl_parse_mem_transactions(char *tok, u32 *val)
+{
+	u32 temp_val = 0;
+	char *evt_str;
+	bool found;
+	int i;
+
+next_config:
+	if (!tok || tok[0] == '\0') {
+		*val = temp_val;
+		return 0;
+	}
+
+	/* Start processing the strings for each memory transaction type */
+	evt_str = strim(strsep(&tok, ","));
+	found = false;
+	for (i = 0; i < NUM_MBM_TRANSACTIONS; i++) {
+		if (!strcmp(mbm_transactions[i].name, evt_str)) {
+			temp_val |= mbm_transactions[i].val;
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		rdt_last_cmd_printf("Invalid memory transaction type %s\n", evt_str);
+		return -EINVAL;
+	}
+
+	goto next_config;
+}
+
+/*
+ * rdtgroup_update_cntr_event - Update the counter assignments for the event
+ *				in a group.
+ * @r:		Resource to which update needs to be done.
+ * @rdtgrp:	Resctrl group.
+ * @evtid:	MBM monitor event.
+ */
+static void rdtgroup_update_cntr_event(struct rdt_resource *r, struct rdtgroup *rdtgrp,
+				       enum resctrl_event_id evtid)
+{
+	struct rdt_mon_domain *d;
+	int cntr_id;
+
+	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+		cntr_id = mbm_cntr_get(r, d, rdtgrp, evtid);
+		if (cntr_id >= 0)
+			rdtgroup_assign_cntr(r, d, evtid, rdtgrp->mon.rmid,
+					     rdtgrp->closid, cntr_id, true);
+	}
+}
+
+/*
+ * resctrl_update_cntr_allrdtgrp - Update the counter assignments for the event
+ *				   for all the groups.
+ * @mevt	MBM Monitor event.
+ */
+static void resctrl_update_cntr_allrdtgrp(struct mon_evt *mevt)
+{
+	struct rdt_resource *r = resctrl_arch_get_resource(mevt->rid);
+	struct rdtgroup *prgrp, *crgrp;
+
+	/*
+	 * Find all the groups where the event is assigned and update the
+	 * configuration of existing assignments.
+	 */
+	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
+		rdtgroup_update_cntr_event(r, prgrp, mevt->evtid);
+
+		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
+			rdtgroup_update_cntr_event(r, crgrp, mevt->evtid);
+	}
+}
+
+ssize_t event_filter_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
+			   loff_t off)
+{
+	struct mon_evt *mevt = rdt_kn_parent_priv(of->kn);
+	struct rdt_resource *r;
+	u32 evt_cfg = 0;
+	int ret = 0;
+
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n')
+		return -EINVAL;
+
+	buf[nbytes - 1] = '\0';
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
+	rdt_last_cmd_clear();
+
+	r = resctrl_arch_get_resource(mevt->rid);
+	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
+		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = resctrl_parse_mem_transactions(buf, &evt_cfg);
+	if (!ret && mevt->evt_cfg != evt_cfg) {
+		mevt->evt_cfg = evt_cfg;
+		resctrl_update_cntr_allrdtgrp(mevt);
+	}
+
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+
+	return ret ?: nbytes;
+}
+
 int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of,
 				 struct seq_file *s, void *v)
 {
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 8f0c403e3fb5..e90bc808fe53 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1925,9 +1925,10 @@ static struct rftype res_common_files[] = {
 	},
 	{
 		.name		= "event_filter",
-		.mode		= 0444,
+		.mode		= 0644,
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.seq_show	= event_filter_show,
+		.write		= event_filter_write,
 	},
 	{
 		.name		= "mbm_assign_mode",
-- 
2.34.1


