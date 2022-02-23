Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EBD4C0BAF
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbiBWFYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238115AbiBWFYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:31 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2D669CC1
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:01 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id o5-20020a25d705000000b0062499d760easo8076385ybg.7
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4OZ+JPmRPuew/8tnwetStHaUs2Nh17IXa7mxxiAMwj8=;
        b=kb4u7VjrnfodFdsXodDcDOsogb6ps0VFuoU2Ch/2lXixZ/HfftZw3kdktGLZNqJaaS
         sS3He2L5FPw70IJb8AKJo1NDhJWYKpPBXq/OhYV1okDxsl0mvsUmyEav/HUJeog/Gj9y
         Q5Dc8pVb07blL49n409GgYRDrcKVQVQRVFNARfm5uMsXWp3Yd02cr7kkTrGmuAR1Xu1E
         sxdm0LFpj5VhSie+6tVTejQjNAf6nTCGVLsZ8GtzBSgzjYfKnMkFSPkXEgjwcV5k4Zwo
         pwZnNuNgZRjJww5tQ8PUPFXrFLOBqqQa1ttWIBXg8Sv/mjjUaM/rS2VlzHPfgRo69Xqa
         n3Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4OZ+JPmRPuew/8tnwetStHaUs2Nh17IXa7mxxiAMwj8=;
        b=23AelsSjI8ui78l1GbLLtK+UbWdVR53c6LlEyur8JeOoS8IIRFjFiiZB7QkEKp36jb
         reV5B9SFUKXWO51lB9dCQfTUTcmMMipoI2BqYrnZd8aoOb7ScY0Uz3SKT0jJy0r1Ury9
         5XA/X/QCG6GFUwEHMcl+2T31LOoF86UjAv+nJ12rI791ctIH/KML3W+xEemYup6P57Bg
         4l2Z3LgGC2yrVEqMsKIK2Ur36wVto64Af1+pTRCW1VaY1GeoldNIfVxCEKu58VaNxmzs
         r9EiRM31Ka7vfK8vZ7kcl9s3016kUmoT1SXWnzAiToLLPhIUf38t9oLMm9FIgv/Mhn0M
         65gQ==
X-Gm-Message-State: AOAM530g+6ph0uIUrHNgFBI/CTB8/DP3PGz1UD/Y6+JV1HSXq1zOLRMx
        SLYbugiG8tQ784mQ7Pxg14GuhJ9KIB2g
X-Google-Smtp-Source: ABdhPJznarXNTwMlwRo1R3Ew9ob69h2spGBZggFbqvzN1k2HjtUx3qHkoNOb8UlGcjxUj887oMmqSttakWi9
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a0d:eb09:0:b0:2d1:e0df:5104 with SMTP id
 u9-20020a0deb09000000b002d1e0df5104mr27667696ywe.250.1645593841036; Tue, 22
 Feb 2022 21:24:01 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:43 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-8-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 07/47] mm: asi: Functions to map/unmap a memory range into
 ASI page tables
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

Two functions, asi_map() and asi_map_gfp(), are added to allow mapping
memory into ASI page tables. The mapping will be identical to the one
for the same virtual address in the unrestricted page tables. This is
necessary to allow switching between the page tables at any arbitrary
point in the kernel.

Another function, asi_unmap() is added to allow unmapping memory mapped
via asi_map*

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h |   5 +
 arch/x86/mm/asi.c          | 196 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/asi.h  |  19 ++++
 mm/internal.h              |   3 +
 mm/vmalloc.c               |  60 +++++++-----
 5 files changed, 261 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 95557211dabd..521b40d1864b 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -53,6 +53,11 @@ void asi_destroy(struct asi *asi);
 void asi_enter(struct asi *asi);
 void asi_exit(void);
 
