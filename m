Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9793D7433DB
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 07:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjF3FCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 01:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjF3FCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 01:02:09 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F90A35AB;
        Thu, 29 Jun 2023 22:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688101323; x=1719637323;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w9SKncOmGEQdHE6qD/R/7vg86NAL50d7Wh7YExXI2pw=;
  b=jYS8l5VJR+1QkL7aA63koZyP1d1YS2MoRlkgFAJX154dKqW939bW60Ji
   KBDKJcL92NqLU0GPJy2v+SogGXU+Vqx0anu+pdT/4GFnSZZxn8PcRihbV
   F8VkkggrjtUS57v0vRA/SHxn5bzMgj5a5zDR1z0NWdIcvq5uB0cn9nN6O
   8pj4ucPRZbQhnaai4dKfUgYRJxQH6B0ZHMj0MRy7WIJcmmzVqEaAuAw23
   dKDLd5eXbuq95lq1aZlMmLq5C0Y6otaogcqyw6fjiGWDD3QfEcYfOe/Nj
   PSdjpJw2nMQGzqjn2rqINcgZce3k85B/YVQbKvaGSMT8eL9tTjdcz01AT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="426003898"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="426003898"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 22:02:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="717665795"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="717665795"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 29 Jun 2023 22:01:58 -0700
Date:   Fri, 30 Jun 2023 13:01:57 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>,
        shina@ecc.u-tokyo.ac.jp, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuan.yao@intel.com
Subject: Re: [PATCH] KVM: nVMX: Prevent vmlaunch with EPTP pointing outside
 assigned memory area
Message-ID: <20230630050157.kurgzdcpjngs6w4k@yy-desk-7060>
References: <20230628071217.71126-1-ishiir@g.ecc.u-tokyo.ac.jp>
 <ZJxTTZzZnfbyMVIH@google.com>
 <ZJ0w5pKk/41Zv26i@yzhao56-desk.sh.intel.com>
 <ZJ3FyLUYrlr6+HLw@google.com>
 <ZJ3p5wBwyQZ+aQOV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJ3p5wBwyQZ+aQOV@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023 at 01:30:31PM -0700, Sean Christopherson wrote:
