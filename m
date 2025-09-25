Return-Path: <kvm+bounces-58722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 659E3B9E944
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A9767A2C43
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0E02EA49C;
	Thu, 25 Sep 2025 10:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2rlXxGux"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010006.outbound.protection.outlook.com [52.101.85.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1E72DE1F0
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758795079; cv=fail; b=i203F2HzRdpiEoc7aYfPZgsZXc3sRm7F35KihJ5cWMX9peRZ2J3CdoDRbtCkDA//NCMoB5ju/KqobQ84vKKVLlcWQDCnM5xAtOEwPJ/KAZbjl433gPT5qU2gZFLUuRAkaO0BmFUFb8udCUWXj2waHCBcv/lTm3Kdm9NuB4KuQV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758795079; c=relaxed/simple;
	bh=eS2r45M+EiAAuKGfg7WYyMHu30r9CCcBGdB6FkerfLk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hSj0nS5d78G3/w/kVB3IkGifrUlMhpYLP3UGp434DNYys4SWpS1sbYBU1/HstdUcLuO3eStylg9z9qwHdotcjlY5I965bjWFLvuDWVcRV5WkzkK27oUtrA6TpXy0yJdbjhh+T3TIcVNT9We8p2pnCplI/Ztu0FsCiCg/izspoLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2rlXxGux; arc=fail smtp.client-ip=52.101.85.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Il/4LZiBjZ/ss5Y0LL10U700BsP1DbgO4ZHh70N+52fZYD+f63/CXmHZbuS+OwcSdULZnacU6EwoD+7iNc/1L00SBECm17WD5UVUaRTFkW+3ye2cUp2vmXlpaWCtbwVWBVfVMuhQZ0TzYPsHgoE3JQyUqkC/DgElOmaJ3bJ8BAzSv2zKdCNTfrYxzHF/qiFbTOR5wtbiManQrMkIA6jQ6Ye3xNfJIZllMQIYqFWMPKocvyBSrczTVMiuimcUnSQ6W6w2gb3AtnAtripPsK18owPm0RwwWU3O/eWtuSHyVOudG7HQvNqUnG5y5LQliWfkTyt4TVqcabA+aBRgt8c3dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jxbwa0hAmcFaPbS95UAvb2TsjN/oPxjNoskHcgkdWXM=;
 b=L01vPFBm515+zQJKBhVohdx6q7jzCcXloAhNZEND1ASdWZjOsdG/lfR78FuopoZxPQbInxtgaaa/72z/VhD3AT1tPG9lz8+zn1GtnlTQsDBB0UKwc2pzyhXhz3A6kLc+MkmPs6Ud4jQCTfXoSc6UTltO6uG2QfmfvRHevnQq0OH/5CGubU0UGkjvSaNh3x4YzTG40grOvCzNZsMxGmBCOd8eJad/ZjdDM24Ve006ktdnVVuldU2HfDNyBT4o4UguHuCZ8TRDehR5DzoCxa9kZp/iCDXE6FVtz5qG+jINHW0vNakZwAe1jnDPEseI1bjjhXPBPxZ74Ba+qCV/NSKtEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jxbwa0hAmcFaPbS95UAvb2TsjN/oPxjNoskHcgkdWXM=;
 b=2rlXxGux92D4UXSv+cVbxP3MouE5paJscq/ypDxv7wxC8TK4FBrg5D2AN9SzK1MqBtWbt7v+12o0360YImpi+KJv1wKelurNbE/jXfno+G3kvJLtUw7aqPcHsme86s4uVGKPFlESX+BlIxa0gF9DUG2IU75nd3UUCeEtt4OmkAQ=
Received: from CH0PR03CA0350.namprd03.prod.outlook.com (2603:10b6:610:11a::24)
 by MN2PR12MB4421.namprd12.prod.outlook.com (2603:10b6:208:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Thu, 25 Sep
 2025 10:11:13 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:11a:cafe::30) by CH0PR03CA0350.outlook.office365.com
 (2603:10b6:610:11a::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.21 via Frontend Transport; Thu,
 25 Sep 2025 10:11:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Thu, 25 Sep 2025 10:11:13 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 25 Sep
 2025 03:11:10 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v3 1/5] KVM: x86: Carve out PML flush routine
