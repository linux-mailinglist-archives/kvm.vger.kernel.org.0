Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2800D610587
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbiJ0WSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbiJ0WSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:18:22 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E18B03D8
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:18:18 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666909097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCOHakwLVHL/HxA71yNFHnB1Ii5dyZBwO4r/8WBoQkk=;
        b=gBBJ9oqxPoQy52ZOU71b1CwdS8m2VS//Z5qVd6DiK3gQttj16Z3M6ZVJZi5w1kPw4sHiT4
        fBVNtHWidkLrs6wJb7sHWBLVrH32QX/VH9WEXZoRNYyXrZLplDJExWp6cXjqZqSDvXACCU
        CXoKfNCqw+yQosfPA7htenG2tUQl9pg=
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
Subject: [PATCH v3 01/15] KVM: arm64: Combine visitor arguments into a context structure
Date:   Thu, 27 Oct 2022 22:17:38 +0000
Message-Id: <20221027221752.1683510-2-oliver.upton@linux.dev>
In-Reply-To: <20221027221752.1683510-1-oliver.upton@linux.dev>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Passing new arguments by value to the visitor callbacks is extremely
inflexible for stuffing new parameters used by only some of the
visitors. Use a context structure instead and pass the pointer through
to the visitor callback.

While at it, redefine the 'flags' parameter to the visitor to contain
the bit indicating the phase of the walk. Pass the entire set of flags
through the context structure such that the walker can communicate
additional state to the visitor callback.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  15 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  10 +-
 arch/arm64/kvm/hyp/nvhe/setup.c       |  16 +-
 arch/arm64/kvm/hyp/pgtable.c          | 269 +++++++++++++-------------
 4 files changed, 154 insertions(+), 156 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 3252eb50ecfe..607f9bb8aab4 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -199,10 +199,17 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 };
 
-typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
-					kvm_pte_t *ptep,
-					enum kvm_pgtable_walk_flags flag,
-					void * const arg);
+struct kvm_pgtable_visit_ctx {
+	kvm_pte_t				*ptep;
+	void					*arg;
+	u64					addr;
+	u64					end;
+	u32					level;
+	enum kvm_pgtable_walk_flags		flags;
+};
+
+typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_ctx *ctx,
+					enum kvm_pgtable_walk_flags visit);
 
 /**
  * struct kvm_pgtable_walker - Hook into a page-table walk.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1e78acf9662e..8f5b6a36a039 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -417,13 +417,11 @@ struct check_walk_data {
 	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte);
 };
 
-static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
-				      kvm_pte_t *ptep,
-				      enum kvm_pgtable_walk_flags flag,
-				      void * const arg)
+static int __check_page_state_visitor(const struct kvm_pgtable_visit_ctx *ctx,
+				      enum kvm_pgtable_walk_flags visit)
 {
-	struct check_walk_data *d = arg;
-	kvm_pte_t pte = *ptep;
+	struct check_walk_data *d = ctx->arg;
+	kvm_pte_t pte = *ctx->ptep;
 
 	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
 		return -EINVAL;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index e8d4ea2fcfa0..a293cf5eba1b 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -186,15 +186,13 @@ static void hpool_put_page(void *addr)
 	hyp_put_page(&hpool, addr);
 }
 
-static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
-					 kvm_pte_t *ptep,
-					 enum kvm_pgtable_walk_flags flag,
-					 void * const arg)
+static int finalize_host_mappings_walker(const struct kvm_pgtable_visit_ctx *ctx,
+					 enum kvm_pgtable_walk_flags visit)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
 	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;
-	kvm_pte_t pte = *ptep;
+	kvm_pte_t pte = *ctx->ptep;
 	phys_addr_t phys;
 
 	if (!kvm_pte_valid(pte))
@@ -205,11 +203,11 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	 * was unable to access the hyp_vmemmap and so the buddy allocator has
 	 * initialised the refcount to '1'.
 	 */
-	mm_ops->get_page(ptep);
-	if (flag != KVM_PGTABLE_WALK_LEAF)
+	mm_ops->get_page(ctx->ptep);
+	if (visit != KVM_PGTABLE_WALK_LEAF)
 		return 0;
 
-	if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
+	if (ctx->level != (KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
 	phys = kvm_pte_to_phys(pte);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index cdf8e76b0be1..900c8b9c0cfc 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -64,20 +64,20 @@ static bool kvm_phys_is_valid(u64 phys)
 	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_EL1_PARANGE_MAX));
 }
 
