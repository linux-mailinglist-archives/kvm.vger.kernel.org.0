Return-Path: <kvm+bounces-57527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DECF7B57407
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE2081896053
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 09:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A6F2F3C11;
	Mon, 15 Sep 2025 09:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OuFfOeqc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7D32F2905
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 09:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757926808; cv=fail; b=Vnx6JTQFrBayJpf2/9S4mAf9so7jdkolm1XwhLcTWlWm8THCQ7dlvoP9dJPhSuiTog5VAJ+jqfy3IRVA/+z8ReitUvkfUANIS/socTitd4OTz1z96fQrNIGQz1rmh6lIDsfIDmqAygLvK30andjcBSv8G2I9jkg3gAdXY37L2bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757926808; c=relaxed/simple;
	bh=eS2r45M+EiAAuKGfg7WYyMHu30r9CCcBGdB6FkerfLk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DZM7K0oqODW0ANdFidwg06LICSejb5F7JkO6mfcqXod8eyGyU8LOmJ0VaVCECrd4TWg+yt9dH6VVgfRFy6DiWAE+KASYKHVpKDwxE5cZYwPBjH+d8/vVIXCB8bV+UQ1A5jAWQLeeIiU37snQpJ9eyohCSe+y/5zarhgn/24RU3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OuFfOeqc; arc=fail smtp.client-ip=40.107.244.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CvQ6iqsX5grLbno9wjcD5odEmYjhA1X4gVYHNE1kXCbLTWh6o7nDkax/vaivlO4WMYEZMV/GaFvSQHP1Dm2j8ohvMjjNRNe+wEGeFwCehYxHJG51O10oLZns/hQTAatOkxcn7iLntvfCqc+8JE4GNs5+HFg7xnljoXWWTORWklino8W+wl+fXZ1Wq+qD9HRvUFGpjz8+dGtMLKaeEC0SXmkY6SrCMzJdeQy1XVLhIPPzChOjEYXEmtHJrFAf7OBtquQ5tsMiI6X+HtJivCCmjuosBhoml+5HxiWQy+0C5OksXj8toXsM99TZfhzhCp5WvZeg5KBk7UUUxcl2uGxEqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jxbwa0hAmcFaPbS95UAvb2TsjN/oPxjNoskHcgkdWXM=;
 b=djfOn900k2Lt0q7EREBS2tz/ys/A5+Edk4OIBM5x0Ciu+E8dWWBSQAcbrMMah6DhOeB5eh+scJbQDZym7gpAe7LWkY8G76ReB3zQFGZrmbkKyGUhoMoXFX5HjzLoSHQ0nuQulO57CxnEt7CHt2Ad1qGki3OYw5OhWFeOMHw423zcF5wnl9JOh19VmrDqx9/64gti7dSI/S9HgLhda5b8nQ0x2gJ2pduBcajVzCL8I8sIakvQfay2zXWIqUpRJ+nUve2FotZJmXlTxsQMoef55KYXSalfonxCUb7/XrXFobpaQ/nS2LfVjn/74B5GDq1a9LTKzi+xxIcOYpjobksQMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jxbwa0hAmcFaPbS95UAvb2TsjN/oPxjNoskHcgkdWXM=;
 b=OuFfOeqcIexAlvPxas7TsOMDkRJand2L0GUZrxW3n/rNn1Pfe3QKC2HmqyApTXIJid5W/HojxIKqX7GmyCZp/ywOBxkEWzmYLlrGOrZBFZq7cjPH5i8J8g34iA1VRcZfM/DqnxBOuINNSRK1t5rvEeoVyjDF4fgQwzmCSi4qBAo=
Received: from BYAPR04CA0020.namprd04.prod.outlook.com (2603:10b6:a03:40::33)
 by DM4PR12MB7696.namprd12.prod.outlook.com (2603:10b6:8:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 09:00:02 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:a03:40:cafe::3b) by BYAPR04CA0020.outlook.office365.com
 (2603:10b6:a03:40::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 09:00:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 15 Sep 2025 09:00:01 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 01:59:57 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v2 1/4] KVM: x86: Carve out PML flush routine
