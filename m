Return-Path: <kvm+bounces-56930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51DEEB465DC
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:41:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63FE71894CF5
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD54301036;
	Fri,  5 Sep 2025 21:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PaxyBa5g"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93DD2F2917;
	Fri,  5 Sep 2025 21:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108276; cv=fail; b=Oa4VoB/SIehnPErFVsp8n3OAdxtHx3pOzIGoOMijmJkkfgTTF94+jCY+QcGl15AkXHpIi6GqSHpxHcVT5mZi1/xk+qG+y+TYl7YwEn3cySlUr3wdzjs34W4oQsDRo6STQo+yk9/N0rBElDuZ4y/1HxTZniJ/7FD3VF9mO9yhiWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108276; c=relaxed/simple;
	bh=8jsnqQDSHs/K8BVUJJMwVxkZ/vhGIz8iUa0aGdqLRm4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R3OeLapNHmm5R/zXDs+oXrOjG5bOH5TBNnJQVRS/FYJvhYhaZHPaDyra5dIU696wEVnoSMMl2QBs9s0yUMPo0FP3At8HsI8kjtm+6vc+pNJzkjFzehJa935FTRtbNbZrcMDqZsLbEsW2oTlxOR5HEOzZuiauKY5Jp2cOFeRH69I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PaxyBa5g; arc=fail smtp.client-ip=40.107.237.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tiD9wU0z1r1KIuH1WmXtHb7d4Yw1mfnomuPiMiDEVOB0zuPYXptEhk+ab8qj9d6QQGWTJVQFI/Y+BRB26DZko2U87mlSVlvWVeBRu1P8JCElg0dxQbbPc/SCOfERr3CJYPm/g/hR7MnS1QQjWj8zyTIjXltAidpOxL+rVh12ERpnl/J5fD4GdtpxslCYB2F0Z/ctSRHtqeTBdNJ+dShCCKvMv6XcSn5dL31hoGPwqqtMWtzedrvdMF4dI8ciPkifuWaeL3LvErkn5JOR9vIUu+rF8fMrvld22Iv3hPoASH8GKWjFLKfYKXA7WTYYB6HHg0lI5yBXozebSbwSId89JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJZh8JpuAp5t2yjD6MdorRLqTUVTjyqRx2a3IaHA4N8=;
 b=WoU7pnWaRFBkZqoWpp6Kg0CRs9Pvdk9vinF6QDtR36PQ2B2swtZZHPttBrvWmvrMEqlnRQ5KJ1XvvFiTX0C/if53XXtZa2o3VOeOZDtdHy7/TDGAwwburs8sWacoJG6J/8ROTFcQJ/7oTnaYC9jVGVCUtreWaIS9k9cgHikHpTkJ9USX4CvlUlF1ysBPXEzIunEn4RCtT4Vl0zBXBNtnhe5bRLQICkWqSHVF4iJAQye++B4mjBJXMGlC8BoyZUuIZca/3wfqjPKdRdwLDpYW7SN5mTTZAeDCbFoUHbu5F4HeAukamsOG8Oz2BrsWRxZNUbjn8BN6+pOQxkk7Iap1hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJZh8JpuAp5t2yjD6MdorRLqTUVTjyqRx2a3IaHA4N8=;
 b=PaxyBa5gxNObjYC8k9dOba1iZndAc/u8tp2y2Sssag+1gaZOpCYv2yPmdIzl6onMr0ayTlaF1LVQuZsWPlBN5dFysJLAMvgiLUXhW8WsPdN+gaV9FLyh3ada/z0kmdW3ofpCoftdItCYlRMtF3jowc0+x9nuKqGfoAjqdnxSeVM=