> On Thu, Jun 29, 2023, Sean Christopherson wrote:
> > On Thu, Jun 29, 2023, Yan Zhao wrote:
> > > On Wed, Jun 28, 2023 at 08:37:45AM -0700, Sean Christopherson wrote:
> > > ...
> > > > So I think we should try this:
> > > >
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c   | 19 -------------------
> > > >  include/linux/kvm_host.h |  1 -
> > > >  virt/kvm/kvm_main.c      | 13 ++-----------
> > > >  3 files changed, 2 insertions(+), 31 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 60397a1beda3..e305737edf84 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -3671,19 +3671,6 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
> > > >
> > > > -
> > > > -static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
> > > > -{
> > > > -	int ret = 0;
> > > > -
> > > > -	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
> > > > -		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > > > -		ret = 1;
> > > > -	}
> > > > -
> > > > -	return ret;
> > > > -}
> > > > -
> > > >  static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
> > > >  			    u8 level)
> > > >  {
> > > > @@ -3821,9 +3808,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
> > > >  	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
> > > >  	root_gfn = root_pgd >> PAGE_SHIFT;
> > > >
> > > > -	if (mmu_check_root(vcpu, root_gfn))
> > > > -		return 1;
> > > > -
> > > Hi Sean,
> > > The checking of existence of memslot is still useful,
> > > Otherwise NULL pointer dereference would be met as in below call trace.
> > >
> > > mmu_alloc_shadow_roots
> > >  |->mmu_alloc_root
> > >     |->mmu_alloc_root(root_gfn)
> > >        |->kvm_mmu_get_shadow_page
> > >           |->__kvm_mmu_get_shadow_page
> > >              |->kvm_mmu_alloc_shadow_page
> > >                 |->account_shadowed
> > >                    |->slot = __gfn_to_memslot(slots, gfn);                    ==>NULL pointer
> > >                    |  kvm_slot_page_track_add_page(kvm, slot, gfn,KVM_PAGE_TRACK_WRITE);
> > >                       |->update_gfn_track(slot, gfn, mode, 1);
> > >                          |->index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);  ==>NULL pointer dereference
> >
> > Argh, right, the internal memslot might "work", but the no memslot case will not.
> > The non-root path effectively injects a page fault if there's no memslot.
> >
> > Oof, and simply skipping the accounting for the no-slot case would result in an
> > imbalanced world if userspace creates a valid memslot before unaccount_shadowed()
> > is called.
> >
> > As much as it pains me to propagate KVM's arbitrary behavior, doing the right from
> > an architectural perspective is really gross for KVM, e.g. would need all kinds of
> > dedicated code in the MMU.
>
> Turns out, not _that_ gross.  Exempting triple fault "works", but as I called out
> earlier, it generates the incorrect exit reason in KVM-Unit-Tests, e.g. when KUT
> stuffs a bad GUEST_RFLAGS to trigger a VM-Exit consistency check, because the
> consistency check has higher priority than anything that can lead to triple fault.
> And I couldn't bring myself to propagate the hack into testing code.
>
> Lightly tested, but if this pans out, I'll post a series to (a) exempt triple
> fault so that there's a fix for stable@, (b) effect the below over several patches,
> and (c) revert the triple fault hack so that HEAD is architecturally less wrong.
>
> ---
>  arch/x86/kvm/kvm_onhyperv.c     |  5 ++
>  arch/x86/kvm/mmu.h              |  7 +--
>  arch/x86/kvm/mmu/mmu.c          | 92 ++++++++++++++++-----------------
>  arch/x86/kvm/mmu/mmu_internal.h | 10 ++++
>  arch/x86/kvm/mmu/spte.h         | 12 +++++
>  arch/x86/kvm/mmu/tdp_iter.c     |  7 ++-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>  7 files changed, 79 insertions(+), 56 deletions(-)
>
> diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
> index ded0bd688c65..77add2afc92b 100644
> --- a/arch/x86/kvm/kvm_onhyperv.c
> +++ b/arch/x86/kvm/kvm_onhyperv.c
> @@ -113,6 +113,11 @@ void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
>  {
>  	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
>
> +	if (!kvm_mmu_is_usable_root(root_tdp)) {
> +		vcpu->arch.hv_root_tdp = INVALID_PAGE;
> +		return;
> +	}
> +
>  	if (kvm_x86_ops.flush_remote_tlbs == hv_flush_remote_tlbs) {
>  		spin_lock(&kvm_arch->hv_root_tdp_lock);
>  		vcpu->arch.hv_root_tdp = root_tdp;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 92d5a1924fc1..6dcc81582afa 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -146,12 +146,7 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>
>  static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  {
> -	u64 root_hpa = vcpu->arch.mmu->root.hpa;
> -
> -	if (!VALID_PAGE(root_hpa))
> -		return;
> -
> -	static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa,
> +	static_call(kvm_x86_load_mmu_pgd)(vcpu, vcpu->arch.mmu->root.hpa,
>  					  vcpu->arch.mmu->root_role.level);
>  }
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6e6078194ec7..64a918d89472 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3574,11 +3574,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  	if (!VALID_PAGE(*root_hpa))
>  		return;
>
> -	/*
> -	 * The "root" may be a special root, e.g. a PAE entry, treat it as a
> -	 * SPTE to ensure any non-PA bits are dropped.
> -	 */
> -	sp = spte_to_child_sp(*root_hpa);
> +	sp = root_to_sp(*root_hpa);
>  	if (WARN_ON(!sp))
>  		return;
>
> @@ -3624,7 +3620,9 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
>  					   &invalid_list);
>
>  	if (free_active_root) {
> -		if (to_shadow_page(mmu->root.hpa)) {
> +		if (kvm_mmu_is_dummy_root(mmu->root.hpa)) {
> +			/* Nothing to cleanup for dummy roots. */
> +		} else if (root_to_sp(mmu->root.hpa)) {
>  			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
>  		} else if (mmu->pae_root) {
>  			for (i = 0; i < 4; ++i) {
> @@ -3648,6 +3646,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
>  void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>  {
>  	unsigned long roots_to_free = 0;
> +	struct kvm_mmu_page *sp;
>  	hpa_t root_hpa;
>  	int i;
>
> @@ -3662,8 +3661,8 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>  		if (!VALID_PAGE(root_hpa))
>  			continue;
>
> -		if (!to_shadow_page(root_hpa) ||
> -			to_shadow_page(root_hpa)->role.guest_mode)
> +		sp = root_to_sp(root_hpa);
> +		if (!sp || sp->role.guest_mode)
>  			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
>  	}
>
> @@ -3671,19 +3670,6 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
>
> -
> -static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
> -{
> -	int ret = 0;
> -
> -	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
> -		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> -		ret = 1;
> -	}
> -
> -	return ret;
> -}
> -
>  static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
>  			    u8 level)
>  {
> @@ -3821,8 +3807,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
>  	root_gfn = root_pgd >> PAGE_SHIFT;
>
> -	if (mmu_check_root(vcpu, root_gfn))
> -		return 1;
> +	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
> +		mmu->root.hpa = kvm_mmu_get_dummy_root();
> +		return 0;
> +	}
>
>  	/*
>  	 * On SVM, reading PDPTRs might access guest memory, which might fault
> @@ -3834,8 +3822,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  			if (!(pdptrs[i] & PT_PRESENT_MASK))
>  				continue;
>
> -			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
> -				return 1;
> +			if (kvm_vcpu_is_visible_gfn(vcpu, pdptrs[i] >> PAGE_SHIFT))
> +				pdptrs[i] = 0;

Hi Sean,

Should this be "!kvm_vcpu_is_visible_gfn(vcpu, pdptrs[i] >> PAGE_SHIFT)" and
turn the pae_root[i] to dummy root yet ? IIRC the fault will be injected to
the guest/L2 when meets out of range GFN/L1 GPA while walking guest page
table/vmcs12 EPT table, without further update on the dummy root and other
middle level shadow page table entries.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 60397a1beda3..4c3465ecfc15 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3834,8 +3834,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			if (!(pdptrs[i] & PT_PRESENT_MASK))
 				continue;

-			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
-				return 1;
+			if (!kvm_vcpu_is_visible_gfn(vcpu, pdptrs[i] >> PAGE_SHIFT))
+				pdptrs[i] = INVALID_GPA;
 		}
 	}

@@ -3892,6 +3892,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));

 		if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
+			if (pdptrs[i] == INVALID_GPA) {
+				mmu->pae_root[i] = kvm_mmu_get_dummy_root();
+				continue;
+			}
 			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
 				mmu->pae_root[i] = INVALID_PAE_ROOT;
 				continue;

>  		}
>  	}
>
> @@ -4002,7 +3990,7 @@ static bool is_unsync_root(hpa_t root)
>  {
>  	struct kvm_mmu_page *sp;
>
> -	if (!VALID_PAGE(root))
> +	if (!VALID_PAGE(root) || kvm_mmu_is_dummy_root(root))
>  		return false;
>
>  	/*
> @@ -4018,7 +4006,7 @@ static bool is_unsync_root(hpa_t root)
>  	 * requirement isn't satisfied.
>  	 */
>  	smp_rmb();
> -	sp = to_shadow_page(root);
> +	sp = root_to_sp(root);
>
>  	/*
>  	 * PAE roots (somewhat arbitrarily) aren't backed by shadow pages, the
> @@ -4035,8 +4023,9 @@ static bool is_unsync_root(hpa_t root)
>
>  void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  {
> -	int i;
>  	struct kvm_mmu_page *sp;
> +	hpa_t root;
> +	int i;
>
>  	if (vcpu->arch.mmu->root_role.direct)
>  		return;
> @@ -4047,12 +4036,12 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
>
>  	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
> -		hpa_t root = vcpu->arch.mmu->root.hpa;
> -		sp = to_shadow_page(root);
> -
> +		root = vcpu->arch.mmu->root.hpa;
>  		if (!is_unsync_root(root))
>  			return;
>
> +		sp = root_to_sp(root);
> +
>  		write_lock(&vcpu->kvm->mmu_lock);
>  		mmu_sync_children(vcpu, sp, true);
>  		write_unlock(&vcpu->kvm->mmu_lock);
> @@ -4062,8 +4051,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  	write_lock(&vcpu->kvm->mmu_lock);
>
>  	for (i = 0; i < 4; ++i) {
> -		hpa_t root = vcpu->arch.mmu->pae_root[i];
> -
> +		root = vcpu->arch.mmu->pae_root[i];
>  		if (IS_VALID_PAE_ROOT(root)) {
>  			sp = spte_to_child_sp(root);
>  			mmu_sync_children(vcpu, sp, true);
> @@ -4382,7 +4370,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>  				struct kvm_page_fault *fault)
>  {
> -	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
> +	struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->root.hpa);
>
>  	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
>  	if (sp && is_obsolete_sp(vcpu->kvm, sp))
> @@ -4562,9 +4550,16 @@ static void nonpaging_init_context(struct kvm_mmu *context)
>  static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
>  				  union kvm_mmu_page_role role)
>  {
> -	return (role.direct || pgd == root->pgd) &&
> -	       VALID_PAGE(root->hpa) &&
> -	       role.word == to_shadow_page(root->hpa)->role.word;
> +	struct kvm_mmu_page *sp;
> +
> +	if (!VALID_PAGE(root->hpa))
> +		return false;
> +
> +	if (!role.direct && pgd != root->pgd)
> +		return false;
> +
> +	sp = root_to_sp(root->hpa);
> +	return sp && role.word == sp->role.word;
>  }
>
>  /*
> @@ -4634,11 +4629,10 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
>  			    gpa_t new_pgd, union kvm_mmu_page_role new_role)
>  {
>  	/*
> -	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
> -	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
> -	 * later if necessary.
> +	 * Limit reuse to 64-bit hosts+VMs without "special" roots in order to
> +	 * avoid having to deal with PDPTEs and other complexities.
>  	 */
> -	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
> +	if (VALID_PAGE(mmu->root.hpa) && !root_to_sp(mmu->root.hpa))
>  		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
>
>  	if (VALID_PAGE(mmu->root.hpa))
> @@ -4684,9 +4678,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
>  	 * If this is a direct root page, it doesn't have a write flooding
>  	 * count. Otherwise, clear the write flooding count.
>  	 */
> -	if (!new_role.direct)
> -		__clear_sp_write_flooding_count(
> -				to_shadow_page(vcpu->arch.mmu->root.hpa));
> +	if (!new_role.direct) {
> +		struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->root.hpa);
> +
> +		if (!WARN_ON_ONCE(!sp))
> +			__clear_sp_write_flooding_count(sp);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
>
> @@ -5536,12 +5533,13 @@ static bool is_obsolete_root(struct kvm *kvm, hpa_t root_hpa)
>  	 * positives and free roots that don't strictly need to be freed, but
>  	 * such false positives are relatively rare:
>  	 *
> -	 *  (a) only PAE paging and nested NPT has roots without shadow pages
> +	 *  (a) only PAE paging and nested NPT have roots without shadow pages
> +	 *      (or any shadow paging flavor with a dummy root)
>  	 *  (b) remote reloads due to a memslot update obsoletes _all_ roots
>  	 *  (c) KVM doesn't track previous roots for PAE paging, and the guest
>  	 *      is unlikely to zap an in-use PGD.
>  	 */
> -	sp = to_shadow_page(root_hpa);
> +	sp = root_to_sp(root_hpa);
>  	return !sp || is_obsolete_sp(kvm, sp);
>  }
>
> @@ -5728,7 +5726,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  	int r, emulation_type = EMULTYPE_PF;
>  	bool direct = vcpu->arch.mmu->root_role.direct;
>
> -	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
> +	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>  		return RET_PF_RETRY;
>
>  	r = RET_PF_INVALID;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index d39af5639ce9..3ca986450393 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -44,6 +44,16 @@ extern bool dbg;
>  #define INVALID_PAE_ROOT	0
>  #define IS_VALID_PAE_ROOT(x)	(!!(x))
>
> +static inline hpa_t kvm_mmu_get_dummy_root(void)
> +{
> +	return my_zero_pfn(0) << PAGE_SHIFT;
> +}
> +
> +static inline bool kvm_mmu_is_dummy_root(hpa_t shadow_page)
> +{
> +	return is_zero_pfn(shadow_page >> PAGE_SHIFT);
> +}
> +
>  typedef u64 __rcu *tdp_ptep_t;
>
>  struct kvm_mmu_page {
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 1279db2eab44..ac8ad12f9698 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -236,6 +236,18 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
>  	return to_shadow_page(__pa(sptep));
>  }
>
> +static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
> +{
> +	if (kvm_mmu_is_dummy_root(root))
> +		return NULL;
> +
> +	/*
> +	 * The "root" may be a special root, e.g. a PAE entry, treat it as a
> +	 * SPTE to ensure any non-PA bits are dropped.
> +	 */
> +	return spte_to_child_sp(root);
> +}
> +
>  static inline bool is_mmio_spte(u64 spte)
>  {
>  	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index d2eb0d4f8710..eda82a0e7fdb 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -41,8 +41,11 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>  {
>  	int root_level = root->role.level;
>
> -	WARN_ON(root_level < 1);
> -	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
> +	if (WARN_ON_ONCE(!root || (root_level < 1) ||
> +			 (root_level > PT64_ROOT_MAX_LEVEL))) {
> +		iter->valid = false;
> +		return;
> +	}
>
>  	iter->next_last_level_gfn = next_last_level_gfn;
>  	iter->root_level = root_level;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 512163d52194..046ac2589611 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -689,7 +689,7 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  		else
>
>  #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
> -	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root.hpa), _start, _end)
> +	for_each_tdp_pte(_iter, root_to_sp(_mmu->root.hpa), _start, _end)
>
>  /*
>   * Yield if the MMU lock is contended or this thread needs to return control
>
> base-commit: 9bee9f1881ecd4eb68ba1ca88b56bff88e50fc8a
> --
>
