Return-Path: <kvm+bounces-56928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D4E8B465D2
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33E275834A0
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E8C3002AD;
	Fri,  5 Sep 2025 21:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3moXs7jz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96552FABFC;
	Fri,  5 Sep 2025 21:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108254; cv=fail; b=T1tRNIZ9vrckr90bWoYEpXHaPShGnlThWmRj9tZbCm5RaX2H3lLrDVF3r7saSWSQDG0uA3Z9+uozG6d5seBhHKmPHYfF4f+RSZ5f3yeZV1f7dD7cs4n+p0iG/9+uboQkCPUMsxwrwVnD8yfkhQrxmfvyS01oPGoFXf/zJ+lCO0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108254; c=relaxed/simple;
	bh=cdrgl4HV/1m6/VGb+Bdxj3Ix6QpTv3RPl3Vh/GBTBMA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ixjrtHwv4sd78P/K+JV72OSDiaSbiJcl5rJIGjAOmhn9DDMXGlPngmBUzmlNE2T3SUb+JIO/ulzXvRPXmQz2bUnhHZvdMZ6SfHJ6wU5uRw3jQi5Olv0GXHsCvR1+/YYDrD+Zht+00ti4v6M80IjMGlI5czyhPGHIX6JgYuEZjk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3moXs7jz; arc=fail smtp.client-ip=40.107.236.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IWRHVYri08KaBdcbjvX6WxXqpVznQo10TC2R1LJ/ckeY88afnpG5w3HOz4SBADdyvI/D0/8GmnxS8x53jTrBfpu8TIcjwcvOcc5QgG6bJdlySt1rkK8CFAczQx3ji4aevfOoYxXjMgLTWsNeJ6mng7k0mVbbja8kYPlFNat+v7+CDP0v8rp5Ijw8ZuKGqNWw27JzZISSOgylacMJ6iB/u7JhfBIVfBR1m8xuBOtMo+oAlEyLO0AiqOy8tO/ljtLEc34rlwqQ7s+30QPhxBLx04laaLMAijKJoHRPuZEnlmj43II+p+ymznHsF1w06yL2zEiKNJmdjpu15RcJAGbWHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANo+EJOGfoirgRWFzJuA5So8QgjJt6rwwzpAi2Gqfy4=;
 b=zN/lVcSpSmur5s/sLIRbY5G5drMXT+zhPMiloLVV7rQ9r9fcOcft7Wd4VTbYEO8wAIoBebyHhS5bGtGofct9Mg60vO95p0pMwt1EqTlzxZF9yrC207Q7PIsPBs+A2bP5Nl6hr/rX0fh2EXEjSo5Gy+5oQSbGOc+1hLnaiLytq4XUnhKZlQIaSSr1xgGYRit3S4Qz7F1b20uquW12aSoV1wAFLUfsTp1QRZ6cBzxYjTV/+N9qJzS+x2h8qK/eKEw6cej6NKjz6bh+bsviqjIddtEX/hr2mzY3B9vl9crSjTgowJgZqR8wnm2dBSM+HbXpsGxfxbw4JmfouT1SEXsDxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANo+EJOGfoirgRWFzJuA5So8QgjJt6rwwzpAi2Gqfy4=;
 b=3moXs7jzT1Fv2qn4gpDJX+IYsGazEYZC36L2N5jHZ0ZMzHowD6pPUI3/KW9WTju9clJmVRKaDj2iXdkcz1VH/jxVMcoJXexN70qZyLpwc+rTA1ndSgvoRh2PndVgltlMT8W8TiEBXFv5w+KN+wszsTKsTetkNxFrq6FaIf9pz9s=
