Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4A23EBD74
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhHMUfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbhHMUfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:35:38 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE26C0617AD
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:11 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ns7-20020a17090b250700b0017942fa12a8so1916236pjb.6
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=g1XjU39Wew2ggUnWSYJ2KWc8KcaVf4eBlGQoqtGdE7I=;
        b=eaQkRzioOJLAfKhXV/HRjB4+heOGPb+3/o+kKl1VLcrbw7DgxjyCix0/MlW6A4/M3X
         EUu0vDQoH0lDqUZfVU0mSVMuN8/k8DPzXQL/0qzdKj+Fbac+WLs22v4UuZ3JG7X/4/GL
         LLDDrCa2FK5LP9ChtRiDLloqtNNTxFvMAdj8JVj10e0E2phLSdPU+/9Zv9PoYt52+iCa
         r0zwSqje8UEOrIf5Dqij0mkdLOJBKi+T17InaNCCTiDO9GAQTDB6pSf262mVHdv7p0aA
         vfDVPuQDjZDh4XQEmn5EdSewstltb2ITGdZfC7HG+tEZN6mQrOyRmybYYZr67yia0dNq
         qPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=g1XjU39Wew2ggUnWSYJ2KWc8KcaVf4eBlGQoqtGdE7I=;
        b=byU7vq2mvWuYCZWlFwttogvHmLXDXuYtuet19qU4KiawakodGjOX91LWgp81SJjfl2
         ioB6zK7vWAmNOETzEWJ4g0zqL4HV35WsaWgdzm7urt4eNI870ztvTLzu5gANf3x1+Em2
         CzjkvIMxKx9UGf+tp4soCALLoNfzRhkhYzWR4CxSMhPe/o+LXjhbon7mwM0VGcvZYatL
         nGkpi8VHqz6VTBMgir5h2mSx+fdys2cuHME6BlQM1YztGHEThYZz+j8oJP8Ecw508lR9
         7igcIUuvbCllhzWE+JCX/NRFvEa9yq6beaJWKnC2QwFPoHdf72R89Jy+rE9DirmEItTx
         NWmQ==
X-Gm-Message-State: AOAM5305n2SA05xG0tNSRzbeqgpHrDTb1SOP3vP8k1OrOEqnK9jRH0Lf
        qPth44DBF5vpnQtY2HhGL6lPHMvDhj/qPA==
X-Google-Smtp-Source: ABdhPJxE04ZTynZYa1+HXenoA4rbBOrTxJ/7TMnUxe1gXnJKZ9ZehHb9hVjcCXOvixXMi41VQndvjWeQt/iOYw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:10cb:b029:3c6:8cc9:5098 with
 SMTP id d11-20020a056a0010cbb02903c68cc95098mr4100359pfu.41.1628886911141;
 Fri, 13 Aug 2021 13:35:11 -0700 (PDT)
Date:   Fri, 13 Aug 2021 20:35:01 +0000
In-Reply-To: <20210813203504.2742757-1-dmatlack@google.com>
Message-Id: <20210813203504.2742757-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20210813203504.2742757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [RFC PATCH 3/6] KVM: x86/mmu: Pass the memslot around via struct kvm_page_fault
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memslot for the faulting gfn is used throughout the page fault
handling code, so capture it in kvm_page_fault as soon as we know the
gfn and use it in the page fault handling code that has direct access
to the kvm_page_fault struct.

This, in combination with the subsequent patch, improves "Populate
memory time" in dirty_log_perf_test by 5% when using the legacy MMU.
There is no discerable improvement to the performance of the TDP MMU.

