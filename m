Return-Path: <kvm+bounces-15017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A9BB8A8E04
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C552E2828BE
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 21:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CB412C49F;
	Wed, 17 Apr 2024 21:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jlpi/bZD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99F4651B1
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 21:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389537; cv=none; b=IJNgTtRSyxZPINrJxLgNIw2jXIUMqa3JuXXvPNhlZelnIKKxKZtjhpndyMnYmIEY6INk8+cuGV7HLdUoTVOXoxjHjYJYlYOq8nATyDQqv8OPhdICIFcFyH+XgyF8WRZ0bsyGXTo0QMplLU58y+8ZJwCao4y0GPtR44XDmzE3VSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389537; c=relaxed/simple;
	bh=o4ZzPbXgGJV6wIN0xFO5k2qGJAg4ROxgXnIOUjkY9Y8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kOZv7GXinDWpyFNlM8TqFdiTMZJ1/cjWf0BlJSHd/U7Yddj61DXqSoSDL3A+LbteNBO7IeTE39RH0+LqUdUDEtuRkTZPsKcRo0W89HSHN+gNo010g4eEKrui+27Delu7Lgc6trQQ9uw3npufGIdBsukm+/0gqe0N/1K0DrkXWI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jlpi/bZD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713389534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FOVQ+kJm5UGoTnaDzH+v120w+Q/H6UQFK/Salxx6EBQ=;
	b=Jlpi/bZDN7xnxqTgytJCBCtf56BKRo3vYeqwXM4xZeDOAfdn8nEyYxz7Q4IR/WL4uhkBhQ
	Au5NxhCu7QtmY9WObKtTY2cJsQLkYiEKhhOxxth7EX3MVxHVwMJhN5HvzQtwzp2xULNxx1
	WD9bgOVeseldXmlyBF6K2NxkrGBWpc4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-k909NswfPk-9Fc3OOqCmXQ-1; Wed, 17 Apr 2024 17:32:13 -0400
X-MC-Unique: k909NswfPk-9Fc3OOqCmXQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4183909fec8so1760535e9.0
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 14:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713389532; x=1713994332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOVQ+kJm5UGoTnaDzH+v120w+Q/H6UQFK/Salxx6EBQ=;
        b=R5h0VC88eSox90KEVkw2gq33LZVgBihnlsUda+an+8TC997wBe/K1DoTtZsmPTzy6w
         FeWfdK1eX2T510wMz1qrB0hULEomTafxL1SxtCnwfc2IcPvzSWDzhL1bRbYC2usdgMcr
         LZehSv8geZCCE5VlksEqBjKkw84qWRcaFXFPUpJ0vTekUJXBq9UrWqP1mLxepr+OHkca
         WnJ+JecYcVmvCtwLShKwi/KM6IGRWqIgOELUpL+Nolai1y32/0iTZUEKAJTS/l7bLf7n
         G48/2hZES5wtC0QRIJnyqy2cVbgd1OXKLYBXHx1M2ioUgQU2G8ey8/7N0djegGUGjNB/
         +LZg==
X-Forwarded-Encrypted: i=1; AJvYcCVFRsa9Yeg15NiO+J0So4IGsOe9BIFrg7Z7kHu4Kff7F5M1M2MkVKTlcipCWytwKVEsn2ybk2Qrr9fuv5EI/URhg2qe
X-Gm-Message-State: AOJu0Ywywt8vu2rTaZxUGJiM13F4r9VbULOAy58uHdPTeqmyon9fSUdy
	uRyNi0x8bN0mruQseBCIKz/kAYLWnUUFB8raFMZOsKI6po3QJhMNQYoyXRR33TRDSlWNa6zeWF9
	yT4bN+mca6OCmiuCBTq5NW0BosCjUkUx5Xrq/pV0jSEWxdXyXaXV1dMOfQ7eJnwV42RJWjpVsYa
	rhtQ8pvbi9B+/DfQ2I2vSr5M1H
X-Received: by 2002:a05:600c:3511:b0:417:f527:21d0 with SMTP id h17-20020a05600c351100b00417f52721d0mr880426wmq.0.1713389531876;
        Wed, 17 Apr 2024 14:32:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExokZ2UtIR757q6xjat/EcnvSwWtY1morlrqJXGuY0QTUFBJhN7WTHXwcuZyIV4LrARliXckvbYj89xB4i44o=
