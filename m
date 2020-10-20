Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA9E2934BE
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403905AbgJTGTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403872AbgJTGTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:12 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5429C0613CE
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:11 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h20so732544lji.9
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ef3vnZp/GnAIOhUojdZDqsMeSzQG+k/o8v/cqaX5tdE=;
        b=kWnjG/bxvvaKB7p7Og+d8rHcQSxNwWjP6TC59FneVw8z/VNXgUaDMKTQO/MkwPrA+x
         +duFDtLhAFDA0qpugJYlrviajPw8NRXeR/ysVV+ZxXdgzP+uvH9BsVizNcK20WoevkeV
         WMSbCL4u7ayNAPEVdnIplFR8AGo2eUH7Qa6s/QpmNARyn2T7XGVKz4Q2RsWWEnVchVQB
         9D4kOaDUpfEcu8nwrB5TUSRXAtenzPz54EqxIf0OKr5R1UAEtOjz5vAv6gktjIWRMcB8
         Tz0Uq4xh7vFJJnA9Pr4i4yyNJxAvwhYezd7vtQicoEwlgj5ko/lCtadFljYF5rIySZRl
         XyAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ef3vnZp/GnAIOhUojdZDqsMeSzQG+k/o8v/cqaX5tdE=;
        b=ERNwYlU8m9fSggbppvhoVNGF5CsAb16w+q8pl2dFARS2/4V90+N/Z7P2ThEtLqfzxk
         5l9JDMHggU1xue/KU2ozb1KrHr921dBgYn1M1pSg1cjNDQzMgGSDtO0Sijx/mYaYnCHX
         CBthy8uj3G0H/GNGu89ElQseuDi25lqFaEMsea60hEa7cOj0o19D/aAsVEKUEzcfwIEL
         TYrjWrrsZ8vamEw73fyMP0DZmsgMKVad5E9164d+k2NtataMNgKN2bFlAfc3R/CNrAhF
         omiQbdyZ0na8jqJ9HD6Lluk48y379zvAHuzEHJ918HeAVYo+N9DNoRsJLJWCFdTuxAIZ
         NRLw==
X-Gm-Message-State: AOAM532fGjyBSt4XI6TmtB3Q40n2PBYvprnIJoe6QfWTtNXO6HC6cKgb
        Z9Y2VNQ9oWsvq+GSnENDz/jmHg==
X-Google-Smtp-Source: ABdhPJyvDjiTcYo3ooj2XDbkY21HO+vY/E6/whgeBJA4ZvSFIs8MEUig63kvuD9QS067pDfLSnnJGA==
X-Received: by 2002:a2e:9bce:: with SMTP id w14mr478315ljj.439.1603174750219;
        Mon, 19 Oct 2020 23:19:10 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id h11sm194817ljc.21.2020.10.19.23.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 03C94102F68; Tue, 20 Oct 2020 09:19:02 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 09/16] KVM: mm: Introduce VM_KVM_PROTECTED
Date:   Tue, 20 Oct 2020 09:18:52 +0300
Message-Id: <20201020061859.18385-10-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new VMA flag that indicate a VMA that is not accessible to userspace
but usable by kernel with GUP if FOLL_KVM is specified.

The FOLL_KVM is only used in the KVM code. The code has to know how to
deal with such pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h  |  8 ++++++++
 mm/gup.c            | 20 ++++++++++++++++----
 mm/huge_memory.c    | 20 ++++++++++++++++----
 mm/memory.c         |  3 +++
 mm/mmap.c           |  3 +++
 virt/kvm/async_pf.c |  2 +-
 virt/kvm/kvm_main.c |  9 +++++----
 7 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 16b799a0522c..c8d8cdcbc425 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -342,6 +342,8 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
 #endif
 
+#define VM_KVM_PROTECTED 0
+
 #ifndef VM_GROWSUP
 # define VM_GROWSUP	VM_NONE
 #endif
@@ -658,6 +660,11 @@ static inline bool vma_is_accessible(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
+static inline bool vma_is_kvm_protected(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & VM_KVM_PROTECTED;
+}
+
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
@@ -2766,6 +2773,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
 #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
 #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
+#define FOLL_KVM	0x100000 /* access to VM_KVM_PROTECTED VMAs */
 
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
diff --git a/mm/gup.c b/mm/gup.c
index e869c634cc9a..accf6db0c06f 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -384,10 +384,19 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
  * FOLL_FORCE can write to even unwritable pte's, but only
  * after we've gone through a COW cycle and they are dirty.
  */
-static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
+static inline bool can_follow_write_pte(struct vm_area_struct *vma,
+					pte_t pte, unsigned int flags)
 {
-	return pte_write(pte) ||
-		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
+	if (pte_write(pte))
+		return true;
+
+	if ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte))
+		return true;
+
+	if (!vma_is_kvm_protected(vma) || !(vma->vm_flags & VM_WRITE))
+		return false;
+
+	return (vma->vm_flags & VM_SHARED) || page_mapcount(pte_page(pte)) == 1;
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -430,7 +439,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 	if ((flags & FOLL_NUMA) && pte_protnone(pte))
 		goto no_page;
