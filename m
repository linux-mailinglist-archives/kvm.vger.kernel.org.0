Return-Path: <kvm+bounces-56923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B167CB465C4
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E488CAA8191
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B966E2FDC4C;
	Fri,  5 Sep 2025 21:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qqEEbEOA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBE82F8BF0;
	Fri,  5 Sep 2025 21:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108203; cv=fail; b=PRPwsX0xxqet/IhPi9X2HZr5YjeLblINeHXB44VqVNTLDuvdgfcGV7j3jpPZcTZi6QjoUcfga1g/IcyuAwE5FAH0yHYnTXtmBSwjPayHE9baxczJyCtz0hoIKGv/1B1awySd4lBZmi7WXziPmVywUfu8h20CJ2bT/EK1D8qyE58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108203; c=relaxed/simple;
	bh=DZIN5OgjKxe0rsdSKf7IZUUf/YfkWorRqR5ckEL6qNM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sVLTDLG2YgNQJ6KpZum/b/+4rS8hgvgUoP+agbl6T/FpeNUQ/sd6FkO0vD+obazsdk6KNQzR0MUeRsXm0ntalpsPLpYg6vz4klNFLlL6mDDfQGRHFrDkWVUurAhAGsNQjza37vM1wWS1ZYJSErzwcULAOvJjMX//54okzWxN2gU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qqEEbEOA; arc=fail smtp.client-ip=40.107.237.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UX6dMlPUJWcigTTlcsfAbgW7Z34+REGatwACLRNeRywRZRGT1nisRXF21Ul6M4U5Ku9tJDSxtRNat0cyVSByvGOJavzxPaJGfRNN/xNziz3AMNhhs2vD2dozmm/WuLU+XDqXjGzxcSXlzc09MgcjnNfb07k7kVzGXx+D4kiAF43een6CkczMHTtxvWnlKwHOE+nwN03dTI4/f2cNqEdpTKUjjhYPC64Hy863lpLPmQ8Q6Llst1/1M+0MkqSqLoF0c5FiT57+NI2X1fpQfTGM8lsF5Nt1WAKGZ7tQ4ZwJfk5WVX9LAOQXQBlDkDpUWJBtEdJEaTHVtP3gTZIQ9uSFCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IZKIc6vEuTlO0O4xzD8+l8eeDHY7dantqPDVTU13T0I=;
 b=JtWA9WgzV4a/qgc9u3hrZqWya/JKQf1HX4giLoF/t+85S68defhOs92qY0jsxiSwSvBWeclGQmwkJlhpbe1LMwHS/U0+KgA+CaUqcgwlmB7AZPEHdqlnIvcWlwrik8B/0e0TPuK5+fT/M5kKd3RQvUjXcCYx6T5tRMxq6NdqDoaQi6FrevDJpy/Tv1mjhZYr18SlO2ZuyO9q3GEN4gSlNyz/ZgZqfJbBgKGC+EAKT34GjfD0A865WL83XZlVWkWDh52B1stByI/J4k1kTfdFe0aBXmfBLEVMkE+sLXAholLak68TgkQX/beeZT6ioNqNbJUxz1rP5ACHS9DFrko6QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZKIc6vEuTlO0O4xzD8+l8eeDHY7dantqPDVTU13T0I=;
 b=qqEEbEOAPcpoL/bW046X+V/pAT7DueB/jqJjjTbY0MH047UvEA0bLne6uWShE4TKr9Kd0EemPw/0e2W+PS6txK5sNXpsbOi7ocz2/KQ3lgcezfmhki9aWutcz8XSHUaWgeFtbM8bwkpnxrTZ8hy5+xkA+aV0K/N3+3srv73AfXE=
