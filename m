Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2B05A6DD1
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiH3Tv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiH3TvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:51:23 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B8772B5E;
        Tue, 30 Aug 2022 12:51:21 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661889080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jyA52n5PXIfZG6yhWBQm3SaPH6T9tI0OWXKlc6krVCE=;
        b=LUuBibphlFTocfvHxEYwjPEhEbf34nsdxlCj+c68189duPaL4Z3ld/zR4FVqL4zRYfqU/c
        Ymt4M1PCH0aBBAwlq2co7SkEZPXrLewGCiTfKB4c5BIadgvKQ9jawXUG13aMoTW/tFH4no
        licZLjpIvirfUDEBqZ8h7/Mu/owfqH4=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] KVM: arm64: Make changes block->table to leaf PTEs parallel-aware
Date:   Tue, 30 Aug 2022 19:51:01 +0000
Message-Id: <20220830195102.964724-1-oliver.upton@linux.dev>
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

In order to service stage-2 faults in parallel, stage-2 table walkers
must take exclusive ownership of the PTE being worked on. An additional
requirement of the architecture is that software must perform a
'break-before-make' operation when changing the block size used for
mapping memory.

Roll these two concepts together into helpers for performing a
'break-before-make' sequence. Use a special PTE value to indicate a PTE
has been locked by a software walker. Additionally, use an atomic
compare-exchange to 'break' the PTE when the stage-2 page tables are
possibly shared with another software walker. Elide the DSB + TLBI if
the evicted PTE was invalid (and thus not subject to break-before-make).

All of the atomics do nothing for now, as the stage-2 walker isn't fully
ready to perform parallel walks.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 87 +++++++++++++++++++++++++++++++++---
 1 file changed, 82 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 61a4437c8c16..71ae96608752 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -49,6 +49,12 @@
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
 #define KVM_MAX_OWNER_ID		1
 
+/*
+ * Used to indicate a pte for which a 'break-before-make' sequence is in
+ * progress.
+ */
+#define KVM_INVALID_PTE_LOCKED		BIT(10)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -586,6 +592,8 @@ struct stage2_map_data {
 
 	/* Force mappings to page granularity */
 	bool				force_pte;
+
+	bool				shared;
 };
 
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
@@ -691,6 +699,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 	return kvm_pte_valid(pte) || kvm_invalid_pte_owner(pte);
 }
 
+static bool stage2_pte_is_locked(kvm_pte_t pte)
+{
+	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
+}
+
 static bool stage2_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bool shared)
 {
 	if (!shared) {
@@ -701,6 +714,69 @@ static bool stage2_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bo
 	return cmpxchg(ptep, old, new) == old;
 }
 
+/**
+ * stage2_try_break_pte() - Invalidates a pte according to the
+ *			    'break-before-make' requirements of the
+ *			    architecture.
+ *
+ * @ptep: Pointer to the pte to break
+ * @old: The previously observed value of the pte
+ * @addr: IPA corresponding to the pte
+ * @level: Table level of the pte
+ * @shared: true if the stage-2 page tables could be shared by multiple software
+ *	    walkers
+ *
+ * Returns: true if the pte was successfully broken.
+ *
+ * If the removed pte was valid, performs the necessary serialization and TLB
+ * invalidation for the old value. For counted ptes, drops the reference count
+ * on the containing table page.
+ */
+static bool stage2_try_break_pte(kvm_pte_t *ptep, kvm_pte_t old, u64 addr, u32 level,
+				 struct stage2_map_data *data)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+
+	if (stage2_pte_is_locked(old)) {
+		/*
+		 * Should never occur if this walker has exclusive access to the
+		 * page tables.
+		 */
+		WARN_ON(!data->shared);
+		return false;
+	}
+
+	if (!stage2_try_set_pte(ptep, old, KVM_INVALID_PTE_LOCKED, data->shared))
+		return false;
+
+	/*
+	 * Perform the appropriate TLB invalidation based on the evicted pte
+	 * value (if any).
+	 */
+	if (kvm_pte_table(old, level))
+		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+	else if (kvm_pte_valid(old))
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
+
+	if (stage2_pte_is_counted(old))
+		mm_ops->put_page(ptep);
+
+	return true;
+}
+
+static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new,
+			    struct stage2_map_data *data)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+
+	WARN_ON(!stage2_pte_is_locked(*ptep));
+
+	if (stage2_pte_is_counted(new))
+		mm_ops->get_page(ptep);
+
+	smp_store_release(ptep, new);
+}
+
 static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
 			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
 {
@@ -836,17 +912,18 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (!childp)
 		return -ENOMEM;
 
+	if (!stage2_try_break_pte(ptep, *old, addr, level, data)) {
+		mm_ops->put_page(childp);
+		return -EAGAIN;
+	}
+
 	/*
 	 * If we've run into an existing block mapping then replace it with
 	 * a table. Accesses beyond 'end' that fall within the new table
 	 * will be mapped lazily.
 	 */
-	if (stage2_pte_is_counted(pte))
-		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
-
 	new = kvm_init_table_pte(childp, mm_ops);
-	mm_ops->get_page(ptep);
-	smp_store_release(ptep, new);
+	stage2_make_pte(ptep, *old, new, data);
 	*old = new;
 
 	return 0;
-- 
2.37.2.672.g94769d06f0-goog

