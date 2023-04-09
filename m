Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15036DBEE1
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 08:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjDIGaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 02:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDIGaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 02:30:13 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955E85FD0
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 23:30:12 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id k1-20020a17090a3e8100b002466844d0f7so464072pjc.1
        for <kvm@vger.kernel.org>; Sat, 08 Apr 2023 23:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021812; x=1683613812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jHSOQtpF+8CEIj7dmYuF7IiDG+OzLJL4o7R1ylB7bTA=;
        b=f1g2bJx9xVVqi3zCXcNMcdDw4UZMJNbLNzL0sL52AI/BjHkPtPCKKkpk/bReQiEli8
         Hl9Z3J9ivkiTR9I52xoXkstGfCagVyJBj01NnUVpFo1YKT7Jw6udU7un4dKPyqofDFWc
         286rwhhNnl5SaYSjAOqIXNs3Bau5E1fo8qe/jr+QO9kUEJAFWwLdrKqObUofSvsxwa/4
         0vFaLdWv5iewGBb9finz5skBtDa5hk9r977g1F6fe3ipgX4hV9jiWOkN+Z3r42B1HiU/
         R3Iwxk2rZ+lW6W7a9PUffepjnR4g/pUBzBIkn8u3zppR/HAtx6bl2d7ANcBRUSSS0XWI
         js4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021812; x=1683613812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jHSOQtpF+8CEIj7dmYuF7IiDG+OzLJL4o7R1ylB7bTA=;
        b=4AEaWBynYtr2+LhBtfX53XB1oD5L8wV2+xtAuZdvbE9mSqqFaJpYpR9QXyHreQWYlt
         NDulH494ISTkfyClcKnF9jYfSsR6houzLAW0dGdr8YC21x6HTKCXsOv4+1LAbhf/wmSc
         cRd/Ytc0AXkGGBFbLQg8NMEqJcO1MER8a596nB3SBGazgNKl8tShp37huT1B/gHpjMCz
         X8Rf9nYcH0AWYFt5yf0zN9lPM6IzCNs9zNzacJTTpWhYrzCJzhbu4DlRmaCnJj5A8cYs
         7ozKczPOT3CnoJLyYbnmh3M5CRq12APujg5RX6wVv6xPl8IJDvXwK5zHtIUXR3h6DCKM
         cLUA==
X-Gm-Message-State: AAQBX9cqXFT/GMLS1H75D1WD9Ih+fG0WDh5FPHwfFRuhjo77WBOuBTrC
        Lj8ZB0R1HzD5isfcT5PHkzgyhIk0TWyFcQ==
X-Google-Smtp-Source: AKy350bbP9c03zEX6O5B5zFHci6VgXEUrqlzERYw3T9iiynyjoVOqKfL6v9RXFCjs+rXiOKQ8qHRCD0LMvNw7Q==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:498e:b0:246:7eb4:781e with SMTP
 id d14-20020a17090a498e00b002467eb4781emr654820pjh.9.1681021812107; Sat, 08
 Apr 2023 23:30:12 -0700 (PDT)
Date:   Sun,  9 Apr 2023 06:29:52 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-6-ricarkol@google.com>
Subject: [PATCH v7 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
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

Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
range of huge pages. This will be used for eager-splitting huge pages
into PAGE_SIZE pages. The goal is to avoid having to split huge pages
on write-protection faults, and instead use this function to do it
ahead of time for large ranges (e.g., all guest memory in 1G chunks at
a time).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  19 +++++
 arch/arm64/kvm/hyp/pgtable.c         | 103 +++++++++++++++++++++++++++
 2 files changed, 122 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c8e0e7d9303b2..32e5d42bf020f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -653,6 +653,25 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
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
+ *
+ * The function tries to split any level 1 or 2 entry that overlaps
+ * with the input range (given by @addr and @size).
+ *
+ * Return: 0 on success, negative error code on failure. Note that
+ * kvm_pgtable_stage2_split() is best effort: it tries to break as many
+ * blocks in the input range as allowed by @mc_capacity.
+ */
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			     struct kvm_mmu_memory_cache *mc);
+
 /**
  * kvm_pgtable_walk() - Walk a page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 477d2be67d401..48c5a95c6e8cd 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1272,6 +1272,109 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
 	return pgtable;
 }
 
+/*
+ * Get the number of page-tables needed to replace a block with a
+ * fully populated tree up to the PTE entries. Note that @level is
+ * interpreted as in "level @level entry".
+ */
+static int stage2_block_get_nr_page_tables(u32 level)
+{
+	switch (level) {
+	case 1:
+		return PTRS_PER_PTE + 1;
+	case 2:
+		return 1;
+	case 3:
+		return 0;
+	default:
+		WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
+			     level >= KVM_PGTABLE_MAX_LEVELS);
+		return -EINVAL;
+	};
+}
+
+static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			       enum kvm_pgtable_walk_flags visit)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	struct kvm_mmu_memory_cache *mc = ctx->arg;
+	struct kvm_s2_mmu *mmu;
+	kvm_pte_t pte = ctx->old, new, *childp;
+	enum kvm_pgtable_prot prot;
+	u32 level = ctx->level;
+	bool force_pte;
+	int nr_pages;
+	u64 phys;
+
+	/* No huge-pages exist at the last level */
+	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
+		return 0;
+
+	/* We only split valid block mappings */
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	nr_pages = stage2_block_get_nr_page_tables(level);
+	if (nr_pages < 0)
+		return nr_pages;
+
+	if (mc->nobjs >= nr_pages) {
+		/* Build a tree mapped down to the PTE granularity. */
+		force_pte = true;
+	} else {
+		/*
+		 * Don't force PTEs, so create_unlinked() below does
+		 * not populate the tree up to the PTE level. The
+		 * consequence is that the call will require a single
+		 * page of level 2 entries at level 1, or a single
+		 * page of PTEs at level 2. If we are at level 1, the
+		 * PTEs will be created recursively.
+		 */
+		force_pte = false;
+		nr_pages = 1;
+	}
+
+	if (mc->nobjs < nr_pages)
+		return -ENOMEM;
+
+	mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
+	phys = kvm_pte_to_phys(pte);
+	prot = kvm_pgtable_stage2_pte_prot(pte);
+
+	childp = kvm_pgtable_stage2_create_unlinked(mmu->pgt, phys,
+						    level, prot, mc, force_pte);
+	if (IS_ERR(childp))
+		return PTR_ERR(childp);
+
+	if (!stage2_try_break_pte(ctx, mmu)) {
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
+	new = kvm_init_table_pte(childp, mm_ops);
+	stage2_make_pte(ctx, new);
+	dsb(ishst);
+	return 0;
+}
+
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			     struct kvm_mmu_memory_cache *mc)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_split_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= mc,
+	};
+
+	return kvm_pgtable_walk(pgt, addr, size, &walker);
+}
+
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
 			      enum kvm_pgtable_stage2_flags flags,
-- 
2.40.0.577.gac1e443424-goog

