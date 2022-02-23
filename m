Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDE84C0C0B
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237619AbiBWF1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238399AbiBWF0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:52 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD596A022
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:16 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d6bca75aa2so141255987b3.18
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Bg8ARgAvpxqrVZujUdMBpF3O5GREYgeeic1zpLXlEAs=;
        b=ZkYcibzizevz7miAILMO787yJLGRxl/cgzlUmAaY/wAepMJq6EHrvI2zYY3SBnMhsX
         y7RWUVRNbxiaiAE1t5uCyYG9PImJ+/9dR0KGIg93jTvqY0XFQDy403oNMPINt668O0wX
         lN1x9DKfkMN5phGLIKP2guH1oM8X+oF56FSnIjn/s1bc0sFaDAvUiQYbfWLnDYkAyeoI
         kOK471SB7zkEDfAJTXNkMVhdXnFBGV5vBVLgIoK40R3LZcAduulDDg2qjj+85oLE8w4w
         JUmk2whW1jd4H91VlFkZkcbARwnTRCiIuS1DGvK4lzbHyv57ehOmB1Yejn5DI2lnROWR
         Cvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Bg8ARgAvpxqrVZujUdMBpF3O5GREYgeeic1zpLXlEAs=;
        b=u5gJTC5Enp4ux/om/6HGU/yXl97BZThof4Va/oc25UhwwYHzJ0FDGoRmVFs1pVr04l
         GH7JLckfiIgcvrZ8pIWTsDF3EdLYkdO/cTmbktE1304um6VaSMrZZaz5GNWV6T14sqUK
         U1/Y78/nL+1RWEt7onkeiSvNALhQj+Yi1mGUOtYjkjrXNILrOb9QMAwPSc7sGYfadK7v
         aD9jgLVPGDLipbiwunVZ2/3jEqAv1Cb2RchGhi9GHYf3Oasw2rKIK11QEB6KzYHBocUQ
         PhDGinMvAOjXaLJ+l0z6uuBnFVOACzcJvK6YcCYiebATfXOT54u2mvTpIWUHoH4fpC0y
         448g==
X-Gm-Message-State: AOAM53206vD1lCrl0KF19F1YYXZxrU5hJhLIPyXK8wrfw0//ablhLxed
        Qz7yn5ZRcQhByEG1IeffKxy/KCVsGupH
X-Google-Smtp-Source: ABdhPJxyXiC19n49tKMSkgiaHfTQpZqUfpkjxmpDblETVmyKjxfScd3DY0k63b7nH5huwuEYpTcB2HPTnvtH
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:6993:0:b0:624:55af:336c with SMTP id
 e141-20020a256993000000b0062455af336cmr19351739ybc.412.1645593905875; Tue, 22
 Feb 2022 21:25:05 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:12 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-37-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 36/47] mm: asi: Adding support for dynamic percpu ASI allocations
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ofir Weisse <oweisse@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        alexandre.chartre@oracle.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
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

From: Ofir Weisse <oweisse@google.com>

Adding infrastructure to support pcpu_alloc with gfp flag of
__GFP_GLOBAL_NONSENSITIVE. We use a similar mechanism as the earlier
infrastructure for memcg percpu allocations and add pcpu type
PCPU_CHUNK_ASI_NONSENSITIVE.
pcpu_chunk_list(PCPU_CHUNK_ASI_NONSENSITIVE) will return a list of ASI
nonsensitive percpu chunks, allowing most of the code to be unchanged.

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 mm/percpu-internal.h |  23 ++++++-
 mm/percpu-km.c       |   5 +-
 mm/percpu-vm.c       |   6 +-
 mm/percpu.c          | 139 ++++++++++++++++++++++++++++++++++---------
 4 files changed, 141 insertions(+), 32 deletions(-)

diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 639662c20c82..2fac01114edc 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -5,6 +5,15 @@
 #include <linux/types.h>
 #include <linux/percpu.h>
 
+enum pcpu_chunk_type {
+        PCPU_CHUNK_ROOT,
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        PCPU_CHUNK_ASI_NONSENSITIVE,
+#endif
+        PCPU_NR_CHUNK_TYPES,
+        PCPU_FAIL_ALLOC = PCPU_NR_CHUNK_TYPES
+};
+
 /*
  * pcpu_block_md is the metadata block struct.
  * Each chunk's bitmap is split into a number of full blocks.
@@ -59,6 +68,9 @@ struct pcpu_chunk {
 #ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup	**obj_cgroups;	/* vector of object cgroups */
 #endif
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        bool                    is_asi_nonsensitive; /* ASI nonsensitive chunk */
+#endif
 
 	int			nr_pages;	/* # of pages served by this chunk */
 	int			nr_populated;	/* # of populated pages */
