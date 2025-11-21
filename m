Return-Path: <kvm+bounces-64040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 37489C76D1C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:56:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A325135E559
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8B52D2381;
	Fri, 21 Nov 2025 00:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="msB6U3iJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3D22BD022;
	Fri, 21 Nov 2025 00:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686312; cv=none; b=mXAgpdZm5FRmJsGRs+WSB8TahwYuPYYwLCx8U9dAR5yIeaPLMBp+EesD3HxsUWEkWVa9cwB7c6e1kfhDcP/xwMw1xfln4MUDco5sqSX1vZpEY9YGgUGUZLcJ/E3W4+jaLvbScgbsWXxcxCyyRPWfh0HjfYGFS0OdNCu57jQOyIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686312; c=relaxed/simple;
	bh=5edLabYwvbcgPSny3ttClCueQX+dcGSJQqyVuiw9CL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ufk5Kzlk6/GzkU/5gg9/5qha1v3jFSNmN9u/7GpWu6phqprtKZuol7GnIzlJKD9iP2K5AHvr/NVuTkEY6nioISV8pWKoj6V03E1cyvV1b1E6PS+BMk9wnWL67XUUrTg+PC6y/kxtkpo6nzZD6ZGpiM2heODp5OgTlE7+V5f5yeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=msB6U3iJ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686310; x=1795222310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5edLabYwvbcgPSny3ttClCueQX+dcGSJQqyVuiw9CL0=;
  b=msB6U3iJEAXIaWKDeb/p5iNL3SIuhgkyW/LlQTAx0mh7Usmuv85yrnAi
   uPhWuXYiIbMLO4MtfmDLN6H2hv5ayVwLD2f00LTTA4krgPVCOLrU+Xn9g
   x5eqYWhhFGzM4xVFYaPgG7RWHo22iiwpmuMmlrtFf3gvAvzBeFQEAU5xN
   OIOT1LJyoVgt8dMRbodFlhN/XCA0H0msHmh2SZRExw7zJ4I8pRprCZh21
   z8mv1Tfn9c/g2Ox10N/BUSkROa7oTdTXxcjK1VBMsc9ejJc0tREx27Bfi
   trrWfgLGMzVhzytNtETH2opgwotVC+YmPofeA2CwtJPPJwfPWiVA2aAfw
   Q==;
X-CSE-ConnectionGUID: F5av8nI/Q9+ZqukLleCq5g==
X-CSE-MsgGUID: YQD9n6rgT4uGHtTiqpMzlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780804"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780804"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:46 -0800
X-CSE-ConnectionGUID: IlCi6sk6QCKdlsgGFzD4Og==
X-CSE-MsgGUID: n8mTGGa+Rdaf2bIgCfrZEw==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:45 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@intel.com
Cc: rick.p.edgecombe@intel.com
Subject: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for pre-allocating pages
Date: Thu, 20 Nov 2025 16:51:21 -0800
Message-ID: <20251121005125.417831-13-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In the KVM fault path page, tables and private pages need to be
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

To avoid the problem of needing the kernel to link to functionality in
KVM, a function pointer could be passed, however this makes the code
convoluted, when what is needed is barely more than a linked list. So
create a tiny, simpler version of KVM's kvm_mmu_memory_cache to use for
PAMT pages.

Don't use mempool_t for this because there is no appropriate topup
mechanism. The mempool_resize() operation is the closest, but it
reallocates an array each time. It also does not have a way to pass
GFP_KERNEL_ACCOUNT to page allocations during resize. So it would need to
be amended, and the problems that caused GFP_KERNEL_ACCOUNT to be
prevented in that operation dealt with. The other option would be simply
allocate pages from TDX code and free them to the pool in order to
implement the top up operation, but this is not really any savings over
the simple linked list.

Allocate the pages as GFP_KERNEL_ACCOUNT based on that the allocations
will be easily user triggerable, and for the future huge pages case (which
advanced cgroups caring setups are likely to use), will also mostly be
associated with the specific TD. So better to be GFP_KERNEL_ACCOUNT,
despite the fact that sometimes the pages may later on only be backing
some other cgroup’s TD memory.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - Change to GFP_KERNEL_ACCOUNT to match replaced kvm_mmu_memory_cache
 - Add GFP_ATOMIC backup, like kvm_mmu_memory_cache has (Kiryl)
 - Explain why not to use mempool (Dave)
 - Tweak local vars to be more reverse christmas tree by deleting some
   that were only added for reasons that go away in this patch anyway
---
 arch/x86/include/asm/tdx.h  | 43 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.c      | 21 +++++++++++++-----
 arch/x86/kvm/vmx/tdx.h      |  2 +-
 arch/x86/virt/vmx/tdx/tdx.c | 22 +++++++++++++------
 virt/kvm/kvm_main.c         |  3 ---
 5 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 914213123d94..416ca9a738ee 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -17,6 +17,7 @@
 #include <uapi/asm/mce.h>
 #include <asm/tdx_global_metadata.h>
 #include <linux/pgtable.h>
