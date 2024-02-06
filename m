Return-Path: <kvm+bounces-8097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB9884B22D
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 11:13:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 794671F250A2
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 10:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D344612E1F7;
	Tue,  6 Feb 2024 10:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UJD8UDKi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFE212E1C5;
	Tue,  6 Feb 2024 10:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707214380; cv=none; b=YuXzwwQb5fC7FnQvSgUBlfozJl31AP3UySqoYLJlhxmdqkpAbwDLwOvTNzdNSzCICuQHjkDslbmCgObCmFrPc3dz4WPaxWzfJ/4pxG0pWgTxsdpOz/+KsanpAeszwzjdsf7Pacz3lyC+W+3IE5tiXjaFUOFO0MDDu1QPxSoYpV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707214380; c=relaxed/simple;
	bh=Rpxj+E/7yrI4tdi5qskpk5pPVzgjrp8YqDARkU2+exc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRxHKO3HHGEJU5ci/1H93fNOJKQRyaqnz5KhIkrd6KD34V+cK/wFpgj4VDVZ2tsTjxy4HVotsLH6Y9jMufyztS0SkoYq/s3HO7BJOWyINKbH0pZ3cUJhMsU+TzoLGpgncqCj6Cv5nnhEnDFRbcB+euY3nSDwwWf1t2viy/8q4bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UJD8UDKi; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707214379; x=1738750379;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Rpxj+E/7yrI4tdi5qskpk5pPVzgjrp8YqDARkU2+exc=;
  b=UJD8UDKiOWKT3UHWxVsppua1SUYeDz/WZNSpEurW+Y0tyA+3gHcCCBWJ
   C9tjDRqNJeqppeAw7z+MTupY1QNps0KqJTtBSi4O1YSAQPfUBcEdnCofk
   A35kVXXRUqD6lSJYXzHP5kv7tVOsSXX2WtYUuf01ziZFjRuWMhgy0B5hp
   r5gdZUY9MBL5Dz5J0vtkvMrfChzKOFBjfjZmbt3AEy/FuwdlP4JG4UhiP
   emLDbYrVD9GYexls5cawZCbsighR4cKEDQyqiBOltcXCtkT9okton9WB/
   lC/myxTtbQNj5dpWQ9N/z8XVoFaJygRg91WMQFrnyXD5GPYiSLNCjkN5L
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="18232952"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="18232952"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 02:12:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="1214880"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa008.fm.intel.com with ESMTP; 06 Feb 2024 02:12:53 -0800
Date: Tue, 6 Feb 2024 18:09:18 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Pattara Teerapong <pteerapong@google.com>
Subject: Re: [PATCH 6/8] KVM: x86/mmu: Check for usable TDP MMU root while
 holding mmu_lock for read
Message-ID: <ZcIFTkWaTqItQPsj@yilunxu-OptiPlex-7050>
References: <20240111020048.844847-1-seanjc@google.com>
 <20240111020048.844847-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111020048.844847-7-seanjc@google.com>

On Wed, Jan 10, 2024 at 06:00:46PM -0800, Sean Christopherson wrote:
> When allocating a new TDP MMU root, check for a usable root while holding
> mmu_lock for read and only acquire mmu_lock for write if a new root needs
> to be created.  There is no need to serialize other MMU operations if a
> vCPU is simply grabbing a reference to an existing root, holding mmu_lock
> for write is "necessary" (spoiler alert, it's not strictly necessary) only
> to ensure KVM doesn't end up with duplicate roots.
> 
> Allowing vCPUs to get "new" roots in parallel is beneficial to VM boot and
> to setups that frequently delete memslots, i.e. which force all vCPUs to
> reload all roots.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  8 ++---
>  arch/x86/kvm/mmu/tdp_mmu.c | 60 +++++++++++++++++++++++++++++++-------
>  arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
>  3 files changed, 55 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c844e428684..ea18aca23196 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3693,15 +3693,15 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  	unsigned i;
>  	int r;
>  
> +	if (tdp_mmu_enabled)
> +		return kvm_tdp_mmu_alloc_root(vcpu);
> +
>  	write_lock(&vcpu->kvm->mmu_lock);
>  	r = make_mmu_pages_available(vcpu);
>  	if (r < 0)
>  		goto out_unlock;
>  
> -	if (tdp_mmu_enabled) {
> -		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> -		mmu->root.hpa = root;
> -	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> +	if (shadow_root_level >= PT64_ROOT_4LEVEL) {
>  		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
>  		mmu->root.hpa = root;
>  	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e0a8343f66dc..9a8250a14fc1 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -223,21 +223,52 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
>  	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
>  }
>  
> -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> +static struct kvm_mmu_page *kvm_tdp_mmu_try_get_root(struct kvm_vcpu *vcpu)
>  {
>  	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> +	int as_id = kvm_mmu_role_as_id(role);
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_mmu_page *root;
>  
> -	lockdep_assert_held_write(&kvm->mmu_lock);
> -
> -	/* Check for an existing root before allocating a new one. */
> -	for_each_valid_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> -		if (root->role.word == role.word &&
> -		    kvm_tdp_mmu_get_root(root))
> -			goto out;
> +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {

No lock yielding attempt in this loop, why change to _yield_safe version?

Thanks,
Yilun

> +		if (root->role.word == role.word)
> +			return root;
>  	}
>  
> +	return NULL;
> +}
> +
> +int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +	union kvm_mmu_page_role role = mmu->root_role;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_mmu_page *root;
> +
> +	/*
> +	 * Check for an existing root while holding mmu_lock for read to avoid
> +	 * unnecessary serialization if multiple vCPUs are loading a new root.
> +	 * E.g. when bringing up secondary vCPUs, KVM will already have created
> +	 * a valid root on behalf of the primary vCPU.
> +	 */
> +	read_lock(&kvm->mmu_lock);
> +	root = kvm_tdp_mmu_try_get_root(vcpu);
> +	read_unlock(&kvm->mmu_lock);
> +
> +	if (root)
> +		goto out;
> +
> +	write_lock(&kvm->mmu_lock);
> +
> +	/*
> +	 * Recheck for an existing root after acquiring mmu_lock for write.  It
> +	 * is possible a new usable root was created between dropping mmu_lock
> +	 * (for read) and acquiring it for write.
> +	 */
> +	root = kvm_tdp_mmu_try_get_root(vcpu);
> +	if (root)
> +		goto out_unlock;
> +
>  	root = tdp_mmu_alloc_sp(vcpu);
>  	tdp_mmu_init_sp(root, NULL, 0, role);
>  
> @@ -254,8 +285,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>  	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
>  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  
> +out_unlock:
> +	write_unlock(&kvm->mmu_lock);
>  out:
> -	return __pa(root->spt);
> +	/*
> +	 * Note, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS will prevent entering the guest
> +	 * and actually consuming the root if it's invalidated after dropping
> +	 * mmu_lock, and the root can't be freed as this vCPU holds a reference.
> +	 */
> +	mmu->root.hpa = __pa(root->spt);
> +	mmu->root.pgd = 0;
> +	return 0;
>  }
>  
>  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> @@ -917,7 +957,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>   * the VM is being destroyed).
>   *
>   * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
> - * See kvm_tdp_mmu_get_vcpu_root_hpa().
> + * See kvm_tdp_mmu_alloc_root().
>   */
>  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
>  {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 20d97aa46c49..6e1ea04ca885 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -10,7 +10,7 @@
>  void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
>  
> -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> +int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
>  
>  __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
>  {
> -- 
> 2.43.0.275.g3460e3d667-goog
> 
> 

