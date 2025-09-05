Return-Path: <kvm+bounces-56919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8B7B465B8
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:37:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70D773BA24F
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C96F2FB60E;
	Fri,  5 Sep 2025 21:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GIyFAlUV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80532F7461;
	Fri,  5 Sep 2025 21:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108167; cv=fail; b=UjNZwG/hXtKHKuGsJ2bUKjCwNg/BCC5SNoexocPAcAzSKwprsuse7ZscbRZeYmcMG6iU0AzNruPqBeLby8TA3A8/sMHZJI2adGzCP4TSHMc8mZJzatSKmiwknDrKCi/ZT3VLD+OFhnTbqCJ7Hd24ctGeAlWYT6AGjAYZGS3xIw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108167; c=relaxed/simple;
	bh=G2Otu2BnizD+qcajxWbgXkIZW2jWBmLGnTTm4r5RSAU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FBY9rojcWUfJDcZnydEHxzZo7W+cvMGAUEezuDqForFW8dnDdHuhVYL4EQjkpJqKddLK6aVLY07xdOIIoywaAv9r65rs5+8aIhFdPzNBMa3KLQJ1KMaJ5D80r0k9IlYOMgTr3dOBtsMyqkiXYh5eEAdozIYZ2+i7TBZDGr6e9VU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GIyFAlUV; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qn8D9oS/vUiKbVhw6kfDQo+SBjfQnN5vuF6PO5uTpbMvNjYu0xO2r79+mAI3CnjNSaUOQcgpjcBOshpbs5S2IpCP+XVm/GZJAbaYQWf9TFd8lukXJ1HV8HfBhwip+crNrVtrWfhh0f8D7l/3pHPpTxDNsJD2bf7tsU6KX9Q9bv9TSFTqqyxqqdT8Egzb4ZENYXYiHGwMmo+7ECZUV2IzAzSprx1ndqYsSoBMDdo9AarlILucy552YOLaC72/MqQ/hKW/7NLXLNFey1lzyapywP5/IZJCl7x17iJ0VXdwlPj1o/uAUn0p0ARKjYKx0U64dl7nNRdJULc8xgWVuhCvAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eE7AFjFAqfY3FUTjY3R394g8i9fTN0JFlGVT3nLTQoQ=;
 b=h9T7haYt52rLOqs7w53gtCgf8GwKYijucAVkSv42hnU45CaWdSYXNLrkWOiBFa4u48g4cebHe9Iaq8RZpKRH9FsmTUoBjBu58Jji0VxZoka/21j1xrc0Fkci6upux7ExaY4NKXF4p8vvegOwZelW/lb1GjjyHL+a/HwYA8Dg1v0X9238yGvnXC9YCD0t6P614013hAlPRe8Mhh2TROtv54u3RGDO2zOilRTRCb0VoCqaHXjSQsY5Mo4D0I+FFjXigNpAUss2rFaECMdSJUdV9UNK9DgLmrxdQZoU17wLUQZxeE/UXi7BHYdPNVR3BogwZMF3DrRQmrPwQ5cL0EsKpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eE7AFjFAqfY3FUTjY3R394g8i9fTN0JFlGVT3nLTQoQ=;
 b=GIyFAlUVcoo9B7SEsE+mx0IxDksNbdCpZ/5Nzmr4R9mdMPp0eVaInRfCS7F/ZaAFK4AZkHmqV5fMq6K0K55FVBJsCjOf4eQc9LmxYpUllW4688lcFFZfW5AsVzjvP+CPY3JnuvP6xeG1RKoJKPqGTzbRV/bqTqqmgoq8ZiiHR/g=
