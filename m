Return-Path: <kvm+bounces-56935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB3E8B465EA
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:43:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4941B1D21104
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1236C2F49E0;
	Fri,  5 Sep 2025 21:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="294dTx3p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C432F3C3A;
	Fri,  5 Sep 2025 21:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108327; cv=fail; b=rIwspFP4eEAEIcEELWLOlXJP7XXjhtgGTOnYOE9+RLsteUygMlf0bbJRsFYtidiBRZlozNydZpI3nH7s+mkNoPbMMoE63NtEYhgbj9tvrkl1FVMTvMOdYxGeAeQIZXd60ZmhyGlijmknxuUGss3FaFzQyN7qfX0DBbsut1WTTyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108327; c=relaxed/simple;
	bh=/I4o+dxpcX7Bf9XobPlB4aTyyblzsTJChDAGbIrVixg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aOqfwCkt6d7It+ZggVrOJboX71m5kS8iBcvGiR4mhLMU63woTjSX5wWXfASdYTVV6/G4cAdfXyuzYiNfP3SRa80AF/Q5mMocTYIhmFVaopJRXv9HoeUBfxwaFYsjwODcXqSy6224gMxR4+CN76nBT0MXrPeAGP68/uvoNNuyvt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=294dTx3p; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yyXRDOHH0qhjqFIwkSHwwCuuwpk6VjoR4Noc3pGBizkRDoGhjM0eknTwvei3o6Wpc2fphL+TCstx3XjTBCyoiLUwHNizBSNyywfUFtX2AdoV4CTTySyyuhuNtjGWv1ilaNjpZwz2lvlBjqu91VFWGp67xaRjRvrMUvYvFDIRIRu30ZCdvllfyHCFlQ9h+5KiDfvV11MegvIwYJ9o3uRsEIdFz5xOAAouiWc2NazhgiC994c0vzx9oeDu0horq4YJUVhucxadusA2d4ZXv9Eu1/O4kIxRK4oexAg2bC7y9LaOZ6yqADybV8tbr5smmfsJkhxuc0aDE12zxzZnAtLr/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78op9oCiskB1eubSC4GnoQp6MOZeW9tBPEJ66cAAymo=;
 b=BpumAhtb298aSVdUGz2PkL4m9UAV6zg8oHYt1usvMC/5qtgX6Lx0MOaEm0jpKBogkCcUKXL+0AqoowvttCIuszAjHAhqcClVE3WOd0hj1NTG3bqdbuBF4DTVEf7aM0PjhLuh0Yl4+eKFuD8tf/J952StBjqpSlaaVQB5n/UZan/4Xx3DMBVbtiKlewg3v0mYBZlbzKs3iy1lHtmcqvWr6X4OqnflaPaHYRLsaI+6dqk5BKNTaU+QoEqUyarsf5FhL8AkufFnf3hxCpak/auIlAl4B5Xgb4XGc5hDcYBE514SKlELQXdPRG/y0oIs8OUstJ0LH59g8HYPAp1e81YEIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78op9oCiskB1eubSC4GnoQp6MOZeW9tBPEJ66cAAymo=;
 b=294dTx3p7Xj0EKd98gqe6wCmUVdkRcCoKvfFb+ZR0G4pMJ2NCHVJ0hqGxPS51dTGMgIjPJOT/FjocSDMfeACc+2AVG4cH+OHVFYGaN9f/7p4R0X1vR5VRBJqHZDqLtkXHTXrmbSj/CBKiIDlIpIUPbKRNbTXc54SPdHmOQJW6ws=
