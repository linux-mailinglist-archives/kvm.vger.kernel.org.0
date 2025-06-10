Return-Path: <kvm+bounces-48805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C491AD3BB1
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 16:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C6253A68CA
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 14:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60B221C9F5;
	Tue, 10 Jun 2025 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="czCHzkSL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC3321B909;
	Tue, 10 Jun 2025 14:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749567089; cv=none; b=EBAGAx+7LtyYzhgb81XhQSz9tjOY3lm4LbBl+tFSY9LH70dtlSsKx3q5jeKoya58qyeow1XELTQOAw8VCE9KLsVRT73wKbcL4y3koyVF99ipuZcmcpFAqoBmBVfdrTizCNnDlcumAeQceSLjATD8YL6kKfetRUeh14O3QSrzmDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749567089; c=relaxed/simple;
	bh=9yMJDZ9WoOJRa9Otxp6Jv7RdN68viaG6fDo7bjYTSHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7ZmQQ7pQRXC7FdVy6ki11+Z3UngekbrMlyESBAwONGDhnrlp7mUnvfm2wbZCUvOvGRDvyEmG+Ys441dflCzmhOV7utKwmoQ9//Stgi36QZbgrW8RKwq1addCm90xMWvqLG2QhyF8rPLDeZviASe+hKii47EfwKj+dWSagjWxRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=czCHzkSL; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749567086; x=1781103086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9yMJDZ9WoOJRa9Otxp6Jv7RdN68viaG6fDo7bjYTSHA=;
  b=czCHzkSLV4ffNVseqMbR14Q6X7AA9KaKbPor1mmCtFt107ojUnFlOT1B
   uNP0jlU0l/CpkfPSvI7+WQLgNekl1FRfegO2r3M8a6ZhKvuooIv26vne+
   3uL8AkTIQSZNvvrTqCMx2o/5QGyid0E9MhC9lh1DWr+3105O9bPKU97SB
   dfdetNc9gjp5sukS/QF7lKfTFENjoZ9IntJAdbKqnDfvD6ZzOsW3r1EGy
   7viNTAj5f2Fb/9jrhcmIDAD7v/LzRNlmFIrpp4/XCUzwpZEIJ/FVgPwlu
   VB378nHeGubFo5ZEeNdLcukiIzVk5hc+KerdC0HUiIrBIrEoWSsDKRGPr
   A==;
X-CSE-ConnectionGUID: +NwP0mlMTB+t+BoAzMpvdg==
X-CSE-MsgGUID: 4POE9cqOR5K3wiPag1mtPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51562413"
X-IronPort-AV: E=Sophos;i="6.16,225,1744095600"; 
   d="scan'208";a="51562413"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 07:51:26 -0700
X-CSE-ConnectionGUID: CD71CfkKTcKGlqaE2EtGEQ==
X-CSE-MsgGUID: GOBLBd6NR6KeqXSTpnI5lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,225,1744095600"; 
   d="scan'208";a="146775536"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa010.jf.intel.com with ESMTP; 10 Jun 2025 07:51:23 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id E335A192; Tue, 10 Jun 2025 17:51:20 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: chao.gao@intel.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kirill.shutemov@linux.intel.com,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org,
	yan.y.zhao@intel.com
