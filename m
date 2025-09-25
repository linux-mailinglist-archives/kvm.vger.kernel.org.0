Return-Path: <kvm+bounces-58723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACFAEB9E947
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:11:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A2E9163BC7
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11DF22EA752;
	Thu, 25 Sep 2025 10:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zF2+ntbH"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010036.outbound.protection.outlook.com [52.101.61.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2EB2DE1F0
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758795083; cv=fail; b=D/XjjwwySTzyZfmLUVzuQkQK7+UlSQLGGn3Pt8MCDaMWcwqqbDspEbHiSC4oq+eZsSmEBHKZ4qv/iYIFXzU4Ht/OrcGuLoYXW3jH6/abNl9K87hjgVntX0eWUJbHoGP5PD2u5JO+48hQif199cVhMzqLOKAQ636VUNCyiPvUdlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758795083; c=relaxed/simple;
	bh=0beXenGdWSe1zhRoLSq5R7ez7RKoYWRiLBTVtzVv39c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dNbgPkZDG7lOPn0w4s82hmTb4d18JDUfi1jIMc6XogENp8nerPvy0txO5Z0QDKttMzceaZhSw1nK/B7kI9PBOhXuLsI5Fx6eAySmQ2bGMmQ0Tjoz3tn5a40ZicI9TQkkR+3C6iZ0LSXFXA6EcU2UsnmXAp/Cs6iYslBxIDrZzOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zF2+ntbH; arc=fail smtp.client-ip=52.101.61.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xsqgokJPp0GN4RP34sxNws6GjZU2fRou13HblN5iXBXHoRTeIWKVet1powFrQnsNNME1ORllsfy6rKrPzheEhQcVCNzEclwcADxSdLh9re0vQ7lsq85PJcd5GMosa6S9w+higKQEu7mmDj+6Ra11GugnVTgdim0+RXYUPCc/s1fmwgW3NuKqaqF0TtpWQn4EAi/gvKU4P9FC4JoODFRyjIGxS+OfzTP6B5vkaIDChA0MaPXTY8us60gSm+K/fxe3fLWLFQrPDj4eLv/sBt+fqIDMKAsSIOlW8fkz1UfLjWJfhzgHDefi0eQE6p3gPCBUzY4gKrL1laVQcehPe8eFlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kySGEeYO9oy+087ztkyYOqgEsfX9zzzJ0bJY7k39pfg=;
 b=TFOAps1VYUZwvRR+hNLJWZsMnjctOgGsHi05rpPdbSo+5ZcGgDqr7xIu3thV+DC6kBcM9cCsX1Of2p24R5oSB7H71sKtPvDSLEAzbEwqRmPaj2CZP/C0rSYBH0X5urO3a8TZRhZxoO/zQihFhuiyYU0pWfIrYBfqaYHaLuJ8l2IMtBM3/xqQi6lE6I/sly44SPyvh/6ygDM/+ihNeW/9h6nAosjNnomxgBlk0+D74x1f+tcej3wGcyVoPKOMTwakL1LtNY6qpEc0uI+AAgRSpgGM9hSdNgbn6rCKr8/XmW90S3GOg0yunnHprU0rgP+7vpblFWV6I6Z+Nwm18K/M/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kySGEeYO9oy+087ztkyYOqgEsfX9zzzJ0bJY7k39pfg=;
 b=zF2+ntbHhijHWs1vWDsN9EaZCQ2U9yZPlNDpKwvFFWXzuVbpSi5BDRHWjwIevQFBm3rjbqVm6qyTm7HVgMBflgVG3AmpqcCGKAbP/hN1HdUpwVKoA0GAJxMM9fXQsYnpGrY4CiaeQ/8rP9iEu6cOrVnJSHBDrr9AoWKLowOaCPA=
Received: from CH0PR03CA0351.namprd03.prod.outlook.com (2603:10b6:610:11a::13)
 by SJ2PR12MB8011.namprd12.prod.outlook.com (2603:10b6:a03:4c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Thu, 25 Sep
 2025 10:11:17 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:11a:cafe::9f) by CH0PR03CA0351.outlook.office365.com
 (2603:10b6:610:11a::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.10 via Frontend Transport; Thu,
 25 Sep 2025 10:11:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Thu, 25 Sep 2025 10:11:16 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 25 Sep
 2025 03:11:13 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v3 2/5] KVM: x86: Move PML page to common vcpu arch structure
