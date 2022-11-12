Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56BE626805
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 09:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiKLIR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 03:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiKLIRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 03:17:24 -0500
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D0259FE2
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:23 -0800 (PST)
Received: by mail-oo1-xc49.google.com with SMTP id g1-20020a4ad841000000b0049f25cf96afso2272018oov.20
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sW8yzYiLN0rvycCwgJfhQm/Ug+OWU4SUgCCWanJUNo8=;
        b=NbEJZXpP3Niw2dcw2EFmfW807+eCgBhUP0IckjhfQgbDN6XAO7jbT/35Ci5xi5xeSs
         zn9W0/x22dmHzoZ6AWoIkI2NGtOx9xOJb+AHT6r/QPU5fcVH+a6kDgTqnjJPshRkr+1R
         7P+TsLw5WN8Pg88KlWtGd2iYqOIMV1GLr4yzT/OTOSkK10DO82XVg1HERphKc5xt4VCQ
         +QIepxX4REPEeHTMDE2Ko/Kwn42KiuTqAYmnpQ07EewoG9rBKhwXYPQO2RCUQ+mLKmqn
         sSChsTrHLbTnpBGs52o+GqmW0idTx3OoJYIv2WyTV7QAFpp1V9UPyuHNNQqbc6E/aohs
         sqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sW8yzYiLN0rvycCwgJfhQm/Ug+OWU4SUgCCWanJUNo8=;
        b=JiiDU9YwAeN3+L3JP5IaRXubMZ7LGJz7fMi97hziU4IxGBOXflTiNCN1oIxgKWTuPf
         oVrFDMRkR+EU8NVzhpzkItZoNwagyQnmD68vWJljD2B134HrMJPMKY93iFWj4HMupUaa
         J2TqACoCAohwhzsnSh/XsnIH18/IR4xGpbQB4PrT4vBCDrJAB26LpTf7y8h64EFwvM6N
         vpHO186UkxiWs73TG80JU8K7lwDaYUsUs3Hii8w2ZFQnS1GRZmwhOESRlTNuJP6N015z
         KD3QNaRLNZJBamJjKl+FoacsdA2KEWk4tC/zatTpWWd6PPaTHZgjWaesr3al04JkDdyo
         SmHA==
X-Gm-Message-State: ANoB5pkqN39GWsajw8ljKPeNUY3ayJHqzW9OTxGFLf+CuN73vEp6Sn47
        J/q4/lmEIr3llydwu+gtQ56TZUzGBvqxBQ==
X-Google-Smtp-Source: AA0mqf6EmkVjDnUjkfNydVITp129iuw75i59sTZNS9in26BWrESzvhDqoX1KVMnkFyFaUWkj5fnscxncp0QoTA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aca:210c:0:b0:343:ad7:4a49 with SMTP id
 12-20020aca210c000000b003430ad74a49mr2383552oiz.278.1668241043060; Sat, 12
 Nov 2022 00:17:23 -0800 (PST)
Date:   Sat, 12 Nov 2022 08:17:05 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-4-ricarkol@google.com>
Subject: [RFC PATCH 03/12] KVM: arm64: Add stage2_create_removed()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, ricarkol@gmail.com,
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

Add a new stage2 function, stage2_create_removed(), for creating removed
tables (the opposite of kvm_pgtable_stage2_free_removed()).  Creating a
removed table is useful for splitting block PTEs into tables.  For example,
a 1G block PTE can be split into 4K PTEs by first creating a fully
populated tree, and then use it to replace the 1G PTE in a single step.
This will be used in a subsequent commit for eager huge page splitting.

No functional change intended. This new function will be used in a
subsequent commit.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 93 ++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 1b371f6dbac2..d1f309128118 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1173,6 +1173,99 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
+struct stage2_create_removed_data {
+	void				*memcache;
+	struct kvm_pgtable_mm_ops	*mm_ops;
+	u64				phys;
+	kvm_pte_t			attr;
+};
+
+/*
+ * This flag should only be used by the create_removed walker, as it would
+ * be misinterpreted it in an installed PTE.
+ */
+#define KVM_INVALID_PTE_NO_PAGE		BIT(9)
+
+/*
+ * Failure to allocate a table results in setting the respective PTE with a
+ * valid block PTE instead of a table PTE.
+ */
+static int stage2_create_removed_walker(const struct kvm_pgtable_visit_ctx *ctx,
+					enum kvm_pgtable_walk_flags visit)
+{
+	struct stage2_create_removed_data *data = ctx->arg;
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+	u64 granule = kvm_granule_size(ctx->level);
+	kvm_pte_t attr = data->attr;
+	kvm_pte_t *childp = NULL;
+	u32 level = ctx->level;
+	int ret = 0;
+
+	if (level < KVM_PGTABLE_MAX_LEVELS - 1) {
+		childp = mm_ops->zalloc_page(data->memcache);
+		ret = childp ? 0 : -ENOMEM;
+	}
+
+	if (childp)
+		*ctx->ptep = kvm_init_table_pte(childp, mm_ops);
+
+	/*
+	 * Create a block PTE if we are at the max level, or if we failed
+	 * to create a table (we are not at max level).
+	 */
+	if (level == KVM_PGTABLE_MAX_LEVELS - 1 || !childp) {
+		*ctx->ptep = kvm_init_valid_leaf_pte(data->phys, attr, level);
+		data->phys += granule;
+	}
+
+	if (ctx->old != KVM_INVALID_PTE_NO_PAGE)
+		mm_ops->get_page(ctx->ptep);
+
+	return ret;
+}
+
+/*
+ * Create a removed page-table tree of PAGE_SIZE leaf PTEs under *ptep.
+ * This new page-table tree is not reachable (i.e., it is removed) from the
+ * root (the pgd).
+ *
+ * This function will try to create as many entries in the tree as allowed
+ * by the memcache capacity. It always writes a valid PTE into *ptep. In
+ * the best case, it returns 0 and a fully populated tree under *ptep. In
+ * the worst case, it returns -ENOMEM and *ptep will contain a valid block
+ * PTE covering the expected level, or any other valid combination (e.g., a
+ * 1G table PTE pointing to half 2M block PTEs and half 2M table PTEs).
+ */
+static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
+				 kvm_pte_t attr, void *memcache,
+				 struct kvm_pgtable_mm_ops *mm_ops)
+{
+	struct stage2_create_removed_data alloc_data = {
+		.phys		= phys,
+		.memcache	= memcache,
+		.mm_ops		= mm_ops,
+		.attr		= attr,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_create_removed_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &alloc_data,
+	};
+	struct kvm_pgtable_walk_data data = {
+		.walker	= &walker,
+
+		/* The IPA is irrelevant for a removed table. */
+		.addr	= 0,
+		.end	= kvm_granule_size(level),
+	};
+
+	/*
+	 * The walker should not try to get a reference to the memory
+	 * holding this ptep (it's not a page).
+	 */
+	*ptep = KVM_INVALID_PTE_NO_PAGE;
+	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
+}
 
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
-- 
2.38.1.431.g37b22c650d-goog