Received: from BY1P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::16)
 by LV8PR12MB9261.namprd12.prod.outlook.com (2603:10b6:408:1ed::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 21:37:47 +0000
Received: from CY4PEPF0000FCBF.namprd03.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::be) by BY1P220CA0021.outlook.office365.com
 (2603:10b6:a03:5c3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Fri,
 5 Sep 2025 21:37:57 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCBF.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:37:45 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:37:45 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:37:43 -0700
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
Subject: [PATCH v18 18/33] fs/resctrl: Add the functionality to unassign MBM events
Date: Fri, 5 Sep 2025 16:34:17 -0500
Message-ID: <5778d712535bd0b39d965f3e1089ce851f232e7f.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBF:EE_|LV8PR12MB9261:EE_
X-MS-Office365-Filtering-Correlation-Id: 4976e430-a914-4da8-14f2-08ddecc473f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6pvCZYY3MWZE8ZbCf4f4fId6ypU3V9uDJwQxUIfg8f+T2/CAHuvUFljuvTWW?=
 =?us-ascii?Q?h94iZh9uQr+pCxxcEqtpg5DjnjMtzLK2Bd9nOnpjuugEha9iDPEyWv06z/nh?=
 =?us-ascii?Q?CVbtxWwUnWcfPbEw9ApKnd3EDIvc1oAFvh+2GvtLkZyRAYl1/LFSGxBnM2ox?=
 =?us-ascii?Q?kD3YsstkIxEkj8+hFSPXDjSRY5Dod5X2+Y5/lh53Up5BXw1qbXdOya67F/4D?=
 =?us-ascii?Q?++drl5XDxkiw1/zzyrXJM9IvLBTvrZDQpP1QMD9kUbVbUgsVsp6BITUXUnTT?=
 =?us-ascii?Q?mPT4IxBaCyo2xA0ynT0UTHgAjDq+7iiKFdgyaYapA/+DDc4WS+/Kdxlc1dXp?=
 =?us-ascii?Q?hC/Z9GSFYUkOWQocgq/eTbRGZBmoIvH2MEseVG0xexRNCI2lvjppukogMYhZ?=
 =?us-ascii?Q?eyreERRGDCUR55U2naA7J+69gB6bK1NQkdR93LmRtX+qm9oAm1F4148Uznfr?=
 =?us-ascii?Q?tzgIVT1V3s7ojIx9axwfeSXHM6XyKJDYNz5HQ+TUmVhQczvDKVs36yzcNYBz?=
 =?us-ascii?Q?yNWrODOroJ2RpyU3SuCMCsXwJYXW9q9kNYMLhBHsyZqVs4E9XfgEonTl6Bfp?=
 =?us-ascii?Q?3jwycFM7zTi+nmw+ZykOEoPmp6uT1mMFOTpAnK3Ucvke50inbgdm0odeL5G5?=
 =?us-ascii?Q?xuUtN//8DGDelCTQFlDYeokMj4WdzC+YIX4Wmq3s3R0YYLGgAeNJH7Ldv3LJ?=
 =?us-ascii?Q?U7mWOqo6M7UvjaEvGpZ0I9xxby3j/NBJLJpD3r4UOHCwR4uVUR6dbf7VBY9g?=
 =?us-ascii?Q?gsJ5SAqxZ/1EgB1z7hLGCUpZITrFCxNPUJWgIoRiZ2v2dSD/YFM6CWADvp5o?=
 =?us-ascii?Q?9O44rSPCTgVGXXhMFR7OmfHKZCZkt2hIYNuFYDErvBIIiATX/t0PNSCO19QX?=
 =?us-ascii?Q?ZD9053cmLktk6xarBOzaU4s91RAtAGHrxQqTCSaAspjys4x3JNcT4P6Slhn2?=
 =?us-ascii?Q?CfXdzTY61gzZXal7ofk8I11Gcg9gZOO1w+bVUdZV2WJsPU+GlHjgOsrilupt?=
 =?us-ascii?Q?GTOC9PQNj0wCYEdc2pOLbvGhrSGGcUtykTyhGcAf2ZDBY/vPmPdHO/whMzxY?=
 =?us-ascii?Q?zMTGuGeM18mnRIGsHbyFnioAZmrQ2WZpv2hZCMxzTGG53C/YTKfMwqwiuM9z?=
 =?us-ascii?Q?Mxe3vL6/B+aysJxOa3SN3nEOQRYpFXAUyXxi5bOnyu6xlAEGIUvS8eXQNnYo?=
 =?us-ascii?Q?q0/NEQwk2D6PmAs2kRLGIXQiIBcVw0fooIgVu/PBBIXvh6Xp+296ysWEe/Ha?=
 =?us-ascii?Q?ko9Et9XzAaKIoHI3qpA1gCc0JL6fl/4mQviFGZrSE44QNx3oKD35wT5MR1Jh?=
 =?us-ascii?Q?KD4Rfi+YGGRvLCo1WXMowIBMnKVq8Au04PigfVzvnDqYo+zwa/2y/KEZttfW?=
 =?us-ascii?Q?+EizObTmZMPSgeQnCVtdgJa/m0yXW/C4m9Kh1bBchJpA5hWWCCJhlJ1IxDNh?=
 =?us-ascii?Q?Mr5SqrT2nZwdajjirmX5fWAjv/1Odm0juXc93HkUuHoFr5LlpNKkPqfrT+U5?=
 =?us-ascii?Q?ziqy4eqoQu1toSg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:37:45.8647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4976e430-a914-4da8-14f2-08ddecc473f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9261

The "mbm_event" counter assignment mode offers "num_mbm_cntrs" number of
counters that can be assigned to RMID, event pairs and monitor bandwidth
usage as long as it is assigned. If all the counters are in use, the kernel
logs the error message "Failed to allocate counter for <event> in domain
<id>" in /sys/fs/resctrl/info/last_cmd_status when a new assignment is
requested.

To make space for a new assignment, users must unassign an already
assigned counter and retry the assignment again.

Add the functionality to unassign and free the counters in the domain.
Also, add the helper rdtgroup_unassign_cntrs() to unassign counters in the
group.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Updated changelog.
     Moved all the functions to monitor.c.
     Brought rdtgroup_unassign_cntrs() from patch 28 to monitor.c to make compiler happy.

v16: Function rename rdtgroup_free_config_cntr() -> rdtgroup_free_unassign_cntr().
     Updated rdtgroup_free_unassign_cntr() to pass struct mon_evt to match
     rdtgroup_alloc_assign_cntr() prototype.

v15: Updated the changelog.
     Changed code in mbm_cntr_free to use the sizeof(*d->cntr_cfg)).
     Removed unnecessary return in resctrl_free_config_cntr().
     Rename resctrl_unassign_cntr_event() -> rdtgroup_unassign_cntr_event().
     Removed the parameter struct rdt_resource. It can be obtained from mevt->rid.

