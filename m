Return-Path: <kvm+bounces-52904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B47CEB0A6C2
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AA631C408AC
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27AD2DCF43;
	Fri, 18 Jul 2025 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GiVxeIfV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F64A22339
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752850905; cv=none; b=Vbkzc3OhCUmtawO5/OHv1Mi5o5dflafAr2VPL7gnGvOcuOPknkQG6lgKP4QNHUJYdXzpdw+Xj5Xc/uyEnMgWt1858sQfhn4Ua+XLzyb5ubDcNIbe9P7eTsIFng7fEg0aiqmt8KznPwmB3rsJ2/rMLfocw+zpoWcojNTU2Z8/LqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752850905; c=relaxed/simple;
	bh=WgvwxniVn+OVr5zoobK2/58Tn2Xyi++2EmWaQbvmIKw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ldc2DWA/6Fkew6U9A6RtgeyBlxtS5O8WFvCmrLBbmYPNIEGH/gGab2glg50Z7uctLsI9O/iyvHdvF4AQEkWwi3IssJoIYpPkjBJY6uSFHRjYDhqZ7J9cZNhJIJfOYEjahCWOjguhIoC3qNIjAqIrwVROSXtAJhQWrfviq/XlPgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GiVxeIfV; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31bd4c3359so1357112a12.3
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 08:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752850903; x=1753455703; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=geYaB9rXHQSUMsGWg9gaauTb+O/4/i92BVIedWT6AZU=;
        b=GiVxeIfVyxqsHMXvKQNglT8byfqLqhsr8TFezB0z6QsfAnCdlwD9vb+SLwUIBkj8VH
         G9mw0itZdD2s99CKH9rnII+FwUW4FytmgPZknM9U2Q0xS75faAdSYQ6SMb7F2SOd7x7T
         Mjg/79baIliQLst2hUqiNm7uONPunG+91frhzotQBtI29LtsQ5bPEuJsm2PfUd3N0pCf
         5Y7Iro4cBzFHf7AvPfSbWc96cLO01SlVFrKLEafSG5EgM+R6xaYfiqRLVkmBWSMFxm2B
         XdDmYxih7qULecOtKZwtWfg3IhSaSwsGtZkX/mFqq2pN7geuwfUdfIk/p6YglHj+Z5+u
         pNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752850903; x=1753455703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=geYaB9rXHQSUMsGWg9gaauTb+O/4/i92BVIedWT6AZU=;
        b=P+JHYKfB/kITPQLin1dmMGiR+G50WsyKCy9+8nSw/ohN7IgZ0djR8IGFZKEvVMgJci
         7e0RwAKy+/l2LUEZBCmDVdPm2mrscT4eLWlFs5x1McwgPvaShbvVgIJfKiN4dQ8V4grC
         GuZLGBDFQwJ6Zm/9vTrQ5KXneaz6kKnsWCWom227ATG80AOGgUk67zGcb5eF9FACh5Fu
         WBqAn2UIybN1ilC2i17cHkUfFfIX0CVZR7LLyz02ymXwyFhBgV7uLL3toJZY1nCt9uxY
         PnsbWqJLPxBp/Ait728wVFz+k1sUl1GcojPTRyQusNTjmTd1F5fB9wFryHLfxO64kZkk
         FgBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLoh3aHor5SiocPfXtehwB1ZM9kkQATOBsvVgagl2dk+YF+TZJPSGvsoPuj2x1ePJz248=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTMc7TNkjU1V0BFeF08DdSVTy2MhPHpU/7pMfOdN4uBruP8RwW
	sIdSKRmAXJE221uI1Zum+HngzmiWT5iynM6CUzmKAdshcylnLpWaVOZe7AhGj3nbodeXm82YTEI
	kD1Mlog==
X-Google-Smtp-Source: AGHT+IHdKCPaGZUvEghSMEa/uSwnZ5WlkHcmcoPjFppjTidPL81orqXlF7aHA7YyyC6gZbDkNyDDlRyVDxc=
X-Received: from pjbqd6.prod.google.com ([2002:a17:90b:3cc6:b0:311:eb65:e269])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:6e17:b0:238:3f54:78e7
 with SMTP id adf61e73a8af0-2383f548d14mr11815528637.45.1752850903016; Fri, 18
 Jul 2025 08:01:43 -0700 (PDT)
Date: Fri, 18 Jul 2025 08:01:41 -0700
In-Reply-To: <aHpf9vuRK691J7HD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250716110737.2513665-1-keirf@google.com> <20250716110737.2513665-3-keirf@google.com>
 <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34> <aHpf9vuRK691J7HD@google.com>
Message-ID: <aHph1ZeYRhWIMCMm@google.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
From: Sean Christopherson <seanjc@google.com>
To: Keir Fraser <keirf@google.com>
Cc: Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, Keir Fraser wrote:
> On Thu, Jul 17, 2025 at 01:44:48PM +0800, Yao Yuan wrote:
> > On Wed, Jul 16, 2025 at 11:07:35AM +0800, Keir Fraser wrote:
> > > In preparation to remove synchronize_srcu() from MMIO registration,
> > > remove the distributor's dependency on this implicit barrier by
> > > direct acquire-release synchronization on the flag write and its
> > > lock-free check.
> > >
> > > Signed-off-by: Keir Fraser <keirf@google.com>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
> > >  1 file changed, 2 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > index 502b65049703..bc83672e461b 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > @@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > >  	gpa_t dist_base;
> > >  	int ret = 0;
> > >
> > > -	if (likely(dist->ready))
> > > +	if (likely(smp_load_acquire(&dist->ready)))
> > >  		return 0;
> > >
> > >  	mutex_lock(&kvm->slots_lock);
> > > @@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > >  		goto out_slots;
> > >  	}
> > >
> > > -	/*
> > > -	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
> > > -	 * registration before returning through synchronize_srcu(), which also
> > > -	 * implies a full memory barrier. As such, marking the distributor as
> > > -	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
> > > -	 * a completely configured distributor.
> > > -	 */
> > > -	dist->ready = true;
> > > +	smp_store_release(&dist->ready, true);
> > 
> > No need the store-release and load-acquire for replacing
> > synchronize_srcu_expedited() w/ call_srcu() IIUC:
> > 
> > Tree SRCU on SMP:
> > call_srcu()
> >  __call_srcu()
> >   srcu_gp_start_if_needed()
> >     __srcu_read_unlock_nmisafe()
> > 	 #ifdef	CONFIG_NEED_SRCU_NMI_SAFE
> > 	   	  smp_mb__before_atomic() // __smp_mb() on ARM64, do nothing on x86.
> > 	 #else
> >           __srcu_read_unlock()
> > 		   smp_mb()
> > 	 #endif
> 
> I don't think it's nice to depend on an implementation detail of
> kvm_io_bus_register_dev() and, transitively, on implementation details
> of call_srcu().
> 
> kvm_vgic_map_resources() isn't called that often and can afford its
> own synchronization.

+1

