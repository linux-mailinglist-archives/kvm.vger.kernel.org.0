Return-Path: <kvm+bounces-56943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8D8B46608
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 430D81887838
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829ED3074A4;
	Fri,  5 Sep 2025 21:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vTG3o3jy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF5F2FF674;
	Fri,  5 Sep 2025 21:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108405; cv=fail; b=e5PY/zd8QLrTnJ/hTHRnv3j5Ta+R/obkdUhJPcGcKUSKBg2cMMSPkJQ+bKUFdUFSQ7kZDsrB2sLIkHDJzyEDrXCg/Ci9mbdQ1m7i9m6AmDTZvKYV9Cg99STr5aa0KuBa219NXyu3KbkkzzDKXAqMBcdwOShiGZZ4ZPbxoQHrIgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108405; c=relaxed/simple;
	bh=1ET0d4Ew7lYEOH6fBHW8kP8OqHbWOJAl6lyOn235Ezk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJKnIopuS94YZ7BvAU+Gwg3JLz0sAWskqA7EAt5MxoAmT8JFoEUT3DVv+JDuSiz6EgeeToi4+VXfv17QgDUCJSNw+XqDG72nRvrZaFKVNuS8L/iHdQx6pWo538NeqiOdZyMTOjkXL44SQ1eCs2sHK7sFpfiags4Cf6mLFxynMhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vTG3o3jy; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aFXJBBce+KUBXB+0twGqeP22tPFubDPpeGjXa6B7cKO25eGoDOGlJNFSApui/EmfC2aDUdYXIzpufaNZrJPyjt9V8s1wDCeDt1rlTYw+ZhK2sHOfE/gXaHuEEGAh4qbcfXIt9AAy49zcwXmCc8o93MHbNW5N7ClZsDErOqDNsRJiM2Yl8dIMCJDIIsd069P+XqPuj7+V5FKg1BiP5G5FhQ7k4v5jRmJHQWryrw+RbeOTrS4Uo2unb4E61tD3/5BHFrApXGeJeU+oItnMtAFrp4o8ufir8SJvFbhKp/vqhI2gLeVskKCOVIjLDD5tnSHzkrA6O1Yocn4LkfZkOub+Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E4/wUPxgWBtYq+1BCjpX/sT7R5i8/tI+CK1tV9STtwA=;
 b=dp4UfSbWDxOafP59WmZ0vJ26KfEpOcE8Su6i3b2isGhhb5Cn9W7If/8CkyoWGew33ijZZJn5ELMAD8fparxaOokp1sUjjaxorZjBlyNh4GciC4i6YGl623f9yo4BjZPLM8q4SdFxw6H1rT79W8TJ2cVTL7uQBRqfLgsOs9PSjhkd3w8lDkhsKI4HYYQar9olkPZI9yl2DFwO3LDiH0QG7qJRJ/J1sXMR4tT/hxUDUZZCNtK160tg3olZj6Vwu1EpEjx5UIqA0VnqZUAOf08vu1Oo1LVdOmBVwob6WaeMJArzg8sbHBZJtJeJ+A+9LsJkcSjfxYUFdymKHzmNH9y2Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E4/wUPxgWBtYq+1BCjpX/sT7R5i8/tI+CK1tV9STtwA=;
 b=vTG3o3jyJS5hJUj8COCT2+ELT3T5Jf8ERNEaerDmOMJkNR589DyFm5FeOQ4A1ClzmpuYZ9Qg1mRkWK/fVSCJZW7D3C8i53whvl/JPLJKHetXncVq7q/d/GXV6nEODm0Z0KvCpWDyPt08o9yyk7zuE+73LqHfvtrj9AnYmf5YWUo=
