Return-Path: <kvm+bounces-45227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9806AA72F6
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C32717DB8F
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94ED12580CF;
	Fri,  2 May 2025 13:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YMNO7feR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CD02566D4;
	Fri,  2 May 2025 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191329; cv=none; b=KwUUHhaq/OJaA0DrC8r0HjC0q3KDYAJIDkpmyXyqDjtpQvbHdULHMzyQIHGr1qNGLIdNFYa8Es1ew3qxYf7BpBdliCVAJC0OHSUVDOWSjE3FQeq3X0qjUU7JeyWbSQvuDBQ5V6WRHgIxbPZucbPzjyLOMtvVcNC5MJWcnuxQMcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191329; c=relaxed/simple;
	bh=m2m5QyspU/4UyDV/0jL1rXptk37jp9pz/ghUzoVVwFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QctJOk40ws/iPnxXepfdhmZmdroAWSRMPolnR2N7+47Lt+M6rHyEzSQzhYalXek+ni5cvhTT4Mu9W1jdNE/cKzSOhGcOqCapiG5n/fpn2RGa7uMeB0RvOF+YhgWezZcbIj17iH7b+8I3JbXP7/0gMV3DnDYFzhZl56E6c+Ugp8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YMNO7feR; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191327; x=1777727327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m2m5QyspU/4UyDV/0jL1rXptk37jp9pz/ghUzoVVwFo=;
  b=YMNO7feRkltCs9GArrga/LzvpSstpMfJ5ztb+L0XKCc8W/WPVY/h6JgO
   /hljyOHvpE37zeNjdjrPvbFUrSdpgO3/qhT7+fO/5qWBLceuAjrfge5Id
   RprSpeBjqwMMDapuB4bD+486OJMJaiQxNxH4fcTzr1AjB98kPBMoaJwDy
   ulBoxCYZzHHNCRoACdCMqF56IDA3I/bqotC7SfvGl5Ksa5nIT1RFF1Gcw
   fmmV3NkY7Tuehz4b8HpXjEA+77ZJlpXT7gNuJmNBqT8Qlo6j3iwRZHWEZ
   t4thfOLLBuEXvXmJ/62lTrZAUUObyNtWr0E0YWeWoL5F5PCLKPj/2eRQ7
   Q==;
X-CSE-ConnectionGUID: lCF/6zVVS+aoYhqbHdEllg==
X-CSE-MsgGUID: JFmFK1pHQqGRJmYVf+Nk3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="48012989"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="48012989"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:45 -0700
X-CSE-ConnectionGUID: LfwDnBDURhq5OyBvLXjxmw==
X-CSE-MsgGUID: zQqhLQYdSiKeYfAeNjyBVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="157871093"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 02 May 2025 06:08:41 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 86CB636F; Fri, 02 May 2025 16:08:36 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC, PATCH 10/12] KVM: TDX: Hookup phys_prepare() and phys_cleanup() kvm_x86_ops
Date: Fri,  2 May 2025 16:08:26 +0300
Message-ID: <20250502130828.4071412-11-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate PAMT memory from a per-VCPU pool in kvm_x86_ops::phys_prepare()
and release memory in kvm_x86_ops::phys_cleanup().

The TDP code invokes these callbacks to handle PAMT memory management.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kvm/vmx/main.c    |  2 ++
 arch/x86/kvm/vmx/tdx.c     | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  9 +++++++++
 virt/kvm/kvm_main.c        |  1 +
 4 files changed, 42 insertions(+)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 94d5d907d37b..665a3dbd4ba5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -63,6 +63,8 @@ static __init int vt_hardware_setup(void)
 		vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 		vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
 		vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
+		vt_x86_ops.phys_prepare = tdx_phys_prepare;
+		vt_x86_ops.phys_cleanup = tdx_phys_cleanup;
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 18c4ae00cd8d..0f06ae7ff6b9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1958,6 +1958,36 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	return tdx_sept_drop_private_spte(kvm, gfn, level, page);
 }
 
+int tdx_phys_prepare(struct kvm_vcpu *vcpu, kvm_pfn_t pfn)
+{
+	unsigned long hpa = pfn << PAGE_SHIFT;
+	atomic_t *pamt_refcount;
+	LIST_HEAD(pamt_pages);
+
+	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
+		return 0;
+
+	pamt_refcount = tdx_get_pamt_refcount(hpa);
+	if (atomic_inc_not_zero(pamt_refcount))
+		return 0;
+
+	for (int i = 0; i < tdx_nr_pamt_pages(tdx_sysinfo); i++) {
+		struct page *page;
+		void *p;
+
+		p = kvm_mmu_memory_cache_alloc(&vcpu->arch.pamt_page_cache);
+		page = virt_to_page(p);
+		list_add(&page->lru, &pamt_pages);
+	}
+
+	return tdx_pamt_add(pamt_refcount, hpa, &pamt_pages);
+}
+
+void tdx_phys_cleanup(kvm_pfn_t pfn)
+{
+	tdx_pamt_put(pfn_to_page(pfn));
+}
+
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector)
 {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 6bf8be570b2e..111f16c3039f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -158,6 +158,8 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 			      enum pg_level level, kvm_pfn_t pfn);
 int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 				 enum pg_level level, kvm_pfn_t pfn);
+int tdx_phys_prepare(struct kvm_vcpu *vcpu, kvm_pfn_t pfn);
+void tdx_phys_cleanup(kvm_pfn_t pfn);
 
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
@@ -224,6 +226,13 @@ static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	return -EOPNOTSUPP;
 }
 
+static inline int tdx_phys_prepare(struct kvm_vcpu *vcpu, kvm_pfn_t pfn)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void tdx_phys_cleanup(kvm_pfn_t pfn) {}
+
 static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
 static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69782df3617f..c3ba3ca37940 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -436,6 +436,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	BUG_ON(!p);
 	return p;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_memory_cache_alloc);
 #endif
 
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
-- 
2.47.2


