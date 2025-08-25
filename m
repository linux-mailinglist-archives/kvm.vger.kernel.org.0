Return-Path: <kvm+bounces-55630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0836B3459A
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:21:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D60EC1890073
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 609162FD1A9;
	Mon, 25 Aug 2025 15:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TqhUrXCj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DE22F99BC
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 15:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135234; cv=fail; b=t8OyQb39deNh78tCfVGhOqAUE2sdHqrr8AlX/Qkr7lEhuFHfRfh65j88HgICa+R9ggM1IQM2raoOe2gqOTNoY1Xyj+wyhNnmYNzUJY+2YmNQ9zJgAIrypmLhS+AmWxzT37l75pvwZLL1jeqmIRlJWfFLgMCxOv1Whh+zTME5dLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135234; c=relaxed/simple;
	bh=sGPuIfAckbM5efKVloPs0UTjsnoHgyyDyM8+x6MZaZE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J39ck6LrRosP09oc8cE8KH3bR1chJQ1HRkDStuZszuB45l+doWr5/PpTKpK7KCXVSFK0qph/e4tlTk0jei2KPheJXhYcpbtxGuK9WqTGp/7bedIW446FQl9IGYboL9rnkaH3NEPrVjreCVRUlmKBifGY8DGtVHGQqY+dAFTcpeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TqhUrXCj; arc=fail smtp.client-ip=40.107.102.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a2Dl9cTpGTHUlutRFtzcSv5SoOAXFU9sf5FpLHqh67F1WG/2jxYSaXJ3LERD0r3fkL2KmG8gFpg4gjE1V6CLplEtgvRbxg57ElXdaLt4OC4RhG2q0Fh+KYyJvSeymX5l5/Abq2XH8gWGTBNsWqAsYl9EfMfLwu7GX9pQNN/p98xHXJy//N8SAkpyGzr4ths+NaA5VfLoJCPEIeqKRjSjTea5xflB5MkNm4WSPnbeweWnquRM4ZeaEKrRmEqj7atmsGQLdlOuT7JCP22FDC/vKdRCrRYIkVp+3Jw4QRioRdQoGvLBNoe/OBUD884x88x0HYZ304qUcUnDlYnGQHXdwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WP18Avk+9a6TrFV8AbuA/geXiaZBONNPteIp+NTcY04=;
 b=JLvKcBG3ycLEW7F/DlJkIKUBfmK758NTlHoYzC7Tv5TsXDjEfZWhISGaZ4GMZS6v5z5eodt0VfoOAlgX+Es1/PqETXnuqyJ5wbOPMS7J5qFDtoJpZQaXDc6hO0IBiobycgLUeqP88Pk9KatCinkpPhy3JWbc+LdNZcF2H3VaIbNIhYIIO97bL2mSbal0kAabKla6fkvIIevvzBlAFTmT5zV5uz5nFuv5ZabJpBh7TYP3Ly1Lm/d1voFPCNqvu3/kFRYFu0aHBHuZWQOz25dVez9jWDkuVqERdrV8rVsK3r3+pbZdP+wYCd3qeNPlU1YpgOqlAi9y4rBX5FFCrqiE3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WP18Avk+9a6TrFV8AbuA/geXiaZBONNPteIp+NTcY04=;
 b=TqhUrXCj3fS88aacR4ipHdVlVJwp11WDDld+k8h81Ka7ynK7SHozJ/NpQMWvKsMjjs8eIlZbAAuTvsUuWQbG4vGeYtSzwZZXyxlQtmp1GbsAS7M3HIkz0DbcnxIwn6PmgSvHlGAr5k/7aIil3tRgtCozERID0/tT43PnMlsmNhs=
