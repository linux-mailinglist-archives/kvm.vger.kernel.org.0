Return-Path: <kvm+bounces-52942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 742ACB0AE80
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 09:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13EABAA7324
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 07:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3652343AE;
	Sat, 19 Jul 2025 07:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vODRF+kC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BE422D9EB
	for <kvm@vger.kernel.org>; Sat, 19 Jul 2025 07:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752911907; cv=none; b=Up5DWgHjGaQO6LsOTnoSA0QX1tFYu0TKaEPJN0BqrTvDOy7fOdklTfZfQwXgBnViBNSfOATSau0ub7KipDAUhMPGi5BrKJXiEZs/23l6dMPp1BjJveO0aZNkFIbpRgIC6gSqZUxM0iy0pLJ/5pqHciNSwoerS8f5VE35cGYuI/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752911907; c=relaxed/simple;
	bh=tJ1uWbUjnxLlGM3QoOhkMA4nYAs8lfUm3ulVKnjtvSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=In1zsrOL6Ok8U8Y0cfxTrrtIHvh9c99sX40qDJS5hryEV3fk9TkIQ82+ICRlYgK1p6zCY03DlWd7m0o1bnUhxiaWKkHYKt5LwmkZXiv232Zs/fae90JdtE3XGJPQ3JXSgnKsBHzPJV3WZSZ7MJiUePzdZiU+2J3YFaq2HEsxaJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vODRF+kC; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a548a73ff2so2567342f8f.0
        for <kvm@vger.kernel.org>; Sat, 19 Jul 2025 00:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752911904; x=1753516704; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TfRByUZViUlkhtvwbgJ9kqHK2zRV37bvsO8dM/mnyeg=;
        b=vODRF+kC95FT79zjGsl+L9B3K1IsbTrfSFnd7wsYCj/GmlykdgMt4NaRn3GYHZtrRr
         pskjfi6iMiM4SZKN6xu7/4E4L8Mf08++LLxiZv3dMYrY+GGNClqi4kfp7VbKGKLyK+9F
         NMNR73ak2Ui35J5ouqolASqhz6CQxK2lAyzkYKq25vdNSO6AZASgG8/0OZ3XYzDoIjV9
         GOaPdMvOhsalcO17ySnZXpwAbtNDCzR8T+Ezw+Yry+42pjftTAdM331+GXnBfjVgFqXB
         NGQyxWtAbgmnt18+m/VR4Vd4dePGXURR9gtCBF2381pKASSgUWS8RrgXjmxOpWjrMwsy
         QsSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752911904; x=1753516704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfRByUZViUlkhtvwbgJ9kqHK2zRV37bvsO8dM/mnyeg=;
        b=b+bwgobzInA4XqOMWY35hxp3tE03U/igzjshTzYciwfSvGEICcIEzdF0Cw12gWCO8x
         0w/F7nkH9XyH4Qdd+/khtjd6Oll2BRJK0cFTjr/CmVHAcZ1W6rEIVEsLpEI2SuFwWnLj
         ok80i5tlz/muNFpGeHz+mA0/t5xvC99eEwpDxD6VwTgTrU95h8Hl0P+WXm2aGgAfav8M
         PwoP3bwOap2MBzkGvueS77Gy5FbzhlWN4McdFGuS0s1WEyQ2JpvZoCpReX8VArmizqUz
         ZGTevB18bp/AgeMoVMjzbwUx4IVEVRL+6ByVSCP8yNiXWkQRJx72MJcOKwZISrp08Mb2
         Lb/g==
X-Forwarded-Encrypted: i=1; AJvYcCVUhtt5P4mBHCJ9sLcPqIG07QR3fK07baiDWkfeyvHVbeFu858wMs4XvzF+UvvKsJhooB0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yysm40TFQo7+/GlNdMoYbmcOLoe/rbBd9LrFuGbyDQCLukOpb5m
	FuJ/vcGJkDIuaF0bQSHLWfDaCgTJ2vLoF3ysy5G8Lnvb6QSXqoV5V5lwdcc4XCCTvg==
X-Gm-Gg: ASbGncve2fVmnKInk2I4YY6v9LLkf9j9nbiDctc99wXuVIkmMQFywqJ42GadCn9KCOU
	LNvlzxfGIHf7MH9orLcIm59Z7XfvS/4UA6UUxdIOw4lcUMte8ctwfuU+ppa72USoEWV1Yq+PDt9
	jNW52IvoilaeVxfibiFnmHQdeHvc7tzT1KRuzikggw7tAAdVRFFTXY9KkbGsC1eQcTDaZn7iKvp
	tq2OGDRDPlT0VmqhuB4q/nufRRbzUdXQ4z7ggtFLpwHI8lybQ1HlpRejsWokPsXw4j5j1rRGACJ
	EHTBaFIqqz6H4sHTuL2wsavQitLJlJEYgrfa4oYe5sU6mFT4npo3ysg6f0LNue4Ushsb5cREN+z
	IqdbB0AUjPCCUHLfBrpuvIAVV3ZNg/a7vYzLp54oHOFvLOqzV1u3wNiPlG5CXCJbWE392Vg==
