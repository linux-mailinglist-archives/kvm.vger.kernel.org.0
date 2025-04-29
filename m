Return-Path: <kvm+bounces-44705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF31AA02FE
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9697B1883AFF
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04D6274FDE;
	Tue, 29 Apr 2025 06:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bJwgEBbN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC701519AD;
	Tue, 29 Apr 2025 06:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907439; cv=fail; b=Ikn9Oh+3zzaKjtNszNl2kF2tDITBxsj45qhq1eJTOTuQg9aBxkdSpmjFAtUcUNUnDlrGd9xW/WfAos1BkqQomcsCefGP7INg+wvjPYauzo0SSVnZzxuaYDBJGIskpXjuSIC68P+hp7DVIOa+bOEszZ6RTtOlzOTrtj94zdfGjkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907439; c=relaxed/simple;
	bh=2l7CMopLgKI0nitDW1Q/anoB0rzBZKURpHTMJMrmjgQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bCR6Gi6RYfm9vDSDCP/gToFYonPDsXV8fNcSA/Ag6QbwjmxjpGg8QF6FBk/gocRHmW7iCaRbemdHngDtPaKrCTxH9kNg0PXD3VCFJ7FmJjzOytVcvsAWSGCInawO0LujysbwVqGkcU6tqL4dRp/+aDWDzswXARvrzYbQZkS+KUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bJwgEBbN; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gDDThC16c9TPcMj10pR49lSX+tti+VZwCxydm1+GuX2B8UxPyKTae4ERp6ekzZ9OY+TP3q04TixKilWAFoINjfJMi9bhg2b7ggDNsEj/bN2zZMXNrlrcA5DsT2J+Y3dR492BjkbVefKGNkYACLHgqQrg/82dWPBo8VF298VmBewXEylqh5+fzSuFijl8lx2vIVrh7zpK20Sh4NZoKOVMfBqHjyGcq9TcFaBbgsfzE86fAmkQFEDt/4ZdaYlDcIIXUYJG3AJqqzF3Ws4dMFV43uQy/xVd/KPs8e5JfKtjwyWrmUniUbb2mUv3OrgKE6Kd7Gyzzo2p7cs6h4rATBjlbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJQINksgkJl56rTeU7migrcohrtOv+ByBHKWAh/Tl0w=;
 b=rhtSJ3KX466UW+FlICgyqdjfAs30tWZ6kWB4iaWu2Il+pbqV/Sl9xvGUeTb9qbS42m0LG2MrBr3haInD/SLG4HPS7JdQocPm63wmm2za6hXJKyCE/U+FHHxYTkXIZ0lmwx6Tfv6ZjKRLKkuod7Faeykm0e3ej8FCfqCXclVcG1JzQ/djGbTybkXZfzl/M2cy3p38EOmu921j0T+Vr/xA9V2UjoUMyOWYAu/j9dmE805NNB+wjhxXhmOrdsLu17o5yCx6MsHhu3X7ThEx5Tz/qfgzk1WDycCVFGyY3vFi00rR1ZKcFSdTxaLKJ16mZlyHgan6QdUT8aK2rzp/5hrTjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJQINksgkJl56rTeU7migrcohrtOv+ByBHKWAh/Tl0w=;
 b=bJwgEBbNRWrEl3GPdjr0+R9UaEIoGMo6DapYZPOTsL1Jrqs+E4Q7/OX5KZ3l6LmK+ydhuWWmBoRZ1biP+ER5KcyaE6NRdzRPCy4Q5+6tm9KpTf46W3/h4AaCy5m0sD0OL9Crlj9k9sJtjR9jazW7n6+DdBnESe73c3PHdQSSgTk=
