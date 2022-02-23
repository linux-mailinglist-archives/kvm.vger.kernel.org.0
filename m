Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A234C0C09
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbiBWF1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238371AbiBWF0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:39 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BEB6E576
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:07 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d07ae11467so163389687b3.12
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Wjvyoa2FJqkBAKFP17bCuJdeRktO4ffR+raoUv+wC04=;
        b=IuC+day3sN1PmeI3q0+DeqehWlmR6vmu4lqtMz2zTkSs/sLWgZjKSMjbDxjarGYK3w
         hUZZQKn00coi8l0R0gTq63im2iXgDqy8kS7ZoG/GfBb24X2etuAVLlEbTVnHHQVOpffA
         7kJw+tCwaYdWlS1krugMDGNM7sJ3OTIDt7ytbn7/z+HK1a8ew2aSceVwKePXDv9f7WZz
         m0Q/zwZ6fjCsUI3xB5Psf0pqjVkAy2TXCzeSjVt+m4RXqs776AhpaQ80FhrK9Kk/bCDo
         Sz1kG0HnL9LnI2+RNBaFmgg3coHxCTDPj+PGc/Rc5iXJGNpAzaSB6KONLlzImp2qWQaO
         osLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wjvyoa2FJqkBAKFP17bCuJdeRktO4ffR+raoUv+wC04=;
        b=ZMWAb3gDJDGAIxAg12N2DkBPm8sCQdUMQWT23E/UKkzu83AuNIfNcynW3X42GLuMsh
         14hb/MeaALY6cxQ2D2BzIW6l2RVZhCT6qbwsmIB9zyyVgdwqP3M8xyHRfvcnqGFbb60z
         hmgwzqnYeIRGFEz/q1xo71FedgawKmdNPI5OD9jXmHRurKfKDX6FQQbGJZ/pAsHHneGm
         Vb73maWwgUjj98GEZ2GE6gylmc1wTnAbK4qxay3bnIvohB1HdYDKHqbZ2VM5mKojKDpf
         UPw09OGQJf+eXOd5IBT64nVFRaekALWqqsRkpU/XU3ETVsDcGpRr8TyQ4tlRQBbigg61
         8+JQ==
X-Gm-Message-State: AOAM533advuWf8e0mJVeO1Mu14t76QMnwuxPWYwjJflAwL65wTi2WXlf
        /crNmh+93Ws75RJ3UY+9TK4OrR4yaNSO
X-Google-Smtp-Source: ABdhPJyc5lR4Rjfv+Xgr2/PVDwYzQX3XdlHXcXxiuT59EhJPeYW9yxuIt2bJoEcFUWJJKvKStyvmN4Ecr+Gy
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a0d:e4c2:0:b0:2d4:da21:cc07 with SMTP id
 n185-20020a0de4c2000000b002d4da21cc07mr27147139ywe.16.1645593894760; Tue, 22
 Feb 2022 21:24:54 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:07 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-32-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 31/47] mm: asi: Support for non-sensitive SLUB caches
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