Received: from BY1P220CA0025.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::12)
 by CH3PR12MB9456.namprd12.prod.outlook.com (2603:10b6:610:1c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 21:36:00 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::9e) by BY1P220CA0025.outlook.office365.com
 (2603:10b6:a03:5c3::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Fri,
 5 Sep 2025 21:35:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:35:59 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:35:58 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:35:56 -0700
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
Subject: [PATCH v18 07/33] x86,fs/resctrl: Consolidate monitoring related data from rdt_resource
Date: Fri, 5 Sep 2025 16:34:06 -0500
Message-ID: <ceed1b206c22c9bf8b7c2ddbc8287758694e707a.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|CH3PR12MB9456:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b7f6ff6-23d3-4745-db3b-08ddecc43469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pqaYlTUrnIfqE/O3zG6alqypi1AZFb3FfkmxA1rcYnSIt66+a2ykwTAHwhH7?=
 =?us-ascii?Q?7iGDuab67CbzPIb1JChh55MhrPnXGuKAwWoYnFoNIn0UJg1R5ovzgh0Lnxjf?=
 =?us-ascii?Q?U4X+wVAImDnGal7oZIXR8nlLKjte8cO+rbDTycn+TiKvG0tbNcbxeLyEcorf?=
 =?us-ascii?Q?Hd9bLPTNvclNTs05dKXwhzmzxupMp8N8LXm2DihvMXPGaF8IEZpVcaJl4dHx?=
 =?us-ascii?Q?JFqyJ0+Cs+P6s0WLq9in0HZ6x4MIfdGbhgCUueEj3aKFn6/zztkuW3cYFqoT?=
 =?us-ascii?Q?oSHoelilaLxlPZKrAMAD47U9Zq/sTBlXa5rCoYIojd19bx9jyRkbvqkXsVPc?=
 =?us-ascii?Q?QTAnlH+VtFjtvuvKJ+igGvuGD3opuWxo7/gM9XWzA+k8H3P+tkXrRP1kGwt8?=
 =?us-ascii?Q?Rh4vT7zJfsvdKPElMO90VWPGQAwQqQHTAcV+WeKB9lVrS20WmhSuGQYu5WrY?=
 =?us-ascii?Q?tk9sj7C1vMQAScS++8RDyBvWT6xESI16gtMEKHSHgfpKVeEi7bvWBDQFJRUw?=
 =?us-ascii?Q?XbRXkrI97yZP/nvxCBKC3MorqENwArnYrJFzUG5AaP/1OvCLW/H/WZMXQFwk?=
 =?us-ascii?Q?tdYG3yM5B/VjPD2GLBfAYAQnx/CmkiRe149Z0agL4hvYTXrEYsc1z7r50IVi?=
 =?us-ascii?Q?vXG+KhVHZSftfAqpwV06p869RD8VSKYrZSCcqvpAb5bewNRcwPKV0sO+Q5WS?=
 =?us-ascii?Q?WyUrSK/BWwo0mwu1xbHsmaVnIbcx5e9kHhA64WHH3honer9/+Mq3wNKdn2+6?=
 =?us-ascii?Q?n5MIj4xkstNBU6yImeFXFBxEetJ89Iqw6IFHdHNtxRHCX6xN5JxFHd71VzCi?=
 =?us-ascii?Q?jmNTF/yi6WH6iSNmqNQHFQ1OeMDznac+EylP/Druop4TdNaGR4LKUi6Is2xx?=
 =?us-ascii?Q?oY+ckC4mHscjDH7xwjF67EqcOM+IkPezTr5M1zro+G+ljxD3Dmylc8c30ghR?=
 =?us-ascii?Q?7bKfS+diW94N5y8wY9h0V0Kqfz57njV+KezPJJx+gJsaRjhwaJ/bBQK7lH0/?=
 =?us-ascii?Q?hMP6mgdGESk19gEtCAnPOBctUo8eP/2QdqNu12NwbM3kZ00v4tHcoxyJPCER?=
 =?us-ascii?Q?YyFj//RWQ9QDh2dkDK1C0eqxRaW7Qud50h7a3MbkofL+RWrX0plEBlHb5hWZ?=
 =?us-ascii?Q?S1F72FP7w/wEIVY8oAVvhxX6+40a5DHy9tMDra+xF9RLgTzHTFkbPwlIVl43?=
 =?us-ascii?Q?Y7PEt6vk45U6IKx7W0FcAfyQubsS+xqmIyXdzfGn4GMyUg40au/L9FjWUL6D?=
 =?us-ascii?Q?3Q0JoIIfAW5AtiL1/ombT9TeJdRfyBY7zmN4WGu/kzhjLD++O4wCShNnUTnw?=
 =?us-ascii?Q?WtZc+i4TIEyuMAieuG0Wx+4rccIZPw7zUV14KvWPhlRdpQnAlTPw18sK2Dfn?=
 =?us-ascii?Q?vBXztTyJYq47Me+szEz1KtgrdSSvRLNzYglAa52K9BvSN7pqmQ8R0C6z/f1x?=
 =?us-ascii?Q?13z98WIfLyz5KkOK2z66803++9+ugXln7lZPWs6JZqu2eBSKvMTLC1Ye02oT?=
 =?us-ascii?Q?woV2ZIP630DlgAbTSA6BaKdKgNumXhlz3xwr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:35:59.2229
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b7f6ff6-23d3-4745-db3b-08ddecc43469
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9456

The cache allocation and memory bandwidth allocation feature properties
are consolidated into struct resctrl_cache and struct resctrl_membw
respectively.

In preparation for more monitoring properties that will clobber the
existing resource struct more, re-organize the monitoring specific
properties to also be in a separate structure.

Also switch "bandwidth sources" term to "memory transactions" to use
consistent term within resctrl for related monitoring features.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: No changes.

v17: No changes.

v16: Added the Reviewed-by tag.

v15: Updated changelog.
     Minor update in code comment in resctrl.h.

v14: Updated the code comment in resctrl.h.

v13: Changes due to FS/ARCH restructure.

v12: Fixed the conflicts due to recent changes in rdt_resource data structure.
     Added new mbm_cfg_mask field to resctrl_mon.
     Removed Reviewed-by tag as patch has changed.

v11: No changes.

v10: No changes.

v9: No changes.

v8: Added Reviewed-by from Reinette. No other changes.

v7: Added kernel doc for data structure. Minor text update.

v6: Update commit message and update kernel doc for rdt_resource.

v5: Commit message update.
    Also changes related to data structure updates does to SNC support.

v4: New patch.
---
 arch/x86/kernel/cpu/resctrl/core.c    |  4 ++--
 arch/x86/kernel/cpu/resctrl/monitor.c | 10 +++++-----
 fs/resctrl/rdtgroup.c                 |  6 +++---
 include/linux/resctrl.h               | 18 +++++++++++++-----
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index b07b12a05886..267e9206a999 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -107,7 +107,7 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
 
 	/* RMID are independent numbers for x86. num_rmid_idx == num_rmid */
-	return r->num_rmid;
+	return r->mon.num_rmid;
 }
 
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
@@ -541,7 +541,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
 
 	arch_mon_domain_online(r, d);
 