-	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
+	if ((flags & FOLL_WRITE) && !can_follow_write_pte(vma, pte, flags)) {
 		pte_unmap_unlock(ptep, ptl);
 		return NULL;
 	}
@@ -750,6 +759,9 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
 
 	ctx->page_mask = 0;
 
+	if (vma_is_kvm_protected(vma) && (flags & FOLL_KVM))
+		flags &= ~FOLL_NUMA;
+
 	/* make this handle hugepd */
 	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
 	if (!IS_ERR(page)) {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index da397779a6d4..ec8cf9a40cfd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1322,10 +1322,19 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
  * FOLL_FORCE can write to even unwritable pmd's, but only
  * after we've gone through a COW cycle and they are dirty.
  */
-static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
+static inline bool can_follow_write_pmd(struct vm_area_struct *vma,
+					pmd_t pmd, unsigned int flags)
 {
-	return pmd_write(pmd) ||
-	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
+	if (pmd_write(pmd))
+		return true;
+
+	if ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd))
+		return true;
+
+	if (!vma_is_kvm_protected(vma) || !(vma->vm_flags & VM_WRITE))
+		return false;
+
+	return (vma->vm_flags & VM_SHARED) || page_mapcount(pmd_page(pmd)) == 1;
 }
 
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
@@ -1338,7 +1347,7 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
-	if (flags & FOLL_WRITE && !can_follow_write_pmd(*pmd, flags))
+	if (flags & FOLL_WRITE && !can_follow_write_pmd(vma, *pmd, flags))
 		goto out;
 
 	/* Avoid dumping huge zero page */
@@ -1412,6 +1421,9 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t pmd)
 	bool was_writable;
 	int flags = 0;
 
+	if (vma_is_kvm_protected(vma))
+		return VM_FAULT_SIGBUS;
+
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_same(pmd, *vmf->pmd)))
 		goto out_unlock;
diff --git a/mm/memory.c b/mm/memory.c
index eeae590e526a..2c9756b4e52f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4165,6 +4165,9 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	bool was_writable = pte_savedwrite(vmf->orig_pte);
 	int flags = 0;
 
+	if (vma_is_kvm_protected(vma))
+		return VM_FAULT_SIGBUS;
+
 	/*
 	 * The "pte" at this point cannot be used safely without
 	 * validation through pte_unmap_same(). It's of NUMA type but
diff --git a/mm/mmap.c b/mm/mmap.c
index bdd19f5b994e..be699f688b6c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -112,6 +112,9 @@ pgprot_t vm_get_page_prot(unsigned long vm_flags)
 				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]) |
 			pgprot_val(arch_vm_get_page_prot(vm_flags)));
 
+	if (vm_flags & VM_KVM_PROTECTED)
+		ret = PAGE_NONE;
+
 	return arch_filter_pgprot(ret);
 }
 EXPORT_SYMBOL(vm_get_page_prot);
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index dd777688d14a..85a2f99f6e9b 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -61,7 +61,7 @@ static void async_pf_execute(struct work_struct *work)
 	 * access remotely.
 	 */
 	mmap_read_lock(mm);
-	get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, NULL,
+	get_user_pages_remote(mm, addr, 1, FOLL_WRITE | FOLL_KVM, NULL, NULL,
 			&locked);
 	if (locked)
 		mmap_read_unlock(mm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a9884cb8c867..125db5a73e10 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1794,7 +1794,7 @@ unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *w
 
 static inline int check_user_page_hwpoison(unsigned long addr)
 {
-	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
+	int rc, flags = FOLL_HWPOISON | FOLL_WRITE | FOLL_KVM;
 
 	rc = get_user_pages(addr, 1, flags, NULL, NULL);
 	return rc == -EHWPOISON;
@@ -1836,7 +1836,7 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 			   bool *writable, kvm_pfn_t *pfn)
 {
-	unsigned int flags = FOLL_HWPOISON;
+	unsigned int flags = FOLL_HWPOISON | FOLL_KVM;
 	struct page *page;
 	int npages = 0;
 
@@ -2327,7 +2327,7 @@ int copy_from_guest(void *data, unsigned long hva, int len, bool protected)
 	check_object_size(data, len, false);
 
 	while ((seg = next_segment(len, offset)) != 0) {
-		npages = get_user_pages_unlocked(hva, 1, &page, 0);
+		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_KVM);
 		if (npages != 1)
 			return -EFAULT;
 		memcpy(data, page_address(page) + offset, seg);
@@ -2354,7 +2354,8 @@ int copy_to_guest(unsigned long hva, const void *data, int len, bool protected)
 	check_object_size(data, len, true);
 
 	while ((seg = next_segment(len, offset)) != 0) {
-		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_WRITE);
+		npages = get_user_pages_unlocked(hva, 1, &page,
+						 FOLL_WRITE | FOLL_KVM);
 		if (npages != 1)
 			return -EFAULT;
 		memcpy(page_address(page) + offset, data, seg);
-- 
2.26.2

