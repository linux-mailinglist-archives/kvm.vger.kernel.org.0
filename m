Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E2D5F8129
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 01:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiJGX3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 19:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJGX3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 19:29:17 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020417F0B0
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 16:29:15 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665185353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D23PvGDHHQIna/CJNl/f6shLt82XH84z9SInvMjnPXI=;
        b=GoQP+Hw01vduL1snTNYukb3gu7UxglULRvlzRk5/XTW0p+LTTQhHtJnVHjEZ7jNxiE5gTO
        jzVU9KJm5bOkih0MmXrsqIyYN+fjBu1WqPUzqvvtnmvXY8/K3UDlDIjNwTMeci9B7s0DB3
        PpYUZqXx+fqSlXXJ/2BrVmEGq4QMW5M=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 06/15] KVM: arm64: Tear down unlinked stage-2 subtree after break-before-make
Date:   Fri,  7 Oct 2022 23:28:09 +0000
Message-Id: <20221007232818.459650-7-oliver.upton@linux.dev>
In-Reply-To: <20221007232818.459650-1-oliver.upton@linux.dev>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The break-before-make sequence is a bit annoying as it opens a window
wherein memory is unmapped from the guest. KVM should replace the PTE
as quickly as possible and avoid unnecessary work in between.

Presently, the stage-2 map walker tears down a removed table before
installing a block mapping when coalescing a table into a block. As the
removed table is no longer visible to hardware walkers after the
DSB+TLBI, it is possible to move the remaining cleanup to happen after
installing the new PTE.

Reshuffle the stage-2 map walker to install the new block entry in
the pre-order callback. Unwire all of the teardown logic and replace
it with a call to kvm_pgtable_stage2_free_removed() after fixing
the PTE. The post-order visitor is now completely unnecessary, so drop
it. Finally, touch up the comments to better represent the now
simplified map walker.

Note that the call to tear down the unlinked stage-2 is indirected
as a subsequent change will use an RCU callback to trigger tear down.
RCU is not available to pKVM, so there is a need to use different
implementations on pKVM and non-pKVM VMs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  3 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 ++
 arch/arm64/kvm/hyp/pgtable.c          | 84 ++++++++-------------------
 arch/arm64/kvm/mmu.c                  |  8 +++
 4 files changed, 40 insertions(+), 61 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 71b7d154b78a..c33edcf36b5b 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -77,6 +77,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
  *				allocation is physically contiguous.
  * @free_pages_exact:		Free an exact number of memory pages previously
  *				allocated by zalloc_pages_exact.
+ * @free_removed_table:		Free a removed paging structure by unlinking and
+ *				dropping references.
  * @get_page:			Increment the refcount on a page.
  * @put_page:			Decrement the refcount on a page. When the
  *				refcount reaches 0 the page is automatically
@@ -95,6 +97,7 @@ struct kvm_pgtable_mm_ops {
 	void*		(*zalloc_page)(void *arg);
 	void*		(*zalloc_pages_exact)(size_t size);
 	void		(*free_pages_exact)(void *addr, size_t size);
+	void		(*free_removed_table)(void *addr, u32 level);
 	void		(*get_page)(void *addr);
 	void		(*put_page)(void *addr);
 	int		(*page_count)(void *addr);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d21d1b08a055..735769886b55 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -79,6 +79,11 @@ static void host_s2_put_page(void *addr)
 	hyp_put_page(&host_s2_pool, addr);
 }
 
+static void host_s2_free_removed_table(void *addr, u32 level)
+{
+	kvm_pgtable_stage2_free_removed(&host_kvm.mm_ops, addr, level);
+}
+
 static int prepare_s2_pool(void *pgt_pool_base)
 {
 	unsigned long nr_pages, pfn;
@@ -93,6 +98,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
 	host_kvm.mm_ops = (struct kvm_pgtable_mm_ops) {
 		.zalloc_pages_exact = host_s2_zalloc_pages_exact,
 		.zalloc_page = host_s2_zalloc_page,
+		.free_removed_table = host_s2_free_removed_table,
 		.phys_to_virt = hyp_phys_to_virt,
 		.virt_to_phys = hyp_virt_to_phys,
 		.page_count = hyp_page_count,
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 363a5cce7e1a..02c33fccb178 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -746,16 +746,19 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
+static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
+				struct stage2_map_data *data);
+
 static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 				     struct stage2_map_data *data)
 {
-	if (data->anchor)
-		return 0;
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	kvm_pte_t *childp = kvm_pte_follow(ctx->old, mm_ops);
+	int ret;
 
 	if (!stage2_leaf_mapping_allowed(ctx, data))
 		return 0;
 
-	data->childp = kvm_pte_follow(ctx->old, ctx->mm_ops);
 	kvm_clear_pte(ctx->ptep);
 
 	/*
@@ -764,8 +767,13 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 	 * individually.
 	 */
 	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
-	data->anchor = ctx->ptep;
-	return 0;
+
+	ret = stage2_map_walk_leaf(ctx, data);
+
+	mm_ops->put_page(ctx->ptep);
+	mm_ops->free_removed_table(childp, ctx->level + 1);
+
+	return ret;
 }
 
 static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
