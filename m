Return-Path: <kvm+bounces-59870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F520BD1AC1
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3F4E94ED3EA
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 06:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2E62E3B03;
	Mon, 13 Oct 2025 06:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LZw6Y+Jp"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD152E0902
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 06:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336757; cv=fail; b=oxLNdObT04z0avRLwDhn0y1eVWNWf45Wk5ZAWhUbpd0Iu8QD/aXCQrINBuHBZ2FMo1+XE4WLiG7KfAK8slLjd4HJvnnOStozQfNYUgGQBoVHl8WTom1/qfbam6TtKO3Cct1RtNsSNrXgiOW4pK1kjax+KUsIlxn0caBgockSYg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336757; c=relaxed/simple;
	bh=6WvHYqnzs8mlxy4muLtKFE2kYBY9p/NFt6qwR6HS6+8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NyzUsSzjMDm3j1EhMdpuTiNOGfhzBzQdH+JcTnOdSdoXcwHM0r8M4fxiOwolOKe9vvA9M+VRKmHgt/5+vEYQ1nGcnrXkdiaTaOhIW9aAYL+E55A6Jbx6/S6+LUvwl0zvD8iJ0TACVnIxFM56ZRqzd2XgXLrPHLr2zl47j7u1Mjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LZw6Y+Jp; arc=fail smtp.client-ip=40.93.198.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=siwLWmlyBqZ9Vk/H3lpugqP1j5VyfU+bQ32WUU6v6LRF2+WzySPDnGcIOyeOKVxhqHasLwsSoFWRYSTkc6x+J+Dvq2xOI6qsUndfISCqHjCodr4KpofcbAutyPeggOq0ynq4wjlpUsavbLNQuMUsS18efTMAJh11rZ1NyKCpllYzLygBz/qcNrW7QNJvlCQTY1Uasf+6J4KfVQM22tIttiXqDg4AtSs5ctc2uvd5iM0C65OiaMQpa1ehlFDht5HoHTkjK+uLejQ/n9p1f+k3GjgtbNbSkk5YhQlX3Hqn3d+RH0luAen1hZHpSUPOoLBBQRDZ6fIskycKmEj1g5hgWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PH45WejTOF6rca1Z9zlYpyUBiA2M5DE/gdb5TVYpAww=;
 b=p4ro4bqQhT3RSZTthmDO2S86gbcOVgdg7bNsJkgj4KBNon3iyRWb/fxvrEvi415oZkw4f3hMkP+5FPM7vcplBBzWukxiFakKgIrcGN1TnWKEXFek664JPZ9dWTM9U2RqWuRucCy1/UfIKU9XnHfF4keTvHp4UiOiO7TN8nkMMOhC7uG7v0whTa9rQsWKYVwmE6SQYJlqW6mMp4WOiKwy9FE6BdwSxbCCiTx41qyKL+fnzH+hx2YsMYK0z0tJp2zECVYDQlZjBODwrF4fB2n9DUv8EXecOZGtrvqRl6WMBUCgBRyU7Y7QYr5mBhKpWBu0umPeZBKx1aDsnHlWLP1d0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PH45WejTOF6rca1Z9zlYpyUBiA2M5DE/gdb5TVYpAww=;
 b=LZw6Y+JpVq+ITTi53EL85wfgZRDfgis7umLAcHObSoSHFJUPCQ5hAh9pFSaA22l4cBNA/HibLyHR/hsxM2wlW4QWRHfkY25ifvFABqDtO7gmotifchDWBQvQm8bcruXw7OMelY2wMjlmFRdjikTpKSSLgorfHQoa3iLmEsoWqpY=
Received: from DS7P220CA0025.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:223::22) by
 DM6PR12MB4154.namprd12.prod.outlook.com (2603:10b6:5:21d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.10; Mon, 13 Oct 2025 06:25:50 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:8:223:cafe::95) by DS7P220CA0025.outlook.office365.com
 (2603:10b6:8:223::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.12 via Frontend Transport; Mon,
 13 Oct 2025 06:25:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 06:25:50 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 23:25:47 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v4 2/7] KVM: x86: Move PML page to common vcpu arch structure
