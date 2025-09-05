Return-Path: <kvm+bounces-56939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 422A6B465F9
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:44:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE1FA1CC79C1
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1208303CAE;
	Fri,  5 Sep 2025 21:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="I3En5oLU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D4B2FE598;
	Fri,  5 Sep 2025 21:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108373; cv=fail; b=XFJZF6/aPChdWKa3sLRfRA/XT2KZ/U8StvmGlvzEwDNh9nMM9jJtHwiKi/gbMUS6toQ+eKD0VT/wy7Z+3mZXWMPytcAL928eWcZH5YJMwXC6ojMU+EG9tP5ZqeubyvoKrHUK8maxDB7reNnCRJqCOYI8qaD+uCMgb1ovmy+TUDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108373; c=relaxed/simple;
	bh=kGsvcT6CK+taRua6mUPqZCx1ys0lSdLI5/Rn73U+dVk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ggSzYqLHa3+fXy6zmsJSrDD2wyCij40z7yNRvLM1AKRgTPnxLv6W3N8N3k2yG1vPS3RkiQDy37I9YlGWiEQys+rLcSDJhyq97UdlSLYZVFKaPIfQG+QqfYcafV/1cLqucTIoRZVtGHQ1hWPeL+kNAkKM6TrjqfwMWPg4GEPmDNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=I3En5oLU; arc=fail smtp.client-ip=40.107.243.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jSrnhdznlYiwICCa4fqhr7ptO2ht8aYbhgqtxO03knGl/T5dcmGIp5bx/x+1/MzChPjeAmlczv80+O38S0HVccreaSxh3py647Zp72H5rUkr9Kn+9OaubsYWj4Sy36rAeaYQ70ubDaIZaEkUcF+9weT3hZ9LEsK1pkeOFv53ri5KyoJdTqRk5wGGFkPfKpXJeqXVuYYZPQwjzBWCXo/yPjA8TSU4eHIj/YsxWMqdoPAEuDCzKS2aPTZRqTPqKYxzHd4PUbKOHXvz3lkRXY34uBT9yEPll0FfTiGRby1oNRsK/+KWGlwknblLmMRHja8JH1603S7nfewHK5dykZbLQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+3V3P+COOAk2do95x8+7qP5N4YmNbUh1SRPH3ddC+tc=;
 b=CL/qC0ozECU6gppsel2Vm9k9B8k+lDxFEx8G1cWPcf2z1iQMAUDcOu0nGG/QlSvfXJv9aIBJ9c7hwGqIMFKvDrGLkrMRT7yMe6OxI+nYf1VWlKfyyxYNGfKqsDx4b1joy7Nk+PvLApZMhulv0MhMO76oaTg5t+SdVCVz5Ay+JoLXWHCI+aPQrYJ3GHZ3mVpb7OyDnHzUEJGfwdgDfhzN3Isojl1nY98/MaF9DW8u0DUMwpCkKuy81WU5qv9r/Al5qjY9G+pTRITnVddD9KRaLQfq16w4MpZHM/tp2YCKA5nXhut1LBqYHvz5Iafj2VHVwdW7aVD9341XxVb+xgi+Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3V3P+COOAk2do95x8+7qP5N4YmNbUh1SRPH3ddC+tc=;
 b=I3En5oLUJ244uTD8z5pGQEKi03Zz+G751bsb/KbX8PLptQP7GJM4qz1olwfMMf6UhSeClEiyuBLDtUeQyyqSNA0Z9I4c33J7VTG7Y4ZbW7KRrJuvxB3kLElYIG1sBoKXK25wASJzbrRewcWXlf6Rxc47/UYgZr5zDtGd3ZJCrro=
