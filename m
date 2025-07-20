Return-Path: <kvm+bounces-52945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB074B0B2F3
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 02:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 577E5189F727
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 00:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948D653A7;
	Sun, 20 Jul 2025 00:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="caMW7XII"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F99E3208;
	Sun, 20 Jul 2025 00:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752970116; cv=none; b=jdDte9VdlOx8zb3FHv2SdJuatQXFO5KfU6r6zjQz5ADGmW8EMRDQV2tb+RlzXlNyZy8Sp/DOzSyS/dEwYLxwoBbRkLTRJbl8Ai3VUti5exrOJ+CV43IOXFz9cdwB/W8BCXTYAuAcnVr6/HT9Z+WnzB1iNJE1hdl9tBchL+H7rFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752970116; c=relaxed/simple;
	bh=dvhlfnC8KYcCSUF8hYDM1WkNpNiTwJjeJomK3LH2drQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NNphhkp5o2ZY/qip9MMP/XBbRHbhqugxTPMyrmKF1x/OwD9tevfY7QbgJzpYuQej7dmkPA1SejAnyw2A06skRrX31lq5po2RMD7Rniv/MFsK/50iPZ13k9X6aJzLxyHOvazkcQuvXsc+YzAZ1wi2+QzejSnuvopFBTmh8NUYqko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=caMW7XII; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-23694cec0feso29654865ad.2;
        Sat, 19 Jul 2025 17:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752970114; x=1753574914; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kl5dOLRGZSE3XxSQd2+oJTQaOnXruucC4cwYHuCuPzY=;
        b=caMW7XIImW/I1wendvYrJSzN2RsA2buEynN8r0HyDKTeU6ag3c8vjYzlL0lFIIdMU3
         74JMPEH2cuGpiSjGY7PoPMOqd3ZLAKsRdiHBwrXsJrbX/RsLksE2LAEQ/z/hDcg9YxAy
         AenPMcm10TvpsRsmDBTd2OogUBQGc5Xrow9LIect2aOZqBqzrmzYnClKFV/6hovsz6xS
         HvzkXmL0TS6cGaXwx4ME0DKlFxx93HNpKqYvm3/jRnK/j6i3jzCEAQFsKSOpZrqud8ji
         s/7CiCuKjGwjc0ItdLftRsXrmc10qgFoFIBL8tkue25uxPhBqv8VaJQKYc5DUfDCO7ko
         gItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752970114; x=1753574914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kl5dOLRGZSE3XxSQd2+oJTQaOnXruucC4cwYHuCuPzY=;
        b=u6ok4q2igh1NtlBuiF+rscFvM+TkoTZcnkpXwCfKCfRTZAEnAO4BvCaMs8RgGsXHpq
         K3A2MR3tUymHHKvrFWxYqnU2S9QS9AMx6CFT27cE8Zsl0MwM5urmqqAVRc5cawHefTPN
         9LwRwYIDC+TAQ7ygvKIb8A8fyQV1UkpWO2QQqTh/+mH8DOIX9Vc65yz/pv737g1gggXg
         3Uz7U+KnzWDTMQrx+BtDSaxy2mP6vB+NgwtiTtbUVM4UWXQze1JTLS76cMrx8W4V1Bb8
         ICrYD1F2pkzI5iZhp0G8+qsseQJU4JWD0mGYT4OJJIzNs5CMw6lK1tX0z2n1LAPo5YKe
         whMw==
X-Forwarded-Encrypted: i=1; AJvYcCV1++rw0+k8GIKC7SybNqpdaafgby2dY1gmS71yiDbJb+Hbj5NchqB1k1gl9b8vYZmzvOdSefZ+DSBPKeVb@vger.kernel.org, AJvYcCVj8PIV9O0I+bj0l5qXOUC4GTexJcc6nO2KRnJ9+Xea3RfdGdL4fuxM0WNqRe8lHrzaZfE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhARDxnAgN3/EZTYsSv5CivgqlJOINjN7WRijXK5vxGkTKIDtI
	ZFckLUQ4MIRAGwPU0KH4L5SbHvymn5/YeW2hJ6l05WPB/Gf+ZzK2L5YU
X-Gm-Gg: ASbGncu95rDP9gsegc5Hi0XwjIExhHKG0IpPcnWReh1yBuUmukh1bWHb33SesNn+UMl
	MmJSNeEKUBzWOtiFu38SACH0iUw58pyc1/rBGo3/dUvQBGdmJeM9PFLCsCXe2lnaWA0kVUhZqqO
	1A/CwTh29VpOcNVDmRDF/0HT9Nf6pRtt1F2BE6kHknsqpnSyBj6y4GcCcybIWIiH/o2OH72Fdur
	ObRAR5wWv0DKHVdAnIopBkDgeQiS0MFThv9og4IoRCEAq7QhFavk2CYHo8Yxmxhto2Qi/RLUUeV
	8d937iHn0YCKlZIfRh+C+X75ZGQCIYGUxKqxCMj9+g9iIyHw4PcKOQ9uiUadrMBHqO3GBgxq9GL
	vsNtWNhKk0Yd2cEBmCPu1Wg==
