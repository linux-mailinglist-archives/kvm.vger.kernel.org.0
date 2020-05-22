Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EB61DE74C
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbgEVMxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729855AbgEVMwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:24 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0DAC08C5C0
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:23 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id e125so6472914lfd.1
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OC110xasR+GTk4uxI41+0arGy8rv1X+JHVBAtK64k7Q=;
        b=DINCmV2aZlY4JnnPCopM4LgQCUWBheVG7kwiY1wVek04AAz6tE+2VQMpV7bu6lmZqF
         0jh3mFvw0V7/oxUHvVwm/T6VOC0xmMbvGcg90XXh+J4zuYyWOqQxFAggr5YLDELpvvXx
         UrVe1p9EpqMd5uoiOA4U7S73PN7iZ0i29Tahu4ktBsbkFkiLShZ3UzAMG/Slnu8VVW+V
         SWH92LSWWdocDdDjrE7Rw7qJde4opaiV2xmFBHM1cYM3aCXnsJvU6fX8a84z3k0bBTlF
         L6geZ1hV7k8f/H80wvI+b+bxthM5QDsSWl1c1ikg+E9FBlRqF9A50NARmUYmW8Ibnomm
         eyvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OC110xasR+GTk4uxI41+0arGy8rv1X+JHVBAtK64k7Q=;
        b=Ze9Wk07NaR61UNw4yVSAUAGcfXMC3Qu4qrR+lLBTNZEnXhwDSv/dWS3RE392ARZTZA
         zfFuYch94l9Zi6++JY8hCYAkO61Wcg468oXcSKsg8BSRlrYJesBp/8U9upWFvAne/QO6
         ZbO7646JkMcQafALKE3JWTHN4B8EwvwCjQmjgihsLzSlxffO8y17zAkvufHyH7Eruij/
         pOETt+e74vE7BSGXDNQMU8CXo05kEk7CkcFfeoJqFkg64Yy5LhAcHwl0dcAqerrzkiSP
         H1tPJPQhINtrvdFUXLe9j6sLL3O5ZahmqP9Ns3I0qHQ2EHGGmA+TOf6EGFt4x9x2q8ad
         mSug==
X-Gm-Message-State: AOAM533/3orOK7U1k9xe5NnwrYiOIznH3zL2ZBSqfE3jC051iOWJnxTx
        jhUb+PYk07CTjmnQrWA8CalYYA==
X-Google-Smtp-Source: ABdhPJzP9UaxWq9turrXCg6xZaiwqG/RivqdrtCbCfxbVzjv8F2JanBpprUM2BRBlHfmWRoh2x4YkQ==
X-Received: by 2002:a19:3855:: with SMTP id d21mr7581245lfj.156.1590151942236;
        Fri, 22 May 2020 05:52:22 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id m4sm2307279ljb.46.2020.05.22.05.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:20 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id D0C22102055; Fri, 22 May 2020 15:52:19 +0300 (+03)
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
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC 07/16] KVM: mm: Introduce VM_KVM_PROTECTED
Date:   Fri, 22 May 2020 15:52:05 +0300
Message-Id: <20200522125214.31348-8-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
 virt/kvm/async_pf.c |  4 ++--
 virt/kvm/kvm_main.c |  9 +++++----
 7 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e1882eec1752..4f7195365cc0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -329,6 +329,8 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
 #endif
 
+#define VM_KVM_PROTECTED 0
+
 #ifndef VM_GROWSUP
 # define VM_GROWSUP	VM_NONE
 #endif
@@ -646,6 +648,11 @@ static inline bool vma_is_accessible(struct vm_area_struct *vma)
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
@@ -2773,6 +2780,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
 #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
+#define FOLL_KVM	0x80000 /* access to VM_KVM_PROTECTED VMAs */
 
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
diff --git a/mm/gup.c b/mm/gup.c
index 87a6a59fe667..bd7b9484b35a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -385,10 +385,19 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
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
@@ -431,7 +440,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 	if ((flags & FOLL_NUMA) && pte_protnone(pte))
 		goto no_page;
