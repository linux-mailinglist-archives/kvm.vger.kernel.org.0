Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F56D5A6D93
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiH3TmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiH3TmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:42:12 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC9479ED1;
        Tue, 30 Aug 2022 12:42:08 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661888526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=540ijd3DSISikR4MfZOPq9ymXvASuAcxTCB5BqenS8g=;
        b=Wtd7wVmgOM8SS945uvAyWmwRa4U4EJrNf2/GNcY+qdiln8p1rNKwfbVBe9fQ1AUCNtE4YR
        xo1zOAK0rJx10pPwtZFj7T+CxMeK+Pv2Ohl4GJKfI/E6WlPJRQ56R2WF+zLzkmCmOZWmZz
        PZq8+6SSFO7ZOhC3/mJDRN04baGgGuI=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] KVM: arm64: Read the PTE once per visit
Date:   Tue, 30 Aug 2022 19:41:22 +0000
Message-Id: <20220830194132.962932-5-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The page table walkers read the PTE multiple times per visit. Presently,
that is safe as changes to the non-leaf PTEs are serialized. A
subsequent change to KVM will enable parallel modifications to the stage
2 page tables. Prepare by ensuring a PTE is read only once per visit.

Promote the PTE read in __kvm_pgtable_visit() to READ_ONCE() and pass
the observed value through to callbacks. Note that the PTE is passed as
a pointer to the callbacks; visitors that install new tables need to aim
traversal at the new table.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  8 ++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  4 +-
 arch/arm64/kvm/hyp/nvhe/setup.c       |  4 +-
 arch/arm64/kvm/hyp/pgtable.c          | 73 ++++++++++++++-------------
 4 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c25633f53b2b..47920ae3f7e7 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -195,7 +195,7 @@ enum kvm_pgtable_walk_flags {
 };
 
 typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
-					kvm_pte_t *ptep,
+					kvm_pte_t *ptep, kvm_pte_t *old,
 					enum kvm_pgtable_walk_flags flag,
 					void * const arg);
 
@@ -561,4 +561,10 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
  *	   kvm_pgtable_prot format.
  */
 enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
+
+static inline kvm_pte_t kvm_pte_read(kvm_pte_t *ptep)
+{
+	return READ_ONCE(*ptep);
+}
+
 #endif	/* __ARM64_KVM_PGTABLE_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a930fdee6fce..61cf223e0796 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -419,12 +419,12 @@ struct check_walk_data {
 };
 
 static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
-				      kvm_pte_t *ptep,
+				      kvm_pte_t *ptep, kvm_pte_t *old,
 				      enum kvm_pgtable_walk_flags flag,
 				      void * const arg)
 {
 	struct check_walk_data *d = arg;
-	kvm_pte_t pte = *ptep;
+	kvm_pte_t pte = *old;
 
 	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
 		return -EINVAL;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index e8d4ea2fcfa0..2b62ca58ebd4 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -187,14 +187,14 @@ static void hpool_put_page(void *addr)
 }
 
 static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
-					 kvm_pte_t *ptep,
+					 kvm_pte_t *ptep, kvm_pte_t *old,
 					 enum kvm_pgtable_walk_flags flag,
 					 void * const arg)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;
-	kvm_pte_t pte = *ptep;
+	kvm_pte_t pte = *old;
 	phys_addr_t phys;
 
 	if (!kvm_pte_valid(pte))
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b6ce786ae570..430753fbb727 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -178,11 +178,11 @@ static u8 kvm_invalid_pte_owner(kvm_pte_t pte)
 }
 
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
-				  u32 level, kvm_pte_t *ptep,
+				  u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
 				  enum kvm_pgtable_walk_flags flag)
 {
 	struct kvm_pgtable_walker *walker = data->walker;
-	return walker->cb(addr, data->end, level, ptep, flag, walker->arg);
+	return walker->cb(addr, data->end, level, ptep, old, flag, walker->arg);
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
@@ -193,17 +193,17 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 {
 	int ret = 0;
 	u64 addr = data->addr;
-	kvm_pte_t *childp, pte = *ptep;
+	kvm_pte_t *childp, pte = kvm_pte_read(ptep);
 	bool table = kvm_pte_table(pte, level);
 	enum kvm_pgtable_walk_flags flags = data->walker->flags;
 
 	if (table && (flags & KVM_PGTABLE_WALK_TABLE_PRE)) {
-		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
+		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
 					     KVM_PGTABLE_WALK_TABLE_PRE);
 	}
 
 	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
-		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
+		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
 					     KVM_PGTABLE_WALK_LEAF);
 		pte = *ptep;
 		table = kvm_pte_table(pte, level);
@@ -224,7 +224,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		goto out;
 
 	if (flags & KVM_PGTABLE_WALK_TABLE_POST) {
-		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
+		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
 					     KVM_PGTABLE_WALK_TABLE_POST);
 	}
 
@@ -297,12 +297,12 @@ struct leaf_walk_data {
 	u32		level;
 };
 
-static int leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
 		       enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct leaf_walk_data *data = arg;
 
-	data->pte   = *ptep;
+	data->pte   = *old;
 	data->level = level;
 
 	return 0;
@@ -388,10 +388,10 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
 	return prot;
 }
 
