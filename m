Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A730A5A6DA2
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiH3Tm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiH3Tmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:42:40 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EF57C753;
        Tue, 30 Aug 2022 12:42:27 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661888545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NFwSFftgtou/xmW0mHXjm84oZeXHuVM1GyZ5T83/2Wg=;
        b=uI1s1ijlRaMGjo0jD+nYZDxRHNF+xtPjYfu05N6LNtXIkm3dIie5gtYAIPsiOyuJ6ClfhV
        ybPxb7Q1Jo+wBTKNu8gdTSY/P1/46syt8d1oBiKjfi4BdrV1c4EXFGM6kN02too/RLt5YY
        AYtX+JXtuvSVgqwwikvtaPajlrG+7rA=
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
Subject: [PATCH 09/14] KVM: arm64: Free removed stage-2 tables in RCU callback
Date:   Tue, 30 Aug 2022 19:41:27 +0000
Message-Id: <20220830194132.962932-10-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/arm64/kvm/mmu.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 91521f4aab97..265951c05879 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -97,6 +97,38 @@ static void *stage2_memcache_zalloc_page(void *arg)
 	return kvm_mmu_memory_cache_alloc(mc);
 }
 
+#define STAGE2_PAGE_PRIVATE_LEVEL_MASK	GENMASK_ULL(2, 0)
+
+static inline unsigned long stage2_page_private(u32 level, void *arg)
+{
+	unsigned long pvt = (unsigned long)arg;
+
+	BUILD_BUG_ON(KVM_PGTABLE_MAX_LEVELS > STAGE2_PAGE_PRIVATE_LEVEL_MASK);
+	WARN_ON_ONCE(pvt & STAGE2_PAGE_PRIVATE_LEVEL_MASK);
+
+	return pvt | level;
+}
+
+static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
+{
+	struct page *page = container_of(head, struct page, rcu_head);
+	unsigned long pvt = page_private(page);
+	void *arg = (void *)(pvt & ~STAGE2_PAGE_PRIVATE_LEVEL_MASK);
+	u32 level = (u32)(pvt & STAGE2_PAGE_PRIVATE_LEVEL_MASK);
+	void *pgtable = page_to_virt(page);
+
+	kvm_pgtable_stage2_free_removed(pgtable, level, arg);
+}
+
+static void stage2_free_removed_table(void *pgtable, u32 level, void *arg)
+{
+	unsigned long pvt = stage2_page_private(level, arg);
+	struct page *page = virt_to_page(pgtable);
+
+	set_page_private(page, (unsigned long)pvt);
+	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
+}
+
 static void *kvm_host_zalloc_pages_exact(size_t size)
 {
 	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -627,7 +659,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
 	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
 	.free_pages_exact	= free_pages_exact,
-	.free_removed_table	= kvm_pgtable_stage2_free_removed,
+	.free_removed_table	= stage2_free_removed_table,
 	.get_page		= kvm_host_get_page,
 	.put_page		= kvm_host_put_page,
 	.page_count		= kvm_host_page_count,
@@ -770,6 +802,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	if (pgt) {
 		kvm_pgtable_stage2_destroy(pgt);
 		kfree(pgt);
+		rcu_barrier();
 	}
 }
 
-- 
2.37.2.672.g94769d06f0-goog