Date: Mon, 15 Sep 2025 08:59:35 +0000
Message-ID: <20250915085938.639049-2-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|DM4PR12MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: 60a8a209-8647-47dc-4bbf-08ddf4364171
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F/W18utOUQvnUHJe14NQh2ICyTnxY2eFDHBmMXPwRu4bRKb1toHUTRPcBif6?=
 =?us-ascii?Q?ZLir8Edw+rjwV5Mt5BJQie4xvyGXcyvyA8EJckGBcnImkKuBnDjdfvLnQut9?=
 =?us-ascii?Q?zvyCk/JM22d35gfGI1XmhIiPJ8oEbNLnD24XCgdhIdmg/2jasTce6aH4kLDS?=
 =?us-ascii?Q?wAkeoW/h6Z+k/Ex+6bIA7TqiD8t0YCrAx4qU0bD2Jcu3cn0Dqrnl7+QQQP41?=
 =?us-ascii?Q?+2MrXFDjC2173C/sbfGDmZxkwVFoyIgys9XDAJ+FyfqUzzmxFYYzAJzIU9Ci?=
 =?us-ascii?Q?GKstgcKh6Kltuc2CmR9Gmqu3GUIx1dGkSB2oOjweIP85kiOjTVqR+Djdd9CU?=
 =?us-ascii?Q?Dv39dcdY+gcGd7rABeqRwgvm9vpkq4aVFRlYNPj0oxXHB8TkH6Uuqb/SPb+H?=
 =?us-ascii?Q?sedE19A4HnZBoucxvdszz1N4z1/eFi2GpaRuVrfB1N7n435e/B4FG1S0Go5m?=
 =?us-ascii?Q?6Qu2YL+Zv5WWMlL0B8BiHUdDCiLuGV+D4u1ID8PqiRu8RT4shgfeIov2Vs9S?=
 =?us-ascii?Q?6Z2fkIvX1XmylRAxCYvYJd0HSNwfqYwEdWW4m0LO0dhUitvWscaKPdEznBUf?=
 =?us-ascii?Q?OTnbmt+oB+SifJ6rbTpat0IkhqhN6jZcX4M39cWv+SfjthqONqosr7BUEXaZ?=
 =?us-ascii?Q?k7fdPOHmWtl7zorbh79VDO5v8m49sMperMyqz+a7dZAjkL1Fj0ctL2Hfx6BQ?=
 =?us-ascii?Q?Aky6U5yoPOQmV6OA4DxHS/nGMx7zgLkbmoYzMVbfDGiGXuwTPq2dtBSZcRyf?=
 =?us-ascii?Q?oP6l82Y+1hMrqmGg65eGjfxKVpeRf46DwT2QL3YiMpAkoX050TeiB7auPk7h?=
 =?us-ascii?Q?t3ajedmb181JGlS/A8gDKIvaEyrgbxdIen9b3jISJfdE6M3cgZmzmKEqsO4d?=
 =?us-ascii?Q?qjTCV+lV4kcdoQQEz+aZwYccmbkQOqxXIDRerL6nJQZ4yFG1pgbJ8vEpQg1R?=
 =?us-ascii?Q?fLAtbgAVmv+W4HKqtLOHIzUTXsBMYI0KNU8b5nA5MlRgfbVa1ck8ZBOWGVAX?=
 =?us-ascii?Q?S9Jsc/6UYbO9dSietqYzCTrMgn/zwfXRi995ZjtRcwJXN0DtlfsrRROd0cDQ?=
 =?us-ascii?Q?EGoxcmE8siU1cJ3nBWUk9oZ4RIpMuNMrbs0x2wiFProg8OH36Ea5rw46Tkqp?=
 =?us-ascii?Q?bwLIOVPLk4dRnxoeaHcglf4e8/Wrt5aTVXGT4p2uT5H7IzrfgRx2a2boHD8q?=
 =?us-ascii?Q?euvZujCITwOxzBGg0Hy6mrH+kuCmdE1wnSBjpieOwrZBUxuxau5z4nNDgw/J?=
 =?us-ascii?Q?KzksgXicW30cQcptfEaBWRDrwDHGzGYE4epJRzzSn2w2QOWLVF6EaW69qDk/?=
 =?us-ascii?Q?E8wLCvBkRKEZ+jVA/b/bZlqLCtSl903c/Vdh9IhQJXPPMRgdpmhgaY5WzO2j?=
 =?us-ascii?Q?SPdDwckmWwYlUW6Qqi+FU2KZNOe62vtZ5xcKMwvVdMpKJ+9uZLerhai0NxYS?=
 =?us-ascii?Q?/XUiVzqdXmcIot2/s+onEXTrBDVbgg/rviLWzefa7y5AhwINMHrFCEhvtMzH?=
 =?us-ascii?Q?+i0PqOmDQkS0t6zmQHhuwObGiFpGPrwHq2Bk?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 09:00:01.8497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a8a209-8647-47dc-4bbf-08ddf4364171
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7696

Move the PML (Page Modification Logging) buffer flushing logic from
VMX-specific code to common x86 KVM code to enable reuse by SVM and avoid
code duplication.

The AMD SVM PML implementations share the same behavior as VMX PML:
 1) The PML buffer is a 4K page with 512 entries
 2) Hardware records dirty GPAs in reverse order (from index 511 to 0)
 3) Hardware clears bits 11:0 when recording GPAs

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
index 33fba801b205..123ebe7be184 100644
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
2.48.1


