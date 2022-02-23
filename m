Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180374C0C06
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237990AbiBWF1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238328AbiBWF0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:25 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546D86E4F2
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:04 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d07ae1145aso162070187b3.4
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vK4stcDcFWOmnS7XFdl48O2PCgqnR6b+h+9UyqGSKHo=;
        b=WeE4/kJf1JBwoHaoRE1hNnNZMWwTToI7DEJHTID7WIxYsRDDOQgqC+1Tt7v7oX0Gpi
         ZmRLZAZ2vDdsuIDB2S8uWUw1YsFiIl0loYVOvIAhqXAjeeol/TFwLp8ORGxcWp10Znnv
         Fm89xpJAHuDIyCGkiR6qSwg/Ed2RYqbaYiZbeHx1AcGw15lQM8m5E4AwvqrpiEZ4xaWB
         fo5SYVGmwmAcFx/4QD/6NyE3+JjhT+8OXDlEZf2AotxVIkqYFj/Rh40KkPJ8CI4n5jQK
         7ZdRdvip/O5Och4s64bR2f4QDQ48Fke+i6WKvHWJfT9D9ayGbTZXm6UK8dYn9Je6DvRz
         f9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vK4stcDcFWOmnS7XFdl48O2PCgqnR6b+h+9UyqGSKHo=;
        b=JdAk0l+W5r0qTLImIASWFQEwfbsiJEMIEBjjgjwyiqm0JL15ftqJApDNS7ZHD6aYPm
         ECwOyTrOIUtDYZ8UzpveFH32dlZQK3Ku4gndZTGv+9JFI9i1UjyDftVYPRzBk7SBB3Wy
         WbiFB5+QgD1tWOSzhBVe4GyaljlhK8UJN/nzT/mF97VyHFTrbFvM90Nt+nY4lDSWJd06
         BWt83cS9h2kBhQOls8j8i4MwwNHehyLJdJuvI7VnC4KKXDWYSlqRj9RinBqXDi++Pi8U
         6VC+MIePdopb/+YzNlsv+ts8QyiHDSLz+FPAiQ1Uxls+R4ReoRAofvNrKEaYdg9rLnvO
         hJfg==
X-Gm-Message-State: AOAM531PnwcO2hPMBVsV5n4/FOb7bHRp1dOr8qzrw2AiGKzFKiqd0rMf
        NNQ1+HqIo3B61dkrrcbp5EQ0a62P6HJN
X-Google-Smtp-Source: ABdhPJyP9PANVGMHQ1NQcOMu/RGh/MDmkswDGY7BrfXZ28lpcuzIVCL0D2Bn/aYlOJdsoN0ZdyV9/jnSWe04
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a05:6902:543:b0:61d:c152:bd19 with SMTP id
 z3-20020a056902054300b0061dc152bd19mr27379968ybs.377.1645593892611; Tue, 22
 Feb 2022 21:24:52 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:06 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-31-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 30/47] mm: asi: Add API for mapping userspace address ranges
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

asi_map_user()/asi_unmap_user() can be used to map userspace address
ranges for ASI classes that do not specify ASI_MAP_ALL_USERSPACE.
In addition, another structure, asi_pgtbl_pool, allows for
pre-allocating a set of pages to avoid having to allocate memory
for page tables within asi_map_user(), which makes it easier to use
that function while holding locks.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h |  19 +++
 arch/x86/mm/asi.c          | 252 ++++++++++++++++++++++++++++++++++---
 include/asm-generic/asi.h  |  21 ++++
 include/linux/mm_types.h   |   2 +-
 4 files changed, 275 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 35421356584b..bdb2f70d4f85 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -44,6 +44,12 @@ struct asi {
 	atomic64_t *tlb_gen;
 	atomic64_t __tlb_gen;
 	int64_t asi_ref_count;
+	rwlock_t user_map_lock;
+};
+
+struct asi_pgtbl_pool {
+	struct page *pgtbl_list;
+	uint count;
 };
 
 DECLARE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