+int  asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags);
+int  asi_map(struct asi *asi, void *addr, size_t len);
+void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb);
+void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len);
+
 static inline void asi_init_thread_state(struct thread_struct *thread)
 {
 	thread->intr_nest_depth = 0;
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 40d772b2e2a8..84d220cbdcfc 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -6,6 +6,8 @@
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 
+#include "../../../mm/internal.h"
+
 #undef pr_fmt
 #define pr_fmt(fmt)     "ASI: " fmt
 
@@ -287,3 +289,197 @@ void asi_init_mm_state(struct mm_struct *mm)
 {
 	memset(mm->asi, 0, sizeof(mm->asi));
 }
+
+static bool is_page_within_range(size_t addr, size_t page_size,
+				 size_t range_start, size_t range_end)
+{
+	size_t page_start, page_end, page_mask;
+
+	page_mask = ~(page_size - 1);
+	page_start = addr & page_mask;
+	page_end = page_start + page_size;
+
+	return page_start >= range_start && page_end <= range_end;
+}
+
+static bool follow_physaddr(struct mm_struct *mm, size_t virt,
+			    phys_addr_t *phys, size_t *page_size, ulong *flags)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+#define follow_addr_at_level(base, level, LEVEL)			\
+	do {								\
+		*page_size = LEVEL##_SIZE;				\
+		level = level##_offset(base, virt);			\
+		if (!level##_present(*level))				\
+			return false;					\
+									\
+		if (level##_large(*level)) {				\
+			*phys = PFN_PHYS(level##_pfn(*level)) |		\
+				(virt & ~LEVEL##_MASK);			\
+			*flags = level##_flags(*level);			\
+			return true;					\
+		}							\
+	} while (false)
+
+	follow_addr_at_level(mm, pgd, PGDIR);
+	follow_addr_at_level(pgd, p4d, P4D);
+	follow_addr_at_level(p4d, pud, PUD);
+	follow_addr_at_level(pud, pmd, PMD);
+
+	*page_size = PAGE_SIZE;
+	pte = pte_offset_map(pmd, virt);
+	if (!pte)
+		return false;
+
+	if (!pte_present(*pte)) {
+		pte_unmap(pte);
+		return false;
+	}
+
+	*phys = PFN_PHYS(pte_pfn(*pte)) | (virt & ~PAGE_MASK);
+	*flags = pte_flags(*pte);
+
+	pte_unmap(pte);
+	return true;
+
+#undef follow_addr_at_level
+}
+
+/*
+ * Map the given range into the ASI page tables. The source of the mapping
+ * is the regular unrestricted page tables.
+ * Can be used to map any kernel memory.
+ *
+ * The caller MUST ensure that the source mapping will not change during this
+ * function. For dynamic kernel memory, this is generally ensured by mapping
+ * the memory within the allocator.
+ *
+ * If the source mapping is a large page and the range being mapped spans the
+ * entire large page, then it will be mapped as a large page in the ASI page
+ * tables too. If the range does not span the entire huge page, then it will
+ * be mapped as smaller pages. In that case, the implementation is slightly
+ * inefficient, as it will walk the source page tables again for each small
+ * destination page, but that should be ok for now, as usually in such cases,
+ * the range would consist of a small-ish number of pages.
+ */
+int asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags)
+{
+	size_t virt;
+	size_t start = (size_t)addr;
+	size_t end = start + len;
+	size_t page_size;
+
+	if (!static_cpu_has(X86_FEATURE_ASI))
+		return 0;
+
+	VM_BUG_ON(start & ~PAGE_MASK);
+	VM_BUG_ON(len & ~PAGE_MASK);
+	VM_BUG_ON(start < TASK_SIZE_MAX);
+
+	gfp_flags &= GFP_RECLAIM_MASK;
+
+	if (asi->mm != &init_mm)
+		gfp_flags |= __GFP_ACCOUNT;
+
+	for (virt = start; virt < end; virt = ALIGN(virt + 1, page_size)) {
+		pgd_t *pgd;
+		p4d_t *p4d;
+		pud_t *pud;
+		pmd_t *pmd;
+		pte_t *pte;
+		phys_addr_t phys;
+		ulong flags;
+
+		if (!follow_physaddr(asi->mm, virt, &phys, &page_size, &flags))
+			continue;
+
+#define MAP_AT_LEVEL(base, BASE, level, LEVEL) {			       \
+			if (base##_large(*base)) {			       \
+				VM_BUG_ON(PHYS_PFN(phys & BASE##_MASK) !=      \
+					  base##_pfn(*base));		       \
+				continue;				       \
+			}						       \
+									       \
+			level = asi_##level##_alloc(asi, base, virt, gfp_flags);\
+			if (!level)					       \
+				return -ENOMEM;				       \
+									       \
+			if (page_size >= LEVEL##_SIZE &&		       \
+			    (level##_none(*level) || level##_leaf(*level)) &&  \
+			    is_page_within_range(virt, LEVEL##_SIZE,	       \
+						 start, end)) {		       \
+				page_size = LEVEL##_SIZE;		       \
+				phys &= LEVEL##_MASK;			       \
+									       \
+				if (level##_none(*level))		       \
+					set_##level(level,		       \
+						    __##level(phys | flags));  \
+				else					       \
+					VM_BUG_ON(level##_pfn(*level) !=       \
+						  PHYS_PFN(phys));	       \
+				continue;				       \
+			}						       \
+		}
+
+		pgd = pgd_offset_pgd(asi->pgd, virt);
+
+		MAP_AT_LEVEL(pgd, PGDIR, p4d, P4D);
+		MAP_AT_LEVEL(p4d, P4D, pud, PUD);
+		MAP_AT_LEVEL(pud, PUD, pmd, PMD);
+		MAP_AT_LEVEL(pmd, PMD, pte, PAGE);
+
+		VM_BUG_ON(true); /* Should never reach here. */
+#undef MAP_AT_LEVEL
+	}
+
+	return 0;
+}
+
+int asi_map(struct asi *asi, void *addr, size_t len)
+{
+	return asi_map_gfp(asi, addr, len, GFP_KERNEL);
+}
+
+/*
+ * Unmap a kernel address range previously mapped into the ASI page tables.
+ * The caller must ensure appropriate TLB flushing.
+ *
+ * The area being unmapped must be a whole previously mapped region (or regions)
+ * Unmapping a partial subset of a previously mapped region is not supported.
+ * That will work, but may end up unmapping more than what was asked for, if
+ * the mapping contained huge pages.
+ *
+ * Note that higher order direct map allocations are allowed to be partially
+ * freed. If it turns out that that actually happens for any of the
+ * non-sensitive allocations, then the above limitation may be a problem. For
+ * now, vunmap_pgd_range() will emit a warning if this situation is detected.
+ */
+void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb)
+{
+	size_t start = (size_t)addr;
+	size_t end = start + len;
+	pgtbl_mod_mask mask = 0;
+
+	if (!static_cpu_has(X86_FEATURE_ASI) || !len)
+		return;
+
+	VM_BUG_ON(start & ~PAGE_MASK);
+	VM_BUG_ON(len & ~PAGE_MASK);
+	VM_BUG_ON(start < TASK_SIZE_MAX);
+
+	vunmap_pgd_range(asi->pgd, start, end, &mask, false);
+
+	if (flush_tlb)
+		asi_flush_tlb_range(asi, addr, len);
+}
+
+void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len)
+{
+	/* Later patches will do a more optimized flush. */
+	flush_tlb_kernel_range((ulong)addr, (ulong)addr + len);
+}
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index dae1403ee1d0..7da91cbe075d 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -2,6 +2,8 @@
 #ifndef __ASM_GENERIC_ASI_H
 #define __ASM_GENERIC_ASI_H
 
+#include <linux/types.h>
+
 /* ASI class flags */
 #define ASI_MAP_STANDARD_NONSENSITIVE	1
 
@@ -44,6 +46,23 @@ static inline struct asi *asi_get_target(void) { return NULL; }
 
 static inline struct asi *asi_get_current(void) { return NULL; }
 
+static inline
+int asi_map_gfp(struct asi *asi, void *addr, size_t len, gfp_t gfp_flags)
+{
+	return 0;
+}
+
+static inline int asi_map(struct asi *asi, void *addr, size_t len)
+{
+	return 0;
+}
+
+static inline
+void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb) { }
+
+static inline
+void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len) { }
+
 #define static_asi_enabled() false
 
 #endif  /* !_ASSEMBLY_ */
diff --git a/mm/internal.h b/mm/internal.h
index 3b79a5c9427a..ae8799d86dd3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -79,6 +79,9 @@ void unmap_page_range(struct mmu_gather *tlb,
 			     unsigned long addr, unsigned long end,
 			     struct zap_details *details);
 
+void vunmap_pgd_range(pgd_t *pgd_table, unsigned long addr, unsigned long end,
+		      pgtbl_mod_mask *mask, bool sleepable);
+
 void do_page_cache_ra(struct readahead_control *, unsigned long nr_to_read,
 		unsigned long lookahead_size);
 void force_page_cache_ra(struct readahead_control *, unsigned long nr);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d2a00ad4e1dd..f2ef719f1cba 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -336,7 +336,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 }
 
 static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