X-Google-Smtp-Source: AGHT+IE8XY+dnJCyO+fxfVPZjk61YisG840KHkxyISTYR3V12PFOL8A/LUQwYZFMMwVeIkosxKL8zw==
X-Received: by 2002:a17:903:198d:b0:23a:cba1:6662 with SMTP id d9443c01a7336-23e24f94702mr281107665ad.46.1752970114388;
        Sat, 19 Jul 2025 17:08:34 -0700 (PDT)
Received: from localhost ([154.21.93.22])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-23e3b6b4a9esm34086575ad.93.2025.07.19.17.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jul 2025 17:08:33 -0700 (PDT)
Date: Sun, 20 Jul 2025 08:08:30 +0800
From: Yao Yuan <yaoyuan0329os@gmail.com>
To: Keir Fraser <keirf@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
Message-ID: <4i65mgp4rtfox2ttchamijofcmwjtd6sefmuhdkfdrjwaznhoc@2uhcfv2ziegj>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-3-keirf@google.com>
 <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
 <aHphgd0fOjHXjPCI@google.com>
 <5zpxxmymnyzncdnewdonnglvmvbtggjyxyqvkf6yars2bbyr4b@gottasrtoq2s>
 <aHtQG_k_1q3862s3@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHtQG_k_1q3862s3@google.com>

On Sat, Jul 19, 2025 at 07:58:19AM +0000, Keir Fraser wrote:
> On Sat, Jul 19, 2025 at 10:15:56AM +0800, Yao Yuan wrote:
> > On Fri, Jul 18, 2025 at 08:00:17AM -0700, Sean Christopherson wrote:
> > > On Thu, Jul 17, 2025, Yao Yuan wrote:
> > > > On Wed, Jul 16, 2025 at 11:07:35AM +0800, Keir Fraser wrote:
> > > > > In preparation to remove synchronize_srcu() from MMIO registration,
> > > > > remove the distributor's dependency on this implicit barrier by
> > > > > direct acquire-release synchronization on the flag write and its
> > > > > lock-free check.
> > > > >
> > > > > Signed-off-by: Keir Fraser <keirf@google.com>
> > > > > ---
> > > > >  arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
> > > > >  1 file changed, 2 insertions(+), 9 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > > > index 502b65049703..bc83672e461b 100644
> > > > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > > > @@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > > > >  	gpa_t dist_base;
> > > > >  	int ret = 0;
> > > > >
> > > > > -	if (likely(dist->ready))
> > > > > +	if (likely(smp_load_acquire(&dist->ready)))
> > > > >  		return 0;
> > > > >
> > > > >  	mutex_lock(&kvm->slots_lock);
> > > > > @@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > > > >  		goto out_slots;
> > > > >  	}
> > > > >
> > > > > -	/*
> > > > > -	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
> > > > > -	 * registration before returning through synchronize_srcu(), which also
> > > > > -	 * implies a full memory barrier. As such, marking the distributor as
> > > > > -	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
> > > > > -	 * a completely configured distributor.
> > > > > -	 */
> > > > > -	dist->ready = true;
> > > > > +	smp_store_release(&dist->ready, true);
> > > >
> > > > No need the store-release and load-acquire for replacing
> > > > synchronize_srcu_expedited() w/ call_srcu() IIUC:
> > >
> > > This isn't about using call_srcu(), because it's not actually about kvm->buses.
> > > This code is concerned with ensuring that all stores to kvm->arch.vgic are ordered
> > > before the store to set kvm->arch.vgic.ready, so that vCPUs never see "ready==true"
> > > with a half-baked distributor.
> > >
> > > In the current code, kvm_vgic_map_resources() relies on the synchronize_srcu() in
> > > kvm_io_bus_register_dev() to provide the ordering guarantees.  Switching to
> > > smp_store_release() + smp_load_acquire() removes the dependency on the
> > > synchronize_srcu() so that the synchronize_srcu() call can be safely removed.
> >
> > Yes, I understand this and agree with your point.
> >
> > Just for discusstion: I thought it should also work even w/o
> > introduce the load acqure + store release after switch to
> > call_srcu(): The smp_mb() in call_srcu() order the all store
> > to kvm->arch.vgic before store kvm->arch.vgic.ready in
> > current implementation.
>
> The load-acquire would still be required, to ensure that accesses to
> kvm->arch.vgic do not get reordered earlier than the lock-free check
> of kvm->arch.vgic.ready. Otherwise that CPU could see that the vgic is
> initialised, but then use speculated reads of uninitialised vgic state.
>

Thanks for your explanation.

I see. But there's "mutex_lock(&kvm->slot_lock);" before later
acccessing to the kvm->arch.vgic, so I think the order can be
guaranteed. Of cause as you said a explicitly acquire-load +
store-release is better than before implicitly implementation.

> > >

