Return-Path: <kvm+bounces-48755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E295AD267A
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0549C16BD5A
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99019221FBD;
	Mon,  9 Jun 2025 19:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GYZhT4Dd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3342B220F30;
	Mon,  9 Jun 2025 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496441; cv=none; b=rRLepc+sJgemhix/AYcCCWUBw+7K0v6IgyRcAiyGaTwG83Lwv2HsspiO0HJN01r8oKHrvu/4XiT9x/vJu/XbyXtVTbJHk4ZTp0l2ibguZt/q/YPGJ6ILdV3GmbJ0zYIFcUejBlLVHLGjqUNHZRcpg02eMqELLJUfNmLhP0G34LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496441; c=relaxed/simple;
	bh=w7pkZDeT2pFDEb3Ky2qV2DXqIV/kyuBmg0NR3kbxln0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6w4PXsLR6zmvdao4vzNjdR7Jrykp/8j2zThAcAXaXFBdofHPPKpnb8KNy7yEsSwmWNY0ni7hY+LnycGnpy9zqK56MmHWxJtPCn224VAYXE9hBqfC3+8OY7DjVjNZsS2gjCxyWhNUo6qyrsT6407JiK8JiWiMBDzkyT1Qn70DKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GYZhT4Dd; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496439; x=1781032439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w7pkZDeT2pFDEb3Ky2qV2DXqIV/kyuBmg0NR3kbxln0=;
  b=GYZhT4Dd1CioqR90hp79OqwxIVnAqUwpdTTKOotbbSjbHeZP3FjlaJHY
   T+nMA3tMdsw6b0uTxMVqaRr2pcytok4U97ZQlnL1+kDzWGYs/AX2IJG9M
   Nd8xQ3qgTry0KDQ+m1S1MApAMXx+i4y+gqrVc51RgKS6hYvG8ogFv447Z
   a8Q9rw2ky/kDZOKGLJQbAIw/vFKx5L293+RGVtE6RsVPdbHzKrv2SIbY4
   rK9oL3uVVQi93Rc1HzyP3mpMotrnnSlzrGhqqpixlNB3ARjWWSCUkY1VM
   EY0yxz8xCeJmEDUzwPtv2oo89jHEDxvtkk3FrG8Xg5P+TYnAhP3CVw21R
   A==;
X-CSE-ConnectionGUID: svclemQ7QuyWGa8CSP5tOw==
X-CSE-MsgGUID: cx7uSABQSwusfVK1ANzrjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51681762"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51681762"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:13:55 -0700
X-CSE-ConnectionGUID: cwfS3GPeSFq2D5kC9dZ8Xg==
X-CSE-MsgGUID: A1UN77I/Sia9lFSwW3TSiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147174164"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa007.jf.intel.com with ESMTP; 09 Jun 2025 12:13:51 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 201A3492; Mon, 09 Jun 2025 22:13:49 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 03/12] x86/virt/tdx: Allocate reference counters for PAMT memory
Date: Mon,  9 Jun 2025 22:13:31 +0300
Message-ID: <20250609191340.2051741-4-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PAMT memory holds metadata for TDX-protected memory. With Dynamic
PAMT, PAMT_4K is allocated on demand. The kernel supplies the TDX module
with a page pair that covers 2M of host physical memory.

The kernel must provide this page pair before using pages from the range
for TDX. If this is not done, any SEAMCALL that attempts to use the
memory will fail.

Allocate reference counters for every 2M range to track PAMT memory
usage. This is necessary to accurately determine when PAMT memory needs
to be allocated and when it can be freed.

This allocation will consume 2MiB for every 1TiB of physical memory.

Tracking PAMT memory usage on the kernel side duplicates what TDX module
does.  It is possible to avoid this by lazily allocating PAMT memory on
SEAMCALL failure and freeing it based on hints provided by the TDX
module when the last user of PAMT memory is no longer present.

However, this approach complicates serialization.

The TDX module takes locks when dealing with PAMT: a shared lock on any
SEAMCALL that uses explicit HPA and an exclusive lock on PAMT.ADD and
PAMT.REMOVE. Any SEAMCALL that uses explicit HPA as an operand may fail
if it races with PAMT.ADD/REMOVE.

Since PAMT is a global resource, to prevent failure the kernel would
need global locking (per-TD is not sufficient). Or, it has to retry on
TDX_OPERATOR_BUSY.

Both options are not ideal, and tracking PAMT usage on the kernel side
seems like a reasonable alternative.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 112 +++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 18179eb26eb9..ad9d7a30989d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -29,6 +29,7 @@
 #include <linux/acpi.h>
 #include <linux/suspend.h>
 #include <linux/idr.h>
