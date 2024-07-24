Return-Path: <kvm+bounces-22199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8918E93B6BC
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 20:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D68928519A
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 18:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2891F15FA9E;
	Wed, 24 Jul 2024 18:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hkJGpdxf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F0C481CE
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 18:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721846105; cv=none; b=OGr5KlpYgZNYAHPyFjHAmjGypBc42CdWWx2Ilw6WcRWPYRuXqLRK5ewLDTqz3XmdRc39Rs560Lz/dbl+5Gg0OkNLvsz6XqkgEaE1nw70YxH+51fwbS7NnLJp3f44KQyi0pO/wXcrAq+OcbPF9t8k8pA5yVLz4S0GVFGkxOlL3+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721846105; c=relaxed/simple;
	bh=2k36nOH0KahBlvPaNnQCzMsFKIRzCtEqH5ZbimLN+60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xi7aZ1ryAjl2AANbdgAbrsXXmn+Zx+BhI0YIP0JwkWcspddo/uZzo5QSoECBMSWmG2vhHNLsRkL5X2XvBg80IYrgiObo0xDqBaiOMsoSYio79kqMS1Dt0/6/I9px7y2vIwFA3JIey3NospkSAtp9LRG5YbNoFGk3ZaYUjHcaoLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hkJGpdxf; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3993fddea13so16925ab.1
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 11:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721846103; x=1722450903; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUnI5rcxEbevGzzOh5jPOLZwixbNr1iEK4eOg2OXtto=;
        b=hkJGpdxfG4OV3CDcucv5mTJrAJuPXADcl3eZrKyxDWcqZY4sOYN+4HpNbeBVGQ6Hv8
         egNn/yoAwyI8uoW87K1/+nOtrC/nKo+wlVPAObUXcOwFOJ0bN4hmVB1nLGkCHZUBm1Sb
         KemFz5AvsiXFLLI2BgzEz8238xJOPThaHQSLiYijMTWy+Jkk4/PDPN+/H+SMHgT3OueX
         DRxUjnYPa+t8ZcK+tfMfMvBDjrj2HXkwHHocSGEO9/v8U1rH/4egCevbe7K9Q3E/NKhL
         4P5udf555SVu5bTcYblDzdQ1k7oQsH6yOSsGfH0TWlKrS95nTi+zlHbXM+OQmt6elMdk
         4U8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721846103; x=1722450903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qUnI5rcxEbevGzzOh5jPOLZwixbNr1iEK4eOg2OXtto=;
        b=EYFpe3T/AMidnBqxBVrtuL874VgaN4iAHVshUP06ghAV4oxlo2Xwlv/7VXw8oyjdO7
         xk1OZO0+yIZq5tX0wkkbfyI7Hv0uVwd6GhQ5DFo+Kc+km1SV4W7kpNkKEhujB1YsytWa
         8WEYWVxC9JyEQPZdU6nDVxoT6Lmv39Wrj12IXyJnheR3vat91MxrgO6/t20LaXt0tVxl
         XwTIJXZ/2IypR5K9N5qmyDxVoELLS17KDJ1PhMfCDKiZd2Pc3uxWLxv9UMBoNCwlEUfE
         To5sIE0Ks0u6pdzedk6pJS/eifQNnby1HovClm3JnGxJ47jLzfcvQafyZRcK3gIlFTBq
         1hqg==
X-Forwarded-Encrypted: i=1; AJvYcCUfFdcSRfRF0PaKPvspOq0MyS9zqjT3bDMFco3e/EqUfomNCjcXTautkkB5KAmqS8aFZB8Kxa18uQP8+JmsnOqb86mj
X-Gm-Message-State: AOJu0YzxFP5xQSNZSkL3iUVAHNO+U6neOc7NWib6Rzc7Yqq36dxGweA8
	sWMATO2lO3FV4CpoqTWvVI7AVXnKW/AagWHgN/5Lq1rNCPYP4EcC+pSS1QonsGBGD6x6NFn1t0h
	eaG53/dICGtXcDARPMP5dLtfB4i1XuEJNvTOr
