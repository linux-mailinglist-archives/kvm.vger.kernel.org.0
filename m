Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323A64C528B
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbiBZASe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241003AbiBZARa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:30 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F9622B964
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:34 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id f4-20020a17090ac28400b001bc40aa09fbso6462483pjt.6
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tmkPc6mVqQlJh3WMOsL8fy8nyqdjVjzoO3UnpmYrMsg=;
        b=C6b9FT0/F6rJ98H5T5jjPa2bRoFq8Lx2Wuvtu/Tm0E8maOHWxUvPUndwuFtwRf66wN
         U52X1vYZH6X+nfmgIeWR2HVnNAqUmJtr0gk6GJbcR0rPhdlTy8m9DXxczJ0Jd9EMhPvV
         wBY12F590v8mOrKx4Dou2alNQe2SgbmLz5rQsPWTl0P85AE1B0S737inYfaQmVAiSM7/
         dRe/4982nWWybeOn8qiZukkWM3I+/uq+81RZq9O0Ulz3Z22n9m0F6gOQvBINx7DR4k8U
         770QhageE44FtYBWUvQ3YL8eFPK+ojjqjhShwy+TLmmcaKLIiKcEzI26Y3Wj516Nw3hi
         czQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tmkPc6mVqQlJh3WMOsL8fy8nyqdjVjzoO3UnpmYrMsg=;
        b=PhcSmK/sc5AT9nM0yflQtAvVfsnLZydeY4G4hdg2kSvk9pBLJ2DMsOXCiIrzuPL4fP
         w0te+J9fqRacwUul17cPpaEOe9t7et4yn7kc461FPRqYSfGCFzRuvoi2a4vF6rNrRQB1
         tWID+KOFSWqcneUUtJAI1NDrBU5XM6efkgSdJEvzcllnQ3tlCykJnoyG4lYZr1EYnb+c
         iz9mymYIMRdVGmK+USeobXZwdKNr4/ZvqcjDS1ApYl9JX0Z/S+je9Kihxr3LTGPzUlZR
         n7WijcOJOLlZjrXxHfQuRWPUGsqYv4nIgx9ZYoX7ZBXO/VhfTXrlsMIuFEirIb9WzORp
         HAqw==
X-Gm-Message-State: AOAM530AVI36o629dJt1ToFNDA4tdjYgNJL4m703q/uomEPXhHnkbpqZ
        KKBKUQPDq4ElHo2tWw3oUdGRpfoZt7Q=
X-Google-Smtp-Source: ABdhPJzCziF3izciZ/LhfwlHVySkBsqfM2Mexof/5DjEEPPRZwwrv6yEi04D0pIlOxkKRmlhaG66XuwfZFs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea81:b0:14f:a4ce:ef79 with SMTP id
 x1-20020a170902ea8100b0014fa4ceef79mr9692264plb.136.1645834593398; Fri, 25
 Feb 2022 16:16:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:37 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-20-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 19/28] KVM: x86/mmu: Defer TLB flush to caller when freeing
 TDP MMU shadow pages
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 arch/x86/kvm/mmu/mmu.c      | 12 ++++++++++++
 arch/x86/kvm/mmu/tdp_iter.h |  7 +++----
 arch/x86/kvm/mmu/tdp_mmu.c  | 20 ++++++++++----------
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 92fe1ba27213..c1deaec795c2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6290,6 +6290,12 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	rcu_idx = srcu_read_lock(&kvm->srcu);
 	write_lock(&kvm->mmu_lock);
 
+	/*
+	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
+	 * be done under RCU protection, the pages are freed via RCU callback.
+	 */
+	rcu_read_lock();
+
 	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
 	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
 	for ( ; to_zap; --to_zap) {
@@ -6314,12 +6320,18 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 
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
index ef594af246f5..3031b42c27a6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -405,9 +405,6 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 				    shared);
 	}
 
-	kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
-					   KVM_PAGES_PER_HPAGE(level + 1));
-
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
@@ -831,19 +828,13 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
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
 
@@ -884,6 +875,11 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 	}
 
 	rcu_read_unlock();
+
+	/*
+	 * Because this flow zaps _only_ leaf SPTEs, the caller doesn't need
+	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
+	 */
 	return flush;
 }
 
@@ -1013,6 +1009,10 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
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
2.35.1.574.g5d30c73bfb-goog

