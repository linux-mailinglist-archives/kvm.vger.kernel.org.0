Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207974C0C00
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbiBWF0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238193AbiBWFZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:53 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982626E294
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:52 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a12-20020a056902056c00b0061dc0f2a94aso26532332ybt.6
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ztkGsqUqkQcfbxlBdMnsFZA5zf9U5+9bkMDZbcQFZD8=;
        b=n78DK1+xw1pRWsJW1CFG6TQ6Gavlq4ZQ5W8oD9M2VCMnu8PrU3OyRhoo6bkFuFB9Bp
         w2aijS13h+Op8okZ6CS3EIZUB1IYhktNxmLMznN4orFxlVaThvl2eVvRB8zbVhIFGOvq
         jpsqzPo5HOiq6C+toVkqrWMJLKA9J7cIFPDVog0m9lqNblUfFa8H0hzg7NsV5GaTgQ4A
         5jBI/lIXeOUGWHVKqN95Y8V5NuPIznfs6f5wBqsu6+GDk2tYuPnXsBHJNOaqpE8YL9hS
         tuNt6ye+jTS2wLjdTDudRIQlCeKYaeA1rt8TrSn8xLY0Ts3RiaaKU5y9wgWJ9NQ/XyT5
         wAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ztkGsqUqkQcfbxlBdMnsFZA5zf9U5+9bkMDZbcQFZD8=;
        b=FlFZPXef6SZBoD79SbGSqfVVj56JPrn/gs5k8ZQgjofYOjvEKIEhmkZgWNdndoD+LW
         ReAIJHMri8BzRDGfn/mfzqDHUrplwg0r4Z0CVqo+ISxJbOYXAh9XXwaaPcaAZ1ghjdcr
         G/NelrEfHLIM7RrRG+T9aaJzeQbWIOLQi4f5lo6yJ4mMJ11TutXRnvVt0z2qiHsZsj2X
         aytzbl/jPX9qP1uBFmc515ryZXZ5aoiuZUApZ10ctupmqGbDqEIe8yVQLNVmJoWMbb8J
         lmwje03jVATlHrpm5pUUl5pO2OnmU9k7fWzDC7RPDyaKzMjg6H6LUl0SzoL7f+DeIVKQ
         3ImQ==
X-Gm-Message-State: AOAM531Ek+pD4F3PjOyG3Tv0akBYp2l/ldl6qBuraJ+1TUJ5d4+1XehL
        hmHMJwusH1/phBvNEzM5weZqyMFHJut+
X-Google-Smtp-Source: ABdhPJzcVkgi3JMg9FekP/jbB0HbpE3UWWhA+GGvHutupthetmKemwuv8RCt3TmZZl6hj5AyHVL2xNuWi5Ck
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:7694:0:b0:624:a2d9:c8f0 with SMTP id
 r142-20020a257694000000b00624a2d9c8f0mr10070639ybc.523.1645593879400; Tue, 22
 Feb 2022 21:24:39 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:00 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-25-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 24/47] mm: asi: Support for local non-sensitive slab caches
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

A new flag SLAB_LOCAL_NONSENSITIVE is added to designate that a slab
cache can be used for local non-sensitive allocations. For such caches,
a per-process child cache will be created when a process tries to
make an allocation from that cache for the first time, similar to the
per-memcg child caches that used to exist before the object based memcg
charging mechanism. (A lot of the infrastructure for handling these
child caches is derived from the original per-memcg cache code).

If a cache only has SLAB_LOCAL_NONSENSITIVE, then all allocations from
that cache will automatically be considered locally non-sensitive. But
if a cache has both SLAB_LOCAL_NONSENSITIVE and
SLAB_GLOBAL_NONSENSITIVE, then each allocation must specify one of
__GFP_LOCAL_NONSENSITIVE or __GFP_GLOBAL_NONSENSITIVE.

Note that the first locally non-sensitive allocation that a process
makes from a given slab cache must occur from a sleepable context. If
that is not the case, then a new kmem_cache_precreate_local* API must
be called from a sleepable context before the first allocation.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/mm/asi.c        |   5 +
 include/linux/mm_types.h |   4 +
 include/linux/sched/mm.h |  12 ++
 include/linux/slab.h     |  38 +++-
 include/linux/slab_def.h |   4 +
 kernel/fork.c            |   3 +-
 mm/slab.c                |  41 ++++-
 mm/slab.h                | 151 +++++++++++++++-
 mm/slab_common.c         | 363 ++++++++++++++++++++++++++++++++++++++-
 9 files changed, 602 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index a3d96be76fa9..6b9a0f5ab391 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -4,6 +4,7 @@
 #include <linux/memblock.h>
 #include <linux/memcontrol.h>
 #include <linux/moduleparam.h>
