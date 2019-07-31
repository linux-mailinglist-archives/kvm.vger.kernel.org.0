Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4BB17C5A5
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388509AbfGaPIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:08:23 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44786 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388460AbfGaPIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:22 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so65977852edr.11
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iUFTIkzD0AEWQDnWiQSmBU6zhO1n8aNV0ScoY6j3b3g=;
        b=HrgukcbYAcj6z3TpaDjKhK1/cgEcnxMbqeCU6Z/toHInRTYK6v2mWxxYMVteRX1xIk
         H1k6zrMLrZvNf3OAcKFKHshR34yCCmm8hkHbTXc/YrWwnbcihOhBQ0QeMMCucKpTXxpJ
         SJC4bsE6hnX5Rp4f6xYDboqRRzvNcWl/MiRQZXEUpfajjat/tIUHsWvIPZyG+FaU+HAd
         1t5RRpHWiXhY/ui/+qO7VOSTp4HsT+a5HDJIKwBC/BlgUgnjNplUOJAe8hTaTHztfKP/
         QXniR7rebS1A+SHJF4GOUe6R1UGSYs9thlag8rbM3PX/uQL9LPZT7zM4jHRHS0tsN4XL
         rrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iUFTIkzD0AEWQDnWiQSmBU6zhO1n8aNV0ScoY6j3b3g=;
        b=O778+fKBFoJIwuh4Dkw2KqVvKRu1lXkSm/Thaa5RHLEIW/wl20QJTvblXafrUALY9F
         i4myX3Ov9eDtYi0CDn2glqLA/u4y8IFmUx9Mfnrp2FHDW9V2J+uNPanHE6rYkF0pqwWo
         NIQ0zJ297l9e0P6/VjBSUMfs1yQc3AXObpMIMPQ8bWyr+07jtDzX0PUqg4sEhCmI0kVH
         Nv9ENcG80kLGhowV/cLVKexEKpBdPtwaCF3ZdcLF7FpDJXyrf04h3amU/pr8t/o9huh3
         Xcz6BaWl3o8likKtpOZc0ZHXIhQtFVncLBcB33lauqm62MiTfAgS85O9bDqe8NlYRjrq
         iWzQ==
X-Gm-Message-State: APjAAAV8TGjIO4YqOlUd2h28Ysf6zNn9bAgu3LbA+s8O7k0ipYr61mEG
        szgVEiThGihmxtNLcabHn/A=
X-Google-Smtp-Source: APXvYqzYj85HAgTooG0QaW9NsjqZtZHRdbLp9Q2J1lz2TGQD3rqCjiCzCypUPluaUdrMl5P/zGF3dA==
X-Received: by 2002:a50:b6ce:: with SMTP id f14mr103054546ede.236.1564585700501;
        Wed, 31 Jul 2019 08:08:20 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id fk15sm12674271ejb.42.2019.07.31.08.08.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:19 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 1246910131C; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 05/59] mm/page_alloc: Handle allocation for encrypted memory
Date:   Wed, 31 Jul 2019 18:07:19 +0300
Message-Id: <20190731150813.26289-6-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For encrypted memory, we need to allocate pages for a specific
encryption KeyID.

There are two cases when we need to allocate a page for encryption:

 - Allocation for an encrypted VMA;

 - Allocation for migration of encrypted page;

The first case can be covered within alloc_page_vma(). We know KeyID
from the VMA.

The second case requires few new page allocation routines that would
allocate the page for a specific KeyID.

An encrypted page has to be cleared after KeyID set. This is handled
in prep_encrypted_page() that will be provided by arch-specific code.

Any custom allocator that deals with encrypted pages has to call
prep_encrypted_page() too. See compaction_alloc() for instance.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/gfp.h     | 50 +++++++++++++++++++++++++---
 include/linux/migrate.h | 14 ++++++--
 mm/compaction.c         |  3 ++
 mm/mempolicy.c          | 27 +++++++++++----
 mm/migrate.c            |  4 +--
 mm/page_alloc.c         | 74 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 155 insertions(+), 17 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 3d4cb9fea417..014aef082821 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -463,16 +463,48 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
+#ifndef prep_encrypted_page
+/*
+ * An architecture may override the helper to prepare the page
+ * to be used for with specific KeyID. To be called on encrypted
+ * page allocation.
+ */
+static inline void prep_encrypted_page(struct page *page, int order,
+		int keyid, bool zero)
+{
+}
+#endif
+
+/*
+ * Encrypted page has to be cleared once keyid is set, not on allocation.
+ */
+static inline bool deferred_page_zero(int keyid, gfp_t *gfp_mask)
+{
+	if (keyid && (*gfp_mask & __GFP_ZERO)) {
+		*gfp_mask &= ~__GFP_ZERO;
+		return true;
+	}
+
+	return false;
+}
+
 struct page *
 __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
 							nodemask_t *nodemask);
 
