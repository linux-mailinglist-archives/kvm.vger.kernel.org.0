Return-Path: <kvm+bounces-15429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB9F8AC073
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92F3B1C2098F
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 372B73D393;
	Sun, 21 Apr 2024 18:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZUcRjb8b"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A53D3AC34;
	Sun, 21 Apr 2024 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722674; cv=fail; b=cGDP/SfYHeW8CrVo6DIoiomzCPeZ0nYN4G7T9jNIBht+eQicxCsoStsk6d/pasjew0FsUPZSGlIKqCVEeOzwdGCa7jsFJzcaWFcdf/gp+8GtvlCA4LvcJuWB6emUdwjDi3UeD8emOLf0P9qzDBuBabKRX91sj27F76jg6aXk6Dk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722674; c=relaxed/simple;
	bh=pAobdNn/S49uchU+iajtbEc2FEd4yPw4a/rSuOtt+S8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PG45woyKAmXQ+nmuncTUjpLnIn+LVoO5z0GLyoCvkV+fMBKadC3Ryw8/dA3cIVU6q0eR82LotUO/GSXgCqSYDTPjDORrfJ9izYLesFIXKvCCVH6Ky8bWIeEBNbcKJ3Azpxj7lxYJXq4K1Nf4wHwrCMKsvnHCU3Hu1+5cIn5pcnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZUcRjb8b; arc=fail smtp.client-ip=40.107.93.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLWNP107Hb+pdSEQTAwNrEU/evH11zYMeffdOgxk0TWVS9zS6IwAq4E0bj1yxWXCSktMCPfIMfLpUgq6xs98lWXVM5T2FIApFWuQWBUsS97tME9Zyr9z73yGbNQpSbfmaMkCxz0Gz3UyU4vt1oUnar1lzEIwMowCjQe8HSMmkM/Mr6UkkMAPMRtdyItE5rnZVS9CdsGRwdhQ7eNJuoEHqE8PjND2JPl79eXDDhw3ExpkOmL/qy/duMjh5AHJZw+0/3CCGz1kxZbVbWYY+g8ENaW3SyzTn4IrX5NX2SZCF7lhSsmyEtVPXMsq4PmwqrOkJ4xjpMSQlhg+yhPUfxrdLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6eik/hCULgEHAtiA7GJPxEV3QNjFxNvc8fyzTC/iuEI=;
 b=X/pdyCgt4shTyzNskb2HcUZ17HQuJxf/6XyhIzl9waZqZI65l5V1y/z9O1HYyejOKdXkKNHXI79fKSYRtMiMiNKhNUn4XIssUmz2uhQrOFMMNRqq0NJDmej4/BosXzuZPoQHoCUBgMNcIcKcKftb5A1xrFG+TujSAQiW6VnifoPLVzJl/tmwYZzOCVOiclni501ajWK9X8GSmNnk8BX0JvRXCJIBoxFqCoAlkZtzuMNJ1xgxc2KzytgToBg+zC+u1jDRBKvcgX4ZDwMGaogAOkJamp4d/gaxhWGCFm8OO3F3uik9NouK+i6zWLOXcJQwh0xQiJJbuTlZEYQCgmjnog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eik/hCULgEHAtiA7GJPxEV3QNjFxNvc8fyzTC/iuEI=;
 b=ZUcRjb8bWrj3iAag0Q9JPHbXQ3Ds/z2PdEjSKJgTJN0nerIkZ4Ve1BH551AfjUCk7VqNaUZ+tysPqX+j6iBhwknRknHlBzFVHJ4Ni+/+M4ONH4wwPi4HxV03MKiEcMoNdEhvjSw4SzpMTioN90P9jVuX57a62v/T/pgA3rHpxu8=
