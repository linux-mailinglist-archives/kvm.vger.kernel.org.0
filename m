Return-Path: <kvm+bounces-23262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C12FA948537
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D397BB224A1
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 22:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EACEF16D9DD;
	Mon,  5 Aug 2024 22:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z2383hP5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B174C13AA3F
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 22:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722895259; cv=none; b=fzTzU2lV0ZVlzrEP28q0McYXZKiWcHHBcEBmPiCfVeoxQ3CWzY0d8kMJKAdfBhlUs5SxLac3+khRqUCG0Iq6vs8fOlOPWL1NLcLSMXCINZBVzFBP4fqakE2s/bSFSHsP88E6GXj8st5/rmvdhnZvQl8EpRei6L32hqb2wASMn/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722895259; c=relaxed/simple;
	bh=5xlLoWgZmxPyqhkhXV+nnKSPg7jlvWHbZj6XV6mqmHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HweuxEj9QJDrR8RnnTC2WqTZKBCBBP8plKtnbRx9SXPzX7OKpV7jPLyymP4BCV9kYZJMPkcBHSdJXE5sOHEIQa2Flzb8HKJgOBAgHK7Lau5LxGba9ktwXCf1mPV1bQCT6dGL15q52smsb4fttBNfncIxM6MqXfCvHTq11HDQ0mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z2383hP5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70e910f309eso12443346b3a.3
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 15:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722895257; x=1723500057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=frZl7v/NXmkLyhBPtTem6pampc1hUciwUVTTgdKJJUg=;
        b=z2383hP5O6Crp3Es4YCibSPYAZfcdMNJRwojbxS/lGHQtRUIqXK63d+6qgUWCR/OkH
         ZjI2M3WKwEYJGzy6spIDjvxMdDtj365gzqmh6aoHcJ+MEUL4u7hg8J5J5uKRctfpzoGu
         +afftNYfeIgWrkRdEixGJ5YHVRmuaSVnHptmmtXLQWyPC9m7fUDqMCciNaufjp5KZ31p
         blnr21Av0q8pS7Y71/V9TyTnTtv52GbENwUNGmSOSXipMpBHUm9VEtU0tsq6HjDJ3EKO
         2138bSRVmalnKHo+pKnjIKAHqPc8nu5eU5ir0Wt3wSBb9MrLwIQzuFnkHzFD3e2btSo2
         ywnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722895257; x=1723500057;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=frZl7v/NXmkLyhBPtTem6pampc1hUciwUVTTgdKJJUg=;
        b=q8elG7K+fhehCiFkA9kGmWfykUlCbD17uywcZOWiCXjNRA4jQplV1mtsSr7S+b9tpc
         DEFsMsv/RkU/vd85wgIPdGznUMKGERqZbse3U37ZG61NF12906vlX6VMwyFuUq+aQZf7
         HrflB9zhdOV1QedgMZ+tAGY6IeDZZVvBbS/Mj8Q9CU1UJc9nM0pDUzKm4Y0ObBN6wTQ1
         OdjB+YgwTTW/ssST8bDY8hSxZIIsh5gY1oz543/5UGeur15QGs/nerMC7sE9YpA8vz/F
         7eY6lXE6TjjQ3EJ1QMUHlfnJOuhWrNXmw9ACS6Y+TVP2Jq8Wf/6Ldv4+ZPMHRWLbIudx
         ZFfg==
X-Forwarded-Encrypted: i=1; AJvYcCXEP7VZq99g2/TpRDttra66IajXpuhz5LQkbMo9RqIB/Sf+dcj4ODjDIhFI5+J9MfJCTLygmrEbgzt53IqjmMTmJK/1
X-Gm-Message-State: AOJu0YwCdincpi6MXeQBSUaSZwDAnOuCfjRi82eKd0V6DixVRPW3KsRr
	3ALl4ndND/CiLGH4P9DsSedhhw+HA7ObYQAW+ambUUsy6jN5JavjgHu06raP0kx/eFA+pgbQPSj
	zuQ==
X-Google-Smtp-Source: AGHT+IEq2uEQ7m2oAnxpoUGgbDV8nJjTFwAlXZT8mynpkOSTGnW/28cQTtQ3EVCrKg+U04tve8R4dYDaYpQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f5b:b0:70d:352f:585b with SMTP id
 d2e1a72fcca58-7106d0a8458mr260354b3a.6.1722895256844; Mon, 05 Aug 2024
 15:00:56 -0700 (PDT)
Date: Mon, 5 Aug 2024 15:00:55 -0700
In-Reply-To: <8f35b524cda53aff29a9389c79742fc14f77ec68.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-23-seanjc@google.com>
 <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
 <ZoxVa55MIbAz-WnM@google.com> <3da2be9507058a15578b5f736bc179dc3b5e970f.camel@redhat.com>
 <ZqKb_JJlUED5JUHP@google.com> <8f35b524cda53aff29a9389c79742fc14f77ec68.camel@redhat.com>