Received: from SJ0PR13CA0025.namprd13.prod.outlook.com (2603:10b6:a03:2c0::30)
 by SA1PR12MB9515.namprd12.prod.outlook.com (2603:10b6:806:45a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 21:38:40 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::f6) by SJ0PR13CA0025.outlook.office365.com
 (2603:10b6:a03:2c0::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.10 via Frontend Transport; Fri,
 5 Sep 2025 21:38:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:38:40 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:38:39 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:38:37 -0700
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
Subject: [PATCH v18 23/33] fs/resctrl: Support counter read/reset with mbm_event assignment mode
Date: Fri, 5 Sep 2025 16:34:22 -0500
Message-ID: <7dc53c86f6b75c8cc711e97c52c16de2fcd7869b.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|SA1PR12MB9515:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e41a3f5-45fc-4f99-db50-08ddecc49458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|7416014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mM53N7L4rZKXPeAKVHDP+bGdMMKn9CDRIA40usu9kGqC9LujSwrp/lidk4bE?=
 =?us-ascii?Q?r9nFfBeFa5EEzt/VqxWTtJA5Db22jZjmopNR5LfM6Z4M9jSFw3y78yqYaLVX?=
 =?us-ascii?Q?rJ3TzPySZEEVgHR1+sZSds6EHcJLGpmipJSKe6xHkeeVV3OBWByrtP0vU6yI?=
 =?us-ascii?Q?LHG55ebIzetovOC4v21o9+QTQpqRapiZl6jb1ixRIn983+Ysw2HtmLBeLJZr?=
 =?us-ascii?Q?IF+9PJXvSyKKFf6LflGJQlGPcISI/LWohe/wQAJW7p83nBhooR1azCOfMlP7?=
 =?us-ascii?Q?xTh/RTCiBPAKdnAuchV3WztlLFR2/gtF270Pr5la6TusMzKHykqiigefwGRm?=
 =?us-ascii?Q?JmkIH4hHxIFsfwyduPTBVGiQmFSULzgzolWr+6RiJ+aoyOYsUdM6Cap3Unrh?=
 =?us-ascii?Q?5+Li6CGsIHDL0ZTpa00QJlG+0vvTuemRaeOeApjGZmQVprXJrCAwEpCtohwK?=
 =?us-ascii?Q?xKb7kXDVutD5oDfk/DaH2lgqOsdN5ufMivOskUUJl7dPu0r9ruSMVGG0XG77?=
 =?us-ascii?Q?e6c4gp1d6rsPwwzxNc/W0l1ruZCyvEzk8PKm98XNj2pqM7XnwuajMTcHYTpU?=
 =?us-ascii?Q?vYaiDFKo/gV79Q9ezhmoE4HqAqeQ2hWKgvBl8GBF3haewbHB4ff/xXszfFBp?=
 =?us-ascii?Q?U/MJduo6hj6HNtsOBiB/LsFe8z2c7gPueRr+wFE6y4itAdXirvGPl4cc/PF4?=
 =?us-ascii?Q?/wgdOYB15evElDPd9QUI7/joeIp9COgrkNpZOPTurGRkgy9N5djPYoedKmGh?=
 =?us-ascii?Q?QTZ1RSP8zdFRMXmvdWDUneEWRhAaKjFzr2S6oxXXOMCNBpjXhMvMR6RQGEbo?=
 =?us-ascii?Q?Go3/ZtJx2Ux1Z9wfvCqLP+dlds1a/z0nXMJ9WtsD3UnIx3/7VuI6NNfo1CqV?=
 =?us-ascii?Q?pYhzj3F/P3NX8ptMIARNayvzn3NBWUwAPr3/7s6siDMi+vOMDXWAd2lKTon+?=
 =?us-ascii?Q?WIDz+fSMcuvYRsP35N/Mhc4CksEOvxS8c+Hzp7mA+wqivPYD1+Ms4e460o+O?=
 =?us-ascii?Q?wZdsgdOaPXSZOpVGInC/RE8h5ydiYNcGZgpH7ggF7S0CFv5xhRo7k7Ly6WXb?=
 =?us-ascii?Q?29l9XAniyTTUfcXM2RIIVvLhLEcTzSUZtgvqBMJupGuEnJccMb/xkA2z33pR?=
 =?us-ascii?Q?mgbIsggWC4FCe5rXxMUsLMzmwta2D/uGTtfUq0VTHfU+5dsCl+9JkVRlUumw?=
 =?us-ascii?Q?51R3MTgj5TamMRj4vHXRNacwqFQ9rbPE/fyOCVCxXtzodGt++Oaxd9YhnDn3?=
 =?us-ascii?Q?a20svkXc4P7G8HYIRs5CmuI6fupVIggtk1B0kf4zEPTHEnWBgwfIiRGq/tkW?=
 =?us-ascii?Q?O7j+OhylO7IpsTllaJQgiDnB5Zcji4y+6UWMiD2ECOphu7t+BefY8L0djT9o?=
 =?us-ascii?Q?52d84QFsWVc/ZZ1yHFidwunJQ9PBPz3z9Tj4LwIrxKMbzDXE/Cu/hgXZDzRe?=
 =?us-ascii?Q?CpQFD5palCoizeLRAitxP/fbA8/jmQNlYA/NJLL0S85FdMAxT6ujGg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(7416014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:38:40.2192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e41a3f5-45fc-4f99-db50-08ddecc49458
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9515

When "mbm_event" counter assignment mode is enabled, the architecture
requires a counter ID to read the event data.

Introduce an is_mbm_cntr field in struct rmid_read to indicate whether
counter assignment mode is in use.

Update the logic to call resctrl_arch_cntr_read() and
resctrl_arch_reset_cntr() when the assignment mode is active. Report
'Unassigned' in case the user attempts to read an event without assigning
a hardware counter.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Updated the changelog.
     Removed duplicate resctrl_arch_mbm_cntr_assign_enabled() check.
     mbm_cntr_get() need not be static anymore.

v16: Squashed two patches here.
     https://lore.kernel.org/lkml/df215f02db88cad714755cd5275f20cf0ee4ae26.1752013061.git.babu.moger@amd.com/
     https://lore.kernel.org/lkml/296c435e9bf63fc5031114cced00fbb4837ad327.1752013061.git.babu.moger@amd.com/
     Changed is_cntr field in struct rmid_read to is_mbm_cntr.
     Fixed the memory leak with arch_mon_ctx.
     Updated the resctrl.rst user doc.
     Updated the changelog.
     Report Unassigned only if none of the events in CTRL_MON and MON are assigned.

v15: New patch to add is_cntr in rmid_read as discussed in
     https://lore.kernel.org/lkml/b4b14670-9cb0-4f65-abd5-39db996e8da9@intel.com/
---
 Documentation/filesystems/resctrl.rst |  6 ++++
 fs/resctrl/ctrlmondata.c              | 22 ++++++++++---
 fs/resctrl/internal.h                 |  3 ++
 fs/resctrl/monitor.c                  | 47 ++++++++++++++++++++-------
 4 files changed, 62 insertions(+), 16 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 446736dbd97f..4c24c5f3f4c1 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -434,6 +434,12 @@ When monitoring is enabled all MON groups will also contain:
 	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
 	where "YY" is the node number.
 
+	When the 'mbm_event' counter assignment mode is enabled, reading
+	an MBM event of a MON group returns 'Unassigned' if no hardware
+	counter is assigned to it. For CTRL_MON groups, 'Unassigned' is
+	returned if the MBM event does not have an assigned counter in the
+	CTRL_MON group nor in any of its associated MON groups.
+
 "mon_hw_id":
 	Available only with debug option. The identifier used by hardware
 	for the monitor group. On x86 this is the RMID.
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index ad7ffc6acf13..31787ce6ec91 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -563,10 +563,15 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	rr->r = r;
 	rr->d = d;
 	rr->first = first;
-	rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evtid);
-	if (IS_ERR(rr->arch_mon_ctx)) {
-		rr->err = -EINVAL;
-		return;
+	if (resctrl_arch_mbm_cntr_assign_enabled(r) &&
+	    resctrl_is_mbm_event(evtid)) {
+		rr->is_mbm_cntr = true;
+	} else {
+		rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evtid);
+		if (IS_ERR(rr->arch_mon_ctx)) {
+			rr->err = -EINVAL;
+			return;
+		}
 	}
 
 	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
@@ -582,7 +587,8 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
-	resctrl_arch_mon_ctx_free(r, evtid, rr->arch_mon_ctx);
+	if (rr->arch_mon_ctx)
+		resctrl_arch_mon_ctx_free(r, evtid, rr->arch_mon_ctx);
 }
 
 int rdtgroup_mondata_show(struct seq_file *m, void *arg)
