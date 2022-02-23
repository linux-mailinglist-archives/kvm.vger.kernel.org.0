Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43394C0BBA
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbiBWFZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbiBWFY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:59 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D86D6CA42
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b12-20020a056902030c00b0061d720e274aso26586376ybs.20
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h48HgrV9Ms87ueeFjUPVjN/Yw+KwlPL1CcnJb5APGwE=;
        b=Hmt0w/kiWsp/YP+equQ01AdLjZMh/o/2Z8oEGQ6Lq4Nt157PlHz1XpRl+A7GPQXL2i
         FRSX/mXn548mQM/TC1p/MGu32EFPYWhSLwU4OefqIbwBe+iA80Pue4vU6e/ZB7nsR4Y4
         523kigSioD12IuJ5T0licYK9j98yC1QXVRYs3anUzXJCRNXAH9qqii0hyNma152NX9Ps
         ggEjc8Pz3upnBint0xIR6P2QSeIhMzI8K84X5fX/AWfAvKn+5L2W9liNKxXaSWKaCFma
         +45lbJ2fC4qur3JJ5wHMSfnoIjceTnzqkA7atH2Cu3t0CWoRI/zCfcvLHfSjM3PIpuRT
         HILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h48HgrV9Ms87ueeFjUPVjN/Yw+KwlPL1CcnJb5APGwE=;
        b=0MVL3NRRie9rA60wOkE3otvnTZtauFn6dysMHOEC5w32LY0cFj8nCGQ7k35Y+Z2ON+
         91/eGS6KNjDrA+oa5550b4gyTiO6pAHscgSx+MYfRWQMVVQfACjQRc/JOTBViUsJ6tKF
         Gd2Z7NsO9chz+IoBomYSIF/az/rv6wPT2ItSIccMXfeWwsrMyMnGA6aCUF7W2Xcueas4
         mF+A+zYWWC2Bw3RBCgdqM2UX0eMhVTbzw9SdrJDuBSBCVVrYBpO3f5lJhbuy35cluSIf
         cWisW7ZFrF93nGRKgYlmB62W/gNR4v1/28GVteOpVTdzGmn5KCR9VL2yqmTmV++wjeL5
         hMXA==
X-Gm-Message-State: AOAM5331qLrCv6WZZelktrB2UNOYyskaFVqS0TT3XIgxYzRZ+vqq3ZGi
        vqXtE+GRoGDm2remWvqURcwv5CSEDQpW
X-Google-Smtp-Source: ABdhPJyfC5FSpMaAtl/McL2SxzvvGsqtTFjrUAQSrC01vyuUjm1vV+WNWVvhncOg+7K7oU2DAPMbItihfugH
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:1c47:0:b0:2d7:5822:1739 with SMTP id
 c68-20020a811c47000000b002d758221739mr11411035ywc.502.1645593852744; Tue, 22
 Feb 2022 21:24:12 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:48 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-13-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 12/47] mm: asi: Support for global non-sensitive slab caches
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

A new flag SLAB_GLOBAL_NONSENSITIVE is added, which would designate all
objects within that slab cache to be globally non-sensitive.

Another flag SLAB_NONSENSITIVE is also added, which is currently just an
alias for SLAB_GLOBAL_NONSENSITIVE, but will eventually be used to
designate slab caches which can allocate either global or local
non-sensitive objects.

In addition, new kmalloc caches have been added that can be used to
allocate non-sensitive objects.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 include/linux/slab.h | 32 +++++++++++++++----
 mm/slab.c            |  5 +++
 mm/slab.h            | 14 ++++++++-
 mm/slab_common.c     | 73 +++++++++++++++++++++++++++++++++-----------
 security/Kconfig     |  2 +-
 5 files changed, 101 insertions(+), 25 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 181045148b06..7b8a3853d827 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -120,6 +120,12 @@
 /* Slab deactivation flag */
 #define SLAB_DEACTIVATED	((slab_flags_t __force)0x10000000U)
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+#define SLAB_GLOBAL_NONSENSITIVE ((slab_flags_t __force)0x20000000U)
+#else
+#define SLAB_GLOBAL_NONSENSITIVE 0
+#endif
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
@@ -329,6 +335,11 @@ enum kmalloc_cache_type {
 extern struct kmem_cache *
 kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+extern struct kmem_cache *
+nonsensitive_kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
+#endif
+
 /*
  * Define gfp bits that should not be set for KMALLOC_NORMAL.
  */
@@ -361,6 +372,17 @@ static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags)
 		return KMALLOC_CGROUP;
 }
 
