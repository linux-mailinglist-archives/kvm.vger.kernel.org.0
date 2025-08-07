Return-Path: <kvm+bounces-54219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6324B1D3F8
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 10:04:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 795AC188A309
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 08:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DADD24A04D;
	Thu,  7 Aug 2025 08:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GyOFjGsG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42762459D2;
	Thu,  7 Aug 2025 08:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754553851; cv=none; b=Qj0WjTP7qTchff7y9j5vO3tun3LTSyS4h2wJCztVpOlt+XIhx4ghAao384KMWgHLhppBzFooyAwplBksxVwkjGQ/0SV67xYJBbxCB54v0NXP7m3oroi9X1s6PB5EOHloN1/CSMQpbf39PpbHzxXELn7GFw3zu7BEtzPFSMpVdzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754553851; c=relaxed/simple;
	bh=dqc9EFJjG8Mr8IC/9Tl9cIt27Y+U76FKz/aNuKscP3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=As/JUIggqHzQS4dZiDRYZR3WqouRSgAtzHKG3k62fNAwShZRn7fmNBgg7nBy6PYM40RRNtXCAZYsqUGJ22F+kpiTSc7OlvQBTMbt13wbuTRaFFWtiZ3/Xl1KOlMh1bnEMOlp0FpqV3McV1CKSM2EJ6ZW18dnNvT+PdlMrHC7McE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GyOFjGsG; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-61997c8e2a1so446527eaf.1;
        Thu, 07 Aug 2025 01:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754553849; x=1755158649; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8wae+qR5fhE8jQMOdtpw1vQe+BuczBuTenzUdlRZ9tY=;
        b=GyOFjGsGI5epLdaeSGKkLJOCK2R6BId3OKuY1XJhU6kYclLJ1Gz283KbeUWlf0V7Gs
         wiPbwfRJFaveRfDwuKRSunbd5bdn0+h9mJOESJh9NdZ7GxpVtjEdVu+kMs8hnbxSunax
         lQLw5ESOBjJnsazz40fLsMoi6Hh8wRsbs4LI1jKvv5YPbsCbg4HT0rcZoJIfxJPpr/Vj
         mNYmMgI//ozLl+1sLmn6zchCwhzF1pqmzO5NSFkItyEy3h8jyyzNSELpL1fItoQvhGyc
         v2BLy4JOhj9ZYwXGYMYCgqlfPd0tTKqTzfvvJ8XqRr6ubVh4/5DOZ7U/Rx3T+VGL14ST
         sEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553849; x=1755158649;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8wae+qR5fhE8jQMOdtpw1vQe+BuczBuTenzUdlRZ9tY=;
        b=lnlgrkIItMBJahoYXg9y7AQCVNfbdyxPc6DrxuEzZszHyIiLaEt2f/bGHEqasqb+OI
         fzt38T74D9qNQsuybzIl8p60QImQGEMigJBLzckcTRvfj8kc3rRgC1w0DHwafUFlJdiv
         ouCsnf5BdHHMazId0390UkOGBpx60V95tPS0HMNGsv00scdSD2oK8blG2mH52tpi3JaZ
         zfmSqS02W+T1bnGp1f1DAT1NHIo+VCaEKZE0jkdxNk01S4x7ovCUti/EidNIiMzfWDGH
         3t1DGdT6IZwPrS+rPEDu2T8oNRmJFWhsGDHwt5YhamTLYXxV004ZmnRJslhKkS+2g95R
         V06A==
X-Forwarded-Encrypted: i=1; AJvYcCXAnGQhGVK5cGAeaB+QjwL7NRFpEfuqL8xd70aFEqfLEDLtlv2y72q+/rSqrvOq8FJE8MQ=@vger.kernel.org, AJvYcCXu9pGu8MW07ay6rpo3hGSIb8tNubuGXvOzARAxe9ctFsGh5PGVw6o4Vwl8vMIlvtrjmj/z+weCPuj/t3Jh@vger.kernel.org
X-Gm-Message-State: AOJu0YyBrIMcBCbkuzMfFQfwF3mSopMq/hbB+xmwdSVPt9s9dulSYXXR
	E9dxxJEyI+bcWOE2HqhQ0oa5qftB93ita8O4uUMW3RG6Av2YPvCH2zJxio/p4rxoI11m1u2Y7GX
	3jW+gpNC2vwuDjqYgM1lp0rtIpAjWOfU=
X-Gm-Gg: ASbGncvzrtxcsrv9P+99+cBXehyAX0hGUr01pvQjqwHigUwEF+AeGvfBlSHllI1ilMV
	dsl8qbQGFdJJ2qEy4yg1dmeQSbORCPshE93aqoHLPSnHacM6shcLG457saXIamHcLs8R4vDFopP
	GQMsMBTWa54IaE6YSIZbg9EBZLR209NUggBopL85rj1hn+a/PR2wsnIl09JMYvFTA4bC9Y+YFMm
	2H1LH4=
