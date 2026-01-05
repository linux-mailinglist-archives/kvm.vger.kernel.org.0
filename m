Return-Path: <kvm+bounces-66999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 689D7CF2151
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D2529300182F
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D8925C80E;
	Mon,  5 Jan 2026 06:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="h/MW6occ"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0CD1B4F0A
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 06:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767595025; cv=fail; b=j11sW/XAOq2geqHrW+fyeC08upZIrSfjsOtykfb+aREjS6MI12gn10o7xzBlFpCt0DxdVrXEmnUg/tTL/wlQYrriBm1gu921lYRhlciZ96Arl3PSRndif5UhR3oAU30zRGGILyGGQmoFyFTOZaLsaIegEIahjtNW/wlFuK9PkqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767595025; c=relaxed/simple;
	bh=1Vk3xrt1IYD68Ro7J1qJ5umLxc13dHvJQtv7KmLyTdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bKiJkYw5Udh8DmslPLimkjUtNIYngZXuXDTUAcuIBm9kwHSAtpHuYTGcj/vIUGh0iHXEUDXK2hMbNLNInJRLCpBZJR/tFfUQOvd/ZeHs8fILYxKiLXSwMaZVi/ZDjbxJ4BfWiVxThGt7W3h5udXaQK1MAh644PGYkWUCfkzJlxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=h/MW6occ; arc=fail smtp.client-ip=52.101.43.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A9mOrP8ONohFYdrdaANTJVunw0AjJAMycknpfOkIWsrZU8sERfFDtOS+IMmsnQyPT7ScfTYHOxyEZSb58oezPbHvh6clYB9T8qfvDQegAQpjAW8xbGiUGYaRvt84C0KJe93Iji08jLRF3s0wVs1i7G83/GzEioM+UMQ3K6tHwbpuGUGCwbqXrQmXAysV6dr0XfDX9uKO04vUnqKgmjglkGij6FiHPwuXiC1NX4as0UfEyQ9SXddqAQfuubndzt4FiCTIK/jzCHm+3uuIyePjaPr1ev+EePayGO4zo8b2pdt0DdBAfXTqmhqzM+8bulEmFRRLABD0uKps7UbWK887rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JYm51y28BIRIKBqq3b2L9KH16ihco+PcPiA2YUv4lK4=;
 b=OEqvoHMb9AQVzpfaN+p/xS1c1l5XpPjPVU86AYdIGCgxjc1f9Lk1dIHfJbsPieN/wqNNdt6BegQrvN4MDLT4O4Cdn7dVgvpj1aIRC4BlLBMggobQxlUlls7Vsgw1Xyrf3/ONGB+sUuBUUdD92ovrMeCCtX46jJBYlSKtlHYG8ZBtnxLaolXfYDEsnDHzkSTHXJDfrOgJKcrRtp5VgjJgRIQPrXOnQ3QgZ7YZGICX8LcebogyTl1eYOJjhjypgGvEaBnAXBVd03Q3ifDrO/SUugYWLVRysuJdVwhpIk23HyLSAFNv5wSy55t2EmDgyGj6aljde6zBA8elIsxe+YvlPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYm51y28BIRIKBqq3b2L9KH16ihco+PcPiA2YUv4lK4=;
 b=h/MW6occhnMmfUjRZVRFQBm/9vj/4hBYPbn7eI/aDfdr2rLWbKzyQTB9DbBGbsMhnd79jwpH3OKfTlCZk84TOYydEk2rkev50i5yQGbwz0Rg5kcbX5CEt+EvQ8Jf0DmFLXlQei2lIA34IZ9ozEq94D6f4CG6EqZegqMvM9UJdR8=
Received: from DM6PR03CA0082.namprd03.prod.outlook.com (2603:10b6:5:333::15)
 by LV3PR12MB9330.namprd12.prod.outlook.com (2603:10b6:408:217::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 06:36:59 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:5:333:cafe::14) by DM6PR03CA0082.outlook.office365.com
 (2603:10b6:5:333::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 06:36:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 06:36:59 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 00:36:55 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v5 2/8] KVM: x86: Move PML page to common vcpu arch structure
