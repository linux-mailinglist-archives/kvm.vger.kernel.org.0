Return-Path: <kvm+bounces-58069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD03CB875F5
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A2DC1C85262
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3F1320CB5;
	Thu, 18 Sep 2025 23:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PoK6C/Eo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84EC30EF75;
	Thu, 18 Sep 2025 23:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237792; cv=none; b=EVqQ83r7+yxePNm8IfI+7yO3i0HI600jBXYnz/6sC65mb2B9kBzm1thJwmfBGYX2Bmy2TmDqIWoKnW0kU4pz1Gm1GxJat6uqwRy6z3EJjkjRuBj5pupSRDBOYq2FaKO/OOIshLXCLfK+W0Xl4Ym1pZOl/oPR3ndjaghdlhKC2fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237792; c=relaxed/simple;
	bh=JsUUp1XAwz49AUE+DFdVOAcwO8MooLllAPLOJ0srrE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fw8s8CjCydRdrgJVIU5rOJGx4ROD4kSXcNJLPjf8ohEE9nLb8eMwcm5af4tIvJKu0zK/Jlo5glXlztDvSZdkx9tDSGSvpTfDOD68SkF5xoSAdiQ6vuGFaRunq5nUcMnwH7sFA05j0IVoZ4i80rIA6UL7ZNg9iLwjf5gkqbav16E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PoK6C/Eo; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758237789; x=1789773789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JsUUp1XAwz49AUE+DFdVOAcwO8MooLllAPLOJ0srrE4=;
  b=PoK6C/EoBcGwB1I/6U9zzagUaWjwXtEaSIj/G0TElD/02GXwCGQY3g9E
   3f43eGhKzdqoE5PFbnsB81Xi7FoVBtRn1EGm/sLf+j2knUeXS5Q6lEbjc
   8I1Teh8GxKzyLXxA9kVGVRbvfoc2X7n03ga1pkoEAAXvM4PIK/w5Wac+6
   AwIMG9wdAeZjFXAtYLx9uuwFWxfT56W0hI45U7H+wbidd5kQWOV6ckg2x
   Nj7jLz1Uk7pb/XQdyREoULL7oBBKOattgy7pahTdHeXblJTpOQERE3iez
   XtRmHakWxtqExCr5p6x/py6MnzFmMQ4FVL1G04TIZeiFzSagK22Lq1xOL
   A==;
X-CSE-ConnectionGUID: G8nt+6RpSpOjMqJioFqWng==
X-CSE-MsgGUID: Zn8tVCl7Sz2LBFKDAAAbgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60735449"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="60735449"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:05 -0700
X-CSE-ConnectionGUID: nSSyvzYpS7O97IlTqGi0bQ==
X-CSE-MsgGUID: A7ZfY9JaQ/KdC5XODIHrDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176491450"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:04 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kas@kernel.org,
	bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@linux.intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	vannapurve@google.com
Cc: rick.p.edgecombe@intel.com
Subject: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for pre-allocating pages
Date: Thu, 18 Sep 2025 16:22:20 -0700
Message-ID: <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the KVM fault path pagei, tables and private pages need to be
installed under a spin lock. This means that the operations around
installing PAMT pages for them will not be able to allocate pages.

Create a small structure to allow passing a list of pre-allocated pages
that PAMT operations can use. Have the structure keep a count such that
it can be stored on KVM's vCPU structure, and "topped up" for each fault.
This is consistent with how KVM manages similar caches and will fit better
than allocating and freeing all possible needed pages each time.

Adding this structure duplicates a fancier one that lives in KVM 'struct
kvm_mmu_memory_cache'. While the struct itself is easy to expose, the
functions that operate on it are a bit big to put in a header, which
would be needed to use them from the core kernel. So don't pursue this
option.

To avoid problem of needing the kernel to link to functionality in KVM,
a function pointer could be passed, however this makes the code
convoluted, when what is needed is barely more than a linked list. So
create a tiny, simpler version of KVM's kvm_mmu_memory_cache to use for
PAMT pages.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/tdx.h  | 43 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.c      | 16 +++++++++++---
 arch/x86/kvm/vmx/tdx.h      |  2 +-
 arch/x86/virt/vmx/tdx/tdx.c | 22 +++++++++++++------
 virt/kvm/kvm_main.c         |  2 --
 5 files changed, 72 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 439dd5c5282e..e108b48af2c3 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -17,6 +17,7 @@
 #include <uapi/asm/mce.h>
 #include <asm/tdx_global_metadata.h>
 #include <linux/pgtable.h>
