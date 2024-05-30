Return-Path: <kvm+bounces-18390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5318D4A24
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29AFAB221BE
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B6E8174EF4;
	Thu, 30 May 2024 11:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WNbnb9nK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D304E16F82E
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067810; cv=fail; b=Nl6QxA2F8YZO4D+sZ5C7JyoX0MzTxFfwv1J0ug3njC6frSRhYtV/eFycj2rf5rhTL6HdeY+59l4J/snIm8HuziDN1kKqGJzH9TvEwEmyoLzYeNlhU24p7NrEbXVaMl1Cl1F51uSZpRW0SFe7va/TdlOHiAItxIQBPJMdGqvQJmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067810; c=relaxed/simple;
	bh=b7zEI1iZraElWXOcrkLpozOBFFF8OhhaHHf+MeG4JMc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P3T5N7lsmxtg/1y25RR1Ww7FmdZXy71d0DE7Bi1ODueEBAP1sPtgq3JC9YYiioKsZHARPBFUE50bQxISRp4qaZ+r0HrgwJsNZ0YWvo0FBt4mvBxKPJTZlhjNGGkJ97Vdmr4XuHbINCyJG7Y4TcOgNmYUj/J1PmpBrN+9uulh93A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WNbnb9nK; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhTDZQ4IEc308shUUOGOxwtqHcawTD9ssJFwbOO3yWCkYcXRa8zGd18efHRllxLorMkMsmMwxtKLzGrAu/M5lr3w2moZYwqAUWyTo4HT8SiLaYrFwNH4+aM/0K2ihivLITPsYhdpsB5iQd96uVcldpUY9bccoBl96jlA1NvLH7FR+5fxBN6dBGMQzrOIveclRJNA/f32v62r/juQwYQZ5B+qo2ioLrx70CbPKPK0opSnClvx1bfrsJwk3V61gFMEDwV/1dhLEzTeTjrVTD8qdsGYgCCydSN+8rPiDJcVbtT6V85T13TzovXNLXfFJXaTeZedkdiLbk1kC/GHfahLUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fvtFIXaNhcG550phznRGtO4sw8XWIei4P4Fi4fuREL8=;
 b=KXzm5cwXrfsm0jldPgzSdoHggbFpFJayTq73FT+1a8TcmNdUOnYo3SmxMKZHLds5N3KNP6wz89wr/5MqzYkMmmnoycKCna4u88+pRmfJEhuhcYC/XV2bevffURim+22S4SL2E7QIcvbtHBc2poyRQrc5QD/DcFxUuZHWeHnW+LmpefTqGixZvOTIPdi6xtMdgzk8b9pVc4dg+Uu54I5uVaiqcJZuPwKLRcaYmKc8nB4piGaANd1bVAwvrr/FKVCKz37len7h0NaqlvVMIEr8CAjZ/79cTvtMzNY4ZSGCT28wxsxZlqqdYjy1/GgTl/8ckOn7PweoEBAMoQ5DDMSRZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvtFIXaNhcG550phznRGtO4sw8XWIei4P4Fi4fuREL8=;
 b=WNbnb9nKiBluGR5oN3X6pRUZe77Z2pLUUnrzxpLcTwkHiAnCnLZE34dP4U5+Qjq6aV3cOBTxSukW9ZUU5vtrdRT1Jl3l0XAR3KlxcQMHcxPhtFSVRK0H9e4ftNzHFBL0UKnyzgG3vedheJrPR38ZRoJEoOPBjKD8nRjTWixTuw8=
Received: from BL0PR02CA0117.namprd02.prod.outlook.com (2603:10b6:208:35::22)
 by DM4PR12MB6011.namprd12.prod.outlook.com (2603:10b6:8:6b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Thu, 30 May
 2024 11:16:46 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:208:35:cafe::8c) by BL0PR02CA0117.outlook.office365.com
 (2603:10b6:208:35::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29 via Frontend
 Transport; Thu, 30 May 2024 11:16:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:46 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:46 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:45 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 03/31] memory: Introduce memory_region_init_ram_guest_memfd()
