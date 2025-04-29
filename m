Return-Path: <kvm+bounces-44703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 973A5AA0301
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D19C83B50C3
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF292749F5;
	Tue, 29 Apr 2025 06:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m6MvDUQg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4E02741D3;
	Tue, 29 Apr 2025 06:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907395; cv=fail; b=kPhvXI4MoJJ7Q+SsqeBMb+HFwct7I1I/sIqz+VxfeV5MKzu3lRv7In5x/anCK/ADiTIaaWuxTPHi3BHZHjcDuIrz2Zejl9ntrgkQDF2DRJarXb3oWuzMoZFxe140BZhneXaKkFuO/gLt1ONUNiaSJ81oOxHlpRsA/dAoCPClvv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907395; c=relaxed/simple;
	bh=9mCL5reqQT8MAa0H6IebqaADY09ZqRXFQjjEXXLUDIQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OS1C3tyEDa5uV2IFJxBQ/Z7XfaTvc8pAw9mahCJXHvF/ukFm899b28/J4qHqn2/407zOjgYpn7L3ji6odCoygd+2mcB4hup1nEA+xQJdmXn/c8qxZ6A+KKgoRxhsnEozrkZ2mGcoAnW5mTZneMG8EwNGFQnRovKOLCy6whad9nI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m6MvDUQg; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vmo0kFXduZwdiB4mA8WOgKXH6FM/vWFN9RJ+84fPxVgH1UAMthDMjjYKCuYX2jOkdQnq1at4CXHHBtC6mY+eC04y87Ga4hVvEiihP2NkQEM5FX/uUuc14E8JOZdO1XMG1Q+zsvRJzPv3Yl1K0IMA0gnDvYnTB7afKa+flEgYzd5DND8RjmuUyg1Sgud8wSrfCjYHjIzSJ5OnkFX1OMbLbko95OPjPcOVLE3z9LqLCrTxOOACSUSPKnW+8uQ8Bsf4trq2oakS3ETQJvqc5fiNlFfCO3Ehmsn+zTTphmZCzXNIYHwQ/+i0/yosXreECsiLnBmILI+KXW8MMM+2P22rYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FdyIoOnNxAqUftB6RClTFZll3s/0YsMOUQfYtnZ0gfI=;
 b=L5YsNl+WOqsLiA4rVKsS3Yv8CQQEF0MmrXLOrji9wplzulbCxfZDQ11+uA/zqtL/AD+BagfxgOALDZMc1PFHqhGV4Tjd6e83iv648atKo/YGSNGD9nNyOqO3aBp3rzMc/Jp7x/XApDYJI/xGoSDTHPL/dG131UrgPzsJQ+VpkovCscrJNanYOqV7/GFUXqZLXcNZAPS84nhmCOooFNrMqBCQxddPYlY4jbg9j7mb32sNSRiwIWIPGM8FofLbOaoXdsD5xGGPsePKTWg9XO2NN1O5eQ1KfPhz12EhJFo1pphZi/ZGBcoTJNeAR5IbnOxNpuax5cMUaq6n14IvEYyOEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdyIoOnNxAqUftB6RClTFZll3s/0YsMOUQfYtnZ0gfI=;
 b=m6MvDUQgNooPsKU9E7RPaJJfTBkn2CFuyepX66pxu2n9HTvFr0yFPmf2cqQR1fLcMO9A/3vOWDkRVDodg8YPR1X5Uvll1INIAE3e0E5nENi5X1uKfjvosbnW+a3B/Qjay7IgW7n5VwPBBVRaUYyTrM1GVPIr6N2L8683LruV5w0=