Received: from MN2PR11CA0025.namprd11.prod.outlook.com (2603:10b6:208:23b::30)
 by SJ2PR12MB7963.namprd12.prod.outlook.com (2603:10b6:a03:4c1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:04:26 +0000
Received: from MN1PEPF0000ECD8.namprd02.prod.outlook.com
 (2603:10b6:208:23b:cafe::ff) by MN2PR11CA0025.outlook.office365.com
 (2603:10b6:208:23b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:04:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD8.mail.protection.outlook.com (10.167.242.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:04:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:04:25 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v14 11/22] KVM: SEV: Add support to handle RMP nested page faults
Date: Sun, 21 Apr 2024 13:01:11 -0500
Message-ID: <20240421180122.1650812-12-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD8:EE_|SJ2PR12MB7963:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e62e364-3328-48e9-83df-08dc622d7b45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yirHvShTIwlR3MvxRmYd8yCGKgCPQX2PE0kY9lH00m4zWFBb7Y3KKK864NyH?=
 =?us-ascii?Q?ht4EVLpGpKBl2JfzO+KbMLRVNXQBMZ2bxPB4kBona1tRp72w9vfKSy4DuKX5?=
 =?us-ascii?Q?/JXwm4MNh5N4T3D2a4RkI8nE6RISYUJtap+4Ai9iw9YHbZzHPIFJ/+ofjYG8?=
 =?us-ascii?Q?2V5l8wcDkDy3jfp9iJA2GNS2RECq/dGiA+bRq+aYAYO6RXltkOScJZ9kCs8y?=
 =?us-ascii?Q?6pdNSJ4wQL8xGklhDRg/WeKJggiW08UV68dv6Rh7M0OiJjJ8/IbYMUGdJYWs?=
 =?us-ascii?Q?CEA3WaRANkHA7pn06DogcXS2w4Y+B2UkIWE50eu5ydz9wOyhJN8rBW51YdJZ?=
 =?us-ascii?Q?YYqnyYUtfcPxlI4ONX1NbIyXGkmrDC+1w8UjBPV73JjTST5n3YLkVbKjulrX?=
 =?us-ascii?Q?vZK+Z2XZobcUzoOJFayMwVcxvQnio5L4b5Tk3f/TEiVq6hvUh9P0i5AgB/1G?=
 =?us-ascii?Q?ZQedFongzTB/X9QLgfZjRTUbyluB7nk73yD4Vri+eHbChb9X1CTIvkMH6eE8?=
 =?us-ascii?Q?S+G0ZaMBUxzbOLxqo+q8HJD5ye+eRsHHbyAX2q4tMdnEKbDnYzzUE2uGP3VJ?=
 =?us-ascii?Q?8H6y2KjEu3SrElp9xQm2cYYLfUWBQxGKcTZDynm1jzBh1ZBWnQ3lKEWDdBjA?=
 =?us-ascii?Q?QGIAJ+ooGontctz0gjsOEV0uA8YvmpsNIVV+oSxXREReNRtJ7sWe58gNIkhO?=
 =?us-ascii?Q?OykqtKIqoQIJ3VZwqhu/b0k/Py62W8bNNiY2JKxlBFr0UFpYiMwfk64tvTZn?=
 =?us-ascii?Q?8g6gQmAOdv6oIPyOpSsl0Z2yCfas5Sh7brbYAFKWfmjD3I0xJKlh2BCrH5P1?=
 =?us-ascii?Q?U5zvAOJYS9i5PriTDtwJa9TrkhLw+s1J321JsRItFuHxBXHn6MhbXWhzx+nH?=
 =?us-ascii?Q?qax6y+hKYHD2dZ0GPPgrfX5Rrymnw7qEgt3Emqr69GMqaII7OYqM21qR3BHC?=
 =?us-ascii?Q?9oTXw7LX2kuTRoftW7LQKRsnFKuCZscUY2Z8e5/ZD6YRypVjnsoJskiX3n7v?=
 =?us-ascii?Q?g/YN/HdT0UhZ8ANfcUPlshlhQSalQgkL1e+uV97Y6DYKVhQdwWqPX5am9/bR?=
 =?us-ascii?Q?E8ZEqP9PiHkvhF/qRtEezx5SmCObjHz3EReVS9OAKIq+doPu3bnnW6PR8TXr?=
 =?us-ascii?Q?Ji76l8y2OChLKPBlRy2cFDiXaAlMjxnavzKm68XVWFGbJDs5SQApkgYwBTd8?=
 =?us-ascii?Q?j1zZVhF0XJa+84fxXF8E9mukFSBY3yN5l76CHN4CN9xEJWAoW+I8OHRcwsFh?=
 =?us-ascii?Q?+Q1ri76o1zbi2+oKrN1ycyfeJWdRPOozI/iRRBIFIEOiIwZJVXq2ZuZVGmrk?=
 =?us-ascii?Q?F1shJJafG3vg+2akYIdGvACTXfXic7ky43ZnMwKl4iLliX3E9qOo7B0CCv9+?=
 =?us-ascii?Q?hQXEyOqQ96FvSbUtCni7dBVN6lvx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(82310400014)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:04:26.0346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e62e364-3328-48e9-83df-08dc622d7b45
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7963

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled in the guest, the hardware places restrictions
on all memory accesses based on the contents of the RMP table. When
hardware encounters RMP check failure caused by the guest memory access
it raises the #NPF. The error code contains additional information on
the access type. See the APM volume 2 for additional information.

When using gmem, RMP faults resulting from mismatches between the state
in the RMP table vs. what the guest expects via its page table result
in KVM_EXIT_MEMORY_FAULTs being forwarded to userspace to handle. This
means the only expected case that needs to be handled in the kernel is
when the page size of the entry in the RMP table is larger than the
mapping in the nested page table, in which case a PSMASH instruction
needs to be issued to split the large RMP entry into individual 4K
entries so that subsequent accesses can succeed.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/include/asm/sev.h      |   3 +
 arch/x86/kvm/mmu.h              |   2 -
 arch/x86/kvm/mmu/mmu.c          |   1 +
 arch/x86/kvm/svm/sev.c          | 109 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  21 ++++--
 arch/x86/kvm/svm/svm.h          |   3 +
 arch/x86/kvm/trace.h            |  31 +++++++++
 arch/x86/kvm/x86.c              |   1 +
 9 files changed, 166 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4c9d8a22840a..90f0de2b8645 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1945,6 +1945,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 7f57382afee4..3a06f06b847a 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -91,6 +91,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 /* RMUPDATE detected 4K page and 2MB page overlap. */
 #define RMPUPDATE_FAIL_OVERLAP		4
 
+/* PSMASH failed due to concurrent access by another CPU */
+#define PSMASH_FAIL_INUSE		3
+
 /* RMP page size */
 #define RMP_PG_SIZE_4K			0
 #define RMP_PG_SIZE_2M			1
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2343c9f00e31..e3cb35b9396d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -251,8 +251,6 @@ static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
 	return __kvm_mmu_honors_guest_mtrrs(kvm_arch_has_noncoherent_dma(kvm));
 }
 
-void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eebb1562c5bc..b6d0aa18b72b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6752,6 +6752,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 
 	return need_tlb_flush;
 }
+EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
 
 static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 					   const struct kvm_memory_slot *slot)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e9519af8f14c..65882033a82f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3464,6 +3464,23 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_rmptable_psmash(kvm_pfn_t pfn)
+{
+	int ret;
+
+	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	/*
+	 * PSMASH_FAIL_INUSE indicates another processor is modifying the
+	 * entry, so retry until that's no longer the case.
+	 */
+	do {
+		ret = psmash(pfn);
+	} while (ret == PSMASH_FAIL_INUSE);
+
+	return ret;
+}
+
 static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4023,3 +4040,95 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
 	return p;
 }
+
+void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm = vcpu->kvm;
+	int order, rmp_level, ret;
+	bool assigned;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+
+	gfn = gpa >> PAGE_SHIFT;
+
+	/*
+	 * The only time RMP faults occur for shared pages is when the guest is
+	 * triggering an RMP fault for an implicit page-state change from
+	 * shared->private. Implicit page-state changes are forwarded to
+	 * userspace via KVM_EXIT_MEMORY_FAULT events, however, so RMP faults
+	 * for shared pages should not end up here.
+	 */
+	if (!kvm_mem_is_private(kvm, gfn)) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault for non-private GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!kvm_slot_can_be_private(slot)) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
+	if (ret) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
+				    gpa);
+		return;
+	}
+
+	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+	if (ret || !assigned) {
+		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
+				    gpa, pfn, ret);
+		goto out_no_trace;
+	}
+
+	/*
+	 * There are 2 cases where a PSMASH may be needed to resolve an #NPF
+	 * with PFERR_GUEST_RMP_BIT set:
+	 *
+	 * 1) RMPADJUST/PVALIDATE can trigger an #NPF with PFERR_GUEST_SIZEM
+	 *    bit set if the guest issues them with a smaller granularity than
+	 *    what is indicated by the page-size bit in the 2MB RMP entry for
+	 *    the PFN that backs the GPA.
+	 *
+	 * 2) Guest access via NPT can trigger an #NPF if the NPT mapping is
+	 *    smaller than what is indicated by the 2MB RMP entry for the PFN
+	 *    that backs the GPA.
+	 *
+	 * In both these cases, the corresponding 2M RMP entry needs to
+	 * be PSMASH'd to 512 4K RMP entries.  If the RMP entry is already
+	 * split into 4K RMP entries, then this is likely a spurious case which
+	 * can occur when there are concurrent accesses by the guest to a 2MB
+	 * GPA range that is backed by a 2MB-aligned PFN who's RMP entry is in
+	 * the process of being PMASH'd into 4K entries. These cases should
+	 * resolve automatically on subsequent accesses, so just ignore them
+	 * here.
+	 */
+	if (rmp_level == PG_LEVEL_4K)
+		goto out;
+
+	ret = snp_rmptable_psmash(pfn);
+	if (ret) {
+		/*
+		 * Look it up again. If it's 4K now then the PSMASH may have
+		 * raced with another process and the issue has already resolved
+		 * itself.
+		 */
+		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
+		    assigned && rmp_level == PG_LEVEL_4K)
+			goto out;
+
+		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
+				    gpa, pfn, ret);
+	}
+
+	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
+out:
+	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
+out_no_trace:
+	put_page(pfn_to_page(pfn));
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 422b452fbc3b..7c9807fdafc3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2043,6 +2043,7 @@ static int pf_interception(struct kvm_vcpu *vcpu)
 static int npf_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	int rc;
 
 	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
