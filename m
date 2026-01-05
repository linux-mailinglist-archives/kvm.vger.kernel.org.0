Return-Path: <kvm+bounces-66998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31ACBCF214E
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D0493300912B
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021761C84A0;
	Mon,  5 Jan 2026 06:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tAurype3"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010054.outbound.protection.outlook.com [52.101.193.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698214502A
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767595023; cv=fail; b=aMFxTUVUKPtEa2QBb8TmKMG3gN1vi1wVY85aN7ypGZRdMgc3TWF4nX6nHLkoU/qQstkN++m63LqFkB55PjHUd2dbECuY/Rj6zxQ45tZMnOGWz4dDxpsuMeZcjWr1x7/mS1I1vAj06KbyA7W58F/l0fiiWJqYu50lbIFdZFJZnMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767595023; c=relaxed/simple;
	bh=xaycsXeMWRUG3KO46F0As3dDm5nNiz3K1e4Bzn/GLqk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlkqQmw3DiDBY7xcCKtimwvwj9A/EH+cZPwJR6PL8267lSic3jV67F+AsGrXiKmHfmucFcFD0CQbdWgutTeUiB2NJ3VzzKOeADxQrbM/PpjmPo5o1ZGGxamLfj50zYMsQsthxMLoxNlssarO6Vxar6W74AdpQcN6mVt9Dq0hNw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tAurype3; arc=fail smtp.client-ip=52.101.193.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QWkqL0kLbybmkhXl/+1q/vJ4UH6uFf+wU149xxxPR50uJ0JVrpJ5u1AArFbf2Sovv7Amz6ce67FOOrRdF/jUh/pmAPhLhQkcbJW/YLYR1sVZbin4rdBL/C9OCI6hHn7piQe/JI88O4guBZLm0PEIfEHOy2hNMOLZ6K02kA3vZQ9Ruw5+9VB70JIMcXfLwBkg4L+NzhJbcFGRZI1qwH9ajHaMXOOqy9PMi8OX2PN7Wwob649qB/DtzGZHszLnH5XqV1Q9GfkHm0Q8Utv9hHjTUiEdMxWyEWOo7vAklQeIxHH9U6BcEejwI2A6rHzJTDr8GzM4cYiz0KZnQrp7vfM9ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZozjguTKE22M80fG0O2F8Flay26hl89suam0x+7En8=;
 b=Im4D9XVMN4OVYX7mapgiKJZ1AmgDZLsXbtu5ZGRR9NMzg3WQh6XUMKOClVK/4K+hvOExoxh11d/z9yiVyjJdVJBhMe+TWSvuGMzbpkOHUvSzgmEsijaLxPA0nDH+tK9JqHrQ97LH8JOtD+ChT5JXrQHZbLtlJv3ioNAKvT3TS82z3JIjs4HnSr3SGXVgn1FwU2/b4W1IeL8Nqzdhg4SsAOtmDqnijxfH66L89Mf2B0KSzp5G1r/a9niMATuK4hax4EBtNJAkdJvlwkU0VKVCgopPaXS6jtVH2TWyOkk37drNURs632gji4eGmmtiBiI44Z/u3cQOeRf7mPM6nhrc0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZozjguTKE22M80fG0O2F8Flay26hl89suam0x+7En8=;
 b=tAurype3slsXrq4nJL4ljOugMUgN+E5KVjTlPvlK2ylpqJHD0GOwL5x9xKmt2/n1Gnor7fEuLookWubo2N92trGCpKiRBPw/qkysmveoceucI+6/1TERDS278IQ1JaAnoM/0Dg2mJ5pKl/UVvJQISpjdWIU0BnQMbIO3wM8gN1Y=
Received: from DM6PR03CA0086.namprd03.prod.outlook.com (2603:10b6:5:333::19)
 by SA5PPFEC2853BA9.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 06:36:56 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:5:333:cafe::3) by DM6PR03CA0086.outlook.office365.com
 (2603:10b6:5:333::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 06:36:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 06:36:56 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 00:36:53 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v5 1/8] KVM: x86: Carve out PML flush routine
