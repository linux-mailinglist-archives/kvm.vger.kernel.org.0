Return-Path: <kvm+bounces-42314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C5DA779CE
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:42:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C28623AE20F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E111FBEA9;
	Tue,  1 Apr 2025 11:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SN4MOQs1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2062.outbound.protection.outlook.com [40.107.100.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E701FBC87;
	Tue,  1 Apr 2025 11:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507664; cv=fail; b=LxQUdrPwYZIVRoYoy5ligDGHVrd+F54SU/5GBSlsGQ9W3AGuEe4eQBzgJQkm3BaU7CWL0WrwQug7o4B8JOLTO9datE7KLs80mHN1rV8bAc8PbU1TdC7EnOg9S3LjUs3GHZg07yFv26HDc/vDqgfMXafA6/mBJ7G1ENhKPnmt4Uc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507664; c=relaxed/simple;
	bh=J+foIHVLTfp6k7crsleO1XiGt/6+s97ST7gWKX/kIzE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OwooStf49j0cUcApzd9AEuXX3pRs5jpeuv9LO40oxYZolVId2PgHLYoUiYhLPIXuV4+dLd4JMF4j6TzTNOtu7f+GmgdOxTKFjjoQGPzCfu1S64Sf0yxdsFk7RSom8Jiq4srQkLYrpwqx4Bpxd+T2e8zFb9MhrMibG9Vslepi88E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SN4MOQs1; arc=fail smtp.client-ip=40.107.100.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XAzdPANUzI4mhj+80k8g1HXxwpuqZiTEey6bpl/omzrbvhQmWYEyYUs8N+7nHHAcTbsSqsT8HP1rrA5jiRvogFGPLyCfBwc+/LaIpwSmveIdO/Ov+HAbOOr/wRVAlU3TXiEgf7J4JsfI6N0EpKxBRM1IBviZdwCDUdt0Xf3oD5I4cVF+FVTFLuTu17RzP64IuGcvTjFTNg422MxLIuPOxcngktLDvFdY0yalPr0qECiC77DqzWAfJrKB22eON4RDWRwwefl6CoMlZYpDKHsUAtdr0vfmcEZsnuGuR2Ix+oFcdE1NSghVee2BI45wdTqXqTgo95NBCPw9aYxFsZSwCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RS4sxldrG+K+gQZwT3+DSbuX6TczT41ZqBH+CxQQoXo=;
 b=Pz9QZ2cY7odWl9rd3lYW3bt6IqoSx0q7ORvaJIFDtPXPmOdcOMQ+fDrdounVKHUBafB9hs6u5k+epud9ZByDSCq5QbwDpeEizir3oKaSw6zkPaSmVgmE5X4npF2Cm911VrkX28AGgRe5AiQjRWn3mtsZIJdZ3/iHzNSj81SJwCm10Uk+5N2f+gVDvBRHqt3wUm2rK+HxiFoq9695FrCckEUrzJALT6Aqh9kJ67auckQ2Eg4NgiM4TVGv5ggxEQFs9Dek+Ly5B0bdiEgOcBhQxF/3LEG320wPvTdSfICzsDhNXEN4yKkDHJMcHwQNO6lkhwjMcABBjcZyN7AXgx++Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RS4sxldrG+K+gQZwT3+DSbuX6TczT41ZqBH+CxQQoXo=;
 b=SN4MOQs1sT1vK2+LJ5g3XQbVUOI77LriS7GBzw8zIPAUkLr1J5IzR08FYRK86F7vz91Ac6BGuiA/PyuZThuAhxBEu4LE5dtyIWUWXAthuorUXtOjupiwqhiMHAxl6qvVY/fH1mRKOmiWyMR8xXBtfeolBs9ZhS1tHn3GWqQQt84=
Received: from PH8PR07CA0022.namprd07.prod.outlook.com (2603:10b6:510:2cd::21)
 by CY5PR12MB6299.namprd12.prod.outlook.com (2603:10b6:930:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.47; Tue, 1 Apr
 2025 11:40:57 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:510:2cd:cafe::94) by PH8PR07CA0022.outlook.office365.com
 (2603:10b6:510:2cd::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.54 via Frontend Transport; Tue,
 1 Apr 2025 11:40:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:40:57 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:40:51 -0500
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
Subject: [PATCH v3 14/17] x86/apic: Add kexec support for Secure AVIC
Date: Tue, 1 Apr 2025 17:06:13 +0530
Message-ID: <20250401113616.204203-15-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|CY5PR12MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: 63f9005a-6e92-463c-1166-08dd71121186
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1AZMmMNNW8u7OWwH+okKRisIQ90c4wKxGWOeNnR8c/J/GqlU98TJ3OsPl+uH?=
 =?us-ascii?Q?/ns2tJJ5o8sk7cYqsEQN+CUuMydKJShrIJWNrNmEhXeXRP7GE5jnDUBG1mrI?=
 =?us-ascii?Q?cLI3Rw8coP8eOdNCCrM1oYvs0PbzC2j7E3JVcPcCdBHF/UySo5Y7Pt5bYvrd?=
 =?us-ascii?Q?PU2DKxe58Oghfur/zxBffKeV5YrSEgxwz6HGGlDHdayQnC0IKVlOQWNsxev+?=
 =?us-ascii?Q?dfiCCbYUJ3U877ZM6kbxRuV9idwOQUBeG6LmeoXsYljKVHfs7LpYd8cKdINo?=
 =?us-ascii?Q?Stvh3o1JlngWjV0SxwbBUss+Oo3Rpg0YJveg0n9oH9mhhfvoEvKPLl61YlN3?=
 =?us-ascii?Q?6KKDuAPOSC5BklsxA/xd44CRdyP4zvT9qpb4mJuUrYWuLfKbtIRlizVMUPB0?=
 =?us-ascii?Q?8SLXVf4zpmYi3X7nluvTaRbkApfESaOXgGZK5Euj25WulRyD3Fhgm9NpiqOJ?=
 =?us-ascii?Q?zkUDKPI9KHwzhy1NAUw0YuoUtAUapQtaJAt0ZTVSNU2gH2Eyw1FW9jqnQ2qm?=
 =?us-ascii?Q?fkY5QbPPLfBc+HT7RDz2jhOKv5tdBu/3IYDPhQz7AIWa4BfJuDA4+2IuAOaQ?=
 =?us-ascii?Q?ost+6sHNEtbu2w06EmOk9HN8Ipziz6EnCF5GZerfWuj3ZUx+SLFzqkePHUL9?=
 =?us-ascii?Q?VHH49Kd5MVJILB11BRKOTFeoi3++vO2ZDoN+cTJRSwSEeXW5ZwHajtBoZ8Ha?=
 =?us-ascii?Q?qkC1J8lGOLaUrXWz5zL7jjwEbgqjA+xrAHYrwVYbqHZj3o7h3Wev0IDZob+M?=
 =?us-ascii?Q?WKXIZuExfPfT9d9OXXjL7H4a1TCDyqOAQFfjh5U6cfZiHokyTEpv8fE30Dfv?=
 =?us-ascii?Q?6SaRzbrRMbro8bJiMXDkbSqCdLZHs+kMJCa7P7WVDFk5UfbSoAZP0pZghHGG?=
 =?us-ascii?Q?4Va81IalcYo4+I8x4ZJBg0pml8h4rjtK+zSDO+7bzoQa+vtcTf2Z8jn8eSkt?=
 =?us-ascii?Q?a8/cZjk2Ju7z4l+0PmShOCZz1nBjVsQVcYSFTMNgVvlgq3dxh/xhv/Xhoh8B?=
 =?us-ascii?Q?1YLbqig6J5h1t+p92Xd4kBpdBmBS0L5WtLmE2U1fbaCoQG1gH4ZnfRrrqEbp?=
 =?us-ascii?Q?BqCW0//K0TLOX7E5AJzU2tvy9AxRjRMCXuSS9RbNsxExFrjWSSWKTunwbmja?=
 =?us-ascii?Q?9Ce2EdII/DP4Na9cfh+y1zG4cKzA6lPGESepT1pO7UyWFfzPB6HKbcpbIuhK?=
 =?us-ascii?Q?GbZ2n8aUmaoUW+1WGw7k+tNKKG7LvUgOoSu7aVzjsSY5NC7IFOe5r281dXRS?=
 =?us-ascii?Q?DAU/qOLFiMAyDGtEnAlkrx2kFU7C+sjGsAfuBNjU3QdzCOQoKA8euEhCpCgY?=
 =?us-ascii?Q?KcYNgChx2ZYbqbjTk/bpXTBNx4mGm/+qWuCXtDwQ5ok4V7mRNpXScvYH+JAx?=
 =?us-ascii?Q?1nzVDoPBDbxjs/wmp+IUXru5I6Pz7NlWczQFjLby/TEQW1LC09O518Wx4AnY?=
 =?us-ascii?Q?obPGCgxbWtLLNkDt8IVNKhDmDju81pQazWbOjrEP4meePjVeQVTeJPmDP1dX?=
 =?us-ascii?Q?hQ4EaHO7HrNJuZw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:40:57.2349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f9005a-6e92-463c-1166-08dd71121186
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6299

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
Changes since v2:
 - Change savic_unregister_gpa() interface to allow GPA unregistration
   only for local CPU.

 arch/x86/coco/sev/core.c            | 25 +++++++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c |  8 ++++++++
 5 files changed, 39 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 9ade2b1993ad..2381859491db 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1588,6 +1588,31 @@ enum es_result savic_register_gpa(u64 gpa)
 	return res;
 }
 
+enum es_result savic_unregister_gpa(u64 *gpa)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	unsigned long flags;
+	struct ghcb *ghcb;
+	int ret = 0;
+
+	local_irq_save(flags);
+
+	ghcb = __sev_get_ghcb(&state);
+
+	vc_ghcb_invalidate(ghcb);
+
+	ghcb_set_rax(ghcb, -1ULL);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SECURE_AVIC,
+			SVM_VMGEXIT_SECURE_AVIC_UNREGISTER_GPA, 0);
+	if (gpa && ret == ES_OK)
+		*gpa = ghcb->save.rbx;
+	__sev_put_ghcb(&state);
+
+	local_irq_restore(flags);
+	return ret;
+}
+
 static void snp_register_per_cpu_ghcb(void)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 7616a622248c..0cd9315226d2 100644
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
index 7c942b9c593a..8a08a03183b4 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -484,6 +484,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+enum es_result savic_unregister_gpa(u64 *gpa);
 u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
@@ -530,6 +531,7 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline enum es_result savic_unregister_gpa(u64 *gpa) { return ES_UNSUPPORTED; }
 static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
 static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 86f9c3c7df1c..b5236c8c3032 100644
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
index 9e2a9bdb0762..8cfffdc4cf8b 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -349,6 +349,13 @@ static void init_apic_page(void)
 	set_reg(APIC_ID, apic_id);
 }
 
+static void x2apic_savic_teardown(void)
+{
+	/* Disable Secure AVIC */
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, 0, 0);
+	savic_unregister_gpa(NULL);
+}
+
 static void x2apic_savic_setup(void)
 {
 	void *backing_page;
@@ -426,6 +433,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.probe				= x2apic_savic_probe,
 	.acpi_madt_oem_check		= x2apic_savic_acpi_madt_oem_check,
 	.setup				= x2apic_savic_setup,
+	.teardown			= x2apic_savic_teardown,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


