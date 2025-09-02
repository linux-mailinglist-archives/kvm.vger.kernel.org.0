Return-Path: <kvm+bounces-56642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 624BFB4102D
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 00:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50EA85E613C
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 22:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A6727FD74;
	Tue,  2 Sep 2025 22:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MZI6YSng"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403522773E9;
	Tue,  2 Sep 2025 22:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852946; cv=fail; b=Bhz2a1s67ZTa6bT91dhaGHhmWQ61LycY3bO4Ef/9V6G8bQI/sLHNBUrVbupNbpIKkajjbkGEOI0rAt+1gzTPpdQYJ5xuRsWSa+SZvyisEgGNdIYY+cdQMXKVl0bA80LYauXAFxsnjqfj7FgeaIPWF1iEtRXfFoyj79xtxRlyRoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852946; c=relaxed/simple;
	bh=joD8sbleMIM2ePulVHiU9ExdAGtWwfE71asQFGXSAlQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SM2BVcexZUFQYVn+szuSMHIleT8gvQA90xUA3hTz0V+50eNoP5RZxxE1llr8A//sopTasVLGZu8ue6o4OtC7BTSy292Vn1I3qkdMy/hSA1yoBRprrWnc6Hl9RhVs436xNsx/SR6S+/BpuWEjk4s5S6zYE3lL4eHi2tFpmmjxzXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MZI6YSng; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MerEuYmE5hZq47MhASZgfMcxmKcu3Lo8O5FANVs9oYPl5hp2pOJBcXI2sCJWTO0pOjxmkLAENS2W8wh5N4WkTDfuVpZJ9jcJ7PheNawKfqq0RHthD+vbW6cdqKmsPfaoQYbHk5NzWBZKdX/vEyrZkQ/jGNE9WrD3Zeore6YSmu/nUaXYYuVk4Sz1SftGa9R0gFd4vyMF2so62marL7jqa4/+SHnxjxMiaa+xUg1BxM4uqcz6lTjgZ4X9Q4dDU4LXQR2Wu6ofyh8368bN84TKTirpmupMMS/akqmaVR63Cvu+spMaKTSGnuBGGkHRKZUpXP/1II8flZEFH0VxBOWcVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHhhwhWBOVcuv9hWajTcmjOMFQp90IZmNkal1johD84=;
 b=VEIiVnYqw3+mjkO+7WYhT8m2FM7gAe/nw558Yv13McUXPL5IggZFo73ZLgWlrg8A+I2Zs7X/Fy8Iw/X+RfM4DQ7Pl6gmxPJZUzUbFVUDfuHyL4hHtOHiM15yyacfJXl4W6k5y1ZhAlG0Qe2fbC1y+krVMaZz6d0f7jffoREwZl636ZXh82AmRG6z/Vbykg+HZjo6lDz8fHKt80PS3dxach78WXiwNqhMAkR10uvFE3WIOFSj9VhsL8sLm3YxsYnBTqiPmp2j5rUevHgQYvXZFR/1ifAD8GoW8tVPMfnwQStgf267nUuT1vVWt1r3T5W7v4UwiFX73b62iLIRcZrgLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHhhwhWBOVcuv9hWajTcmjOMFQp90IZmNkal1johD84=;
 b=MZI6YSng8AOB2W96WCuPFPw9bpYv+P1nrDlc/qFiTBtHyseExnNPnn+Q1Cyh4mBeqQxB/2oIHY1pYf4F8q7giq9wfLEAWpb09H0a1Cgo4gCzHKxVhyDZDXzfadJuzYIp9RvYAdN6gdLcCBx8OKZa01fpi/z/iz4VLovxW49l6hI=
