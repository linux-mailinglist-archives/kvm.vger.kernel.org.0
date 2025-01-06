Return-Path: <kvm+bounces-34593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0427A025ED
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:49:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B24A7161D26
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7521DEFCC;
	Mon,  6 Jan 2025 12:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kuG1orKj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2066.outbound.protection.outlook.com [40.107.212.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0934F1DED58;
	Mon,  6 Jan 2025 12:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167658; cv=fail; b=sFPnaR99UyQ5NmtSP4Mr1QZBSK57pI+Jpop0JxHAwxDWASsRf87FmRrc+esE6jEpC58faG44aeAmIABeOMpw5GsqBgtPHRNADuBL5s31c693UYgPuTe7rOVVj4yYwZZbVhxSnznuGmtgBN4+P+3bB6uxhqbFdmH77TDxfvKykrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167658; c=relaxed/simple;
	bh=kcAVba4kClpBYhKhpRXE6mm7wgwJ3ChrH34if8g6p+I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QbbbkccHXu99ELVyQm84P6S13orQAQPK10llhSDTIcKpLUdixnFw1mLz1aphl7LuF/2pVUutNQPCDtuydzpUcCX3sehRNx9NUf93TXDJaTPprTKecJTyvhfxMEsU9lcwJq3RHhDRC6bsvWttjdVYLOXLFB5CkRPQlcYQQ6xWn7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kuG1orKj; arc=fail smtp.client-ip=40.107.212.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J61xh2ll/k3XOj2mVosER592nGu8yVc0ct1NdOT9uf0J/xxTR95ES1ReMLEYv3imYL1phIIm4y///CI6gsM9WRoEayYi0ZzXcypNfMkvV3c8CfBDeWDB0awgX9pyQZIv4T6GzYUM5czOM8qSz0nHbz/aGs7TtgBdUiF+ia7Nxi1ByIBZQywrp1aN8z4iunhfeAandrh+4XrO6Ykwwr8hnqh4xxAL7B8yUoRhGTVtXeie2TIqNEXUKbv0GH+3dBPPGDKQUOyPn5RmVSwOty+LIoFjU2QHkL2Q14h6M4zjpu0F7cQIhEOOJ7RbkuC+HV73a+Upuh4PW/FVqXn652vlqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d40jDv2EoA8qkjBQnhMpVkyini3Wdb/Qul8jAxhT3Dk=;
 b=mOJ0V3pcNILeqhJktIj8JpNofQHaoxj6O7j4wliPRUDLo+SdEa5PiuviU0/cPDlK6K6e5hiPQVQYCFTmDtCmzNaViLlA8n8wSOLiGnxu7AliirV9sWQn4Ut0aB6dFAF4rYHJwVnKXhJGn6L/7lGO07n32u4ikLu6TaVeGCyFnKf7bxD1gJ0BCkRYEUEz3APQy12Zfu8yYiZBZCmGWgmr1agouoJP7oFiWRkIOWUrKPOyUj2pQbeFgR2oQ4rQFS5c09AoNFMss61vDi2hMecsosl+iS1ZhuxTWFjTitfCM0smIQO61QDuChn+uIUN6yPyZ4jfVPYfQ/0FO8tFHBn+ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d40jDv2EoA8qkjBQnhMpVkyini3Wdb/Qul8jAxhT3Dk=;
 b=kuG1orKjD8ZGyQpC0brZZ2H3/06KE5OB4V7jIOIEGYMJO046J0+owQJfjAgvEKtd1lJTc1HSf9T6YUOb9yCLN6KkO5Y7XX2Z7AOnSFPu/6fsGy6PqC+FDnTtvyshW4O3WH8+43V4l+MtKYbTryL/TUv8dk5gBwwiKEcqzVu0mDM=
Received: from CY5PR22CA0009.namprd22.prod.outlook.com (2603:10b6:930:16::20)
 by DM4PR12MB6496.namprd12.prod.outlook.com (2603:10b6:8:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:47:26 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:930:16:cafe::c3) by CY5PR22CA0009.outlook.office365.com
 (2603:10b6:930:16::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:26 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:21 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 07/13] x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests
Date: Mon, 6 Jan 2025 18:16:27 +0530
Message-ID: <20250106124633.1418972-8-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106124633.1418972-1-nikunj@amd.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|DM4PR12MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: c3f27baa-d910-48ba-310c-08dd2e504639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R7jDx+2GJ/DhjYRr6KEoi4B0FvCrZMPEgAhpKaxIjhnFKP5v3+02S8JCPaUc?=
 =?us-ascii?Q?VFi5uSISwt0kCXSdckXBs6h5kQl0mZns/49cPE4XDVwTB+bK3nkt4OaCYNUR?=
 =?us-ascii?Q?quLRzl8RaFSJjo+rbSxzkFztcezZgiqON/O10v7JbiUcVLIL8hamQPLOLKLE?=
 =?us-ascii?Q?WEhNbsiBxHbpNafkt7O4baX/k0JW/ZQycqZYpjiKUE7IqV+3rQx3TnoiXLjU?=
 =?us-ascii?Q?V22gVoElIv13chzn8NonPAlLRIj6SDDR17BZTLBmNSBz7FJ5j25dNPWnBBSJ?=
 =?us-ascii?Q?F80POQm6Jm88d1lcpvaYrA7oq3wMq/zHpcS8WABO4B6/7fy/DBrkB1wWNYkl?=
 =?us-ascii?Q?Jx6RuWHE2Sm1xfUP4JdmCmWg4gAMvqtnDaCgcOzx+crACsmhsRD1k9Wrsrv/?=
 =?us-ascii?Q?6Iq0q+STSCapCFCZKFlGRUB6CFglc/zsLdePZDc409nEmOsSQtVavuRphy77?=
 =?us-ascii?Q?Qy6XXoZWqwf7IIVGgyuMNL8gkxVlr7djL3of9lDcYAL+J7d+Sz5nU+1fQLfJ?=
 =?us-ascii?Q?tuEifP8qODSFLB+9rCuV2gx/EoxRB7VAebowno1SmEAhTe8xuUA6PtPX00ke?=
 =?us-ascii?Q?cMDwkp/ir/XTgo/RMQeebTjKB0lKe6CToagqR1T0I6FCuy/ENShXciI6Wqsm?=
 =?us-ascii?Q?6gMisgLrWKEy9S9dcu2Vqese3oVWu6cgv9ez3W2TfWAi9v1aVhTlM9iR2D58?=
 =?us-ascii?Q?worYyam36d16Q3BbSi/c4ZlVNAtr7/0JuCpYCncPiEith+kxzezV3fzxpvQq?=
 =?us-ascii?Q?4VzMABQhpe7RYx1I6+aFAKd0wCRk3x+OzyqaS2twqch5ohg6JYeBdrWSfOIa?=
 =?us-ascii?Q?VRfLnHwdebh6jm6A+VkzhmArKn+i3FQuzHUF//otllX/QF/sTNuvIfcAR/H1?=
 =?us-ascii?Q?mxI7PxrIRuBewMUyIV1tWX/FzqH7U+b8oagpd+2UxK3jjGczUB5Ba6wzgO2K?=
 =?us-ascii?Q?DVVwtQcYfaO6IBMxDgaFMyRhb5Dv57Pe0t8z9VXsT2wamNG1nBgoGCdzvtQu?=
 =?us-ascii?Q?pgOe1ILXAs8fBUoBSe9gnWpz/qcNZJxVTc2cXdw5VmzzWof+uMdpkIqdLGHM?=
 =?us-ascii?Q?lAac2L5AV6T9pnGUhDwiq1EvD1tsRTKlqi/4TfaCoT5560OXf444rwbDgQ4U?=
 =?us-ascii?Q?la3yfErwm6Egi0EWQbNe9BubS/zYXNmLpiSkIyTjwZMlCm69vVRNA5l6tBx5?=
 =?us-ascii?Q?z2oqdFlnXiNEMzQrohZp5Y6kLRZzkn6wJrm09QGqtfFZj1/JhtBPqBiUuoyM?=
 =?us-ascii?Q?3DZ7TIQB0mm4VU3AqU/lMIWu6B3S8RH1Xxonh6BjGNNIM0kc6eaCYLN2t/EE?=
 =?us-ascii?Q?3jA0W0r0ejPFCJKNDb2Ak0ilFmftzzRxm+kEwXl+ZZRXhmn70Wji7mVaqbLb?=
 =?us-ascii?Q?EkjJpcS3YpEBkYjWCOyE1+p1r4byaIaAgDS5611Esofx4DCm+kF59oZAag5p?=
 =?us-ascii?Q?VtIY4ntBUKbijJ3pyGSfjZMGEsVrIfquzKzuRDP6Hwgo3B+AJH5bGUnf5Mdm?=
 =?us-ascii?Q?yYe3oAQJhn7ReJE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:26.5174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f27baa-d910-48ba-310c-08dd2e504639
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6496

The hypervisor should not be intercepting GUEST_TSC_FREQ MSR(0xcOO10134)
when Secure TSC is enabled. A #VC exception will be generated if the
GUEST_TSC_FREQ MSR is being intercepted. If this should occur and Secure
TSC is enabled, terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/coco/sev/core.c         | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3f3e2bc99162..9a71880eec07 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -608,6 +608,7 @@
 #define MSR_AMD_PERF_CTL		0xc0010062
 #define MSR_AMD_PERF_STATUS		0xc0010063
 #define MSR_AMD_PSTATE_DEF_BASE		0xc0010064
+#define MSR_AMD64_GUEST_TSC_FREQ	0xc0010134
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD_PPIN_CTL		0xc00102f0
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index f49d3e97e170..dbf4531c6271 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1431,12 +1431,19 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
 /*
  * TSC related accesses should not exit to the hypervisor when a guest is
  * executing with Secure TSC enabled, so special handling is required for
- * accesses of MSR_IA32_TSC.
+ * accesses of MSR_IA32_TSC and MSR_AMD64_GUEST_TSC_FREQ.
  */
 static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool write)
 {
 	u64 tsc;
 
+	/*
+	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is enabled.
+	 * Terminate the SNP guest when the interception is enabled.
+	 */
+	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
+		return ES_VMM_ERROR;
+
 	/*
 	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads of the TSC
 	 *         to return undefined values, so ignore all writes.
@@ -1469,6 +1476,7 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	case MSR_SVSM_CAA:
 		return __vc_handle_msr_caa(regs, write);
 	case MSR_IA32_TSC:
+	case MSR_AMD64_GUEST_TSC_FREQ:
 		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
 			return __vc_handle_secure_tsc_msrs(regs, write);
 		else
-- 
2.34.1