@@ -74,6 +80,19 @@ void asi_do_lazy_map(struct asi *asi, size_t addr);
 void asi_clear_user_pgd(struct mm_struct *mm, size_t addr);
 void asi_clear_user_p4d(struct mm_struct *mm, size_t addr);
 
+int  asi_map_user(struct asi *asi, void *addr, size_t len,
+		  struct asi_pgtbl_pool *pool,
+		  size_t allowed_start, size_t allowed_end);
+void asi_unmap_user(struct asi *asi, void *va, size_t len);
+int  asi_fill_pgtbl_pool(struct asi_pgtbl_pool *pool, uint count, gfp_t flags);
+void asi_clear_pgtbl_pool(struct asi_pgtbl_pool *pool);
+
+static inline void asi_init_pgtbl_pool(struct asi_pgtbl_pool *pool)
+{
+	pool->pgtbl_list = NULL;
+	pool->count = 0;
+}
+
 static inline void asi_init_thread_state(struct thread_struct *thread)
 {
 	thread->intr_nest_depth = 0;
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 29c74b6d4262..9b1bd005f343 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -86,6 +86,55 @@ void asi_unregister_class(int index)
 }
 EXPORT_SYMBOL_GPL(asi_unregister_class);
 
+static ulong get_pgtbl_from_pool(struct asi_pgtbl_pool *pool)
+{
+	struct page *pgtbl;
+
+	if (pool->count == 0)
+		return 0;
+
+	pgtbl = pool->pgtbl_list;
+	pool->pgtbl_list = pgtbl->asi_pgtbl_pool_next;
+	pgtbl->asi_pgtbl_pool_next = NULL;
+	pool->count--;
+
+	return (ulong)page_address(pgtbl);
+}
+
+static void return_pgtbl_to_pool(struct asi_pgtbl_pool *pool, ulong virt)
+{
+	struct page *pgtbl = virt_to_page(virt);
+
+	pgtbl->asi_pgtbl_pool_next = pool->pgtbl_list;
+	pool->pgtbl_list = pgtbl;
+	pool->count++;
+}
+
+int asi_fill_pgtbl_pool(struct asi_pgtbl_pool *pool, uint count, gfp_t flags)
+{
+	if (!static_cpu_has(X86_FEATURE_ASI))
+		return 0;
+
+	while (pool->count < count) {
+		ulong pgtbl = get_zeroed_page(flags);
+
+		if (!pgtbl)
+			return -ENOMEM;
+
+		return_pgtbl_to_pool(pool, pgtbl);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(asi_fill_pgtbl_pool);
+
+void asi_clear_pgtbl_pool(struct asi_pgtbl_pool *pool)
+{
+	while (pool->count > 0)
+		free_page(get_pgtbl_from_pool(pool));
+}
+EXPORT_SYMBOL_GPL(asi_clear_pgtbl_pool);
+
 static void asi_clone_pgd(pgd_t *dst_table, pgd_t *src_table, size_t addr)
 {
 	pgd_t *src = pgd_offset_pgd(src_table, addr);
@@ -110,10 +159,12 @@ static void asi_clone_pgd(pgd_t *dst_table, pgd_t *src_table, size_t addr)
 #define DEFINE_ASI_PGTBL_ALLOC(base, level)				\
 static level##_t * asi_##level##_alloc(struct asi *asi,			\
 				       base##_t *base, ulong addr,	\
-				       gfp_t flags)			\
+				       gfp_t flags,			\
+				       struct asi_pgtbl_pool *pool)	\
 {									\
 	if (unlikely(base##_none(*base))) {				\
-		ulong pgtbl = get_zeroed_page(flags);			\
+		ulong pgtbl = pool ? get_pgtbl_from_pool(pool)		\
+				   : get_zeroed_page(flags);		\
 		phys_addr_t pgtbl_pa;					\
 									\
 		if (pgtbl == 0)						\
@@ -127,7 +178,10 @@ static level##_t * asi_##level##_alloc(struct asi *asi,			\
 			mm_inc_nr_##level##s(asi->mm);			\
 		} else {						\
 			paravirt_release_##level(PHYS_PFN(pgtbl_pa));	\
-			free_page(pgtbl);				\
+			if (pool)					\
+				return_pgtbl_to_pool(pool, pgtbl);	\
+			else						\
+				free_page(pgtbl);			\
 		}							\
 									\
 		/* NOP on native. PV call on Xen. */			\
@@ -336,6 +390,7 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 	asi->class = &asi_class[asi_index];
 	asi->mm = mm;
 	asi->pcid_index = asi_index;
+	rwlock_init(&asi->user_map_lock);
 
 	if (asi->class->flags & ASI_MAP_STANDARD_NONSENSITIVE) {
 		uint i;
@@ -650,11 +705,6 @@ static bool follow_physaddr(struct mm_struct *mm, size_t virt,
 /*
  * Map the given range into the ASI page tables. The source of the mapping
  * is the regular unrestricted page tables.
- * Can be used to map any kernel memory.
- *
- * The caller MUST ensure that the source mapping will not change during this
- * function. For dynamic kernel memory, this is generally ensured by mapping
- * the memory within the allocator.
  *
  * If the source mapping is a large page and the range being mapped spans the
  * entire large page, then it will be mapped as a large page in the ASI page
@@ -664,19 +714,17 @@ static bool follow_physaddr(struct mm_struct *mm, size_t virt,
  * destination page, but that should be ok for now, as usually in such cases,
  * the range would consist of a small-ish number of pages.
  */
-int asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags)
+int __asi_map(struct asi *asi, size_t start, size_t end, gfp_t gfp_flags,
+	      struct asi_pgtbl_pool *pool,
+	      size_t allowed_start, size_t allowed_end)
 {
 	size_t virt;
-	size_t start = (size_t)addr;
-	size_t end = start + len;
 	size_t page_size;
 
-	if (!static_cpu_has(X86_FEATURE_ASI) || !asi)
-		return 0;
-
 	VM_BUG_ON(start & ~PAGE_MASK);
-	VM_BUG_ON(len & ~PAGE_MASK);
-	VM_BUG_ON(start < TASK_SIZE_MAX);
+	VM_BUG_ON(end & ~PAGE_MASK);
+	VM_BUG_ON(end > allowed_end);
+	VM_BUG_ON(start < allowed_start);
 
 	gfp_flags &= GFP_RECLAIM_MASK;
 
@@ -702,14 +750,15 @@ int asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags)
 				continue;				       \
 			}						       \
 									       \
-			level = asi_##level##_alloc(asi, base, virt, gfp_flags);\
+			level = asi_##level##_alloc(asi, base, virt,	       \
+						    gfp_flags, pool);	       \
 			if (!level)					       \
 				return -ENOMEM;				       \
 									       \
 			if (page_size >= LEVEL##_SIZE &&		       \
 			    (level##_none(*level) || level##_leaf(*level)) &&  \
 			    is_page_within_range(virt, LEVEL##_SIZE,	       \
-						 start, end)) {		       \
+						 allowed_start, allowed_end)) {\
 				page_size = LEVEL##_SIZE;		       \
 				phys &= LEVEL##_MASK;			       \
 									       \
@@ -737,6 +786,26 @@ int asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags)
 	return 0;
 }
 
+/*
+ * Maps the given kernel address range into the ASI page tables.
+ *
+ * The caller MUST ensure that the source mapping will not change during this
+ * function. For dynamic kernel memory, this is generally ensured by mapping
+ * the memory within the allocator.
+ */
+int asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags)
+{
+	size_t start = (size_t)addr;
+	size_t end = start + len;
+
+	if (!static_cpu_has(X86_FEATURE_ASI) || !asi)
+		return 0;
+
+	VM_BUG_ON(start < TASK_SIZE_MAX);
+
+	return __asi_map(asi, start, end, gfp_flags, NULL, start, end);
+}
+
 int asi_map(struct asi *asi, void *addr, size_t len)
 {
 	return asi_map_gfp(asi, addr, len, GFP_KERNEL);
@@ -935,3 +1004,150 @@ void asi_clear_user_p4d(struct mm_struct *mm, size_t addr)
 	if (!pgtable_l5_enabled())
 		__asi_clear_user_pgd(mm, addr);
 }
