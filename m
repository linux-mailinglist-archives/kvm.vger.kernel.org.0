Return-Path: <kvm+bounces-56934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99150B465E5
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76661AC2693
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3282302776;
	Fri,  5 Sep 2025 21:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SkgrWmBY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2040.outbound.protection.outlook.com [40.107.95.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AC82F90CC;
	Fri,  5 Sep 2025 21:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108317; cv=fail; b=E1Kc4xslOOcF6q1ncN/tZ/qFnQxLXnSisp8OpTxYmiLYoAj0PZzYhkQU/tYnK7G0LF68hkc1CqbxjOymPDopKpeATGPd7o0lyKnzvZTZcjpzn2ARLRVtvW42aOVFdG19H0VvsySLHXoTQmXNLgmSCgSloboE38eTDragI82hAyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108317; c=relaxed/simple;
	bh=GS5Q/52HhQceAHJqW7A+F8udiwsgn4W6EkO1akBG9pU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CNKrKELHBG+TSv7YNW8GpP1/dG2CxY5Tx/ZbJClyMIQHWcjARmleJFVtthgn502s7uO7ndC0a7Ewt/UBnITFS+X/9Bl8xqOMuy81FXoTQGBpud+ccZ2o07VHBmloSIEWlnK0MvE1kvHpVxAzY/j1+U5o6gRt7SrenB1Id24e48o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SkgrWmBY; arc=fail smtp.client-ip=40.107.95.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RzxP9gnZc/tS3L1il82KyLnH/loLOq4Kn2gBT0/29FU9hwJJojuWHxt5hVH0LAQksdHWrThQByG9Kgwc3V67NOIeWAkZLo6+phkxeVDmqLdpRbTs4SANsSpDDzeA4h3lxbCU3z9dRxhB7ABoME8uWAwddBt4kJj4sPWAbfyj4YJ3swSai6cUHuHpmcbBG8YnVQ2t6spMM8/T+IWmx9RC4GTykuYiqCD9M+Cx+2/PWgFIGZheAm3yH6RDz5/hyQ6pN17TiHkhXCr2Q+klNTBXIgs6cOQOsMpkcaVc//6l+Lncub6dVeXq1h1Ki7fF/0AjvohMssrSK4fxrG/CQTvHDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dhIg3KlhT6xSCzjVPY+opGWZrZCi1EBsjm0od61hgGw=;
 b=CGm8B14AuqbPTUrdd6X0gIrzKo9myteYz+3cj4Zs3MEZvqoFQsBXtHpXBRurEF/pfxJwMXdR2/K1cB9VVMMtpccOxBCbLei/ZYozv0PIGqwcAMK7C6P/WqwBfbQdbPE63MfNfGiMG8vGb6ZKIDFWRn1ErbBVmtda3RBGgcRsxBe30DGBJ8ZYyJXj4J3PLUMOZradsFiEIBWR719+q0nC1HE411eOFn93iyjxGqqfh0hIZzMty1A4Seh1dtTHD+XJTbEFfwVoR1VU6qIhYoLa1yR3TSNT2KL4PjWdtxVsWSi3vgghAYdlCssDyvkfyAZG+44ojuUKWHEpAKhIGVbIKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dhIg3KlhT6xSCzjVPY+opGWZrZCi1EBsjm0od61hgGw=;
 b=SkgrWmBYzhsCuHt+WrNjNn8UqFVZRHB2W5J5usMuea5OLo2U5SZN9/jvClCiGOnPWx6SuvRinC1aLUS+QJQamabw9R+8fkmPmzdD/gjpm3Tf92PN/TTewG61qt85ghEzdLJBUSrZed7TkcNm1wt76EGN+g9oVMinkmfgjNFCMFQ=
Received: from DS7PR03CA0350.namprd03.prod.outlook.com (2603:10b6:8:55::27) by
 DS0PR12MB7827.namprd12.prod.outlook.com (2603:10b6:8:146::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.29; Fri, 5 Sep 2025 21:38:31 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:8:55:cafe::cf) by DS7PR03CA0350.outlook.office365.com
 (2603:10b6:8:55::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Fri,
 5 Sep 2025 21:38:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:38:31 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:38:30 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:38:28 -0700
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
Subject: [PATCH v18 22/33] x86/resctrl: Implement resctrl_arch_reset_cntr() and resctrl_arch_cntr_read()
Date: Fri, 5 Sep 2025 16:34:21 -0500
Message-ID: <8ef30aebd36972ea63f422f28b465fc4b2544fa4.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|DS0PR12MB7827:EE_
X-MS-Office365-Filtering-Correlation-Id: eea1d9e7-5aac-46c7-3b39-08ddecc48f0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rO2PrRNl2ChwBEj5NxKXcl4Vf0UhKy26PV6vpnxO/JAZFC4GXse9ymEmlPjE?=
 =?us-ascii?Q?8//t9qQtTEbeU72NibaaPgeEGJhXZOpTvOXhWAOjwSml3GHP/L+93TNt4FiP?=
 =?us-ascii?Q?9OCvDMry9/xDQXgLsNGayBIfR3QwdfR72R4BbIKV8qJiDLJlLDzVfA2C5Gv3?=
 =?us-ascii?Q?coaMNTkV3Uc4ksPO9ycdC2y+aaNgH1I9LrimcFFBOITWPlA2vVIOsYm7DKLP?=
 =?us-ascii?Q?r99i157JXKZXPhgZDK+FhrNR18fzqbR6Bw63BDjT8FWMjMj6Xza6wKkxcZKP?=
 =?us-ascii?Q?VfEgt5QptQa/zuXW/BgTO9jbTzroIw9oQScZSmYGOPfYucKS/7g3i0yjj7HI?=
 =?us-ascii?Q?k2b1873vESCGHxwTqN/0DSk6gE8LB0fAlZrzN5JHNH+Uxb+msNDGdqATGd5V?=
 =?us-ascii?Q?hrbVYVOOnAwRyi1pxNR9oCeqKOeAA2GR1GYJil75QU5lYKaFetTaCWMsDZur?=
 =?us-ascii?Q?tewDAaCBJWRrmL06LcFUjrSAWZb2WFjyDvPWes4Y1HiauuKtiSgx6sDB6UW1?=
 =?us-ascii?Q?tzn1Karq8AKkJfnXgOOVWqNaN2rhrj2BjQ6F18lCq2ijjcjfjYcT5yFDSC+M?=
 =?us-ascii?Q?Z4fNM8oNxEnUpXAJnItbldxJJlGEtNnFSPiexZZOjOlAHtoFKVj01YCHJeEL?=
 =?us-ascii?Q?scmYC418O4+Iyo7zpW6dxvFaVygjZbFgcLUJUI0YcipECA2VxmzKizdvoZpi?=
 =?us-ascii?Q?vMBYFVsWFKqF2Cmjpw8m/XCFVnIIK7p28ppzWm12v/XQiO7fSHau2DkxSbxH?=
 =?us-ascii?Q?e2IfU0HeT2FRjlDqUcvy6ikHyVbUkLMMhY06uFFTT0hBFhFl7hERjLDA+roa?=
 =?us-ascii?Q?ds8Zzy5PGfZ+hh6jPDxCikgt5UW2dOLzrxGe71woCRpW7rakwu/oRZhIfDqj?=
 =?us-ascii?Q?h1lrnTrUcD0UbKinilCGYQj1//hMWLsOdl65asxzLTuz/nx5E9DxPYUct5N0?=
 =?us-ascii?Q?VIGGV3VW0ik5sA2R249sLxUbhexkkpB1/d8cGoanj+v+Zf+Ypnr5pObXzkbr?=
 =?us-ascii?Q?jRmKFFRZ3IPJ8DudnuqONjKcRiDg1nuiZiuTtLD3ZH8LSFxYshGhSbHnwYMI?=
 =?us-ascii?Q?1inZDR8EI7FYjeqL+n3Bcrrhf6RJQFcY/8aM4+3mbKw6uYAkYcplrQQL/nzn?=
 =?us-ascii?Q?+NXx0nEghEHgRil6FcMS5lV76LOBv/OUdegF6DWR+wA4c/uq6osGd0tslNY7?=
 =?us-ascii?Q?Cb0A5kEuE6vAAJc+FshXc3QPHzbXS0GDZIKPiM2DHL/Nx1l8pVtnNCwkltzn?=
 =?us-ascii?Q?KkOR3QLa0UXpMahYTHcw8JSSTlspomCIBoYaILe/wm5vE5ilGW2G22U3JIKx?=
 =?us-ascii?Q?bgJAWjJXeykHZ3WkPPtxh/WGuUwIEZCkYhUYHRXPsIOcm9HJN26Njd7puDyX?=
 =?us-ascii?Q?U8WLZcCsAhHkPGhYW/BbQZcc4YAxxBUEMfS8kLE77FhR5Qt5aJ6djtBiUm4U?=
 =?us-ascii?Q?DjLTY1OUGPc4mqGOU74gncUU4mha7mgEZs2vfUNMNG7+QBUcby9yPKisjBiT?=
 =?us-ascii?Q?2PaKaH/WDgJDCsEM8m7txLjQmap+RLT7WYfXNdpmvcnMasITec1PAfs4Ow?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:38:31.3542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eea1d9e7-5aac-46c7-3b39-08ddecc48f0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7827

System software reads resctrl event data for a particular resource by
writing the RMID and Event Identifier (EvtID) to the QM_EVTSEL register and
then reading the event data from the QM_CTR register.

In ABMC mode, the event data of a specific counter ID is read by setting
the following fields: QM_EVTSEL.ExtendedEvtID = 1, QM_EVTSEL.EvtID =
L3CacheABMC (=1) and setting QM_EVTSEL.RMID to the desired counter ID.
Reading the QM_CTR then returns the contents of the specified counter ID.
RMID_VAL_ERROR bit is set if the counter configuration is invalid, or
if an invalid counter ID is set in the QM_EVTSEL.RMID field.
RMID_VAL_UNAVAIL bit is set if the counter data is unavailable.

Introduce resctrl_arch_reset_cntr() and resctrl_arch_cntr_read() to reset
and read event data for a specific counter.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: Added Reviewed-by tag.

v17: Updated changelog.
     Updated code comment little bit.

v16: Updated the changelog.
     Removed the call resctrl_arch_rmid_read_context_check();
     Added the text about RMID_VAL_UNAVAIL error.

v15: Updated patch to add arch calls resctrl_arch_cntr_read() and resctrl_arch_reset_cntr()
     with mbm_event mode.
     https://lore.kernel.org/lkml/b4b14670-9cb0-4f65-abd5-39db996e8da9@intel.com/

v14: Updated the context in changelog. Added text in imperative tone.
     Added WARN_ON_ONCE() when cntr_id < 0.
     Improved code documentation in include/linux/resctrl.h.
     Added the check in mbm_update() to skip overflow handler when counter is unassigned.

v13: Split the patch into 2. First one to handle the passing of rdtgroup structure to few
     functions( __mon_event_count and mbm_update(). Second one to handle ABMC counter reading.
     Added new function __cntr_id_read_phys() to handle ABMC event reading.
     Updated kernel doc for resctrl_arch_reset_rmid() and resctrl_arch_rmid_read().
     Resolved conflicts caused by the recent FS/ARCH code restructure.
     The monitor.c file has now been split between the FS and ARCH directories.

v12: New patch to support extended event mode when ABMC is enabled.
---
 arch/x86/kernel/cpu/resctrl/internal.h |  6 +++
 arch/x86/kernel/cpu/resctrl/monitor.c  | 69 ++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 6bf6042f11b6..ae4003d44df4 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -40,6 +40,12 @@ struct arch_mbm_state {
 /* Setting bit 0 in L3_QOS_EXT_CFG enables the ABMC feature. */
 #define ABMC_ENABLE_BIT			0
 
+/*
+ * Qos Event Identifiers.
+ */
+#define ABMC_EXTENDED_EVT_ID		BIT(31)
+#define ABMC_EVT_ID			BIT(0)
+
 /**
  * struct rdt_hw_ctrl_domain - Arch private attributes of a set of CPUs that share
  *			       a resource for a control function
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 1f77fd58e707..0b3c199e9e01 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -259,6 +259,75 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 	return 0;
 }
 
+static int __cntr_id_read(u32 cntr_id, u64 *val)
+{
+	u64 msr_val;
+
+	/*
+	 * QM_EVTSEL Register definition:
+	 * =======================================================
+	 * Bits    Mnemonic        Description
+	 * =======================================================
+	 * 63:44   --              Reserved
+	 * 43:32   RMID            RMID or counter ID in ABMC mode
+	 *                         when reading an MBM event
+	 * 31      ExtendedEvtID   Extended Event Identifier
+	 * 30:8    --              Reserved
+	 * 7:0     EvtID           Event Identifier
+	 * =======================================================
+	 * The contents of a specific counter can be read by setting the
+	 * following fields in QM_EVTSEL.ExtendedEvtID(=1) and
+	 * QM_EVTSEL.EvtID = L3CacheABMC (=1) and setting QM_EVTSEL.RMID
+	 * to the desired counter ID. Reading the QM_CTR then returns the
+	 * contents of the specified counter. The RMID_VAL_ERROR bit is set
+	 * if the counter configuration is invalid, or if an invalid counter
+	 * ID is set in the QM_EVTSEL.RMID field.  The RMID_VAL_UNAVAIL bit
+	 * is set if the counter data is unavailable.
+	 */
+	wrmsr(MSR_IA32_QM_EVTSEL, ABMC_EXTENDED_EVT_ID | ABMC_EVT_ID, cntr_id);
+	rdmsrl(MSR_IA32_QM_CTR, msr_val);
+
+	if (msr_val & RMID_VAL_ERROR)
+		return -EIO;
+	if (msr_val & RMID_VAL_UNAVAIL)
+		return -EINVAL;
+
+	*val = msr_val;
+	return 0;
+}
+
+void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+			     u32 unused, u32 rmid, int cntr_id,
+			     enum resctrl_event_id eventid)
+{
+	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	struct arch_mbm_state *am;
+
+	am = get_arch_mbm_state(hw_dom, rmid, eventid);
+	if (am) {
+		memset(am, 0, sizeof(*am));
+
+		/* Record any initial, non-zero count value. */
+		__cntr_id_read(cntr_id, &am->prev_msr);
+	}
+}
+
+int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+			   u32 unused, u32 rmid, int cntr_id,
+			   enum resctrl_event_id eventid, u64 *val)
+{
+	u64 msr_val;
+	int ret;
+
+	ret = __cntr_id_read(cntr_id, &msr_val);
+	if (ret)
+		return ret;
+
+	*val = get_corrected_val(r, d, rmid, eventid, msr_val);
+
+	return 0;
+}
+
 /*
  * The power-on reset value of MSR_RMID_SNC_CONFIG is 0x1
  * which indicates that RMIDs are configured in legacy mode.
-- 
2.34.1


