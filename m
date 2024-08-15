Return-Path: <kvm+bounces-24238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC324952B15
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 11:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E3AC2812E2
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 09:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484FA1BF32C;
	Thu, 15 Aug 2024 08:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hVvbmP+V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5667D1BF31C;
	Thu, 15 Aug 2024 08:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723710645; cv=none; b=qk4V82XwD3xXBDB9AxlIivAv6ZB2qfTXxCTZyaHlsP+FYns269OYHhQLeIGkRLDKuerIbCd9lEdShm36KLFKKgUj3TsdSn/QxLksUdoRfBQEjiWTtqz8SEbG4yrAWNZ63Z1v4lQbkdpe83DDNlAlyLjH+I0r+4GCeFQRzuMLEQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723710645; c=relaxed/simple;
	bh=umWuN6DJjYYUyFKidQehFx3KKXN+3HzPpnQu8tyFmbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IrwUpbYTNfHC4SfmZzlLqVOXmhWL9AmGqANZzTyg4qUVm25lbdO+PyzEToqhpcG+ILQ5XAcp73SVAjV34/5l2Y9bVaDkOB0bDku96aHCpZ8gs5Ce14OHKxXYbzZG8oZTtZD4UbOiu+ce1Wq/CF8O9sPkrRAP9wfBJ1YNxSvFrsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hVvbmP+V; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723710644; x=1755246644;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=umWuN6DJjYYUyFKidQehFx3KKXN+3HzPpnQu8tyFmbk=;
  b=hVvbmP+V65RswPh5HNwzABQ6EkBnKFtzz3CfnzTAZc0HnNMdPHjcspqH
   wCche49q+811Z9Kk7LIWOtBvdBEyqgv8hfDgj1bRqFWD7DtlXLyf5XG8u
   SF/D/u9M5FT4sOQ3dX3DlHGiGsrWigaHWiMUyQpKfuHx3XrZDPZxLCc+f
   otjXO1y0vckPzf9/eZb28WujkwO3rL+HKyRyLzkdyNeYAKRlcWk879qUu
   sDleDo3V5S4rhRigP2DLONgdV5MND3i9q4vwsFar5CZyVqQ5VVT/1W9F8
   ke/rnoMbdgi2z15ekCz1pCbUWP+5unmaUsvftSXk6KP3atF4/o0ul1Djc
   g==;
X-CSE-ConnectionGUID: e8yNsT83TPma7fK02bK78g==
X-CSE-MsgGUID: g8pKFBliQFOOuUT7vQnWyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="32533749"
X-IronPort-AV: E=Sophos;i="6.10,148,1719903600"; 
   d="scan'208";a="32533749"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 01:30:43 -0700
X-CSE-ConnectionGUID: CzdzmKY4RNmLhKSvjvD/pQ==
X-CSE-MsgGUID: Fpc0aYNiR+ePp5bX3oUZQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,148,1719903600"; 
   d="scan'208";a="60052023"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa008.jf.intel.com with ESMTP; 15 Aug 2024 01:30:40 -0700
Date: Thu, 15 Aug 2024 16:30:39 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerly Tng <ackerleytng@google.com>
Subject: Re: [PATCH 03/22] KVM: x86/mmu: Trigger unprotect logic only on
 write-protection page faults
Message-ID: <20240815083039.737qa2bxhwxxhf32@yy-desk-7060>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-4-seanjc@google.com>
 <20240814114230.hgzrh3cal6k6x2dn@yy-desk-7060>
 <Zry9Us0HVEDmhCB4@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zry9Us0HVEDmhCB4@google.com>
User-Agent: NeoMutt/20171215

