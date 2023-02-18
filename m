Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1000369B7E7
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 04:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjBRDXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 22:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBRDXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 22:23:23 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77F21A951
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:22 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b15-20020a252e4f000000b008ee1c76c25dso2407024ybn.11
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IPKuIrgtmaUvnSQsSTqJdSngfJOw0G5AsmYHjfQDA+w=;
        b=Df1ZtaZZDKkMQcinUaB82zEycAOToO5IWYefHKGUwkjpNvaM1eFEGTH2JKXaM97RQt
         sx1LAS0HYD0+iSqWZcKnhakihEd2vR85fH8b49cYd0v+AA9ePg1fKRrR0gpqHBVux4PU
         VkvWLwg+lL6aTRSvNvchziRnyznLen1sTUgeyF1d+m/BgCbUGc5YcNc4+c0ajIH4O7AT
         MHr8N9LGGxyxeUIQRRZH46vZzLEyQ4UknI8YAMpZIZfh3ULGNzMcUtJ9JYqS0eQcqm6W
         9UB5p+qLsKYq7yvsplYerlWZjYcdw4Jt1oO2R/4z6Mog8AVlsFoE/pTbqsqySH1rwXMK
         YWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IPKuIrgtmaUvnSQsSTqJdSngfJOw0G5AsmYHjfQDA+w=;
        b=ABKkVEaxoSCZcsFYPd9V3zbBqcBpmC+2l/9O0hfeT7iU3+G8HpmTsvYUd2ezpmKH8m
         TQNgBmREeYLTGBURDhnJlKArZE8pY+uMstB/FKaHcCAw8z4IDlT59hMHMbiee3I3JjEg
         /TMQucP3f0E/1ZkTDrQdWi1iL8odpNCcZZ+YhkfhZiRW92nWVtVlZ0wIA9oY0MqWIU3+
         5WOz3C9eUUvbHfjtqh/pAHoUfFhNMBFIUxkktnbMbGhPz5jyito5dW5weNiOof/3B6vy
         3p+T6EXjMtbsD2o+gEpqyf0P5MHmQhwGYnjXBj+D3WSLSyi+w9WD87k7NIr0h6TOpTIc
         MhJg==
X-Gm-Message-State: AO0yUKVOeon+I8s59B5A1dthtFy+jEQaO1J6Y5wwv0UecdmwF8GqY3b0
        j/Z2Ip2Ljd9TYk51z1gtytwUUeAKNuOZRQ==
X-Google-Smtp-Source: AK7set+LpHmmkgDl+/xDHOC/PKsWo6xoTJCTFIX3caU3Y29wflPl4vB0beoWr8mP2hw10HMmU41BpbJMuaJfwA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:7b02:0:b0:52e:d589:c893 with SMTP id
 w2-20020a817b02000000b0052ed589c893mr1411708ywc.457.1676690601872; Fri, 17
 Feb 2023 19:23:21 -0800 (PST)
Date:   Sat, 18 Feb 2023 03:23:05 +0000
In-Reply-To: <20230218032314.635829-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230218032314.635829-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-4-ricarkol@google.com>
Subject: [PATCH v4 03/12] KVM: arm64: Add helper for creating unlinked stage2 subtrees
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

Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
creating unlinked tables (which is the opposite of
kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
useful for splitting PMD and PUD blocks into subtrees of PAGE_SIZE
PTEs.  For example, a PUD can be split into PAGE_SIZE PTEs by first
creating a fully populated tree, and then use it to replace the PUD in
a single step.  This will be used in a subsequent commit for eager
huge-page splitting (a dirty-logging optimization).

No functional change intended. This new function will be used in a
subsequent commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 28 +++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 46 ++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index dcd3aafd3e6c..b8cde914cca9 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -460,6 +460,34 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  */
 void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
 
+/**
+ * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @phys:	Physical address of the memory to map.
+ * @level:	Starting level of the stage-2 paging structure to be created.
+ * @prot:	Permissions and attributes for the mapping.
+ * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
+ *		page-table pages.
+ * @force_pte:  Force mappings to PAGE_SIZE granularity.
+ *
+ * Create an unlinked page-table tree under @new. If @force_pte is
+ * true or @level is 2 (the PMD level), then the tree is mapped up to
+ * the PAGE_SIZE leaf PTE; the tree is mapped up one level otherwise.
+ * This new page-table tree is not reachable (i.e., it is unlinked)
+ * from the root pgd and it's therefore unreachableby the hardware
+ * page-table walker. No TLB invalidation or CMOs are performed.
+ *
+ * If device attributes are not explicitly requested in @prot, then the
+ * mapping will be normal, cacheable.
+ *
+ * Return: The fully populated (unlinked) stage-2 paging structure, or
+ * an ERR_PTR(error) on failure.
+ */
+kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
+					      u64 phys, u32 level,
+					      enum kvm_pgtable_prot prot,
+					      void *mc, bool force_pte);
+
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0a5ef9288371..80f2965ab0fe 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1181,6 +1181,52 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
+kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
+					      u64 phys, u32 level,
+					      enum kvm_pgtable_prot prot,
+					      void *mc, bool force_pte)
+{
+	struct stage2_map_data map_data = {
+		.phys		= phys,
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+		.force_pte	= force_pte,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb		= stage2_map_walker,
+		.flags		= KVM_PGTABLE_WALK_LEAF |
+				  KVM_PGTABLE_WALK_SKIP_BBM |
+				  KVM_PGTABLE_WALK_SKIP_CMO,
+		.arg		= &map_data,
+	};
+	/* .addr (the IPA) is irrelevant for a removed table */
+	struct kvm_pgtable_walk_data data = {
+		.walker	= &walker,
+		.addr	= 0,
+		.end	= kvm_granule_size(level),
+	};
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
+	kvm_pte_t *pgtable;
+	int ret;
+
+	ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
+	if (ret)
+		return ERR_PTR(ret);
+
+	pgtable = mm_ops->zalloc_page(mc);
+	if (!pgtable)
+		return ERR_PTR(-ENOMEM);
+
+	ret = __kvm_pgtable_walk(&data, mm_ops, (kvm_pteref_t)pgtable,
+				 level + 1);
+	if (ret) {
+		kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
+		mm_ops->put_page(pgtable);
+		return ERR_PTR(ret);
+	}
+
+	return pgtable;
+}
 
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
-- 
2.39.2.637.g21b0678d19-goog

