Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72D861059D
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbiJ0WTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbiJ0WTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:19:39 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46667BCBB
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:19:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666909177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mv1EXk7b0WRNpMnuTJ2F6nnFei9j0WoAuUnFOLgvpnk=;
        b=xQcvENmIKTrwxjDK/dw9mPYRkebIm2+wuy76Rpz17/OUnBpoD2GBhkWpMqv6Ekr2045RFt
        5pEOMLRMNZHPMDx09Izme5XI8ZPR4DhbvwDzB1a9a+Uqv6CCXIKZi99mQxxMv5SzSWu0Hr
        kQ8t4baYvOL0/zfhsXR65miYBlRXJUA=
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
Subject: [PATCH v3 09/15] KVM: arm64: Free removed stage-2 tables in RCU callback
Date:   Thu, 27 Oct 2022 22:17:46 +0000
Message-Id: <20221027221752.1683510-10-oliver.upton@linux.dev>
In-Reply-To: <20221027221752.1683510-1-oliver.upton@linux.dev>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no real urgency to free a stage-2 subtree that was pruned.
Nonetheless, KVM does the tear down in the stage-2 fault path while
holding the MMU lock.

Free removed stage-2 subtrees after an RCU grace period. To guarantee
all stage-2 table pages are freed before killing a VM, add an
rcu_barrier() to the flush path.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 +-
 arch/arm64/kvm/mmu.c                 | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index d1859e8550df..f35e7d4d73f1 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -65,7 +65,7 @@ typedef kvm_pte_t __rcu *kvm_pteref_t;
 
 static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
 {
-	return rcu_dereference_check(pteref, shared);
+	return rcu_dereference_check(pteref, !shared);
 }
 
 static inline void kvm_pgtable_walk_begin(void)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 175a0e9a04b6..a1a623c5b069 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -130,9 +130,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
 
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
 
+static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
+{
+	struct page *page = container_of(head, struct page, rcu_head);
+	void *pgtable = page_to_virt(page);
+	u32 level = page_private(page);
+
+	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, pgtable, level);
+}
+
 static void stage2_free_removed_table(void *addr, u32 level)
 {
-	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, addr, level);
+	struct page *page = virt_to_page(addr);
+
+	set_page_private(page, (unsigned long)level);
+	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
 }
 
 static void kvm_host_get_page(void *addr)
-- 
2.38.1.273.g43a17bfeac-goog

