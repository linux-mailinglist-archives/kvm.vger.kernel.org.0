Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DC46A75E6
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjCAVJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCAVJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:09:36 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3964AFF6
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 13:09:35 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536a4eba107so293241857b3.19
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 13:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VzIyQySx5sWgoLBKBraq0PBD+mNgK07WEx+j6MVzqPM=;
        b=fJSfK1i4WA7O+rhUUrcur7zN//1Q2TYfP++kVyMePa8X3MKpgHn9f2vhnTpPMjWRMF
         CLkyRV4kv0vWqNd6TGly5t6cluezCp5iqyy6kfoZ5MNhoqniGYTRLXwLcHB3+1bqGbg8
         +T9MU3Vw0ogu30e7okI/c1GHhoitQxsgGTv/FGVDMpiDMcOxFDncIQuTNjzqk+3jXcqz
         mqkx5sxL8+M4wzlhLdzTDKte6+JW99WVunEJUUGDP4+Ocit73z4/mnInak6WumrY5NHV
         C2yFJ60kA1ZoD8r55B4XPtRbBijvK6jm4yVlTPdknH+MQB12tqeyCImLOAJ7ilv6Qe57
         elCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VzIyQySx5sWgoLBKBraq0PBD+mNgK07WEx+j6MVzqPM=;
        b=iMSCc4Cj8AE5ovLe+BkoGJ8M19pV+nHvk25O8MCjVvyszritqDjwmD0wB5GhVk07vi
         yWB7360VfTbAawIUIsP48IEeZgAZ6vriarMWX3RV+n691WC4HWCfxH1WZARe5Qo6ky5o
         Dwsz4sPrNlK0pArozDmwl7doKbrH16512O7uWU3ZoGi1xOeajD+Wj+3NFPhVhkoaocAA
         yeEKnee/oGIWkLalQPqME8hlJ8BYY7CsvPof89D4VVosIIp4IHecTF5v8Bs8sKJKgYrd
         z06uUZrE+TKY2jgFk5Xw7EEatZkWtYQhP2V+5g4A0BhzRFIlqR6bW/4hmGv6wY1HGqw1
         OsJw==
X-Gm-Message-State: AO0yUKWTsYCSlJKvLzF5zaME25Dzf9EFxY5vdcghUkOAvPFBy0F3p1A+
        nszUw7jjwaMDTg1lnkcN4oJM6IZbOaw1ow==
X-Google-Smtp-Source: AK7set+U/GHrK922XxR7lZ6/5QF7NSwHYfRHSugXKbr3gq2VSnqUgzH/QvSpXE8keLEtLhkmc3S+49W/5FJ8PQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:8b:0:b0:8bb:dfe8:a33b with SMTP id
 b11-20020a5b008b000000b008bbdfe8a33bmr4245653ybp.9.1677704974687; Wed, 01 Mar
 2023 13:09:34 -0800 (PST)
Date:   Wed,  1 Mar 2023 21:09:18 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-3-ricarkol@google.com>
Subject: [PATCH v5 02/12] KVM: arm64: Rename free_unlinked to free_removed
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
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

Normalize on referring to tables outside of an active paging structure
as 'unlinked'.

A subsequent change to KVM will add support for building page tables
that are not part of an active paging structure. The existing
'removed_table' terminology is quite clunky when applied in this
context.

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  8 ++++----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++---
 arch/arm64/kvm/hyp/pgtable.c          |  6 +++---
 arch/arm64/kvm/mmu.c                  | 10 +++++-----
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 252b651f743d..dcd3aafd3e6c 100644
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
+ * kvm_pgtable_stage2_free_unlinked() - Free an unlinked stage-2 paging structure.
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
2.39.2.722.g9855ee24e9-goog