Date: Thu, 25 Sep 2025 10:10:49 +0000
Message-ID: <20250925101052.1868431-3-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250925101052.1868431-1-nikunj@amd.com>
References: <20250925101052.1868431-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|SJ2PR12MB8011:EE_
X-MS-Office365-Filtering-Correlation-Id: 76f2cf5a-d8a8-4bf9-d581-08ddfc1bdd9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CQp79Ve0LsyiBoo6yWkNO9nVrNVBLGKa5UDaf1LMbSBjm/BvHI56BdKa+vCb?=
 =?us-ascii?Q?N1bV4OmMIVY9+Qahg5wsTKoWc9vDVKimTBMnb8QEDiaSjqsPDFpmD1xtvh1U?=
 =?us-ascii?Q?qV0BRy2IInfUuBisutEkBajW4pmsUT+TDg1BLoLaQfTBWrIMcQHEpGUybK5b?=
 =?us-ascii?Q?Izh3yXAh6zWy7RACH3EN0xQdukxtDq5RWcqK89ojh9pq+O3LkqArun5spHUh?=
 =?us-ascii?Q?pC1N8GCl1HFh8P1CtIO+vCdyuMpB5shKLEa1uLQwX3VS+NkVurnmjRGVRovg?=
 =?us-ascii?Q?tyE1aT+5GNAYt1p+lB9kJArH+1hpSlSpewUDG25RZmA8F8Dkf10t0D8rTP3+?=
 =?us-ascii?Q?ya5+dmfvvg47XmXWJCNfIZY4kTUuLnIXNfw/c0bKzOjdFubvfkL/ymgCGnDX?=
 =?us-ascii?Q?7V7JxLdWpwq6rWhBkEsvWwzrjkoibFtwByhz2fCXoiMs4gi0X9DPD3+3BTx3?=
 =?us-ascii?Q?J6ib6ibUg/KS+B6h+OSras8ugJXQJ0O8HD0H5ts8ZlubA/We75w0qZSfxqcD?=
 =?us-ascii?Q?L2dGs84QINEpEgEaAVg4WWzJXrVZUZfyr3lyiEuFDEbH+arcw5I3OnjvbXCs?=
 =?us-ascii?Q?HejUI4Dcjbt0oU7IvkEJxZaO6BTpR2mcPjeyednHWNRmljld++7bD20QmvlS?=
 =?us-ascii?Q?Ndv17t02gfTVBjoH5UzVLQcy5K0lpeccj5oILURtvuXkl7ViJC+Hf4PG7IGv?=
 =?us-ascii?Q?eyBTZXEsYlx+vZk13Gow3ReVKGlrOd7XYvInN57/KsRu+wlkfjO1jrOIRsAC?=
 =?us-ascii?Q?XC8Z+Om6W+CGnPXM1DccXFiFF1tRVGPCNFdO8+86cHAO6BTTxqDEeHjhoSCN?=
 =?us-ascii?Q?OOuK5cjvuIvG1wvNmyapOFc3JMQeamgFiQ3UK7fFx4exDjhpHUt1aENAXOiq?=
 =?us-ascii?Q?xQo9rCI3MLKfN8NfxZaSmqAhrOxc2x+VqbCTqkWgmzVAGlyGFAI4Z2c1FxjP?=
 =?us-ascii?Q?pwXnIOA6Q1qFcHJWHX6pUxK2BUD5X+DMCdGr1Oqb8TaHdRHg0nJCAXHB8pmA?=
 =?us-ascii?Q?G91Qap9b87HXouJy4i0Yppl5ZaQL2Bf8u2bIVV7lHaOZ6qP9On07YckWoi37?=
 =?us-ascii?Q?5F0Hq9pHp8WzFvhwOdA502aVavGt+B34zWNQh/nqiaQ91BRVncuXwRioRUdY?=
 =?us-ascii?Q?+gOkI0MiCP8wwCLb+P+jvc87kbgKyBPyMAUG7P8htG4C8eNZ28cay/ZKG3ke?=
 =?us-ascii?Q?8VLrcDQz3TaqlW8p7kZxDU9amrFmuSbGaRDSMYRYwCOW1AC57pOpw6EBPkyN?=
 =?us-ascii?Q?d05Sfj5VCTSH3YyqgLaTt5LD43ZSTTFVlpee1x9VwPsAaYviRL+KZjxEAsg5?=
 =?us-ascii?Q?NwE6X7M2pjSlD731s8tWcww+Zqn3pcGVrZChH9xBKyLFO0enY1ilIKL2DvMZ?=
 =?us-ascii?Q?BemakvQTWq4V6uDOcWZnTzMV1VMmc9x0edDxIt3qsVRWUnyOQFZaaJ/e8gqX?=
 =?us-ascii?Q?7pHfDXbUVe3ef/hmyJsflswNtWy8T4ZUC75VjH+393D40mVmqSnmYW1Efv64?=
 =?us-ascii?Q?bMRuOtad/F7H/+ndIdUYEazzlsGdDuAeYUocD/17Z7XoutDlzcPI6L/xM8+j?=
 =?us-ascii?Q?yw1FxmrvQH2TF1brm+A=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 10:11:16.8166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f2cf5a-d8a8-4bf9-d581-08ddfc1bdd9a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8011

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
index c56cc54d682a..62a7d519fbaf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -857,6 +857,8 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 
+	struct page *pml_page;
+
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
 	 * In vcpu_run, we switch between the user and guest FPU contexts.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a0955155d7ca..9520e11b08d0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4612,7 +4612,8 @@ int vmx_vcpu_precreate(struct kvm *kvm)
 
 static void init_vmcs(struct vcpu_vmx *vmx)
 {
-	struct kvm *kvm = vmx->vcpu.kvm;
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 
 	if (nested)
@@ -4703,7 +4704,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
 
 	if (enable_pml) {
-		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
+		vmcs_write64(PML_ADDRESS, page_to_phys(vcpu->arch.pml_page));
 		vmcs_write16(GUEST_PML_INDEX, PML_HEAD_INDEX);
 	}
 
@@ -6096,17 +6097,16 @@ void vmx_get_entry_info(struct kvm_vcpu *vcpu, u32 *intr_info, u32 *error_code)
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
@@ -6115,7 +6115,7 @@ static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 	if (pml_idx == PML_HEAD_INDEX)
 		return;
 
-	kvm_flush_pml_buffer(vcpu, vmx->pml_pg, pml_idx);
+	kvm_flush_pml_buffer(vcpu, pml_idx);
 
 	/* reset PML index */
 	vmcs_write16(GUEST_PML_INDEX, PML_HEAD_INDEX);
@@ -7388,7 +7388,7 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (enable_pml)
-		vmx_destroy_pml_buffer(vmx);
+		vmx_destroy_pml_buffer(vcpu);
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
@@ -7417,8 +7417,8 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	 * for the guest), etc.
 	 */
 	if (enable_pml) {
-		vmx->pml_pg = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-		if (!vmx->pml_pg)
+		vcpu->arch.pml_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!vcpu->arch.pml_page)
 			goto free_vpid;
 	}
 
