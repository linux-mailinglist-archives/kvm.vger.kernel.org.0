Return-Path: <kvm+bounces-45219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1E7BAA72E5
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 711B0168680
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63702550D6;
	Fri,  2 May 2025 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E3+yNsXY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42104253F34;
	Fri,  2 May 2025 13:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191323; cv=none; b=rE+7BQ50oJHJcyMQSeprdkTcclBu6A1NModfEeOyU6iEPAXzhTCbQE9dfU+0avM1TXUKEaI4/v/GlSpYtHfnn9bBcAablmSLg7ZX0JZkuoxHGh+9qJ5POhVvArk66YbOvMY5/tBYrz1RhshHT249evXXZ41RrX66kLaQzM99UHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191323; c=relaxed/simple;
	bh=koLJLqsdXQLlsDvglmbIut6PeC1m9lsxMFhLJpepDOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNJPopn3rePMQI49JIpsPS96bEVdgvJFIo+LlWP0m2KTDycTbYc1aA+lKjrG669Vph2O9MFGmwv6ZTOdiQQHfgnIq3YVal4opQo/XFpEXWtY/fjjJGEWAV4LCujtDqwcxfYn8wtmFjtzBRgd3fQIn41eiIaPNbZ5CUF4glXW83s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E3+yNsXY; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191321; x=1777727321;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=koLJLqsdXQLlsDvglmbIut6PeC1m9lsxMFhLJpepDOg=;
  b=E3+yNsXYj2zmPZORQ6ihdD98+LpecCujWDRwoc/MN9vONsIU9tarhgc9
   HXl4gBvFjzHZHW/JkFG0OsacGX/WuvQPNsEylmZJCLUYqjDZoqdqYrF8G
   56VnRvFG0GAs5HG6du5TKRt49jOhu1ZinyiONvqTYGVmbrhzBze/RgDLH
   3nXuDZq4zKEv46PqaG/gLhGycBtaYN37drmMg2Ww0HHrNXl0ZuczA8mPf
   33JO0Teguud8aiBZm0wKLqADvhLLFA++GlErZlro9CasfcjzVKofEuFg8
   5adWKaPjtpXfN2+JR7vn5lloyVnJeEhWeeUFV2VwrPuB2tVSC3FAFynls
   w==;
X-CSE-ConnectionGUID: NUA9G5x1TAiI3tp7WaI4Cw==
X-CSE-MsgGUID: tKX+6cM+SaiskHVdyPWP7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="58495250"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="58495250"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:41 -0700
X-CSE-ConnectionGUID: X0dBsm4/T1OHQX1RNbYFZQ==
X-CSE-MsgGUID: IBErx+7zSeuwKQ7RN/B3RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="138657775"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa003.fm.intel.com with ESMTP; 02 May 2025 06:08:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 1E3241AC; Fri, 02 May 2025 16:08:36 +0300 (EEST)
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
Subject: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for PAMT memory
Date: Fri,  2 May 2025 16:08:18 +0300
Message-ID: <20250502130828.4071412-3-kirill.shutemov@linux.intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 113 +++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c8bfd765e451..00e07a0c908a 100644
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
 
@@ -1035,9 +1038,108 @@ static int config_global_keyid(void)
 	return ret;
 }
 
+atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
+{
+	return &pamt_refcounts[hpa / PMD_SIZE];
+}
+EXPORT_SYMBOL_GPL(tdx_get_pamt_refcount);
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
+static int alloc_tdmr_pamt_refcount(struct tdmr_info *tdmr)
+{
+	unsigned long start, end;
+
+	start = (unsigned long)tdx_get_pamt_refcount(tdmr->base);
+	end = (unsigned long)tdx_get_pamt_refcount(tdmr->base + tdmr->size);
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
+	size = round_up(size, PAGE_SIZE);
+	apply_to_existing_page_range(&init_mm,
+				     (unsigned long)pamt_refcounts,
+				     size, pamt_refcount_depopulate,
+				     NULL);
+	vfree(pamt_refcounts);
+	pamt_refcounts = NULL;
+}
+
 static int init_tdmr(struct tdmr_info *tdmr)
 {
 	u64 next;
+	int ret;
+
+	ret = alloc_tdmr_pamt_refcount(tdmr);
+	if (ret)
+		return ret;
 
 	/*
 	 * Initializing a TDMR can be time consuming.  To avoid long
@@ -1048,7 +1150,6 @@ static int init_tdmr(struct tdmr_info *tdmr)
 		struct tdx_module_args args = {
 			.rcx = tdmr->base,
 		};
-		int ret;
 
 		ret = seamcall_prerr_ret(TDH_SYS_TDMR_INIT, &args);
 		if (ret)
@@ -1134,10 +1235,15 @@ static int init_tdx_module(void)
 	if (ret)
 		goto err_reset_pamts;
 
+	/* Reserve vmalloc range for PAMT reference counters */
+	ret = init_pamt_metadata();
+	if (ret)
+		goto err_reset_pamts;
+
 	/* Initialize TDMRs to complete the TDX module initialization */
 	ret = init_tdmrs(&tdx_tdmr_list);
 	if (ret)
-		goto err_reset_pamts;
+		goto err_free_pamt_metadata;
 
 	pr_info("%lu KB allocated for PAMT\n", tdmrs_count_pamt_kb(&tdx_tdmr_list));
 
@@ -1149,6 +1255,9 @@ static int init_tdx_module(void)
 	put_online_mems();
 	return ret;
 
+err_free_pamt_metadata:
+	free_pamt_metadata();
+
 err_reset_pamts:
 	/*
 	 * Part of PAMTs may already have been initialized by the
-- 
2.47.2


