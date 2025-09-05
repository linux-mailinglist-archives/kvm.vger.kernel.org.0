Return-Path: <kvm+bounces-56936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D74B465EC
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA69EAC1A39
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B22062FDC4F;
	Fri,  5 Sep 2025 21:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZtU+t4wc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5BA2F3625;
	Fri,  5 Sep 2025 21:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108337; cv=fail; b=nuZGq6Zx/p8EozPh4Sh8wLS0wxRmrs4fllGrewmKRhcGJTH5Fop+8K99+UYGH5hXhDkNfqzaUBSGWpNaY7Q8f70QtecNRZmY5qeP+XWuXgewEnvztWemZFmUw8NZvmTqp8CMmKGDie+nvieliO2ofnAEEH2eQyEW8rU4QjPrguI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108337; c=relaxed/simple;
	bh=7hGQBmjgPxkJg/Smbun2IbwD2r77z56XLI45wEfPeMA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VNqaCUv7+xOpjER1iOn/V5zgucg4QGd96/OKMq47dIUWgZZRlgtHis8EzxarpCwKFCVXQCkaVnfEEygSyPML68UhnG8cb5oOh0gf8wPHsClheXRubVNvkNN69KC+GslqtPf4PUfBUUOfjHA9IAgHyI+yDqC66Tt6kiupnGY4Dxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZtU+t4wc; arc=fail smtp.client-ip=40.107.223.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NDdJZ6wYyqpSMxy6IOv5jCP8JFhCrnocWNUhs+uUmCgtct3LQBlStxouP7W0fssYNIoeBEvdFUg12H0xZCRY5zTxMXTu6MLU49vypo1rizRwdqbPH84hSiNK08jPjhVE9ZovxfbB4Ug7Th6FKyuUd30vcp4n80Idmr5o2OGj2bFdPjA3LQkCBXChgiSkQFvXeoCkDcYF6yUaJ/PcdtbNW5OrWHUUENpJQG+/6yIRE9HWIaYU00X4tg0IFDDALF6MrGi69xsFlcs0+wF1Le6pKib705ajKOt/QM3bh/4fy+PPWAe3zctI6QwiCUOwffdLBFuVCJNXs7h1i/yeNeYbZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLQQv/F7X1PgM8xIvrMwNfDgB76o6QuCrj5gZxOWtVQ=;
 b=yb8a7ArcEZ33IzZBymJl5AmbWdzMFNhh+zJVcUwgEw2isRCtbqCS4ab+PV8L36pj6rYwcwYX6uYQAwYXRRc89ZnmOexvG04PLZV2VPSC1akr3cIfW0CvuXK38egfqvSKC5/no+efRFMLsFKHHLlry9zV4NFiTiYuMKp2/PXehBz2jh5VMJUXOezg859z0jZ15t9mCjOxwQygJjK2bhsUhIedf1RIPSVUf1U38H2Iw+ZfIe/5PFlG+Dtk6ZjizOJ57gFoEQQCF/mv8d2tUWBtQn7GV7O5HkXjFg850n45KnMDlclD7nZmMWp5T4zA1FPAJSnmr2fwbieCuWgQyN73yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLQQv/F7X1PgM8xIvrMwNfDgB76o6QuCrj5gZxOWtVQ=;
 b=ZtU+t4wc4XoatRK9s//Tz+G5497vChukJ70d434wKo4SfqUO9HGjeoxMVjY/6mfU41ougKSkkJWCJ2EnpSQ/kyAwhq5GwWrpzIkjSt/8F/uLfi5qSNmcCEMLHKkmA0uVr3LLvgosSx46tdOOQIcLd36B+XOJc3+/u/T85rnavFs=
