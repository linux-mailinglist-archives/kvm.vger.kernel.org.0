Return-Path: <kvm+bounces-19086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 991C1900B94
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 19:55:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE4581C215FA
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 17:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DA919B59D;
	Fri,  7 Jun 2024 17:55:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D80E19B3FB;
	Fri,  7 Jun 2024 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717782907; cv=none; b=HKeW84C0325Jy58dISoZRRhUZomvZZ76fQtMi4zuslZvMgRJo8bvgQ+QwrACp6ev1amTMaNvi+DnQVsq28ILiHsBvTUUrC95mHuFxj9BkFSfWB89s2lPBxbzzguTHW00fejbQXD8/TKYvIbI7700XtGD2mdHhMmAH4mCb8LysNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717782907; c=relaxed/simple;
	bh=XnDbiFM+BN2bxP5TKFCb/OJuFSFu4EMoe+P/ielAHNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CP1IHoGKVwaAwb8pMsvZqQXJtv44Fw4PjznmCHNX+z/7NwN0oyv9vbx7AB767aJG9r7fJdJv9HseQrClh9nghCn72HKTAF20/aLxszhD/aWe7yRtXzMvuw/vo9GlOfEiUOnEckWIYrmlUoPtVxsLePD2A+JX890Ip+tueEIyq2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE39C32781;
	Fri,  7 Jun 2024 17:55:03 +0000 (UTC)
Date: Fri, 7 Jun 2024 18:55:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
Message-ID: <ZmNJdSxSz-sYpVgI@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-13-steven.price@arm.com>
 <86a5jzld9g.wl-maz@kernel.org>
 <4c363476-e5b5-42ff-9f30-a02a92b6751b@arm.com>
 <867cf2l6in.wl-maz@kernel.org>
 <ZmICEN8JvWM7M9Ch@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmICEN8JvWM7M9Ch@arm.com>

On Thu, Jun 06, 2024 at 07:38:08PM +0100, Catalin Marinas wrote:
> On Thu, Jun 06, 2024 at 11:17:36AM +0100, Marc Zyngier wrote:
> > On Wed, 05 Jun 2024 16:08:49 +0100,
> > Steven Price <steven.price@arm.com> wrote:
> > > 2. Use a special (global) memory allocator that does the
> > > set_memory_decrypted() dance on the pages that it allocates but allows
> > > packing the allocations. I'm not aware of an existing kernel API for
> > > this, so it's potentially quite a bit of code. The benefit is that it
> > > reduces memory consumption in a realm guest, although fragmentation
> > > still means we're likely to see a (small) growth.
> > > 
> > > Any thoughts on what you think would be best?
> > 
> > I would expect that something similar to kmem_cache could be of help,
> > only with the ability to deal with variable object sizes (in this
> > case: minimum of 256 bytes, in increments defined by the
> > implementation, and with a 256 byte alignment).
> 
> Hmm, that's doable but not that easy to make generic. We'd need a new
> class of kmalloc-* caches (e.g. kmalloc-decrypted-*) which use only
> decrypted pages together with a GFP_DECRYPTED flag or something to get
> the slab allocator to go for these pages and avoid merging with other
> caches. It would actually be the page allocator parsing this gfp flag,
> probably in post_alloc_hook() to set the page decrypted and re-encrypt
> it in free_pages_prepare(). A slight problem here is that free_pages()
> doesn't get the gfp flag, so we'd need to store some bit in the page
> flags. Maybe the flag is not that bad, do we have something like for
> page_to_phys() to give us the high IPA address for decrypted pages?

I had a go at this generic approach, Friday afternoon fun. Not tested
with the CCA patches, just my own fake set_memory_*() functionality on
top of 6.10-rc2. I also mindlessly added __GFP_DECRYPTED to the ITS code
following the changes in this patch. I noticed that
allocate_vpe_l2_table() doesn't use shared pages (I either missed it or
it's not needed).

If we want to go this way, I can tidy up the diff below, split it into a
proper series and add what's missing. What I can't tell is how a driver
writer knows when to pass __GFP_DECRYPTED. There's also a theoretical
overlap with __GFP_DMA, it can't handle both. The DMA flag takes
priority currently but I realised it probably needs to be the other way
around, we wouldn't have dma mask restrictions for emulated devices.

--------------------8<----------------------------------
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 40ebf1726393..b6627e839e62 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2212,7 +2212,8 @@ static struct page *its_allocate_prop_table(gfp_t gfp_flags)
 {
 	struct page *prop_page;
 
-	prop_page = alloc_pages(gfp_flags, get_order(LPI_PROPBASE_SZ));
+	prop_page = alloc_pages(gfp_flags | __GFP_DECRYPTED,
+				get_order(LPI_PROPBASE_SZ));
 	if (!prop_page)
 		return NULL;
 
@@ -2346,7 +2347,8 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		order = get_order(GITS_BASER_PAGES_MAX * psz);
 	}
 
