Return-Path: <kvm+bounces-56940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC2CB465F6
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01C703B68A4
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B7093054ED;
	Fri,  5 Sep 2025 21:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="saIlWOsY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61255303C85;
	Fri,  5 Sep 2025 21:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108377; cv=fail; b=JjZnSCfcNYEX3ARsTJI8j+NxtrnqyBakMiZhlZz5FF3E+YND3/mpdW3H6aPMKCc6P2YEk8bJl/SAJszd7eONmQQ3i/cuYfydJXB1NnEhBwuO8ImdvpmGvRMNn9UEzeO+kwdaWHJ2gJ+qYM+Yy0u6FcvVDWfuxwFP2fC0xdjv1JI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108377; c=relaxed/simple;
	bh=gA9ZaWMRIKcl1uDa5KAHwPXST+423XVwI7RvvmL9IpE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UV15iftx+I7QQWf+a/jFe12Q5yqwNdNnRA4lVCJJ6lOQO9T1qzhIQIpUGuzoV560vMiTQupV8re5mQmT3nJ3IAyr61LU6OH0RRcA9BQXomO8vwb5U1TOWgTWYbaYESEut3ifMSzH2011bZtcfYkxCsX1yPpjrRe+99CXKHdSYJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=saIlWOsY; arc=fail smtp.client-ip=40.107.92.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zKB35DMteZRNGZNhrqJSIbjGNE3i4Q95W4/YoA/D+ir5dXTxZb6e9NnUWmalH2yYSqFEzpgG4j1GyLiEPhDBkCTb9VrfyH5i2VhwZ8CDhCIndd3Rfqwqi9zTClwW7A4u73K8DqwQyd7C4IlMvaZh7iXnUE8LT+FwyWEtOwf3yqXh+5EW3KR/G7WapWeVrEpCTgLEc03unqxKjpxh/GZ4H0JxTs3o+G0tdpYbXZ/hJe/UHMeHLNerXJraD6DGznTq6/9wGtuWSPSog5fc7BMSO3Kdo8ZEFxVb5ZPV0bNXbajdsYVWDJ0Q82eAumpSvwvkRE9jqtPBQcT+HvQQybYfgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbd3xvE3E3Hc5EuUxlSEqd/94jwtpuiBiqc2Oz/+p74=;
 b=xlQzAOTNutMgN980bB4MkAaNUOwcVDmc1sAFGNQXfXu8jnXjDwmqyKMiq9DxCgk+Ty4CyAJcwsfSYHouCBPgG+Bcwrx+uoJiwtTch9XpNbo2fp0OKJe9iFLJ2hDVryFnbxr/oomWvht6+y5fmJbpMczUb/1EOuIZNKgOyyBv6Fiei5JHLlANu9YQWwWQv5tH0aMWItfzLbjPokrJar5wIj6PF18jwn8djDireD9iJyTALZx97+nuqbp57AD3nCLsm4vGjknGH2N5V5y1F+mclgwgi5fMSWJh2M2GxOsTP5z4CwiQF0Taepjp0WsmxTTbyHYCy+xtcihIT9G6qx4Vbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbd3xvE3E3Hc5EuUxlSEqd/94jwtpuiBiqc2Oz/+p74=;
 b=saIlWOsYFNInCn82/KE74NpPqZifqdydNR+jDOv4oZWeBKar8MLim2RtHHDR4Ix4tOp4odmOKIX7uHPAFieD3jXA18FiIy1T52nqetf7r1l4gXxSqB7KvKPjlAu2uY0uY/9sVNMBe9qSdcV/iF+S5o9VR1G4n/ITm1fLMayp8P0=
