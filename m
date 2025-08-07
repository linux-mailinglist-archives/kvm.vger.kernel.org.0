Return-Path: <kvm+bounces-54247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BBA0B1D537
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9401727D1C
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E506278E77;
	Thu,  7 Aug 2025 09:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PuNKEDJC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E2026B2CE;
	Thu,  7 Aug 2025 09:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754560014; cv=none; b=aZiR9OOopi9GIBSRXv3OdwOq5OyfxYoksXRGkwWZPdshb4B8ldTyfG/fHiyHPlmLAN8qakwZTL9XT0da17O2ZUOUjSCWlKNITqhVKZmN5YMpQATMIFt7JiT/NF3kVwyzGC8Fn6OcCABxE2POjjB7JTBwC8ZClqi1wG41tNBw19E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754560014; c=relaxed/simple;
	bh=NyJ4m+SyEe6lOcqy+kGfg9evl71B58tKKrzSzMNKMUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6D70rOHgdvAicBxZvWnaAjmiPWFXChksDzdS4NqrPn5f9Rp48NHuBDfncNa02WeLQ6rxKMQ4rIcCkZ7NLBtcHKOdQ8NgRvyxj3c2gy6rJ3E9oI2vbr0zaT9kajv/1nk4L3CS4aUu2H35ut1zqpHR11YuaMxdtbBO6hZO0iNyMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PuNKEDJC; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754560013; x=1786096013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NyJ4m+SyEe6lOcqy+kGfg9evl71B58tKKrzSzMNKMUs=;
  b=PuNKEDJCCoQBP+i62g9PmPhFLHVy10r7GzGrO16bzjjotA5ewZhoeHvL
   rZ9DPBH+AbIf1c6E90yP18Wu/lXXN6oj97y7sfsn/kTxtAC51Lpl8LDLs
   G/DBAahrF8b5VKJsIAW91KpzjjZgpIAf1RpLOo4ZZ+1D4w3eCNvKMgT8w
   ulaVKAE9+f0Yl3wpdCxU3hp8deWYHHRG7gTHwx0/CGcsabsUjPvJNPCp8
   vghwlLwyLlv3DTqjF7us15k8xQZR43v7FnRv5ZBbDX5mIK9yaPeQz3YsS
   ErUh+LpmuZ0Lbcr6W68AVjqRkk74bfIDCkkozYhkE3Z0hbJMo0tPEbbLg
   Q==;
X-CSE-ConnectionGUID: F1RiWYVIRw60QQ1CyoXuSQ==
X-CSE-MsgGUID: qafBYm14TPuVOMH6ZR5+6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68342898"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68342898"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:46:53 -0700
X-CSE-ConnectionGUID: RFfjZLNxTlSRcZxBgf0YGg==
X-CSE-MsgGUID: N777nVFXTEOQKr2PUyNZlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="170392385"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:46:47 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 22/23] KVM: TDX: Handle Dynamic PAMT on page split
Date: Thu,  7 Aug 2025 17:46:16 +0800
Message-ID: <20250807094616.4776-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Page demote from 2M to 4k requires an additional PAMT page pair to cover
the 2M range that now mapped with 4k.

EPT page also has to be covered in PAMT_4K.

Allocate both from pre-allocated split PAMT pool.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Pulled from
  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
- Rebased on top of TDX huge page RFC v2 (Yan).
---
 arch/x86/include/asm/tdx.h  |  4 ++++
 arch/x86/kvm/vmx/tdx.c      | 28 ++++++++++++++++++++++++----
 arch/x86/virt/vmx/tdx/tdx.c | 11 +++++++----
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 2e529f0c578a..da317981e95a 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -123,6 +123,10 @@ u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
 int tdx_nr_pamt_pages(void);