Date: Thu, 25 Sep 2025 10:10:48 +0000
Message-ID: <20250925101052.1868431-2-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|MN2PR12MB4421:EE_
X-MS-Office365-Filtering-Correlation-Id: 6969d9b8-35a0-496e-aa6c-08ddfc1bdba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OczcPG665KAUBFZ5iHFwMRf6xyLXrMw3Ib1HKh6bsg94Q6i8mKKq0YTaLhVc?=
 =?us-ascii?Q?OdJ1z7R8hBKqQwTOxea6VN0Qo5M+rAoXiT24FQ/zm/wXKW/mzoDA3kDBuSCF?=
 =?us-ascii?Q?Ahps0XibV4DKQqkKc3heqOFngNic2GRqxdGMdu/5wYHAt3v8ZTum+KHLi+/0?=
 =?us-ascii?Q?Ucz7E72VFikQKxYLPWlT8O/TUpveQqH0IIkYWM5g1SCr7g+0KvvDwwmbxLEq?=
 =?us-ascii?Q?TKlZSOOlXfX2d9GrulbSrnJY3sWOGsm9wGBbbO+yfao4Cl9hgj2ZNud6ZvK2?=
 =?us-ascii?Q?Q0C4qpQIh843ht/XsWBJjjRoOeMigr0BgtcRHGNQn9Vd8768EGWVAEMiNhmZ?=
 =?us-ascii?Q?YEmzcWjcip6yuvSGkaLjgGZrEI/2h7123/wpPAQyU9b+rsQXWjPSO0778DD3?=
 =?us-ascii?Q?39zeBbJLsq5OxIAX91IoANvoQo0oER3JoioUFXtB53TiheRBkg39Wb5I76fN?=
 =?us-ascii?Q?vmEoaSSf8xJU7kmW+dXuz1qhTzwLDhjIp1FwFEpv7Dn94PBNgUuJlO2px5ND?=
 =?us-ascii?Q?zee+q6vKlc1LxrkO4ZsMuGcplgi6WAx8LwdB93P70fJmfc1Z6CTyXMN8Uvh9?=
 =?us-ascii?Q?H68UQNIWhIWRY36At2JYoiamkSGdJcNy+l6LIKsx4h34Ofl6KWCqrka7vrKN?=
 =?us-ascii?Q?SvRQFJhE5cCJbXp1UGx5eBZAKinc9OA8QhfercMfb8CVMr8dIXT/nk2Axc7d?=
 =?us-ascii?Q?Z6JFFjNpQ3HiW/L2JPUnWWkWIOUNrUi9fB9Ln+zK8S/bqBWmOsBLKe2Nhh8o?=
 =?us-ascii?Q?l8sbT5YVArPkfjXTnRVwjNSVCVKfdqf/ZItsKdDf0fInAdHUEIb9rRi3KPsX?=
 =?us-ascii?Q?9mwr/ecTZEJwXHKzZa/EjUjGZtNrKIgh4FulXvcZEoXtbrGGkEftkOvebGAr?=
 =?us-ascii?Q?0JUurZtv9RL1iCT4u9uCtgpOxFtcM03uxNWBzqXn7jeixUBI9GyjvjGoFwcI?=
 =?us-ascii?Q?XOvsPnP9zFok56mBrggvOKnddpMYwL8VVwoonk+EWzSrDh8FxFuHorNA5Xr6?=
 =?us-ascii?Q?hyTFnDVT8EaKcq5cBIy6wBMba6pOOrN4ERaGB1WivE3efm26phUxpSwtpB7m?=
 =?us-ascii?Q?th3kHv2kGAvgFh1rhGgv37Z+Qd/ZSFDMld7DSO+gngI+1DFTK7nvs1Itz9OW?=
 =?us-ascii?Q?ZpAdF6H3RQW5FAjWE4WL/43aibsoKF5SueZEE63Imj8RzFs0mOWqbFUO2xYe?=
 =?us-ascii?Q?30KMbfv1TTpwAcgfgmxk/VnxmUu/49G05zSrzGJ93IO+VeCsy53XFF2JlH9h?=
 =?us-ascii?Q?EerXj5uXh9aVisU22jAPdD8syjw6HJ88mxX1S2KT+bJTKH6DWKjFrNhXBLSq?=
 =?us-ascii?Q?Ir8DENENUBqACJUgAdw7xNnLuObJED12iJWU9pewMDq9i3LIlf9WcJ9/EgMA?=
 =?us-ascii?Q?LdHZl4Ea7IyWrB8+ytWS5ghDDqe7iRpzlQfyHFwb1wkM1GlEyTwriMJS/F1Q?=
 =?us-ascii?Q?C6iexJq9IQ00btTZzDAvYbVSAENNTpYqQlxslR3KwiebUmMLj5/Ql7h1Rw/2?=
 =?us-ascii?Q?wEhe0CpMVMEbbD5SKEArglPPBXq9fU9yFgW9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 10:11:13.5340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6969d9b8-35a0-496e-aa6c-08ddfc1bdba5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4421

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


