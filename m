Return-Path: <kvm+bounces-56920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A16E7B465BC
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:38:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3602B5A67B7
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0272F83A5;
	Fri,  5 Sep 2025 21:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S1wySnWk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39962F7ABE;
	Fri,  5 Sep 2025 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108182; cv=fail; b=UT9iZnywQcohweETpdtEyc8HDK+AXKlfxR+EOGVQr9sher2U+LrnywtbWnUYZ9rQZKQZPJYv+7iJT4L+fBzS314azwkDXYOshW0uAmJa1tJCY284dZhw7NzNw89PT+aCoUUGJLLlXqhr0B7FDVhqPGdjenelJ/uPiagQy8gAEM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108182; c=relaxed/simple;
	bh=z6HxhvwDB81zS0uMSsA9NNFiU0iK+DevWs621fMBfAA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gDQc/4NAOYe6YB4Qfdsv1igAjgOdI6IndzTs7rqFwxOBQU4nZubcWU28H56hiNnne53qt4aRxHsvDuAM+moS8B6jjNd3tyLtefsB13GLwVqhf0sGH3zai9xEYSUdi9T7oluFpCbSAxrvWqsiZ1Nx7o9ADLucn0zJEb4LMvxHUzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S1wySnWk; arc=fail smtp.client-ip=40.107.220.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DBCQ/PrVnQQe3ttjbD0tNOSgWe2dqg1PaQkCsfBgR0Cc9bxEu/p8djqIMIjqKEPIcS4wudYqZ7BNzYoWr0bovLJ7dJvvB5SFqTWs7mxnH+MwCBsytwyUahWzEZXeC/UpPr9cxiwZzctABVc5RvzMjZVnehtD2t3RvFW8Dusa7KY4lnLdwppJrTr8rBSYXw262UlQiZOuIV0VWrN2QujzR2I4hBUBQnTfiAKKFvIDabAPP09SA4kmOOlpgWI437EjhEJpA2FaVDNdxKbLAOeGjIFHyLN1DXkjYwyh9437QSoUYpWQHGGzw5IZGX6pZjf8QdDBTHqgvm5L7U2xR0BGDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvua6RiXwDwRpuB1ctOSlung1JmEr1AfvIaWnnF2iNo=;
 b=BFJDd1svYcnOXzJbBWuvoqJOo0fukaWTNE2zvuPVfHZ3Hd15Ws54YkvHq/jDOA9mf5oOUH8lI8OZB23We5KrlpVZ/RNumFKQ4uyMOweueNJjkvUbfxzozTB45MlnTW4NAEgYAkCqi5JHGaKckZLmAPYea8ii28DTwApnOTyAlNoVjETcLo5QoAdta0u6Ae5h/IC+Dt61qQeUOwUweKcgDa6antrmx8wqvGIfHI8eIZEcUpAtU2IPBEeRNYol/0KrbFamCpRs5oAttrOsM4r3TD41wt9uIJWljH4Tb4yAF3INyCEnLb5aT24vhksqO6P4/y+FQJsUL8pWEC6XkfAuSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvua6RiXwDwRpuB1ctOSlung1JmEr1AfvIaWnnF2iNo=;
 b=S1wySnWkdbaTUKIxQ5tjNK/qw6TUpVGAcb1sp4fZ2OZGE5eYBMWFpnQH1IMUOOQafbvXxdOyAPxRVMVFOZMpX7wPljUBDv62PHV/Z+frLPRYDWP77fJL8RWpBpi+G2aRvr5OPQEgzKswsdWV3wVq57y1Pwn4G/iXlzY7nv5FzNU=
