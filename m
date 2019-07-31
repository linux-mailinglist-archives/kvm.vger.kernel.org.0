Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD117C637
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfGaPVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:21:49 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43610 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbfGaPVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:21:49 -0400
Received: by mail-ed1-f68.google.com with SMTP id e3so66071928edr.10
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6dcOutisXa7w0OA/k2AObJgMHjT+CIuNqnczE3/DBrQ=;
        b=uMkV7dlRYvyMPJSqXwVLQaxh1SbMKWA/rm406Ydz9eGRvi8Ft4SJy+9nN22gWE9nDd
         ukzSoH56vPyqxpbLxjXEVQdYrRICJ3eXKLrgBvRFBms4X0n7IZ+ZkDfkegruHN6WvVvT
         VYHq1kwbDORHQTBggf4gpsC2HkGEb8Xme0eLM5kcOMkZ+Lj0L0oK5rV1zYjDMJNxRWjh
         kE59Netr4gNuDmfTCZsRVwCmyv9aL6liFd+uDsoGPs3jxtHmkwXPkxqd+N1WdLw441rw
         xLD919fxfFbemgAuXp6p/VFQr+63k3I4lodcy1I8OZYnfLHOvaaxOAO79aSd/92Ov9k0
         Pn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6dcOutisXa7w0OA/k2AObJgMHjT+CIuNqnczE3/DBrQ=;
        b=bpDLqWnSvYOGJqarozSPAfeObyXT+Dbf5FWK8vXA4Dw85QxKiO+aeb8ZvW3I8D+xw0
         aG1AM0rXqkFa7fVHmv8NAkhcJRjOASe9jqb7Mm3Bs/WShb1N3d99j75EBEKqiS26tQbt
         MlHXu5Pjh2FNmowAduehyzXrVWBoR4G52chUWdTVxMIoul57NJv9NKAQy4hraNHPdqYD
         hSXVsGRVu4UTy8MmJkg7JKoU6u2uwUw6HtZQNpwwEwRjfq8RBpfavfc87CeWBJbioykg
         QYoED5FliJuK8kfWDNNexfJ2pNGmw2k3qpgXTIRPBf9sjom+0Z0RVXsfpW0tVGho7gGT
         /4jQ==
X-Gm-Message-State: APjAAAUfFRwHC7S91pc0HhdzdsbIAmd5aRCtLAYR6JOWNw/oTIBy4+w4
        e/D22YQJe/+IT8zrRulPO24=
X-Google-Smtp-Source: APXvYqzT/aiiyEFc/2CsYYWiqLLTpjVrXs9HBollStS9amsquCg5LbgKvTyLrvlJSZnlDsAlK0g/mw==
X-Received: by 2002:a50:90c5:: with SMTP id d5mr109797190eda.28.1564586032900;
        Wed, 31 Jul 2019 08:13:52 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id g7sm16945082eda.52.2019.07.31.08.13.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:50 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 733161030BA; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 19/59] x86/mm: Implement syncing per-KeyID direct mappings
Date:   Wed, 31 Jul 2019 18:07:33 +0300
Message-Id: <20190731150813.26289-20-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
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
 arch/x86/mm/init_64.c        |   7 +
 arch/x86/mm/mktme.c          | 439 +++++++++++++++++++++++++++++++++++
 arch/x86/mm/pageattr.c       |  27 +++
 4 files changed, 479 insertions(+)

diff --git a/arch/x86/include/asm/mktme.h b/arch/x86/include/asm/mktme.h
index 3fc246acc279..d26ada6b65f7 100644
--- a/arch/x86/include/asm/mktme.h
+++ b/arch/x86/include/asm/mktme.h
@@ -62,6 +62,8 @@ static inline void arch_free_page(struct page *page, int order)
 		free_encrypted_page(page, order);
 }
 
+int sync_direct_mapping(unsigned long start, unsigned long end);
+
 #else
 #define mktme_keyid_mask()	((phys_addr_t)0)
 #define mktme_nr_keyids()	0
@@ -76,6 +78,10 @@ static inline bool mktme_enabled(void)
 
 static inline void mktme_disable(void) {}
 
