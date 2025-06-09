Return-Path: <kvm+bounces-48753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDC9EAD2674
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 602793B15C7
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4ED221270;
	Mon,  9 Jun 2025 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gMSr+kFe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269CE21E08A;
	Mon,  9 Jun 2025 19:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496439; cv=none; b=TB/l3wsK8d3SN0M8QR6421w9jfKfaXQsDZqie12VkxyoemQhQVj8Rpz6RCl79jMm2R+/rBJX4WlLc5ZemPAnNAtlyDCP8XK/Cs3GkKf04ElzTY9cF7QIQyM7d41m8BqD/vKe9+IIb2uU6JsMn5o2Nnhxvxoob5rMrtR1sgjPMJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496439; c=relaxed/simple;
	bh=8CmXDZNtUgRwbG5heuuxgJssDszuLMnl/EJ2jEgttpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMktaxMB4wABv7ZdcZ23VeFZnYHCM7QeSRjotY62yn5ZoHg073ITuaY2r3+L+cL7qjAjry65ZdFrK63LFwUWhOmKM90XehML2LQ8arS2gZI02LY6tNFRtIrLIBPPanI/2tnajPwRq3twGGbGYkHoh6JUKjRTEB4FzEZ/EGpc+DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gMSr+kFe; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496437; x=1781032437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8CmXDZNtUgRwbG5heuuxgJssDszuLMnl/EJ2jEgttpc=;
  b=gMSr+kFePmE9b/KROqrF39Kxd8CIdFK+O2kUQvwJO5/RsMknbVRaiqXz
   Jg6D/ZIiCVrf3+n9Pb1DgeyD9PoxiR59G4j0q1pp0vWZSwG00vBJeyb48
   Km4vvqNHcLIHVfXsxNJoIOpvQPM5evHpB1ylmBQ3xcujh2dW4JX47RkBZ
   dsThW9XaYNiwnfxlrOlC41AzjfWvnuzcXC8Qz6qWNnAujyqlkEGQrlvrh
   0k0vMdWmDtkm9wZ2PDFhoyqj7tX7dLiAp7vPocMawKVA1x0FcVPtR7MkT
   Xdiaqb8hahDg1a4/gR+XK2HX5kz/b2mYQrIjeSY/+v/FVMq6C6Z9U/vgL
   Q==;
X-CSE-ConnectionGUID: 6RIVesiDSQek+1LlQRf9vw==
X-CSE-MsgGUID: Vs+IUYbkQMa35BFClz+HAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51681750"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51681750"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:13:55 -0700
X-CSE-ConnectionGUID: kS/Po0pETxSlbmv6Ks8ilA==
X-CSE-MsgGUID: /yQorKbQQVqPFnzMa2ckrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147174159"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa007.jf.intel.com with ESMTP; 09 Jun 2025 12:13:51 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 308CA4EA; Mon, 09 Jun 2025 22:13:49 +0300 (EEST)
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
Subject: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Date: Mon,  9 Jun 2025 22:13:32 +0300
Message-ID: <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c      | 205 +++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h      |   2 +
 4 files changed, 216 insertions(+)

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
index ad9d7a30989d..c514c60e8c8d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2000,3 +2000,208 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
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
+		if (!page)
+			goto fail;
+		list_add(&page->lru, pamt_pages);
+	}
+	return 0;
+fail:
+	tdx_free_pamt_pages(pamt_pages);
+	return -ENOMEM;
+}
+
+static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
+			struct list_head *pamt_pages)
+{
+	u64 err;
+
+	guard(spinlock)(&pamt_lock);
+
+	hpa = ALIGN_DOWN(hpa, PMD_SIZE);
+
+	/* Lost race to other tdx_pamt_add() */
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


