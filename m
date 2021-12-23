Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7007F47E961
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350791AbhLWWYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350584AbhLWWYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:24:04 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C516C061784
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:04 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id b4-20020a17090a6e0400b001b179d36a57so6390372pjk.6
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BNNkx5iDOAmq+UI4vOkeZBthRbL3U3mJe4quYYQ4WIc=;
        b=ELA1VF+P7266N3tFYQZiX57UD7CJ9nzv9z97D9a7u4zYcnIW7U/YemfMb25FGYe3mH
         DRcZ5+3JvJ3mc5zka3nwe/0efPQHWwqiH2XmUenaRFwXPha7bT4tkZkZ+wpVlrdhuIyI
         52KVymQHUuzdgNJIfAjF2sZZzraeV3GlVvPdMK0AbxuVVvCRA+bA4oC3rXrqu0FpUzMz
         Sshre2GWrf7S/JYqmudAL+Yr8BmDPGAX7GNqyuUzioByhRgT7qLgIZG8yuq5T4uie9AL
         kAGV03e4SN2X10if6CXLT4Z8o09/HhDJvZKfIzigw1YxZIW0KXN8X8EYd6xUjFIdd9fh
         oQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BNNkx5iDOAmq+UI4vOkeZBthRbL3U3mJe4quYYQ4WIc=;
        b=beW//Kb9UG9xJH9+j1j9Ybzeu0hvkdd33RIMSD4avE2pjMU4RknV843NUGAM0Dj+n5
         bweUkkujTkh+YcEiQc8cMBn8YQ9GlvDTq/HzhQ69AErMD4Sowtw1qJeQ3ZuV1Om29DJZ
         pWf2doEv9AFf0Tjx5YaNPgbnv9xrUX0qI9D2WQUkXA6Tr3Pai1iWDrCHkAoKSzXAMjXd
         Nmp1Gz61oZGxXmlL8kb61ptvUFXsKZD9uByaQcafjcEBvtLd4hzimRKXuyRqZv0BHBU/
         GG9PAWxbrwxUErJDNOa/sqNUIZQJQEm4ALGU+ldFZA9h8NuCvjtXTS8is+f5tnzpVQUa
         Dlpw==
X-Gm-Message-State: AOAM531oPvyMkXlHdn1o5mtPSxzFj0zCKy9Iym6PMrS+B6eE5MG2xgo1
        U2zi1pIgasyOKa/kb/7ajVGZoweAKlc=
X-Google-Smtp-Source: ABdhPJxrCGl+X5LAgyGiaOibHR8XaD5zaKzAM30Bk0/2KTJtfA6wwRp3IzYbzyk0a1nr52rei86LKPIdARQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:3d42:: with SMTP id
 o2mr738615pjf.1.1640298243595; Thu, 23 Dec 2021 14:24:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:02 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-15-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 14/30] KVM: x86/mmu: Add helpers to read/write TDP MMU
 SPTEs and document RCU
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

Add helpers to read and write TDP MMU SPTEs instead of open coding
rcu_dereference() all over the place, and to provide a convenient
location to document why KVM doesn't exempt holding mmu_lock for write
from having to hold RCU (and any future changes to the rules).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c |  6 +++---
 arch/x86/kvm/mmu/tdp_iter.h | 16 ++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  | 14 +++++++-------
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index caa96c270b95..de31f3e68668 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -12,7 +12,7 @@ static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 {
 	iter->sptep = iter->pt_path[iter->level - 1] +
 		SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
-	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
+	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 }
 
 static gfn_t round_gfn_for_level(gfn_t gfn, int level)
@@ -87,7 +87,7 @@ static bool try_step_down(struct tdp_iter *iter)
 	 * Reread the SPTE before stepping down to avoid traversing into page
 	 * tables that are no longer linked from this entry.
 	 */
-	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
+	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 
 	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
 	if (!child_pt)
@@ -121,7 +121,7 @@ static bool try_step_side(struct tdp_iter *iter)
 	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
 	iter->next_last_level_gfn = iter->gfn;
 	iter->sptep++;
-	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
+	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index e19cabbcb65c..3cdfaf391a49 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -9,6 +9,22 @@
 
 typedef u64 __rcu *tdp_ptep_t;
 
+/*
+ * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
+ * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
+ * correctness if mmu_lock is held for write, but plumbing "struct kvm" down to
+ * the lower* depths of the TDP MMU just to make lockdep happy is a nightmare,
+ * so all* accesses to SPTEs are must be done under RCU protection.
+ */
+static inline u64 kvm_tdp_mmu_read_spte(tdp_ptep_t sptep)
+{
+	return READ_ONCE(*rcu_dereference(sptep));
+}
+static inline void kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 val)
+{
+	WRITE_ONCE(*rcu_dereference(sptep), val);
+}
+
 /*
  * A TDP iterator performs a pre-order walk over a TDP paging structure.
  */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 47424e22a681..41c3a1cff3e7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -603,7 +603,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * here since the SPTE is going from non-present
 	 * to non-present.
 	 */
-	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
+	kvm_tdp_mmu_write_spte(iter->sptep, 0);
 
 	return true;
 }
@@ -642,7 +642,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	 */
 	WARN_ON(is_removed_spte(iter->old_spte));
 
-	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
+	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
 			      new_spte, iter->level, false);
@@ -807,7 +807,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			 * The iter must explicitly re-read the SPTE because
 			 * the atomic cmpxchg failed.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 			goto retry;
 		}
 	}
@@ -1011,7 +1011,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			 * because the new value informs the !present
 			 * path below.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
@@ -1217,7 +1217,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			 * The iter must explicitly re-read the SPTE because
 			 * the atomic cmpxchg failed.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 			goto retry;
 		}
 		spte_set = true;
@@ -1288,7 +1288,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			 * The iter must explicitly re-read the SPTE because
 			 * the atomic cmpxchg failed.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 			goto retry;
 		}
 		spte_set = true;
@@ -1419,7 +1419,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			 * The iter must explicitly re-read the SPTE because
 			 * the atomic cmpxchg failed.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 			goto retry;
 		}
 	}
-- 
2.34.1.448.ga2b2bfdf31-goog

