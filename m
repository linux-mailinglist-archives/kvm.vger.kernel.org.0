Return-Path: <kvm+bounces-56925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D7FB465CA
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92AC117CCE6
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27AD2F8BC9;
	Fri,  5 Sep 2025 21:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pjUIlEC7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC6B2F6188;
	Fri,  5 Sep 2025 21:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108223; cv=fail; b=Zd8s9AOqnqGlr/fI5xYsgMDlxzpFiqzqrWm1fu91jDPvPglLB9p+M7yDW2t19HLsZ0hgYpARiXxAOmSIJAovGHPbMx9GERUii5a7TKxKBuCAyZKC+Pq4qwtDGrZE+zrpalXpjrxXIiypKHXXbNtkP1VOm1ptr65lEkJC8Lh2B+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108223; c=relaxed/simple;
	bh=hM9vyvgVZGnqiOYfEZ8G9iYM7jLQxkBf3PEFL8RA1e8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BPHsUH5pvTo07xlaS1CwU9Xqxri+7GlCo3b6ky9RPL/9XGx3DAY7hrQjud+nP6SY2N/s4v9RL7nqGC/W3KUE822Que8lFyLSGilt9jfD+rnotGRam7XL2mQ2LEbeplfjvbgOYRFEXoJakmsNMBLLkjpBTMOvH6jusmNZLJ0TYME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pjUIlEC7; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lxx1vnpwZ57iJBZp6xpXYIWPFt/MmVXmd861zLfAs68g/B9kEaKtcDJIEVFxaZ91CuXRcfQ6gHl9TkBWH1UcZBKzP4lu17+vQLDuYBB6hJHaZrP6wtWTvsXT2p96yCE5jpikOYdAcjdEt8gbPQqS2dVv1FlZPvSMO9AtayWIkdYS1JOuM3Gl8D/Q01RI+++OXk9rD4BFNkRApcfPhC+eTTAp8OcHuyGj9ZIHZnjYR0nQxmi7/GLQWZrjW3w+5Ej7dO0TVUWNLSLP0i8a3hdmoFWASypxv2D15S+rhzjFtPNiPZnaBjXK0mt7Gzrth1JPYaFWklpy9XLFhvqQWk2PNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNtdEC557XYLdYFk3RaTzOMcvA9YNWIjV0cZl98+Y40=;
 b=sTq+wDYKEsD2AfLmYpk0hFItXGPILj0izWZHmEN7EGwx8GzEC3XbPUZU2eL0JT0eE1kJs8iy3medQ1Cq3783Oeun6ynGDduVxoV/GLjb7bxqg/TgwjzldH0U4VIHg0hZYqsQGdxTGBE3eA69TluxPFGKYL8leWy3rUON1xh6OCrkO2g883IkSGpvVeyNtbM2xC3RPlQFHtaK/T2aS0GDX2Wg2NUgqvOB7PUo8mCljT+osJXhrSX6FlM3MdXevG7ehHojIt2BAWNeENkCyfET54XhNhlwF7aIVz4Dj6xzszuj485bQf84rWmQhg3LvOI4DPT1qcUu/13DHPMhIOsl4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNtdEC557XYLdYFk3RaTzOMcvA9YNWIjV0cZl98+Y40=;
 b=pjUIlEC7WzJCQ8cun+SgLNRKm/OesmnWriFLlsSm8S0c+05i6S+jfY2599y2O8ngtG9K9vuTQeqbnBw5S1z6AxyLWCTHk1WWuw0xw4hWdQjuE81rWuqg3CMMc66dBG0wSf7/kIGm+rFZyaWdcZVb31eMit36PXJ44UR7zqKjcEE=
