Return-Path: <kvm+bounces-64034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C4FC76D07
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id C629E2F0D0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD622957B6;
	Fri, 21 Nov 2025 00:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hwm+TSK1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C63727C84E;
	Fri, 21 Nov 2025 00:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686307; cv=none; b=I6MCKLN0xc3zAR+g9LdtOi+bS3QTOfM+M7FKMo5W+TiFfbBJR/R3JjTZkXjKkNnOXqK77eDsTVINKPR2BBHJilO7AMIRcxs/cF8OCwmVYhHsnGaKwWvHgVB2VUzzokREgSRAJuOF1VuHTgxk5QFo3ZMYIQOmzzcVX4VZpkaZYQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686307; c=relaxed/simple;
	bh=6ditKQEwLGNNw4WszuVeRpNXeaOTTzhGUAT8kkxlvYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=btty19C+s8bj06vKlslLHmmKorYEZLPCnM56xRQLmCB/bJz0lkfnZS4g5qpNlI/sR6Rd9smuyvDpHnqo3e0AmNv00vK9ubTZbkArjVG778yqnDzXA/vKH7QJHoAYGKTZPSGNDHujlKq6/7FYDuIrQVxv3ATRztOvWMDv6kBk91k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hwm+TSK1; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686306; x=1795222306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ditKQEwLGNNw4WszuVeRpNXeaOTTzhGUAT8kkxlvYM=;
  b=Hwm+TSK1QsYXiQ32QWONtbnNEzGu3GZ0b83CnXDC/hYOlQizzKs61w6D
   IBxOqzL0AuKMLb2zwQBmqApGmKRPs9IlHZegzbi+GFaqqJqtF31l6ruSt
   iXQyU7I7kECtlXcn336Ym2EPFWLisIXZBvQS/3uHPHdwSWS5+ICUFlLct
   XVklk4CQn5tMpoH9IQdmioT4Qb5f57BHam9lTd5sd+3wcr12YzKsSt5IR
   sU5WcbD97X9BzOBwSOWOg4Pr3rxHGkw4PzJIYkdBzwoXBVmgdWfBX3U/3
   VOIxewCiG8pjL8mGYSPqTN2dowv0fe41uJ70ewd2gDhzA+49GmP1snt+0
   w==;
X-CSE-ConnectionGUID: 3DeylPoCTI+QRG1CAexOHg==
X-CSE-MsgGUID: 1WiAZu+ISIGvWfPpJTHjYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780759"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780759"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:43 -0800
X-CSE-ConnectionGUID: iCe9v2eeToeFnf8xXAEuIA==
X-CSE-MsgGUID: srluBitBTXi+ORvBwUI2BA==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:43 -0800
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
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation for sparse memory
Date: Thu, 20 Nov 2025 16:51:15 -0800
Message-ID: <20251121005125.417831-7-rick.p.edgecombe@intel.com>
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

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

init_pamt_metadata() allocates PAMT refcounts for all physical memory up
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
v4:
 - Fix refcount allocation size calculation. (Kai, Binbin)
 - Fix/improve comments. (Kai, Binbin)
 - Simplify tdx_find_pamt_refcount() implemenation and callers by making
   it take a PFN and calculating it directly rather than going through a
   PA intermediate.
 - Check tdx_supports_dynamic_pamt() in alloc_pamt_refcount() to prevent
   crash when TDX module does not support DPAMT. (Kai)
 - Log change refcounters->refcount to be consistent

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
 arch/x86/virt/vmx/tdx/tdx.c | 136 +++++++++++++++++++++++++++++++++---
 1 file changed, 125 insertions(+), 11 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c28d4d11736c..edf9182ed86d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -194,30 +194,135 @@ int tdx_cpu_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_cpu_enable);
 
-/*
- * Allocate PAMT reference counters for all physical memory.
- *
- * It consumes 2MiB for every 1TiB of physical memory.
- */
-static int init_pamt_metadata(void)
+/* Find PAMT refcount for a given physical address */
+static atomic_t *tdx_find_pamt_refcount(unsigned long pfn)
 {
-	size_t size = DIV_ROUND_UP(max_pfn, PTRS_PER_PTE) * sizeof(*pamt_refcounts);
+	/* Find which PMD a PFN is in. */
+	unsigned long index = pfn >> (PMD_SHIFT - PAGE_SHIFT);
 
-	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
-		return 0;
+	return &pamt_refcounts[index];
+}
 
-	pamt_refcounts = __vmalloc(size, GFP_KERNEL | __GFP_ZERO);
-	if (!pamt_refcounts)
+/* Map a page into the PAMT refcount vmalloc region */
+static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void *data)
+{
+	struct page *page;
+	pte_t entry;
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
 		return -ENOMEM;
 
+	entry = mk_pte(page, PAGE_KERNEL);
+
+	spin_lock(&init_mm.page_table_lock);
+	/*
+	 * PAMT refcount populations can overlap due to rounding of the
+	 * start/end pfn. Make sure the PAMT range is only populated once.
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
+	unsigned long refcount_first, refcount_last;
+	unsigned long mapping_start, mapping_end;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	/*
+	 * 'start_pfn' is inclusive and 'end_pfn' is exclusive. Find the
+	 * range of refcounts the pfn range will need.
+	 */
+	refcount_first = (unsigned long)tdx_find_pamt_refcount(start_pfn);
+	refcount_last   = (unsigned long)tdx_find_pamt_refcount(end_pfn - 1);
+
+	/*
+	 * Calculate the page aligned range that includes the refcounts. The
+	 * teardown logic needs to handle potentially overlapping refcount
+	 * mappings resulting from the alignments.
+	 */
+	mapping_start = round_down(refcount_first, PAGE_SIZE);
+	mapping_end   = round_up(refcount_last + sizeof(*pamt_refcounts), PAGE_SIZE);
+
+
+	return apply_to_page_range(&init_mm, mapping_start, mapping_end - mapping_start,
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
+	size = DIV_ROUND_UP(max_pfn, PTRS_PER_PTE) * sizeof(*pamt_refcounts);
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
+	/* refcount allocation is sparse, may not be populated */
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
@@ -288,10 +393,19 @@ static int build_tdx_memlist(struct list_head *tmb_list)
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
2.51.2