+static __always_inline struct kmem_cache *get_kmalloc_cache(gfp_t flags,
+							    uint index)
+{
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+	if (static_asi_enabled() && (flags & __GFP_GLOBAL_NONSENSITIVE))
+		return nonsensitive_kmalloc_caches[kmalloc_type(flags)][index];
+#endif
+	return kmalloc_caches[kmalloc_type(flags)][index];
+}
+
 /*
  * Figure out which kmalloc slab an allocation of a certain size
  * belongs to.
@@ -587,9 +609,8 @@ static __always_inline __alloc_size(1) void *kmalloc(size_t size, gfp_t flags)
 		if (!index)
 			return ZERO_SIZE_PTR;
 
-		return kmem_cache_alloc_trace(
-				kmalloc_caches[kmalloc_type(flags)][index],
-				flags, size);
+		return kmem_cache_alloc_trace(get_kmalloc_cache(flags, index),
+					      flags, size);
 #endif
 	}
 	return __kmalloc(size, flags);
@@ -605,9 +626,8 @@ static __always_inline __alloc_size(1) void *kmalloc_node(size_t size, gfp_t fla
 		if (!i)
 			return ZERO_SIZE_PTR;
 
-		return kmem_cache_alloc_node_trace(
-				kmalloc_caches[kmalloc_type(flags)][i],
-						flags, node, size);
+		return kmem_cache_alloc_node_trace(get_kmalloc_cache(flags, i),
+						   flags, node, size);
 	}
 #endif
 	return __kmalloc_node(size, flags, node);
diff --git a/mm/slab.c b/mm/slab.c
index ca4822f6b2b6..5a928d95d67b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1956,6 +1956,9 @@ int __kmem_cache_create(struct kmem_cache *cachep, slab_flags_t flags)
 		size = ALIGN(size, REDZONE_ALIGN);
 	}
 
+	if (!static_asi_enabled())
+		flags &= ~SLAB_NONSENSITIVE;
+
 	/* 3) caller mandated alignment */
 	if (ralign < cachep->align) {
 		ralign = cachep->align;
@@ -2058,6 +2061,8 @@ int __kmem_cache_create(struct kmem_cache *cachep, slab_flags_t flags)
 		cachep->allocflags |= GFP_DMA32;
 	if (flags & SLAB_RECLAIM_ACCOUNT)
 		cachep->allocflags |= __GFP_RECLAIMABLE;
+	if (flags & SLAB_GLOBAL_NONSENSITIVE)
+		cachep->allocflags |= __GFP_GLOBAL_NONSENSITIVE;
 	cachep->size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
 
diff --git a/mm/slab.h b/mm/slab.h
index 56ad7eea3ddf..f190f4fc0286 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -77,6 +77,10 @@ extern struct kmem_cache *kmem_cache;
 /* A table of kmalloc cache names and sizes */
 extern const struct kmalloc_info_struct {
 	const char *name[NR_KMALLOC_TYPES];
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	const char *nonsensitive_name[NR_KMALLOC_TYPES];
+#endif
+	slab_flags_t flags[NR_KMALLOC_TYPES];
 	unsigned int size;
 } kmalloc_info[];
 
@@ -124,11 +128,14 @@ static inline slab_flags_t kmem_cache_flags(unsigned int object_size,
 }
 #endif
 
+/* This will also include SLAB_LOCAL_NONSENSITIVE in a later patch. */
+#define SLAB_NONSENSITIVE SLAB_GLOBAL_NONSENSITIVE
 
 /* Legal flag mask for kmem_cache_create(), for various configurations */
 #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
-			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS )
+			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
+			 SLAB_NONSENSITIVE)
 
 #if defined(CONFIG_DEBUG_SLAB)
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
@@ -491,6 +498,11 @@ static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
 
 	might_alloc(flags);
 