Received: from DS7P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::28) by
 MW4PR12MB6756.namprd12.prod.outlook.com (2603:10b6:303:1e9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.18; Fri, 5 Sep 2025 21:36:57 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:8:2e:cafe::2f) by DS7P222CA0029.outlook.office365.com
 (2603:10b6:8:2e::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.20 via Frontend Transport; Fri,
 5 Sep 2025 21:36:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:36:56 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:36:56 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:36:54 -0700
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
Subject: [PATCH v18 13/33] fs/resctrl: Introduce interface to display number of free MBM counters
Date: Fri, 5 Sep 2025 16:34:12 -0500
Message-ID: <346cf41a45abc2091ce188a098aa61838a12cc22.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|MW4PR12MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: e30fe3af-5691-481e-e932-08ddecc456c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?96B/czPYIhV1iJ9c3o3fac8amSFmL5CBgpplkUB5u+WOwHL0ZARr9PZSt41c?=
 =?us-ascii?Q?g2//FteKHsIqz8mmcRzciJia9EIZX3vI7WCM31RfA1IyCUxt1l6NA1zCkdM+?=
 =?us-ascii?Q?7VuBG9Dzr2BMhj9QYuJ4BibJPzeXXk+eHc5kmChfLaO+H5+OXyrrZdx6USXK?=
 =?us-ascii?Q?EGuHxoRhPpl3S5meiSEj29IGA8NqHhXVVRaZKZ982JdTODbwNSr5KssoZL+T?=
 =?us-ascii?Q?B6OvgabtAvc9eBsVdu2xPxRHUQhngSnTXtIOkGnCWudwxzpBTwD/QaT8J2PS?=
 =?us-ascii?Q?0hCKD/iUPnxUdOGwWqQIbAMqCfYDhtEDfgqjkjEtyTp9EIpE/MJL1YHCg09H?=
 =?us-ascii?Q?mT/ymhGZ/5qtgDGqV4pU3KjcgXtob3RHdpKRhqWGWCU3t6Ya1JOnRUHtnRDs?=
 =?us-ascii?Q?6k6EgAnNLZL3b5xLpmDIwRs9LHLThIELlbRLiWPRSe/N+yxs7L6GhWOXllaM?=
 =?us-ascii?Q?9OJnsZAANeyHxrouDBytARiq6BH6fcAg6KK0h3CJP43EUK6VqMdbjMjfu/E6?=
 =?us-ascii?Q?EfJm+OP0uXykHnHFiYlMLlVH+dCQxF1B6giZLlVgUucmxDXVW1lIeRMV92UY?=
 =?us-ascii?Q?5XudO8VrhLBnYeveMGwnHOOhBfoYB6jJoGB/KzTiWl7woGmXwyP4XnLGQ1fL?=
 =?us-ascii?Q?vEcTl20jNeg1lZlRPQJvvNO0BCJvTdpFnjyiUalwh+W3tztujHo5cHARDJgn?=
 =?us-ascii?Q?v96Q6TdS+OMomoI9QdAmr/MlkH7OS22vZUdnHdkKxFXYHII1lB1LCr8RSZbc?=
 =?us-ascii?Q?1C5UTrXaOBjXMQwfKyP78K6Lt38mtSLAQ0nTpw8QrW+DltxfUBANQ2ossB/t?=
 =?us-ascii?Q?hSNDjSeSmx0/1PPvfkPbm1xfVJW7Dlsk5sXq99h/1bc/JCt/9I6mRFZTyOFY?=
 =?us-ascii?Q?iAkcGuLb2EW3gFxMZf8PqFW7MjjN08lrq40dZJmCD4CfuI6ZOdd/u1kLKUEM?=
 =?us-ascii?Q?5s37+4n8gwadNo1Zmab6XIpol/ou+MuJDdByvY2pArHtDU58gmg7JE7Kl6Oo?=
 =?us-ascii?Q?mn+rSopWduUtELg2FbxuHgQGJZlA03T1MNVPQ64METPamgi74jqyVQqL22gB?=
 =?us-ascii?Q?TtwlR9UxEpYmrDZxO2EAXBFr4njqifQB4iIrQ8WNLwbzLx1Nf+KgSdqgOV/n?=
 =?us-ascii?Q?+CIdiF5q6NsIz4FFOh4lt7tHc2VX/9+JJd6+nd03rDDwmoYEj1IipXSMkgwh?=
 =?us-ascii?Q?Wi/34x6/HI5d4NUrIPLUFuqQ47rloQPLDt597f+17uDIReivpMeSCjyjd9od?=
 =?us-ascii?Q?i6nAHWSU6U0kbl1/khLyjfsGjQmO+riO/D4aOBGJ2X9i81Dl81+zxbcY6oHS?=
 =?us-ascii?Q?hDQPV6VpWDL4ED9J0xgplQwg8GHTEfAM8GtS0RCTvVSmb0YscjYI2W9U5NHy?=
 =?us-ascii?Q?PoSWCMSRzFQolhNIXFggq7m1nqgWM+5MMv5NfBqDhPHTZmiNJycCBIvjxxUP?=
 =?us-ascii?Q?mOLwL2l+c+7uYEAjrf2JQodBhyCpJOPPfBVSY0yZKqhqtuHKzY0wcx5e+QFd?=
 =?us-ascii?Q?D5JYkvqb21QSkBA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:36:56.9025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e30fe3af-5691-481e-e932-08ddecc456c2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6756

Introduce the "available_mbm_cntrs" resctrl file to display the number of
counters available for assignment in each domain when "mbm_event" mode is
enabled.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Moved resctrl_available_mbm_cntrs_show() to fs/resctrl/monitor.c.
     Removed the Reviewed-by tag.

v16: Added Reviewed-by tag.

v15: Minor changelog text update.
     Minor resctrl.rst text update and corrected the error text in
     resctrl_available_mbm_cntrs_show().
     Changed the goto label to out_unlock for consistency.

v14: Minor changelog update.
     Changed subject line to fs/resctrl.

v13: Resolved conflicts caused by the recent FS/ARCH code restructure.
     The files monitor.c and rdtgroup.c file has now been split between
     the FS and ARCH directories.

v12: Minor change to change log.
     Updated the documentation text with an example.
     Replaced seq_puts(s, ";") with seq_putc(s, ';');
     Added missing rdt_last_cmd_clear() in resctrl_available_mbm_cntrs_show().

v11: Rename rdtgroup_available_mbm_cntrs_show() to resctrl_available_mbm_cntrs_show().
     Few minor text changes.

v10: Patch changed to handle the counters at domain level.
     https://lore.kernel.org/lkml/CALPaoCj+zWq1vkHVbXYP0znJbe6Ke3PXPWjtri5AFgD9cQDCUg@mail.gmail.com/
     So, display logic also changed now.

v9: New patch
---
 Documentation/filesystems/resctrl.rst | 11 +++++++
 fs/resctrl/internal.h                 |  3 ++
 fs/resctrl/monitor.c                  | 44 +++++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                 |  6 ++++
 4 files changed, 64 insertions(+)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 4eb27530be6f..446736dbd97f 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -299,6 +299,17 @@ with the following files:
 	  # cat /sys/fs/resctrl/info/L3_MON/num_mbm_cntrs
 	  0=32;1=32
 
+"available_mbm_cntrs":
+	The number of counters available for assignment in each domain when mbm_event
+	mode is enabled on the system.
+
+	For example, on a system with 30 available [hardware] assignable counters
+	in each of its L3 domains:
+	::
+
+	  # cat /sys/fs/resctrl/info/L3_MON/available_mbm_cntrs
+	  0=30;1=30
+
 "max_threshold_occupancy":
 		Read/write file provides the largest value (in
 		bytes) at which a previously used LLC_occupancy
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index e4d7aa1a8fd1..35a8bad8ca75 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -388,6 +388,9 @@ int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of, struct seq_file *s
 
 int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of, struct seq_file *s, void *v);
 