Received: from SJ0PR13CA0182.namprd13.prod.outlook.com (2603:10b6:a03:2c3::7)
 by IA1PR12MB8466.namprd12.prod.outlook.com (2603:10b6:208:44b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 21:39:19 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::10) by SJ0PR13CA0182.outlook.office365.com
 (2603:10b6:a03:2c3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.9 via Frontend Transport; Fri, 5
 Sep 2025 21:39:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:39:18 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:39:15 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:39:12 -0700
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
Subject: [PATCH v18 27/33] fs/resctrl: Auto assign counters on mkdir and clean up on group removal
Date: Fri, 5 Sep 2025 16:34:26 -0500
Message-ID: <db4240e3d815c3f193402b36723995427ec358b0.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|IA1PR12MB8466:EE_
X-MS-Office365-Filtering-Correlation-Id: 50bd927c-ace5-46c2-f9f8-08ddecc4ab43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jaO1IRGqbrXRftF6vIYI8ZNoVEzE82Q++2+NFiYpe7y7zglTtD7x/y0S2XRV?=
 =?us-ascii?Q?oRi2L3FnLhV0f9VGSFE9cwTlNrS+wb+351irST2Eq7cpP5zYAPZaIg6wPTQx?=
 =?us-ascii?Q?rPvH/fe3TXmqu5+e9xxzopc8yEsndq5ZEq2mcaRLV1EyJ23VU+JuTWBLVY/W?=
 =?us-ascii?Q?/iIdRkEdb1MLRZSPtPJzk/Bo8kJs4Ss47l2a8cAMHbFtX8Z6OOc1qAkKZz6K?=
 =?us-ascii?Q?iQSYQpQyM/0TeiKCvv583ztrAmtQ0O3Jf4O+lJgFAJEtRtJzyqdafNYZrKAm?=
 =?us-ascii?Q?asJU0AQ2ZVBuPsthXquWerySkksg4CptJ1/Bqj7fO+No6GcltNjRkI5ojAxy?=
 =?us-ascii?Q?E4niNKZJjaq/cO0805xAlzcDY3QfguFChI8l2jnAy2HlrS1MuEakZGZ917Me?=
 =?us-ascii?Q?mnrfmzUbwZ/TG2Y+E6Ry37zCiQYuHoTTKQi6n5oZVXmZMVWczYptxNJGd5pv?=
 =?us-ascii?Q?FPEWzQdu42mjzz0aa80Lob4um9NwjQsgTFTzcbje7Qe/qk7wH33zF1Hre74q?=
 =?us-ascii?Q?SvW9eK3S0H0L7CAgE+Sgi7+0T4HN/FQzkEMRZHGkvGvK5ms0DhgXpNl3GdOl?=
 =?us-ascii?Q?7dq3QWLlD12ZdYiov8Wqse1lzt904dADCC1k7Zbk5Ys/flT6ahaCPgzQwgsL?=
 =?us-ascii?Q?hp4IbuFhsn+r1vE2dhhkuG5GpULweP6SQLHxBSV9lNLUltfj2S1cbz6OAbme?=
 =?us-ascii?Q?6prNZAHmL4/6RHtr8LWT/KIqKx4WLNrf5L3nMYTgIcgoViP9V5Rz9WjY9drI?=
 =?us-ascii?Q?8UHz7n/TJ1uGsRFJzXfc2IRY72z/KYIExNCrw7xYYuNOLx2QOpgmalIJSLdz?=
 =?us-ascii?Q?jzBmed0qQOI7eIVXoLdc0049mUEbg0qlHuVUv+JDIvVKTzZABuef7//XAH1g?=
 =?us-ascii?Q?sc+H7gGU30pGDASu+I2VYh+X7Zb9yCo6U3RKDnGVu2S7cBOLIiZtsTigdCQJ?=
 =?us-ascii?Q?acFR3RBe3KxYukuEebw/VWAkq2gP6pAZhs0/B489NGjVRqUrJUdQhsFlp4Dw?=
 =?us-ascii?Q?d0If9jLrlDxwuABwRWibesg/a3xVYxXof7zm3XPJTVZkuQOrsrVa9imbhETv?=
 =?us-ascii?Q?xcbJpd1CXOAmY+d+H7fXmazMzjDYLDcJJCjSdONQvZIXaZuxIvX+D1G82gBE?=
 =?us-ascii?Q?QaYJ3hZFl4IAReZMXNYj2VUUA1/0S2s6tWRD9MiF2wz0/3beXtDBb1XZ0Ukx?=
 =?us-ascii?Q?h+CEFEp2mY+XuU2At484ba063b+AQCHngGQ6Lz2PMt6Cx8L/ZQ6n6xWYBLsj?=
 =?us-ascii?Q?9bZArz7ikvg0LKIl7uO+r0pGTo/VQPuN2OiDGDCc99tJUpg1B87RSEKHIiDU?=
 =?us-ascii?Q?ynX+VEvD9921/kio+Cjn7N0hmWSdFJT343Vc/X+/be/+7SMpCzzdK99R8b1l?=
 =?us-ascii?Q?mrbGWpEklNHEdK4I8RgX4/GR2Ulz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:39:18.6698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50bd927c-ace5-46c2-f9f8-08ddecc4ab43
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8466

Resctrl provides a user-configurable option mbm_assign_on_mkdir that
determines if a counter will automatically be assigned to an RMID, event
pair when its associated monitor group is created via mkdir.

Enable mbm_assign_on_mkdir by default to automatically assign counters to
the two default events (MBM total and MBM local) of a new monitoring group
created via mkdir. This maintains backward compatibility with original
resctrl support for these two events.

Unassign and free counters belonging to a monitoring group when the group
is deleted.

Monitor group creation does not fail if a counter cannot be assigned to one
or both events. There may be limited counters and users have the
flexibility to modify counter assignments at a later time. Log the error
message "Failed to allocate counter for <event> in domain <id>" in
/sys/fs/resctrl/info/last_cmd_status when a new monitoring group is created
but counter assignment failed.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: rdtgroup_assign_cntrs() and rdtgroup_unassign_cntrs() have been moved to
     patch 17 and 18 respectively.

v16: Updated the changelog. Thanks to Reinette.
     Moved r->mon.mbm_assign_on_mkdir initialization to resctrl_mon_resource_init().
     Minor code comment update.
     Updated  the Subject line to fs/resctrl:

v15: Updated the subject line.
     Updated changelog to add unassign part.
     Fixed the check in rdtgroup_assign_cntrs() to call assign correctly.
     Renamed resctrl_assign_cntr_event() -> rdtgroup_assign_cntr_event()
             resctrl_unassign_cntr_event() -> rdtgroup_unassign_cntr_event().

v14: Updated the changelog with changed name mbm_event.
     Update code comments with changed name mbm_event.
     Changed the code to reflect Tony's struct mon_evt changes.

v13: Changes due to calling of resctrl_assign_cntr_event() and resctrl_unassign_cntr_event().
     It only takes evtid. evt_cfg is not required anymore.
     Resolved conflicts caused by the recent FS/ARCH code restructure.
     The monitor.c/rdtgroup.c files have been split between the FS and ARCH directories.

v12: Removed mbm_cntr_reset() as it is not required while removing the group.
     Update the commit text.
     Added r->mon_capable  check in rdtgroup_assign_cntrs() and rdtgroup_unassign_cntrs.

v11: Moved mbm_cntr_reset() to monitor.c.
     Added code reset non-architectural state in mbm_cntr_reset().
     Added missing rdtgroup_unassign_cntrs() calls on failure path.

v10: Assigned the counter before exposing the event files.
    Moved the call rdtgroup_assign_cntrs() inside mkdir_rdt_prepare_rmid_alloc().
    This is called both CNTR_MON and MON group creation.
    Call mbm_cntr_reset() when unmounted to clear all the assignments.
    Taken care of few other feedback comments.

v9: Changed rdtgroup_assign_cntrs() and rdtgroup_unassign_cntrs() to return void.
    Updated couple of rdtgroup_unassign_cntrs() calls properly.
    Updated function comments.

v8: Renamed rdtgroup_assign_grp to rdtgroup_assign_cntrs.
    Renamed rdtgroup_unassign_grp to rdtgroup_unassign_cntrs.
    Fixed the problem with unassigning the child MON groups of CTRL_MON group.

v7: Reworded the commit message.
    Removed the reference of ABMC with mbm_cntr_assign.
    Renamed the function rdtgroup_assign_cntrs to rdtgroup_assign_grp.

v6: Removed the redundant comments on all the calls of
    rdtgroup_assign_cntrs. Updated the commit message.
    Dropped printing error message on every call of rdtgroup_assign_cntrs.

v5: Removed the code to enable/disable ABMC during the mount.
    That will be another patch.
    Added arch callers to get the arch specific data.
    Renamed fuctions to match the other abmc function.
    Added code comments for assignment failures.

v4: Few name changes based on the upstream discussion.
    Commit message update.

v3: This is a new patch. Patch addresses the upstream comment to enable
    ABMC feature by default if the feature is available.
---
 fs/resctrl/monitor.c  |  4 +++-
 fs/resctrl/rdtgroup.c | 22 ++++++++++++++++++++--
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index b3d33b983c3c..13af138d4b3b 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1233,7 +1233,8 @@ void rdtgroup_unassign_cntrs(struct rdtgroup *rdtgrp)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 
-	if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r))
+	if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r) ||
+	    !r->mon.mbm_assign_on_mkdir)
 		return;
 
 	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