Received: from DS7P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::32) by
 DM4PR12MB6012.namprd12.prod.outlook.com (2603:10b6:8:6c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.19; Fri, 5 Sep 2025 21:39:24 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:8:2e:cafe::f8) by DS7P222CA0026.outlook.office365.com
 (2603:10b6:8:2e::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.20 via Frontend Transport; Fri,
 5 Sep 2025 21:39:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:39:24 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:39:23 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:39:21 -0700
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
Subject: [PATCH v18 28/33] fs/resctrl: Introduce mbm_L3_assignments to list assignments in a group
Date: Fri, 5 Sep 2025 16:34:27 -0500
Message-ID: <fdcb23bc9061a9e1b8d99e922b234c02db561ff1.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|DM4PR12MB6012:EE_
X-MS-Office365-Filtering-Correlation-Id: cb14f751-18b0-4bde-1906-08ddecc4aea7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WFcjAV2jl89H+e8dmgtL/UYC7kJb//rLLFxTPwlju4ygl+vLvRTN99vDLTPG?=
 =?us-ascii?Q?AJDh8PsYAwbYWpd7rBp1L8u/+nE6Z0bzW1V1YUBgs8MJD9FN4gGAJZGkoxnr?=
 =?us-ascii?Q?MhjI1JM4ls+H5TCt/R2V9qSyRl+ND2zyFCTEKnWHMyGW7wlUd7lnbUnIX37K?=
 =?us-ascii?Q?uQ78SXn185/8RVAgc0CiaEbAR1l6DxyeDXn/INcVGPblDGbw0d8x4/BOGfMw?=
 =?us-ascii?Q?EC3L+GEKPjxpPN884fkXnf7tcUYoC9bssdn9SoMRktAbgkGBTw0sdVdWwtQ/?=
 =?us-ascii?Q?2PaNdD4dJN4uQm4vmQD2v9eaR+mcou479NW+SB2+lLH9wea13JH4TNgJ/Bt/?=
 =?us-ascii?Q?PbOo9EQmhlJXWPOKwD2BW2U14a+aYjtz8Oz+mgtqD/FOFAvSp4I9o/nTu9Fk?=
 =?us-ascii?Q?FArPDpKG4sRe4EGdgBqCl2ZeDmlTJMS8rneaXN0DfAh9SCfIL45DjR83izIG?=
 =?us-ascii?Q?xcFMMbDOHMh3zqx8egFibkqebfLDSLsSEcTVeSIWFzst3ELQu3zs0jOOk6T8?=
 =?us-ascii?Q?4GAAXqhVz+uNX93//ZiiYmLz0SDr6Z6+IhHGh+t0gBELbEEQkqvDbRXfUHMD?=
 =?us-ascii?Q?TpdCwsFXD3xRYotgJZ5duzLzl8fZbaBmcS6aJiXp/HrmSP91703hgaZU0PXD?=
 =?us-ascii?Q?V7/2jOBbv+PceTg3VlueSnH2pVW3G7BCm08q4zrYBVclk1SPcQmiJ6tnm2FI?=
 =?us-ascii?Q?uGNoHaIlItsrQnSNx9KdpirzSMxLrFmSRZaAL8q1w2rBU4jH9w+eDTxblh5O?=
 =?us-ascii?Q?4NyeaEZi1Ey15gcv79sOswwKk+xD1jxJctGfNzrEzELk1alCD9xKQcr0alcw?=
 =?us-ascii?Q?qNQ1RxG+qEk0mcEQz1mj1RQ8KUhoIWiSQPqaZHmmjsTAOQs7HX9qsqtj5VwJ?=
 =?us-ascii?Q?CB//L0zpco4JnFXdp6AX6V7dcfYvUrIM9difz8ribHCfvwkMwXwOPVFYn5NY?=
 =?us-ascii?Q?7Mp6aXmx5CtO4LaqIG9jM7dqNXFjYQzNFMhLdElDz+ngOJcJz/i1jHjtSExT?=
 =?us-ascii?Q?thRiP6HToPkNLFsD1aoOVObGlYEGYnQhXlQn233c8/rzpap5FN/iTYC4I2Gr?=
 =?us-ascii?Q?JVJeeJfio0YY4MJwRSanJLvWSvFp7vjetYDhVaa7rBcUyj4bi3iYgQ2hc03J?=
 =?us-ascii?Q?7gq4cl1m3jm99BkQZZ2T9+y5AJIFBH2wKzXPGdf0MQfqDunwFD4wSQCJ3QpT?=
 =?us-ascii?Q?0VTYWUSrHI4vFUFi0O3jYnz6QSLyKpTIrhSHj5pOAhbxDNzV26HSkk50YIzx?=
 =?us-ascii?Q?xvsamMK6sJeOSdAiRWe+UooQES7BsbuIgJq9W6tmG2JjSDeAd2lCBEVcBDue?=
 =?us-ascii?Q?zFz3vxbB/hUcWjLXt1z4EKQnAMxpWh/jH7uWKvBhH6zSLIHcaoEO78bFUmoz?=
 =?us-ascii?Q?vyUZLK008DUJdYrbr2LFBY7EqlQ69YSIpYFbpyh7ej0Fq5RiP5UMsU3QuaH9?=
 =?us-ascii?Q?jqoqjItcxNsufcZqnI3NP9rTiI3e/XKvoR5CEO3vtG7n4vfBlfiYQg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:39:24.3601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb14f751-18b0-4bde-1906-08ddecc4aea7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6012

Introduce the mbm_L3_assignments resctrl file associated with CTRL_MON and
MON resource groups to display the counter assignment states of the
resource group when "mbm_event" counter assignment mode is enabled.

Display the list in the following format:
<Event>:<Domain id>=<Assignment state>;<Domain id>=<Assignment state>

Event: A valid MBM event listed in
       /sys/fs/resctrl/info/L3_MON/event_configs directory.

Domain ID: A valid domain ID.

The assignment state can be one of the following:

_ : No counter assigned.

e : Counter assigned exclusively.

Example:
To list the assignment states for the default group
$ cd /sys/fs/resctrl
$ cat /sys/fs/resctrl/mbm_L3_assignments
mbm_total_bytes:0=e;1=e
mbm_local_bytes:0=e;1=e

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v18: Moved documentation of "mbm_L3_assignments" just after mon_hw_id.

v17: Moved mbm_L3_assignments_show() to fs/resctrl/monitor.c.
     mbm_cntr_get() can stay static.
     Minor change in changelog for imperative mode.
     Fixed the return error for consistancy.

v16: Fixed minor merge conflicts with code displacement.
     Changed the check with mbm_cntr_get() to "< 0" from " >=".

v15: Updated the changelog with Reinette's text.
     Updated the event format list to list multiple domains.
     Changed the goto out_assing to out_unlock.
     Updated to use new loop for_each_mon_event() instead of hardcoding.

v14: Added missed rdtgroup_kn_lock_live on failure case.
     Updated the user doc resctrl.rst to clarify counter assignments.
     Updated the changelog.

v13: Changelog update.
     Few changes in mbm_L3_assignments_show() after moving the event config to evt_list.
     Resolved conflicts caused by the recent FS/ARCH code restructure.
     The rdtgroup.c/monitor.c files have been split between the FS and ARCH directories.

v12: New patch:
     Assignment interface moved inside the group based the discussion
     https://lore.kernel.org/lkml/CALPaoCiii0vXOF06mfV=kVLBzhfNo0SFqt4kQGwGSGVUqvr2Dg@mail.gmail.com/#t
---
 Documentation/filesystems/resctrl.rst | 31 +++++++++++++++++
 fs/resctrl/internal.h                 |  2 ++
 fs/resctrl/monitor.c                  | 49 +++++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                 |  6 ++++
 4 files changed, 88 insertions(+)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 1de815b3a07b..a2b7240b0818 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -509,6 +509,37 @@ When monitoring is enabled all MON groups will also contain:
 	Available only with debug option. The identifier used by hardware
 	for the monitor group. On x86 this is the RMID.
 
+When monitoring is enabled all MON groups may also contain:
+
+"mbm_L3_assignments":
+	Exists when "mbm_event" counter assignment mode is supported and lists the
+	counter assignment states of the group.
+
+	The assignment list is displayed in the following format:
+
+	<Event>:<Domain ID>=<Assignment state>;<Domain ID>=<Assignment state>
+
+	Event: A valid MBM event in the
+	       /sys/fs/resctrl/info/L3_MON/event_configs directory.
+
+	Domain ID: A valid domain ID.
+
+	Assignment states:
+
+	_ : No counter assigned.
+
+	e : Counter assigned exclusively.
+
+	Example:
+
+	To display the counter assignment states for the default group.
+	::
+
+	 # cd /sys/fs/resctrl
+	 # cat /sys/fs/resctrl/mbm_L3_assignments
+	   mbm_total_bytes:0=e;1=e
+	   mbm_local_bytes:0=e;1=e
+
 When the "mba_MBps" mount option is used all CTRL_MON groups will also contain:
 
 "mba_MBps_event":
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 9be1e53a73d3..88079ca0d57a 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -416,6 +416,8 @@ int resctrl_mbm_assign_on_mkdir_show(struct kernfs_open_file *of,
 ssize_t resctrl_mbm_assign_on_mkdir_write(struct kernfs_open_file *of, char *buf,
 					  size_t nbytes, loff_t off);
 
+int mbm_L3_assignments_show(struct kernfs_open_file *of, struct seq_file *s, void *v);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 13af138d4b3b..e8c3b3a7987b 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1456,6 +1456,54 @@ int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of,
 	return ret;
 }
 
+int mbm_L3_assignments_show(struct kernfs_open_file *of, struct seq_file *s, void *v)
+{
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+	struct rdt_mon_domain *d;
+	struct rdtgroup *rdtgrp;
+	struct mon_evt *mevt;
+	int ret = 0;
+	bool sep;
+
+	rdtgrp = rdtgroup_kn_lock_live(of->kn);
+	if (!rdtgrp) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	rdt_last_cmd_clear();
+	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
+		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	for_each_mon_event(mevt) {
+		if (mevt->rid != r->rid || !mevt->enabled || !resctrl_is_mbm_event(mevt->evtid))
+			continue;
+
+		sep = false;
+		seq_printf(s, "%s:", mevt->name);
+		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+			if (sep)
+				seq_putc(s, ';');
+
+			if (mbm_cntr_get(r, d, rdtgrp, mevt->evtid) < 0)
+				seq_printf(s, "%d=_", d->hdr.id);
+			else
+				seq_printf(s, "%d=e", d->hdr.id);
+
+			sep = true;
+		}
+		seq_putc(s, '\n');
+	}
+
+out_unlock:
+	rdtgroup_kn_unlock(of->kn);
+
+	return ret;
+}
+
 /**
  * resctrl_mon_resource_init() - Initialise global monitoring structures.
  *
@@ -1514,6 +1562,7 @@ int resctrl_mon_resource_init(void)
 		resctrl_file_fflags_init("event_filter", RFTYPE_ASSIGN_CONFIG);
 		resctrl_file_fflags_init("mbm_assign_on_mkdir", RFTYPE_MON_INFO |
 					 RFTYPE_RES_CACHE);
+		resctrl_file_fflags_init("mbm_L3_assignments", RFTYPE_MON_BASE);
 	}
 
 	return 0;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 48f98146c099..519aa6acef5b 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1937,6 +1937,12 @@ static struct rftype res_common_files[] = {
 		.seq_show	= event_filter_show,
 		.write		= event_filter_write,
 	},
+	{
+		.name		= "mbm_L3_assignments",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= mbm_L3_assignments_show,
+	},
 	{
 		.name		= "mbm_assign_mode",
 		.mode		= 0444,
-- 
2.34.1


