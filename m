Return-Path: <kvm+bounces-52938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B51B0AD7A
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 04:24:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B68F1AA543A
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 02:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768891E7660;
	Sat, 19 Jul 2025 02:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MaZc7s3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4BB17A2F8;
	Sat, 19 Jul 2025 02:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752891844; cv=none; b=OxXA0ZXTV4dVhJ5sDCURDrrVKph9xgopMrY/9HwLeV6aUqSiA0S5XWArysXOEoqKLjyxsQNgsvYvtb7W1CjbIdVwJv/yHtuSkUa794wlUcRMCIuWV3Z4ExE/KgXKAEhDjw0ZPtHtuSFXwW4UVW/t4fNUVQJC3RKPG7pC4Rztskw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752891844; c=relaxed/simple;
	bh=MwUbN4TfFlKXegA5PdkOQgrZZ3JWWOKguNS37HbIF+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7LV3EDqU12tEy2BF8JIYURVXwo9g91frppv3UsMj5XjD/xCQoRk8cYgoECdBpghSmKRoBcIm1+oSbU5fyVsnCKKmy5eS5Nk5IlumtiDYKayMMuSaQn6Z4yhvdAfXh7mWVxGNKzRdeIrqhlpVrtTghyzRVP5kIaG8Opl0LHdD2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MaZc7s3Y; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3137c20213cso2525082a91.3;
        Fri, 18 Jul 2025 19:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752891842; x=1753496642; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UekTEVhnNq8YuPcLfLeZp+/v4L/znNVYlBT0hy1V2FU=;
        b=MaZc7s3YZhz6h5Imw64tDG5xFKthhshPYqQkjMc3QEd5pbx9/yxBincY7Z4/iNTcUN
         qEnypxNX+pKQIlw3ebkN6WAP5zGKB8YFoAdnRTkgtdbn6qCQy6bR9Hvj1oqFSQNF2WgT
         uxbMim6F2I8Ih5guVO1NHnGYgWO+b596Vnxy44vnaGfgVT2uyZ6UqnU3wNLMCWBxziLe
         PhYaoBcsw2Kl9p6AwAWzC4YqtF0VbpaMhzMvxK54G3C81QbYXaysQB9ldDK50QLh2Dik
         WRCPZTCxm0h+lvlYtzk00/e2wuxWI8yAGfj3wnLud4TWSxHgr0Ualwgbd+TsOQ46En5C
         j+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752891842; x=1753496642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UekTEVhnNq8YuPcLfLeZp+/v4L/znNVYlBT0hy1V2FU=;
        b=oBadnzX0JSxSS1/LJQ8XJUk0qD4h++YHD66w5oJ+OJK9pUU8JlFrmSbOaH2yGQ5Fas
         ALSElFes0pA9qFbR8/pNNwDuJjX+9JO50hs1f9TPNHNG2+gia6FNYUXwlQ1J/cbTKtIn
         VEUxTZtARkiKdCACfay2ah+pD1NE+4X9SM6Ftm+CENCAym5dabapabOWkm5nC2enrj53
         oEoIKLJLZG88WQknPiXOZAJF11z0TfK/QooWN79Rf3b58ssd98e/gWm0fGSbCsyBYVY/
         AzYav8FuxMA5jPh5NrU3CcsnWmO5/Mv2z3EkXT/EqQbDiDIu+7ZzNuowwN7n1EL3gSWs
         nQ9g==
X-Forwarded-Encrypted: i=1; AJvYcCUtLXOAd/tPqzcy4/KWoC2xLhjCxhQHWmvcW0X5wBd7zabMYI+Wy4tb7NVLzBGaUFv04bc=@vger.kernel.org, AJvYcCWK4+WPN6Hi1mBDsFTqm/RB3OMrvAP4FrX9p9G38RxB6j03GfY/06u4zJ2C0nLGhYspLVwWI2NrSThDgRWC@vger.kernel.org
X-Gm-Message-State: AOJu0YzF1OPNxjwjcW2Y/806Vzmi6Gii04Dnhb35kSqv57eEjrCCYLDp
	j4KZGOqnWuYldd3PoEgH1Zfj7K1CVD8gG9h8KQP9Qq+M0F4jkuSPeEIj
