Return-Path: <kvm+bounces-30247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD2D49B847C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:40:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A198B28389F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB7D1CC17C;
	Thu, 31 Oct 2024 20:39:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602AD199FAF
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 20:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730407194; cv=none; b=cwuSc/dPhrWr9mzzdf4y/YFzMfOTQIRHc6mS52vSA1xf5r1XBag6YXlpZ1a7XWBPFGdTL8Rgw96zn98BNu+DowvVOZs5Y8BoT4vpuCTL10dOZ8MNzdFdvK9HJumhyMUlZcLwNNiYKLmsKgATkN8zolc82E6LZcS2uCN+etbWmSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730407194; c=relaxed/simple;
	bh=TvR5BYmZF8Ioi3rUdxIKWoxJqY1greZXSh4RxUX61ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NwsucIHrBF2LZm2jYKefbeA+AniIQdwW4185qYcWM3wtMWcHGtAvs1OKR4x45yyonlhxEsp3KcM38/dJVKRQrJFE7+P3lpopOcF9dQ8F3zWJWQa+8NA6Mgr1jLefg7RnFetpSEWC5F/TQnEknNVryYlMNpVXTH36idSIfKU78E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=mias.mediconcil.de; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mias.mediconcil.de
Received: from bernie by mediconcil.de with local (Exim 4.96)
	(envelope-from <bernie@mias.mediconcil.de>)
	id 1t6bT7-00ENqN-17;
	Thu, 31 Oct 2024 21:08:33 +0100
Date: Thu, 31 Oct 2024 21:08:33 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Sean Christopherson <seanjc@google.com>
Cc: Bernhard Kauer <bk@alpico.io>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: drop the kvm_has_noapic_vcpu optimization
Message-ID: <ZyPjwW55n0JHg0pu@mias.mediconcil.de>
References: <20241018100919.33814-1-bk@alpico.io>
 <Zxfhy9uifey4wShq@google.com>
 <Zxf4FeRtA3xzdZG3@mias.mediconcil.de>
 <ZyOvPYHrpgPbxUtX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyOvPYHrpgPbxUtX@google.com>

On Thu, Oct 31, 2024 at 09:24:29AM -0700, Sean Christopherson wrote:
> On Tue, Oct 22, 2024, Bernhard Kauer wrote:
> > > > It used a static key to avoid loading the lapic pointer from
> > > > the vcpu->arch structure.  However, in the common case the load
> > > > is from a hot cacheline and the CPU should be able to perfectly
> > > > predict it. Thus there is no upside of this premature optimization.
> > >
> > > Do you happen to have performance numbers?
> >
> > Sure.  I have some preliminary numbers as I'm still optimizing the
> > round-trip time for tiny virtual machines.
> >
> > A hello-world micro benchmark on my AMD 6850U needs at least 331us.  With
> > the static keys it requires 579us.  That is a 75% increase.
>
> For the first VM only though, correct?

That is right. If I keep one VM in the background the overhead is not
measureable anymore.


> > Take the absolute values with a grain of salt as not all of my patches might
> > be applicable to the general case.
> >
> > For the other side I don't have a relevant benchmark yet.  But I doubt you
> > would see anything even with a very high IRQ rate.
> >
> >
> > > > The downside is that code patching including an IPI to all CPUs
> > > > is required whenever the first VM without an lapic is created or
> > > > the last is destroyed.
> > >
> > > In practice, this almost never happens though.  Do you have a use case for
> > > creating VMs without in-kernel local APICs?
> >
> > I switched from "full irqchip" to "no irqchip" due to a significant
> > performance gain
>
> Signifcant performance gain for what path?  I'm genuinely curious.

I have this really slow PREEMPT_RT kernel (Debian 6.11.4-rt-amd64).
The hello-world benchmark takes on average 100ms.  With IRQCHIP it goes
up to 220ms.  An strace gives 83ms for the extra ioctl:

        ioctl(4, KVM_CREATE_IRQCHIP, 0)         = 0 <0.083242>

My current theory is that RCU takes ages on this kernel.  And creating an
IOAPIC uses SRCU to synchronize the bus array...

However, in my latest benchmark runs the overhead for IRQCHIP is down to 15
microseconds.  So no big deal anymore.


> Unless your VM doesn't need a timer and doesn't need interrupts of
> any kind, emulating the local APIC in userspace is going to be much
> less performant.


Do you have any performance numbers?

