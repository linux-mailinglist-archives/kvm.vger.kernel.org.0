Return-Path: <kvm+bounces-58061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4C0B875C2
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7837652859A
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AB172820D5;
	Thu, 18 Sep 2025 23:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UktrpuND"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BB72F5A19;
	Thu, 18 Sep 2025 23:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237786; cv=none; b=DwYT/tmD0NgNomlfWbiYOuKJ1yFNgXqgXKBwy5V/qfVW4UKzxbtUKJ6E0Um0oQXfR0E0uCl2D9feaEpSGTnymtk4xTuG/Ol9QHyEfwOSmdisuw8nfBWjoBVwFj9MUy7hQbvyS0nymB5RwpSQrG0I1Ij0Qibk6+LxuWFb04FRf+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237786; c=relaxed/simple;
	bh=rCANk1Zi5uMLovOEWBu1YxvB9ONePMcQ/CLGhfy8ro0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y9GQpXnYQpejU+sXhTYCDfhVqSFWLiM1ESZEOruL7e3UvlnxkaaObhaK6T+34uZo8XCn7LgZE31x4HJcNjpA8/oxV2bChjPZC/XdAKnguGxACmTT/zXp1fe2wFHnkqmVm+FVY2Jh3iBFigjFNiM14goh5+9UcaD66Qp0xnUGnGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UktrpuND; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758237784; x=1789773784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rCANk1Zi5uMLovOEWBu1YxvB9ONePMcQ/CLGhfy8ro0=;
  b=UktrpuNDJKfLtFog43N3vDGrLYvyDB+ZhXhh65o7ToM5d0MESUzexen3
   wZ8O+EQNa8IQuI6D/U6EjAtjWioZ95pRlWtXR0so2o+8Obmezl1mhDA2W
   Y9J61WfA7OQwo0Zd5biOZqGx2Ky24exrBjwXofrePfULFeSvuB1tZjJGD
   d9EIN/OA2yMABedafHfw1D0RlA9o7Pky7D5C3CvCxFN9Havxma6q/8Pmz
   0Pc/ODW5lBVy6d2MoICcOj0RS6iyobHRMgqEimP+FUP0l6mpCC4hG6Dvj
   Q8iI1M5SAgsmZFT3aQd7aJl3G33ouWexlXgO99sUW43sZIg/HcKzokPHb
   w==;
X-CSE-ConnectionGUID: 8/gEHGv8Qu6gURSAzFBkgg==
X-CSE-MsgGUID: 8D/ziNa7Q3SK0XsCY0dlow==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60735404"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="60735404"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:02 -0700
X-CSE-ConnectionGUID: UvbBiokLQ0aLwrfoWXCFMw==
X-CSE-MsgGUID: r6A+7hBaRQSVBrmsJdh0yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176491414"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:01 -0700
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
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters allocation for sparse memory
Date: Thu, 18 Sep 2025 16:22:14 -0700
Message-ID: <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

init_pamt_metadata() allocates PAMT refcounters for all physical memory up
to max_pfn. It might be suboptimal if the physical memory layout is
discontinuous and has large holes.

The refcount allocation vmalloc allocation. This is necessary to support a
large allocation size. The virtually contiguous property also makes it
easy to find a specific 2MB range’s refcount since it can simply be
indexed.

Since vmalloc mappings support remapping during normal kernel runtime,
switch to an approach that only populates refcount pages for the vmalloc
mapping when there is actually memory for that range. This means any holes
in the physical address space won’t use actual physical memory.

The validity of this memory optimization is based on a couple assumptions:
1. Physical holes in the ram layout are commonly large enough for it to be
   worth it.
2. An alternative approach that looks the refcounts via some more layered
   data structure wouldn’t overly complicate the lookups. Or at least
   more than the complexity of managing the vmalloc mapping.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Add feedback, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v3:
 - Split from "x86/virt/tdx: Allocate reference counters for
   PAMT memory" (Dave)
 - Rename tdx_get_pamt_refcount()->tdx_find_pamt_refcount() (Dave)
 - Drop duplicate pte_none() check (Dave)
 - Align assignments in alloc_pamt_refcount() (Kai)
 - Add comment in pamt_refcount_depopulate() to clarify teardown
   logic (Dave)
 - Drop __va(PFN_PHYS(pte_pfn(ptep_get()))) pile on for simpler method.
   (Dave)
 - Improve log
