Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E60C742E55
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 22:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjF2Uah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 16:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjF2Uaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 16:30:35 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC939213D
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 13:30:33 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-573d70da2afso9494077b3.2
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 13:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688070633; x=1690662633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fzTRzB9Fpjk0/kuH/2km63deID+1fZnt9MNVb73OsIg=;
        b=ogmBKznJ3/8LHrHIkKbl5GdJvTlOVgs07JU9CB7a8+8Ed8UOqlbUcGstnsGSWWN6Eh
         4+5pfLJgSMTEGaloFTir8foPPwtspouzlpAfuneUszwTt/iDwlAiOztsYzzRT6sY0hJx
         7RjUx8AN4zlJdp8MvVf0UFJsUybRunZR6dcSNwmHUYPch4K/SG/I+3lpshkes39zj9Ty
         ikOOh4YzSKEh/31NQ+jPYkJFliYq2t82M7WDLOZNkTcHpiB03sLYLjoBDj5bET0TwvwG
         xq06rpO5S7eIYWEtH5VoF5+aDe5Y5KWd06+xYZNPMHHUxwSwco+IipLX79xZ+uSbNK6t
         JR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688070633; x=1690662633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fzTRzB9Fpjk0/kuH/2km63deID+1fZnt9MNVb73OsIg=;
        b=bm/M+8KO9xy0HgL0OhlLZEXUadDEJL3QbvOnnVgL34Tl/XOmMrvjf7eaPHHKuz0Nvk
         Y1VOZzUoM/JYpLpl408hwkEBnNfF5K+xmXkKKHxuBxVIKF/VaeCK8pc+AtxMv5Mvi9xI
         WeCPrMISWEN5ygKm0CYJoyB2p3zHr9mRSTrBVbw13qdeTnZWqBCaN7sGH+ST1MePYuQQ
         6jkcdXTmaib6An3VJ4jYxjjCGbdUDDCO+TmNDAtIDxL1QAygngMmRk9lXcqFVCbE8naX
         B5aueB/g/+Eo3NCjHvWJflkVRDJzxj5J4B9ppUhOdFHn+uMYVLD4W2Z6o6MCs76LqJfH
         KHFA==
X-Gm-Message-State: ABy/qLZljNnozMf0VnZJ7iHpZixKI5roIMeg0jJYJTp+EyMS//ijRN0i
        tmDmODC/huuVG8we4yzrXmwS38+uB2k=
X-Google-Smtp-Source: APBJJlFIlYSlKCMPbv5gvrWaAVpda+CSatw98QKkkFB9TZnJdPl5F/NAh1buZtVRLAbFjndvT+QyZ4I8hK4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab68:0:b0:bed:d03a:fc5f with SMTP id
 u95-20020a25ab68000000b00bedd03afc5fmr5669ybi.11.1688070633064; Thu, 29 Jun
 2023 13:30:33 -0700 (PDT)
Date:   Thu, 29 Jun 2023 13:30:31 -0700
In-Reply-To: <ZJ3FyLUYrlr6+HLw@google.com>
Mime-Version: 1.0
References: <20230628071217.71126-1-ishiir@g.ecc.u-tokyo.ac.jp>
 <ZJxTTZzZnfbyMVIH@google.com> <ZJ0w5pKk/41Zv26i@yzhao56-desk.sh.intel.com> <ZJ3FyLUYrlr6+HLw@google.com>
