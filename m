Return-Path: <kvm+bounces-56094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B5FEB39B14
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 779FE1B275C5
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C65130DEA1;
	Thu, 28 Aug 2025 11:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TKJ90n15"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB113081DC;
	Thu, 28 Aug 2025 11:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379389; cv=fail; b=sAsvZGprtUyDAp8zM1PCf6AF9XcSt/6xMUny1VZW/ULoLkX78a9UTpwOTBM1bdRN/eu2zC2hqC6c3SzJd1wta6QpPC337DOkucma373QlcANS0YeFTl5OD9v+6YfCIgFqNFJx9va0pc05DyQnNZucyrABXdgy6QTvQLM+80WsVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379389; c=relaxed/simple;
	bh=oJfcKitk//1Xj1u6HR69d490BwEAG3GVdaN8gCcnoT8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CM7EOCoLvLVUe/Q9YkBD4L4GURkNgUoX/jeQJXregJvSDz1Xq04l272TYtXRbuQJajXk2KzRF7swPKjPcKYa3KTKGNQOq3jwWBrb1HL6m/z9lz2N+Ya/rpn+84T+hGNnkdBIHsheRrnFPxktez6PZPvPw5MrnJtMhRLEoFOJLug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TKJ90n15; arc=fail smtp.client-ip=40.107.236.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h5UqZjBviIECIGCBIYiY5IIdjmrRhMMIQyJzFRHMipbvbwP5rW22O0CuC9s3uYpVyKM3nh++wyrtYl15JoL08fxJ7iXoJ6I8FgFHiQt0RdWGtFQ3YoN9RkK4NvEbtwkR1FRNQQa8821eTLbao2n8eMQSlsWhUSgw49p0OebGzZEAF6weNyzcuICnNP0jtqS/PNDAxD8N4tDL2mFC5WK6CjPB50dVdu26x/wG9kfL448sOoZJZH3uBy44kLELoKKy05SnO7UPIHQJ2DS4VF0uJp++DK66/3fBsTFVT+oPRXSpr36u7rz5CRjQZFLSvhJneYpA7MJaFx0smbxrArDDEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYklYlUPRAqd1GnhX+wenKZCEtfTKANoahB91paHJmU=;
 b=BK+/Ow1WtMsdNROYyERhQvSBihWN4hfA+u5aOe+oipjSzLq0iJG9zujzeqmRuQ/qhp6vs6ylCL21lD82h88ldM+WU1KiMlv4BxmjV6wtuHMzcV27zZ0MSpNqiUeg6mo1XXjsMk6vgF7jm55v7y0/Z2eVYrYSWhpvPX64kcd+OdaViklD195qA2STgGhwCwviIm2IavXkmhq7lFq+rF4yyo8w7u5BNKgRyzoiNhxZnFjuyh9Z+rd7c/ZrVdCp6+Y3GSd6RosSUo7uNM+ivrFw17NEDxGj2reNwW9BMgP5ep58fclQDjhWJ8k2U+qgf/05WypLS4WMh/L+Cp22/HY/Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYklYlUPRAqd1GnhX+wenKZCEtfTKANoahB91paHJmU=;
 b=TKJ90n155hEzB1SgL+vlfmSc94khjYNsFxy03jQQtIddVBNrYCBXdrIOjHG7CDHp+BZydYKqpCgOWFDpRHTmFJReGTWH51hQgsltzo+7eMpixKpq0uYfC+KUHnMC32aDnebjUof+6Wv/2rj7nPMqhRSxxEx+cz6DusuAQmhCTHA=