-static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
-				    kvm_pte_t *ptep, struct hyp_map_data *data)
+static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+				    kvm_pte_t old, struct hyp_map_data *data)
 {
-	kvm_pte_t new, old = *ptep;
+	kvm_pte_t new;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
 
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
@@ -410,14 +410,14 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	return true;
 }
 
-static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
 			  enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	kvm_pte_t *childp;
 	struct hyp_map_data *data = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
-	if (hyp_map_walker_try_leaf(addr, end, level, ptep, arg))
+	if (hyp_map_walker_try_leaf(addr, end, level, ptep, *old, arg))
 		return 0;
 
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
@@ -461,10 +461,10 @@ struct hyp_unmap_data {
 	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
-static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
 			    enum kvm_pgtable_walk_flags flag, void * const arg)
 {
-	kvm_pte_t pte = *ptep, *childp = NULL;
+	kvm_pte_t pte = *old, *childp = NULL;
 	u64 granule = kvm_granule_size(level);
 	struct hyp_unmap_data *data = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
@@ -537,11 +537,11 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 	return 0;
 }
 
-static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
-	kvm_pte_t pte = *ptep;
+	kvm_pte_t pte = *old;
 
 	if (!kvm_pte_valid(pte))
 		return 0;
@@ -723,10 +723,10 @@ static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
 }
 
 static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
-				      kvm_pte_t *ptep,
+				      kvm_pte_t *ptep, kvm_pte_t old,
 				      struct stage2_map_data *data)
 {
-	kvm_pte_t new, old = *ptep;
+	kvm_pte_t new;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
 	struct kvm_pgtable *pgt = data->mmu->pgt;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
@@ -772,11 +772,11 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 				struct stage2_map_data *data);
 
 static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
-				     kvm_pte_t *ptep,
+				     kvm_pte_t *ptep, kvm_pte_t *old,
 				     struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
-	kvm_pte_t *childp = kvm_pte_follow(*ptep, mm_ops);
+	kvm_pte_t *childp = kvm_pte_follow(*old, mm_ops);
 	struct kvm_pgtable *pgt = data->mmu->pgt;
 	int ret;
 
@@ -801,13 +801,14 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 }
 
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-				struct stage2_map_data *data)
+				kvm_pte_t *old, struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
-	kvm_pte_t *childp, pte = *ptep;
+	kvm_pte_t *childp, pte = *old;
 	int ret;
 
-	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, data);
+	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, pte, data);
+
 	if (ret != -E2BIG)
 		return ret;
 
@@ -844,16 +845,16 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
  * Otherwise, the LEAF callback performs the mapping at the existing leaves
  * instead.
  */
-static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
 			     enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct stage2_map_data *data = arg;
 
 	switch (flag) {
 	case KVM_PGTABLE_WALK_TABLE_PRE:
-		return stage2_map_walk_table_pre(addr, end, level, ptep, data);
+		return stage2_map_walk_table_pre(addr, end, level, ptep, old, data);
 	case KVM_PGTABLE_WALK_LEAF:
-		return stage2_map_walk_leaf(addr, end, level, ptep, data);
+		return stage2_map_walk_leaf(addr, end, level, ptep, old, data);
 	default:
 		return -EINVAL;
 	}
@@ -918,13 +919,13 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 }
 
 static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			       enum kvm_pgtable_walk_flags flag,
+			       kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
 	struct kvm_pgtable *pgt = arg;
 	struct kvm_s2_mmu *mmu = pgt->mmu;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
-	kvm_pte_t pte = *ptep, *childp = NULL;
+	kvm_pte_t pte = *old, *childp = NULL;
 	bool need_flush = false;
 
 	if (!kvm_pte_valid(pte)) {
@@ -981,10 +982,10 @@ struct stage2_attr_data {
 };
 
 static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			      enum kvm_pgtable_walk_flags flag,
+			      kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
 			      void * const arg)
 {
-	kvm_pte_t pte = *ptep;
+	kvm_pte_t pte = *old;
 	struct stage2_attr_data *data = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
@@ -1007,7 +1008,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		 * stage-2 PTE if we are going to add executable permission.
 		 */
 		if (mm_ops->icache_inval_pou &&
-		    stage2_pte_executable(pte) && !stage2_pte_executable(*ptep))
+		    stage2_pte_executable(pte) && !stage2_pte_executable(data->pte))
 			mm_ops->icache_inval_pou(kvm_pte_follow(pte, mm_ops),
 						  kvm_granule_size(level));
 		WRITE_ONCE(*ptep, pte);
@@ -1109,12 +1110,12 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 }
 
 static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			       enum kvm_pgtable_walk_flags flag,
+			       kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
 	struct kvm_pgtable *pgt = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
-	kvm_pte_t pte = *ptep;
+	kvm_pte_t pte = *old;
 
 	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
 		return 0;
@@ -1169,11 +1170,11 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 }
 
 static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			      enum kvm_pgtable_walk_flags flag,
+			      kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
 			      void * const arg)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
-	kvm_pte_t pte = *ptep;
+	kvm_pte_t pte = *old;
 
 	if (!stage2_pte_is_counted(pte))
 		return 0;
-- 
2.37.2.672.g94769d06f0-goog

