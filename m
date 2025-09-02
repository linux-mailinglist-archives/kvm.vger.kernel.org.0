Return-Path: <kvm+bounces-56645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5370AB41037
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2B541649B0
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8172777E4;
	Tue,  2 Sep 2025 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XcdBSSF/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EEB27F010;
	Tue,  2 Sep 2025 22:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852970; cv=fail; b=HxDGuR3rO4Uh2RI/PojobiCSHf0+VGoDASNUgpwnPEM4JJYBOGD2/jS3cztJCBj4AwSt78oDBlhnyjQ+xB0k2eMVdZ+T/lo1EXvEiU2aiBITfHSFiQE3Kedb6YYdvR0qBu5S8bTtFUM9hrZCZBwLC5zaFFYCIcBuWyRrn/EpZlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852970; c=relaxed/simple;
	bh=0w8jdrDZeA8rRtV7mA60E1cF9UTt8gMseh35o0VS5fM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cal1j33LGEllJCzTk9btR2BpUn5P9b6ulAmff5EgCyvj2VOfT4nuSRzQFfhgVayp8176hTkdGG9eO/neX5NFlHRz32w3nIYWBUuInRwCii0xthEVhh2pfbm6I7l8bJQdPWxHiWXB03f2DTPhZWUxvKG+pc7vGlWIZ1kgDTlJC1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XcdBSSF/; arc=fail smtp.client-ip=40.107.93.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+bhb4mYkODZRg8r65YJAUbQtNRl7gNKW5ceFE+px2F9QURnD1taaUFSysvxp8si3A7P2cJsiwYjRnTt10l0rdH08VHv3fJT/qBVTLbdbe72yFJogtDzJAaaroDogW/iSFTTG8+l4Dy70bvjOa2W3nF2TuyV9AveixI1x6T+CHabrLzrX4CWg++rZsWrHnCmuzyjZvQcPTPEzuyJt1kevaxzwsH7MSScZOV6jXGCOIbGt4lLNJvmgoXPaDb9Qv1IdmQf76KEZaEd8EICq++C06F1N4rrfuvlRvu0/S2T2HZMkrk5Pwzv+0DczOTfQR5GsIfFYb+LfKOxO+qa4QZ1Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jsBrsRdL6utdLeB2AR1in0jR2kI+97ctFd7nnQ9HwU8=;
 b=CsAfoBbVf9YUV2DgrAXHIrW4aLF+FzG2mrSal59w2iqVZtE/yCvFZQf2PirDjyO6Ek/Z+ZfTK0M5DygJ/HHlM0QCLKzaUFxakECxmizcqDUbIl3Fqwwr5vPV8dis26VlXq9bbBdbkrsrzySEa/QI2nHvXNYsTca99KOFrGenEiH84MYa8lMpecpIHj/MTG6Ku6+sxzNiWiNBIbIRJKPkt+dVlynBDiVkJCI4fO7mGbFaJwM0r1EmFU40YVYXn4raTFO2dh93rGqwAgt9YZYKliHvSCn0H+gvlWWwUd8bS/v0Q4vFQ4kYrt1CfgL+vXmregvsCV+duh3gyD5nOhBBlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsBrsRdL6utdLeB2AR1in0jR2kI+97ctFd7nnQ9HwU8=;
 b=XcdBSSF/aAHncctkPwYwNqp5rjWvB1EdApYm90SeNJVHT8QQaSw5aIo61oFpoEOPqXvdaHdSpMQjUXtQSoN05nEGOnJUkX2ctvCTZzQUK3tG1K+qhzJq1Xk5Fa03z/Ea2dNX/1CGwvSuTwan1vOUfe86VQhZ9ko2TxmhRzlkAZw=