Subject: [PATCHv2.1 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Date: Tue, 10 Jun 2025 17:51:16 +0300
Message-ID: <20250610145116.2502206-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <aEeaJH1KqZ38tgKi@intel.com>
References: <aEeaJH1KqZ38tgKi@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new helpers allocate and free pages that can be used for a TDs.

Besides page allocation and freeing, these helpers also take care about
managing PAMT memory, if kernel runs on a platform with Dynamic PAMT
supported.

tdx_pamt_get()/put() helpers take care of PAMT allocation/freeing and
its refcounting.

PAMT memory is allocated when refcount for the 2M range crosses from 0
to 1 and gets freed back on when it is dropped to zero. These
transitions can happen concurrently and pamt_lock spinlock serializes
them.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/tdx.h       |   3 +
 arch/x86/include/asm/tdx_errno.h |   6 +
 arch/x86/virt/vmx/tdx/tdx.c      | 224 +++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h      |   2 +
 4 files changed, 235 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 583d6fe66821..d9a77147412f 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -115,6 +115,9 @@ int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
+struct page *tdx_alloc_page(void);
+void tdx_free_page(struct page *page);
+
 struct tdx_td {
 	/* TD root structure: */
 	struct page *tdr_page;
diff --git a/arch/x86/include/asm/tdx_errno.h b/arch/x86/include/asm/tdx_errno.h
index d418934176e2..0b3332c2d6b2 100644
--- a/arch/x86/include/asm/tdx_errno.h
+++ b/arch/x86/include/asm/tdx_errno.h
@@ -18,6 +18,7 @@
 #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
 #define TDX_RND_NO_ENTROPY			0x8000020300000000ULL
 #define TDX_PAGE_METADATA_INCORRECT		0xC000030000000000ULL
+#define TDX_HPA_RANGE_NOT_FREE			0xC000030400000000ULL
 #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
 #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
 #define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
@@ -86,5 +87,10 @@ static inline bool tdx_operand_busy(u64 err)
 {
 	return tdx_status(err) == TDX_OPERAND_BUSY;
 }
+
+static inline bool tdx_hpa_range_not_free(u64 err)
+{
+	return tdx_status(err) == TDX_HPA_RANGE_NOT_FREE;
+}
 #endif /* __ASSEMBLER__ */
 #endif /* _X86_TDX_ERRNO_H */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ad9d7a30989d..3830fbc06397 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2000,3 +2000,227 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
+
+static int tdx_nr_pamt_pages(void)
+{
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
+}
+
+static u64 tdh_phymem_pamt_add(unsigned long hpa,
+			       struct list_head *pamt_pages)
+{
+	struct tdx_module_args args = {
+		.rcx = hpa,
+	};
+	struct page *page;
+	u64 *p;
+
+	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
+
+	p = &args.rdx;
+	list_for_each_entry(page, pamt_pages, lru) {
+		*p = page_to_phys(page);
+		p++;
+	}
+
+	return seamcall(TDH_PHYMEM_PAMT_ADD, &args);
+}
+
+static u64 tdh_phymem_pamt_remove(unsigned long hpa,
+				  struct list_head *pamt_pages)
+{
+	struct tdx_module_args args = {
+		.rcx = hpa,
+	};
+	struct page *page;
+	u64 *p, ret;
+
+	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
+
+	ret = seamcall_ret(TDH_PHYMEM_PAMT_REMOVE, &args);
+	if (ret)
+		return ret;
+
+	p = &args.rdx;
+	for (int i = 0; i < tdx_nr_pamt_pages(); i++) {
+		page = phys_to_page(*p);
+		list_add(&page->lru, pamt_pages);
+		p++;
+	}
+
+	return ret;
+}
+
+static DEFINE_SPINLOCK(pamt_lock);
+
+static void tdx_free_pamt_pages(struct list_head *pamt_pages)
+{
+	struct page *page;
+
+	while ((page = list_first_entry_or_null(pamt_pages, struct page, lru))) {
+		list_del(&page->lru);
+		__free_page(page);
+	}
+}
+
+static int tdx_alloc_pamt_pages(struct list_head *pamt_pages)
+{
+	for (int i = 0; i < tdx_nr_pamt_pages(); i++) {
+		struct page *page = alloc_page(GFP_KERNEL);
+		if (!page) {
+			tdx_free_pamt_pages(pamt_pages);
+			return -ENOMEM;
+		}
+		list_add(&page->lru, pamt_pages);
+	}
+	return 0;
+}
+
+/*
+ * Returns >=0 on success. -errno on failure.
+ *
+ * Non-zero return value indicates that the pamt_pages unused and can be freed.
+ */
+static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
+			struct list_head *pamt_pages)
+{
+	u64 err;
+
+	guard(spinlock)(&pamt_lock);
+
+	hpa = ALIGN_DOWN(hpa, PMD_SIZE);
+
+	/*
+	 * Lost race to other tdx_pamt_add(). Other task has already allocated
+	 * PAMT memory for the HPA.
+	 *
+	 * Return 1 to indicate that pamt_pages is unused and can be freed.
+	 */
+	if (atomic_read(pamt_refcount) != 0) {
+		atomic_inc(pamt_refcount);
+		return 1;
+	}
+
+	err = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pages);
+
+	/*
+	 * tdx_hpa_range_not_free() is true if current task won race
+	 * against tdx_pamt_put().
+	 */
+	if (err && !tdx_hpa_range_not_free(err)) {
+		pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", err);
+		return -EIO;
+	}
+
+	atomic_set(pamt_refcount, 1);
+
+	/*
+	 * Current task won race against tdx_pamt_put() and prevented it
+	 * from freeing PAMT memory.
+	 *
+	 * Return 1 to indicate that pamt_pages is unused and can be freed.
+	 */
+	if (tdx_hpa_range_not_free(err))
+		return 1;
+
+	return 0;
+}
+
+static int tdx_pamt_get(struct page *page, enum pg_level level)
+{
+	unsigned long hpa = page_to_phys(page);
+	atomic_t *pamt_refcount;
+	LIST_HEAD(pamt_pages);
+	int ret;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	/*
+	 * Only PAMT_4K is allocated dynamically. PAMT_2M and PAMT_1G is
+	 * allocated statically on TDX module initialization.
+	 */
+	if (level != PG_LEVEL_4K)
+		return 0;
+
+	pamt_refcount = tdx_get_pamt_refcount(hpa);
+	WARN_ON_ONCE(atomic_read(pamt_refcount) < 0);
+
+	if (atomic_inc_not_zero(pamt_refcount))
+		return 0;
+
+	if (tdx_alloc_pamt_pages(&pamt_pages))
+		return -ENOMEM;
+
+	ret = tdx_pamt_add(pamt_refcount, hpa, &pamt_pages);
+	if (ret)
+		tdx_free_pamt_pages(&pamt_pages);
+
+	return ret >= 0 ? 0 : ret;
+}
+
+static void tdx_pamt_put(struct page *page, enum pg_level level)
+{
+	unsigned long hpa = page_to_phys(page);
+	atomic_t *pamt_refcount;
+	LIST_HEAD(pamt_pages);
+	u64 err;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return;
+
+	if (level != PG_LEVEL_4K)
+		return;
+
+	hpa = ALIGN_DOWN(hpa, PMD_SIZE);
+
+	pamt_refcount = tdx_get_pamt_refcount(hpa);
+	if (!atomic_dec_and_test(pamt_refcount))
+		return;
+
+	scoped_guard(spinlock, &pamt_lock) {
+		/* Lost race against tdx_pamt_add()? */
+		if (atomic_read(pamt_refcount) != 0)
+			return;
+
+		err = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, &pamt_pages);
+
+		if (err) {
+			atomic_inc(pamt_refcount);
+			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", err);
+			return;
+		}
+	}
+
+	tdx_free_pamt_pages(&pamt_pages);
+}
+
+struct page *tdx_alloc_page(void)
+{
+	struct page *page;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return NULL;
+
+	if (tdx_pamt_get(page, PG_LEVEL_4K)) {
+		__free_page(page);
+		return NULL;
+	}
+
+	return page;
+}
+EXPORT_SYMBOL_GPL(tdx_alloc_page);
+
+void tdx_free_page(struct page *page)
+{
+	if (!page)
+		return;
+
+	tdx_pamt_put(page, PG_LEVEL_4K);
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
2.47.2


