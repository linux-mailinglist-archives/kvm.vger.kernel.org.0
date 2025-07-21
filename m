Return-Path: <kvm+bounces-52957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B41B0BE0F
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 09:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4FE2188E683
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 07:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F3A27F4CE;
	Mon, 21 Jul 2025 07:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KTpHwn2D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB91DF49
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 07:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753084157; cv=none; b=FqAQtzdk4h//TCtrqT7U1UuCy2IPnhShx0LnE9Wen2Mt0qX7pnsMf4X8jA/gV5O+gnU0P4GeEKY8RxbRr1olD9H6ZYpA5swnWYKhIsmSK2Js32OhWAD7uAd4Vf/HavCp8Nd/sop1axAg3Zn5V5MVrJIRTnluy0ywt0rEJ7gl6fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753084157; c=relaxed/simple;
	bh=VOtCbcVt0gGNHLvbj63WBHKbZ6X+uMuPLPPZJmm635U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E6WuRFc9IInluYMI0gv7aAMdCyNnt3QkdITUcrrVI+qsKK9d8Zjnrh2N0Qlb5fXl/MlcY5XDGnNsnF6dZtZOOjrj2lBw0FaEW7Ic6UeOWm5TC9pBpKya9QUu5Ekp8AOsV53U30nrb/5yH3pcwULMBdyu4vD4bXayjScFHlXi+Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KTpHwn2D; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a4ef2c2ef3so3001618f8f.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 00:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753084154; x=1753688954; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kKg1W6M4USiwNTbJCkdBvx9IOQ14GKTE6DwJxmpiYlk=;
        b=KTpHwn2D1V731ECf6Svpzs8L3US8IIPvQM7jN5YHCcM4xOnSonU97lkyz66kQ04K+q
         EZYGMtF3wLuOS/r20L05itNE3IiKgPd3jw0rFCMbqeJTDe8YPaG0i9lfMH0LcGg+d4Vr
         fdSKAECmCx7xu8EUu7cNG5xVK+IyO8X+tzMhrfDId9yqqee0Z2O+uSFxWdVhOgZgnf1l
         T9Q/VeHzUvlpk7TMdBDfKzo6BsQI+kuZMR4An5hLjoNbv8hY61hH/yyL01wzxmRZnF18
         Ni+Ob8IkZmBIOiQUZ54HhaizjqO4kJ8M7GqjHQdd011pQIiFfDkuUZshJakUpoFJZxtO
         joSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753084154; x=1753688954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKg1W6M4USiwNTbJCkdBvx9IOQ14GKTE6DwJxmpiYlk=;
        b=qsyVBgwgPIYmDCoHvC+ROt1kKVEilBJO0dUmEObUD7FX4YlLj6ZH2ctAFjfjV0cRl2
         LQyZp4N6pd1/jX6Uld2gFi27bpwaQeEZZQ6GbTvxetFvLYuMOUdMmzNC2VF4b1F+I7O8
         YNwRX5bx+Dfd4R+pTpnRjnnPJJS0xSfnv3ca34ya6SWAkRU1wacT5S7P90RwAVay0qBE
         sf27LUyvnVfqHo4Sdeh2XypebK86Ijo7vlDsT4led2yK5PLP+6/GnMTxGGPn0A6OQuO1
         1cXECGkJBCOrDdggOvL5/OCB4b7zoIg1xZQVwpi+cUixUZVm9uwaM5sfQIx6jpEu4OqM
         6lYg==
X-Forwarded-Encrypted: i=1; AJvYcCUx/a0NRY3TYsoK9TTNXPJ1i8hLLVAQW22ecvJ5VpAz6oaDJHc6lnRsm7IFWTMAkVboG9g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1P3VKs0Npus6wVx2MmyMKthBmUUd5RDquGX/HQkSUA6lximqw
	yQJiZbQhiNk26pTF36J3jZ/3U/bOan9kbh0LgrTovYNZWlf07RmZvoL3S7syvLbQUQ==
X-Gm-Gg: ASbGnctYhrxH8nLBqrvNeHZ+BqF/HFQ8pBtLIdZyV+Bkdnw7A0v/3tMpLcekR3XwfK/
	g2ONtsUFh+7IHnibRyVWYmIU1nEF+QGEVB3ctBYPIB3pn2C+O3a/2aTEHTvJuf/cTl6U10X/WCZ
	34ReYlRwi8YVQO+2t2+KtQlLTdK8GwZSAJWejXOj7XG5HFe+8P7kmcO79eqcdCeQmzvtAZ386+y
	cidKi/CULihkPiH+zWxANcg4c4Rx2TDoesuEvjcP8zGoEWvFoKiEpmmpNCq+OByIlrk7o5wXdET
	xeMV5oLUHH5+9l9y9VFQ7Ry46GR7QEw86ByKceHGd2vlAs4MlPEQyyXuC+krHY8WSNf922PwbHG
	BHFxNKZlKQ4VH/ShUQ8AhEQJLBhtiDv0wSmjXivkdExqr53WgXXJQX6HI+tFiwh+lot74IA==
X-Google-Smtp-Source: AGHT+IHLCPN08G76cpeAjmGFh2SwOYUq7PKTpI10Q0DJaIHMug/5GI7V+ike5MmSquAW5czvaJ/6xw==
X-Received: by 2002:a05:6000:2902:b0:3a4:f038:af74 with SMTP id ffacd0b85a97d-3b60e518418mr15229224f8f.51.1753084153650;
        Mon, 21 Jul 2025 00:49:13 -0700 (PDT)