+	if (static_asi_enabled()) {
+		VM_BUG_ON(!(s->flags & SLAB_GLOBAL_NONSENSITIVE) &&
+			  (flags & __GFP_GLOBAL_NONSENSITIVE));
+	}
+
 	if (should_failslab(s, flags))
 		return NULL;
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index e5d080a93009..72dee2494bf8 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -50,7 +50,7 @@ static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
 		SLAB_FAILSLAB | kasan_never_merge())
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
-			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
+			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_NONSENSITIVE)
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
@@ -681,6 +681,15 @@ kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1] __ro_after_init =
 { /* initialization for https://bugs.llvm.org/show_bug.cgi?id=42570 */ };
 EXPORT_SYMBOL(kmalloc_caches);
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+struct kmem_cache *
+nonsensitive_kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1] __ro_after_init =
+{ /* initialization for https://bugs.llvm.org/show_bug.cgi?id=42570 */ };
+EXPORT_SYMBOL(nonsensitive_kmalloc_caches);
+
+#endif
+
 /*
  * Conversion table for small slabs sizes / 8 to the index in the
  * kmalloc array. This is necessary for slabs < 192 since we have non power
@@ -738,25 +747,34 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
 		index = fls(size - 1);
 	}
 
-	return kmalloc_caches[kmalloc_type(flags)][index];
+	return get_kmalloc_cache(flags, index);
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+#define __KMALLOC_NAME(type, base_name, sz)			\
+			.name[type] = base_name "-" #sz,	\
+			.nonsensitive_name[type] = "ns-" base_name "-" #sz,
+#else
+#define __KMALLOC_NAME(type, base_name, sz)			\
+			.name[type] = base_name "-" #sz,
+#endif
+
 #ifdef CONFIG_ZONE_DMA
-#define KMALLOC_DMA_NAME(sz)	.name[KMALLOC_DMA] = "dma-kmalloc-" #sz,
+#define KMALLOC_DMA_NAME(sz)	__KMALLOC_NAME(KMALLOC_DMA, "dma-kmalloc", sz)
 #else
 #define KMALLOC_DMA_NAME(sz)
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
-#define KMALLOC_CGROUP_NAME(sz)	.name[KMALLOC_CGROUP] = "kmalloc-cg-" #sz,
+#define KMALLOC_CGROUP_NAME(sz)	__KMALLOC_NAME(KMALLOC_CGROUP, "kmalloc-cg", sz)
 #else
 #define KMALLOC_CGROUP_NAME(sz)
 #endif
 
 #define INIT_KMALLOC_INFO(__size, __short_size)			\
 {								\
-	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
-	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #__short_size,	\
+	__KMALLOC_NAME(KMALLOC_NORMAL, "kmalloc", __short_size)	\
+	__KMALLOC_NAME(KMALLOC_RECLAIM, "kmalloc-rcl", __short_size) \
 	KMALLOC_CGROUP_NAME(__short_size)			\
 	KMALLOC_DMA_NAME(__short_size)				\
 	.size = __size,						\
@@ -846,18 +864,30 @@ void __init setup_kmalloc_cache_index_table(void)
 static void __init
 new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 {
+	struct kmem_cache *(*caches)[KMALLOC_SHIFT_HIGH + 1] = kmalloc_caches;
+	const char *name = kmalloc_info[idx].name[type];
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+	if (flags & SLAB_NONSENSITIVE) {
+		caches = nonsensitive_kmalloc_caches;
+		name = kmalloc_info[idx].nonsensitive_name[type];
+	}
+#endif
+
 	if (type == KMALLOC_RECLAIM) {
 		flags |= SLAB_RECLAIM_ACCOUNT;
 	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
 		if (cgroup_memory_nokmem) {
-			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
+			caches[type][idx] = caches[KMALLOC_NORMAL][idx];
 			return;
 		}
 		flags |= SLAB_ACCOUNT;
+	} else if (IS_ENABLED(CONFIG_ZONE_DMA) && (type == KMALLOC_DMA)) {
+		flags |= SLAB_CACHE_DMA;
 	}
 
-	kmalloc_caches[type][idx] = create_kmalloc_cache(
-					kmalloc_info[idx].name[type],
+	caches[type][idx] = create_kmalloc_cache(name,
 					kmalloc_info[idx].size, flags, 0,
 					kmalloc_info[idx].size);
 
@@ -866,7 +896,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 	 * KMALLOC_NORMAL caches.
 	 */
 	if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_NORMAL))
-		kmalloc_caches[type][idx]->refcount = -1;
+		caches[type][idx]->refcount = -1;
 }
 
 /*
@@ -908,15 +938,24 @@ void __init create_kmalloc_caches(slab_flags_t flags)
 	for (i = 0; i <= KMALLOC_SHIFT_HIGH; i++) {
 		struct kmem_cache *s = kmalloc_caches[KMALLOC_NORMAL][i];
 
-		if (s) {
-			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
-				kmalloc_info[i].name[KMALLOC_DMA],
-				kmalloc_info[i].size,
-				SLAB_CACHE_DMA | flags, 0,
-				kmalloc_info[i].size);
-		}
+		if (s)
+			new_kmalloc_cache(i, KMALLOC_DMA, flags);
 	}
 #endif
+	/*
+	 * TODO: We may want to make slab allocations without exiting ASI.
+	 * In that case, the cache metadata itself would need to be
+	 * treated as non-sensitive and mapped as such, and we would need to
+	 * do the bootstrap much more carefully. We can do that if we find
+	 * that slab allocations while inside a restricted address space are
+	 * frequent enough to warrant the additional complexity.
+	 */
+	if (static_asi_enabled())
+		for (type = KMALLOC_NORMAL; type < NR_KMALLOC_TYPES; type++)
+			for (i = 0; i <= KMALLOC_SHIFT_HIGH; i++)
+				if (kmalloc_caches[type][i])
+					new_kmalloc_cache(i, type,
+						flags | SLAB_NONSENSITIVE);
 }
 #endif /* !CONFIG_SLOB */
 
diff --git a/security/Kconfig b/security/Kconfig
index 21b15ecaf2c1..0a3e49d6a331 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -68,7 +68,7 @@ config PAGE_TABLE_ISOLATION
 config ADDRESS_SPACE_ISOLATION
 	bool "Allow code to run with a reduced kernel address space"
 	default n
-	depends on X86_64 && !UML
+	depends on X86_64 && !UML && SLAB
 	depends on !PARAVIRT
 	help
 	   This feature provides the ability to run some kernel code
-- 
2.35.1.473.g83b2b277ed-goog

