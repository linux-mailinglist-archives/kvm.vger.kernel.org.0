Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1059668A67
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbjAMDuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjAMDuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:50:07 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAAE12D3C
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:06 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4c0fe6e3f13so214422047b3.0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vmp1Kc4wx1CMTXvUGnc7kt4vfG7uXA3nNZdPoWjSPWk=;
        b=Sbe6PwDItRsJwuIWtuHakgH+nKZjoQozxzoc6Ffpja7NEX4l9tAAnCtB4g6D2pPj26
         +2fcDnDZHAwgvQfT9wlYY3i2HwfC34B6M0dvoQrrk1vmw8sONtY59ZGotBT5LRIFiiCn
         KtfRj8xXfJrxNjXJDb1o7qEETCIeU28yDE7E58WuqN6NuDZR5UC1J4VguZtnOr8+jRZ7
         9nYHyoYOaxo+v8+rll3rsB7DfdpVeKrny+ktV5HTpFo6/MQ6SIR5AK3ZdnUJjepo97sp
         DVQ91IUxCv75ztrKXMlPBuvHMpF+ZfkJPvrwYOuZf37RpmPUGJ/ptmKxLIWQAjDLX1yx
         c9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vmp1Kc4wx1CMTXvUGnc7kt4vfG7uXA3nNZdPoWjSPWk=;
        b=IUHs7LjeYZkL1DFBsJhjfmc8WyD2+cuQGjNnNGgg4h6rRLcoKRsZR7a+Jav3+btBeF
         g4aOtu7tvTZVjm0aUszhTOMTf90Fo5NoLv2qd8kKoEU83704PEIOmC1CXdA0vdJ62SBu
         D11SSKqdIsg4mGR9Wh/7tRUH06/bgSkpVETtFeLuaLAvmD0OPt/n7mtf4fhWxNYJTG3N
         JVhKFqOFl6YPfA08i7I9PwW4MRKHJ9U5gkaDLudc/pSvrQyhC/jZ8JKKdIMZ4ppi+/gd
         NXoPt3qlOe08u4hGuhqlaKxvEW3tjlIwSFx9Fr5ZgqWlrtMhnB4TwnWg62mDwjtT7i6j
         F5Kg==
X-Gm-Message-State: AFqh2kpH6IhA4uRCcoYUQOP9TI3zj3NLrFUwwqM4BSHZwpUiLHoAILXF
        1CM5MP7lfpJBY7BR0hauHkF1aJxCxTDJQA==
X-Google-Smtp-Source: AMrXdXsQSZJtgtSeMsHcjfJu/cgQkQRfMArQC1Un94wlx6OadkveqwpLcA1ZoEyNU/jeLgk27DIYUuT2meetUw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:690c:68e:b0:4ce:6aab:6c39 with SMTP
 id bp14-20020a05690c068e00b004ce6aab6c39mr1931785ywb.90.1673581805824; Thu,
 12 Jan 2023 19:50:05 -0800 (PST)
Date:   Fri, 13 Jan 2023 03:49:53 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-3-ricarkol@google.com>
Subject: [PATCH 2/9] KVM: arm64: Add helper for creating removed stage2 subtrees
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

Add a stage2 helper, kvm_pgtable_stage2_create_removed(), for creating
removed tables (the opposite of kvm_pgtable_stage2_free_removed()).
Creating a removed table is useful for splitting block PTEs into
subtrees of 4K PTEs.  For example, a 1G block PTE can be split into 4K
PTEs by first creating a fully populated tree, and then use it to
replace the 1G PTE in a single step.  This will be used in a
subsequent commit for eager huge-page splitting (a dirty-logging
optimization).

No functional change intended. This new function will be used in a
subsequent commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 25 +++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 84a271647007..8ad78d61af7f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -450,6 +450,31 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  */
 void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
 
+/**
+ * kvm_pgtable_stage2_free_removed() - Create a removed stage-2 paging structure.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @new:	Unlinked stage-2 paging structure to be created.
+ * @phys:	Physical address of the memory to map.
+ * @level:	Level of the stage-2 paging structure to be created.
+ * @prot:	Permissions and attributes for the mapping.
+ * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
+ *		page-table pages.
+ *
+ * Create a removed page-table tree of PAGE_SIZE leaf PTEs under *new.
+ * This new page-table tree is not reachable (i.e., it is removed) from the
+ * root pgd and it's therefore unreachableby the hardware page-table
+ * walker. No TLB invalidation or CMOs are performed.
+ *
+ * If device attributes are not explicitly requested in @prot, then the
+ * mapping will be normal, cacheable.
+ *
+ * Return: 0 only if a fully populated tree was created, negative error
+ * code on failure. No partially-populated table can be returned.
+ */
+int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
+				      kvm_pte_t *new, u64 phys, u32 level,
+				      enum kvm_pgtable_prot prot, void *mc);
+
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 87fd40d09056..0dee13007776 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1181,6 +1181,53 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
+/*
+ * map_data->force_pte is true in order to force creating PAGE_SIZE PTEs.
+ * data->addr is 0 because the IPA is irrelevant for a removed table.
+ */
+int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
+				      kvm_pte_t *new, u64 phys, u32 level,
+				      enum kvm_pgtable_prot prot, void *mc)
+{
+	struct stage2_map_data map_data = {
+		.phys		= phys,
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+		.force_pte	= true,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb		= stage2_map_walker,
+		.flags		= KVM_PGTABLE_WALK_LEAF |
+				  KVM_PGTABLE_WALK_REMOVED,
+		.arg		= &map_data,
+	};
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
+		return ret;
+
+	pgtable = mm_ops->zalloc_page(mc);
+	if (!pgtable)
+		return -ENOMEM;
+
+	ret = __kvm_pgtable_walk(&data, mm_ops, pgtable, level + 1);
+	if (ret) {
+		kvm_pgtable_stage2_free_removed(mm_ops, pgtable, level);
+		mm_ops->put_page(pgtable);
+		return ret;
+	}
+
+	*new = kvm_init_table_pte(pgtable, mm_ops);
+	return 0;
+}
 
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
-- 
2.39.0.314.g84b9a713c41-goog

