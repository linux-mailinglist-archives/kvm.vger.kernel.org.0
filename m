Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5550969825F
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjBORk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjBORkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:40:55 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001A23A877
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:40:53 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52ed582a847so183456227b3.1
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sWExYb9W6cBTQECiD3NGjMpMAJyrLNehR8rTRyD8cZk=;
        b=Uk4JrvY03aYVgV6pGl+OkLpLEO/SztCIpH0GzoDc/Ity/iQfNoGGXaoQx1bPJJ4dHX
         7WAiNU+cYwHEChsp8J0JSm+eoKt30UPlYymFHtUUlpXkeCGRZQmF73MVIA7j/3kvc0uy
         sd01w05We1+Kb8nNrHWjq9O26dJaCWFwHAQa/VF+Ro7piSCSD8/jtpPE3i0jDq7GqXu2
         3RjRzvL6PH9WcRQsGRMAoOfp6V1lTQaISuMbY+xgrrOCefyK0xeYvtttquPO2dGGFrlx
         QUwN2ylDVgtES83TUSsbTx0mu6xm4m76iSry0pISh12wfQjlIGuWlR2m0sdSCu/40FZI
         C9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sWExYb9W6cBTQECiD3NGjMpMAJyrLNehR8rTRyD8cZk=;
        b=geRLfsfGIaLMSUm6i+blJmB1Tb7C3yGPKyBoQPbYkOEWZcqoCXnFl+G3zipA4Hc8Am
         X4s8iPkNGt+b2w+3tiNqBoYfFR9X0fUr4xQqiABW+T3UKqh2w480FnLBHHe9TejixEfg
         sMbI57S1mGogsNpsatA3x/h+6s0AlQmd80Z3nQ7jXXybYXwcmlVo8GiOcq+MnunuRBh9
         t3OuNurnI2oqvQf/ieXyHRhj5akJKRaSZMckUOvrfMW2P+vC5AF8e6z00bEvl2FwO76l
         tmNVKlN/lWDPgMBQxS580xTSz92Hf6T6n2zRMy2Zi9VljckNotBi9VTN2HMiXqjEShbO
         oFZg==
X-Gm-Message-State: AO0yUKWo4Nz4HlrFwpWoNGrBJfEDTs0FVyKNrFWQQOL9Oyzn3tLsWLiJ
        a/0uPGOQoa9ncsLeCE00Iho0z/2JcOPWCg==
X-Google-Smtp-Source: AK7set98gHuMPzIz8rj3tH23STvG3jXbUavndI9z9KYGfd+U1tKc9rJpUKduvfRy7CRiXZQg3GPvtoq2r3KtzA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:ad48:0:b0:52f:24ac:9575 with SMTP id
 l8-20020a81ad48000000b0052f24ac9575mr4ywk.3.1676482852799; Wed, 15 Feb 2023
 09:40:52 -0800 (PST)
Date:   Wed, 15 Feb 2023 17:40:36 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-3-ricarkol@google.com>
Subject: [PATCH v3 02/12] KVM: arm64: Rename free_unlinked to free_removed
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make it clearer that the "free_removed" functions refer to tables that
have never been part of the paging structure: they are "unlinked".

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  8 ++++----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++---
 arch/arm64/kvm/hyp/pgtable.c          |  6 +++---
 arch/arm64/kvm/mmu.c                  | 10 +++++-----
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 3339192a97a9..7c45082e6c23 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -99,7 +99,7 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
  *				allocation is physically contiguous.
  * @free_pages_exact:		Free an exact number of memory pages previously
  *				allocated by zalloc_pages_exact.
- * @free_removed_table:		Free a removed paging structure by unlinking and
+ * @free_unlinked_table:	Free an unlinked paging structure by unlinking and
  *				dropping references.
  * @get_page:			Increment the refcount on a page.
  * @put_page:			Decrement the refcount on a page. When the