+#include <linux/slab.h>
 
 #include <asm/asi.h>
 #include <asm/pgalloc.h>
@@ -455,6 +456,8 @@ int asi_init_mm_state(struct mm_struct *mm)
 
 	memset(mm->asi, 0, sizeof(mm->asi));
 	mm->asi_enabled = false;
+	RCU_INIT_POINTER(mm->local_slab_caches, NULL);
+	mm->local_slab_caches_array_size = 0;
 
 	/*
 	 * TODO: In addition to a cgroup flag, we may also want a per-process
@@ -482,6 +485,8 @@ void asi_free_mm_state(struct mm_struct *mm)
 	if (!boot_cpu_has(X86_FEATURE_ASI) || !mm->asi_enabled)
 		return;
 
+	free_local_slab_caches(mm);
+
 	asi_free_pgd_range(&mm->asi[0], pgd_index(ASI_LOCAL_MAP),
 			   pgd_index(ASI_LOCAL_MAP +
 				     PFN_PHYS(max_possible_pfn)) + 1);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index e6980ae31323..56511adc263e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -517,6 +517,10 @@ struct mm_struct {
 
 		struct asi asi[ASI_MAX_NUM];
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+		struct kmem_cache * __rcu *local_slab_caches;
+		uint local_slab_caches_array_size;
+#endif
 		/**
 		 * @mm_users: The number of users including userspace.
 		 *
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index aca874d33fe6..c9122d4436d4 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -37,9 +37,21 @@ static inline void mmgrab(struct mm_struct *mm)
 }
 
 extern void __mmdrop(struct mm_struct *mm);
+extern void mmdrop_async(struct mm_struct *mm);
 
 static inline void mmdrop(struct mm_struct *mm)
 {
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/*
+	 * We really only need to do this if we are in an atomic context.
+	 * Unfortunately, there doesn't seem to be a reliable way to detect
+	 * atomic context across all kernel configs. So we just always do async.
+	 */
+	if (rcu_access_pointer(mm->local_slab_caches)) {
+		mmdrop_async(mm);
+		return;
+	}
+#endif
 	/*
 	 * The implicit full barrier implied by atomic_dec_and_test() is
 	 * required by the membarrier system call before returning to
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 7b8a3853d827..ef9c73c0d874 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -93,6 +93,8 @@
 /* Avoid kmemleak tracing */
 #define SLAB_NOLEAKTRACE	((slab_flags_t __force)0x00800000U)
 
+/* 0x01000000U is used below for SLAB_LOCAL_NONSENSITIVE */
+
 /* Fault injection mark */
 #ifdef CONFIG_FAILSLAB
 # define SLAB_FAILSLAB		((slab_flags_t __force)0x02000000U)
@@ -121,8 +123,10 @@
 #define SLAB_DEACTIVATED	((slab_flags_t __force)0x10000000U)
 
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+#define SLAB_LOCAL_NONSENSITIVE ((slab_flags_t __force)0x01000000U)
 #define SLAB_GLOBAL_NONSENSITIVE ((slab_flags_t __force)0x20000000U)
 #else
+#define SLAB_LOCAL_NONSENSITIVE 0
 #define SLAB_GLOBAL_NONSENSITIVE 0
 #endif
 
