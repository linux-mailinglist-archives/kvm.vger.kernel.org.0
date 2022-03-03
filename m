Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D534CC62F
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbiCCTku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234817AbiCCTkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:40:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5250D1A2705
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uXMJFnpMtnH5wSFYNxP8RRVBPwgpGiauSF2oRw961Ug=;
        b=hK5e096B+WUdBO0ho1Wkok9rvDEO+rxbAhV+swmRzY/IlgUyMHjzAp7Cl7QjF1ZwI04lIs
        qzlVgHDGFz28fwmFeiyaFVtwkcVogwRy/F9P59t7jKi07sm+TFtg+eDgNuKs9WqYEEvjCi
        AW8MWGHpOmuNMo0PgJ0YrQ/UcNFuBMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-EDxymfhwNtWtyuhC7jxDgQ-1; Thu, 03 Mar 2022 14:39:13 -0500
X-MC-Unique: EDxymfhwNtWtyuhC7jxDgQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A77E81006AA5;
        Thu,  3 Mar 2022 19:39:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 652E468D90;
        Thu,  3 Mar 2022 19:39:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 20/30] KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow pages
Date:   Thu,  3 Mar 2022 14:38:32 -0500
Message-Id: <20220303193842.370645-21-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Defer TLB flushes to the caller when freeing TDP MMU shadow pages instead
of immediately flushing.  Because the shadow pages are freed in an RCU
callback, so long as at least one CPU holds RCU, all CPUs are protected.
For vCPUs running in the guest, i.e. consuming TLB entries, KVM only
needs to ensure the caller services the pending TLB flush before dropping
its RCU protections.  I.e. use the caller's RCU as a proxy for all vCPUs
running in the guest.

Deferring the flushes allows batching flushes, e.g. when installing a
1gb hugepage and zapping a pile of SPs.  And when zapping an entire root,
deferring flushes allows skipping the flush entirely (because flushes are
not needed in that case).

Avoiding flushes when zapping an entire root is especially important as
synchronizing with other CPUs via IPI after zapping every shadow page can
cause significant performance issues for large VMs.  The issue is
exacerbated by KVM zapping entire top-level entries without dropping
RCU protection, which can lead to RCU stalls even when zapping roots
backing relatively "small" amounts of guest memory, e.g. 2tb.  Removing
the IPI bottleneck largely mitigates the RCU issues, though it's likely
still a problem for 5-level paging.  A future patch will further address
the problem by zapping roots in multiple passes to avoid holding RCU for
an extended duration.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220226001546.360188-20-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c      | 13 +++++++++++++
 arch/x86/kvm/mmu/tdp_iter.h |  7 +++----
 arch/x86/kvm/mmu/tdp_mmu.c  | 20 ++++++++++----------
 3 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index febdcaaa7b94..0b88592495f8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6349,6 +6349,13 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	rcu_idx = srcu_read_lock(&kvm->srcu);
 	write_lock(&kvm->mmu_lock);
 
+	/*
+	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
+	 * be done under RCU protection, because the pages are freed via RCU
+	 * callback.
+	 */
+	rcu_read_lock();
+
 	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
 	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
 	for ( ; to_zap; --to_zap) {
@@ -6373,12 +6380,18 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
 			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
+			rcu_read_unlock();
+
 			cond_resched_rwlock_write(&kvm->mmu_lock);
 			flush = false;
+
+			rcu_read_lock();
 		}
 	}
 	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 
+	rcu_read_unlock();
+
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index e2a7e267a77d..b1eaf6ec0e0b 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -9,10 +9,9 @@
 
 /*
  * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
- * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
- * correctness if mmu_lock is held for write, but plumbing "struct kvm" down to
- * the lower depths of the TDP MMU just to make lockdep happy is a nightmare, so
- * all accesses to SPTEs are done under RCU protection.
+ * to be zapped while holding mmu_lock for read, and to allow TLB flushes to be
+ * batched without having to collect the list of zapped SPs.  Flows that can
+ * remove SPs must service pending TLB flushes prior to dropping RCU protection.
  */
 static inline u64 kvm_tdp_mmu_read_spte(tdp_ptep_t sptep)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3a866fcb5ea9..5038de0c872d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -391,9 +391,6 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 				    shared);
 	}
 
-	kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
-					   KVM_PAGES_PER_HPAGE(level + 1));
-
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
@@ -817,19 +814,13 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (WARN_ON_ONCE(!sp->ptep))
 		return false;
 
-	rcu_read_lock();
-
 	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
-	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte))) {
-		rcu_read_unlock();
+	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
 		return false;
-	}
 
 	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
 			   sp->gfn, sp->role.level + 1, true, true);
 
-	rcu_read_unlock();
-
 	return true;
 }
 
@@ -870,6 +861,11 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 	}
 
 	rcu_read_unlock();
+
+	/*
+	 * Because this flow zaps _only_ leaf SPTEs, the caller doesn't need
+	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
+	 */
 	return flush;
 }
 
@@ -1036,6 +1032,10 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		ret = RET_PF_SPURIOUS;
 	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
 		return RET_PF_RETRY;
+	else if (is_shadow_present_pte(iter->old_spte) &&
+		 !is_last_spte(iter->old_spte, iter->level))
+		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+						   KVM_PAGES_PER_HPAGE(iter->level + 1));
 
 	/*
 	 * If the page fault was caused by a write but the page is write
-- 
2.31.1