+#include <linux/memory.h>
 
 /*
  * Used by the #VE exception handler to gather the #VE exception
@@ -116,7 +117,46 @@ int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
-int tdx_pamt_get(struct page *page);
+int tdx_dpamt_entry_pages(void);
+
+/*
+ * Simple structure for pre-allocating Dynamic
+ * PAMT pages outside of locks.
+ */
+struct tdx_prealloc {
+	struct list_head page_list;
+	int cnt;
+};
+
+static inline struct page *get_tdx_prealloc_page(struct tdx_prealloc *prealloc)
+{
+	struct page *page;
+
+	page = list_first_entry_or_null(&prealloc->page_list, struct page, lru);
+	if (page) {
+		list_del(&page->lru);
+		prealloc->cnt--;
+	}
+
+	return page;
+}
+
+static inline int topup_tdx_prealloc_page(struct tdx_prealloc *prealloc, unsigned int min_size)
+{
+	while (prealloc->cnt < min_size) {
+		struct page *page = alloc_page(GFP_KERNEL);
+
+		if (!page)
+			return -ENOMEM;
+
+		list_add(&page->lru, &prealloc->page_list);
+		prealloc->cnt++;
+	}
+
+	return 0;
+}
+
+int tdx_pamt_get(struct page *page, struct tdx_prealloc *prealloc);
 void tdx_pamt_put(struct page *page);
 
 struct page *tdx_alloc_page(void);
@@ -192,6 +232,7 @@ static inline int tdx_enable(void)  { return -ENODEV; }
 static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
+static inline int tdx_dpamt_entry_pages(void) { return 0; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLER__ */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6c9e11be9705..b274d350165c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1593,16 +1593,26 @@ static void tdx_unpin(struct kvm *kvm, struct page *page)
 static void *tdx_alloc_external_fault_cache(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct page *page = get_tdx_prealloc_page(&tdx->prealloc);
 
-	return kvm_mmu_memory_cache_alloc(&tdx->mmu_external_spt_cache);
+	if (!page)
+		return NULL;
+
+	return page_address(page);
 }
 
 static int tdx_topup_external_fault_cache(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct tdx_prealloc *prealloc = &tdx->prealloc;
+	int min_fault_cache_size;
 
-	return kvm_mmu_topup_memory_cache(&tdx->mmu_external_spt_cache,
-					  PT64_ROOT_MAX_LEVEL);
+	/* External page tables */
+	min_fault_cache_size = PT64_ROOT_MAX_LEVEL;
+	/* Dynamic PAMT pages (if enabled) */
+	min_fault_cache_size += tdx_dpamt_entry_pages() * PT64_ROOT_MAX_LEVEL;
+
+	return topup_tdx_prealloc_page(prealloc, min_fault_cache_size);
 }
 
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index cd7993ef056e..68bb841c1b6c 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -71,7 +71,7 @@ struct vcpu_tdx {
 	u64 map_gpa_next;
 	u64 map_gpa_end;
 
-	struct kvm_mmu_memory_cache mmu_external_spt_cache;
+	struct tdx_prealloc prealloc;
 };
 
 void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c25e238931a7..b4edc3ee495c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1999,13 +1999,23 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
 
 /* Number PAMT pages to be provided to TDX module per 2M region of PA */
-static int tdx_dpamt_entry_pages(void)
+int tdx_dpamt_entry_pages(void)
 {
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return 0;
 
 	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
 }
+EXPORT_SYMBOL_GPL(tdx_dpamt_entry_pages);
+
+static struct page *alloc_dpamt_page(struct tdx_prealloc *prealloc)
+{
+	if (prealloc)
+		return get_tdx_prealloc_page(prealloc);
+
+	return alloc_page(GFP_KERNEL);
+}
+
 
 /*
  * The TDX spec treats the registers like an array, as they are ordered
@@ -2032,12 +2042,12 @@ static u64 *dpamt_args_array_ptr(struct tdx_module_args *args)
 	return (u64 *)((u8 *)args + offsetof(struct tdx_module_args, rdx));
 }
 
-static int alloc_pamt_array(u64 *pa_array)
+static int alloc_pamt_array(u64 *pa_array, struct tdx_prealloc *prealloc)
 {
 	struct page *page;
 
 	for (int i = 0; i < tdx_dpamt_entry_pages(); i++) {
-		page = alloc_page(GFP_KERNEL);
+		page = alloc_dpamt_page(prealloc);
 		if (!page)
 			return -ENOMEM;
 		pa_array[i] = page_to_phys(page);
@@ -2111,7 +2121,7 @@ static u64 tdh_phymem_pamt_remove(unsigned long hpa, u64 *pamt_pa_array)
 static DEFINE_SPINLOCK(pamt_lock);
 
 /* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
-int tdx_pamt_get(struct page *page)
+int tdx_pamt_get(struct page *page, struct tdx_prealloc *prealloc)
 {
 	unsigned long hpa = ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
 	u64 pamt_pa_array[MAX_DPAMT_ARG_SIZE];
@@ -2122,7 +2132,7 @@ int tdx_pamt_get(struct page *page)
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return 0;
 
-	ret = alloc_pamt_array(pamt_pa_array);
+	ret = alloc_pamt_array(pamt_pa_array, prealloc);
 	if (ret)
 		return ret;
 
@@ -2228,7 +2238,7 @@ struct page *tdx_alloc_page(void)
 	if (!page)
 		return NULL;
 
-	if (tdx_pamt_get(page)) {
+	if (tdx_pamt_get(page, NULL)) {
 		__free_page(page);
 		return NULL;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f05e6d43184b..fee108988028 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -404,7 +404,6 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 {
 	return __kvm_mmu_topup_memory_cache(mc, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, min);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_topup_memory_cache);
 
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 {
@@ -437,7 +436,6 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	BUG_ON(!p);
 	return p;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_memory_cache_alloc);
 #endif
 
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
-- 
2.51.0