Received: from SJ0PR13CA0016.namprd13.prod.outlook.com (2603:10b6:a03:2c0::21)
 by DS0PR12MB7780.namprd12.prod.outlook.com (2603:10b6:8:152::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 21:37:24 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::1c) by SJ0PR13CA0016.outlook.office365.com
 (2603:10b6:a03:2c0::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.9 via Frontend Transport; Fri, 5
 Sep 2025 21:37:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:37:23 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:37:22 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:37:20 -0700
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
Subject: [PATCH v18 16/33] x86,fs/resctrl: Implement resctrl_arch_config_cntr() to assign a counter with ABMC
Date: Fri, 5 Sep 2025 16:34:15 -0500
Message-ID: <fc76658255a1e5e474cbfc4cab92df601f929a65.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|DS0PR12MB7780:EE_
X-MS-Office365-Filtering-Correlation-Id: f66c3f9d-3e68-42d6-5394-08ddecc46687
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GnSL+lVw5wLqEWHo9nEAJ8eRsYcoVHN2EvTkN9iG6PhIQH+nQAqopTr6SevE?=
 =?us-ascii?Q?CVOXDBkRLZf6L0PRrmKzj+kkv2rqzmvBUHhNCGqOro+KI9j1taYKlLGpRogb?=
 =?us-ascii?Q?jHH56wW3gzhsKzSl0vjb1YYIxXc2FhuoxAc5NbzgYK8P1zDbzpF7iK3v5MSj?=
 =?us-ascii?Q?prabnqTrLXIhbGEjeAXkr5bQypCG6Tc1w43ZhduuWuPRRf9Szp0cTTNez1y4?=
 =?us-ascii?Q?lzQ6CbKJsk8igRGkS81J0hQzSmmfekHgE64XSPI31wKhA8Fz9+iIgbTXxMMj?=
 =?us-ascii?Q?Jo8U2/kDZpecptJDmyqNRK348ART/IBswB/MVFRlwVHfz5YomFq9bpThxwLO?=
 =?us-ascii?Q?benhaOmaLnB/fbsid9qeRBzkHhzg6Fj+stEQyUl3Fs4DwpnTmIEu56ziiiPv?=
 =?us-ascii?Q?Yds86dzuJZ4lmaBCu8knUOlhYZ/1XdajbdcQXuWw/D1iS+YcBhVvrckFdRTg?=
 =?us-ascii?Q?Dq10HeSslWeZkWG/1up+8PHQz7BRNlak20+nyLHJClcCfrsW4p2Tld4eHghV?=
 =?us-ascii?Q?S48X1eqV9IQhK0BlrYPVOSsJ2a0gENYaq+18hVcWCrWJVaNCUyCkGIE6JYdx?=
 =?us-ascii?Q?/hSqWoprrKRlgZbYcveFPN550Iq/JL22FOTvG846S3e/d7QUZrwKXkn2eT4D?=
 =?us-ascii?Q?smPrOTvUzYpEwt3oM174xv8pTP7CtXD/+m0iq6xQBFiviiwU54r4PHwYcR3O?=
 =?us-ascii?Q?zTSNbVRvOec5pf1yR9QbzmErPwjB47TSisD0QRrUPaExKwVMIoaXMUaopBRT?=
 =?us-ascii?Q?X/2R87dHgZbBY0VQ2a/w+JDVYJvy0accXy9UvNKxrDcxOFOzeorcSLCdu3sF?=
 =?us-ascii?Q?MSCcsWtXmAyOUcYx7w7Mvq/ZJIMJMl6HSqb+zrad9BUQpeHoAssnUp7OYAbB?=
 =?us-ascii?Q?a+YmqjWzXH82pIrOc9ijePUIn1GA+300QCUcl3kgGiqM7oTDogOMXI52rIBJ?=
 =?us-ascii?Q?G26vrEgz7zuoF+bKlN2WCE+3vYstdpr0a3BI/kv/q9+/qX7zXV+gJIIi10IY?=
 =?us-ascii?Q?xV4eim/dorJt+naSGSwVNdKRlWsvaLB8TkpcduJcKfsxVsf1akvUgeVG+Dhq?=
 =?us-ascii?Q?OMBp3fazmUW6hfccFRZMxll0WhXgxJjpcjONlzUmo7UQmdSslk0AhshjB46Q?=
 =?us-ascii?Q?SsSQZXBK8qm4BKKAyJ0py22E2u7WaOV4FAlSrFzNa+Y22hTE8ffQx8B545LS?=
 =?us-ascii?Q?YEa9BDTMaCSBcPWELxUeCf3Gi2o9/XagXMvJ1fN2q+yuhtldL9omGZSQj7Gz?=
 =?us-ascii?Q?zZGd82YU/fJN8GSyDAWUjlYZ273T94h/pe1xjgJ96jppQA01rDLrZbmL3F+K?=
 =?us-ascii?Q?biIFx5DgfBLQHJaAwEai89Izj/fVeYmnTKcNP0s6d4wPR8HILtCedon3W8LY?=
 =?us-ascii?Q?fXfdHE+kHPcRGdIt0UwprBnCmpTbMVpxWWqJT0EU4J/cyXXW83KaQ7NapEC3?=
 =?us-ascii?Q?IYiN8QR4wHOQsHvdM12PPsfNV+3m5gr0CPQdSduE6x+yfP9L6FBCoQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:37:23.3489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f66c3f9d-3e68-42d6-5394-08ddecc46687
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7780

The ABMC feature allows users to assign a hardware counter to an RMID,
event pair and monitor bandwidth usage as long as it is assigned. The
hardware continues to track the assigned counter until it is explicitly
unassigned by the user.

Implement an x86 architecture-specific handler to configure a counter. This
architecture specific handler is called by resctrl fs when a counter is
assigned or unassigned as well as when an already assigned counter's
configuration should be updated. Configure counters by writing to the
L3_QOS_ABMC_CFG MSR, specifying the counter ID, bandwidth source (RMID),
and event configuration.

The ABMC feature details are documented in APM [1] available from [2].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
    Publication # 24593 Revision 3.41 section 19.3.3.3 Assignable Bandwidth
    Monitoring (ABMC).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added the text about the documentation link.

v17: Added Reviewed-by tag.

v16: Updated the changelog.
     Reset the architectural state in resctrl_arch_config_cntr() in both
     assign and unassign cases.

v15: Minor changelog update.
     Added few code comments in include/linux/resctrl.h.

v14: Removed evt_cfg parameter in resctrl_arch_config_cntr(). Get evt_cfg
     only when assign is required.
     Minor update to changelog.

v13: Moved resctrl_arch_config_cntr() prototype to include/linux/resctrl.h.
     Changed resctrl_arch_config_cntr() to retun void from int.
     Updated the kernal doc for the prototype.
     Updated the code comment.

12: Added the check to reset the architecture-specific state only when
     assign is requested.
     Added evt_cfg as the parameter as the user will be passing the event
     configuration from /info/L3_MON/event_configs/.

v11: Moved resctrl_arch_assign_cntr() and resctrl_abmc_config_one_amd() to
     monitor.c.
     Added the code to reset the arch state in resctrl_arch_assign_cntr().
     Also removed resctrl_arch_reset_rmid() inside IPI as the counters are
     reset from the callers.
     Re-wrote commit message.

v10: Added call resctrl_arch_reset_rmid() to reset the RMID in the domain
     inside IPI call.
     SMP and non-SMP call support is not required in resctrl_arch_config_cntr
     with new domain specific assign approach/data structure.
     Commit message update.

v9: Removed the code to reset the architectural state. It will done
    in another patch.

v8: Rename resctrl_arch_assign_cntr to resctrl_arch_config_cntr.

v7: Separated arch and fs functions. This patch only has arch implementation.
    Added struct rdt_resource to the interface resctrl_arch_assign_cntr.
    Rename rdtgroup_abmc_cfg() to resctrl_abmc_config_one_amd().

v6: Removed mbm_cntr_alloc() from this patch to keep fs and arch code
    separate.
    Added code to update the counter assignment at domain level.

v5: Few name changes to match cntr_id.
    Changed the function names to
      rdtgroup_assign_cntr
      resctr_arch_assign_cntr
      More comments on commit log.
      Added function summary.

v4: Commit message update.
      User bitmap APIs where applicable.
      Changed the interfaces considering MPAM(arm).
      Added domain specific assignment.

v3: Removed the static from the prototype of rdtgroup_assign_abmc.
      The function is not called directly from user anymore. These
      changes are related to global assignment interface.

v2: Minor text changes in commit message.
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 36 +++++++++++++++++++++++++++
 include/linux/resctrl.h               | 19 ++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index cce35a0ad455..ed295a6c5e66 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -444,3 +444,39 @@ bool resctrl_arch_mbm_cntr_assign_enabled(struct rdt_resource *r)
 {
 	return resctrl_to_arch_res(r)->mbm_cntr_assign_enabled;
 }
+
+static void resctrl_abmc_config_one_amd(void *info)
+{
+	union l3_qos_abmc_cfg *abmc_cfg = info;
+
+	wrmsrl(MSR_IA32_L3_QOS_ABMC_CFG, abmc_cfg->full);
+}
+
+/*
+ * Send an IPI to the domain to assign the counter to RMID, event pair.
+ */
+void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+			      enum resctrl_event_id evtid, u32 rmid, u32 closid,
+			      u32 cntr_id, bool assign)
+{
+	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	union l3_qos_abmc_cfg abmc_cfg = { 0 };
+	struct arch_mbm_state *am;
+
+	abmc_cfg.split.cfg_en = 1;
+	abmc_cfg.split.cntr_en = assign ? 1 : 0;
+	abmc_cfg.split.cntr_id = cntr_id;
+	abmc_cfg.split.bw_src = rmid;
+	if (assign)
+		abmc_cfg.split.bw_type = resctrl_get_mon_evt_cfg(evtid);
+
+	smp_call_function_any(&d->hdr.cpu_mask, resctrl_abmc_config_one_amd, &abmc_cfg, 1);
+
+	/*
+	 * The hardware counter is reset (because cfg_en == 1) so there is no
+	 * need to record initial non-zero counts.
+	 */
+	am = get_arch_mbm_state(hw_dom, rmid, evtid);
+	if (am)
+		memset(am, 0, sizeof(*am));
+}
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 87daa4ca312d..50e38445183a 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -594,6 +594,25 @@ void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *
  */
 void resctrl_arch_reset_all_ctrls(struct rdt_resource *r);
 
+/**
+ * resctrl_arch_config_cntr() - Configure the counter with its new RMID
+ *				and event details.
+ * @r:			Resource structure.
+ * @d:			The domain in which counter with ID @cntr_id should be configured.
+ * @evtid:		Monitoring event type (e.g., QOS_L3_MBM_TOTAL_EVENT_ID
+ *			or QOS_L3_MBM_LOCAL_EVENT_ID).
+ * @rmid:		RMID.
+ * @closid:		CLOSID.
+ * @cntr_id:		Counter ID to configure.
+ * @assign:		True to assign the counter or update an existing assignment,
+ *			false to unassign the counter.
+ *
+ * This can be called from any CPU.
+ */
+void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+			      enum resctrl_event_id evtid, u32 rmid, u32 closid,
+			      u32 cntr_id, bool assign);
+
 extern unsigned int resctrl_rmid_realloc_threshold;
 extern unsigned int resctrl_rmid_realloc_limit;
 
-- 
2.34.1


