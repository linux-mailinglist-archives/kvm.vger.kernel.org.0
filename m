Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEB41DE743
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgEVMxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729923AbgEVMw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:26 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335FAC08C5C4
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:26 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id o14so12528700ljp.4
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pRaycCbZ+3CnIYdCK6nzb5QeCq4+CXz15hhrfgpmlnU=;
        b=qzMU1YykXzSpxfq4gUGJDa7r6eExwnPKDaXlBK/O4gsy+HAeO9hWikW7PXlS15tSOH
         7H2ujvQyQ05kpn3qDXjrynE8jghjk+tV+50UPlqbQIX2du+hpaNowisoN3ub3qLjZ5f3
         99uEnzvP+pKXBJgAF83Y0N6c9SKtYKnnrIwDVaq4Kv2Wr4a1zhoeEi0d4NhcPOVBti0r
         vHJJz6mQyDZ0DqRM/9/4Yxr3+0jwg6iVABSBDnyxepF8R+wLTQn/tl3MyqWiC7CeSR0U
         kzl1lMGgQZQwNGnw8k9TRIqO4lZbttrvG76y6b1LYb/UbTJV1kAVw7lgseAYLJzdrIFo
         mGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pRaycCbZ+3CnIYdCK6nzb5QeCq4+CXz15hhrfgpmlnU=;
        b=RVGrlZU0aGzDwyx+D98a5UqzIFXMVFPcgjszdCzTwgfCtcuUCgUtFSepzUa2llh8tT
         2bWLHzerT2Xao8gmaOemgDziLl8wc5cQvkhSeg5KUyq6iFlD4Ih+etJh/Dkn4ef5S1de
         AZZ0IKMsSn2FpECX0izlDbLdbq/QdDY5CTqxTUzLmXY3YlrMyXg14/mW5lr/8e+BI8EJ
         5j0hd1CGJwpF+FiKLY/1q1E8G5X/88JkMp1eDIann9vGqoRcRiSC7tkp/+cfD8wvMFLh
         Oirz5yDxpKOyCOnbhCQv4grGVZ3SV99tcbdbJcQTHAeDbesssIJmdhxxlKax1RB36EWt
         At2w==
X-Gm-Message-State: AOAM5330C5nJj0EZQOMEZQoWfV7eflT305sQlZ1ep63La3X3q7GKiGCW
        W0xR2jmwNMMwi8b1jwPfTfXwZA==
X-Google-Smtp-Source: ABdhPJw8ESx6i7S5LKvY5bQPxCQloW++OXZLrfBoGefxWzX7bSl6+c0AL/x/tGcrHssIDz/lu11VOg==
X-Received: by 2002:a2e:5d1:: with SMTP id 200mr7029616ljf.157.1590151944653;
        Fri, 22 May 2020 05:52:24 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id p23sm1665017ljh.117.2020.05.22.05.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:22 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 21A53102061; Fri, 22 May 2020 15:52:20 +0300 (+03)
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
Subject: [RFC 16/16] KVM: Unmap protected pages from direct mapping
Date:   Fri, 22 May 2020 15:52:14 +0300
Message-Id: <20200522125214.31348-17-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the protected memory feature enabled, unmap guest memory from
kernel's direct mappings.

Migration and KSM is disabled for protected memory as it would require a
special treatment.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/mm/pat/set_memory.c |  1 +
 include/linux/kvm_host.h     |  3 ++
 mm/huge_memory.c             |  9 +++++
 mm/ksm.c                     |  3 ++
 mm/memory.c                  | 13 +++++++
 mm/rmap.c                    |  4 ++
 virt/kvm/kvm_main.c          | 74 ++++++++++++++++++++++++++++++++++++
 7 files changed, 107 insertions(+)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 6f075766bb94..13988413af40 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2227,6 +2227,7 @@ void __kernel_map_pages(struct page *page, int numpages, int enable)
 
 	arch_flush_lazy_mmu_mode();
 }
+EXPORT_SYMBOL_GPL(__kernel_map_pages);
 
 #ifdef CONFIG_HIBERNATION
 bool kernel_page_present(struct page *page)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b6944f88033d..e1d7762b615c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -705,6 +705,9 @@ int kvm_protect_all_memory(struct kvm *kvm);
 int kvm_protect_memory(struct kvm *kvm,
 		       unsigned long gfn, unsigned long npages, bool protect);
 
+void kvm_map_page(struct page *page, int nr_pages);
+void kvm_unmap_page(struct page *page, int nr_pages);
+
 int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 			    struct page **pages, int nr_pages);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c3562648a4ef..d8a444a401cc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -33,6 +33,7 @@
 #include <linux/oom.h>
 #include <linux/numa.h>
 #include <linux/page_owner.h>
