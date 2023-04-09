Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7B96DBEDF
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 08:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjDIGaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 02:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDIGaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 02:30:11 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8F15B83
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 23:30:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n3-20020a170903110300b001a50ede5078so3408564plh.8
        for <kvm@vger.kernel.org>; Sat, 08 Apr 2023 23:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021810; x=1683613810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/0WFH7GFE0mRjpnGGu49tFfHY8Pv67dwYEe7UNPoJvs=;
        b=KRg2ZZzrVmLZIbHI1MuwBELHiQDMcYC808ymF2vc5eWEi6DHbZ43B3dYm1NfDEPFUZ
         QZdSi+RLVIhcBd53xSsVqlRleNHsXqscNMNETLV5E+j1iTlPgqTw9tvsOyvJV/mv0C9p
         MI/SxAWETi0Xd5/dxWSJQXk2SBfzF4bYUlAlMTjLotU75goyieq6vX/sgkWTsd4lt4Q/
         Hb+jkyd+tugzTSd1FzqLmUxKvTbPRLT/lLlbeBN8mWzFw0PzdeyxJYL30nIMp3ns9kny
         WtKBV6YYkF3izqPtBYxwDYdtuB5CLOmW8whQjPK2eZPGLGYqENkbKRfZ+BLaOX5sC373
         2zfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021810; x=1683613810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/0WFH7GFE0mRjpnGGu49tFfHY8Pv67dwYEe7UNPoJvs=;
        b=EfA+RxtwjC8dVqrB39uXMNw+Txv21+84M7XdwOuwRk7PWf643EB/DQ9rZ/LH+Et11O
         9z7yVrz5gSVNJiEdqUt9P8T+hjgpl3iw9G6zudJDmWs5Txm9HLPyIGt/IGCe9AFiaJ34
         oHZ94XXA9JkyX/4xtyFtxmuh7ToDDGPSS/pTSWJPxlrAicaYSP2JC7f9qV2gAtwp8Wx2
         Pgj6lp8I7/j3+41WOazzI1k7rlNxOtVPAXN/iUzljzaLyYnt19xiT/baXLBYsOCmmcM9
         45gnuqT8gak+TYri7KREdEMLjll32wC0JKf3MzBXtVNnQPaBzihD0ipxuoTOeoP/S7iW
         OuCA==
X-Gm-Message-State: AAQBX9fypYbtCS2Eff5v2PBI4q99IMPpLjuPdYtQJSM/XdX0JJR1uGyp
        mCNqSx5Wv0x2uMkJHnt8TzUuv378GrjjAQ==
X-Google-Smtp-Source: AKy350an8Hu6auEQsu5vdgnKkE0Q7SYNlGzZ+rYgT1KfrnVeBYst44Vg0iq9XpIVVfJYlAi9EY/3o5vS0dCQAA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:8d7:b0:23f:c69:96e2 with SMTP id
 ds23-20020a17090b08d700b0023f0c6996e2mr1890660pjb.6.1681021810444; Sat, 08
 Apr 2023 23:30:10 -0700 (PDT)
Date:   Sun,  9 Apr 2023 06:29:51 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-5-ricarkol@google.com>
Subject: [PATCH v7 03/12] KVM: arm64: Add helper for creating unlinked stage2 subtrees
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
---
 arch/arm64/include/asm/kvm_pgtable.h | 26 +++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 49 ++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 3f2d43ba2b628..c8e0e7d9303b2 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -458,6 +458,32 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
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
index 633679ee3c49a..477d2be67d401 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1222,6 +1222,55 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
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
+	/* .addr (the IPA) is irrelevant for an unlinked table */
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
2.40.0.577.gac1e443424-goog