Received: from SJ0PR13CA0012.namprd13.prod.outlook.com (2603:10b6:a03:2c0::17)
 by DM6PR12MB4419.namprd12.prod.outlook.com (2603:10b6:5:2aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 21:39:56 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::7f) by SJ0PR13CA0012.outlook.office365.com
 (2603:10b6:a03:2c0::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.10 via Frontend Transport; Fri,
 5 Sep 2025 21:39:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:39:55 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:39:55 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:39:53 -0700
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
Subject: [PATCH v18 31/33] fs/resctrl: Introduce the interface to switch between monitor modes
Date: Fri, 5 Sep 2025 16:34:30 -0500
Message-ID: <22585f963c8b3c042cb7acfd663d497225fb0f75.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|DM6PR12MB4419:EE_
X-MS-Office365-Filtering-Correlation-Id: a51fda14-1cd6-4c93-ec80-08ddecc4c17a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m7pUtQnqkvPCbd4EwrkZUBtAIdCtOzAsKilpr6HTiO1JolnKLZ57JTiFJ5RR?=
 =?us-ascii?Q?AySouXfQbSfKv1El9XYn3dfqp6l66rYKcEaHJgYZsYdH6YVGvu8Tp7qINuCt?=
 =?us-ascii?Q?YsxTJyaWrgYLTteJ/H62GVNLxXxeYnGE3nJr7QRpNHvOOqfCJKdMDydg9vgU?=
 =?us-ascii?Q?x5Al/61dWODfNhMJxwH9pKnst0r3knLhXKfc4LpYlOjqgGHXl+Vkz79xzojN?=
 =?us-ascii?Q?ODXU2bdVSl0pY0LtLg7domGgo8bpdKj0CSmR4rjXjIM5asKTvzdw5nLV7dU1?=
 =?us-ascii?Q?sl1+hMQhwQBtrWuRdA+d3fUSC147ag0+3tsew9zM296mYEPOB/Wu4NiHb0ZX?=
 =?us-ascii?Q?Y+Ut/rxtQ36OUO2XWPc3fejYMTGL8pToWCvoUQSy50qqGY254kIBIzfHajYT?=
 =?us-ascii?Q?aCAecJtaYKF7vr0roV1cSwx0uPt6tFXYGFG29yLXb5fisFShQlcOy5ydv95Z?=
 =?us-ascii?Q?8+0lqeIrEx0tBbqhsVKMK9SYByF28IINhSc0aAmRWgj9MusiYMbMF1UMQuy8?=
 =?us-ascii?Q?uarNNK/dwHxEbSvMmXOMr+btb3xee5QN3xZmFO/w2g0rYRuA+jIMiCG5Zmir?=
 =?us-ascii?Q?lgDLSJCCXWmsrLm1A5q5zRmAVKVAuiuorGL3hft7h0Z9L2psG80H1F0XjLym?=
 =?us-ascii?Q?t/E3Kb+2rpWpOeEgRssLl9Rj1scL3pq+8Fm7sMPpDZa/baG2pDRDR/LqoXII?=
 =?us-ascii?Q?z159GDRCM5af3P+fv+P1vvVqjS/+lWZ5Uy4qVXAJrZaaCCzNQCyPgc+FpBVx?=
 =?us-ascii?Q?hl578czORogbOZXVgQfRIFG4FludA3A81diMDWnjAJAVAgXnkvrFWhhCPki2?=
 =?us-ascii?Q?Vu2/3QKC1WyTNzt7xNhEyayW4s2A0V4Jz+NKI0sduuZAEsKeMSResL4n0eE1?=
 =?us-ascii?Q?rBZsEiZPMRX+3NTFlWk8yFJYUxYyen/pWOoT4onrIk2wOeHmO6On6LpiAVLJ?=
 =?us-ascii?Q?RYWQmwsr0roshKtcE5rNyMmqyCseZzqEJmXL922yVRkaX23cJkOIJWzAIrqg?=
 =?us-ascii?Q?tbh/CSI67jIAA43cLtZyl4I9GWpBafBO0DGoA+sh6SgJnVHxkgeo+XQI2s//?=
 =?us-ascii?Q?/d0OGqlrqek6qeINZ53kzSpNNMRr4h/tirJq+IotSeOlYaBIfxIGJQ1NXYpS?=
 =?us-ascii?Q?K7p1QurvpITZGRBRhXIf0Q6mqfQ5rTW4khm62pZPPYpSl+G4eHgPcKkCyrEJ?=
 =?us-ascii?Q?ftmIpPbLMaUNbtP/s0ut17GMX9gXoBv1trtqkkAcsBRLqs769FSc7DsgG7bt?=
 =?us-ascii?Q?HYrsK1VpSxemClxHRB/n1Je55Xxo/ZKLh8/YQsow/ZcRE+PGiiRJmE1Cpguy?=
 =?us-ascii?Q?UJoBauJGDNlj7ZwPrJdpMuyQdWE3rw5HKNv6c6j7JnbSN1HXcHcHW3W1HOPU?=
 =?us-ascii?Q?yIDgKVtXYUK7zRuJYVcZASqMzRLkk3sZB6f3InnIO66H2EEvYlh2sEiJkosi?=
 =?us-ascii?Q?6fbyXYpW/4tz3ZUYE6iIcpqWUEN7cK8T/90BNfwqvQ/whG7DGb3+ozHNbHOY?=
 =?us-ascii?Q?B3nrYH1u6kGShrs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:39:55.9411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a51fda14-1cd6-4c93-ec80-08ddecc4c17a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4419

Resctrl subsystem can support two monitoring modes, "mbm_event" or
"default". In mbm_event mode, monitoring event can only accumulate data
while it is backed by a hardware counter. In "default" mode, resctrl
assumes there is a hardware counter for each event within every CTRL_MON
and MON group.

Introduce mbm_assign_mode resctrl file to switch between mbm_event and
default modes.

Example:
To list the MBM monitor modes supported:
$ cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
[mbm_event]
default

To enable the "mbm_event" counter assignment mode:
$ echo "mbm_event" > /sys/fs/resctrl/info/L3_MON/mbm_assign_mode

To enable the "default" monitoring mode:
$ echo "default" > /sys/fs/resctrl/info/L3_MON/mbm_assign_mode

Reset MBM event counters automatically as part of changing the mode.
Clear both architectural and non-architectural event states to prevent
overflow conditions during the next event read. Clear assignable counter
configuration on all the domains. Also, enable auto assignment when
switching to "mbm_event" mode.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Changelog update for imperative mode.
     Added Reviewed-by tag.

v17: Moved resctrl_mbm_assign_mode_write() to fs/resctrl/monitor.c
     Fixed the event configuration initialization while considering hw support.
     Enable auto assignment when switching to "mbm_event" mode.

v16: Minor changelog update.
     Minor update in resctrl.rst.
     Updated resctrl_bmec_files_show() to pass NULL for kn_fs_node.

v15: Minor changelog update.
     Minir user do resctrl.rst update.
     Fixed stray hunks.

v14: Updated the changelog to reflect the change in monitor mode naming.
     Added the call resctrl_bmec_files_show() to enable/disable files
     related to BMEC.
     Added resctrl_set_mon_evt_cfg() to reset event configuration values
     when mode is changes.

v13: Resolved the conflicts due to FS/ARCH restructure.
     Introduced the new resctrl_init_evt_configuration() to initialize
     the event modes and configuration values.
     Added the call to resctrl_bmec_files_show() hide/show BMEC related
     files.

v12: Fixed the documentation for a consistency.
     Introduced mbm_cntr_free_all() and resctrl_reset_rmid_all() to clear
     counters and non-architectural states when monitor mode is changed.
     https://lore.kernel.org/lkml/b60b4f72-6245-46db-a126-428fb13b6310@intel.com/

v11: Changed the name of the function rdtgroup_mbm_assign_mode_write() to
     resctrl_mbm_assign_mode_write().
     Rewrote the commit message with context.
     Added few more details in resctrl.rst about mbm_cntr_assign mode.
     Re-arranged the text in resctrl.rst file.

v10: The call mbm_cntr_reset() has been moved to earlier patch.
     Minor documentation update.

v9: Fixed extra spaces in user documentation.
    Fixed problem changing the mode to mbm_cntr_assign mode when it is
    not supported. Added extra checks to detect if systems supports it.
    Used the rdtgroup_cntr_id_init to initialize cntr_id.

v8: Reset the internal counters after mbm_cntr_assign mode is changed.
    Renamed rdtgroup_mbm_cntr_reset() to mbm_cntr_reset()
    Updated the documentation to make text generic.

v7: Changed the interface name to mbm_assign_mode.
    Removed the references of ABMC.
    Added the changes to reset global and domain bitmaps.
    Added the changes to reset rmid.

v6: Changed the mode name to mbm_cntr_assign.
    Moved all the FS related code here.
    Added changes to reset mbm_cntr_map and resctrl group counters.

v5: Change log and mode description text correction.

v4: Minor commit text changes. Keep the default to ABMC when supported.
    Fixed comments to reflect changed interface "mbm_mode".

v3: New patch to address the review comments from upstream.
---
 Documentation/filesystems/resctrl.rst |  22 +++++-
 fs/resctrl/internal.h                 |   6 ++
 fs/resctrl/monitor.c                  | 100 ++++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                 |   7 +-
 4 files changed, 131 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index f60f6a96cb6b..006d23af66e1 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -259,7 +259,8 @@ with the following files:
 
 "mbm_assign_mode":
 	The supported counter assignment modes. The enclosed brackets indicate which mode
-	is enabled.
+	is enabled. The MBM events associated with counters may reset when "mbm_assign_mode"
+	is changed.
 	::
 
 	  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
@@ -279,6 +280,15 @@ with the following files:
 	of counters available is described in the "num_mbm_cntrs" file. Changing the
 	mode may cause all counters on the resource to reset.
 
+	Moving to mbm_event counter assignment mode requires users to assign the counters
+	to the events. Otherwise, the MBM event counters will return 'Unassigned' when read.
+
+	The mode is beneficial for AMD platforms that support more CTRL_MON
+	and MON groups than available hardware counters. By default, this
+	feature is enabled on AMD platforms with the ABMC (Assignable Bandwidth
+	Monitoring Counters) capability, ensuring counters remain assigned even
+	when the corresponding RMID is not actively used by any processor.
+
 	"default":
 
 	In default mode, resctrl assumes there is a hardware counter for each
@@ -288,6 +298,16 @@ with the following files:
 	result in misleading values or display "Unavailable" if no counter is assigned
 	to the event.
 
+	* To enable "mbm_event" counter assignment mode:
+	  ::
+
+	    # echo "mbm_event" > /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
+
+	* To enable "default" monitoring mode:
+	  ::
+
+	    # echo "default" > /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
+
 "num_mbm_cntrs":
 	The maximum number of counters (total of available and assigned counters) in
 	each domain when the system supports mbm_event mode.
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 264f04c7dfba..6938734b14a4 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -396,6 +396,12 @@ void *rdt_kn_parent_priv(struct kernfs_node *kn);
 
 int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of, struct seq_file *s, void *v);
 
