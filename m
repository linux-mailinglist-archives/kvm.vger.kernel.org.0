Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1057A50310F
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356042AbiDOWBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244034AbiDOWBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:43 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A84377F8
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:13 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id ay41-20020a5d9da9000000b00653e75506b8so58861iob.2
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1Dvq0vSpuJ+B5i+lAUjot+b1S2UM0uuMiRyTOuKbozw=;
        b=f0Ct2KeIjmpzITrXuAlU/IXp9HqHaYUY14BbtuMlXzD5cMFehCeAkuIQZN9MFinFsR
         Qbp4qrLoUZqthvpvsvdzGjy8wLygbQ0WlDP6aTuRbHdO6gSsTKMD7flO7JZ2wK78u7pG
         wT+k3nbsihczJyCyCIw6RfoaQT/fGxDvVRDbU7dqJ8LveecvlvpXCtSrZ8FvWshbrqjr
         Ng8Gw6k3NN7OCQLHsMdOXloj+4FOOvcMCgra/n/WfgQ+hXQpA9D4ZmLf6aM2jgKzhggE
         p0G7rjmCjRnZn/8CS7n2NbTu/eKmMqhSDUDAs++6W0Jit3quykTz1+d+JiM2+53KSPXM
         XqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1Dvq0vSpuJ+B5i+lAUjot+b1S2UM0uuMiRyTOuKbozw=;
        b=lu8q2an8UiMEty2zgKqGq8PYwXvBK5wqGtQWmCW7sQN3OZ9DINaFSzEz3rG5VInF62
         pr9s52Dwz8UrajEbI8p8zQDdMPmYWraNnksuXdsTVigZ+sxBdltaGU9N9rjUG5hiFrVb
         WR//8geIT/Pq3Y7MLpvBO/Xgzs1IoqgTTYtOcTtWpVnR6JenwFHhmZvPhcezijuTXrFD
         CSngKQuTEOyVrK/i0h605LnEZs/Ya3366caHrR5AndgQ+i4E2HNvT9q4YZevDZwjmpbc
         +Tc56QqJ47IPBNBEHCFT6drFEcv8STrHJ+s9Iz3ttfavfTnGFnq1NWwafk6vBYWwry4w
         Vc9A==
X-Gm-Message-State: AOAM531POOA8WQpxGaloeztHhD8UIGCwzZlifSb2bjkDqy/qX60FEe/S
        n5lH8n2GM3KI/z0kgJvHyqcUm+RRVTM=
X-Google-Smtp-Source: ABdhPJw+CGHjGO0ZS08PkgVlHelz0Jm4z2IXXsD/Vyzt5RIyBZDRwHzHFKVKAtaVcfL7OMy4ZxqJFar+bXU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:12e9:b0:2c9:f576:8951 with SMTP id
 l9-20020a056e0212e900b002c9f5768951mr355751iln.204.1650059953138; Fri, 15 Apr
 2022 14:59:13 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:49 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-6-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 05/17] KVM: arm64: Take an argument to indicate parallel walk
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
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

It is desirable to reuse the same page walkers for serial and parallel
faults. Take an argument to kvm_pgtable_walk() (and throughout) to
indicate whether or not a walk might happen in parallel with another.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  5 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  4 +-
 arch/arm64/kvm/hyp/nvhe/setup.c       |  4 +-
 arch/arm64/kvm/hyp/pgtable.c          | 91 ++++++++++++++-------------
 4 files changed, 54 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index ea818a5f7408..74955aba5918 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -194,7 +194,7 @@ enum kvm_pgtable_walk_flags {
 typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
 					kvm_pte_t *ptep, kvm_pte_t *old,
 					enum kvm_pgtable_walk_flags flag,
-					void * const arg);
+					void * const arg, bool shared);
 
 /**
  * struct kvm_pgtable_walker - Hook into a page-table walk.
@@ -490,6 +490,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
  * @addr:	Input address for the start of the walk.
  * @size:	Size of the range to walk.
  * @walker:	Walker callback description.
+ * @shared:	Indicates if the page table walk can be done in parallel
  *
  * The offset of @addr within a page is ignored and @size is rounded-up to
  * the next page boundary.
@@ -506,7 +507,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
  * Return: 0 on success, negative error code on failure.
  */
 int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
