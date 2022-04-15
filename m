Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659285031BA
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355427AbiDOWBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244037AbiDOWBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:41 -0400
Received: from mail-oo1-xc4a.google.com (mail-oo1-xc4a.google.com [IPv6:2607:f8b0:4864:20::c4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E02381B5
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:11 -0700 (PDT)
Received: by mail-oo1-xc4a.google.com with SMTP id g18-20020a4a6b12000000b003246ed86f00so4838933ooc.23
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=33zitZnypC/5iqOPd40oIiPlXIxM1MYIm9nWTEFWX9o=;
        b=VeV72ZOKUV0992/61pLhySJu6tUdMC93GGMiIqLb9e42oF03C+E2MC6P0USn6WlWZL
         rRNNBiXDbdfTk5SekJB4zDXKX5HZQcP9L/L90QZ9Q75Zs43P4FnxEdhX0e9NjQNL70sv
         2OPflS3JXbC6xVrB8AYJnRT4D6TEDtD80e3gDO4GetEaSf95eT3DYLJKy2GdkEoTECwt
         kBvgRBy6BE0rZ3f1wCMtyh7VurS1pRhhSYr6eZEbOvHISaR8hy4G1UMIcnlc/RFerVBo
         oXY5ygxtXok6qpcxi+MJT9/FZJVx/Zmp7+6uAsJiQSmMLB6jJ6cMJW4AyoLAa7e0QIHR
         F2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=33zitZnypC/5iqOPd40oIiPlXIxM1MYIm9nWTEFWX9o=;
        b=be+PQ91cqdDs0ByBGK7l9fakSORx8Vs/lcRCa5sW0Uod3Ud2Q8TgEVmTTRqGe04Oq8
         TyggKPMV++ppmieGyY58sGlYkKUT/j/7uxxHA5nLRhDkhUozMydZkjt45545dC4w7uwg
         4HWk5IVrDiDAxvyVnVZLctobfDtTT1hoThr4LU5/K5etFF1U6bwsIunAQ9PBilhjQRwf
         CGm67navucov36TMTXBqOOvoyZ8ueBltJnAzvbBkT2w3IYNZ6Wds70k48et78Jqlx95l
         YS3BkivqoWhCV+mUZ7em48BuFoOzjfCU+b9iRBB9Ysf9LIU6xPSyksaoVEgFJwNRuYr/
         GWFg==
X-Gm-Message-State: AOAM531chp+BhwOiKbygZyg+Qz9QXnjGVHPoCVc/4SV4qork6vznP56P
        vK3nxcq+pmPg2ueGYe8UOiI+3TEKs3c=
X-Google-Smtp-Source: ABdhPJzWYiHch/fvnCe1iFtXCe45SXo8QvSqLvIYoF5WCPSgovlAS0bf0qoZ0Uk3C+rcWH/OsMMHHUvyqdM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6870:f29a:b0:de:eaa4:233a with SMTP id
 u26-20020a056870f29a00b000deeaa4233amr354373oap.137.1650059950378; Fri, 15
 Apr 2022 14:59:10 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:46 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-3-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 02/17] KVM: arm64: Only read the pte once per visit
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
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A subsequent change to KVM will parallize modifications to the stage-2
page tables. The various page table walkers read the ptep multiple
times, which could lead to a visitor seeing multiple values during the
visit.

Pass through the observed pte to the visitor callbacks. Promote reads of
the ptep to a full READ_ONCE(), which will matter more when we start
tweaking ptes atomically. Note that a pointer to the old pte is given to
visitors, as parallel visitors will need to steer the page table
traversal as they adjust the page tables.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  |   2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |   7 +-
 arch/arm64/kvm/hyp/nvhe/setup.c       |   9 +-
 arch/arm64/kvm/hyp/pgtable.c          | 113 +++++++++++++-------------
 4 files changed, 63 insertions(+), 68 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 9f339dffbc1a..ea818a5f7408 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -192,7 +192,7 @@ enum kvm_pgtable_walk_flags {
 };
 
 typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
-					kvm_pte_t *ptep,
+					kvm_pte_t *ptep, kvm_pte_t *old,
 					enum kvm_pgtable_walk_flags flag,
 					void * const arg);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 78edf077fa3b..601a586581d8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -422,17 +422,16 @@ struct check_walk_data {
 };
 
 static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
