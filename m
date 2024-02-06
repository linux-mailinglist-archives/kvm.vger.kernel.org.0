Return-Path: <kvm+bounces-8106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B6284B9EC
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 16:42:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F1F51F22345
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 15:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C219A133435;
	Tue,  6 Feb 2024 15:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B3k903NX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B05132C1B;
	Tue,  6 Feb 2024 15:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707234163; cv=none; b=uPtcVCZLMyjA3LIeKHnLIoEKLN9W06Q6RbKlJMEL2kJd8GLV44f4vFqzj3YUzAOpiAm7tU6dvhZeqsRCHUwb5ujJ34Ri7OhIOCHPzqNcN0WyqtP7tJCEBWfxwBT5gcQT/vTHrr8WTUPiYCWDpIBgGaEK857VXPkSfx65g4DP2Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707234163; c=relaxed/simple;
	bh=55QXQxJDQOG7HqlXSoDBC52tqHTe/Q36kRchCdnTUcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIeftYzwhHghTAGne+57+cD94WUK5Fy7JjkB41oTwBg6PXK1yVHxTp+DNVNVw3g0OLr4LGbHGIZEzJ7qcsApYsreDTdMnIM7vVf/yXdTO99AdQMUgC5ei/R3zOnXD2l6+e1VVYc5gKwDv5j+9npZhkvMBfyfeM+kPIrUGS8NEkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B3k903NX; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707234162; x=1738770162;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=55QXQxJDQOG7HqlXSoDBC52tqHTe/Q36kRchCdnTUcI=;
  b=B3k903NXNFGR7OTHxZ04GvCh2TKKQpsK73bQcsi2SJJDGxPVgVhbC+cn
   fVApJWqqvpVLvo6anWzVTRxT9gzX3jaVNu9cYQrFS/C+UXdlgo1Cp+Ira
   FwPmr8UsT4+VovhaahzB6FSe9NaUhAHHROmEvmsyZD7Rc5MNIPfwWcPfJ
   q3plPjPKEMfx8EVdu7skb7KrzG8kQbpg+g6t4WDSdCiXBSPtD6O4b1k6w
   Q+LU+UJwKqeyKmtemG8xJImGWE811dYIH8Yg4f/txjYv0HqfF3QVqOaIy
   hqbmqfKsnEQ7v8Q0Z9ph/yWr3k7y+mhXQjbXP7BRZnMHmmyxg6Tb2MTE3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="4655672"
X-IronPort-AV: E=Sophos;i="6.05,247,1701158400"; 
   d="scan'208";a="4655672"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 07:42:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,247,1701158400"; 
   d="scan'208";a="32132035"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa001.fm.intel.com with ESMTP; 06 Feb 2024 07:42:40 -0800
Date: Tue, 6 Feb 2024 23:39:04 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Pattara Teerapong <pteerapong@google.com>
Subject: Re: [PATCH 7/8] KVM: x86/mmu: Alloc TDP MMU roots while holding
 mmu_lock for read
Message-ID: <ZcJSmNRLbKacPfoq@yilunxu-OptiPlex-7050>
References: <20240111020048.844847-1-seanjc@google.com>
 <20240111020048.844847-8-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111020048.844847-8-seanjc@google.com>

