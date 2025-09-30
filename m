Return-Path: <kvm+bounces-59225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51244BAE883
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 22:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF6791C67DF
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 20:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135072571A1;
	Tue, 30 Sep 2025 20:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vDRXq3TX"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010055.outbound.protection.outlook.com [52.101.61.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF7C2405ED;
	Tue, 30 Sep 2025 20:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759263993; cv=fail; b=eG7tQzFNV1+rhKeRMknoUSndCyWuywbqqljHg3mbJHxIJEzqpgn6JdJ+EHMgA2vrcNoyat7UA4QbQC2THTSrRK85Lp/5N8dJLzeMp6u0GwuV2et0svOS9DCmknkoXuVHHZhoBxWGlnAoqcuBDQNn2OtgqITwOdqQMMhOn2nQL9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759263993; c=relaxed/simple;
	bh=KRUpiadyDqMXyRjc/HPj5mx5f9H8YYkwd0Sq5eMDf4U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FklUWK5kyqnUxGh/Z62n5J33KiTSDcez3+SYo0wM55moJpAl0YZg4or8OAurtRY+LKd8SXCdIi2RoFhQKOWFPErFarMKjY3hJA21ephpDok69dFK30TG2bu38tLrbGAZRgSGAydiIMeALYEsv4/+e1JKsn6zS3BiVs/pUDHAnqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vDRXq3TX; arc=fail smtp.client-ip=52.101.61.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zATCf1UzrcUpGNFqGP8sWthddqQqfyTCiEuhTT3+6xtfk8aOCVjL76C4ptIqJSUlaUEmT1LvShbRJF/l6TNKXBhrroIJbwWUGhQWRwL6yrp1NwvSQFIor3NgHDQJDJmTs123NgV/8+pT8y+20AHfXys6xSoaIfOSJhbyKWjLdcSQK2dtuhQ/uv4ul8/hbfOaAiALh7/ppSVVIIR98usn0vkGhIZinyICsq+f4Wu/bH8+yIcSPe443TF/rURGK5z0FXeP14FsLCte1MWzZDT1PKelRnXYFyX/+MEG3LvumZLjQeYgf1LBbMO41y6mfbmGCXSY5hdnHfQGGvWy83iPsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Llyey2Z/XTy4m6lvHA4QNP6i1eo507saXZNbEJgcl24=;
 b=xH1N1h9Z/xY1FIPQa1JEMr+3dHZrXAH3mAGvVJMmqJHZbaTrW2gsEjinzVhAdSe5AjiD6wmmxce6mt3OijSwppP9zSMCzUWXsChsqcfm4fl5vWViGQ4Wkf0v+YxsBXzOArVQcIVF9iR9XGNK8bjFNd4KJIhjPKOpqIBDbKhaaguIjQs+WMhkjuZxlkDIUE2lkH5G1NC7L4agMyV7yg4Asrh+KjGnB/ou9LLsIZs/sRBfH9us/BLD9XvOmVLqtMOmduPXAjqzptmFO9SBE5MpVJZsJzm3hnsSbjcTvN87/R5rcS9JMovQ7FcORyzkYuUKl9IRnz0jJMDk39VRTybq1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Llyey2Z/XTy4m6lvHA4QNP6i1eo507saXZNbEJgcl24=;
 b=vDRXq3TXeAtD1UlhrkCfGhNeARsofmgBrm0WqwRQ72t86Im0z0EmlqyjacjqtC6N37rQa8WFFJy987A6d7SygRQzXzlnrqQeY3QfMka50npGP24vwMDB/jcPz5p8he5BIuDotHrDjM79ERmKIeNYJJZIMhBjPGV9j0Y04itRTqc=
