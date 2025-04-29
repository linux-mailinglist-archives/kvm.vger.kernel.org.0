Return-Path: <kvm+bounces-44698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0C4AA02DA
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:16:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9E371B63D26
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A40B2749F5;
	Tue, 29 Apr 2025 06:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p17Z1jCi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F30127465F;
	Tue, 29 Apr 2025 06:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907270; cv=fail; b=uc9fBy4xI12BDXSeqTdIsUv3RhV9nzvnWmwT25ffg4H3BaUuflb+fkjpHyG7ynW35tMsaVELb1/T81uKpLI8u0llCkNSV9qcuM/eNxIHbd7e8JKAu9YoeVxXn7aWHWIaMTyWMXkiOh4fGrrZmYzINDumjBhO93qWxmGxwMxnk2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907270; c=relaxed/simple;
	bh=TIwRMpDHOnudrZILPi/EIXt9M+KBYkSfYbedmGnqaU4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmEQrST9NRx0gQgcA/bA1tPxScFpm+OrkksbPmOM/uGbiiVkm4KC/9LjAfJMgmEdin9Ekz5A6NXmXf0UysgZn4wLIduh60jtQY5+HlEn5jB5ji3HU/QOHtlb1M/aY6ZYO3pc8hRRjHYkHfkS4w4Dn8hWkJCuxHfsGApD1Dhe1ME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p17Z1jCi; arc=fail smtp.client-ip=40.107.94.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTmZ0PZwrr55JRCAL4xjbSyNcGPIBqhVp68JthcLulSKuZ/Tk6h+DDLwC3zwB/buVjm/kPxslPv8+dp+8zjovY906e8VIsXa+dvO5VhRk6O69CSvtP3fDcK0+GBuqg/P4sx55MpxfJncsKR7pGCS1mCGln3+HSvotZ8+MzvBXyO+9EaysHboGjCLMY0pWOt115y00j02KC7bYbnB3GyD1yER6erlzZ503jaL3Lpi8gg+uydMarIZhPeujiAn6ApZFWuiOTAecKGizs159rZroaPE0s1AZjDQ2ykkfDUiK4dMiiTvwiyPnnVmFBmy1uCe00w1qGjN/18vz/GOxmPUFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iH0o+6eyncMjY2WVaLwmKrFPPoVeJy4woEAPpYabzLA=;
 b=X6TTGCC1qyVJ9Vhi4NuXYCvuExOLaTnAVLpiGm2UIAmxcOOeS8A93XTq0GRjn9kbpemLVRL8QpfAsQYmopZ0oYcgBT2etLJPipcalWC4jYlrYhBw8DZEIcg7Y8V8QA775pSZR4V7D7PuxGtXncUsmqTNF2d5F3i6Sckb28uZhxsxVOzUDA/JCuX53sbU/XCBybY2eCjKUzklhWPe1EUWFkRlGoWgChCuLaPpZLT0b0/qW4Pm+O7+/pRTUAkORAvDybqjP1DuK2rYBg7dOQ01+SAmc8vDTEUGXWX4z54kJTMKaSmlDZuH6f5Awb9J01ihLFykDKyp8RzV3XEdruTatA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH0o+6eyncMjY2WVaLwmKrFPPoVeJy4woEAPpYabzLA=;
 b=p17Z1jCia2XdGE/055Fa25+eD3yga2E3tzkDxEmUP8PZscZ3pcff0+ILHOt1FwZG/IXLvv2sk1FzpqDgwWvEnfFmdTdXzNZBCuTcKdcrFgak6M/AjfIq1VuapqdgUS/1R84ARvVmLkuyDb850ep9nW8znPTVB/wUt0hAbiY6KOk=
