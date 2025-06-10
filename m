Return-Path: <kvm+bounces-48843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B95AAD4193
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D40DF177B20
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE433245038;
	Tue, 10 Jun 2025 18:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sI0JYp0D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816B62367CC;
	Tue, 10 Jun 2025 18:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578691; cv=fail; b=WB1kjZlNNnA+i85Y2CrPe0vjltoZ5h9HRneercOz6V5TWUCoeN9UMXKUGcO8QhllIyrN90uLcAm/Az8jCcYdQgX5xaGInkByYHrAEvgoLW30EepVAG4ueaUT0qKv/yac8G1HH2bHwMzsmzZskUTXrT2RpxFeX2KEUH1Q+O6xyXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578691; c=relaxed/simple;
	bh=Wy1JYPfciiZW3xqqhcYj+CWHYx4Ej4lNdfjEJoKUk54=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jl56Fu82Cx+2YWqF4CSHoe09W7CPkqrCLhlxLVNvTyraefMpb9fTH+lKoYelIJEWZXpx4r+zQlAxsAdWuGEVSJnmUyAUki+DJ6Nd/Gx1ke3O4pMUJiFm76BXiYqvqAwhwJr2rv8TMTResjNeWFeS3pUYg2RuYpYNxalEr2sPr9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sI0JYp0D; arc=fail smtp.client-ip=40.107.243.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O6TUZmX040cHeF5JA3MLV75qrITs1pdKsZ8hK70E0XAwm06/QT9roYMwLIsA8R6qimEgDS1wOTB3nOtB+bY6Oibc/rh0RxX9F6Nvvdxfwvw5XclBRkYUU/HCiWAvQ/FyCBT4WuZH1nTfPVbRfidJVYMZrLwikH6m295wmLTckc3i1Aa/VSZ4Qc5ce190OTHvJvhcAYOqeuZdmY79VlsZ9/tFoCwkfJh1B7BmAdjxZ7FtERmk0HwkNyTG2zhiQH3t3WhwBPAFdvXYm7lzKMDQnPH8NjVdX6S+KnF4fhQZqZtHXSVGFhxfah49ckoCyH1k4SPjzpe1HRDrbp9yfGN6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Ig9ibYosY0/1TQaAvgUkIUfHQ132ND+e04EL/xoa6w=;
 b=m2I46pgHqZho9yHI8I98VguWk6WeotM+MvGe5I1ff1cCUf6eT7ysFLq4xlGXKjXgHo3BMa5WPJtsrZrMWT5aHhn9cLb4INSvzSk8968Rg59dgB4AeOG5eetNkzVVxSHkbCDz4Xc/4fLWkaJ2C+QP9nfHMPWta44kdFrDz6Vst+4MDwl2b6CqUDNR6Izm1fRpOJGYmkQnlbK3bERxDjZYgk4BOOQD2FIMFsCtiJp1V61Kdo5YnBZHaepoK6NP7Jf0R031rOqTtpY2Bl0msHMiamWJppGYZDmysJKk73gTm7O3pPsnyl0PFCus1BhtrRalyYCGjwbTogrZ4/Xv58VYVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Ig9ibYosY0/1TQaAvgUkIUfHQ132ND+e04EL/xoa6w=;
 b=sI0JYp0Dl8H9BvaEKYK6HDVIG6YsOO/5tGriWRCiJnu1aNCVJe6UeVsCNFeFrQtYE1DxUkffBJYLzmuotyh+98ZCZwALxoMNikRXHKVCmO0pck82HfVt8Flj3aNoCi9vVxZtN9ExZpI/crCd+zh3rAYccuR/++uWSwRXolh62Gk=