-			     pgtbl_mod_mask *mask)
+			     pgtbl_mod_mask *mask, bool sleepable)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -350,18 +350,22 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 		if (cleared || pmd_bad(*pmd))
 			*mask |= PGTBL_PMD_MODIFIED;
 
-		if (cleared)
+		if (cleared) {
+			WARN_ON(addr & ~PMD_MASK);
+			WARN_ON(next & ~PMD_MASK);
 			continue;
+		}
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		vunmap_pte_range(pmd, addr, next, mask);
 
-		cond_resched();
+		if (sleepable)
+			cond_resched();
 	} while (pmd++, addr = next, addr != end);
 }
 
 static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
-			     pgtbl_mod_mask *mask)
+			     pgtbl_mod_mask *mask, bool sleepable)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -375,16 +379,19 @@ static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 		if (cleared || pud_bad(*pud))
 			*mask |= PGTBL_PUD_MODIFIED;
 
-		if (cleared)
+		if (cleared) {
+			WARN_ON(addr & ~PUD_MASK);
+			WARN_ON(next & ~PUD_MASK);
 			continue;
+		}
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		vunmap_pmd_range(pud, addr, next, mask);
+		vunmap_pmd_range(pud, addr, next, mask, sleepable);
 	} while (pud++, addr = next, addr != end);
 }
 
 static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-			     pgtbl_mod_mask *mask)
