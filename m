Return-Path: <kvm+bounces-18803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 174418FBAE7
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 19:49:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C695B288214
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 17:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4520214A0A3;
	Tue,  4 Jun 2024 17:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sB0w9A9c"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9150F18635
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 17:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717523378; cv=none; b=WO84xjfRJmue4jZflr3q0NlmQDLedw1gFHyloH+icLF3E81JI+ILIh7aDZUx9SbaYe28D1pF6oWo5uBja44jZBn4yCZQtOz3iMNVr5Vk8e4RbJQ9te6UXmyQIqg6MgGomAJmUbXq7D7VwY6RvZt8hqtBf1EqAGDE0uJz7PxjYqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717523378; c=relaxed/simple;
	bh=If0E+en4+U0bT1yYftj/63Mw0JZ9S2/fu7XpDdTdYQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lz/kLWphtoEBqqAJ31aHeMDKrjzcWgQ/7AAQ3rj2ceHNf1ltg3pUVLB0LqDB53MPEnBbtO1UB5ISvmvHQpp3DCbSD6bOYtdSz+Zz8sTEvxcz6JpvmYIkcTtZFu9ZhXMKL/v07HTsrppDW25WEY4D4//u11U7AqUllVq9wh656DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sB0w9A9c; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717523374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=etKMv0XSdM2kOYDVKjTa73bSuavz0OyzOh2yvMYeyrQ=;
	b=sB0w9A9cT/zYlL4Ri39dhj7yQndj7CmnhiPjzfwalNOLzIf8R/VkvI75BRAS6dmU6KXjl2
	2UmtCLUlZ+ul5TH9Xfb30WSFkWP2uMTOrIrqMQMQf4fH/NHuZ/zx1L3CuUdZEPW+S/Z1Jc
	aj3m5ZQwV9JAcq2jOsBjQedZKI4DezA=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: christoffer.dall@arm.com
X-Envelope-To: gankulkarni@os.amperecomputing.com
Date: Tue, 4 Jun 2024 17:49:29 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 13/16] KVM: arm64: nv: Invalidate TLBs based on shadow
 S2 TTL-like information
Message-ID: <Zl9TqVRqNo-Cm90N@linux.dev>
References: <20240529145628.3272630-1-maz@kernel.org>
 <20240529145628.3272630-14-maz@kernel.org>
 <Zl4NScV0E_YV7GR2@linux.dev>
 <87frtt2l56.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87frtt2l56.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 04, 2024 at 08:59:49AM +0100, Marc Zyngier wrote:
> On Mon, 03 Jun 2024 19:36:57 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Wed, May 29, 2024 at 03:56:25PM +0100, Marc Zyngier wrote:
> 
> [...]
> 
> > > +/*
> > > + * Compute the equivalent of the TTL field by parsing the shadow PT.  The
> > > + * granule size is extracted from the cached VTCR_EL2.TG0 while the level is
> > > + * retrieved from first entry carrying the level as a tag.
> > > + */
> > > +static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
> > > +{
> > 
> > Can you add a lockdep assertion that the MMU lock is held for write
> > here? At least for me this is far enough away from the 'real' page table
> > walk that it wasn't clear what locks were held at this point.
> 
> Sure thing.
> 
> > 
> > > +	u64 tmp, sz = 0, vtcr = mmu->tlb_vtcr;
> > > +	kvm_pte_t pte;
> > > +	u8 ttl, level;
> > > +
> > > +	switch (vtcr & VTCR_EL2_TG0_MASK) {
> > > +	case VTCR_EL2_TG0_4K:
> > > +		ttl = (TLBI_TTL_TG_4K << 2);
> > > +		break;
> > > +	case VTCR_EL2_TG0_16K:
> > > +		ttl = (TLBI_TTL_TG_16K << 2);
> > > +		break;
> > > +	case VTCR_EL2_TG0_64K:
> > > +	default:	    /* IMPDEF: treat any other value as 64k */
> > > +		ttl = (TLBI_TTL_TG_64K << 2);
> > > +		break;
> > > +	}
> > > +
> > > +	tmp = addr;
> > > +
> > > +again:
> > > +	/* Iteratively compute the block sizes for a particular granule size */
> > > +	switch (vtcr & VTCR_EL2_TG0_MASK) {
> > > +	case VTCR_EL2_TG0_4K:
> > > +		if	(sz < SZ_4K)	sz = SZ_4K;
> > > +		else if (sz < SZ_2M)	sz = SZ_2M;
> > > +		else if (sz < SZ_1G)	sz = SZ_1G;
> > > +		else			sz = 0;
> > > +		break;
> > > +	case VTCR_EL2_TG0_16K:
> > > +		if	(sz < SZ_16K)	sz = SZ_16K;
> > > +		else if (sz < SZ_32M)	sz = SZ_32M;
> > > +		else			sz = 0;
> > > +		break;
> > > +	case VTCR_EL2_TG0_64K:
> > > +	default:	    /* IMPDEF: treat any other value as 64k */
> > > +		if	(sz < SZ_64K)	sz = SZ_64K;
> > > +		else if (sz < SZ_512M)	sz = SZ_512M;
> > > +		else			sz = 0;
> > > +		break;
> > > +	}
> > > +
> > > +	if (sz == 0)
> > > +		return 0;
> > > +
> > > +	tmp &= ~(sz - 1);
> > > +	if (kvm_pgtable_get_leaf(mmu->pgt, tmp, &pte, NULL))
> > > +		goto again;
> > 
> > Assuming we're virtualizing a larger TG than what's in use at L0 this
> > may not actually find a valid leaf that exists within the span of a
> > single virtual TLB entry.
> > 
> > For example, if we're using 4K at L0 and 16K at L1, we could have:
> > 
> > 	[ ----- valid 16K entry ------- ]
> > 
> > mapped as:
> > 
> > 	[ ----- | ----- | valid | ----- ]
> > 
> > in the shadow S2. kvm_pgtable_get_leaf() will always return the first
> > splintered page, which could be invalid.
> > 
> > What I'm getting at is: should this use a bespoke table walker that
> > scans for a valid TTL in the range of [addr, addr + sz)? It may make
> > sense to back off a bit more aggressively and switch to a conservative,
> > unscoped TLBI to avoid visiting too many PTEs.
> 
> I had something along those lines at some point (circa 2019), and
> quickly dropped it as it had a horrible "look-around" behaviour,
> specially if the L1 S2 granule size is much larger than L0's (64k vs
> 4k). As you pointed out, it needs heuristics to limit the look-around,
> which I don't find very satisfying.
> 
> Which is why the current code limits the search to be in depth only,
> hoping for the head descriptor to be valid, and quickly backs off to
> do a level-0 invalidation.
> 
> My preferred option would be to allow the use of non-valid entries to
> cache the level (always using the first L0 entry that would map the L1
> descriptor), but this opens another can of worms: you could end-up
> with page table pages containing only invalid descriptors, except for
> the presence of a level annotation, which screws the refcounting. I'd
> very much like to see this rather than the look-around option.

Yeah, this seems to be a better solution, albeit more complex on the map
path. Having said that, such an improvement can obviously be layered on
top after the fact, so I don't view this as a requirement for getting
these patches merged.

> Now, it is important to consider how useful this is. I expect modern
> hypervisors to use either TTL-hinted (which we emulate even if the HW
> doesn't support it) or Range-based invalidation in the vast majority
> of the cases, so this would only help SW that hasn't got on with the
> program.

"enterprise edition" hypervisors could be an annoyance, but you do have
a good point that there are tools available to the L1 to obviate TTL
caching as a requirement for good perf.

-- 
Thanks,
Oliver