On Wed, Jan 10, 2024 at 06:00:47PM -0800, Sean Christopherson wrote:
> Allocate TDP MMU roots while holding mmu_lock for read, and instead use
> tdp_mmu_pages_lock to guard against duplicate roots.  This allows KVM to
> create new roots without forcing kvm_tdp_mmu_zap_invalidated_roots() to
> yield, e.g. allows vCPUs to load new roots after memslot deletion without
> forcing the zap thread to detect contention and yield (or complete if the
> kernel isn't preemptible).
> 
> Note, creating a new TDP MMU root as an mmu_lock reader is safe for two
> reasons: (1) paths that must guarantee all roots/SPTEs are *visited* take
> mmu_lock for write and so are still mutually exclusive, e.g. mmu_notifier
> invalidations, and (2) paths that require all roots/SPTEs to *observe*
> some given state without holding mmu_lock for write must ensure freshness
> through some other means, e.g. toggling dirty logging must first wait for
> SRCU readers to recognize the memslot flags change before processing
> existing roots/SPTEs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 55 +++++++++++++++-----------------------
>  1 file changed, 22 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 9a8250a14fc1..d078157e62aa 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -223,51 +223,42 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
>  	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
>  }
>  
> -static struct kvm_mmu_page *kvm_tdp_mmu_try_get_root(struct kvm_vcpu *vcpu)
> -{
> -	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> -	int as_id = kvm_mmu_role_as_id(role);
> -	struct kvm *kvm = vcpu->kvm;
> -	struct kvm_mmu_page *root;
> -
> -	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
> -		if (root->role.word == role.word)
> -			return root;
> -	}
> -
> -	return NULL;
> -}
> -
>  int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  	union kvm_mmu_page_role role = mmu->root_role;
> +	int as_id = kvm_mmu_role_as_id(role);
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_mmu_page *root;
>  
>  	/*
> -	 * Check for an existing root while holding mmu_lock for read to avoid
> +	 * Check for an existing root before acquiring the pages lock to avoid
>  	 * unnecessary serialization if multiple vCPUs are loading a new root.
>  	 * E.g. when bringing up secondary vCPUs, KVM will already have created
>  	 * a valid root on behalf of the primary vCPU.
>  	 */
>  	read_lock(&kvm->mmu_lock);
> -	root = kvm_tdp_mmu_try_get_root(vcpu);
> -	read_unlock(&kvm->mmu_lock);
>  
> -	if (root)
> -		goto out;
> +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
> +		if (root->role.word == role.word)
> +			goto out_read_unlock;
> +	}
>  
> -	write_lock(&kvm->mmu_lock);

It seems really complex to me...

I failed to understand why the following KVM_BUG_ON() could be avoided
without the mmu_lock for write. I thought a valid root could be added
during zapping.

  void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  {
	struct kvm_mmu_page *root;

	read_lock(&kvm->mmu_lock);

	for_each_tdp_mmu_root_yield_safe(kvm, root) {
		if (!root->tdp_mmu_scheduled_root_to_zap)
			continue;

		root->tdp_mmu_scheduled_root_to_zap = false;
		KVM_BUG_ON(!root->role.invalid, kvm);

Thanks,
Yilun

> +	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  
>  	/*
> -	 * Recheck for an existing root after acquiring mmu_lock for write.  It
> -	 * is possible a new usable root was created between dropping mmu_lock
> -	 * (for read) and acquiring it for write.
> +	 * Recheck for an existing root after acquiring the pages lock, another
> +	 * vCPU may have raced ahead and created a new usable root.  Manually
> +	 * walk the list of roots as the standard macros assume that the pages
> +	 * lock is *not* held.  WARN if grabbing a reference to a usable root
> +	 * fails, as the last reference to a root can only be put *after* the
> +	 * root has been invalidated, which requires holding mmu_lock for write.
>  	 */
> -	root = kvm_tdp_mmu_try_get_root(vcpu);
> -	if (root)
> -		goto out_unlock;
> +	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> +		if (root->role.word == role.word &&
> +		    !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
> +			goto out_spin_unlock;
> +	}
>  
>  	root = tdp_mmu_alloc_sp(vcpu);
>  	tdp_mmu_init_sp(root, NULL, 0, role);
> @@ -280,14 +271,12 @@ int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
>  	 * is ultimately put by kvm_tdp_mmu_zap_invalidated_roots().
>  	 */
>  	refcount_set(&root->tdp_mmu_root_count, 2);
> -
> -	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
> -	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  
> -out_unlock:
> -	write_unlock(&kvm->mmu_lock);
> -out:
> +out_spin_unlock:
> +	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +out_read_unlock:
> +	read_unlock(&kvm->mmu_lock);
>  	/*
>  	 * Note, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS will prevent entering the guest
>  	 * and actually consuming the root if it's invalidated after dropping
> -- 
> 2.43.0.275.g3460e3d667-goog
> 
> 