Received: from CH2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:610:50::31)
 by MW4PR12MB7032.namprd12.prod.outlook.com (2603:10b6:303:1e9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.34; Tue, 29 Apr
 2025 06:16:30 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:610:50:cafe::76) by CH2PR16CA0021.outlook.office365.com
 (2603:10b6:610:50::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.41 via Frontend Transport; Tue,
 29 Apr 2025 06:16:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:16:29 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:16:18 -0500
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
Subject: [PATCH v5 15/20] x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
Date: Tue, 29 Apr 2025 11:39:59 +0530
Message-ID: <20250429061004.205839-16-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|MW4PR12MB7032:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a170967-6cda-449e-6ac2-08dd86e5617f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XHVL82JvU5itpVE4x4Sbqs2f5REUsX1Oky/ZukhVtUl1Lyt9TRczRoIuOQMH?=
 =?us-ascii?Q?pmlrpOfLJeM21IrR3AwqUdX3pPywB+lcSoiJXH4o0yHltnQcFKaHS1WlPPKF?=
 =?us-ascii?Q?/SIcEtf4MWidWA3a1OifEtQ4GOZisXGXzL5dkssrPhJBvePdvEyHo4RQswyj?=
 =?us-ascii?Q?BGxNMhhw8NM5G9ni5ukPFhT2ZSPzIDsnQ9VUTx+ObkWqln6weaWCvrF2J3U4?=
 =?us-ascii?Q?kXawy0iEc//Bba1eegmWXMhVHOgo8We3k6ZSt30hY9XRdkVFB6TRT2OIlMK5?=
 =?us-ascii?Q?ikcbE/dZG5yfrA2aGkg0qX66hXBh7S9QHPI+E8v0uWmQokyBj//W3nNumy4d?=
 =?us-ascii?Q?EvHWNAL1M1/Zoz7UqdT6m20SOIC7yOcrEH7VGC7YghLPzBpazEc18WvhTqtB?=
 =?us-ascii?Q?xiixc1llGQKRurm5u0/wCWs4PG/aWYL3dU1KAy+q4DhOt+P9/ZEJFmbqu3Z2?=
 =?us-ascii?Q?nJAjJMohaw2CrVj6qhAzpEiznSWZbVyHNV6M3QmmRnjVIqpB77eiJVOg5rhi?=
 =?us-ascii?Q?Zf2YQDPtK42tDVri+XyOy77sfHFJYIsLadlck/d7UhnGK0FANyd/BNcaXeLs?=
 =?us-ascii?Q?aodE5MNJrQsWcPoyKLXCEtHw8ZrxRrdWGq/hac22fgmuiynevwx8umljZhwk?=
 =?us-ascii?Q?qtGH+HoiNOt+gBqwgAABSLcvrAQ9jQNBT17tsypjQaaa7/D52nxzdadw9Roh?=
 =?us-ascii?Q?3VAeuPjYGBO72QuOjdchuboHxJi4BN5pdRMpdtEzdKpqVWq9j4ihFq0+gBS+?=
 =?us-ascii?Q?ELuKY9b22IKcN2CYVuUghErrYXqFmQlXXzVeQX8Om0KUjbUf3xE2o+DOgD1U?=
 =?us-ascii?Q?S8ycQ2sG7BlQzqkwd8HbTi/NAp5GjRPxvxGtJgKDTCi/JkhQdA4oHqoWsq3q?=
 =?us-ascii?Q?xBuPd9wYf3xpTNVnfFEOiVxmBnMn1NH1TkqoNlDqhCfxTuLlLQ3aWa5GPFl1?=
 =?us-ascii?Q?bsYRTcTxornEcPZvHc09+bLbCbXyq0hDA082x3wPKUGMJW6rRXWjogEMrBnA?=
 =?us-ascii?Q?t+0PtdCz/MtdbhLCVEIoQ6cUljTAxtboX3Eoo0Qg4BtaHUKJFnbI1cj6Dj7/?=
 =?us-ascii?Q?dsEmpUBjXH9meoCSrEaELaCo1GvdkIJ+u86sGYawgC95w7hN2Pi/BF7N2Y96?=
 =?us-ascii?Q?gzVtTBrcqZLOlcq9+j9yScjHp8oHkwSTtSYjnuE7IP2ubB0VLp1uPojxZKjx?=
 =?us-ascii?Q?AwURXPyvhEXLwkMKUBq2Hft1RUyAGWea/zXOXwnE7s2OBwgrYvGZ2fnhU13e?=
 =?us-ascii?Q?uqW1sCW1pO+8714vuUwt4yHqyMWvmqEqgIukOfMqpwAoXYXsT73DXhMFJoLj?=
 =?us-ascii?Q?GYYRqsN/KHEppP1duUY6eiRnX/XSNU3XhIzE7OJc0qyoxtcElh0PsTRtL+jb?=
 =?us-ascii?Q?r6EAUlCdjzfKw8KzX/xzs5ZtOp4vDWghbCF/8DKYzXd2U65cC7s4f0ZBJvMD?=
 =?us-ascii?Q?Yq3+vdyG+z5OQ00BcKo4EDUyfs1V46WLvquUiNvr/ZRGraKc62ZshNGyg6hU?=
 =?us-ascii?Q?Mq/PwD4bsAzTV1F1kWpUHrQv4iJUwRf8MxFq?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:16:29.7082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a170967-6cda-449e-6ac2-08dd86e5617f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7032

Hypervisor need information about the current state of LVT registers
for device emulation and NMI. So, forward reads and write of these
registers to the hypervisor for Secure AVIC enabled guests.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index d7b9067fe996..fda1bd13aff6 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -97,6 +97,11 @@ static u32 savic_read(u32 reg)
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
@@ -107,11 +112,6 @@ static u32 savic_read(u32 reg)
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
@@ -160,19 +160,19 @@ static void savic_write(u32 reg, u32 data)
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