Date: Mon, 5 Jan 2026 06:36:16 +0000
Message-ID: <20260105063622.894410-3-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260105063622.894410-1-nikunj@amd.com>
References: <20260105063622.894410-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|LV3PR12MB9330:EE_
X-MS-Office365-Filtering-Correlation-Id: 31021e30-960d-49ae-30aa-08de4c24d402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M3tzLsDegIJEhe/Du4vqkKgZEKveem+b9jSqkhJuFoxS8fslowskYZx85PZd?=
 =?us-ascii?Q?t91jUBySzeNMUO95s7vtXOTvoH+eg5wA0LY8PpGcHnkh3XIdwl4WA5E8duJK?=
 =?us-ascii?Q?05cH3IJxgh6W1jBSYo7fdkBidB5KnBg/ffPcg0tr8Qj4RnLaJnuKwhSHOzOM?=
 =?us-ascii?Q?VFq9k2f9dscZeXos0CupXPs2PmQeM+hiPGJEuneiwgUVFcr7X2+pRoNDdXlp?=
 =?us-ascii?Q?WvuzfqR5RhTzTXmen12I9Api/Tm07PCaL56XBa/7KBWxuo3QIRfJ9xtJQB+F?=
 =?us-ascii?Q?wvnUHa8L+OLDM6EtOdCYclxbTw4mvgP1y/OD2Ss2s1i44lY8x5+dfhjfft8y?=
 =?us-ascii?Q?CYr5xvI96tFbX7p+2RcVGhmd7nGjBSTZSF9wMafWzytUsu1B8HDJgoaNWLKf?=
 =?us-ascii?Q?WtVjumadL1beLTH+80DOv20TegGarGMaMvahD3PZS4nO4OnzjB3xsc8bzo5h?=
 =?us-ascii?Q?vwp167drH4PPFJHi4fqXgUv6pVt9+NCcA+SCuWQhFAPe86n+7IegIhSsiFX7?=
 =?us-ascii?Q?jyX7CVe3o4Cz2VAOW32RaRNgimH37G2EN+jGPdtMqL6PlMDC0q2XH0sGWvg9?=
 =?us-ascii?Q?faGH9YHUvzh9OJte4t5vsOBt9MNE6iz/LNb++lNFtjVxXUWBzEhjHMjdRCxI?=
 =?us-ascii?Q?XinXY9izTDd3QcoftZeZhay4A9fTDK7TyMypeXF24OXpHeWzl+Jac9G6zFoS?=
 =?us-ascii?Q?bKdSQoX4OUE18yjoJRYZYbW/mZh1qiKP1bR/MMWohmdQ+7Vvknz4srekFcyY?=
 =?us-ascii?Q?74+T5cE6/4wwPsH6birSJua6vAKAgs3b7Gn3Kjo0hmaeeyNSKLR36EPLoW1a?=
 =?us-ascii?Q?IZNinjcK1lNv1IGpCbz0oQEOYlQkBVUxnnlo425Mzbz6jqNR4OxgyhcrgDMn?=
 =?us-ascii?Q?+TBmPibKjj/Qpf515bMa5qzu4EPWi0wvP+Zarsf/dUmwfszI30XzXWE29IoQ?=
 =?us-ascii?Q?D0GVlgKihul9/Oc5ZQTRRowzoK7MPlS00JYFtdZnDCn4DpZiVRZUQehPvmMT?=
 =?us-ascii?Q?CO+gWXu/Il7Nrs5OvIDV/pL7BlWs5k7v+YKCOw/cGD26cFZxQJHkj9OCjo9w?=
 =?us-ascii?Q?J6IfSIezaA87rK7o/IVckO0J1iz8mVejyTickXxu0ue7S4v4s3ZSoZNerOiN?=
 =?us-ascii?Q?bRs6gnVHmFirrWDkiCNYH/POZ/3hLn2Pe9l6coV33y6VkeIxvvYzTSjmFa5J?=
 =?us-ascii?Q?aOlbz8p3fU8ZAmHLih1GaTv0A/JQ+vPsvcDgf0PHA8uw4BqwVNadM0IQVo+a?=
 =?us-ascii?Q?3+EkxMxllBCQ63vi8pmlioOcWfQzU+qIN08jiwrxwQlQ4G2FIoTz/0s8Fqls?=
 =?us-ascii?Q?3Krr6PQ89nYP31dhUKQ5gTOw27o3NB3r+s7RmdIr+ZcvqgeEHxmZePJc6C12?=
 =?us-ascii?Q?guUgZijOWstmTNpHovdOhoa/vj4q/TUPnuvmzaNDUS8peerVWzZrCDc1m8l8?=
 =?us-ascii?Q?AcRre2v1dNxHs3/vc4U5BB2IcL60TFf5tjB8RcYQuUSUx2SCl8tJsG5560uJ?=
 =?us-ascii?Q?B+TSoh19a0cQBqqrNfD9rJ+kIYx9V6kp+H3EZWC5es/hRb6p7fxsMBHTDHh3?=
 =?us-ascii?Q?SNy4B21vS4GUcPJZjEM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:36:59.2224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31021e30-960d-49ae-30aa-08de4c24d402
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9330

Move the PML page pointer from VMX-specific vcpu_vmx structure to the
common kvm_vcpu_arch structure to enable sharing between VMX and SVM
implementations. Only the page pointer is moved to x86 common code while
keeping allocation logic vendor-specific, since AMD requires
snp_safe_alloc_page() for PML buffer allocation.