+atomic_t *tdx_get_pamt_refcount(unsigned long hpa);
+int tdx_alloc_pamt_pages(struct list_head *pamt_pages,
+			 struct page *(alloc)(void *data), void *data);
+void tdx_free_pamt_pages(struct list_head *pamt_pages);
 int tdx_pamt_get(struct page *page, enum pg_level level,
 		 struct page *(alloc)(void *data), void *data);
 void tdx_pamt_put(struct page *page, enum pg_level level);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9d24a1a86a23..6e061d659639 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1915,28 +1915,48 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static struct page *tdx_alloc_pamt_page_split(void *data)
+{
+	struct kvm *kvm = data;
+	void *p;
+
+	p = kvm_mmu_memory_cache_alloc(&kvm->arch.pamt_page_cache);
+	return virt_to_page(p);
+}
+
 static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
-					enum pg_level level, struct page *page)
+					enum pg_level level, struct page *page,
+					kvm_pfn_t pfn_for_gfn)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
+	hpa_t hpa = pfn_to_hpa(pfn_for_gfn);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
+	LIST_HEAD(pamt_pages);
+
+	tdx_pamt_get(page, PG_LEVEL_4K, tdx_alloc_pamt_page_split, kvm);
+	tdx_alloc_pamt_pages(&pamt_pages, tdx_alloc_pamt_page_split, kvm);
 
 	err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
-				  NULL, &entry, &level_state);
+				  &pamt_pages, &entry, &level_state);
 
 	if (unlikely(tdx_operand_busy(err))) {
 		tdx_no_vcpus_enter_start(kvm);
 		err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
-					  NULL, &entry, &level_state);
+					  &pamt_pages, &entry, &level_state);
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 
 	if (KVM_BUG_ON(err, kvm)) {
+		tdx_free_pamt_pages(&pamt_pages);
+		tdx_pamt_put(page, PG_LEVEL_4K);
 		pr_tdx_error_2(TDH_MEM_PAGE_DEMOTE, err, entry, level_state);
 		return -EIO;
 	}
+
+	if (tdx_supports_dynamic_pamt(tdx_sysinfo))
+		atomic_set(tdx_get_pamt_refcount(hpa), PTRS_PER_PMD);
 	return 0;
 }
 
@@ -1963,7 +1983,7 @@ static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level
 
 	tdx_track(kvm);
 
-	return tdx_spte_demote_private_spte(kvm, gfn, level, page);
+	return tdx_spte_demote_private_spte(kvm, gfn, level, page, pfn_for_gfn);
 }
 
 static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 50f9d49f1c91..dbbddd00ec60 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -188,10 +188,11 @@ int tdx_cpu_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_cpu_enable);
 
-static atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
+atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
 {
 	return &pamt_refcounts[hpa / PMD_SIZE];
 }
+EXPORT_SYMBOL_GPL(tdx_get_pamt_refcount);
 
 static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void *data)
 {
@@ -2151,7 +2152,7 @@ static u64 tdh_phymem_pamt_remove(unsigned long hpa,
 
 static DEFINE_SPINLOCK(pamt_lock);
 
-static void tdx_free_pamt_pages(struct list_head *pamt_pages)
+void tdx_free_pamt_pages(struct list_head *pamt_pages)
 {
 	struct page *page;
 
@@ -2160,9 +2161,10 @@ static void tdx_free_pamt_pages(struct list_head *pamt_pages)
 		__free_page(page);
 	}
 }
+EXPORT_SYMBOL_GPL(tdx_free_pamt_pages);
 
-static int tdx_alloc_pamt_pages(struct list_head *pamt_pages,
-				 struct page *(alloc)(void *data), void *data)
+int tdx_alloc_pamt_pages(struct list_head *pamt_pages,
+			 struct page *(alloc)(void *data), void *data)
 {
 	for (int i = 0; i < tdx_nr_pamt_pages(); i++) {
 		struct page *page;
@@ -2180,6 +2182,7 @@ static int tdx_alloc_pamt_pages(struct list_head *pamt_pages,
 	tdx_free_pamt_pages(pamt_pages);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(tdx_alloc_pamt_pages);
 
 static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
 			struct list_head *pamt_pages)
-- 
2.43.2


