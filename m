Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E764767A61
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbjG2Ayl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbjG2Axw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:53:52 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D124C19
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:53:11 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bba9a0da10so18263445ad.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591931; x=1691196731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=scefrr3SIufw6sNZG0VjXNno2RViLSFvpYi41J7nSSE=;
        b=x5RzGi3sYi9BiTkBJxkYuke/eRiSqxxn6e8LLPx+jc0R1g87xw23xc1uTMjhHPOhUj
         51SR01z5k7qEZgwqE7HuF/7KW+s8T8fdPQsjvQ7vgqnc7jblmNVQ5XVZSEeB1s2dZOtE
         mSuV919P1mcYTdRWKawEg7mkLNFRbUIAMMlAJjIiyEC6+Y4fwbaCJRCSqUD939LeJL3+
         K06Khr/NfX9YrBf/pgpC1WLGKhooduG1EbwFzsoxeHbhUnt1T/Xg+MjLnVhYgGr0nOQ5
         tY3nn+OuNMHlBrmhxoQ34+vkxNMy1DSh8xo1E1iaPsNl2Umkqub1UjtNMBdpuirs9YRA
         EcRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591931; x=1691196731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=scefrr3SIufw6sNZG0VjXNno2RViLSFvpYi41J7nSSE=;
        b=PgHv0dRduyxmqQyYp4Ig6yZoH6N54hZi95vO4k6Gina1ia4TVm+W1Dyu7Kn86zE7Ya
         BShS91T7rGCJgo4CBE1H/59Rk3x/1GdfsDMvKvUixDjBq2Dty1syQ7dYOeNDr5h1Pc2Z
         Efi05PSh2HCilnkH/rhtydXa2IR/6IXkGb8Y4J1FbUVy8fYe9hbGpg/jsFye6BA7g6ws
         qe4oBi6CkGcsNBI/Trx7DR6YLHtA7PF71I68ytbdEIkV9D1Bqac+znoTm++93ASOShMM
         7ok6GkAEEpsFq60ZZ3Hl4B27AdXVLxDHCTbmX4oY04RnyoHrFAzLkruPNouYWi9pov4u
         tzIg==
X-Gm-Message-State: ABy/qLaMybXgIOBeQ4tCJDL3MqyV4pd/cclMTDMAMiAloD6/oD/71bdL
        rW1SvnOB0DzjFGn16elAVjXAO6BTbSw=
X-Google-Smtp-Source: APBJJlFdKpDKSf4oUz2CUbPZ6BWw60qvC2qZQ71C6Ase8j60mH9EApUOPtfLZAvqBe2m00AFHwRsWu7gRTw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e748:b0:1b5:61d3:dae5 with SMTP id
 p8-20020a170902e74800b001b561d3dae5mr14358plf.1.1690591931517; Fri, 28 Jul
 2023 17:52:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:52:00 -0700
In-Reply-To: <20230729005200.1057358-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729005200.1057358-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729005200.1057358-6-seanjc@google.com>
Subject: [PATCH v2 5/5] KVM: x86/mmu: Use dummy root, backed by zero page, for
 !visible guest roots
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
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

When attempting to allocate a shadow root for a !visible guest root gfn,
e.g. that resides in MMIO space, load a dummy root that is backed by the
zero page instead of immediately synthesizing a triple fault shutdown
(using the zero page ensures any attempt to translate memory will generate
a !PRESENT fault and thus VM-Exit).

Unless the vCPU is racing with memslot activity, KVM will inject a page
fault due to not finding a visible slot in FNAME(walk_addr_generic), i.e.
the end result is mostly same, but critically KVM will inject a fault only
*after* KVM runs the vCPU with the bogus root.

Waiting to inject a fault until after running the vCPU fixes a bug where
KVM would bail from nested VM-Enter if L1 tried to run L2 with TDP enabled
and a !visible root.  Even though a bad root will *probably* lead to
shutdown, (a) it's not guaranteed and (b) the CPU won't read the
underlying memory until after VM-Enter succeeds.  E.g. if L1 runs L2 with
a VMX preemption timer value of '0', then architecturally the preemption
timer VM-Exit is guaranteed to occur before the CPU executes any
instruction, i.e. before the CPU needs to translate a GPA to a HPA (so
long as there are no injected events with higher priority than the
preemption timer).

If KVM manages to get to FNAME(fetch) with a dummy root, e.g. because
userspace created a memslot between installing the dummy root and handling
the page fault, simply unload the MMU to allocate a new root and retry the
instruction.  Use KVM_REQ_MMU_FREE_OBSOLETE_ROOTS to drop the root, as
invoking kvm_mmu_free_roots() while holding mmu_lock would deadlock, and
conceptually the dummy root has indeeed become obsolete.  The only
difference versus existing usage of KVM_REQ_MMU_FREE_OBSOLETE_ROOTS is
that the root has become obsolete due to memslot *creation*, not memslot
deletion or movement.