+			     pgtbl_mod_mask *mask, bool sleepable)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -398,14 +405,35 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 		if (cleared || p4d_bad(*p4d))
 			*mask |= PGTBL_P4D_MODIFIED;
 
-		if (cleared)
+		if (cleared) {
+			WARN_ON(addr & ~P4D_MASK);
+			WARN_ON(next & ~P4D_MASK);
 			continue;
+		}
 		if (p4d_none_or_clear_bad(p4d))
 			continue;
-		vunmap_pud_range(p4d, addr, next, mask);
+		vunmap_pud_range(p4d, addr, next, mask, sleepable);
 	} while (p4d++, addr = next, addr != end);
 }
 
+void vunmap_pgd_range(pgd_t *pgd_table, unsigned long addr, unsigned long end,
+		      pgtbl_mod_mask *mask, bool sleepable)
+{
+	unsigned long next;
+	pgd_t *pgd = pgd_offset_pgd(pgd_table, addr);
+
+	BUG_ON(addr >= end);
+
+	do {
+		next = pgd_addr_end(addr, end);
+		if (pgd_bad(*pgd))
+			*mask |= PGTBL_PGD_MODIFIED;
+		if (pgd_none_or_clear_bad(pgd))
+			continue;
+		vunmap_p4d_range(pgd, addr, next, mask, sleepable);
+	} while (pgd++, addr = next, addr != end);
+}
+
 /*
  * vunmap_range_noflush is similar to vunmap_range, but does not
  * flush caches or TLBs.
@@ -420,21 +448,9 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
  */
 void vunmap_range_noflush(unsigned long start, unsigned long end)
 {
-	unsigned long next;
-	pgd_t *pgd;
-	unsigned long addr = start;
 	pgtbl_mod_mask mask = 0;
 
-	BUG_ON(addr >= end);
-	pgd = pgd_offset_k(addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_bad(*pgd))
-			mask |= PGTBL_PGD_MODIFIED;
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		vunmap_p4d_range(pgd, addr, next, &mask);
-	} while (pgd++, addr = next, addr != end);
+	vunmap_pgd_range(init_mm.pgd, start, end, &mask, true);
 
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
 		arch_sync_kernel_mappings(start, end);
-- 
2.35.1.473.g83b2b277ed-goog

