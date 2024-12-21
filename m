Return-Path: <kvm+bounces-34285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DA499FA2B7
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 22:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7571C1659AF
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 21:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36661DB344;
	Sat, 21 Dec 2024 21:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EknnvT+C"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348CE1714BF
	for <kvm@vger.kernel.org>; Sat, 21 Dec 2024 21:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734818330; cv=none; b=M90baoYFlPmV9+k0bdOlfDQ8OfDGLNyR2juZbK6XPXxW4I/zQpQQ+O1USvaMT3Tl+hiCTXSUfVNhwZ9Ga029hw/iGKzPb9t5zJqkWZrRR/1N8WlAyI+RmObV1SkBOJxctb2Azw+9Iu++EwhWgcIAl1EMpAr36R6Zz/sE7I3qi3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734818330; c=relaxed/simple;
	bh=YmqEabFpC/1TJIUM0H58+TKJqMOxL0YYqTaF+I7Yf14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DEV9q54DN06vB2sk/OUjWIXB4Q3wmZFBQcBDkaBQs8/anayxcHR5gZyxYUMwN0af6FQrU0oby2gMAognc2eAQa0bfZ6IL7h3zkKIU1bmMdXzSgSvzz5KBlgpfni/fcFCu8pc3hwEJ2bLHuQ5yeC83wJaAgegs91Z97abGoJICl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EknnvT+C; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 21 Dec 2024 13:58:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734818325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UIxrn6gDBkTgraPiBRw+gNRB2bS9Ks0FdtrVzsG+Kzg=;
	b=EknnvT+CTw9gKiB+Xw7ZwYqNKELcHsd1ZsrQW01NthyXKt6fZ8ZuruypV3qFto2Yo3HWBF
	x/2xL5NOOEIZ0/dOeExugYmjUfks51yPerp3hxDq3lbLaV5HjdeRZd/9nQSTYwnB/y5cVA
	tTn4uvrsgtx/rfcl0q+YMkhERjk6BDI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v2 01/12] KVM: arm64: nv: Add handling of EL2-specific
 timer registers
Message-ID: <Z2c6DJYW1_sSbFIw@linux.dev>
References: <20241217142321.763801-1-maz@kernel.org>
 <20241217142321.763801-2-maz@kernel.org>
 <Z2Yb8BWnqpt441V-@linux.dev>
 <874j2xs6hz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874j2xs6hz.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Dec 21, 2024 at 09:57:44AM +0000, Marc Zyngier wrote:
> On Sat, 21 Dec 2024 01:38:28 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Tue, Dec 17, 2024 at 02:23:09PM +0000, Marc Zyngier wrote:
> > > @@ -3879,9 +4020,11 @@ static const struct sys_reg_desc cp15_64_regs[] = {
> > >  	{ SYS_DESC(SYS_AARCH32_CNTPCT),	      access_arch_timer },
> > >  	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR1_EL1 },
> > >  	{ Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */
> > > +	{ SYS_DESC(SYS_AARCH32_CNTVCT),	      access_arch_timer },
> > >  	{ Op1( 2), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI0R */
> > >  	{ SYS_DESC(SYS_AARCH32_CNTP_CVAL),    access_arch_timer },
> > >  	{ SYS_DESC(SYS_AARCH32_CNTPCTSS),     access_arch_timer },
> > > +	{ SYS_DESC(SYS_AARCH32_CNTVCTSS),     access_arch_timer },
> > >  };
> > 
> > Huh. You know, I had always thought we hid 32-bit EL0 from nested
> > guests, but I now realize that isn't the case. Of course, we don't have
> > the necessary trap reflection for exits that came out of a 32-bit EL0,
> > nor should we bother.
> > 
> > Of the 4 NV2 implementations I'm aware of (Neoverse-V1, Neoverse-V2,
> > AmpereOne, M2) only Neoverse-V1 supports 32-bit userspace. And even
> > then, a lot of deployments of V1 have a broken NV2 implementation.
> > 
> > What do you think about advertising a 64-bit only EL0 for nested VMs?
> 
> I'm completely OK with that.
> 
> Actually, we already nuke the guest if exiting from 32bit context, no
> matter the EL (vcpu_mode_is_bad_32bit() is where this happens).  But
> we're missing the ID_AA64PFR0_EL1.EL0 sanitising, which is a bug. I'll
> send a patch shortly.
> 
> Now, for this particular patch, I still think we should gracefully
> handle access to the EL1 timer from a 32bit capable, non-NV guest.
> Just in case we end-up with a CPU with a broken CNTVOFF_EL2 *and*
> 32bit capability.
> 
> In the end, it doesn't cost us much to support this case, and it helps
> that we can verify that we handle all registers without exception.
> 
> Thoughts?

Absolutely. The only reason I made the comment is because the 32-bit
changes had nudged me into thinking about it. Happy with the patch as
is.

-- 
Thanks,
Oliver

