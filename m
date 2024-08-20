Return-Path: <kvm+bounces-24624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8469586A2
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 14:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8E45B23A98
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB0418F2FC;
	Tue, 20 Aug 2024 12:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D5tKL1NT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD2818A6BC
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 12:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724155992; cv=none; b=GcjIk09TzLsSmUfF1lDKpyRPIgQhOLH1cMNFedMIfDW2Zmm8ko6NCPZE+xmg52Q8Lr4NdBzSlmKHO4XmoB98d/6HsqhDRDf7ZzTlSA9F9ao5FvFWwknZ7md4SffYUlwsbgGBmiqhg8X8c8sPiY0lQlOQLfv8OeP06WWKi5fQz38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724155992; c=relaxed/simple;
	bh=CoUJSJEOY+AD70nQdwXhTuAMdIpi3c3yBUXbO52Nu8w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kGQ1bXndaGkFra7Dbxt/mlSTbVL2tN2xRs5ar5hmam8D8uUqL2wIWD1UxJ7voVYsr4zkmIldl5WmyI+WL+M6+rheKcIfpbmYu9xUJw/nMxCXZhB3gIBT5TnK8POC6o5Rsg0G9L1cLiNDsYQwwzfe1iuDSDkIGgTHw/NsuHG5qog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D5tKL1NT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724155990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vb++bCC8FYQ7kr3j17L2pvrqNCN0LH413bDrfxJr0Ms=;
	b=D5tKL1NT3zm1xp75vXzNlhaTSwj8XVuPNQaJm+wO8nz7Qdc9lNxglYmGcd4Ig48HxPsZo8
	3O2ag8vrV/mMHzBHIrZUwzcNu1aGLX8XYXBkmSF5lnHkCQS5h927FRZNskiZGZzY7Z0Xzd
	JVHxkzq9hr6vTBqn7VduTx2N3CnhKFg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-5B4J-AFWNOWW3usyb2ChcQ-1; Tue, 20 Aug 2024 08:13:08 -0400
X-MC-Unique: 5B4J-AFWNOWW3usyb2ChcQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4281ca9f4dbso47385255e9.0
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 05:13:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724155987; x=1724760787;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vb++bCC8FYQ7kr3j17L2pvrqNCN0LH413bDrfxJr0Ms=;
        b=KIfRiOCasq/AOU2Wdc6b781XoZMoIvPmBRJ8tJ9HdSRmh0yyeN2Df3dH7NdPXXJYGG
         QeCH3CJcQYykI7fbtq5abI38hItnntKLof+xmxrJRnQ/X+upjnolkBhgk0lmgyUTH9MS
         +nx3SahNn44aS1XUD3QVRE28f5uKgOWI02CCSotTQqdsD5HM4AFS25qtwvSL+le0e+gf
         DahB4e5QwfP+6xexJMOHTvw0cnIk/VPEJYZkroWnqz04Vu5vaJcL2ucULKBQRDlUvPvy
         ePpeE//4gPES9JOUIHXc2OdvrWMfbSM3WmuxkENSEXIMXJo3zQFkAWOZz7zEgL3RHPP9
         XpgA==
X-Gm-Message-State: AOJu0Yzw2Zfp6VJt0owYlID+q2BLHxWHE8irulPLlf6sgxDvIWq3754m
	FVLIkwez8yaq8Rb1vE8lmkDwasU82Ym/uaMKDU0CrKpnWXBH0ioH7sd8L4oPKw1kPOyDdMRTUhW
	Gx/gZamozodm6X6OyMpxfbVzxNX+KixIzq6EL2Zp0HwfdarQzrQ==
X-Received: by 2002:a05:600c:3047:b0:426:8884:2c54 with SMTP id 5b1f17b1804b1-42a6e08e134mr71252375e9.35.1724155987446;
        Tue, 20 Aug 2024 05:13:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHiA+dVXDpiOyzS3SSDsVNVQZAM6GV5dwzSOz0YEVlKtnCtAG9mpX45+Hon7C9AbLlil0KY3w==
X-Received: by 2002:a05:600c:3047:b0:426:8884:2c54 with SMTP id 5b1f17b1804b1-42a6e08e134mr71252105e9.35.1724155986893;
        Tue, 20 Aug 2024 05:13:06 -0700 (PDT)
Received: from intellaptop.lan ([2a06:c701:77ab:3101:d6e6:2b8f:46b:7344])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ed649004sm141914785e9.4.2024.08.20.05.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 05:13:06 -0700 (PDT)
Message-ID: <fa69866979cdb8ad445d0dffe98d6158288af339.camel@redhat.com>
Subject: Re: [PATCH v3 1/4] KVM: x86: relax canonical check for some x86
 architectural msrs
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Chao Gao
 <chao.gao@intel.com>
