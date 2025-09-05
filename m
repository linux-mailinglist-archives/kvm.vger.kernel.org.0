Return-Path: <kvm+bounces-56938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B714B465F1
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:43:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 929E53B4347
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7EC92FE060;
	Fri,  5 Sep 2025 21:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CC/o7HVp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E32E2F4A01;
	Fri,  5 Sep 2025 21:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108364; cv=fail; b=oDF9csS5tITBaPLwS4pN+naK4jOOWrnsm5bGZe0Xm9OzEihz6Q+/Vy/XZDEL5WWvmPfdwsHbIFmvORwV9lGA0h766a8tEzVkzf+3F2PST4jvLhQkHrWNSLwBlmOMnRU/tTll+GWVZyG9bEuTLvSFCmTWzCuRk6fBoMONjD9ciQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108364; c=relaxed/simple;
	bh=OJocdRGPhxtwDIPwL/3Gy/PRBtujHX+ulsjauVHAKhA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMN36PSc8ylDmBqpENZT9CZ0b4LNdN+j+hbUUF0PuL9YhDQ+1fHjgtTmhSqNbzRbrAQdnRXkPgLdxI1lSLHSYLVUxmUy+rmmNjBfDM2OWWgq3ZZEMqrv3oFO7T7ztMYOwWXr7n0FtesEytT1afCh8Uzm97HGNfPV6TR8GkSC/q0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CC/o7HVp; arc=fail smtp.client-ip=40.107.244.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o+j3tt9HG/q80LMKZ7F13FZNhdFiOzblVqf0AuxGqhz6zS0WsJrIRoCdy+jbDJE31Z2Z5IKaEUAzxTTd5NphcWzOr/9rtzfwySQy/XZTzTWAglc1KW6gf9JvzxJup8243xM+jIsqmhewfd27umHyhtZK+rMcA/JZxwpycIatCvjZc5l/6qZBah0rGIBNfT8L0KHjhn4wnawbqTqVjkspKeSimzaocqCIEHRRBAkVKzZfc6IVbVJRcpICCMp23CjCoOvRKtaobltQxAeZbk9693z4sVDVDgJcJ+wdyybyGifNPpz3h27rfX5fAmDZhlBq7nMH9+BbiaBIrCfG7jZ5Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RbCU+jZKka7LSev8KfsQT4/cfs2p/jI4boFzMDnXCb4=;
 b=esPpr2+QRFjZvbX5xNdISlcVZKAd/n24YjeuHchcU2UOqKGfGmMl/IhtWciNU4hbBq6kod4yX9I8gfqfTjZDuBLO04vq91gf7yTgag5sqGqgAqX3pgnJLsPbp/LJ0pHfuzAos2lSEVxmkjg9D1F712ATmjSKl5TIvp5WlPxwcq7gTCFOaKYoMnJEog7kPlGDmH/KLlTD/G/FyHXPWFoWC5FD7eSeJ+qZzvg78tpAHgkPPGJJ7TMZwRTI4NfPG+SqxmFOaOm7fBecoLj5bLa8vF7RFs09hsnIdwf6aP0j3JfUnNvJG0ebHjaeC8uUd13RbNVhwTCg9GxgiXN21gN69A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbCU+jZKka7LSev8KfsQT4/cfs2p/jI4boFzMDnXCb4=;
 b=CC/o7HVpXZmvl4KSR+XKDcto/BCABwP7bSLy1N2Z79A8QC/LonOmPQ43Duo5KB4gB3Fh0hzeYQDKcOY/FfWWnZtjxcKH/OUnzx06AMCZjdi+6Xzy3ZzIWcabz6kYNrr+J10sZgk5tH/DN12vd3xb9W8F3/0dDdWp1rb4KyEmPgg=