-static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
+static bool kvm_block_mapping_supported(const struct kvm_pgtable_visit_ctx *ctx, u64 phys)
 {
-	u64 granule = kvm_granule_size(level);
+	u64 granule = kvm_granule_size(ctx->level);
 
-	if (!kvm_level_supports_block_mapping(level))
+	if (!kvm_level_supports_block_mapping(ctx->level))
 		return false;
 
-	if (granule > (end - addr))
+	if (granule > (ctx->end - ctx->addr))
 		return false;
 
 	if (kvm_phys_is_valid(phys) && !IS_ALIGNED(phys, granule))
 		return false;
 
-	return IS_ALIGNED(addr, granule);
+	return IS_ALIGNED(ctx->addr, granule);
 }
 
 static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
@@ -172,12 +172,12 @@ static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
 	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
 }
 
-static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
-				  u32 level, kvm_pte_t *ptep,
-				  enum kvm_pgtable_walk_flags flag)
+static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
+				  const struct kvm_pgtable_visit_ctx *ctx,
+				  enum kvm_pgtable_walk_flags visit)
 {
 	struct kvm_pgtable_walker *walker = data->walker;
-	return walker->cb(addr, data->end, level, ptep, flag, walker->arg);
+	return walker->cb(ctx, visit);
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
@@ -186,20 +186,24 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 				      kvm_pte_t *ptep, u32 level)
 {
+	enum kvm_pgtable_walk_flags flags = data->walker->flags;
+	struct kvm_pgtable_visit_ctx ctx = {
+		.ptep	= ptep,
+		.arg	= data->walker->arg,
+		.addr	= data->addr,
+		.end	= data->end,
+		.level	= level,
+		.flags	= flags,
+	};
 	int ret = 0;
-	u64 addr = data->addr;
 	kvm_pte_t *childp, pte = *ptep;
 	bool table = kvm_pte_table(pte, level);
-	enum kvm_pgtable_walk_flags flags = data->walker->flags;
 
-	if (table && (flags & KVM_PGTABLE_WALK_TABLE_PRE)) {
-		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
-					     KVM_PGTABLE_WALK_TABLE_PRE);
-	}
+	if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE))
+		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_PRE);
 
-	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
-		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
-					     KVM_PGTABLE_WALK_LEAF);
+	if (!table && (ctx.flags & KVM_PGTABLE_WALK_LEAF)) {
+		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_LEAF);
 		pte = *ptep;
 		table = kvm_pte_table(pte, level);
 	}
@@ -218,10 +222,8 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 	if (ret)
 		goto out;
 
-	if (flags & KVM_PGTABLE_WALK_TABLE_POST) {
-		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
-					     KVM_PGTABLE_WALK_TABLE_POST);
-	}
+	if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
+		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_POST);
 
 out:
 	return ret;
@@ -292,13 +294,13 @@ struct leaf_walk_data {
 	u32		level;
 };
 
-static int leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-		       enum kvm_pgtable_walk_flags flag, void * const arg)
+static int leaf_walker(const struct kvm_pgtable_visit_ctx *ctx,
+		       enum kvm_pgtable_walk_flags visit)
 {
-	struct leaf_walk_data *data = arg;
+	struct leaf_walk_data *data = ctx->arg;
 
-	data->pte   = *ptep;
-	data->level = level;
+	data->pte   = *ctx->ptep;
+	data->level = ctx->level;
 
 	return 0;
 }
@@ -383,47 +385,47 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
 	return prot;
 }
 
