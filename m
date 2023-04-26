Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC1C6EF944
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbjDZRX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbjDZRXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:23:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F173955BA
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:44 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-51bacd63947so6668963a12.0
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529824; x=1685121824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qFKUcF3JZpWLqO01Rsl/NAaE0MvmeZbPzzVF64iF+RU=;
        b=QLFl6a8Chgqrwieh7nvifqut1zpGp9DjtQMV2Z8WhQJw3/p4dFymf+ZhjMMdhhyL+r
         mrcqUdp0L2DMa/HmMMTT+btMsS4mf0kqm5DOpfJHr+Ery7gspnU6fqCh/ODjnk6sQTxN
         VbeCEPlPORTyW0KATiQnAXBrQ0iHfY42BBORIQouc+WnqkSl4W7kA8134kZJdEw2r7YF
         xdUEBE+9o/jsaavxitw632reyYVL58rr+GyURdg9YY7iNNBN1EgWO5k7G3RQ+DdJ0bv5
         j5+QChUVSz551X5KPq7Z/4VgT7xcVsfRs0yeorQCqcZZCouUs0LGJBk6UqhxRfvTYq/w
         Vs6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529824; x=1685121824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qFKUcF3JZpWLqO01Rsl/NAaE0MvmeZbPzzVF64iF+RU=;
        b=FWPH7qYELbMLdch+w1OWM9mrRmSe5GKxFncKEC3HjIVANamNhPm4wFMc2s5JZTZOSy
         yodvzhKE1bnkPz/VBRG5QbWUGIPZ9v8eQg4pG2Aq5lORKWHQWSPW+Q42TDNzyfyONg5L
         rU2FbzrVaHsMlZM2qY7hRUG+aV9nP7buMcWyFCL+oArlLbSr4+F5VT/JoZkXhKuVLjK9
         P7Sjfm6qmu1pcJHb0vx0zcPTPMEnwsYU5LcP5ua/kGN9WCp2w/lmNL0vAeMI/h8mtcuV
         4uYaMZTV3qGG1nDZ53Qq+Oy7/0ruFAIyfKINqUVwTtGVPOwgMJriBOWQkH7lzgbLPj5Z
         K8SQ==
X-Gm-Message-State: AAQBX9ez586p9OjRW5WdtRdlnJK4rbutsN6Chd+SYTv+9zVbJ7rRuQXN
        ZyzNnyXh/Ed6sXYLDocjqHguO3x8KSCtEA==
X-Google-Smtp-Source: AKy350ZZsfVXqULEV7PZj9rBJyYMzzJsrQFUHPbAmEgmxwI0KjzUYAriLWlVoi4p7y9M1w9CDsa9OZs6xrRCdA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:ea49:0:b0:524:bc58:5e5c with SMTP id
 l9-20020a63ea49000000b00524bc585e5cmr2893177pgk.8.1682529824450; Wed, 26 Apr
 2023 10:23:44 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:23:24 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-7-ricarkol@google.com>
Subject: [PATCH v8 06/12] KVM: arm64: Add kvm_pgtable_stage2_split()
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  19 +++++
 arch/arm64/kvm/hyp/pgtable.c         | 103 +++++++++++++++++++++++++++
 2 files changed, 122 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4182d5df70c93..a41581c985b78 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -672,6 +672,25 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
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
index 722848a7cac3a..85f42fb2d0d75 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1299,6 +1299,109 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
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
2.40.1.495.gc816e09b53d-goog