Received: from BN9P222CA0010.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::15)
 by PH0PR12MB7861.namprd12.prod.outlook.com (2603:10b6:510:26e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 18:04:45 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:408:10c:cafe::c0) by BN9P222CA0010.outlook.office365.com
 (2603:10b6:408:10c::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.19 via Frontend Transport; Tue,
 10 Jun 2025 18:04:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:04:44 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:04:36 -0500
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
Subject: [RFC PATCH v7 27/37] x86/apic: Support LAPIC timer for Secure AVIC
Date: Tue, 10 Jun 2025 23:24:14 +0530
Message-ID: <20250610175424.209796-28-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|PH0PR12MB7861:EE_
X-MS-Office365-Filtering-Correlation-Id: 61b68056-b492-44a0-20ab-08dda84947a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IzYyicDWBfuputJamMikdL1a9WTQuIfvyGC3uvKmkbIQjB/WkvTDdsJzrOl0?=
 =?us-ascii?Q?/76Li2HjjmqTCDZfbjDIPThEMnbVIVMeR5ocTb1xF5pUHT7o3K0mvxMs7nbQ?=
 =?us-ascii?Q?DUtItmAgdipbIg3b6H5j0PwsQ+CHMq4r/HerND6Wb0T9S0/qHHmJl2TOTybY?=
 =?us-ascii?Q?HwsOab1KQatGg80/nyf39fuM3X7BqxcclMfSkdzxi4gM4KtKWNYVp1uT3dtX?=
 =?us-ascii?Q?DSuep49lDAq7go5H/+KCwWcO0/gO+Fi1iBZmQ4pOckNtXViNhyMDrBbyUo8U?=
 =?us-ascii?Q?btWU5Wz1j5xKcX0Y0twNqTs3T26oeDSXS7cs55sMXThboGwgvWekbXMkbFMr?=
 =?us-ascii?Q?pmFyMXAlC2zzIdWDC2sQwhPiazWL7PfITD4XnLaxO5NYzlE2E1tYOIiWU4vH?=
 =?us-ascii?Q?FENYzj8fcfRr5NCPYK4R8OOxEbE3/hbxczURNlK/wiDEip93B4FGfiVUyaUf?=
 =?us-ascii?Q?8QH+3d5u+eCGyY2v5f1OPJ23X2l1qUvtP1KV+zfeZpHhKWTEmOiS/Mv68C0x?=
 =?us-ascii?Q?A8fmA4HWC7of2YuG1Yv4edv8FDxoZGH/OUvg0IqbEasUAKFiW6CcFa5lsJ4G?=
 =?us-ascii?Q?vbYcmE0TZVYNqeC5w+bYjlUKW5W52rgE3bU0RZFlo1aP190p3Dky4e9NWN9E?=
 =?us-ascii?Q?Yh8YvCACNLMNNEhyexZ/tlGMCMve0lND0JPGEsdDnY6peFrKxaHZ8sCOUSo/?=
 =?us-ascii?Q?csSSMC6KnJ/O4UIu+IUm2kS3XSBRimPLElTUZ8PKS4OK4YkxsiVf/dU74W7f?=
 =?us-ascii?Q?uwYt5CDW9bJ+mlHgqsOHDCGuKxtCVbYqUIZvkAtltJuOPcXSZdiFCDhJnd+d?=
 =?us-ascii?Q?D+MxhgHhPZpiG9mQOoeOa+7T4O586Wsu1k8AMFXROzAuc27z/ZJKf1qu2cV9?=
 =?us-ascii?Q?Dqzz7ohK0RPVOaRiSyZosz43Fb9s6Nrs1VmxfKSORyWGph+isTmbSSJpTFh0?=
 =?us-ascii?Q?CL3VCL9MkJ1mM0JjQmM92fW22IzEWjV/3M8YSZDoi9W5bz3THT49iHcDgqCk?=
 =?us-ascii?Q?NCL+KlGrYSIPB5hd8XtfYYOePcnlyt0+mZEWoW9C43aiY0EB8RRKB8VRhPSr?=
 =?us-ascii?Q?/e28G+/90bA8MXtKPTAAZUlwI4za5D30ZZHDTEdH4EHSxA5RF/okHxl2uFeJ?=
 =?us-ascii?Q?6n0rH9oOkQnDNDSY/vA0g4WHUnfFnuytXNtRiLV1aqaxPymothP61rkhwJw1?=
 =?us-ascii?Q?/UOFYkoYb6Ecul1fmWywfPfvftjDVfBAx3Q+MxN2OsbcEuNVDOEKxkD3NJ9x?=
 =?us-ascii?Q?wLTh5jWC2rGpMH+5Ll09aLDjOwLgdUU3DSlVPtBRZg+wjSLqD7qWwHYxc5CF?=
 =?us-ascii?Q?1fZgHatIZ2kosVM3DsvdGKz8oPM8tM8FTS0gimPUfYhw7A5R5TTMQ0qywIhL?=
 =?us-ascii?Q?0Do6ojRfGQo/OR9aEV6Iv/rUV5ntqs2r4V5w32hO9GJO8dxmFWhGHZMyyNlF?=
 =?us-ascii?Q?zIcRBX7W0Bk/IaHad2Jl0G0UKpdcvLFnuQ4YNTh6O4SOZx4GSePfp5AsvXMK?=
 =?us-ascii?Q?KO4I4MMf2eV57LrhNghliBcNQFggGvuVZG4n?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:04:44.4246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b68056-b492-44a0-20ab-08dda84947a7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7861

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
Changes since v6:

 - No change.

 arch/x86/coco/sev/core.c            | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c |  7 +++++--
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 97cf9a8ebd5d..abe7b329869a 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1072,6 +1072,32 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
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
index f08a025c4232..bf42cc136c49 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -521,6 +521,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
@@ -596,6 +597,7 @@ static inline void __init snp_secure_tsc_prepare(void) { }
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
index 2a95e549ff68..e5bf717db1bc 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -64,6 +64,7 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
 	case APIC_TASKPRI:
@@ -184,10 +185,12 @@ static void savic_write(u32 reg, u32 data)
 
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