On Wed, Aug 14, 2024 at 07:21:06AM -0700, Sean Christopherson wrote:
> On Wed, Aug 14, 2024, Yuan Yao wrote:
> > > @@ -5960,6 +5961,41 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> > >  	write_unlock(&vcpu->kvm->mmu_lock);
> > >  }
> > >
> > > +static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > > +				       u64 error_code, int *emulation_type)
> > > +{
> > > +	bool direct = vcpu->arch.mmu->root_role.direct;
> > > +
> > > +	/*
> > > +	 * Before emulating the instruction, check if the error code
> > > +	 * was due to a RO violation while translating the guest page.
> > > +	 * This can occur when using nested virtualization with nested
> > > +	 * paging in both guests. If true, we simply unprotect the page
> > > +	 * and resume the guest.
> > > +	 */
> > > +	if (direct &&
> > > +	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
> > > +		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
> > > +		return RET_PF_FIXED;
> > > +	}
> > > +
> > > +	/*
> > > +	 * The gfn is write-protected, but if emulation fails we can still
> > > +	 * optimistically try to just unprotect the page and let the processor
> > > +	 * re-execute the instruction that caused the page fault.  Do not allow
> > > +	 * retrying MMIO emulation, as it's not only pointless but could also
> > > +	 * cause us to enter an infinite loop because the processor will keep
> > > +	 * faulting on the non-existent MMIO address.  Retrying an instruction
> > > +	 * from a nested guest is also pointless and dangerous as we are only
> > > +	 * explicitly shadowing L1's page tables, i.e. unprotecting something
> > > +	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
> > > +	 */
> > > +	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
> >
> > Looks the mmio_info_in_cache() checking can be removed,
> > emulation should not come here with RET_PF_WRITE_PROTECTED
> > introduced, may WARN_ON_ONCE() it.
>
> Yeah, that was my instinct as well.  I kept it mostly because I liked having the
> comment, but also because I was thinking the cache could theoretically get a hit.
> But that's not true.  KVM should return RET_PF_WRITE_PROTECTED if and only if
> there is a memslot, and creating a memslot is supposed to invalidate the MMIO
> cache by virtue of changing the memslot generation.
>
> Unless someone feels strongly that the mmio_info_in_cache() call should be
> deleted entirely, I'll tack on this patch.  The cache lookup is cheap, and IMO
> it's helpful to explicitly document that it should be impossible to reach this
> point with what appears to be MMIO.
>
> ---
>  arch/x86/kvm/mmu/mmu.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 50695eb2ee22..7f3f57237f23 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5997,6 +5997,18 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	vcpu->arch.last_retry_eip = 0;
>  	vcpu->arch.last_retry_addr = 0;
>
> +	/*
> +	 * It should be impossible to reach this point with an MMIO cache hit,
> +	 * as RET_PF_WRITE_PROTECTED is returned if and only if there's a valid,
> +	 * writable memslot, and creating a memslot should invalidate the MMIO
> +	 * cache by way of changing the memslot generation.  WARN and disallow
> +	 * retry if MMIO is detect, as retrying MMIO emulation is pointless and
> +	 * could put the vCPU into an infinite loop because the processor will
> +	 * keep faulting on the non-existent MMIO address.
> +	 */
> +	if (WARN_ON_ONCE(mmio_info_in_cache(vcpu, cr2_or_gpa, direct)))
> +		return RET_PF_EMULATE;
> +

LGTM.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>  	/*
>  	 * Before emulating the instruction, check to see if the access may be
>  	 * due to L1 accessing nested NPT/EPT entries used for L2, i.e. if the
> @@ -6029,17 +6041,15 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		return RET_PF_FIXED;
>
>  	/*
> -	 * The gfn is write-protected, but if emulation fails we can still
> -	 * optimistically try to just unprotect the page and let the processor
> +	 * The gfn is write-protected, but if KVM detects its emulating an
> +	 * instruction that is unlikely to be used to modify page tables, or if
> +	 * emulation fails, KVM can try to unprotect the gfn and let the CPU
>  	 * re-execute the instruction that caused the page fault.  Do not allow
> -	 * retrying MMIO emulation, as it's not only pointless but could also
> -	 * cause us to enter an infinite loop because the processor will keep
> -	 * faulting on the non-existent MMIO address.  Retrying an instruction
> -	 * from a nested guest is also pointless and dangerous as we are only
> -	 * explicitly shadowing L1's page tables, i.e. unprotecting something
> -	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
> +	 * retrying an instruction from a nested guest as KVM is only explicitly
> +	 * shadowing L1's page tables, i.e. unprotecting something for L1 isn't
> +	 * going to magically fix whatever issue cause L2 to fail.
>  	 */
> -	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
> +	if (!is_guest_mode(vcpu))
>  		*emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
>
>  	return RET_PF_EMULATE;
>
> base-commit: 7d33880356496eb0640c6c825cc60898063c4902
> --