+static inline int sync_direct_mapping(unsigned long start, unsigned long end)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4c1f93df47a5..6769650ad18d 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -726,6 +726,7 @@ __kernel_physical_mapping_init(unsigned long paddr_start,
 {
 	bool pgd_changed = false;
 	unsigned long vaddr, vaddr_start, vaddr_end, vaddr_next, paddr_last;
+	int ret;
 
 	paddr_last = paddr_end;
 	vaddr = (unsigned long)__va(paddr_start);
@@ -762,6 +763,9 @@ __kernel_physical_mapping_init(unsigned long paddr_start,
 		pgd_changed = true;
 	}
 
+	ret = sync_direct_mapping(vaddr_start, vaddr_end);
+	WARN_ON(ret);
+
 	if (pgd_changed)
 		sync_global_pgds(vaddr_start, vaddr_end - 1);
 
@@ -1201,10 +1205,13 @@ void __ref vmemmap_free(unsigned long start, unsigned long end,
 static void __meminit
 kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 {
+	int ret;
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
 
 	remove_pagetable(start, end, true, NULL);
+	ret = sync_direct_mapping(start, end);
+	WARN_ON(ret);
 }
 
 void __ref arch_remove_memory(int nid, u64 start, u64 size,
diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
index 1e8d662e5bff..ed13967bb543 100644
--- a/arch/x86/mm/mktme.c
+++ b/arch/x86/mm/mktme.c
@@ -1,6 +1,8 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <asm/mktme.h>
+#include <asm/pgalloc.h>
+#include <asm/tlbflush.h>
 
 /* Mask to extract KeyID from physical address. */
 phys_addr_t __mktme_keyid_mask;
@@ -54,6 +56,8 @@ static bool need_page_mktme(void)
 static void init_page_mktme(void)
 {
 	static_branch_enable(&mktme_enabled_key);
+
+	sync_direct_mapping(PAGE_OFFSET, PAGE_OFFSET + direct_mapping_size);
 }
 
 struct page_ext_operations page_mktme_ops = {
@@ -148,3 +152,438 @@ void free_encrypted_page(struct page *page, int order)
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
+		val = pte_val(*src_pte) | keyid << mktme_keyid_shift();
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
+			val = pmd_val(*__src_pmd) | keyid << mktme_keyid_shift();
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
+			val = pud_val(*__src_pud) | keyid << mktme_keyid_shift();
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
+static int sync_direct_mapping_keyid(unsigned long keyid,
+		unsigned long addr, unsigned long end)
+{
+	pgd_t *src_pgd, *dst_pgd;
+	unsigned long next;
+	int ret = 0;
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
+int sync_direct_mapping(unsigned long start, unsigned long end)
+{
+	int i, ret = 0;
+
+	if (!mktme_enabled())
+		return 0;
+
+	for (i = 1; !ret && i <= mktme_nr_keyids(); i++)
+		ret = sync_direct_mapping_keyid(i, start, end);
+
+	flush_tlb_all();
+
+	return ret;
+}
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 6a9a77a403c9..f4e3205d2cdd 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -347,6 +347,33 @@ static void cpa_flush(struct cpa_data *data, int cache)
 
 	BUG_ON(irqs_disabled() && !early_boot_irqs_disabled);
 
+	if (mktme_enabled()) {
+		unsigned long start, end;
+
+		start = PAGE_OFFSET + (cpa->pfn << PAGE_SHIFT);
+		end = start + cpa->numpages * PAGE_SIZE;
+
+		/* Round to cover huge page possibly split by the change */
+		start = round_down(start, direct_gbpages ? PUD_SIZE : PMD_SIZE);
+		end = round_up(end, direct_gbpages ? PUD_SIZE : PMD_SIZE);
+
+		/* Sync all direct mapping for an array */
+		if (cpa->flags & CPA_ARRAY) {
+			start = PAGE_OFFSET;
+			end = PAGE_OFFSET + direct_mapping_size;
+		}
+
+		/*
+		 * Sync per-KeyID direct mappings with the canonical one
+		 * (KeyID-0).
+		 *
+		 * sync_direct_mapping() does full TLB flush.
+		 */
+		sync_direct_mapping(start, end);
+		if (!cache)
+			return;
+	}
+
 	if (cache && !static_cpu_has(X86_FEATURE_CLFLUSH)) {
 		cpa_flush_all(cache);
 		return;
-- 
2.21.0