---
 arch/x86/virt/vmx/tdx/tdx.c | 120 ++++++++++++++++++++++++++++++++----
 1 file changed, 109 insertions(+), 11 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 0ce4181ca352..d4b01656759a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -194,30 +194,119 @@ int tdx_cpu_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_cpu_enable);
 
-/*
- * Allocate PAMT reference counters for all physical memory.
- *
- * It consumes 2MiB for every 1TiB of physical memory.
- */
-static int init_pamt_metadata(void)
+/* Find PAMT refcount for a given physical address */
+static atomic_t *tdx_find_pamt_refcount(unsigned long hpa)
 {
-	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
+	return &pamt_refcounts[hpa / PMD_SIZE];
+}
 
-	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
-		return 0;
+/* Map a page into the PAMT refcount vmalloc region */
+static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void *data)
+{
+	struct page *page;
+	pte_t entry;
 
-	pamt_refcounts = vmalloc(size);
-	if (!pamt_refcounts)
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
 		return -ENOMEM;
 
+	entry = mk_pte(page, PAGE_KERNEL);
+
+	spin_lock(&init_mm.page_table_lock);
+	/*
+	 * PAMT refcount populations can overlap due to rounding of the
+	 * start/end pfn. Make sure another PAMT range didn't already
+	 * populate it.
+	 */
+	if (pte_none(ptep_get(pte)))
+		set_pte_at(&init_mm, addr, pte, entry);
+	else
+		__free_page(page);
+	spin_unlock(&init_mm.page_table_lock);
+
 	return 0;
 }
 
+/*
+ * Allocate PAMT reference counters for the given PFN range.
+ *
+ * It consumes 2MiB for every 1TiB of physical memory.
+ */
+static int alloc_pamt_refcount(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long start, end;
+
+	start = (unsigned long)tdx_find_pamt_refcount(PFN_PHYS(start_pfn));
+	end   = (unsigned long)tdx_find_pamt_refcount(PFN_PHYS(end_pfn + 1));
+	start = round_down(start, PAGE_SIZE);
+	end   = round_up(end, PAGE_SIZE);
+
+	return apply_to_page_range(&init_mm, start, end - start,
+				   pamt_refcount_populate, NULL);
+}
+
+/*
+ * Reserve vmalloc range for PAMT reference counters. It covers all physical
+ * address space up to max_pfn. It is going to be populated from
+ * build_tdx_memlist() only for present memory that available for TDX use.
+ *
+ * It reserves 2MiB of virtual address space for every 1TiB of physical memory.
+ */
+static int init_pamt_metadata(void)
+{
+	struct vm_struct *area;
+	size_t size;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
+	size = round_up(size, PAGE_SIZE);
+
+	area = get_vm_area(size, VM_SPARSE);
+	if (!area)
+		return -ENOMEM;
+
+	pamt_refcounts = area->addr;
+	return 0;
+}
+
+/* Unmap a page from the PAMT refcount vmalloc region */
+static int pamt_refcount_depopulate(pte_t *pte, unsigned long addr, void *data)
+{
+	struct page *page;
+	pte_t entry;
+
+	spin_lock(&init_mm.page_table_lock);
+
+	entry = ptep_get(pte);
+	/* refount allocation is sparse, may not be populated */
+	if (!pte_none(entry)) {
+		pte_clear(&init_mm, addr, pte);
+		page = pte_page(entry);
+		__free_page(page);
+	}
+
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+/* Unmap all PAMT refcount pages and free vmalloc range */
 static void free_pamt_metadata(void)
 {
+	size_t size;
+
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return;
 
+	size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
+	size = round_up(size, PAGE_SIZE);
+
+	apply_to_existing_page_range(&init_mm,
+				     (unsigned long)pamt_refcounts,
+				     size, pamt_refcount_depopulate,
+				     NULL);
 	vfree(pamt_refcounts);
 	pamt_refcounts = NULL;
 }
@@ -288,10 +377,19 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn, nid);
 		if (ret)
 			goto err;
+
+		/* Allocated PAMT refcountes for the memblock */
+		ret = alloc_pamt_refcount(start_pfn, end_pfn);
+		if (ret)
+			goto err;
 	}
 
 	return 0;
 err:
+	/*
+	 * Only free TDX memory blocks here, PAMT refcount pages
+	 * will be freed in the init_tdx_module() error path.
+	 */
 	free_tdx_memlist(tmb_list);
 	return ret;
 }
-- 
2.51.0


