Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3DF4C0BB7
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238298AbiBWFZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbiBWFYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:55 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090EF6C1D9
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:08 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d07ae11464so162253827b3.14
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gMgbv5PxdERvilfG13W1/59w3Y4MPufgzH9ipT5mZcE=;
        b=b6urhxkWGfnvarQIxVi9atsKIrKLwBXqKa9HpQGtESTNRqGIm9vkGf3iqdrTrF3WZR
         5m1o2lHCH4V6NfBZsxlk8GhGN3fJPzlR3rYLD19suBuPDuixp1NPgPg6U6hpUzZvTY5L
         IgBE58eLo2ZZzbqp5xEwBHiVFVtDJ87nrKLza6quhghsvVIu54Q0IHEcJ3cNhC/sxTwh
         jZftmgJSZ3zhdFt219bc3VfY34rKbPUl3RGNBdUPaeK8YOXIcRYVBQ85kA7yXhGQqR5+
         DMF/TwW/QA+HqXhMMcxPWsADaTGbuLYcULrIcRh5s/jS84XHXJ0eFx/xBfm7XL6hFrwa
         +MKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gMgbv5PxdERvilfG13W1/59w3Y4MPufgzH9ipT5mZcE=;
        b=Wave+P5sIlJuS6nA+lL6uV56I3kj/3Ds3FbIJlj5CLZ3lWbqV5B9/DuFKrTjEvZMnh
         g/ooRlEEsbMC86xsXtgJD+iB7A0KsRFyAYOcvSRTtGrq24NAhochRiXwNXPOPeOZvfiB
         drwxEXky3NNrHh1xSG9GDBeUdnpUgGIah+WAzPjfBA9GaNuLFcYULDs35vSpg8BxmHR/
         gcGgmH401jEGCWTrw1dS/uYJmJ/jKKVohebYfp4eRetz6s2nluFe6KDVytshiM1jzWWR
         uiteSznU9fTwUPrDtVWIG3ArRIV5yqoax2TsXGhChbVdbREAC0sLlhjCV27hFW6ngsYk
         9qVA==
X-Gm-Message-State: AOAM531xcyGO+vnZ011PzXb8FpjoL4u1gxfTF5h7ZKg/aVj7eeRx8VBC
        NZbmqAmJ+bzAuOsJjhfXq4X8EoEPnnac
X-Google-Smtp-Source: ABdhPJxT/vWX0OjiErFxevki8JUky5j473dKCodPTix92VCbsXfh3r9zdc2C7QnCBcd9ntaYhKL50joC8J3g
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:5d0:0:b0:2d0:d056:c703 with SMTP id
 199-20020a8105d0000000b002d0d056c703mr28080196ywf.288.1645593847896; Tue, 22
 Feb 2022 21:24:07 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:46 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-11-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 10/47] mm: asi: Support for global non-sensitive direct
 map allocations
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

