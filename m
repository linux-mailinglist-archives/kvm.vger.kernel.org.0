Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE0E2934C1
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403930AbgJTGTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403890AbgJTGTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:14 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88EAC061755
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:13 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d24so660375lfa.8
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KIAVbPzuFo0SQGjh1AZh62RNTXjbtTvj2q2tSqP5u5A=;
        b=lMVJEorZcBNsU+WKL2FowmkbJxB6ruG+LU7quJ9vFJVwuQlbsEYX1tQ83ACqgxFanj
         4ggBJcvVBmrTiDeUgBFYqEv57Ou/jSYAqNFrrAVcorcH/JToj5lI/C0UYX3yS0S8rCl6
         zaL5WY6luVVaXlJq3jMMf1kO2wjLAfZv8Tqu+zy4VbuCreEYfz5QDzVEf9hkVMUKAoaf
         ljmDOeYwiFfb15HQs4So/fZYbIIRRobF9J0oUy9bS+4I4TGYW7GisLUf3CbZwP2zbgQZ
         eygBtilf124JiAcgeTqYXIt+33gQNYAMrILdV2OAyHpTiAwPYUyu+8Qm6iDPuDE5nrur
         7bSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KIAVbPzuFo0SQGjh1AZh62RNTXjbtTvj2q2tSqP5u5A=;
        b=ulyzBIyGEbnG+bw+sLKcbFC5cVwJ8PrgMw1m62mQ+QM2/ClL+84WX8cdjDGoGwDurO
         29arcOF81jq7qCMkLhltFHn/hlS7Ha1Rk6u4XkEcc/ChpLv51c3+vJ6Sb0sPNp+f5mPF
         Dnn7aNQuPnqQyyYbMYE8WiQiXs83OVrYWL6cmy+oBj95wP7JCMoP2YXUdX7NMxIBcv+p
         pN38NJ3JpF1NQWYsz3yNJ0ufxPX0xb4phCMNCc0cbUi4tUfXnL5sBWzr2+aFpUCBvUO/
         +t7vUITA1q/Dr6xyoNfw+9Mjo7R8EVLiNkbRJCblFX3toRmnsMpX+yYVXilrHhRQmzwr
         PYwA==
X-Gm-Message-State: AOAM530o7pubfl7frJsVmIdROoKe31LIBO9bknGSTVQrqPkSrzH5SGm5
        seTA3sJKkJZmUIL5GXYTuzC1VQ==
X-Google-Smtp-Source: ABdhPJyJBolsoJfELSO4r+qt6ijjZjPzBQXOcPFq5Dp6mn7pNXbaxYjhYpHuOQpmW8XwEU+vrLpZBw==
X-Received: by 2002:a05:6512:41e:: with SMTP id u30mr463605lfk.204.1603174752407;
        Mon, 19 Oct 2020 23:19:12 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id x28sm140002lfd.4.2020.10.19.23.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 344C2102F6E; Tue, 20 Oct 2020 09:19:02 +0300 (+03)
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
Subject: [RFCv2 15/16] KVM: Unmap protected pages from direct mapping
Date:   Tue, 20 Oct 2020 09:18:58 +0300
Message-Id: <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the protected memory feature enabled, unmap guest memory from
kernel's direct mappings.

Migration and KSM is disabled for protected memory as it would require a
special treatment.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h       |  3 +++
 mm/huge_memory.c         |  8 ++++++++
 mm/ksm.c                 |  2 ++
 mm/memory.c              | 12 ++++++++++++
 mm/rmap.c                |  4 ++++
 virt/lib/mem_protected.c | 21 +++++++++++++++++++++
 6 files changed, 50 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ee274d27e764..74efc51e63f0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -671,6 +671,9 @@ static inline bool vma_is_kvm_protected(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_KVM_PROTECTED;
 }
 
