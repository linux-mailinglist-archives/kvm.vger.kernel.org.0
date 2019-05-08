Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412AA17C97
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfEHOoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:61857 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727315AbfEHOoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP; 08 May 2019 07:44:33 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 08 May 2019 07:44:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 9AE752E5; Wed,  8 May 2019 17:44:28 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 02/62] mm: Add helpers to setup zero page mappings
Date:   Wed,  8 May 2019 17:43:22 +0300
Message-Id: <20190508144422.13171-3-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When kernel setups an encrypted page mapping, encryption KeyID is
derived from a VMA. KeyID is going to be part of vma->vm_page_prot and
it will be propagated transparently to page table entry on mk_pte().

But there is an exception: zero page is never encrypted and its mapping
must use KeyID-0, regardless VMA's KeyID.

Introduce helpers that create a page table entry for zero page.

The generic implementation will be overridden by architecture-specific
code that takes care about using correct KeyID.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/dax.c                      | 3 +--
 include/asm-generic/pgtable.h | 8 ++++++++
 mm/huge_memory.c              | 6 ++----
 mm/memory.c                   | 3 +--
 mm/userfaultfd.c              | 3 +--
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index e5e54da1715f..6d609bff53b9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1441,8 +1441,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		mm_inc_nr_ptes(vma->vm_mm);
 	}
-	pmd_entry = mk_pmd(zero_page, vmf->vma->vm_page_prot);
-	pmd_entry = pmd_mkhuge(pmd_entry);
+	pmd_entry = mk_zero_pmd(zero_page, vmf->vma->vm_page_prot);
 	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
 	spin_unlock(ptl);
 	trace_dax_pmd_load_hole(inode, vmf, zero_page, *entry);
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index fa782fba51ee..cde8b81f6f2b 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -879,8 +879,16 @@ static inline unsigned long my_zero_pfn(unsigned long addr)
 }
 #endif
 
+#ifndef mk_zero_pte
+#define mk_zero_pte(addr, prot) pte_mkspecial(pfn_pte(my_zero_pfn(addr), prot))
+#endif
+
 #ifdef CONFIG_MMU
 
+#ifndef mk_zero_pmd
+#define mk_zero_pmd(zero_page, prot) pmd_mkhuge(mk_pmd(zero_page, prot))
+#endif
+
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 165ea46bf149..26c3503824ba 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -675,8 +675,7 @@ static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 	pmd_t entry;
 	if (!pmd_none(*pmd))
 		return false;
-	entry = mk_pmd(zero_page, vma->vm_page_prot);
-	entry = pmd_mkhuge(entry);
+	entry = mk_zero_pmd(zero_page, vma->vm_page_prot);
 	if (pgtable)
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
@@ -2101,8 +2100,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
 		pte_t *pte, entry;
-		entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
-		entry = pte_mkspecial(entry);
+		entry = mk_zero_pte(haddr, vma->vm_page_prot);
 		pte = pte_offset_map(&_pmd, haddr);
 		VM_BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, haddr, pte, entry);
diff --git a/mm/memory.c b/mm/memory.c
index ab650c21bccd..c5e0c87a12b7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2927,8 +2927,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	/* Use the zero-page for reads */
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm)) {
-		entry = pte_mkspecial(pfn_pte(my_zero_pfn(vmf->address),
-						vma->vm_page_prot));
+		entry = mk_zero_pte(vmf->address, vma->vm_page_prot);
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				vmf->address, &vmf->ptl);
 		if (!pte_none(*vmf->pte))
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d59b5a73dfb3..ac1ce3866036 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -122,8 +122,7 @@ static int mfill_zeropage_pte(struct mm_struct *dst_mm,
 	pgoff_t offset, max_off;
 	struct inode *inode;
 
-	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
-					 dst_vma->vm_page_prot));
+	_dst_pte = mk_zero_pte(dst_addr, dst_vma->vm_page_prot);
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
 	if (dst_vma->vm_file) {
 		/* the shmem MAP_PRIVATE case requires checking the i_size */
-- 
2.20.1