A new GFP flag is added to specify that an allocation should be
considered globally non-sensitive. The pages will be mapped into the
ASI global non-sensitive pseudo-PGD, which is shared between all
standard ASI instances. A new page flag is also added so that when
these pages are freed, they can also be unmapped from the ASI page
tables.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 include/linux/gfp.h            |  10 ++-
 include/linux/mm_types.h       |   5 ++
 include/linux/page-flags.h     |   9 ++
 include/trace/events/mmflags.h |  12 ++-
 mm/page_alloc.c                | 145 ++++++++++++++++++++++++++++++++-
 tools/perf/builtin-kmem.c      |   1 +
 6 files changed, 178 insertions(+), 4 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 8fcc38467af6..07a99a463a34 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -60,6 +60,11 @@ struct vm_area_struct;
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+#define ___GFP_GLOBAL_NONSENSITIVE 0x4000000u
+#else
+#define ___GFP_GLOBAL_NONSENSITIVE 0
+#endif
 /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 
 /*
@@ -248,8 +253,11 @@ struct vm_area_struct;
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
+/* Allocate non-sensitive memory */
+#define __GFP_GLOBAL_NONSENSITIVE ((__force gfp_t)___GFP_GLOBAL_NONSENSITIVE)
+
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT (25 + IS_ENABLED(CONFIG_LOCKDEP))
+#define __GFP_BITS_SHIFT 27
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /**
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3de1afa57289..5b8028fcfe67 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -191,6 +191,11 @@ struct page {
 
 		/** @rcu_head: You can use this to free a page by RCU. */
 		struct rcu_head rcu_head;
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+		/* Links the pages_to_free_async list */
+		struct llist_node async_free_node;
+#endif
 	};
 
 	union {		/* This union is 4 bytes in size. */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b90a17e9796d..a07434cc679c 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -140,6 +140,9 @@ enum pageflags {
 #endif
 #ifdef CONFIG_KASAN_HW_TAGS
 	PG_skip_kasan_poison,
+#endif
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	PG_global_nonsensitive,
 #endif
 	__NR_PAGEFLAGS,
 
@@ -542,6 +545,12 @@ TESTCLEARFLAG(Young, young, PF_ANY)
 PAGEFLAG(Idle, idle, PF_ANY)
 #endif
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+__PAGEFLAG(GlobalNonSensitive, global_nonsensitive, PF_ANY);
+#else
+__PAGEFLAG_FALSE(GlobalNonSensitive, global_nonsensitive);
+#endif
+
 #ifdef CONFIG_KASAN_HW_TAGS
 PAGEFLAG(SkipKASanPoison, skip_kasan_poison, PF_HEAD)
 #else
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 116ed4d5d0f8..73a49197ef54 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -50,7 +50,8 @@
 	{(unsigned long)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},\
 	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},\
 	{(unsigned long)__GFP_ZEROTAGS,		"__GFP_ZEROTAGS"},	\
-	{(unsigned long)__GFP_SKIP_KASAN_POISON,"__GFP_SKIP_KASAN_POISON"}\
+	{(unsigned long)__GFP_SKIP_KASAN_POISON,"__GFP_SKIP_KASAN_POISON"},\
+	{(unsigned long)__GFP_GLOBAL_NONSENSITIVE, "__GFP_GLOBAL_NONSENSITIVE"}\
 
 #define show_gfp_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
@@ -93,6 +94,12 @@
 #define IF_HAVE_PG_SKIP_KASAN_POISON(flag,string)
 #endif
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+#define IF_HAVE_ASI(flag, string) ,{1UL << flag, string}
+#else
+#define IF_HAVE_ASI(flag, string)
+#endif
+
 #define __def_pageflag_names						\
 	{1UL << PG_locked,		"locked"	},		\
 	{1UL << PG_waiters,		"waiters"	},		\
@@ -121,7 +128,8 @@ IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
 IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
 IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
 IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)		\
-IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
+IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")	\
+IF_HAVE_ASI(PG_global_nonsensitive,	"global_nonsensitive")
 
 #define show_page_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c5952749ad40..a4048fa1868a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -697,7 +697,7 @@ static inline bool pcp_allowed_order(unsigned int order)
 	return false;
 }
 
-static inline void free_the_page(struct page *page, unsigned int order)
+static inline void __free_the_page(struct page *page, unsigned int order)
 {
 	if (pcp_allowed_order(order))		/* Via pcp? */
 		free_unref_page(page, order);
@@ -705,6 +705,14 @@ static inline void free_the_page(struct page *page, unsigned int order)
 		__free_pages_ok(page, order, FPI_NONE);
 }
 