This adds support for allocating global and local non-sensitive objects
using the SLUB allocator. Similar to SLAB, per-process child caches are
created for locally non-sensitive allocations. This mechanism is based
on a modified form of the earlier implementation of per-memcg caches.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 include/linux/slub_def.h |   6 ++
 mm/slab.h                |   5 ++
 mm/slab_common.c         |  33 +++++++--
 mm/slub.c                | 140 ++++++++++++++++++++++++++++++++++++++-
 security/Kconfig         |   3 +-
 5 files changed, 179 insertions(+), 8 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 0fa751b946fa..6e185b61582c 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -137,6 +137,12 @@ struct kmem_cache {
 	struct kasan_cache kasan_info;
 #endif
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	struct kmem_local_cache_info local_cache_info;
+	/* For propagation, maximum size of a stored attr */
+	unsigned int max_attr_size;
+#endif
+
 	unsigned int useroffset;	/* Usercopy region offset */
 	unsigned int usersize;		/* Usercopy region size */
 
diff --git a/mm/slab.h b/mm/slab.h
index b9e11038be27..8799bcdd2fff 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -216,6 +216,7 @@ int __kmem_cache_shutdown(struct kmem_cache *);
 void __kmem_cache_release(struct kmem_cache *);
 int __kmem_cache_shrink(struct kmem_cache *);
 void slab_kmem_cache_release(struct kmem_cache *);
+void kmem_cache_shrink_all(struct kmem_cache *s);
 
 struct seq_file;
 struct file;
@@ -344,6 +345,7 @@ void restore_page_nonsensitive_metadata(struct page *page,
 }
 
 void set_nonsensitive_cache_params(struct kmem_cache *s);
+void init_local_cache_info(struct kmem_cache *s, struct kmem_cache *root);
 
 #else /* CONFIG_ADDRESS_SPACE_ISOLATION */
 
@@ -380,6 +382,9 @@ static inline void restore_page_nonsensitive_metadata(struct page *page,
 
 static inline void set_nonsensitive_cache_params(struct kmem_cache *s) { }
 
+static inline
+void init_local_cache_info(struct kmem_cache *s, struct kmem_cache *root) { }
+
 #endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
 
 #ifdef CONFIG_MEMCG_KMEM
diff --git a/mm/slab_common.c b/mm/slab_common.c
index b486b72d6344..efa61b97902a 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -142,7 +142,7 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t nr,
 
 LIST_HEAD(slab_root_caches);
 
-static void init_local_cache_info(struct kmem_cache *s, struct kmem_cache *root)
+void init_local_cache_info(struct kmem_cache *s, struct kmem_cache *root)
 {
 	if (root) {
 		s->local_cache_info.root_cache = root;
@@ -194,9 +194,6 @@ void set_nonsensitive_cache_params(struct kmem_cache *s)
 
 #else
 
-static inline
-void init_local_cache_info(struct kmem_cache *s, struct kmem_cache *root) { }
-
 static inline void cleanup_local_cache_info(struct kmem_cache *s) { }
 
 #endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
@@ -644,6 +641,34 @@ int kmem_cache_shrink(struct kmem_cache *cachep)
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
+/**
+ * kmem_cache_shrink_all - shrink a cache and all child caches for root cache
+ * @s: The cache pointer
+ */
+void kmem_cache_shrink_all(struct kmem_cache *s)
+{
+	struct kmem_cache *c;
+
+	if (!static_asi_enabled() || !is_root_cache(s)) {
+		kmem_cache_shrink(s);
+		return;
+	}
+
+	kasan_cache_shrink(s);
+	__kmem_cache_shrink(s);
+
+	/*
+	 * We have to take the slab_mutex to protect from the child cache list
+	 * modification.
+	 */
+	mutex_lock(&slab_mutex);
+	for_each_child_cache(c, s) {
+		kasan_cache_shrink(c);
+		__kmem_cache_shrink(c);
+	}
+	mutex_unlock(&slab_mutex);
+}
+
 bool slab_is_available(void)
 {
 	return slab_state >= UP;
diff --git a/mm/slub.c b/mm/slub.c
index abe7db581d68..df0191f8b0e2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -289,6 +289,21 @@ static void debugfs_slab_add(struct kmem_cache *);
 static inline void debugfs_slab_add(struct kmem_cache *s) { }
 #endif
 
+#if defined(CONFIG_SYSFS) && defined(CONFIG_ADDRESS_SPACE_ISOLATION)
+static void propagate_slab_attrs_from_parent(struct kmem_cache *s);
+static void propagate_slab_attr_to_children(struct kmem_cache *s,
+					    struct attribute *attr,
+					    const char *buf, size_t len);
+#else
+static inline void propagate_slab_attrs_from_parent(struct kmem_cache *s) { }
+
+static inline
+void propagate_slab_attr_to_children(struct kmem_cache *s,
+				     struct attribute *attr,
+				     const char *buf, size_t len)
+{ }
+#endif
+
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
 {
 #ifdef CONFIG_SLUB_STATS
@@ -2015,6 +2030,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
 	unaccount_slab_page(page, order, s);
+	restore_page_nonsensitive_metadata(page, s);
 	__free_pages(page, order);
 }
 
@@ -4204,6 +4220,8 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 		}
 	}
 
+	set_nonsensitive_cache_params(s);
+
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (system_has_cmpxchg_double() && (s->flags & SLAB_NO_CMPXCHG) == 0)
@@ -4797,6 +4815,10 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
 #endif
 	}
 	list_add(&s->list, &slab_caches);
+	init_local_cache_info(s, NULL);
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	list_del(&static_cache->root_caches_node);
+#endif
 	return s;
 }
 
@@ -4863,7 +4885,7 @@ struct kmem_cache *
 __kmem_cache_alias(const char *name, unsigned int size, unsigned int align,
 		   slab_flags_t flags, void (*ctor)(void *))
 {
-	struct kmem_cache *s;
+	struct kmem_cache *s, *c;
 
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
@@ -4876,6 +4898,11 @@ __kmem_cache_alias(const char *name, unsigned int size, unsigned int align,
 		s->object_size = max(s->object_size, size);
 		s->inuse = max(s->inuse, ALIGN(size, sizeof(void *)));
 
+		for_each_child_cache(c, s) {
+			c->object_size = s->object_size;
+			c->inuse = max(c->inuse, ALIGN(size, sizeof(void *)));
+		}
+
 		if (sysfs_slab_alias(s, name)) {
 			s->refcount--;
 			s = NULL;
@@ -4889,6 +4916,9 @@ int __kmem_cache_create(struct kmem_cache *s, slab_flags_t flags)
 {
 	int err;
 
+	if (!static_asi_enabled())
+		flags &= ~SLAB_NONSENSITIVE;
+
 	err = kmem_cache_open(s, flags);
 	if (err)
 		return err;
@@ -4897,6 +4927,8 @@ int __kmem_cache_create(struct kmem_cache *s, slab_flags_t flags)
 	if (slab_state <= UP)
 		return 0;
 
+	propagate_slab_attrs_from_parent(s);
+
 	err = sysfs_slab_add(s);
 	if (err) {
 		__kmem_cache_release(s);
@@ -5619,7 +5651,7 @@ static ssize_t shrink_store(struct kmem_cache *s,
 			const char *buf, size_t length)
 {
 	if (buf[0] == '1')
-		kmem_cache_shrink(s);
+		kmem_cache_shrink_all(s);
 	else
 		return -EINVAL;
 	return length;
@@ -5829,6 +5861,87 @@ static ssize_t slab_attr_show(struct kobject *kobj,
 	return err;
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+static void propagate_slab_attrs_from_parent(struct kmem_cache *s)
+{
+	int i;
+	char *buffer = NULL;
+	struct kmem_cache *root_cache;
+
+	if (is_root_cache(s))
+		return;
+
+	root_cache = s->local_cache_info.root_cache;
+
+	/*
+	 * This mean this cache had no attribute written. Therefore, no point
+	 * in copying default values around
+	 */
+	if (!root_cache->max_attr_size)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(slab_attrs); i++) {
+		char mbuf[64];
+		char *buf;
+		struct slab_attribute *attr = to_slab_attr(slab_attrs[i]);
+		ssize_t len;
+
+		if (!attr || !attr->store || !attr->show)
+			continue;
+
+		/*
+		 * It is really bad that we have to allocate here, so we will
+		 * do it only as a fallback. If we actually allocate, though,
+		 * we can just use the allocated buffer until the end.
+		 *
+		 * Most of the slub attributes will tend to be very small in
+		 * size, but sysfs allows buffers up to a page, so they can
+		 * theoretically happen.
+		 */
+		if (buffer) {
+			buf = buffer;
+		} else if (root_cache->max_attr_size < ARRAY_SIZE(mbuf) &&
+			 !IS_ENABLED(CONFIG_SLUB_STATS)) {
+			buf = mbuf;
+		} else {
+			buffer = (char *)get_zeroed_page(GFP_KERNEL);
+			if (WARN_ON(!buffer))
+				continue;
+			buf = buffer;
+		}
+
+		len = attr->show(root_cache, buf);
+		if (len > 0)
+			attr->store(s, buf, len);
+	}
+
+	if (buffer)
+		free_page((unsigned long)buffer);
+}
+
+static void propagate_slab_attr_to_children(struct kmem_cache *s,
+					    struct attribute *attr,
+					    const char *buf, size_t len)
+{
+	struct kmem_cache *c;
+	struct slab_attribute *attribute = to_slab_attr(attr);
+
+	if (static_asi_enabled()) {
+		mutex_lock(&slab_mutex);
+
+		if (s->max_attr_size < len)
+			s->max_attr_size = len;
+
+		for_each_child_cache(c, s)
+			attribute->store(c, buf, len);
+
+		mutex_unlock(&slab_mutex);
+	}
+}
+
+#endif
+
 static ssize_t slab_attr_store(struct kobject *kobj,
 				struct attribute *attr,
 				const char *buf, size_t len)
@@ -5844,6 +5957,27 @@ static ssize_t slab_attr_store(struct kobject *kobj,
 		return -EIO;
 
 	err = attribute->store(s, buf, len);
+
+	/*
+	 * This is a best effort propagation, so this function's return
+	 * value will be determined by the parent cache only. This is
+	 * basically because not all attributes will have a well
+	 * defined semantics for rollbacks - most of the actions will
+	 * have permanent effects.
+	 *
+	 * Returning the error value of any of the children that fail
+	 * is not 100 % defined, in the sense that users seeing the
+	 * error code won't be able to know anything about the state of
+	 * the cache.
+	 *
+	 * Only returning the error code for the parent cache at least
+	 * has well defined semantics. The cache being written to
+	 * directly either failed or succeeded, in which case we loop
+	 * through the descendants with best-effort propagation.
+	 */
+	if (slab_state >= FULL && err >= 0 && is_root_cache(s))
+		propagate_slab_attr_to_children(s, attr, buf, len);
+
 	return err;
 }
 
@@ -5866,7 +6000,7 @@ static struct kset *slab_kset;
 
 static inline struct kset *cache_kset(struct kmem_cache *s)
 {
-	return slab_kset;
+	return is_root_cache(s) ? slab_kset : NULL;
 }
 
 #define ID_STR_LENGTH 64
diff --git a/security/Kconfig b/security/Kconfig
index 070a948b5266..a5cfb09352b0 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -68,7 +68,8 @@ config PAGE_TABLE_ISOLATION
 config ADDRESS_SPACE_ISOLATION
 	bool "Allow code to run with a reduced kernel address space"
 	default n
-	depends on X86_64 && !UML && SLAB && !NEED_PER_CPU_KM
+	depends on X86_64 && !UML && !NEED_PER_CPU_KM
+	depends on SLAB || SLUB
 	depends on !PARAVIRT
 	depends on !MEMORY_HOTPLUG
 	help
-- 
2.35.1.473.g83b2b277ed-goog

