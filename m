Return-Path: <kvm+bounces-11493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D4B3877A71
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 05:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F6C91C20FDE
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 04:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C21881F;
	Mon, 11 Mar 2024 04:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kn5dAt4V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6691878;
	Mon, 11 Mar 2024 04:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710132486; cv=none; b=Se0Ff4dL+A2D8rfPx9YHKH/swzVGmclByXRQ1/63Yr8LMUcEn4VWsO/n+RQPr+0lmyRa5nyyGR7Z49GrAnwYAio4fw8qtMjRG8TrodxxACFhetczef5QdDenhVpVX6vwO3LynORYKjsbzwpuqGLsg6D0pSJa751zc6eu80bcTps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710132486; c=relaxed/simple;
	bh=+xQ984v3y25MBDNQk67yJ/vJQapd1ncJ6iyho2QJ5+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5Xe2S6qHDR6qvgUdVbzIkcj/mlhRGlokf9UQ5+eGL4S+VOzDFh/Smsru9KmzSoc+l8yGGskMSCeHY33bIfgULYwbsxE8uPJEdPMJsnxz99Kb+DZMYsbSQ/AbUcoXBtkPjKoW0v7mwnRrML5ZvjGNqk1JMpbKffNW+eM9uiUpuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kn5dAt4V; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710132485; x=1741668485;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+xQ984v3y25MBDNQk67yJ/vJQapd1ncJ6iyho2QJ5+w=;
  b=kn5dAt4V8P2HSwOZkqIgtsDMnxKX+l8+HaNkBtvtgF+4cdCLYCHVENkD
   iw3GBG6EDLjqkLs2BWFvhlgePLmcwDcvSKOwjVohk7fJ32UTq09Sk+skl
   CZX3BBR/Idjl6lYvsbsC0fYv6nUpIR5QI1dHSotHaP2mDU48v3v4DyNH0
   390p4vVhB5c3OT4WNJvfLdfnpeFInjmITCHjJaO9aX4hyyDuG+iD4cHKy
   EsDFx4YBktc8Y3kzXro15BStJ20x0nwg3zHkEQpVchx/1lDhUQV6p+JfL
   sQaV3W4oTGWKyrwwBhzWxDP3BbbisJmR1SChxC9oQ5FF28XayP5MI/4kp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="4621577"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="4621577"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 21:48:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="42030439"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa001.fm.intel.com with ESMTP; 10 Mar 2024 21:48:01 -0700
Date: Mon, 11 Mar 2024 12:43:41 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
Message-ID: <Ze6L/Tnrvs7eayqG@yilunxu-OptiPlex-7050>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-10-seanjc@google.com>
 <ZeqZ+BDTN5bIx0rm@yilunxu-OptiPlex-7050>
 <ZeufCK2Yj_8Bx7EV@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeufCK2Yj_8Bx7EV@google.com>

On Fri, Mar 08, 2024 at 03:28:08PM -0800, Sean Christopherson wrote:
> On Fri, Mar 08, 2024, Xu Yilun wrote:
> > On Tue, Feb 27, 2024 at 06:41:40PM -0800, Sean Christopherson wrote:
> > > Prioritize private vs. shared gfn attribute checks above slot validity
> > > checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
> > > userspace if there is no memslot, but emulate accesses to the APIC access
> > > page even if the attributes mismatch.
> > > 
> > > Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
> > > Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
> > > Cc: Chao Peng <chao.p.peng@linux.intel.com>
> > > Cc: Fuad Tabba <tabba@google.com>
> > > Cc: Michael Roth <michael.roth@amd.com>
> > > Cc: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 15 ++++++++++-----
> > >  1 file changed, 10 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 9206cfa58feb..58c5ae8be66c 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4365,11 +4365,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> > >  			return RET_PF_EMULATE;
> > >  	}
> > >  
> > > -	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> > > -		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > > -		return -EFAULT;
> > > -	}
> > > -
> > >  	if (fault->is_private)
> > >  		return kvm_faultin_pfn_private(vcpu, fault);
> > >  
> > > @@ -4410,6 +4405,16 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > >  	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> > >  	smp_rmb();
> > >  
> > > +	/*
> > > +	 * Check for a private vs. shared mismatch *after* taking a snapshot of
> > > +	 * mmu_invalidate_seq, as changes to gfn attributes are guarded by the
> > > +	 * invalidation notifier.
> > 
> > I didn't see how mmu_invalidate_seq influences gfn attribute judgement.
> > And there is no synchronization between the below check and
> > kvm_vm_set_mem_attributes(), the gfn attribute could still be changing
> > after the snapshot.
> 
> There is synchronization.  If kvm_vm_set_mem_attributes() changes the attributes,
> and thus bumps mmu_invalidate_seq, after kvm_faultin_pfn() takes its snapshot,
> then is_page_fault_stale() will detect that an invalidation related to the gfn
> occured and resume the guest *without* installing a mapping in KVM's page tables.
> 
> I.e. KVM may read the old, stale gfn attributes, but it will never actually
> expose the stale attirubtes to the guest.

That makes sense!  I was just thinking of the racing for below few lines,

	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
		return -EFAULT;
	}

But the guarding is actually for the whole kvm_faultin_pfn(). It is the
the same mechanism between getting old gfn attributes and getting old pfn.

I wonder if we could instead add some general comments at

   fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;

about the snapshot and is_page_fault_stale() thing.

Thanks,
Yilun
> 