+static bool asi_unmap_freed_pages(struct page *page, unsigned int order);
+
+static inline void free_the_page(struct page *page, unsigned int order)
+{
+	if (asi_unmap_freed_pages(page, order))
+		__free_the_page(page, order);
+}
+
 /*
  * Higher-order pages are called "compound pages".  They are structured thusly:
  *
@@ -5162,6 +5170,129 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	return true;
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+static DEFINE_PER_CPU(struct work_struct, async_free_work);
+static DEFINE_PER_CPU(struct llist_head, pages_to_free_async);
+static bool async_free_work_initialized;
+
+static void __free_the_page(struct page *page, unsigned int order);
+
+static void async_free_work_fn(struct work_struct *work)
+{
+	struct page *page, *tmp;
+	struct llist_node *pages_to_free;
+	void *va;
+	size_t len;
+	uint order;
+
+	pages_to_free = llist_del_all(this_cpu_ptr(&pages_to_free_async));
+
+	/* A later patch will do a more optimized TLB flush. */
+
+	llist_for_each_entry_safe(page, tmp, pages_to_free, async_free_node) {
+		va = page_to_virt(page);
+		order = page->private;
+		len = PAGE_SIZE * (1 << order);
+
+		asi_flush_tlb_range(ASI_GLOBAL_NONSENSITIVE, va, len);
+		__free_the_page(page, order);
+	}
+}
+
+static int __init asi_page_alloc_init(void)
+{
+	int cpu;
+
+	if (!static_asi_enabled())
+		return 0;
+
+	for_each_possible_cpu(cpu)
+		INIT_WORK(per_cpu_ptr(&async_free_work, cpu),
+			  async_free_work_fn);
+
+	/*
+	 * This function is called before SMP is initialized, so we can assume
+	 * that this is the only running CPU at this point.
+	 */
+
+	barrier();
+	async_free_work_initialized = true;
+	barrier();
+
+	if (!llist_empty(this_cpu_ptr(&pages_to_free_async)))
+		queue_work_on(smp_processor_id(), mm_percpu_wq,
+			      this_cpu_ptr(&async_free_work));
+
+	return 0;
+}
+early_initcall(asi_page_alloc_init);
+
+static int asi_map_alloced_pages(struct page *page, uint order, gfp_t gfp_mask)
+{
+	uint i;
+
+	if (!static_asi_enabled())
+		return 0;
+
+	if (gfp_mask & __GFP_GLOBAL_NONSENSITIVE) {
+		for (i = 0; i < (1 << order); i++)
+			__SetPageGlobalNonSensitive(page + i);
+
+		return asi_map_gfp(ASI_GLOBAL_NONSENSITIVE, page_to_virt(page),
+				   PAGE_SIZE * (1 << order), gfp_mask);
+	}
+
+	return 0;
+}
+
+static bool asi_unmap_freed_pages(struct page *page, unsigned int order)
+{
+	void *va;
+	size_t len;
+	bool async_flush_needed;
+
+	if (!static_asi_enabled())
+		return true;
+
+	if (!PageGlobalNonSensitive(page))
+		return true;
+
+	va = page_to_virt(page);
+	len = PAGE_SIZE * (1 << order);
+	async_flush_needed = irqs_disabled() || in_interrupt();
+
+	asi_unmap(ASI_GLOBAL_NONSENSITIVE, va, len, !async_flush_needed);
+
+	if (!async_flush_needed)
+		return true;
+
+	page->private = order;
+	llist_add(&page->async_free_node, this_cpu_ptr(&pages_to_free_async));
+
+	if (async_free_work_initialized)
+		queue_work_on(smp_processor_id(), mm_percpu_wq,
+			      this_cpu_ptr(&async_free_work));
+
+	return false;
+}
+
+#else /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
+static inline
+int asi_map_alloced_pages(struct page *pages, uint order, gfp_t gfp_mask)
+{
+	return 0;
+}
+
+static inline
+bool asi_unmap_freed_pages(struct page *page, unsigned int order)
+{
+	return true;
+}
+
+#endif
+
 /*
  * __alloc_pages_bulk - Allocate a number of order-0 pages to a list or array
  * @gfp: GFP flags for the allocation
@@ -5345,6 +5476,9 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 		return NULL;
 	}
 
+	if (static_asi_enabled() && (gfp & __GFP_GLOBAL_NONSENSITIVE))
+		gfp |= __GFP_ZERO;
+
 	gfp &= gfp_allowed_mask;
 	/*
 	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
@@ -5388,6 +5522,15 @@ struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 		page = NULL;
 	}
 
+	if (page) {
+		int err = asi_map_alloced_pages(page, order, gfp);
+
+		if (unlikely(err)) {
+			__free_pages(page, order);
+			page = NULL;
+		}
+	}
+
 	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
 
 	return page;
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index da03a341c63c..5857953cd5c1 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -660,6 +660,7 @@ static const struct {
 	{ "__GFP_RECLAIM",		"R" },
 	{ "__GFP_DIRECT_RECLAIM",	"DR" },
 	{ "__GFP_KSWAPD_RECLAIM",	"KR" },
+	{ "__GFP_GLOBAL_NONSENSITIVE",	"GNS" },
 };
 
 static size_t max_gfp_len;
-- 
2.35.1.473.g83b2b277ed-goog