-static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
-				    kvm_pte_t *ptep, struct hyp_map_data *data)
+static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
+				    struct hyp_map_data *data)
 {
-	kvm_pte_t new, old = *ptep;
-	u64 granule = kvm_granule_size(level), phys = data->phys;
+	kvm_pte_t new, old = *ctx->ptep;
+	u64 granule = kvm_granule_size(ctx->level), phys = data->phys;
 
-	if (!kvm_block_mapping_supported(addr, end, phys, level))
+	if (!kvm_block_mapping_supported(ctx, phys))
 		return false;
 
 	data->phys += granule;
-	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+	new = kvm_init_valid_leaf_pte(phys, data->attr, ctx->level);
 	if (old == new)
 		return true;
 	if (!kvm_pte_valid(old))
-		data->mm_ops->get_page(ptep);
+		data->mm_ops->get_page(ctx->ptep);
 	else if (WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
 		return false;
 
-	smp_store_release(ptep, new);
+	smp_store_release(ctx->ptep, new);
 	return true;
 }
 
-static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			  enum kvm_pgtable_walk_flags flag, void * const arg)
+static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			  enum kvm_pgtable_walk_flags visit)
 {
 	kvm_pte_t *childp;
-	struct hyp_map_data *data = arg;
+	struct hyp_map_data *data = ctx->arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
-	if (hyp_map_walker_try_leaf(addr, end, level, ptep, arg))
+	if (hyp_map_walker_try_leaf(ctx, data))
 		return 0;
 
-	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
+	if (WARN_ON(ctx->level == KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
 	childp = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
 	if (!childp)
 		return -ENOMEM;
 
-	kvm_set_table_pte(ptep, childp, mm_ops);
-	mm_ops->get_page(ptep);
+	kvm_set_table_pte(ctx->ptep, childp, mm_ops);
+	mm_ops->get_page(ctx->ptep);
 	return 0;
 }
 
@@ -456,39 +458,39 @@ struct hyp_unmap_data {
 	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
-static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			    enum kvm_pgtable_walk_flags flag, void * const arg)
+static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			    enum kvm_pgtable_walk_flags visit)
 {
-	kvm_pte_t pte = *ptep, *childp = NULL;
-	u64 granule = kvm_granule_size(level);
-	struct hyp_unmap_data *data = arg;
+	kvm_pte_t pte = *ctx->ptep, *childp = NULL;
+	u64 granule = kvm_granule_size(ctx->level);
+	struct hyp_unmap_data *data = ctx->arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
 	if (!kvm_pte_valid(pte))
 		return -EINVAL;
 
-	if (kvm_pte_table(pte, level)) {
+	if (kvm_pte_table(pte, ctx->level)) {
 		childp = kvm_pte_follow(pte, mm_ops);
 
 		if (mm_ops->page_count(childp) != 1)
 			return 0;
 
-		kvm_clear_pte(ptep);
+		kvm_clear_pte(ctx->ptep);
 		dsb(ishst);
-		__tlbi_level(vae2is, __TLBI_VADDR(addr, 0), level);
+		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
 	} else {
-		if (end - addr < granule)
+		if (ctx->end - ctx->addr < granule)
 			return -EINVAL;
 
-		kvm_clear_pte(ptep);
+		kvm_clear_pte(ctx->ptep);
 		dsb(ishst);
-		__tlbi_level(vale2is, __TLBI_VADDR(addr, 0), level);
+		__tlbi_level(vale2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
 		data->unmapped += granule;
 	}
 
 	dsb(ish);
 	isb();
-	mm_ops->put_page(ptep);
+	mm_ops->put_page(ctx->ptep);
 
 	if (childp)
 		mm_ops->put_page(childp);
@@ -532,18 +534,18 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 	return 0;
 }
 
-static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			   enum kvm_pgtable_walk_flags flag, void * const arg)
+static int hyp_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			   enum kvm_pgtable_walk_flags visit)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = arg;
-	kvm_pte_t pte = *ptep;
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
+	kvm_pte_t pte = *ctx->ptep;
 
 	if (!kvm_pte_valid(pte))
 		return 0;
 
-	mm_ops->put_page(ptep);
+	mm_ops->put_page(ctx->ptep);
 
-	if (kvm_pte_table(pte, level))
+	if (kvm_pte_table(pte, ctx->level))
 		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
 
 	return 0;
@@ -682,19 +684,19 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 	return !!pte;
 }
 
-static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
-			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
+static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
+			   struct kvm_pgtable_mm_ops *mm_ops)
 {
 	/*
 	 * Clear the existing PTE, and perform break-before-make with
 	 * TLB maintenance if it was valid.
 	 */
-	if (kvm_pte_valid(*ptep)) {
-		kvm_clear_pte(ptep);
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, addr, level);
+	if (kvm_pte_valid(*ctx->ptep)) {
+		kvm_clear_pte(ctx->ptep);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
 	}
 
-	mm_ops->put_page(ptep);
+	mm_ops->put_page(ctx->ptep);
 }
 
 static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
@@ -708,29 +710,28 @@ static bool stage2_pte_executable(kvm_pte_t pte)
 	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
 }
 
-static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
+static bool stage2_leaf_mapping_allowed(const struct kvm_pgtable_visit_ctx *ctx,
 					struct stage2_map_data *data)
 {
-	if (data->force_pte && (level < (KVM_PGTABLE_MAX_LEVELS - 1)))
+	if (data->force_pte && (ctx->level < (KVM_PGTABLE_MAX_LEVELS - 1)))
 		return false;
 
-	return kvm_block_mapping_supported(addr, end, data->phys, level);
+	return kvm_block_mapping_supported(ctx, data->phys);
 }
 
