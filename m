Return-Path: <kvm+bounces-48757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06854AD267D
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0E8A17011F
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18908222566;
	Mon,  9 Jun 2025 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q8eb9Qwq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B376A221262;
	Mon,  9 Jun 2025 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496441; cv=none; b=DsFrxKn98SjL15IiZRPbVaq5j+lHFH4qwl8N46jmJcBi9ZZcB2JyoQkPe9rDul9XVHm9mU+WNpCHPZGzj1jQC42/7r7eVS7H1BlddglRzKFnXha9rj5aB5OMg+WwqPzvbwtriHwhkiYaIt41Bp1MT4XebgmaZgwgtsXIrwiY1NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496441; c=relaxed/simple;
	bh=1KtN0Q8dMeZGdFmpkljFfijLNOzTCQGangJAVHHPvZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQcZice0w7BY0fjI64faiMIJaIItxW88Wrqwoy9VXWaHU8jkS8fsMDdanrtbKfGdn8icCwQY5L18TBfTlTW/wmxGXHmEBkIfLLqD1Rs7+KbQHJo8NFbqAnysklx5/0DyF9PSbe8rmPtmWvTRE0FjqRnk3af5QxqBeXDRpF+9Jc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q8eb9Qwq; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496440; x=1781032440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1KtN0Q8dMeZGdFmpkljFfijLNOzTCQGangJAVHHPvZw=;
  b=Q8eb9QwqZ/YcAubBOW8MgvbPD44QDbBcrUb54aDgC/ET6DfslFwwET2F
   KZy2Herac4zAbE/TXYof6FA1DEhSEOsv40Tp31UsOK2wwOrpAm1yepDaY
   b64Ev2LPxIrcCpBYHw1m5Hlhdpj0PCaecSG0PKU9ecwyIbeF/XETcO+m1
   Ax0DlGnkKwKhdidoIeOkRPJIEpEkFotRzwEhpORlNZmgaA+elzlr2ddzl
   S0m2yeWgV/ADlXtOcM+JKKq+dWrkU7KVcdBocK9QVSuhuatxtxheWW2vp
   gzEHz99MlU+FKhC0JH8qaQrC4rzQpU7uidYU3ESSpCNpOby/9GaIS5rY0
   g==;
X-CSE-ConnectionGUID: SkCBoHOkQVeMX7h5oQHtEg==
X-CSE-MsgGUID: WySUYMJRT2yy/Ap/VY87SA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51681780"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51681780"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:13:59 -0700
X-CSE-ConnectionGUID: vP8mJcvNSwqMwssTTfOWiQ==
X-CSE-MsgGUID: S03nyYFkR2W7J4TU4fWmrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147174188"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa007.jf.intel.com with ESMTP; 09 Jun 2025 12:13:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 5BD8DA45; Mon, 09 Jun 2025 22:13:49 +0300 (EEST)
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
Subject: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
Date: Mon,  9 Jun 2025 22:13:36 +0300
Message-ID: <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
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

There are two distinct cases when the kernel needs to allocate PAMT
memory in the fault path: for SEPT page tables in tdx_sept_link_private_spt()
and for leaf pages in tdx_sept_set_private_spte().

These code paths run in atomic context. Use a pre-allocated per-VCPU
pool for memory allocations.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/tdx.h  |  4 ++++
 arch/x86/kvm/vmx/tdx.c      | 40 ++++++++++++++++++++++++++++++++-----
 arch/x86/virt/vmx/tdx/tdx.c | 21 +++++++++++++------
 virt/kvm/kvm_main.c         |  1 +
 4 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 47092eb13eb3..39f8dd7e0f06 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -116,6 +116,10 @@ u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
 int tdx_nr_pamt_pages(void);