-				      kvm_pte_t *ptep,
+				      kvm_pte_t *ptep, kvm_pte_t *old,
 				      enum kvm_pgtable_walk_flags flag,
 				      void * const arg)
 {
 	struct check_walk_data *d = arg;
-	kvm_pte_t pte = *ptep;
 
-	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
+	if (kvm_pte_valid(*old) && !addr_is_memory(kvm_pte_to_phys(*old)))
 		return -EINVAL;
 
-	return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
+	return d->get_page_state(*old) == d->desired ? 0 : -EPERM;
 }
 
 static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 27af337f9fea..ecab7a4049d6 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -162,17 +162,16 @@ static void hpool_put_page(void *addr)
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
 	phys_addr_t phys;
 
-	if (!kvm_pte_valid(pte))
+	if (!kvm_pte_valid(*old))
 		return 0;
 
 	/*
@@ -187,7 +186,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
-	phys = kvm_pte_to_phys(pte);
+	phys = kvm_pte_to_phys(*old);
 	if (!addr_is_memory(phys))
 		return -EINVAL;
 
@@ -195,7 +194,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	 * Adjust the host stage-2 mappings to match the ownership attributes
 	 * configured in the hypervisor stage-1.
 	 */
-	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
+	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(*old));
 	switch (state) {
 	case PKVM_PAGE_OWNED:
 		return host_stage2_set_owner_locked(phys, PAGE_SIZE, pkvm_hyp_id);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index e1506da3e2fb..ad911cd44425 100644
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
+	kvm_pte_t *childp, pte = READ_ONCE(*ptep);
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
@@ -461,19 +461,19 @@ struct hyp_unmap_data {
 	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
-static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
 			    enum kvm_pgtable_walk_flags flag, void * const arg)
 {
-	kvm_pte_t pte = *ptep, *childp = NULL;
+	kvm_pte_t *childp = NULL;
 	u64 granule = kvm_granule_size(level);
 	struct hyp_unmap_data *data = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
 
-	if (!kvm_pte_valid(pte))
+	if (!kvm_pte_valid(*old))
 		return -EINVAL;
 
-	if (kvm_pte_table(pte, level)) {
-		childp = kvm_pte_follow(pte, mm_ops);
+	if (kvm_pte_table(*old, level)) {
+		childp = kvm_pte_follow(*old, mm_ops);
 
 		if (mm_ops->page_count(childp) != 1)
 			return 0;
@@ -537,19 +537,18 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 	return 0;
 }
 
-static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte_t *old,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
-	kvm_pte_t pte = *ptep;
 
-	if (!kvm_pte_valid(pte))
+	if (!kvm_pte_valid(*old))
 		return 0;
 
 	mm_ops->put_page(ptep);
 
-	if (kvm_pte_table(pte, level))
-		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
+	if (kvm_pte_table(*old, level))
+		mm_ops->put_page(kvm_pte_follow(*old, mm_ops));
 
 	return 0;
 }
@@ -723,10 +722,10 @@ static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
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
@@ -769,7 +768,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 }
 
 static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
-				     kvm_pte_t *ptep,
+				     kvm_pte_t *ptep, kvm_pte_t *old,
 				     struct stage2_map_data *data)
 {
 	if (data->anchor)
@@ -778,7 +777,7 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
 		return 0;
 
-	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
+	data->childp = kvm_pte_follow(*old, data->mm_ops);
 	kvm_clear_pte(ptep);
 
 	/*
@@ -792,20 +791,20 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 }
 
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-				struct stage2_map_data *data)
+				kvm_pte_t *old, struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
-	kvm_pte_t *childp, pte = *ptep;
+	kvm_pte_t *childp;
 	int ret;
 
 	if (data->anchor) {
-		if (stage2_pte_is_counted(pte))
+		if (stage2_pte_is_counted(*old))
 			mm_ops->put_page(ptep);
 
 		return 0;
 	}
 
-	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, data);
+	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data);
 	if (ret != -E2BIG)
 		return ret;
 
@@ -824,7 +823,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * a table. Accesses beyond 'end' that fall within the new table
 	 * will be mapped lazily.
 	 */
-	if (stage2_pte_is_counted(pte))
+	if (stage2_pte_is_counted(*old))
 		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
 
 	kvm_set_table_pte(ptep, childp, mm_ops);
@@ -834,7 +833,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 }
 
 static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
