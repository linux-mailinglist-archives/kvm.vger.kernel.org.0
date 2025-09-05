Return-Path: <kvm+bounces-56924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD99B465C7
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE7D7AA7D62
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F5CD2FE05A;
	Fri,  5 Sep 2025 21:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RczQ/Kp7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E620A2F4A10;
	Fri,  5 Sep 2025 21:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108215; cv=fail; b=QMBQICdaVScKzbDo26adkCLgbBH1GDjEBadRc5gAy0dF0E3MTdi9f447SRLxM95mTkwXfjdUfvA6G2a78HvAwg1OG5REQeBCuucQkwuq0LxwNVrIzqdmTFajrOVamBnIpg2xPSbpo7pe7DLdn5loMisnlIpSSI12S6vfDuBLK8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108215; c=relaxed/simple;
	bh=qpIPIGUUewvT9oarTT+LGxHTxBpzYumlNay3h5d2Jes=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3x0hqXiJdY3XCquCckI56mf1HjGjOjQcin0z2VPn/cLzBO8R55kzgkdRK5DtV24LopDbS1XIcMAjJ8nko8KOY03rJ0ws28mWbdHL2ryOWFQZYs905o2AyDx4OkVN2XxjjLXqxjDbqOGOCm++XztUQDqz/GG544/dLw7Az5u7H0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RczQ/Kp7; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F1u93wBjjWeY4T0NBYjs7TBJ0N3S9MgqnWY+m7rLsPfHAa4l45kZMmLAuITawLvU20ostdY31RhZbA+wBd41O4zhMLJZ1HuNyQBBP9uB4UQZ1MqVDDGZoXNNwKz00lEntWkTwX6LmCFWwxyj4W5p8PgoqQSpmIMxQ9nF/8I2wiuS+07mxo9+Dit+gCroX/+8kKhgrZYu+olQgup+O2RiAHlZ9yqEiWIf9laWoNU0DoQ5RngMoUG7oR9UVuSUHfgKj4+vJTF6T7w1ygcyv0IxNvfwD3fJ/4fdn6A5sPYpKjM9SGGIs3k7KUkwqmtH5GFtK8T8Swb6EJJVdvHMhfqlbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Srg1adGFPViKMcpbti7FNWgscD2NkDwu0nWifsFjGlA=;
 b=dhb4ZX1mDWSFEdyYEoOFCieIzRenISR7JD/RjEMLjVMkA8paR24I+kxEpzC9mbfoipmilvR8X64gcwsEr7Y+1SA/DHbAAfHXYWOS3fdhMkHxNCTRrvUx32zfZz9IXk1zAefpD0Ic6XtAESQZbpnxjhkWlMIvnVkPk0v/lYeTZiDMj8S912D/Z/EvojeNsW1SmtVOxrPj0bTzFEjiTo31wWppPqMUJDbvUKAx25kCQQy8vjfuNimvlxkCN1oejZp295lkDOPlDcAwbLuoUq3A/TF3aFV+7WZ6JTGL+snRQk/0ub4JLIsVLXhTjjXCGXoVIOx0iwYOXUcpWOdw/tmxSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Srg1adGFPViKMcpbti7FNWgscD2NkDwu0nWifsFjGlA=;
 b=RczQ/Kp7lDQnINyvzuEZTibbV21NKQcArX6lxHGj1TqwO29ktEQ8WFLJB3QdwQTNXqkl52mnVqgeu1Xf5EcCmDDpRn3HLJwWBEAgk5xNLnXLrosVubPjT91E3o/L/fOafS/QdBf9Zo+NXbCSN1tuEB2FbeHZ7SAVJOcC6jsbUPQ=
