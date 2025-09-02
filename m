Return-Path: <kvm+bounces-56643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F90CB41030
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:43:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBC777B5A16
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FFF52E11DC;
	Tue,  2 Sep 2025 22:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bTFLGXkP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07C72773CB;
	Tue,  2 Sep 2025 22:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852948; cv=fail; b=snZug78LI6duus52gIDFd8MroTLTCbUpEqDMttZkwRewc+HcvY7RocUa5EvTiJ8CIhMIV83KZ/d84eDf2SspwCrdSRNr4nhNoR2DFb6aVAyytcWzIw0qUN5Ahm8Q5Pctx1DSM/FHjcWrZkMG5i0QL5vcQHDjKXGVOTDTPc6hFCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852948; c=relaxed/simple;
	bh=LT7JgeZ2Utew8gsGC2/uvx7CYpTbFebLH22iQmQmgN8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a/VWSIoWs66yImutujmJFqBz727u7EL5gw7c4YYkSa/v19268unedWkbtszu2eZVqeGXfvS0e0m4f4f2SM4bX1Q20SDrw0o0gaz26e95RweIC3nNdSs4O9g3gtXRVdOTSgzUFiVjWYgCFzmZRvj1KayO9ZWo7aDHtgNvsyrwODw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bTFLGXkP; arc=fail smtp.client-ip=40.107.92.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LlpqbS6b20sxxXnZbsXY4wUQCfcCXGXCcgfQtdZjQarjv7VqHYgJtNgRKKiR4Edp9lv1zqyo3Z0ZFX1BsOekpMk3vmP7TvTYfteZO4c8AGN6WIMyZ5LHBp18ftdnw7a8BWqDAltCzzg2zcL41VZD4NuNQ3QzOua4HZoBwL20MsQPSoGD5pux++7HDqgKatXNoaHd8O60Z8XPob/bUViyymYwnal0VdrZ7qFtynjf20907NrVUXt+tPYyZwl2740gGXWQWI9aD8wCerHtbbr1e/qOgbFLRQ2TAZE7dVsZY+AfKwQDQpToVwb11ulqgd+8J6vxa+cH8hJaguqzTSbheg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eI5olHTJWv2iRYdVrVP3RAGVNn9PDSt68wKuv2KNcwY=;
 b=p2NtoYxGPeftUD2YavkPbkFnfHCfhRzVFrCSi9HtGhWD2kNE7EIJvChhScaQsozAGMLJ0fcGPCDqHnErxCxR/v9rDqNcVpSTt37kUD/vG7liftnhqLt6PBu4a4zjfgZLrOfjxIMdpjYAIfzSfmbRAfRyMny16C23lEoq1H9oo1ccvOQrPZldsYXqQHl+swSYkJKKHBz39vO+b9ktQSMup6Rb1/e4hh0Nnx+qkUk07YAk5PN4idRisd4cZT6FbzBfjvejEr52T5YNf33qAvyRjarpkv9jDDIBJxC3EwOoDXgtXI1o7L//cvjOc5I7Wff9fEYHP12U+rmvIxMKaxxY/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eI5olHTJWv2iRYdVrVP3RAGVNn9PDSt68wKuv2KNcwY=;
 b=bTFLGXkPHNDptpa7f1ufRXN6nSVRR6iVeRYzKiHKLTHQ0HYgaThEXSMvfpor82JHhY/hMqga+er/mecSPBbtN6pZXqjws3AD+R1mkeSsr2wXxfkB9lMfhzUNO0hc+wTvKD9H1M2NtB9Z7UOw4iUZWlubVW+XTUOBh2tBvNIDJ6A=
