Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA39610592
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbiJ0WTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235445AbiJ0WSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:18:52 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902F0B3B1D
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:18:44 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666909123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A3cd+3dFUfDHSKU6YAIam1ncezaUskmfW+2jIWNKZP8=;
        b=aCW8Ox1ZZi/ewVC8mLw+VztnjtFAFODK8AYrC1WDgDNFDeIwdE8x0P7kp9x5oFjqu9BVzX
        fSAcac61msnsgJT9vgT2MecPqieWbs4kA5CIXFhc1BF8XWSorbqG71dIqBv/ljTb8myWzD
        ahK39ywb+4G+/Ksz6afi2G1BRp62UVk=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 05/15] KVM: arm64: Add a helper to tear down unlinked stage-2 subtrees
Date:   Thu, 27 Oct 2022 22:17:42 +0000
Message-Id: <20221027221752.1683510-6-oliver.upton@linux.dev>
In-Reply-To: <20221027221752.1683510-1-oliver.upton@linux.dev>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/arm64/kvm/hyp/pgtable.c         | 23 +++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index a752793482cb..93b1feeaebab 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -333,6 +333,17 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
  */
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 
+/**
+ * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
+ * @mm_ops:	Memory management callbacks.
+ * @pgtable:	Unlinked stage-2 paging structure to be freed.
+ * @level:	Level of the stage-2 paging structure to be freed.
+ *
+ * The page-table is assumed to be unreachable by any hardware walkers prior to
+ * freeing and therefore no TLB invalidation is performed.
+ */
+void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
+
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 93989b750a26..363a5cce7e1a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1203,3 +1203,26 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
 	pgt->pgd = NULL;
 }
+
+void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
+{
+	kvm_pte_t *ptep = (kvm_pte_t *)pgtable;
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_free_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF |
+			  KVM_PGTABLE_WALK_TABLE_POST,
+	};
+	struct kvm_pgtable_walk_data data = {
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
+	WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level));
+}
-- 
2.38.1.273.g43a17bfeac-goog