-	if (arch_domain_mbm_alloc(r->num_rmid, hw_dom)) {
+	if (arch_domain_mbm_alloc(r->mon.num_rmid, hw_dom)) {
 		mon_domain_free(hw_dom);
 		return;
 	}
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index f01db2034d08..2558b1bdef8b 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -130,7 +130,7 @@ static int logical_rmid_to_physical_rmid(int cpu, int lrmid)
 	if (snc_nodes_per_l3_cache == 1)
 		return lrmid;
 
-	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
+	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->mon.num_rmid;
 }
 
 static int __rmid_read_phys(u32 prmid, enum resctrl_event_id eventid, u64 *val)
@@ -205,7 +205,7 @@ void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *
 			continue;
 		idx = MBM_STATE_IDX(eventid);
 		memset(hw_dom->arch_mbm_states[idx], 0,
-		       sizeof(*hw_dom->arch_mbm_states[0]) * r->num_rmid);
+		       sizeof(*hw_dom->arch_mbm_states[0]) * r->mon.num_rmid);
 	}
 }
 
@@ -344,7 +344,7 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
 	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
-	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
+	r->mon.num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
 	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
 
 	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
@@ -359,7 +359,7 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	 *
 	 * For a 35MB LLC and 56 RMIDs, this is ~1.8% of the LLC.
 	 */