@@ -68,7 +80,7 @@ struct pcpu_chunk {
 
 extern spinlock_t pcpu_lock;
 
-extern struct list_head *pcpu_chunk_lists;
+extern struct list_head *pcpu_chunk_lists[PCPU_NR_CHUNK_TYPES];
 extern int pcpu_nr_slots;
 extern int pcpu_sidelined_slot;
 extern int pcpu_to_depopulate_slot;
@@ -113,6 +125,15 @@ static inline int pcpu_chunk_map_bits(struct pcpu_chunk *chunk)
 	return pcpu_nr_pages_to_map_bits(chunk->nr_pages);
 }
 
+static inline enum pcpu_chunk_type pcpu_chunk_type(struct pcpu_chunk *chunk)
+{
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        if (chunk->is_asi_nonsensitive)
+                return PCPU_CHUNK_ASI_NONSENSITIVE;
+#endif
+        return PCPU_CHUNK_ROOT;
+}
+
 #ifdef CONFIG_PERCPU_STATS
 
 #include <linux/spinlock.h>
diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index fe31aa19db81..01e31bd55860 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -50,7 +50,8 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
 	/* nada */
 }
 
-static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
+static struct pcpu_chunk *pcpu_create_chunk(enum pcpu_chunk_type type,
+					    gfp_t gfp)
 {
 	const int nr_pages = pcpu_group_sizes[0] >> PAGE_SHIFT;
 	struct pcpu_chunk *chunk;
@@ -58,7 +59,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	unsigned long flags;
 	int i;
 
-	chunk = pcpu_alloc_chunk(gfp);
+	chunk = pcpu_alloc_chunk(type, gfp);
 	if (!chunk)
 		return NULL;
 
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 5579a96ad782..59f3b55abdd1 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -357,7 +357,8 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
 	pcpu_free_pages(chunk, pages, page_start, page_end);
 }
 
-static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
+static struct pcpu_chunk *pcpu_create_chunk(enum pcpu_chunk_type type,
+                                            gfp_t gfp)
 {
 	struct pcpu_chunk *chunk;
 	struct vm_struct **vms;
@@ -368,7 +369,8 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 
 	gfp &= ~__GFP_GLOBAL_NONSENSITIVE;
 
-	chunk = pcpu_alloc_chunk(gfp);
+	chunk = pcpu_alloc_chunk(type, gfp);
+
 	if (!chunk)
 		return NULL;
 
diff --git a/mm/percpu.c b/mm/percpu.c
index f5b2c2ea5a54..beaca5adf9d4 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -172,7 +172,7 @@ struct pcpu_chunk *pcpu_reserved_chunk __ro_after_init;
 DEFINE_SPINLOCK(pcpu_lock);	/* all internal data structures */
 static DEFINE_MUTEX(pcpu_alloc_mutex);	/* chunk create/destroy, [de]pop, map ext */
 
-struct list_head *pcpu_chunk_lists __ro_after_init; /* chunk list slots */
+struct list_head *pcpu_chunk_lists[PCPU_NR_CHUNK_TYPES] __ro_after_init; /* chunk list slots */
 
 /* chunks which need their map areas extended, protected by pcpu_lock */
 static LIST_HEAD(pcpu_map_extend_chunks);
@@ -531,10 +531,12 @@ static void __pcpu_chunk_move(struct pcpu_chunk *chunk, int slot,
 			      bool move_front)
 {
 	if (chunk != pcpu_reserved_chunk) {
+                struct list_head *pcpu_type_lists =
+                          pcpu_chunk_lists[pcpu_chunk_type(chunk)];
 		if (move_front)
-			list_move(&chunk->list, &pcpu_chunk_lists[slot]);
+			list_move(&chunk->list, &pcpu_type_lists[slot]);
 		else
-			list_move_tail(&chunk->list, &pcpu_chunk_lists[slot]);
+			list_move_tail(&chunk->list, &pcpu_type_lists[slot]);
 	}
 }
 
@@ -570,13 +572,16 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
 
 static void pcpu_isolate_chunk(struct pcpu_chunk *chunk)
 {
+	struct list_head *pcpu_type_lists =
+		  pcpu_chunk_lists[pcpu_chunk_type(chunk)];
+
 	lockdep_assert_held(&pcpu_lock);
 
 	if (!chunk->isolated) {
 		chunk->isolated = true;
 		pcpu_nr_empty_pop_pages -= chunk->nr_empty_pop_pages;
 	}
-	list_move(&chunk->list, &pcpu_chunk_lists[pcpu_to_depopulate_slot]);
+	list_move(&chunk->list, &pcpu_type_lists[pcpu_to_depopulate_slot]);
 }
 
 static void pcpu_reintegrate_chunk(struct pcpu_chunk *chunk)
@@ -1438,7 +1443,8 @@ static struct pcpu_chunk * __init pcpu_alloc_first_chunk(unsigned long tmp_addr,
 	return chunk;
 }
 
-static struct pcpu_chunk *pcpu_alloc_chunk(gfp_t gfp)
+static struct pcpu_chunk *pcpu_alloc_chunk(enum pcpu_chunk_type type,
+                                           gfp_t gfp)
 {
 	struct pcpu_chunk *chunk;
 	int region_bits;
@@ -1475,6 +1481,13 @@ static struct pcpu_chunk *pcpu_alloc_chunk(gfp_t gfp)
 			goto objcg_fail;
 	}
 #endif
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        /* TODO: (oweisse) do asi_map for nonsensitive chunks */
+        if (type == PCPU_CHUNK_ASI_NONSENSITIVE)
+                chunk->is_asi_nonsensitive = true;
+        else
+                chunk->is_asi_nonsensitive = false;
+#endif
 
 	pcpu_init_md_blocks(chunk);
 
@@ -1580,7 +1593,8 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
 				  int page_start, int page_end);
 static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
 				      int page_start, int page_end);