@@ -7489,7 +7489,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 free_vmcs:
 	free_loaded_vmcs(vmx->loaded_vmcs);
 free_pml:
-	vmx_destroy_pml_buffer(vmx);
+	vmx_destroy_pml_buffer(vcpu);
 free_vpid:
 	free_vpid(vmx->vpid);
 	return err;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4494c253727f..6fafb6228c17 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -269,8 +269,6 @@ struct vcpu_vmx {
 	unsigned int ple_window;
 	bool ple_window_dirty;
 
-	struct page *pml_pg;
-
 	/* apic deadline value in host tsc */
 	u64 hv_deadline_tsc;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 123ebe7be184..afa7f8b46416 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6417,7 +6417,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 		kvm_vcpu_kick(vcpu);
 }
 
-void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_page, u16 pml_idx)
+void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, u16 pml_idx)
 {
 	u16 pml_tail_index;
 	u64 *pml_buf;
@@ -6436,7 +6436,7 @@ void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_page, u16 pml_
 	 * Read the entries in the same order they were written, to ensure that
 	 * the dirty ring is filled in the same order the CPU wrote them.
 	 */
-	pml_buf = page_address(pml_page);
+	pml_buf = page_address(vcpu->arch.pml_page);
 
 	for (i = PML_HEAD_INDEX; i >= pml_tail_index; i--) {
 		u64 gpa;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 23c188c0a24b..92016081a7e7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -704,6 +704,6 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 /* PML is written backwards: this is the first entry written by the CPU */
 #define PML_HEAD_INDEX		(PML_LOG_NR_ENTRIES-1)
 
-void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_pg, u16 pml_idx);
+void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, u16 pml_idx);
 
 #endif
-- 
2.48.1