Received: from BN0PR04CA0138.namprd04.prod.outlook.com (2603:10b6:408:ed::23)
 by DM6PR12MB4370.namprd12.prod.outlook.com (2603:10b6:5:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 21:36:39 +0000
Received: from BN2PEPF000044A5.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::19) by BN0PR04CA0138.outlook.office365.com
 (2603:10b6:408:ed::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Fri,
 5 Sep 2025 21:36:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF000044A5.mail.protection.outlook.com (10.167.243.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:36:39 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:36:38 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:36:36 -0700
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
Subject: [PATCH v18 11/33] fs/resctrl: Add resctrl file to display number of assignable counters
Date: Fri, 5 Sep 2025 16:34:10 -0500
Message-ID: <1c0c15a872ee03456ba6c1c48f5489a792a1336e.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A5:EE_|DM6PR12MB4370:EE_
X-MS-Office365-Filtering-Correlation-Id: d56a6cb6-0ca4-4650-1515-08ddecc44c1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kc82czOQxNXYuIC0l1kc2xl1WO5yIZ4KXWVh7IDYFctW2B4ujZZOiqdvezXf?=
 =?us-ascii?Q?YlWqH63U5IObzE8p3BNYQOeFyuMmTzXIiHgxkH1Cqbf/YHQls9agKknVN4dX?=
 =?us-ascii?Q?kgn1QML7KKOHsDUUkzbReBDMkcDKtIkQay2w/l2gVgWo1dZJcwmJnhK5zqwB?=
 =?us-ascii?Q?bSn6hv226QCGasYWMb/xzsrPsNvbULICU2Bi71IyMInV2jx+4zCfRXh7VcOF?=
 =?us-ascii?Q?924pkx7IFG3zQzbWnlKqVDfIqGbLMG8MBtmZDXO4Jqp05smYtXyo+66gzRW/?=
 =?us-ascii?Q?7RChkITKyZz47lRxmvTOaIyGV2elWl8lmdXPtk00uZplLBvtIgmiEOi9FQFk?=
 =?us-ascii?Q?SxHpqr3vpxj/otSe3KhB65sqyk8cxRzSV0gV1rK05Gyj5tZuVY/VyynvwAUm?=
 =?us-ascii?Q?T9zZzZztjDXkYwwQVU2NKnR7h57r+/VsuQndENn/Wv3xT9HjfMxoChSL2Tiz?=
 =?us-ascii?Q?HYAqEa4YkbT6V4koUGeJxNoC7d3iQk1KJtBoKY3rpWkRSUSCCKIVu00cZGQ2?=
 =?us-ascii?Q?/aS6Btf3NoZpEIcpQrf9YIRBqD8CzD6TPM84WIT8oFSPtrUVQPfVaMmdX3bq?=
 =?us-ascii?Q?wgU3qgsK1NhchH/HCFEQKiKymXYPd8QOXzj42b5URNPnyjHj89aOmF7sCrSV?=
 =?us-ascii?Q?bYahvUVM0R5dCod375+UNSgGzhB8ewuJRS+4ZIXqBsU2oAiSjrI/1Scv/mqu?=
 =?us-ascii?Q?yQKs68RR9P3s8fBw82sh09Q7q7Ep8KhxGqMCig2YMX+RFR0Uymagkp3QBwJf?=
 =?us-ascii?Q?Uvs89oNRntmhLQrDZesuccaApibMTvb2g24bnN0TnSlPErSjuGRMe6mB2g4R?=
 =?us-ascii?Q?By10T37BXwVYrjzSy84Kx32CkKlrHnZ7qrLh2lEfZnboOi5SU9saLV1uIdIJ?=
 =?us-ascii?Q?jB/S9dmeDHUlZ92VSllqh40glIZSzTSdy11oYILfepVIy2KH172unvcopovI?=
 =?us-ascii?Q?qyKU8hNzFg8BeU8r+9ZjakJwJj925pYjDUCGzwKlQX7P+Dn5kw54pcTITkXL?=
 =?us-ascii?Q?zjQWDc1znGUtPA7Ivp2Xtc/g+WXgJc6T4LehH6hx91ZSKSJwC//wKLHnqykB?=
 =?us-ascii?Q?r5J3zxHoQS8DHQHyOb1EuMk2LyKECCYj++zQJHXdxvLn658xujoNEcR3Td9i?=
 =?us-ascii?Q?gQmZlkK0goe9ZrkDFtDL489a6ffZoSyvtZVZvkMmSKNN6GfofpjA8fyCSvnB?=
 =?us-ascii?Q?H/wa7sVMx1hH62VHVtv4RxwHeSklydPzOLvw1FvrBTlJLp1mdQ9r0kNnMplU?=
 =?us-ascii?Q?0gSYmhCZG7vWlTjl7FByuVY31pu/bmFHAyi4ZLxraFH67b7aUA3w6iyCZvFo?=
 =?us-ascii?Q?y7w8p6yQ0svcw/D+wLfSsXjbl04LnZr1xEy8pHZgNbUiNyz+u6kilUFHtKYu?=
 =?us-ascii?Q?aZ0N69WT+EJhAYw0adn/gXA3iUi1dCBtSk+eEJYsuPU/EaWnNi4tbHX/7QGS?=
 =?us-ascii?Q?daFe3ZXtRiE0TMVekHywjXka0K63L5qOw3vzm44gSwOwDRlwszr6t3Qu7WZc?=
 =?us-ascii?Q?m5R2TwBDe2hJaE7BxTVx2npobXAUTZWArSV4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:36:39.0779
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d56a6cb6-0ca4-4650-1515-08ddecc44c1d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4370

The "mbm_event" counter assignment mode allows users to assign a hardware
counter to an RMID, event pair and monitor bandwidth usage as long as it is
assigned.  The hardware continues to track the assigned counter until it is
explicitly unassigned by the user.

Create 'num_mbm_cntrs' resctrl file that displays the number of counters
supported in each domain. 'num_mbm_cntrs' is only visible to user space
when the system supports "mbm_event" mode.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Moved resctrl_num_mbm_cntrs_show() to fs/resctrl/monitor.c.
     Removed Reviewed-by tag.

v16: Added Reviewed-by tag.

v15: Changed "assign a hardware counter ID" to "assign a hardware counter"
     in couple of places.

v14: Minor update to changelog and user doc (resctrl.rst).
     Changed subject line to fs/resctrl.

v13: Updated the changelog.
     Added fflags RFTYPE_RES_CACHE to the file num_mbm_cntrs.
     Replaced seq_puts from seq_putc where applicable.
     Resolved conflicts caused by the recent FS/ARCH code restructure.
     The files monitor.c/rdtgroup.c have been split between FS and ARCH directories.

v12: Changed the code to display the max supported monitoring counters in
     each domain. Also updated the documentation.
     Resolved the conflict with the latest code.

v11: Renamed rdtgroup_num_mbm_cntrs_show() to resctrl_num_mbm_cntrs_show().
     Few monor text updates.

v10: No changes.

v9: Updated user document based on the comments.
    Will add a new file available_mbm_cntrs later in the series.

v8: Commit message update and documentation update.

v7: Minor commit log text changes.

v6: No changes.

v5: Changed the display name from num_cntrs to num_mbm_cntrs.
    Updated the commit message.
    Moved the patch after mbm_mode is introduced.

v4: Changed the counter name to num_cntrs. And few text changes.

v3: Changed the field name to mbm_assign_cntrs.

v2: Changed the field name to mbm_assignable_counters from abmc_counter.
---
 Documentation/filesystems/resctrl.rst | 11 +++++++++++
 fs/resctrl/internal.h                 |  2 ++
 fs/resctrl/monitor.c                  | 26 ++++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                 |  6 ++++++
 4 files changed, 45 insertions(+)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index b692829fec5f..4eb27530be6f 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -288,6 +288,17 @@ with the following files:
 	result in misleading values or display "Unavailable" if no counter is assigned
 	to the event.
 
+"num_mbm_cntrs":
+	The maximum number of counters (total of available and assigned counters) in
+	each domain when the system supports mbm_event mode.
+
+	For example, on a system with maximum of 32 memory bandwidth monitoring
+	counters in each of its L3 domains:
+	::
+
+	  # cat /sys/fs/resctrl/info/L3_MON/num_mbm_cntrs
+	  0=32;1=32
+
 "max_threshold_occupancy":
 		Read/write file provides the largest value (in
 		bytes) at which a previously used LLC_occupancy
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 4fbc809b11a6..e4d7aa1a8fd1 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -386,6 +386,8 @@ void *rdt_kn_parent_priv(struct kernfs_node *kn);
 
 int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of, struct seq_file *s, void *v);
 
+int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of, struct seq_file *s, void *v);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 379166134f5a..667770ecfd78 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -914,6 +914,30 @@ int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of,
 	return 0;
 }
 
+int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of,
+			       struct seq_file *s, void *v)
+{
+	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
+	struct rdt_mon_domain *dom;
+	bool sep = false;
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
+	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
+		if (sep)
+			seq_putc(s, ';');
+
+		seq_printf(s, "%d=%d", dom->hdr.id, r->mon.num_mbm_cntrs);
+		sep = true;
+	}
+	seq_putc(s, '\n');
+
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+	return 0;
+}
+
 /**
  * resctrl_mon_resource_init() - Initialise global monitoring structures.
  *
@@ -959,6 +983,8 @@ int resctrl_mon_resource_init(void)
 			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
 		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
 			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
+		resctrl_file_fflags_init("num_mbm_cntrs",
+					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 	}
 
 	return 0;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 144585a85996..9d95d01da3f9 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1836,6 +1836,12 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdt_default_ctrl_show,
 		.fflags		= RFTYPE_CTRL_INFO | RFTYPE_RES_CACHE,
 	},
+	{
+		.name		= "num_mbm_cntrs",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= resctrl_num_mbm_cntrs_show,
+	},
 	{
 		.name		= "min_cbm_bits",
 		.mode		= 0444,
-- 
2.34.1