@@ -119,7 +119,7 @@ struct kvm_pgtable_mm_ops {
 	void*		(*zalloc_page)(void *arg);
 	void*		(*zalloc_pages_exact)(size_t size);
 	void		(*free_pages_exact)(void *addr, size_t size);
-	void		(*free_removed_table)(void *addr, u32 level);
+	void		(*free_unlinked_table)(void *addr, u32 level);
 	void		(*get_page)(void *addr);
 	void		(*put_page)(void *addr);
 	int		(*page_count)(void *addr);
@@ -450,7 +450,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 
 /**
- * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
+ * kvm_pgtable_stage2_free_unlinked() - Free un unlinked stage-2 paging structure.
  * @mm_ops:	Memory management callbacks.
  * @pgtable:	Unlinked stage-2 paging structure to be freed.
  * @level:	Level of the stage-2 paging structure to be freed.
@@ -458,7 +458,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  * The page-table is assumed to be unreachable by any hardware walkers prior to
  * freeing and therefore no TLB invalidation is performed.
  */
-void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
+void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
 
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 552653fa18be..b030170d803b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -91,9 +91,9 @@ static void host_s2_put_page(void *addr)
 	hyp_put_page(&host_s2_pool, addr);
 }
 
-static void host_s2_free_removed_table(void *addr, u32 level)
+static void host_s2_free_unlinked_table(void *addr, u32 level)
 {
-	kvm_pgtable_stage2_free_removed(&host_mmu.mm_ops, addr, level);
+	kvm_pgtable_stage2_free_unlinked(&host_mmu.mm_ops, addr, level);
 }
 
 static int prepare_s2_pool(void *pgt_pool_base)
@@ -110,7 +110,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
 	host_mmu.mm_ops = (struct kvm_pgtable_mm_ops) {
 		.zalloc_pages_exact = host_s2_zalloc_pages_exact,
 		.zalloc_page = host_s2_zalloc_page,
-		.free_removed_table = host_s2_free_removed_table,
+		.free_unlinked_table = host_s2_free_unlinked_table,
 		.phys_to_virt = hyp_phys_to_virt,
 		.virt_to_phys = hyp_virt_to_phys,
 		.page_count = hyp_page_count,
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index e093e222daf3..0a5ef9288371 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -841,7 +841,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 	if (ret)
 		return ret;
 
-	mm_ops->free_removed_table(childp, ctx->level);
+	mm_ops->free_unlinked_table(childp, ctx->level);
 	return 0;
 }
 
@@ -886,7 +886,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
  * The TABLE_PRE callback runs for table entries on the way down, looking
  * for table entries which we could conceivably replace with a block entry
  * for this mapping. If it finds one it replaces the entry and calls
- * kvm_pgtable_mm_ops::free_removed_table() to tear down the detached table.
+ * kvm_pgtable_mm_ops::free_unlinked_table() to tear down the detached table.
  *
  * Otherwise, the LEAF callback performs the mapping at the existing leaves
  * instead.
@@ -1250,7 +1250,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	pgt->pgd = NULL;
 }
 
-void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
+void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
 {
 	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
 	struct kvm_pgtable_walker walker = {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a3ee3b605c9b..9bd3c2cfb476 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -130,21 +130,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
 
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
 
-static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
+static void stage2_free_unlinked_table_rcu_cb(struct rcu_head *head)
 {
 	struct page *page = container_of(head, struct page, rcu_head);
 	void *pgtable = page_to_virt(page);
 	u32 level = page_private(page);
 
-	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, pgtable, level);
+	kvm_pgtable_stage2_free_unlinked(&kvm_s2_mm_ops, pgtable, level);
 }
 
-static void stage2_free_removed_table(void *addr, u32 level)
+static void stage2_free_unlinked_table(void *addr, u32 level)
 {
 	struct page *page = virt_to_page(addr);
 
 	set_page_private(page, (unsigned long)level);
-	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
+	call_rcu(&page->rcu_head, stage2_free_unlinked_table_rcu_cb);
 }
 
 static void kvm_host_get_page(void *addr)
@@ -681,7 +681,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
 	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
 	.free_pages_exact	= kvm_s2_free_pages_exact,
-	.free_removed_table	= stage2_free_removed_table,
+	.free_unlinked_table	= stage2_free_unlinked_table,
 	.get_page		= kvm_host_get_page,
 	.put_page		= kvm_s2_put_page,
 	.page_count		= kvm_host_page_count,
-- 
2.39.1.637.g21b0678d19-goog

