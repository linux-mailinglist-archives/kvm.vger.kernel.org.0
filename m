Return-Path: <kvm+bounces-58062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 856D5B875CB
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 414A1528674
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC52D30170B;
	Thu, 18 Sep 2025 23:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lpNIhyeH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473042F617A;
	Thu, 18 Sep 2025 23:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237786; cv=none; b=oqrHycoFJmo9miSkKWIxF70ctPgMGDVs3P2A9OORGb/yN1tgsCpI3JuGhZGyMGDxNQxue11F5Wcr7FnFoZ8TypM4DwYYLyY2Ioq3DHfv/soZQsG69z9mFSplCFXhW0muy3yV80M8aXf7fLXGr1i6JvRRogdfeMd4AucFYoDZcFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237786; c=relaxed/simple;
	bh=aWyB7JF5bLDMX+kGSxpaidk4YblJnMP2Ty8v8niS64U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U7V9iUKhkxFZgjR/xhRadGr2gtVktZEL3QOjV1349NpXNxMuOzeT3NcETEsM9JBdktzXdJPz+zYc7RheF6fn/DrmlB2QfJs6GH97QbAhLVeM3E3KjkbinE6ajW1qZo7r+6W3UhOxjQ95Xh49w9jIVGyXx+lajh6C1QZ6qraDKpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lpNIhyeH; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758237784; x=1789773784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aWyB7JF5bLDMX+kGSxpaidk4YblJnMP2Ty8v8niS64U=;
  b=lpNIhyeHSpn9Q9elra+ljof+zv3VJpbqtDeUDu9JOFVkTTVY/SIgwI40
   K3+9F1j3/HQOwkrmsO7gCpZFnXXmL8NInJS34DooQaIcylVgR8uNkFyyT
   QHZc6KIwwNZVMA3OVwC/5TU7Hs4elA9HtmexkzY+lBnNwzYEaym5C8GJx
   qF41pr4lWUoi+FBad512K+VucKeQM+vmdq6BgXAMTk0/C6F/fZou4EpOH
   3bozghoHOd6Ds/LAwK9LScks+8S4SkU2Itu1qAf+YDzeP+cfAQ6Ev30zu
   KCmukXxRalBYXJHBmoJNxPiSxg8hao8lSkpkiFhFKrR4DukcLJDpCEnkm
   A==;
X-CSE-ConnectionGUID: Re3M33R4SpifwJj+QgEO0g==
X-CSE-MsgGUID: suaQQXdvRMuotcMdc8yfCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60735411"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="60735411"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:03 -0700
X-CSE-ConnectionGUID: x3iFpARKT0KE8kuPj6R6MQ==
X-CSE-MsgGUID: 6vES700vS+OBHlBA/ClDGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176491419"
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
Subject: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Date: Thu, 18 Sep 2025 16:22:15 -0700
Message-ID: <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
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

Add helpers to use when allocating or preparing pages that need DPAMT
backing. Make them handle races internally for the case of multiple
callers trying operate on the same 2MB range simultaneously.

While the TDX initialization code in arch/x86 uses pages with 2MB
alignment, KVM will need to hand 4KB pages for it to use. Under DPAMT,
these pages will need DPAMT backing 4KB backing.

Add tdx_alloc_page() and tdx_free_page() to handle both page allocation
and DPAMT installation. Make them behave like normal alloc/free functions
where allocation can fail in the case of no memory, but free (with any
necessary DPAMT release) always succeeds. Do this so they can support the
existing TDX flows that require cleanups to succeed. Also create
tdx_pamt_put()/tdx_pamt_get() to handle installing DPAMT 4KB backing for
pages that are already allocated (such as external page tables, or S-EPT
pages).

Since the source of these pages is the page allocator, multiple TDs could
each get 4KB pages that are covered by the same 2MB range. When this
happens only one page pair needs to be installed to cover the 2MB range.
Similarly, when one page is freed, the DPAMT backing cannot be freed until
all TDX pages in the range are no longer in use. Have the helpers manage
these races internally.

So the requirements are that:

1. Free path cannot fail (i.e. no TDX module BUSY errors).
2. Allocation paths need to handle finding that DPAMT backing is already
   installed, and only return an error in the case of no memory, not in the
   case of losing races with other’s trying to operate on the same DPAMT
   range.
3. Free paths cannot fail, and also need to clean up the DPAMT backing
   when the last page in the 2MB range is no longer needed by TDX.

Previous changes allocated refcounts to be used to track how many 4KB
pages are in use by TDX for each 2MB region. So update those inside the
helpers and use them to decide when to actually install the DPAMT backing
pages.