X-Google-Smtp-Source: AGHT+IH3rC620Ad0bDM8bPs/dSkuakMXrw+b62dY9ttQbWB+LhmXAlXtlNpoCZtfqdD2ku0pTkueOWNxOghxYLJZQz8=
X-Received: by 2002:a4a:ee19:0:b0:619:a34b:3e29 with SMTP id
 006d021491bc7-61b6ed17b1amr1746527eaf.1.1754553848581; Thu, 07 Aug 2025
 01:04:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806081051.3533470-1-hugoolli@tencent.com> <aJOc8vIkds_t3e8C@google.com>
In-Reply-To: <aJOc8vIkds_t3e8C@google.com>
From: hugo lee <cs.hugolee@gmail.com>
Date: Thu, 7 Aug 2025 16:03:56 +0800
X-Gm-Features: Ac12FXxHJZjqVcXiDcK5WpwSoEYWRRNT84CAqoxo1hkGbDkaTZtrLeDUrHvcNo0
Message-ID: <CAAdeq_+Ppuj8PxABvCT54phuXY021HxdayYyb68G3JjkQE0WQg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Synchronize APIC State with QEMU when irqchip=split
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuguo Li <hugoolli@tencent.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 7, 2025 Sean Christopherson wrote:
>
> On Wed, Aug 06, 2025, Yuguo Li wrote:
> > When using split irqchip mode, IOAPIC is handled by QEMU while the LAPIC is
> > emulated by KVM.  When guest disables LINT0, KVM doesn't exit to QEMU for
> > synchronization, leaving IOAPIC unaware of this change.  This may cause vCPU
> > to be kicked when external devices(e.g. PIT)keep sending interrupts.
>
> I don't entirely follow what the problem is.  Is the issue that QEMU injects an
> IRQ that should have been blocked?  Or is QEMU forcing the vCPU to exit unnecessarily?
>

This issue is about QEMU keeps injecting should-be-blocked
(blocked by guest and qemu just doesn't know that) IRQs.
As a result, QEMU forces vCPU to exit unnecessarily.

> > This patch ensure that KVM exits to QEMU for synchronization when the guest
> > disables LINT0.
>
> Please wrap at ~75 characters.

Thanks for reminding, will do in the next patch.

>
> > Signed-off-by: Yuguo Li <hugoolli@tencent.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 1 +
> >  arch/x86/kvm/lapic.c            | 4 ++++
> >  arch/x86/kvm/x86.c              | 5 +++++
> >  include/uapi/linux/kvm.h        | 1 +
> >  4 files changed, 11 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f19a76d3ca0e..f69ce111bbe0 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -129,6 +129,7 @@
> >       KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
> >       KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
> > +#define KVM_REQ_LAPIC_UPDATE              KVM_ARCH_REQ(35)
> >
> >  #define CR0_RESERVED_BITS                                               \
> >       (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 8172c2042dd6..65ffa89bf8a6 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2329,6 +2329,10 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> >                       val |= APIC_LVT_MASKED;
> >               val &= apic_lvt_mask[index];
> >               kvm_lapic_set_reg(apic, reg, val);
> > +             if (irqchip_split(apic->vcpu->kvm) && (val & APIC_LVT_MASKED)) {
>
> This applies to much more than just LINT0, and for at least LVTPC and LVTCMCI,
> KVM definitely doesn't want to exit on every change.

Actually every masking on LAPIC should be synchronized with IOAPIC.
Because any desynchronization may cause unnecessary kicks
which rarely happens due to the well-behaving guests.
Exits here won't harm, but maybe only exit when LINT0 is being masked?
Since others unlikely cause exits.

>
> Even for LINT0, it's not obvious that "pushing" from KVM is a better option than
> having QEMU "pull" as needed.
>

QEMU has no idea when LINT0 is masked by the guest. Then the problem becomes
when it is needed to "pull". The guess on this could lead to extra costs.

> At the very least, this would need to be guarded by a capability, otherwise
> the new userspace exit would confuse existing VMMs (and probably result in the
> VM being terminated).

True, I'll add this protection.

>
>
> > +                     kvm_make_request(KVM_REQ_LAPIC_UPDATE, apic->vcpu);
> > +                     kvm_vcpu_kick(apic->vcpu);
>
> Why kick?  Cross-vCPU writes to LINT0 shouldn't be a thing, i.e. the kick should
> effectivel be a nop.

It is unnecessary, I will fix it in the next version.