-static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
-				      kvm_pte_t *ptep,
+static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 				      struct stage2_map_data *data)
 {
-	kvm_pte_t new, old = *ptep;
-	u64 granule = kvm_granule_size(level), phys = data->phys;
+	kvm_pte_t new, old = *ctx->ptep;
+	u64 granule = kvm_granule_size(ctx->level), phys = data->phys;
 	struct kvm_pgtable *pgt = data->mmu->pgt;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
-	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
+	if (!stage2_leaf_mapping_allowed(ctx, data))
 		return -E2BIG;
 
 	if (kvm_phys_is_valid(phys))
-		new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+		new = kvm_init_valid_leaf_pte(phys, data->attr, ctx->level);
 	else
 		new = kvm_init_invalid_leaf_owner(data->owner_id);
 
@@ -744,7 +745,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		if (!stage2_pte_needs_update(old, new))
 			return -EAGAIN;
 
-		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
+		stage2_put_pte(ctx, data->mmu, mm_ops);
 	}
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
@@ -755,26 +756,25 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
-	smp_store_release(ptep, new);
+	smp_store_release(ctx->ptep, new);
 	if (stage2_pte_is_counted(new))
-		mm_ops->get_page(ptep);
+		mm_ops->get_page(ctx->ptep);
 	if (kvm_phys_is_valid(phys))
 		data->phys += granule;
 	return 0;
 }
 
-static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
-				     kvm_pte_t *ptep,
+static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 				     struct stage2_map_data *data)
 {
 	if (data->anchor)
 		return 0;
 
-	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
+	if (!stage2_leaf_mapping_allowed(ctx, data))
 		return 0;
 
-	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
-	kvm_clear_pte(ptep);
+	data->childp = kvm_pte_follow(*ctx->ptep, data->mm_ops);
+	kvm_clear_pte(ctx->ptep);
 
 	/*
 	 * Invalidate the whole stage-2, as we may have numerous leaf
@@ -782,29 +782,29 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	 * individually.
 	 */
 	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
-	data->anchor = ptep;
+	data->anchor = ctx->ptep;
 	return 0;
 }
 
-static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 				struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
-	kvm_pte_t *childp, pte = *ptep;
+	kvm_pte_t *childp, pte = *ctx->ptep;
 	int ret;
 
 	if (data->anchor) {
 		if (stage2_pte_is_counted(pte))
-			mm_ops->put_page(ptep);
+			mm_ops->put_page(ctx->ptep);
 
 		return 0;
 	}
 
-	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, data);
+	ret = stage2_map_walker_try_leaf(ctx, data);
 	if (ret != -E2BIG)
 		return ret;
 