Received: from BN9PR03CA0350.namprd03.prod.outlook.com (2603:10b6:408:f6::25)
 by LV5PR12MB9801.namprd12.prod.outlook.com (2603:10b6:408:2fc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Tue, 2 Sep
 2025 22:42:20 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:408:f6:cafe::73) by BN9PR03CA0350.outlook.office365.com
 (2603:10b6:408:f6::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Tue,
 2 Sep 2025 22:42:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 22:42:19 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 2 Sep
 2025 17:42:14 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 2 Sep
 2025 15:42:12 -0700
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
Subject: [PATCH v9 04/10] x86,fs/resctrl: Implement "io_alloc" enable/disable handlers
Date: Tue, 2 Sep 2025 17:41:26 -0500
Message-ID: <c7d90ec5ab2c96682b6eca69b260631847061a61.1756851697.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|LV5PR12MB9801:EE_
X-MS-Office365-Filtering-Correlation-Id: aa1442d6-1f24-47fc-b18b-08ddea71f9cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9R93AEnHTtrbNczyCPxho7A+n4Ylt+bZTDPLIPMcsFjxOoihRJ6v/qYHuDfm?=
 =?us-ascii?Q?tdl1/uJAhAroQTcMc6c6uiH8wAgyLhs4IopvmH51Hi+ugcCWER4zAYv7b4rH?=
 =?us-ascii?Q?93mAuNLkuKQWLB8o4X1TtLx5VmEqEw5T2Vt1DDQN2hGSeSUtLtnYJ1CrdgeV?=
 =?us-ascii?Q?8G21a2XGtU1QLB75O2R45nKvdGVwPAIwH8/bI2n5gJBmNybZpR4vytLVbLuL?=
 =?us-ascii?Q?DzlqkxrVE1ucQGiYXYpXsmSZ7mAkfbh29QXWGCdL4y2P3C9p5eyIyvkFoQdx?=
 =?us-ascii?Q?ooKwr6PeU/sv2rV5omXA53owczHasKd5vO1Ssxoxj2p/AuSboJ4ofG4b4erD?=
 =?us-ascii?Q?c2ITfEOyBCvaa7YGj94WNTZe1PYd+445G10kID5p2UdlTIV1BmnvKQUVdPRY?=
 =?us-ascii?Q?D220pAQPNiLSNBNE/FCCwSjjxbq2wxo+OhIDjNlECsjD7EfHj3OUNwHC6GJ8?=
 =?us-ascii?Q?VEbUwoJk4OU2LsSRMkL+JBcxAjm8n9yi+KlyGGVCIQeeII/W9k/fTM3y7uCE?=
 =?us-ascii?Q?fjITOD1qeVTIOvmeJjL3q25aHyw7HADdiWP+gDacBacm8GQoDfA327lPsWsH?=
 =?us-ascii?Q?zLXrNgdSxYtqRLx1yQy1+K6VDVmcynGseqPMd0XyfmDmdHH4cSWL8s1XcSm/?=
 =?us-ascii?Q?z2xUC3fYpb2kZ6sItL8u7s1Diz/mxW8uxz0HXyW4YLFuHk6LFTnbea3ElBnS?=
 =?us-ascii?Q?WwtC2fKRg3gwIKBwmte05JDRzEfASmSnCsINpCki8jlykLhQ5YTT681hwOaW?=
 =?us-ascii?Q?aeT7DT+sVrMExtb22Z/FdvJAbH2rSFAhY/Gsx31Qv/ug4Hfn8zRwiRiCGZIJ?=
 =?us-ascii?Q?vFSOjiPDASchLie9cJEG9XIuKfUnoARL/84jVnV7WeMJc2XfaC4wS0Hjzr0b?=
 =?us-ascii?Q?lXirWZ1QWQGLjqi2yjL518fTmABubq/2nHV4qst8YhKhFgenlaAWcHx9ZKvm?=
 =?us-ascii?Q?HV0fug7NfgLZEfOvie/TePW8mOK59Jxi6xaxSi0q6Jd2mThFgN7owUIYmAQc?=
 =?us-ascii?Q?jDCGrxEKYRgmgkjp1y8OWQhprCGvijaQviNf0FuwqVr4GtDchxC6JU7/c18F?=
 =?us-ascii?Q?uNcTXrL0P5smOpjMH6tRYbOqLjJ+j54VNelTkblOuNM+uUlmIcyg6QQwTskc?=
 =?us-ascii?Q?OSPD8fyzc/HL5yswCZCRK2yQzCI/EOR+Joj5f0E1hyp9lEzfX388ckkzdeVi?=
 =?us-ascii?Q?pUAPmUK05p03MHwmKbtaEmIv2gVbgoTOs3gZl+G/Rysldq3lOkZE/f8ZddEF?=
 =?us-ascii?Q?BlW1VmvMROR8K3XdoSIX3NNluJDKlKhi2io6xQA2cRZbV8kNqY6Pk2CB54z3?=
 =?us-ascii?Q?JO5uT7U5WlMKG+b7qXFzi06UwBdLG7l9K1JvCjtnbpX7cxwz5S/rJGSKvLL5?=
 =?us-ascii?Q?0qF2UxzsZDPzp8lnfAN3NUfC7IlAA17U6HbAUm/LixleFpbNy1ym/C1qWI7h?=
 =?us-ascii?Q?UnZpQ40Sc/pbGbPT6Fbvs5eJ4cydDZqEbwn1vXrbfAxMKQr6RNS2dw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:42:19.9203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1442d6-1f24-47fc-b18b-08ddea71f9cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9801

"io_alloc" enables direct insertion of data from I/O devices into the
cache.

On AMD systems, "io_alloc" feature is backed by L3 Smart Data Cache
Injection Allocation Enforcement (SDCIAE). Change SDCIAE state by setting
(to enable) or clearing (to disable) bit 1 of MSR L3_QOS_EXT_CFG on all
logical processors within the cache domain.

Introduce architecture-specific call to enable and disable the feature.

The SDCIAE feature details are documented in APM [1] available from [2].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41 section 19.4.7 L3 Smart Data Cache
Injection Allocation Enforcement (SDCIAE)

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v9: Minor changelog update.
    Added Reviewed-by: tag.

v8: Moved resctrl_arch_io_alloc_enable() and its dependancies to
    arch/x86/kernel/cpu/resctrl/ctrlmondata.c file.

v7: Removed the inline for resctrl_arch_get_io_alloc_enabled().
    Update code comment in resctrl.h.
    Changed the subject to x86,fs/resctrl.

v6: Added lockdep_assert_cpus_held() in _resctrl_sdciae_enable() to protect
    r->ctrl_domains.
    Added more comments in include/linux/resctrl.h.

v5: Resolved conflicts due to recent resctrl FS/ARCH code restructure.
    The files monitor.c/rdtgroup.c have been split between FS and ARCH directories.
    Moved prototypes of resctrl_arch_io_alloc_enable() and
    resctrl_arch_get_io_alloc_enabled() to include/linux/resctrl.h.

v4: Updated the commit log to address the feedback.

v3: Passed the struct rdt_resource to resctrl_arch_get_io_alloc_enabled() instead of resource id.
    Renamed the _resctrl_io_alloc_enable() to _resctrl_sdciae_enable() as it is arch specific.
    Changed the return to void in _resctrl_sdciae_enable() instead of int.
    Added more context in commit log and fixed few typos.

v2: Renamed the functions to simplify the code.
    Renamed sdciae_capable to io_alloc_capable.

    Changed the name of few arch functions similar to ABMC series.
    resctrl_arch_get_io_alloc_enabled()
    resctrl_arch_io_alloc_enable()
---
 arch/x86/include/asm/msr-index.h          |  1 +
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 40 +++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/internal.h    |  5 +++
 include/linux/resctrl.h                   | 21 ++++++++++++
 4 files changed, 67 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index f627196eb796..e20450fd6253 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1225,6 +1225,7 @@
 /* - AMD: */
 #define MSR_IA32_MBA_BW_BASE		0xc0000200
 #define MSR_IA32_SMBA_BW_BASE		0xc0000280
+#define MSR_IA32_L3_QOS_EXT_CFG		0xc00003ff
 #define MSR_IA32_EVT_CFG_BASE		0xc0000400
 
 /* AMD-V MSRs */
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 1189c0df4ad7..85b6bd6bfb81 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -91,3 +91,43 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 
 	return hw_dom->ctrl_val[idx];
 }