@@ -377,7 +381,8 @@ static __always_inline struct kmem_cache *get_kmalloc_cache(gfp_t flags,
 {
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 
-	if (static_asi_enabled() && (flags & __GFP_GLOBAL_NONSENSITIVE))
+	if (static_asi_enabled() &&
+	    (flags & (__GFP_GLOBAL_NONSENSITIVE | __GFP_LOCAL_NONSENSITIVE)))
 		return nonsensitive_kmalloc_caches[kmalloc_type(flags)][index];
 #endif
 	return kmalloc_caches[kmalloc_type(flags)][index];
@@ -800,4 +805,35 @@ int slab_dead_cpu(unsigned int cpu);
 #define slab_dead_cpu		NULL
 #endif
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+struct kmem_cache *get_local_kmem_cache(struct kmem_cache *s,
+					struct mm_struct *mm, gfp_t flags);
+void free_local_slab_caches(struct mm_struct *mm);
+int kmem_cache_precreate_local(struct kmem_cache *s);
+int kmem_cache_precreate_local_kmalloc(size_t size, gfp_t flags);
+
+#else
+
+static inline
+struct kmem_cache *get_local_kmem_cache(struct kmem_cache *s,
+					struct mm_struct *mm, gfp_t flags)
+{
+	return NULL;
+}
+
+static inline void free_local_slab_caches(struct mm_struct *mm) { }
+
+static inline int kmem_cache_precreate_local(struct kmem_cache *s)
+{
+	return 0;
+}
+
+static inline int kmem_cache_precreate_local_kmalloc(size_t size, gfp_t flags)
+{
+	return 0;
+}
+
+#endif
+
 #endif	/* _LINUX_SLAB_H */
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 3aa5e1e73ab6..53cbc1f40031 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -81,6 +81,10 @@ struct kmem_cache {
 	unsigned int *random_seq;
 #endif
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	struct kmem_local_cache_info local_cache_info;
+#endif
+
 	unsigned int useroffset;	/* Usercopy region offset */
 	unsigned int usersize;		/* Usercopy region size */
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 68b3aeab55ac..d7f55de00947 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -714,13 +714,14 @@ static void mmdrop_async_fn(struct work_struct *work)
 	__mmdrop(mm);
 }
 
-static void mmdrop_async(struct mm_struct *mm)
+void mmdrop_async(struct mm_struct *mm)
 {
 	if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
 		INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
 		schedule_work(&mm->async_put_work);
 	}
 }
+EXPORT_SYMBOL(mmdrop_async);
 
 static inline void free_signal_struct(struct signal_struct *sig)
 {
diff --git a/mm/slab.c b/mm/slab.c
index 5a928d95d67b..44cf6d127a4c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1403,6 +1403,8 @@ static void kmem_freepages(struct kmem_cache *cachep, struct page *page)
 	/* In union with page->mapping where page allocator expects NULL */
 	page->slab_cache = NULL;
 
+	restore_page_nonsensitive_metadata(page, cachep);
+
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += 1 << order;
 	unaccount_slab_page(page, order, cachep);
@@ -2061,11 +2063,9 @@ int __kmem_cache_create(struct kmem_cache *cachep, slab_flags_t flags)
 		cachep->allocflags |= GFP_DMA32;
 	if (flags & SLAB_RECLAIM_ACCOUNT)
 		cachep->allocflags |= __GFP_RECLAIMABLE;
-	if (flags & SLAB_GLOBAL_NONSENSITIVE)
-		cachep->allocflags |= __GFP_GLOBAL_NONSENSITIVE;
 	cachep->size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
-
+	set_nonsensitive_cache_params(cachep);
 #if DEBUG
 	/*
 	 * If we're going to use the generic kernel_map_pages()
@@ -3846,8 +3846,8 @@ static int setup_kmem_cache_nodes(struct kmem_cache *cachep, gfp_t gfp)
 }
 
 /* Always called with the slab_mutex held */
-static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
-			    int batchcount, int shared, gfp_t gfp)
+static int __do_tune_cpucache(struct kmem_cache *cachep, int limit,
+			      int batchcount, int shared, gfp_t gfp)
 {
 	struct array_cache __percpu *cpu_cache, *prev;
 	int cpu;
@@ -3892,6 +3892,29 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
 	return setup_kmem_cache_nodes(cachep, gfp);
 }
 
+static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
+			    int batchcount, int shared, gfp_t gfp)
+{
+	int ret;
+	struct kmem_cache *c;
+
+	ret = __do_tune_cpucache(cachep, limit, batchcount, shared, gfp);
+
+	if (slab_state < FULL)
+		return ret;
+
+	if ((ret < 0) || !is_root_cache(cachep))
+		return ret;
+
+	lockdep_assert_held(&slab_mutex);
+	for_each_child_cache(c, cachep) {
+		/* return value determined by the root cache only */
+		__do_tune_cpucache(c, limit, batchcount, shared, gfp);
+	}
+
+	return ret;
+}
+
 /* Called with slab_mutex held always */
 static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp)
 {
@@ -3904,6 +3927,14 @@ static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp)
 	if (err)
 		goto end;
 