Received: from google.com (120.142.205.35.bc.googleusercontent.com. [35.205.142.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4894asm9640037f8f.49.2025.07.21.00.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 00:49:13 -0700 (PDT)
Date: Mon, 21 Jul 2025 07:49:10 +0000
From: Keir Fraser <keirf@google.com>
To: Yao Yuan <yaoyuan0329os@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
Message-ID: <aH3w9t78dvxsDjhV@google.com>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-3-keirf@google.com>
 <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
 <aHphgd0fOjHXjPCI@google.com>
 <5zpxxmymnyzncdnewdonnglvmvbtggjyxyqvkf6yars2bbyr4b@gottasrtoq2s>
 <aHtQG_k_1q3862s3@google.com>
 <4i65mgp4rtfox2ttchamijofcmwjtd6sefmuhdkfdrjwaznhoc@2uhcfv2ziegj>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4i65mgp4rtfox2ttchamijofcmwjtd6sefmuhdkfdrjwaznhoc@2uhcfv2ziegj>

On Sun, Jul 20, 2025 at 08:08:30AM +0800, Yao Yuan wrote:
> On Sat, Jul 19, 2025 at 07:58:19AM +0000, Keir Fraser wrote:
> > On Sat, Jul 19, 2025 at 10:15:56AM +0800, Yao Yuan wrote:
> > > On Fri, Jul 18, 2025 at 08:00:17AM -0700, Sean Christopherson wrote:
> > > > On Thu, Jul 17, 2025, Yao Yuan wrote:
> > > > > On Wed, Jul 16, 2025 at 11:07:35AM +0800, Keir Fraser wrote:
> > > > > > In preparation to remove synchronize_srcu() from MMIO registration,
> > > > > > remove the distributor's dependency on this implicit barrier by
> > > > > > direct acquire-release synchronization on the flag write and its
> > > > > > lock-free check.
> > > > > >
> > > > > > Signed-off-by: Keir Fraser <keirf@google.com>
> > > > > > ---
> > > > > >  arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
> > > > > >  1 file changed, 2 insertions(+), 9 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > > > > index 502b65049703..bc83672e461b 100644
> > > > > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > > > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > > > > @@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > > > > >  	gpa_t dist_base;
> > > > > >  	int ret = 0;
> > > > > >
> > > > > > -	if (likely(dist->ready))
> > > > > > +	if (likely(smp_load_acquire(&dist->ready)))
> > > > > >  		return 0;
> > > > > >
> > > > > >  	mutex_lock(&kvm->slots_lock);
> > > > > > @@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > > > > >  		goto out_slots;
> > > > > >  	}
> > > > > >
> > > > > > -	/*
> > > > > > -	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
> > > > > > -	 * registration before returning through synchronize_srcu(), which also
> > > > > > -	 * implies a full memory barrier. As such, marking the distributor as
> > > > > > -	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
> > > > > > -	 * a completely configured distributor.
> > > > > > -	 */
> > > > > > -	dist->ready = true;
> > > > > > +	smp_store_release(&dist->ready, true);
> > > > >
> > > > > No need the store-release and load-acquire for replacing
> > > > > synchronize_srcu_expedited() w/ call_srcu() IIUC:
> > > >
> > > > This isn't about using call_srcu(), because it's not actually about kvm->buses.
> > > > This code is concerned with ensuring that all stores to kvm->arch.vgic are ordered
> > > > before the store to set kvm->arch.vgic.ready, so that vCPUs never see "ready==true"
> > > > with a half-baked distributor.
> > > >
> > > > In the current code, kvm_vgic_map_resources() relies on the synchronize_srcu() in
> > > > kvm_io_bus_register_dev() to provide the ordering guarantees.  Switching to
> > > > smp_store_release() + smp_load_acquire() removes the dependency on the
> > > > synchronize_srcu() so that the synchronize_srcu() call can be safely removed.
> > >
> > > Yes, I understand this and agree with your point.
> > >
> > > Just for discusstion: I thought it should also work even w/o
> > > introduce the load acqure + store release after switch to
> > > call_srcu(): The smp_mb() in call_srcu() order the all store
> > > to kvm->arch.vgic before store kvm->arch.vgic.ready in
> > > current implementation.
> >
> > The load-acquire would still be required, to ensure that accesses to
> > kvm->arch.vgic do not get reordered earlier than the lock-free check
> > of kvm->arch.vgic.ready. Otherwise that CPU could see that the vgic is
> > initialised, but then use speculated reads of uninitialised vgic state.
> >
> 
> Thanks for your explanation.
> 
> I see. But there's "mutex_lock(&kvm->slot_lock);" before later
> acccessing to the kvm->arch.vgic, so I think the order can be
> guaranteed. Of cause as you said a explicitly acquire-load +
> store-release is better than before implicitly implementation.

If vgic_dist::ready is observed true by the lock-free read (the one
which is turned into load-acquire by this patch) then the function
immediately returns with no mutex_lock() executed. It is reads of
vgic_dist *after* return from kvm_vgic_map_resources() that you have
to worry about, and which require load-acquire semantics.

> 
> > > >

