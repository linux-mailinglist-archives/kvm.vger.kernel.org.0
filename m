Return-Path: <kvm+bounces-15148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 421AF8AA33F
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:48:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB87A287F38
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B43E4181B8E;
	Thu, 18 Apr 2024 19:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VVwpvj5D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40300184119;
	Thu, 18 Apr 2024 19:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469546; cv=fail; b=Ib9gf7lQ5Yy6vt5xQVRyRk8ibFvhdiO4DwwfmqdWeDlQMpqwiJ/AmGyWId7rxEAhLGB6+YSCOc2QhImzymOV7oKmKDU7hSbpoY/RK6cLzL/aIx+S4Jeq6aYTfoxRJvIBFMgCHfaNfPTOoBzqLJt83otvx2wyb2xHIfoLBZghxos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469546; c=relaxed/simple;
	bh=aDOFK9YvgHWQXr+D7VnmDDM+J8Lm7iSKcvR9ab98pDw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OTJ9mDkKjbDvFtZ230us9TS+3VpfHql3Mmq3QZvS1pj9xwXbZhDsfuMXx8YQzM7s2Nlu0aJfodTGCGKxesneBM+k3P3ISendbZkyukn0HXSM9V8NI/U+Nuq5j8Sj/FvDBgbkhIkInLXC6lKHJ/nIMP60W9pDDwx1QXiik5RAh3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VVwpvj5D; arc=fail smtp.client-ip=40.107.92.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aH97/MO9JloXuv7DEtdZxuYOJUVndecNJ3VWkS2KwMKcrOF9cymg8WpqN9pd5p+Bg0Ec75iboBXxV+7M84F3/Wmb+npmyXHLSdeT83fGiF44juG+o+yBlczofLCBdgLZYoqOPZCOtzR1v7VVcJBI3atr32P6/V6wDM5X3xFQC+/UZzwvYpmkOLXl+NXzXIwLHU5f5aJNtNmrrb4Gd6W7EwdxxtZROfoQn9h1ZSzbiEmguHWgVoH8uTpmbFCluqQd3gjIkbHO0ejH9UEMT7mtTJlnMNUsO2ogYL2kh8WTPTZLZ2QVL9D6Mc5N1utX+KdDIj50Ocl8jO6avYc+ilDMTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vmXazHrpz1P7vgqNxIBZta6eB0wnzBKoBVOMqzXL9IE=;
 b=RPuFcdeBixdtswDjch6Gqde7LOZjPIoBZj6sf4sdV2Uhahb4SXgvooUWQEEdfWyIn07wT4cTyjP4zVc5ccl3HKu0A/YrsBdAQXuhYXtwgFY3xpnXmHmf7knVTMXNTMg1N2Ja3sa/oZNZwtKzQQYFe0UKcyI+7jW6JzGZxdIK7udr43orCgspyGOO44HB6d67r74W/pO0Cdxq4cgEWIpHs2SO0qyqtSuyZpwBM2+zTWyYI5/cosDQvVt8J05kJnjNp6bm0ef8ET9FxcDO84StACRnGUiANgcLakIjetsLge0VQnUuNpnjuoxr9K1QGnvmZ7NKBOSl+hym757d6MpDrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmXazHrpz1P7vgqNxIBZta6eB0wnzBKoBVOMqzXL9IE=;
 b=VVwpvj5DNouvoSTBsN0MiKgInvmDNt8QUZFn5oDDI4WywcnW7dQvPEVYwT2SlmCxfO2bkkzAoep0NXsjoi1P5q5pB7sb/pvuoNYsbif4trgKia5zah/gb8eAD6TTsbYJpZj1g7F7F+dOdBt8KHYnjjk5tXfgDlTxhQeUhG9Bx6A=
Received: from BYAPR06CA0065.namprd06.prod.outlook.com (2603:10b6:a03:14b::42)
 by CH3PR12MB9342.namprd12.prod.outlook.com (2603:10b6:610:1cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 19:45:39 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:14b:cafe::c) by BYAPR06CA0065.outlook.office365.com
 (2603:10b6:a03:14b::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.28 via Frontend
 Transport; Thu, 18 Apr 2024 19:45:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:45:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:45:37 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v13 18/26] KVM: SEV: Implement gmem hook for initializing private pages
