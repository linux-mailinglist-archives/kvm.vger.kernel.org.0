Return-Path: <kvm+bounces-62979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E4AC55E92
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:19:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B3E4B34C58E
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887C83203BA;
	Thu, 13 Nov 2025 06:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1kE8JCN0"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012024.outbound.protection.outlook.com [40.107.200.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4852609DC;
	Thu, 13 Nov 2025 06:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763014775; cv=fail; b=SmG9WUpHlwaLITRZYNKbg5tMGHqcYn6/NKwOQyB0qi2vwpFl1+FXIBkSyyPtLD7HOIG+EFxFROWxoTc7mhyYvcS/sBY5/ckH88QAzmttnH+XT/ak4RQOxVYgMii4w45Pm85XdlRyJD1+QrgLo6CGuqTDjrPWemYyX9Goxutm50s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763014775; c=relaxed/simple;
	bh=CiI0IG+gcS61snpfg4Rf963lrhRsWof6fqJ1GXUXcbM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8U7AHqeP0YEayLHnSXQhLyf6DxMNALOpMtg5eaQwNEIoFtP4VhzbVUiY8jv8KjgxYdp5w+91j61SMOmOZbCyDgE7djJEYN2Jo0NBTqDEG3sF89lnzsvM2nYjRHnMHhVLFVbVbGyYptxZ8H0QtDnR6aXz0368B5YZLENl8Qtymw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1kE8JCN0; arc=fail smtp.client-ip=40.107.200.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+5T1lE60+Ra90MroMJwBetrMVF9Iap4Aoi8VSsVANIfmTwvc4Gs6JTFvBwJCWRpJ5VDUrLmeHwf/XgdaEB6cargr2R2gNnPbDvlRioQJ4mgRb/x6xNP2lYgk5Do1qXLOp3u8o7mqAQ0hrs4lKO2n1Vj8w1avd705awy2DHqOELpxjMxlc/GL8IUbYNKT4AkcqQvrFBPp5RkMj2aSubSbR2FVe02JAvgWyG2dv9gmpHgHqp+3obvbcUDqLF9+U6NrD7NsC+X4N1zRA0ygDasXAgdmkX4DGLl9OJtTPQFac9GaCVDAwvBUAjsy9oWgmQOC3nYxwU4YID8EArGSA0PLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPKyONfjcMls6e4PwF5MA000464Z43NTMk5tj5/sos0=;
 b=dXxGm9d0SenvCFt9hhgJQCG0WFO0WTQ6ayoUWYH2pA0s8sBsfIv7ERKIp85NUiXvA10Gu06Pso59I+7HifLbLqRgyOfteA4tpzkpn0gvjySYF32ffsOKcj3bMMzYQIORdqmaY58CBZm0We7gtmYNKi5qNX8OG6U2ejSEmPwHCrvGOJLgbKK/sjs9/r0hYQUxT7+WYa/e39Dg+jxHUE/p63xMtJPdhWwSue8l2s/fELjV/R8sE2xyhNVW1RRqY+ePIQl6IQ63avGQibCBL1vs1f9rCtyzBjXfB6h4ccBKtyRR+Pla1vjl7vT9yjvKcHC7i8avu6UN2NzVuszETG0ElA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPKyONfjcMls6e4PwF5MA000464Z43NTMk5tj5/sos0=;
 b=1kE8JCN0jxF9v6EjKXyOlLGeofXFB2x/hA4vbDs1OjI9XQ/mWjcFde9rvz1qsv1kFHaaWL8KZ3zGsMdjp+PKifAN1LqkXQZv3YZJguXneJ4ckCCeo5L5ZfaK304d78dkA7oQcJiAL5iLoCVm2tI2M8P7/ty5DfIjvIJb5gFXq3w=