Received: from SJ0PR13CA0100.namprd13.prod.outlook.com (2603:10b6:a03:2c5::15)
 by IA1PR12MB6186.namprd12.prod.outlook.com (2603:10b6:208:3e6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 20:26:26 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::62) by SJ0PR13CA0100.outlook.office365.com
 (2603:10b6:a03:2c5::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.13 via Frontend Transport; Tue,
 30 Sep 2025 20:26:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Tue, 30 Sep 2025 20:26:25 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 30 Sep
 2025 13:26:23 -0700
From: Babu Moger <babu.moger@amd.com>
To: <tony.luck@intel.com>, <reinette.chatre@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <dave.hansen@linux.intel.com>, <bp@alien8.de>
CC: <babu.moger@amd.com>, <kas@kernel.org>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
Subject: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled in mbm_event mode
Date: Tue, 30 Sep 2025 15:26:17 -0500
Message-ID: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|IA1PR12MB6186:EE_
X-MS-Office365-Filtering-Correlation-Id: 7471d42b-6af1-41bb-3810-08de005fa0ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pb7xeLjMrgTSC0ubb5G7fypcwU/KBkKorePkU03VcPPAM0iBsT7FbDCnpPx2?=
 =?us-ascii?Q?YjFVBuEYOpTdcEFZTs4lKLTTSGYOC2m/YiqaLXKXbkEW2Xc1htZn3P93vllH?=
 =?us-ascii?Q?lozJVkXwvzllf75ZHCX7lCy6EwDhpNz/vnTZyY2L2YAY/SRuOsDHxzJNIqYJ?=
 =?us-ascii?Q?e/87uJkAZqLpaz1O22CnbwJhlqvLhG68m9BVugzkYIGdFhiJbgOwVPQnIbzu?=
 =?us-ascii?Q?8Zn0bNQdF/Kvdqf70B2msEK9cfnNn3tyZo4J27XJpueLCtaRA5lV82rOQv3p?=
 =?us-ascii?Q?jvQb5ZyttAwxa4rhCthIJicXjzWoUVIX6qOos+E43OTyypOQw1gwBXPeYlPM?=
 =?us-ascii?Q?/uzq/L7xVfhxvR+1Sw/MzC7Pwva3MsDyC0lyczghcZKSjRre0Su1Edxg9F9t?=
 =?us-ascii?Q?mHWF6IuzOmzRVkYmfAiUi88MuFLWJjCCO7Xr0aqlwV3A3kKErUuSQAlPaX5m?=
 =?us-ascii?Q?W7UOzqLifjMlAyAdIypMn3XlgS0IYZz0+l7+uKyyrf/mbSra/p28MMSQeUVz?=
 =?us-ascii?Q?aYObajV9eLqCm7ZwZifNH41mi60tIuzF7x3a19K02taIQB8c69rc1rQzLDis?=
 =?us-ascii?Q?lIeczrr9IzoUtXcSpt6s85XRf0yisJ13w1o+QuasHRDZlyA+Jf4k8o4X1zWg?=
 =?us-ascii?Q?sYMc32sXlzJ3EGs/7fh2UmK19RTDOGsZJM/bR+vfWkNO2Jn2UXuzW5B5ntLT?=
 =?us-ascii?Q?8XlrCdNKUSJKd/yfJl1lO9DpGhAZ9bR5hLd+FCjaWZBKkmlOWw1E2Z45iiKS?=
 =?us-ascii?Q?7RqDna9wo3oi8zjTxFphjsaU2r2ACI1wtHhrmJXuIp28xP3GKEzhc1KkKspt?=
 =?us-ascii?Q?FLFJQ667IXrVHZKBuumVdc5bkPm3PIjLeBtqWi/Lkwaw91aEFL6Wron+k98J?=
 =?us-ascii?Q?GgfYR9JYFRakeDaRWzNfIY43D6F54IbdbMWL2NlFvchh/b9dPL+9IsmWosYl?=
 =?us-ascii?Q?DmsxJCWr/V0Texa7YtqO+AI0RJ3f5kCBmNllpYaANn37IYLSBTi250W+2p+2?=
 =?us-ascii?Q?2/QQPXiny+uWiuMFWFo4AiquDDutiuNGw58BzoC9iwpzPYB20nLXFtSWdoIQ?=
 =?us-ascii?Q?46HG++qQMzXEnw3DqXP9kmARyQkx/6HcpwqmalFlMhDAlTu5ftLTqbMpeEYN?=
 =?us-ascii?Q?bGFRZZGh04vmqEZnFRyZlsAvJko+plvHZhqxXZkSy2nX3JQvdVE85o+2fYwQ?=
 =?us-ascii?Q?YTS4FLjnYR/BdcT56ziMkB/LhTtN3yjY60YNM8mKY+1hB0PZMJIfDgxYGqlJ?=
 =?us-ascii?Q?o00WcgAWbARBvbTfeq1Sci6zOEQ7yy9MoTwDNJtc0hr73wTysJPT4AQRzVvb?=
 =?us-ascii?Q?tcBN62GLTcanzDCDKDhlIIJxrAeSjvCLDkfeGh5Jew6c5eQ1WQ0BiC6ntxxY?=
 =?us-ascii?Q?ReNz/NaebbqvcmGxl4DG2eWgi+Zbp2lbhiEP5PqEMPkTDEtnMFmLEi/mCrGj?=
 =?us-ascii?Q?uYYFUyOxmfV3sB+NRAp0zIJubLkjhAdaRxcbrJ1rGBDCmsY96EM/GB5pH1oY?=
 =?us-ascii?Q?J+vkdmhQly/AsxSTLIIVwvc4FS7TXA6thwVKfJXN4L9CFjNKdhKYfdlhZBrh?=
 =?us-ascii?Q?V5SOR7Xr0sKWDju3+Jc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 20:26:25.3607
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7471d42b-6af1-41bb-3810-08de005fa0ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6186

resctrl features can be enabled or disabled using boot-time kernel
parameters. To turn off the memory bandwidth events (mbmtotal and
mbmlocal), users need to pass the following parameter to the kernel:
"rdt=!mbmtotal,!mbmlocal".

Found that memory bandwidth events (mbmtotal and mbmlocal) cannot be
disabled when mbm_event mode is enabled. resctrl_mon_resource_init()
unconditionally enables these events without checking if the underlying
hardware supports them.

Remove the unconditional enablement of MBM features in
resctrl_mon_resource_init() to fix the problem. The hardware support
verification is already done in get_rdt_mon_resources().

Fixes: 13390861b426 ("x86,fs/resctrl: Detect Assignable Bandwidth Monitoring feature details")
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
Patch is created on top of latest tip/master(6.17.0-rc7):
707007037fc6 (tip/master) Merge branch into tip/master: 'x86/tdx'
---
 fs/resctrl/monitor.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 4076336fbba6..572a9925bd6c 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1782,15 +1782,13 @@ int resctrl_mon_resource_init(void)
 		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
 
 	if (r->mon.mbm_cntr_assignable) {
-		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
-		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
-		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
-		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
-								   (READS_TO_LOCAL_MEM |
-								    READS_TO_LOCAL_S_MEM |
-								    NON_TEMP_WRITE_TO_LOCAL_MEM);
+		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
+			mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
+		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
+			mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
+									   (READS_TO_LOCAL_MEM |
+									    READS_TO_LOCAL_S_MEM |
+									    NON_TEMP_WRITE_TO_LOCAL_MEM);
 		r->mon.mbm_assign_on_mkdir = true;
 		resctrl_file_fflags_init("num_mbm_cntrs",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
-- 
2.34.1