+	if (!is_root_cache(cachep)) {
+		struct kmem_cache *root = get_root_cache(cachep);
+
+		limit = root->limit;
+		shared = root->shared;
+		batchcount = root->batchcount;
+	}
+
 	/*
 	 * The head array serves three purposes:
 	 * - create a LIFO ordering, i.e. return objects that are cache-warm
diff --git a/mm/slab.h b/mm/slab.h
index f190f4fc0286..b9e11038be27 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -5,6 +5,45 @@
  * Internal slab definitions
  */
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+struct kmem_local_cache_info {
+	/* Valid for child caches. NULL for the root cache itself. */
+	struct kmem_cache *root_cache;
+	union {
+		/* For root caches */
+		struct {
+			int cache_id;
+			struct list_head __root_caches_node;
+			struct list_head children;
+			/*
+			 * For SLAB_LOCAL_NONSENSITIVE root caches, this points
+			 * to the cache to be used for local non-sensitive
+			 * allocations from processes without ASI enabled.
+			 *
+			 * For root caches with only SLAB_LOCAL_NONSENSITIVE,
+			 * the root cache itself is used as the sensitive cache.
+			 *
+			 * For root caches with both SLAB_LOCAL_NONSENSITIVE and
+			 * SLAB_GLOBAL_NONSENSITIVE, the sensitive cache will be
+			 * a child cache allocated on-demand.
+			 *
+			 * For non-sensiitve kmalloc caches, the sensitive cache
+			 * will just be the corresponding regular kmalloc cache.
+			 */
+			struct kmem_cache *sensitive_cache;
+		};
+
+		/* For child (process-local) caches */
+		struct {
+			struct mm_struct *mm;
+			struct list_head children_node;
+		};
+	};
+};
+
+#endif
+
 #ifdef CONFIG_SLOB
 /*
  * Common fields provided in kmem_cache by all slab allocators
@@ -128,8 +167,7 @@ static inline slab_flags_t kmem_cache_flags(unsigned int object_size,
 }
 #endif
 
-/* This will also include SLAB_LOCAL_NONSENSITIVE in a later patch. */
-#define SLAB_NONSENSITIVE SLAB_GLOBAL_NONSENSITIVE
+#define SLAB_NONSENSITIVE (SLAB_GLOBAL_NONSENSITIVE | SLAB_LOCAL_NONSENSITIVE)
 
 /* Legal flag mask for kmem_cache_create(), for various configurations */
 #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
@@ -251,6 +289,99 @@ static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t fla
 	return false;
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+/* List of all root caches. */
+extern struct list_head		slab_root_caches;
+#define root_caches_node	local_cache_info.__root_caches_node
+
+/*
+ * Iterate over all child caches of the given root cache. The caller must hold
+ * slab_mutex.
+ */
+#define for_each_child_cache(iter, root) \
+	list_for_each_entry(iter, &(root)->local_cache_info.children, \
+			    local_cache_info.children_node)
+
+static inline bool is_root_cache(struct kmem_cache *s)
+{
+	return !s->local_cache_info.root_cache;
+}
+
+static inline bool slab_equal_or_root(struct kmem_cache *s,
+				      struct kmem_cache *p)
+{
+	return p == s || p == s->local_cache_info.root_cache;
+}
+
+/*
+ * We use suffixes to the name in child caches because we can't have caches
+ * created in the system with the same name. But when we print them
+ * locally, better refer to them with the base name
+ */
+static inline const char *cache_name(struct kmem_cache *s)
+{
+	if (!is_root_cache(s))
+		s = s->local_cache_info.root_cache;
+	return s->name;
+}
+
+static inline struct kmem_cache *get_root_cache(struct kmem_cache *s)
+{
+	if (is_root_cache(s))
+		return s;
+	return s->local_cache_info.root_cache;
+}
+
+static inline
+void restore_page_nonsensitive_metadata(struct page *page,
+					struct kmem_cache *cachep)
+{
+	if (PageLocalNonSensitive(page)) {
+		VM_BUG_ON(is_root_cache(cachep));
+		page->asi_mm = cachep->local_cache_info.mm;
+	}
+}
+
+void set_nonsensitive_cache_params(struct kmem_cache *s);
+
+#else /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
+#define slab_root_caches	slab_caches
+#define root_caches_node	list
+
+#define for_each_child_cache(iter, root) \
+	for ((void)(iter), (void)(root); 0; )
+
+static inline bool is_root_cache(struct kmem_cache *s)
+{
+	return true;
+}
+
+static inline bool slab_equal_or_root(struct kmem_cache *s,
+				      struct kmem_cache *p)
+{
+	return s == p;
+}
+
+static inline const char *cache_name(struct kmem_cache *s)
+{
+	return s->name;
+}
+
+static inline struct kmem_cache *get_root_cache(struct kmem_cache *s)
+{
+	return s;
+}
+
+static inline void restore_page_nonsensitive_metadata(struct page *page,
+						      struct kmem_cache *cachep)
+{ }
+
+static inline void set_nonsensitive_cache_params(struct kmem_cache *s) { }
+
+#endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
 #ifdef CONFIG_MEMCG_KMEM
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 				 gfp_t gfp, bool new_page);
@@ -449,11 +580,12 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 	struct kmem_cache *cachep;
 
 	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
