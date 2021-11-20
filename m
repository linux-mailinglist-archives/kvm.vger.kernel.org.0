Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7079A457B78
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhKTEzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237136AbhKTEyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:55 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F4EC061378
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:38 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id j6-20020a17090276c600b0014377d8ede3so5691793plt.21
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=S4JOCCsPUUv01il4bq7xVAk0JN1RDL3MFZIqYpXV/gc=;
        b=DvRqYo7YCSiwaPFC6e7L2pdRy6GddVpWyKFFGrSi166hINT7MKSjE9JdqFy8KDly0b
         h9420y7z/UogTj+WC3NKQ+vfupHPCbM2pwbq/S/ZrUbOU97Ns0zoyS11ZMTJPxE2exrX
         8CtofV/kE8ZP6D7+zLvAYitPV7aG+Wo0FM9pDI9AE6BIQtbex//+iuo7W/MwLIhfYvas
         gixr1kylm0aC9f3ok/quYHEfAWYYCiGW1EUGRav/li8n10OeYMqkEisNWW+MSV6hxDOL
         zP+pvpzPaHiIs26sbyqnV67xMf8hXwcJgfNWCP6itMfyJKTWJkA9kRuSlmLpgqrJxLix
         OWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=S4JOCCsPUUv01il4bq7xVAk0JN1RDL3MFZIqYpXV/gc=;
        b=VMECtKQEV3Trkq0dpSkvGwrNiv6AonIo1p3qsihcnKwIFV3WgcOixxXTd3dvF2hvuY
         R/4p+mbagFljvdT/AazDScPF0E/qj0tZyDk/LDbRKEMMMmh1jmJ8FV8F6+5ckVZjFOtO
         KcdKMqPHXQ/v984lq4GYFqOltUTiTbxWmskP/lwhkRmRINpdXaJHmtOwpIHZ8JaKoVD6
         gvvKa1aJtNGINzxB6uOF2pPn2a/aOKoPlhFJwav95wab+RDI6mrh9DNqy2cFblEnq70O
         iwmCBDI2haxblZ/dbzTJuVLdo+jWXtSq9YEW9d8wq7Vu5yhMfgX72/szbL/calz42yIH
         oNlw==
X-Gm-Message-State: AOAM532SPtuv8786br/40yBrXeatHR2YNKUy4SQdBrYFO+gI5wh0iMcy
        RqLKeNQEdTmwEbRZ+xnHGU5vguP3gQA=
X-Google-Smtp-Source: ABdhPJxqI2uJM9vS1nKHoAeqHJHluigvIKY6YVsqnGXp8lpNlWbedyzzsHXsRuobZfC6Mg8EM5xEjAWTvOM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:8b4a:: with SMTP id j71mr1004814pge.231.1637383897612;
 Fri, 19 Nov 2021 20:51:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:46 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-29-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 28/28] KVM: x86/mmu: Defer TLB flush to caller when freeing
 TDP MMU shadow pages
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
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
1gb hugepage and zapping a pile of SPs, and when zapping an entire root,
allows skipping the flush entirely (becaues flushes are not needed in
that case).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c      | 12 ++++++++++++
 arch/x86/kvm/mmu/tdp_iter.h |  7 +++----
 arch/x86/kvm/mmu/tdp_mmu.c  | 23 +++++++++++------------
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ef689b8bab12..7aab9737dffa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6237,6 +6237,12 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
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
@@ -6261,12 +6267,18 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 
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
index 0693f1fdb81e..0299703fc844 100644
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
index 55c16680b927..62cb357b1dff 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -433,9 +433,6 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 				    shared);
 	}
 
-	kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
-					   KVM_PAGES_PER_HPAGE(level + 1));
-
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
@@ -815,21 +812,14 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 
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
 
@@ -871,6 +861,11 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 	}
 
 	rcu_read_unlock();
+
+	/*
+	 * Because this flows zaps _only_ leaf SPTEs, the caller doesn't need
+	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
+	 */
 	return flush;
 }
 
@@ -1011,6 +1006,10 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
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
2.34.0.rc2.393.gf8c9666880-goog

