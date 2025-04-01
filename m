Return-Path: <kvm+bounces-42312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB5FA779CB
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83BB13ADFD5
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB201FBEA5;
	Tue,  1 Apr 2025 11:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZRMpJXyM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A013C1F12F1;
	Tue,  1 Apr 2025 11:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507625; cv=fail; b=SWoA8ILpslcZXJB/KxKra71IjArBmzi8N4Cln1Z/iIm5IwaOFo0tXE91/YGFFgXN9pFPYkC/vgED6bBIXz8HNw10yxT5kigCsE+aThtMv1vIep3G5OImK4ADrgqiTCqXlGuI5oKdvwQ/EDQ1Pd1+CnQpirMYGn2Y+YJYCD0aheI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507625; c=relaxed/simple;
	bh=8/ELsWybgnIXv1i47c4RGxmxeYQBD0td+EUnalRhJ/E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJoGtFf19ESqfJ9eCvo92/8W5X4R4fDR9tjMNKY8wWHxy3rG0aUm5lLFy5XMe8pOlx1umI+vZhNzb6Sikpl9kS0IwEbxJjUKXYtKWSaYI9Az5pp24TKksElql1SWPmPT6WILr0K8lIM4DuaaKlBdmh3zrC6QhnktxpEu75WmrZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZRMpJXyM; arc=fail smtp.client-ip=40.107.237.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iao6F5wZ8kJjveSKMz+QvgMKTHlYYYOCkzj3TW9q0WJ3gqLbiIc0kbPgkZmre9vvfntclB4rbjf/3fBpZS2IWz4lFbnG3SqoM5kDb3Ip76snsXyGtZkBZl4HOIUCus8AkmBU7TQPmL7W7ReePAzRZs/QTNpM35EdYxTLli5Das/bjUxSanV9VpfuPEA891Ct0ZxVLFv8uD63CkFt9XSheX/CD6HyRDKr95I1F4FW5shDCVxI3qF9NqyfTC6nU7MvNUpVKjzp3VgnTTLdSSuEzEEJNjo3LTgjrwBkgq1g6iqiNkAtzEP+I5h+0qkynyGDg6dqth8ALDUmBm+t6sef3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TromaWv4bDLiiKQovDaBmEqVp8ucnrTwr3wb8/61/mI=;
 b=XtJ/dL2yMiJP1/0uCNBqI6ezLbtzkGt2S9YhmAwFsC/fqnq/mjbiqPOQYwdPIYQcBAzgm2TUx9w4RFJ4yZZUD1J5HaDI8W0UTjYXGdGJ/52zvSLBzRzC52KuzBLCd+zuWr4WDx4/2jQy7mnNUZCOBqhygwXR25fNtjIu7AW2F4gr2quqWRQnv6/Dn8GUCL6WrSiZbBgP+Pe/LY39zT5meZZ+HZqCt6t8mLHMCgorTakRjXkTZbgMimUoT1kC+GvjnhYK2KrjBzaqqA/B3m3dCrXLlJL7Iz2Xsz7eAre6P5EuHeiD7C/8bUjPvR5Tdg5s6UMzQ2IMm6rDSoASKfyl5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TromaWv4bDLiiKQovDaBmEqVp8ucnrTwr3wb8/61/mI=;
 b=ZRMpJXyMin7E5M8zQK6HzebkiPhnHZ4SbPkbQ2Uni9/IksFHfNc0vv4ez0S2S/Y2fNEP2BXkgsMEuzWV7IRZmDLznAKBFqcKfJLpIX8OkcNQsHmbBebdB7pgEbkzVXffaWgsw6tz3iuEBaUl35dDLVKfG44rYoOUpzJCq5Cyax0=
Received: from PH8PR07CA0020.namprd07.prod.outlook.com (2603:10b6:510:2cd::12)
 by CY3PR12MB9577.namprd12.prod.outlook.com (2603:10b6:930:109::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.45; Tue, 1 Apr
 2025 11:40:21 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:510:2cd:cafe::cb) by PH8PR07CA0020.outlook.office365.com
 (2603:10b6:510:2cd::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.54 via Frontend Transport; Tue,
 1 Apr 2025 11:40:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:40:20 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:40:14 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v3 12/17] x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