-	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
+	if (WARN_ON(ctx->level == KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
 	if (!data->memcache)
@@ -820,16 +820,15 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * will be mapped lazily.
 	 */
 	if (stage2_pte_is_counted(pte))
-		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
+		stage2_put_pte(ctx, data->mmu, mm_ops);
 
-	kvm_set_table_pte(ptep, childp, mm_ops);
-	mm_ops->get_page(ptep);
+	kvm_set_table_pte(ctx->ptep, childp, mm_ops);
+	mm_ops->get_page(ctx->ptep);
 
 	return 0;
 }
 
-static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
-				      kvm_pte_t *ptep,
+static int stage2_map_walk_table_post(const struct kvm_pgtable_visit_ctx *ctx,
 				      struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
@@ -839,17 +838,17 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 	if (!data->anchor)
 		return 0;
 
-	if (data->anchor == ptep) {
+	if (data->anchor == ctx->ptep) {
 		childp = data->childp;
 		data->anchor = NULL;
 		data->childp = NULL;
-		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
+		ret = stage2_map_walk_leaf(ctx, data);
 	} else {
-		childp = kvm_pte_follow(*ptep, mm_ops);
+		childp = kvm_pte_follow(*ctx->ptep, mm_ops);
 	}
 
 	mm_ops->put_page(childp);
-	mm_ops->put_page(ptep);
+	mm_ops->put_page(ctx->ptep);
 
 	return ret;
 }
@@ -873,18 +872,18 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
  * the page-table, installing the block entry when it revisits the anchor
  * pointer and clearing the anchor to NULL.
  */
-static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			     enum kvm_pgtable_walk_flags flag, void * const arg)
+static int stage2_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			     enum kvm_pgtable_walk_flags visit)
 {
-	struct stage2_map_data *data = arg;
+	struct stage2_map_data *data = ctx->arg;
 
-	switch (flag) {
+	switch (visit) {
 	case KVM_PGTABLE_WALK_TABLE_PRE:
-		return stage2_map_walk_table_pre(addr, end, level, ptep, data);
+		return stage2_map_walk_table_pre(ctx, data);
 	case KVM_PGTABLE_WALK_LEAF:
-		return stage2_map_walk_leaf(addr, end, level, ptep, data);
+		return stage2_map_walk_leaf(ctx, data);
 	case KVM_PGTABLE_WALK_TABLE_POST:
-		return stage2_map_walk_table_post(addr, end, level, ptep, data);
+		return stage2_map_walk_table_post(ctx, data);
 	}
 
 	return -EINVAL;
@@ -949,25 +948,24 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
-static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			       enum kvm_pgtable_walk_flags flag,
-			       void * const arg)
+static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			       enum kvm_pgtable_walk_flags visit)
 {
-	struct kvm_pgtable *pgt = arg;
+	struct kvm_pgtable *pgt = ctx->arg;
 	struct kvm_s2_mmu *mmu = pgt->mmu;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
-	kvm_pte_t pte = *ptep, *childp = NULL;
+	kvm_pte_t pte = *ctx->ptep, *childp = NULL;
 	bool need_flush = false;
 
 	if (!kvm_pte_valid(pte)) {
 		if (stage2_pte_is_counted(pte)) {
-			kvm_clear_pte(ptep);
-			mm_ops->put_page(ptep);
+			kvm_clear_pte(ctx->ptep);
+			mm_ops->put_page(ctx->ptep);
 		}
 		return 0;
 	}
 
-	if (kvm_pte_table(pte, level)) {
+	if (kvm_pte_table(pte, ctx->level)) {
 		childp = kvm_pte_follow(pte, mm_ops);
 
 		if (mm_ops->page_count(childp) != 1)
@@ -981,11 +979,11 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * block entry and rely on the remaining portions being faulted
 	 * back lazily.
 	 */
-	stage2_put_pte(ptep, mmu, addr, level, mm_ops);
+	stage2_put_pte(ctx, mmu, mm_ops);
 
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
-					       kvm_granule_size(level));
+					       kvm_granule_size(ctx->level));
 
 	if (childp)
 		mm_ops->put_page(childp);
@@ -1012,18 +1010,17 @@ struct stage2_attr_data {
 	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
-static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			      enum kvm_pgtable_walk_flags flag,
-			      void * const arg)
+static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			      enum kvm_pgtable_walk_flags visit)
 {
-	kvm_pte_t pte = *ptep;
-	struct stage2_attr_data *data = arg;
+	kvm_pte_t pte = *ctx->ptep;
+	struct stage2_attr_data *data = ctx->arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
 	if (!kvm_pte_valid(pte))
 		return 0;
 
-	data->level = level;
+	data->level = ctx->level;
 	data->pte = pte;
 	pte &= ~data->attr_clr;
 	pte |= data->attr_set;
@@ -1039,10 +1036,10 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		 * stage-2 PTE if we are going to add executable permission.
 		 */
 		if (mm_ops->icache_inval_pou &&
-		    stage2_pte_executable(pte) && !stage2_pte_executable(*ptep))
+		    stage2_pte_executable(pte) && !stage2_pte_executable(*ctx->ptep))
 			mm_ops->icache_inval_pou(kvm_pte_follow(pte, mm_ops),
-						  kvm_granule_size(level));
-		WRITE_ONCE(*ptep, pte);
+						  kvm_granule_size(ctx->level));
+		WRITE_ONCE(*ctx->ptep, pte);
 	}
 
 	return 0;
@@ -1140,20 +1137,19 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	return ret;
 }
 
-static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			       enum kvm_pgtable_walk_flags flag,
-			       void * const arg)
+static int stage2_flush_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			       enum kvm_pgtable_walk_flags visit)
 {
-	struct kvm_pgtable *pgt = arg;
+	struct kvm_pgtable *pgt = ctx->arg;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
-	kvm_pte_t pte = *ptep;
+	kvm_pte_t pte = *ctx->ptep;
 
 	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
 		return 0;
 
 	if (mm_ops->dcache_clean_inval_poc)
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
-					       kvm_granule_size(level));
+					       kvm_granule_size(ctx->level));
 	return 0;
 }
 
@@ -1200,19 +1196,18 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	return 0;
 }
 
-static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			      enum kvm_pgtable_walk_flags flag,
-			      void * const arg)
+static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			      enum kvm_pgtable_walk_flags visit)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = arg;
-	kvm_pte_t pte = *ptep;
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
+	kvm_pte_t pte = *ctx->ptep;
 
 	if (!stage2_pte_is_counted(pte))
 		return 0;
 
-	mm_ops->put_page(ptep);
+	mm_ops->put_page(ctx->ptep);
 
-	if (kvm_pte_table(pte, level))
+	if (kvm_pte_table(pte, ctx->level))
 		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
 
 	return 0;
-- 
2.38.1.273.g43a17bfeac-goog