+	    !(s->flags & SLAB_LOCAL_NONSENSITIVE) &&
 	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
 		return s;
 
 	cachep = virt_to_cache(x);
-	if (WARN(cachep && cachep != s,
+	if (WARN(cachep && !slab_equal_or_root(cachep, s),
 		  "%s: Wrong slab cache. %s but object is from %s\n",
 		  __func__, s->name, cachep->name))
 		print_tracking(cachep, x);
@@ -501,11 +633,24 @@ static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
 	if (static_asi_enabled()) {
 		VM_BUG_ON(!(s->flags & SLAB_GLOBAL_NONSENSITIVE) &&
 			  (flags & __GFP_GLOBAL_NONSENSITIVE));
+		VM_BUG_ON(!(s->flags & SLAB_LOCAL_NONSENSITIVE) &&
+			  (flags & __GFP_LOCAL_NONSENSITIVE));
+		VM_BUG_ON((s->flags & SLAB_NONSENSITIVE) == SLAB_NONSENSITIVE &&
+			   !(flags & (__GFP_LOCAL_NONSENSITIVE |
+				      __GFP_GLOBAL_NONSENSITIVE)));
 	}
 
 	if (should_failslab(s, flags))
 		return NULL;
 
+	if (static_asi_enabled() &&
+	    (!(flags & __GFP_GLOBAL_NONSENSITIVE) &&
+	      (s->flags & SLAB_LOCAL_NONSENSITIVE))) {
+		s = get_local_kmem_cache(s, current->mm, flags);
+		if (!s)
+			return NULL;
+	}
+
 	if (!memcg_slab_pre_alloc_hook(s, objcgp, size, flags))
 		return NULL;
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 72dee2494bf8..b486b72d6344 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -42,6 +42,13 @@ static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work);
 static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
 		    slab_caches_to_rcu_destroy_workfn);
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+static DEFINE_IDA(nonsensitive_cache_ids);
+static uint max_num_local_slab_caches = 32;
+
+#endif
+
 /*
  * Set of flags that will prevent slab merging
  */
