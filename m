Return-Path: <kvm+bounces-8102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC1284B8E3
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 16:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AEEBB2C770
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 14:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD7F134723;
	Tue,  6 Feb 2024 14:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jA8jF/7M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C43F1339A2;
	Tue,  6 Feb 2024 14:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707231297; cv=none; b=XHis8+ps0njDvKxH3BCYYFZ4zezfazuMzAI+CSCqS2E4KXeWnkY0xlY0SEco1IOm1g7wJwURcE475ekV0O+ibJzqeAFSQqeTjbpj6QidShAG620GpIACzp/K5IAwfeLx4pjOeufEUgTmJ4cjkAKzY2Y2IDgCsFuy/d7VuuQrQ4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707231297; c=relaxed/simple;
	bh=lOr+XGR2hJml6WGSq7dut5XfAyTVuZ4y58BVDSiEjas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dx44NmUNbghg81i12tqjwjJqWgCrVqJKKqDqS8ymgdaAqi+BtDe/VIofwoPkc+Uo4BaaH4Hodu3nRyQuX4OdUkwAcXEPZLsAbiGuKX4I+ulolRiTBrlk5sn5D6E8K6UBe2OeHufAA/MbOa8O0eVxjknmCZKbxAjT9AxCLC9I/VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jA8jF/7M; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707231296; x=1738767296;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lOr+XGR2hJml6WGSq7dut5XfAyTVuZ4y58BVDSiEjas=;
  b=jA8jF/7ME2N9ead1vl+9g0/PtcsbYnGBpxzkFF+GFmUaLaGlQQ5BOIUn
   m415YyPfB05LXzZeqvtr5F/jbdBjNUo2ctzfSvL4mKJfwTzv9eSpjeKBg
   wfJEHCHoYBCqXA9UDDgYU34KnQFHt7Mzd1f+NTwzH28o+9J/XCOBLMKGG
   tXJAQZUKGoudxcykkpflvTofb28EV9v8b4cmGtgkmW2sdLrujcA8kK7WH
   R6yy2lJjFMKPp70qUZrUHE42JG2jpL/mKk8VlKMqpNjHU/D5gQtX4gY9p
   II0NjEYysKxEXaYEoH4xwTEOBBvBLIwodajbqpIyciNhjOYS06sSSKheM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="435901069"
X-IronPort-AV: E=Sophos;i="6.05,247,1701158400"; 
   d="scan'208";a="435901069"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 06:54:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,247,1701158400"; 
   d="scan'208";a="1067177"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa010.jf.intel.com with ESMTP; 06 Feb 2024 06:54:50 -0800
Date: Tue, 6 Feb 2024 22:51:14 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Pattara Teerapong <pteerapong@google.com>
Subject: Re: [PATCH 6/8] KVM: x86/mmu: Check for usable TDP MMU root while
 holding mmu_lock for read
Message-ID: <ZcJHYtMZsQHInVEI@yilunxu-OptiPlex-7050>
References: <20240111020048.844847-1-seanjc@google.com>
 <20240111020048.844847-7-seanjc@google.com>
 <ZcIFTkWaTqItQPsj@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcIFTkWaTqItQPsj@yilunxu-OptiPlex-7050>