Date: Thu, 30 May 2024 06:16:15 -0500
Message-ID: <20240530111643.1091816-4-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB03.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|DM4PR12MB6011:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c60e61-17f0-4ec2-3e22-08dc8099fe3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zTo0QpD0/82t4N/RWz6WpKLwRwMt/GUWvo+eNOsIrSQ7gCL0/He5QUfGHATH?=
 =?us-ascii?Q?U4ynjJMOituKIPMXPeK2/jU6/P/qoUHhQwxJbOAuulgLGxDH6ypu0OvAOUHi?=
 =?us-ascii?Q?1h5f/XpSQQwtbxB+QvqTVr8m8+AfwdQxNdyGtcgJCNAFnKC/wap8Zg6aZ84z?=
 =?us-ascii?Q?MjHq0jeAFo+qbw91ZHVGBvB5+xyusRKkgsrqPv+1He1IKDFwmd1UvtLKz+7V?=
 =?us-ascii?Q?oTmNO2fwfRBD0JC2G3XtQpLnuw50ya/zYDTZBnG3quvTKQc/QcAkZRqZ+iN/?=
 =?us-ascii?Q?saLx34XD8g/mf559LU7KrnE5vquuDAbbjFHdqdN7Hw8dxcnHIfVScu6HL55R?=
 =?us-ascii?Q?I9LCGLuqOd8DRPlb+RQE4F050MaySMX79Ag6d+9SsANwMPZy1E6DWE/RWOi1?=
 =?us-ascii?Q?gYt1CuafBdAellSOYM0cKrt42I7VXI0DMFfXwUSyGdtS1sUaT08XJODWEuLD?=
 =?us-ascii?Q?giC8CC8DaXrJuJpNGWk/7N++lxXvfEknJRa72dw8qxpAnTbDzS6L4vaN8LQj?=
 =?us-ascii?Q?lVm5eshmRO3MCSlxPlwIxN1/FcFd8N5kSd3ahYdcefOgykWsYToM0fvUZUvN?=
 =?us-ascii?Q?2Hf03oKiPXP2cf7FU8FgKtCb8LPhAWBwbtRsDbfsZgEcF0P1SBDGxcDgbymy?=
 =?us-ascii?Q?GcdIVcj5eaI3ZOqQ8DhKxTMnaS9pQlsUHpErYBM29PCckuMdMQ+Y8+fdw7O0?=
 =?us-ascii?Q?NRbDDeJUwKObMHfYms1qcwMWiUmOY3xe1b1M31oWB2V94ZrfZ0ZBhsx3tjSQ?=
 =?us-ascii?Q?f0w+ShfhixHiBFLIWKxCCSy78N7TxxHrrcm1hUe5E4rpk2i2s9kH3PKkZrln?=
 =?us-ascii?Q?myYD0wbxcWjsalWPGc20SSXjZwsDG+s00eCZYMYldVR62YcUv9ougur1HR1J?=
 =?us-ascii?Q?K61d/cUc4kgMEEh9OVVybGSudo7LIBcE2Ub7vgOnsi/RdQ46jqCkIE/uV3Gv?=
 =?us-ascii?Q?N5WUj9P5DwmO7bW0ysGvIEKh4raH5IDyQWpTI6DyEsAcsRj4CGYocJqKbfBH?=
 =?us-ascii?Q?oHbBd11DvP68F5WM3F0tgr41PwgTgokDMJS/u1ekDWrJHnE2PPLXW7YLzPer?=
 =?us-ascii?Q?ht0UwuwZreYGvmRWh5LjhOfGhGLYxheWP9btFcTEVa2nSji3CXhTFXftrzWJ?=
 =?us-ascii?Q?LDOede+KU9pqypsULfpkpoKvhLuWycioOiL/kduKE/Yxiyj7XKsvLux5eJY1?=
 =?us-ascii?Q?CI8M7+YYqY86Vzic7x0L0yguXmcXrKEUoUg9SjjAK3q3XaFA8nG69lAkvYXn?=
 =?us-ascii?Q?WdZNcdLES6Uo0JsrYal9vXUYBVMii2l1YV4JDqFq1vQVuYPGb1hVwPI46bR0?=
 =?us-ascii?Q?F5dLKoi0b4UuQVjmj4eLYpIcDSp7qgYmV3u7TmeaUujMT+4sswOSDlWdQV1h?=
 =?us-ascii?Q?Yhqp5w3YyAPfq515+R55iOeRphcl?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:46.3011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c60e61-17f0-4ec2-3e22-08dc8099fe3c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6011

From: Xiaoyao Li <xiaoyao.li@intel.com>

Introduce memory_region_init_ram_guest_memfd() to allocate private
guset memfd on the MemoryRegion initialization. It's for the use case of
TDVF, which must be private on TDX case.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 include/exec/memory.h |  6 ++++++
 system/memory.c       | 24 ++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 9cdd64e9c6..1be58f694c 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1638,6 +1638,12 @@ bool memory_region_init_ram(MemoryRegion *mr,
                             uint64_t size,
                             Error **errp);
 
+bool memory_region_init_ram_guest_memfd(MemoryRegion *mr,
+                                        Object *owner,
+                                        const char *name,
+                                        uint64_t size,
+                                        Error **errp);
+
 /**
  * memory_region_init_rom: Initialize a ROM memory region.
  *
diff --git a/system/memory.c b/system/memory.c
index 9540caa8a1..74cd73ebc7 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -3649,6 +3649,30 @@ bool memory_region_init_ram(MemoryRegion *mr,
     return true;
 }
 
+bool memory_region_init_ram_guest_memfd(MemoryRegion *mr,
+                                        Object *owner,
+                                        const char *name,
+                                        uint64_t size,
+                                        Error **errp)
+{
+    DeviceState *owner_dev;
+
+    if (!memory_region_init_ram_flags_nomigrate(mr, owner, name, size,
+                                                RAM_GUEST_MEMFD, errp)) {
+        return false;
+    }
+    /* This will assert if owner is neither NULL nor a DeviceState.
+     * We only want the owner here for the purposes of defining a
+     * unique name for migration. TODO: Ideally we should implement
+     * a naming scheme for Objects which are not DeviceStates, in
+     * which case we can relax this restriction.
+     */
+    owner_dev = DEVICE(owner);
+    vmstate_register_ram(mr, owner_dev);
+
+    return true;
+}
+
 bool memory_region_init_rom(MemoryRegion *mr,
                             Object *owner,
                             const char *name,
-- 
2.34.1


