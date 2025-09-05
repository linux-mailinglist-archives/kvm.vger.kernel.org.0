Return-Path: <kvm+bounces-56931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00E42B465DA
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:41:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A23825A6372
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897ED2F83DF;
	Fri,  5 Sep 2025 21:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0VQpT8VS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDDD2F83AF;
	Fri,  5 Sep 2025 21:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108302; cv=fail; b=DsDQOtnrSsEUeuJmF84pF7505RjkJL4kKnkCpODhf31zleQdqjMfMedmI2dLmKFNVi2zFF3q13D3B4en4bPiXsWYZ/hVBmWtuBocr1/iM3SOR4v1tbFWzfsPntv835bJCVUINU8WOpq5oAyMTVKISHfNFbQ+SY15yqW6SEecnJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108302; c=relaxed/simple;
	bh=FAGzvn/5Xq5aPkG25QxsHhkW1sGoqOfHwW3EqS++Kbg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h7yN6Gd3fiCoz+w+cLtI+dclIFP8ykLhfu/5/AEno+uqNjV9cpf3lWWl45jlN3SERFCSeGsqaSl3GlcTxCnfVwYKB1DMJKRWaV+U4ipgLrppsjtaGdh0nQiqXW9o4ujYHTC9mnwzFaKkXXgClVk1xTagmss52DmpAqZZQsa7YNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0VQpT8VS; arc=fail smtp.client-ip=40.107.244.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Icw8GhAnE6a3oFh6kuzZcaklFCHlsMC7StwQphUq9lmAJ1oE1YBW88yxWKYhT9O6JfgLy8yvXi2s5kttvZPqgUPczomHz1JBQQfbbfzx4KMBTGjfr4AJGZsU/iM0iTDwQKgLL1k1SyoTHcPOCO7VJLeTe3u8GH9PBFS8LJMCF0zRQ/QGOMBDVY1yEgb5ug+Yx+zMIB/bwtBFYaJNKiaXWUnIsijO/3+ogUSNVTQ/uB0MZpG0X42Ojy2nwW/UxHciqweFvqVGSbVWkqaZkSMkChieuAGAoPZMC9cjoB1CyiDwk+LahnBu6n/x7DB4iD4Ql8+J63ZE/e1ZM/5qze1tTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IG1DLL0ZR00Kt4Oy4VMdRGU5bkhwt9nTiHo0Mr3h5Qs=;
 b=janSOQlDSNmYxAw7Kq2PdqCm/ZYwPh8J1Pq1Z8p6pX72va9RLiACGpzKDO/vktImLH6yu0+69A18kkIw/55Z2usXpoh0EBXfxL7EZa51/fg+vOiy7rY6SVF6ZBWq+l33tgDZ644aw/NVJBAozJqlRhlobQkOQlB79oSFlYrZOc/BF9VjJ8YIOaGYUfvDY2pGht/ozLv8e7fhM7QOxDg5xEPbaUz+6ExToVnFGLI7aYzzpMGGDXEFCyMXwdvRczmDB76um2yV+7ST/bE5FX7sokeBFAhrfJJG50Um58W3jEH8M3lsuPRnHTHeuvrwIxAqU3+bAbW7hOYN9OWwLuzL7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IG1DLL0ZR00Kt4Oy4VMdRGU5bkhwt9nTiHo0Mr3h5Qs=;
 b=0VQpT8VS6zsrE/9y0aZbYoZzwh/DcsPCTQvzfOlk1kwNcfilc4ve12Cb0CLLUP3Eewf7DwGuIhBNEz43SOLz0WL5x7JTacBW9rsN4mR4PspHbbDvJomXPZioOB3N6A5Rqky5SplL2f16GI5I58+KHjIawAyjYVWt9/b0DuOzmu4=