Date: Mon, 5 Jan 2026 06:36:15 +0000
Message-ID: <20260105063622.894410-2-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|SA5PPFEC2853BA9:EE_
X-MS-Office365-Filtering-Correlation-Id: df4c647a-6dfa-4ba4-0ff0-08de4c24d23b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QjJeLwokXPYU8srJ0OJuaS9GAdN1tqKVp3gG4wHI8QsDXYHEpSoHMYACm4Af?=
 =?us-ascii?Q?+7Q8eL0uvttpq0xwLyoTbfVQqtR2GXpWT7ChbjAnRGReGlZuph8wlkSE8rCh?=
 =?us-ascii?Q?fyp9vjwHgGxgXNA3oCrzMLlp9dZcgCLSy6qxdTuuH4pTZEWv5rb3cIdmB8Gp?=
 =?us-ascii?Q?8oH8sk4PuPIx4MsUYBPwN2BSOmppFJvr6HLRb6TPoaQKgMoJBJtr1kzc7Yvm?=
 =?us-ascii?Q?XpZiG0hsdyYQz1LjJmib1RiePMJ3WhqZ6aAqW/87eRsjhShww21n84oCCKOa?=
 =?us-ascii?Q?w9Wgj250oK1wbL5ncQSKlHOL4W1IE+vBZou6/T9DsA5OiAdBaYlb9Eqco2Dd?=
 =?us-ascii?Q?cRkA2HjMwrIv85XiC12CYhKMylX/snjaz9sNXz87maqRE+BGA/AZDrQkcHk5?=
 =?us-ascii?Q?jj0IDEu3tK9iiMRnQO0/YN0vp9SH8ZAV5G1yKd7yQON2ADT6UcHoNjNZEWBy?=
 =?us-ascii?Q?Sv+eXb1b9QHMR9z+BC6eIh/vuwC7b5JxTW1NEe2L5T8K48SENAeetNKWocsq?=
 =?us-ascii?Q?UQDh+xo+Cfw6CeMx69c0Es40KxnwSW9m9kddTf10/byYkaf0YkZhcsEla980?=
 =?us-ascii?Q?5HqDWbbNjRM6NNtGpZJgoPLS8zD7w8TVxSpbXNhR247EBY5CvvhpIKu/VCQw?=
 =?us-ascii?Q?i0j4Y5Zww7jX6GoIkiWAtjL/qf5otMxwqLxIZuLCMkyOyx9C9LoakMvePwNO?=
 =?us-ascii?Q?FHXPFFPWxAhE9bKFaNa5/dKT+hde0xuIuNPQ68m9QzKWzPCe1+Qjyv79ceqK?=
 =?us-ascii?Q?vslaXtmrpkcGrjgZf5n2hMIOB0rL/sJSmVPNaBaqf9GWc5aT6Aa4X2gphD9T?=
 =?us-ascii?Q?gJj5n1PtGBxddoGlituf8U1e/S63vdvJJCspC2ugtZwsq1rCQ9lJugTreCMY?=
 =?us-ascii?Q?Z6zVwZIr4RLXC1GYToHWXInivjep52aKp61O1uqB2wmjWq0WZqsakLdbBnBO?=
 =?us-ascii?Q?XgpU8aRRhSLQAb5gmiZCAje1LH77brb0SJVYg3MhUd4Js2jWvHMty9VQPjoP?=
 =?us-ascii?Q?Kjlz76/fZiv2fm4d7bVRCYzE3P9rTiXbSZ0+SxU/F8pIetcUdHAlAKBppZaa?=
 =?us-ascii?Q?lPdtGcwVeYHu5wQ7uiHbalXzE/IGYirH7Vfo9AXVA0gnhZ+P6WfhqGNMnwv2?=
 =?us-ascii?Q?yxOl8JyQ5HVUCJXaURhAGXDHGZptVENPBmevCXTKB39A2DRu7h7Izx343N0+?=
 =?us-ascii?Q?r+umYIe7T4sm14x7PrYlZFiUE9w9/pxkR12gvKxeQE0c2D8C7grqmaPVf7bd?=
 =?us-ascii?Q?vKKJmnp8hlkB+fUNnE97Uu2f661cIhbMr98iAc5vuQu+i8KUGXayc1BTo1sk?=
 =?us-ascii?Q?kC7RIrfRZUIZo7ABjk1Ozi8jttbQkmRPTsmuGkF3lGMwD1P9s1jjf2Xqtz9b?=
 =?us-ascii?Q?BhStfQFZLbVvtgWk2fUp1y0Y4Tlm/ZErT9y6549EbiJ6rJhQLKhQ7wlg/UxR?=
 =?us-ascii?Q?iB8evHQ10ICfeO1N1CpRJde5eEDwDUVXyqjshFt5ULTjBpJ91hj6IqXN29Fu?=
 =?us-ascii?Q?7RViegFbsTSPBdhy2gBK2gxXy+d9cuNNXbOAQVhvqVbDiUxJxU6uk2fHbhoa?=
 =?us-ascii?Q?OXTufyREkvv2fTPZS+M=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:36:56.2400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df4c647a-6dfa-4ba4-0ff0-08de4c24d23b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFEC2853BA9

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
 arch/x86/kvm/x86.h     |  8 ++++++++
 4 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6b96f7aea20b..c152c8590374 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6342,37 +6342,15 @@ static void vmx_destroy_pml_buffer(struct vcpu_vmx *vmx)
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
index bc3ed3145d7e..e1602db0d3a4 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -272,11 +272,6 @@ struct vcpu_vmx {
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
index ff8812f3a129..fec4f5c94510 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6696,6 +6696,37 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
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
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_flush_pml_buffer);
+
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fdab0ad49098..24aee9d99787 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -749,4 +749,12 @@ static inline bool kvm_is_valid_u_s_cet(struct kvm_vcpu *vcpu, u64 data)
 
 	return true;
 }
+
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


