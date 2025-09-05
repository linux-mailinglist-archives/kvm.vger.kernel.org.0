Return-Path: <kvm+bounces-56922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB017B465C1
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 035BC5A4DEA
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1332FD1B6;
	Fri,  5 Sep 2025 21:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G6oigTl7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCB32FCBFD;
	Fri,  5 Sep 2025 21:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108195; cv=fail; b=HuatxYfxT4ZZHXJFioUjAapoknYaQInBu3DxHdhlQWXRhj/74rRGxgNgBHpb2W3IcKrXZMchrBORjIwfQGvfNss90ZyDFJU5W4q2EZ806xSYSg401hk1BdKskjg7iimeWY+WiHMWNjEC8eq7aEhI3oL2qk2QaMwKLcaOWE7v1b0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108195; c=relaxed/simple;
	bh=0nGq7ij5oVPwBUWKH6wIxc2KsBFSwag7wfarYfKG48I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUZLwYp4ft4FHBVxILcjGOLx/geWCMPKsZybM7dylzDz9CScnpk3sgiw85St0CHWwbq5fdhVG04mcqEeYpHDNYAtDa6XW1HL8M7LVJi0mTGXz0+JlDPe/JuQxsaLoQTLGfjtG8vR/d0iP1Sz6/oEuw886teRIakKz16Hf7dnum8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G6oigTl7; arc=fail smtp.client-ip=40.107.220.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ODJ20TNdCK2J5wGkqYU8aRiOm6ZGO4M2jCzZV9qhw69mhxHKfyYWnJ/sCEs/IzgUl2Vrzt+eDR6qiMzjQkq1f17R/l4JS+Ue13wyfSX1PJx/NnhTXCviCI8llLQM5iXfcRyh7pr1V1pOTKP8pSy9MT7E9ylgjeijOjthLtJnTzgA92AxiEoXtucVI5rbB9F/xIkDVOARHg/y74u6UU56y7W/OBBy1gPMgGzsXWfZ3IX6QOVtnaNlMzCrFlxDcmyNczizrCL9GuxyO8JmpEZ+IYlmKec8br5W6AbiNX2VERIABQpyU8WVOeyzOM+lcErDH1b89bxumMDIF/xgoW13aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57RCUYF4kVhkrZEujKTG7w0nwRUTDkI+hrI5hDK1Eh0=;
 b=MNCetzOAg7hvtV+vpo6WomAGM8D5Go8SnIdgsZrVG1zMWGdWjkw4OLK/QrnWCUwQpee/UKhOFiLTkiwLWX/50Ipib9y6SVeQLthvNQ9ZCOL+SBn92IfTIwz3BE5Ql4K1O9iOzK8/hIuAqwCuNraMtgUt9JKB4zfKfgiOb+WOXqq2GdKkd5ErkDP+WPb+icCkdtnvKejj7HF4oeOFSbHUbuapk8gmk2NwptbH3ltUDctH8+/mRiYbNKsJTkK7RPl4xRi7A7Bx7FjDS1qCePXdgOUUiRKNPJTcIVolQLkw1W0s0AkwSuNfK8ej54b50pwACcJWfc2EXfE2zk6xIl6xXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57RCUYF4kVhkrZEujKTG7w0nwRUTDkI+hrI5hDK1Eh0=;
 b=G6oigTl7iVwxk9wjRjhLrzFE7TB3o6NuybgOiy8fwowXDIvJNEgBVT3nvQ7HTymB5+UjSEdzcPzPKVkm4KDXRJJBnoiBnFlfcmd0rj7tG/xvb73CTiUSjzG6aFk6HrVbtz5mGq6iCjaJ6koCwB15+i+OrB6XCr0SjcrVyN5YQ1M=
