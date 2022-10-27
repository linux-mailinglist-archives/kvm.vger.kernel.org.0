Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7EE61059C
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiJ0WTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbiJ0WTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:19:39 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CABA65C3
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:19:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666909170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SGgezeaRpwTbMJIwssPR+7+RFNLpIEtsfVUv+WQJPCY=;
        b=M/EoevzFfiPGlFnffXiUm4is7ZrRno9Or5lwGUFDOPAWGe38FC7h7OdzBokBUyNaDZzy+A
        TtHP6rUmLK9ciWOHrNxMeauNfrxoYQKd70YjzVq4VUTSPz25//n+LI6oIg54E5SFLFqWPn
        lONjpWUmsIvEgQO++wRLFrOVU4CMt+w=
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
Subject: [PATCH v3 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Date:   Thu, 27 Oct 2022 22:17:45 +0000
Message-Id: <20221027221752.1683510-9-oliver.upton@linux.dev>
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

The use of RCU is necessary to safely change the stage-2 page tables in
parallel. Acquire and release the RCU read lock when traversing the page
tables.

Use the _raw() flavor of rcu_dereference when changes to the page tables
are otherwise protected from parallel software walkers (e.g. holding the
write lock).

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 41 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 10 ++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index e70cf57b719e..d1859e8550df 100644
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
+	return rcu_dereference_check(pteref, shared);
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
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c4d103889a62..5bab932aeaec 100644
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
-- 
2.38.1.273.g43a17bfeac-goog