v14: Passing the struct mon_evt to resctrl_free_config_cntr() and removed
     the need for mbm_get_mon_event() call.
     Corrected the code documentation for mbm_cntr_free().
     Changed resctrl_free_config_cntr() and resctrl_unassign_cntr_event()
     to return void.
     Changed subject line to fs/resctrl.
     Updated the changelog.

v13: Moved mbm_cntr_free() to this patch as it is used in here first.
     Not required to pass evt_cfg to resctrl_unassign_cntr_event(). It is
     available via mbm_get_mon_event().
     Resolved conflicts caused by the recent FS/ARCH code restructure.
     The monitor.c file has now been split between the FS and ARCH directories.

v12: Updated the commit text to make bit more clear.
     Replaced several counters with "num_mbm_cntrs" counters.
     Fixed typo in the subjest line.
     Fixed the handling error on first failure.
     Added domain id and event id on failure.
     Added new parameter event configuration (evt_cfg) to provide the event from
     user space.

v11: Moved the functions to monitor.c.
     Renamed rdtgroup_unassign_cntr_event() to resctrl_unassign_cntr_event().
     Refactored the resctrl_unassign_cntr_event().
     Updated commit message and code comments.


v10: Patch changed again.
     Counters are managed at the domain based on the discussion.
     https://lore.kernel.org/lkml/CALPaoCj+zWq1vkHVbXYP0znJbe6Ke3PXPWjtri5AFgD9cQDCUg@mail.gmail.com/
     commit message update.

v9: Changes related to addition of new function resctrl_config_cntr().
    The removed rdtgroup_mbm_cntr_is_assigned() as it was introduced
    already.
    Text changes to take care comments.

