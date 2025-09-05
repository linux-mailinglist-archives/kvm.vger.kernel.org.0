Return-Path: <kvm+bounces-56914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 481F9B465A8
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8D201D20638
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC452F3611;
	Fri,  5 Sep 2025 21:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rIR/MVKQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC7B2F3621;
	Fri,  5 Sep 2025 21:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108117; cv=fail; b=Qo2c+XIId9wILjziH8kQV+O18IxsHs+7157MoK9IEdHVJe/4AbyeimNd3a5eENicRGVYbyt8+pYljCST2weGHwohDrnlsJosfVQXz2lJp1ZTZcIhdhV7GzMuTdsjjw2D7zPrWQmeIGmPnLf0N5rtxDesGoA7KaaWim/FASopDv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108117; c=relaxed/simple;
	bh=Jc5sYPRFZLOX2J9RPjjvc4wUB44caIjYM9iagZ4gqW4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2OKUYt4TbAqS5ujsbGx2CqUxr04o509xDlH5TDsSC15cCx7NgHw31FK7Ra3Gi5F3W4hPtl6TwnItGrt1xK97vvsj0H0DwZLQWpvqt6cHZzbudlD6DmjKP9jiT9Ktj25rEH84Pm3HXyzXNmEZPCU7XzKDk4kwjtBV4qD9X/SGT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rIR/MVKQ; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C9Twqz8cii+8HniiyZOIbXF8eq3agSKEz0DcOBOeyEfBCvXsPTs2tdxS95vH3IsAJo9Kq0IT9aa5XkJ8gJQdWDkETtIMFtmr59AS1BpzXN6cnbax8X9zYBxA/xAtSWXs0ZvbJ/qwlxU3VS5uW+krvcLhVWhgF1pzLuvh4oOalzD0amMNmurlNpIyp9GwmA0fBI/wzpjOCuYCro2fpMUsgtyHfgg9UQMz4BqvBb0INBegwfIH8lFoZHuynC1en59LG582i0IfD43PevEta59QHWLzy7dwkYNaMnD+eZ4c+YR5KxOdaEFy2L5PmQ/spW7CmsvNNJpREZ+asDuqYnaeBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/grSWyFz51I1xAvpruMOD475afp3zZGetyQd9xEqcM=;
 b=bIqyyiUqI6sQYGwERoJgkW00kfmfcWyPqYYOjaNw25rMz9+Lwzc8N2YCqGU2bEBe4wEzfFT6wJhEf+I3E4Z8UAwB/Z7/jo6nazh91IT83Y/Z7jrmUS5TWN3KO/WLCTf80ZFXsktCwTIwSSt09TROVVbxqTAPUnXAOUQXyogSrIWL0EtNU9vcL8F1UKaPsdOq8+77kh5OV8sv2ba4kXTlE+Myn7Hg6t/pFvexfjB+V86PfBJVuzocxSWKrQLYARBgyZicsTuTXYO/zaEOCe95L6KdHvZg/78S8Fuc/FbrVPr2TornSup86wVNaarowqHhYLppaSgMctJfbRahd5NcZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/grSWyFz51I1xAvpruMOD475afp3zZGetyQd9xEqcM=;
 b=rIR/MVKQuC55KB32hcGBXX5jkGmxg18ug7H6w8U0dG4citPi6odpmQEnzsVGJPIAJzadr0RssRq5HeLz7tiLlSqz7u3xB0l0SKGTFWobOoO2CqJdOTAx5xPFdxMMJl3MlId1OIxW0vYMfZJKOrDQ5uQQg1cvNSsr1LtQ7mlK0IE=