+ssize_t resctrl_mbm_assign_mode_write(struct kernfs_open_file *of, char *buf,
+				      size_t nbytes, loff_t off);
+
+void resctrl_bmec_files_show(struct rdt_resource *r, struct kernfs_node *l3_mon_kn,
+			     bool show);
+
 int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of, struct seq_file *s, void *v);
 
 int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of, struct seq_file *s,
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index d49170247b75..4cf78a9a8807 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1080,6 +1080,33 @@ ssize_t resctrl_mbm_assign_on_mkdir_write(struct kernfs_open_file *of, char *buf
 	return ret ?: nbytes;
 }
 
+/*
+ * mbm_cntr_free_all() - Clear all the counter ID configuration details in the
+ *			 domain @d. Called when mbm_assign_mode is changed.
+ */
+static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_mon_domain *d)
+{
+	memset(d->cntr_cfg, 0, sizeof(*d->cntr_cfg) * r->mon.num_mbm_cntrs);
+}
+
+/*
+ * resctrl_reset_rmid_all() - Reset all non-architecture states for all the
+ *			      supported RMIDs.
+ */
+static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
+{
+	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
+	enum resctrl_event_id evt;
+	int idx;
+
+	for_each_mbm_event_id(evt) {
+		if (!resctrl_is_mon_event_enabled(evt))
+			continue;
+		idx = MBM_STATE_IDX(evt);
+		memset(d->mbm_states[idx], 0, sizeof(*d->mbm_states[0]) * idx_limit);
+	}
+}
+
 /*
  * rdtgroup_assign_cntr() - Assign/unassign the counter ID for the event, RMID
  * pair in the domain.
@@ -1390,6 +1417,79 @@ int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of,
 	return 0;
 }
 
+ssize_t resctrl_mbm_assign_mode_write(struct kernfs_open_file *of, char *buf,
+				      size_t nbytes, loff_t off)
+{
+	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
+	struct rdt_mon_domain *d;
+	int ret = 0;
+	bool enable;
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
+	if (!strcmp(buf, "default")) {
+		enable = 0;
+	} else if (!strcmp(buf, "mbm_event")) {
+		if (r->mon.mbm_cntr_assignable) {
+			enable = 1;
+		} else {
+			ret = -EINVAL;
+			rdt_last_cmd_puts("mbm_event mode is not supported\n");
+			goto out_unlock;
+		}
+	} else {
+		ret = -EINVAL;
+		rdt_last_cmd_puts("Unsupported assign mode\n");
+		goto out_unlock;
+	}
+
+	if (enable != resctrl_arch_mbm_cntr_assign_enabled(r)) {
+		ret = resctrl_arch_mbm_cntr_assign_set(r, enable);
+		if (ret)
+			goto out_unlock;
+
+		/* Update the visibility of BMEC related files */
+		resctrl_bmec_files_show(r, NULL, !enable);
+
+		/*
+		 * Initialize the default memory transaction values for
+		 * total and local events.
+		 */
+		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
+			mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
+		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
+			mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
+									   (READS_TO_LOCAL_MEM |
+									    READS_TO_LOCAL_S_MEM |
+									    NON_TEMP_WRITE_TO_LOCAL_MEM);
+		/* Enable auto assignment when switching to "mbm_event" mode */
+		if (enable)
+			r->mon.mbm_assign_on_mkdir = true;
+		/*
+		 * Reset all the non-achitectural RMID state and assignable counters.
+		 */
+		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+			mbm_cntr_free_all(r, d);
+			resctrl_reset_rmid_all(r, d);
+		}
+	}
+
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+
+	return ret ?: nbytes;
+}
+
 int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of,
 			       struct seq_file *s, void *v)
 {
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0c404a159d45..0320360cd7a6 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1807,8 +1807,8 @@ static ssize_t mbm_local_bytes_config_write(struct kernfs_open_file *of,
  * Don't treat kernfs_find_and_get failure as an error, since this function may
  * be called regardless of whether BMEC is supported or the event is enabled.
  */
-static void resctrl_bmec_files_show(struct rdt_resource *r, struct kernfs_node *l3_mon_kn,
-				    bool show)
+void resctrl_bmec_files_show(struct rdt_resource *r, struct kernfs_node *l3_mon_kn,
+			     bool show)
 {
 	struct kernfs_node *kn_config, *mon_kn = NULL;
 	char name[32];
@@ -1985,9 +1985,10 @@ static struct rftype res_common_files[] = {
 	},
 	{
 		.name		= "mbm_assign_mode",
-		.mode		= 0444,
+		.mode		= 0644,
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.seq_show	= resctrl_mbm_assign_mode_show,
+		.write		= resctrl_mbm_assign_mode_write,
 		.fflags		= RFTYPE_MON_INFO | RFTYPE_RES_CACHE,
 	},
 	{
-- 
2.34.1