Message-ID: <ZJ3p5wBwyQZ+aQOV@google.com>
Subject: Re: [PATCH] KVM: nVMX: Prevent vmlaunch with EPTP pointing outside
 assigned memory area
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>, shina@ecc.u-tokyo.ac.jp,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuan.yao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023, Sean Christopherson wrote:
> On Thu, Jun 29, 2023, Yan Zhao wrote:
> > On Wed, Jun 28, 2023 at 08:37:45AM -0700, Sean Christopherson wrote:
> > ...
> > > So I think we should try this:
> > > 
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c   | 19 -------------------
> > >  include/linux/kvm_host.h |  1 -
> > >  virt/kvm/kvm_main.c      | 13 ++-----------
> > >  3 files changed, 2 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 60397a1beda3..e305737edf84 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3671,19 +3671,6 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
> > >  
> > > -
> > > -static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
> > > -{
> > > -	int ret = 0;
> > > -
> > > -	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
> > > -		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > > -		ret = 1;
> > > -	}
> > > -
> > > -	return ret;
> > > -}
> > > -
> > >  static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
> > >  			    u8 level)
> > >  {
> > > @@ -3821,9 +3808,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
> > >  	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
> > >  	root_gfn = root_pgd >> PAGE_SHIFT;
> > >  
> > > -	if (mmu_check_root(vcpu, root_gfn))
> > > -		return 1;
> > > -
> > Hi Sean,
> > The checking of existence of memslot is still useful,
> > Otherwise NULL pointer dereference would be met as in below call trace.
> >
> > mmu_alloc_shadow_roots
> >  |->mmu_alloc_root
> >     |->mmu_alloc_root(root_gfn)
> >        |->kvm_mmu_get_shadow_page
> >           |->__kvm_mmu_get_shadow_page
> >              |->kvm_mmu_alloc_shadow_page
> >                 |->account_shadowed
> >                    |->slot = __gfn_to_memslot(slots, gfn);                    ==>NULL pointer
> >                    |  kvm_slot_page_track_add_page(kvm, slot, gfn,KVM_PAGE_TRACK_WRITE);
> >                       |->update_gfn_track(slot, gfn, mode, 1);
> >                          |->index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);  ==>NULL pointer dereference
> 
> Argh, right, the internal memslot might "work", but the no memslot case will not.
> The non-root path effectively injects a page fault if there's no memslot.
> 
> Oof, and simply skipping the accounting for the no-slot case would result in an
> imbalanced world if userspace creates a valid memslot before unaccount_shadowed()
> is called.
> 
> As much as it pains me to propagate KVM's arbitrary behavior, doing the right from
> an architectural perspective is really gross for KVM, e.g. would need all kinds of
> dedicated code in the MMU.

Turns out, not _that_ gross.  Exempting triple fault "works", but as I called out
earlier, it generates the incorrect exit reason in KVM-Unit-Tests, e.g. when KUT
stuffs a bad GUEST_RFLAGS to trigger a VM-Exit consistency check, because the
consistency check has higher priority than anything that can lead to triple fault.
And I couldn't bring myself to propagate the hack into testing code.

Lightly tested, but if this pans out, I'll post a series to (a) exempt triple
fault so that there's a fix for stable@, (b) effect the below over several patches,
and (c) revert the triple fault hack so that HEAD is architecturally less wrong.

---
 arch/x86/kvm/kvm_onhyperv.c     |  5 ++
 arch/x86/kvm/mmu.h              |  7 +--
 arch/x86/kvm/mmu/mmu.c          | 92 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/mmu_internal.h | 10 ++++
 arch/x86/kvm/mmu/spte.h         | 12 +++++
 arch/x86/kvm/mmu/tdp_iter.c     |  7 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 7 files changed, 79 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index ded0bd688c65..77add2afc92b 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -113,6 +113,11 @@ void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
 	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
 