Received: from BLAPR03CA0026.namprd03.prod.outlook.com (2603:10b6:208:32b::31)
 by DS7PR12MB5813.namprd12.prod.outlook.com (2603:10b6:8:75::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 06:14:25 +0000
Received: from BL6PEPF0001AB59.namprd02.prod.outlook.com
 (2603:10b6:208:32b:cafe::82) by BLAPR03CA0026.outlook.office365.com
 (2603:10b6:208:32b::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.37 via Frontend Transport; Tue,
 29 Apr 2025 06:14:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB59.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:14:25 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:14:13 -0500
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
Subject: [PATCH v5 10/20] x86/apic: Support LAPIC timer for Secure AVIC
Date: Tue, 29 Apr 2025 11:39:54 +0530
Message-ID: <20250429061004.205839-11-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB59:EE_|DS7PR12MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: 5be1d1fa-a84b-4e80-66ea-08dd86e5176b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vyNnAufa9VXpmP8rIidtmlGlR02vMzlnJ/FlvEvDNQnzBDGChJIX0OgZB+5j?=
 =?us-ascii?Q?H5cOFp80XJ151x01dzqfE+8NFjpVimMeY56J2/jJ8dB8rlyv82clC/W/OAQZ?=
 =?us-ascii?Q?DIYN23TMIcZ535uQmxxL0s2/kUQGdOlwD+X/XQMKUZpJ2W9jpap026jXJcmI?=
 =?us-ascii?Q?8biGpvo/KSLaMizx1GSKKcG5QrK24T+ud4bBC3KVHpACnmeddtcJkXnbtIQl?=
 =?us-ascii?Q?UINSHQpG7oyI1Nx9yHlfIPY2+e4n5MLbEWgzXGVmfUG7lhi39LnHTwPKJjfS?=
 =?us-ascii?Q?YydvHoRi/8DhqNT+Xh4OWNXrZXTXlvULiMlpLeC5A/9GLTnQ0QTom570mLbn?=
 =?us-ascii?Q?kESIgD5yrIeE/KvV7bC9/1ru5O5TOsn/35SAvWxzvbUxslojg7+kZLi4wtNa?=
 =?us-ascii?Q?+c0elFRxkXET/cyJ2fZfJ2Zt/lfz4PIST/gtidTnHesLE/Ioh63sZ4SiYZd6?=
 =?us-ascii?Q?K5o4WgNpQCZ/fLOGs6I1AVGytdebIvRCl2lGE0jXiAFt9qQMrwpXAeh1hPCf?=
 =?us-ascii?Q?7KfDNmhCno0w1HHhf3lDaVRMA1kIRpQKEbM3pmsk+Zz3G0vMrA7vI+PxfPUz?=
 =?us-ascii?Q?sLKzH1aqflYtF90CPVxJKVcJ+6xC9/oYrtr09jLTf/powcF1lvnW200Uj54V?=
 =?us-ascii?Q?zOgqZHIp8dP0jhxUK7qG9Soe2PC/z/AL+LSwI3w3+m7mJdEdY/FuG5TZqceE?=
 =?us-ascii?Q?FC+pnSS6UsCCAVbZyYCe1y2ChrY3ros88aaDK7ZI7ywKJjGTXNoZCg8OkoMq?=
 =?us-ascii?Q?j//92dQfqcOA20aUAnI9CMlOSTBz1Z+OkPFltdkItyGa9dTshGrShprMqAwI?=
 =?us-ascii?Q?Y4/aMpV5WkiUN6AOAtFTZIoWUcX77cbivnK8czX5pDLhty+7yyT5s99O30Vr?=
 =?us-ascii?Q?YdikgEP+7+5R7TKc6DIS9/6M/XNHnELtQ9r0fl2ZYYrAct6egp2fw3SPam01?=
 =?us-ascii?Q?OW3QNHYzoXUcFE/cqNE41V0CAStx/catZY1S+MTFlC3PedDuMLcJcn64nazj?=
 =?us-ascii?Q?q1Hy6weemAGwEli0g67ZKtX4sS8fFyf7iiAGHrxzx5ADVekNqdudt7F942sy?=
 =?us-ascii?Q?MbDxaHZYrnA64YVADpjYEBdETlp/+Ln+nntdmHwl7eRdxBezsX619X/8JH8h?=
 =?us-ascii?Q?EhZIDn5WUprv8UI7K5moZQUqLIkiZoMKd28S/B0ruMBH+TCbL0nXtwObGhME?=
 =?us-ascii?Q?mKsrDz2h2W5pC5pjiXilwRQDbw9a2hmBvqpG3XPuJRxb0qjZJYaTnO60gWSi?=
 =?us-ascii?Q?cLvc+OLpp9DRHrspJyyJt+dhMIets1jQ7A8njxxaq4pUHlivmiQ4bh491+wK?=
 =?us-ascii?Q?CXzzYO8ASidk9M3ZaPiU9aKtwCUv7S2N+w1J7d0E3CO1Cv1eNoZjeIcPMusY?=
 =?us-ascii?Q?ZnR229z1rxPVLABaeTCKdC4s2+zGDwI0l3l4m84a+7qrYdUkDBhMzkw4/AF0?=
 =?us-ascii?Q?7q/Ci3TnzmTiFJyob7qRvFuNDelPt0Hxi1Tey3WecQEB333pFsHCG3DKK6Tw?=
 =?us-ascii?Q?jeKYZ1JyPxwbwwHRfY4ytZMR/B3lZ39bkB/C?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:14:25.4561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be1d1fa-a84b-4e80-66ea-08dd86e5176b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB59.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5813

Secure AVIC requires LAPIC timer to be emulated by the hypervisor.
KVM already supports emulating LAPIC timer using hrtimers. In order
to emulate LAPIC timer, APIC_LVTT, APIC_TMICT and APIC_TDCR register
values need to be propagated to the hypervisor for arming the timer.
APIC_TMCCT register value has to be read from the hypervisor, which
is required for calibrating the APIC timer. So, read/write all APIC
timer registers from/to the hypervisor.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - Resolve merge conflicts due to addition of new sev-startup.c

 arch/x86/coco/sev/core.c            | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c |  7 +++++--
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 545d314f4a83..d62075379a33 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1004,6 +1004,32 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
 	return 0;
 }
 
+u64 savic_ghcb_msr_read(u32 reg)
+{
+	u64 msr = APIC_BASE_MSR + (reg >> 4);
+	struct pt_regs regs = { .cx = msr };
+	struct es_em_ctxt ctxt = { .regs = &regs };
+	struct ghcb_state state;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	res = sev_es_ghcb_handle_msr(ghcb, &ctxt, false);
+	if (res != ES_OK) {
+		pr_err("Secure AVIC msr (0x%llx) read returned error (%d)\n", msr, res);
+		/* MSR read failures are treated as fatal errors */
+		snp_abort();
+	}
+
+	__sev_put_ghcb(&state);
+
+	return regs.ax | regs.dx << 32;
+}
+
 void savic_ghcb_msr_write(u32 reg, u64 value)
 {
 	u64 msr = APIC_BASE_MSR + (reg >> 4);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 2056e7be41d0..fab71d311135 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -521,6 +521,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
@@ -574,6 +575,7 @@ static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
+static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 16e88449dc62..88e4bddff5ba 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -591,6 +591,8 @@ static void setup_APIC_timer(void)
 						0xF, ~0UL);
 	} else
 		clockevents_register_device(levt);
+
+	apic_update_vector(smp_processor_id(), LOCAL_TIMER_VECTOR, true);
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 9398b34a5184..0935a1da6d72 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -92,6 +92,7 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
 	case APIC_TASKPRI:
@@ -152,10 +153,12 @@ static void savic_write(u32 reg, u32 data)
 {
 	switch (reg) {
 	case APIC_LVTT:
-	case APIC_LVT0:
-	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
+		savic_ghcb_msr_write(reg, data);
+		break;
+	case APIC_LVT0:
+	case APIC_LVT1:
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
-- 
2.34.1