Received: from BN9PR03CA0902.namprd03.prod.outlook.com (2603:10b6:408:107::7)
 by DS0PR12MB8018.namprd12.prod.outlook.com (2603:10b6:8:149::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 21:35:09 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:408:107:cafe::d3) by BN9PR03CA0902.outlook.office365.com
 (2603:10b6:408:107::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Fri,
 5 Sep 2025 21:35:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:35:09 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:35:04 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:35:01 -0700
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
Subject: [PATCH v18 02/33] x86,fs/resctrl: Replace architecture event enabled checks
Date: Fri, 5 Sep 2025 16:34:01 -0500
Message-ID: <e07ac35fcd6ac91c82ac58b2aebc613973f25945.1757108044.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|DS0PR12MB8018:EE_
X-MS-Office365-Filtering-Correlation-Id: 68d5144c-ab76-42f1-f66e-08ddecc4169a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p8+bo3jv1nNwBtfuGslNwhEoF6XtenBvhptUNx+Lf42Bu3j83fuax8wdT/74?=
 =?us-ascii?Q?M6gbegUfwmX2oZ9QU2N76OJNoDJ5W+GirTz0W2SWmsRtOpgjyiV8p1YoSE/D?=
 =?us-ascii?Q?LvucZz7+jMhtjx6GvjzDC1oEhINghbPN40lwVGD4dypSVbsHoILib46e1vzL?=
 =?us-ascii?Q?6TGfu8FAy7IX2hrUwm1p+jryAPYEsLk/sA1d0PedKM/GVaII3wFXnvvVSFX/?=
 =?us-ascii?Q?iJbyPjDYJkTwIIufGM3wmMwGscNUpEWQDf3AxarBqbrcQaBudSk7tm2I70r0?=
 =?us-ascii?Q?3shHl9k0pqT+bev+r2c9HUWX87Em0XU78KdnHFLWHOvJ0ZbuV8CSUKsiaoQ+?=
 =?us-ascii?Q?kDuM1TYvAhGNfPHfcc6sbFKuBMnzFW6JIfmyKeBpAtFmo7gRy75SI2pkE2fP?=
 =?us-ascii?Q?tqsV1q+kRu4haseZzzkTKeeF1m6NJddHQhk/VW4nXYx7+czqbGBU4eGJQrAS?=
 =?us-ascii?Q?eVAyqLw0WYYKHF9taTAq7s02nTns3BtcXd13FoBgFATRlX1bHrDC1T8GBgpm?=
 =?us-ascii?Q?SBtpUusI9/tLoMAq/25jnRR+e+s8nF4Ld+cga8Qs2dEAS8N2lHK+rwor2PJ5?=
 =?us-ascii?Q?elFP6ckhUjHihzWynqnYvXMkDHGKG8hmyyI5E4QEtqmoOZytDMdtTDhnCIZZ?=
 =?us-ascii?Q?8kXyHkEI6oznhrbckqsSCfBnKBfUhScBUamasaQWkKyl9+0ObqXOsm+pGtdg?=
 =?us-ascii?Q?6SBkVxEYG0Z8jOR1tT89PqD6TXxwpRPivR/4hMWtWVC92v/ligXYJ++ir6NW?=
 =?us-ascii?Q?OZlqM1pHKMNN071DHFcB3bCmGtgybL9pmhEIlCEa+dWBmKxg9d4EkUFbbAUd?=
 =?us-ascii?Q?D1F6RfCGOOtUREP6bdIUMRzG3Jl77INFGroCO2c5fi2EYgdWBHoxg//I/qpV?=
 =?us-ascii?Q?+PU2YYrMZUL0GdcKHUuJkGe9tqSmSy5UvXHCSCAQaJr/lG4Wk8vh+nnQaesO?=
 =?us-ascii?Q?vEfNOG08ZoXfZwxfbVusoAdKHEe+x0i2oGoJpnZ4NKOPO3PAc2GyD3TKtp8u?=
 =?us-ascii?Q?Kc7B5Cg63WRZ/lN8MH9vMny8dM2iSN7xRZE+gKzwCqdg2p3f6kWuUaBVqX/9?=
 =?us-ascii?Q?TnWtd4s67ClPdRsfiH9DGiWjH9AGvvViVaJUfaOxEBguEGc0AoH8LPMXdTWU?=
 =?us-ascii?Q?klGT1pPUiUbv2eZ6CRYdhBnWq+XgQdRULW12BExWghVpHBLD6eIjN1wfyOXR?=
 =?us-ascii?Q?HnJDfX2H46AOkNF/PV15AAeYtgWe7oCqnvfsYQeU476HR6TFVgU9JYTNbDsl?=
 =?us-ascii?Q?tOkayPJjryW8VG4Bvxmqo9NktrTrLwDRm8R8En8Iy7AMpEDhhm4u4NOzmYbW?=
 =?us-ascii?Q?pUxnAfbCkUyhBKFA63XkDUamCppsNhqHP7nO89xnKE50VmijUnBjxv5sMY8L?=
 =?us-ascii?Q?fDvJCV4MI5//V0V3Vy/eu0fs/Cy4Pb7xfe7SyS9Z7G7wtybJMwbadpyC7XGF?=
 =?us-ascii?Q?7l1I84LW2cR3gEJRmWHXrG7P1et2ccbSKp0PCcxA7VZdDK+7ezruDiima4Rf?=
 =?us-ascii?Q?T096YzJWsuEqPkHfjm6Ey3pe9+NKMrPT1plAP+gY4MSm9Rb5I2mqS3DsQw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:35:09.3055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d5144c-ab76-42f1-f66e-08ddecc4169a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8018

From: Tony Luck <tony.luck@intel.com>

The resctrl file system now has complete knowledge of the status
of every event. So there is no need for per-event function calls
to check.

Replace each of the resctrl_arch_is_{event}enabled() calls with
resctrl_is_mon_event_enabled(QOS_{EVENT}).

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v17: Addred Signed-off-by tag.

Picked up first four patches from:
https://lore.kernel.org/lkml/20250711235341.113933-1-tony.luck@intel.com/
These patches have already been reviewed.
---
 arch/x86/include/asm/resctrl.h        | 15 ---------------
 arch/x86/kernel/cpu/resctrl/core.c    |  4 ++--
 arch/x86/kernel/cpu/resctrl/monitor.c |  4 ++--
 fs/resctrl/ctrlmondata.c              |  4 ++--
 fs/resctrl/monitor.c                  | 16 +++++++++++-----
 fs/resctrl/rdtgroup.c                 | 18 +++++++++---------
 include/linux/resctrl.h               |  2 ++
 7 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index feb93b50e990..b1dd5d6b87db 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -84,21 +84,6 @@ static inline void resctrl_arch_disable_mon(void)
 	static_branch_dec_cpuslocked(&rdt_enable_key);
 }
 
