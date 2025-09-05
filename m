Return-Path: <kvm+bounces-56921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF03B465BE
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBC4F17A329
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F08D2F83D3;
	Fri,  5 Sep 2025 21:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gsziLh88"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97C72F83CD;
	Fri,  5 Sep 2025 21:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108187; cv=fail; b=awDVn5sJ3U0nMH2Ix15SLLU1m9zoW6GMid8AyExIXVUFoHVaLflO3bw62bXc2zawXSZjjmqPaC/HKYxJlHnwSyIQHTc/aODjG5xjN9gtcraQqMFtdI+wTCtAzaPAGfsMFZcrHtn3al0mpUMnRj8VyhgU1JAia5rNHv8QNXu9xic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108187; c=relaxed/simple;
	bh=el22Ano1lwStvtMACPat7XSO46X6s1E5d3REsTpHXN4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S/VjeA7JV3ZHyxvkvEZfWMYBL8W/qO2HjCNT6KCOmBOVQt6QSIZTAUuXVEnXGltTF9KOaelSHN/znmUmCYrCXL9Fs7wUbVK10vfpC93TpkadtdTH2YIE5fcx7WU3ktwwbx6VmIdccYYqXA3+1d3Br0xXx4U89MSavFwEBHAwkPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gsziLh88; arc=fail smtp.client-ip=40.107.223.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNbvC9j0uaeBi6j5rC94quKLtvoR6dxfwB+iLjDLVvUfhsUIbmokS5a4pFWY/SbNkHOVl/NYvqnt2sn38F0ZS6CYQAMwxcCtxBiB2Ca9BV0nXFCz82XpDqTpSdpbQ/eCuGYibbqup2YzlvIP3lzgDpfuLE7dqA9DXA5wYgOXhWLG976fK0reh6oHr3hS5lRkeB0YLd2mj/f2SI4sD/mdmf8LshItZ96fVh0RhlZPIDeIhF4U6gaOHNJdFhWYNqSkl5ekcE7yCHm1U3cWScVocTM1XMP5iArwBwgf8cmmENRQm8e/b+Q08mLMT6cQarE6m0TZWzlzq/2k2B4YkxEndg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cg3WvGRuD9US/qCx+4SK4cafcFAEcfQyv9pzA7qY6kQ=;
 b=R0qV1nIZjcInAW2u0DvvHBGm7sIYCe//zrRrhGNQR5xKBwQPODrVuJUIdDQm5tkuKX/n9yVZZVALwIpWLWGSJ6qab186aW0GITv0Qr0vh3dRniqgNmlZ4PvzUlLYqntP11OoITZix8ZtNSEN7bKVgXVvxYAqvjN86b9SloXnJVAWXXW1w933Xp+scRNUAh+ZX+vIx5VvJd9mfZg9IXBt+cuRLTnmfDxQ0oiSAPi9tBcLsrzOax0ZtJoV6T1WDeVDDz3wYz9npY/PWWnE4sGBT2WScITMndV54U/Zbz7y+PgZEX+4RnNvjP8q2DxEwUpvyTCyGdvRB+AmpjdH6rukiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cg3WvGRuD9US/qCx+4SK4cafcFAEcfQyv9pzA7qY6kQ=;
 b=gsziLh88brgWDT4mr2+7D886xztMTWygtq9Ypga5kwx/cjq1oueX9e7q2VA+D0lwuc7F9DWGGX/TraqyyHhpEVirJ7/ryYMNHVNgPj1ocpe/Ut6Rv2g9ufbNP4Q7ux3ZmlmWYtBTGwFy7gZxTfVSrqYS6U7VkcZPD0LS938sqec=