-	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, order);
+	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO |
+				__GFP_DECRYPTED, order);
 	if (!page)
 		return -ENOMEM;
 
@@ -2940,7 +2942,8 @@ static int allocate_vpe_l1_table(void)
 
 	pr_debug("np = %d, npg = %lld, psz = %d, epp = %d, esz = %d\n",
 		 np, npg, psz, epp, esz);
-	page = alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_SIZE));
+	page = alloc_pages(GFP_ATOMIC | __GFP_ZERO | __GFP_DECRYPTED,
+			   get_order(np * PAGE_SIZE));
 	if (!page)
 		return -ENOMEM;
 
@@ -2986,7 +2989,7 @@ static struct page *its_allocate_pending_table(gfp_t gfp_flags)
 {
 	struct page *pend_page;
 
-	pend_page = alloc_pages(gfp_flags | __GFP_ZERO,
+	pend_page = alloc_pages(gfp_flags | __GFP_ZERO | __GFP_DECRYPTED,
 				get_order(LPI_PENDBASE_SZ));
 	if (!pend_page)
 		return NULL;
@@ -3334,7 +3337,8 @@ static bool its_alloc_table_entry(struct its_node *its,
 
 	/* Allocate memory for 2nd level table */
 	if (!table[idx]) {
-		page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
+		page = alloc_pages_node(its->numa_node, GFP_KERNEL |
+					__GFP_ZERO | __GFP_DECRYPTED,
 					get_order(baser->psz));
 		if (!page)
 			return false;
@@ -3438,7 +3442,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	nr_ites = max(2, nvecs);
 	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
 	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
-	itt = kzalloc_node(sz, GFP_KERNEL, its->numa_node);
+	itt = kzalloc_node(sz, GFP_KERNEL | __GFP_DECRYPTED, its->numa_node);
 	if (alloc_lpis) {
 		lpi_map = its_lpi_alloc(nvecs, &lpi_base, &nr_lpis);
 		if (lpi_map)
@@ -5131,8 +5135,8 @@ static int __init its_probe_one(struct its_node *its)
 		}
 	}
 
-	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
-				get_order(ITS_CMD_QUEUE_SZ));
+	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO |
+				__GFP_DECRYPTED, get_order(ITS_CMD_QUEUE_SZ));
 	if (!page) {
 		err = -ENOMEM;
 		goto out_unmap_sgir;
diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 313be4ad79fd..573989664639 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -57,6 +57,9 @@ enum {
 #endif
 #ifdef CONFIG_SLAB_OBJ_EXT
 	___GFP_NO_OBJ_EXT_BIT,
+#endif
+#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
+	___GFP_DECRYPTED_BIT,
 #endif
 	___GFP_LAST_BIT
 };
@@ -103,6 +106,11 @@ enum {
 #else
 #define ___GFP_NO_OBJ_EXT       0
 #endif
+#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
+#define ___GFP_DECRYPTED	BIT(___GFP_DECRYPTED_BIT)
+#else
+#define ___GFP_DECRYPTED	0
+#endif
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -117,6 +125,8 @@ enum {
 #define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* ZONE_MOVABLE allowed */
 #define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
 
+#define __GFP_DECRYPTED	((__force gfp_t)___GFP_DECRYPTED)
+
 /**
  * DOC: Page mobility and placement hints
  *
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 104078afe0b1..705707052274 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -127,6 +127,9 @@ enum pageflags {
 #ifdef CONFIG_MEMORY_FAILURE
 	PG_hwpoison,		/* hardware poisoned page. Don't touch */
 #endif
+#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
+	PG_decrypted,
+#endif
 #if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
 	PG_young,
 	PG_idle,
@@ -626,6 +629,15 @@ PAGEFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
 #endif
 
+#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
+PAGEFLAG(Decrypted, decrypted, PF_HEAD)
+#define __PG_DECRYPTED	(1UL << PG_decrypted)
+#else
+PAGEFLAG_FALSE(Decrypted, decrypted)
+#define __PG_DECRYPTED	0
+#endif
+
+
 #ifdef CONFIG_PAGE_IDLE_FLAG
 #ifdef CONFIG_64BIT
 FOLIO_TEST_FLAG(young, FOLIO_HEAD_PAGE)
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 7247e217e21b..f7a2cf624c35 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -422,6 +422,9 @@ enum kmalloc_cache_type {
 #endif
 #ifdef CONFIG_MEMCG_KMEM
 	KMALLOC_CGROUP,
+#endif
+#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
+	KMALLOC_DECRYPTED,
 #endif
 	NR_KMALLOC_TYPES
 };
@@ -433,7 +436,7 @@ kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
  * Define gfp bits that should not be set for KMALLOC_NORMAL.
  */
 #define KMALLOC_NOT_NORMAL_BITS					\
-	(__GFP_RECLAIMABLE |					\
+	(__GFP_RECLAIMABLE | __GFP_DECRYPTED |			\
 	(IS_ENABLED(CONFIG_ZONE_DMA)   ? __GFP_DMA : 0) |	\
 	(IS_ENABLED(CONFIG_MEMCG_KMEM) ? __GFP_ACCOUNT : 0))
 
@@ -458,11 +461,14 @@ static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, unsigne
 	 * At least one of the flags has to be set. Their priorities in
 	 * decreasing order are:
 	 *  1) __GFP_DMA
-	 *  2) __GFP_RECLAIMABLE
-	 *  3) __GFP_ACCOUNT
+	 *  2) __GFP_DECRYPTED
+	 *  3) __GFP_RECLAIMABLE
+	 *  4) __GFP_ACCOUNT
 	 */
 	if (IS_ENABLED(CONFIG_ZONE_DMA) && (flags & __GFP_DMA))
 		return KMALLOC_DMA;
