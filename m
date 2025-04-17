Return-Path: <kvm+bounces-43553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8243AA917B6
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:23:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E760C1895D3F
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC6A228CB5;
	Thu, 17 Apr 2025 09:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="W75zYKie"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F3722157E;
	Thu, 17 Apr 2025 09:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881820; cv=fail; b=AxNapLtXVQxJrJ9i8G3oMv0gsuYFiBVOOcHF/CJ+dVCy1g2nAvceeFgMllB16wUyRpjRdjMQr7nk+h5+dKwxuSGno+Zm/QyQiENF8QV81FZiCgNruPqdhYUm4kNOCgH0z6+b3GePu7WwP5k8qDaYsHREZiElu1VDtsiryNlyC3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881820; c=relaxed/simple;
	bh=CKLrXGY7++cHpO76C0dZiH37suKGi4TDM+yGiL0lMZY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UCV35kbLEI81G0vDG3ETh7wMgPQRl7IHZtucLDl88N4+yb6loK/99j49amxcCGzDj0utYjt1rQ2oyr2zaRY2GipLEjKF7BKq0tt3WHUVlmsGmGt/Yet3B3QCc6RWm3TKk3s0KGyu7XYWjBq1XkoT+mwSZiAv/k3uOtti+x6LwCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=W75zYKie; arc=fail smtp.client-ip=40.107.220.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u615+UOOM+eh+X77wxSzTps3WDpYFf2yZ1WyNANIbKhMmnXiMX35e9zxw/upOhIyzhDPgdmUaNB603u+gDLJMPdwMITcII/3w1e9FB6CKDqzuVJrTtu25/WBqnBs/8EFZ7TQ+9FslGzSNvCJgsgNp+Nt+4JXR5RT+BuNJEefqHEr4AaGKDI30ngjIXrwbXKgrx3UTZpIcb76YiHYsz9Hw0+NC33tTVzWWG1JbAD/iQyQamlavrjo3BYqwF+DFjvk3zne3ixZD4GcTKWsi6Pn+ClaAOrflg7mQ9snH3I1+FjnzaGQOyeJwOOroAso6p32SOC6iye3JNZUSw4S866fZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lUv1SmKy5i/8r8vZVOWpDmjPcAHjAA25R4HpO+iBVa0=;
 b=AJgTLs9mVrT1f1UrNWltSMp/GUaVA3uPlRi2MKx5sS19IHN7fOg+NzRsXLaFz6JkZwQVZERzldeWwAeFNBoPn9duDTNj6Y9h68YZSmDHLhF0EFW+3r74l4e1tGcaSnmX4lMZtn2AHviCXxUr3X4b00cN5h20CI7LVli6zK3m6VltmTRM4I3McRSxqFx1+my5wOvnMrq/c2dyQQVmveFNGlxgeXPgf+D+nVjPTQ0dX22T9+eRPkrv6fv7iCy3Dz8Oin7XcP24wzOqFWFkZS1aOYQBgT+kG/kIMlCKjgkOKzgl+9jq4D15XoRoX3uEhSQtI/zycYNYB+k3bbJDBEH0nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUv1SmKy5i/8r8vZVOWpDmjPcAHjAA25R4HpO+iBVa0=;
 b=W75zYKieDHcwyz0dzVIWFCvT/pT37VO4Md5BoF/Nn6erWvcC69+m+Avjx+4JQmUb305MDH6pBNGDuyJlv4VLyYrwydQM2gngkEUstYLB9Lv5iyaMpi0hXb4n9zYy9z9VuxarifWLf1L2whXgiupY0GVMvbZJaGhTiezWKXTA/6o=