Received: from BN9PR03CA0410.namprd03.prod.outlook.com (2603:10b6:408:111::25)
 by SA1PR12MB8966.namprd12.prod.outlook.com (2603:10b6:806:385::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 21:36:22 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:111:cafe::ec) by BN9PR03CA0410.outlook.office365.com
 (2603:10b6:408:111::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.20 via Frontend Transport; Fri,
 5 Sep 2025 21:36:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:36:21 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:36:21 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:36:18 -0700
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
Subject: [PATCH v18 09/33] x86/resctrl: Add support to enable/disable AMD ABMC feature
Date: Fri, 5 Sep 2025 16:34:08 -0500
Message-ID: <e937c847dcf764f094e7ce72bb7bca2ae08210f9.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|SA1PR12MB8966:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cd8a0b8-41b5-4b87-c80e-08ddecc441c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jk/P8HBSGBV/d5qqDyBB1+hkKRvs4ESAyTYiImnGY/HMu2s9W4zr7o3D6ihk?=
 =?us-ascii?Q?arPEusTXMTC9us7yb3Pqa8OcxJ8W3ZIhDAUKKUkujxKmEePsSZPxOCrR+PQu?=
 =?us-ascii?Q?zahg5qw1FuwqBmF/A+BWycVQY9GwlHiR2hzeGL9gWKGiKf56RSddMdQiiZqb?=
 =?us-ascii?Q?Toncli37ccpXx3L7SrqwM/DcTZ4srk0pmYoCwfhwMs+Ue6xAIdzjnF0qnReG?=
 =?us-ascii?Q?hUngsF6a01GJ3fWa+0glWP6lkkUf8WxHJrafz6wt63xSg2EOgcFaBjKZBYw7?=
 =?us-ascii?Q?eZqpDG6Z3SbL6xWyM35Hxok0L8ip+Lb3VxkYFhnGrQuRvz0Jzk1JV3AyBqtn?=
 =?us-ascii?Q?JyW7GDb9Rcz0VlWlmg+hOEBLV0Cb/XkZTPMvHt7fRJcEt19B2yFiDUZUwzMh?=
 =?us-ascii?Q?9dOxnX4su33Hj+8z12HYaOFlSn5C0kynaLCwZbMo4mrvLiz2ya7BuPQp7e9z?=
 =?us-ascii?Q?bag7HD9S/Ii4V8O+EY7wGeF2+fCcAohVE37Eud4gXT0AYpECCb5QDzk7ye5S?=
 =?us-ascii?Q?xuSojbKdVADcH6v5XYCgyF86y7ByDmMfOpn7ZunJUX6ExIuuhDR07+RSvUfy?=
 =?us-ascii?Q?pXdUZiJapUKnyWtV53J7ajTenjpodK3xIB6MPrGG2+YP91WobCHD1uZT6XVb?=
 =?us-ascii?Q?8tEm2TA7aoLpLJFfZ4Arzt1WOS4uNw3OpWKlhxmJveT/chtG22U6VrE4nyj+?=
 =?us-ascii?Q?UQWXEy2ukrqBtSqw0MXY4qpnDTSyTbwcRnrdqTXpnV+wYJ+RcYuZISxOtbtI?=
 =?us-ascii?Q?lHh/LM9uVJl4kdCwsbt8OJlyY8vsiQ7BR7QtHbSs0Ct/taY1DcJQi49NRA/f?=
 =?us-ascii?Q?irB/QxjxMr2Glv2vMOivmtzGfsyyBFnOY/U7DoMCzH7MdB9cvd3r165LyM9s?=
 =?us-ascii?Q?WlWEcGu7dXtQY2kJ/MoXv5Ca8Wf8TD/jeY3oO3tr+pq821X8XH2GDJ3wRunl?=
 =?us-ascii?Q?n4ffvApjCC0edjLLx6RYuEQ+PHcuqLkYMX/VMhnAJpy2ysT0rGb2NzyZ6V2B?=
 =?us-ascii?Q?tGeWKzZ4kr7au2aaYxclFsnw77UJz9UTs1sPlBodxolfLyWMq+mou5g4ieTq?=
 =?us-ascii?Q?o71VyiNHJ/+dorUmNuFvoQdMWc1aMUjOFKT4Mu/Mw0MIXc5x9EAjEFZZZIyF?=
 =?us-ascii?Q?ek5FuoczWp8Ozw0scpKRBbB9UXqKQ49E7HzlIErH4neW2Ir97cGEAmN/mw1y?=
 =?us-ascii?Q?V19ySfHMxg/A8qZxFQ9+ntDFBCJbewgyrAnYLyHv3Xmh59EX+O0VpbEhu8Jz?=
 =?us-ascii?Q?6pY1VaNOWXJBXlLrw5n3OYN5lUb9OzGlzS32PL9itam80yyl1SucYgruTnll?=
 =?us-ascii?Q?sN4qIH2CSK+wcQtyjPwgs3yLWB6o+5New3v7nEGQ56UnWSFv0wW2AWLStC4F?=
 =?us-ascii?Q?J2DfRovNiC9TrqD3hPqMtjxP31152+TZDXVlJdZBO6xzFTcUZF6aiZOEUOgV?=
 =?us-ascii?Q?LTpAyRiLd+Gmgbn2xA/DGf1/tsGUFXKKm2SHBJMEK5DcSk3DRl6d/A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:36:21.6995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd8a0b8-41b5-4b87-c80e-08ddecc441c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8966

Add the functionality to enable/disable AMD ABMC feature.

AMD ABMC feature is enabled by setting enabled bit(0) in MSR
L3_QOS_EXT_CFG. When the state of ABMC is changed, the MSR needs
to be updated on all the logical processors in the QOS Domain.

Hardware counters will reset when ABMC state is changed.

The ABMC feature details are documented in APM [1] available from [2].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41 section 19.3.3.3 Assignable Bandwidth
Monitoring (ABMC).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: No changes.

v17: No changes.

v16: Added Reviewed-by tag.

v15: Minor comment change in resctrl.h.

v14: Added lockdep_assert_cpus_held() in _resctrl_abmc_enable().
     Removed inline for resctrl_arch_mbm_cntr_assign_enabled().
     Added prototype descriptions for resctrl_arch_mbm_cntr_assign_enabled()
     and resctrl_arch_mbm_cntr_assign_set() in include/linux/resctrl.h.

v13: Resolved minor conflicts with recent FS/ARCH restructure.

v12: Clarified the comment on _resctrl_abmc_enable().
     Added the code to reset arch state in _resctrl_abmc_enable().
     Resolved the conflicts with latest merge.

v11: Moved the monitoring related calls to monitor.c file.
     Moved the changes from include/linux/resctrl.h to
     arch/x86/kernel/cpu/resctrl/internal.h.
     Removed the Reviewed-by tag as patch changed.
     Actual code did not change.

v10: No changes.

v9: Re-ordered the MSR and added Reviewed-by tag.

v8: Commit message update and moved around the comments about L3_QOS_EXT_CFG
    to _resctrl_abmc_enable.

v7: Renamed the function
    resctrl_arch_get_abmc_enabled() to resctrl_arch_mbm_cntr_assign_enabled().

    Merged resctrl_arch_mbm_cntr_assign_disable, resctrl_arch_mbm_cntr_assign_disable
    and renamed to resctrl_arch_mbm_cntr_assign_set().

    Moved the function definition to linux/resctrl.h.

    Passed the struct rdt_resource to these functions.
    Removed resctrl_arch_reset_rmid_all() from arch code. This will be done
    from the caller.

v6: Renamed abmc_enabled to mbm_cntr_assign_enabled.
    Used msr_set_bit and msr_clear_bit for msr updates.
    Renamed resctrl_arch_abmc_enable() to resctrl_arch_mbm_cntr_assign_enable().
    Renamed resctrl_arch_abmc_disable() to resctrl_arch_mbm_cntr_assign_disable().
    Made _resctrl_abmc_enable to return void.

v5: Renamed resctrl_abmc_enable to resctrl_arch_abmc_enable.
    Renamed resctrl_abmc_disable to resctrl_arch_abmc_disable.
    Introduced resctrl_arch_get_abmc_enabled to get abmc state from
    non-arch code.
    Renamed resctrl_abmc_set_all to _resctrl_abmc_enable().
    Modified commit log to make it clear about AMD ABMC feature.

v3: No changes.

v2: Few text changes in commit message.
---
 arch/x86/include/asm/msr-index.h       |  1 +
 arch/x86/kernel/cpu/resctrl/internal.h |  5 +++
 arch/x86/kernel/cpu/resctrl/monitor.c  | 45 ++++++++++++++++++++++++++
 include/linux/resctrl.h                | 20 ++++++++++++
 4 files changed, 71 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a0c1dbf5692b..18222527b0ee 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1232,6 +1232,7 @@
 /* - AMD: */
 #define MSR_IA32_MBA_BW_BASE		0xc0000200
 #define MSR_IA32_SMBA_BW_BASE		0xc0000280
+#define MSR_IA32_L3_QOS_EXT_CFG		0xc00003ff
 #define MSR_IA32_EVT_CFG_BASE		0xc0000400
 
 /* AMD-V MSRs */
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 58dca892a5df..a79a487e639c 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -37,6 +37,9 @@ struct arch_mbm_state {
 	u64	prev_msr;
 };
 
+/* Setting bit 0 in L3_QOS_EXT_CFG enables the ABMC feature. */
+#define ABMC_ENABLE_BIT			0
+
 /**
  * struct rdt_hw_ctrl_domain - Arch private attributes of a set of CPUs that share
  *			       a resource for a control function
@@ -102,6 +105,7 @@ struct msr_param {
  * @mon_scale:		cqm counter * mon_scale = occupancy in bytes
  * @mbm_width:		Monitor width, to detect and correct for overflow.
  * @cdp_enabled:	CDP state of this resource
+ * @mbm_cntr_assign_enabled:	ABMC feature is enabled
  *
  * Members of this structure are either private to the architecture
  * e.g. mbm_width, or accessed via helpers that provide abstraction. e.g.
@@ -115,6 +119,7 @@ struct rdt_hw_resource {
 	unsigned int		mon_scale;
 	unsigned int		mbm_width;
 	bool			cdp_enabled;
+	bool			mbm_cntr_assign_enabled;
 };
 
 static inline struct rdt_hw_resource *resctrl_to_arch_res(struct rdt_resource *r)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 0a695ce68f46..cce35a0ad455 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -399,3 +399,48 @@ void __init intel_rdt_mbm_apply_quirk(void)
 	mbm_cf_rmidthreshold = mbm_cf_table[cf_index].rmidthreshold;
 	mbm_cf = mbm_cf_table[cf_index].cf;
 }
+
+static void resctrl_abmc_set_one_amd(void *arg)
+{
+	bool *enable = arg;
+
+	if (*enable)
+		msr_set_bit(MSR_IA32_L3_QOS_EXT_CFG, ABMC_ENABLE_BIT);
+	else
+		msr_clear_bit(MSR_IA32_L3_QOS_EXT_CFG, ABMC_ENABLE_BIT);
+}
+
+/*
+ * ABMC enable/disable requires update of L3_QOS_EXT_CFG MSR on all the CPUs
+ * associated with all monitor domains.
+ */
+static void _resctrl_abmc_enable(struct rdt_resource *r, bool enable)
+{
+	struct rdt_mon_domain *d;
+
+	lockdep_assert_cpus_held();
+
+	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+		on_each_cpu_mask(&d->hdr.cpu_mask, resctrl_abmc_set_one_amd,
+				 &enable, 1);
+		resctrl_arch_reset_rmid_all(r, d);
+	}
+}
+
+int resctrl_arch_mbm_cntr_assign_set(struct rdt_resource *r, bool enable)
+{
+	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
+
+	if (r->mon.mbm_cntr_assignable &&
+	    hw_res->mbm_cntr_assign_enabled != enable) {
+		_resctrl_abmc_enable(r, enable);
+		hw_res->mbm_cntr_assign_enabled = enable;
+	}
+
+	return 0;
+}
+
+bool resctrl_arch_mbm_cntr_assign_enabled(struct rdt_resource *r)
+{
+	return resctrl_to_arch_res(r)->mbm_cntr_assign_enabled;
+}
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index eb80cc233be4..919806122c50 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -445,6 +445,26 @@ static inline u32 resctrl_get_config_index(u32 closid,
 bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l);
 int resctrl_arch_set_cdp_enabled(enum resctrl_res_level l, bool enable);
 
+/**
+ * resctrl_arch_mbm_cntr_assign_enabled() - Check if MBM counter assignment
+ *					    mode is enabled.
+ * @r:		Pointer to the resource structure.
+ *
+ * Return:
+ * true if the assignment mode is enabled, false otherwise.
+ */
+bool resctrl_arch_mbm_cntr_assign_enabled(struct rdt_resource *r);
+
+/**
+ * resctrl_arch_mbm_cntr_assign_set() - Configure the MBM counter assignment mode.
+ * @r:		Pointer to the resource structure.
+ * @enable:	Set to true to enable, false to disable the assignment mode.
+ *
+ * Return:
+ * 0 on success, < 0 on error.
+ */
+int resctrl_arch_mbm_cntr_assign_set(struct rdt_resource *r, bool enable);
+
 /*
  * Update the ctrl_val and apply this config right now.
  * Must be called on one of the domain's CPUs.
-- 
2.34.1