+#include <linux/memory.h>
 
 /*
  * Used by the #VE exception handler to gather the #VE exception
@@ -141,7 +142,46 @@ int tdx_guest_keyid_alloc(void);
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
+		struct page *page = alloc_page(GFP_KERNEL_ACCOUNT);
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
@@ -219,6 +259,7 @@ static inline int tdx_enable(void)  { return -ENODEV; }
 static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
+static inline int tdx_dpamt_entry_pages(void) { return 0; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #ifdef CONFIG_KEXEC_CORE
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 260bb0e6eb44..61a058a8f159 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1644,23 +1644,34 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 
 static void *tdx_alloc_external_fault_cache(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct page *page = get_tdx_prealloc_page(&to_tdx(vcpu)->prealloc);
 
-	return kvm_mmu_memory_cache_alloc(&tdx->mmu_external_spt_cache);
+	if (WARN_ON_ONCE(!page))
+		return (void *)__get_free_page(GFP_ATOMIC | __GFP_ACCOUNT);
+
+	return page_address(page);
 }
 
 static int tdx_topup_external_fault_cache(struct kvm_vcpu *vcpu, unsigned int cnt)
 {
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct tdx_prealloc *prealloc = &to_tdx(vcpu)->prealloc;
+	int min_fault_cache_size;
 
-	return kvm_mmu_topup_memory_cache(&tdx->mmu_external_spt_cache, cnt);
+	/* External page tables */
+	min_fault_cache_size = cnt;
+	/* Dynamic PAMT pages (if enabled) */
+	min_fault_cache_size += tdx_dpamt_entry_pages() * PT64_ROOT_MAX_LEVEL;
+
+	return topup_tdx_prealloc_page(prealloc, min_fault_cache_size);
 }
 
 static void tdx_free_external_fault_cache(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct page *page;
 
-	kvm_mmu_free_memory_cache(&tdx->mmu_external_spt_cache);
+	while ((page = get_tdx_prealloc_page(&tdx->prealloc)))
+		__free_page(page);
 }
 
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 1eefa1b0df5e..43dd295b7fd6 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -74,7 +74,7 @@ struct vcpu_tdx {
 	u64 map_gpa_next;
 	u64 map_gpa_end;
 
-	struct kvm_mmu_memory_cache mmu_external_spt_cache;
+	struct tdx_prealloc prealloc;
 };
 
 void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 39e2e448c8ba..74b0342b7570 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2010,13 +2010,23 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
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
+	return alloc_page(GFP_KERNEL_ACCOUNT);
+}
+
 
 /*
  * The TDX spec treats the registers like an array, as they are ordered
@@ -2040,13 +2050,13 @@ static u64 *dpamt_args_array_ptr(struct tdx_module_array_args *args)
 	return &args->args_array[TDX_ARG_INDEX(rdx)];
 }
 
-static int alloc_pamt_array(u64 *pa_array)
+static int alloc_pamt_array(u64 *pa_array, struct tdx_prealloc *prealloc)
 {
 	struct page *page;
 	int i;
 
 	for (i = 0; i < tdx_dpamt_entry_pages(); i++) {
-		page = alloc_page(GFP_KERNEL_ACCOUNT);
+		page = alloc_dpamt_page(prealloc);
 		if (!page)
 			goto err;
 		pa_array[i] = page_to_phys(page);
@@ -2134,7 +2144,7 @@ static u64 tdh_phymem_pamt_remove(struct page *page, u64 *pamt_pa_array)
 static DEFINE_SPINLOCK(pamt_lock);
 
 /* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
-int tdx_pamt_get(struct page *page)
+int tdx_pamt_get(struct page *page, struct tdx_prealloc *prealloc)
 {
 	u64 pamt_pa_array[MAX_TDX_ARG_SIZE(rdx)];
 	atomic_t *pamt_refcount;
@@ -2153,7 +2163,7 @@ int tdx_pamt_get(struct page *page)
 	if (atomic_inc_not_zero(pamt_refcount))
 		return 0;
 
-	ret = alloc_pamt_array(pamt_pa_array);
+	ret = alloc_pamt_array(pamt_pa_array, prealloc);
 	if (ret)
 		goto out_free;
 
@@ -2278,7 +2288,7 @@ struct page *tdx_alloc_page(void)
 	if (!page)
 		return NULL;
 
-	if (tdx_pamt_get(page)) {
+	if (tdx_pamt_get(page, NULL)) {
 		__free_page(page);
 		return NULL;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cff24b950baa..9eca084bdcbe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -404,7 +404,6 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 {
 	return __kvm_mmu_topup_memory_cache(mc, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, min);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_topup_memory_cache);
 
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 {
@@ -425,7 +424,6 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 	mc->objects = NULL;
 	mc->capacity = 0;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_free_memory_cache);
 
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 {
@@ -438,7 +436,6 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	BUG_ON(!p);
 	return p;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_memory_cache_alloc);
 #endif
 
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
-- 
2.51.2


