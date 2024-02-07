Return-Path: <kvm+bounces-8231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A7184CD78
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:58:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E03E1C24F92
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 14:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5098B7F477;
	Wed,  7 Feb 2024 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dyq7/izO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B6C7E788;
	Wed,  7 Feb 2024 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707317897; cv=none; b=aqDtNwtj7Y++ZwgnOIkG606BQnoAzwo47GkWppObvddsj5amS6StGL4Jp7Edv6U0lvBDJjmeAWS6iuRKdFB12gOA0Unw3IFkQkHLEpcdjihiYN2jZRbPVpckt33wRva4yTKbpnG/3i+lTzTMxITg8RPfPEKLvupr5qpw5WDY1gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707317897; c=relaxed/simple;
	bh=Zcfu4s2mGNxv9U/rabj5bTaiDiHDbjmmMVOXq9x9lOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAqlt6Wc52BQA8bxncMjYODy7cRkO4wAMb/IQpdRGqpMziEU3bmiwOAlEVHRJapI+SRGu7KloD9SDvomCYQvaEbt1cYOP4bTt8wLPPwEg+YMQyab50XsEL9pzr3f3WTXHPanUrHtXOVtSnhXCxTEZh1QUFX6MsO8lDpMSNZ7RTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dyq7/izO; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707317896; x=1738853896;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zcfu4s2mGNxv9U/rabj5bTaiDiHDbjmmMVOXq9x9lOU=;
  b=dyq7/izOhWh7Pi3LX0OSID8jCOOS8yyTxHGQgFHEFWpn0RhYV2X64c5t
   JipboQPfriqS3wFlshiA2BE0AH9JA5zUH7ewnMmS92xaEUHMIfdg2H+Ij
   zzevNE6t2qg39OBiCAVRTXuq/UsUlGkx7EoDUpxKy8FuQhOk2pFYRcZyt
   kDPb0SKyINFGSlBxBEClDMq40DoVOUoxpHHDdZF8lYwIi1bAnCeOeJTiY
   v6E2CNXq6ul0GBtfotisj6Vlrcncde7YQkKRN8EzCsKC+NFD2+/ReAi0m
   vy/lbAcg9YgkeOzAy0MGk0HnbTbpPeBHSL6CFQDypmndBVtib3SpoemTg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="1138500"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="1138500"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 06:58:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="32426232"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa001.fm.intel.com with ESMTP; 07 Feb 2024 06:58:13 -0800
Date: Wed, 7 Feb 2024 22:54:36 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Pattara Teerapong <pteerapong@google.com>
Subject: Re: [PATCH 6/8] KVM: x86/mmu: Check for usable TDP MMU root while
 holding mmu_lock for read
Message-ID: <ZcOZrNLJqjtjSRdP@yilunxu-OptiPlex-7050>
References: <20240111020048.844847-1-seanjc@google.com>
 <20240111020048.844847-7-seanjc@google.com>
 <ZcIFTkWaTqItQPsj@yilunxu-OptiPlex-7050>
 <ZcJHYtMZsQHInVEI@yilunxu-OptiPlex-7050>
 <ZcJ4jBQatw7ti46D@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcJ4jBQatw7ti46D@google.com>

