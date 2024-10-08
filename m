Return-Path: <kvm+bounces-28142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C180995565
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 19:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19C6E1F2666E
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 17:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405AF1E1C02;
	Tue,  8 Oct 2024 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="X3yXiO6Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6D11E1A13;
	Tue,  8 Oct 2024 17:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728407544; cv=fail; b=O8uDPYWVmdyqglRWQ3HFkIJDIAKLQw/LLMyfYZ7fayiBzC0zrgul6lXXt8SicQrEjqiaw3RzB9FCCUSEGcnaYNQiOBEZSEe12JQjbjjfmYHeeQRA2p13HmYiBxdVmYRPX2CG3vasImDBQ8pkspjv8nfDiEztn5GDJgHwJNdtG4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728407544; c=relaxed/simple;
	bh=gYAnZaK+LpZJ3c8nMoCrhpNMSB+ROLwQvp+fzxjL4zY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=L1rhI6imnE8TuWFHh640AK5NzU+RhWlsRkUnQZJruUS39e4PYgPjTIDcyOHgsFAtynDjHPIdyRx7upoifLqMJ0AcgxjP5uGnZqY8sZ3lkNvKmlb5oXER5bUbDK096vqlBb+mDz1sG5GWk+dydXbFFRd6nx1tTY/lB85TwyGQvLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=X3yXiO6Z; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JrN5ldjE/k+CE7+g0FLjNstouEzlLSik2Zsq6hXUf+cIPEPIGM3DdLlSzu0X/CeZAoxeX1TCStdQ0pZ4obGbFsiFPqve0c0UwTUo6b06PjOC61psvPQIr6I4wiVvVKdd8jXpmRGO+zDf4xzcULILKurDZo1lupWD438zQxufzqLhpOGgdVOila5eBG+xFoIkXSdISUXc06SmiLNKgzs+Uf7GtSxNxnLFRacSliw58H/uIqcdobsQmx4gKPYdft69+oEbL8ftaQBQiVhoAIyQGfrWgqRYeqt3TFQrWTurT8a3Er39CqqqkZbdvXtOHGF9eG6uqMI35XIwxtMwpZas5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDED7NF6S68dp/OMrPTPtzE3sq9UYTFZJXJ/IEMvdII=;
 b=QRyb6poVULbK1U96F9/h/CoMkfbeJuFNcM6HrbtUy0H/Z94t9xP/JhOx0MPcI0pz7dTGHq4/o16yT+xXX7a+9flh72UBYu1Lj9fHMFtpif2WwJg+vBWsXpmKyrojYmSHNUFYdlAIeVk2w63SZtnfDxM52o4zIxhpPlZqJv1e3EUKB7fjJ/KzCSUj0PZG3vHNzJm7prjLlg0pcZWXBSimBAitI5bhUxtqdSYT37wQwc5WR9qdsqytBuwQGWw19Tmk4fVdMT+aiM+wG3vvPD+wb38zGtv5Bm+g6JIpBnhRTVpKVVpLzbW5kS3YUgFv8tlJZAONTrdWKcGgCuF/GZNxJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDED7NF6S68dp/OMrPTPtzE3sq9UYTFZJXJ/IEMvdII=;
 b=X3yXiO6ZFcZokq0ZJff3/vAI3S/9mOSy2yxMy8POi6Y1azjhh6PszxLumuexrsUqxve0+/HxM0Hc9GQE2XrNirxHtTGUyjwjMgjM1wRer4DgESI6VbmRkKOl3yQnlDlkaSP3C4/BzqbsaU8ES9ktfSpokl/kkOfRMFjnpFegwww=
