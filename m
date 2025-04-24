Return-Path: <kvm+bounces-44041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B62A4A99F55
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:09:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B684B1946F0D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5AAF1AAA1A;
	Thu, 24 Apr 2025 03:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CHbUxoym"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DA8125B2;
	Thu, 24 Apr 2025 03:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464124; cv=none; b=fZ85gOTaoZHcdWklcKq9H6vOWgRVY0VqPhEJljKTTXaAw0b/qpCckCLs7gUhF7rxUMJv81Ruag0OPjOozaokbbtGC2vFDPkT4yUmtuwxuP2KEY/SOuIk++0xPwS138a5Io/jZDzwXz1w+jqgEbQ9hVMUq8Rh0W6PdVAelBpJmo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464124; c=relaxed/simple;
	bh=An74aOxyztZCl6ULrSMm+V+H5s60SqIrpPJ7KYfFglI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyhDkAB8dFhAema0BC80ZIZQ0Szsl4kopKiGn22ucor6u/mXu59NQDugMr2Nj4geZD+K8Es1DMdXqeHZAXydl049oZeE+4Z42V8EDixwCkxQSJ+9azXVC3pt8PUm+TJXF2UAtw0GBvjCucaF/N4qmtO3Gtz7uiOH5kULXGIkyH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CHbUxoym; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464122; x=1777000122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=An74aOxyztZCl6ULrSMm+V+H5s60SqIrpPJ7KYfFglI=;
  b=CHbUxoymHRwHR9VFKqr5Kz+C2+D8L8uoDAgY48xVQxzLMIdjNTssEKfx
   /3K50GIKTiJj986drzUVcWN+MUipU2g51PO1K3a7Enl7lhkZ8tpq92ZVi
   iquqILQ3TfpNv+xElYWCsq9FjbXLZIuQCPrLtEiYwjQez88iKED/l32Id
   k+P3ALQWJkjmKz5s3J1qsQbLtmu10R3PnPdCj+NnVcBgLd+bQa9bVvTdS
   t67a2Fs52a81Z3wuX6DgHBuSHXu9Gk6SZ4caMl0gemCf2whiT9YglwXwk
   Nbb3bmnAaoOPdB2s3W2D6B4A4hrf9PB9j0zYYQqvDcm6DqZYB5+fYGCtQ
   A==;
X-CSE-ConnectionGUID: lQQdQiRNTUKK1z87MLO6iw==
X-CSE-MsgGUID: 3ejp8FmYTSegN1Wh5nhkwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="57727347"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="57727347"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:08:42 -0700
X-CSE-ConnectionGUID: 5LOSexQJTG6xbXID4Z4/RQ==
X-CSE-MsgGUID: EPMSJpw3ToiWQOH6dfYFCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137286407"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:08:36 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 11/21] KVM: x86: Add "vcpu" "gfn" parameters to x86 hook private_max_mapping_level
Date: Thu, 24 Apr 2025 11:06:49 +0800
Message-ID: <20250424030649.386-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce "vcpu" and "gfn" parameters to the KVM x86 hook
private_max_mapping_level.

This is a preparation to enable TDX to return the max mapping level for a
specific GFN in a vCPU.

No functional change expected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/mmu/mmu.c          | 6 +++---
 arch/x86/kvm/svm/sev.c          | 4 ++--
 arch/x86/kvm/svm/svm.h          | 4 ++--
 arch/x86/kvm/vmx/main.c         | 6 +++---
 arch/x86/kvm/vmx/tdx.c          | 4 ++--
 arch/x86/kvm/vmx/x86_ops.h      | 4 ++--
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ed9b65785a24..f96d30ad4ae8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1896,7 +1896,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*private_max_mapping_level)(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b923deeeb62e..0e227199d73e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4466,7 +4466,7 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
+static u8 kvm_max_private_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn,
 					u8 max_level, int gmem_order)
 {
 	u8 req_max_level;
@@ -4478,7 +4478,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
+	req_max_level = kvm_x86_call(private_max_mapping_level)(vcpu, pfn, gfn);
 	if (req_max_level)
 		max_level = min(max_level, req_max_level);
 
@@ -4510,7 +4510,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
+	fault->max_level = kvm_max_private_mapping_level(vcpu, fault->pfn, fault->gfn,
 							 fault->max_level, max_order);
 
 	return RET_PF_CONTINUE;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..dc6cdf9fa1ba 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4910,12 +4910,12 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	}
 }
 
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int sev_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn)
 {
 	int level, rc;
 	bool assigned;
 
-	if (!sev_snp_guest(kvm))
+	if (!sev_snp_guest(vcpu->kvm))
 		return 0;
 
 	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d4490eaed55d..1a9738b6ae37 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -782,7 +782,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
-int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int sev_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -809,7 +809,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static inline int sev_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 94d5d907d37b..ae8540576821 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -880,10 +880,10 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
-static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+static int vt_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn)
 {
-	if (is_td(kvm))
-		return tdx_gmem_private_max_mapping_level(kvm, pfn);
+	if (is_td(vcpu->kvm))
+		return tdx_gmem_private_max_mapping_level(vcpu, pfn, gfn);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6b3a8f3e6c9c..86775af85cd8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3258,9 +3258,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
+int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn)
 {
-	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
+	if (unlikely(to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE))
 		return PG_LEVEL_4K;
 
 	return PG_LEVEL_2M;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 6bf8be570b2e..7c183da7c4d4 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -162,7 +162,7 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
-int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn);
 #else
 static inline void tdx_disable_virtualization_cpu(void) {}
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
@@ -227,7 +227,7 @@ static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
 static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
-static inline int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn) { return 0; }
+static inline int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn) { return 0; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.43.2


