Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F127A668A68
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjAMDuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjAMDuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:50:08 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D895554703
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:07 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a4-20020a5b0004000000b006fdc6aaec4fso21742876ybp.20
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PpQHC4NcAeUWNMKwINV6b15y1SedzAb1MKkwfHkrc18=;
        b=sRVsa74aJlqP+CI0/p52Jx9L5VC+mO7wdeF4D7T+Mo1wjekmMl3RXgLkUBGj+ov+7h
         iqfNNV4APK79XeAWWxe975BGxAcf4PH5/fet8p2+BoKQ9ApU9VqDVk/w0QsIpAxniQPI
         c4zXPaeSm03ulWOiL6fqv0KI4i3Lvmk4X8aBK/v8jSbOYwCK0RylPwO7oKcc9uXsaVLl
         Os6NLLvPEKQGFjv1EKil1CqdjqT86lB7Q0JlZnV20/9FaGCY1zZWugPaRzdcTn6bJDU5
         FqM8HbiJeD2BA5fPe9wiNAbNPJh0HpDScF044zvfsYz5SF7hO/KGAHBrZXH/Xk722/KT
         9Xww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PpQHC4NcAeUWNMKwINV6b15y1SedzAb1MKkwfHkrc18=;
        b=50WddlCQRp6NF7LvZYpFwUxDIWlFQfQDRXyzpbOHsxTWzzkyF6nOollmv8nO7vTRgX
         w2zXsJRp7iA6k5B2H6xC10Llocb9IRl/APA0CR5HOAt3m6sxo9Dd64PlWxX1L9Ym/4P0
         pST+q/s5qI6sW/qaHN6HRwCTFNeeDxy6emOvkHouc/yWYSrP2vFA+O9AAzYMxku/mABI
         +XgoHLwvfCrg3KkZTpNeINS8tUiyPBVjZEte3wBGG7Xn/D/+vztLfOlZugxws36R5Hcx
         nCTanw/rCdx3piUBeSRlySH2fTIPEYFbW96vvweXKFe7Izq4K4qovcROL31JIRpFNqlH
         6sxA==
X-Gm-Message-State: AFqh2kr0Ux+j0Gi3D1gwre2cDNBZQ4MGcxwDalusDVr/QfQD5YMNy3ox
        XabLCXq2doIwv2SbziNXB1JRmLGkGDOaeQ==
X-Google-Smtp-Source: AMrXdXtByGjzrtFwpkQ3ixpE9eu5GVo/M7lmKE4T2FFkjUAkJQvw/7lHXnVfIY+XJox9W/TxwJ8KB3r/Q59HNw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:4c81:0:b0:6f9:ece2:7b87 with SMTP id
 z123-20020a254c81000000b006f9ece27b87mr9161127yba.485.1673581807103; Thu, 12
 Jan 2023 19:50:07 -0800 (PST)
Date:   Fri, 13 Jan 2023 03:49:54 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-4-ricarkol@google.com>
Subject: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
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
 arch/arm64/include/asm/kvm_pgtable.h | 29 ++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 67 ++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 8ad78d61af7f..5fbdc1f259fd 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -644,6 +644,35 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
  */
 int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
+/**
+ * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
+ *				to PAGE_SIZE guest pages.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @addr:	Intermediate physical address from which to split.
+ * @size:	Size of the range.
+ * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
+ *		page-table pages.
+ *
+ * @addr and the end (@addr + @size) are effectively aligned down and up to
+ * the top level huge-page block size. This is an exampe using 1GB
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
+ * blocks in the input range as allowed by the size of the memcache. It
+ * will fail it wasn't able to break any block.
+ */
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
+
 /**
  * kvm_pgtable_walk() - Walk a page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0dee13007776..db9d1a28769b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1229,6 +1229,73 @@ int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
 	return 0;
 }
 
+struct stage2_split_data {
+	struct kvm_s2_mmu		*mmu;
+	void				*memcache;
+};
+
+static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			       enum kvm_pgtable_walk_flags visit)
+{
+	struct stage2_split_data *data = ctx->arg;
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	kvm_pte_t pte = ctx->old, new, *childp;
+	enum kvm_pgtable_prot prot;
+	void *mc = data->memcache;
+	u32 level = ctx->level;
+	u64 phys;
+	int ret;
+
+	/* Nothing to split at the last level */
+	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
+		return 0;
+
+	/* We only split valid block mappings */
+	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
+		return 0;
+
+	phys = kvm_pte_to_phys(pte);
+	prot = kvm_pgtable_stage2_pte_prot(pte);
+
+	ret = kvm_pgtable_stage2_create_removed(data->mmu->pgt, &new, phys,
+						level, prot, mc);
+	if (ret)
+		return ret;
+
+	if (!stage2_try_break_pte(ctx, data->mmu)) {
+		childp = kvm_pte_follow(new, mm_ops);
+		kvm_pgtable_stage2_free_removed(mm_ops, childp, level);
+		mm_ops->put_page(childp);
+		return -EAGAIN;
+	}
+
+	/*
+	 * Note, the contents of the page table are guaranteed to be
+	 * made visible before the new PTE is assigned because
+	 * stage2_make_pte() writes the PTE using smp_store_release().
+	 */
+	stage2_make_pte(ctx, new);
+	dsb(ishst);
+	return 0;
+}
+
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt,
+			     u64 addr, u64 size, void *mc)
+{
+	struct stage2_split_data split_data = {
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
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
2.39.0.314.g84b9a713c41-goog