Date: Tue, 1 Apr 2025 17:06:11 +0530
Message-ID: <20250401113616.204203-13-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|CY3PR12MB9577:EE_
X-MS-Office365-Filtering-Correlation-Id: ddb42be8-cb45-47f0-ee2b-08dd7111fb8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dHVCNbUPCu6g8a8K+viC4XaWzos1cO4XGzxCcroPSssfns8dSTw7Pe+5CeuD?=
 =?us-ascii?Q?tNNaEOuEKksbuxv8EgC8gEJF9H6BSABkfereYCH4/GfLqAzRiHeWC/f8ZvHA?=
 =?us-ascii?Q?4TEG8aJLOfwfW15mLji9/pr2lJ2Hl4zDeW7Cucc3DSx2sFzkqrV3ah5bl+aH?=
 =?us-ascii?Q?PnaqT8l/nd5LgUZ8PdN3V3mKQzqq7ZLar1UCbIqqoVmEMcBeVMP6yCXdHgBp?=
 =?us-ascii?Q?sIB+0SZOg8es7tbyxsm23syZ5QeLxyWqyRNiCxRABte9T40VPxb4ZoNL6l7j?=
 =?us-ascii?Q?iLzsxIBFNvA5ZPCMNTpG8tVLgBXu+9SWj859uuZ/6Zxhz/DrgJ06PS+/N8bG?=
 =?us-ascii?Q?JG8CRaghJuijKE9JdkxyCOeCOwJ8GBOCuzUTu7eIP3lr1aVsxvC9y5k4XN0D?=
 =?us-ascii?Q?eQP4TVeNtIEqW1K1cgfd0y/KG7h3UvmXGu8eycqbg2xSf37S4JbRJ9W9pT1K?=
 =?us-ascii?Q?gzWAYTT1rnfeL/F5XyGab9WJGyr4N8oPykRNbSGmU/Yl7RIV0FtYt170shMt?=
 =?us-ascii?Q?ESLiU5vwHF8L/LiS+GGEjCXPBYyer/xaRXDDhNO9R56V7RTzRGAUkFGLiUcx?=
 =?us-ascii?Q?qdIRUfPgTamMCuZf3UFkV4iU8ZNauHaf3D3Uqtcm2MmFDA9y2Yhp502Yewo5?=
 =?us-ascii?Q?QMwSE3w0VBeC/sIxZlYMPk9Nlk51nzjuXOBLmaMmmgjMYAk9M1wH/9S+4/sh?=
 =?us-ascii?Q?5hz3+Ay96NBeMtw6hvD7kUJ1PZNvOSD75Qbtb1AkLD7KK4ykyEyBD0USUIaQ?=
 =?us-ascii?Q?MdS+vwA5FSy3hSKN6HIcwlqMeRVdzciFn73xs2dikmT56fdkBoQ3JgEOoRSb?=
 =?us-ascii?Q?R9GvuuIBz51ztSG0dLfjJrCPMD8CdHeYGfwwHYd5t/1jMNR7YYggZeKwt/f5?=
 =?us-ascii?Q?iODrJZzPc2AwoRVxjFPeLSbceeUXn0Ch37Gr2jvc4ISJoeIzHK/CPkPcM7Hc?=
 =?us-ascii?Q?RMue7kQIoBPsGrvkrhc53qs+9bsNsmo/JcSdJh/AXkCAf61OMIXecdqxmb9B?=
 =?us-ascii?Q?GzdYXdXSETrnduKq/F/OGoqp1vJTqMa4gtMRYmorgcbPhhVj3LNm9XlVfsDh?=
 =?us-ascii?Q?JEhKcsA7LsOabHDXxpe+J8OCDlJd0U/7v2zCef0vZZmHuzokbsVlbM7E1eTY?=
 =?us-ascii?Q?mawNnjfvPhuHdK/9a9NDniJhBv/MoM7ZfwKggNAOd+neaWQsVhsESB985gHB?=
 =?us-ascii?Q?TBrNkzHcGcAEP4h2vZyNSdczqSFWlpmN4vTR8e1bE8LL1A7G/3gi6qbQkkep?=
 =?us-ascii?Q?I476av9ZX0pvt9eCtMgsxVCT0hFlU7UQBz83ZLvBseSQoQIKxI/j1yunKd/R?=
 =?us-ascii?Q?oi+NdUfGW5slPfSujRypSs7Ef9sGqw7kaINSugyj4pk9NFySkv7G/yGKDd/Q?=
 =?us-ascii?Q?/VkUkNX4vqaqE7hQOMly9Olp/u/tLwxOY2G7PhTE4YJG/WA9WVV6bFWP0sRM?=
 =?us-ascii?Q?k2Vxt9Di7AFPUtkZ3rNn/E7HfAfna0VSEEExwzdirhvoKH+mPtR8g9QhoUDI?=
 =?us-ascii?Q?TcxFNiD9VjWkrrY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:40:20.3600
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb42be8-cb45-47f0-ee2b-08dd7111fb8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9577

Hypervisor need information about the current state of LVT registers
for device emulation and NMI. So, forward reads and write of these
registers to the Hypervisor for Secure AVIC guests.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 845d90cbdcdf..4adb9cad0a0c 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -88,6 +88,11 @@ static u32 x2apic_savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
 		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
@@ -98,11 +103,6 @@ static u32 x2apic_savic_read(u32 reg)
 	case APIC_SPIV:
 	case APIC_ESR:
 	case APIC_ICR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVT0:
-	case APIC_LVT1:
-	case APIC_LVTERR:
 	case APIC_EFEAT:
 	case APIC_ECTRL:
 	case APIC_SEOI:
@@ -151,19 +151,19 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	case APIC_LVTT:
 	case APIC_TMICT:
 	case APIC_TDCR:
-		savic_ghcb_msr_write(reg, data);
-		break;
 	case APIC_LVT0:
 	case APIC_LVT1:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+		savic_ghcb_msr_write(reg, data);
+		break;
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
 	case SAVIC_NMI_REQ:
 	case APIC_ESR:
 	case APIC_ICR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVTERR:
 	case APIC_ECTRL:
 	case APIC_SEOI:
 	case APIC_IER:
-- 
2.34.1


