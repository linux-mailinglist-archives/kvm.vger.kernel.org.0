Return-Path: <kvm+bounces-56929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A88B465D6
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FDEA586076
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EDFA2FB0A7;
	Fri,  5 Sep 2025 21:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ewWnkQJa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374632F39A2;
	Fri,  5 Sep 2025 21:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108273; cv=fail; b=rLFa/IUO6rPUKfeg3eCle+PK6en+TVO8m/zazckpwhMDMa0SCUYF9/x5qBEl/bap0cY/iJvA2LBGi20XHuY/8Tiw1TMjIS74ClSdy+u06m4aimEVSEy7WoEBhIST9NY7rBHHlsIffmafcfdiTgKjlS4KR04CEeOA1ZUswoJDNY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108273; c=relaxed/simple;
	bh=IaPT/QhgxMy+g4iItQ9AKEugTaVxNZzOo5qCeIg0Zc8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ds8V71A7QXMJk14oQiqeDcq86ICG/Qw+jSmrY32/GMD60mO3/XL/WzW+a2Ken4JCqWKUJQn18r+CZLuYSelDwwF5OuGzNqRBOwViS7XtF4OKuzv9E5TAjXIpVB+ASDx0a8qyE43DVLkhU+d88ei1wX3rQw9UqY0Prcx/lvSlIlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ewWnkQJa; arc=fail smtp.client-ip=40.107.92.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l+LqBwRIOPUHTbXJznzIulw55rwodsUh95+rVxl+fHY2KHejLnH16pLzXfoWByF6z5puhM6wmyDcMSLIHzZoEm9DUHqmyWD2BzPUinvJI/6isvcckolzCnDzjBFXskExv50WcGcLz/wXWLUiVmNxLvOUiQW8RyA66mRMUZKqS+oTAj8XQ+6Da3WSwFPzptOnWxHrofoMJP3541X43hZ+h928P7gim90ejB4E2GM6SsOGGedn5qGAgAjcSy/RJ16n0QcabjsEpEYeJofLa6A+CowTwWqgHyir6oo9oRPdj3Fn9LxxsBnbpynfR1XcUMNuf7YQKiE0uWq2joKRLJrYbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkvV3qmVo0BFE1rcoOGEIdN0HAc/NiKY6gcnZOzcaaI=;
 b=YfstGGRpY92/BFj85ORxgb+ZgR0fpOYJDYdQ3fFPDkKuceSXraGZvXwLF8srJqU1gOJyM3IfQTWGQnaJDZoCu/Vn2xJXVw+EOfocy6ZfwlzZFkzuUBuBXUe2/LHe6YiUme4R5r2FCojXbs0uUzhinot3r3pGXv1J1FLNf4SH5JpWtME0itMzjnCEqaxWJWIWYKe35JAnfTH8wwbyxcbOT3vcPlKGoKbOTM9CwF9rVpTVQ9hs2QeSZdUJv3suSujuNQkDTVrzxWbE2wwr2Mr4PF9Ar15RBxw2yBZ9xqlU2KaJboRvOJG1hBb4ApK2EkXuzD7cOv3W4oEs1544VvQ17A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkvV3qmVo0BFE1rcoOGEIdN0HAc/NiKY6gcnZOzcaaI=;
 b=ewWnkQJaSv1BwX93Ix4hPnq9LYvBmsALOqDdtulrtnyQ8ZKLZQk3I2nPmPQzLu+OjTpDUWy+n2ED72zLVqltbF2MseEktkUFgum2BKVI9LKBMVc2CTktQRYh+lAxeYkZinIRAhAmkUq0m2OGi7HIXLp1zgvMHJJ99o7vRvJ3A5w=