Date: Mon, 13 Oct 2025 06:25:10 +0000
Message-ID: <20251013062515.3712430-3-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251013062515.3712430-1-nikunj@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|DM6PR12MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: 53eabbfe-bc5d-42b9-6b65-08de0a215ae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E4cjLmmYaFBNj2zvyFtgSyBImVPn4Tffpv9VixcUI4HfB475lkRw4CjJa0L9?=
 =?us-ascii?Q?L3T2Gh0WEA2TVZD6CnDP3zSNDZZZmWTjw29kWXCqoML5jyGlsXl1TfJYWpQ8?=
 =?us-ascii?Q?VXXPGspQtTP59XB/F0iZIjvmvw2mDLXTXne1QkhpdAEZ732172cxJdU5VIul?=
 =?us-ascii?Q?C5++qNFRNZ+LqUiq+JFnc+1QcJnJfe3SbyVAZdVedySAkndYBbuEepCHW44J?=
 =?us-ascii?Q?aBBDES+99i79deDLaIbn4h+ANg9sunaSNGV8M5MUF4HHj0v3k6OL/MZ82GAi?=
 =?us-ascii?Q?5SOcG1bo2Qu/ABcDttsJV5qNUluXaMKvuNs3qKO8b6NA1ylrwmCNB0mOOiYA?=
 =?us-ascii?Q?WWgHEiXhnYmTk/DkNgJyZRVsKsA/zfMWZwbnispQKb9NmDcH7gaIBMAQaKMy?=
 =?us-ascii?Q?jk0XxlYWInBsDHITBRUnvjLhvWD4BCMpifGghliHXNbEOfTI0a6lHK9kRiHQ?=
 =?us-ascii?Q?skXiBGo2BusuHNijJvWKpW9Q5F4KrLnOxMweq6jRXrAS0YznfaoOHKCiv6XI?=
 =?us-ascii?Q?mSRo2tYOOfhvM9zZq3R7vagcxP9AQvtmdkUEwZRqMPzNx6qL6IQ8HEKcOCwG?=
 =?us-ascii?Q?/MD3Tc2oTE9FFC9lDgKrHwkibWjQr1bloiSklMxkcxbWTuDPuF/POpUYozWd?=
 =?us-ascii?Q?U/Iasn3jVf0EXKzFZy43j+FwlMl4b1zk94cKaVUlHnDc+O/5O48NmB2YXpW0?=
 =?us-ascii?Q?B2r0Wi+RWtE9XpkRd/Tk7DnGibJscABSiWJQCWeMFoxq/UEhlZyhOiXn/xjC?=
 =?us-ascii?Q?mUp1NuSJ+OamkI0GvqqO3e7wwliUy7jaHPGlDbfEYPkhzmmgMFqXSrot+uTB?=
 =?us-ascii?Q?COERVtr3WwiS34nYW7p+CT57ALb/zf3hGmycgmuab4oiQ4+bdowAbtr/50xG?=
 =?us-ascii?Q?uNlMVZo1MqUkn1+nTtun52UTGNJ1P2cllVPeSroazbyj63vX4b5DghxXCW0h?=
 =?us-ascii?Q?UvLy91oy3DR8ZtT6mqkQcWPUNzyV/aop/RCmHnEEH0T8GUhIfAhZFC48k6fV?=
 =?us-ascii?Q?Ogxy0tIvHP64Ge4+ojQzNaSgxg+EFmfEkX5A8M9aN0L/GWnmnPONyaCWZK7M?=
 =?us-ascii?Q?JiK7KMEIUS/4pwPx+9qM09pRLiZg7kDKS9zB0CnRuxXQsE1hOvW7W57xyKuE?=
 =?us-ascii?Q?eOKnDtD3LoF1ThusD5omDpo/8N8DZLA7G0cNAG0dg0OnWZBBFIkemr4Nq+v8?=
 =?us-ascii?Q?J39h9HyarIBSo72JJq1sqPOMz4ym5yvJ/9djNLNrXWuCtGtA98RNyKYzXg84?=
 =?us-ascii?Q?SuNAAQJ5VXho7UKj25snd7a6m1F15nlXPsiZXJCKU//zFWQbz2MjT/5qn2kh?=
 =?us-ascii?Q?G7GiCuQrVB931pphKeCC0NPL4yb0z8ECR3e0rrYO3McEralgRKeUP6obEPXw?=
 =?us-ascii?Q?LOhAVih6NEi0/A8HylMg0nNTAc/T7XVTcPpq9UeoX0YzNJYsFqurzbzFUWGn?=
 =?us-ascii?Q?lZk/SDVLHYu7IdqH880e7gBhaI66a0PDjFfRPaMKNOWLSNud/wkgrzgRBIpe?=
 =?us-ascii?Q?fGsWpgr3b0G1xFo6we4LfTzLr4r3DtwWFsugUVp10qyruZujegnp5PcE5Ixh?=
 =?us-ascii?Q?R5itBy1Of4whqxJGRdU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 06:25:50.7468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53eabbfe-bc5d-42b9-6b65-08de0a215ae3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4154

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
index 48598d017d6f..7e5dceb4530e 100644
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
index db1379cffbcb..aa1ba8db6392 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4677,7 +4677,8 @@ int vmx_vcpu_precreate(struct kvm *kvm)
 
 static void init_vmcs(struct vcpu_vmx *vmx)
 {
-	struct kvm *kvm = vmx->vcpu.kvm;
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 
 	if (nested)
@@ -4768,7 +4769,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
 
 	if (enable_pml) {
-		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
+		vmcs_write64(PML_ADDRESS, page_to_phys(vcpu->arch.pml_page));
 		vmcs_write16(GUEST_PML_INDEX, PML_HEAD_INDEX);
 	}
 
@@ -6195,17 +6196,16 @@ void vmx_get_entry_info(struct kvm_vcpu *vcpu, u32 *intr_info, u32 *error_code)
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
@@ -6214,7 +6214,7 @@ static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 	if (pml_idx == PML_HEAD_INDEX)
 		return;
 
-	kvm_flush_pml_buffer(vcpu, vmx->pml_pg, pml_idx);
+	kvm_flush_pml_buffer(vcpu, pml_idx);
 
 	/* reset PML index */
 	vmcs_write16(GUEST_PML_INDEX, PML_HEAD_INDEX);
@@ -7502,7 +7502,7 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (enable_pml)
-		vmx_destroy_pml_buffer(vmx);
+		vmx_destroy_pml_buffer(vcpu);
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
@@ -7531,8 +7531,8 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	 * for the guest), etc.
 	 */
 	if (enable_pml) {
-		vmx->pml_pg = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-		if (!vmx->pml_pg)
+		vcpu->arch.pml_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!vcpu->arch.pml_page)
 			goto free_vpid;
 	}
 
