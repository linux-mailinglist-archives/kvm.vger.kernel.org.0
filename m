Return-Path: <kvm+bounces-56915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EDB6B465AC
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 517C8AC0C71
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D792F83B6;
	Fri,  5 Sep 2025 21:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bzzUZUay"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890EF2F3621;
	Fri,  5 Sep 2025 21:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108126; cv=fail; b=cjQq5tFbISQSK7w2D39m6M+li8jSXzNMOeKB/ZazwIdabFkOVarQ8nk2KmfvJaqT4YtqLpF+99RgC6Seuvl1kw2ENZXBx+XphexzbQ6TrCUCTKeS2rhOZMpSw+gi/lgOeEyz3Dk8iFefYfhIxGvJNtFCqDveazNBnD/zcPsBuNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108126; c=relaxed/simple;
	bh=XpX+SOncOoOeJ54VXKlF+sbRLAGeB1MJKwL5mNc5BXo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgoTyObGoSBz2OmJZ1zh77zFYXyy+bVnQvmuJR8N8ilT0igndtoNOGaI19juELNuq2D9G75jdla7AXzKQi0+H7MtaYFJFy0Wc/FeXW1Btd4DRPbREnjETfY8i2BWVWxCPGK9Z9TikkUrMs2WKqQvkjVLUlY0PjXSm5jDi0U3EkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bzzUZUay; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZcBJIpDEBdX3LqqSevWLxbz9rqaC78IsOs6pvlm8+BmErVfAAFnxCqhOkoTxYvdBfQaoYeqIFkEfBtj8vNund2/rzM1sYDnoDE4VYfRjDP29Ty+CCwqCEBCwezszKUWHykf4P/g/SF/3YP5Mn4WdxyTmulSgE+T6jL8LY0Yh+gy7FfJWwyfZhOwc+s/ljUvviVSgLSZacGmKNxaHIIZF2GS38yRNF0Y05bbrx8eQApvORAQvFfgEhwExswRMT9pktCKouukbCwJrkNK0V9BWoaI1IGxDqE5H8Zeee0aVK/s/Yo3dKlXy5Xr7fkINfa/znrGH7ykKiWzKxqb2Rpgcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iE8yqzx7kEkHg7glGt3Qi0CYyglBRWmx8RkgZid6tgE=;
 b=gRwZtsJKrx1XEtj5GQy9NhvtMHjc4f8Iszqa8P7LEDmqV9ursQCDGpL0OWgtsoe+61W+3zhpNemiwh2K4Whbp4D/18VrvfSMeXsim/KgaalhHryq00xp8gBcgo8cSuMHJbha0fD43EY4u5LS+PuynPwKpMPhBI+I2gp2Wen0yFNz83duioVQw7+glm5ObkruK5qhh3T/UyiDhcWlkzS2qzOhb6qwC9Kw8m3v2wXfdIitxQTsgFqqzF7Sibvl9fY7rtJSh7bzNVnyTszTJgRmV0+ZXW+m9XmSqZ+wflUGxE1p89bnSfs2OPdP+TJbSalFhnYkLFXFr68gxFvEwGLJjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iE8yqzx7kEkHg7glGt3Qi0CYyglBRWmx8RkgZid6tgE=;
 b=bzzUZUay+SXZAJB/9UGnnpS5+huDsvbrnDIeYTNFBISnlaNDBebbuCnfOBXConSr5vGlxRf2+J2NMX21D6su3kv2yiGQdXRq3u6SRfAKs93zaD0RTBuowtkF8SSS+Sk40FBluxd8FYCHGWCRDNPdtcmNSgG/XM1EUGAeZcpbVW4=