Received: from DS7PR03CA0336.namprd03.prod.outlook.com (2603:10b6:8:55::20) by
 DM4PR12MB7528.namprd12.prod.outlook.com (2603:10b6:8:110::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.18; Fri, 5 Sep 2025 21:38:49 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:8:55:cafe::7b) by DS7PR03CA0336.outlook.office365.com
 (2603:10b6:8:55::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Fri,
 5 Sep 2025 21:38:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:38:49 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:38:48 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:38:46 -0700
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
Subject: [PATCH v18 24/33] fs/resctrl: Add event configuration directory under info/L3_MON/
Date: Fri, 5 Sep 2025 16:34:23 -0500
Message-ID: <0c76ad2d0a9c8399d242742f23dfaf077e61e900.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|DM4PR12MB7528:EE_
X-MS-Office365-Filtering-Correlation-Id: fbcb57f9-0e4e-4cec-fe13-08ddecc49999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qmTKtpLSENySSAJVSl/35GRQw8jRWyg6jWjb4TNzd1Hgshmdj0qbmqm1K74r?=
 =?us-ascii?Q?OOYZZwYToSMLocWKLdnrJPi5sZMhytZMXBTKRmkB6uNLG2JEZUB8d/xcA89q?=
 =?us-ascii?Q?D96GMZG+Z+aYo4C04H+ednd9xw9AyzTckjGtBIqPbX9uoCtXlBZAsz3um30U?=
 =?us-ascii?Q?RYq1ljdDKXZDjM5F/R4Gol29EFmGQxu7NOC18L4nBZTNKEBorZ8ryZdEMjpd?=
 =?us-ascii?Q?jvYzWH04XT2LoqYp757o3zcdvCl1KQIbV/LVv9oRIFrPUi+oQpeeu0+qFhwL?=
 =?us-ascii?Q?TJKkY/k0YsgvfpofPnq+aMMxvleDJK5Wr9iYOYCHuzefV4XvCiEaNvZosVp3?=
 =?us-ascii?Q?qnoUHrt4cP4Yxu0VmHOXhJP0CjQAbU1DF9lPw+3nmdquG+cB5YERKamncyyC?=
 =?us-ascii?Q?bMFhN+QR8m2rMGvzGR2qHbfTSy5EUK9lY/M5V0Lqd4OovC2P0iuUQjkDpwwd?=
 =?us-ascii?Q?3Bj1wYuLUe95sUUC6LLTzxA6M9x3hhFL8o63fj9LGBwbpwLGDTtFiRc90YbA?=
 =?us-ascii?Q?Kujn3SNKLwg1oDQ1tAybqw0xDfu9ygMcga1/axNrk86elAvgouFRFS+Et2Sz?=
 =?us-ascii?Q?KalHP7FZabRvgxzyv3j8aEGFF0Ms0aNt5lzkj0tUhPbmG1WpVBTLLVWNhEk+?=
 =?us-ascii?Q?w4Og+IjZQO7/O+6XDpPzbPJGJDoUZwHOycE6R8I0w7MzO8fboGeOM2AJ0AGh?=
 =?us-ascii?Q?jvSRwIeAboUPeuXVnr5VnINNFVJHwnxboAIXvNeL18jxTpxU0+8UkBsxcyhP?=
 =?us-ascii?Q?HZdeP1X0wXv3Ls+PWQOqFNNM41/0GBC7LJ7ST3a0AFdq6snur4bcIPPrT5kX?=
 =?us-ascii?Q?UZbQ7tEmaiiOk6KkkOq7x02eX80a846XlIOR7JTZVp3P6CpoSvbUtHAJ8ImI?=
 =?us-ascii?Q?FDLY8/XYc5ASx1boT5xOo2QqqJ6pxp7ROLFU+H0QxEYBvwnTM8H5QM1dawai?=
 =?us-ascii?Q?UDrXl4DABFmAHvEpJpmVBMPDgQJRHdSz/Qcgzwi0agOFf07jXwRNtetUjCj3?=
 =?us-ascii?Q?+jn8kvEl9/BGLOyrkhJ8Ddry/ZySn6ADI2BZxe9nPlnQqicBZ6vcLetu+Oi0?=
 =?us-ascii?Q?D8srR0iZ0HsDF+G7Z/1EBCKyQSDQIhlFYyg1jz/RnstlplQaPENzZ/Ghd1w2?=
 =?us-ascii?Q?0Kkmf8Tke9SrAQRwgVBZpPuSEW93Sa/+UaFXbIHAfjY47wT5hqVoK567VJbw?=
 =?us-ascii?Q?iw6MGGxMSzCEWBIhDit75A0+QQHLOi/YnGp08aIIG+6HM1LOO0mUbMr7zvnP?=
 =?us-ascii?Q?A2wq9WacFY4M7/z8eQ36Cb20/ZO01rB3sRzdUNCWCrF41nvH0+rbuws+FNZs?=
 =?us-ascii?Q?wY7cLKBbNQl3hXmb8FKBbzZ2RGmOmyDAK83S5dXU33ZhVEie7x2MXTu8Aagj?=
 =?us-ascii?Q?EdSkPsaZcYHu6ZBHHyU8G3IFtepFeIw1cCTO1c+xa1G+VqhjSHWBO0NO+q+t?=
 =?us-ascii?Q?QUevmI1zKEBgFB9mhGxJYRMUInEmPIpEmkBtfPghcpEJSriwjVeGSzwHrWNQ?=
 =?us-ascii?Q?bjj+qK1bKIdM87MWIdcqsS3fFniRsezDtVh4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:38:49.0418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbcb57f9-0e4e-4cec-fe13-08ddecc49999
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7528

The "mbm_event" counter assignment mode allows the user to assign a
hardware counter to an RMID, event pair and monitor the bandwidth as long
as it is assigned. The user can specify the memory transaction(s) for the
counter to track.

When this mode is supported, the /sys/fs/resctrl/info/L3_MON/event_configs
directory contains a sub-directory for each MBM event that can be assigned
to a counter.  The MBM event sub-directory contains a file named
"event_filter" that is used to view and modify which memory transactions
the MBM event is configured with.

Create /sys/fs/resctrl/info/L3_MON/event_configs directory on resctrl mount
and pre-populate it with directories for the two existing MBM events:
mbm_total_bytes and mbm_local_bytes. Create the "event_filter" file within
each MBM event directory with the needed *show() that displays the memory
transactions with which the MBM event is configured.

Example:
$ mount -t resctrl resctrl /sys/fs/resctrl
$ cd /sys/fs/resctrl/
$ cat info/L3_MON/event_configs/mbm_total_bytes/event_filter
  local_reads,remote_reads,local_non_temporal_writes,
  remote_non_temporal_writes,local_reads_slow_memory,
  remote_reads_slow_memory,dirty_victim_writes_all

$ cat info/L3_MON/event_configs/mbm_local_bytes/event_filter
  local_reads,local_non_temporal_writes,local_reads_slow_memory

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Squashed patch #24 abd #25 into one. Both are dependent on each other.
     Minor change in resctrl.rst.
     Remove check for kernfs_activate() in rdtgroup_mkdir_info_resdir().
     Added resctrl_arch_mbm_cntr_assign_enabled() in event_filter_show().
     Moved struct mbm_transaction declaration to monitor.c and made it static.

v16: Moved event_filter_show() to fs/resctrl/monitor.c
     Changed the goto label out_config to out.
     Added rdtgroup_mutex in event_filter_show().
     Removed extern for mbm_transactions. Not required.
     0025-fs-resctrl-Add-event-configuration-directory-under
     0025-fs-resctrl-Add-event-configuration-directory-under
     0025-fs-resctrl-Add-event-configuration-directory-under
     Added prototype rdt_kn_parent_priv() in so it can be called from monitor.c

v15: Fixed the event_filter display with proper spacing.
     Updated the changelog.
     Changed the function name resctrl_mkdir_counter_configs() to
     resctrl_mkdir_event_configs().
     Called resctrl_mkdir_event_configs from rdtgroup_mkdir_info_resdir().
     It avoids the call kernfs_find_and_get() to get the node for info directory.
     Used for_each_mon_event() where applicable.

v14: Updated the changelog with context. Thanks to Reinette.
     Changed the name of directory to event_configs from counter_config.
     Updated user doc about the memory transactions supported by assignment.
     Removed mbm_mode from struct mon_evt. Not required anymore.

v13: Updated user doc (resctrl.rst).
     Changed the name of the function resctrl_mkdir_info_configs to
     resctrl_mkdir_counter_configs().
     Replaced seq_puts() with seq_putc() where applicable.
     Removed RFTYPE_MON_CONFIG definition. Not required.
     Changed the name of the flag RFTYPE_CONFIG to RFTYPE_ASSIGN_CONFIG.
     Reinette suggested RFTYPE_MBM_EVENT_CONFIG but RFTYPE_ASSIGN_CONFIG
     seemed shorter and pricise.
     The configuration is created using evt_list.
     Resolved conflicts caused by the recent FS/ARCH code restructure.
     The monitor.c/rdtgroup.c files have been split between the FS and ARCH directories.

v12: New patch to hold the MBM event configurations for mbm_cntr_assign mode.
---
 Documentation/filesystems/resctrl.rst | 33 +++++++++++++++
 fs/resctrl/internal.h                 |  4 ++
 fs/resctrl/monitor.c                  | 56 +++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                 | 59 ++++++++++++++++++++++++++-
 include/linux/resctrl_types.h         |  3 ++
 5 files changed, 153 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 4c24c5f3f4c1..ddd95f1472e6 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -310,6 +310,39 @@ with the following files:
 	  # cat /sys/fs/resctrl/info/L3_MON/available_mbm_cntrs
 	  0=30;1=30
 
+"event_configs":
+	Directory that exists when "mbm_event" counter assignment mode is supported.
+	Contains a sub-directory for each MBM event that can be assigned to a counter.
+
+	Two MBM events are supported by default: mbm_local_bytes and mbm_total_bytes.
+	Each MBM event's sub-directory contains a file named "event_filter" that is
+	used to view and modify which memory transactions the MBM event is configured
+	with. The file is accessible only when "mbm_event" counter assignment mode is
+	enabled.
+
+	List of memory transaction types supported:
+
+	==========================  ========================================================
+	Name			    Description
+	==========================  ========================================================
+	dirty_victim_writes_all     Dirty Victims from the QOS domain to all types of memory
+	remote_reads_slow_memory    Reads to slow memory in the non-local NUMA domain
+	local_reads_slow_memory     Reads to slow memory in the local NUMA domain
+	remote_non_temporal_writes  Non-temporal writes to non-local NUMA domain
+	local_non_temporal_writes   Non-temporal writes to local NUMA domain
+	remote_reads                Reads to memory in the non-local NUMA domain
+	local_reads                 Reads to memory in the local NUMA domain
+	==========================  ========================================================
+
+	For example::
+
+	  # cat /sys/fs/resctrl/info/L3_MON/event_configs/mbm_total_bytes/event_filter
+	  local_reads,remote_reads,local_non_temporal_writes,remote_non_temporal_writes,
+	  local_reads_slow_memory,remote_reads_slow_memory,dirty_victim_writes_all
+
+	  # cat /sys/fs/resctrl/info/L3_MON/event_configs/mbm_local_bytes/event_filter
+	  local_reads,local_non_temporal_writes,local_reads_slow_memory
+
 "max_threshold_occupancy":
 		Read/write file provides the largest value (in
 		bytes) at which a previously used LLC_occupancy
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 88e1a800417d..7b1206fff116 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -241,6 +241,8 @@ struct rdtgroup {
 
 #define RFTYPE_DEBUG			BIT(10)
 
+#define RFTYPE_ASSIGN_CONFIG		BIT(11)
+
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
@@ -403,6 +405,8 @@ void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp);
 
 void rdtgroup_unassign_cntrs(struct rdtgroup *rdtgrp);
 
+int event_filter_show(struct kernfs_open_file *of, struct seq_file *seq, void *v);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 0a9d257e27a2..25fec9bf2d61 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -974,6 +974,61 @@ u32 resctrl_get_mon_evt_cfg(enum resctrl_event_id evtid)
 	return mon_event_all[evtid].evt_cfg;
 }
 
