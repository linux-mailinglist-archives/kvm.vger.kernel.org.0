Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC48C5A6D87
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiH3Tl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiH3Tlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:41:55 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1650F726A0;
        Tue, 30 Aug 2022 12:41:54 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661888512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QlZz4xsWZh51ZQP7HNgRWu8mkrkQyxoC5UQCh4dA9Gc=;
        b=oW0OkHRXICpe1qsMt0Vkf05qJypn89W1g6AlFhTy1KOz5tK4JqHClut6fFaXYCX49Vc1QJ
        jhWNFu4tgN1b56RXLkVgSjCkxoSdx4TVq936DjQMlyZOnhuv8/848Ta6ygx6EIPnwQZlbP
        IAcGQ4HxQopueoqeyeKY2SIVQBOPmhQ=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] KVM: arm64: Add a helper to tear down unlinked stage-2 subtrees
Date:   Tue, 30 Aug 2022 19:41:19 +0000
Message-Id: <20220830194132.962932-2-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A subsequent change to KVM will move the tear down of an unlinked
stage-2 subtree out of the critical path of the break-before-make
sequence.

Introduce a new helper for tearing down unlinked stage-2 subtrees.
Leverage the existing stage-2 free walkers to do so, with a deep call
into __kvm_pgtable_walk() as the subtree is no longer reachable from the
root.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 26 ++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 9f339dffbc1a..d71fb92dc913 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -316,6 +316,17 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
  */
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 
+/**
+ * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
+ * @pgtable:	Unlinked stage-2 paging structure to be freed.
+ * @level:	Level of the stage-2 paging structure to be freed.
+ * @arg:	Page-table structure initialised by kvm_pgtable_stage2_init*()
+ *
+ * The page-table is assumed to be unreachable by any hardware walkers prior to
+ * freeing and therefore no TLB invalidation is performed.
+ */
+void kvm_pgtable_stage2_free_removed(void *pgtable, u32 level, void *arg);
+
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 2cb3867eb7c2..d8127c25424c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1233,3 +1233,29 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
 	pgt->pgd = NULL;
 }
+
+void kvm_pgtable_stage2_free_removed(void *pgtable, u32 level, void *arg)
+{
+	struct kvm_pgtable *pgt = (struct kvm_pgtable *)arg;
+	kvm_pte_t *ptep = (kvm_pte_t *)pgtable;
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_free_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF |
+			  KVM_PGTABLE_WALK_TABLE_POST,
+		.arg	= pgt->mm_ops,
+	};
+	struct kvm_pgtable_walk_data data = {
+		.pgt	= pgt,
+		.walker	= &walker,
+
+		/*
+		 * At this point the IPA really doesn't matter, as the page
+		 * table being traversed has already been removed from the stage
+		 * 2. Set an appropriate range to cover the entire page table.
+		 */
+		.addr	= 0,
+		.end	= kvm_granule_size(level),
+	};
+
+	WARN_ON(__kvm_pgtable_walk(&data, ptep, level));
+}
-- 
2.37.2.672.g94769d06f0-goog