+#include <linux/kvm_host.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -650,6 +651,10 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
 		spin_unlock(vmf->ptl);
 		count_vm_event(THP_FAULT_ALLOC);
 		count_memcg_events(memcg, THP_FAULT_ALLOC, 1);
+
+		/* Unmap page from direct mapping */
+		if (vma_is_kvm_protected(vma))
+			kvm_unmap_page(page, HPAGE_PMD_NR);
 	}
 
 	return 0;
@@ -1886,6 +1891,10 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
index 281c00129a2e..942b88782ac2 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -527,6 +527,9 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 		return NULL;
 	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 		return NULL;
+	/* TODO */
+	if (vma_is_kvm_protected(vma))
+		return NULL;
 	return vma;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index d7228db6e4bf..74773229b854 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -71,6 +71,7 @@
 #include <linux/dax.h>
 #include <linux/oom.h>
 #include <linux/numa.h>
+#include <linux/kvm_host.h>
 
 #include <trace/events/kmem.h>
 
@@ -1088,6 +1089,11 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
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
@@ -3312,6 +3318,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	struct page *page;
 	vm_fault_t ret = 0;
 	pte_t entry;
+	bool set = false;
 
 	/* File mapping without ->vm_ops ? */
 	if (vma->vm_flags & VM_SHARED)
@@ -3397,6 +3404,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	page_add_new_anon_rmap(page, vma, vmf->address, false);
 	mem_cgroup_commit_charge(page, memcg, false, false);
 	lru_cache_add_active_or_unevictable(page, vma);
+	set = true;
 setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
 
@@ -3404,6 +3412,11 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
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
 	mem_cgroup_cancel_charge(page, memcg, false);
diff --git a/mm/rmap.c b/mm/rmap.c
index f79a206b271a..a9b2e347d1ab 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1709,6 +1709,10 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 
 static bool invalid_migration_vma(struct vm_area_struct *vma, void *arg)
 {
+	/* TODO */
+	if (vma_is_kvm_protected(vma))
+		return true;
+
 	return vma_is_temporary_stack(vma);
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 71aac117357f..defc33d3a124 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,6 +51,7 @@
 #include <linux/io.h>
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
+#include <linux/pagewalk.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -2718,6 +2719,72 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
+void kvm_map_page(struct page *page, int nr_pages)
+{
+	int i;
+
+	/* Clear page before returning it to the direct mapping */
+	for (i = 0; i < nr_pages; i++) {
+		void *p = map_page_atomic(page + i);
+		memset(p, 0, PAGE_SIZE);
+		unmap_page_atomic(p);
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
+static int adjust_direct_mapping_pte_range(pmd_t *pmd, unsigned long addr,
+					   unsigned long end,
+					   struct mm_walk *walk)
+{
+	bool protect = (bool)walk->private;
+	pte_t *pte;
+	struct page *page;
+
+	if (pmd_trans_huge(*pmd)) {
+		page = pmd_page(*pmd);
+		if (is_huge_zero_page(page))
+			return 0;
+		VM_BUG_ON_PAGE(total_mapcount(page) != 1, page);
+		/* XXX: Would it fail with direct device assignment? */
+		VM_BUG_ON_PAGE(page_count(page) != 1, page);
+		kernel_map_pages(page, HPAGE_PMD_NR, !protect);
+		return 0;
+	}
+
+	pte = pte_offset_map(pmd, addr);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		pte_t entry = *pte;
+
+		if (!pte_present(entry))
+			continue;
+
+		if (is_zero_pfn(pte_pfn(entry)))
+			continue;
+
+		page = pte_page(entry);
+
+		VM_BUG_ON_PAGE(page_mapcount(page) != 1, page);
+		/* XXX: Would it fail with direct device assignment? */
+		VM_BUG_ON_PAGE(page_count(page) !=
+			       total_mapcount(compound_head(page)), page);
+		kernel_map_pages(page, 1, !protect);
+	}
+
+	return 0;
+}
+
+static const struct mm_walk_ops adjust_direct_mapping_ops = {
+	.pmd_entry	= adjust_direct_mapping_pte_range,
+};
+
 static int protect_memory(unsigned long start, unsigned long end, bool protect)
 {
 	struct mm_struct *mm = current->mm;
@@ -2763,6 +2830,13 @@ static int protect_memory(unsigned long start, unsigned long end, bool protect)
 		if (ret)
 			goto out;
 
+		if (vma_is_anonymous(vma)) {
+			ret = walk_page_range_novma(mm, start, tmp,
+					    &adjust_direct_mapping_ops, NULL,
+					    (void *) protect);
+			if (ret)
+				goto out;
+		}
 next:
 		start = tmp;
 		if (start < prev->vm_end)
-- 
2.26.2

