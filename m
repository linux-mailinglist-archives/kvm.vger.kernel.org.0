Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF8C68C402
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 17:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjBFQ7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 11:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjBFQ7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 11:59:02 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25400298DA
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 08:59:01 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id h126-20020a636c84000000b004d31ad79086so5440280pgc.23
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 08:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sycVjS/8vH1Yip3OrT5l3m3XOZFV09Y6IZ3loHvAqI0=;
        b=M2XimBj4AZUXOOI9YyAUluFWLJlskgmE+P0t5KNuwcUgUlCHGGtb/ammqMGFXzxscw
         Kyf8o1Le8kL706wk8+YzwI8iOnzoneMjzqtyKcOtn6U0P1O5Ej9PKa0T5M7k2VOJy1FY
         4kTpEssoNSlYqvU+mVqse5RSZVjqhQoYK4EijNtDAOtLyzqgswtFv7cAB2ilh5kVH9KU
         yOepw04fgSu7PmaeRSn9YuoCOaW0JVDXZkPYrshYlvnmyX/ETkGIlyKgFunxVo8aKPrS
         VLjtOvnZuuCrtRbhURreDAalO3SFQjqY4HRas/JYYOjZ7s1CC6iIe9wtG42LEtD6s4eq
         HgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sycVjS/8vH1Yip3OrT5l3m3XOZFV09Y6IZ3loHvAqI0=;
        b=nHrhy/eSSxK8Wd7KQ9rGLF0mQx9Txe32XNWyHYYzwQ2egWiaOkOrF8rdNHlBKeIyYk
         69Alrnj7tX0nLoW3/23Gdv6gSorrl3GpCGvZd/KVX5LMAWM7sQKMOIDW8wzdPZ5buzZD
         OPKNTt746KXQ5U6KgWilzoZOLe7CTRbQdF4fQg58lziSfL14wb+y6GEpgxDzgDY38qea
         daxpvjaV/uCFZP16ATUTt+qVDmCjrKWkbuEquM6mszXW6/TOa0+EV5+E/0RHEonmySvX
         2dZ9WsFxqzQBnFN3vo0RlDzy/ecaW6ddXOy62fXjcwQnqWHI9A9OnmJNaUdop0FOwLcS
         rHZA==
X-Gm-Message-State: AO0yUKWG4Vj1XbIeZUUbf04fvFKDE/KUT09Q3TSMPNuM1UqHhEPDVz0A
        Z4JATTecBygrFxJM1fzZE4is48l1KFNvFg==
X-Google-Smtp-Source: AK7set+vQXUrlZln3lkRbxF3dLJN90KsXVlnVSvAcGMPqFcONmeiLN0CaAeVKDi0CJUMtYsvCwUOnO4fFFSbMg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e545:b0:199:1458:6c67 with SMTP
 id n5-20020a170902e54500b0019914586c67mr1058514plf.28.1675702740582; Mon, 06
 Feb 2023 08:59:00 -0800 (PST)
