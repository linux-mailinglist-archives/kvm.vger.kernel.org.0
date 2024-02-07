Return-Path: <kvm+bounces-8235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0877184CDD2
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:17:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99E171F23386
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410A37F7D9;
	Wed,  7 Feb 2024 15:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ljNFezj+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E24E7E77F;
	Wed,  7 Feb 2024 15:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707319042; cv=none; b=oXZpn15sRzbED1TXBX89XNTM4G4/vhei6cx5qDHVkvmy/c2pbAW8GmGO8xNjkYbi5UTYCqUj6XFhFXikBvyG/C26tc/lQHsaoapC8IzUi0TULStjU0hlj6Nn9hxd7uaFSyKtGdK/Eh0nxQJrNFLHBvaot29msGPBtHWPqpBlLLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707319042; c=relaxed/simple;
	bh=HaVwog0vd20fRKI8tk8LKuyAmGU4sQJZhYsnB/xkj5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4lTtvQyMWW2mtEOggBYFloPP5IZI1zA4acfsjcd6p/83cjwIFKCoKjnZOKFoU9+3l/oe1yKlHO5Zz/TF4PsB+FmS3QJ1cQbfzhY3hv5AVg0KCe/7QUlOk8AN0lin7SBRpgrx9V6F/Cj4PnvlhrZQ43JYK2KpHWtHzU/7hl0RJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ljNFezj+; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707319040; x=1738855040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HaVwog0vd20fRKI8tk8LKuyAmGU4sQJZhYsnB/xkj5U=;
  b=ljNFezj+yRIK1tU8w7rnmY+UpOSZJPEn+GD4gcS5bzKJeP2v71DwSbfz
   kkdxYx+W/R4QVenb/OlBOmUj74PXUZDy5xRNLdUfLD7Mll/Oeh6hZviw/
   d59A9tr331+wHN2ArXcR/AKdXkcgq/R1Vz5gXswEqpxN/fXVGXwHAF8Go
   A8oC1QBlH28tKTPNs+O+9Fl/NcFB8pB5TtafxLJ2EL65X6g+i/TwC7i0P
   Zk4ToDtz3QtLkJDYn9qKDopgPLQ4tve+pjShTWYuwiHogD/9ySD3CfpnI
   M+Prs2oWTFTnvAU0jV6Nbs5X6lJJ2HSj6n3fw3lcFGzIG66iO7z+Rs7NL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="11742453"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="11742453"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 07:17:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="32431766"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa001.fm.intel.com with ESMTP; 07 Feb 2024 07:17:18 -0800
Date: Wed, 7 Feb 2024 23:13:41 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Pattara Teerapong <pteerapong@google.com>
Subject: Re: [PATCH 7/8] KVM: x86/mmu: Alloc TDP MMU roots while holding
 mmu_lock for read
Message-ID: <ZcOeJXHsiE5XUrBv@yilunxu-OptiPlex-7050>
References: <20240111020048.844847-1-seanjc@google.com>
 <20240111020048.844847-8-seanjc@google.com>
 <ZcJSmNRLbKacPfoq@yilunxu-OptiPlex-7050>
 <ZcJ2JG54O0g07e-P@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcJ2JG54O0g07e-P@google.com>

On Tue, Feb 06, 2024 at 10:10:44AM -0800, Sean Christopherson wrote:
> On Tue, Feb 06, 2024, Xu Yilun wrote:
> > On Wed, Jan 10, 2024 at 06:00:47PM -0800, Sean Christopherson wrote:
> > > ---
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 55 +++++++++++++++-----------------------
> > >  1 file changed, 22 insertions(+), 33 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 9a8250a14fc1..d078157e62aa 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -223,51 +223,42 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
> > >  	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
> > >  }
> > >  
> > > -static struct kvm_mmu_page *kvm_tdp_mmu_try_get_root(struct kvm_vcpu *vcpu)
> > > -{
> > > -	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> > > -	int as_id = kvm_mmu_role_as_id(role);
> > > -	struct kvm *kvm = vcpu->kvm;
> > > -	struct kvm_mmu_page *root;
> > > -
> > > -	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
> > > -		if (root->role.word == role.word)
> > > -			return root;
> > > -	}
> > > -
> > > -	return NULL;
> > > -}
> > > -
> > >  int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
> > >  {
> > >  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> > >  	union kvm_mmu_page_role role = mmu->root_role;
> > > +	int as_id = kvm_mmu_role_as_id(role);
> > >  	struct kvm *kvm = vcpu->kvm;
> > >  	struct kvm_mmu_page *root;
> > >  
> > >  	/*
> > > -	 * Check for an existing root while holding mmu_lock for read to avoid
> > > +	 * Check for an existing root before acquiring the pages lock to avoid
> > >  	 * unnecessary serialization if multiple vCPUs are loading a new root.
> > >  	 * E.g. when bringing up secondary vCPUs, KVM will already have created
> > >  	 * a valid root on behalf of the primary vCPU.
> > >  	 */
> > >  	read_lock(&kvm->mmu_lock);
> > > -	root = kvm_tdp_mmu_try_get_root(vcpu);
> > > -	read_unlock(&kvm->mmu_lock);
> > >  
> > > -	if (root)
> > > -		goto out;
> > > +	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id) {
> > > +		if (root->role.word == role.word)
> > > +			goto out_read_unlock;
> > > +	}
> > >  
> > > -	write_lock(&kvm->mmu_lock);
> > 
> > It seems really complex to me...
> > 
> > I failed to understand why the following KVM_BUG_ON() could be avoided
> > without the mmu_lock for write. I thought a valid root could be added
> > during zapping.
> > 
> >   void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
> >   {
> > 	struct kvm_mmu_page *root;
> > 
> > 	read_lock(&kvm->mmu_lock);
> > 
> > 	for_each_tdp_mmu_root_yield_safe(kvm, root) {
> > 		if (!root->tdp_mmu_scheduled_root_to_zap)
> > 			continue;
> > 
> > 		root->tdp_mmu_scheduled_root_to_zap = false;
> > 		KVM_BUG_ON(!root->role.invalid, kvm);
> 
> tdp_mmu_scheduled_root_to_zap is set only when mmu_lock is held for write, i.e.
> it's mutually exclusive with allocating a new root.
> 
> And tdp_mmu_scheduled_root_to_zap is cleared if and only if kvm_tdp_mmu_zap_invalidated_roots
> is already set, and is only processed by kvm_tdp_mmu_zap_invalidated_roots(),
> which runs under slots_lock (a mutex).
> 
> So a new, valid root can be added, but it won't have tdp_mmu_scheduled_root_to_zap
> set, at least not until the current "fast zap" completes and a new one beings,
> which as above requires taking mmu_lock for write.

It's clear to me.

Thanks for the detailed explanation.
> 