-		     struct kvm_pgtable_walker *walker);
+		     struct kvm_pgtable_walker *walker, bool shared);
 
 /**
  * kvm_pgtable_get_leaf() - Walk a page-table and retrieve the leaf entry
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 601a586581d8..42a5f35cd819 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -424,7 +424,7 @@ struct check_walk_data {
 static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep, kvm_pte_t *old,
 				      enum kvm_pgtable_walk_flags flag,
-				      void * const arg)
+				      void * const arg, bool shared)
 {
 	struct check_walk_data *d = arg;
 
@@ -443,7 +443,7 @@ static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 	};
 
-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	return kvm_pgtable_walk(pgt, addr, size, &walker, false);
 }
 
 static enum pkvm_page_state host_get_page_state(kvm_pte_t pte)
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index ecab7a4049d6..178a5539fe7c 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -164,7 +164,7 @@ static void hpool_put_page(void *addr)
 static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 					 kvm_pte_t *ptep, kvm_pte_t *old,
 					 enum kvm_pgtable_walk_flags flag,
-					 void * const arg)
+					 void * const arg, bool shared)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	enum kvm_pgtable_prot prot;
@@ -224,7 +224,7 @@ static int finalize_host_mappings(void)
 		struct memblock_region *reg = &hyp_memory[i];
 		u64 start = (u64)hyp_phys_to_virt(reg->base);
 
-		ret = kvm_pgtable_walk(&pkvm_pgtable, start, reg->size, &walker);
+		ret = kvm_pgtable_walk(&pkvm_pgtable, start, reg->size, &walker, false);
 		if (ret)
 			return ret;
 	}
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d4699f698d6e..bf46d6d24951 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -198,17 +198,17 @@ static u8 kvm_invalid_pte_owner(kvm_pte_t pte)
 
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
-				  enum kvm_pgtable_walk_flags flag)
+				  enum kvm_pgtable_walk_flags flag, bool shared)
 {
 	struct kvm_pgtable_walker *walker = data->walker;
-	return walker->cb(addr, data->end, level, ptep, old, flag, walker->arg);
+	return walker->cb(addr, data->end, level, ptep, old, flag, walker->arg, shared);
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
-			      kvm_pte_t *pgtable, u32 level);
+			      kvm_pte_t *pgtable, u32 level, bool shared);
 
 static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
-				      kvm_pte_t *ptep, u32 level)
+				      kvm_pte_t *ptep, u32 level, bool shared)
 {
 	int ret = 0;
 	u64 addr = data->addr;
@@ -218,12 +218,12 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 
 	if (table && (flags & KVM_PGTABLE_WALK_TABLE_PRE)) {
 		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
-					     KVM_PGTABLE_WALK_TABLE_PRE);
+					     KVM_PGTABLE_WALK_TABLE_PRE, shared);
 	}
 
 	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
 		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
-					     KVM_PGTABLE_WALK_LEAF);
+					     KVM_PGTABLE_WALK_LEAF, shared);
 	}
 
 	if (ret)
@@ -237,13 +237,13 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 	}
 
 	childp = kvm_pte_follow(pte, data->pgt->mm_ops);
-	ret = __kvm_pgtable_walk(data, childp, level + 1);
+	ret = __kvm_pgtable_walk(data, childp, level + 1, shared);
 	if (ret)
 		goto out;
 
 	if (flags & KVM_PGTABLE_WALK_TABLE_POST) {
 		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
-					     KVM_PGTABLE_WALK_TABLE_POST);
+					     KVM_PGTABLE_WALK_TABLE_POST, shared);
 	}
 
 out:
@@ -251,7 +251,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
-			      kvm_pte_t *pgtable, u32 level)
+			      kvm_pte_t *pgtable, u32 level, bool shared)
 {
 	u32 idx;
 	int ret = 0;
@@ -265,7 +265,7 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 		if (data->addr >= data->end)
 			break;
 
-		ret = __kvm_pgtable_visit(data, ptep, level);
+		ret = __kvm_pgtable_visit(data, ptep, level, shared);
 		if (ret)
 			break;
 	}
@@ -273,7 +273,7 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 	return ret;
 }
 
-static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
+static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data, bool shared)
 {
 	u32 idx;
 	int ret = 0;
@@ -289,7 +289,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
 	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
 		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
 
-		ret = __kvm_pgtable_walk(data, ptep, pgt->start_level);
+		ret = __kvm_pgtable_walk(data, ptep, pgt->start_level, shared);
 		if (ret)
 			break;
 	}
@@ -298,7 +298,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
 }
 
 int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
-		     struct kvm_pgtable_walker *walker)
+		     struct kvm_pgtable_walker *walker, bool shared)
 {
 	struct kvm_pgtable_walk_data walk_data = {
 		.pgt	= pgt,
@@ -308,7 +308,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	};
 
 	kvm_pgtable_walk_begin();
-	return _kvm_pgtable_walk(&walk_data);
+	return _kvm_pgtable_walk(&walk_data, shared);
 	kvm_pgtable_walk_end();
 }
 
@@ -318,7 +318,7 @@ struct leaf_walk_data {
 };
 
 static int leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
-		       enum kvm_pgtable_walk_flags flag, void * const arg)
+		       enum kvm_pgtable_walk_flags flag, void * const arg, bool shared)
 {
 	struct leaf_walk_data *data = arg;
 
@@ -340,7 +340,7 @@ int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
 	int ret;
 
 	ret = kvm_pgtable_walk(pgt, ALIGN_DOWN(addr, PAGE_SIZE),
-			       PAGE_SIZE, &walker);
+			       PAGE_SIZE, &walker, false);
 	if (!ret) {
 		if (ptep)
 			*ptep  = data.pte;
@@ -409,7 +409,7 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
 }
 
 static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-				    kvm_pte_t old, struct hyp_map_data *data)
+				    kvm_pte_t old, struct hyp_map_data *data, bool shared)
 {
 	kvm_pte_t new;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
@@ -431,13 +431,13 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *pte
 }
 
 static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
-			  enum kvm_pgtable_walk_flags flag, void * const arg)
+			  enum kvm_pgtable_walk_flags flag, void * const arg, bool shared)
 {
 	kvm_pte_t *childp;
 	struct hyp_map_data *data = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
-	if (hyp_map_walker_try_leaf(addr, end, level, ptep, *old, arg))
+	if (hyp_map_walker_try_leaf(addr, end, level, ptep, *old, arg, shared))
 		return 0;
 
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
@@ -471,7 +471,7 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 	if (ret)
 		return ret;
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker, false);
 	dsb(ishst);
 	isb();
 	return ret;
@@ -483,7 +483,7 @@ struct hyp_unmap_data {
 };
 
 static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
-			    enum kvm_pgtable_walk_flags flag, void * const arg)
+			    enum kvm_pgtable_walk_flags flag, void * const arg, bool shared)
 {
 	kvm_pte_t *childp = NULL;
 	u64 granule = kvm_granule_size(level);
@@ -536,7 +536,7 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	if (!pgt->mm_ops->page_count)
 		return 0;
 
-	kvm_pgtable_walk(pgt, addr, size, &walker);
+	kvm_pgtable_walk(pgt, addr, size, &walker, false);
 	return unmap_data.unmapped;
 }
 
@@ -559,7 +559,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 }
 
 static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
-			   enum kvm_pgtable_walk_flags flag, void * const arg)
+			   enum kvm_pgtable_walk_flags flag, void * const arg, bool shared)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
 
@@ -582,7 +582,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 		.arg	= pgt->mm_ops,
 	};
 
-	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
+	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker, false));
 	pgt->mm_ops->put_page(pgt->pgd);
 	pgt->pgd = NULL;
 }
@@ -744,7 +744,8 @@ static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
 
 static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep, kvm_pte_t old,
-				      struct stage2_map_data *data)
+				      struct stage2_map_data *data,
+				      bool shared)
 {
 	kvm_pte_t new;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
@@ -790,7 +791,8 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 
 static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 				     kvm_pte_t *ptep, kvm_pte_t *old,
-				     struct stage2_map_data *data)
+				     struct stage2_map_data *data,
+				     bool shared)
 {
 	if (data->anchor)
 		return 0;
@@ -812,7 +814,7 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 }
 
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-				kvm_pte_t *old, struct stage2_map_data *data)
+				kvm_pte_t *old, struct stage2_map_data *data, bool shared)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 	kvm_pte_t *childp;
@@ -825,7 +827,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return 0;
 	}
 
-	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data);
+	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data, shared);
 	if (ret != -E2BIG)
 		return ret;
 
@@ -855,7 +857,8 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep, kvm_pte_t *old,
-				      struct stage2_map_data *data)
+				      struct stage2_map_data *data,
+				      bool shared)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 	kvm_pte_t *childp;
@@ -868,7 +871,7 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 		childp = data->childp;
 		data->anchor = NULL;
 		data->childp = NULL;
-		ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data);
+		ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared);
 	} else {
 		childp = kvm_pte_follow(*old, mm_ops);
 	}
@@ -899,17 +902,17 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
  * pointer and clearing the anchor to NULL.
  */
 static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