X-Gm-Gg: ASbGncsAQtKreIpWbdl0bb3jumu6m0mx4xoz7E0AKi9tYNgFeJ3mtmIAf/Fh/Fq6mqO
	YhkxiNX92zaoQ+p0e9FEHxCZULzU1VE17VypZfmFO5K1bz/NAn9WCjHVFh+srE+og5zS6wy5/xh
	rn9wbT+saeCrdOL9NROKyB5kIHOwhNNfF4CQ9pB5n7VXCjh3T3I8d9dWX1ii5qfM2QI63pHx6T2
	ua7cAfdVrj+RCk+jJY4Q7aClFE76wuzyMb5SFqI1QW2gfsjky4WOMWvZtYU9hk8yL99GMrhcSBl
	FQZinKHsJHTkmyHlqgeUSBb4lPNo576xs6rOqD0Fbm3wgeQuXZ/XUatOekjJn04Uf8dc2RX4AEW
	Jzd1hGckkGGuygJDRVt2TUP5sowRg4X1pLsPZ
X-Google-Smtp-Source: AGHT+IFxnG+CFF/7oWtplwctTOfS13tWpUsKu9J6m0qA87Ejv7R4S25APaUlFN65xbYHenOBz6lh6w==
X-Received: by 2002:a17:90b:5307:b0:313:db0b:75e4 with SMTP id 98e67ed59e1d1-31c9f48a241mr23268365a91.33.1752891842281;
        Fri, 18 Jul 2025 19:24:02 -0700 (PDT)
Received: from localhost ([2409:891f:6a27:93c:d451:d825:eb30:1bcc])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-31c9f1ba67csm6115660a91.8.2025.07.18.19.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 19:24:01 -0700 (PDT)
Date: Sat, 19 Jul 2025 10:23:53 +0800
From: Yao Yuan <yaoyuan0329os@gmail.com>
To: Keir Fraser <keirf@google.com>
Cc: Yao Yuan <yaoyuan@linux.alibaba.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
Message-ID: <tvn672qzjbpp37awdm7fnpojcm3fpddbrpn7ayjqud7znih4zx@nzhnx5g5izrs>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-3-keirf@google.com>
 <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
 <aHpf9vuRK691J7HD@google.com>
 <aHpnev3hf1bEllsy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHpnev3hf1bEllsy@google.com>

On Fri, Jul 18, 2025 at 03:25:46PM +0000, Keir Fraser wrote:
> On Fri, Jul 18, 2025 at 02:53:42PM +0000, Keir Fraser wrote:
> > On Thu, Jul 17, 2025 at 01:44:48PM +0800, Yao Yuan wrote:
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
> > >
> > > Tree SRCU on SMP:
> > > call_srcu()
> > >  __call_srcu()
> > >   srcu_gp_start_if_needed()
> > >     __srcu_read_unlock_nmisafe()
> > > 	 #ifdef	CONFIG_NEED_SRCU_NMI_SAFE
> > > 	   	  smp_mb__before_atomic() // __smp_mb() on ARM64, do nothing on x86.
> > > 	 #else
> > >           __srcu_read_unlock()
> > > 		   smp_mb()
> > > 	 #endif
> >
> > I don't think it's nice to depend on an implementation detail of
> > kvm_io_bus_register_dev() and, transitively, on implementation details
> > of call_srcu().

This is good point, I agree with you.

>
> Also I should note that this is moot because the smp_mb() would *not*
> safely replace the load-acquire.

Hmm.. do you mean it can't order the write to dist->ready
here while read it in aonther thread at the same time ?

>
> > kvm_vgic_map_resources() isn't called that often and can afford its
> > own synchronization.
> >
> >  -- Keir
> >
> > > TINY SRCY on UP:
> > > Should have no memory ordering issue on UP.
> > >
> > > >  	goto out_slots;
> > > >  out:
> > > >  	mutex_unlock(&kvm->arch.config_lock);
> > > > --
> > > > 2.50.0.727.gbf7dc18ff4-goog
> > > >
>

