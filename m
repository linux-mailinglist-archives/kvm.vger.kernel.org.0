Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D9F47E976
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240997AbhLWW0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350819AbhLWWY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:24:57 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3019C061223
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:19 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p1-20020a17090a2d8100b001b1e44000daso6385673pjd.9
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XnGypoQjpJLcdvN50ul/dpb0cgel0J6MKJVjKnPbCtA=;
        b=sG2UyMhvkZ8U2FX5mvM5cexvwtWbu7t/mCSJDI++GL1UzZe+g6T+1maB2HhgjKD0s1
         GI4/2Lx5FSZ9menQ82aQmAOUqmUAd6zKE0LdoGsXBBMXBC72/EPoW3/nM8BNWBv8YeXd
         jDHeEgoXYXXMlX/Q/pLhX4mi/dbb0jBfmkVk5ljVgEmKg9R4d+k96sTiLtoSFmCAtypX
         U57lGynZ5hGdh+94TufGd9wgMMue86300KTtpyvzCPMPGoALU5NRH4T2bpwsnc2K+UaZ
         cXVqMJQw+krN1ilxeGTr3cI5py9khd5m18cgFf065z9xS+uEq8MFK7AJ3b3bzaLy4Sg4
         AekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XnGypoQjpJLcdvN50ul/dpb0cgel0J6MKJVjKnPbCtA=;
        b=oAoyuw9ccUZch3YqbVLJqsn9XQ01KRZSnWqMEXbK28DElk5orHCPgzdqGDLQkszym4
         ixxfHT3/YM5ehDzWXQ8Tul0ZCyyuJi1OUcwoonrfZd3RaxClShrMPkquGTWYTXkkdhBg
         m+VDPNTcKaJKw8MscGKY3dAG6ugm9HlQIntrvJwzsTL12pz8Z1aFgE1icuqKN2Z04fvb
         WDzyrI391F4uc5u+xjlxuk9Msd2WXKgioRAhEdyfraf13UxLFaCWnzEoA6Aum2oCShs3
         IYyTv56UgTMrv4rcdD36SIsxhUxQEVw1Ay0o81CTmxlNVj5YsuMcJIEEwuMWsoueXjY+
         4RdQ==
X-Gm-Message-State: AOAM5306W4R5gpVBEY4/PJWacY/QCPAZhDotIY3a/88iGp5rcIEt9zI7
        OJmWkgn6+COkBvumxgw0a6mWX9Lfo0Q=
X-Google-Smtp-Source: ABdhPJwnLEBHJ17525jR+sFbQ3rwDDvhujkjePkSsWp07gUh7QThUDsSbmUrYAKVUommlH4P7XnlqZWHanE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:188:b0:149:512a:e69c with SMTP id
 z8-20020a170903018800b00149512ae69cmr3768689plg.40.1640298259192; Thu, 23 Dec
 2021 14:24:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:11 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-24-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 23/30] KVM: x86/mmu: Defer TLB flush to caller when freeing
 TDP MMU shadow pages
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
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
 arch/x86/kvm/mmu/tdp_mmu.c  | 23 +++++++++++------------
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f40773dc4c92..ff5a7f763b1e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6268,6 +6268,12 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
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
@@ -6292,12 +6298,18 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 
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
index 1de6c1c9ff7b..95bd54027e08 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -9,10 +9,9 @@
 
 /*
  * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
- * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
- * correctness if mmu_lock is held for write, but plumbing "struct kvm" down to
- * the lower* depths of the TDP MMU just to make lockdep happy is a nightmare,
- * so all* accesses to SPTEs are must be done under RCU protection.
+ * to be zapped while holding mmu_lock for read, and to allow TLB flushes to be
+ * batched without having to collect the list of zapped SPs.  Flows that can
+ * remove SPs must service pending TLB flushes prior to dropping RCU protection.
  */
 static inline u64 kvm_tdp_mmu_read_spte(tdp_ptep_t sptep)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e7086eb35599..72bcec2cd23c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -424,9 +424,6 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 				    shared);
 	}
 
-	kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
-					   KVM_PAGES_PER_HPAGE(level + 1));
-
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
@@ -822,21 +819,14 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	u64 old_spte;
+	u64 old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
 
-	rcu_read_lock();
-
-	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
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
 
@@ -878,6 +868,11 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 	}
 
 	rcu_read_unlock();
+
+	/*
+	 * Because this flows zaps _only_ leaf SPTEs, the caller doesn't need
+	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
+	 */
 	return flush;
 }
 
@@ -1007,6 +1002,10 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		ret = RET_PF_SPURIOUS;
 	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
 		return RET_PF_RETRY;
+	else if (is_shadow_present_pte(iter->old_spte) &&
+		 !is_last_spte(iter->old_spte, iter->level))
+		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+						   KVM_PAGES_PER_HPAGE(iter->level + 1));
 
 	/*
 	 * If the page fault was caused by a write but the page is write
-- 
2.34.1.448.ga2b2bfdf31-goog