-static inline bool resctrl_arch_is_llc_occupancy_enabled(void)
-{
-	return (rdt_mon_features & (1 << QOS_L3_OCCUP_EVENT_ID));
-}
-
-static inline bool resctrl_arch_is_mbm_total_enabled(void)
-{
-	return (rdt_mon_features & (1 << QOS_L3_MBM_TOTAL_EVENT_ID));
-}
-
-static inline bool resctrl_arch_is_mbm_local_enabled(void)
-{
-	return (rdt_mon_features & (1 << QOS_L3_MBM_LOCAL_EVENT_ID));
-}
-
 /*
  * __resctrl_sched_in() - Writes the task's CLOSid/RMID to IA32_PQR_MSR
  *
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7fcae25874fe..1a319ce9328c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -402,13 +402,13 @@ static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_mon_domain *hw_dom)
 {
 	size_t tsize;
 
-	if (resctrl_arch_is_mbm_total_enabled()) {
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		tsize = sizeof(*hw_dom->arch_mbm_total);
 		hw_dom->arch_mbm_total = kcalloc(num_rmid, tsize, GFP_KERNEL);
 		if (!hw_dom->arch_mbm_total)
 			return -ENOMEM;
 	}
-	if (resctrl_arch_is_mbm_local_enabled()) {
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
 		tsize = sizeof(*hw_dom->arch_mbm_local);
 		hw_dom->arch_mbm_local = kcalloc(num_rmid, tsize, GFP_KERNEL);
 		if (!hw_dom->arch_mbm_local) {
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index c261558276cd..61d38517e2bf 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -207,11 +207,11 @@ void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *
 {
 	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 
-	if (resctrl_arch_is_mbm_total_enabled())
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
 		memset(hw_dom->arch_mbm_total, 0,
 		       sizeof(*hw_dom->arch_mbm_total) * r->num_rmid);
 
-	if (resctrl_arch_is_mbm_local_enabled())
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
 		memset(hw_dom->arch_mbm_local, 0,
 		       sizeof(*hw_dom->arch_mbm_local) * r->num_rmid);
 }
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index d98e0d2de09f..ad7ffc6acf13 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -473,12 +473,12 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 	rdt_last_cmd_clear();
 
 	if (!strcmp(buf, "mbm_local_bytes")) {
-		if (resctrl_arch_is_mbm_local_enabled())
+		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
 			rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
 		else
 			ret = -EINVAL;
 	} else if (!strcmp(buf, "mbm_total_bytes")) {
-		if (resctrl_arch_is_mbm_total_enabled())
+		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
 			rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
 		else
 			ret = -EINVAL;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 2313e48de55f..9e988b2c1a22 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -336,7 +336,7 @@ void free_rmid(u32 closid, u32 rmid)
 
 	entry = __rmid_entry(idx);
 
-	if (resctrl_arch_is_llc_occupancy_enabled())
+	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
 		add_rmid_to_limbo(entry);
 	else
 		list_add_tail(&entry->list, &rmid_free_lru);
@@ -637,10 +637,10 @@ static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
 	 * This is protected from concurrent reads from user as both
 	 * the user and overflow handler hold the global mutex.
 	 */