Received: from MN2PR22CA0014.namprd22.prod.outlook.com (2603:10b6:208:238::19)
 by LV8PR12MB9667.namprd12.prod.outlook.com (2603:10b6:408:297::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 22:42:24 +0000
Received: from BN2PEPF00004FC1.namprd04.prod.outlook.com
 (2603:10b6:208:238:cafe::83) by MN2PR22CA0014.outlook.office365.com
 (2603:10b6:208:238::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Tue,
 2 Sep 2025 22:42:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FC1.mail.protection.outlook.com (10.167.243.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:42:23 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:42:23 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:42:21 -0700
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
Subject: [PATCH v9 05/10] fs/resctrl: Introduce interface to display "io_alloc" support
Date: Tue, 2 Sep 2025 17:41:27 -0500
Message-ID: <5f368e4f65629c5bf377466e9004733b625c5807.1756851697.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC1:EE_|LV8PR12MB9667:EE_
X-MS-Office365-Filtering-Correlation-Id: b1aad7f7-a3ae-4b4b-d406-08ddea71fc0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jnhMbOSt9+9/BtjclCeSjKT6uKbv1vWcegd4+ZUYnokJjlXBCfIncB1wpcfm?=
 =?us-ascii?Q?CHE5FbMuu1Tr4gOkF+8cK3y+XHCRornKn/o1Ykf3gg+If9CBM4IbpBqzrbUy?=
 =?us-ascii?Q?pdhatVt2JWg8Ffh7r4X8chWlkPVng4HwTU/FSHJiW9ch1+yxk1ABH780cWk8?=
 =?us-ascii?Q?j4XlikpvYPirpCZz9AHShf5i8pwywzCSMV1cy+urIp9E1GmBv/2Fn+IJHCl4?=
 =?us-ascii?Q?p5PCZNWbQe0Pz1WmH0qzeFsmQRQRVlxcokZiVlAwYxP8CIFPAA03poajsmNG?=
 =?us-ascii?Q?KwIG8Or/l+1ViF7/cO3fcU5elNXt69va9KM5lb4/YqzMzx6O00rwpp88YKz6?=
 =?us-ascii?Q?Xt5KxXmwgzAAxUEx0BPixphuHRNzO8ybeO7eFb8CIER+hVOVYgaVoVoDRZOC?=
 =?us-ascii?Q?GNWJhfj8pAMSUo+4PtNYzMWGjUtCf4OqIwkSxtbjwGdjwRI1FB581E5CqePV?=
 =?us-ascii?Q?tc63Oc1sN2T45XDrVPfQJ2hw65GzD+X0gj9A5p75j0RdHM06gsMP1bI0oyef?=
 =?us-ascii?Q?7OQCaOwXzIcgmwqNGLBS1iSevO1uHdU9B5h+Bp9wPRk/Kxdp0P7TjxqkIaco?=
 =?us-ascii?Q?+J4SU0aiPVCTI0NOHXqJoeqAnP7QCbr5gndK9HOw2TTnPuO9svYYscS9qL1X?=
 =?us-ascii?Q?hkPyl4xFsz0Ga1F1GUiMcS3M3uX1n79tCOASb5xmnvdOvNPLm93PRHJFLwnG?=
 =?us-ascii?Q?zdO9zIQ8bqpQNYOE9HnjK5XctiBRPZ0c9Mk2ELkwtWfsos57fdYBzfrvterd?=
 =?us-ascii?Q?Ul6+5rBsFys7P5/jJUEeAN36O3U/XV/rIPiCsZKh8EKWa6mWAKAsreD/Pq7I?=
 =?us-ascii?Q?hUAJhMsKqUZ5MEtmX2F+BrGoXl2lyRSP6R/dmCP09Sk3nOGUdUrWrqg4USCT?=
 =?us-ascii?Q?D8B2t0M8vU1rFP5gFb0mjsGilDSujgBlogoXpeMJ5Da8uBO1H9hNe0TU/a5J?=
 =?us-ascii?Q?bKLPTtiZiRwtiXkt5sy1OtqDixwYDHL/x5feuU0KAThL8+owIdMOSxioazQP?=
 =?us-ascii?Q?3u0I81xP7To9pingan0Z67VVuP03LLaB8NN4EsTYXqU0vy69YXtvq50vchiC?=
 =?us-ascii?Q?qrXADUSN5HCnptYWd1TaChAbVyZtAAP6haux2seZDu8E1UbkBSC+Z9JR3O6w?=
 =?us-ascii?Q?Gac900BFewpYH0csnjqg94kF+sz+y3o5iOaZmdyjjM4cYIh+0AxSZZGunWY+?=
 =?us-ascii?Q?3AIKpP2RGpiEnjMpUuvMy+hnte0jx7clae1yrLZVemYRm7l1ECzLa/99SqmA?=
 =?us-ascii?Q?7x96hJn3wuG79kRKFhuLEgHtkXHI86Qfsp1vves75J01ey7j4pBUb6vPuKAi?=
 =?us-ascii?Q?MbGOE3oA3S1rd7RCDvMK2AM7yw0ohNA/T1dKoEaSZUtTwGMOrJ2CpDRSm8ut?=
 =?us-ascii?Q?TeLaaHMcwHDdRrCb0vTSyA9b1Cy5vF60+yEJ67T32wgy5JTopMXhakexwIPw?=
 =?us-ascii?Q?85MzX2o9o0Ae5LGeAGbq01I5245lixpZZepy3kEr0pXy+uXpcAmD6yqQQ8fB?=
 =?us-ascii?Q?15P12IVuXlb4WPvU8/peV2LA9+6TPgqO3Fb4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:42:23.7020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1aad7f7-a3ae-4b4b-d406-08ddea71fc0d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9667

"io_alloc" feature in resctrl allows direct insertion of data from I/O
devices into the cache.

Introduce the 'io_alloc' resctrl file to indicate the support for the
feature.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v9: Minor user doc(resctrl.rst) update.

v8: Updated Documentation/filesystems/resctrl.rst.
    Moved resctrl_io_alloc_show() to fs/resctrl/ctrlmondata.c.
    Added prototype for rdt_kn_parent_priv() in fs/resctrl/internal.h
    so, it can be uses in other fs/resctrl/ files.
    Added comment for io_alloc_init().

v7: Updated the changelog.
    Updated user doc for io_alloc in resctrl.rst.
    Added mutex rdtgroup_mutex in resctrl_io_alloc_show();

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
 Documentation/filesystems/resctrl.rst | 30 +++++++++++++++++++++++++++
 fs/resctrl/ctrlmondata.c              | 21 +++++++++++++++++++
 fs/resctrl/internal.h                 |  5 +++++
 fs/resctrl/rdtgroup.c                 | 24 ++++++++++++++++++++-
 4 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 4866a8a4189f..89aab17b00cb 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -136,6 +136,36 @@ related to allocation:
 			"1":
 			      Non-contiguous 1s value in CBM is supported.
 
+"io_alloc":
+		"io_alloc" enables system software to configure the portion of
+		the cache allocated for I/O traffic. File may only exist if the
+		system supports this feature on some of its cache resources.
+
+			"disabled":
+			      Resource supports "io_alloc" but the feature is disabled.
+			      Portions of cache used for allocation of I/O traffic cannot
+			      be configured.
+			"enabled":
+			      Portions of cache used for allocation of I/O traffic
+			      can be configured using "io_alloc_cbm".
+			"not supported":
+			      Support not available for this resource.
+
+		The underlying implementation may reduce resources available to
+		general (CPU) cache allocation. See architecture specific notes
+		below. Depending on usage requirements the feature can be enabled
+		or disabled.
+
+		On AMD systems, io_alloc feature is supported by the L3 Smart
+		Data Cache Injection Allocation Enforcement (SDCIAE). The CLOSID for
+		io_alloc is the highest CLOSID supported by the resource. When
+		io_alloc is enabled, the highest CLOSID is dedicated to io_alloc and
+		no longer available for general (CPU) cache allocation. When CDP is
+		enabled, io_alloc routes I/O traffic using the highest CLOSID allocated
+		for the instruction cache (L3CODE), making this CLOSID no longer
+		available for general (CPU) cache allocation for both the L3CODE and
+		L3DATA resources.
+
 Memory bandwidth(MB) subdirectory contains the following files
 with respect to allocation:
 
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index d98e0d2de09f..d495a5d5c9d5 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -664,3 +664,24 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	rdtgroup_kn_unlock(of->kn);
 	return ret;
 }
+
+int resctrl_io_alloc_show(struct kernfs_open_file *of, struct seq_file *seq, void *v)
+{
+	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
+	struct rdt_resource *r = s->res;
+
+	mutex_lock(&rdtgroup_mutex);
+
+	if (r->cache.io_alloc_capable) {
+		if (resctrl_arch_get_io_alloc_enabled(r))
+			seq_puts(seq, "enabled\n");
+		else
+			seq_puts(seq, "disabled\n");
+	} else {
+		seq_puts(seq, "not supported\n");
+	}
+
+	mutex_unlock(&rdtgroup_mutex);
+
+	return 0;
+}
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 0a1eedba2b03..1a4543c2b988 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -375,6 +375,11 @@ bool closid_allocated(unsigned int closid);
 
 int resctrl_find_cleanest_closid(void);
 
+int resctrl_io_alloc_show(struct kernfs_open_file *of, struct seq_file *seq,
+			  void *v);
+
+void *rdt_kn_parent_priv(struct kernfs_node *kn);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5f0b7cfa1cc2..41ce2be4b2cb 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -981,7 +981,7 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
 	return 0;
 }
 
-static void *rdt_kn_parent_priv(struct kernfs_node *kn)
+void *rdt_kn_parent_priv(struct kernfs_node *kn)
 {
 	/*
 	 * The parent pointer is only valid within RCU section since it can be
@@ -1893,6 +1893,12 @@ static struct rftype res_common_files[] = {
 		.kf_ops		= &rdtgroup_kf_single_ops,
 		.seq_show	= rdt_thread_throttle_mode_show,
 	},
+	{
+		.name		= "io_alloc",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= resctrl_io_alloc_show,
+	},
 	{
 		.name		= "max_threshold_occupancy",
 		.mode		= 0644,
@@ -2062,6 +2068,20 @@ static void thread_throttle_mode_init(void)
 				 RFTYPE_CTRL_INFO | RFTYPE_RES_MB);
 }
 
+/*
+ * The resctrl file "io_alloc" is added using L3 resource. However, it results
+ * in this file being visible for *all* cache resources (eg. L2 cache),
+ * whether it supports "io_alloc" or not.
+ */
+static void io_alloc_init(void)
+{
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+
+	if (r->cache.io_alloc_capable)
+		resctrl_file_fflags_init("io_alloc", RFTYPE_CTRL_INFO |
+					 RFTYPE_RES_CACHE);
+}
+
 void resctrl_file_fflags_init(const char *config, unsigned long fflags)
 {
 	struct rftype *rft;
@@ -4246,6 +4266,8 @@ int resctrl_init(void)
 
 	thread_throttle_mode_init();
 
+	io_alloc_init();
+
 	ret = resctrl_mon_resource_init();
 	if (ret)
 		return ret;
-- 
2.34.1


