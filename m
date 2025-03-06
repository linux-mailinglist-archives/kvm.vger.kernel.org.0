Return-Path: <kvm+bounces-40249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F851A54FAA
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:53:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48F1F3B2C02
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 15:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F9F211278;
	Thu,  6 Mar 2025 15:52:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4665120D516
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 15:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741276357; cv=none; b=dkiLuU3ByaGoEKZSJGR1heV5pRgn0+e7v08DviDgbaMTITFYF0WexH1CAcw3N01ukHj5beG5nXWuvn64FDZb9a5lZFvvFJz7m2q4Nzl6wHpYAitR4CbO6VnhBzVI99r4C1wk1CK2uG2oIsL7+El8B0wScMH0Y+m6R1lbi8gUAAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741276357; c=relaxed/simple;
	bh=+sWXptzDc1NDYG+YfJbpFHs9I/j/rOKy2TkxpVnN5Y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=an83zn9RVUxDpbKniVR2mYw3reOlHr8Io5xqDaN0R6MUf8478uuIFpitF4gIlow/3Gn6gf7PUkEnDqyU68mTaxllbo/LXp4kNI5wGn3CDIdNvix3kx6OCZGHp4mYT1idP3cTBy8cv3HlDkOvB+PqN4dCnBwXcjFxFRBMglKURLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5788F1007;
	Thu,  6 Mar 2025 07:52:48 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B3983F673;
	Thu,  6 Mar 2025 07:52:34 -0800 (PST)
Date: Thu, 6 Mar 2025 15:52:31 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, drjones@redhat.com, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 1/7] arm64: drop to EL1 if booted at EL2
Message-ID: <Z8nEv17KEXFCHoAi@raptor>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
 <20250220141354.2565567-2-joey.gouly@arm.com>
 <Z8CYeyKrFoglWWSp@raptor>
 <20250304170213.GB1553498@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304170213.GB1553498@e124191.cambridge.arm.com>

Hi Joey,

On Tue, Mar 04, 2025 at 05:02:13PM +0000, Joey Gouly wrote:
> Hi,
> 
> On Thu, Feb 27, 2025 at 04:53:15PM +0000, Alexandru Elisei wrote:
> > Hi Joey,
> > 
> > On Thu, Feb 20, 2025 at 02:13:48PM +0000, Joey Gouly wrote:
> > > EL2 is not currently supported, drop to EL1 to conitnue booting.
> > > 
> > > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > > ---
> > >  arm/cstart64.S | 27 +++++++++++++++++++++++++--
> > >  1 file changed, 25 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > > index b480a552..3a305ad0 100644
> > > --- a/arm/cstart64.S
> > > +++ b/arm/cstart64.S
> > > @@ -57,14 +57,25 @@ start:
> > >  	add     x6, x6, :lo12:reloc_end
> > >  1:
> > >  	cmp	x5, x6
> > > -	b.hs	1f
> > > +	b.hs	reloc_done
> > >  	ldr	x7, [x5]			// r_offset
> > >  	ldr	x8, [x5, #16]			// r_addend
> > >  	add	x8, x8, x4			// val = base + r_addend
> > >  	str	x8, [x4, x7]			// base[r_offset] = val
> > >  	add	x5, x5, #24
> > >  	b	1b
> > > -
> > > +reloc_done:
> > > +	mrs	x4, CurrentEL
> > > +	cmp	x4, CurrentEL_EL2
> > > +	b.ne	1f
> > > +drop_to_el1:
> > > +	mov	x4, 4
> > > +	msr	spsr_el2, x4
> > > +	adrp	x4, 1f
> > > +	add	x4, x4, :lo12:1f
> > > +	msr	elr_el2, x4
> > 
> > I'm going to assume this works because KVM is nice enough to initialise the
> > EL2 registers that affect execution at EL1 to some sane defaults. Is that
> > something that can be relied on going forward?
> 
> I was just trying to keep the changes minimal.

Sure, I appreciate that, and the series looks nice and small because of it, but
in the absence of an ABI from KVM, the reset values for the EL2 registers that
affect execution at EL1 are just an implemention choice that KVM made at a
particular point in time. I don't think robust software should rely on it.

> 
> > 
> > What about UEFI?
> 
> Haven't tested it yet.

Ok, I saw you made changes to the UEFI code so I had assumed to tested them.

> 
> > 
> > I was expecting some kind of initialization of the registers that affect
> > EL1.
> 
> I'll look into it.

Great, thanks. I think arch/arm64/incluse/asm/el2_setup.h might be a useful
starting point. You can put the initialization code in a macro and use it
for the primary and secondaries CPUs, like Marc suggested.

Thanks,
Alex

