Return-Path: <kvm+bounces-56927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C54DB465D1
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF69F3A2CBB
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113532FF65D;
	Fri,  5 Sep 2025 21:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SIeBA/Iv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DC42F39CD;
	Fri,  5 Sep 2025 21:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108252; cv=fail; b=XKTYI0O5lGkhNHd0Jso2whvsCDaRXksAL927doioytrTZkZAgTDJCys4qdEUXNwNKQ6PNBK7WeDysmcJ6DuTByzCFGz+p1MgRitRsVLN+WFoFUG6f8a0WM+vDlstBCn5xth+Jxu+BuJm53eibIxOYOTmKBFtIti4wWrZ1kEO/Ac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108252; c=relaxed/simple;
	bh=6X16RiL4bHScWm0n60aWa7nYQhVf341JR6zhEIcKinY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R43Pck74S5kXzwE3rvPTxzIEv/ZEqdg6at6M9eZ+2r2rypzRVPT65xybAm8gCkgIVwZYjrrcsLInDkSNVf++2YFisNcFK/z/4Mily/Ts9sChL6hYyyrwbOUL10QQ6X0jS6fVfkDz9JmYUzh7teJzqaWejJ/xGBcHM4sxvNJ8lag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SIeBA/Iv; arc=fail smtp.client-ip=40.107.94.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KnSTbaCA10oy4ILa7cVW2gHj2wNeKhSViSHegGN1Aai3ESzPDQoNskRubrVzvKryXj3rlICGrCd2szyBZOgSLkoj+8stKW2/HXXOW7vpg6wEnaEgTxrhXSfR19RfBoSgtvhhHfTAW6MvGAUzpRd/T37rLYrO42mFVo3UFsV+w2/bhcC+44A9ZJVkQZuzB6WJJeEA8++3IUQjP9iYkBakouo6jc/RYNslaP/CqoKqVfggKdRiKDMw8Hx2BYlhAOkYIDs5J7LH3O/AWnf1VxRT/zrK0da+JOZkn2q3xMhqOnK+OUQo+yD2Jlj+HAj1io/reiV9+dAFXhqta8cj9Y1Bqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eekhFRhiRhyZKox94F0trT04GoFxXrV1Cth+TFwbIiM=;
 b=AgYBkMS0wkPNQBHyyGJIdhywk/BXYPJ7osR25HE7BnMKRQGk6Sn9cMNT5GZ/MMB7fhV6YNTjJNZDaSXWNI9Cnk04dX2Rlj0zDtstVnpuqY32jwy0tFEeG2pEYDbC1PGVfazPLX1FZDrIAQofU8OsdCNaw4czF49NTbFL/PjzGwDQn86WVh0kzsF/AtOlrf0IAgHI4u2NadYT0SYMvlNfJvNDpVojK2ory4sP1HfqOFfcASbLMDiZvLEURvCrCWeyIHlHySGfdlIyvjdO3aAG/UBFcj8Oct/R5PLQ4UxgZehIyoCVRmVkouPvqqhu7a4zIsJ4esQ8hw1anWXztlxkqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eekhFRhiRhyZKox94F0trT04GoFxXrV1Cth+TFwbIiM=;
 b=SIeBA/IvksR95nymJxPxgYCnEaO9VbQmooeDB12qD7snIteZ+1GN1QnhWOOXvy+bo8O8+F0CJxSxBYiCss/k+zHtdO3i8zumDXfglxoViRA2rBBukdwR5HPOE+R8DTvijR4eMWgaG+rTAIJck2xbrn+BdeBRzzCdd36BRu6vuMM=