-	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
+	if ((flags & FOLL_WRITE) && !can_follow_write_pte(vma, pte, flags)) {
 		pte_unmap_unlock(ptep, ptl);
 		return NULL;
 	}
@@ -751,6 +760,9 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
 
 	ctx->page_mask = 0;
 
+	if (vma_is_kvm_protected(vma) && (flags & FOLL_KVM))
+		flags &= ~FOLL_NUMA;
+
 	/* make this handle hugepd */
 	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
 	if (!IS_ERR(page)) {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6ecd1045113b..c3562648a4ef 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1518,10 +1518,19 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
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
@@ -1534,7 +1543,7 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
-	if (flags & FOLL_WRITE && !can_follow_write_pmd(*pmd, flags))
+	if (flags & FOLL_WRITE && !can_follow_write_pmd(vma, *pmd, flags))
 		goto out;
 
 	/* Avoid dumping huge zero page */
@@ -1609,6 +1618,9 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t pmd)
 	bool was_writable;
 	int flags = 0;
 
+	if (vma_is_kvm_protected(vma))
+		return VM_FAULT_SIGBUS;
+
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_same(pmd, *vmf->pmd)))
 		goto out_unlock;
diff --git a/mm/memory.c b/mm/memory.c
index f703fe8c8346..d7228db6e4bf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4013,6 +4013,9 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	bool was_writable = pte_savedwrite(vmf->orig_pte);
 	int flags = 0;
 
+	if (vma_is_kvm_protected(vma))
+		return VM_FAULT_SIGBUS;
+
 	/*
 	 * The "pte" at this point cannot be used safely without
 	 * validation through pte_unmap_same(). It's of NUMA type but
diff --git a/mm/mmap.c b/mm/mmap.c
index f609e9ec4a25..d56c3f6efc99 100644
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
index 15e5b037f92d..7663e962510a 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -60,8 +60,8 @@ static void async_pf_execute(struct work_struct *work)
 	 * access remotely.
 	 */
 	down_read(&mm->mmap_sem);
-	get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
-			&locked);
+	get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE | FOLL_KVM, NULL,
+			      NULL, &locked);
 	if (locked)
 		up_read(&mm->mmap_sem);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 033471f71dae..530af95efdf3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1727,7 +1727,7 @@ unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *w
 
 static inline int check_user_page_hwpoison(unsigned long addr)
 {
-	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
+	int rc, flags = FOLL_HWPOISON | FOLL_WRITE | FOLL_KVM;
 
 	rc = get_user_pages(addr, 1, flags, NULL, NULL);
 	return rc == -EHWPOISON;
@@ -1771,7 +1771,7 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 			   bool *writable, kvm_pfn_t *pfn)
 {
-	unsigned int flags = FOLL_HWPOISON;
+	unsigned int flags = FOLL_HWPOISON | FOLL_KVM;
 	struct page *page;
 	int npages = 0;
 
@@ -2255,7 +2255,7 @@ int copy_from_guest(void *data, unsigned long hva, int len)
 	int npages, seg;
 
 	while ((seg = next_segment(len, offset)) != 0) {
-		npages = get_user_pages_unlocked(hva, 1, &page, 0);
+		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_KVM);
 		if (npages != 1)
 			return -EFAULT;
 		memcpy(data, page_address(page) + offset, seg);
@@ -2275,7 +2275,8 @@ int copy_to_guest(unsigned long hva, const void *data, int len)
 	int npages, seg;
 
 	while ((seg = next_segment(len, offset)) != 0) {
-		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_WRITE);
+		npages = get_user_pages_unlocked(hva, 1, &page,
+						 FOLL_WRITE | FOLL_KVM);
 		if (npages != 1)
 			return -EFAULT;
 		memcpy(page_address(page) + offset, data, seg);
-- 
2.26.2