+/**
+ * struct mbm_transaction - Memory transaction an MBM event can be configured with.
+ * @name:	Name of memory transaction (read, write ...).
+ * @val:	The bit (eg. READS_TO_LOCAL_MEM or READS_TO_REMOTE_MEM) used to
+ *		represent the memory transaction within an event's configuration.
+ */
+struct mbm_transaction {
+	char	name[32];
+	u32	val;
+};
+
+/* Decoded values for each type of memory transaction. */
+static struct mbm_transaction mbm_transactions[NUM_MBM_TRANSACTIONS] = {
+	{"local_reads", READS_TO_LOCAL_MEM},
+	{"remote_reads", READS_TO_REMOTE_MEM},
+	{"local_non_temporal_writes", NON_TEMP_WRITE_TO_LOCAL_MEM},
+	{"remote_non_temporal_writes", NON_TEMP_WRITE_TO_REMOTE_MEM},
+	{"local_reads_slow_memory", READS_TO_LOCAL_S_MEM},
+	{"remote_reads_slow_memory", READS_TO_REMOTE_S_MEM},
+	{"dirty_victim_writes_all", DIRTY_VICTIMS_TO_ALL_MEM},
+};
+
+int event_filter_show(struct kernfs_open_file *of, struct seq_file *seq, void *v)
+{
+	struct mon_evt *mevt = rdt_kn_parent_priv(of->kn);
+	struct rdt_resource *r;
+	bool sep = false;
+	int ret = 0, i;
+
+	mutex_lock(&rdtgroup_mutex);
+	rdt_last_cmd_clear();
+
+	r = resctrl_arch_get_resource(mevt->rid);
+	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
+		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	for (i = 0; i < NUM_MBM_TRANSACTIONS; i++) {
+		if (mevt->evt_cfg & mbm_transactions[i].val) {
+			if (sep)
+				seq_putc(seq, ',');
+			seq_printf(seq, "%s", mbm_transactions[i].name);
+			sep = true;
+		}
+	}
+	seq_putc(seq, '\n');
+
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+
+	return ret;
+}
+
 /*
  * rdtgroup_assign_cntr() - Assign/unassign the counter ID for the event, RMID
  * pair in the domain.
@@ -1289,6 +1344,7 @@ int resctrl_mon_resource_init(void)
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 		resctrl_file_fflags_init("available_mbm_cntrs",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
+		resctrl_file_fflags_init("event_filter", RFTYPE_ASSIGN_CONFIG);
 	}
 
 	return 0;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 2e1d0a2703da..8f0c403e3fb5 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1923,6 +1923,12 @@ static struct rftype res_common_files[] = {
 		.seq_show	= mbm_local_bytes_config_show,
 		.write		= mbm_local_bytes_config_write,
 	},
+	{
+		.name		= "event_filter",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= event_filter_show,
+	},
 	{
 		.name		= "mbm_assign_mode",
 		.mode		= 0444,
@@ -2183,10 +2189,48 @@ int rdtgroup_kn_mode_restore(struct rdtgroup *r, const char *name,
 	return ret;
 }
 
+static int resctrl_mkdir_event_configs(struct rdt_resource *r, struct kernfs_node *l3_mon_kn)
+{
+	struct kernfs_node *kn_subdir, *kn_subdir2;
+	struct mon_evt *mevt;
+	int ret;
+
+	kn_subdir = kernfs_create_dir(l3_mon_kn, "event_configs", l3_mon_kn->mode, NULL);
+	if (IS_ERR(kn_subdir))
+		return PTR_ERR(kn_subdir);
+
+	ret = rdtgroup_kn_set_ugid(kn_subdir);
+	if (ret)
+		return ret;
+
+	for_each_mon_event(mevt) {
+		if (mevt->rid != r->rid || !mevt->enabled || !resctrl_is_mbm_event(mevt->evtid))
+			continue;
+
+		kn_subdir2 = kernfs_create_dir(kn_subdir, mevt->name, kn_subdir->mode, mevt);
+		if (IS_ERR(kn_subdir2)) {
+			ret = PTR_ERR(kn_subdir2);
+			goto out;
+		}
+
+		ret = rdtgroup_kn_set_ugid(kn_subdir2);
+		if (ret)
+			goto out;
+
+		ret = rdtgroup_add_files(kn_subdir2, RFTYPE_ASSIGN_CONFIG);
+		if (ret)
+			break;
+	}
+
+out:
+	return ret;
+}
+
 static int rdtgroup_mkdir_info_resdir(void *priv, char *name,
 				      unsigned long fflags)
 {
 	struct kernfs_node *kn_subdir;
+	struct rdt_resource *r;
 	int ret;
 
 	kn_subdir = kernfs_create_dir(kn_info, name,
@@ -2199,8 +2243,19 @@ static int rdtgroup_mkdir_info_resdir(void *priv, char *name,
 		return ret;
 
 	ret = rdtgroup_add_files(kn_subdir, fflags);
-	if (!ret)
-		kernfs_activate(kn_subdir);
+	if (ret)
+		return ret;
+
+	if ((fflags & RFTYPE_MON_INFO) == RFTYPE_MON_INFO) {
+		r = priv;
+		if (r->mon.mbm_cntr_assignable) {
+			ret = resctrl_mkdir_event_configs(r, kn_subdir);
+			if (ret)
+				return ret;
+		}
+	}
+
+	kernfs_activate(kn_subdir);
 
 	return ret;
 }
diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index d98351663c2c..acfe07860b34 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -34,6 +34,9 @@
 /* Max event bits supported */
 #define MAX_EVT_CONFIG_BITS		GENMASK(6, 0)
 
+/* Number of memory transactions that an MBM event can be configured with */
+#define NUM_MBM_TRANSACTIONS		7
+
 /* Event IDs */
 enum resctrl_event_id {
 	/* Must match value of first event below */
-- 
2.34.1