Received: from SJ0PR03CA0039.namprd03.prod.outlook.com (2603:10b6:a03:33e::14)
 by MW4PR12MB7014.namprd12.prod.outlook.com (2603:10b6:303:218::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 21:35:18 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:33e:cafe::b) by SJ0PR03CA0039.outlook.office365.com
 (2603:10b6:a03:33e::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Fri,
 5 Sep 2025 21:35:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:35:18 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:35:18 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:35:15 -0700
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
Subject: [PATCH v18 03/33] x86/resctrl: Remove 'rdt_mon_features' global variable
Date: Fri, 5 Sep 2025 16:34:02 -0500
Message-ID: <d663538d0ce03e61967cd8e308a3c4549b3cded3.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|MW4PR12MB7014:EE_
X-MS-Office365-Filtering-Correlation-Id: 430d506c-2e0a-4a13-6729-08ddecc41c2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5FmdbJscBt3AKW5dl5BiwujkAv1K2T3+xxmd7Xxz75CG7NBYR4k1OyFh8acj?=
 =?us-ascii?Q?IkwjWzG5cSWHz3WKEki/ATp9dT7h14ZH6bhzxERvg3KcfaLXiN0H9yHbVYwZ?=
 =?us-ascii?Q?qshM1k8P9Bex6NuCG4Wad0R03ERe6JNuXeeTexQaegcuFMNu8K5Wmx+6Cbl7?=
 =?us-ascii?Q?pJgbU5VHBHGEqyJmiqcRHcaNP9eNR4wfDxJ6g3QzcFRbu5E+80GErwvACV/O?=
 =?us-ascii?Q?J3HfgzChwIQSP9rT7emGwBAQskvMEzXa0vuPZYrWyI/qaxzpyaVRZ1rk4+PN?=
 =?us-ascii?Q?F1kS+Dpb3DzrQbWxnFrW+PRwdCtDDS2+tlARtBHbvljY5p0AJS5i43WWvzSy?=
 =?us-ascii?Q?RgtdtyWVt2kRPYjNWZ+3r6PoldR7/k2+J95nhdWmilLnVyckRg8TftNJ3VbQ?=
 =?us-ascii?Q?pJuSaHGqM0KZ+1VEyzMrNHiUBB+CL20rv+EQ0/0/JGkPBvxoVZX8hDxLb4mv?=
 =?us-ascii?Q?K43zUzmLkt20QW/Os3ivy/GMHUyNMEYf0RC8vg15ssag/h2TeTCcU/5tI35+?=
 =?us-ascii?Q?3eDaMazdScWz466tBL4iNnOfwPz2/OZB/zPXOA/KcpwG8NyVyGyf0uRHsSiu?=
 =?us-ascii?Q?iKxx6ZIeUFh1a1KCZQfecj/yLcUxvK/YVQhbhOYg4XuKJR51BCwP+1mFvdk7?=
 =?us-ascii?Q?UH+9CkdvejJVq6V6VcizAQf7WMHnRZai8RcQdLYOdQS2pfukO3vyoezdtrbR?=
 =?us-ascii?Q?rSL0mHqCDL3eQwfEJ9pb1fmtxcemdJ/aMDdglRg42bKPq2SbGNjLEwRY7mPf?=
 =?us-ascii?Q?j5+TfZ5jJW7Z3OdwTgMmarVzpAB2tMwDD/VONbXB9j9Xa6xu7+UDNU9I96N/?=
 =?us-ascii?Q?/9aIJxSxEaiPQTgoRbxDN6Jn5loM/qxGM3Cb/5GpabBmsyH8Gy5Z2LtSRxPr?=
 =?us-ascii?Q?jDOtMN3X+VvlfCxp5G0Z4i/R8KlfF7j/vpVwpkn+GbiCObk/VHd9iSbz62bp?=
 =?us-ascii?Q?vc2/uSEFWRBe5mzrj5hfDwTK1TLmeV4Pxzwn5UB46NCLs7ogAjZBcLo5fTsr?=
 =?us-ascii?Q?MIWrtHMsVXNrluv3jl9ZxOaEeQ7hj9Ys1Xtae17K667sQ1fdymGXRvbtOjjM?=
 =?us-ascii?Q?uAWlqZNtw6zV3TC+ppz6pc+i1CaSBN8w3fnAMmNokRD2q2fvKu+H3URKfuCG?=
 =?us-ascii?Q?D16sVmG+p6wlnzyoz7rqgdjhTI00YH0d1n9x2mgmj6ttQ+t7WOfDgp2WFu8s?=
 =?us-ascii?Q?YIYfn+YkDyDL49qXinYudT6gTiVdmXJhq/CZEflIB10Fi74WhoS2HGqXHcTH?=
 =?us-ascii?Q?H6ay2f8DY2VpV3pbX3FV2TTOVeeulaxnAFORmmn7ERpcAaMQ6ZBVe2AlJyca?=
 =?us-ascii?Q?uhScHc8pJFx5F2O9n2kz3wXXaEfLMdPoRGaL+/SgtAEngGR1EOGGRWK9d0V6?=
 =?us-ascii?Q?h7M3hMVgjn0WakJaTH5Sv9SPo3ayC5iKALoDIPybhILLoB3kwU5b4Oc/4YCS?=
 =?us-ascii?Q?FrW+tUTE2P5XTY9Unh0LxJVahqvi2rGXD29kNkd9GSldBJvJdnwrpW3RA3Kp?=
 =?us-ascii?Q?Mzs58F5CLjK59JcjiFE+8qUq8w7jiqKev8mrb+Dw/F3n6v1Yc8sYeCrt1w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:35:18.5675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 430d506c-2e0a-4a13-6729-08ddecc41c2e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7014

From: Tony Luck <tony.luck@intel.com>

rdt_mon_features is used as a bitmask of enabled monitor events. A monitor
event's status is now maintained in mon_evt::enabled with all monitor
events' mon_evt structures found in the filesystem's mon_event_all[] array.

Remove the remaining uses of rdt_mon_features.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: No changes

v17: Added Signed-off-by tag;

Picked up first four patches from:
https://lore.kernel.org/lkml/20250711235341.113933-1-tony.luck@intel.com/
These patches have already been reviewed.
---
 arch/x86/include/asm/resctrl.h        | 1 -
 arch/x86/kernel/cpu/resctrl/core.c    | 9 +++++----
 arch/x86/kernel/cpu/resctrl/monitor.c | 5 -----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index b1dd5d6b87db..575f8408a9e7 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -44,7 +44,6 @@ DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 extern bool rdt_alloc_capable;
 extern bool rdt_mon_capable;
-extern unsigned int rdt_mon_features;
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 1a319ce9328c..5d14f9a14eda 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -863,21 +863,22 @@ static __init bool get_rdt_alloc_resources(void)
 static __init bool get_rdt_mon_resources(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	bool ret = false;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
 		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID);
-		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
+		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
 		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
-		rdt_mon_features |= (1 << QOS_L3_MBM_TOTAL_EVENT_ID);
+		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
 		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
-		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
+		ret = true;
 	}
 
-	if (!rdt_mon_features)
+	if (!ret)
 		return false;
 
 	return !rdt_get_mon_l3_config(r);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 61d38517e2bf..07f8ab097cbe 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -31,11 +31,6 @@
  */
 bool rdt_mon_capable;
 
-/*
- * Global to indicate which monitoring events are enabled.
- */
-unsigned int rdt_mon_features;
-
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
 static int snc_nodes_per_l3_cache = 1;
-- 
2.34.1


