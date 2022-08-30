Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3743D5A6D9E
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiH3Tmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiH3Tmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:42:38 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598047B7AF;
        Tue, 30 Aug 2022 12:42:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661888542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PAa+cBkl9mtwNYK8/w+PcWpN4aBBuzKZQpA5735hA3U=;
        b=ZLs5MEMDu72sPbf1oddAbPXFBK5HqyrH0LLuSMgJABWcVJhbffI94ChKh6fxlG4PUKb7Vt
        fp76TAzFIbxRDAKaCkX+hrkh4G3NnP0ojf+1rETVa0eO6qJqWT0Ozz+ovLennkecVRUXjy
        TzWk0l+KpUzy6uyX60KuJjkrZ/YIBkM=
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
Subject: [PATCH 08/14] KVM: arm64: Protect page table traversal with RCU
Date:   Tue, 30 Aug 2022 19:41:26 +0000
Message-Id: <20220830194132.962932-9-oliver.upton@linux.dev>
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

The use of RCU is necessary to change the paging structures in parallel.
Acquire and release an RCU read lock when traversing the page tables.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 19 ++++++++++++++++++-
 arch/arm64/kvm/hyp/pgtable.c         |  7 ++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 78fbb7be1af6..7d2de0a98ccb 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -578,9 +578,26 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
  */
 enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
 
+#if defined(__KVM_NVHE_HYPERVISOR___)
+
+static inline void kvm_pgtable_walk_begin(void) {}
+static inline void kvm_pgtable_walk_end(void) {}
+
+#define kvm_dereference_ptep rcu_dereference_raw
+
+#else	/* !defined(__KVM_NVHE_HYPERVISOR__) */
+
+#define kvm_pgtable_walk_begin	rcu_read_lock
+#define kvm_pgtable_walk_end	rcu_read_unlock
+#define kvm_dereference_ptep	rcu_dereference
+
+#endif	/* defined(__KVM_NVHE_HYPERVISOR__) */
+
 static inline kvm_pte_t kvm_pte_read(kvm_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	kvm_pte_t __rcu *p = (kvm_pte_t __rcu *)ptep;
+
+	return READ_ONCE(*kvm_dereference_ptep(p));
 }
 
 #endif	/* __ARM64_KVM_PGTABLE_H__ */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f911509e6512..215a14c434ed 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -284,8 +284,13 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.end	= PAGE_ALIGN(walk_data.addr + size),
 		.walker	= walker,
 	};
+	int r;
 
-	return _kvm_pgtable_walk(&walk_data);
+	kvm_pgtable_walk_begin();
+	r = _kvm_pgtable_walk(&walk_data);
+	kvm_pgtable_walk_end();
+
+	return r;
 }
 
 struct leaf_walk_data {
-- 
2.37.2.672.g94769d06f0-goog

