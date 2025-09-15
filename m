Return-Path: <kvm+bounces-57528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F0BEB57409
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7263188E281
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 09:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5150B2F3C3E;
	Mon, 15 Sep 2025 09:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ffYLwPXr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2086.outbound.protection.outlook.com [40.107.212.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93F127604E
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 09:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757926829; cv=fail; b=XZWfLtBh/1bb87Ex/yXDAS358+8rYXuwnnuv9kHx6TZco8fILgyvFMPKJsKs7lqgmVB/9YsTVp+jFiUh3f6OnYVSF1n9sl+D/4fC2R+OT9lt7ApgYWwPbwOVj/3UhlfgcsF4LciiN8tXVGn+7zwl7jhgbNzvOjTrAo/9N5SRGH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757926829; c=relaxed/simple;
	bh=cofjAWaCI0OokJEXSHFCg3K9Jgelao8Mvnu0u19YqZQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVitlO3lkok8l7/OJ6tV8Z45VWfADzoNXrUdMSl6NENr1SdGrR1zzTlrNCtnBAZS9VXbnqxwnSHhufOQpLbLafwOuTg6AiC97nNs9IwmIHrRzoA3uV0bi8gs4YVtDiSQXsONcb0Uc8Y3U4hYlk9aPOB4kohAN9YrD9SFY15qIko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ffYLwPXr; arc=fail smtp.client-ip=40.107.212.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X+gAJJiiAYfgqanYIcsMw3pTQ7gh1UQVO1yai4eVa6xKfblRmed+dVUgD0wgCgBTN7tlCQK4mTEUF+bSy/OKuu4nm5QacxvqPV+uoCOTRs1MSOKME2XTMsUZcPws9klW2/BkgPNz87RQ3Q/RPniRLJSNpquIQxqnTTx+JlkDo7ID5aN5mdoy5fcKHduIXOC2QKiDoUzTHlVeqDPACpSx9IMvCjJFSHvg1RUv/TsWUSK07XxGyusYLd20UdPM8oJHtAlfDXKNeYFDRJ4x1wsDsKRObEx4zDL9p7ZUKysxSgcLiGJIbTnY1/BmgwGgzyU/tPltSHA4Cgug8ZLu6Nb9Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=608JU6TfeUnoOpqNP6No4qc0vhdFKM5QRP5BOrN0FXE=;
 b=nD3kkBdICcFgTEFTaV0jc7mb0R80/zaJ+vajKkdQGfhlYu8854pt8Ad9Zn5rodQT5V8mD7nNN8h4zDUDjeMaHMfLdcx4wNdsSedhVCC5tMnafxH29uxy6svfPpk5jrZqpzoMr9qqK/A9ZPoROgCLEOv47WWS7oog7mBK3RAyUe20j0t0SbaDMY9Plg4455zYmf0oEtrFgWjc1cE5bdyd4ySZ85uJwGcDoA0SoFi/RIMX0UkxcRI3POMd8/JE/X32nHGeah4FgR+v/Mvck5hmOyIqAyxFD/Wa14bim+hwoK0vckaibbg5HL/QG4LQDx/d7dgdSbGgqXhiz/uvVJpJyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=608JU6TfeUnoOpqNP6No4qc0vhdFKM5QRP5BOrN0FXE=;
 b=ffYLwPXrYhW1M5FAI180r84Kt+TwiFiKYoLraMlJI9ier2TLOreVNphfLdYHHgk5l1GehEOx8yrihjL6derY982yRc2E774pr6+63hzihjAoy4Hx7tA7J5bfK7NyDzADX/shL2vjYEg0w8rDPcmeWlYAGLOGizy5CPTkGoM29CY=
Received: from BYAPR07CA0099.namprd07.prod.outlook.com (2603:10b6:a03:12b::40)
 by DS0PR12MB7558.namprd12.prod.outlook.com (2603:10b6:8:133::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 09:00:23 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:12b:cafe::de) by BYAPR07CA0099.outlook.office365.com
 (2603:10b6:a03:12b::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Mon,
 15 Sep 2025 09:00:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Mon, 15 Sep 2025 09:00:21 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 02:00:01 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v2 2/4] KVM: x86: Move PML page to common vcpu arch structure
Date: Mon, 15 Sep 2025 08:59:36 +0000
Message-ID: <20250915085938.639049-3-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250915085938.639049-1-nikunj@amd.com>
References: <20250915085938.639049-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|DS0PR12MB7558:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d660284-3638-46de-1fe4-08ddf4364cfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KBkWRrGvtGJ/Bf0D1tXT8d3JLBZpw4AAMHvI28WuRcN952Z7zRI6X3594aT3?=
 =?us-ascii?Q?LnldGzsHQjXBXlS8iiRTiDm5bOooUUHyDCHQsF9Gi/rqkC7aJ+509vdmEP+V?=
 =?us-ascii?Q?qerVnl9Hlem6udtQL9vVzgavYOsHdJ0S4gCQocb31moB/i81StWEyuXgCU5L?=
 =?us-ascii?Q?47DeFb60qfvM3aL2Nn0w3hZJtDlW4DlEE3o9//d0oqoxwbCmFYnJ9zNm2WVs?=
 =?us-ascii?Q?lg4sOIRoBIOjf8Xxj7xJ5IeIBBwGm5slIyINDTmdSL9vfJxlsEutUwS/45BB?=
 =?us-ascii?Q?+VrO5oXn6oacEQ5e297+Rg5z+ezYrxjxHaJPM7VAJUb4jCGvPmtLXW29rOxc?=
 =?us-ascii?Q?WrWbPWexB/IwS6ZElULYGcanZSEAirajN/y87L1z5DTP7aTAjWsob7ygZqds?=
 =?us-ascii?Q?2cabSaqqLmndzmabH7QpruRc1lx/QBkEMehcwY+FVnN9sO83XIowAr0tCaOI?=
 =?us-ascii?Q?CRrfOCw9uxL4whKaGqBRF8kSJKzXKwwi3COJUdyOzdgAR10EKDMD3R26v84S?=
 =?us-ascii?Q?2lNMkN6WqquYsDdrLk6pIq8uwNnWqb0r8XEMTcvQCQhllmL/iMeSRYIL7xkL?=
 =?us-ascii?Q?IWQ+9Qg4/CSyRhlyCQCU2p3HZmWhSoGA3hYiF3GLI7eoqpW1m9Zod/VvsbBJ?=
 =?us-ascii?Q?Tq7UzGgQvr8D76jTuMCqXj3PHaxbYwXCu1HWsZhgjw7BWsqwiBb5MI/Vhl9i?=
 =?us-ascii?Q?hC89kFNiAtWppGSomC2YFzaL0zKR9EsAkY6jljV/rUJLt5UcoKfk5L9IMkWL?=
 =?us-ascii?Q?+w0U0x3LQgIGAoauWr3OzSDpASXHXAnnd+Sfj5lwzVBKdqB1yoX4wqG3wF+A?=
 =?us-ascii?Q?8LXhU6+TAu2gVkW7PsVdXqDQ4SoJ44vnSx75Oecbn90+D1b9tmpi5WDOQgGr?=
 =?us-ascii?Q?hFdGCve2ALhK+cbnpDXB+RtKi6gfIWCttoqsQ0EQQjRuyWxB3i8C0iRfR5vu?=
 =?us-ascii?Q?8qWUYuJtSwvvM3WSbtSb/3ytgRQbtH0Tt5q6MOjb9SJ5pQ350O5+5DxLzBag?=
 =?us-ascii?Q?jfhRkrlae1rkGx6T43pPjZTnZ3fwAKAVBPKTt1CFVtM4gWwQA0pomo1X4OjI?=
 =?us-ascii?Q?8d8d/PPn2ei5xCmdM197+sSLISDmsvGaomFYgTvHdOMfohHPjfNTVPnkDAPj?=
 =?us-ascii?Q?E+JA0xWbLHw1rl5eqtb/zrA1Slg2+pMZmiRBr7GQrtv94bXlAU/6xaSQG92a?=
 =?us-ascii?Q?UWUfvro5zUuqU+FNH2BHonoHYKXozulujEm+28wA/yUslItGpHepYm3tCp7L?=
 =?us-ascii?Q?p/QuFUuLy77SVtB88Y7QO1MNdeHmlLoces8c5UxlBNXyV4sNxOgf/1m2wK/z?=
 =?us-ascii?Q?b4URfA5RUacPOrytQaKorAv77Q2sOKCntt9OwXeLqClWKPrHTzht2eLokwkO?=
 =?us-ascii?Q?efZPc56D6gRJe+QcZZp95ZF0JCltpV1fMgoaFKYBcDU9Gt0LuuXskVE9dWBG?=
 =?us-ascii?Q?zAMJhWMubrkWNAcwVFXqC49tPdhNBDubcW4GacabRcV6YA3uenpS6XPKip7e?=
 =?us-ascii?Q?qhpc/lizXLSKmtdTK0eWBDZIdSvZtsj2Ja+c?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 09:00:21.2018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d660284-3638-46de-1fe4-08ddf4364cfa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7558

Move the PML page from VMX-specific vcpu_vmx structure to the common
kvm_vcpu_arch structure to share it between VMX and SVM implementations.

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