On Tue, Feb 06, 2024 at 10:21:00AM -0800, Sean Christopherson wrote:
> On Tue, Feb 06, 2024, Xu Yilun wrote:
> > On Tue, Feb 06, 2024 at 06:09:18PM +0800, Xu Yilun wrote:
> > > On Wed, Jan 10, 2024 at 06:00:46PM -0800, Sean Christopherson wrote:
> > > > When allocating a new TDP MMU root, check for a usable root while holding
> > > > mmu_lock for read and only acquire mmu_lock for write if a new root needs
> > > > to be created.  There is no need to serialize other MMU operations if a
> > > > vCPU is simply grabbing a reference to an existing root, holding mmu_lock
> > > > for write is "necessary" (spoiler alert, it's not strictly necessary) only
> > > > to ensure KVM doesn't end up with duplicate roots.
> > > > 
> > > > Allowing vCPUs to get "new" roots in parallel is beneficial to VM boot and
> > > > to setups that frequently delete memslots, i.e. which force all vCPUs to
> > > > reload all roots.
> > > > 
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c     |  8 ++---
> > > >  arch/x86/kvm/mmu/tdp_mmu.c | 60 +++++++++++++++++++++++++++++++-------
> > > >  arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
> > > >  3 files changed, 55 insertions(+), 15 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 3c844e428684..ea18aca23196 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -3693,15 +3693,15 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> > > >  	unsigned i;
> > > >  	int r;
> > > >  
> > > > +	if (tdp_mmu_enabled)
> > > > +		return kvm_tdp_mmu_alloc_root(vcpu);
> > > > +
> > > >  	write_lock(&vcpu->kvm->mmu_lock);
> > > >  	r = make_mmu_pages_available(vcpu);
> > > >  	if (r < 0)
> > > >  		goto out_unlock;
> > > >  
> > > > -	if (tdp_mmu_enabled) {
> > > > -		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > > > -		mmu->root.hpa = root;
> > > > -	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> > > > +	if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> > > >  		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
> > > >  		mmu->root.hpa = root;
> > > >  	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
> > > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > index e0a8343f66dc..9a8250a14fc1 100644
> > > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > @@ -223,21 +223,52 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
> > > >  	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
> > > >  }
> > > >  
> > > > -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> > > > +static struct kvm_mmu_page *kvm_tdp_mmu_try_get_root(struct kvm_vcpu *vcpu)
> > > >  {
> > > >  	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> > > > +	int as_id = kvm_mmu_role_as_id(role);
> > > >  	struct kvm *kvm = vcpu->kvm;
> > > >  	struct kvm_mmu_page *root;
> > > >  
> > > > -	lockdep_assert_held_write(&kvm->mmu_lock);
> > > > -
> > > > -	/* Check for an existing root before allocating a new one. */
> > > > -	for_each_valid_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> > > > -		if (root->role.word == role.word &&
> > > > -		    kvm_tdp_mmu_get_root(root))
> > > > -			goto out;
> > > > +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
> > > 
> > > No lock yielding attempt in this loop, why change to _yield_safe version?
> 
> Because variants that don't allow yielding, i.e. for_each_valid_tdp_mmu_root()
> as of this patch, require mmu_lock be held for write.  Holding mmu_lock for write
> is necessary because that simpler version uses list_for_each_entry() and doesn't
> grab a reference to the root, i.e. entries on the list could be freed, e.g. by
> kvm_tdp_mmu_zap_invalidated_roots().
> 
> The _yield_safe() versions don't require the user to want to yield.  The naming
> is _yield_safe() because the yield-safe iterators can run with mmu_lock held for
> read *or* right.
> 
> > Oh, I assume you just want to early exit the loop with the reference to
> > root hold.  But I feel it makes harder for us to have a clear
> > understanding of the usage of _yield_safe and non _yield_safe helpers.
> > 
> > Maybe change it back?
> 
> No.  There's even a comment above for_each_tdp_mmu_root() (which is

Oh, I should have read comments more carefully.

> for_each_valid_tdp_mmu_root() as of this patch) that explains the difference.
> The rule is essentially, use the yield-safe variant unless there's a good reason
> not to.
> 
> /*
>  * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
>  * the implication being that any flow that holds mmu_lock for read is
>  * inherently yield-friendly and should use the yield-safe variant above.

I still have doubt until I see the changelog:

The nature of a shared walk means that the caller needs to
play nice with other tasks modifying the page tables, which is more or
less the same thing as playing nice with yielding.

Thanks.

>  * Holding mmu_lock for write obviates the need for RCU protection as the list
>  * is guaranteed to be stable.
>  */