Received: from SJ0PR03CA0057.namprd03.prod.outlook.com (2603:10b6:a03:33e::32)
 by PH0PR12MB8152.namprd12.prod.outlook.com (2603:10b6:510:292::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 21:36:48 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:33e:cafe::e4) by SJ0PR03CA0057.outlook.office365.com
 (2603:10b6:a03:33e::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.18 via Frontend Transport; Fri,
 5 Sep 2025 21:36:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:36:48 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:36:47 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:36:45 -0700
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
Subject: [PATCH v18 12/33] fs/resctrl: Introduce mbm_cntr_cfg to track assignable counters per domain
Date: Fri, 5 Sep 2025 16:34:11 -0500
Message-ID: <c11ea8f305e3f72032e1b8f8cf292959189e0c12.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|PH0PR12MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: 41250a87-4542-4319-36b8-08ddecc451a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aHehbC14JgjjL5WZJ04qubAU0KibUKqG7NLS4qNVViupA2HXKyq5Jxhver0g?=
 =?us-ascii?Q?uM0J8MTf/tcUy/2P/V2BetceeSweVR0pp7eS9R1ew1C485RX0mWSYW2ATTrM?=
 =?us-ascii?Q?JeyuZQGJjcVojsbF+Ju8kLyjg/kO0PogIRebd9wH3GqTzUxCfuElRuiFiSqY?=
 =?us-ascii?Q?FWqH/KyESTC/wCW53j9AK0A03FWzxwIXc1HVeoChR5cLy3C0qVWANcmbL2fG?=
 =?us-ascii?Q?9F1hR++zWdebehD0Kd4a6nO3oIGzLLUwABXu93GJ2n8aC0neFi8r3Jl1E+T4?=
 =?us-ascii?Q?lHBWGhlyxpPcqiuU+2J/6c5QsWyfU/eTGFW7qLLVx9uOG2rXDWLeyOXrpxa+?=
 =?us-ascii?Q?wW6tVP6Eun26cXigs4vYl1jmRiFhUVZy9YnFcs4SzeIBGuiFOeWUDVf5yNaJ?=
 =?us-ascii?Q?oEzG7CPEdhwB7jeec6q+fV5DpH8+VnPcAMX2qkOs3VlNR0kGH9/CNnB7AA8V?=
 =?us-ascii?Q?yZ4UtcKZ9YraNiVy7f9aGqwPKtTIkCEOiDStqw7e+4v1ZAMFnoYrj9YF5C2m?=
 =?us-ascii?Q?XHA2EERgMgqdiqWlrjI9gEv6O7u7PsjkQG88yqwAZwhSuRZmGjk2VR2SK9zL?=
 =?us-ascii?Q?hfLr9f5yOyuRCrQZ0bs7r1f1x3t4Lea9g9DsGHeq5eUmh8GxQCIa4xsBZyfv?=
 =?us-ascii?Q?BU1Hi9yjEri0bb66QgZLnY7d2TURhTgEsptEz/l60cb5JaGM9foIscrRKHkI?=
 =?us-ascii?Q?3w5z7nT+GZuiZPfKTakEx1GbqpR2G6SKLLsGfPpjlhGHbt33IH4Yg7oHiyRd?=
 =?us-ascii?Q?YpQiDnkBK6m5h3ohup3TZgSejJuLfnspXleOMzavJa65E6esHK6xLKy07llx?=
 =?us-ascii?Q?GUN4W+rMgEPtPGfJdm4smMRLSiW6ygkF41punTJ8f6p9uJVrWlgAs1ggiXtq?=
 =?us-ascii?Q?zMRvkOxIvYgP2ACxXbq1MrEEQ37OnjVBrZ7vDvGtIujQ825vnpIzyTgjyKBD?=
 =?us-ascii?Q?qWtpEkRScxvVtzYlGlyZRxhWOpeOL/0xehELH8tjNHWuNcT5H+gKxTTXwP9y?=
 =?us-ascii?Q?VWTJR6hr/TVXv99VpMrNoCtONQhP0qc1pfMM+W6YGvFq3UHeY82EH+/Xg21X?=
 =?us-ascii?Q?K7AscK9+Wq65Nx3q1tVV5StfGPGBGt42Gbi55eN/CbS8KAFpKaSg3Q1k5mTX?=
 =?us-ascii?Q?soJlK89dvtZnxJEOI7UHR9uAXCSFSZBTc0Lo9lJq19MZct8HLSKTp/0ONlH5?=
 =?us-ascii?Q?WdNlu37xnKYUTEDr5MvjdyOz41bkW8gh1/HYRDXHRZqcNTuGLiJFXzURQrLI?=
 =?us-ascii?Q?BlleTFWblB486ZO6k23V2ohZhzEuVXoKBtXhOCZfNPbvO94p8ii/ephKDqdL?=
 =?us-ascii?Q?so0jChbMELDdv02hNEC4jkOAQne7YawbNtedfM1QfqNQJWDglMCzqXTPGO2a?=
 =?us-ascii?Q?y9mNnsnWN8BHieNqi7gMjMLCptTmy2p1WuB3dcwAaY8SW+8sKxP4Y3QfagBk?=
 =?us-ascii?Q?KuJoVkolx78FlpXdLp8BnfnD3qd6PdMZBrNJITKr9FAfnB47Q7cLZESii8pa?=
 =?us-ascii?Q?QVM95nsYU0jHIIE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:36:48.2451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41250a87-4542-4319-36b8-08ddecc451a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8152

The "mbm_event" counter assignment mode allows users to assign a hardware
counter to an RMID, event pair and monitor bandwidth usage as long as it is
assigned.  The hardware continues to track the assigned counter until it is
explicitly unassigned by the user. Counters are assigned/unassigned at
monitoring domain level.

Manage a monitoring domain's hardware counters using a per monitoring
domain array of struct mbm_cntr_cfg that is indexed by the hardware
counter ID. A hardware counter's configuration contains the MBM event
ID and points to the monitoring group that it is assigned to, with a NULL
pointer meaning that the hardware counter is available for assignment.

There is no direct way to determine which hardware counters are assigned
to a particular monitoring group. Check every entry of every hardware
counter configuration array in every monitoring domain to query which
MBM events of a monitoring group is tracked by hardware. Such queries are
acceptable because of a very small number of assignable counters (32
to 64).

Suggested-by: Peter Newman <peternewman@google.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: No changes.

v17: No changes.

v16: Added Reviewed-by tag.

v15: Minor changelog update.
     Removed evt_cfg from struct mbm_cntr_cfg based on the discussion.
     https://lore.kernel.org/lkml/887bad33-7f4a-4b6d-95a7-fdfe0451f42b@intel.com/

v14: Updated code documentation and changelog.
     Fixed up the indentation in resctrl.h.
     Changed subject line to fs/resctrl.

v13: Resolved conflicts caused by the recent FS/ARCH code restructure.
     The files monitor.c/rdtgroup.c have been split between FS and ARCH directories.

v12: Fixed the struct mbm_cntr_cfg code documentation.
     Removed few strange charactors in changelog.
     Added the counter range for better understanding.
     Moved the struct mbm_cntr_cfg definition to resctrl/internal.h as
     suggested by James.

v11: Refined the change log based on Reinette's feedback.
     Fixed few style issues.

v10: Patch changed completely to handle the counters at domain level.
     https://lore.kernel.org/lkml/CALPaoCj+zWq1vkHVbXYP0znJbe6Ke3PXPWjtri5AFgD9cQDCUg@mail.gmail.com/
     Removed Reviewed-by tag.
     Did not see the need to add cntr_id in mbm_state structure. Not used in the code.

v9: Added Reviewed-by tag. No other changes.

v8: Minor commit message changes.

v7: Added check mbm_cntr_assignable for allocating bitmap mbm_cntr_map

v6: New patch to add domain level assignment.
---
 fs/resctrl/rdtgroup.c   |  8 ++++++++
 include/linux/resctrl.h | 15 +++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 9d95d01da3f9..61f7b68f2273 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4029,6 +4029,7 @@ static void domain_destroy_mon_state(struct rdt_mon_domain *d)
 {
 	int idx;
 
+	kfree(d->cntr_cfg);
 	bitmap_free(d->rmid_busy_llc);
 	for_each_mbm_idx(idx) {
 		kfree(d->mbm_states[idx]);
@@ -4112,6 +4113,13 @@ static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain
 			goto cleanup;
 	}
 
+	if (resctrl_is_mbm_enabled() && r->mon.mbm_cntr_assignable) {
+		tsize = sizeof(*d->cntr_cfg);
+		d->cntr_cfg = kcalloc(r->mon.num_mbm_cntrs, tsize, GFP_KERNEL);
+		if (!d->cntr_cfg)
+			goto cleanup;
+	}
+
 	return 0;
 cleanup:
 	bitmap_free(d->rmid_busy_llc);
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 919806122c50..e013caba6641 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -156,6 +156,18 @@ struct rdt_ctrl_domain {
 	u32				*mbps_val;
 };
 
+/**
+ * struct mbm_cntr_cfg - Assignable counter configuration.
+ * @evtid:		MBM event to which the counter is assigned. Only valid
+ *			if @rdtgroup is not NULL.
+ * @rdtgrp:		resctrl group assigned to the counter. NULL if the
+ *			counter is free.
+ */
+struct mbm_cntr_cfg {
+	enum resctrl_event_id	evtid;
+	struct rdtgroup		*rdtgrp;
+};
+
 /**
  * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
  * @hdr:		common header for different domain types
@@ -168,6 +180,8 @@ struct rdt_ctrl_domain {
  * @cqm_limbo:		worker to periodically read CQM h/w counters
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
  * @cqm_work_cpu:	worker CPU for CQM h/w counters
+ * @cntr_cfg:		array of assignable counters' configuration (indexed
+ *			by counter ID)
  */
 struct rdt_mon_domain {
 	struct rdt_domain_hdr		hdr;
@@ -178,6 +192,7 @@ struct rdt_mon_domain {
 	struct delayed_work		cqm_limbo;
 	int				mbm_work_cpu;
 	int				cqm_work_cpu;
+	struct mbm_cntr_cfg		*cntr_cfg;
 };
 
 /**
-- 
2.34.1


