Return-Path: <kvm+bounces-21743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C2C9334A7
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 01:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D71A1C225EB
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 23:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A7D1442FD;
	Tue, 16 Jul 2024 23:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PSaCpzZi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E22481D5;
	Tue, 16 Jul 2024 23:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721173743; cv=none; b=l8LDHsocVoRrpT5IjALLDxIZVzY14zGSBnZWhMic5AQc7ImJUGKiv+RXaxIlZlKQY/3cJ2yPZ/JlJLiA44ghcV2VOdIKT3iTng8kKCaLDbYy4xiY+zeFpqE707C7S/t352qpSrNvnCTB7IfvRnDSuHs410j4xE+xPFZxkQTGZJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721173743; c=relaxed/simple;
	bh=g0rA0U8muHE/buzDMeKE/nEnkPPLpVNiN+DkRiyTolE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jrFNM/lxlmAUhkBAMrLNyOavFrgIb0z/57o6lRoULTMPt/B/nLSz4RSeDA2oAUUjaJXU65+PZrOn7qtbhwMbwKaDOEwo5BL4PKKp5PP1ardyvMMxF4hElWqRK3sgl2x5U+R0Hi2ilcF15dsSwyDwFd1c46C0gedAd3nj/nyWOTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PSaCpzZi; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721173742; x=1752709742;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=g0rA0U8muHE/buzDMeKE/nEnkPPLpVNiN+DkRiyTolE=;
  b=PSaCpzZiMuMa+UJjTt6OjY+VRTR8iIsraXBV5oPneZJxXWMjxrsEc7Ty
   Af01AfbeMy4VEOXKTGIhrEe8jhv+tKVdbvo5+17q2Bp8oYraB7RJM5Z+2
   dqHXlfFuI0OmWpALG3ExBX41hpFsswae/ddlqh0UQx9TU8azZkpjBxVYZ
   J78di2H2/litug+P1WDsYFc+3sWIqcGSbPmYPlbsUe8n46vkcwyX69AiU
   5qmDVqDhImm1QHL0LMCKV0SpKgevm2iAPDkybwjvqBUvqUog67cXfO82d
   x9V3RIixdQwnmng6OlHVVhgIi75ut1xHq1m4RnDubntKZnGo4FTOC6zmK
   Q==;
X-CSE-ConnectionGUID: KjobsD4iSXqz0Ie3o2GoiA==
X-CSE-MsgGUID: ONLLRuCjQ+WUKd9qg9KQkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18792254"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18792254"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 16:49:01 -0700
X-CSE-ConnectionGUID: y2/uzj8tSJu6eXqjCfnAWw==
X-CSE-MsgGUID: UOKLS6TnQeuFNGm1BWGEOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="55346237"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 16:49:00 -0700
Date: Tue, 16 Jul 2024 16:49:00 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add GPA limit check to
 kvm_arch_vcpu_pre_fault_memory()
Message-ID: <20240716234900.GF1900928@ls.amr.corp.intel.com>
References: <f2a46971d37ee3bf32ff33dc730e16bf0f755410.1721091397.git.isaku.yamahata@intel.com>
 <ZpbVVyp3YvCJp3Am@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZpbVVyp3YvCJp3Am@google.com>

On Tue, Jul 16, 2024 at 01:17:27PM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Jul 15, 2024, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add GPA limit check to kvm_arch_vcpu_pre_fault_memory() with guest
> > maxphyaddr and kvm_mmu_max_gfn().
> > 
> > The KVM page fault handler decides which level of TDP to use, 4-level TDP
> > or 5-level TDP based on guest maxphyaddr (CPUID[0x80000008].EAX[7:0]), the
> > host maxphyaddr, and whether the host supports 5-level TDP or not.  The
> > 4-level TDP can map GPA up to 48 bits, and the 5-level TDP can map GPA up
> > to 52 bits.  If guest maxphyaddr <= 48, KVM uses 4-level TDP even when the
> > host supports 5-level TDP.
> > 
> > If we pass GPA > beyond the TDP mappable limit to the TDP MMU fault handler
> > (concretely GPA > 48-bits with 4-level TDP), it will operate on GPA without
> > upper bits, (GPA & ((1UL < 48) - 1)), not the specified GPA.  It is not
> > expected behavior.  It wrongly maps GPA without upper bits with the page
> > for GPA with upper bits.
> > 
> > KVM_PRE_FAULT_MEMORY calls x86 KVM page fault handler, kvm_tdp_page_fault()
> > with a user-space-supplied GPA without the limit check so that the user
> > space can trigger WARN_ON_ONCE().  Check the GPA limit to fix it.
> 
> Which WARN?

Sorry, I confused with the local changes for 4/5-level.


> 
> > - For non-TDX case (DEFAULT_VM, SW_PROTECTED_VM, or SEV):
> >   When the host supports 5-level TDP, KVM decides to use 4-level TDP if
> >   cpuid_maxphyaddr() <= 48.  cpuid_maxhyaddr() check prevents
> >   KVM_PRE_FAULT_MEMORY from passing GFN beyond mappable GFN.
> 
> Hardening against cpuid_maxphyaddr() should be out of scope.  We don't enforce
> it for guest faults, e.g. KVM doesn't kill the guest if allow_smaller_maxphyaddr
> is false and the GPA is supposed to be illegal.  And trying to enforce it here is
> a fool's errand since userspace can simply do KVM_SET_CPUID2 to circumvent the
> restriction.

Ok, I'll drop maxphys addr check.


> > - For TDX case:
> >   We'd like to exclude shared bit (or gfn_direct_mask in [1]) from GPA
> >   passed to the TDP MMU so that the TDP MMU can handle Secure-EPT or
> >   Shared-EPT (direct or mirrored in [1]) without explicitly
> >   setting/clearing the GPA (except setting up the TDP iterator,
> >   tdp_iter_refresh_sptep()).  We'd like to make kvm_mmu_max_gfn() per VM
> >   for TDX to be 52 or 47 independent of the guest maxphyaddr with other
> >   patches.
> > 
> > Fixes: 6e01b7601dfe ("KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()")
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 4e0e9963066f..6ee5af55cee1 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4756,6 +4756,11 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >  	u64 end;
> >  	int r;
> >  
> > +	if (range->gpa >= (1UL << cpuid_maxphyaddr(vcpu)))
> > +		return -E2BIG;
> > +	if (gpa_to_gfn(range->gpa) > kvm_mmu_max_gfn())
> > +		return -E2BIG;
> 
> 
> Related to my thoughts on making kvm_mmu_max_gfn() and rejecting aliased memslots,
> I think we should add a common helper that's used by kvm_arch_prepare_memory_region()
> and kvm_arch_vcpu_pre_fault_memory() to reject GPAs that are disallowed.
> 
> https://lore.kernel.org/all/ZpbKqG_ZhCWxl-Fc@google.com

I'll look into it. I'll combine two patches into single patch series.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