+struct page *
+__alloc_pages_nodemask_keyid(gfp_t gfp_mask, unsigned int order,
+		int preferred_nid, nodemask_t *nodemask, int keyid);
+
 static inline struct page *
 __alloc_pages(gfp_t gfp_mask, unsigned int order, int preferred_nid)
 {
 	return __alloc_pages_nodemask(gfp_mask, order, preferred_nid, NULL);
 }
 
+struct page *__alloc_pages_node_keyid(int nid, int keyid,
+		gfp_t gfp_mask, unsigned int order);
+
 /*
  * Allocate pages, preferring the node given as nid. The node must be valid and
  * online. For more general interface, see alloc_pages_node().
@@ -500,6 +532,19 @@ static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 	return __alloc_pages_node(nid, gfp_mask, order);
 }
 
+static inline struct page *alloc_pages_node_keyid(int nid, int keyid,
+		gfp_t gfp_mask, unsigned int order)
+{
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
+	return __alloc_pages_node_keyid(nid, keyid, gfp_mask, order);
+}
+
+extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
+			struct vm_area_struct *vma, unsigned long addr,
+			int node, bool hugepage);
+
 #ifdef CONFIG_NUMA
 extern struct page *alloc_pages_current(gfp_t gfp_mask, unsigned order);
 
@@ -508,14 +553,9 @@ alloc_pages(gfp_t gfp_mask, unsigned int order)
 {
 	return alloc_pages_current(gfp_mask, order);
 }
-extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
-			struct vm_area_struct *vma, unsigned long addr,
-			int node, bool hugepage);
 #else
 #define alloc_pages(gfp_mask, order) \
 		alloc_pages_node(numa_node_id(), gfp_mask, order)
-#define alloc_pages_vma(gfp_mask, order, vma, addr, node, false)\
-	alloc_pages(gfp_mask, order)
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 7f04754c7f2b..a68516271c40 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -38,9 +38,16 @@ static inline struct page *new_page_nodemask(struct page *page,
 	unsigned int order = 0;
 	struct page *new_page = NULL;
 
-	if (PageHuge(page))
+	if (PageHuge(page)) {
+		/*
+		 * HugeTLB doesn't support encryption. We shouldn't see
+		 * such pages.
+		 */
+		if (WARN_ON_ONCE(page_keyid(page)))
+			return NULL;
 		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
 				preferred_nid, nodemask);
