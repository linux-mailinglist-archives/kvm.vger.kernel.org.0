Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2232E17C4D
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfEHOuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:50:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:59507 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbfEHOop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:44 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2019 07:44:39 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 93F2C9B1; Wed,  8 May 2019 17:44:29 +0300 (EEST)
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
Subject: [PATCH, RFC 18/62] x86/mm: Implement syncing per-KeyID direct mappings
Date:   Wed,  8 May 2019 17:43:38 +0300
Message-Id: <20190508144422.13171-19-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For MKTME we use per-KeyID direct mappings. This allows kernel to have
access to encrypted memory.

sync_direct_mapping() sync per-KeyID direct mappings with a canonical
one -- KeyID-0.

The function tracks changes in the canonical mapping:
 - creating or removing chunks of the translation tree;
 - changes in mapping flags (i.e. protection bits);
 - splitting huge page mapping into a page table;
 - replacing page table with a huge page mapping;

The function need to be called on every change to the direct mapping:
hotplug, hotremove, changes in permissions bits, etc.

The function is nop until MKTME is enabled.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/mktme.h |   6 +
 arch/x86/mm/init_64.c        |  10 +
 arch/x86/mm/mktme.c          | 441 +++++++++++++++++++++++++++++++++++
 3 files changed, 457 insertions(+)

diff --git a/arch/x86/include/asm/mktme.h b/arch/x86/include/asm/mktme.h
index 454d6d7c791d..bd6707e73219 100644
--- a/arch/x86/include/asm/mktme.h
+++ b/arch/x86/include/asm/mktme.h
@@ -59,6 +59,8 @@ static inline void arch_free_page(struct page *page, int order)
 		free_encrypted_page(page, order);
 }
 
+int sync_direct_mapping(void);
+
 #else
 #define mktme_keyid_mask	((phys_addr_t)0)
 #define mktme_nr_keyids		0
@@ -73,6 +75,10 @@ static inline bool mktme_enabled(void)
 
 static inline void mktme_disable(void) {}
 