-	threshold = resctrl_rmid_realloc_limit / r->num_rmid;
+	threshold = resctrl_rmid_realloc_limit / r->mon.num_rmid;
 
 	/*
 	 * Because num_rmid may not be a power of two, round the value
@@ -373,7 +373,7 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 
 		/* Detect list of bandwidth sources that can be tracked */
 		cpuid_count(0x80000020, 3, &eax, &ebx, &ecx, &edx);
-		r->mbm_cfg_mask = ecx & MAX_EVT_CONFIG_BITS;
+		r->mon.mbm_cfg_mask = ecx & MAX_EVT_CONFIG_BITS;
 	}
 
 	r->mon_capable = true;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index a6047e9345cd..b6ab10704993 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1135,7 +1135,7 @@ static int rdt_num_rmids_show(struct kernfs_open_file *of,
 {
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 
-	seq_printf(seq, "%d\n", r->num_rmid);
+	seq_printf(seq, "%d\n", r->mon.num_rmid);
 
 	return 0;
 }
@@ -1731,9 +1731,9 @@ static int mon_config_write(struct rdt_resource *r, char *tok, u32 evtid)
 	}
 
 	/* Value from user cannot be more than the supported set of events */
-	if ((val & r->mbm_cfg_mask) != val) {
+	if ((val & r->mon.mbm_cfg_mask) != val) {
 		rdt_last_cmd_printf("Invalid event configuration: max valid mask is 0x%02x\n",
-				    r->mbm_cfg_mask);
+				    r->mon.mbm_cfg_mask);
 		return -EINVAL;
 	}
 
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 478d7a935ca3..fe2af6cb96d4 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -255,38 +255,46 @@ enum resctrl_schema_fmt {
 	RESCTRL_SCHEMA_RANGE,
 };
 
+/**
+ * struct resctrl_mon - Monitoring related data of a resctrl resource.
+ * @num_rmid:		Number of RMIDs available.
+ * @mbm_cfg_mask:	Memory transactions that can be tracked when bandwidth
+ *			monitoring events can be configured.
+ */
+struct resctrl_mon {
+	int			num_rmid;
+	unsigned int		mbm_cfg_mask;
+};
+
 /**
  * struct rdt_resource - attributes of a resctrl resource
  * @rid:		The index of the resource
  * @alloc_capable:	Is allocation available on this machine
  * @mon_capable:	Is monitor feature available on this machine
- * @num_rmid:		Number of RMIDs available
  * @ctrl_scope:		Scope of this resource for control functions
  * @mon_scope:		Scope of this resource for monitor functions
  * @cache:		Cache allocation related data
  * @membw:		If the component has bandwidth controls, their properties.
+ * @mon:		Monitoring related data.
  * @ctrl_domains:	RCU list of all control domains for this resource
  * @mon_domains:	RCU list of all monitor domains for this resource
  * @name:		Name to use in "schemata" file.
  * @schema_fmt:		Which format string and parser is used for this schema.
- * @mbm_cfg_mask:	Bandwidth sources that can be tracked when bandwidth
- *			monitoring events can be configured.
  * @cdp_capable:	Is the CDP feature available on this resource
  */
 struct rdt_resource {
 	int			rid;
 	bool			alloc_capable;
 	bool			mon_capable;
-	int			num_rmid;
 	enum resctrl_scope	ctrl_scope;
 	enum resctrl_scope	mon_scope;
 	struct resctrl_cache	cache;
 	struct resctrl_membw	membw;
+	struct resctrl_mon	mon;
 	struct list_head	ctrl_domains;
 	struct list_head	mon_domains;
 	char			*name;
 	enum resctrl_schema_fmt	schema_fmt;
-	unsigned int		mbm_cfg_mask;
 	bool			cdp_capable;
 };
 
-- 
2.34.1