+	if (!kvm_mmu_is_usable_root(root_tdp)) {
+		vcpu->arch.hv_root_tdp = INVALID_PAGE;
+		return;
+	}
+
 	if (kvm_x86_ops.flush_remote_tlbs == hv_flush_remote_tlbs) {
 		spin_lock(&kvm_arch->hv_root_tdp_lock);
 		vcpu->arch.hv_root_tdp = root_tdp;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 92d5a1924fc1..6dcc81582afa 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -146,12 +146,7 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
 
 static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 {
-	u64 root_hpa = vcpu->arch.mmu->root.hpa;
-
-	if (!VALID_PAGE(root_hpa))
-		return;
-
-	static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa,
+	static_call(kvm_x86_load_mmu_pgd)(vcpu, vcpu->arch.mmu->root.hpa,
 					  vcpu->arch.mmu->root_role.level);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e6078194ec7..64a918d89472 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3574,11 +3574,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (!VALID_PAGE(*root_hpa))
 		return;
 
-	/*
-	 * The "root" may be a special root, e.g. a PAE entry, treat it as a
-	 * SPTE to ensure any non-PA bits are dropped.
-	 */
-	sp = spte_to_child_sp(*root_hpa);
+	sp = root_to_sp(*root_hpa);
 	if (WARN_ON(!sp))
 		return;
 
@@ -3624,7 +3620,9 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 					   &invalid_list);
 
 	if (free_active_root) {
-		if (to_shadow_page(mmu->root.hpa)) {
+		if (kvm_mmu_is_dummy_root(mmu->root.hpa)) {
+			/* Nothing to cleanup for dummy roots. */
+		} else if (root_to_sp(mmu->root.hpa)) {
 			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
 		} else if (mmu->pae_root) {
 			for (i = 0; i < 4; ++i) {
@@ -3648,6 +3646,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
 void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 {
 	unsigned long roots_to_free = 0;
+	struct kvm_mmu_page *sp;
 	hpa_t root_hpa;
 	int i;
 
@@ -3662,8 +3661,8 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 		if (!VALID_PAGE(root_hpa))
 			continue;
 
-		if (!to_shadow_page(root_hpa) ||
-			to_shadow_page(root_hpa)->role.guest_mode)
+		sp = root_to_sp(root_hpa);
+		if (!sp || sp->role.guest_mode)
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
@@ -3671,19 +3670,6 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
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
@@ -3821,8 +3807,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
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
@@ -3834,8 +3822,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			if (!(pdptrs[i] & PT_PRESENT_MASK))
 				continue;
 
-			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
-				return 1;
+			if (kvm_vcpu_is_visible_gfn(vcpu, pdptrs[i] >> PAGE_SHIFT))
+				pdptrs[i] = 0;
 		}
 	}
 
@@ -4002,7 +3990,7 @@ static bool is_unsync_root(hpa_t root)
 {
 	struct kvm_mmu_page *sp;
 
-	if (!VALID_PAGE(root))
+	if (!VALID_PAGE(root) || kvm_mmu_is_dummy_root(root))
 		return false;
 
 	/*
@@ -4018,7 +4006,7 @@ static bool is_unsync_root(hpa_t root)
 	 * requirement isn't satisfied.
 	 */
 	smp_rmb();
-	sp = to_shadow_page(root);
+	sp = root_to_sp(root);
 
 	/*
 	 * PAE roots (somewhat arbitrarily) aren't backed by shadow pages, the
@@ -4035,8 +4023,9 @@ static bool is_unsync_root(hpa_t root)
 
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
-	int i;
 	struct kvm_mmu_page *sp;
+	hpa_t root;
+	int i;
 
 	if (vcpu->arch.mmu->root_role.direct)
 		return;
@@ -4047,12 +4036,12 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
 	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
-		hpa_t root = vcpu->arch.mmu->root.hpa;
-		sp = to_shadow_page(root);
-
+		root = vcpu->arch.mmu->root.hpa;
 		if (!is_unsync_root(root))
 			return;
 
+		sp = root_to_sp(root);
+
 		write_lock(&vcpu->kvm->mmu_lock);
 		mmu_sync_children(vcpu, sp, true);
 		write_unlock(&vcpu->kvm->mmu_lock);
@@ -4062,8 +4051,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	write_lock(&vcpu->kvm->mmu_lock);
 
 	for (i = 0; i < 4; ++i) {
-		hpa_t root = vcpu->arch.mmu->pae_root[i];
-
+		root = vcpu->arch.mmu->pae_root[i];
 		if (IS_VALID_PAE_ROOT(root)) {
 			sp = spte_to_child_sp(root);
 			mmu_sync_children(vcpu, sp, true);
@@ -4382,7 +4370,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault)
 {
-	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
+	struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->root.hpa);
 
 	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
 	if (sp && is_obsolete_sp(vcpu->kvm, sp))
@@ -4562,9 +4550,16 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
 				  union kvm_mmu_page_role role)
 {
-	return (role.direct || pgd == root->pgd) &&
-	       VALID_PAGE(root->hpa) &&
-	       role.word == to_shadow_page(root->hpa)->role.word;
+	struct kvm_mmu_page *sp;
+
+	if (!VALID_PAGE(root->hpa))
+		return false;
+
+	if (!role.direct && pgd != root->pgd)
+		return false;
+
+	sp = root_to_sp(root->hpa);
+	return sp && role.word == sp->role.word;
 }
 
 /*
@@ -4634,11 +4629,10 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
 			    gpa_t new_pgd, union kvm_mmu_page_role new_role)
 {
 	/*
-	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
-	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
-	 * later if necessary.
+	 * Limit reuse to 64-bit hosts+VMs without "special" roots in order to
+	 * avoid having to deal with PDPTEs and other complexities.
 	 */
-	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
+	if (VALID_PAGE(mmu->root.hpa) && !root_to_sp(mmu->root.hpa))
 		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
 
 	if (VALID_PAGE(mmu->root.hpa))
@@ -4684,9 +4678,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	 * If this is a direct root page, it doesn't have a write flooding
 	 * count. Otherwise, clear the write flooding count.
 	 */
-	if (!new_role.direct)
-		__clear_sp_write_flooding_count(
-				to_shadow_page(vcpu->arch.mmu->root.hpa));
+	if (!new_role.direct) {
+		struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->root.hpa);
+
+		if (!WARN_ON_ONCE(!sp))
+			__clear_sp_write_flooding_count(sp);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
@@ -5536,12 +5533,13 @@ static bool is_obsolete_root(struct kvm *kvm, hpa_t root_hpa)
 	 * positives and free roots that don't strictly need to be freed, but
 	 * such false positives are relatively rare:
 	 *
-	 *  (a) only PAE paging and nested NPT has roots without shadow pages
+	 *  (a) only PAE paging and nested NPT have roots without shadow pages
+	 *      (or any shadow paging flavor with a dummy root)
 	 *  (b) remote reloads due to a memslot update obsoletes _all_ roots
 	 *  (c) KVM doesn't track previous roots for PAE paging, and the guest
 	 *      is unlikely to zap an in-use PGD.
 	 */
-	sp = to_shadow_page(root_hpa);
+	sp = root_to_sp(root_hpa);
 	return !sp || is_obsolete_sp(kvm, sp);
 }
 
@@ -5728,7 +5726,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	int r, emulation_type = EMULTYPE_PF;
 	bool direct = vcpu->arch.mmu->root_role.direct;
 
-	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
+	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 
 	r = RET_PF_INVALID;
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
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1279db2eab44..ac8ad12f9698 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -236,6 +236,18 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
 	return to_shadow_page(__pa(sptep));
 }
 
+static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
+{
+	if (kvm_mmu_is_dummy_root(root))
+		return NULL;
+
+	/*
+	 * The "root" may be a special root, e.g. a PAE entry, treat it as a
+	 * SPTE to ensure any non-PA bits are dropped.
+	 */
+	return spte_to_child_sp(root);
+}
+
 static inline bool is_mmio_spte(u64 spte)
 {
 	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index d2eb0d4f8710..eda82a0e7fdb 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -41,8 +41,11 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 {
 	int root_level = root->role.level;
 
-	WARN_ON(root_level < 1);
-	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
+	if (WARN_ON_ONCE(!root || (root_level < 1) ||
+			 (root_level > PT64_ROOT_MAX_LEVEL))) {
+		iter->valid = false;
+		return;
+	}
 
 	iter->next_last_level_gfn = next_last_level_gfn;
 	iter->root_level = root_level;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 512163d52194..046ac2589611 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -689,7 +689,7 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 		else
 
 #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root.hpa), _start, _end)
+	for_each_tdp_pte(_iter, root_to_sp(_mmu->root.hpa), _start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control

base-commit: 9bee9f1881ecd4eb68ba1ca88b56bff88e50fc8a
-- 