+static inline int sync_direct_mapping(void)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 3a08d707eec8..ad4ea3703faf 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -693,6 +693,7 @@ kernel_physical_mapping_init(unsigned long paddr_start,
 {
 	bool pgd_changed = false;
 	unsigned long vaddr, vaddr_start, vaddr_end, vaddr_next, paddr_last;
+	int ret;
 
 	paddr_last = paddr_end;
 	vaddr = (unsigned long)__va(paddr_start);
@@ -726,6 +727,9 @@ kernel_physical_mapping_init(unsigned long paddr_start,
 		pgd_changed = true;
 	}
 
+	ret = sync_direct_mapping();
+	WARN_ON(ret);
+
 	if (pgd_changed)
 		sync_global_pgds(vaddr_start, vaddr_end - 1);
 
@@ -1135,10 +1139,13 @@ void __ref vmemmap_free(unsigned long start, unsigned long end,
 static void __meminit
 kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 {
+	int ret;
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
 
 	remove_pagetable(start, end, true, NULL);
+	ret = sync_direct_mapping();
+	WARN_ON(ret);
 }
 
 int __ref arch_remove_memory(int nid, u64 start, u64 size,
@@ -1247,6 +1254,7 @@ void mark_rodata_ro(void)
 	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
 	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
 	unsigned long all_end;
+	int ret;
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -1280,6 +1288,8 @@ void mark_rodata_ro(void)
 	free_kernel_image_pages((void *)text_end, (void *)rodata_start);
 	free_kernel_image_pages((void *)rodata_end, (void *)_sdata);
 
+	ret = sync_direct_mapping();
+	WARN_ON(ret);
 	debug_checkwx();
 }
 
diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
index 9221c894e8e9..024165c9c7f3 100644
--- a/arch/x86/mm/mktme.c
+++ b/arch/x86/mm/mktme.c
@@ -1,6 +1,8 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <asm/mktme.h>
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
 
 /* Mask to extract KeyID from physical address. */
 phys_addr_t mktme_keyid_mask;
@@ -36,6 +38,8 @@ static bool need_page_mktme(void)
 static void init_page_mktme(void)
 {
 	static_branch_enable(&mktme_enabled_key);
+
+	sync_direct_mapping();
 }
 
 struct page_ext_operations page_mktme_ops = {
@@ -96,3 +100,440 @@ void free_encrypted_page(struct page *page, int order)
 		page++;
 	}
 }
+
+static int sync_direct_mapping_pte(unsigned long keyid,
+		pmd_t *dst_pmd, pmd_t *src_pmd,
+		unsigned long addr, unsigned long end)
+{
+	pte_t *src_pte, *dst_pte;
+	pte_t *new_pte = NULL;
+	bool remove_pte;
+
+	/*
+	 * We want to unmap and free the page table if the source is empty and
+	 * the range covers whole page table.
+	 */
+	remove_pte = !src_pmd && PAGE_ALIGNED(addr) && PAGE_ALIGNED(end);
+
+	/*
+	 * PMD page got split into page table.
+	 * Clear PMD mapping. Page table will be established instead.
+	 */
+	if (pmd_large(*dst_pmd)) {
+		spin_lock(&init_mm.page_table_lock);
+		pmd_clear(dst_pmd);
+		spin_unlock(&init_mm.page_table_lock);
+	}
+
+	/* Allocate a new page table if needed. */
+	if (pmd_none(*dst_pmd)) {
+		new_pte = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (!new_pte)
+			return -ENOMEM;
+		dst_pte = new_pte + pte_index(addr + keyid * direct_mapping_size);
+	} else {
+		dst_pte = pte_offset_map(dst_pmd, addr + keyid * direct_mapping_size);
+	}
+	src_pte = src_pmd ? pte_offset_map(src_pmd, addr) : NULL;
+
+	spin_lock(&init_mm.page_table_lock);
+
+	do {
+		pteval_t val;
+
+		if (!src_pte || pte_none(*src_pte)) {
+			set_pte(dst_pte, __pte(0));
+			goto next;
+		}
+
+		if (!pte_none(*dst_pte)) {
+			/*
+			 * Sanity check: PFNs must match between source
+			 * and destination even if the rest doesn't.
+			 */
+			BUG_ON(pte_pfn(*dst_pte) != pte_pfn(*src_pte));
+		}
+
+		/* Copy entry, but set KeyID. */
+		val = pte_val(*src_pte) | keyid << mktme_keyid_shift;
+		val &= __supported_pte_mask;
+		set_pte(dst_pte, __pte(val));
+next:
+		addr += PAGE_SIZE;
+		dst_pte++;
+		if (src_pte)
+			src_pte++;
+	} while (addr != end);
+
+	if (new_pte)
+		pmd_populate_kernel(&init_mm, dst_pmd, new_pte);
+
+	if (remove_pte) {
+		__free_page(pmd_page(*dst_pmd));
+		pmd_clear(dst_pmd);
+	}
+
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+static int sync_direct_mapping_pmd(unsigned long keyid,
+		pud_t *dst_pud, pud_t *src_pud,
+		unsigned long addr, unsigned long end)
+{
+	pmd_t *src_pmd, *dst_pmd;
+	pmd_t *new_pmd = NULL;
+	bool remove_pmd = false;
+	unsigned long next;
+	int ret = 0;
+
+	/*
+	 * We want to unmap and free the page table if the source is empty and
+	 * the range covers whole page table.
+	 */
+	remove_pmd = !src_pud && IS_ALIGNED(addr, PUD_SIZE) && IS_ALIGNED(end, PUD_SIZE);
+
+	/*
+	 * PUD page got split into page table.
+	 * Clear PUD mapping. Page table will be established instead.
+	 */
+	if (pud_large(*dst_pud)) {
+		spin_lock(&init_mm.page_table_lock);
+		pud_clear(dst_pud);
+		spin_unlock(&init_mm.page_table_lock);
+	}
+
+	/* Allocate a new page table if needed. */
+	if (pud_none(*dst_pud)) {
+		new_pmd = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (!new_pmd)
+			return -ENOMEM;
+		dst_pmd = new_pmd + pmd_index(addr + keyid * direct_mapping_size);
+	} else {
+		dst_pmd = pmd_offset(dst_pud, addr + keyid * direct_mapping_size);
+	}
+	src_pmd = src_pud ? pmd_offset(src_pud, addr) : NULL;
+
+	do {
+		pmd_t *__src_pmd = src_pmd;
+
+		next = pmd_addr_end(addr, end);
+		if (!__src_pmd || pmd_none(*__src_pmd)) {
+			if (pmd_none(*dst_pmd))
+				goto next;
+			if (pmd_large(*dst_pmd)) {
+				spin_lock(&init_mm.page_table_lock);
+				set_pmd(dst_pmd, __pmd(0));
+				spin_unlock(&init_mm.page_table_lock);
+				goto next;
+			}
+			__src_pmd = NULL;
+		}
+
+		if (__src_pmd && pmd_large(*__src_pmd)) {
+			pmdval_t val;
+
+			if (pmd_large(*dst_pmd)) {
+				/*
+				 * Sanity check: PFNs must match between source
+				 * and destination even if the rest doesn't.
+				 */
+				BUG_ON(pmd_pfn(*dst_pmd) != pmd_pfn(*__src_pmd));
+			} else if (!pmd_none(*dst_pmd)) {
+				/*
+				 * Page table is replaced with a PMD page.
+				 * Free and unmap the page table.
+				 */
+				__free_page(pmd_page(*dst_pmd));
+				spin_lock(&init_mm.page_table_lock);
+				pmd_clear(dst_pmd);
+				spin_unlock(&init_mm.page_table_lock);
+			}
+
+			/* Copy entry, but set KeyID. */
+			val = pmd_val(*__src_pmd) | keyid << mktme_keyid_shift;
+			val &= __supported_pte_mask;
+			spin_lock(&init_mm.page_table_lock);
+			set_pmd(dst_pmd, __pmd(val));
+			spin_unlock(&init_mm.page_table_lock);
+			goto next;
+		}
+
+		ret = sync_direct_mapping_pte(keyid, dst_pmd, __src_pmd,
+				addr, next);
+next:
+		addr = next;
+		dst_pmd++;
+		if (src_pmd)
+			src_pmd++;
+	} while (addr != end && !ret);
+
+	if (new_pmd) {
+		spin_lock(&init_mm.page_table_lock);
+		pud_populate(&init_mm, dst_pud, new_pmd);
+		spin_unlock(&init_mm.page_table_lock);
+	}
+
+	if (remove_pmd) {
+		spin_lock(&init_mm.page_table_lock);
+		__free_page(pud_page(*dst_pud));
+		pud_clear(dst_pud);
+		spin_unlock(&init_mm.page_table_lock);
+	}
+
+	return ret;
+}
+
+static int sync_direct_mapping_pud(unsigned long keyid,
+		p4d_t *dst_p4d, p4d_t *src_p4d,
+		unsigned long addr, unsigned long end)
+{
+	pud_t *src_pud, *dst_pud;
+	pud_t *new_pud = NULL;
+	bool remove_pud = false;
+	unsigned long next;
+	int ret = 0;
+
+	/*
+	 * We want to unmap and free the page table if the source is empty and
+	 * the range covers whole page table.
+	 */
+	remove_pud = !src_p4d && IS_ALIGNED(addr, P4D_SIZE) && IS_ALIGNED(end, P4D_SIZE);
+
+	/*
+	 * P4D page got split into page table.
+	 * Clear P4D mapping. Page table will be established instead.
+	 */
+	if (p4d_large(*dst_p4d)) {
+		spin_lock(&init_mm.page_table_lock);
+		p4d_clear(dst_p4d);
+		spin_unlock(&init_mm.page_table_lock);
+	}
+
+	/* Allocate a new page table if needed. */
+	if (p4d_none(*dst_p4d)) {
+		new_pud = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (!new_pud)
+			return -ENOMEM;
+		dst_pud = new_pud + pud_index(addr + keyid * direct_mapping_size);
+	} else {
+		dst_pud = pud_offset(dst_p4d, addr + keyid * direct_mapping_size);
+	}
+	src_pud = src_p4d ? pud_offset(src_p4d, addr) : NULL;
+
+	do {
+		pud_t *__src_pud = src_pud;
+
+		next = pud_addr_end(addr, end);
+		if (!__src_pud || pud_none(*__src_pud)) {
+			if (pud_none(*dst_pud))
+				goto next;
+			if (pud_large(*dst_pud)) {
+				spin_lock(&init_mm.page_table_lock);
+				set_pud(dst_pud, __pud(0));
+				spin_unlock(&init_mm.page_table_lock);
+				goto next;
+			}
+			__src_pud = NULL;
+		}
+
+		if (__src_pud && pud_large(*__src_pud)) {
+			pudval_t val;
+
+			if (pud_large(*dst_pud)) {
+				/*
+				 * Sanity check: PFNs must match between source
+				 * and destination even if the rest doesn't.
+				 */
+				BUG_ON(pud_pfn(*dst_pud) != pud_pfn(*__src_pud));
+			} else if (!pud_none(*dst_pud)) {
+				/*
+				 * Page table is replaced with a pud page.
+				 * Free and unmap the page table.
+				 */
+				__free_page(pud_page(*dst_pud));
+				spin_lock(&init_mm.page_table_lock);
+				pud_clear(dst_pud);
+				spin_unlock(&init_mm.page_table_lock);
+			}
+
+			/* Copy entry, but set KeyID. */
+			val = pud_val(*__src_pud) | keyid << mktme_keyid_shift;
+			val &= __supported_pte_mask;
+			spin_lock(&init_mm.page_table_lock);
+			set_pud(dst_pud, __pud(val));
+			spin_unlock(&init_mm.page_table_lock);
+			goto next;
+		}
+
+		ret = sync_direct_mapping_pmd(keyid, dst_pud, __src_pud,
+				addr, next);
+next:
+		addr = next;
+		dst_pud++;
+		if (src_pud)
+			src_pud++;
+	} while (addr != end && !ret);
+
+	if (new_pud) {
+		spin_lock(&init_mm.page_table_lock);
+		p4d_populate(&init_mm, dst_p4d, new_pud);
+		spin_unlock(&init_mm.page_table_lock);
+	}
+
+	if (remove_pud) {
+		spin_lock(&init_mm.page_table_lock);
+		__free_page(p4d_page(*dst_p4d));
+		p4d_clear(dst_p4d);
+		spin_unlock(&init_mm.page_table_lock);
+	}
+
+	return ret;
+}
+
+static int sync_direct_mapping_p4d(unsigned long keyid,
+		pgd_t *dst_pgd, pgd_t *src_pgd,
+		unsigned long addr, unsigned long end)
+{
+	p4d_t *src_p4d, *dst_p4d;
+	p4d_t *new_p4d_1 = NULL, *new_p4d_2 = NULL;
+	bool remove_p4d = false;
+	unsigned long next;
+	int ret = 0;
+
+	/*
+	 * We want to unmap and free the page table if the source is empty and
+	 * the range covers whole page table.
+	 */
+	remove_p4d = !src_pgd && IS_ALIGNED(addr, PGDIR_SIZE) && IS_ALIGNED(end, PGDIR_SIZE);
+
+	/* Allocate a new page table if needed. */
+	if (pgd_none(*dst_pgd)) {
+		new_p4d_1 = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (!new_p4d_1)
+			return -ENOMEM;
+		dst_p4d = new_p4d_1 + p4d_index(addr + keyid * direct_mapping_size);
+	} else {
+		dst_p4d = p4d_offset(dst_pgd, addr + keyid * direct_mapping_size);
+	}
+	src_p4d = src_pgd ? p4d_offset(src_pgd, addr) : NULL;
+
+	do {
+		p4d_t *__src_p4d = src_p4d;
+
+		next = p4d_addr_end(addr, end);
+		if (!__src_p4d || p4d_none(*__src_p4d)) {
+			if (p4d_none(*dst_p4d))
+				goto next;
+			__src_p4d = NULL;
+		}
+
+		ret = sync_direct_mapping_pud(keyid, dst_p4d, __src_p4d,
+				addr, next);
+next:
+		addr = next;
+		dst_p4d++;
+
+		/*
+		 * Direct mappings are 1TiB-aligned. With 5-level paging it
+		 * means that on PGD level there can be misalignment between
+		 * source and distiantion.
+		 *
+		 * Allocate the new page table if dst_p4d crosses page table
+		 * boundary.
+		 */
+		if (!((unsigned long)dst_p4d & ~PAGE_MASK) && addr != end) {
+			if (pgd_none(dst_pgd[1])) {
+				new_p4d_2 = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+				if (!new_p4d_2)
+					ret = -ENOMEM;
+				dst_p4d = new_p4d_2;
+			} else {
+				dst_p4d = p4d_offset(dst_pgd + 1, 0);
+			}
+		}
+		if (src_p4d)
+			src_p4d++;
+	} while (addr != end && !ret);
+
+	if (new_p4d_1 || new_p4d_2) {
+		spin_lock(&init_mm.page_table_lock);
+		if (new_p4d_1)
+			pgd_populate(&init_mm, dst_pgd, new_p4d_1);
+		if (new_p4d_2)
+			pgd_populate(&init_mm, dst_pgd + 1, new_p4d_2);
+		spin_unlock(&init_mm.page_table_lock);
+	}
+
+	if (remove_p4d) {
+		spin_lock(&init_mm.page_table_lock);
+		__free_page(pgd_page(*dst_pgd));
+		pgd_clear(dst_pgd);
+		spin_unlock(&init_mm.page_table_lock);
+	}
+
+	return ret;
+}
+
+static int sync_direct_mapping_keyid(unsigned long keyid)
+{
+	pgd_t *src_pgd, *dst_pgd;
+	unsigned long addr, end, next;
+	int ret = 0;
+
+	addr = PAGE_OFFSET;
+	end = PAGE_OFFSET + direct_mapping_size;
+
+	dst_pgd = pgd_offset_k(addr + keyid * direct_mapping_size);
+	src_pgd = pgd_offset_k(addr);
+
+	do {
+		pgd_t *__src_pgd = src_pgd;
+
+		next = pgd_addr_end(addr, end);
+		if (pgd_none(*__src_pgd)) {
+			if (pgd_none(*dst_pgd))
+				continue;
+			__src_pgd = NULL;
+		}
+
+		ret = sync_direct_mapping_p4d(keyid, dst_pgd, __src_pgd,
+				addr, next);
+	} while (dst_pgd++, src_pgd++, addr = next, addr != end && !ret);
+
+	return ret;
+}
+
+/*
+ * For MKTME we maintain per-KeyID direct mappings. This allows kernel to have
+ * access to encrypted memory.
+ *
+ * sync_direct_mapping() sync per-KeyID direct mappings with a canonical
+ * one -- KeyID-0.
+ *
+ * The function tracks changes in the canonical mapping:
+ *  - creating or removing chunks of the translation tree;
+ *  - changes in mapping flags (i.e. protection bits);
+ *  - splitting huge page mapping into a page table;
+ *  - replacing page table with a huge page mapping;
+ *
+ * The function need to be called on every change to the direct mapping:
+ * hotplug, hotremove, changes in permissions bits, etc.
+ *
+ * The function is nop until MKTME is enabled.
+ */
+int sync_direct_mapping(void)
+{
+	int i, ret = 0;
+
+	if (!mktme_enabled())
+		return 0;
+
+	for (i = 1; !ret && i <= mktme_nr_keyids; i++)
+		ret = sync_direct_mapping_keyid(i);
+
+	flush_tlb_all();
+
+	return ret;
+}
-- 
2.20.1

