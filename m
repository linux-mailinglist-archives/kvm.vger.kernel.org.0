Return-Path: <kvm+bounces-22787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90AB69432DA
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 121E61F279F3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FFD1C68BA;
	Wed, 31 Jul 2024 15:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1VmQAjJQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9081C688B;
	Wed, 31 Jul 2024 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438570; cv=fail; b=GLyStzNfLNlvf7spAK34wDnUFdKdGH1Lezqmm2WGm36s2g0jhNc5e1O+tzgL30zTLUAor1GCq3f0ORcoBPzYS2ivzSRmxca6K99rS/QucndYYMVjPbVDPokHx6wFQoJsg1U22YlS1QDXketE11/FmYQ99E9X2uBA55L3p6Tqjz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438570; c=relaxed/simple;
	bh=hSZbUW2/bM1A6QdJ60yq069vhtw0izSkgM8HaEajmac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XN8sZze4hctq+g1dDtdN0TLsU/XW3xJMNggZbKifSlLz5pGwoYuP2LEu4K/xWKy3MoyFKV6UejisJ7JfhtYYqCAZwR/OxDWxQNrRKw8/IBnUBOfTHoDOumEiXyNQq9QM1dOg0lX3xXRFlKe4TOnQgIpQClLPBsNX7uTiUj7Za8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1VmQAjJQ; arc=fail smtp.client-ip=40.107.94.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C9nGsjZfGwfVs5mtOpCj+vv2FguiYcAxJhavKnGnGWiiIFfF/Q0Wu5bjlBE3XqV5P5C6632g2/1X5CFfM4ol4dn249ksyLJFH1n+qSzs6DfngAX0qX/9YDYKOTJwfrkDNrzoXca9qMJsgLW5T0vJ611E6TA87+XOOWGpsBV64TFQToL57Fk905r15i0IbEKHN8I4e3ZC8/SyxoNQro9cCbLgLr9IdX5hPWVAC73Sj4cj05Xsq95I7q0z9Q9pBJXTYCk6Td1zNtaZ9k0ncZDVFm4y7SmcZPRUwtW1uN2Z0m5pAKpRnC+uFkVhNsIL/ULYoJn6/fmpBpJ7yAW36QN3yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8pvAGzjYDbGXaW/62fZKkjZr7d9W/JeYpXG1PMAlFkk=;
 b=xZy2m4cANEkoCezvfgDJ5yUOOxWuNuhwYyX9+JfBplTZsfZUnjMdryTY344MupoHupWh6rfVltWypTWQAaXj5yq41qGiGgq6b0mkTDFOqxJJkkZxlPgrPZBdN2QCSOiK6LvMetpTJvt83gLeZvOntP12KcKQ4yyB6e2M2C9qT+9qVaRARKv76B+hOOOovw+E0q+HtQ/DkBfkiYBX697DqQFWs+Cxvt8FjBpp252zLNRVbkIYRHlxSh2syEMQpWUBB9wr4oSTUdGpZg20Ft/73WRxvmyboTpllRqsna1x7YFR/wCW4o2wnIM/P0FqycsxS0KncPp/hgv4n+Pes5D1Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pvAGzjYDbGXaW/62fZKkjZr7d9W/JeYpXG1PMAlFkk=;
 b=1VmQAjJQLh/pYTMUE4MRKDuQRRPjV1D674Itwr1vhGvvx3J+L5Kp4bWuERoHUk8p8u0QG1DtL9jNmHJCPEo/Lf2znt+8cXiEaeU3ggi+wLR8Txq1F8BAXUqTdGn1ZjztBxZip3bso3mn9IKLzXGu6htKm7f47wD3ATqSZq7qCYg=