Received: from DS7PR03CA0358.namprd03.prod.outlook.com (2603:10b6:8:55::7) by
 PH8PR12MB7135.namprd12.prod.outlook.com (2603:10b6:510:22c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 21:37:24 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:8:55:cafe::80) by DS7PR03CA0358.outlook.office365.com
 (2603:10b6:8:55::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.18 via Frontend Transport; Fri,
 5 Sep 2025 21:37:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:37:23 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:37:14 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:37:11 -0700
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
Subject: [PATCH v18 15/33] fs/resctrl: Introduce event configuration field in struct mon_evt
Date: Fri, 5 Sep 2025 16:34:14 -0500
Message-ID: <1ce97c42836bd64d5e1bd4631235ef06f8600313.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|PH8PR12MB7135:EE_
X-MS-Office365-Filtering-Correlation-Id: 19a3bb2e-5eea-479a-4734-08ddecc466ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3y7MBiJjEFAr33t0V6BWCQ3sNbXfhE9FZAz2NUt7kxSNg/IWA3tcSNqxDFY2?=
 =?us-ascii?Q?Ev7gpOkiKcn62RwvgsUdeaDoitABd8n7P5JLW7D5hvsWYN6uByTivjDF9Z5r?=
 =?us-ascii?Q?2+Gcq99B81SzPjzQk+fLukkTCCKW9qu5k4NAXr32hpn+njwZuoUICkvf/n6e?=
 =?us-ascii?Q?/oqgB4gHfXoSZFJWuXJLCGuC7wFtuqK7e+GPCUIzZpSvZvDZNKfxBzmHxWsz?=
 =?us-ascii?Q?75lg5bKcRaWmy6/SQfep4EOzjoN9yK5cSFQOrGdpgf1X1vRhvGipu1RHZCIx?=
 =?us-ascii?Q?F2n7Pc98GCG739lZnNj/LpNbmp8a8EdtHaXHQc6JHSUu4NGMAEfiLKMbyRg7?=
 =?us-ascii?Q?3incKlGeTbGCFLtfqUd1Ywp3qLF+NfldvK8R4ZtajO7iLylfJSbwT38D2FTu?=
 =?us-ascii?Q?rFTkWqrBtbFaXOCwPn6jV3DoqdbwIT04wgUaDBFk1+Aa/RUgBRleh61oU7CK?=
 =?us-ascii?Q?wI73AOqeWZ2nDEUuq+2/yQ1JAYQrN1Al5eCLDQRzFzWfGZUvfNAld9zvU8s8?=
 =?us-ascii?Q?R7Un09u1ngBU4AJ0vvPf/gLQm1Vmsp0k/spC4DGHGlIrvPeRL1URGvB7DilV?=
 =?us-ascii?Q?6QvB/aDRh9BmfkWA03ozQ/XAo1yoXK5LS2bhDcdm0aF01PkeXBIOFK/ERZvA?=
 =?us-ascii?Q?KOlAHAcQTJUkidvDA2pi+Na2nmiwx6wpgblyX4YtsQwSRh04NScUwlkWX4IH?=
 =?us-ascii?Q?8rP4U60oPfY58hy3MeThkAALGWaHvAFJ/e+f0mt2KsC2n9uPkaSasvwk4jen?=
 =?us-ascii?Q?YRbqlGVaYJtBeMz4Yi7xakr/WS9CSBRA/dIywsy2iYm3KdQavQiJyr9WuH8d?=
 =?us-ascii?Q?qOCGWy+shoQRsNLxeuNWUMjwc2cfIgLH4Mhl6XvUia6tx/mLn4kBRXvu0kWw?=
 =?us-ascii?Q?MeLoWDSpKRlU1OgmF+Suf/a9lCgNaeX/WlhnQ49dYzKO7nAxQ4oOx4oglOBN?=
 =?us-ascii?Q?CXhFGWFPsxfobSthGVnEIvQM8EKPWnZZKpU4lXWSKcevM+/w9ki2jFS2V/K6?=
 =?us-ascii?Q?gTQGhLk6nih9ZvIp9t8LijjPJjGOgSsEKeFECIcWGp3gE1tBcVlo1vh522ea?=
 =?us-ascii?Q?iMyGlvWRkYfMV8qYeQdXHRu9dDYCYGAPCn7gpfSHKTDm69ubhbJeYtzboxmo?=
 =?us-ascii?Q?9jhpEhgJwEBPLt7BUH9bTN9jDqXlosz5HMNIs/n7ED7FrVnJ7OWcvz+ykyS0?=
 =?us-ascii?Q?hMlCCZF0qxVsyXulMxZrEjbNQb3kefr0Ynjvqs8p/2GJwOc6QStEXLQdhmKp?=
 =?us-ascii?Q?aG16Y2s+0bdaBb2MdbS5Fjl3+qzmyVFkOtEZSFdzu0zh7Xr5fdASrfma61kg?=
 =?us-ascii?Q?R9twHoaF0JWJxtrvoa0h96FFZsyp5LBJB0ghXcWnmdY6pcG8FecbkmvPXz62?=
 =?us-ascii?Q?SqUj1Fc7Wz91Px7Hoi+XJbuc5She7SA7/b9gMGrBTfyyrDCaAD+zY0wn55uw?=
 =?us-ascii?Q?TrZF+mlNqa3eFNh+481rCpR/wGUuLPAB5rdsFsQDDCZHR40bVN1L/w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:37:23.6896
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a3bb2e-5eea-479a-4734-08ddecc466ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7135

When supported, mbm_event counter assignment mode allows the user to
configure events to track specific types of memory transactions.

Introduce the evt_cfg field in struct mon_evt to define the type of memory
transactions tracked by a monitoring event. Also add a helper function to
get the evt_cfg value.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Updated evt_cfg to use r->mon.mbm_cfg_mask.
     Removed Reviewed-by tag since the patch was modified slightly.

v16: Added Reviewed-by tag.

v15: Updated the changelog.
     Removed resctrl_set_mon_evt_cfg().
     Moved the event initialization to resctrl_mon_resource_init().

v14: This is updated patch from previous patch.
     https://lore.kernel.org/lkml/95b7f4e9d72773e8fda327fc80b429646efc3a8a.1747349530.git.babu.moger@amd.com/
     Removed mbm_mode as it is not required anymore.
     Added resctrl_get_mon_evt_cfg() and resctrl_set_mon_evt_cfg().

v13: New patch to handle different event configuration types with
     mbm_cntr_assign mode.
---
 fs/resctrl/internal.h   |  5 +++++
 fs/resctrl/monitor.c    | 10 ++++++++++
 include/linux/resctrl.h |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 35a8bad8ca75..874b59f52d13 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -56,6 +56,10 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  * @evtid:		event id
  * @rid:		resource id for this event
  * @name:		name of the event
+ * @evt_cfg:		Event configuration value that represents the
+ *			memory transactions (e.g., READS_TO_LOCAL_MEM,
+ *			READS_TO_REMOTE_MEM) being tracked by @evtid.
+ *			Only valid if @evtid is an MBM event.
  * @configurable:	true if the event is configurable
  * @enabled:		true if the event is enabled
  */
@@ -63,6 +67,7 @@ struct mon_evt {
 	enum resctrl_event_id	evtid;
 	enum resctrl_res_level	rid;
 	char			*name;
+	u32			evt_cfg;
 	bool			configurable;
 	bool			enabled;
 };
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 4185f2a4ba89..8c6e44e0e57c 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -884,6 +884,11 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
 	       mon_event_all[eventid].enabled;
 }
 
+u32 resctrl_get_mon_evt_cfg(enum resctrl_event_id evtid)
+{
+	return mon_event_all[evtid].evt_cfg;
+}
+
 int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of,
 				 struct seq_file *s, void *v)
 {
@@ -1025,6 +1030,11 @@ int resctrl_mon_resource_init(void)
 			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
 		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
 			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
+		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
+		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
+								   (READS_TO_LOCAL_MEM |
+								    READS_TO_LOCAL_S_MEM |
+								    NON_TEMP_WRITE_TO_LOCAL_MEM);
 		resctrl_file_fflags_init("num_mbm_cntrs",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 		resctrl_file_fflags_init("available_mbm_cntrs",
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index e013caba6641..87daa4ca312d 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -409,6 +409,8 @@ static inline bool resctrl_is_mbm_event(enum resctrl_event_id eventid)
 		eventid <= QOS_L3_MBM_LOCAL_EVENT_ID);
 }
 
+u32 resctrl_get_mon_evt_cfg(enum resctrl_event_id eventid);
+
 /* Iterate over all memory bandwidth events */
 #define for_each_mbm_event_id(eventid)				\
 	for (eventid = QOS_L3_MBM_TOTAL_EVENT_ID;		\
-- 
2.34.1