Received: from CH0PR13CA0043.namprd13.prod.outlook.com (2603:10b6:610:b2::18)
 by PH7PR12MB5654.namprd12.prod.outlook.com (2603:10b6:510:137::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20; Tue, 8 Oct
 2024 17:12:18 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::d2) by CH0PR13CA0043.outlook.office365.com
 (2603:10b6:610:b2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Tue, 8 Oct 2024 17:12:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Tue, 8 Oct 2024 17:12:17 +0000
Received: from volcano-ed17host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Oct
 2024 12:12:16 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
	<jon.grimm@amd.com>, <santosh.shukla@amd.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: SVM: Increase X2AVIC limit to 4096 vcpus
Date: Tue, 8 Oct 2024 17:11:56 +0000
Message-ID: <20241008171156.11972-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|PH7PR12MB5654:EE_
X-MS-Office365-Filtering-Correlation-Id: a2212d85-2df3-4cb9-ee6c-08dce7bc5cd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CLhzplDkyp0bLJtHLip96WkAbZOenVFHW2Ck1xAkdmGxGCTBlsdJvVWXOupp?=
 =?us-ascii?Q?0mzV1tCRZgd8oYqRrUmd+CKlIo6PTgDP4oDyxlgiW5D7N6HRNVpC4fm9SQue?=
 =?us-ascii?Q?PYXWMFfwgSr4mSvTVLZDrmCO7LfgSPMmljnoED60EBwxiMa2n0BVD3Ux21Aq?=
 =?us-ascii?Q?Mdj/OW9CT6eYDs/OAUvM2w+1tii8aJ4SlwavfMgTcoPyWvpT3EKQQClUAetE?=
 =?us-ascii?Q?QekeJQ+DPBBW6wikikT55qlO5jREmk30RAQqlwFsRgMCq3EUx9v/14Xwlzod?=
 =?us-ascii?Q?Z6AzxyzH7j0dcgVpyrfUl7nscmdykGChg8iO6K5KUaJFe/1T9JAAqVpUaore?=
 =?us-ascii?Q?yYCjS1sF7eZYjSnHaOAUrGnSRKN18upQ0gr9/+8fNe3gDlB6piDovdj7gByV?=
 =?us-ascii?Q?F+oO+2xVHyIn8ew2xcatxxWpSjjqBSc6GC0HpFY++5JZWn+7LRvJVWSt5J8d?=
 =?us-ascii?Q?SWZ3eqgfBWf4pW9Ipw88cS+7IMx4XkHnA1p3Z78r41dO+dUNehuxxYCGpjjk?=
 =?us-ascii?Q?rea2gaPBOJGbqPVlzrBPIbXKV9EOLV2E/0EFCRbYoigjze6vN9q4PgC27cyw?=
 =?us-ascii?Q?h3DTcNkpxGyacElhSAYNIVjU2Us9fHcAW4O90X2qsfxL/V0yi3Rv7RVx/AU7?=
 =?us-ascii?Q?qR6BO8SEYlmUb4kLfnFg3SzCsRbg4AOAq2g+LED8xL19uFUXXK3U76yF8ki3?=
 =?us-ascii?Q?FjY94B48r62ZXDhtt093IMSrOwI7uwuShmnu7igWTUW3g7VwN8MRIfuPotEb?=
 =?us-ascii?Q?6sDSu86G1nAIQAkyePKTglNEDILfR8Uh7wpPDOEqGFayOeVUrrHz6MSHFmz/?=
 =?us-ascii?Q?Huh+PwmWK5bT+zd4NiC2uIthXjH7w1xDhcgn/LER7NwYuhgVAhe9CoLc1Lyl?=
 =?us-ascii?Q?DWIvZjnGpYtKldov9HejS6Eszo/7XL6AO+dw0gmJO+8EiU/9T62SGc1fB812?=
 =?us-ascii?Q?xy1Zwk2MSRPz0w70IeJcJSJipceEwoEPDvu6HWRnsznPbl9p4WZZy3iykF8a?=
 =?us-ascii?Q?9JBCwLsq+hq4NcvgUR+GUhzLNGo502zeLpZZ6xsJ1fr+oxxLNED2rxKSxRoN?=
 =?us-ascii?Q?hMpOCmUrDZ0kWALU35fR42cwuJBGAZJGj7bcz/13vl17oNJFCzT+yAVuxtsr?=
 =?us-ascii?Q?AJDXlir4FfIzCLaOn1GIJfvsQCalybRR6lbx9AKtyCtVaCAY7WC+E3VAxJRl?=
 =?us-ascii?Q?t4nEkm4tsJ38rZ/1SfEq/pq6cw5RjSdIAJg4EVYrpszQl3bb9rz5KWoCftjE?=
 =?us-ascii?Q?9yTYiOKaQPSdlAbzTByDOp1PQGFEXyQb0C5BAnJh2rnZciY+vjaFlF/KOVaJ?=
 =?us-ascii?Q?mmcOUvpH8ndykjf4a08nauBsqfj3WzFOGCntQM6hEYVPCXBg/YHHcEpmt94U?=
 =?us-ascii?Q?0U9VkZQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2024 17:12:17.6222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2212d85-2df3-4cb9-ee6c-08dce7bc5cd5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5654

Newer AMD platforms enhance x2AVIC feature to support up to 4096 vcpus.
This capatility is detected via CPUID_Fn8000000A_ECX[x2AVIC_EXT].

Modify the SVM driver to check the capability. If detected, extend bitmask
for guest max physical APIC ID to 0xFFF, increase maximum vcpu index to
4095, and increase the size of the Phyical APIC ID table from 4K to 32K in
order to accommodate up to 4096 entries.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  4 ++++
 arch/x86/kvm/svm/avic.c    | 42 ++++++++++++++++++++++++++------------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 2b59b9951c90..2e9728cec242 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -268,6 +268,7 @@ enum avic_ipi_failure_cause {
 };
 
 #define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
+#define AVIC_PHYSICAL_MAX_INDEX_4K_MASK	GENMASK_ULL(11, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID table is 0xfe (254), as
@@ -277,11 +278,14 @@ enum avic_ipi_failure_cause {
 
 /*
  * For x2AVIC, the max index allowed for physical APIC ID table is 0x1ff (511).
+ * For extended x2AVIC, the max index allowed for physical APIC ID table is 0xfff (4095).
  */
 #define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
+#define X2AVIC_MAX_PHYSICAL_ID_4K	0xFFFUL
 
 static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_PHYSICAL_ID);
 static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
+static_assert((X2AVIC_MAX_PHYSICAL_ID_4K & AVIC_PHYSICAL_MAX_INDEX_4K_MASK) == X2AVIC_MAX_PHYSICAL_ID_4K);
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b74ea91f4e6..fe09e35dad42 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -38,9 +38,9 @@
  * size of the GATag is defined by hardware (32 bits), but is an opaque value
  * as far as hardware is concerned.
  */
-#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
+#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_4K_MASK
 
-#define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
+#define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_4K_MASK)
 #define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
 
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
@@ -73,6 +73,9 @@ static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 bool x2avic_enabled;
+static bool x2avic_4k_vcpu_supported;
+static u64 x2avic_max_physical_id;
+static u64 avic_physical_max_index_mask;
 
 /*
  * This is a wrapper of struct amd_iommu_ir_data.
@@ -87,7 +90,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
-	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+	vmcb->control.avic_physical_id &= ~avic_physical_max_index_mask;
 
 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 
@@ -100,7 +103,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	 */
 	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
-		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
+		vmcb->control.avic_physical_id |= x2avic_max_physical_id;
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
@@ -122,7 +125,7 @@ static void avic_deactivate_vmcb(struct vcpu_svm *svm)
 	struct vmcb *vmcb = svm->vmcb01.ptr;
 
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
-	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+	vmcb->control.avic_physical_id &= ~avic_physical_max_index_mask;
 
 	/*
 	 * If running nested and the guest uses its own MSR bitmap, there
@@ -197,13 +200,15 @@ int avic_vm_init(struct kvm *kvm)
 	struct kvm_svm *k2;
 	struct page *p_page;
 	struct page *l_page;
-	u32 vm_id;
+	u32 vm_id, entries;
 
 	if (!enable_apicv)
 		return 0;
 
-	/* Allocating physical APIC ID table (4KB) */
-	p_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	/* Allocating physical APIC ID table */
+	entries = x2avic_max_physical_id + 1;
+	p_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
+			     get_order(sizeof(u64) * entries));
 	if (!p_page)
 		goto free_avic;
 
