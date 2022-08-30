Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829265A6DDD
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiH3Twi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiH3Twd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:52:33 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CA07F09B;
        Tue, 30 Aug 2022 12:52:29 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661889147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Aaj6aduqJg0qPG7z7QEPBrvjXDSrf093O5MldGzyJW0=;
        b=GETBblIBmkxAJ4C0aV0FyXIWdykr0NSb97rmSxC7cm9TB+hS6KWX4O93m4eZGwVKCKxaa/
        H8m7yaCmeOAuKCdirUXCROdaWetwUGunlab4cdY927z1X2UYORkwuny0Nhby80fYNaW11D
        3zsdb9kIDVw4nAvyUC9po0SNDjNSkJU=
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
Subject: [PATCH 14/14] KVM: arm64: Handle stage-2 faults in parallel
Date:   Tue, 30 Aug 2022 19:52:15 +0000
Message-Id: <20220830195216.964988-1-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/arm64/include/asm/kvm_pgtable.h  |  4 +++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  2 +-
 arch/arm64/kvm/hyp/pgtable.c          |  3 ++-
 arch/arm64/kvm/mmu.c                  | 31 ++++++---------------------
 4 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 7d2de0a98ccb..dc839db86a1a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -355,6 +355,8 @@ void kvm_pgtable_stage2_free_removed(void *pgtable, u32 level, void *arg);
  * @prot:	Permissions and attributes for the mapping.
  * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
  *		page-table pages.
+ * @shared:	true if multiple software walkers could be traversing the tables
+ *		in parallel
  *
  * The offset of @addr within a page is ignored, @size is rounded-up to
  * the next page boundary and @phys is rounded-down to the previous page
@@ -376,7 +378,7 @@ void kvm_pgtable_stage2_free_removed(void *pgtable, u32 level, void *arg);
  */
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   void *mc);
+			   void *mc, bool shared);
 
 /**
  * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 61cf223e0796..924d028af447 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -252,7 +252,7 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
 				      enum kvm_pgtable_prot prot)
 {
 	return kvm_pgtable_stage2_map(&host_kvm.pgt, start, end - start, start,
-				      prot, &host_s2_pool);
+				      prot, &host_s2_pool, false);
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 92e230e7bf3a..52ecaaa84b22 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -944,7 +944,7 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_
 
 int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   u64 phys, enum kvm_pgtable_prot prot,
-			   void *mc)
+			   void *mc, bool shared)
 {
 	int ret;
 	struct stage2_map_data map_data = {
@@ -953,6 +953,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.memcache	= mc,
 		.mm_ops		= pgt->mm_ops,
 		.force_pte	= pgt->force_pte_cb && pgt->force_pte_cb(addr, addr + size, prot),
+		.shared		= shared,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 265951c05879..a73adc35cf41 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -840,7 +840,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 		write_lock(&kvm->mmu_lock);
 		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
-					     &cache);
+					     &cache, false);
 		write_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
@@ -1135,7 +1135,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	bool use_read_lock = false;
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1170,8 +1169,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
-		use_read_lock = (fault_status == FSC_PERM && write_fault &&
-				 fault_granule == PAGE_SIZE);
 	} else {
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
@@ -1270,15 +1267,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1322,15 +1311,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
+					     memcache, true);
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
@@ -1339,10 +1325,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1548,7 +1531,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	 */
 	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
 			       PAGE_SIZE, __pfn_to_phys(pfn),
-			       KVM_PGTABLE_PROT_R, NULL);
+			       KVM_PGTABLE_PROT_R, NULL, false);
 
 	return false;
 }
-- 
2.37.2.672.g94769d06f0-goog

