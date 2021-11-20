Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F28457B6C
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237189AbhKTEy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236963AbhKTEyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:45 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86766C06139B
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:16 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gf15-20020a17090ac7cf00b001a9a31687d0so2827120pjb.1
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2GZAYl+Hy53qDpC3NvrS/wuUUZ4gZv4FyReRm6zKr9k=;
        b=Ur6zakk5x4hwhumRZny7eXGLngAsCtIDvRAUVpQEHy8PS1ZBTqsHQr6B9U69LpFKHe
         2HQtLVHVVZiSO5nOTduOlanKXAursd7C8x8SG2AjjRw6mS/2GlF0q6xeP88SmZQrimOl
         Oj8bzbOufuUNkvfWrHSkHcXUzAaSmpsQlcKc4rBcHDiha8wZOum4VtSe7noXgwAL7GgL
         x5vzkvV1be4XuKJYmWJYGLTmAgtKL6jeb0R2cwpEotgYqsxQPyxm3A0zb5SzbwG1aLNM
         21OY4EsYoy1GvKESfjeAcHS1PKKNjPOdY8gPTV3asQnLfqn1KHEOB8sT6NBq7twV6NY4
         8G3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2GZAYl+Hy53qDpC3NvrS/wuUUZ4gZv4FyReRm6zKr9k=;
        b=i9ih6Djr4WAo3pMOGBmnRiWj7NlWqfMTH7e0iV/rBC/p8baMVou7to1Ye5bHGVE4l9
         F14yAN4JDNTmb/5/S3MaT8L3aXoibsvSu/5mRb8gCtKVcT5ZDofYvgH1o9awjXl++veC
         mjgyvdLHbhOEV1fFhIPhoClAaXE1QDSpyWPHGx9XmSREkovDzo0hgczkXd5aHC4zAZO/
         fEQzdVQFYoshvTVFFBpiu7649oOdU0an3o+jF24j+1FViyK0uro+ShXXl1Tv4wAzSAYb
         T/oyznSMIDD5WiOq84MW7lg7Xm1wwkk5LAjXgn55QC8RfsFNP25yeTrmWlj8DNn/tD9W
         Z7Qg==
X-Gm-Message-State: AOAM530bwpuJ9nYfZRyAw2hqn6m7eSRtrbpo+ejl8chD9m9iZwXg8mlp
        bcCHjmYEIF+p5qg1xneUo2Xr3LJS06w=
X-Google-Smtp-Source: ABdhPJyucCGXkzgDuupYhMHgJLccwtbQuk/8oKQKDu56tSd6NRsLZJX7fCP4h87DF07CGgK1DGUdiVnP8CU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d703:b0:144:e012:d550 with SMTP id
 w3-20020a170902d70300b00144e012d550mr17976612ply.38.1637383876088; Fri, 19
 Nov 2021 20:51:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:32 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-15-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 14/28] KVM: x86/mmu: Add helpers to read/write TDP MMU SPTEs
 and document RCU
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

Add helpers to read and write TDP MMU SPTEs instead of open coding
rcu_dereference() all over the place, and to provide a convenient
location to document why KVM doesn't exempt holding mmu_lock for write
from having to hold RCU (and any future changes to the rules).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c |  6 +++---
 arch/x86/kvm/mmu/tdp_iter.h | 16 ++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  | 14 +++++++-------
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index b3ed302c1a35..1f7741c725f6 100644
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
@@ -86,7 +86,7 @@ static bool try_step_down(struct tdp_iter *iter)
 	 * Reread the SPTE before stepping down to avoid traversing into page
 	 * tables that are no longer linked from this entry.
 	 */
-	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
+	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 
 	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
 	if (!child_pt)
@@ -120,7 +120,7 @@ static bool try_step_side(struct tdp_iter *iter)
 	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
 	iter->next_last_level_gfn = iter->gfn;
 	iter->sptep++;
-	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
+	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index b1748b988d3a..9c04d8677cb3 100644
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
index 3ff7b4cd7d0e..ca6b30a7130d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -572,7 +572,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * here since the SPTE is going from non-present
 	 * to non-present.
 	 */
-	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
+	kvm_tdp_mmu_write_spte(iter->sptep, 0);
 
 	return true;
 }
@@ -609,7 +609,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	 */
 	WARN_ON(is_removed_spte(iter->old_spte));
 
-	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
+	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
 			      new_spte, iter->level, false);
@@ -775,7 +775,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			 * The iter must explicitly re-read the SPTE because
 			 * the atomic cmpxchg failed.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 			goto retry;
 		}
 	}
@@ -1012,7 +1012,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			 * because the new value informs the !present
 			 * path below.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
@@ -1225,7 +1225,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			 * The iter must explicitly re-read the SPTE because
 			 * the atomic cmpxchg failed.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 			goto retry;
 		}
 		spte_set = true;
@@ -1296,7 +1296,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			 * The iter must explicitly re-read the SPTE because
 			 * the atomic cmpxchg failed.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 			goto retry;
 		}
 		spte_set = true;
@@ -1427,7 +1427,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			 * The iter must explicitly re-read the SPTE because
 			 * the atomic cmpxchg failed.
 			 */
-			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
 			goto retry;
 		}
 	}
-- 
2.34.0.rc2.393.gf8c9666880-goog