Received: from DS7PR03CA0360.namprd03.prod.outlook.com (2603:10b6:8:55::33) by
 BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 21:37:37 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:8:55:cafe::91) by DS7PR03CA0360.outlook.office365.com
 (2603:10b6:8:55::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Fri,
 5 Sep 2025 21:37:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:37:37 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:37:36 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:37:34 -0700
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
Subject: [PATCH v18 17/33] fs/resctrl: Add the functionality to assign MBM events
Date: Fri, 5 Sep 2025 16:34:16 -0500
Message-ID: <25421710af9c3110ee6dfc1fa25b8f59de99454d.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|BL1PR12MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d0bf887-805a-47f9-9b8e-08ddecc46eb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t7pHlWLBRXYXLtLPT4yLBR7CksJ498AbCXFQOMwru58nwICSP6WvxAxynB7F?=
 =?us-ascii?Q?VCqaPP+r9V5spUSew7OVT5uUnsZoEjDkP1yEiRokmOEWm21lQEBvAxMN+dj/?=
 =?us-ascii?Q?PC50aP1TV32kt49rL8i05aThbkamt+qqsOAjBYxQ6YQoI4RQ9XUU0W+PLYb6?=
 =?us-ascii?Q?DbYhNzct4NzLmztK/NfDjp+6YPF6WSUOe9RPvJ+fL3bGaGfDxOYIa6ZME8RB?=
 =?us-ascii?Q?368YrA5TLYhkuLRHC5UPXJhzw/DBoeh1b9hWog6KtI0N5xZglYCZ0W3M4gV5?=
 =?us-ascii?Q?l16GVF2f7iHglVzDWE6MXnqO7McLch5pvmF1/jFVwjIsL0iJ/wM5tScUh5y7?=
 =?us-ascii?Q?HZ91X4LkSS53tMFKegLNgn1XnlphTS1nzrSKHVuY0ReTcBxgfOTJeLRlL82p?=
 =?us-ascii?Q?BDTcu67j0wuvecjiBt+bKAdDioQqmc8jSvqMruP0MxhVM4PiYXy3X62lxDh+?=
 =?us-ascii?Q?SMsX1DltZhmFIPLSAF6gaG+jWeodv2z2txoaVp1AqU+WuLEI3Gd9PLdkHyDU?=
 =?us-ascii?Q?3LkI6NAnV1s+AgnAm+dmOmAuGDdFLPiONKupevrzzJxTA3VSBlNio/HfeTPO?=
 =?us-ascii?Q?3TU6R3gls4kyQfyqG0NKzJGde7ErqjBtASUiZ8Lu3ayLBietxs89osmrcwWB?=
 =?us-ascii?Q?ODWSElGlbe+ScT5Cfy/WWWYk5e1kqR2e9hF94U7VcK2MM4raGvwJFVSd6l0B?=
 =?us-ascii?Q?8tW2pLxRWSna/rX0pHKeu4yvsMesfu+qO+dw/zuIH3psFMvrP0iO7cu8/fwR?=
 =?us-ascii?Q?boCjdLEfkK2rcN6xG5NdDGoEe2DgmhHwP1EakW9OESOHgqYnIK2I28MoXmlv?=
 =?us-ascii?Q?vkJhuB7M/3na6Ugdnf1j0qonBAEXaWmN6miIcwoqd2FMGz7AFTInLyLxW15E?=
 =?us-ascii?Q?qtJk/QJ3VVzT3ina/rDdwxbui+L40pMso1VSRj/uU6oZ6GIinwgDX/K89I7Y?=
 =?us-ascii?Q?g0A3xBwFq7YnGRu0aHV0oJW4fZDi3SUqDRLzAvpsXtkz74Eby3oZ4VoNqHhg?=
 =?us-ascii?Q?jg7jZGCpvfk5uPV9CDr7mtmD8EEYG1qIpfut5s+KJfYsm3tV6vTrsVr7oNlV?=
 =?us-ascii?Q?53olXnR8f8BcgOte+VH56zXNF6BPuoIyxmBh97sfIwgZNzUcYTNE8d5IMGj8?=
 =?us-ascii?Q?1OW7gfGOfezE3GgB4XL2ErB/UsGbTRYIOTHNJZ0zbswMk68ORAMdT4kwFosd?=
 =?us-ascii?Q?TyildcDOMJ++kJs2b5aylBbRQM3txZnThe4w/QGmBJXubSsuiFI3gHvV38dn?=
 =?us-ascii?Q?3tTZm9WA1LrCyDL6XVRaxL2+ucx9mm5ahQpMHFvcO7911pliYPgdD5uocO00?=
 =?us-ascii?Q?sXTo5CRI7ObmSIaEPVR8manyJXWw6gL0bbS1ik2sPGJ/aMCyvnSOKJsJECA0?=
 =?us-ascii?Q?UMMnsMxSvgfqR5WOgGOkJU1TccF5hnBbIP0luNzz4MovHlv0o8FzN64kW1ca?=
 =?us-ascii?Q?SUwXGF3IIvjVciVXza8Z2pJ2BVrJksZzM8h2EvuhCuRrweAE9mi+yek4ZD2E?=
 =?us-ascii?Q?xIkR2+vXnYnBA9Q=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:37:37.0876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0bf887-805a-47f9-9b8e-08ddecc46eb6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5995

When supported, "mbm_event" counter assignment mode offers "num_mbm_cntrs"
number of counters that can be assigned to RMID, event pairs and monitor
bandwidth usage as long as it is assigned.

Add the functionality to allocate and assign a counter to an RMID, event
pair in the domain. Also, add the helper rdtgroup_assign_cntrs() to assign
counters in the group.

Log the error message "Failed to allocate counter for <event> in domain
<id>" in /sys/fs/resctrl/info/last_cmd_status if all the counters are in
use. Exit on the first failure when assigning counters across all the
domains.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Minor changelog update.
     Moved all the functions from fs/resctrl/rdtgroup.c to fs/resctrl/monitor.c.
     Brought rdtgroup_assign_cntrs() in this patch from patch 28 to make compiler happy.

v16: Function renames:
     resctrl_config_cntr() -> rdtgroup_assign_cntr()
     rdtgroup_alloc_config_cntr() -> rdtgroup_alloc_assign_cntr()
     Passed struct mevt to rdtgroup_alloc_assign_cntr so it can print event name on failure.
     Minor code comment update.

v15: Updated the changelog.
     Added the check !r->mon.mbm_cntr_assignable in mbm_cntr_get() to return error.
     Removed the check to verify evt_cfg in the domain as it is not required anymore.
     https://lore.kernel.org/lkml/887bad33-7f4a-4b6d-95a7-fdfe0451f42b@intel.com/
     Return success if the counter is already assigned.
     Rename resctrl_assign_cntr_event() -> rdtgroup_assign_cntr_event().
     Removed the parameter struct rdt_resource. It can be obtained from mevt->rid.

v14: Updated the changelog little bit.
     Updated the code documentation for mbm_cntr_alloc() and  mbm_cntr_get().
     Passed struct mon_evt to resctrl_assign_cntr_event() that way to avoid
     back and forth calls to get event details.
     Updated the code documentation about the failure when counters are exhasted.
     Changed subject line to fs/resctrl.

v13: Updated changelog.
     Changed resctrl_arch_config_cntr() to return void instead of int.
     Just passing evtid is to resctrl_alloc_config_cntr() and
     resctrl_assign_cntr_event(). Event configuration value can be easily
     obtained from mon_evt list.
     Introduced new function mbm_get_mon_event() to get event configuration value.
     Added prototype descriptions to mbm_cntr_get() and mbm_cntr_alloc().
     Resolved conflicts caused by the recent FS/ARCH code restructure.
     The files monitor.c/rdtgroup.c have been split between FS and ARCH directories.

v12: Fixed typo in the subjest line.
     Replaced several counters with "num_mbm_cntrs" counters.
     Changed the check in resctrl_alloc_config_cntr() to reduce the indentation.
     Fixed the handling error on first failure.
     Added domain id and event id on failure.
     Fixed the return error override.
     Added new parameter event configuration (evt_cfg) to get the event configuration
     from user space.

v11: Patch changed again quite a bit.
     Moved the functions to monitor.c.
     Renamed rdtgroup_assign_cntr_event() to resctrl_assign_cntr_event().
     Refactored the resctrl_assign_cntr_event().
     Added functionality to exit on the first error during assignment.
     Simplified mbm_cntr_free().
     Removed the function mbm_cntr_assigned(). Will be using mbm_cntr_get() to
     figure out if the counter is assigned or not.
     Updated commit message and code comments.

v10: Patch changed completely.
     Counters are managed at the domain based on the discussion.
     https://lore.kernel.org/lkml/CALPaoCj+zWq1vkHVbXYP0znJbe6Ke3PXPWjtri5AFgD9cQDCUg@mail.gmail.com/
     Reset non-architectural MBM state.
     Commit message update.

v9: Introduced new function resctrl_config_cntr to assign the counter, update
    the bitmap and reset the architectural state.
    Taken care of error handling(freeing the counter) when assignment fails.
    Moved mbm_cntr_assigned_to_domain here as it used in this patch.
    Minor text changes.

v8: Renamed rdtgroup_assign_cntr() to rdtgroup_assign_cntr_event().
    Added the code to return the error if rdtgroup_assign_cntr_event fails.
    Moved definition of MBM_EVENT_ARRAY_INDEX to resctrl/internal.h.
    Updated typo in the comments.

v7: New patch. Moved all the FS code here.
    Merged rdtgroup_assign_cntr and rdtgroup_alloc_cntr.
    Adde new #define MBM_EVENT_ARRAY_INDEX.
---
 fs/resctrl/internal.h |   2 +
 fs/resctrl/monitor.c  | 156 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 874b59f52d13..73cad7c17a1f 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -396,6 +396,8 @@ int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of, struct seq_file *s,
 int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of, struct seq_file *s,
 				     void *v);
 