Received: from BYAPR01CA0023.prod.exchangelabs.com (2603:10b6:a02:80::36) by
 MW4PR12MB6850.namprd12.prod.outlook.com (2603:10b6:303:1ed::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Fri, 5 Sep
 2025 21:36:30 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:a02:80:cafe::de) by BYAPR01CA0023.outlook.office365.com
 (2603:10b6:a02:80::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.18 via Frontend Transport; Fri,
 5 Sep 2025 21:35:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:36:30 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:36:29 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:36:27 -0700
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
Subject: [PATCH v18 10/33] fs/resctrl: Introduce the interface to display monitoring modes
Date: Fri, 5 Sep 2025 16:34:09 -0500
Message-ID: <8e49aa6d087f42a8f00a0263fc8d194f105d5fc1.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|MW4PR12MB6850:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cab1b10-21ad-4cba-3c24-08ddecc44724
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?te5msxNQV0VLcIA4qn24f2kj7MVIKMnzDp3Eu+24+SVAlROeu+hOsyBc01wI?=
 =?us-ascii?Q?aotQ6WCyC6NLY6059HrKisI3mciQ+vydZYLKdJ6Qe2qB7kcKBl1f7a0eU7sM?=
 =?us-ascii?Q?gfO6yVewjiaP/wUzdigd9+d0yNViSxiY1jmck7Q5/5ibz/2/xudoIDNPtpBh?=
 =?us-ascii?Q?FgZUibmdfwfDjQJx7lLSp1AuwTqbLIZOpdPG6+PyIlHofKxVEHBVWP1ysoVb?=
 =?us-ascii?Q?5b73afk8tyMHps4YIFYWkr8jpESn73INwk2uwhfjYzSoOniZNcZrxtalSA78?=
 =?us-ascii?Q?xt6m1ad0fEt2atgkg/zWrKI8F9UAzUF4iozgsfXSiJYDOxgirspUfRVO1giI?=
 =?us-ascii?Q?KPuCEYLGAm1GqKIsxMZM9SEGvYFAUU3JPoPXM2FT757vdqtiR5woQwymPVXG?=
 =?us-ascii?Q?UAtsq3St2LjQ0XsJPi1TXARGZXRX/lMye+hEKvU1R49Unx/UGLk/zzSIhElQ?=
 =?us-ascii?Q?vrS1hsfSQp6lzafInqEScpHRT+gxQtLa2BzKxtUZLB/5wSZ73rGUSAODfIm1?=
 =?us-ascii?Q?CVWfGFtiZpAakKcuvycvsw7k46zK6M+Kx5oeHKrMXB/hbMkFJVCWmuGECxnK?=
 =?us-ascii?Q?Xok5lyAWAv/Q0WhYOorVNasNlkky9dXy0bo6jF6dDLaYcv0/Qzgpjki/vsrK?=
 =?us-ascii?Q?HDWKKZ1yFgv0VtExJLEOayBiPd4aFcMUai6mXpSvXRwxA4miTXt7LkwSSrzU?=
 =?us-ascii?Q?aW+i/VLiZ/ZnIMNRy5fISjstHN58oNI2dFZxphWN/4aK8kX6QwLk1Xrbdt5K?=
 =?us-ascii?Q?3Vw/qCwgSvBjaOPhE1kTzanamDYngmhycF2r9gBMwY2v8rxqA0uhlBGp5MmF?=
 =?us-ascii?Q?kYCAZr69dsFLaynnSfG0EMuK/BCFRafcFbmpG5vnXotBnE1/Ns+pLOxwcWNc?=
 =?us-ascii?Q?mnG7nL9GXfVXx+J04ILEt9g+FqUIEGEf95i6Ti3tY41DjTchtp2wsKkqiQtQ?=
 =?us-ascii?Q?uvg183I3sHdDcwaImXVX3jdgeBlYIpn6erwpSvx9Ijp22h7Y1MQ5MEvwr/Jd?=
 =?us-ascii?Q?HaI3OIKxpXV3DrLNb4PNiyS2SsN0QbgEDoEx+6DQyEf7bdNFpp76vzzivbsX?=
 =?us-ascii?Q?QfnbDTjf4oaFeqZjFlQRVipY3yYvbIZYuYzeE5hQ+zlfV6QBrkBSyeENBK3v?=
 =?us-ascii?Q?MUK+5SUWn1d9RtoixRbEFD/FRqQU16qsMf0YZqS1jOHDETLz5onTj92lQZ5i?=
 =?us-ascii?Q?u2NcuiZxG12+ZpnYe066HT7E0oBIKHXSStXuDQ067Qiw3aBwGMHRakxBIxnJ?=
 =?us-ascii?Q?3k/pSoNqGA7eoE4f1PkvGRw2NzIr3ACB1qEOzsBE+NXPHyW8Xymg3gVhZZSM?=
 =?us-ascii?Q?Vq4wruKnY5WV8lfwaz8ScLNfl4smKkROhu/5ajlvpxbdLmFyQQ22ZC/EqZ1y?=
 =?us-ascii?Q?AbXmhlnvXy5N75JEIBe6U6cv+jhKvAwy9Nt+HeQl8bX87O5D9I5HMglW9hB9?=
 =?us-ascii?Q?G+lduXf0kXSJF/zVjROEj/S5KZrn9zqoROuxrp7HwDISq1LzG38D1aU1QM7z?=
 =?us-ascii?Q?wmRaP9lskjNkAC5EFOcrP/mt3jWUdlxIehrvy/9J83z8oGszJyUMDVMn2w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:36:30.6382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cab1b10-21ad-4cba-3c24-08ddecc44724
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6850

Introduce the resctrl file "mbm_assign_mode" to list the supported counter
assignment modes.

The "mbm_event" counter assignment mode allows users to assign a hardware
counter to an RMID, event pair and monitor bandwidth usage as long as it is
assigned. The hardware continues to track the assigned counter until it is
explicitly unassigned by the user. Each event within a resctrl group can be
assigned independently in this mode.

On AMD systems "mbm_event" mode is backed by the ABMC (Assignable
Bandwidth Monitoring Counters) hardware feature and is enabled by default.

The "default" mode is the existing mode that works without the explicit
counter assignment, instead relying on dynamic counter assignment by
hardware that may result in hardware not dedicating a counter resulting
in monitoring data reads returning "Unavailable".

Provide an interface to display the monitor modes on the system.

$ cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
[mbm_event]
default

Add IS_ENABLED(CONFIG_RESCTRL_ASSIGN_FIXED) check to support Arm64.

On x86, CONFIG_RESCTRL_ASSIGN_FIXED is not defined. On Arm64, it will be
defined when the "mbm_event" mode is supported.

Add IS_ENABLED(CONFIG_RESCTRL_ASSIGN_FIXED) check early to ensure the user
interface remains compatible with upcoming Arm64 support. IS_ENABLED()
safely evaluates to 0 when the configuration is not defined.

As a result, for MPAM, the display would be either:
[default]
or
[mbm_event]

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Moved resctrl_mbm_assign_mode_show() to fs/resctrl/monitor.c.
     Removed Reviewed-by tag as patch has changed.

v16: Update with Reviewed-by tag.

v15: Minor text changes in changelog and resctrl.rst.

v14: Changed the name of the monitor mode to mbm_cntr_evt_assign based on the discussion.
     https://lore.kernel.org/lkml/7628cec8-5914-4895-8289-027e7821777e@amd.com/
     Changed the name of the mbm_assign_mode's.
     Updated resctrl.rst for mbm_event mode.
     Changed subject line to fs/resctrl.

v13: Updated the commit log with motivation for adding CONFIG_RESCTRL_ASSIGN_FIXED.
     Added fflag RFTYPE_RES_CACHE for mbm_assign_mode file.
     Updated user doc. Removed the references to "mbm_assign_control".
     Resolved the conflicts with latest FS/ARCH code restructure.

v12: Minor text update in change log and user documentation.
     Added the check CONFIG_RESCTRL_ASSIGN_FIXED to take care of arm platforms.
     This will be defined only in arm and not in x86.

v11: Renamed rdtgroup_mbm_assign_mode_show() to resctrl_mbm_assign_mode_show().
     Removed few texts in resctrl.rst about AMD specific information.
     Updated few texts.

v10: Added few more text to user documentation clarify on the default mode.

v9: Updated user documentation based on comments.

v8: Commit message update.

v7: Updated the descriptions/commit log in resctrl.rst to generic text.
    Thanks to James and Reinette.
    Rename mbm_mode to mbm_assign_mode.
    Introduced mutex lock in rdtgroup_mbm_mode_show().

v6: Added documentation for mbm_cntr_assign and legacy mode.
    Moved mbm_mode fflags initialization to static initialization.

v5: Changed interface name to mbm_mode.
    It will be always available even if ABMC feature is not supported.
    Added description in resctrl.rst about ABMC mode.
    Fixed display abmc and legacy consistantly.

v4: Fixed the checks for legacy and abmc mode. Default it ABMC.

v3: New patch to display ABMC capability.
---
 Documentation/filesystems/resctrl.rst | 31 +++++++++++++++++++++++++++
 fs/resctrl/internal.h                 |  4 ++++
 fs/resctrl/monitor.c                  | 30 ++++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                 |  9 +++++++-
 4 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index c97fd77a107d..b692829fec5f 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -257,6 +257,37 @@ with the following files:
 	    # cat /sys/fs/resctrl/info/L3_MON/mbm_local_bytes_config
 	    0=0x30;1=0x30;3=0x15;4=0x15
 
+"mbm_assign_mode":
+	The supported counter assignment modes. The enclosed brackets indicate which mode
+	is enabled.
+	::
+
+	  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
+	  [mbm_event]
+	  default
+
+	"mbm_event":
+
+	mbm_event mode allows users to assign a hardware counter to an RMID, event
+	pair and monitor the bandwidth usage as long as it is assigned. The hardware
+	continues to track the assigned counter until it is explicitly unassigned by
+	the user. Each event within a resctrl group can be assigned independently.
+
+	In this mode, a monitoring event can only accumulate data while it is backed
+	by a hardware counter. Use "mbm_L3_assignments" found in each CTRL_MON and MON
+	group to specify which of the events should have a counter assigned. The number
+	of counters available is described in the "num_mbm_cntrs" file. Changing the
+	mode may cause all counters on the resource to reset.
+
+	"default":
+
+	In default mode, resctrl assumes there is a hardware counter for each
+	event within every CTRL_MON and MON group. On AMD platforms, it is
+	recommended to use the mbm_event mode, if supported, to prevent reset of MBM
+	events between reads resulting from hardware re-allocating counters. This can
+	result in misleading values or display "Unavailable" if no counter is assigned
+	to the event.
+
 "max_threshold_occupancy":
 		Read/write file provides the largest value (in
 		bytes) at which a previously used LLC_occupancy
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 4f315b7e9ec0..4fbc809b11a6 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -382,6 +382,10 @@ bool closid_allocated(unsigned int closid);
 
 int resctrl_find_cleanest_closid(void);
 
+void *rdt_kn_parent_priv(struct kernfs_node *kn);
+
+int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of, struct seq_file *s, void *v);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 66c8c635f4b3..379166134f5a 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -884,6 +884,36 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
 	       mon_event_all[eventid].enabled;
 }
 
