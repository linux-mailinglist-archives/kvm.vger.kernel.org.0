Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF4B6DBEDD
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 08:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjDIGaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 02:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDIGaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 02:30:07 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0224044BD
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 23:30:06 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54be7584b28so144050557b3.16
        for <kvm@vger.kernel.org>; Sat, 08 Apr 2023 23:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021805; x=1683613805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l91z4IN5ufM+bjM+mAjwB0x8oHq8/73erY5LUhWtzxk=;
        b=bXAcqrs8mtmwYzPDKpB4lwFcpn+14SbEYJcteXMYSFk/1oTh8INI3WLxp6Xwi7v5XE
         tdOxWWKWC9RUMvMOatmnHUe5bEmHElAKbq5NMHsPP8MNQG4gNG5haLlWe+S9pshc1t8C
         2YW5YdcluFNCil1czb2vDVmaa9w4CvXIcjmtSYligfuKuSdw7tXwxWIG2922CsN304Ev
         Y+vnnxk8mCGxyvPuIMDYLWGHOkTFg6JTy2jUrVK1Pb1oE6nRwSy29mHXk1kEHUSSRb9+
         gYkwRFBp1mN0N5C5w+yF8NGStpZXEripxX+3L35lUMieqJA3WGIKjeR1dEf+twTvgR2g
         wYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021805; x=1683613805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l91z4IN5ufM+bjM+mAjwB0x8oHq8/73erY5LUhWtzxk=;
        b=iY77X6lGei9m27V0+htpaDcU9bhYB+i63GjQPwRpd9IqqI7BCV3nEsfjLAP/7Eu03s
         Fpx9xrAB5WNNjzAc0CCBT5mHELlkhILzBvqKs3OZ8tWw20t7Fi4V38mxRVgBMassSOMG
         8XD9N7C4q+nNtcaBt2UJkZoMvUJiRf4CW1DJSKGieTn3zmnGPg3go7Mrg+n6lBjDPOIg
         TQXlMNpWguJic3V0lDJSKFHCT2/m4b4HbElV9RhtnSJ+5PqNLq0koqB57d36Nxh828i8
         dktj/uwuFdvuj6AAEz6GGq3Wb7xgvUhnibRCGZxBGEJTszuYW8qeRfwOD3hi5dhyEZu0
         pHrA==
X-Gm-Message-State: AAQBX9cRi8gjDeg8XoyueiK98BLosu9fJF++t2YyliEOjC8YNtQ9JuLH
        EQ542ee36cDvBr8Uahl3iQebcRb4OwlBfA==
X-Google-Smtp-Source: AKy350ahseVKGzvcIva6jK2DW8bFMq0WEBxDc2aRi1TCZxznLHpTmAa1afX2FezqZ+sKo05mk6cEYQv+dFXGIQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:f40f:0:b0:b8d:1cb:5ba6 with SMTP id
 q15-20020a25f40f000000b00b8d01cb5ba6mr4158785ybd.5.1681021805203; Sat, 08 Apr
 2023 23:30:05 -0700 (PDT)
Date:   Sun,  9 Apr 2023 06:29:48 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-2-ricarkol@google.com>
Subject: [PATCH v7 01/12] KVM: arm64: Rename free_removed to free_unlinked
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  8 ++++----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++---
 arch/arm64/kvm/hyp/pgtable.c          |  6 +++---
 arch/arm64/kvm/mmu.c                  | 10 +++++-----
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4cd6762bda805..26a4293726c14 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -104,7 +104,7 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
  *				allocation is physically contiguous.
  * @free_pages_exact:		Free an exact number of memory pages previously
  *				allocated by zalloc_pages_exact.
- * @free_removed_table:		Free a removed paging structure by unlinking and
+ * @free_unlinked_table:	Free an unlinked paging structure by unlinking and
  *				dropping references.
  * @get_page:			Increment the refcount on a page.
  * @put_page:			Decrement the refcount on a page. When the
@@ -124,7 +124,7 @@ struct kvm_pgtable_mm_ops {
 	void*		(*zalloc_page)(void *arg);
 	void*		(*zalloc_pages_exact)(size_t size);
 	void		(*free_pages_exact)(void *addr, size_t size);
-	void		(*free_removed_table)(void *addr, u32 level);
+	void		(*free_unlinked_table)(void *addr, u32 level);
 	void		(*get_page)(void *addr);
 	void		(*put_page)(void *addr);
 	int		(*page_count)(void *addr);
@@ -440,7 +440,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 
 /**
- * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
+ * kvm_pgtable_stage2_free_unlinked() - Free an unlinked stage-2 paging structure.
  * @mm_ops:	Memory management callbacks.
  * @pgtable:	Unlinked stage-2 paging structure to be freed.
  * @level:	Level of the stage-2 paging structure to be freed.
@@ -448,7 +448,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  * The page-table is assumed to be unreachable by any hardware walkers prior to
  * freeing and therefore no TLB invalidation is performed.
  */
-void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
+void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
 
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 552653fa18be3..b030170d803b6 100644
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
index 3d61bd3e591d2..a3246d6cddec7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -860,7 +860,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 	if (ret)
 		return ret;
 
-	mm_ops->free_removed_table(childp, ctx->level);
+	mm_ops->free_unlinked_table(childp, ctx->level);
 	return 0;
 }
 
@@ -905,7 +905,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
  * The TABLE_PRE callback runs for table entries on the way down, looking
  * for table entries which we could conceivably replace with a block entry
  * for this mapping. If it finds one it replaces the entry and calls
- * kvm_pgtable_mm_ops::free_removed_table() to tear down the detached table.
+ * kvm_pgtable_mm_ops::free_unlinked_table() to tear down the detached table.
  *
  * Otherwise, the LEAF callback performs the mapping at the existing leaves
  * instead.
@@ -1276,7 +1276,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	pgt->pgd = NULL;
 }
 
-void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
+void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
 {
 	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
 	struct kvm_pgtable_walker walker = {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ffe..efdaab3f154de 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -131,21 +131,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
 
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
@@ -682,7 +682,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
 	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
 	.free_pages_exact	= kvm_s2_free_pages_exact,
-	.free_removed_table	= stage2_free_removed_table,
+	.free_unlinked_table	= stage2_free_unlinked_table,
 	.get_page		= kvm_host_get_page,
 	.put_page		= kvm_s2_put_page,
 	.page_count		= kvm_host_page_count,
-- 
2.40.0.577.gac1e443424-goog