Received: from BL0PR02CA0062.namprd02.prod.outlook.com (2603:10b6:207:3d::39)
 by DM4PR12MB6591.namprd12.prod.outlook.com (2603:10b6:8:8e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Thu, 17 Apr
 2025 09:23:33 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:207:3d:cafe::8f) by BL0PR02CA0062.outlook.office365.com
 (2603:10b6:207:3d::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.35 via Frontend Transport; Thu,
 17 Apr 2025 09:23:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 17 Apr 2025 09:23:33 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:23:24 -0500
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
Subject: [PATCH v4 15/18] x86/apic: Add kexec support for Secure AVIC
Date: Thu, 17 Apr 2025 14:47:05 +0530
Message-ID: <20250417091708.215826-16-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|DM4PR12MB6591:EE_
X-MS-Office365-Filtering-Correlation-Id: d85fb08b-4e3e-4838-a9fc-08dd7d918660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sHhD7t+fhr6R1Agx0DzeFZJuoiTKYxxioQks+PORWNau4G8y3bOyNHBHWXWP?=
 =?us-ascii?Q?G9ZsfwFyG3WIduIOioHvKaQI8J6YWMbCI0dSXIl5FMRmBU4IcfS02VCOgoWt?=
 =?us-ascii?Q?S93xMa0Y+cAIKRGl+XYK2SoIjlzI6Ff4lDWT6tdZ8ZA4Ymdl61wcFcysisI+?=
 =?us-ascii?Q?m2b58TslIPHdlHcqHZGL6zOKY8Yq3RsM8eQbSYEzK8n5D1mXJKsLpbACyhgN?=
 =?us-ascii?Q?+7uqUyhcWbTKwWz7eAiCN/xXhfzSzN/87PBtYDHEYtx3U/14hz2KfrMJeW2D?=
 =?us-ascii?Q?wt25CPH6ZcnzITTHYmKPl2pfM2EbXQiwpK5PpKcMVeNHgP9sEelKORSJ9shU?=
 =?us-ascii?Q?LMPVaWJMrv3+n9zLe2y1yv81qnaJ4fFQybXgcWuqUh5nYwqu8NR6rIZSYOH3?=
 =?us-ascii?Q?OYXkCmGf2ZzBFn4fm7/Y2GOXpsJZVAeGik2HXQcfskdjl6IxBJwXwXVZ6/4N?=
 =?us-ascii?Q?mTzh6NBxxZVitxOiBJEzDTIu7SIMxrDNwAYQgkKZLlandZq+CZi3DwlDbvdn?=
 =?us-ascii?Q?xc0/Cg0V71P8GId8w1y00JGhaeh4n5g7sbBBiSXNlDYX60ehJ+asgOwc5UGh?=
 =?us-ascii?Q?NGRNg9+U43m3beeQV4TQ9VK0WYxeEQ6rOBryRxdYGEu0xxeSmaThV9kKaqqy?=
 =?us-ascii?Q?jrLigIhcOcve/MDRz7Ux5GvNxGLtHuTSZOm2Bl9TBtBCq8mxjKDJzVEzF87w?=
 =?us-ascii?Q?n6p556Sh+eHm0pi4poqEzYUBqurY/fRHRoMlvNZ91L5Fpavs/Mt4miXmXV64?=
 =?us-ascii?Q?wXSEv4WSc2Vqk8maw3WyHB/VFaGEV59jjl34YbS94XNQLnrLQhRR1Gd9n9as?=
 =?us-ascii?Q?ut2/xbWcWTT/yedynjYuZyVvoBaHQf2y1S3YGaD4+qLqA7pC1D9EcyRC/eue?=
 =?us-ascii?Q?sKr5Y5FpQtRba7/bOYibRcIfFwAvAInUvw9JbFL+9SgJgAx3VVVg4JgjYtxa?=
 =?us-ascii?Q?Qb3vVB6Ud+pDpqp8LMtTJ4NHZwaFLVdcgGChn7RW2veO+m9PUZFZSVx7wIQ4?=
 =?us-ascii?Q?zYBRqeLQNLmNdJw5jyzibAIeY+/2BBevFsBp0uJTDIV8jCi2CU3dQZgqOLDF?=
 =?us-ascii?Q?CCS9Ql4mWIHuz61BQrYJf1T1K2p7ca+vCKl4D9W/BE5KzMrVJRjkC63+EShC?=
 =?us-ascii?Q?prGbcgf4hpLnd1Hpk1WSraC1yvBgQPOYPfz3EL5DFsK6cCdQt15w6u9Jr1Wn?=
 =?us-ascii?Q?+QGvOIqDsniLC1JUcDoxKLkJYhm49FaoEOWnqsMsbQL9/0wgcZc9BTu47Nw4?=
 =?us-ascii?Q?jMAn86VpqdTiQHFR0rQ8hj2bAo+exTrODoUQ776WkeFCr3z8X7YiMQhmudo4?=
 =?us-ascii?Q?hswGyHuoLsIp02xwxJE74Xb/dyItk8pRq/mV2UNIO8yNDngWNi2Kl+XYCVml?=
 =?us-ascii?Q?ogF1jNMvGUmnk/N5T4HI1bpc3NkX/JFiv64vQNy4M90BcEfGUQdjRYqEh9d2?=
 =?us-ascii?Q?y3Mvos2JbkgfDMqDmNQ5D+MDyoniu6w9oFgX90BsR/yNshnhHdG16+ZVajoX?=
 =?us-ascii?Q?xeD6voDAQ/6cX1JhkOECx0iqzmL0SME5n66l?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:23:33.4254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d85fb08b-4e3e-4838-a9fc-08dd7d918660
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6591

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
Changes since v3:

 - Use SVM_VMGEXIT_SAVIC_SELF_GPA in place of -1ULL in
   savic_unregister_gpa().
 - Use guard(irqsave)() in savic_unregister_gpa().
 - Misc cleanups.

 arch/x86/coco/sev/core.c            | 23 +++++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c |  8 ++++++++
 5 files changed, 37 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 1dcd40e80a46..49cf0f97e372 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1499,6 +1499,29 @@ enum es_result savic_register_gpa(u64 gpa)
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
index bad60bcb80e7..5a378bdf7db3 100644
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
index bfb6f2770f7e..e7dd7ec7c502 100644
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