+int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of, struct seq_file *s,
+				     void *v);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 667770ecfd78..4185f2a4ba89 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -938,6 +938,48 @@ int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of,
 	return 0;
 }
 
+int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of,
+				     struct seq_file *s, void *v)
+{
+	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
+	struct rdt_mon_domain *dom;
+	bool sep = false;
+	u32 cntrs, i;
+	int ret = 0;
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
+	rdt_last_cmd_clear();
+
+	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
+		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
+		if (sep)
+			seq_putc(s, ';');
+
+		cntrs = 0;
+		for (i = 0; i < r->mon.num_mbm_cntrs; i++) {
+			if (!dom->cntr_cfg[i].rdtgrp)
+				cntrs++;
+		}
+
+		seq_printf(s, "%d=%u", dom->hdr.id, cntrs);
+		sep = true;
+	}
+	seq_putc(s, '\n');
+
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+
+	return ret;
+}
+
 /**
  * resctrl_mon_resource_init() - Initialise global monitoring structures.
  *
@@ -985,6 +1027,8 @@ int resctrl_mon_resource_init(void)
 			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
 		resctrl_file_fflags_init("num_mbm_cntrs",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
+		resctrl_file_fflags_init("available_mbm_cntrs",
+					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 	}
 
 	return 0;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 61f7b68f2273..2e1d0a2703da 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1822,6 +1822,12 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdt_mon_features_show,
 		.fflags		= RFTYPE_MON_INFO,
 	},
+	{
+		.name		= "available_mbm_cntrs",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= resctrl_available_mbm_cntrs_show,
+	},
 	{
 		.name		= "num_rmids",
 		.mode		= 0444,
-- 
2.34.1