Received: from MN2PR11CA0013.namprd11.prod.outlook.com (2603:10b6:208:23b::18)
 by DM6PR12MB4284.namprd12.prod.outlook.com (2603:10b6:5:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 22:42:41 +0000
Received: from BN2PEPF00004FC0.namprd04.prod.outlook.com
 (2603:10b6:208:23b:cafe::42) by MN2PR11CA0013.outlook.office365.com
 (2603:10b6:208:23b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Tue,
 2 Sep 2025 22:42:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FC0.mail.protection.outlook.com (10.167.243.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:42:40 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:42:40 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:42:38 -0700
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<babu.moger@amd.com>, <dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
Subject: [PATCH v9 07/10] fs/resctrl: Introduce interface to display io_alloc CBMs
Date: Tue, 2 Sep 2025 17:41:29 -0500
Message-ID: <382926e0decbe8d64df56c857fdf10feef6fcc51.1756851697.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1756851697.git.babu.moger@amd.com>
References: <cover.1756851697.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC0:EE_|DM6PR12MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d37522-46d0-43b2-f85f-08ddea720656
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?beEb2iWjv+khbJzZ3NI5fEGz08e41U2Ae3yWjWN+7voUAr3/o7N7ohfvwvkQ?=
 =?us-ascii?Q?5ghofcdwQNy36pWMJPkliAFUQA5Kd8GRlEFTEYfmyGvbdO7Ei3cm+GoaSxQT?=
 =?us-ascii?Q?5UYkurrmpETQO1ms9fYWxUB8HkulGutqj6Uw92k76rkBhJpkdZ38rbQ6J0x8?=
 =?us-ascii?Q?bYXcLc1l40Hcx5RNL5f5/7qSJKOusCpqvN3bpt/K47KqqzBUzSQMo40Nc3b0?=
 =?us-ascii?Q?UAdpL+uallT5v88d2Yl0gVXV544X+DgzNGRzZuawZf5hf10tr5jLKq8hu848?=
 =?us-ascii?Q?Ee9lcrAQY+LYeASDhAyCfK5oQ925CrEltg28ACXQp6BssAxwZUW+f0K0FaY5?=
 =?us-ascii?Q?uACWttC9+uWsqGAxqvYhMYcZZf4Ozph1dXhb+8N0QEzDgdLj8m6jq74t98Vx?=
 =?us-ascii?Q?CWNVw8/wrHQB02LOJWd5PniiD8FDuNg+MdBWXmUYzHuiMU8ZDdD3B/UygyhW?=
 =?us-ascii?Q?hl63N/zh+fGdZvEkUVBxc8QGSqt3OPQD7PZAzYJ7W0X3BRCli2mMBAtgbW40?=
 =?us-ascii?Q?g9foF/gXLf8EfL+goHa7uHHs7hMoSdxBeQZ9XdwGAC+Q65PvpgR054EMZM9a?=
 =?us-ascii?Q?+waPUsoHm6P+8BV26c0H3fiyjn38HjKU3v36MwyBY25nYLPfB/7SQirDn4ww?=
 =?us-ascii?Q?2VXPIEXy5ODu9VPadPduOSiU5dg4RHKWYLluoGkbyd5/fiSJOg1s06JzbxhD?=
 =?us-ascii?Q?m+a6D0A3Sz5WSEDKjvmHdCMfIvkav1J8Crm614+j8Qy44C++2iNxx9XN2slt?=
 =?us-ascii?Q?v68Tx+Uq7LVveOu1S6YGt31f5Y2VHJlm8Tkt4f1jvH4gj1VfzS5FlPULa8a4?=
 =?us-ascii?Q?dS17veaYQqG4bsJbg5NcR69czeb8mhx3lzNgtaikLP1X/z1qU8waenS3KH1F?=
 =?us-ascii?Q?avE3Fp+A768lx8QuVuS4SlAmPLa4WqyUhPdu4WqwTvTiWChaop/MbHjjwC0y?=
 =?us-ascii?Q?Yz4RiCsG689rNbFtB0Inx5ywKtnhAL9peT/vdPP4Hon7KnnaVFVzJA/1XVkb?=
 =?us-ascii?Q?vxtN1ELbdE4MMBwyIWFmAqvL5UeC2+XH1YYuFL3B91HYFng4yJhVhk4UKTlf?=
 =?us-ascii?Q?T3bWFlSYolZ7j0t9NBgRdmbTpUswofSwdtk+RGb13OHgT1SQTUSSnYqKuFBT?=
 =?us-ascii?Q?VmT92F+cP8G8yQrG5M+Ec/U1Cff4l3eIsADFNo2SjpoZavur28o3knLW/0ng?=
 =?us-ascii?Q?D9bnJcmyBT01NV6jenI3sMosxwItMOtCsFK+BkmUTvNzd7c0jCeMGX3EKsRu?=
 =?us-ascii?Q?XCbE2SIW94NRPw8hJN5kMiWYA+QNgXnqbLjddIUzny8Klps1mMtSYxOXRqlk?=
 =?us-ascii?Q?EdCuE7JYaERvwwi6Ww5PnMBBBnlzN5rO6YgTLwnZ1acyAgXAosAanlKs2Fhi?=
 =?us-ascii?Q?CW6TdnCBymZit6Jn3ck42cDgClSIlkLUiHTXIanxaTOJoOycP2Awd5cNGAcU?=
 =?us-ascii?Q?NMmCEzIiISxZ094ECyLa4lrl+411pRne8ciSmRzM/boBq3/ycwiWDzdnNGaD?=
 =?us-ascii?Q?OhCGRmDJfuYQQRqSHZZJgLI5oAVzEvUDtaZH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:42:40.9588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d37522-46d0-43b2-f85f-08ddea720656
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4284

The io_alloc feature in resctrl enables system software to configure
the portion of the cache allocated for I/O traffic.

Add "io_alloc_cbm" resctrl file to display the Capacity Bit Masks (CBMs)
that represent the portion of each cache instance allocated for I/O
traffic.

The CBM interface file io_alloc_cbm resides in the info directory (e.g.,
/sys/fs/resctrl/info/L3/). Since the resource name is part of the path, it
is not necessary to display the resource name as done in the schemata file.
Pass the resource name to show_doms() and print it only if the name is
valid. For io_alloc, pass NULL pointer to suppress printing the resource
name.

When CDP is enabled, io_alloc routes traffic using the highest CLOSID
associated with the L3CODE resource. To ensure consistent cache allocation
behavior, the L3CODE and L3DATA resources are kept in sync. So, the
Capacity Bit Masks (CBMs) accessed through either L3CODE or L3DATA will
reflect identical values.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v9: Updated the changelog with respect to CDP.
    Added code comment in resctrl_io_alloc_cbm_show().

v8: Updated the changelog.
    Moved resctrl_io_alloc_cbm_show() to fs/resctrl/ctrlmondata.c.
    show_doms is remains static with this change.

v7: Updated changelog.
    Updated use doc (resctrl.rst).
    Removed if (io_alloc_closid < 0) check. Not required anymore.

v6: Added "io_alloc_cbm" details in user doc resctrl.rst.
    Resource name is not printed in CBM now. Corrected the texts about it
    in resctrl.rst.

v5: Resolved conflicts due to recent resctrl FS/ARCH code restructure.
    Updated show_doms() to print the resource if only it is valid. Pass NULL while
    printing io_alloc CBM.
    Changed the code to access the CBMs via either L3CODE or L3DATA resources.

v4: Updated the change log.
    Added rdtgroup_mutex before rdt_last_cmd_puts().
    Returned -ENODEV when resource type is CDP_DATA.
    Kept the resource name while printing the CBM (L3:0=fff) that way
    I dont have to change show_doms() just for this feature and it is
    consistant across all the schemata display.

v3: Minor changes due to changes in resctrl_arch_get_io_alloc_enabled()
    and resctrl_io_alloc_closid_get().
    Added the check to verify CDP resource type.
    Updated the commit log.

v2: Fixed to display only on L3 resources.
    Added the locks while processing.
    Rename the displat to io_alloc_cbm (from sdciae_cmd).
---
 Documentation/filesystems/resctrl.rst | 19 +++++++++++
 fs/resctrl/ctrlmondata.c              | 45 +++++++++++++++++++++++++--
 fs/resctrl/internal.h                 |  3 ++
 fs/resctrl/rdtgroup.c                 | 11 ++++++-
 4 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 55e35db0c6de..15e3a4abf90e 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -174,6 +174,25 @@ related to allocation:
 		available for general (CPU) cache allocation for both the L3CODE and
 		L3DATA resources.
 
+"io_alloc_cbm":
+		CBMs(Capacity Bit Masks) that describe the portions of cache instances
+		to which I/O traffic from supported I/O devices are routed when "io_alloc"
+		is enabled.
+
+		CBMs are displayed in the following format:
+
+			<cache_id0>=<cbm>;<cache_id1>=<cbm>;...
+
+		Example::
+
+			# cat /sys/fs/resctrl/info/L3/io_alloc_cbm
+			0=ffff;1=ffff
+
+		When CDP is enabled "io_alloc_cbm" associated with the DATA and CODE
+		resources may reflect the same values. For example, values read from and
+		written to /sys/fs/resctrl/info/L3DATA/io_alloc_cbm may be reflected by
+		/sys/fs/resctrl/info/L3CODE/io_alloc_cbm and vice versa.
+
 Memory bandwidth(MB) subdirectory contains the following files
 with respect to allocation:
 
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 1f714301f79f..d1a54f6c4876 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -381,7 +381,8 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
-static void show_doms(struct seq_file *s, struct resctrl_schema *schema, int closid)
+static void show_doms(struct seq_file *s, struct resctrl_schema *schema,
+		      char *resource_name, int closid)
 {
 	struct rdt_resource *r = schema->res;
 	struct rdt_ctrl_domain *dom;
@@ -391,7 +392,8 @@ static void show_doms(struct seq_file *s, struct resctrl_schema *schema, int clo
 	/* Walking r->domains, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
-	seq_printf(s, "%*s:", max_name_width, schema->name);
+	if (resource_name)
+		seq_printf(s, "%*s:", max_name_width, resource_name);
 	list_for_each_entry(dom, &r->ctrl_domains, hdr.list) {
 		if (sep)
 			seq_puts(s, ";");
@@ -437,7 +439,7 @@ int rdtgroup_schemata_show(struct kernfs_open_file *of,
 			closid = rdtgrp->closid;
 			list_for_each_entry(schema, &resctrl_schema_all, list) {
 				if (closid < schema->num_closid)
-					show_doms(s, schema, closid);
+					show_doms(s, schema, schema->name, closid);
 			}
 		}
 	} else {
@@ -807,3 +809,40 @@ ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
 
 	return ret ?: nbytes;
 }
+
+int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq, void *v)
+{
+	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
+	struct rdt_resource *r = s->res;
+	int ret = 0;
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
+	rdt_last_cmd_clear();
+
+	if (!r->cache.io_alloc_capable) {
+		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	if (!resctrl_arch_get_io_alloc_enabled(r)) {
+		rdt_last_cmd_printf("io_alloc is not enabled on %s\n", s->name);
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/*
+	 * When CDP is enabled, resctrl_io_alloc_init_cbm() sets the same CBM for
+	 * both L3CODE and L3DATA of the highest CLOSID. As a result, the io_alloc
+	 * CBMs shown for either CDP resource are identical and accurately represent
+	 * the CBMs used for I/O.
+	 */
+	show_doms(seq, s, NULL, resctrl_io_alloc_closid(r));
+
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+	return ret;
+}
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 335def7af1f6..49934cd3dc40 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -389,6 +389,9 @@ enum resctrl_conf_type resctrl_peer_type(enum resctrl_conf_type my_type);
 ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
 			       size_t nbytes, loff_t off);
 
+int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq,
+			      void *v);
+
 const char *rdtgroup_name_by_closid(int closid);
 
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ebf56782ed63..71003328fdda 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1917,6 +1917,12 @@ static struct rftype res_common_files[] = {
 		.seq_show	= resctrl_io_alloc_show,
 		.write          = resctrl_io_alloc_write,
 	},
+	{
+		.name		= "io_alloc_cbm",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= resctrl_io_alloc_cbm_show,
+	},
 	{
 		.name		= "max_threshold_occupancy",
 		.mode		= 0644,
@@ -2095,9 +2101,12 @@ static void io_alloc_init(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 
-	if (r->cache.io_alloc_capable)
+	if (r->cache.io_alloc_capable) {
 		resctrl_file_fflags_init("io_alloc", RFTYPE_CTRL_INFO |
 					 RFTYPE_RES_CACHE);
+		resctrl_file_fflags_init("io_alloc_cbm",
+					 RFTYPE_CTRL_INFO | RFTYPE_RES_CACHE);
+	}
 }
 
 void resctrl_file_fflags_init(const char *config, unsigned long fflags)
-- 
2.34.1


