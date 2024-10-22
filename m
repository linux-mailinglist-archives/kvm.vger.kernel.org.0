Return-Path: <kvm+bounces-29429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A60A9AB66B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 21:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0730DB21E7E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 19:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85DEE1C9ED3;
	Tue, 22 Oct 2024 19:08:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015A712F5B3
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 19:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729624109; cv=none; b=EUoawUM2xOP5YhD7esMDvN2k0A2nWNxiCKw70Yonems6UA7zKUdZ2EjK+QKZ5uBUWxvdhdSM+6c4m0ZBaSjShoqlHuc5FRTh8osrCCJmEaS3dy6mzP8rTurP2pdgHfIY5Uwd0wEplNPieOhY3Py1830GESkgJjYL3WJdyqYHCQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729624109; c=relaxed/simple;
	bh=eMBwch2nVAK+XZocRXcJXVaq8kzvBQYf1aFWKKkevGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4ASWpcBX84Es/tKpPP7Yi1OeW9s100vj54yiemVHE0diwnJOb752ylKto278SNO4pQXlbD7sMNyDTKnRsLLp0k8pes1A+x3b2FhsOniZYySL1HgTcD54rOXf6kTKYjs+7uUIQ1VuNQ26FnKYXNBZPe3/Ab+g83MPbSdoq24KyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=mias.mediconcil.de; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mias.mediconcil.de
Received: from bernie by mediconcil.de with local (Exim 4.96)
	(envelope-from <bernie@mias.mediconcil.de>)
	id 1t3KEf-004MoW-0B;
	Tue, 22 Oct 2024 21:08:05 +0200
Date: Tue, 22 Oct 2024 21:08:05 +0200
From: Bernhard Kauer <bk@alpico.io>
To: Sean Christopherson <seanjc@google.com>
Cc: Bernhard Kauer <bk@alpico.io>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: drop the kvm_has_noapic_vcpu optimization
Message-ID: <Zxf4FeRtA3xzdZG3@mias.mediconcil.de>
References: <20241018100919.33814-1-bk@alpico.io>
 <Zxfhy9uifey4wShq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zxfhy9uifey4wShq@google.com>

On Tue, Oct 22, 2024 at 10:32:59AM -0700, Sean Christopherson wrote:
> On Fri, Oct 18, 2024, Bernhard Kauer wrote:
> > It used a static key to avoid loading the lapic pointer from
> > the vcpu->arch structure.  However, in the common case the load
> > is from a hot cacheline and the CPU should be able to perfectly
> > predict it. Thus there is no upside of this premature optimization.
> 
> Do you happen to have performance numbers? 

Sure.  I have some preliminary numbers as I'm still optimizing the
round-trip time for tiny virtual machines.

A hello-world micro benchmark on my AMD 6850U needs at least 331us.  With
the static keys it requires 579us.  That is a 75% increase.

Take the absolute values with a grain of salt as not all of my patches might
be applicable to the general case.

For the other side I don't have a relevant benchmark yet.  But I doubt you
would see anything even with a very high IRQ rate.


> > The downside is that code patching including an IPI to all CPUs
> > is required whenever the first VM without an lapic is created or
> > the last is destroyed.
> 
> In practice, this almost never happens though.  Do you have a use case for
> creating VMs without in-kernel local APICs?

I switched from "full irqchip" to "no irqchip" due to a significant
performance gain and the simplicity it promised.

I might have to go to "split irqchip" mode for performance reasons but I
didn't had time to look into it yet.

So in the end I assume it will be a trade-off: Do I want to rely on these
3000 lines of kernel code to gain an X% performance increase, or not?


