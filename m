Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435D64C52A4
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiBZARa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240728AbiBZARC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:02 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBBA2255AC
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:23 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id r8-20020a638f48000000b0036c6a881088so3491430pgn.2
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Nb5T6qukJfhOngauD2ESxpCO0BeOqZQialSaNjnnS68=;
        b=YRhZoUpI1WKzeeuxXZCk7f2N6l4lfLKrp/cTyzEUwa85H3cFJoLfqi83eCctqMW7Sy
         PO4FOeZtACnJq/1EfPBDGPHhsxlusMOAKKNVJuWVwid/8z0LbaWU7d4wuSNrwSaELNTa
         dOTtF/gQ8jz+CyzwdFWdxOd7guqCQ/4EDBxXvC8t8EwLmJRPzShQcN6DWGkv70B6rmR+
         UcWCqS6GfPRrvpwUAEuv97Bso93hOkxN5wZIxlyKbW3TuxXHgGHpUHBzpkmK0jh6QjKf
         sbjhpKJiGl1Vl4mbfn4bBNm/pWlUJ+3tK8rJR135lKfwhAKh7/0BejsFrgr9/86gJOvR
         gXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Nb5T6qukJfhOngauD2ESxpCO0BeOqZQialSaNjnnS68=;
        b=7kuHs/0djDh3RphvNTCP+1laI1jeGnSwAG570GpiWE4ZmItBwXgExwTT9gXIzzO2Kb
         Uk35FX60YZz2j+9SNsAOhjyG2Mf5E6I3jyK8DMiHjNdbNEn8IbvJHKsZy1RCFj5p5NZ7
         ajxlCo1rmYciXG7xFIT/mTPqzANOJrkaUoQUIo8Air/Dlm+r90b/qyFXXyA+qek4QDXn
         45smz3XH2LWKEbBAWr1m2UQka176ajfdLhLFM4NJA0akb1PHX9kCkc5re0h/eYfi3BW7
         fGov7Ia4TUM5F87H0W2dM6wvnXs3XdfR137bZHO+GXfblVcmOPdaBFXaJKXGaZiXKeti
         FgGw==
X-Gm-Message-State: AOAM531DL7tXw/Jw2O6L0rdmWcIDZliRGHHT5yKjS/JemI2ibfhq1xy6
        D1xVOSVMF/ZI1XBz9j8e/rOhdcVZ028=
X-Google-Smtp-Source: ABdhPJwCvauD91w5CnudMRn251U0c/3mR0mjM4DYE6FTyCQ8OHHKIg0SuJEnTbT2acnNwjL5J5yrQTyQP5o=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:be10:b0:14d:66b5:7065 with SMTP id
 r16-20020a170902be1000b0014d66b57065mr9466370pls.81.1645834583158; Fri, 25
 Feb 2022 16:16:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:31 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 13/28] KVM: x86/mmu: Zap only the target TDP MMU shadow
 page in NX recovery
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

When recovering a potential hugepage that was shattered for the iTLB
multihit workaround, precisely zap only the target page instead of
iterating over the TDP MMU to find the SP that was passed in.  This will
allow future simplification of zap_gfn_range() by having it zap only
leaf SPTEs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h |  7 ++++++-
 arch/x86/kvm/mmu/tdp_iter.h     |  2 --
 arch/x86/kvm/mmu/tdp_mmu.c      | 36 +++++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h      | 18 +----------------
 4 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index da6166b5c377..be063b6c91b7 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -30,6 +30,8 @@ extern bool dbg;
 #define INVALID_PAE_ROOT	0
 #define IS_VALID_PAE_ROOT(x)	(!!(x))
 
+typedef u64 __rcu *tdp_ptep_t;
+
 struct kvm_mmu_page {
 	/*
 	 * Note, "link" through "spt" fit in a single 64 byte cache line on
@@ -59,7 +61,10 @@ struct kvm_mmu_page {
 		refcount_t tdp_mmu_root_count;
 	};
 	unsigned int unsync_children;
-	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
+	union {
+		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
+		tdp_ptep_t ptep;
+	};
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 	struct list_head lpage_disallowed_link;
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index bb9b581f1ee4..e2a7e267a77d 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -7,8 +7,6 @@
 
 #include "mmu.h"
 
-typedef u64 __rcu *tdp_ptep_t;
-
 /*
  * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
  * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9e8ba6f12ebf..c231b60e1726 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -213,13 +213,14 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 	return sp;
 }
 
-static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, gfn_t gfn,
-			      union kvm_mmu_page_role role)
+static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
+			    gfn_t gfn, union kvm_mmu_page_role role)
 {
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	sp->role = role;
 	sp->gfn = gfn;
+	sp->ptep = sptep;
 	sp->tdp_mmu_page = true;
 
 	trace_kvm_mmu_get_page(sp, true);
@@ -236,7 +237,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	role = parent_sp->role;
 	role.level--;
 
-	tdp_mmu_init_sp(child_sp, iter->gfn, role);
+	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
@@ -258,7 +259,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	}
 
 	root = tdp_mmu_alloc_sp(vcpu);
-	tdp_mmu_init_sp(root, 0, role);
+	tdp_mmu_init_sp(root, NULL, 0, role);
 
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
@@ -750,6 +751,33 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
 }
 
+bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	u64 old_spte;
+
+	/*
+	 * This helper intentionally doesn't allow zapping a root shadow page,
+	 * which doesn't have a parent page table and thus no associated entry.
+	 */
+	if (WARN_ON_ONCE(!sp->ptep))
+		return false;
+
+	rcu_read_lock();
+
+	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
+	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte))) {
+		rcu_read_unlock();
+		return false;
+	}
+
+	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
+			   sp->gfn, sp->role.level + 1, true, true);
+
+	rcu_read_unlock();
+
+	return true;
+}
+
 /*
  * Tears down the mappings for the range of gfns, [start, end), and frees the
  * non-root pages mapping GFNs strictly within that range. Returns true if
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 57c73d8f76ce..5e5ef2576c81 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -22,24 +22,8 @@ static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
 {
 	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
 }
-static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level + 1);
-
-	/*
-	 * Don't allow yielding, as the caller may have a flush pending.  Note,
-	 * if mmu_lock is held for write, zapping will never yield in this case,
-	 * but explicitly disallow it for safety.  The TDP MMU does not yield
-	 * until it has made forward progress (steps sideways), and when zapping
-	 * a single shadow page that it's guaranteed to see (thus the mmu_lock
-	 * requirement), its "step sideways" will always step beyond the bounds
-	 * of the shadow page's gfn range and stop iterating before yielding.
-	 */
-	lockdep_assert_held_write(&kvm->mmu_lock);
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
-					   sp->gfn, end, false, false);
-}
 
+bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
-- 
2.35.1.574.g5d30c73bfb-goog