X-Google-Smtp-Source: AGHT+IH9Zj8Sie+1djBoT8jRSDy8Q+NDwYSbOAjVh0kWnwssstjjIHWaSUiNz3Ecv1vUll7ozzg2eA==
X-Received: by 2002:a05:6000:42c6:b0:3a3:7115:5e7a with SMTP id ffacd0b85a97d-3b60dd7b0dbmr8359452f8f.42.1752911903972;
        Sat, 19 Jul 2025 00:58:23 -0700 (PDT)
Received: from google.com (120.142.205.35.bc.googleusercontent.com. [35.205.142.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca2b803sm3923821f8f.19.2025.07.19.00.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jul 2025 00:58:23 -0700 (PDT)
Date: Sat, 19 Jul 2025 07:58:19 +0000
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
Message-ID: <aHtQG_k_1q3862s3@google.com>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-3-keirf@google.com>
 <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
 <aHphgd0fOjHXjPCI@google.com>
 <5zpxxmymnyzncdnewdonnglvmvbtggjyxyqvkf6yars2bbyr4b@gottasrtoq2s>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5zpxxmymnyzncdnewdonnglvmvbtggjyxyqvkf6yars2bbyr4b@gottasrtoq2s>

On Sat, Jul 19, 2025 at 10:15:56AM +0800, Yao Yuan wrote:
> On Fri, Jul 18, 2025 at 08:00:17AM -0700, Sean Christopherson wrote:
> > On Thu, Jul 17, 2025, Yao Yuan wrote:
> > > On Wed, Jul 16, 2025 at 11:07:35AM +0800, Keir Fraser wrote:
> > > > In preparation to remove synchronize_srcu() from MMIO registration,
> > > > remove the distributor's dependency on this implicit barrier by
> > > > direct acquire-release synchronization on the flag write and its
> > > > lock-free check.
> > > >
> > > > Signed-off-by: Keir Fraser <keirf@google.com>
> > > > ---
> > > >  arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
> > > >  1 file changed, 2 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > > index 502b65049703..bc83672e461b 100644
> > > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > > @@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > > >  	gpa_t dist_base;
> > > >  	int ret = 0;
> > > >
> > > > -	if (likely(dist->ready))
> > > > +	if (likely(smp_load_acquire(&dist->ready)))
> > > >  		return 0;
> > > >
> > > >  	mutex_lock(&kvm->slots_lock);
> > > > @@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > > >  		goto out_slots;
> > > >  	}
> > > >
> > > > -	/*
> > > > -	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
> > > > -	 * registration before returning through synchronize_srcu(), which also
> > > > -	 * implies a full memory barrier. As such, marking the distributor as
> > > > -	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
> > > > -	 * a completely configured distributor.
> > > > -	 */
> > > > -	dist->ready = true;
> > > > +	smp_store_release(&dist->ready, true);
> > >
> > > No need the store-release and load-acquire for replacing
> > > synchronize_srcu_expedited() w/ call_srcu() IIUC:
> >
> > This isn't about using call_srcu(), because it's not actually about kvm->buses.
> > This code is concerned with ensuring that all stores to kvm->arch.vgic are ordered
> > before the store to set kvm->arch.vgic.ready, so that vCPUs never see "ready==true"
> > with a half-baked distributor.
> >
> > In the current code, kvm_vgic_map_resources() relies on the synchronize_srcu() in
> > kvm_io_bus_register_dev() to provide the ordering guarantees.  Switching to
> > smp_store_release() + smp_load_acquire() removes the dependency on the
> > synchronize_srcu() so that the synchronize_srcu() call can be safely removed.
> 
> Yes, I understand this and agree with your point.
> 
> Just for discusstion: I thought it should also work even w/o
> introduce the load acqure + store release after switch to
> call_srcu(): The smp_mb() in call_srcu() order the all store
> to kvm->arch.vgic before store kvm->arch.vgic.ready in
> current implementation.

The load-acquire would still be required, to ensure that accesses to
kvm->arch.vgic do not get reordered earlier than the lock-free check
of kvm->arch.vgic.ready. Otherwise that CPU could see that the vgic is
initialised, but then use speculated reads of uninitialised vgic state.

> >