+#include <linux/vmalloc.h>
 #include <asm/page.h>
 #include <asm/special_insns.h>
 #include <asm/msr-index.h>
@@ -50,6 +51,8 @@ static DEFINE_PER_CPU(bool, tdx_lp_initialized);
 
 static struct tdmr_info_list tdx_tdmr_list;
 
+static atomic_t *pamt_refcounts;
+
 static enum tdx_module_status_t tdx_module_status;
 static DEFINE_MUTEX(tdx_module_lock);
 
@@ -182,6 +185,102 @@ int tdx_cpu_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_cpu_enable);
 
+static atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
+{
+	return &pamt_refcounts[hpa / PMD_SIZE];
+}
+
+static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void *data)
+{
+	unsigned long vaddr;
+	pte_t entry;
+
+	if (!pte_none(ptep_get(pte)))
+		return 0;
+
+	vaddr = __get_free_page(GFP_KERNEL | __GFP_ZERO);
+	if (!vaddr)
+		return -ENOMEM;
+
+	entry = pfn_pte(PFN_DOWN(__pa(vaddr)), PAGE_KERNEL);
+
+	spin_lock(&init_mm.page_table_lock);
+	if (pte_none(ptep_get(pte)))
+		set_pte_at(&init_mm, addr, pte, entry);
+	else
+		free_page(vaddr);
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+static int pamt_refcount_depopulate(pte_t *pte, unsigned long addr,
+				    void *data)
+{
+	unsigned long vaddr;
+
+	vaddr = (unsigned long)__va(PFN_PHYS(pte_pfn(ptep_get(pte))));
+
+	spin_lock(&init_mm.page_table_lock);
+	if (!pte_none(ptep_get(pte))) {
+		pte_clear(&init_mm, addr, pte);
+		free_page(vaddr);
+	}
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+static int alloc_pamt_refcount(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long start, end;
+
+	start = (unsigned long)tdx_get_pamt_refcount(PFN_PHYS(start_pfn));
+	end = (unsigned long)tdx_get_pamt_refcount(PFN_PHYS(end_pfn + 1));
+	start = round_down(start, PAGE_SIZE);
+	end = round_up(end, PAGE_SIZE);
+
+	return apply_to_page_range(&init_mm, start, end - start,
+				   pamt_refcount_populate, NULL);
+}
+
+static int init_pamt_metadata(void)
+{
+	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
+	struct vm_struct *area;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	/*
+	 * Reserve vmalloc range for PAMT reference counters. It covers all
+	 * physical address space up to max_pfn. It is going to be populated
+	 * from init_tdmr() only for present memory that available for TDX use.
+	 */
+	area = get_vm_area(size, VM_IOREMAP);
+	if (!area)
+		return -ENOMEM;
+
+	pamt_refcounts = area->addr;
+	return 0;
+}
+
+static void free_pamt_metadata(void)
+{
+	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return;
+
+	size = round_up(size, PAGE_SIZE);
+	apply_to_existing_page_range(&init_mm,
+				     (unsigned long)pamt_refcounts,
+				     size, pamt_refcount_depopulate,
+				     NULL);
+	vfree(pamt_refcounts);
+	pamt_refcounts = NULL;
+}
+
 /*
  * Add a memory region as a TDX memory block.  The caller must make sure
  * all memory regions are added in address ascending order and don't
@@ -248,6 +347,10 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn, nid);
 		if (ret)
 			goto err;
+
+		ret = alloc_pamt_refcount(start_pfn, end_pfn);
+		if (ret)
+			goto err;
 	}
 
 	return 0;
@@ -1110,10 +1213,15 @@ static int init_tdx_module(void)
 	 */
 	get_online_mems();
 
-	ret = build_tdx_memlist(&tdx_memlist);
+	/* Reserve vmalloc range for PAMT reference counters */
+	ret = init_pamt_metadata();
 	if (ret)
 		goto out_put_tdxmem;
 
+	ret = build_tdx_memlist(&tdx_memlist);
+	if (ret)
+		goto err_free_pamt_metadata;
+
 	/* Allocate enough space for constructing TDMRs */
 	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdx_sysinfo.tdmr);
 	if (ret)
@@ -1171,6 +1279,8 @@ static int init_tdx_module(void)
 	free_tdmr_list(&tdx_tdmr_list);
 err_free_tdxmem:
 	free_tdx_memlist(&tdx_memlist);
+err_free_pamt_metadata:
+	free_pamt_metadata();
 	goto out_put_tdxmem;
 }
 
-- 
2.47.2


