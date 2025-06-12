Return-Path: <kvm+bounces-49267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF5EAD711C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:05:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7BAE3ADE3B
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 13:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F209C23C51E;
	Thu, 12 Jun 2025 13:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JgdmrRwr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9375E23AB86;
	Thu, 12 Jun 2025 13:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749733528; cv=none; b=rrOAf2DnU0a/fKtjC81qEXyR8NwRWN4+g7IPNlnE3BNUtCPscEeAbAtCfgHMHNLL3N5w9U2if9xHwMLO11tHmAR5b5s0sKoUjl15Ma9WJ6kd82LuP321YiFvj6vIld0bgeaMDJiZHZ+PK/GTK9H0VhVqlVNT/ttOMhN/5Rl+ELw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749733528; c=relaxed/simple;
	bh=y8NLeed2Zpqmgrw7HwqwPGxaHBEVNUyCekU0isYI6sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7B0H1lOxHDhPHp6ZEwJWTn5e5BvByQ++s1O/4yeqXGbn95j920Xg+zGQhHzS+yefDSiYlXbKt9cgnIqT7m3fKhk/IJ3ItEGP29kYoJEHq/U+T2FSGksmR+KVYX22wc1EaZ3rt1tylH9b65pzw/1jaw0G0w+oCAQAl3eNx/+qpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JgdmrRwr; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749733526; x=1781269526;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y8NLeed2Zpqmgrw7HwqwPGxaHBEVNUyCekU0isYI6sc=;
  b=JgdmrRwrxx4k7HiHqcJRRH+LWllC745MjnNG4sPpazjVvSEnyNZqNIQx
   Dc4lzZj9ztjygzDqonWtOFK1fG3w9bR/cyNdvoBHQCq0b9rDkvD8EHC8Y
   9QCLxCSYEqF5F3W/IFxu1kRBSRPyYM0/gYdiZYbGWMPyRxIFXPshg85gq
   1pjU3FgI+hRfQdvO1MXELKohS76T9YcSlNKFGPy3Xb7YDKBbDPIBdByVF
   MRfqZMbCaEQ46szqgsQH3UZeF+y3hr35Jcus/Efu68JNxuIW76AZhsB/+
   g4Fok8yw2q8quzZ8C7+KyG7x/YDj+b66XK8QoIdKtipAgj4E1XusO5VPH
   A==;
X-CSE-ConnectionGUID: UkUt4FHSSjmhdy1j+4K1ug==
X-CSE-MsgGUID: gPCe54sDRxKxj9F+EhkOzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51017680"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="51017680"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 06:05:26 -0700
X-CSE-ConnectionGUID: YRi7Uk+ESkOTtO4HZdYkkw==
X-CSE-MsgGUID: 4/6vREUtSlaI3YeLwVU/rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="178489788"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa001.fm.intel.com with ESMTP; 12 Jun 2025 06:05:21 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 2259E1DF; Thu, 12 Jun 2025 16:05:21 +0300 (EEST)
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
Subject: [PATCHv2.1 08/12] KVM: TDX: Handle PAMT allocation in fault path
Date: Thu, 12 Jun 2025 16:05:08 +0300
Message-ID: <20250612130508.3213505-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <aErF7JXwjmsf5zYp@intel.com>
References: <aErF7JXwjmsf5zYp@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 23 +++++++++++++++------
 virt/kvm/kvm_main.c         |  1 +
 4 files changed, 57 insertions(+), 11 deletions(-)

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
index 36c3c9f8a62c..2f058e17fd73 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1537,16 +1537,31 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
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
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return -EINVAL;
 
+	ret = tdx_pamt_get(page, level, tdx_alloc_pamt_page_atomic, vcpu);
+	if (ret)
+		return ret;
+
 	/*
 	 * Because guest_memfd doesn't support page migration with
 	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
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
index 0cbf052c64e9..4fc9f4ae8165 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2067,14 +2067,22 @@ static void tdx_free_pamt_pages(struct list_head *pamt_pages)
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
+
 		if (!page) {
 			tdx_free_pamt_pages(pamt_pages);
 			return -ENOMEM;
 		}
+
 		list_add(&page->lru, pamt_pages);
 	}
 	return 0;
@@ -2130,7 +2138,8 @@ static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
 	return 0;
 }
 
-static int tdx_pamt_get(struct page *page, enum pg_level level)
+int tdx_pamt_get(struct page *page, enum pg_level level,
+		 struct page *(alloc)(void *data), void *data)
 {
 	unsigned long hpa = page_to_phys(page);
 	atomic_t *pamt_refcount;
@@ -2153,7 +2162,7 @@ static int tdx_pamt_get(struct page *page, enum pg_level level)
 	if (atomic_inc_not_zero(pamt_refcount))
 		return 0;
 
-	if (tdx_alloc_pamt_pages(&pamt_pages))
+	if (tdx_alloc_pamt_pages(&pamt_pages, alloc, data))
 		return -ENOMEM;
 
 	ret = tdx_pamt_add(pamt_refcount, hpa, &pamt_pages);
@@ -2162,8 +2171,9 @@ static int tdx_pamt_get(struct page *page, enum pg_level level)
 
 	return ret >= 0 ? 0 : ret;
 }
+EXPORT_SYMBOL_GPL(tdx_pamt_get);
 
-static void tdx_pamt_put(struct page *page, enum pg_level level)
+void tdx_pamt_put(struct page *page, enum pg_level level)
 {
 	unsigned long hpa = page_to_phys(page);
 	atomic_t *pamt_refcount;
@@ -2198,6 +2208,7 @@ static void tdx_pamt_put(struct page *page, enum pg_level level)
 
 	tdx_free_pamt_pages(&pamt_pages);
 }
+EXPORT_SYMBOL_GPL(tdx_pamt_put);
 
 struct page *tdx_alloc_page(void)
 {
@@ -2207,7 +2218,7 @@ struct page *tdx_alloc_page(void)
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