-static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp);
+static struct pcpu_chunk *pcpu_create_chunk(enum pcpu_chunk_type type,
+					    gfp_t gfp);
 static void pcpu_destroy_chunk(struct pcpu_chunk *chunk);
 static struct page *pcpu_addr_to_page(void *addr);
 static int __init pcpu_verify_alloc_info(const struct pcpu_alloc_info *ai);
@@ -1733,6 +1747,8 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 	unsigned long flags;
 	void __percpu *ptr;
 	size_t bits, bit_align;
+        enum pcpu_chunk_type type;
+        struct list_head *pcpu_type_lists;
 
 	gfp = current_gfp_context(gfp);
 	/* whitelisted flags that can be passed to the backing allocators */
@@ -1763,6 +1779,16 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 	if (unlikely(!pcpu_memcg_pre_alloc_hook(size, gfp, &objcg)))
 		return NULL;
 
+        type = PCPU_CHUNK_ROOT;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        if (static_asi_enabled() && (gfp & __GFP_GLOBAL_NONSENSITIVE)) {
+                 type = PCPU_CHUNK_ASI_NONSENSITIVE;
+                 pcpu_gfp |= __GFP_GLOBAL_NONSENSITIVE;
+        }
+#endif
+	pcpu_type_lists = pcpu_chunk_lists[type];
+        BUG_ON(!pcpu_type_lists);
+
 	if (!is_atomic) {
 		/*
 		 * pcpu_balance_workfn() allocates memory under this mutex,
@@ -1800,7 +1826,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 restart:
 	/* search through normal chunks */
 	for (slot = pcpu_size_to_slot(size); slot <= pcpu_free_slot; slot++) {
-		list_for_each_entry_safe(chunk, next, &pcpu_chunk_lists[slot],
+		list_for_each_entry_safe(chunk, next, &pcpu_type_lists[slot],
 					 list) {
 			off = pcpu_find_block_fit(chunk, bits, bit_align,
 						  is_atomic);
@@ -1830,8 +1856,8 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 		goto fail;
 	}
 
-	if (list_empty(&pcpu_chunk_lists[pcpu_free_slot])) {
-		chunk = pcpu_create_chunk(pcpu_gfp);
+	if (list_empty(&pcpu_type_lists[pcpu_free_slot])) {
+		chunk = pcpu_create_chunk(type, pcpu_gfp);
 		if (!chunk) {
 			err = "failed to allocate new chunk";
 			goto fail;
@@ -1983,12 +2009,19 @@ void __percpu *__alloc_reserved_percpu(size_t size, size_t align)
  * CONTEXT:
  * pcpu_lock (can be dropped temporarily)
  */
-static void pcpu_balance_free(bool empty_only)
+
+static void __pcpu_balance_free(bool empty_only,
+                                enum pcpu_chunk_type type)
 {
 	LIST_HEAD(to_free);
-	struct list_head *free_head = &pcpu_chunk_lists[pcpu_free_slot];
+        struct list_head *pcpu_type_lists = pcpu_chunk_lists[type];
+	struct list_head *free_head;
 	struct pcpu_chunk *chunk, *next;
 
+        if (!pcpu_type_lists)
+                  return;
+	free_head = &pcpu_type_lists[pcpu_free_slot];
+
 	lockdep_assert_held(&pcpu_lock);
 
 	/*
@@ -2026,6 +2059,14 @@ static void pcpu_balance_free(bool empty_only)
 	spin_lock_irq(&pcpu_lock);
 }
 
+static void pcpu_balance_free(bool empty_only)
+{
+        enum pcpu_chunk_type type;
+        for (type = 0; type < PCPU_NR_CHUNK_TYPES; type++) {
+                __pcpu_balance_free(empty_only, type);
+        }
+}
+
 /**
  * pcpu_balance_populated - manage the amount of populated pages
  *
@@ -2038,12 +2079,21 @@ static void pcpu_balance_free(bool empty_only)
  * CONTEXT:
  * pcpu_lock (can be dropped temporarily)
  */
-static void pcpu_balance_populated(void)
+static void __pcpu_balance_populated(enum pcpu_chunk_type type)
 {
 	/* gfp flags passed to underlying allocators */
-	const gfp_t gfp = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
+        const gfp_t gfp = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+              | (type == PCPU_CHUNK_ASI_NONSENSITIVE ?
+                    __GFP_GLOBAL_NONSENSITIVE : 0)
+#endif
+        ;
 	struct pcpu_chunk *chunk;
 	int slot, nr_to_pop, ret;
+	struct list_head *pcpu_type_lists = pcpu_chunk_lists[type];
+
+	if (!pcpu_type_lists)
+		return;
 
 	lockdep_assert_held(&pcpu_lock);
 
@@ -2074,7 +2124,7 @@ static void pcpu_balance_populated(void)
 		if (!nr_to_pop)
 			break;
 
-		list_for_each_entry(chunk, &pcpu_chunk_lists[slot], list) {
+		list_for_each_entry(chunk, &pcpu_type_lists[slot], list) {
 			nr_unpop = chunk->nr_pages - chunk->nr_populated;
 			if (nr_unpop)
 				break;
@@ -2107,7 +2157,7 @@ static void pcpu_balance_populated(void)
 	if (nr_to_pop) {
 		/* ran out of chunks to populate, create a new one and retry */
 		spin_unlock_irq(&pcpu_lock);
-		chunk = pcpu_create_chunk(gfp);
+		chunk = pcpu_create_chunk(type, gfp);
 		cond_resched();
 		spin_lock_irq(&pcpu_lock);
 		if (chunk) {
@@ -2117,6 +2167,14 @@ static void pcpu_balance_populated(void)
 	}
 }
 
+static void pcpu_balance_populated()
+{
+        enum pcpu_chunk_type type;
+
+        for (type = 0; type < PCPU_NR_CHUNK_TYPES; type++)
+                __pcpu_balance_populated(type);
+}
+
 /**
  * pcpu_reclaim_populated - scan over to_depopulate chunks and free empty pages
  *
@@ -2132,13 +2190,19 @@ static void pcpu_balance_populated(void)
  * pcpu_lock (can be dropped temporarily)
  *
  */
-static void pcpu_reclaim_populated(void)
+
+
+static void __pcpu_reclaim_populated(enum pcpu_chunk_type type)
 {
 	struct pcpu_chunk *chunk;
 	struct pcpu_block_md *block;
 	int freed_page_start, freed_page_end;
 	int i, end;
 	bool reintegrate;
+        struct list_head *pcpu_type_lists = pcpu_chunk_lists[type];
+
+        if (!pcpu_type_lists)
+                  return;
 
 	lockdep_assert_held(&pcpu_lock);
 
@@ -2148,8 +2212,8 @@ static void pcpu_reclaim_populated(void)
 	 * other accessor is the free path which only returns area back to the
 	 * allocator not touching the populated bitmap.
 	 */
-	while (!list_empty(&pcpu_chunk_lists[pcpu_to_depopulate_slot])) {
-		chunk = list_first_entry(&pcpu_chunk_lists[pcpu_to_depopulate_slot],
+	while (!list_empty(&pcpu_type_lists[pcpu_to_depopulate_slot])) {
+		chunk = list_first_entry(&pcpu_type_lists[pcpu_to_depopulate_slot],
 					 struct pcpu_chunk, list);
 		WARN_ON(chunk->immutable);
 
@@ -2219,10 +2283,18 @@ static void pcpu_reclaim_populated(void)
 			pcpu_reintegrate_chunk(chunk);
 		else
 			list_move_tail(&chunk->list,
-				       &pcpu_chunk_lists[pcpu_sidelined_slot]);
+				       &pcpu_type_lists[pcpu_sidelined_slot]);
 	}
 }
 
+static void pcpu_reclaim_populated(void)
+{
+        enum pcpu_chunk_type type;
+        for (type = 0; type < PCPU_NR_CHUNK_TYPES; type++) {
+                __pcpu_reclaim_populated(type);
+        }
+}
+
 /**
  * pcpu_balance_workfn - manage the amount of free chunks and populated pages
  * @work: unused
@@ -2268,6 +2340,7 @@ void free_percpu(void __percpu *ptr)
 	unsigned long flags;
 	int size, off;
 	bool need_balance = false;
+        struct list_head *pcpu_type_lists = NULL;
 
 	if (!ptr)
 		return;
@@ -2280,6 +2353,8 @@ void free_percpu(void __percpu *ptr)
 
 	chunk = pcpu_chunk_addr_search(addr);
 	off = addr - chunk->base_addr;
+        pcpu_type_lists = pcpu_chunk_lists[pcpu_chunk_type(chunk)];
+        BUG_ON(!pcpu_type_lists);
 
 	size = pcpu_free_area(chunk, off);
 
@@ -2293,7 +2368,7 @@ void free_percpu(void __percpu *ptr)
 	if (!chunk->isolated && chunk->free_bytes == pcpu_unit_size) {
 		struct pcpu_chunk *pos;
 
-		list_for_each_entry(pos, &pcpu_chunk_lists[pcpu_free_slot], list)
+		list_for_each_entry(pos, &pcpu_type_lists[pcpu_free_slot], list)
 			if (pos != chunk) {
 				need_balance = true;
 				break;
@@ -2601,6 +2676,7 @@ void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	int map_size;
 	unsigned long tmp_addr;
 	size_t alloc_size;
+        enum pcpu_chunk_type type;
 
 #define PCPU_SETUP_BUG_ON(cond)	do {					\
 	if (unlikely(cond)) {						\
@@ -2723,15 +2799,24 @@ void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	pcpu_free_slot = pcpu_sidelined_slot + 1;
 	pcpu_to_depopulate_slot = pcpu_free_slot + 1;
 	pcpu_nr_slots = pcpu_to_depopulate_slot + 1;
-	pcpu_chunk_lists = memblock_alloc(pcpu_nr_slots *
-					  sizeof(pcpu_chunk_lists[0]),
+	for (type = 0; type < PCPU_NR_CHUNK_TYPES; type++) {
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+                if (type == PCPU_CHUNK_ASI_NONSENSITIVE &&
+                    !static_asi_enabled()) {
+                        pcpu_chunk_lists[type] = NULL;
+                        continue;
+                }
+#endif
+	        pcpu_chunk_lists[type] = memblock_alloc(pcpu_nr_slots *
+					  sizeof(pcpu_chunk_lists[0][0]),
 					  SMP_CACHE_BYTES);
-	if (!pcpu_chunk_lists)
-		panic("%s: Failed to allocate %zu bytes\n", __func__,
-		      pcpu_nr_slots * sizeof(pcpu_chunk_lists[0]));
+                if (!pcpu_chunk_lists[type])
+                        panic("%s: Failed to allocate %zu bytes\n", __func__,
+                              pcpu_nr_slots * sizeof(pcpu_chunk_lists[0][0]));
 
-	for (i = 0; i < pcpu_nr_slots; i++)
-		INIT_LIST_HEAD(&pcpu_chunk_lists[i]);
+                for (i = 0; i < pcpu_nr_slots; i++)
+                        INIT_LIST_HEAD(&pcpu_chunk_lists[type][i]);
+        }
 
 	/*
 	 * The end of the static region needs to be aligned with the
-- 
2.35.1.473.g83b2b277ed-goog