-			     enum kvm_pgtable_walk_flags flag, void * const arg)
+			     enum kvm_pgtable_walk_flags flag, void * const arg, bool shared)
 {
 	struct stage2_map_data *data = arg;
 
 	switch (flag) {
 	case KVM_PGTABLE_WALK_TABLE_PRE:
-		return stage2_map_walk_table_pre(addr, end, level, ptep, old, data);
+		return stage2_map_walk_table_pre(addr, end, level, ptep, old, data, shared);
 	case KVM_PGTABLE_WALK_LEAF:
-		return stage2_map_walk_leaf(addr, end, level, ptep, old, data);
+		return stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared);
 	case KVM_PGTABLE_WALK_TABLE_POST:
-		return stage2_map_walk_table_post(addr, end, level, ptep, old, data);
+		return stage2_map_walk_table_post(addr, end, level, ptep, old, data, shared);
 	}
 
 	return -EINVAL;
@@ -942,7 +945,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	if (ret)
 		return ret;
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker, false);
 	dsb(ishst);
 	return ret;
 }
@@ -970,13 +973,13 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	if (owner_id > KVM_MAX_OWNER_ID)
 		return -EINVAL;
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker, false);
 	return ret;
 }
 
 static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
-			       void * const arg)
+			       void * const arg, bool shared)
 {
 	struct kvm_pgtable *pgt = arg;
 	struct kvm_s2_mmu *mmu = pgt->mmu;
@@ -1026,7 +1029,7 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	return kvm_pgtable_walk(pgt, addr, size, &walker, false);
 }
 
 struct stage2_attr_data {
@@ -1039,7 +1042,7 @@ struct stage2_attr_data {
 
 static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			      kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
-			      void * const arg)
+			      void * const arg, bool shared)
 {
 	kvm_pte_t pte = *old;
 	struct stage2_attr_data *data = arg;
@@ -1091,7 +1094,7 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 		.flags		= KVM_PGTABLE_WALK_LEAF,
 	};
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker, false);
 	if (ret)
 		return ret;
 
@@ -1167,7 +1170,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 
 static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
-			       void * const arg)
+			       void * const arg, bool shared)
 {
 	struct kvm_pgtable *pgt = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
@@ -1192,7 +1195,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	if (stage2_has_fwb(pgt))
 		return 0;
 
-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	return kvm_pgtable_walk(pgt, addr, size, &walker, false);
 }
 
 
@@ -1226,7 +1229,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 
 static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			      kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
-			      void * const arg)
+			      void * const arg, bool shared)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
 
@@ -1251,7 +1254,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 		.arg	= pgt->mm_ops,
 	};
 
-	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
+	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker, false));
 	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
 	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
 	pgt->pgd = NULL;
-- 
2.36.0.rc0.470.gd361397f0d-goog