Received: from MN2PR18CA0015.namprd18.prod.outlook.com (2603:10b6:208:23c::20)
 by PH7PR12MB6394.namprd12.prod.outlook.com (2603:10b6:510:1fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Fri, 5 Sep
 2025 21:36:14 +0000
Received: from BN2PEPF000044A9.namprd04.prod.outlook.com
 (2603:10b6:208:23c:cafe::50) by MN2PR18CA0015.outlook.office365.com
 (2603:10b6:208:23c::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Fri,
 5 Sep 2025 21:36:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF000044A9.mail.protection.outlook.com (10.167.243.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:36:13 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:36:07 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:36:05 -0700
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
Subject: [PATCH v18 08/33] x86,fs/resctrl: Detect Assignable Bandwidth Monitoring feature details
Date: Fri, 5 Sep 2025 16:34:07 -0500
Message-ID: <37b798c0c4cf19365ca77a5ab4bc7dbba53b9aba.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A9:EE_|PH7PR12MB6394:EE_
X-MS-Office365-Filtering-Correlation-Id: 07bb31d4-10d0-4575-95d3-08ddecc43cf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gCLqlk109CmRsZM09jnjR+sn+fU75KAqPnsqDIOmf99kSViyq9K6JrdiK2O3?=
 =?us-ascii?Q?KBq5pPEQxNaW7Q/4GLvrMnrLempmBhmkfkTz2VnO7lYDisRHckFbgaiPZste?=
 =?us-ascii?Q?BU9eTm1VAYrJ4XJVcklcYWhhhdgSsSGK1dHOK22tCrm13WO9hYIZTFQUjjs4?=
 =?us-ascii?Q?wbjxIe4zt2sJCKHNKxApQza0JVXzSjID2x5dxdou86F1YpVNGQBrEjHZUs3L?=
 =?us-ascii?Q?LHZ4xQ9J972BFgHA2Yy3Q9twn/amXI2HttSOBIMuHN67DNejoN+aMkI/oUbY?=
 =?us-ascii?Q?K/JYjoLhzVWqZCPuwd9tQ5faKFaDroguIA/UJLZ08bBowfa9HaJDINsXIpfz?=
 =?us-ascii?Q?xGzukaFpfV6yKVkgEsoNzc3/yVOw4n5DucRdiCMEvDU9DjG/yD1uF034oKur?=
 =?us-ascii?Q?nY5xSBptT7Azt4P8Q25zTBSmXkaVQ7W+uxwzoor5GePj01LUv5xqsOTZGSCP?=
 =?us-ascii?Q?kxr6odnlT3tEc9TxG3kz89EGlggtRhtNRdBV4lN0fILk29mAB25OBN43uTFA?=
 =?us-ascii?Q?57yN4MP3OBBnt/u9ouc+osj4AsYPKGt4k0JdA3oERfJ3rlFUisMse/0mrQzr?=
 =?us-ascii?Q?F/WwN3jZAD1tNsUW8/Aggfq2j8FjPwvb88GGI4Q9/lOoKCg7MdQt9H6F1yfj?=
 =?us-ascii?Q?cVwI0Wc4GQeySk/zVQZLSpejUxznxgh0o56bvdwITEWOrYmfL4hHjHcOgx5C?=
 =?us-ascii?Q?+TneQJeYdFmOFuHnUS/nS8ZbgFOibA7t+JZdKNnlNRbo/fQcbXKtpHygqh4b?=
 =?us-ascii?Q?okgf9ZlAeT1RwnsKY/ggE+vJnMBnDNjYSWvdhhlzfFD/3ecUEAdapnruDb2X?=
 =?us-ascii?Q?Sg/qVmKLE7W35jlzOtK0nYJtramRzfVrNTY4y8qI1Kww5tmke4emlG2KbAFW?=
 =?us-ascii?Q?KxXANKFSrcq/cINgY1GpK0aOIlFU3Mf8f/moaGPsTsLHqrHzwUv/HmGGCaf1?=
 =?us-ascii?Q?05QDIY9XomtmRwlx1q/f202hV9oI7Nix6rDFfbJI0sBjHesAOTUw1LpJQ9LD?=
 =?us-ascii?Q?trw5b5M2Ffs3fDn0IdG2gumQBsuvtPv+VVhm3wdIz/J7SH3xZPxgUaX/aIJ3?=
 =?us-ascii?Q?ETjcly6S6nX3vg2qQc1bwGUdMXIeZG0Qf14ufRO2A3/OUXs6WxSxXjsIqRJz?=
 =?us-ascii?Q?uwloLjO8P3u+f6wX/zun/F/kXFNLN5DBmxVMpDHw2cBvss6DbVNOrBAnTtlL?=
 =?us-ascii?Q?8IRFo7NoV2ajCSfO22mIouSx9cuBzl/huiTvxPvKbGFdTiaJWtqCIf4LFcj/?=
 =?us-ascii?Q?fRqsnX9ny5hKQ3+wLS22tKP+KwUaCqIZlk/cLLacueOgO+MdvJyEj/2ov5RK?=
 =?us-ascii?Q?LR51ek4RzeI4RgAf2DJWEWcuv++X4yWOrKu72viw3FrpGpEw7BcPPiQr0KsH?=
 =?us-ascii?Q?07FFLYoTtfppkkhrW4Xh5n3K98Ib1eDh7mMiyAWStcagkpLpqc7NODJRU+2l?=
 =?us-ascii?Q?pApl0w/TiF/3JD1ixIa2NVm+8PwztNhXJjEuQ6YZ72wRrEIemvnn1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:36:13.6686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07bb31d4-10d0-4575-95d3-08ddecc43cf8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6394

ABMC feature details are reported via CPUID Fn8000_0020_EBX_x5.
Bits Description
15:0 MAX_ABMC Maximum Supported Assignable Bandwidth
     Monitoring Counter ID + 1

The ABMC feature details are documented in APM [1] available from [2].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41 section 19.3.3.3 Assignable Bandwidth
Monitoring (ABMC).

Detect the feature and number of assignable counters supported. For
backward compatibility, upon detecting the assignable counter feature,
enable the mbm_total_bytes and mbm_local_bytes events that users are
familiar with as part of original L3 MBM support.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag. Updated the text about the documentation Link.

v17: Added another ABMC check in resctrl_cpu_detect().

v15: Minor update to changelog.
     Added check in resctrl_cpu_detect().
     Moved the resctrl_enable_mon_event() to resctrl_mon_resource_init().

v14: Updated enumeration to support ABMC regardless of MBM total and local support.
     Updated the changelog accordingly.

v13: No changes.

v12: Resolved conflicts because of latest merge.
     Removed Reviewed-by as the patch has changed.

v11: No changes.

v10: No changes.

v9: Added Reviewed-by tag. No code changes

v8: Used GENMASK for the mask.

v7: Removed WARN_ON for num_mbm_cntrs. Decided to dynamically allocate the
    bitmap. WARN_ON is not required anymore.
    Removed redundant comments.

v6: Commit message update.
    Renamed abmc_capable to mbm_cntr_assignable.

v5: Name change num_cntrs to num_mbm_cntrs.
    Moved abmc_capable to resctrl_mon.

v4: Removed resctrl_arch_has_abmc(). Added all the code inline. We dont
    need to separate this as arch code.

v3: Removed changes related to mon_features.
    Moved rdt_cpu_has to core.c and added new function resctrl_arch_has_abmc.
    Also moved the fields mbm_assign_capable and mbm_assign_cntrs to
    rdt_resource. (James)

v2: Changed the field name to mbm_assign_capable from abmc_capable.
---
 arch/x86/kernel/cpu/resctrl/core.c    |  7 +++++--
 arch/x86/kernel/cpu/resctrl/monitor.c | 11 ++++++++---
 fs/resctrl/monitor.c                  |  7 +++++++
 include/linux/resctrl.h               |  4 ++++
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 267e9206a999..2e68aa02ad3f 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -883,6 +883,8 @@ static __init bool get_rdt_mon_resources(void)
 		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
 		ret = true;
 	}
+	if (rdt_cpu_has(X86_FEATURE_ABMC))
+		ret = true;
 
 	if (!ret)
 		return false;
@@ -978,7 +980,7 @@ static enum cpuhp_state rdt_online;
 /* Runs once on the BSP during boot. */
 void resctrl_cpu_detect(struct cpuinfo_x86 *c)
 {
-	if (!cpu_has(c, X86_FEATURE_CQM_LLC)) {
+	if (!cpu_has(c, X86_FEATURE_CQM_LLC) && !cpu_has(c, X86_FEATURE_ABMC)) {
 		c->x86_cache_max_rmid  = -1;
 		c->x86_cache_occ_scale = -1;
 		c->x86_cache_mbm_width_offset = -1;
@@ -990,7 +992,8 @@ void resctrl_cpu_detect(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_CQM_OCCUP_LLC) ||
 	    cpu_has(c, X86_FEATURE_CQM_MBM_TOTAL) ||
-	    cpu_has(c, X86_FEATURE_CQM_MBM_LOCAL)) {
+	    cpu_has(c, X86_FEATURE_CQM_MBM_LOCAL) ||
+	    cpu_has(c, X86_FEATURE_ABMC)) {
 		u32 eax, ebx, ecx, edx;
 
 		/* QoS sub-leaf, EAX=0Fh, ECX=1 */
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 2558b1bdef8b..0a695ce68f46 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -339,6 +339,7 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
 	unsigned int threshold;
+	u32 eax, ebx, ecx, edx;
 
 	snc_nodes_per_l3_cache = snc_get_config();
 
@@ -368,14 +369,18 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	 */
 	resctrl_rmid_realloc_threshold = resctrl_arch_round_mon_val(threshold);
 
-	if (rdt_cpu_has(X86_FEATURE_BMEC)) {
-		u32 eax, ebx, ecx, edx;
-
+	if (rdt_cpu_has(X86_FEATURE_BMEC) || rdt_cpu_has(X86_FEATURE_ABMC)) {
 		/* Detect list of bandwidth sources that can be tracked */
 		cpuid_count(0x80000020, 3, &eax, &ebx, &ecx, &edx);
 		r->mon.mbm_cfg_mask = ecx & MAX_EVT_CONFIG_BITS;
 	}
 
+	if (rdt_cpu_has(X86_FEATURE_ABMC)) {
+		r->mon.mbm_cntr_assignable = true;
+		cpuid_count(0x80000020, 5, &eax, &ebx, &ecx, &edx);
+		r->mon.num_mbm_cntrs = (ebx & GENMASK(15, 0)) + 1;
+	}
+
 	r->mon_capable = true;
 
 	return 0;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index dcc6c00eb362..66c8c635f4b3 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -924,6 +924,13 @@ int resctrl_mon_resource_init(void)
 	else if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
 		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
 
+	if (r->mon.mbm_cntr_assignable) {
+		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
+			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
+		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
+			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index fe2af6cb96d4..eb80cc233be4 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -260,10 +260,14 @@ enum resctrl_schema_fmt {
  * @num_rmid:		Number of RMIDs available.
  * @mbm_cfg_mask:	Memory transactions that can be tracked when bandwidth
  *			monitoring events can be configured.
+ * @num_mbm_cntrs:	Number of assignable counters.
+ * @mbm_cntr_assignable:Is system capable of supporting counter assignment?
  */
 struct resctrl_mon {
 	int			num_rmid;
 	unsigned int		mbm_cfg_mask;
+	int			num_mbm_cntrs;
+	bool			mbm_cntr_assignable;
 };
 
 /**
-- 
2.34.1