-				      kvm_pte_t *ptep,
+				      kvm_pte_t *ptep, kvm_pte_t *old,
 				      struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
@@ -848,9 +847,9 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 		childp = data->childp;
 		data->anchor = NULL;
 		data->childp = NULL;
-		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
+		ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data);
 	} else {
-		childp = kvm_pte_follow(*ptep, mm_ops);
+		childp = kvm_pte_follow(*old, mm_ops);
 	}
 
 	mm_ops->put_page(childp);
@@ -878,18 +877,18 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
  * the page-table, installing the block entry when it revisits the anchor
  * pointer and clearing the anchor to NULL.
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
 	case KVM_PGTABLE_WALK_TABLE_POST:
-		return stage2_map_walk_table_post(addr, end, level, ptep, data);
+		return stage2_map_walk_table_post(addr, end, level, ptep, old, data);
 	}
 
 	return -EINVAL;
@@ -955,29 +954,29 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
+	kvm_pte_t *childp = NULL;
 	bool need_flush = false;
 
-	if (!kvm_pte_valid(pte)) {
-		if (stage2_pte_is_counted(pte)) {
+	if (!kvm_pte_valid(*old)) {
+		if (stage2_pte_is_counted(*old)) {
 			kvm_clear_pte(ptep);
 			mm_ops->put_page(ptep);
 		}
 		return 0;
 	}
 
-	if (kvm_pte_table(pte, level)) {
-		childp = kvm_pte_follow(pte, mm_ops);
+	if (kvm_pte_table(*old, level)) {
+		childp = kvm_pte_follow(*old, mm_ops);
 
 		if (mm_ops->page_count(childp) != 1)
 			return 0;
-	} else if (stage2_pte_cacheable(pgt, pte)) {
+	} else if (stage2_pte_cacheable(pgt, *old)) {
 		need_flush = !stage2_has_fwb(pgt);
 	}
 
@@ -989,7 +988,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	stage2_put_pte(ptep, mmu, addr, level, mm_ops);
 
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
-		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(*old, mm_ops),
 					       kvm_granule_size(level));
 
 	if (childp)
@@ -1018,10 +1017,10 @@ struct stage2_attr_data {
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
 
@@ -1146,18 +1145,17 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 }
 
 static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			       enum kvm_pgtable_walk_flags flag,
+			       kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
 	struct kvm_pgtable *pgt = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
-	kvm_pte_t pte = *ptep;
 
-	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
+	if (!kvm_pte_valid(*old) || !stage2_pte_cacheable(pgt, *old))
 		return 0;
 
 	if (mm_ops->dcache_clean_inval_poc)
-		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(*old, mm_ops),
 					       kvm_granule_size(level));
 	return 0;
 }
@@ -1206,19 +1204,18 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 }
 
 static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-			      enum kvm_pgtable_walk_flags flag,
+			      kvm_pte_t *old, enum kvm_pgtable_walk_flags flag,
 			      void * const arg)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
-	kvm_pte_t pte = *ptep;
 
-	if (!stage2_pte_is_counted(pte))
+	if (!stage2_pte_is_counted(*old))
 		return 0;
 
 	mm_ops->put_page(ptep);
 
-	if (kvm_pte_table(pte, level))
-		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
+	if (kvm_pte_table(*old, level))
+		mm_ops->put_page(kvm_pte_follow(*old, mm_ops));
 
 	return 0;
 }
-- 
2.36.0.rc0.470.gd361397f0d-goog