@@ -7603,7 +7603,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 free_vmcs:
 	free_loaded_vmcs(vmx->loaded_vmcs);
 free_pml:
-	vmx_destroy_pml_buffer(vmx);
+	vmx_destroy_pml_buffer(vcpu);
 free_vpid:
 	free_vpid(vmx->vpid);
 	return err;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index fe9d2b10f4be..d2dd63194ee2 100644
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
index 732d8a4b7dff..be8483d20fbc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6737,7 +6737,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 		kvm_vcpu_kick(vcpu);
 }
 
-void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_page, u16 pml_idx)
+void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, u16 pml_idx)
 {
 	u16 pml_tail_index;
 	u64 *pml_buf;
@@ -6756,7 +6756,7 @@ void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_page, u16 pml_
 	 * Read the entries in the same order they were written, to ensure that
 	 * the dirty ring is filled in the same order the CPU wrote them.
 	 */
-	pml_buf = page_address(pml_page);
+	pml_buf = page_address(vcpu->arch.pml_page);
 
 	for (i = PML_HEAD_INDEX; i >= pml_tail_index; i--) {
 		u64 gpa;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 199d39492df8..6bf6645c4fe4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -743,6 +743,6 @@ static inline bool kvm_is_valid_u_s_cet(struct kvm_vcpu *vcpu, u64 data)
 /* PML is written backwards: this is the first entry written by the CPU */
 #define PML_HEAD_INDEX		(PML_LOG_NR_ENTRIES-1)
 
-void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_pg, u16 pml_idx);
+void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, u16 pml_idx);
 
 #endif
-- 
2.48.1