@@ -2060,10 +2061,22 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 		error_code |= PFERR_PRIVATE_ACCESS;
 
 	trace_kvm_page_fault(vcpu, fault_address, error_code);
-	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
-			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
-			svm->vmcb->control.insn_bytes : NULL,
-			svm->vmcb->control.insn_len);
+	rc = kvm_mmu_page_fault(vcpu, fault_address, error_code,
+				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
+				svm->vmcb->control.insn_bytes : NULL,
+				svm->vmcb->control.insn_len);
+
+	/*
+	 * rc == 0 indicates a userspace exit is needed to handle page
+	 * transitions, so do that first before updating the RMP table.
+	 */
+	if (error_code & PFERR_GUEST_RMP_MASK) {
+		if (rc == 0)
+			return rc;
+		sev_handle_rmp_fault(vcpu, fault_address, error_code);
+	}
+
+	return rc;
 }
 
 static int db_interception(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 730f5ced2a2e..d2b0ec27d4fe 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -722,6 +722,7 @@ void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
+void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -735,6 +736,8 @@ static inline void sev_hardware_unsetup(void) {}
 static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
 static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
+static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
+
 #endif
 
 /* vmenter.S */
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index c6b4b1728006..3531a187d5d9 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1834,6 +1834,37 @@ TRACE_EVENT(kvm_vmgexit_msr_protocol_exit,
 		  __entry->vcpu_id, __entry->ghcb_gpa, __entry->result)
 );
 
+/*
+ * Tracepoint for #NPFs due to RMP faults.
+ */
+TRACE_EVENT(kvm_rmp_fault,
+	TP_PROTO(struct kvm_vcpu *vcpu, u64 gpa, u64 pfn, u64 error_code,
+		 int rmp_level, int psmash_ret),
+	TP_ARGS(vcpu, gpa, pfn, error_code, rmp_level, psmash_ret),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, vcpu_id)
+		__field(u64, gpa)
+		__field(u64, pfn)
+		__field(u64, error_code)
+		__field(int, rmp_level)
+		__field(int, psmash_ret)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu->vcpu_id;
+		__entry->gpa		= gpa;
+		__entry->pfn		= pfn;
+		__entry->error_code	= error_code;
+		__entry->rmp_level	= rmp_level;
+		__entry->psmash_ret	= psmash_ret;
+	),
+
+	TP_printk("vcpu %u gpa %016llx pfn 0x%llx error_code 0x%llx rmp_level %d psmash_ret %d",
+		  __entry->vcpu_id, __entry->gpa, __entry->pfn,
+		  __entry->error_code, __entry->rmp_level, __entry->psmash_ret)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83b8260443a3..14693effec6b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13996,6 +13996,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
 
 static int __init kvm_x86_init(void)
 {
-- 
2.25.1