@@ -653,10 +659,16 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 
 checkresult:
 
+	/*
+	 * -ENOENT is a special case, set only when "mbm_event" counter assignment
+	 * mode is enabled and no counter has been assigned.
+	 */
 	if (rr.err == -EIO)
 		seq_puts(m, "Error\n");
 	else if (rr.err == -EINVAL)
 		seq_puts(m, "Unavailable\n");
+	else if (rr.err == -ENOENT)
+		seq_puts(m, "Unassigned\n");
 	else
 		seq_printf(m, "%llu\n", rr.val);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index c11f2751acf5..88e1a800417d 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -110,6 +110,8 @@ struct mon_data {
  *	   domains in @r sharing L3 @ci.id
  * @evtid: Which monitor event to read.
  * @first: Initialize MBM counter when true.
+ * @is_mbm_cntr: true if "mbm_event" counter assignment mode is enabled and it
+ *	   is an MBM event.
  * @ci_id: Cacheinfo id for L3. Only set when @d is NULL. Used when summing domains.
  * @err:   Error encountered when reading counter.
  * @val:   Returned value of event counter. If @rgrp is a parent resource group,
@@ -124,6 +126,7 @@ struct rmid_read {
 	struct rdt_mon_domain	*d;
 	enum resctrl_event_id	evtid;
 	bool			first;
+	bool			is_mbm_cntr;
 	unsigned int		ci_id;
 	int			err;
 	u64			val;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 85187273d562..0a9d257e27a2 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -419,13 +419,25 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	u32 closid = rdtgrp->closid;
 	u32 rmid = rdtgrp->mon.rmid;
 	struct rdt_mon_domain *d;
+	int cntr_id = -ENOENT;
 	struct cacheinfo *ci;
 	struct mbm_state *m;
 	int err, ret;
 	u64 tval = 0;
 
+	if (rr->is_mbm_cntr) {
+		cntr_id = mbm_cntr_get(rr->r, rr->d, rdtgrp, rr->evtid);
+		if (cntr_id < 0) {
+			rr->err = -ENOENT;
+			return -EINVAL;
+		}
+	}
+
 	if (rr->first) {
-		resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
+		if (rr->is_mbm_cntr)
+			resctrl_arch_reset_cntr(rr->r, rr->d, closid, rmid, cntr_id, rr->evtid);
+		else
+			resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
 		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
 		if (m)
 			memset(m, 0, sizeof(struct mbm_state));
@@ -436,8 +448,12 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 		/* Reading a single domain, must be on a CPU in that domain. */
 		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
 			return -EINVAL;
-		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
-						 rr->evtid, &tval, rr->arch_mon_ctx);
+		if (rr->is_mbm_cntr)
+			rr->err = resctrl_arch_cntr_read(rr->r, rr->d, closid, rmid, cntr_id,
+							 rr->evtid, &tval);
+		else
+			rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
+							 rr->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
 
@@ -462,8 +478,12 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
 		if (d->ci_id != rr->ci_id)
 			continue;
-		err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
-					     rr->evtid, &tval, rr->arch_mon_ctx);
+		if (rr->is_mbm_cntr)
+			err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
+						     rr->evtid, &tval);
+		else
+			err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
+						     rr->evtid, &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -670,11 +690,15 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 	rr.r = r;
 	rr.d = d;
 	rr.evtid = evtid;
-	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
-	if (IS_ERR(rr.arch_mon_ctx)) {
-		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-				    PTR_ERR(rr.arch_mon_ctx));
-		return;
+	if (resctrl_arch_mbm_cntr_assign_enabled(r)) {
+		rr.is_mbm_cntr = true;
+	} else {
+		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
+		if (IS_ERR(rr.arch_mon_ctx)) {
+			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
+					    PTR_ERR(rr.arch_mon_ctx));
+			return;
+		}
 	}
 
 	__mon_event_count(rdtgrp, &rr);
@@ -686,7 +710,8 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 	if (is_mba_sc(NULL))
 		mbm_bw_count(rdtgrp, &rr);
 
-	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+	if (rr.arch_mon_ctx)
+		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
 }
 
 static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
-- 
2.34.1


