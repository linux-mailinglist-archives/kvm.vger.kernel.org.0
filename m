Return-Path: <kvm+bounces-46451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F10DAAB6451
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 136BE189342D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D695920E002;
	Wed, 14 May 2025 07:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4MDOKPPk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2052.outbound.protection.outlook.com [40.107.212.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BF31F0E2E;
	Wed, 14 May 2025 07:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207650; cv=fail; b=c/ZTh/iVtzIatKId7FjSG7JI7G0Z6zhDuNOpk0hiOD7MJ6KeOYI10mADTjY6kAXgOdqhrkngZImdtZdnjzXjsLoIuJ/MLjFqVmAfg2eIL/xkRDO+yFHEvSbQIBjSeUsp+fiiEEq8uKHfX+P83nxXG9ySXTSYQWzbO4B8O0YUckQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207650; c=relaxed/simple;
	bh=r0LYEhETxyK7MbBWu/UH3eGNqhmmTF2yw+BCvkV0FWE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AiZTMspskWE0hBqX48ktAcsZeolKjlqaw4OllXFpBW5uFDOnzfJKJvfqSkV+REVcCAnngKb7RSSiD/KPi8loI03+VIylCwqQZQiiaxkuNh3qab9L4M/F7o0Eu/62AnqpT6vyDcoE24JSkUPFEYSTfYksF+enbWm7sQZIy4eSvH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4MDOKPPk; arc=fail smtp.client-ip=40.107.212.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mrD7bbWeQQjLDUXOvEcYqR1lpDnnIrhlEWPFFazMRP76RKYFQ1gedzudxTxl3DOOfrB0yXbtNu9OUqa721PWwQRx3WfnkW/aWqrClVEuMBUWwXXjqYj2NHUfniHCELe7lZ0LhHGNUkK3VTvFXZkfQbx9VP+b0AWV2VdrCmpiC/jsNrpY56Y3d1qmIu/mnnZH39LE+0x3X0/5PCNVRyOgJKbdkhAsZHEB0UIkBMqMxo5wr4SeXC16qfwibwNnpzHktLpLI00WHZX+fVWSQv+5h+vwFIhFZ2W9svXs7Wa4q9WkmDG6qpxUoQzAF/MNGFbPsIgmekYQ54eArhJ2O+6Lww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=no1chHjH7Zckjq3UY/cRycHOLdqPndUaBpSTuBpCZBQ=;
 b=eRlzqgqRUKGqAwifxRCY79t4o9EncV9adgAj2q6yAxc0ueQC1pzYE5sUrULlAMbqSuwazPINwRlU3obd9TUWRKKV/JAXLirboLdAq7eY9HK/XlxfFROIWEErE4zBurQL12Hmjww7CwSVx+4i/lz5l+9HTpmmqKxbbsj14zin/NbV21EdMWQChrmbfonOwmAGaSWecac/XlVlLsT7y41CIhrHxcYa4Bz+VdJ8u34Qe5wpvBBZqA9dPleCqQ0T69iFhmxAgrOsA9VDoM3aHRxlDKIPxqwGlyexaew3WKmRJj6iBXCuSVXaLYmK+aQlvOK/cQpSEjNWhswaDNO+cx2Ucg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=no1chHjH7Zckjq3UY/cRycHOLdqPndUaBpSTuBpCZBQ=;
 b=4MDOKPPk3SFgXhF9hKSlDZORtHVOCOiVgsfmIXxJWeVo/gMo/gkQqkCgRBMRA/02tqgupMamRMoxTE/z2zDf2N6/WWvqd52oyrYTvzFRzVxyjjblYZ8MZ0aJYB5luqJ6/ayf8xkucRN5sjMKyZvhPwHG4bSa6o/P6Ye/1s5QHe4=
Received: from BN0PR10CA0010.namprd10.prod.outlook.com (2603:10b6:408:143::14)
 by PH7PR12MB7161.namprd12.prod.outlook.com (2603:10b6:510:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:27:25 +0000
Received: from BN3PEPF0000B075.namprd04.prod.outlook.com
 (2603:10b6:408:143:cafe::c4) by BN0PR10CA0010.outlook.office365.com
 (2603:10b6:408:143::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.25 via Frontend Transport; Wed,
 14 May 2025 07:27:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B075.mail.protection.outlook.com (10.167.243.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:27:24 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:27:14 -0500
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
Subject: [RFC PATCH v6 22/32] x86/apic: Support LAPIC timer for Secure AVIC
Date: Wed, 14 May 2025 12:47:53 +0530
Message-ID: <20250514071803.209166-23-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B075:EE_|PH7PR12MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b4ca601-46b7-4283-c6c7-08dd92b8c5f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xDW9GYZiCHKmSfhcxd4K0li0zhy5IJlNJ4R0NIGeH7jfcK85R2RQV3rZToSe?=
 =?us-ascii?Q?iTH/prv8rmqShDFufvQKaCTOh7mfCSpxfMG4LnvpWPmMVO75MBYpLaKQJsxq?=
 =?us-ascii?Q?cHNKVtvAv5EHIXno2dUrnZBVcpE1OYlxaZ3+5NRvidCVndO73F3lD1ze6U/d?=
 =?us-ascii?Q?xrwUx2Ij0yvwsI3ClYntd2XWX0ThDah8oGgoHcy8EDVt+GhX+EtmPlA/A2Tt?=
 =?us-ascii?Q?JJi2DYONxrRZu9GrpiZZP1v4UkC+QHFMAE+/peJzV2rk97RHdKGp8XRtpDpn?=
 =?us-ascii?Q?DBPrKa64xmwoVJ6JqIgtt83AaxPDK6IR1DV6P2nfSJ1akphm5j7HD0Dz/DIi?=
 =?us-ascii?Q?Lh8scccIBKAe3NYa79RhHoVSiSVnAssfCXZaq/Gv3oeul4bKZ0pDSYoEGLm6?=
 =?us-ascii?Q?d5dqiz/6pgLBT4C1RvN4D1VfVAP3THkmY790vGVwkACKF6T9A5rA7ztdhdwl?=
 =?us-ascii?Q?YhBA8QH9f7GM3f+IpMAVeAzIJsTbP9VzxPEFz75UvnPbIhFJe0kiBryG1PHA?=
 =?us-ascii?Q?uMD2GLYgH/Ts4tXrLgkoRxAHQsbRgSSYfKeTEGAufN8n6YSkusLaPkvB9uM7?=
 =?us-ascii?Q?/Y9hGa0X2HnFzjnyG7GtGIN9vwDDXNBqSGpmgrfhUYb2Y0Q1MGFyT4CUijtp?=
 =?us-ascii?Q?6cGZwy0MkNaofZ4pQ/5ttPqBFaIR4d7jdRYV8s85wtdjVFyPbgCyQ4012rKO?=
 =?us-ascii?Q?ZO6vQ7Ju2YA8RbLTtx/Bk/eJ6/7i9gZa8PbhEJhg4x34978/2XTFaD230s3p?=
 =?us-ascii?Q?JbsQwG9Em7/rnx5ZMagh+W5eFfFVsQ1ZXAIx4ouQOvKPIssQaqwvMs7Qdugh?=
 =?us-ascii?Q?LiUO42B0rwXWBmLjzqQhpUSAXvWBjS4B0Pq/mTzSRF00/TgHL2VcvFc3ucyE?=
 =?us-ascii?Q?t5CM6WvKnAxvvkOuGmULcOPXrRO6F3u3E2v/p181IvyrH55cSH6IitMJMSyN?=
 =?us-ascii?Q?M8+8W1wmS/qHjIrcEu87jzDifJUfdu8zw81qtWbztFGDSfn4/ofLg02Whv36?=
 =?us-ascii?Q?SmF33aG4Q2zVcY6rejzueJ307MMd+bpEVO3QbMFbjXj65JAQgAigNEAKSxgV?=
 =?us-ascii?Q?awPoIzMLY4C0ehYfB6tr4yoP/XScIty1C2h/SiRydTxsnXImFoK3ReSviwwo?=
 =?us-ascii?Q?nZoi1uMcvZQ7d77FViov+E3G2FCNBnnjf+nb68z2rlZmBkuGL5B5ontA82Ir?=
 =?us-ascii?Q?JHfxP5B9HnTRqj1oq5F5pf4F2PnSpdl7vkDvTd9EN53SboT2n0hnXrC50FTH?=
 =?us-ascii?Q?2grwhluC3YxksoVDsz1v8sNVgSNR4LRBxKPUHObSeazkGPKVJ3Y5Cx56P6jV?=
 =?us-ascii?Q?KAW0J9I9+kh1vR9CjOyOyxwEcdq7XyJCAGnCNNzAHC1RxjNJmQMvgBGZoltj?=
 =?us-ascii?Q?sUszt55KeiH+Guc6g5LwM0KQ7+WNA/kGvWZ1vF6fX4g37PAfNgk9i9vzb/w6?=
 =?us-ascii?Q?bYq2RqK4Tf9GcOZKVOtJR+M2a3a0WIn/TaEU6VvfPV4ag4gLaX67Aztax6qR?=
 =?us-ascii?Q?JI41F+k1bpDFdM+R/ncHCAnxrvJFx0CUclGE?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:27:24.8838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b4ca601-46b7-4283-c6c7-08dd92b8c5f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7161

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
Changes since v5:

 - Minor refactoring.

 arch/x86/coco/sev/core.c            | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c |  7 +++++--
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e3aafa095067..ffe1f2083927 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1006,6 +1006,32 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
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