tdx_pamt_put() needs to guarantee the DPAMT is installed before returning
so that racing threads don’t tell the TDX module to operate on the page
before it’s installed. Take a lock while adjusting the refcount and doing
the actual TDH.PHYMEM.PAMT.ADD/REMOVE to make sure these happen
atomically. The lock is heavyweight, but will be optimized in future
changes. Just do the simple solution before any complex improvements.

TDH.PHYMEM.PAMT.ADD/REMOVE take exclusive locks at the granularity each
2MB range. A simultaneous attempt to operate on the same 2MB region would
result in a BUSY error code returned from the SEAMCALL. Since the
invocation of SEAMCALLs are behind a lock, this won’t conflict.

Besides the contention between TDH.PHYMEM.PAMT.ADD/REMOVE, many other
SEAMCALLs take the same 2MB granularity locks as shared. This means any
attempt to operate on the page by the TDX module while simultaneously
doing PAMT.ADD/REMOVE will result in a BUSY error. This should not happen,
as the PAMT pages always has to be installed before giving the pages to
the TDX module anyway.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Add feedback, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v3:
 - Fix hard to follow iteration over struct members.
 - Simplify the code by removing the intermediate lists of pages.
 - Clear PAMT pages before freeing. (Adrian)
 - Rename tdx_nr_pamt_pages(). (Dave)
 - Add comments some comments, but thought the simpler code needed
   less. So not as much as seem to be requested. (Dave)
 - Fix asymmetry in which level of the add/remove helpers global lock is
   held.
 - Split out optimization.
 - Write log.
 - Flatten call hierarchies and adjust errors accordingly.
---
 arch/x86/include/asm/tdx.h  |   6 +
 arch/x86/virt/vmx/tdx/tdx.c | 216 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |   2 +
 3 files changed, 224 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b9bb052f4daa..439dd5c5282e 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -116,6 +116,12 @@ int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
