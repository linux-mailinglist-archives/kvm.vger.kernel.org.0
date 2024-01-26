Return-Path: <kvm+bounces-7085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AD7A83D5AB
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0908D2865BA
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0526A348;
	Fri, 26 Jan 2024 08:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E1Xxd/8d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2044EBE62;
	Fri, 26 Jan 2024 08:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706256583; cv=none; b=EFYdNIPSx13qHMFu9I+rOBBddsk4q6CyIS8kv7871BFO4EyNmA8WIN3cvmdNCD2sQh2XJ77vlUw5J9f9DKzvkSqaNpSz4pGsPKpGpjitV9UNPMQJC0nf9vmp/nHEvUSP7sGGESJM9jcwQq5gtLTqayv+007E/XzgFrP+BAZAwNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706256583; c=relaxed/simple;
	bh=0szE48INaKewwpjGWxapSAC8Tr8Em99nueDTOh87npY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmiBNeQlnb+qmNzSWyVDtCw6ycrHwZ7iByZG7dsl+ezjI3EH33HxjuPBsBOw2n4xWhxXIIKvccwvymINmP/+ebFrievVA9Sszd6cfNyuCObxkKfaBLaLd4gUkzqAYd7QFr0xWpmZmtd49+pZfp88YC9jJ+1qhNB5vASny4k/MvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E1Xxd/8d; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706256581; x=1737792581;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0szE48INaKewwpjGWxapSAC8Tr8Em99nueDTOh87npY=;
  b=E1Xxd/8dtEcR2mNI9sPst2xe/Ce2fWa9xiHrYb7UcutKAGL8jPtwehZN
   gaciwQ2JGuuiAFL82MWeZe/ZwezESUsfIwUVT8oFjFgTNZiOFfQVdvelA
   GBe3T+zPLjhO8Utsih95srwVabOurNtNpI94aVNhFfb1QuPMIBLeMGJmR
   IWPaDFSaWOLqXv8VJclSJy3kqLBIu1sTeSIg41pHTrdUdGEjGzom/XvoU
   g9Fb1bhXBNTYrCcQGVuMWAEa3I/Kq/NuZ/XKwU7JDHbhcvHXBOjfu4Seb
   xemxPCgBuj3Wl7zsprEO8fl/5q07ULiNAJyTK4dIRr76kdFpRvp4kW7LN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9095971"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9095971"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:09:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="960143071"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="960143071"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orsmga005.jf.intel.com with ESMTP; 26 Jan 2024 00:09:37 -0800
Date: Fri, 26 Jan 2024 16:06:17 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 3/4] KVM: Get reference to VM's address space in the
 async #PF worker
Message-ID: <ZbNn+Z8TzOcgJZJg@yilunxu-OptiPlex-7050>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-4-seanjc@google.com>
 <Zavj4U2LYeOsnXOh@yilunxu-OptiPlex-7050>
 <ZbFcXB5ctGOMEr22@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbFcXB5ctGOMEr22@google.com>

On Wed, Jan 24, 2024 at 10:52:12AM -0800, Sean Christopherson wrote:
> On Sat, Jan 20, 2024, Xu Yilun wrote:
> > On Tue, Jan 09, 2024 at 05:15:32PM -0800, Sean Christopherson wrote:
> > > Get a reference to the target VM's address space in async_pf_execute()
> > > instead of gifting a reference from kvm_setup_async_pf().  Keeping the
> > > address space alive just to service an async #PF is counter-productive,
> > > i.e. if the process is exiting and all vCPUs are dead, then NOT doing
> > > get_user_pages_remote() and freeing the address space asap is desirable.
> > > 
> > > Handling the mm reference entirely within async_pf_execute() also
> > > simplifies the async #PF flows as a whole, e.g. it's not immediately
> > > obvious when the worker task vs. the vCPU task is responsible for putting
> > > the gifted mm reference.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  include/linux/kvm_host.h |  1 -
> > >  virt/kvm/async_pf.c      | 32 ++++++++++++++++++--------------
> > >  2 files changed, 18 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 7e7fd25b09b3..bbfefd7e612f 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -238,7 +238,6 @@ struct kvm_async_pf {
> > >  	struct list_head link;
> > >  	struct list_head queue;
> > >  	struct kvm_vcpu *vcpu;
> > > -	struct mm_struct *mm;
> > >  	gpa_t cr2_or_gpa;
> > >  	unsigned long addr;
> > >  	struct kvm_arch_async_pf arch;
> > > diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> > > index d5dc50318aa6..c3f4f351a2ae 100644
> > > --- a/virt/kvm/async_pf.c
> > > +++ b/virt/kvm/async_pf.c
> > > @@ -46,8 +46,8 @@ static void async_pf_execute(struct work_struct *work)
> > >  {
> > >  	struct kvm_async_pf *apf =
> > >  		container_of(work, struct kvm_async_pf, work);
> > > -	struct mm_struct *mm = apf->mm;
> > >  	struct kvm_vcpu *vcpu = apf->vcpu;
> > > +	struct mm_struct *mm = vcpu->kvm->mm;
> > >  	unsigned long addr = apf->addr;
> > >  	gpa_t cr2_or_gpa = apf->cr2_or_gpa;
> > >  	int locked = 1;
> > > @@ -56,16 +56,24 @@ static void async_pf_execute(struct work_struct *work)
> > >  	might_sleep();
> > >  
> > >  	/*
> > > -	 * This work is run asynchronously to the task which owns
> > > -	 * mm and might be done in another context, so we must
> > > -	 * access remotely.
> > > +	 * Attempt to pin the VM's host address space, and simply skip gup() if
> > > +	 * acquiring a pin fail, i.e. if the process is exiting.  Note, KVM
> > > +	 * holds a reference to its associated mm_struct until the very end of
> > > +	 * kvm_destroy_vm(), i.e. the struct itself won't be freed before this
> > > +	 * work item is fully processed.
> > >  	 */
> > > -	mmap_read_lock(mm);
> > > -	get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, &locked);
> > > -	if (locked)
> > > -		mmap_read_unlock(mm);
> > > -	mmput(mm);
> > > +	if (mmget_not_zero(mm)) {
> > > +		mmap_read_lock(mm);
> > > +		get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, &locked);
> > > +		if (locked)
> > > +			mmap_read_unlock(mm);
> > > +		mmput(mm);
> > > +	}
> > >  
> > > +	/*
> > > +	 * Notify and kick the vCPU even if faulting in the page failed, e.g.
> > 
> > How about when the process is exiting? Could we just skip the following?
> 
> Maybe?  I'm not opposed to trimming this down even more, but I doubt it will make
> much of a difference.  The vCPU can't be running so async_pf.lock shouldn't be
> contended, no IPIs will be issued for kicks, etc.  So for this patch at least,
> I want to take the most conservative approach while still cleaning up the mm_struct
> usage.

It's good to me.

Reviewed-by: Xu Yilun <yilun.xu@intel.com>