-	if (resctrl_arch_is_mbm_total_enabled())
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
 		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
 
-	if (resctrl_arch_is_mbm_local_enabled())
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
 		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
 }
 
@@ -879,6 +879,12 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid)
 	mon_event_all[eventid].enabled = true;
 }
 
+bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
+{
+	return eventid >= QOS_FIRST_EVENT && eventid < QOS_NUM_EVENTS &&
+	       mon_event_all[eventid].enabled;
+}
+
 /**
  * resctrl_mon_resource_init() - Initialise global monitoring structures.
  *
@@ -914,9 +920,9 @@ int resctrl_mon_resource_init(void)
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 	}
 
-	if (resctrl_arch_is_mbm_local_enabled())
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
 		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;
-	else if (resctrl_arch_is_mbm_total_enabled())
+	else if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
 		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
 
 	return 0;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ab943a5907c5..2ca8e66c0d20 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -123,8 +123,8 @@ void rdt_staged_configs_clear(void)
 
 static bool resctrl_is_mbm_enabled(void)
 {
-	return (resctrl_arch_is_mbm_total_enabled() ||
-		resctrl_arch_is_mbm_local_enabled());
+	return (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID) ||
+		resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID));
 }
 
 static bool resctrl_is_mbm_event(int e)
@@ -196,7 +196,7 @@ static int closid_alloc(void)
 	lockdep_assert_held(&rdtgroup_mutex);
 
 	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID) &&
-	    resctrl_arch_is_llc_occupancy_enabled()) {
+	    resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID)) {
 		cleanest_closid = resctrl_find_cleanest_closid();
 		if (cleanest_closid < 0)
 			return cleanest_closid;
@@ -4048,7 +4048,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
-	if (resctrl_arch_is_llc_occupancy_enabled() && has_busy_rmid(d)) {
+	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
 		/*
 		 * When a package is going down, forcefully
 		 * decrement rmid->ebusy. There is no way to know
@@ -4084,12 +4084,12 @@ static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	size_t tsize;
 
-	if (resctrl_arch_is_llc_occupancy_enabled()) {
+	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID)) {
 		d->rmid_busy_llc = bitmap_zalloc(idx_limit, GFP_KERNEL);
 		if (!d->rmid_busy_llc)
 			return -ENOMEM;
 	}
-	if (resctrl_arch_is_mbm_total_enabled()) {
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		tsize = sizeof(*d->mbm_total);
 		d->mbm_total = kcalloc(idx_limit, tsize, GFP_KERNEL);
 		if (!d->mbm_total) {
@@ -4097,7 +4097,7 @@ static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain
 			return -ENOMEM;
 		}
 	}
-	if (resctrl_arch_is_mbm_local_enabled()) {
+	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
 		tsize = sizeof(*d->mbm_local);
 		d->mbm_local = kcalloc(idx_limit, tsize, GFP_KERNEL);
 		if (!d->mbm_local) {
@@ -4142,7 +4142,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 					   RESCTRL_PICK_ANY_CPU);
 	}
 
-	if (resctrl_arch_is_llc_occupancy_enabled())
+	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
 		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
 
 	/*
@@ -4217,7 +4217,7 @@ void resctrl_offline_cpu(unsigned int cpu)
 			cancel_delayed_work(&d->mbm_over);
 			mbm_setup_overflow_handler(d, 0, cpu);
 		}
-		if (resctrl_arch_is_llc_occupancy_enabled() &&
+		if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) &&
 		    cpu == d->cqm_work_cpu && has_busy_rmid(d)) {
 			cancel_delayed_work(&d->cqm_limbo);
 			cqm_setup_limbo_handler(d, 0, cpu);
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 2944042bd84c..40aba6b5d4f0 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -372,6 +372,8 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 void resctrl_enable_mon_event(enum resctrl_event_id eventid);
 
+bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
+
 bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
 
 /**
-- 
2.34.1