@@ -775,13 +783,6 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	kvm_pte_t *childp;
 	int ret;
 
-	if (data->anchor) {
-		if (stage2_pte_is_counted(ctx->old))
-			mm_ops->put_page(ctx->ptep);
-
-		return 0;
-	}
-
 	ret = stage2_map_walker_try_leaf(ctx, data);
 	if (ret != -E2BIG)
 		return ret;
@@ -810,49 +811,14 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
-static int stage2_map_walk_table_post(const struct kvm_pgtable_visit_ctx *ctx,
-				      struct stage2_map_data *data)
-{
-	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
-	kvm_pte_t *childp;
-	int ret = 0;
-
-	if (!data->anchor)
-		return 0;
-
-	if (data->anchor == ctx->ptep) {
-		childp = data->childp;
-		data->anchor = NULL;
-		data->childp = NULL;
-		ret = stage2_map_walk_leaf(ctx, data);
-	} else {
-		childp = kvm_pte_follow(ctx->old, mm_ops);
-	}
-
-	mm_ops->put_page(childp);
-	mm_ops->put_page(ctx->ptep);
-
-	return ret;
-}
-
 /*
- * This is a little fiddly, as we use all three of the walk flags. The idea
- * is that the TABLE_PRE callback runs for table entries on the way down,
- * looking for table entries which we could conceivably replace with a
- * block entry for this mapping. If it finds one, then it sets the 'anchor'
- * field in 'struct stage2_map_data' to point at the table entry, before
- * clearing the entry to zero and descending into the now detached table.
- *
- * The behaviour of the LEAF callback then depends on whether or not the
- * anchor has been set. If not, then we're not using a block mapping higher
- * up the table and we perform the mapping at the existing leaves instead.
- * If, on the other hand, the anchor _is_ set, then we drop references to
- * all valid leaves so that the pages beneath the anchor can be freed.
+ * The TABLE_PRE callback runs for table entries on the way down, looking
+ * for table entries which we could conceivably replace with a block entry
+ * for this mapping. If it finds one it replaces the entry and calls
+ * kvm_pgtable_mm_ops::free_removed_table() to tear down the detached table.
  *
- * Finally, the TABLE_POST callback does nothing if the anchor has not
- * been set, but otherwise frees the page-table pages while walking back up
- * the page-table, installing the block entry when it revisits the anchor
- * pointer and clearing the anchor to NULL.
+ * Otherwise, the LEAF callback performs the mapping at the existing leaves
+ * instead.
  */
 static int stage2_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			     enum kvm_pgtable_walk_flags visit)
@@ -864,11 +830,9 @@ static int stage2_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
 		return stage2_map_walk_table_pre(ctx, data);
 	case KVM_PGTABLE_WALK_LEAF:
 		return stage2_map_walk_leaf(ctx, data);
-	case KVM_PGTABLE_WALK_TABLE_POST:
-		return stage2_map_walk_table_post(ctx, data);
+	default:
+		return -EINVAL;
 	}
-
-	return -EINVAL;
 }
 
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
@@ -885,8 +849,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
 		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
-				  KVM_PGTABLE_WALK_LEAF |
-				  KVM_PGTABLE_WALK_TABLE_POST,
+				  KVM_PGTABLE_WALK_LEAF,
 		.arg		= &map_data,
 	};
 
@@ -916,8 +879,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
 		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
-				  KVM_PGTABLE_WALK_LEAF |
-				  KVM_PGTABLE_WALK_TABLE_POST,
+				  KVM_PGTABLE_WALK_LEAF,
 		.arg		= &map_data,
 	};
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9a13e487187..04a25319abb0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -102,6 +102,13 @@ static void *kvm_host_zalloc_pages_exact(size_t size)
 	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 }
 
+static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
+
+static void stage2_free_removed_table(void *addr, u32 level)
+{
+	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, addr, level);
+}
+
 static void kvm_host_get_page(void *addr)
 {
 	get_page(virt_to_page(addr));
@@ -627,6 +634,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
 	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
 	.free_pages_exact	= free_pages_exact,
+	.free_removed_table	= stage2_free_removed_table,
 	.get_page		= kvm_host_get_page,
 	.put_page		= kvm_host_put_page,
 	.page_count		= kvm_host_page_count,
-- 
2.38.0.rc1.362.ged0d419d3c-goog