Received: from DM6PR21CA0017.namprd21.prod.outlook.com (2603:10b6:5:174::27)
 by BY5PR12MB4132.namprd12.prod.outlook.com (2603:10b6:a03:209::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 06:19:30 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:5:174:cafe::56) by DM6PR21CA0017.outlook.office365.com
 (2603:10b6:5:174::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.6 via Frontend Transport; Thu,
 13 Nov 2025 06:19:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 06:19:29 +0000
Received: from sindhu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 22:19:25 -0800
From: Sandipan Das <sandipan.das@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Kan Liang
	<kan.liang@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, "Manali
 Shukla" <manali.shukla@amd.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
	"Ananth Narayan" <ananth.narayan@amd.com>, Sandipan Das
	<sandipan.das@amd.com>
Subject: [RFC PATCH 3/7] perf/x86/amd/core: Set PERF_PMU_CAP_VIRTUALIZED_VPMU
Date: Thu, 13 Nov 2025 11:48:23 +0530
Message-ID: <1e491fe080083d35f44964d8e2f244b52262e53d.1762960531.git.sandipan.das@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762960531.git.sandipan.das@amd.com>
References: <cover.1762960531.git.sandipan.das@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|BY5PR12MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fcdf166-4abe-4146-fd93-08de227c9ab2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PqsmriqC/CBJK7ztfqUME6CRgudrbUacFpUxiYqVPjMAdibwoQU/rz0lQpZd?=
 =?us-ascii?Q?xhjCzAmYdswqaPihEEFkdCLcgQNDIRwH0zqWgiHvlCU0xZlSpgWFyrE+/n8c?=
 =?us-ascii?Q?F4XEy5Ly/oz+ygRn89Q+0No+ETGSm82lvJDSXhj78mIm/Act/YtRkHe9dM+j?=
 =?us-ascii?Q?TybdpC+ubSwLIVXoSTCgGfmDnXudj2aLv27kxzBJgtfrnQ1a78AgLCBKRw2l?=
 =?us-ascii?Q?rqkbjFmq/gyxZus8XI4M3yQMi/9P84QXuMwYj+4ACxLNKzj/HCUuZN27at0Z?=
 =?us-ascii?Q?9z+8QH5p+85JukRcaAH2mGplDIkgS5Ts+Y0PZS6mAmMMbfGNB00n3SLkP58d?=
 =?us-ascii?Q?rVLwwA9+NtkamAQiNy7OeDBm8yxVzntpoOlZMb970Xvq8f695/qPf1IICYRb?=
 =?us-ascii?Q?lVuT0NI6o1St+n6m33uFEp4UiR+RMCVaLuTrDU5JKM1PJAszy98oLY0bYJdG?=
 =?us-ascii?Q?k7/K7o5dM6PZaUBHZLi0LlbxXTlR3b+OM9paZIkY3Bte0nqi6RBkLPDnCymG?=
 =?us-ascii?Q?XhghBA+6dgN+m9yqtwYVEHQr/tOyTfbhIDq51RL4Bd9ABNqu2eY9ISfC6avf?=
 =?us-ascii?Q?HboGGxi4kFOK7Yss/snW1VxgwBrrt9xiBgknzixeoes1J5F9d+KFvudmq3eV?=
 =?us-ascii?Q?m9VxP5m1x9cpaDRn7hgHA+Tbw20jSX53q9nP3hCot/SCZdKkrjAAQC5jtp4c?=
 =?us-ascii?Q?reYinGqpE3twFfcvGWREn37EmhTHxJ4lN6AAhTAEvPcvaKuSfgGvi/2R1SZ8?=
 =?us-ascii?Q?r5FbyYaE7L8j3KEdUoDrQBUoEWkQI9OEoTi1Ehvn0Mvgj+09spnRTJLGK9Rn?=
 =?us-ascii?Q?a+dTZMhO66imazMPrxorJWG8YWgSXRiJaxXGOcvTNv5JQ9XZAhn9XoAhlLzA?=
 =?us-ascii?Q?/DfUbt99+HCu48TwCpDYuJJN9EBE9ROTueoSTp31nzBfedDXmlER7HSxqtQh?=
 =?us-ascii?Q?RzjuRi0B4+WUwZ3D/LpUmcf4QhrnySGHX+/mDXcjBBZVyQ9ypg9mZlw4J7Zt?=
 =?us-ascii?Q?2YBG3FWQ2cw1ojdfFCLH9ZwAaw0nYy7Yy9ngfiWzDxxuGTKUMoIwz9Sd6GfE?=
 =?us-ascii?Q?3wmX1FZPRzQGaKpbk7QkLs9jDVTj8obg4CTpzzV1gGmUyLG7ui5DQhn/OcAP?=
 =?us-ascii?Q?krzNdF+nAUQXnn//X0upo0TtFjRnDIkeB3/7mIvvSfmWhhQvnbSPhkFEUFV4?=
 =?us-ascii?Q?vMq4j/vVOAH1HnlKuWuL9UTjFP/E/UxSDz0z45X+k93vd5GjG6dbdKWmucha?=
 =?us-ascii?Q?qBFKWgRFXRUgTAqUWhX/TZws4kBh2lendjKWsEssAeLlmDgDmEoIpWZxAorK?=
 =?us-ascii?Q?8AIdlDGMEx2JtPy9y46GHaF8Md4TgIdzdnEOPwGXKuVKRMWlem30A5qFmUqY?=
 =?us-ascii?Q?lBgBcBbrtDuFmLwDQakZB6K+qpN20Myz/09oLPWGIdH/qSLpMcD+GdCfpl73?=
 =?us-ascii?Q?dn0RnuLNY2IL778bViizJxiyxHwqAOPYvziIQsGH3wfLAEJ+4e0SJBGWTEbf?=
 =?us-ascii?Q?YPXzluNBb2T7WdCvX7Roaban/CzwDtiY/zpGIHW9lFr71BW2iQwXI/zPSoNJ?=
 =?us-ascii?Q?PDM2+XX2QgEIVJcS57A=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 06:19:29.9017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fcdf166-4abe-4146-fd93-08de227c9ab2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4132

Set the PERF_PMU_CAP_VIRTUALIZED_VPMU flag for processors that support
X86_FEATURE_PERFCTR_VIRT.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/events/amd/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 8179fb5f1ee3..0cd2f54778c0 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -1443,6 +1443,9 @@ static int __init amd_core_pmu_init(void)
 		static_call_update(amd_pmu_test_overflow, amd_pmu_test_overflow_status);
 	}
 
+	if (cpu_feature_enabled(X86_FEATURE_PERFCTR_VIRT))
+		x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_VIRTUALIZED_VPMU;
+
 	/*
 	 * AMD Core perfctr has separate MSRs for the NB events, see
 	 * the amd/uncore.c driver.
-- 
2.43.0