Date:   Mon,  6 Feb 2023 16:58:43 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-5-ricarkol@google.com>
Subject: [PATCH v2 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
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

Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
range of huge pages. This will be used for eager-splitting huge pages
into PAGE_SIZE pages. The goal is to avoid having to split huge pages
on write-protection faults, and instead use this function to do it
ahead of time for large ranges (e.g., all guest memory in 1G chunks at
a time).

No functional change intended. This new function will be used in a
subsequent commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  30 ++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 105 +++++++++++++++++++++++++++
 2 files changed, 135 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index e94c92988745..871c4eeb0184 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -658,6 +658,36 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
  */
 int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
+/**
+ * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
+ *				to PAGE_SIZE guest pages.
+ * @pgt:	 Page-table structure initialised by kvm_pgtable_stage2_init().
+ * @addr:	 Intermediate physical address from which to split.
+ * @size:	 Size of the range.
+ * @mc:		 Cache of pre-allocated and zeroed memory from which to allocate
+ *		 page-table pages.
+ * @mc_capacity: Number of pages in @mc.
+ *
+ * @addr and the end (@addr + @size) are effectively aligned down and up to
+ * the top level huge-page block size. This is an example using 1GB
+ * huge-pages and 4KB granules.
+ *
+ *                          [---input range---]
+ *                          :                 :
+ * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
+ *                          :                 :
+ *                   [--2MB--][--2MB--][--2MB--][--2MB--]
+ *                          :                 :
+ *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
+ *                          :                 :
+ *
+ * Return: 0 on success, negative error code on failure. Note that
+ * kvm_pgtable_stage2_split() is best effort: it tries to break as many
+ * blocks in the input range as allowed by @mc_capacity.
+ */
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			     void *mc, u64 mc_capacity);
+
 /**
  * kvm_pgtable_walk() - Walk a page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index fed314f2b320..ae80845c8db7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1229,6 +1229,111 @@ int kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
 	return 0;
 }
 
+struct stage2_split_data {
+	struct kvm_s2_mmu		*mmu;
+	void				*memcache;
+	u64				mc_capacity;
+};
+
+/*
+ * Get the number of page-tables needed to replace a bock with a fully
+ * populated tree, up to the PTE level, at particular level.
+ */
+static inline u32 stage2_block_get_nr_page_tables(u32 level)
+{
+	switch (level) {
+	/* There are no blocks at level 0 */
+	case 1: return 1 + PTRS_PER_PTE;
+	case 2: return 1;
+	case 3: return 0;
+	default:
+		WARN_ON_ONCE(1);
+		return ~0;
+	}
+}
+
+static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			       enum kvm_pgtable_walk_flags visit)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	struct stage2_split_data *data = ctx->arg;
+	kvm_pte_t pte = ctx->old, new, *childp;
+	enum kvm_pgtable_prot prot;
+	void *mc = data->memcache;
+	u32 level = ctx->level;
+	u64 phys, nr_pages;
+	bool force_pte;
+	int ret;
+
+	/* No huge-pages exist at the last level */
+	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
+		return 0;
+
+	/* We only split valid block mappings */
+	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
+		return 0;
+
+	nr_pages = stage2_block_get_nr_page_tables(level);
+	if (data->mc_capacity >= nr_pages) {
+		/* Build a tree mapped down to the PTE granularity. */
+		force_pte = true;
+	} else {
+		/*
+		 * Don't force PTEs. This requires a single page of PMDs at the
+		 * PUD level, or a single page of PTEs at the PMD level. If we
+		 * are at the PUD level, the PTEs will be created recursively.
+		 */
+		force_pte = false;
+		nr_pages = 1;
+	}
+
+	if (data->mc_capacity < nr_pages)
+		return -ENOMEM;
+
+	phys = kvm_pte_to_phys(pte);
+	prot = kvm_pgtable_stage2_pte_prot(pte);
+
+	ret = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, &new, phys,
+						 level, prot, mc, force_pte);
+	if (ret)
+		return ret;
+
+	if (!stage2_try_break_pte(ctx, data->mmu)) {
+		childp = kvm_pte_follow(new, mm_ops);
+		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
+		mm_ops->put_page(childp);
+		return -EAGAIN;
+	}
+
+	/*
+	 * Note, the contents of the page table are guaranteed to be made
+	 * visible before the new PTE is assigned because stage2_make_pte()
+	 * writes the PTE using smp_store_release().
+	 */
+	stage2_make_pte(ctx, new);
+	dsb(ishst);
+	data->mc_capacity -= nr_pages;
+	return 0;
+}
+
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			     void *mc, u64 mc_capacity)
+{
+	struct stage2_split_data split_data = {
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+		.mc_capacity	= mc_capacity,
+	};
+
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_split_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &split_data,
+	};
+
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
+}
+
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
 			      enum kvm_pgtable_stage2_flags flags,
-- 
2.39.1.519.gcb327c4b5f-goog