+void kvm_map_page(struct page *page, int nr_pages);
+void kvm_unmap_page(struct page *page, int nr_pages);
+
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ec8cf9a40cfd..40974656cb43 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -627,6 +627,10 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
 		spin_unlock(vmf->ptl);
 		count_vm_event(THP_FAULT_ALLOC);
 		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+
+		/* Unmap page from direct mapping */
+		if (vma_is_kvm_protected(vma))
+			kvm_unmap_page(page, HPAGE_PMD_NR);
 	}
 
 	return 0;
@@ -1689,6 +1693,10 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			page_remove_rmap(page, true);
 			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
+
+			/* Map the page back to the direct mapping */
+			if (vma_is_kvm_protected(vma))
+				kvm_map_page(page, HPAGE_PMD_NR);
 		} else if (thp_migration_supported()) {
 			swp_entry_t entry;
 
diff --git a/mm/ksm.c b/mm/ksm.c
index 9afccc36dbd2..c720e271448f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -528,6 +528,8 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 		return NULL;
 	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 		return NULL;
+	if (vma_is_kvm_protected(vma))
+		return NULL;
 	return vma;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 2c9756b4e52f..e28bd5f902a7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1245,6 +1245,11 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				    likely(!(vma->vm_flags & VM_SEQ_READ)))
 					mark_page_accessed(page);
 			}
+
+			/* Map the page back to the direct mapping */
+			if (vma_is_anonymous(vma) && vma_is_kvm_protected(vma))
+				kvm_map_page(page, 1);
+
 			rss[mm_counter(page)]--;
 			page_remove_rmap(page, false);
 			if (unlikely(page_mapcount(page) < 0))
@@ -3466,6 +3471,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	struct page *page;
 	vm_fault_t ret = 0;
 	pte_t entry;
+	bool set = false;
 
 	/* File mapping without ->vm_ops ? */
 	if (vma->vm_flags & VM_SHARED)
@@ -3554,6 +3560,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, vmf->address, false);
 	lru_cache_add_inactive_or_unevictable(page, vma);
+	set = true;
 setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
 
@@ -3561,6 +3568,11 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	update_mmu_cache(vma, vmf->address, vmf->pte);
 unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
+
+	/* Unmap page from direct mapping */
+	if (vma_is_kvm_protected(vma) && set)
+		kvm_unmap_page(page, 1);
+
 	return ret;
 release:
 	put_page(page);
diff --git a/mm/rmap.c b/mm/rmap.c
index 9425260774a1..247548d6d24b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1725,6 +1725,10 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 
 static bool invalid_migration_vma(struct vm_area_struct *vma, void *arg)
 {
+	/* TODO */
+	if (vma_is_kvm_protected(vma))
+		return true;
+
 	return vma_is_temporary_stack(vma);
 }
 
diff --git a/virt/lib/mem_protected.c b/virt/lib/mem_protected.c
index 1dfe82534242..9d2ef99285e5 100644
--- a/virt/lib/mem_protected.c
+++ b/virt/lib/mem_protected.c
@@ -30,6 +30,27 @@ void kvm_unmap_page_atomic(void *vaddr)
 }
 EXPORT_SYMBOL_GPL(kvm_unmap_page_atomic);
 
+void kvm_map_page(struct page *page, int nr_pages)
+{
+	int i;
+
+	/* Clear page before returning it to the direct mapping */
+	for (i = 0; i < nr_pages; i++) {
+		void *p = kvm_map_page_atomic(page + i);
+		memset(p, 0, PAGE_SIZE);
+		kvm_unmap_page_atomic(p);
+	}
+
+	kernel_map_pages(page, nr_pages, 1);
+}
+EXPORT_SYMBOL_GPL(kvm_map_page);
+
+void kvm_unmap_page(struct page *page, int nr_pages)
+{
+	kernel_map_pages(page, nr_pages, 0);
+}
+EXPORT_SYMBOL_GPL(kvm_unmap_page);
+
 int kvm_init_protected_memory(void)
 {
 	guest_map_ptes = kmalloc_array(num_possible_cpus(),
-- 
2.26.2

