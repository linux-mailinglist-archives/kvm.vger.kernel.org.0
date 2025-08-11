Return-Path: <kvm+bounces-54396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 680BAB20471
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E474F7AED64
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9A722425E;
	Mon, 11 Aug 2025 09:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dmSKwJXe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2065.outbound.protection.outlook.com [40.107.102.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2760B1DF270;
	Mon, 11 Aug 2025 09:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905671; cv=fail; b=Zwkj0z0qxJ0Md3QbWHSH926DFyBhH/qAPFZ8ONobqM1RP7j9j3YtJ9o9mqyiW2B9+kzwXLYcTP+KY69mKHCyHErpIVh5Lvs7bqsNNheptBzOEhy3W5q05tThhjd9Dz7XC8ZDYNWecQK9fcfuHZPC9TF5GLVDXfTB5rp9YigMkfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905671; c=relaxed/simple;
	bh=ZONVpSkm0Bu/5WXM9dVcIWdUhuOrpWEdcFhfaNQqWVI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgimLeYfkHXvDKZwPDgtmMZjKMzrVjGSOM+UqctqcQDR7Llp5+VV//0gUgV2pzbEmuq+eSK4LjUVplw7IfywBmWY+fdlrkfE69hRIvY3odfuh7kEvw5gbMBzDftyVA4SI72JFWFvth4IVMpLHAFVuGFUUJkeJ+8IybTOTebx7SE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dmSKwJXe; arc=fail smtp.client-ip=40.107.102.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dcTLVpbZJepYKGrQhec4mLZWprLZFopqGLo0mRvWdpI0w5A8oa1kRbhJSNgw3/WozVYMcUHVU3MYHchtELV5wDdsWgwkh1mO73PPRTYf0t4Y/zlOziMdOwfWWkVixa9g1Aaf0Hb9P7I8DcEw2/I9DKZZwsynumOblJJ/jW7rnHE92Rz34XZiM/qVk9KLYetrC3CkL98USD/d9LZrRHdt1E5A83HPGL46S2FPjFcEy3Q7gw68Q6cOIUdrL0ipEbxkem8J2K48yHSb+BXQ1HVd3zjPo4qxKOXiJuqrbGRlyauv0QwTzFiYU2+UwDxefThDOtYRBU40VjbkPLn5xQgdiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1/V5md7qa+MbVNjRDAV+2U78r+pHjy+WQ1bdv33MVw=;
 b=WnjS0bHRkY7EpGc7vRHZI2aWuKZbmsbamzFNqsnT+9wwj4boAE2KdOL2NvJ7ymUL8Sl/FU30j+tDdPs6hCnLxxfoRAFU4fPOMSaAtkSQAXtp5PJahj9MByywpkQdcGJzRT+Y707wvhQhKeh2TPsDn1QM5Tihg0oiNMJFwY9HPpuCZPY02/iIIwY2lWjsWNkvSGMtnwoG3ymUBoHW8HSOMZwY+pTZqjAe8kY5go4ba/0h2/10nIy3cgUu4IjokG1TtnBrd9slcVpmUWR5FGhbfNPBiMHUCW7fB/gfJIlN+txCVAxh7VWBKN+GGQ29hnDydA0rN0U8hZING2JChAkO+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1/V5md7qa+MbVNjRDAV+2U78r+pHjy+WQ1bdv33MVw=;
 b=dmSKwJXeMAJiUJOzV+2YEsBISlwPaDk0zJqVqyCACEWAQPK2fUMQIN6RIBE80/Y4JeIpmQXH1q5rBKmENZ3Ucn3h0nsUDzPwecXx6AGohC/079vmxlOwCfiIafktHitBivoriuTxy3R5qs4urgIWmCy/d7Sf8ivYoz89Qqacz6I=
Received: from CH2PR14CA0035.namprd14.prod.outlook.com (2603:10b6:610:56::15)
 by CY5PR12MB6479.namprd12.prod.outlook.com (2603:10b6:930:34::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Mon, 11 Aug
 2025 09:47:46 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::eb) by CH2PR14CA0035.outlook.office365.com
 (2603:10b6:610:56::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.21 via Frontend Transport; Mon,
 11 Aug 2025 09:47:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:47:45 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:47:38 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v9 08/18] x86/apic: Support LAPIC timer for Secure AVIC
Date: Mon, 11 Aug 2025 15:14:34 +0530
Message-ID: <20250811094444.203161-9-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|CY5PR12MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: e314e345-1dd3-4178-a982-08ddd8bc200f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dNFwxKRso61pY4oaYiiLhzFu5VrEfFm3bwo5LtO8wU9GRUoOyQSCW9HBbIte?=
 =?us-ascii?Q?FwH8Tyog9wk+vIumDVHuPqLQQG3fctApNTSKARYlBv8GuOJwhIlM+rP8HBGW?=
 =?us-ascii?Q?nr5AmnaakrGtScPgHnBZRrUDsQx5vZ+qm/owOJIt4jsvI51+bSglG96heKtH?=
 =?us-ascii?Q?WbJrVSc4Pdn0btk6KbVk9M1Bab0D1INFeub1BTiQp8O/vTFXPpqAhJ3gKgSC?=
 =?us-ascii?Q?F5rL50hZ4zDBmKOA25oNs5TsFB9nGxGAXxdlL/yvjEWRXEzyntKePNFLJ4PF?=
 =?us-ascii?Q?s51WHR/cm/N0nGdSDCiTi3eO6swTERoLskxl9ou1ma37uleqCKuZSwKoLhSY?=
 =?us-ascii?Q?+pqIoVk/A3mpZLXb9sTfnLOJieHlrluUZRoS85TUzUGVeMxBAYrKSLkNLhCw?=
 =?us-ascii?Q?BW/iOykuL59DULIyzuLbNhF72cmatWqo7cxS7JIt7SpCo7bZXGBEIWBY/LwF?=
 =?us-ascii?Q?E6r/tuv/jhKuVlS3he/MzVrL315RoRrFkVCjGU/7zlBOlJD5EK3C3A7a6SVH?=
 =?us-ascii?Q?KeQu/whchl2eQJ73NEbjHLvE6TzLHDIRReB39Jwsb0RMndUrppzNtWzfE8Ds?=
 =?us-ascii?Q?E2rVwIVNWIeCxm4Oae9OMFRJNbRrXfrIOpJ34gI7AYo4NsdazkV8FGgT+ffk?=
 =?us-ascii?Q?KWIlYs/ysJo08Kr6geGvk1b4DQJ5tFUlW3+OnJUtkeJXuwtQAq0WIfSBLjKJ?=
 =?us-ascii?Q?11i+9RC6Kyjgm8cQsMGvWdphKyZQyRRK74PyRASH09V7HKO51M52IZxNoBWZ?=
 =?us-ascii?Q?dbwGPe25rl+nArvKmMPnjp7cNLyYSZSGbXPonnvSTFvj+2cXvlPdhqkoAct/?=
 =?us-ascii?Q?r/Z9V2Q2SbxfBy3xkg+K1j2ixHHP3Y9TOor3Li1LtweXLVAdfZIL7yi6C+eC?=
 =?us-ascii?Q?HsAOGNbjyvxd3tnaPGyYjLZwtQBj4vTcxgelCzWUKpYFJJdOk+gBBsCTLXyQ?=
 =?us-ascii?Q?1pcu7kXtTDoV8Ww5ga4O/7YKyfDuMIIrZK7F4OVWIFBJ/wdPyIXM7HgmTQZG?=
 =?us-ascii?Q?pd/+dIi922PyT/uadyFlA8t7EeR+lRPz0u56I7SvvHvKP7tbCoX9k2mIKhkJ?=
 =?us-ascii?Q?T1eVYj3CYWYuzVUJhdYsfmnsF2/ocnVUaKyfpEAuwkEd5JFmNitrx0J3jcWx?=
 =?us-ascii?Q?ER3liZcrlJsTKQZr6Aklc77apAa6zxjaGCku9+GTNE1bhUs9ixpdhJPmPoEn?=
 =?us-ascii?Q?aaSj5dFF7yVAzhUsj5fzLK+bcgeekDCq9ENwn0ssYSZtpxhAzOWuGlz+DBqE?=
 =?us-ascii?Q?YIraVRFEtxumdEP7eG7xU7zQecsvO+hP2IUNhlIRrkZyQtuJrVTiSD+VfKKx?=
 =?us-ascii?Q?xufqyE981k72A7hJVOQKzQ3B2Upe6/cE+omF4eaCySINh7RMxg0br7sbapBo?=
 =?us-ascii?Q?2DEfULSdoUwq9zLWPxwcGpQceaNsadOBsB5ng7CfmzbcRbDhclyJ4CG8QC5s?=
 =?us-ascii?Q?NUIs5MWRdMWCPa63GP9eNQTefeOx8wjpnzUg2uKyMnMh7PbBQrA87QEWYy39?=
 =?us-ascii?Q?1Fwzt4TGxiu9y0wYczxyM/oQV4FAu0GCBCYx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:47:45.9293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e314e345-1dd3-4178-a982-08ddd8bc200f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6479

Secure AVIC requires LAPIC timer to be emulated by the hypervisor.
KVM already supports emulating LAPIC timer using hrtimers. In order
to emulate LAPIC timer, APIC_LVTT, APIC_TMICT and APIC_TDCR register
values need to be propagated to the hypervisor for arming the timer.
APIC_TMCCT register value has to be read from the hypervisor, which
is required for calibrating the APIC timer. So, read/write all APIC
timer registers from/to the hypervisor.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.
 
 arch/x86/coco/sev/core.c            | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c |  7 +++++--
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 221a0fc0c387..3f64ed6bd1e6 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1085,6 +1085,32 @@ int __init sev_es_efi_map_ghcbs_cas(pgd_t *pgd)
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
index e849e616dd24..d10ca66aa684 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -534,6 +534,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
@@ -609,6 +610,7 @@ static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
+static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 36f1326fea2e..69b1084da8f4 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -592,6 +592,8 @@ static void setup_APIC_timer(void)
 						0xF, ~0UL);
 	} else
 		clockevents_register_device(levt);
+
+	apic_update_vector(smp_processor_id(), LOCAL_TIMER_VECTOR, true);
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index dbd488191a16..668912945d3b 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -66,6 +66,7 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
 	case APIC_TASKPRI:
@@ -185,10 +186,12 @@ static void savic_write(u32 reg, u32 data)
 
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


