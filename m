Return-Path: <kvm+bounces-15887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9C858B185A
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 03:13:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA7E0B239A8
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 01:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96046107A8;
	Thu, 25 Apr 2024 01:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WAC18Cwx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F215BE545;
	Thu, 25 Apr 2024 01:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714007572; cv=none; b=EoLmrHY4gbvoeeTKMLcYqvsRVDv51V1z+BPtFCoNSKQiwPeyEx7lwxmmHUcgBc8ZxX8+eaZ0/18NA3YcAffXtovUXTjShk3hOJUqwIxJiFGkbE1UUpE7QGONtLVA++R96pTAsPL1zMxrjbbWHA2qQmRSBK+lPoHkt/XLEdtKuj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714007572; c=relaxed/simple;
	bh=DCOHQ81K7KSwHRn/ZnyTyNG2ltuVE6co4OXFYQ6sob0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=re6lE1s+PXCUwVUkjoPbrniore7UuFt0oEKA4O/d3jz+GZyLcIXrEa6/EmEGmjfEgUpA4SdRM561dG7vsQiwRBodVeH+SCb+8GwdhAG3HULmM/zKK2f+9Cefgq/gIlsotFZljw0I/XQSNrQ54yKLRspHotcbKt6+j7WSD+9I5PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WAC18Cwx; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714007571; x=1745543571;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DCOHQ81K7KSwHRn/ZnyTyNG2ltuVE6co4OXFYQ6sob0=;
  b=WAC18Cwx5jVx49Hwm+BvtCS3+qQJrRWFW3n3KqWAnaGqeU55Ia4+Er4D
   pRPZyCe13NmULS5ma8g3vQ1H6E7fI6/tCjOcWLjTiQeahCWUugqmM8NY8
   itvtBVy/IZMK1GjUSMIZqiFNMI5f0bjzMS2fUWAaqgWk/v0f0YilqBmXn
   Y182LqaMmxB/bR5BHegtnkF2h49bFz6kt80ZbaOYNr/+fsJFOpzcac2il
   xa0gkLGSdoUcBvtzdXnt/r0SjSynWBcBdZRSNx43mKaFoVmBsD/jAIQ77
   OeWDAAPUZCGsJu/n4Sq/H6NA7u+C7odf+fm/7OwAGQLAQvOoYCl0b0WWs
   w==;
X-CSE-ConnectionGUID: D9UBBNtiSRmXb7LJ29iUNw==
X-CSE-MsgGUID: BVvWzp9sSXWCZYTD8jaj3w==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9536130"
X-IronPort-AV: E=Sophos;i="6.07,227,1708416000"; 
   d="scan'208";a="9536130"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 18:12:50 -0700
X-CSE-ConnectionGUID: eXxpT0YkSSa0srnuU8Ltfg==
X-CSE-MsgGUID: xNx5iu/MSZm01HRWdLmMkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,227,1708416000"; 
   d="scan'208";a="25402870"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 18:12:49 -0700
Date: Wed, 24 Apr 2024 18:12:48 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, michael.roth@amd.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating
 gmem pages with user data
Message-ID: <20240425011248.GP3596705@ls.amr.corp.intel.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-10-pbonzini@redhat.com>
 <20240423235013.GO3596705@ls.amr.corp.intel.com>
 <ZimGulY6qyxt6ylO@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZimGulY6qyxt6ylO@google.com>

On Wed, Apr 24, 2024 at 03:24:58PM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Tue, Apr 23, 2024, Isaku Yamahata wrote:
> > On Thu, Apr 04, 2024 at 02:50:31PM -0400,
> > Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > > During guest run-time, kvm_arch_gmem_prepare() is issued as needed to
> > > prepare newly-allocated gmem pages prior to mapping them into the guest.
> > > In the case of SEV-SNP, this mainly involves setting the pages to
> > > private in the RMP table.
> > > 
> > > However, for the GPA ranges comprising the initial guest payload, which
> > > are encrypted/measured prior to starting the guest, the gmem pages need
> > > to be accessed prior to setting them to private in the RMP table so they
> > > can be initialized with the userspace-provided data. Additionally, an
> > > SNP firmware call is needed afterward to encrypt them in-place and
> > > measure the contents into the guest's launch digest.
> > > 
> > > While it is possible to bypass the kvm_arch_gmem_prepare() hooks so that
> > > this handling can be done in an open-coded/vendor-specific manner, this
> > > may expose more gmem-internal state/dependencies to external callers
> > > than necessary. Try to avoid this by implementing an interface that
> > > tries to handle as much of the common functionality inside gmem as
> > > possible, while also making it generic enough to potentially be
> > > usable/extensible for TDX as well.
> > 
> > I explored how TDX will use this hook.  However, it resulted in not using this
> > hook, and instead used kvm_tdp_mmu_get_walk() with a twist.  The patch is below.
> > 
> > Because SEV-SNP manages the RMP that is not tied to NPT directly, SEV-SNP can
> > ignore TDP MMU page tables when updating RMP.
> > On the other hand, TDX essentially updates Secure-EPT when it adds a page to
> > the guest by TDH.MEM.PAGE.ADD().  It needs to protect KVM TDP MMU page tables
> > with mmu_lock, not guest memfd file mapping with invalidate_lock.  The hook
> > doesn't apply to TDX well.  The resulted KVM_TDX_INIT_MEM_REGION logic is as
> > follows.
> > 
> >   get_user_pages_fast(source addr)
> >   read_lock(mmu_lock)
> >   kvm_tdp_mmu_get_walk_private_pfn(vcpu, gpa, &pfn);
> >   if the page table doesn't map gpa, error.
> >   TDH.MEM.PAGE.ADD()
> >   TDH.MR.EXTEND()
> >   read_unlock(mmu_lock)
> >   put_page()
> 
> Hmm, KVM doesn't _need_ to use invalidate_lock to protect against guest_memfd
> invalidation, but I also don't see why it would cause problems.  I.e. why not
> take mmu_lock() in TDX's post_populate() implementation?

We can take the lock.  Because we have already populated the GFN of guest_memfd,
we need to make kvm_gmem_populate() not pass FGP_CREAT_ONLY.  Otherwise we'll
get -EEXIST.


> That would allow having
> a sanity check that the PFN that guest_memfd() has is indeed the PFN that KVM's
> S-EPT mirror has, i.e. the PFN that KVM is going to PAGE.ADD.

Because we have PFN from the mirrored EPT, I thought it's duplicate to get PFN
again via guest memfd.  We can check if two PFN matches.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

