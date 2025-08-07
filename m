Return-Path: <kvm+bounces-54267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12F60B1DD2E
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 030E67A122A
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 18:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8D921A458;
	Thu,  7 Aug 2025 18:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hnmqpRKz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0525C1D7E26
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 18:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754591929; cv=none; b=oHeALNwY6XlJrCsb0iTASehDvQuZ8w1UgUvzJRzxe9598Yh5NhvSMIi0W9DvygmcxhKOYTDxiaEY6yTTPEobsEV5yoYAZi3ePNcATp+aGHqNjVaejnqT+7e+SAzcZi+1Cs6kh6lUWozaCM0ceBfP1JOB+ylO1yirtVj2lNdXxiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754591929; c=relaxed/simple;
	bh=xmmHCmJcE2ulD2451FS6SDHBUoDFstNnx3dJA00gofo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SgtI2U2fiy4ltd3F5wIACOf+jtV0i36qJszWIIUbOWwBI0elj8FMQVQq8pdC5oHbF6T3epk1diocPGiTVFSz1SCmMlHTYb6zf4ZfQOzcg0uXtA1TiSMivrtX6Hj3nTGhw2IasBK+iLZ72xye/zHWxc3tAqJg/9TmwMCN5OEf4lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hnmqpRKz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3214765a5b9so2605226a91.3
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 11:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754591927; x=1755196727; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yp84IsrpOeYSbgICcPR8apvUJuROu2Gav6Oyrx9mTk4=;
        b=hnmqpRKzSQp0UndbKtkjlzsUeE52pwoO38uc6md0/VsOZ30hrpGBYfIVSY3n46So4D
         qvcjHtUBxOxgLjGVZ3d5fvytgJGxYZ6N2XI1+2oLVAbVtpnLMRqK588RTV9FrYf5vMuW
         OYb0f6J5eAFTtuWqKlNKdFn8IoR9jfY2ONyZZwX3xXSsoXBuv295hLpkmeXpes1rVwrA
         /UYYqd5tA8QeeqyJNxhDeX9AyHXgyM6m6LVgewrIWd9TmBqd6+wL7CaRaENifMYFpJoB
         P9rsn9CHqw4njfOOH2wX3RL2OYmf51TCiSHI5gltPW+MMcpARprDlN/V2fkG+Herjfmd
         EaoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754591927; x=1755196727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yp84IsrpOeYSbgICcPR8apvUJuROu2Gav6Oyrx9mTk4=;
        b=hbHxuSgn8H05geIK4T7y2kirXNRg6UsZgOxz0bQXRxkIUqSVqdivjmdK7iWGftpLxO
         4Sez0/KUBxyUAzq59Mh3TepEFb8ZffhVXJeU3XDEgz//pAJZ/slmLWvKXf0nGRDj5/ML
         nbukLvfExMR8qs15S+qLsL41PFSqNXtTlQEpvn1I5Ea1BrYvMWJBfwR3t0zVm8lR3NDo
         o5mLknw+O/PGm0RCLomnsy3h0tsozhiPmYZa1eW7vg6B4zfVJ53PVqI6NAV3jAdD2GSG
         GXwvX+aQkRuptBfZBPPcHjsc2kn9w7DgSwHh6ILWtidtZRst/vDDENloPYlbw4XYcYW2
         vfNA==
X-Forwarded-Encrypted: i=1; AJvYcCX6t3sE/iqnURDKjhcAWtK8XeVMODfWGdXdkWUpOOp5HcLSwKPKH8UKIB2lmb9yomZnDRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLwdbTTN7rCtXRLIammetUDrUOJ7YaOk30FBoMCiqtZKENhO8q
	SZRW/efmlCy33PavlMPraOJ7FkOL5plGC08TRlFErQFBEhpx8RKBOjUoREHAPebaPhKIptaggnn
	SIjKy6w==
X-Google-Smtp-Source: AGHT+IFCWCOlCO6n5/AEOdaCe6fYz3jM8iX2vBVKNK9vB/91SLgPbLstukRS4VE0qXM9vySMQaYSmXIXgcA=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:31c:2fe4:33ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b41:b0:31f:6ddd:ef3
 with SMTP id 98e67ed59e1d1-32183e74d4dmr55251a91.35.1754591927300; Thu, 07
 Aug 2025 11:38:47 -0700 (PDT)
Date: Thu, 7 Aug 2025 11:38:46 -0700
In-Reply-To: <CAAdeq_+Ppuj8PxABvCT54phuXY021HxdayYyb68G3JjkQE0WQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806081051.3533470-1-hugoolli@tencent.com>
 <aJOc8vIkds_t3e8C@google.com> <CAAdeq_+Ppuj8PxABvCT54phuXY021HxdayYyb68G3JjkQE0WQg@mail.gmail.com>
Message-ID: <aJTytueCqmZXtbUk@google.com>
Subject: Re: [PATCH] KVM: x86: Synchronize APIC State with QEMU when irqchip=split
From: Sean Christopherson <seanjc@google.com>
To: hugo lee <cs.hugolee@gmail.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuguo Li <hugoolli@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 07, 2025, hugo lee wrote:
> On Thu, Aug 7, 2025 Sean Christopherson wrote:
> >
> > On Wed, Aug 06, 2025, Yuguo Li wrote:
> > > When using split irqchip mode, IOAPIC is handled by QEMU while the LAPIC is
> > > emulated by KVM.  When guest disables LINT0, KVM doesn't exit to QEMU for
> > > synchronization, leaving IOAPIC unaware of this change.  This may cause vCPU
> > > to be kicked when external devices(e.g. PIT)keep sending interrupts.
> >
> > I don't entirely follow what the problem is.  Is the issue that QEMU injects an
> > IRQ that should have been blocked?  Or is QEMU forcing the vCPU to exit unnecessarily?
> >
> 
> This issue is about QEMU keeps injecting should-be-blocked
> (blocked by guest and qemu just doesn't know that) IRQs.
> As a result, QEMU forces vCPU to exit unnecessarily.

Is the problem that the guest receives spurious IRQs, or that QEMU is forcing
unnecesary exits, i.e hurting performance?

> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 8172c2042dd6..65ffa89bf8a6 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -2329,6 +2329,10 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> > >                       val |= APIC_LVT_MASKED;
> > >               val &= apic_lvt_mask[index];
> > >               kvm_lapic_set_reg(apic, reg, val);
> > > +             if (irqchip_split(apic->vcpu->kvm) && (val & APIC_LVT_MASKED)) {
> >
> > This applies to much more than just LINT0, and for at least LVTPC and LVTCMCI,
> > KVM definitely doesn't want to exit on every change.
> 
> Actually every masking on LAPIC should be synchronized with IOAPIC.

No, because not all LVT entries can be wired up to the I/O APIC.

> Because any desynchronization may cause unnecessary kicks
> which rarely happens due to the well-behaving guests.
> Exits here won't harm, but maybe only exit when LINT0 is being masked?

Exits here absolutely will harm the VM by generating spurious slow path exits.

> Since others unlikely cause exits.

On Intel, LVTPC is masked on every PMI.

> > Even for LINT0, it's not obvious that "pushing" from KVM is a better option than
> > having QEMU "pull" as needed.
> >
> 
> QEMU has no idea when LINT0 is masked by the guest. Then the problem becomes
> when it is needed to "pull". The guess on this could lead to extra costs.

So this patch is motivated by performance?