+
+/*
+ * Maps the given userspace address range into the ASI page tables.
+ *
+ * The caller MUST ensure that the source mapping will not change during this
+ * function e.g. by synchronizing via MMU notifiers or acquiring the
+ * appropriate locks.
+ */
+int asi_map_user(struct asi *asi, void *addr, size_t len,
+		 struct asi_pgtbl_pool *pool,
+		 size_t allowed_start, size_t allowed_end)
+{
+	int err;
+	size_t start = (size_t)addr;
+	size_t end = start + len;
+
+	if (!static_cpu_has(X86_FEATURE_ASI) || !asi)
+		return 0;
+
+	VM_BUG_ON(end > TASK_SIZE_MAX);
+
+	read_lock(&asi->user_map_lock);
+	err = __asi_map(asi, start, end, GFP_NOWAIT, pool,
+			allowed_start, allowed_end);
+	read_unlock(&asi->user_map_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(asi_map_user);
+
+static bool
+asi_unmap_free_pte_range(struct asi_pgtbl_pool *pgtbls_to_free,
+			 pte_t *pte, size_t addr, size_t end)
+{
+	do {
+		pte_clear(NULL, addr, pte);
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+
+	return true;
+}
+
+#define DEFINE_ASI_UNMAP_FREE_RANGE(level, LEVEL, next_level, NEXT_LVL_SIZE)   \
+static bool								       \
+asi_unmap_free_##level##_range(struct asi_pgtbl_pool *pgtbls_to_free,	       \
+			       level##_t *level, size_t addr, size_t end)      \
+{									       \
+	bool unmapped = false;						       \
+	size_t next;							       \
+									       \
+	do {								       \
+		next = level##_addr_end(addr, end);			       \
+		if (level##_none(*level))				       \
+			continue;					       \
+									       \
+		if (IS_ALIGNED(addr, LEVEL##_SIZE) &&			       \
+		    IS_ALIGNED(next, LEVEL##_SIZE)) {			       \
+			if (!level##_large(*level)) {			       \
+				ulong pgtbl = level##_page_vaddr(*level);      \
+				struct page *page = virt_to_page(pgtbl);       \
+									       \
+				page->private = PG_LEVEL_##NEXT_LVL_SIZE;      \
+				return_pgtbl_to_pool(pgtbls_to_free, pgtbl);   \
+			}						       \
+			level##_clear(level);				       \
+			unmapped = true;				       \
+		} else {						       \
+			/*						       \
+			 * At this time, we don't have a case where we need to \
+			 * unmap a subset of a huge page. But that could arise \
+			 * in the future. In that case, we'll need to split    \
+			 * the huge mapping here.			       \
+			 */						       \
+			if (WARN_ON(level##_large(*level)))		       \
+				continue;				       \
+									       \
+			unmapped |= asi_unmap_free_##next_level##_range(       \
+					pgtbls_to_free,			       \
+					next_level##_offset(level, addr),      \
+					addr, next);			       \
+		}							       \
+	} while (level++, addr = next, addr != end);			       \
+									       \
+	return unmapped;						       \
+}
+
+DEFINE_ASI_UNMAP_FREE_RANGE(pmd, PMD, pte, 4K)
+DEFINE_ASI_UNMAP_FREE_RANGE(pud, PUD, pmd, 2M)
+DEFINE_ASI_UNMAP_FREE_RANGE(p4d, P4D, pud, 1G)
+DEFINE_ASI_UNMAP_FREE_RANGE(pgd, PGDIR, p4d, 512G)
+
+static bool asi_unmap_and_free_range(struct asi_pgtbl_pool *pgtbls_to_free,
+				     struct asi *asi, size_t addr, size_t end)
+{
+	size_t next;
+	bool unmapped = false;
+	pgd_t *pgd = pgd_offset_pgd(asi->pgd, addr);
+
+	BUILD_BUG_ON((void *)&((struct page *)NULL)->private ==
+		     (void *)&((struct page *)NULL)->asi_pgtbl_pool_next);
+
+	if (pgtable_l5_enabled())
+		return asi_unmap_free_pgd_range(pgtbls_to_free, pgd, addr, end);
+
+	do {
+		next = pgd_addr_end(addr, end);
+		unmapped |= asi_unmap_free_p4d_range(pgtbls_to_free,
+						     p4d_offset(pgd, addr),
+						     addr, next);
+	} while (pgd++, addr = next, addr != end);
+
+	return unmapped;
+}
+
+void asi_unmap_user(struct asi *asi, void *addr, size_t len)
+{
+	static void (*const free_pgtbl_at_level[])(struct asi *, size_t) = {
+		NULL,
+		asi_free_pte,
+		asi_free_pmd,
+		asi_free_pud,
+		asi_free_p4d
+	};
+
+	struct asi_pgtbl_pool pgtbls_to_free = { 0 };
+	size_t start = (size_t)addr;
+	size_t end = start + len;
+	bool unmapped;
+
+	if (!static_cpu_has(X86_FEATURE_ASI) || !asi)
+		return;
+
+	write_lock(&asi->user_map_lock);
+	unmapped = asi_unmap_and_free_range(&pgtbls_to_free, asi, start, end);
+	write_unlock(&asi->user_map_lock);
+
+	if (unmapped)
+		asi_flush_tlb_range(asi, addr, len);
+
+	while (pgtbls_to_free.count > 0) {
+		size_t pgtbl = get_pgtbl_from_pool(&pgtbls_to_free);
+		struct page *page = virt_to_page(pgtbl);
+
+		VM_BUG_ON(page->private >= PG_LEVEL_NUM);
+		free_pgtbl_at_level[page->private](asi, pgtbl);
+	}
+}
+EXPORT_SYMBOL_GPL(asi_unmap_user);
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index 8513d0d7865a..fffb323d2a00 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -26,6 +26,7 @@
 
 struct asi_hooks {};
 struct asi {};
+struct asi_pgtbl_pool {};
 
 static inline
 int asi_register_class(const char *name, uint flags,
@@ -92,6 +93,26 @@ void asi_clear_user_pgd(struct mm_struct *mm, size_t addr) { }
 static inline
 void asi_clear_user_p4d(struct mm_struct *mm, size_t addr) { }
 
+static inline
+int asi_map_user(struct asi *asi, void *addr, size_t len,
+		 struct asi_pgtbl_pool *pool,
+		 size_t allowed_start, size_t allowed_end)
+{
+	return 0;
+}
+
+static inline void asi_unmap_user(struct asi *asi, void *va, size_t len) { }
+
+static inline
+int asi_fill_pgtbl_pool(struct asi_pgtbl_pool *pool, uint count, gfp_t flags)
+{
+	return 0;
+}
+
+static inline void asi_clear_pgtbl_pool(struct asi_pgtbl_pool *pool) { }
+
+static inline void asi_init_pgtbl_pool(struct asi_pgtbl_pool *pool) { }
+
 static inline
 void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len) { }
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 7d38229ca85c..c3f209720a84 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -198,7 +198,7 @@ struct page {
 			/* Links the pages_to_free_async list */
 			struct llist_node async_free_node;
 
-			unsigned long _asi_pad_1;
+			struct page *asi_pgtbl_pool_next;
 			u64 asi_tlb_gen;
 
 			union {
-- 
2.35.1.473.g83b2b277ed-goog