Received: from DS0PR17CA0014.namprd17.prod.outlook.com (2603:10b6:8:191::10)
 by MN0PR12MB5977.namprd12.prod.outlook.com (2603:10b6:208:37c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 06:17:12 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:8:191:cafe::15) by DS0PR17CA0014.outlook.office365.com
 (2603:10b6:8:191::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.37 via Frontend Transport; Tue,
 29 Apr 2025 06:17:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:17:12 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:17:04 -0500
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
Subject: [PATCH v5 17/20] x86/apic: Add kexec support for Secure AVIC
Date: Tue, 29 Apr 2025 11:40:01 +0530
Message-ID: <20250429061004.205839-18-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|MN0PR12MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a7b1c1b-5211-4c9e-b896-08dd86e57add
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iWfXW7FYjlDuF7mF12k+cRm6t1d+bOpynE+bTK0lGppLDs+2B/rAAxtSKl4s?=
 =?us-ascii?Q?TzEPJ/tvnhqksX+KYO9Wch3Af2h0dRC/l+ZYnrw2N0A8xzPebC3OL7Ki6Kmm?=
 =?us-ascii?Q?194VPcOJFJ5W9o8PaIzXOCm9sGj/sdsaV7LF8m0jvABNH0yCh2HVVn4PX6NW?=
 =?us-ascii?Q?BSVi3FvbxG9ujT7XsWJAvNBSKv/w5EOq6lTBOB25MBc3b7d8EBFZRNYY/Nrb?=
 =?us-ascii?Q?0WR+uY8IL+3oB9jHlyhZlZ61rFDM/07tdXm+zBB7Umf0CzaEWoD5D77/ezOM?=
 =?us-ascii?Q?DyeJWW5nAmrIRNm95n4FNh4gOMuSeqOfY5uF1FrQ0TleqLQZ6nQrJCX5A/p6?=
 =?us-ascii?Q?YQQmIa8d9QRtHt36xT95URmb74m6HUZqs9E3hMoE5zTm4t5DtJPd3BmIMtSk?=
 =?us-ascii?Q?do7Dp9/sFQ4ZoxUyhoz4HHsrV5oObWV65BxJKUW9/pfzTQaY2j369C4IWiNk?=
 =?us-ascii?Q?eqD3GZSnaUk5UU400m3FBaFKuZ5JQhWyZif0H95LcyhYeCShoJ2Z62RK0hJZ?=
 =?us-ascii?Q?wNkl48oTTjip4tFJJKw+HoYZCGGOZMnsP7ymoFtdZ/NlThmuSkmHIFvt8XdV?=
 =?us-ascii?Q?w11C5sngxxMT/FO2U3agXOnAU+hzaAyqnZlQgpijD9OavUjB8r5v368jZ3Ge?=
 =?us-ascii?Q?UiA/pv6gMcKvMBUgeLJS2m0MvP56kOvTeA3U466r+Huuppm903VGdKW4kfjL?=
 =?us-ascii?Q?SF6uwP9vTjas3jQJaia3EPaBuNTlgnm/Y/Zf1UFJT4aRZaIv8nm+Ux+HYFBa?=
 =?us-ascii?Q?JW/FmAhDXXeuTDIqSWIC7sm/696UzrLmuomIcsnPMhij4zIY2TwMjbPHeIzM?=
 =?us-ascii?Q?fmwildJJxL//YGG35D/F8QLnkLh8Yp+JH1G2geHd8R3baH51gmslFb3sfmGp?=
 =?us-ascii?Q?KkXb72a1BFPTqpxayU7/e5/KVKOieBsJ/qDN0IKs9/QH948IpAQLvK8aPha6?=
 =?us-ascii?Q?sbt40w0rrFOprlZx69rHVX+GUlP2fXRgLim8t2T6Xod73xCv8O5UguJL+OUR?=
 =?us-ascii?Q?AfirsB+YERgYHuNTm64BFgXLU/zNBvnBTovihWSlUjsm7CQ2Z7qPPaWoCR80?=
 =?us-ascii?Q?w+KvPr99Pp3ZLOWKPbtPOsr/wuqCIaW+k2Uj0OnArwO6sQ8J6N0aDjzMYg/l?=
 =?us-ascii?Q?sHSMODYwNZvYL5ZE8BQwD50MmM2Men9yWCFdvpnV7w/DcNoGCSgXk8Qy9lbr?=
 =?us-ascii?Q?QHhBN3g5rk/uw/41uMikNJVS+4EkD06xk/TJmOe2w45o8TU/POjqWDKO+y5o?=
 =?us-ascii?Q?DHaamViw975CKyy6fS1RrAQgV7CZZd5PmLKHPd+ge3fzmc+JGHm4fMuLKZy6?=
 =?us-ascii?Q?RB8PS2RSFkpYyedilg3+WxysQe7DimJ7144zEIjU5hr9LlONBjbNHs5XdFye?=
 =?us-ascii?Q?t5AAxV0EvYVLx4y8siAK/kgKap/j9vVLGeQQkCJ0oHVRV/JdjnKADDPt2/no?=
 =?us-ascii?Q?HXE1FklMp1mW1GvUQw10ao6tDd8v4JJKLWNl7WTQZtQEfSOvtdSh828OSrT9?=
 =?us-ascii?Q?Q5PrZRngfg2r8Z0PA18BCziaOo3FwFIHrIII?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:17:12.2701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7b1c1b-5211-4c9e-b896-08dd86e57add
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5977

Add a apic->teardown() callback to disable Secure AVIC before
rebooting into the new kernel. This ensures that the new
kernel does not access the old APIC backing page which was
allocated by the previous kernel. Such accesses can happen
if there are any APIC accesses done during guest boot before
Secure AVIC driver probe is done by the new kernel (as Secure
AVIC would have remained enabled in the Secure AVIC control
msr).

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - No change.

 arch/x86/coco/sev/core.c            | 23 +++++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c |  8 ++++++++
 5 files changed, 37 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 4cc8c4361b97..2dccfe411b14 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1083,6 +1083,29 @@ enum es_result savic_register_gpa(u64 gpa)
 	return res;
 }
 
+enum es_result savic_unregister_gpa(u64 *gpa)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	ghcb_set_rax(ghcb, SVM_VMGEXIT_SAVIC_SELF_GPA);
+	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SAVIC,
+				  SVM_VMGEXIT_SAVIC_UNREGISTER_GPA, 0);
+	if (gpa && res == ES_OK)
+		*gpa = ghcb->save.rbx;
+
+	__sev_put_ghcb(&state);
+
+	return res;
+}
+
 static void snp_register_per_cpu_ghcb(void)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c359cce60b22..37317d914c05 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,6 +306,7 @@ struct apic {
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
 	void	(*setup)(void);
+	void	(*teardown)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index fab71d311135..feeff8418bb7 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -521,6 +521,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+enum es_result savic_unregister_gpa(u64 *gpa);
 u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
@@ -574,6 +575,7 @@ static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline enum es_result savic_unregister_gpa(u64 *gpa) { return ES_UNSUPPORTED; }
 static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
 static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 88e4bddff5ba..e33a25ebd694 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1169,6 +1169,9 @@ void disable_local_APIC(void)
 	if (!apic_accessible())
 		return;
 
+	if (apic->teardown)
+		apic->teardown();
+
 	apic_soft_disable();
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index c517abdae314..7ba296ba26e3 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -333,6 +333,13 @@ static void init_apic_page(void)
 	set_reg(APIC_ID, apic_id);
 }
 
+static void savic_teardown(void)
+{
+	/* Disable Secure AVIC */
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, 0, 0);
+	savic_unregister_gpa(NULL);
+}
+
 static void savic_setup(void)
 {
 	void *backing_page;
@@ -419,6 +426,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
 	.setup				= savic_setup,
+	.teardown			= savic_teardown,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