On Tue, Feb 06, 2024 at 06:09:18PM +0800, Xu Yilun wrote:
> On Wed, Jan 10, 2024 at 06:00:46PM -0800, Sean Christopherson wrote:
> > When allocating a new TDP MMU root, check for a usable root while holding
> > mmu_lock for read and only acquire mmu_lock for write if a new root needs
> > to be created.  There is no need to serialize other MMU operations if a
> > vCPU is simply grabbing a reference to an existing root, holding mmu_lock
> > for write is "necessary" (spoiler alert, it's not strictly necessary) only
> > to ensure KVM doesn't end up with duplicate roots.
> > 
> > Allowing vCPUs to get "new" roots in parallel is beneficial to VM boot and
> > to setups that frequently delete memslots, i.e. which force all vCPUs to
> > reload all roots.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     |  8 ++---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 60 +++++++++++++++++++++++++++++++-------
> >  arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
> >  3 files changed, 55 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 3c844e428684..ea18aca23196 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3693,15 +3693,15 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >  	unsigned i;
> >  	int r;
> >  
> > +	if (tdp_mmu_enabled)
> > +		return kvm_tdp_mmu_alloc_root(vcpu);
> > +
> >  	write_lock(&vcpu->kvm->mmu_lock);
> >  	r = make_mmu_pages_available(vcpu);
> >  	if (r < 0)
> >  		goto out_unlock;
> >  
> > -	if (tdp_mmu_enabled) {
> > -		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > -		mmu->root.hpa = root;
> > -	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> > +	if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> >  		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
> >  		mmu->root.hpa = root;
> >  	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index e0a8343f66dc..9a8250a14fc1 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -223,21 +223,52 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
> >  	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
> >  }
> >  
> > -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> > +static struct kvm_mmu_page *kvm_tdp_mmu_try_get_root(struct kvm_vcpu *vcpu)
> >  {
> >  	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> > +	int as_id = kvm_mmu_role_as_id(role);
> >  	struct kvm *kvm = vcpu->kvm;
> >  	struct kvm_mmu_page *root;
> >  
> > -	lockdep_assert_held_write(&kvm->mmu_lock);
> > -
> > -	/* Check for an existing root before allocating a new one. */
> > -	for_each_valid_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> > -		if (root->role.word == role.word &&
> > -		    kvm_tdp_mmu_get_root(root))
> > -			goto out;
> > +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
> 
> No lock yielding attempt in this loop, why change to _yield_safe version?

Oh, I assume you just want to early exit the loop with the reference to
root hold.  But I feel it makes harder for us to have a clear
understanding of the usage of _yield_safe and non _yield_safe helpers.

Maybe change it back?

Thanks,
Yilun

> 
> Thanks,
> Yilun
> 
> > +		if (root->role.word == role.word)
> > +			return root;
> >  	}
> >  
> > +	return NULL;
> > +}
> > +
> > +int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_mmu *mmu = vcpu->arch.mmu;
> > +	union kvm_mmu_page_role role = mmu->root_role;
> > +	struct kvm *kvm = vcpu->kvm;
> > +	struct kvm_mmu_page *root;
> > +
> > +	/*
> > +	 * Check for an existing root while holding mmu_lock for read to avoid
> > +	 * unnecessary serialization if multiple vCPUs are loading a new root.
> > +	 * E.g. when bringing up secondary vCPUs, KVM will already have created
> > +	 * a valid root on behalf of the primary vCPU.
> > +	 */
> > +	read_lock(&kvm->mmu_lock);
> > +	root = kvm_tdp_mmu_try_get_root(vcpu);
> > +	read_unlock(&kvm->mmu_lock);
> > +
> > +	if (root)
> > +		goto out;
> > +
> > +	write_lock(&kvm->mmu_lock);
> > +
> > +	/*
> > +	 * Recheck for an existing root after acquiring mmu_lock for write.  It
> > +	 * is possible a new usable root was created between dropping mmu_lock
> > +	 * (for read) and acquiring it for write.
> > +	 */
> > +	root = kvm_tdp_mmu_try_get_root(vcpu);
> > +	if (root)
> > +		goto out_unlock;
> > +
> >  	root = tdp_mmu_alloc_sp(vcpu);
> >  	tdp_mmu_init_sp(root, NULL, 0, role);
> >  
> > @@ -254,8 +285,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >  	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
> >  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> >  
> > +out_unlock:
> > +	write_unlock(&kvm->mmu_lock);
> >  out:
> > -	return __pa(root->spt);
> > +	/*
> > +	 * Note, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS will prevent entering the guest
> > +	 * and actually consuming the root if it's invalidated after dropping
> > +	 * mmu_lock, and the root can't be freed as this vCPU holds a reference.
> > +	 */
> > +	mmu->root.hpa = __pa(root->spt);
> > +	mmu->root.pgd = 0;
> > +	return 0;
> >  }
> >  
> >  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> > @@ -917,7 +957,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
> >   * the VM is being destroyed).
> >   *
> >   * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
> > - * See kvm_tdp_mmu_get_vcpu_root_hpa().
> > + * See kvm_tdp_mmu_alloc_root().
> >   */
> >  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
> >  {
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index 20d97aa46c49..6e1ea04ca885 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -10,7 +10,7 @@
> >  void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> >  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
> >  
> > -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> > +int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
> >  
> >  __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
> >  {
> > -- 
> > 2.43.0.275.g3460e3d667-goog
> > 
> > 
> 