+int tdx_pamt_get(struct page *page, enum pg_level level,
+		 struct page *(alloc)(void *data), void *data);
+void tdx_pamt_put(struct page *page, enum pg_level level);
+
 struct page *tdx_alloc_page(void);
 void tdx_free_page(struct page *page);
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 36c3c9f8a62c..bc9bc393f866 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1537,11 +1537,26 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static struct page *tdx_alloc_pamt_page_atomic(void *data)
+{
+	struct kvm_vcpu *vcpu = data;
+	void *p;
+
+	p = kvm_mmu_memory_cache_alloc(&vcpu->arch.pamt_page_cache);
+	return virt_to_page(p);
+}
+
 int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 			      enum pg_level level, kvm_pfn_t pfn)
 {
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct page *page = pfn_to_page(pfn);
+	int ret;
+
+	ret = tdx_pamt_get(page, level, tdx_alloc_pamt_page_atomic, vcpu);
+	if (ret)
+		return ret;
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
@@ -1562,10 +1577,16 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * barrier in tdx_td_finalize().
 	 */
 	smp_rmb();
-	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
-		return tdx_mem_page_aug(kvm, gfn, level, page);
 
-	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
+	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
+		ret = tdx_mem_page_aug(kvm, gfn, level, page);
+	else
+		ret = tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
+
+	if (ret)
+		tdx_pamt_put(page, level);
+
+	return ret;
 }
 
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1622,17 +1643,26 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 			      enum pg_level level, void *private_spt)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
-	gpa_t gpa = gfn_to_gpa(gfn);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct page *page = virt_to_page(private_spt);
+	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
+	int ret;
+
+	ret = tdx_pamt_get(page, PG_LEVEL_4K, tdx_alloc_pamt_page_atomic, vcpu);
+	if (ret)
+		return ret;
 
 	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, tdx_level, page, &entry,
 			       &level_state);
-	if (unlikely(tdx_operand_busy(err)))
+	if (unlikely(tdx_operand_busy(err))) {
+		tdx_pamt_put(page, PG_LEVEL_4K);
 		return -EBUSY;
+	}
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state);
+		tdx_pamt_put(page, PG_LEVEL_4K);
 		return -EIO;
 	}
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4f9eaba4af4a..d4b50b6428fa 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2067,10 +2067,16 @@ static void tdx_free_pamt_pages(struct list_head *pamt_pages)
 	}
 }
 
-static int tdx_alloc_pamt_pages(struct list_head *pamt_pages)
+static int tdx_alloc_pamt_pages(struct list_head *pamt_pages,
+				 struct page *(alloc)(void *data), void *data)
 {
 	for (int i = 0; i < tdx_nr_pamt_pages(); i++) {
-		struct page *page = alloc_page(GFP_KERNEL);
+		struct page *page;
+
+		if (alloc)
+			page = alloc(data);
+		else
+			page = alloc_page(GFP_KERNEL);
 		if (!page)
 			goto fail;
 		list_add(&page->lru, pamt_pages);
@@ -2115,7 +2121,8 @@ static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
 	return 0;
 }
 
-static int tdx_pamt_get(struct page *page, enum pg_level level)
+int tdx_pamt_get(struct page *page, enum pg_level level,
+		 struct page *(alloc)(void *data), void *data)
 {
 	unsigned long hpa = page_to_phys(page);
 	atomic_t *pamt_refcount;
@@ -2134,7 +2141,7 @@ static int tdx_pamt_get(struct page *page, enum pg_level level)
 	if (atomic_inc_not_zero(pamt_refcount))
 		return 0;
 
-	if (tdx_alloc_pamt_pages(&pamt_pages))
+	if (tdx_alloc_pamt_pages(&pamt_pages, alloc, data))
 		return -ENOMEM;
 
 	ret = tdx_pamt_add(pamt_refcount, hpa, &pamt_pages);
@@ -2143,8 +2150,9 @@ static int tdx_pamt_get(struct page *page, enum pg_level level)
 
 	return ret >= 0 ? 0 : ret;
 }
+EXPORT_SYMBOL_GPL(tdx_pamt_get);
 
-static void tdx_pamt_put(struct page *page, enum pg_level level)
+void tdx_pamt_put(struct page *page, enum pg_level level)
 {
 	unsigned long hpa = page_to_phys(page);
 	atomic_t *pamt_refcount;
@@ -2179,6 +2187,7 @@ static void tdx_pamt_put(struct page *page, enum pg_level level)
 
 	tdx_free_pamt_pages(&pamt_pages);
 }
+EXPORT_SYMBOL_GPL(tdx_pamt_put);
 
 struct page *tdx_alloc_page(void)
 {
@@ -2188,7 +2197,7 @@ struct page *tdx_alloc_page(void)
 	if (!page)
 		return NULL;
 
-	if (tdx_pamt_get(page, PG_LEVEL_4K)) {
+	if (tdx_pamt_get(page, PG_LEVEL_4K, NULL, NULL)) {
 		__free_page(page);
 		return NULL;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eec82775c5bf..6add012532a0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -436,6 +436,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	BUG_ON(!p);
 	return p;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_memory_cache_alloc);
 #endif
 
 static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
-- 
2.47.2