+
+bool resctrl_arch_get_io_alloc_enabled(struct rdt_resource *r)
+{
+	return resctrl_to_arch_res(r)->sdciae_enabled;
+}
+
+static void resctrl_sdciae_set_one_amd(void *arg)
+{
+	bool *enable = arg;
+
+	if (*enable)
+		msr_set_bit(MSR_IA32_L3_QOS_EXT_CFG, SDCIAE_ENABLE_BIT);
+	else
+		msr_clear_bit(MSR_IA32_L3_QOS_EXT_CFG, SDCIAE_ENABLE_BIT);
+}
+
+static void _resctrl_sdciae_enable(struct rdt_resource *r, bool enable)
+{
+	struct rdt_ctrl_domain *d;
+
+	/* Walking r->ctrl_domains, ensure it can't race with cpuhp */
+	lockdep_assert_cpus_held();
+
+	/* Update L3_QOS_EXT_CFG MSR on all the CPUs in all domains */
+	list_for_each_entry(d, &r->ctrl_domains, hdr.list)
+		on_each_cpu_mask(&d->hdr.cpu_mask, resctrl_sdciae_set_one_amd, &enable, 1);
+}
+
+int resctrl_arch_io_alloc_enable(struct rdt_resource *r, bool enable)
+{
+	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
+
+	if (hw_res->r_resctrl.cache.io_alloc_capable &&
+	    hw_res->sdciae_enabled != enable) {
+		_resctrl_sdciae_enable(r, enable);
+		hw_res->sdciae_enabled = enable;
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 5e3c41b36437..70f5317f1ce4 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -37,6 +37,9 @@ struct arch_mbm_state {
 	u64	prev_msr;
 };
 
+/* Setting bit 1 in L3_QOS_EXT_CFG enables the SDCIAE feature. */
+#define SDCIAE_ENABLE_BIT		1
+
 /**
  * struct rdt_hw_ctrl_domain - Arch private attributes of a set of CPUs that share
  *			       a resource for a control function
@@ -102,6 +105,7 @@ struct msr_param {
  * @mon_scale:		cqm counter * mon_scale = occupancy in bytes
  * @mbm_width:		Monitor width, to detect and correct for overflow.
  * @cdp_enabled:	CDP state of this resource
+ * @sdciae_enabled:	SDCIAE feature (backing "io_alloc") is enabled.
  *
  * Members of this structure are either private to the architecture
  * e.g. mbm_width, or accessed via helpers that provide abstraction. e.g.
@@ -115,6 +119,7 @@ struct rdt_hw_resource {
 	unsigned int		mon_scale;
 	unsigned int		mbm_width;
 	bool			cdp_enabled;
+	bool			sdciae_enabled;
 };
 
 static inline struct rdt_hw_resource *resctrl_to_arch_res(struct rdt_resource *r)
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 010f238843b2..d98933ce77af 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -531,6 +531,27 @@ void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *
  */
 void resctrl_arch_reset_all_ctrls(struct rdt_resource *r);
 
+/**
+ * resctrl_arch_io_alloc_enable() - Enable/disable io_alloc feature.
+ * @r:		The resctrl resource.
+ * @enable:	Enable (true) or disable (false) io_alloc on resource @r.
+ *
+ * This can be called from any CPU.
+ *
+ * Return:
+ * 0 on success, <0 on error.
+ */
+int resctrl_arch_io_alloc_enable(struct rdt_resource *r, bool enable);
+
+/**
+ * resctrl_arch_get_io_alloc_enabled() - Get io_alloc feature state.
+ * @r:		The resctrl resource.
+ *
+ * Return:
+ * true if io_alloc is enabled or false if disabled.
+ */
+bool resctrl_arch_get_io_alloc_enabled(struct rdt_resource *r);
+
 extern unsigned int resctrl_rmid_realloc_threshold;
 extern unsigned int resctrl_rmid_realloc_limit;
 
-- 
2.34.1


