Return-Path: <kvm+bounces-56942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E1DAB465FC
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC5B178806
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805BA305E20;
	Fri,  5 Sep 2025 21:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iqQXsKFr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2085.outbound.protection.outlook.com [40.107.100.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF0A30595D;
	Fri,  5 Sep 2025 21:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108395; cv=fail; b=ok6uqBnpT4QnzsOt1H89N4Qsh3yFIl1nbWJSFzzKw4zTHmwK96g27ko2w1tUpylZ6f3f7CkBmcOiFLnsWC1SeIGLhUmXh7/iFDRVCwmndl4AoJhTCnsoHyIIuNwjNKJ6yypFIdIfbQv3NhzbIB4oDQ7fN5cGhUkPK0DATI3wB2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108395; c=relaxed/simple;
	bh=ZjzVIMWbrwlZ85pzgGoAWEFtQSQNHYaD/+E84mviNf8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dPWeFFvOLV5vVfav/ExPDBXjJ++jrQOSyVgmE4LxQKVgS0rjUPA3XtWe1vcrUwdx9NEtxyv+49UnOsviBVjnGEV3LC2Mk/5XBJqy0Zu0W34aUSC4+R+xYnWtlGXIpdqflzQFOmbLECf2lYsLcLDgWMMF4iGiRToecKhZObg25HM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iqQXsKFr; arc=fail smtp.client-ip=40.107.100.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQBq6wunRToQEr3w/ubJdT0xdjUXgIFsb79AWAfoncSdH4xOjgHxVLZOiqEGT6dstX7kTYb5Ptg0Zn9+Iw+JvSz2ZKtVB6VUxgZ8yQO06bCB/6l0sY5fwZ88V/AECuHW2PNnC9AbiX67cMAFjUYzKN4GvAP2OCUqh3BIyLl7Sznb5UvXhe48oGGJPGWEqjiQP+YnGy1x49v6Ly1AGHkAaykExJKW7PMmVJf8hVWNyOm6CPCIaKbisQS70UoGk5bFPdMCo3kDFn4xKXSEiy2OigzZLgbNhvrN6imr1nzovGV4COGNUva4KfSTvswOUmwzcfCZYC1rY3FtTUdDlSbjBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EykpIDBQU2ocgxcFmGnzapAUq7hZkcbeG4kYlGMjuqo=;
 b=kPIodea6bevuCYG2Bpa4uofre3OckN1MT29aCCaLBdfjR/sjUxdK+Pgud0C/LpmMo1e6MANbzw7zgHf0f28kWZRRUlmcWG/LHbyK+YxYucIxBb6kimkryJT7CePqfzTbaKgJ7V8SRW2fasydBzSgEQdyA/iP9t77iHPMewvK9WPiVsvgoYi/x4jjkgtkjIOjxKFGxGXzKhxFMQ8iljso362unpxbeiSc6osj0qDAPNjR8heBkcsO4McDFuRrofO9J9baaSi/62KuijVJcZRgN2F3axZHY4fL8SSFATZpmXGw1NvuJk2v1KR+R3VPriCObqHW/cEpNk5Zc+Vq2zv7Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EykpIDBQU2ocgxcFmGnzapAUq7hZkcbeG4kYlGMjuqo=;
 b=iqQXsKFrHs6hHBEtiyKDo062xbao4ByM9KbGoXv959WmhWn/Uqox5Gnbw4kRJWGqrejlQ0wpcq7vZdk+/vUuwymg5YFBDT1OQv2FJjnes7NPE7NaCRWq5diWeVawv2706XH5jE4sJn0/+GaJ3uva8vxTwZbrRECVYg4OVVszRXQ=
Received: from DS7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::22) by
 PH7PR12MB6694.namprd12.prod.outlook.com (2603:10b6:510:1b1::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Fri, 5 Sep 2025 21:39:47 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:8:2e:cafe::9) by DS7P222CA0013.outlook.office365.com
 (2603:10b6:8:2e::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.18 via Frontend Transport; Fri,
 5 Sep 2025 21:39:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:39:47 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:39:46 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:39:44 -0700
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
Subject: [PATCH v18 30/33] fs/resctrl: Disable BMEC event configuration when mbm_event mode is enabled
Date: Fri, 5 Sep 2025 16:34:29 -0500
Message-ID: <70cdd1e86129266844ebabafd9a31bb0a253b07d.1757108044.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1757108044.git.babu.moger@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|PH7PR12MB6694:EE_
X-MS-Office365-Filtering-Correlation-Id: 264e6165-129d-4701-d802-08ddecc4bc27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WFNweDRhQ1luUmVDOWcraTcrY3ZCTmxQK0VXbFdqRDlwSkxnTWtQQUxnSlg1?=
 =?utf-8?B?VWVyWWZSS3dzNUFXbGkrVUN3VEVZVFk4a0wzTXgrZzdwNWZRMUg3Y09HTGZp?=
 =?utf-8?B?ZDE0WSt6dnVEMERaOTlrbGVMeGc3YjUzYkFyTVY0dU5zTTA1blRaVEdJOXdS?=
 =?utf-8?B?VllPUDRrbXlsVXFrbmpZeEhPeFVzbUVaZHdENnFWNnVhU0JCOVJhS1pEZURx?=
 =?utf-8?B?d0s1REZqUXF0YnZ0Kzd5SDlMNGRUSDZSVnZHZnVBVXkvcmo5bUJmWjVxTFVR?=
 =?utf-8?B?andWQ2lTdjdtZkRBTXRyczlvaUc4NEdGRmdJUmE4NFdoT0FPUmx1aEFVcHhH?=
 =?utf-8?B?dzBHVDkyWTB3ZUZkTGZLUnU0Um81RkdUc3M0ODR2SGd2U04rbVIyYS9KZjFq?=
 =?utf-8?B?QUlhbkpNczB6UjdtZmUwWitqT0w2dGZOOFc3R2tTMUNVUHRlSVJ1OFlEQXpJ?=
 =?utf-8?B?aWlucmM4Y1h6ZUhHaFFLaUdGMkt1T3FoOFZMRGdESFh6enNSN21Vd0loVFFm?=
 =?utf-8?B?MmYrNUJGZis5M1I3d1dFN0lvZFdIVzRzVk5kY2xWc05QNVBDVkpMTUtKeGo1?=
 =?utf-8?B?TDJOSUZZdXVOWjFyRktJdjdPU2t1QUh4WXM2Qm5TVlovckdFMnNrQzBCY1R6?=
 =?utf-8?B?NFlxc3Jvd3Y4NGhzTmdzcFhVZTZaRHR5MS9yWXovVTBlT3VpM0Z3MjgxNnRz?=
 =?utf-8?B?SFJVc3c2cURWdWtQZ1ZTNGpoZUlHK1JQVFRRcndCa0pTZWowLzFtUmE4bXU3?=
 =?utf-8?B?NlU4MGc3dHcreGo5Yk1ORlpVUHZaaSt6MXBxeElERUVOVFVDT3NLUlpaV0Fj?=
 =?utf-8?B?NzZ2OVRURjhaOFRFVXFlY3pTVDBydng3dGhxUDNRc3RVd1VvNWlpcFBPNjl5?=
 =?utf-8?B?WnpSaWFFTzV3WGJ1WnBaNlZlTWhnaEl6VlJHdmFPYUUwalc4QS9kS3JyOGY3?=
 =?utf-8?B?YSs1b0lGSmtDQWo5UXRXU1Q2UzBzQlpzWkhPVGFXWUkrd1VaeHd1d0xnTlcv?=
 =?utf-8?B?ZjltWkFIUEhkUFRHMWkvVTlacnpkcUNkb2hBZUJrQlpNbkdiTDl5WmpwaTlt?=
 =?utf-8?B?NnR5U3lZNjVZK0JCdGRRZTBFdjRMSGdCRVA3MFB6akJzYWlFWkhrWHpNOWJQ?=
 =?utf-8?B?OU5rdHhRVWFWMEs3dG5oWERQVEFXeThWdWJ2SGRFUVFLM3hCdHFMZmZsT0lL?=
 =?utf-8?B?aXBiN2dmNGFPb1RySTgrZFdJd3llSk9hY0UrZy9UMDQ0TzVYRmsrM0RHbXFy?=
 =?utf-8?B?RDErTzE3RzR3T0Jyd2RSQ0hNakhJdlVvSTlqWXNnK0dOS01YVFNSZFJxWDFu?=
 =?utf-8?B?TndING1tR3R6Y0pXTUNjTFpjOGZHQmI3M1lqVHpmWlBja2paVEl1TitSV20x?=
 =?utf-8?B?Qk5qSkk4TGFTWnFqVFRWL3JwNDFkbG01MkxqbTUzWEVxb3FISzdFbyt6c2tK?=
 =?utf-8?B?cnkxU1gxVGRUYzE1Q0s3d2FHN2c4cFgwUmo0eUZGb0NMNjVxZFVVdGNVb1ZQ?=
 =?utf-8?B?eUpCUXNlQ0laamIyUy84L3B5V05pRHpsZ2wzTGVSYkhvM1daZHV5OVdseEdw?=
 =?utf-8?B?ZlpWRVNDYk81TzJZWGx6bHhQTG0zL0ZKVStPMjM5bkZzWFVtN2QzaHhmSTdN?=
 =?utf-8?B?bmdXTjNlVCtjM3ZVSTlIY2p4MHVOV0lVZlA1dFFyUXBESU1iWWIzKzkyZ3Nz?=
 =?utf-8?B?aG5VOWRuT05QbnJRVXJQZG4wY1JxSU8zNTBCZ0s1djRYOElxNlUrVWkyL2V1?=
 =?utf-8?B?bE9qOWdKa096YkF0dHpwaGxFUEM3dzBhUm1qdWJMZmdwOTNyVXBGSWNSYWpa?=
 =?utf-8?B?Q0lCeTlJSERDeDlxZlhVdkNKUnQ0cG50SU4rWDlvSkQ3RyswV2svNTlGcUl6?=
 =?utf-8?B?bHVUTTZYRE00ZXErbWQzR2thejE5UGdPN0dHYXhrWTdjQU43bEJvbVVzMjVo?=
 =?utf-8?B?TTlaMDRqN01rNHZmK1RUNXlPT0FyRzJmNnRUbEFmS2o5bmZ6ZXVybUVIVVE0?=
 =?utf-8?B?anBvS05NcHp2ZWlWUGhEVDhWZ2c5VC9leU04bW4rZ3RVb0lnbjlSL2V6MlJM?=
 =?utf-8?Q?UdCjU1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:39:47.0138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 264e6165-129d-4701-d802-08ddecc4bc27
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6694

The BMEC (Bandwidth Monitoring Event Configuration) feature enables
per-domain event configuration. With BMEC the MBM events are configured
using the mbm_total_bytes_config or mbm_local_bytes_config files in
/sys/fs/resctrl/info/L3_MON/ and the per-domain event configuration affects
all monitor resource groups.

The mbm_event counter assignment mode enables counters to be assigned to
RMID (i.e a monitor resource group), event pairs, with potentially unique
event configurations associated with every counter.

There may be systems that support both BMEC and mbm_event counter
assignment mode, but resctrl supporting both concurrently will present a
conflicting interface to the user with both per-domain and per RMID, event
configurations active at the same time.

The mbm_event counter assignment provides most flexibility to user space
and aligns with Arm's counter support. On systems that support both,
disable BMEC event configuration when mbm_event mode is enabled by hiding
the mbm_total_bytes_config or mbm_local_bytes_config files when mbm_event
mode is enabled. Ensure mon_features always displays accurate information
about monitor features.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Fixed the extra reference release in resctrl_bmec_files_show().

v16: Added new comment in resctrl_bmec_files_show() about kernfs_find_and_get failure.
     Added the parameter to resctrl_bmec_files_show() to pass the kernfs_node.

v15: Updated the changelog.
     Moved resctrl_bmec_files_show() inside rdtgroup_mkdir_info_resdir().
     Removed the unnecessary kernfs_get() call.

v14: Updated the changelog for change in mbm_assign_modes.
     Added check in rdt_mon_features_show to hide bmec related feature.

v13: New patch to hide BMEC related files.
---
 fs/resctrl/rdtgroup.c | 47 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index bd4a115ffea1..0c404a159d45 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1150,7 +1150,8 @@ static int rdt_mon_features_show(struct kernfs_open_file *of,
 		if (mevt->rid != r->rid || !mevt->enabled)
 			continue;
 		seq_printf(seq, "%s\n", mevt->name);
-		if (mevt->configurable)
+		if (mevt->configurable &&
+		    !resctrl_arch_mbm_cntr_assign_enabled(r))
 			seq_printf(seq, "%s_config\n", mevt->name);
 	}
 
@@ -1799,6 +1800,44 @@ static ssize_t mbm_local_bytes_config_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
+/*
+ * resctrl_bmec_files_show() — Controls the visibility of BMEC-related resctrl
+ * files. When @show is true, the files are displayed; when false, the files
+ * are hidden.
+ * Don't treat kernfs_find_and_get failure as an error, since this function may
+ * be called regardless of whether BMEC is supported or the event is enabled.
+ */
+static void resctrl_bmec_files_show(struct rdt_resource *r, struct kernfs_node *l3_mon_kn,
+				    bool show)
+{
+	struct kernfs_node *kn_config, *mon_kn = NULL;
+	char name[32];
+
+	if (!l3_mon_kn) {
+		sprintf(name, "%s_MON", r->name);
+		mon_kn = kernfs_find_and_get(kn_info, name);
+		if (!mon_kn)
+			return;
+		l3_mon_kn = mon_kn;
+	}
+
+	kn_config = kernfs_find_and_get(l3_mon_kn, "mbm_total_bytes_config");
+	if (kn_config) {
+		kernfs_show(kn_config, show);
+		kernfs_put(kn_config);
+	}
+
+	kn_config = kernfs_find_and_get(l3_mon_kn, "mbm_local_bytes_config");
+	if (kn_config) {
+		kernfs_show(kn_config, show);
+		kernfs_put(kn_config);
+	}
+
+	/* Release the reference only if it was acquired */
+	if (mon_kn)
+		kernfs_put(mon_kn);
+}
+
 /* rdtgroup information files for one cache resource. */
 static struct rftype res_common_files[] = {
 	{
@@ -2267,6 +2306,12 @@ static int rdtgroup_mkdir_info_resdir(void *priv, char *name,
 			ret = resctrl_mkdir_event_configs(r, kn_subdir);
 			if (ret)
 				return ret;
+			/*
+			 * Hide BMEC related files if mbm_event mode
+			 * is enabled.
+			 */
+			if (resctrl_arch_mbm_cntr_assign_enabled(r))
+				resctrl_bmec_files_show(r, kn_subdir, false);
 		}
 	}
 
-- 
2.34.1