Received: from DM6PR02CA0119.namprd02.prod.outlook.com (2603:10b6:5:1b4::21)
 by CH2PR12MB4150.namprd12.prod.outlook.com (2603:10b6:610:a6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 21:37:55 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:1b4:cafe::b3) by DM6PR02CA0119.outlook.office365.com
 (2603:10b6:5:1b4::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.28 via Frontend Transport; Fri,
 5 Sep 2025 21:37:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:37:54 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:37:54 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:37:52 -0700
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
Subject: [PATCH v18 19/33] fs/resctrl: Pass struct rdtgroup instead of individual members
Date: Fri, 5 Sep 2025 16:34:18 -0500
Message-ID: <6cbebfc1f5e63d3c5dcbb6751ee7ccda9f38cf4b.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|CH2PR12MB4150:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a44c625-e981-4a1e-a756-08ddecc47939
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0SjbQkGSyefk2LnuCb0Hgb1W6QPY9ZoSMImSDW6QyYytFudCqUe/sFSsF/jF?=
 =?us-ascii?Q?EcAYF13Nwx1K3LUMGtKoU/La99+tZ2S6gUaVrua+ifRj8jf8/xrt8XtOpauM?=
 =?us-ascii?Q?rTKnVYe7q+Sum+laJnM7HLviGROuy8MFgKyeAgzoYF/Ji6bsr4F2Xhe1YThN?=
 =?us-ascii?Q?AGkaTDck2r7L5e/KH+w0v6lTTgheO/n9FmpNLL4uVvoPKYuWAFXgIB5N/nG4?=
 =?us-ascii?Q?OGEO5T1pBqILAq7mGZe6agp9IUkoYsC8r97by4ebwC1w9H5Dpe16JTpLPylS?=
 =?us-ascii?Q?wzDqUqJHb3keJEnl+CYQUKtpQSjJtksGHYngt5oXCfCy3nBpeOOS9GKihiCE?=
 =?us-ascii?Q?Y+wPOlKliWslFI6m0uEjkW5azvA2/3DcN9RP3J1JXqYyn9vHmeD+Jol/3FjB?=
 =?us-ascii?Q?BftvEvHh9jR1U8hUp+iEiH5BM0TFzLR6m3O5MuNcilVDryuc5e2wcdCiQ3bF?=
 =?us-ascii?Q?0sdGIKOaakieZemXdYUDWaBdXAZXCKt6wZ2Pdk5/PtCjNSFFfjwuMK3o0w3v?=
 =?us-ascii?Q?Nmi5xw0L+QPwqqvFrHZrvhcv4ONKHB/2A5HFnN7zUmg1LHbRVqV7V4oJSagN?=
 =?us-ascii?Q?FcY+DCLpaUas9vhawGtla9FwtN/42zPWqdIgIzkbhuAm/Yv505aTHwdlVLr8?=
 =?us-ascii?Q?LqSBsykwxQkMH5AFqzCyXg+woAuar40t7I7WVdIr3YZb8gYa4kva/6w/gYjs?=
 =?us-ascii?Q?1dU8da6OLFfWo07/7Fas3L3ngsxjJ4JkFGDGeusV6189ox9ghiAAY+g3WO+r?=
 =?us-ascii?Q?1wtOKbyPlhR0WjEuEdjj1ApS+juI4FafkLqOlg5z7HbGhHzbosYLft75hs9k?=
 =?us-ascii?Q?93pi5lrQ18Yxm500Gxhk5pMQvLqiAJpzPVC+ecRgUwPOQqz8j+UVmHtLUKgs?=
 =?us-ascii?Q?3u1dZ1KX6sRgDM1xZjHxEEN9/geBdWFNjkMKGOk2Z4agORkYMtX2l27M3YOS?=
 =?us-ascii?Q?XnJ1ZCtGhGHU3yzCqLt2OnpcDl0nt8dp1HL6+vM9I8ZJRNUU3Sy7ZdRQ6G7l?=
 =?us-ascii?Q?j3phUH0SdgMYBg7McoCcC6Nr4++T6BZWJusLjzPqIKJu4xEoKF+W4mIIRfAi?=
 =?us-ascii?Q?WejxDMvMExVyswsjfKZQET2OlC/2Nv0sMzNDGlGrEP+HHaHb9+JfIYQ2E9FL?=
 =?us-ascii?Q?ap71jSXMP75S7L2pDaFVyG5WDPj4OWZwNbtXLyyW+55L5GUPx1aSgzhaKwWQ?=
 =?us-ascii?Q?YdEmF+LbdXT6c1hW2Le/1TSsihwpFVGfkOa0s87ZMcLopFPTEa+qLOgCyWQs?=
 =?us-ascii?Q?ue9qLgM+1dHQLuRngsHrYJ40R+P5J7An/E8VyG0OUSHdidkJKNoZPDs0Kcxr?=
 =?us-ascii?Q?dJmp84R5DRul47jguHL1Dof6iWR0/vHIbpiS02D+mEqemf29E1BTyK7WKnca?=
 =?us-ascii?Q?LhkH0cfW/Wo3RGL+xhKSkA13q4uWywSdN1KMY9svEso51/GoDbuS4DulbEJs?=
 =?us-ascii?Q?63eazYfS2IRqflNA61AyjVX0miJj8SSx2g8oL9VA4I7Pls3/O/VoATtMgR0j?=
 =?us-ascii?Q?C6BQngNf9HR2kNibw8co6SWYzsdhvthuUzTz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:37:54.7232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a44c625-e981-4a1e-a756-08ddecc47939
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4150

Reading monitoring data for a monitoring group requires both the RMID and
CLOSID. The RMID and CLOSID are members of struct rdtgroup but passed
separately to several functions involved in retrieving event data.

When "mbm_event" counter assignment mode is enabled, a counter ID is
required to read event data. The counter ID is obtained through
mbm_cntr_get(), which expects a struct rdtgroup pointer.

Provide a pointer to the struct rdtgroup as parameter to functions involved
in retrieving event data to simplify access to RMID, CLOSID, and counter
ID.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: No changes.

v17: Added Reviewed-by.

v16: Minor code comment update.

v15: Rephrased the changelog. Thanks to Reinette.

v14: Few text update to commit log.

v13: New patch to pass the entire struct rdtgroup to __mon_event_count(),
     mbm_update(), and related functions.
---
 fs/resctrl/monitor.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index c03266e36cba..85187273d562 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -413,9 +413,11 @@ static void mbm_cntr_free(struct rdt_mon_domain *d, int cntr_id)
 	memset(&d->cntr_cfg[cntr_id], 0, sizeof(*d->cntr_cfg));
 }
 
