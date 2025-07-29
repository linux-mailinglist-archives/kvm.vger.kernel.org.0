Return-Path: <kvm+bounces-53659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B30B15270
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 20:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4FF1160E93
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 18:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645FB29993E;
	Tue, 29 Jul 2025 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GmGwuBcw"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C627D1B3925
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753812194; cv=none; b=GzvKgLizl0XncArvjzFPuk3e6l5pzFo6fVTBOwuPnQHeshwU1OG39aWdQc/3M5JQpHGz2pVu/3aTGGqj7SUlLBN5SPsVItD2GjNwcnpNxds+4znpFlNcB3RL0jFFA8CTojA+DdGnj88jTtGyP/lvkiuApxw6h3ApoZ/7eDDDqN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753812194; c=relaxed/simple;
	bh=wiXhlXiONbtF56lrexMT0kCpgfrkgTca/ouosvLeoyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uoeQQf7fVlAAnzDSNsqMSol/SXXkRlZ6Kwx1JLZBr8jn1Knjj0UROBedDHr35bHMdgQjy0j7XTeP/ZFWEgg5u7/8Ug3sW4psEdY0I+ehLVF54GUx406k5ZHJi1z+9TfvispPhATM7I8+PgJd70EIQgWxD/ElumRBeVa0sy1SL7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GmGwuBcw; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 29 Jul 2025 11:02:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753812179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40dRevb3+VbSqC7PTRUcFwY+Be9Qk1uzZ2DAmm4HBNw=;
	b=GmGwuBcwRjVOq4k7VEaTkmwB4av+swJA7Ghf530CDjC3cjGYHKELbUrsUe5cNnN0x2nl8u
	crfORW5dyCulim6P3KozhWBhcHoTKE7BsYNr7i2eGyjitZ6rDF2Lw5vnNxVZxxelul6ht+
	VdArZIn5ZLyadHML5z3tqLhb03CgPcU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Set/unset vGIC v4 forwarding if direct IRQs
 are supported
Message-ID: <aIkMy7YPbcf0jvHq@linux.dev>
References: <20250728223710.129440-1-rananta@google.com>
 <aIjcmquPNOdE5l4K@linux.dev>
 <CAJHc60xPKgVn96azWhP1NbfKioEZj68APQPf=zKRMuHB7-goqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60xPKgVn96azWhP1NbfKioEZj68APQPf=zKRMuHB7-goqA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 29, 2025 at 09:56:12AM -0700, Raghavendra Rao Ananta wrote:
> On Tue, Jul 29, 2025 at 7:37 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Hi Raghu,
> >
> > Thanks for reporting this so quickly :)
> >
> > On Mon, Jul 28, 2025 at 10:37:10PM +0000, Raghavendra Rao Ananta wrote:
> > > diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> > > index e7e284d47a77..873a190bcff7 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-v4.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> > > @@ -433,7 +433,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
> > >       unsigned long flags;
> > >       int ret = 0;
> > >
> > > -     if (!vgic_supports_direct_msis(kvm))
> > > +     if (!vgic_supports_direct_irqs(kvm))
> > >               return 0;
> > >
> > >       /*
> > > @@ -533,7 +533,7 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
> > >       unsigned long flags;
> > >       int ret = 0;
> > >
> > > -     if (!vgic_supports_direct_msis(kvm))
> > > +     if (!vgic_supports_direct_irqs(kvm))
> > >               return 0;
> >
> > I'm not sure this is what we want, since a precondition of actually
> > doing vLPI injection is the guest having an ITS. Could you try the
> > following?
> >
> > Thanks,
> > Oliver
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > index a3ef185209e9..70d50c77e5dc 100644
> > --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > @@ -50,6 +50,14 @@ bool vgic_has_its(struct kvm *kvm)
> >
> >  bool vgic_supports_direct_msis(struct kvm *kvm)
> >  {
> > +       /*
> > +        * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
> > +        * indirectly allowing userspace to control whether or not vPEs are
> > +        * allocated for the VM.
> > +        */
> > +       if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
> > +               return false;
> > +
> >         return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
> >  }
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> > index 1384a04c0784..de1c1d3261c3 100644
> > --- a/arch/arm64/kvm/vgic/vgic.h
> > +++ b/arch/arm64/kvm/vgic/vgic.h
> > @@ -396,15 +396,7 @@ bool vgic_supports_direct_sgis(struct kvm *kvm);
> >
> >  static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
> >  {
> > -       /*
> > -        * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
> > -        * indirectly allowing userspace to control whether or not vPEs are
> > -        * allocated for the VM.
> > -        */
> > -       if (system_supports_direct_sgis())
> > -               return vgic_supports_direct_sgis(kvm);
> > -
> > -       return vgic_supports_direct_msis(kvm);
> > +       return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
> >  }
> >
> >  int vgic_v4_init(struct kvm *kvm);
> 
> Yes, the diff seems fine (tested as well). Would you be pushing a v2
> or do you want me to (on your behalf)?

Go ahead and respin this diff, thanks!

Oliver