Message-ID: <ZrFLlxvUs86nqDqG@google.com>
Subject: Re: [PATCH v2 22/49] KVM: x86: Add a macro to precisely handle
 aliased 0x1.EDX CPUID features
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 05, 2024, mlevitsk@redhat.com wrote:
> =D0=A3 =D1=87=D1=82, 2024-07-25 =D1=83 11:39 -0700, Sean Christopherson =
=D0=BF=D0=B8=D1=88=D0=B5:
> > > On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> > > > > On Mon, 2024-07-08 at 14:08 -0700, Sean Christopherson wrote:
> > > > > > > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > > > > > > > What if we defined the aliased features instead.
> > > > > > > > > Something like this:
> > > > > > > > >=20
> > > > > > > > > #define __X86_FEATURE_8000_0001_ALIAS(feature) \
> > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(feature =
+ (CPUID_8000_0001_EDX - CPUID_1_EDX) * 32)
> > > > > > > > >=20
> > > > > > > > > #define KVM_X86_FEATURE_FPU_ALIAS=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_FPU)
> > > > > > > > > #define KVM_X86_FEATURE_VME_ALIAS=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_VME)
> > > > > > > > >=20
> > > > > > > > > And then just use for example the 'F(FPU_ALIAS)' in the C=
PUID_8000_0001_EDX
> > > > > > >=20
> > > > > > > At first glance, I really liked this idea, but after working =
through the
> > > > > > > ramifications, I think I prefer "converting" the flag when pa=
ssing it to
> > > > > > > kvm_cpu_cap_init().=C2=A0 In-place conversion makes it all bu=
t impossible for KVM to
> > > > > > > check the alias, e.g. via guest_cpu_cap_has(), especially sin=
ce the AF() macro
> > > > > > > doesn't set the bits in kvm_known_cpu_caps (if/when a non-hac=
ky validation of
> > > > > > > usage becomes reality).
> > > > >=20
> > > > > Could you elaborate on this as well?
> > > > >=20
> > > > > My suggestion was that we can just treat aliases as completely in=
dependent
> > > > > and dummy features, say KVM_X86_FEATURE_FPU_ALIAS, and pass them =
as is to the
> > > > > guest, which means that if an alias is present in host cpuid, it =
appears in
> > > > > kvm caps, and thus qemu can then set it in guest cpuid.
> > > > >=20
> > > > > I don't think that we need any special treatment for them if you =
look at it
> > > > > this way.=C2=A0 If you don't agree, can you give me an example?
> > >=20
> > > KVM doesn't honor the aliases beyond telling userspace they can be se=
t (see below
> > > for all the aliased features that KVM _should_ be checking).=C2=A0 Th=
e APM clearly
> > > states that the features are the same as their CPUID.0x1 counterparts=
, but Intel
> > > CPUs don't support the aliases.=C2=A0 So, as you also note below, I t=
hink we could
> > > unequivocally say that enumerating the aliases but not the "real" fea=
tures is a
> > > bogus CPUID model, but we can't say the opposite, i.e. the real featu=
res can
> > > exists without the aliases.
> > >=20
> > > And that means that KVM must never query the aliases, e.g. should nev=
er do
> > > guest_cpu_cap_has(KVM_X86_FEATURE_FPU_ALIAS), because the result is e=
ssentially
> > > meaningless.=C2=A0 It's a small thing, but if KVM_X86_FEATURE_FPU_ALI=
AS simply doesn't
> > > exist, i.e. we do in-place conversion, then it's impossible to feed t=
he aliases
> > > into things like guest_cpu_cap_has().
>=20
> This only makes my case stronger - treating the aliases as just features =
will
> allow us to avoid adding more logic to code which is already too complex =
IMHO.
>=20
> If your concern is that features could be queried by guest_cpu_cap_has()
> that is easy to fix, we can (and should) put them into a separate file an=
d
> #include them only in cpuid.c.
>=20
> We can even #undef the __X86_FEATURE_8000_0001_ALIAS macro after the kvm_=
set_cpu_caps,
> then if I understand the macro pre-processor correctly, any use of featur=
e alias
> macros will not fully evaluate and cause a compile error.

I don't see how that's less code.  Either way, KVM needs a macro to handle =
aliases,
e.g. either we end up with ALIAS_F() or __X86_FEATURE_8000_0001_ALIAS().  F=
or the
macros themselves, IMO they carry the same amount of complexity.

If we go with ALIASED_F() (or ALIASED_8000_0001_F()), then that macro is al=
l that
is needed, and it's bulletproof.  E.g. there is no KVM_X86_FEATURE_FPU_ALIA=
S that
can be queried, and thus no need to be ensure it's defined in cpuid.c and #=
undef'd
after its use.

Hmm, I supposed we could harden the aliased feature usage in the same way a=
s the
ALIASED_F(), e.g.

  #define __X86_FEATURE_8000_0001_ALIAS(feature)				\
  ({										\
	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) !=3D CPUID_1_EDX);	\
	BUILD_BUG_ON(kvm_cpu_cap_init_in_progress !=3D CPUID_8000_0001_EDX);	\
	(feature + (CPUID_8000_0001_EDX - CPUID_1_EDX) * 32);			\
  })

If something tries to use an X86_FEATURE_*_ALIAS outside if kvm_cpu_cap_ini=
t(),
it would need to define and set kvm_cpu_cap_init_in_progress, i.e. would re=
ally
have to try to mess up.

Effectively the only differences are that KVM would have ~10 or so more lin=
es of
code to define the X86_FEATURE_*_ALIAS macros, and that the usage would loo=
k like:

	VIRTUALIZED_F(FPU_ALIAS)

versus

	ALIASED_F(FPU)

At that point, I'm ok with defining each alias, though I honestly still don=
't
understand the motivation for defining single-use macros.