+	if (IS_ENABLED(CONFIG_ARCH_HAS_MEM_ENCRYPT) && (flags & __GFP_DECRYPTED))
+		return KMALLOC_DECRYPTED;
 	if (!IS_ENABLED(CONFIG_MEMCG_KMEM) || (flags & __GFP_RECLAIMABLE))
 		return KMALLOC_RECLAIM;
 	else
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index e46d6e82765e..a0879155f892 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -83,6 +83,12 @@
 #define IF_HAVE_PG_HWPOISON(_name)
 #endif
 
+#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
+#define IF_HAVE_PG_DECRYPTED(_name) ,{1UL << PG_##_name, __stringify(_name)}
+#else
+#define IF_HAVE_PG_DECRYPTED(_name)
+#endif
+
 #if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
 #define IF_HAVE_PG_IDLE(_name) ,{1UL << PG_##_name, __stringify(_name)}
 #else
@@ -121,6 +127,7 @@
 IF_HAVE_PG_MLOCK(mlocked)						\
 IF_HAVE_PG_UNCACHED(uncached)						\
 IF_HAVE_PG_HWPOISON(hwpoison)						\
+IF_HAVE_PG_DECRYPTED(decrypted)						\
 IF_HAVE_PG_IDLE(idle)							\
 IF_HAVE_PG_IDLE(young)							\
 IF_HAVE_PG_ARCH_X(arch_2)						\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2e22ce5675ca..c93ae50ec402 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -47,6 +47,7 @@
 #include <linux/sched/mm.h>
 #include <linux/page_owner.h>
 #include <linux/page_table_check.h>
+#include <linux/set_memory.h>
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
 #include <linux/lockdep.h>
@@ -1051,6 +1052,12 @@ __always_inline bool free_pages_prepare(struct page *page,
 		return false;
 	}
 
+	if (unlikely(PageDecrypted(page))) {
+		set_memory_encrypted((unsigned long)page_address(page),
+				     1 << order);
+		ClearPageDecrypted(page);
+	}
+
 	VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
 	/*
@@ -1415,6 +1422,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
 	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
+	bool decrypted = true; //gfp_flags & __GFP_DECRYPTED;
 	int i;
 
 	set_page_private(page, 0);
@@ -1465,6 +1473,12 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	if (init)
 		kernel_init_pages(page, 1 << order);
 
+	if (decrypted) {
+		set_memory_decrypted((unsigned long)page_address(page),
+				     1 << order);
+		SetPageDecrypted(page);
+	}
+
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
 	pgalloc_tag_add(page, current, 1 << order);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 1560a1546bb1..de9c8c674aa1 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -737,6 +737,12 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_RCL_NAME(sz)
 #endif
 
+#ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
+#define KMALLOC_DECRYPTED_NAME(sz)	.name[KMALLOC_DECRYPTED] = "kmalloc-decrypted-" #sz,
+#else
+#define KMALLOC_DECRYPTED_NAME(sz)
+#endif
+
 #ifdef CONFIG_RANDOM_KMALLOC_CACHES
 #define __KMALLOC_RANDOM_CONCAT(a, b) a ## b
 #define KMALLOC_RANDOM_NAME(N, sz) __KMALLOC_RANDOM_CONCAT(KMA_RAND_, N)(sz)
@@ -765,6 +771,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 	KMALLOC_RCL_NAME(__short_size)				\
 	KMALLOC_CGROUP_NAME(__short_size)			\
 	KMALLOC_DMA_NAME(__short_size)				\
+	KMALLOC_DECRYPTED_NAME(__short_size)			\
 	KMALLOC_RANDOM_NAME(RANDOM_KMALLOC_CACHES_NR, __short_size)	\
 	.size = __size,						\
 }
@@ -889,6 +896,9 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 	if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_NORMAL))
 		flags |= SLAB_NO_MERGE;
 
+	if (IS_ENABLED(CONFIG_ARCH_HAS_MEM_ENCRYPT) && (type == KMALLOC_DECRYPTED))
+		flags |= SLAB_NO_MERGE;
+
 	if (minalign > ARCH_KMALLOC_MINALIGN) {
 		aligned_size = ALIGN(aligned_size, minalign);
 		aligned_idx = __kmalloc_index(aligned_size, false);