Received: from BYAPR01CA0040.prod.exchangelabs.com (2603:10b6:a03:94::17) by
 CY8PR12MB7219.namprd12.prod.outlook.com (2603:10b6:930:59::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.17; Thu, 28 Aug 2025 11:09:41 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:a03:94:cafe::b0) by BYAPR01CA0040.outlook.office365.com
 (2603:10b6:a03:94::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 11:09:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 11:09:41 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:09:41 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:09:34 -0700
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
Subject: [PATCH v10 08/18] x86/apic: Support LAPIC timer for Secure AVIC
Date: Thu, 28 Aug 2025 16:39:26 +0530
Message-ID: <20250828110926.208866-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|CY8PR12MB7219:EE_
X-MS-Office365-Filtering-Correlation-Id: 76cc3341-53b5-4e65-685f-08dde6236313
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y6ajVbnuEOhZqsthqyMaMyenXqJsC3j8xeIWhkWRkGasclZWdo4PwbIOuPEs?=
 =?us-ascii?Q?avjEZsXMwapx0U06OGC8NJuhGX6aR1fUrpAA0KFBEah1MoPe8ac5ESSgrowS?=
 =?us-ascii?Q?kao8V9lESijCcFQ+knzq0flXrbZHldvaGKw6vHD08a7hBp9QRSLCj0oym5bH?=
 =?us-ascii?Q?GaJhpIJSbFZSn3pz/kSyhjIT3W2e/6CVpDzMW1WPjU/9jmQIuB8H0MVuUdMs?=
 =?us-ascii?Q?hEcq9ugaAiCE8cG4gur+zIxongP5IIgwCSyllpfF/zM+4ggGTbg4l2oAbCdX?=
 =?us-ascii?Q?fjP79Rm76tKU26EYdL9i2BWw0uKLG481yhCqlEFgeqOLVPa7g+I4yPqLFKCC?=
 =?us-ascii?Q?xVHz9AvpQi91ykYuKc+k21uxUIoDGQNlXkZYCzR+dCMwMZFrfEfP/kRMsFRy?=
 =?us-ascii?Q?3T6Xs/bRACg68lAGEROMbby/VxG8Z9jT/1Xbq1pZLDgdrtg8dBFk4TqZQdlv?=
 =?us-ascii?Q?CAT5OyTBwpjhwyAx+uahGTGk6r2XDXPCp7/qKcW3LOnF3ur5cS2Au3Tp8Lyb?=
 =?us-ascii?Q?+z/3M7szWixhot0xZkozrS7dbG1D8lxZymhURr1NcDOun31vHxJ873z/ZgDi?=
 =?us-ascii?Q?stCukw/mQ1NF4F1oeUe9UAIjbEa70FIr/SX61Ojld5Iao4FpOBO5p7EBKb3W?=
 =?us-ascii?Q?RSAppB56FpkGL569ncrNt+BDIQe1SvqjuhbW85KSBqz5nLvGdOwqIjqzvcey?=
 =?us-ascii?Q?jNh8RZNWufOnZxSXh/S6Gaf1hOWvec264WjceEZPcLMXdRmuxloHBx83587k?=
 =?us-ascii?Q?PrK17+PURNIpZ+Ecrv6N1ejZBj6s7kGFVciIbge9PzBr2c7PXJ8R4VA++him?=
 =?us-ascii?Q?5Fro0klDInjmh/BXkVIHrwpavrqcgchOk3VtX1Lfo2O4HesZV+2KkGPO8JXw?=
 =?us-ascii?Q?Xkw6ta/K9UFP93Ga+VY30RuVD+mT9XnRn5apNm7yquALzJeFXzeFeQ5QpxaD?=
 =?us-ascii?Q?o2n3PB16s+Pid6vd//rw/l2fpbeT6VO2bdatfeiDtBiSoy5uqUVqOnsxoiC7?=
 =?us-ascii?Q?G3CoZU4wPrP1tsjrCneJoF48ulMbSdilw3fTiwNf6CXuKteHB+cqo41ud46s?=
 =?us-ascii?Q?lx7yc5+k1WAxAM+LOGsnyHg8AgZ/6516kPMQcMIdsBTQC6GWwm+XkH5HmKsV?=
 =?us-ascii?Q?AnQlUs8p4CbWsCsLqoz0vhthUXzSVgwKOj/fTHU8F1kHdcR1HrDBRhjfb+dc?=
 =?us-ascii?Q?RSd8H3Un1lUDTlPmzYKqiW6mPmD23BhFnOEp74PShXjjrnEHLkfmHzyKPr6E?=
 =?us-ascii?Q?ZNNMJvKXp8MpcryGs2x4O+9jMuRzEQRLXoTppFoLSQJl1hVmq47P2OvfC/ex?=
 =?us-ascii?Q?UI48dJ50zbZ5pAtM9K3pSnxqlXUgdqmoZ9IwusNzZ5MLju9O+OxGYo4xedBJ?=
 =?us-ascii?Q?tVTDELOCAdBSNrk4q2tei4afWGze1NJ/cceTjbV1DAmUiK4S5DvnIzB+bPve?=
 =?us-ascii?Q?9ssowIE0VD6tzTQwHkzhSlvcGzZzkuDjm1DKw2mr9wJKGBaoZ+1mLWA24VWT?=
 =?us-ascii?Q?g8qNaslUVATvPJ5pJuhjxq+rTux1/JmtyQcl?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:09:41.6060
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76cc3341-53b5-4e65-685f-08dde6236313
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7219

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
Changes since v9:
 - No change.

 arch/x86/coco/sev/core.c            | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c |  7 +++++--
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index bb33fc2265db..da9fa9d7254b 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1108,6 +1108,32 @@ int __init sev_es_efi_map_ghcbs_cas(pgd_t *pgd)
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
+		pr_err("Secure AVIC MSR (0x%llx) read returned error (%d)\n", msr, res);
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
index fa2864eb3e20..875c7669ba95 100644
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
index 47dfbf0c5ec5..bdefe4cd4e29 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -67,6 +67,7 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
 	case APIC_TASKPRI:
@@ -194,10 +195,12 @@ static void savic_write(u32 reg, u32 data)
 
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