v8: Renamed rdtgroup_mbm_cntr_is_assigned to mbm_cntr_assigned_to_domain
    Added return error handling in resctrl_arch_config_cntr().

v7: Merged rdtgroup_unassign_cntr and rdtgroup_free_cntr functions.
    Renamed rdtgroup_mbm_cntr_test() to rdtgroup_mbm_cntr_is_assigned().
    Reworded the commit log little bit.

v6: Removed mbm_cntr_free from this patch.
    Added counter test in all the domains and free if it is not assigned to
    any domains.

v5: Few name changes to match cntr_id.
    Changed the function names to rdtgroup_unassign_cntr
    More comments on commit log.

v4: Added domain specific unassign feature.
    Few name changes.

v3: Removed the static from the prototype of rdtgroup_unassign_abmc.
    The function is not called directly from user anymore. These
    changes are related to global assignment interface.

v2: No changes.
---
 fs/resctrl/internal.h |  2 ++
 fs/resctrl/monitor.c  | 66 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 73cad7c17a1f..c11f2751acf5 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -398,6 +398,8 @@ int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of, struct seq_fil
 
 void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp);
 
+void rdtgroup_unassign_cntrs(struct rdtgroup *rdtgrp);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 3eb5a30f44fb..c03266e36cba 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -405,6 +405,14 @@ static int mbm_cntr_alloc(struct rdt_resource *r, struct rdt_mon_domain *d,
 	return -ENOSPC;
 }
 
+/*
+ * mbm_cntr_free() - Clear the counter ID configuration details in the domain @d.
+ */
+static void mbm_cntr_free(struct rdt_mon_domain *d, int cntr_id)
+{
+	memset(&d->cntr_cfg[cntr_id], 0, sizeof(*d->cntr_cfg));
+}
+
 static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
 	int cpu = smp_processor_id();
@@ -1045,6 +1053,64 @@ void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
 					   &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
 }
 
+/*
+ * rdtgroup_free_unassign_cntr() - Unassign and reset the counter ID configuration
+ * for the event pointed to by @mevt within the domain @d and resctrl group @rdtgrp.
+ */
+static void rdtgroup_free_unassign_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+					struct rdtgroup *rdtgrp, struct mon_evt *mevt)
+{
+	int cntr_id;
+
+	cntr_id = mbm_cntr_get(r, d, rdtgrp, mevt->evtid);
+
+	/* If there is no cntr_id assigned, nothing to do */
+	if (cntr_id < 0)
+		return;
+
+	rdtgroup_assign_cntr(r, d, mevt->evtid, rdtgrp->mon.rmid, rdtgrp->closid, cntr_id, false);
+
+	mbm_cntr_free(d, cntr_id);
+}
+
+/*
+ * rdtgroup_unassign_cntr_event() - Unassign a hardware counter associated with
+ * the event structure @mevt from the domain @d and the group @rdtgrp. Unassign
+ * the counters from all the domains if @d is NULL else unassign from @d.
+ */
+static void rdtgroup_unassign_cntr_event(struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
+					 struct mon_evt *mevt)
+{
+	struct rdt_resource *r = resctrl_arch_get_resource(mevt->rid);
+
+	if (!d) {
+		list_for_each_entry(d, &r->mon_domains, hdr.list)
+			rdtgroup_free_unassign_cntr(r, d, rdtgrp, mevt);
+	} else {
+		rdtgroup_free_unassign_cntr(r, d, rdtgrp, mevt);
+	}
+}
+
+/*
+ * rdtgroup_unassign_cntrs() - Unassign the counters associated with MBM events.
+ *			       Called when a group is deleted.
+ */
+void rdtgroup_unassign_cntrs(struct rdtgroup *rdtgrp)
+{
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+
+	if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r))
+		return;
+
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
+		rdtgroup_unassign_cntr_event(NULL, rdtgrp,
+					     &mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID]);
+
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
+		rdtgroup_unassign_cntr_event(NULL, rdtgrp,
+					     &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
+}
+
 int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of,
 				 struct seq_file *s, void *v)
 {
-- 
2.34.1