+int tdx_pamt_get(struct page *page);
+void tdx_pamt_put(struct page *page);
+
+struct page *tdx_alloc_page(void);
+void tdx_free_page(struct page *page);
+
 struct tdx_td {
 	/* TD root structure: */
 	struct page *tdr_page;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d4b01656759a..af73b6c2e917 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1997,3 +1997,219 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
+
+/* Number PAMT pages to be provided to TDX module per 2M region of PA */
+static int tdx_dpamt_entry_pages(void)
+{
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
+}
+
+/*
+ * The TDX spec treats the registers like an array, as they are ordered
+ * in the struct. The array size is limited by the number or registers,
+ * so define the max size it could be for worst case allocations and sanity
+ * checking.
+ */
+#define MAX_DPAMT_ARG_SIZE (sizeof(struct tdx_module_args) - \
+			    offsetof(struct tdx_module_args, rdx))
+
+/*
+ * Treat struct the registers like an array that starts at RDX, per
+ * TDX spec. Do some sanitychecks, and return an indexable type.
+ */
+static u64 *dpamt_args_array_ptr(struct tdx_module_args *args)
+{
+	WARN_ON_ONCE(tdx_dpamt_entry_pages() > MAX_DPAMT_ARG_SIZE);
+
+	/*
+	 * FORTIFY_SOUCE could inline this and complain when callers copy
+	 * across fields, which is exactly what this is supposed to be
+	 * used for. Obfuscate it.
+	 */
+	return (u64 *)((u8 *)args + offsetof(struct tdx_module_args, rdx));
+}
+
+static int alloc_pamt_array(u64 *pa_array)
+{
+	struct page *page;
+
+	for (int i = 0; i < tdx_dpamt_entry_pages(); i++) {
+		page = alloc_page(GFP_KERNEL);
+		if (!page)
+			return -ENOMEM;
+		pa_array[i] = page_to_phys(page);
+	}
+
+	return 0;
+}
+
+static void free_pamt_array(u64 *pa_array)
+{
+	for (int i = 0; i < tdx_dpamt_entry_pages(); i++) {
+		if (!pa_array[i])
+			break;
+
+		reset_tdx_pages(pa_array[i], PAGE_SIZE);
+
+		/*
+		 * It might have come from 'prealloc', but this is an error
+		 * path. Don't be fancy, just free them. TDH.PHYMEM.PAMT.ADD
+		 * only modifies RAX, so the encoded array is still in place.
+		 */
+		__free_page(phys_to_page(pa_array[i]));
+	}
+}
+
+/*
+ * Add PAMT memory for the given HPA. Return's negative error code
+ * for kernel side error conditions (-ENOMEM) and 1 for TDX Module
+ * error. In the case of TDX module error, the return code is stored
+ * in tdx_err.
+ */
+static u64 tdh_phymem_pamt_add(unsigned long hpa, u64 *pamt_pa_array)
+{
+	struct tdx_module_args args = {
+		.rcx = hpa,
+	};
+	u64 *args_array = dpamt_args_array_ptr(&args);
+
+	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
+
+	/* Copy PAMT page PA's into the struct per the TDX ABI */
+	memcpy(args_array, pamt_pa_array,
+	       tdx_dpamt_entry_pages() * sizeof(*args_array));
+
+	return seamcall(TDH_PHYMEM_PAMT_ADD, &args);
+}
+
+/* Remove PAMT memory for the given HPA */
+static u64 tdh_phymem_pamt_remove(unsigned long hpa, u64 *pamt_pa_array)
+{
+	struct tdx_module_args args = {
+		.rcx = hpa,
+	};
+	u64 *args_array = dpamt_args_array_ptr(&args);
+	u64 ret;
+
+	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
+
+	ret = seamcall_ret(TDH_PHYMEM_PAMT_REMOVE, &args);
+	if (ret)
+		return ret;
+
+	/* Copy PAMT page PA's out of the struct per the TDX ABI */
+	memcpy(pamt_pa_array, args_array,
+	       tdx_dpamt_entry_pages() * sizeof(u64));
+
+	return ret;
+}
+
+/* Serializes adding/removing PAMT memory */
+static DEFINE_SPINLOCK(pamt_lock);
+
+/* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
+int tdx_pamt_get(struct page *page)
+{
+	unsigned long hpa = ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
+	u64 pamt_pa_array[MAX_DPAMT_ARG_SIZE];
+	atomic_t *pamt_refcount;
+	u64 tdx_status;
+	int ret;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	ret = alloc_pamt_array(pamt_pa_array);
+	if (ret)
+		return ret;
+
+	pamt_refcount = tdx_find_pamt_refcount(hpa);
+
+	scoped_guard(spinlock, &pamt_lock) {
+		if (atomic_read(pamt_refcount))
+			goto out_free;
+
+		tdx_status = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pa_array);
+
+		if (IS_TDX_SUCCESS(tdx_status)) {
+			atomic_inc(pamt_refcount);
+		} else {
+			pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", tdx_status);
+			goto out_free;
+		}
+	}
+
+	return ret;
+out_free:
+	free_pamt_array(pamt_pa_array);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdx_pamt_get);
+
+/*
+ * Drop PAMT refcount for the given page and free PAMT memory if it is no
+ * longer needed.
+ */
+void tdx_pamt_put(struct page *page)
+{
+	unsigned long hpa = ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
+	u64 pamt_pa_array[MAX_DPAMT_ARG_SIZE];
+	atomic_t *pamt_refcount;
+	u64 tdx_status;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return;
+
+	hpa = ALIGN_DOWN(hpa, PMD_SIZE);
+
+	pamt_refcount = tdx_find_pamt_refcount(hpa);
+
+	scoped_guard(spinlock, &pamt_lock) {
+		if (!atomic_read(pamt_refcount))
+			return;
+
+		tdx_status = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, pamt_pa_array);
+
+		if (IS_TDX_SUCCESS(tdx_status)) {
+			atomic_dec(pamt_refcount);
+		} else {
+			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", tdx_status);
+			return;
+		}
+	}
+
+	free_pamt_array(pamt_pa_array);
+}
+EXPORT_SYMBOL_GPL(tdx_pamt_put);
+
+/* Allocate a page and make sure it is backed by PAMT memory */
+struct page *tdx_alloc_page(void)
+{
+	struct page *page;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return NULL;
+
+	if (tdx_pamt_get(page)) {
+		__free_page(page);
+		return NULL;
+	}
+
+	return page;
+}
+EXPORT_SYMBOL_GPL(tdx_alloc_page);
+
+/* Free a page and release its PAMT memory */
+void tdx_free_page(struct page *page)
+{
+	if (!page)
+		return;
+
+	tdx_pamt_put(page);
+	__free_page(page);
+}
+EXPORT_SYMBOL_GPL(tdx_free_page);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 82bb82be8567..46c4214b79fb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -46,6 +46,8 @@
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
+#define TDH_PHYMEM_PAMT_ADD		58
+#define TDH_PHYMEM_PAMT_REMOVE		59
 
 /*
  * SEAMCALL leaf:
-- 
2.51.0