Reported-by: Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Cc Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 47 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/mmu_internal.h | 10 +++++++
 arch/x86/kvm/mmu/paging_tmpl.h  | 11 ++++++++
 arch/x86/kvm/mmu/spte.h         |  3 +++
 4 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dd8cc46551b2..565988c81b57 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3620,7 +3620,9 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 					   &invalid_list);
 
 	if (free_active_root) {
-		if (root_to_sp(mmu->root.hpa)) {
+		if (kvm_mmu_is_dummy_root(mmu->root.hpa)) {
+			/* Nothing to cleanup for dummy roots. */
+		} else if (root_to_sp(mmu->root.hpa)) {
 			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
 		} else if (mmu->pae_root) {
 			for (i = 0; i < 4; ++i) {
@@ -3668,19 +3670,6 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
 
-
-static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
-{
-	int ret = 0;
-
-	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
-		ret = 1;
-	}
-
-	return ret;
-}
-
 static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 			    u8 level)
 {
@@ -3818,8 +3807,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
-	if (mmu_check_root(vcpu, root_gfn))
-		return 1;
+	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
+		mmu->root.hpa = kvm_mmu_get_dummy_root();
+		return 0;
+	}
 
 	/*
 	 * On SVM, reading PDPTRs might access guest memory, which might fault
@@ -3831,8 +3822,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			if (!(pdptrs[i] & PT_PRESENT_MASK))
 				continue;
 
-			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
-				return 1;
+			if (!kvm_vcpu_is_visible_gfn(vcpu, pdptrs[i] >> PAGE_SHIFT))
+				pdptrs[i] = 0;
 		}
 	}
 
@@ -3999,7 +3990,7 @@ static bool is_unsync_root(hpa_t root)
 {
 	struct kvm_mmu_page *sp;
 
-	if (!VALID_PAGE(root))
+	if (!VALID_PAGE(root) || kvm_mmu_is_dummy_root(root))
 		return false;
 
 	/*
@@ -4405,6 +4396,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 {
 	int r;
 
+	/* Dummy roots are used only for shadowing bad guest roots. */
+	if (WARN_ON_ONCE(kvm_mmu_is_dummy_root(vcpu->arch.mmu->root.hpa)))
+		return RET_PF_RETRY;
+
 	if (page_fault_handle_page_track(vcpu, fault))
 		return RET_PF_EMULATE;
 
@@ -4642,9 +4637,8 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
 			    gpa_t new_pgd, union kvm_mmu_page_role new_role)
 {
 	/*
-	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
-	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
-	 * later if necessary.
+	 * Limit reuse to 64-bit hosts+VMs without "special" roots in order to
+	 * avoid having to deal with PDPTEs and other complexities.
 	 */
 	if (VALID_PAGE(mmu->root.hpa) && !root_to_sp(mmu->root.hpa))
 		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
@@ -5557,14 +5551,19 @@ static bool is_obsolete_root(struct kvm *kvm, hpa_t root_hpa)
 
 	/*
 	 * When freeing obsolete roots, treat roots as obsolete if they don't
-	 * have an associated shadow page.  This does mean KVM will get false
+	 * have an associated shadow page, as it's impossible to determine if
+	 * such roots are fresh or stale.  This does mean KVM will get false
 	 * positives and free roots that don't strictly need to be freed, but
 	 * such false positives are relatively rare:
 	 *
-	 *  (a) only PAE paging and nested NPT has roots without shadow pages
+	 *  (a) only PAE paging and nested NPT have roots without shadow pages
+	 *      (or any shadow paging flavor with a dummy root, see note below)
 	 *  (b) remote reloads due to a memslot update obsoletes _all_ roots
 	 *  (c) KVM doesn't track previous roots for PAE paging, and the guest
 	 *      is unlikely to zap an in-use PGD.
+	 *
+	 * Note!  Dummy roots are unique in that they are obsoleted by memslot
+	 * _creation_!  See also FNAME(fetch).
 	 */
 	sp = root_to_sp(root_hpa);
 	return !sp || is_obsolete_sp(kvm, sp);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d39af5639ce9..3ca986450393 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -44,6 +44,16 @@ extern bool dbg;
 #define INVALID_PAE_ROOT	0
 #define IS_VALID_PAE_ROOT(x)	(!!(x))
 
+static inline hpa_t kvm_mmu_get_dummy_root(void)
+{
+	return my_zero_pfn(0) << PAGE_SHIFT;
+}
+
+static inline bool kvm_mmu_is_dummy_root(hpa_t shadow_page)
+{
+	return is_zero_pfn(shadow_page >> PAGE_SHIFT);
+}
+
 typedef u64 __rcu *tdp_ptep_t;
 
 struct kvm_mmu_page {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 122bfc0124d3..caf7623e5f91 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -646,6 +646,17 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		goto out_gpte_changed;
 
+	/*
+	 * Load a new root and retry the faulting instruction in the extremely
+	 * unlikely scenario that the guest root gfn became visible between
+	 * loading a dummy root and handling the resulting page fault, e.g. if
+	 * userspace create a memslot in the interim.
+	 */
+	if (unlikely(kvm_mmu_is_dummy_root(vcpu->arch.mmu->root.hpa))) {
+		kvm_make_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu);
+		goto out_gpte_changed;
+	}
+
 	for_each_shadow_entry(vcpu, fault->addr, it) {
 		gfn_t table_gfn;
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 9f8e8cda89e8..ac8ad12f9698 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -238,6 +238,9 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
 
 static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
 {
+	if (kvm_mmu_is_dummy_root(root))
+		return NULL;
+
 	/*
 	 * The "root" may be a special root, e.g. a PAE entry, treat it as a
 	 * SPTE to ensure any non-PA bits are dropped.
-- 
2.41.0.487.g6d72f3e995-goog