+int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of,
+				 struct seq_file *s, void *v)
+{
+	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
+	bool enabled;
+
+	mutex_lock(&rdtgroup_mutex);
+	enabled = resctrl_arch_mbm_cntr_assign_enabled(r);
+
+	if (r->mon.mbm_cntr_assignable) {
+		if (enabled)
+			seq_puts(s, "[mbm_event]\n");
+		else
+			seq_puts(s, "[default]\n");
+
+		if (!IS_ENABLED(CONFIG_RESCTRL_ASSIGN_FIXED)) {
+			if (enabled)
+				seq_puts(s, "default\n");
+			else
+				seq_puts(s, "mbm_event\n");
+		}
+	} else {
+		seq_puts(s, "[default]\n");
+	}
+
+	mutex_unlock(&rdtgroup_mutex);
+
+	return 0;
+}
+
 /**
  * resctrl_mon_resource_init() - Initialise global monitoring structures.
  *
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index b6ab10704993..144585a85996 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -975,7 +975,7 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
 	return 0;
 }
 
-static void *rdt_kn_parent_priv(struct kernfs_node *kn)
+void *rdt_kn_parent_priv(struct kernfs_node *kn)
 {
 	/*
 	 * The parent pointer is only valid within RCU section since it can be
@@ -1911,6 +1911,13 @@ static struct rftype res_common_files[] = {
 		.seq_show	= mbm_local_bytes_config_show,
 		.write		= mbm_local_bytes_config_write,
 	},
+	{
+		.name		= "mbm_assign_mode",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= resctrl_mbm_assign_mode_show,
+		.fflags		= RFTYPE_MON_INFO | RFTYPE_RES_CACHE,
+	},
 	{
 		.name		= "cpus",
 		.mode		= 0644,
-- 
2.34.1


