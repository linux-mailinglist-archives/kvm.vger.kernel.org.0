Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28583617985
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 10:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiKCJMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 05:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiKCJM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 05:12:27 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B25DEC5
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 02:12:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667466743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gbgj6F1irzD3eHo5eTzoENFPze9NjhrkBKA87ZC9HOI=;
        b=NY1yfvQrUxz6wITWFHrfzDHtn62u9Xre+XU2k40jl0NRRJRDqAsqs+Xnc4zwyrOqv4FiQ6
        mZd3+AI7DErfh64AMvvdxZ1fqaoG1XxGuIUKNXv45bZ9hpFXpvnd4u//HLPLvgLxk9xziS
        wEG9QJj0L0OWi4l9xRFQ4+edNjDppRs=
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
Subject: [PATCH v4 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Date:   Thu,  3 Nov 2022 09:11:34 +0000
Message-Id: <20221103091140.1040433-9-oliver.upton@linux.dev>
In-Reply-To: <20221103091140.1040433-1-oliver.upton@linux.dev>
References: <20221103091140.1040433-1-oliver.upton@linux.dev>
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

Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
release the RCU read lock when traversing the page tables. Defer the
freeing of table memory to an RCU callback. Indirect the calls into RCU
and provide stubs for hypervisor code, as RCU is not available in such a
context.

The RCU protection doesn't amount to much at the moment, as readers are
already protected by the read-write lock (all walkers that free table
memory take the write lock). Nonetheless, a subsequent change will
futher relax the locking requirements around the stage-2 MMU, thereby
depending on RCU.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 49 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 10 +++++-
 arch/arm64/kvm/mmu.c                 | 14 +++++++-
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index e70cf57b719e..7634b6964779 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -37,6 +37,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
 
 typedef u64 kvm_pte_t;
 
+/*
+ * RCU cannot be used in a non-kernel context such as the hyp. As such, page
+ * table walkers used in hyp do not call into RCU and instead use other
+ * synchronization mechanisms (such as a spinlock).
+ */
+#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
+
 typedef kvm_pte_t *kvm_pteref_t;
 
 static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
@@ -44,6 +51,40 @@ static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared
 	return pteref;
 }
 
+static inline void kvm_pgtable_walk_begin(void) {}
+static inline void kvm_pgtable_walk_end(void) {}
+
+static inline bool kvm_pgtable_walk_lock_held(void)
+{
+	return true;
+}
+
+#else
+
+typedef kvm_pte_t __rcu *kvm_pteref_t;
+
+static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
+{
+	return rcu_dereference_check(pteref, !shared);
+}
+
+static inline void kvm_pgtable_walk_begin(void)
+{
+	rcu_read_lock();
+}
+
+static inline void kvm_pgtable_walk_end(void)
+{
+	rcu_read_unlock();
+}
+
+static inline bool kvm_pgtable_walk_lock_held(void)
+{
+	return rcu_read_lock_held();
+}
+
+#endif
+
 #define KVM_PTE_VALID			BIT(0)
 
 #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
@@ -202,11 +243,14 @@ struct kvm_pgtable {
  *					children.
  * @KVM_PGTABLE_WALK_TABLE_POST:	Visit table entries after their
  *					children.
+ * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
+ *					with other software walkers.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
 	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
+	KVM_PGTABLE_WALK_SHARED			= BIT(3),
 };
 
 struct kvm_pgtable_visit_ctx {
@@ -223,6 +267,11 @@ struct kvm_pgtable_visit_ctx {
 typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_ctx *ctx,
 					enum kvm_pgtable_walk_flags visit);
 
+static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
+}
+
 /**
  * struct kvm_pgtable_walker - Hook into a page-table walk.
  * @cb:		Callback function to invoke during the walk.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index de8a2e1c7435..156754d87b2a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -171,6 +171,9 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
 				  enum kvm_pgtable_walk_flags visit)
 {
 	struct kvm_pgtable_walker *walker = data->walker;
+
+	/* Ensure the appropriate lock is held (e.g. RCU lock for stage-2 MMU) */
+	WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx) && !kvm_pgtable_walk_lock_held());
 	return walker->cb(ctx, visit);
 }
 
@@ -281,8 +284,13 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.end	= PAGE_ALIGN(walk_data.addr + size),
 		.walker	= walker,
 	};
+	int r;
+
+	kvm_pgtable_walk_begin();
+	r = _kvm_pgtable_walk(pgt, &walk_data);
+	kvm_pgtable_walk_end();
 
-	return _kvm_pgtable_walk(pgt, &walk_data);
+	return r;
 }
 
 struct leaf_walk_data {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 73ae908eb5d9..52e042399ba5 100644
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
2.38.1.431.g37b22c650d-goog