+	}
 
 	if (PageTransHuge(page)) {
 		gfp_mask |= GFP_TRANSHUGE;
@@ -50,8 +57,9 @@ static inline struct page *new_page_nodemask(struct page *page,
 	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
 		gfp_mask |= __GFP_HIGHMEM;
 
-	new_page = __alloc_pages_nodemask(gfp_mask, order,
-				preferred_nid, nodemask);
+	/* Allocate a page with the same KeyID as the source page */
+	new_page = __alloc_pages_nodemask_keyid(gfp_mask, order,
+				preferred_nid, nodemask, page_keyid(page));
 
 	if (new_page && PageTransHuge(new_page))
 		prep_transhuge_page(new_page);
diff --git a/mm/compaction.c b/mm/compaction.c
index 9e1b9acb116b..874af83214b7 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1559,6 +1559,9 @@ static struct page *compaction_alloc(struct page *migratepage,
 	list_del(&freepage->lru);
 	cc->nr_freepages--;
 
+	/* Prepare the page using the same KeyID as the source page */
+	if (freepage)
+		prep_encrypted_page(freepage, 0, page_keyid(migratepage), false);
 	return freepage;
 }
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 14ee933b1ff7..f79b4fa08c30 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -961,22 +961,29 @@ static void migrate_page_add(struct page *page, struct list_head *pagelist,
 /* page allocation callback for NUMA node migration */
 struct page *alloc_new_node_page(struct page *page, unsigned long node)
 {
-	if (PageHuge(page))
+	if (PageHuge(page)) {
+		/*
+		 * HugeTLB doesn't support encryption. We shouldn't see
+		 * such pages.
+		 */
+		if (WARN_ON_ONCE(page_keyid(page)))
+			return NULL;
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					node);
-	else if (PageTransHuge(page)) {
+	} else if (PageTransHuge(page)) {
 		struct page *thp;
 
-		thp = alloc_pages_node(node,
+		thp = alloc_pages_node_keyid(node, page_keyid(page),
 			(GFP_TRANSHUGE | __GFP_THISNODE),
 			HPAGE_PMD_ORDER);
 		if (!thp)
 			return NULL;
 		prep_transhuge_page(thp);
 		return thp;
-	} else
-		return __alloc_pages_node(node, GFP_HIGHUSER_MOVABLE |
-						    __GFP_THISNODE, 0);
+	} else {
+		return __alloc_pages_node_keyid(node, page_keyid(page),
+				GFP_HIGHUSER_MOVABLE | __GFP_THISNODE, 0);
+	}
 }
 
 /*
@@ -2053,9 +2060,13 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 {
 	struct mempolicy *pol;
 	struct page *page;
-	int preferred_nid;
+	bool deferred_zero;
+	int keyid, preferred_nid;
 	nodemask_t *nmask;
 
+	keyid = vma_keyid(vma);
+	deferred_zero = deferred_page_zero(keyid, &gfp);
+
 	pol = get_vma_policy(vma, addr);
 
 	if (pol->mode == MPOL_INTERLEAVE) {
@@ -2097,6 +2108,8 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 	page = __alloc_pages_nodemask(gfp, order, preferred_nid, nmask);
 	mpol_cond_put(pol);
 out:
+	if (page)
+		prep_encrypted_page(page, order, keyid, deferred_zero);
 	return page;
 }
 EXPORT_SYMBOL(alloc_pages_vma);
diff --git a/mm/migrate.c b/mm/migrate.c
index 8992741f10aa..c1b88eae71d8 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1873,7 +1873,7 @@ static struct page *alloc_misplaced_dst_page(struct page *page,
 	int nid = (int) data;
 	struct page *newpage;
 
-	newpage = __alloc_pages_node(nid,
+	newpage = __alloc_pages_node_keyid(nid, page_keyid(page),
 					 (GFP_HIGHUSER_MOVABLE |
 					  __GFP_THISNODE | __GFP_NOMEMALLOC |
 					  __GFP_NORETRY | __GFP_NOWARN) &
@@ -1999,7 +1999,7 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	int page_lru = page_is_file_cache(page);
 	unsigned long start = address & HPAGE_PMD_MASK;
 
-	new_page = alloc_pages_node(node,
+	new_page = alloc_pages_node_keyid(node, page_keyid(page),
 		(GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
 		HPAGE_PMD_ORDER);
 	if (!new_page)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 272c6de1bf4e..963f959350e4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4046,6 +4046,53 @@ should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_fla
 }
 #endif /* CONFIG_COMPACTION */
 
+#ifndef CONFIG_NUMA
+struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
+		struct vm_area_struct *vma, unsigned long addr,
+		int node, bool hugepage)
+{
+	struct page *page;
+	bool deferred_zero;
+	int keyid = vma_keyid(vma);
+
+	deferred_zero = deferred_page_zero(keyid, &gfp_mask);
+	page = alloc_pages(gfp_mask, order);
+	if (page)
+		prep_encrypted_page(page, order, keyid, deferred_zero);
+
+	return page;
+}
+#endif
+
+/**
+ * __alloc_pages_node_keyid - allocate a page for a specific KeyID with
+ * preferred allocation node.
+ * @nid: the preferred node ID where memory should be allocated
+ * @keyid: KeyID to use
+ * @gfp_mask: GFP flags for the allocation
+ * @order: the page order
+ *
+ * Like __alloc_pages_node(), but prepares the page for a specific KeyID.
+ *
+ * Return: pointer to the allocated page or %NULL in case of error.
+ */
+struct page * __alloc_pages_node_keyid(int nid, int keyid,
+		gfp_t gfp_mask, unsigned int order)
+{
+	struct page *page;
+	bool deferred_zero;
+
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	VM_WARN_ON(!node_online(nid));
+
+	deferred_zero = deferred_page_zero(keyid, &gfp_mask);
+	page = __alloc_pages(gfp_mask, order, nid);
+	if (page)
+		prep_encrypted_page(page, order, keyid, deferred_zero);
+
+	return page;
+}
+
 #ifdef CONFIG_LOCKDEP
 static struct lockdep_map __fs_reclaim_map =
 	STATIC_LOCKDEP_MAP_INIT("fs_reclaim", &__fs_reclaim_map);
@@ -4757,6 +4804,33 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
 
+/**
+ * __alloc_pages_nodemask_keyid - allocate a page for a specific KeyID.
+ * @gfp_mask: GFP flags for the allocation
+ * @order: the page order
+ * @preferred_nid: the preferred node ID where memory should be allocated
+ * @nodemask: allowed nodemask
+ * @keyid: KeyID to use
+ *
+ * Like __alloc_pages_nodemask(), but prepares the page for a specific KeyID.
+ *
+ * Return: pointer to the allocated page or %NULL in case of error.
+ */
+struct page *
+__alloc_pages_nodemask_keyid(gfp_t gfp_mask, unsigned int order,
+		int preferred_nid, nodemask_t *nodemask, int keyid)
+{
+	struct page *page;
+	bool deferred_zero;
+
+	deferred_zero = deferred_page_zero(keyid, &gfp_mask);
+	page = __alloc_pages_nodemask(gfp_mask, order, preferred_nid, nodemask);
+	if (page)
+		prep_encrypted_page(page, order, keyid, deferred_zero);
+	return page;
+}
+EXPORT_SYMBOL(__alloc_pages_nodemask_keyid);
+
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
  * address cannot represent highmem pages. Use alloc_pages and then kmap if
-- 
2.21.0