X-Google-Smtp-Source: AGHT+IFj1z2KuSefCJduUXgXHn8NSMFVxbRF/VZQH3C8K7QIoAOflStB4e5lQL3sWJzIpP080cyuCdZoBmY+B4aZ2eg=
X-Received: by 2002:a05:6e02:b4b:b0:377:15c7:1aa0 with SMTP id
 e9e14a558f8ab-39a22563f19mr310685ab.25.1721846102781; Wed, 24 Jul 2024
 11:35:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625235554.2576349-1-jmattson@google.com> <CALMp9eSTsGaAcEKkJ+=vWD4aHC3e_iOA8nnwWhGQdfBj_nj3-A@mail.gmail.com>
 <323bf4cc39f3e4dd3b95e0e25de35a7c0c2e9d2d.camel@redhat.com>
In-Reply-To: <323bf4cc39f3e4dd3b95e0e25de35a7c0c2e9d2d.camel@redhat.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 24 Jul 2024 11:34:51 -0700
Message-ID: <CALMp9eRmL_7xdK11dsC-yapd29d+6121tWu7sdLnTmHiEEBsdA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Complain about an attempt to change the APIC
 base address
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2024 at 11:13=E2=80=AFAM Maxim Levitsky <mlevitsk@redhat.co=
m> wrote:
>
> On Wed, 2024-07-24 at 11:05 -0700, Jim Mattson wrote:
> > On Tue, Jun 25, 2024 at 4:56=E2=80=AFPM Jim Mattson <jmattson@google.co=
m> wrote:
> > > KVM does not support changing the APIC's base address. Prior to commi=
t
> > > 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or
> > > APIC base"), it emitted a rate-limited warning about this. Now, it's
> > > just silently broken.
> > >
> > > Use vcpu_unimpl() to complain about this unsupported operation. Even =
a
> > > rate-limited error message is better than complete silence.
> > >
> > > Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC=
 ID or APIC base")
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > ---
> > >  Changes in v2:
> > >   * Changed format specifiers from "%#llx" to "%#x"
> > >   * Cast apic->base_address to unsigned int for printing
> > >
> > >  arch/x86/kvm/lapic.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index acd7d48100a1..43ac05d10b2e 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -2583,6 +2583,9 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, =
u64 value)
> > >
> > >         if ((value & MSR_IA32_APICBASE_ENABLE) &&
> > >              apic->base_address !=3D APIC_DEFAULT_PHYS_BASE) {
> > > +               vcpu_unimpl(vcpu, "APIC base %#x is not %#x",
> > > +                           (unsigned int)apic->base_address,
> > > +                           APIC_DEFAULT_PHYS_BASE);
> > >                 kvm_set_apicv_inhibit(apic->vcpu->kvm,
> > >                                       APICV_INHIBIT_REASON_APIC_BASE_=
MODIFIED);
> > >         }
> > > --
> > > 2.45.2.741.gdbec12cfda-goog
> >
> > Ping.
> >
> I think that we talked about this once, that nobody looks at these dmesg =
warnings,
> its just a way for a malicious guest to fill up the host log (yes rate li=
mit helps,
> but slowly you can still fill it up),
> but if you think that this is valuable, I am not against putting it back.

Funny that you mention this. I'm about to send out another change to
curtail some ratelimited spam that *quickly* fills up the host log.

> I wonder....
>
> What if we introduce a new KVM capability, say CAP_DISABLE_UNSUPPORTED_FE=
ATURES,
> and when enabled, outright crash the guest when it attempts things like c=
hanging APIC base,
> APIC IDs, and other unsupported things like that?
>
> Then we can make qemu set it by default, and if users have to use an unsu=
pported feature,
> they could always add a qemu flag that will disable this capability.

Alternatively, why not devise a way to inform userspace that the guest
has exercised an unsupported feature? Unless you're a hobbyist working
on your desktop, kernel messages are a *terrible* mechanism for
communicating with the end user.

> Best regards,
>         Maxim Levitsky
>