Update all VMX references accordingly, and simplify the
kvm_flush_pml_buffer() interface by removing the page parameter since it
can now access the page directly from the vcpu structure.

No functional change, restructuring to prepare for SVM PML support.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/vmx.c          | 24 ++++++++++++------------
 arch/x86/kvm/vmx/vmx.h          |  2 --
 arch/x86/kvm/x86.c              |  4 ++--
 arch/x86/kvm/x86.h              |  2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5a3bfa293e8b..123b4d0a8297 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -861,6 +861,8 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 
+	struct page *pml_page;
+
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
 	 * In vcpu_run, we switch between the user and guest FPU contexts.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c152c8590374..bd244b46068f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4805,7 +4805,8 @@ int vmx_vcpu_precreate(struct kvm *kvm)
 
 static void init_vmcs(struct vcpu_vmx *vmx)
 {
-	struct kvm *kvm = vmx->vcpu.kvm;
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 
 	if (nested)
@@ -4896,7 +4897,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
 
 	if (enable_pml) {
-		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
+		vmcs_write64(PML_ADDRESS, page_to_phys(vcpu->arch.pml_page));
 		vmcs_write16(GUEST_PML_INDEX, PML_HEAD_INDEX);
 	}
 
@@ -6331,17 +6332,16 @@ void vmx_get_entry_info(struct kvm_vcpu *vcpu, u32 *intr_info, u32 *error_code)
 		*error_code = 0;
 }
 
-static void vmx_destroy_pml_buffer(struct vcpu_vmx *vmx)
+static void vmx_destroy_pml_buffer(struct kvm_vcpu *vcpu)
 {
-	if (vmx->pml_pg) {
-		__free_page(vmx->pml_pg);
-		vmx->pml_pg = NULL;
+	if (vcpu->arch.pml_page) {
+		__free_page(vcpu->arch.pml_page);
+		vcpu->arch.pml_page = NULL;
 	}
 }
 
 static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u16 pml_idx;
 
 	pml_idx = vmcs_read16(GUEST_PML_INDEX);
@@ -6350,7 +6350,7 @@ static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 	if (pml_idx == PML_HEAD_INDEX)
 		return;
 
-	kvm_flush_pml_buffer(vcpu, vmx->pml_pg, pml_idx);
+	kvm_flush_pml_buffer(vcpu, pml_idx);
 
 	/* reset PML index */
 	vmcs_write16(GUEST_PML_INDEX, PML_HEAD_INDEX);
@@ -7545,7 +7545,7 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (enable_pml)
-		vmx_destroy_pml_buffer(vmx);
+		vmx_destroy_pml_buffer(vcpu);
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
@@ -7574,8 +7574,8 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	 * for the guest), etc.
 	 */
 	if (enable_pml) {
-		vmx->pml_pg = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-		if (!vmx->pml_pg)
+		vcpu->arch.pml_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!vcpu->arch.pml_page)
 			goto free_vpid;
 	}
 
@@ -7646,7 +7646,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 free_vmcs:
 	free_loaded_vmcs(vmx->loaded_vmcs);
 free_pml:
-	vmx_destroy_pml_buffer(vmx);
+	vmx_destroy_pml_buffer(vcpu);
 free_vpid:
 	free_vpid(vmx->vpid);
 	return err;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e1602db0d3a4..c9b6760d7a2d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -272,8 +272,6 @@ struct vcpu_vmx {
 	unsigned int ple_window;
 	bool ple_window_dirty;
 
-	struct page *pml_pg;
-
 	/* apic deadline value in host tsc */
 	u64 hv_deadline_tsc;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fec4f5c94510..7e299c4b9bf7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6696,7 +6696,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 		kvm_vcpu_kick(vcpu);
 }
 
-void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_page, u16 pml_idx)
+void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, u16 pml_idx)
 {
 	u16 pml_tail_index;
 	u64 *pml_buf;
@@ -6715,7 +6715,7 @@ void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_page, u16 pml_
 	 * Read the entries in the same order they were written, to ensure that
 	 * the dirty ring is filled in the same order the CPU wrote them.
 	 */
-	pml_buf = page_address(pml_page);
+	pml_buf = page_address(vcpu->arch.pml_page);
 
 	for (i = PML_HEAD_INDEX; i >= pml_tail_index; i--) {
 		u64 gpa;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 24aee9d99787..105d9e9ad99c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -755,6 +755,6 @@ static inline bool kvm_is_valid_u_s_cet(struct kvm_vcpu *vcpu, u64 data)
 /* PML is written backwards: this is the first entry written by the CPU */
 #define PML_HEAD_INDEX		(PML_LOG_NR_ENTRIES-1)
 
-void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_pg, u16 pml_idx);
+void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, u16 pml_idx);
 
 #endif
-- 
2.48.1


