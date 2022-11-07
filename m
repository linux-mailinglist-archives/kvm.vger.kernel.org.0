Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACEB6201A7
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 23:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbiKGWAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 17:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbiKGWAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 17:00:45 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2DCB5B
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 14:00:44 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667858442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RqLk7RWPKnUNF/MDbobVslqYC6flZA3inOBRUipp+ik=;
        b=OkUF+oqTfbepr2gFpL5x6/EJditl869PCjbfwzwYU81D/Cv6Ie62EC2u8/eXySeHSHWT6v
        NjyeiBIiKsLaZl8/HwKKvVc9C3CxWi7WIPnUBHmpXKs8nA3S64FN03xJpB43Ul5vI9KS9x
        6qhbiazeQyfU6gUcXQshUEt/xz6Rq7s=
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
Subject: [PATCH v5 14/14] KVM: arm64: Handle stage-2 faults in parallel
Date:   Mon,  7 Nov 2022 22:00:33 +0000
Message-Id: <20221107220033.1895655-1-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-1-oliver.upton@linux.dev>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
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

The stage-2 map walker has been made parallel-aware, and as such can be
called while only holding the read side of the MMU lock. Rip out the
conditional locking in user_mem_abort() and instead grab the read lock.
Continue to take the write lock from other callsites to
kvm_pgtable_stage2_map().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  3 ++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  2 +-
 arch/arm64/kvm/hyp/pgtable.c          |  5 +++--
 arch/arm64/kvm/mmu.c                  | 31 ++++++---------------------
 4 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 7634b6964779..a874ce0ce7b5 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -412,6 +412,7 @@ void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pg
  * @prot:	Permissions and attributes for the mapping.
  * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
  *		page-table pages.
+ * @flags:	Flags to control the page-table walk (ex. a shared walk)
  *
  * The offset of @addr within a page is ignored, @size is rounded-up to
  * the next page boundary and @phys is rounded-down to the previous page
@@ -433,7 +434,7 @@ void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pg
  */
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   void *mc);
+			   void *mc, enum kvm_pgtable_walk_flags flags);
 
 /**
  * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 735769886b55..f6d82bf33ce1 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -257,7 +257,7 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
 				      enum kvm_pgtable_prot prot)
 {
 	return kvm_pgtable_stage2_map(&host_kvm.pgt, start, end - start, start,
-				      prot, &host_s2_pool);
+				      prot, &host_s2_pool, 0);
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f814422ef795..5bca9610d040 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -912,7 +912,7 @@ static int stage2_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   void *mc)
+			   void *mc, enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
 	struct stage2_map_data map_data = {
@@ -923,7 +923,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
-		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
+		.flags		= flags |
+				  KVM_PGTABLE_WALK_TABLE_PRE |
 				  KVM_PGTABLE_WALK_LEAF,
 		.arg		= &map_data,
 	};
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 52e042399ba5..410c2a37fe32 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -861,7 +861,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 		write_lock(&kvm->mmu_lock);
 		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
-					     &cache);
+					     &cache, 0);
 		write_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
@@ -1156,7 +1156,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	bool use_read_lock = false;
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1191,8 +1190,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
-		use_read_lock = (fault_status == FSC_PERM && write_fault &&
-				 fault_granule == PAGE_SIZE);
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
@@ -1291,15 +1288,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	/*
-	 * To reduce MMU contentions and enhance concurrency during dirty
-	 * logging dirty logging, only acquire read lock for permission
-	 * relaxation.
-	 */
-	if (use_read_lock)
-		read_lock(&kvm->mmu_lock);
-	else
-		write_lock(&kvm->mmu_lock);
+	read_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_invalidate_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1343,15 +1332,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
+	if (fault_status == FSC_PERM && vma_pagesize == fault_granule)
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
-	} else {
-		WARN_ONCE(use_read_lock, "Attempted stage-2 map outside of write lock\n");
-
+	else
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
-					     memcache);
-	}
+					     memcache, KVM_PGTABLE_WALK_SHARED);
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
@@ -1360,10 +1346,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	if (use_read_lock)
-		read_unlock(&kvm->mmu_lock);
-	else
-		write_unlock(&kvm->mmu_lock);
+	read_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
@@ -1569,7 +1552,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	 */
 	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
 			       PAGE_SIZE, __pfn_to_phys(pfn),
-			       KVM_PGTABLE_PROT_R, NULL);
+			       KVM_PGTABLE_PROT_R, NULL, 0);
 
 	return false;
 }
-- 
2.38.1.431.g37b22c650d-goog