@@ -131,6 +138,69 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t nr,
 	return i;
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+LIST_HEAD(slab_root_caches);
+
+static void init_local_cache_info(struct kmem_cache *s, struct kmem_cache *root)
+{
+	if (root) {
+		s->local_cache_info.root_cache = root;
+		list_add(&s->local_cache_info.children_node,
+			 &root->local_cache_info.children);
+	} else {
+		s->local_cache_info.cache_id = -1;
+		INIT_LIST_HEAD(&s->local_cache_info.children);
+		list_add(&s->root_caches_node, &slab_root_caches);
+	}
+}
+
+static void cleanup_local_cache_info(struct kmem_cache *s)
+{
+	if (is_root_cache(s)) {
+		VM_BUG_ON(!list_empty(&s->local_cache_info.children));
+
+		list_del(&s->root_caches_node);
+		if (s->local_cache_info.cache_id >= 0)
+			ida_free(&nonsensitive_cache_ids,
+				 s->local_cache_info.cache_id);
+	} else {
+		struct mm_struct *mm = s->local_cache_info.mm;
+		struct kmem_cache *root_cache = s->local_cache_info.root_cache;
+		int id = root_cache->local_cache_info.cache_id;
+
+		list_del(&s->local_cache_info.children_node);
+		if (mm) {
+			struct kmem_cache **local_caches =
+				rcu_dereference_protected(mm->local_slab_caches,
+						lockdep_is_held(&slab_mutex));
+			local_caches[id] = NULL;
+		}
+	}
+}
+
+void set_nonsensitive_cache_params(struct kmem_cache *s)
+{
+	if (s->flags & SLAB_GLOBAL_NONSENSITIVE) {
+		s->allocflags |= __GFP_GLOBAL_NONSENSITIVE;
+		VM_BUG_ON(!is_root_cache(s));
+	} else if (s->flags & SLAB_LOCAL_NONSENSITIVE) {
+		if (is_root_cache(s))
+			s->local_cache_info.sensitive_cache = s;
+		else
+			s->allocflags |= __GFP_LOCAL_NONSENSITIVE;
+	}
+}
+
+#else
+
+static inline
+void init_local_cache_info(struct kmem_cache *s, struct kmem_cache *root) { }
+
+static inline void cleanup_local_cache_info(struct kmem_cache *s) { }
+
+#endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
 /*
  * Figure out what the alignment of the objects will be given a set of
  * flags, a user specified alignment and the size of the objects.
@@ -168,6 +238,9 @@ int slab_unmergeable(struct kmem_cache *s)
 	if (slab_nomerge || (s->flags & SLAB_NEVER_MERGE))
 		return 1;
 
+	if (!is_root_cache(s))
+		return 1;
+
 	if (s->ctor)
 		return 1;
 
@@ -202,7 +275,7 @@ struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
 	if (flags & SLAB_NEVER_MERGE)
 		return NULL;
 
-	list_for_each_entry_reverse(s, &slab_caches, list) {
+	list_for_each_entry_reverse(s, &slab_root_caches, root_caches_node) {
 		if (slab_unmergeable(s))
 			continue;
 
@@ -254,6 +327,8 @@ static struct kmem_cache *create_cache(const char *name,
 	s->useroffset = useroffset;
 	s->usersize = usersize;
 
+	init_local_cache_info(s, root_cache);
+
 	err = __kmem_cache_create(s, flags);
 	if (err)
 		goto out_free_cache;
@@ -266,6 +341,7 @@ static struct kmem_cache *create_cache(const char *name,
 	return s;
 
 out_free_cache:
+	cleanup_local_cache_info(s);
 	kmem_cache_free(kmem_cache, s);
 	goto out;
 }
@@ -459,6 +535,7 @@ static int shutdown_cache(struct kmem_cache *s)
 		return -EBUSY;
 
 	list_del(&s->list);
+	cleanup_local_cache_info(s);
 
 	if (s->flags & SLAB_TYPESAFE_BY_RCU) {
 #ifdef SLAB_SUPPORTS_SYSFS
@@ -480,6 +557,36 @@ static int shutdown_cache(struct kmem_cache *s)
 	return 0;
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+static int shutdown_child_caches(struct kmem_cache *s)
+{
+	struct kmem_cache *c, *c2;
+	int r;
+
+	VM_BUG_ON(!is_root_cache(s));
+
+	lockdep_assert_held(&slab_mutex);
+
+	list_for_each_entry_safe(c, c2, &s->local_cache_info.children,
+				 local_cache_info.children_node) {
+		r = shutdown_cache(c);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
+#else
+
+static inline int shutdown_child_caches(struct kmem_cache *s)
+{
+	return 0;
+}
+
+#endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
 void slab_kmem_cache_release(struct kmem_cache *s)
 {
 	__kmem_cache_release(s);
@@ -501,7 +608,10 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	if (s->refcount)
 		goto out_unlock;
 
-	err = shutdown_cache(s);
+	err = shutdown_child_caches(s);
+	if (!err)
+		err = shutdown_cache(s);
+
 	if (err) {
 		pr_err("%s %s: Slab cache still has objects\n",
 		       __func__, s->name);
@@ -651,6 +761,8 @@ void __init create_boot_cache(struct kmem_cache *s, const char *name,
 	s->useroffset = useroffset;
 	s->usersize = usersize;
 
+	init_local_cache_info(s, NULL);
+
 	err = __kmem_cache_create(s, flags);
 
 	if (err)
@@ -897,6 +1009,13 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 	 */
 	if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_NORMAL))
 		caches[type][idx]->refcount = -1;
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+	if (flags & SLAB_NONSENSITIVE)
+		caches[type][idx]->local_cache_info.sensitive_cache =
+						kmalloc_caches[type][idx];
+#endif
 }
 
 /*
@@ -1086,12 +1205,12 @@ static void print_slabinfo_header(struct seq_file *m)
 void *slab_start(struct seq_file *m, loff_t *pos)
 {
 	mutex_lock(&slab_mutex);
-	return seq_list_start(&slab_caches, *pos);
+	return seq_list_start(&slab_root_caches, *pos);
 }
 
 void *slab_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	return seq_list_next(p, &slab_caches, pos);
+	return seq_list_next(p, &slab_root_caches, pos);
 }
 
 void slab_stop(struct seq_file *m, void *p)
@@ -1099,6 +1218,24 @@ void slab_stop(struct seq_file *m, void *p)
 	mutex_unlock(&slab_mutex);
 }
 
+static void
+accumulate_children_slabinfo(struct kmem_cache *s, struct slabinfo *info)
+{
+	struct kmem_cache *c;
+	struct slabinfo sinfo;
+
+	for_each_child_cache(c, s) {
+		memset(&sinfo, 0, sizeof(sinfo));
+		get_slabinfo(c, &sinfo);
+
+		info->active_slabs += sinfo.active_slabs;
+		info->num_slabs += sinfo.num_slabs;
+		info->shared_avail += sinfo.shared_avail;
+		info->active_objs += sinfo.active_objs;
+		info->num_objs += sinfo.num_objs;
+	}
+}
+
 static void cache_show(struct kmem_cache *s, struct seq_file *m)
 {
 	struct slabinfo sinfo;
@@ -1106,8 +1243,10 @@ static void cache_show(struct kmem_cache *s, struct seq_file *m)
 	memset(&sinfo, 0, sizeof(sinfo));
 	get_slabinfo(s, &sinfo);
 
+	accumulate_children_slabinfo(s, &sinfo);
+
 	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d",
-		   s->name, sinfo.active_objs, sinfo.num_objs, s->size,
+		   cache_name(s), sinfo.active_objs, sinfo.num_objs, s->size,
 		   sinfo.objects_per_slab, (1 << sinfo.cache_order));
 
 	seq_printf(m, " : tunables %4u %4u %4u",
@@ -1120,9 +1259,9 @@ static void cache_show(struct kmem_cache *s, struct seq_file *m)
 
 static int slab_show(struct seq_file *m, void *p)
 {
-	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
+	struct kmem_cache *s = list_entry(p, struct kmem_cache, root_caches_node);
 
-	if (p == slab_caches.next)
+	if (p == slab_root_caches.next)
 		print_slabinfo_header(m);
 	cache_show(s, m);
 	return 0;
@@ -1148,14 +1287,14 @@ void dump_unreclaimable_slab(void)
 	pr_info("Unreclaimable slab info:\n");
 	pr_info("Name                      Used          Total\n");
 
-	list_for_each_entry(s, &slab_caches, list) {
+	list_for_each_entry(s, &slab_root_caches, root_caches_node) {
 		if (s->flags & SLAB_RECLAIM_ACCOUNT)
 			continue;
 
 		get_slabinfo(s, &sinfo);
 
 		if (sinfo.num_objs > 0)
-			pr_info("%-17s %10luKB %10luKB\n", s->name,
+			pr_info("%-17s %10luKB %10luKB\n", cache_name(s),
 				(sinfo.active_objs * s->size) / 1024,
 				(sinfo.num_objs * s->size) / 1024);
 	}
@@ -1361,3 +1500,209 @@ int should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 	return 0;
 }
 ALLOW_ERROR_INJECTION(should_failslab, ERRNO);
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+static int resize_local_slab_caches_array(struct mm_struct *mm, gfp_t flags)
+{
+	struct kmem_cache **new_array;
+	struct kmem_cache **old_array =
+		rcu_dereference_protected(mm->local_slab_caches,
+					  lockdep_is_held(&slab_mutex));
+
+	new_array = kcalloc(max_num_local_slab_caches,
+			    sizeof(struct kmem_cache *), flags);
+	if (!new_array)
+		return -ENOMEM;
+
+	if (old_array)
+		memcpy(new_array, old_array, mm->local_slab_caches_array_size *
+					     sizeof(struct kmem_cache *));
+
+	rcu_assign_pointer(mm->local_slab_caches, new_array);
+	smp_store_release(&mm->local_slab_caches_array_size,
+			  max_num_local_slab_caches);
+
+	if (old_array) {
+		synchronize_rcu();
+		kfree(old_array);
+	}
+
+	return 0;
+}
+
+static int get_or_alloc_cache_id(struct kmem_cache *root_cache, gfp_t flags)
+{
+	int id = root_cache->local_cache_info.cache_id;
+
+	if (id >= 0)
+		return id;
+
+	id = ida_alloc_max(&nonsensitive_cache_ids,
+			   max_num_local_slab_caches - 1, flags);
+	if (id == -ENOSPC) {
+		max_num_local_slab_caches *= 2;
+		id = ida_alloc_max(&nonsensitive_cache_ids,
+				   max_num_local_slab_caches - 1, flags);
+	}
+
+	if (id >= 0)
+		root_cache->local_cache_info.cache_id = id;
+
+	return id;
+}
+
+static struct kmem_cache *create_local_kmem_cache(struct kmem_cache *root_cache,
+						  struct mm_struct *mm,
+						  gfp_t flags)
+{
+	char *name;
+	struct kmem_cache *s = NULL;
+	slab_flags_t slab_flags = root_cache->flags & CACHE_CREATE_MASK;
+	struct kmem_cache **cache_ptr;
+
+	flags &= GFP_RECLAIM_MASK;
+
+	mutex_lock(&slab_mutex);
+
+	if (mm_asi_enabled(mm)) {
+		struct kmem_cache **caches;
+		int id = get_or_alloc_cache_id(root_cache, flags);
+
+		if (id < 0)
+			goto out;
+
+		flags |= __GFP_ACCOUNT;
+
+		if (mm->local_slab_caches_array_size <= id &&
+		    resize_local_slab_caches_array(mm, flags) < 0)
+			goto out;
+
+		caches = rcu_dereference_protected(mm->local_slab_caches,
+						   lockdep_is_held(&slab_mutex));
+		cache_ptr = &caches[id];
+		if (*cache_ptr) {
+			s = *cache_ptr;
+			goto out;
+		}
+
+		slab_flags &= ~SLAB_GLOBAL_NONSENSITIVE;
+		name = kasprintf(flags, "%s(%d:%s)", root_cache->name,
+				 task_pid_nr(mm->owner), mm->owner->comm);
+		if (!name)
+			goto out;
+
+	} else {
+		cache_ptr = &root_cache->local_cache_info.sensitive_cache;
+		if (*cache_ptr) {
+			s = *cache_ptr;
+			goto out;
+		}
+
+		slab_flags &= ~SLAB_NONSENSITIVE;
+		name = kasprintf(flags, "%s(sensitive)", root_cache->name);
+		if (!name)
+			goto out;
+	}
+
+	s = create_cache(name,
+			 root_cache->object_size,
+			 root_cache->align,
+			 slab_flags,
+			 root_cache->useroffset, root_cache->usersize,
+			 root_cache->ctor, root_cache);
+	if (IS_ERR(s)) {
+		pr_info("Unable to create child kmem cache %s. Err %ld",
+			name, PTR_ERR(s));
+		kfree(name);
+		s = NULL;
+		goto out;
+	}
+
+	if (mm_asi_enabled(mm))
+		s->local_cache_info.mm = mm;
+
+	smp_store_release(cache_ptr, s);
+out:
+	mutex_unlock(&slab_mutex);
+
+	return s;
+}
+
+struct kmem_cache *get_local_kmem_cache(struct kmem_cache *s,
+					struct mm_struct *mm, gfp_t flags)
+{
+	struct kmem_cache *local_cache = NULL;
+
+	if (!(s->flags & SLAB_LOCAL_NONSENSITIVE) || !is_root_cache(s))
+		return s;
+
+	if (mm_asi_enabled(mm)) {
+		struct kmem_cache **caches;
+		int id = READ_ONCE(s->local_cache_info.cache_id);
+		uint array_size = smp_load_acquire(
+					&mm->local_slab_caches_array_size);
+
+		if (id >= 0 && array_size > id) {
+			rcu_read_lock();
+			caches = rcu_dereference(mm->local_slab_caches);
+			local_cache = smp_load_acquire(&caches[id]);
+			rcu_read_unlock();
+		}
+	} else {
+		local_cache =
+			smp_load_acquire(&s->local_cache_info.sensitive_cache);
+	}
+
+	if (!local_cache)
+		local_cache = create_local_kmem_cache(s, mm, flags);
+
+	return local_cache;
+}
+
+void free_local_slab_caches(struct mm_struct *mm)
+{
+	uint i;
+	struct kmem_cache **caches =
+		rcu_dereference_protected(mm->local_slab_caches,
+					  atomic_read(&mm->mm_count) == 0);
+
+	if (!caches)
+		return;
+
+	cpus_read_lock();
+	mutex_lock(&slab_mutex);
+
+	for (i = 0; i < mm->local_slab_caches_array_size; i++)
+		if (caches[i])
+			WARN_ON(shutdown_cache(caches[i]));
+
+	mutex_unlock(&slab_mutex);
+	cpus_read_unlock();
+
+	kfree(caches);
+}
+
+int kmem_cache_precreate_local(struct kmem_cache *s)
+{
+	VM_BUG_ON(!is_root_cache(s));
+	VM_BUG_ON(!in_task());
+	might_sleep();
+
+	return get_local_kmem_cache(s, current->mm, GFP_KERNEL) ? 0 : -ENOMEM;
+}
+EXPORT_SYMBOL(kmem_cache_precreate_local);
+
+int kmem_cache_precreate_local_kmalloc(size_t size, gfp_t flags)
+{
+	struct kmem_cache *s = kmalloc_slab(size,
+					    flags | __GFP_LOCAL_NONSENSITIVE);
+
+	if (ZERO_OR_NULL_PTR(s))
+		return 0;
+
+	return kmem_cache_precreate_local(s);
+}
+EXPORT_SYMBOL(kmem_cache_precreate_local_kmalloc);
+
+#endif
-- 
2.35.1.473.g83b2b277ed-goog