Received: from DS7PR06CA0042.namprd06.prod.outlook.com (2603:10b6:8:54::23) by
 CH3PR12MB8481.namprd12.prod.outlook.com (2603:10b6:610:157::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 31 Jul
 2024 15:09:26 +0000
Received: from DS3PEPF0000C37F.namprd04.prod.outlook.com
 (2603:10b6:8:54:cafe::24) by DS7PR06CA0042.outlook.office365.com
 (2603:10b6:8:54::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.35 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37F.mail.protection.outlook.com (10.167.23.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:26 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:09:22 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 15/20] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Wed, 31 Jul 2024 20:38:06 +0530
Message-ID: <20240731150811.156771-16-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37F:EE_|CH3PR12MB8481:EE_
X-MS-Office365-Filtering-Correlation-Id: 526e4af0-dcab-4d1d-2f3f-08dcb172c498
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SayNvtN1Le2T/25a8zf5/C1edYkmEjnVpOO0wkPw9ga0EnVTLxbUHLPTGPo0?=
 =?us-ascii?Q?XB2dTsWw7JkHe52cyI2Xh85w8GRri1uHHbvMQrn9PrvnIhxKVdVfNDTehHhy?=
 =?us-ascii?Q?r706kxjr413SbR8x/1401fLmuuiNS61bzKoE2EdMnFKxj/G0JaCbpGsvm/TY?=
 =?us-ascii?Q?HEJpFQQExUuGbXROIKMKlgJbiTzz+cW9rfc2o0FV7EYMf44lTc/WghU4bLIf?=
 =?us-ascii?Q?v+Rk4rxrTpYHwffRMil9tWQmbKCkvo5FEHgzNhyXLAXLRlvKIUNNB/KThv8e?=
 =?us-ascii?Q?PYP/I0cSxUvD6g3TT/a8Prg4ot3IMxZqp5C2koFqmaWnafBPqi3wmQrBI2ZN?=
 =?us-ascii?Q?zizaGU/bodJyKC2bYraT8eGBNgQVslqDbdTxxAQI7Xs3gJRdNIKFYapRrzs1?=
 =?us-ascii?Q?HFoLLNLo8mEHAJ+qk48iV4uPy97Ug4shCUK35d4KpMn4uzijY8Xr1ngV2/60?=
 =?us-ascii?Q?/jRTWT30ab3It8UzrK7KVg/nSGyN22b2gBt31/6VdpyUlk4B7uQIuNaZ1/EC?=
 =?us-ascii?Q?DETsGKi5WuN4+P1gaS3wq9/A6LasyupVbtvSuxTzbtKKfuA07fFzPVPFdZOF?=
 =?us-ascii?Q?3PvM9cPJ3zu87cr8cs2J3hCM1cicy16tKO4VwaAuYPY53RdNmIdl1woNmBTh?=
 =?us-ascii?Q?rajizZ5AkeKgtY/a9vbx/cRukPEYfgi0cyQ6MboitZqRP2UtUtFtzROwhmKu?=
 =?us-ascii?Q?xy9RmApz1mqCulkDim1SCE38guKLJHF2bxcgIe1LA32gUPX7Csf6ElnUZQLB?=
 =?us-ascii?Q?zkGDsP7E9avaYT58VqVvO1zzliPeWANJ+OgcoON7eB8tM1DaepACZ9zBu3A5?=
 =?us-ascii?Q?kKUDsANtrDTLjLKZ7K5bRsW1uGW2+lRDl4BdcxpVJWGSNfMZA6ZNxX/SYCyR?=
 =?us-ascii?Q?fVILbZcWyoQHB2sQHcsdpF5jJDNml5TXROG329pvZy1U4F2x/p7yUD01c8cN?=
 =?us-ascii?Q?8/AaD4t5oUc7MrmStB7VY2Qc+8QRKJOwKGobRc8/6Vs1bv20Tbu7KaFTrdxT?=
 =?us-ascii?Q?OIkOrLRezWR81jcgO0EK3nBUDLzYy/+dRh7MGhLcvGi6lrmHW4Xp//NEW1th?=
 =?us-ascii?Q?B55Fm+84JzlV3YXAg7560m5rJ6XczMAl/Z/JoPtDHPz731VTIYWra89KUJv5?=
 =?us-ascii?Q?etnKkYuizWfXdanRAXG2eytC+U7orleNh5ZhjFOtYGaV0wo4qSYsNtuePes0?=
 =?us-ascii?Q?0FGlulb1ND8WoPOb0xwMe5abY92+Q6RpIIgq4vTbo49j3+YemQ5fQQ4Hyq/M?=
 =?us-ascii?Q?yEzSpHy2wX5RrAIU8HUrHe0XxEwgyiBeMq9uywjR1cOrNvPUO3i7B0y0APGk?=
 =?us-ascii?Q?e7Fx+kl0BImFSn6Trxz54Fb91xXnvoQa0+8UbZsR+DgnZRnWB06cx8OUe6pI?=
 =?us-ascii?Q?OzAw/GsI1av7ZI47di6N/f4U7lysQhlg4aocO2j2rnzekeWR604fqRsL6nbh?=
 =?us-ascii?Q?WNstcC1y0gAhhnQZLMng+3PjO5CSLpPr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:26.1370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 526e4af0-dcab-4d1d-2f3f-08dcb172c498
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8481

Secure TSC enabled guests should not write to MSR_IA32_TSC(10H) register as
the subsequent TSC value reads are undefined. MSR_IA32_TSC read/write
accesses should not exit to the hypervisor for such guests.

Accesses to MSR_IA32_TSC needs special handling in the #VC handler for the
guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be ignored,
and reads of MSR_IA32_TSC should return the result of the RDTSC
instruction.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/coco/sev/core.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 9815aa419978..a4c737afce50 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1335,6 +1335,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return ES_OK;
 	}
 
+	/*
+	 * TSC related accesses should not exit to the hypervisor when a
+	 * guest is executing with SecureTSC enabled, so special handling
+	 * is required for accesses of MSR_IA32_TSC:
+	 *
+	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
+	 *         of the TSC to return undefined values, so ignore all
+	 *         writes.
+	 * Reads:  Reads of MSR_IA32_TSC should return the current TSC
+	 *         value, use the value returned by RDTSC.
+	 */
+	if (regs->cx == MSR_IA32_TSC && cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
+		u64 tsc;
+
+		if (exit_info_1)
+			return ES_OK;
+
+		tsc = rdtsc();
+		regs->ax = UINT_MAX & tsc;
+		regs->dx = UINT_MAX & (tsc >> 32);
+
+		return ES_OK;
+	}
+
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (exit_info_1) {
 		ghcb_set_rax(ghcb, regs->ax);
-- 
2.34.1