No functional change intended.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu.h             |  3 +++
 arch/x86/kvm/mmu/mmu.c         | 27 +++++++++------------------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c     | 10 +++++-----
 4 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2c726b255fa8..8d13333f0345 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -158,6 +158,9 @@ struct kvm_page_fault {
 	/* Shifted addr, or result of guest page table walk if addr is a gva.  */
 	gfn_t gfn;
 
+	/* The memslot containing gfn. May be NULL. */
+	struct kvm_memory_slot *slot;
+
 	/* Outputs of kvm_faultin_pfn.  */
 	kvm_pfn_t pfn;
 	hva_t hva;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3352312ab1c9..fb2c95e8df00 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2890,7 +2890,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_memory_slot *slot;
+	struct kvm_memory_slot *slot = fault->slot;
 	kvm_pfn_t mask;
 
 	fault->huge_page_disallowed = fault->exec && fault->nx_huge_page_workaround_enabled;
@@ -2901,8 +2901,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
 		return;
 
-	slot = gfn_to_memslot_dirty_bitmap(vcpu, fault->gfn, true);
-	if (!slot)
+	if (kvm_slot_dirty_track_enabled(slot))
 		return;
 
 	/*
@@ -3076,13 +3075,9 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
  * someone else modified the SPTE from its original value.
  */
 static bool
-fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			u64 *sptep, u64 old_spte, u64 new_spte)
 {
-	gfn_t gfn;
-
-	WARN_ON(!sp->role.direct);
-
 	/*
 	 * Theoretically we could also set dirty bit (and flush TLB) here in
 	 * order to eliminate unnecessary PML logging. See comments in
@@ -3098,14 +3093,8 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (cmpxchg64(sptep, old_spte, new_spte) != old_spte)
 		return false;
 
-	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
-		/*
-		 * The gfn of direct spte is stable since it is
-		 * calculated by sp->gfn.
-		 */
-		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
-	}
+	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
+		mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);
 
 	return true;
 }
@@ -3233,7 +3222,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * since the gfn is not stable for indirect shadow page. See
 		 * Documentation/virt/kvm/locking.rst to get more detail.
 		 */
-		if (fast_pf_fix_direct_spte(vcpu, sp, sptep, spte, new_spte)) {
+		if (fast_pf_fix_direct_spte(vcpu, fault, sptep, spte, new_spte)) {
 			ret = RET_PF_FIXED;
 			break;
 		}
@@ -3823,7 +3812,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault, int *r)
 {
-	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
+	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
 
 	/*
@@ -3888,6 +3877,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	int r;
 
 	fault->gfn = fault->addr >> PAGE_SHIFT;
+	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
+
 	if (page_fault_handle_page_track(vcpu, fault))
 		return RET_PF_EMULATE;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f70afecbf3a2..50ade6450ace 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -847,6 +847,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	fault->gfn = walker.gfn;
+	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
+
 	if (page_fault_handle_page_track(vcpu, fault)) {
 		shadow_page_table_clear_flood(vcpu, fault->addr);
 		return RET_PF_EMULATE;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 47ec9f968406..6f733a68d750 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -533,6 +533,7 @@ static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
  * TDP page fault.
  *
  * @vcpu: The vcpu instance that took the TDP page fault.
+ * @fault: The kvm_page_fault being resolved by this SPTE.
  * @iter: a tdp_iter instance currently on the SPTE that should be set
  * @new_spte: The value the SPTE should be set to
  *
@@ -540,6 +541,7 @@ static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
  *	    this function will have no side-effects.
  */
 static inline bool tdp_mmu_map_set_spte_atomic(struct kvm_vcpu *vcpu,
+					       struct kvm_page_fault *fault,
 					       struct tdp_iter *iter,
 					       u64 new_spte)
 {
@@ -553,12 +555,10 @@ static inline bool tdp_mmu_map_set_spte_atomic(struct kvm_vcpu *vcpu,
 	 * handle_changed_spte_dirty_log() to leverage vcpu->last_used_slot.
 	 */
 	if (is_writable_pte(new_spte)) {
-		struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, iter->gfn);
-
-		if (slot && kvm_slot_dirty_track_enabled(slot)) {
+		if (fault->slot && kvm_slot_dirty_track_enabled(fault->slot)) {
 			/* Enforced by kvm_mmu_hugepage_adjust. */
 			WARN_ON_ONCE(iter->level > PG_LEVEL_4K);
-			mark_page_dirty_in_slot(kvm, slot, iter->gfn);
+			mark_page_dirty_in_slot(kvm, fault->slot, iter->gfn);
 		}
 	}
 
@@ -934,7 +934,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else if (!tdp_mmu_map_set_spte_atomic(vcpu, iter, new_spte))
+	else if (!tdp_mmu_map_set_spte_atomic(vcpu, fault, iter, new_spte))
 		return RET_PF_RETRY;
 
 	/*
-- 
2.33.0.rc1.237.g0d66db33f3-goog