Date: Thu, 18 Apr 2024 14:41:25 -0500
Message-ID: <20240418194133.1452059-19-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|CH3PR12MB9342:EE_
X-MS-Office365-Filtering-Correlation-Id: 463e2e90-41c9-4aed-f4b3-08dc5fe01fb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a3Emki6T++NIwADxr4SSNO/DPZPRSMRp5wzsY9K2Q/gZb5bmZBWleXa4H+CokUPrbED3a6K98mpizkOv6KRgs8ffaWIp4LiYu2MeefIZ18TPYmK93z7dTDJr9MSiL4WszeoXGMgLSEq1y/32B7BydpAD0LN5+CNZ6TcLKIiCBuvqxm5elAJ7G7PtKHI1IGNOsSvm+4Fs/ceSnPzKJy7/tApiNCDvlz9pL2hcx89qNEUA0RPSvWToGxjuMTHZfqu3ZoGRquFSimaSHBOho/Gh2aH8Arb2m5ZzME1yg+3726YhqXFkoD1QrMXT8BePkvm2bsB4IztGZMQozIWlRrWIvY2A42M+utRAMxZm2QahoxZBkgAmLuzkjWXGVNxXgjO0AGVofp9h+ze46kgTqYOFBmkDBvEottOC+nsHu89kYRK/qtcsW/Wk70VdKAGNTwixcLhHb7sJz2QwMoh2HRIe/y0kcDSQiguwVyA60Fiv1Aoo7wmlvCSMJj9LbJ3+J97gdjUQFkq9Ho0stxsz7NV4xzKFoxl4t5IB++WcfYbN9mENogdpZ+tg/CUUztj77ev7zYIaW2oCCiZWSJK6m7/JndMNfL0psqNfHrx7bDEZZWWH2K1ICo7AuICkNpZg3nBuAwPWlPcG+t0st8azIfOoXrPNsz56ACh34mISZ8GRx2Rd8YPqdeVJOJN5hnxC0YIt29bTMSr45STlvtC2y3Ccz/fqrDAXYGokOgre7xkGq3TQH0OC8kuC3RREztQHe+yP
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(82310400014)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:45:38.7496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 463e2e90-41c9-4aed-f4b3-08dc5fe01fb2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9342

This will handle the RMP table updates needed to put a page into a
private state before mapping it into an SEV-SNP guest.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig   |  1 +
 arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  2 +
 arch/x86/kvm/svm/svm.h |  5 +++
 arch/x86/kvm/x86.c     |  5 +++
 virt/kvm/guest_memfd.c |  4 +-
 6 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 5e72faca4e8f..10768f13b240 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -137,6 +137,7 @@ config KVM_AMD_SEV
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
 	select KVM_GENERIC_PRIVATE_MEM
+	select HAVE_KVM_GMEM_PREPARE
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2e0e825b6436..29f6e8dc29c8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4357,3 +4357,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 out_no_trace:
 	put_page(pfn_to_page(pfn));
 }
+
+static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
+{
+	kvm_pfn_t pfn = start;
+
+	while (pfn < end) {
+		int ret, rmp_level;
+		bool assigned;
+
+		ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
+		if (ret) {
+			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GFN start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
+					    pfn, start, end, rmp_level, ret);
+			return false;
+		}
+
+		if (assigned) {
+			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d\n",
+				 __func__, pfn, start, end, rmp_level);
+			return false;
+		}
+
+		pfn++;
+	}
+
+	return true;
+}
+
+static u8 max_level_for_order(int order)
+{
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
+{
+	kvm_pfn_t pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
+
+	/*
+	 * If this is a large folio, and the entire 2M range containing the
+	 * PFN is currently shared, then the entire 2M-aligned range can be
+	 * set to private via a single 2M RMP entry.
+	 */
+	if (max_level_for_order(order) > PG_LEVEL_4K &&
+	    is_pfn_range_shared(pfn_aligned, pfn_aligned + PTRS_PER_PMD))
+		return true;
+
+	return false;
+}
+
+int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t pfn_aligned;
+	gfn_t gfn_aligned;
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc) {
+		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %llx error %d\n",
+				   gfn, pfn, rc);
+		return -ENOENT;
+	}
+
+	if (assigned) {
+		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %d\n",
+			 __func__, gfn, pfn, max_order, level);
+		return 0;
+	}
+
+	if (is_large_rmp_possible(kvm, pfn, max_order)) {
+		level = PG_LEVEL_2M;
+		pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
+		gfn_aligned = ALIGN_DOWN(gfn, PTRS_PER_PMD);
+	} else {
+		level = PG_LEVEL_4K;
+		pfn_aligned = pfn;
+		gfn_aligned = gfn;
+	}
+
+	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, sev->asid, false);
+	if (rc) {
+		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx level %d error %d\n",
+				   gfn, pfn, level, rc);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d level %d\n",
+		 __func__, gfn, pfn, pfn_aligned, max_order, level);
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9dc929316c5d..3e8d0752bf1b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5080,6 +5080,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
+	.gmem_prepare = sev_gmem_prepare,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 81e335dca281..7712ed90aae8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -730,6 +730,7 @@ extern unsigned int max_sev_asid;
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -746,6 +747,10 @@ static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXI
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
 static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
+static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
+{
+	return 0;
+}
 
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 436078b9e5aa..2e911dc0a991 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13610,6 +13610,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_SNP_VM;
+}
+
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
 {
 	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9d7c6a70c547..b814e5d61f8e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -46,8 +46,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 		gfn = slot->base_gfn + index - slot->gmem.pgoff;
 		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
 		if (rc) {
-			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
-					    index, rc);
+			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
+					    index, gfn, pfn, rc);
 			return rc;
 		}
 	}
-- 
2.25.1