X-Received: by 2002:a05:600c:3511:b0:417:f527:21d0 with SMTP id
 h17-20020a05600c351100b00417f52721d0mr880411wmq.0.1713389531554; Wed, 17 Apr
 2024 14:32:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240417153450.3608097-1-pbonzini@redhat.com> <20240417153450.3608097-6-pbonzini@redhat.com>
 <ZiA-DQi52hroCSZ8@google.com>
In-Reply-To: <ZiA-DQi52hroCSZ8@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 23:31:49 +0200
Message-ID: <CABgObfaoVMzEhu6O5HPe=GXH-bCkpTwSy8Ji0a1=je6f3eSqRQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] KVM: x86/mmu: Introduce kvm_tdp_map_page() to
 populate guest memory
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 11:24=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, Apr 17, 2024, Paolo Bonzini wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Introduce a helper function to call the KVM fault handler.  It allows a=
 new
> > ioctl to invoke the KVM fault handler to populate without seeing RET_PF=
_*
> > enums or other KVM MMU internal definitions because RET_PF_* are intern=
al
> > to x86 KVM MMU.  The implementation is restricted to two-dimensional pa=
ging
> > for simplicity.  The shadow paging uses GVA for faulting instead of L1 =
GPA.
> > It makes the API difficult to use.
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Message-ID: <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.is=
aku.yamahata@intel.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/mmu.h     |  3 +++
> >  arch/x86/kvm/mmu/mmu.c | 32 ++++++++++++++++++++++++++++++++
> >  2 files changed, 35 insertions(+)
> >
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index e8b620a85627..51ff4f67e115 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -183,6 +183,9 @@ static inline void kvm_mmu_refresh_passthrough_bits=
(struct kvm_vcpu *vcpu,
> >       __kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
> >  }
> >
> > +int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> > +                  u8 *level);
> > +
> >  /*
> >   * Check if a given access (described through the I/D, W/R and U/S bit=
s of a
> >   * page fault error code pfec) causes a permission fault with the give=
n PTE
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 7fbcfc97edcc..fb2149d16f8d 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4646,6 +4646,38 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, st=
ruct kvm_page_fault *fault)
> >       return direct_page_fault(vcpu, fault);
> >  }
> >
> > +int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> > +                  u8 *level)
>
> If the return is an overloaded "long", then there's no need for @level, i=
.e. do
> the level=3D>size conversion in this helper.
>
> > +{
> > +     int r;
> > +
> > +     /* Restrict to TDP page fault. */
>
> Do we want to restrict this to the TDP MMU?  Not for any particular reaso=
n, mostly
> just to keep moving towards officially deprecating/removing TDP support f=
rom the
> shadow MMU.

Heh, yet another thing I briefly thought about while reviewing Isaku's
work. In the end I decided that, with the implementation being just a
regular prefault, there's not much to save from keeping the shadow MMU
away from this.

The real ugly part is that if the memslots are zapped the
pre-population effect basically goes away (damn
kvm_arch_flush_shadow_memslot). This is the reason why I initially
thought of KVM_CHECK_EXTENSION for the VM file descriptor, to only
allow this for TDX VMs.

The real solution for this is to not "graduate" this ioctl too soon to
kvm/next. Let's keep it in kvm-coco-queue until TDX is ready and then
make a final decision.

Paolo

> > +     if (vcpu->arch.mmu->page_fault !=3D kvm_tdp_page_fault)
> > +             return -EOPNOTSUPP;
> > +
> > +     r =3D __kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, =
level);
> > +     if (r < 0)
> > +             return r;
> > +
> > +     switch (r) {
> > +     case RET_PF_RETRY:
> > +             return -EAGAIN;
> > +
> > +     case RET_PF_FIXED:
> > +     case RET_PF_SPURIOUS:
> > +             return 0;
>
> Going with the "long" idea, this becomes:
>
>                 end =3D (gpa & KVM_HPAGE_MASK(level)) + KVM_HPAGE_SIZE(le=
vel);
>                 return min(size, end - gpa);
>
> though I would vote for a:
>
>                 break;
>
> so that the happy path is nicely isolated at the end of the function.
>
> > +
> > +     case RET_PF_EMULATE:
> > +             return -EINVAL;
> > +
> > +     case RET_PF_CONTINUE:
> > +     case RET_PF_INVALID:
> > +     default:
> > +             WARN_ON_ONCE(r);
> > +             return -EIO;
> > +     }
> > +}
> > +
> >  static void nonpaging_init_context(struct kvm_mmu *context)
> >  {
> >       context->page_fault =3D nonpaging_page_fault;
> > --
> > 2.43.0
> >
> >
>


