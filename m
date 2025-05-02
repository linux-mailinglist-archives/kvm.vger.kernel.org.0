Return-Path: <kvm+bounces-45230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E62DAA7301
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:12:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9F071C02BFE
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B0D25C716;
	Fri,  2 May 2025 13:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jm5XCcJt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284B425A64E;
	Fri,  2 May 2025 13:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191336; cv=none; b=ABph4fKH+HNF05e8s+9SphhMgn4HzhsFUhfmoGJWrbgB2LfF9y1f5CQPl6U/2oMbIMw5HMZHtJr4U4QvOGjNj9yKH5p3ds3W93n4z6joe5K14lrLv7SikWLs/KPRKCx0HJZsxujyNLGaCmt9Jq1o6yXFSrkPL0s9QNB+GWbEpeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191336; c=relaxed/simple;
	bh=6KdVYsEBJ/j6nE8ePLlnDGqB/MG4p1xHnjjBkVTUNtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJDu0CSKhkkaIIcRBpScm76RpwiAM6WgdBYY4NcIOOwnv/YQmj/N0eJL15zdE1TcLiPide/mqEttVdWC5LFjMjcPhTCuGnQPn6chJz+eBZ5PNQ444Zkwfma6kN7GNkElX1GfHYdn9m+TAfzLcj7PwZlVYHnzKo6px8znNK2mMwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jm5XCcJt; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191333; x=1777727333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6KdVYsEBJ/j6nE8ePLlnDGqB/MG4p1xHnjjBkVTUNtA=;
  b=jm5XCcJtpLljNy9hcSTBtrgLDvRHB9fXBIXmLeVw7WOYn0Vx9KhGR16H
   dPMvT1mPHQCWusmkg7d04lq7WVO+CUGuF3aYaGBkTwAWUgdgdZHgmUcWh
   fQiE4bBTlvb3RyLNGvd8HCak7SZF0IiHrX1hjnQfFWUrPr1FFnco2SjND
   IQqt9uq9znnPja3wYbCYcQVcELQZQTSzJEZNb8bkvqit1QuHiF5VS38ZW
   tFmtGUn4UwOS1Pau7lcKL5eDrVlmhouCV2GwUOu2qJhxeCBE15TXGIVd+
   AOPXi4yPHJPGoykHgDzJ00+fs+h0azksCPw+TGXhVtGtf2NllYXvd0hmz
   A==;
X-CSE-ConnectionGUID: y5nuyg0BQtyYxs/imU/SRA==
X-CSE-MsgGUID: jEc0ryaXTCeElw3fXTlOkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="58495280"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="58495280"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:51 -0700
X-CSE-ConnectionGUID: 8tZWGe7yT5a8MWhcxhzp+w==
X-CSE-MsgGUID: lJjrM7SrRlu9dwzC/wPHZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="138657786"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa003.fm.intel.com with ESMTP; 02 May 2025 06:08:41 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 40BB51A1; Fri, 02 May 2025 16:08:36 +0300 (EEST)
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
Subject: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Date: Fri,  2 May 2025 16:08:21 +0300
Message-ID: <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
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

Introduce a pair of helpers to allocate and free memory for a given 2M
range. The range is represented by struct page for any memory in the
range and the PAMT memory by a list of pages.

Use per-2M refcounts to detect when PAMT memory has to be allocated and
when it can be freed.

pamt_lock spinlock serializes against races between multiple
tdx_pamt_add() as well as tdx_pamt_add() vs tdx_pamt_put().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/tdx.h   |   2 +
 arch/x86/kvm/vmx/tdx.c       | 123 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_errno.h |   1 +
 3 files changed, 126 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 8091bf5b43cc..42449c054938 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -135,6 +135,8 @@ static inline int tdx_nr_pamt_pages(const struct tdx_sys_info *sysinfo)
 	return sysinfo->tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
 }
 
+atomic_t *tdx_get_pamt_refcount(unsigned long hpa);
+
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..ea7e2d93fb44 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -207,6 +207,10 @@ static bool tdx_operand_busy(u64 err)
 	return (err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY;
 }
 
+static bool tdx_hpa_range_not_free(u64 err)
+{
+	return (err & TDX_SEAMCALL_STATUS_MASK) == TDX_HPA_RANGE_NOT_FREE;
+}
 
 /*
  * A per-CPU list of TD vCPUs associated with a given CPU.
@@ -276,6 +280,125 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
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
+	for (int i = 0; i < tdx_nr_pamt_pages(tdx_sysinfo); i++) {
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
+	hpa = ALIGN_DOWN(hpa, SZ_2M);
+
+	spin_lock(&pamt_lock);
+
+	/* Lost race to other tdx_pamt_add() */
+	if (atomic_read(pamt_refcount) != 0) {
+		atomic_inc(pamt_refcount);
+		spin_unlock(&pamt_lock);
+		tdx_free_pamt_pages(pamt_pages);
+		return 0;
+	}
+
+	err = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pages);
+
+	if (err)
+		tdx_free_pamt_pages(pamt_pages);
+
+	/*
+	 * tdx_hpa_range_not_free() is true if current task won race
+	 * against tdx_pamt_put().
+	 */
+	if (err && !tdx_hpa_range_not_free(err)) {
+		spin_unlock(&pamt_lock);
+		pr_tdx_error(TDH_PHYMEM_PAMT_ADD, err);
+		return -EIO;
+	}
+
+	atomic_set(pamt_refcount, 1);
+	spin_unlock(&pamt_lock);
+	return 0;
+}
+
+static int tdx_pamt_get(struct page *page)
+{
+	unsigned long hpa = page_to_phys(page);
+	atomic_t *pamt_refcount;
+	LIST_HEAD(pamt_pages);
+
+	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
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
+	return tdx_pamt_add(pamt_refcount, hpa, &pamt_pages);
+}
+
+static void tdx_pamt_put(struct page *page)
+{
+	unsigned long hpa = page_to_phys(page);
+	atomic_t *pamt_refcount;
+	LIST_HEAD(pamt_pages);
+	u64 err;
+
+	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
+		return;
+
+	hpa = ALIGN_DOWN(hpa, SZ_2M);
+
+	pamt_refcount = tdx_get_pamt_refcount(hpa);
+	if (!atomic_dec_and_test(pamt_refcount))
+		return;
+
+	spin_lock(&pamt_lock);
+
+	/* Lost race against tdx_pamt_add()? */
+	if (atomic_read(pamt_refcount) != 0) {
+		spin_unlock(&pamt_lock);
+		return;
+	}
+
+	err = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, &pamt_pages);
+	spin_unlock(&pamt_lock);
+
+	if (err) {
+		pr_tdx_error(TDH_PHYMEM_PAMT_REMOVE, err);
+		return;
+	}
+
+	tdx_free_pamt_pages(&pamt_pages);
+}
+
 static void tdx_clear_page(struct page *page)
 {
 	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index 6ff4672c4181..c8a471d6b991 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -18,6 +18,7 @@
 #define TDX_OPERAND_BUSY			0x8000020000000000ULL
 #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
 #define TDX_PAGE_METADATA_INCORRECT		0xC000030000000000ULL
+#define TDX_HPA_RANGE_NOT_FREE			0xC000030400000000ULL
 #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
 #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
 #define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
-- 
2.47.2