+void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 8c6e44e0e57c..3eb5a30f44fb 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -356,6 +356,55 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
 	return state ? &state[idx] : NULL;
 }
 
+/*
+ * mbm_cntr_get() - Return the counter ID for the matching @evtid and @rdtgrp.
+ *
+ * Return:
+ * Valid counter ID on success, or -ENOENT on failure.
+ */
+static int mbm_cntr_get(struct rdt_resource *r, struct rdt_mon_domain *d,
+			struct rdtgroup *rdtgrp, enum resctrl_event_id evtid)
+{
+	int cntr_id;
+
+	if (!r->mon.mbm_cntr_assignable)
+		return -ENOENT;
+
+	if (!resctrl_is_mbm_event(evtid))
+		return -ENOENT;
+
+	for (cntr_id = 0; cntr_id < r->mon.num_mbm_cntrs; cntr_id++) {
+		if (d->cntr_cfg[cntr_id].rdtgrp == rdtgrp &&
+		    d->cntr_cfg[cntr_id].evtid == evtid)
+			return cntr_id;
+	}
+
+	return -ENOENT;
+}
+
+/*
+ * mbm_cntr_alloc() - Initialize and return a new counter ID in the domain @d.
+ * Caller must ensure that the specified event is not assigned already.
+ *
+ * Return:
+ * Valid counter ID on success, or -ENOSPC on failure.
+ */
+static int mbm_cntr_alloc(struct rdt_resource *r, struct rdt_mon_domain *d,
+			  struct rdtgroup *rdtgrp, enum resctrl_event_id evtid)
+{
+	int cntr_id;
+
+	for (cntr_id = 0; cntr_id < r->mon.num_mbm_cntrs; cntr_id++) {
+		if (!d->cntr_cfg[cntr_id].rdtgrp) {
+			d->cntr_cfg[cntr_id].rdtgrp = rdtgrp;
+			d->cntr_cfg[cntr_id].evtid = evtid;
+			return cntr_id;
+		}
+	}
+
+	return -ENOSPC;
+}
+
 static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
 	int cpu = smp_processor_id();