Date: Tue, 20 Aug 2024 15:13:04 +0300
In-Reply-To: <Zr_JX1z8xWNAxHmz@google.com>
References: <20240815123349.729017-1-mlevitsk@redhat.com>
	 <20240815123349.729017-2-mlevitsk@redhat.com> <Zr_JX1z8xWNAxHmz@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

=D0=A3 =D0=BF=D1=82, 2024-08-16 =D1=83 14:49 -0700, Sean Christopherson =D0=
=BF=D0=B8=D1=88=D0=B5:
> > > > On Thu, Aug 15, 2024, Maxim Levitsky wrote:
> > > > > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > > > > index ce7c00894f32..2e83f7d74591 100644
> > > > > > > > --- a/arch/x86/kvm/x86.c
> > > > > > > > +++ b/arch/x86/kvm/x86.c
> > > > > > > > @@ -302,6 +302,31 @@ const struct kvm_stats_header kvm_vcpu=
_stats_header =3D {
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 sizeof(kvm_vcpu_stats_desc),
> > > > > > > > =C2=A0};
> > > > > > > > =C2=A0
> > > > > > > > +
> > > > > > > > +/*
> > > > > > > > + * Most x86 arch MSR values which contain linear addresses=
 like
> > > >=20
> > > > Is it most, or all?=C2=A0 I'm guessing all?

I can't be sure that all of them are like that - there could be some outlie=
rs that behave differently.

One of the things my work at Intel taught me is that there is nothing consi=
stent
in x86 spec, anything is possible and nothing can be assumed.

I dealt only with those msrs, that KVM checks for canonicality, therefore I=
 use the word=C2=A0
'most'. There could be other msrs that are not known to me and/or to KVM.

I can write 'some' if you prefer.

> > > >=20
> > > > > > > > + * segment bases, addresses that are used in instructions =
(e.g SYSENTER),
> > > > > > > > + * have static canonicality checks,
> > > >=20
> > > > Weird and early line breaks.
> > > >=20
> > > > How about this?
> > > >=20
> > > > /*
> > > > =C2=A0* The canonicality checks for MSRs that hold linear addresses=
, e.g. segment
> > > > =C2=A0* bases, SYSENTER targets, etc., are static, in the sense tha=
t they are based
> > > > =C2=A0* on CPU _support_ for 5-level paging, not the state of CR4.L=
A57.
> > > >=20
> > > > > > > > + * size of whose depends only on CPU's support for 5-level
> > > > > > > > + * paging, rather than state of CR4.LA57.
> > > > > > > > + *
> > > > > > > > + * In addition to that, some of these MSRS are directly pa=
ssed
> > > > > > > > + * to the guest (e.g MSR_KERNEL_GS_BASE) thus even if the =
guest
> > > > > > > > + * doen't have LA57 enabled in its CPUID, for consistency =
with
> > > > > > > > + * CPUs' ucode, it is better to pivot the check around hos=
t
> > > > > > > > + * support for 5 level paging.
> > > >=20
> > > > I think we should elaborate on why it's better.=C2=A0 It only takes=
 another line or
> > > > two, and that way we don't forget the edge cases that make properly=
 emulating
> > > > guest CPUID a bad idea.

OK, will do.

> > > >=20
> > > > =C2=A0* This creates a virtualization hole where a guest writes to =
passthrough MSRs
> > > > =C2=A0* may incorrectly succeed if the CPU supports LA57, but the v=
CPU does not
> > > > =C2=A0* (because hardware has no awareness of guest CPUID).=C2=A0 D=
o not try to plug this
> > > > =C2=A0* hole, i.e. emulate the behavior for intercepted accesses, a=
s injecting #GP
> > > > =C2=A0* depending on whether or not KVM happens to emulate a WRMSR =
would result in
> > > > =C2=A0* non-deterministic behavior, and could even allow L2 to cras=
h L1, e.g. if L1
> > > > =C2=A0* passes through an MSR to L2, and then tries to save+restore=
 L2's value.
> > > > =C2=A0*/
> > > >=20
> > > > > > > > +
> > > > > > > > +static u8=C2=A0 max_host_supported_virt_addr_bits(void)
> > > >=20
> > > > Any objection to dropping the "supported", i.e. going with max_host=
_virt_addr_bits()?
> > > > Mostly to shorten the name, but also because "supported" suggests t=
here's software
> > > > involvement, e.g. the max supported by the kernel/KVM, which isn't =
the case.

Doesn't matter to me.

> > > >=20
> > > > If you're ok with the above, I'll fixup when applying.
> > > >=20

Best regards,
   Maxim Levitsky


