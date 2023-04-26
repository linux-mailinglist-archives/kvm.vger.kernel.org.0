Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DE16EF941
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbjDZRXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbjDZRXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:23:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0617ED8
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b8f6d2ac543so14108162276.2
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529819; x=1685121819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+T6CscrPRj2h9dMIeU5t7cK2tjOcKWs6GiIIF3afrFg=;
        b=KVB50CS8f2PwBQq+4Eh9UvxubFluGx+n4tHfrq6rE6pXdlftmy+RgIC2Ugnvym/End
         rK+I2ZXf6ar1nff9OK//HhA7+Ay7A4rG5e4HeqFyugeOmutjFHCT0HNAG0MaAEEhnK9F
         73LD4zC2oVYG6DXZCf8Z5aV8jksr3HI6gh3dM2b1FTUREJFe2/6zkqFIipws6+kVZXSt
         oKzkJWV3zxqI9IhnuH9X45wYKDPwS8QVvCMSuVPnUnfSpm6bPRudCZUKG9HetFgzZPdi
         luIVegRWAiG+G1nTlRhnmtb1zrnCXgMVgItifF9VI1Qw0omk/2uTV5aZXfHtPbJhxtqc
         5daw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529819; x=1685121819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+T6CscrPRj2h9dMIeU5t7cK2tjOcKWs6GiIIF3afrFg=;
        b=CtMqHUvAbxum0TFIxxkwekJOb/rou8jEaHDMvcHHy47HmgEg3/WzXZtW4qjJ21R/OC
         oS/dkca6l85gcdO6BqtBRVpyXcOdELOy0FmPlT392D68xYTzPXypXiYh9yIwYgnpG9ly
         xQOXOhKmX2hlETnfCMW/BCTtVKnEea32zf13DqrRtXXzwDd/Ja3xZAXGccefZDoJ54AZ
         nXM+NX2uRk0W8foXhtDe2lQ3YDAa5OF8HvsbleAsG/LLUKJWbsgT1dwqnKeErl9yXZqW
         4v1K2X2PVv9W1Peb144+vZNR2poIHFIsZp4R6auoFE4YlH6rN1ZyaNBkeDGeuq4V7UJJ
         qy9A==
X-Gm-Message-State: AAQBX9dT5TzG2SsRVnZkSdbiAXfLPwr6HH9Hg1bEW3/m2oBsdhMrKVmE
        JWTHt9Ws4UR0URjVSGq3WX7pIJ5d/a663Q==
X-Google-Smtp-Source: AKy350ZtrEbFl9OqWlzr6eQlnWxnF/yXDKHLDvcp+9pamCGs6UX/f0eVMyjlTO/rwWnDIF1rf/YU3u7r0SNvIg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:7713:0:b0:b98:6352:be1b with SMTP id
 s19-20020a257713000000b00b986352be1bmr12183813ybc.13.1682529819281; Wed, 26
 Apr 2023 10:23:39 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:23:21 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-4-ricarkol@google.com>
Subject: [PATCH v8 03/12] KVM: arm64: Add helper for creating unlinked stage2 subtrees
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

Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
creating unlinked tables (which is the opposite of
kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
useful for splitting level 1 and 2 entries into subtrees of PAGE_SIZE
PTEs.  For example, a level 1 entry can be split into PAGE_SIZE PTEs
by first creating a fully populated tree, and then use it to replace
the level 1 entry in a single step.  This will be used in a subsequent
commit for eager huge-page splitting (a dirty-logging optimization).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 26 ++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 53 ++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 7bbd77e9b7b47..00c8bef4f3ca0 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -459,6 +459,32 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
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
+ * Returns an unlinked page-table tree.  This new page-table tree is
+ * not reachable (i.e., it is unlinked) from the root pgd and it's
+ * therefore unreachableby the hardware page-table walker. No TLB
+ * invalidation or CMOs are performed.
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
index 64c96f9116171..722848a7cac3a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1245,6 +1245,59 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
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
+				  KVM_PGTABLE_WALK_SKIP_BBM_TLBI |
+				  KVM_PGTABLE_WALK_SKIP_CMO,
+		.arg		= &map_data,
+	};
+	/*
+	 * The input address (.addr) is irrelevant for walking an
+	 * unlinked table. Construct an ambiguous IA range to map
+	 * kvm_granule_size(level) worth of memory.
+	 */
+	struct kvm_pgtable_walk_data data = {
+		.walker	= &walker,
+		.addr	= 0,
+		.end	= kvm_granule_size(level),
+	};
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
+	kvm_pte_t *pgtable;
+	int ret;
+
+	if (!IS_ALIGNED(phys, kvm_granule_size(level)))
+		return ERR_PTR(-EINVAL);
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
2.40.1.495.gc816e09b53d-goog