-static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
+static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 {
 	int cpu = smp_processor_id();
+	u32 closid = rdtgrp->closid;
+	u32 rmid = rdtgrp->mon.rmid;
 	struct rdt_mon_domain *d;
 	struct cacheinfo *ci;
 	struct mbm_state *m;
@@ -477,8 +479,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 /*
  * mbm_bw_count() - Update bw count from values previously read by
  *		    __mon_event_count().
- * @closid:	The closid used to identify the cached mbm_state.
- * @rmid:	The rmid used to identify the cached mbm_state.
+ * @rdtgrp:	resctrl group associated with the CLOSID and RMID to identify
+ *		the cached mbm_state.
  * @rr:		The struct rmid_read populated by __mon_event_count().
  *
  * Supporting function to calculate the memory bandwidth
@@ -486,9 +488,11 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
  * __mon_event_count() is compared with the chunks value from the previous
  * invocation. This must be called once per second to maintain values in MBps.
  */
-static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
+static void mbm_bw_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 {
 	u64 cur_bw, bytes, cur_bytes;
+	u32 closid = rdtgrp->closid;
+	u32 rmid = rdtgrp->mon.rmid;
 	struct mbm_state *m;
 
 	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
@@ -517,7 +521,7 @@ void mon_event_count(void *info)
 
 	rdtgrp = rr->rgrp;
 
-	ret = __mon_event_count(rdtgrp->closid, rdtgrp->mon.rmid, rr);
+	ret = __mon_event_count(rdtgrp, rr);
 
 	/*
 	 * For Ctrl groups read data from child monitor groups and
@@ -528,8 +532,7 @@ void mon_event_count(void *info)
 
 	if (rdtgrp->type == RDTCTRL_GROUP) {
 		list_for_each_entry(entry, head, mon.crdtgrp_list) {
-			if (__mon_event_count(entry->closid, entry->mon.rmid,
-					      rr) == 0)
+			if (__mon_event_count(entry, rr) == 0)
 				ret = 0;
 		}
 	}
@@ -660,7 +663,7 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 }
 
 static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
-				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
+				 struct rdtgroup *rdtgrp, enum resctrl_event_id evtid)
 {
 	struct rmid_read rr = {0};
 
@@ -674,30 +677,30 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 		return;
 	}
 
-	__mon_event_count(closid, rmid, &rr);
+	__mon_event_count(rdtgrp, &rr);
 
 	/*
 	 * If the software controller is enabled, compute the
 	 * bandwidth for this event id.
 	 */
 	if (is_mba_sc(NULL))
-		mbm_bw_count(closid, rmid, &rr);
+		mbm_bw_count(rdtgrp, &rr);
 
 	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
 }
 
 static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
-		       u32 closid, u32 rmid)
+		       struct rdtgroup *rdtgrp)
 {
 	/*
 	 * This is protected from concurrent reads from user as both
 	 * the user and overflow handler hold the global mutex.
 	 */
 	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
+		mbm_update_one_event(r, d, rdtgrp, QOS_L3_MBM_TOTAL_EVENT_ID);
 
 	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
+		mbm_update_one_event(r, d, rdtgrp, QOS_L3_MBM_LOCAL_EVENT_ID);
 }
 
 /*
@@ -770,11 +773,11 @@ void mbm_handle_overflow(struct work_struct *work)
 	d = container_of(work, struct rdt_mon_domain, mbm_over.work);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
-		mbm_update(r, d, prgrp->closid, prgrp->mon.rmid);
+		mbm_update(r, d, prgrp);
 
 		head = &prgrp->mon.crdtgrp_list;
 		list_for_each_entry(crgrp, head, mon.crdtgrp_list)
-			mbm_update(r, d, crgrp->closid, crgrp->mon.rmid);
+			mbm_update(r, d, crgrp);
 
 		if (is_mba_sc(NULL))
 			update_mba_bw(prgrp, d);
-- 
2.34.1