@@ -1505,6 +1506,7 @@ int resctrl_mon_resource_init(void)
 								   (READS_TO_LOCAL_MEM |
 								    READS_TO_LOCAL_S_MEM |
 								    NON_TEMP_WRITE_TO_LOCAL_MEM);
+		r->mon.mbm_assign_on_mkdir = true;
 		resctrl_file_fflags_init("num_mbm_cntrs",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 		resctrl_file_fflags_init("available_mbm_cntrs",
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index c7ea42c2a3c2..48f98146c099 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2713,6 +2713,8 @@ static int rdt_get_tree(struct fs_context *fc)
 		if (ret < 0)
 			goto out_info;
 
+		rdtgroup_assign_cntrs(&rdtgroup_default);
+
 		ret = mkdir_mondata_all(rdtgroup_default.kn,
 					&rdtgroup_default, &kn_mondata);
 		if (ret < 0)
@@ -2751,8 +2753,10 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (resctrl_arch_mon_capable())
 		kernfs_remove(kn_mondata);
 out_mongrp:
-	if (resctrl_arch_mon_capable())
+	if (resctrl_arch_mon_capable()) {
+		rdtgroup_unassign_cntrs(&rdtgroup_default);
 		kernfs_remove(kn_mongrp);
+	}
 out_info:
 	kernfs_remove(kn_info);
 out_closid_exit:
@@ -2897,6 +2901,7 @@ static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
 
 	head = &rdtgrp->mon.crdtgrp_list;
 	list_for_each_entry_safe(sentry, stmp, head, mon.crdtgrp_list) {
+		rdtgroup_unassign_cntrs(sentry);
 		free_rmid(sentry->closid, sentry->mon.rmid);
 		list_del(&sentry->mon.crdtgrp_list);
 
@@ -2937,6 +2942,8 @@ static void rmdir_all_sub(void)
 		cpumask_or(&rdtgroup_default.cpu_mask,
 			   &rdtgroup_default.cpu_mask, &rdtgrp->cpu_mask);
 
+		rdtgroup_unassign_cntrs(rdtgrp);
+
 		free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
 
 		kernfs_remove(rdtgrp->kn);
@@ -3021,6 +3028,7 @@ static void resctrl_fs_teardown(void)
 		return;
 
 	rmdir_all_sub();
+	rdtgroup_unassign_cntrs(&rdtgroup_default);
 	mon_put_kn_priv();
 	rdt_pseudo_lock_release();
 	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
@@ -3501,9 +3509,12 @@ static int mkdir_rdt_prepare_rmid_alloc(struct rdtgroup *rdtgrp)
 	}
 	rdtgrp->mon.rmid = ret;
 
+	rdtgroup_assign_cntrs(rdtgrp);
+
 	ret = mkdir_mondata_all(rdtgrp->kn, rdtgrp, &rdtgrp->mon.mon_data_kn);
 	if (ret) {
 		rdt_last_cmd_puts("kernfs subdir error\n");
+		rdtgroup_unassign_cntrs(rdtgrp);
 		free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
 		return ret;
 	}
@@ -3513,8 +3524,10 @@ static int mkdir_rdt_prepare_rmid_alloc(struct rdtgroup *rdtgrp)
 
 static void mkdir_rdt_prepare_rmid_free(struct rdtgroup *rgrp)
 {
-	if (resctrl_arch_mon_capable())
+	if (resctrl_arch_mon_capable()) {
+		rdtgroup_unassign_cntrs(rgrp);
 		free_rmid(rgrp->closid, rgrp->mon.rmid);
+	}
 }
 
 /*
@@ -3790,6 +3803,9 @@ static int rdtgroup_rmdir_mon(struct rdtgroup *rdtgrp, cpumask_var_t tmpmask)
 	update_closid_rmid(tmpmask, NULL);
 
 	rdtgrp->flags = RDT_DELETED;
+
+	rdtgroup_unassign_cntrs(rdtgrp);
+
 	free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
 
 	/*
@@ -3837,6 +3853,8 @@ static int rdtgroup_rmdir_ctrl(struct rdtgroup *rdtgrp, cpumask_var_t tmpmask)
 	cpumask_or(tmpmask, tmpmask, &rdtgrp->cpu_mask);
 	update_closid_rmid(tmpmask, NULL);
 
+	rdtgroup_unassign_cntrs(rdtgrp);
+
 	free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
 	closid_free(rdtgrp->closid);
 
-- 
2.34.1