@@ -889,6 +938,113 @@ u32 resctrl_get_mon_evt_cfg(enum resctrl_event_id evtid)
 	return mon_event_all[evtid].evt_cfg;
 }
 
+/*
+ * rdtgroup_assign_cntr() - Assign/unassign the counter ID for the event, RMID
+ * pair in the domain.
+ *
+ * Assign the counter if @assign is true else unassign the counter. Reset the
+ * associated non-architectural state.
+ */
+static void rdtgroup_assign_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+				 enum resctrl_event_id evtid, u32 rmid, u32 closid,
+				 u32 cntr_id, bool assign)
+{
+	struct mbm_state *m;
+
+	resctrl_arch_config_cntr(r, d, evtid, rmid, closid, cntr_id, assign);
+
+	m = get_mbm_state(d, closid, rmid, evtid);
+	if (m)
+		memset(m, 0, sizeof(*m));
+}
+
+/*
+ * rdtgroup_alloc_assign_cntr() - Allocate a counter ID and assign it to the event
+ * pointed to by @mevt and the resctrl group @rdtgrp within the domain @d.
+ *
+ * Return:
+ * 0 on success, < 0 on failure.
+ */
+static int rdtgroup_alloc_assign_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+				      struct rdtgroup *rdtgrp, struct mon_evt *mevt)
+{
+	int cntr_id;
+
+	/* No action required if the counter is assigned already. */
+	cntr_id = mbm_cntr_get(r, d, rdtgrp, mevt->evtid);
+	if (cntr_id >= 0)
+		return 0;
+
+	cntr_id = mbm_cntr_alloc(r, d, rdtgrp, mevt->evtid);
+	if (cntr_id < 0) {
+		rdt_last_cmd_printf("Failed to allocate counter for %s in domain %d\n",
+				    mevt->name, d->hdr.id);
+		return cntr_id;
+	}
+
+	rdtgroup_assign_cntr(r, d, mevt->evtid, rdtgrp->mon.rmid, rdtgrp->closid, cntr_id, true);
+
+	return 0;
+}
+
+/*
+ * rdtgroup_assign_cntr_event() - Assign a hardware counter for the event in
+ * @mevt to the resctrl group @rdtgrp. Assign counters to all domains if @d is
+ * NULL; otherwise, assign the counter to the specified domain @d.
+ *
+ * If all counters in a domain are already in use, rdtgroup_alloc_assign_cntr()
+ * will fail. The assignment process will abort at the first failure encountered
+ * during domain traversal, which may result in the event being only partially
+ * assigned.
+ *
+ * Return:
+ * 0 on success, < 0 on failure.
+ */
+static int rdtgroup_assign_cntr_event(struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
+				      struct mon_evt *mevt)
+{
+	struct rdt_resource *r = resctrl_arch_get_resource(mevt->rid);
+	int ret = 0;
+
+	if (!d) {
+		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+			ret = rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
+			if (ret)
+				return ret;
+		}
+	} else {
+		ret = rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
+	}
+
+	return ret;
+}
+
+/*
+ * rdtgroup_assign_cntrs() - Assign counters to MBM events. Called when
+ *			     a new group is created.
+ *
+ * Each group can accommodate two counters per domain: one for the total
+ * event and one for the local event. Assignments may fail due to the limited
+ * number of counters. However, it is not necessary to fail the group creation
+ * and thus no failure is returned. Users have the option to modify the
+ * counter assignments after the group has been created.
+ */
+void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
+{
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+
+	if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r))
+		return;
+
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
+		rdtgroup_assign_cntr_event(NULL, rdtgrp,
+					   &mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID]);
+
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
+		rdtgroup_assign_cntr_event(NULL, rdtgrp,
+					   &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
+}
+
 int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of,
 				 struct seq_file *s, void *v)
 {
-- 
2.34.1