@@ -266,7 +271,7 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 
 	if ((!x2avic_enabled && index > AVIC_MAX_PHYSICAL_ID) ||
-	    (index > X2AVIC_MAX_PHYSICAL_ID))
+	    (index > x2avic_max_physical_id))
 		return NULL;
 
 	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
@@ -281,7 +286,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
-	    (id > X2AVIC_MAX_PHYSICAL_ID))
+	    (id > x2avic_max_physical_id))
 		return -EINVAL;
 
 	if (!vcpu->arch.apic->regs)
@@ -493,7 +498,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
 	u32 icrl = svm->vmcb->control.exit_info_1;
 	u32 id = svm->vmcb->control.exit_info_2 >> 32;
-	u32 index = svm->vmcb->control.exit_info_2 & 0x1FF;
+	u32 index = svm->vmcb->control.exit_info_2 & avic_physical_max_index_mask;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
@@ -1212,8 +1217,19 @@ bool avic_hardware_setup(void)
 
 	/* AVIC is a prerequisite for x2AVIC. */
 	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
-	if (x2avic_enabled)
-		pr_info("x2AVIC enabled\n");
+	if (x2avic_enabled) {
+		x2avic_4k_vcpu_supported = !!(cpuid_ecx(0x8000000a) & 0x40);
+		if (x2avic_4k_vcpu_supported) {
+			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID_4K;
+			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_4K_MASK;
+		} else {
+			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID;
+			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_MASK;
+		}
+
+		pr_info("x2AVIC enabled%s\n",
+			x2avic_4k_vcpu_supported ? " (w/ 4K-vcpu)" : "");
+	}
 
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 
-- 
2.43.0