Received: from BN8PR04CA0054.namprd04.prod.outlook.com (2603:10b6:408:d4::28)
 by SA3PR12MB9226.namprd12.prod.outlook.com (2603:10b6:806:396::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 15:20:28 +0000
Received: from BN3PEPF0000B06A.namprd21.prod.outlook.com
 (2603:10b6:408:d4:cafe::b3) by BN8PR04CA0054.outlook.office365.com
 (2603:10b6:408:d4::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 15:20:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06A.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 15:20:28 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 10:20:25 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>
Subject: [RFC PATCH 1/4] KVM: x86: Carve out PML flush routine
Date: Mon, 25 Aug 2025 15:20:06 +0000
Message-ID: <20250825152009.3512-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825152009.3512-1-nikunj@amd.com>
References: <20250825152009.3512-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06A:EE_|SA3PR12MB9226:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e72c8f-2f26-4f4c-af91-08dde3eaec58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AlYWs8WZD2Iz8mU1iiS4KKFWaYdzu3IygfKLnOIiz1+mUMQlIwxZLxY7juL4?=
 =?us-ascii?Q?CNPwJKgwbEVOA1dAIq6yAo6RHkySdVpruTALTJv8fXVO2ELyQFn0jWI69WpQ?=
 =?us-ascii?Q?IfAgZffA1S+9mI7Suf6jDm8CNnKvUHXe9fI3gmXeXnQflVD1aP0ZkGfud/OY?=
 =?us-ascii?Q?tVksVDJ+NvGpsPBqG0oMVRPAZUqicHJXic6Ej+Wkr3NgezOD1v4G+FXA1m4E?=
 =?us-ascii?Q?Tc8WcDTkzUKt6Ba2yDfLyMi8Vv6PyaKvx2y/bSBcDFJZzrJ/xIBnFx5u7ONb?=
 =?us-ascii?Q?SZGqgJKuQYx2uYWK8kG3sqpFa1hAevUxRU9E/onQsSifFNVA7Q1spu2ZRxcp?=
 =?us-ascii?Q?vJestUZNtXZ/VyHpM9adXznJiJggt/0W9qZ7DKDWmdkY8zej8BHU/U9zTTjc?=
 =?us-ascii?Q?rNXM3qKiv3stx6peLSS1hrwC6hoY61Hoi23FCCiW28zKdyDjG99SvmeIfYKQ?=
 =?us-ascii?Q?MOSVyrM89SUgYDZYrsAbE4yJ+UkOHVbRjMUWkREaWpdyVcgC6aV1gFMArsKW?=
 =?us-ascii?Q?a4NXAOMShd44pBJnnmUK6jboAebVNP5778MRGB5zK6JAKwWia6xO/+jF8Yx6?=
 =?us-ascii?Q?ZPjyQ/XUlOJYcM5OlwBj01Q29qR2Vz4a0QkSHEYjJsmViPO7qB+mltpfjf/P?=
 =?us-ascii?Q?L+hEBPpTIznW6N3VrVIjMZcPoG5CIjYyQy1BvCmkDs5C8NROKjH436bf2FSP?=
 =?us-ascii?Q?6OK/e9Az4o0sTA3fFVmHlnW07RkTq5OhuvtcwknC+L+YhlyJmHxgm7ceuATy?=
 =?us-ascii?Q?F+UuuP66Z4Pw57k1dDWc1xZD+82upofMQJ901mWxmfcZkR+ioE60Y30nIDxw?=
 =?us-ascii?Q?bY/WRygdP5L0Uszm20y9XzbLXOZixq8OLYOeW9MNenoaMxhH2v3Zfp7UhtXg?=
 =?us-ascii?Q?Bog4AKQZhnZ1sKYGOKeVn5JOcfMlHL3r2QIjoa9ishgIM7fkdV7GEcWXgK+o?=
 =?us-ascii?Q?bL0wMEmm2myqZRgN8Aahq2dVRl31ECOq73A/kEJeNqwAYChaQnhShpk2TzvP?=
 =?us-ascii?Q?MNJPwFjPLWok9n94RcoVFavOIcWAmcz6bz/8X55G6IRtZsXHJicAmkZd51zD?=
 =?us-ascii?Q?5ezQtSC4wF1idsNSwUkvabff27HRdLrF+/1u7OmOAc6L37U7iB0vALiDlMK8?=
 =?us-ascii?Q?dLXgFw3rT1aAQtGoaBN25ybi8nKEQV2EWjeUGrvAXqQf5hE4b+c9AnAEeU3o?=
 =?us-ascii?Q?xvIhelONIbQ4asInKJplWQom00q/rWGAnJissyP2L57clyWYO+jJxjVIPUpP?=
 =?us-ascii?Q?e+Efxdymw/2muoEYKfD4Dwm9Zsuhiuucj1CfbqySK/Y15/HhgP2JvsJwFi0c?=
 =?us-ascii?Q?AInwy5ucFlECrW9z/NiiI5OG6kSUQZR1xsinpv1JRI94X7SyqKbuPb2n3bUP?=
 =?us-ascii?Q?vWdRXuIpwyZxV7IEl8OSvNNAo+uRI3KQTd6JLkLuWqf/2TRAUkA+AjF2cDna?=
 =?us-ascii?Q?gwjRuO/ySGa5Tfk5y6yaWK0wHlU0ICbLSxaPAEta/XrFtW4f7uPnxQ36pUY6?=
 =?us-ascii?Q?zzR95YQ+s+Cqhao60nXyz+HOhigK0Vf0uXru?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 15:20:28.3144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e72c8f-2f26-4f4c-af91-08dde3eaec58
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9226

Move the PML (Page Modification Logging) buffer flushing logic from
VMX-specific code to common x86 KVM code to enable reuse by SVM and avoid
code duplication.

The PML constants (PML_LOG_NR_ENTRIES and PML_HEAD_INDEX) are moved from
vmx.h to x86.h to make them available to both VMX and SVM.

No functional change intended for VMX, except tone down the WARN_ON() to
WARN_ON_ONCE() for the page alignment check. If hardware exhibits this
behavior once, it's likely to occur repeatedly, so use WARN_ON_ONCE() to
avoid log flooding while still capturing the unexpected condition.

The refactoring prepares for SVM to leverage the same PML flushing
implementation.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/vmx/vmx.c | 26 ++------------------------
 arch/x86/kvm/vmx/vmx.h |  5 -----
 arch/x86/kvm/x86.c     | 31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |  7 +++++++
 4 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa157fe5b7b3..a0955155d7ca 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6107,37 +6107,15 @@ static void vmx_destroy_pml_buffer(struct vcpu_vmx *vmx)
 static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u16 pml_idx, pml_tail_index;
-	u64 *pml_buf;
-	int i;
+	u16 pml_idx;
 
 	pml_idx = vmcs_read16(GUEST_PML_INDEX);
 
 	/* Do nothing if PML buffer is empty */
 	if (pml_idx == PML_HEAD_INDEX)
 		return;
-	/*
-	 * PML index always points to the next available PML buffer entity
-	 * unless PML log has just overflowed.
-	 */
-	pml_tail_index = (pml_idx >= PML_LOG_NR_ENTRIES) ? 0 : pml_idx + 1;
 
-	/*
-	 * PML log is written backwards: the CPU first writes the entry 511
-	 * then the entry 510, and so on.
-	 *
-	 * Read the entries in the same order they were written, to ensure that
-	 * the dirty ring is filled in the same order the CPU wrote them.
-	 */
-	pml_buf = page_address(vmx->pml_pg);
-
-	for (i = PML_HEAD_INDEX; i >= pml_tail_index; i--) {
-		u64 gpa;
-
-		gpa = pml_buf[i];
-		WARN_ON(gpa & (PAGE_SIZE - 1));
-		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
-	}
+	kvm_flush_pml_buffer(vcpu, vmx->pml_pg, pml_idx);
 
 	/* reset PML index */
 	vmcs_write16(GUEST_PML_INDEX, PML_HEAD_INDEX);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d3389baf3ab3..4494c253727f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -269,11 +269,6 @@ struct vcpu_vmx {
 	unsigned int ple_window;
 	bool ple_window_dirty;
 
-	/* Support for PML */
-#define PML_LOG_NR_ENTRIES	512
-	/* PML is written backwards: this is the first entry written by the CPU */
-#define PML_HEAD_INDEX		(PML_LOG_NR_ENTRIES-1)
-
 	struct page *pml_pg;
 
 	/* apic deadline value in host tsc */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..054ba09d3737 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6417,6 +6417,37 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 		kvm_vcpu_kick(vcpu);
 }
 
+void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_page, u16 pml_idx)
+{
+	u16 pml_tail_index;
+	u64 *pml_buf;
+	int i;
+
+	/*
+	 * PML index always points to the next available PML buffer entity
+	 * unless PML log has just overflowed.
+	 */
+	pml_tail_index = (pml_idx >= PML_LOG_NR_ENTRIES) ? 0 : pml_idx + 1;
+
+	/*
+	 * PML log is written backwards: the CPU first writes the entry 511
+	 * then the entry 510, and so on.
+	 *
+	 * Read the entries in the same order they were written, to ensure that
+	 * the dirty ring is filled in the same order the CPU wrote them.
+	 */
+	pml_buf = page_address(pml_page);
+
+	for (i = PML_HEAD_INDEX; i >= pml_tail_index; i--) {
+		u64 gpa;
+
+		gpa = pml_buf[i];
+		WARN_ON_ONCE(gpa & (PAGE_SIZE - 1));
+		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_flush_pml_buffer);
+
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index bcfd9b719ada..23c188c0a24b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -699,4 +699,11 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
+/* Support for PML */
+#define PML_LOG_NR_ENTRIES	512
+/* PML is written backwards: this is the first entry written by the CPU */
+#define PML_HEAD_INDEX		(PML_LOG_NR_ENTRIES-1)
+
+void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_pg, u16 pml_idx);
+
 #endif
-- 
2.43.0