Received: from DM6PR02CA0123.namprd02.prod.outlook.com (2603:10b6:5:1b4::25)
 by DM3PR12MB9327.namprd12.prod.outlook.com (2603:10b6:0:42::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 21:39:15 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:1b4:cafe::7b) by DM6PR02CA0123.outlook.office365.com
 (2603:10b6:5:1b4::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Fri,
 5 Sep 2025 21:38:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:39:15 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:39:06 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:39:03 -0700
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
Subject: [PATCH v18 26/33] fs/resctrl: Introduce mbm_assign_on_mkdir to enable assignments on mkdir
Date: Fri, 5 Sep 2025 16:34:25 -0500
Message-ID: <3b73498a18ddd94b0c6ab5568a23ec42b62af52a.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|DM3PR12MB9327:EE_
X-MS-Office365-Filtering-Correlation-Id: e1cf95f7-1487-408a-7f90-08ddecc4a951
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0QcrdXzW3jbiIVdbsNKL9INeXuPeHmK//tgnU9RRFdk0B96+SdRRtzKnrzGU?=
 =?us-ascii?Q?ZOHh00GaGQj2XXwPJ7BSnl+f3enYQB31ruXKVyTLehvKjbIdcajvwuf/RY3q?=
 =?us-ascii?Q?yWADDoZBv4PHSSXiYTqxJwU3WHOr7waQOvD0S5xKkUWHuvDiDYVEjUatHhRL?=
 =?us-ascii?Q?zwjbolPf5+RWYWNLKO3MMw8qF0NdQlDqcPczmznmJaBs1bmxZfcG0Vc3moJs?=
 =?us-ascii?Q?pXvXY9CECGm1pH47fMuBN57DJhfOgD3YQ0moAB+D1F/4V3C7SgDJ6CKn8MDK?=
 =?us-ascii?Q?cMiruqIo9B9Qb/v0QkrEcJTyNIixFo9SZu7vqESjpFC6K7uC0vswUS6KQ65d?=
 =?us-ascii?Q?8sj9/0g0nl91TolGpzOB5uqNk1Q9V1q5dvVBEijdLxEzxB9d0h26xNhrfHys?=
 =?us-ascii?Q?FiUbXmGh2npk9HNSSst1euV7SsU0ChOYrvhFHqEm9duhpYcRH+N2Dp2ph9Ll?=
 =?us-ascii?Q?MzrRaUuZUcXInNNDZK43LqRfovZBL8zjYzZjuJTgyuTSqr2ZBlzyb1YCrUIY?=
 =?us-ascii?Q?J6zrYchk05XZ+fk4FDyJdJwzeIJRJ3lCHbBd9dSUKlJjJWptdISD8SNJiqLq?=
 =?us-ascii?Q?eRGRoOHl3wb6rQ0vsIWagSGQN+PFqqqkNXThk5bXR8OCUsAzBJsGYxdj634i?=
 =?us-ascii?Q?4Qrr3v0gMb28QXArEoZDemoiLpSjCuajmQSO77tCzoH+nZvC4DBPzcCZZXVx?=
 =?us-ascii?Q?Qun5AxcEgkBIE2jp3lEn8l6vZUFwBf0UYh8Ao0jKe6xJ/FgyOIHsxiM368nC?=
 =?us-ascii?Q?UAsLJQ0YwMqAvF/KjwaaxJaduEZlKktQSSXrj3ltLghvlg1ht46vf/E1A/4B?=
 =?us-ascii?Q?NraCzywA6epxPXNkkoDOLXvZlARor3VdAEOJTdej28soZf1RqVidBOSEA/1m?=
 =?us-ascii?Q?NpoOegN12wV5m5F02PVvaSifWYxfNRYhW37rI2DZ+ixLx81zCMX0YPZyG5lr?=
 =?us-ascii?Q?TIXqzdleMZzXS2iyWSqpaqVkL0PCNebDcHt+mOPS/sK1nOA9z/cAfEpbtmMS?=
 =?us-ascii?Q?Z9U6UFIcxH8IZg7OXEEAd2qr9AIwDLqdL5rVADMiM4ro3isdUh7e2Bxlw9gj?=
 =?us-ascii?Q?y2gAHygaHz7tSjsiCUuCcdwsvyz2UY6n245OCI/Xh+/svxF1lpg7//E6yVJk?=
 =?us-ascii?Q?HeMrYyifPVM3RuPj3w+hawWEXB9tCmBbDU1iOOvF+n5VbAEjGC5KgHlqc/Ud?=
 =?us-ascii?Q?wZYuuUbuFbHh85+lRza53paAmsQtuy6UGDNvscmL6vJCY2EA1/l8PhedRr+Z?=
 =?us-ascii?Q?gDMPSXFEysLgi0VJLNrN/eoBuysrvR32FjAwScEAtUbx00JHDVOmPFJXaf/a?=
 =?us-ascii?Q?JJABQ1gZau6OvpWEMt2pnzi60UVgQdBPRrxKC+tXCaddSddIwMxACWkasoz2?=
 =?us-ascii?Q?c1DHUw/fAt+whk/aZi4/cMOftJPvolwjbnT/YFylO789RjlKG7ANlSNrciIA?=
 =?us-ascii?Q?oHlEycfyZ1ea+8QCS5zIfY2ouhXhQYY/EUssBrnJERNrCnxHa456oyonjYVM?=
 =?us-ascii?Q?jiA2J7EJKJxIhkX+d21O+JZkqE57p/Bps8i6vI62XMj0/5UE0O8WBQ5K+w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:39:15.4098
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1cf95f7-1487-408a-7f90-08ddecc4a951
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9327

The "mbm_event" counter assignment mode allows users to assign a hardware
counter to an RMID, event pair and monitor the bandwidth as long as it is
assigned.

Introduce a user-configurable option that determines if a counter will
automatically be assigned to an RMID, event pair when its associated
monitor group is created via mkdir. Accessible when "mbm_event" counter
assignment mode is enabled.

Suggested-by: Peter Newman <peternewman@google.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Mismatched quote fix in changelog.
     Added Reviewed-by tag.
     Updated the coverletter to add mbm_assign_on_mkdir.

v17: Added the check resctrl_arch_mbm_cntr_assign_enabled() in
     resctrl_mbm_assign_on_mkdir_show() and resctrl_mbm_assign_on_mkdir_write()
     to make it accessible when mbm_event mode is enabled.
     Added texts in resctrl.rst about the accessability.

v16: Fixed the return in resctrl_mbm_assign_on_mkdir_write().

v15: Fixed the static checker warning in resctrl_mbm_assign_on_mkdir_write() reported in
     https://lore.kernel.org/lkml/dd4a1021-b996-438e-941c-69dfcea5f22a@intel.com/

v14: Added rdtgroup_mutex in resctrl_mbm_assign_on_mkdir_show().
     Updated resctrl.rst for clarity.
     Fixed squashing of few previous changes.
     Added more code documentation.

v13: Added Suggested-by tag.
     Resolved conflicts caused by the recent FS/ARCH code restructure.
     The rdtgroup.c/monitor.c file has now been split between the FS and ARCH directories.

v12: New patch. Added after the discussion on the list.
     https://lore.kernel.org/lkml/CALPaoCh8siZKjL_3yvOYGL4cF_n_38KpUFgHVGbQ86nD+Q2_SA@mail.gmail.com/
---
 Documentation/filesystems/resctrl.rst | 20 ++++++++++
 fs/resctrl/internal.h                 |  6 +++
 fs/resctrl/monitor.c                  | 53 +++++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                 |  7 ++++
 include/linux/resctrl.h               |  3 ++
 5 files changed, 89 insertions(+)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 2e840ef26f68..1de815b3a07b 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -355,6 +355,26 @@ with the following files:
 	  # cat /sys/fs/resctrl/info/L3_MON/event_configs/mbm_total_bytes/event_filter
 	   local_reads,local_non_temporal_writes
 
+"mbm_assign_on_mkdir":
+	Exists when "mbm_event" counter assignment mode is supported. Accessible
+	only when "mbm_event" counter assignment mode is enabled.
+
+	Determines if a counter will automatically be assigned to an RMID, MBM event
+	pair when its associated monitor group is created via mkdir. Enabled by default
+	on boot, also when switched from "default" mode to "mbm_event" counter assignment
+	mode. Users can disable this capability by writing to the interface.
+
+	"0":
+		Auto assignment is disabled.
+	"1":
+		Auto assignment is enabled.
+
+	Example::
+
+	  # echo 0 > /sys/fs/resctrl/info/L3_MON/mbm_assign_on_mkdir
+	  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_on_mkdir
+	  0
+
 "max_threshold_occupancy":
 		Read/write file provides the largest value (in
 		bytes) at which a previously used LLC_occupancy
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 5956570d49fc..9be1e53a73d3 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -410,6 +410,12 @@ int event_filter_show(struct kernfs_open_file *of, struct seq_file *seq, void *v
 ssize_t event_filter_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 			   loff_t off);
 
+int resctrl_mbm_assign_on_mkdir_show(struct kernfs_open_file *of,
+				     struct seq_file *s, void *v);
+
+ssize_t resctrl_mbm_assign_on_mkdir_write(struct kernfs_open_file *of, char *buf,
+					  size_t nbytes, loff_t off);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index a4bbd45fc58a..b3d33b983c3c 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1029,6 +1029,57 @@ int event_filter_show(struct kernfs_open_file *of, struct seq_file *seq, void *v
 	return ret;
 }
 
+int resctrl_mbm_assign_on_mkdir_show(struct kernfs_open_file *of, struct seq_file *s,
+				     void *v)
+{
+	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
+	int ret = 0;
+
+	mutex_lock(&rdtgroup_mutex);
+	rdt_last_cmd_clear();
+
+	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
+		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	seq_printf(s, "%u\n", r->mon.mbm_assign_on_mkdir);
+
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+
+	return ret;
+}
+
+ssize_t resctrl_mbm_assign_on_mkdir_write(struct kernfs_open_file *of, char *buf,
+					  size_t nbytes, loff_t off)
+{
+	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
+	bool value;
+	int ret;
+
+	ret = kstrtobool(buf, &value);
+	if (ret)
+		return ret;
+
+	mutex_lock(&rdtgroup_mutex);
+	rdt_last_cmd_clear();
+
+	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
+		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	r->mon.mbm_assign_on_mkdir = value;
+
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+
+	return ret ?: nbytes;
+}
+
 /*
  * rdtgroup_assign_cntr() - Assign/unassign the counter ID for the event, RMID
  * pair in the domain.
@@ -1459,6 +1510,8 @@ int resctrl_mon_resource_init(void)
 		resctrl_file_fflags_init("available_mbm_cntrs",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 		resctrl_file_fflags_init("event_filter", RFTYPE_ASSIGN_CONFIG);
+		resctrl_file_fflags_init("mbm_assign_on_mkdir", RFTYPE_MON_INFO |
+					 RFTYPE_RES_CACHE);
 	}
 
 	return 0;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index e90bc808fe53..c7ea42c2a3c2 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1808,6 +1808,13 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdt_last_cmd_status_show,
 		.fflags		= RFTYPE_TOP_INFO,
 	},
+	{
+		.name		= "mbm_assign_on_mkdir",
+		.mode		= 0644,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= resctrl_mbm_assign_on_mkdir_show,
+		.write		= resctrl_mbm_assign_on_mkdir_write,
+	},
 	{
 		.name		= "num_closids",
 		.mode		= 0444,
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 04152654827d..a7d92718b653 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -277,12 +277,15 @@ enum resctrl_schema_fmt {
  *			monitoring events can be configured.
  * @num_mbm_cntrs:	Number of assignable counters.
  * @mbm_cntr_assignable:Is system capable of supporting counter assignment?
+ * @mbm_assign_on_mkdir:True if counters should automatically be assigned to MBM
+ *			events of monitor groups created via mkdir.
  */
 struct resctrl_mon {
 	int			num_rmid;
 	unsigned int		mbm_cfg_mask;
 	int			num_mbm_cntrs;
 	bool			mbm_cntr_assignable;
+	bool			mbm_assign_on_mkdir;
 };
 
 /**
-- 
2.34.1


