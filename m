Return-Path: <kvm+bounces-48034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B94B1AC84D1
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82028A2020F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F98F22D9F4;
	Thu, 29 May 2025 23:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zW94CmwE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E053221D584
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748560091; cv=none; b=qmc0wtdpYEFY4w/QsXZqYg8SrZQy+/YN1IZNIQudgieyj1lszEunDjFM6zXeIrad+JGl3ULBXz1RnWHpBom5ihG2hMb7q7M4hxZ7u3FRb6GMJm840mJadU2yOT+sQNl48llyvpqOzkqAgSDRYTje1OWFa5IGvTxpcwAYZt0NejY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748560091; c=relaxed/simple;
	bh=Ga4ixeHjWc0kl5EHrAQUHylI16bJElehK1WrCsTnH38=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nfLzPCUkX9vMvOFKJZKfMoAHEO1+kNpNbUgPT7ADWg33yZ7x2bRiqZu4IB88Zn1MfMPIzAXmgH9VwuUL+DiEgmG1k4knm83WQ2fxIbnhOkOlvWgnYyH221fFW2l92O3rIm1Dc8a6NfkcLnLVhKo3iIXOCs7q8mY7LcQVw0uLaeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zW94CmwE; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7401179b06fso1079151b3a.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748560089; x=1749164889; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WWQT92vYYiaC+lxmNKagAXWxRs8ao22U9MaAqLN+cH4=;
        b=zW94CmwEubGV1ZKeyaorWKjffjDpZSGa8hzyw767n3DW2hsqHLgBN/ESh3SAEM5u/S
         mxYEKXp8En1dvo7KZhjPfqEDoQuEiwgtNwFvybWqbs/qNz6U9tf/3iSaI/TlyOWcaUSs
         I1EuVWrwWdnFMz/bffe4WASpq8plE4KglJ8qZxu7oSYKWCQfaUwJ51RuHClYY2Nxwcf9
         8620HaZWOx09SfYI37z02ULzbJRrIxo4pLxCU11pO49Qjh7kiJ5k8eLHm3j761QLpAAR
         liW8Jc8XweqvM4iFlNphtCJQRQ3bZ7MdXdOiNG3XcYbvKQpckxW1fbxcV7OaK1eALLVX
         fahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748560089; x=1749164889;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WWQT92vYYiaC+lxmNKagAXWxRs8ao22U9MaAqLN+cH4=;
        b=M0gH14qdpfy/Rr4nNeXjR+YCsrIXBesC1CHQ4qGVeaOOTSUyjm0gjvbZm5kAJ4kboG
         r8WzCyF/eNJ9sDdJ9zJtI0MVWKiADniwZe99GyDb2FotfrWC8zo2gD4+gUQk67tJsdTE
         Ynl2qVk1TZTOg9o3akLVGANsdry+gNBVUX5YNIDQIWHpSP41gbICrV/Ad83GMfPjYzhe
         GJ7U2WzveNlo8DiL+DjwU16uVssqbRmGbyBQd0R1YLh2trwuyY6oDP+5ZJLFs7fPQOqg
         ewraEWkiUHkWadJazAqI1O78WkefNWX6X3ZeXOlFNjoM47ig5HsflLoBQ/o7J2/y55A0
         VIVw==
X-Gm-Message-State: AOJu0YyB9p2Z+h5wIIq/4WguFwOqGY8vCTNVEEwX7P6HEuVed4M44Au7
	QhJ9Rsdj6r7BO/FAaoyAnzOIVKYQr6H7GqmkQ0807OweSq5d5+Syqv3Fmx55YVJWiKVVobbJ3Y1
	UfVFpzw==
X-Google-Smtp-Source: AGHT+IFyNnF3N9qo+8t5isM7o5tVxkSUB9ncohiiPZsNdoq3EI2z81ANG4JC82ouNV+RJVlSKp7aEnxQiq0=
X-Received: from pfbhb7.prod.google.com ([2002:a05:6a00:8587:b0:746:2d5e:7936])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b43:b0:742:a4e0:6476
 with SMTP id d2e1a72fcca58-747bd954bd2mr1627939b3a.4.1748560088942; Thu, 29
 May 2025 16:08:08 -0700 (PDT)
Date: Thu, 29 May 2025 16:08:07 -0700
In-Reply-To: <58a580b0f3274f6a7bba8431b2a6e6fef152b237.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com> <20250519232808.2745331-12-seanjc@google.com>
 <d131524927ffe1ec70300296343acdebd31c35b3.camel@intel.com>
 <019c1023c26e827dc538f24d885ec9a8530ad4af.camel@intel.com>
 <aDhvs1tXH6pv8MxN@google.com> <58a580b0f3274f6a7bba8431b2a6e6fef152b237.camel@intel.com>
Message-ID: <aDjo16EcJiWx9Nfa@google.com>
Subject: Re: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2025, Kai Huang wrote:
> On Thu, 2025-05-29 at 07:31 -0700, Sean Christopherson wrote:
> > On Thu, May 29, 2025, Kai Huang wrote:
> > > On Thu, 2025-05-29 at 23:55 +1200, Kai Huang wrote:
> > > > On Mon, 2025-05-19 at 16:28 -0700, Sean Christopherson wrote:
> > > > > Add a Kconfig to allowing building KVM without support for emulat=
ing an
> > > > 		   ^
> > > > 		   allow
> > > >=20
> > > > > I/O APIC, PIC, and PIT, which is desirable for deployments that e=
ffectively
> > > > > don't support a fully in-kernel IRQ chip, i.e. never expect any V=
MM to
> > > > > create an in-kernel I/O APIC. =C2=A0
> > > >=20
> > > > Do you happen to know what developments don't support a full in-ker=
nel IRQ chip?
> >=20
> > Google Cloud, for one.  I suspect/assume many/most CSPs don't utilize a=
n in-kernel
> > I/O APIC.
> >=20
> > > > Do they only support userspace IRQ chip, or not support any IRQ chi=
p at all?
> >=20
> > The former, only userspace I/O APIC (and associated devices), though so=
me VM
> > shapes, e.g. TDX, don't provide an I/O APIC or PIC.
>=20
> Thanks for the info.
>=20
> Just wondering what's the benefit of using userspace IRQCHIP instead of
> emulating in the kernel?

Reduced kernel attack surface (this was especially true years ago, before K=
VM's
I/O APIC emulation was well-tested) and more flexibility (e.g. shipping use=
rspace
changes is typically easier than shipping new kernels.  I'm pretty sure the=
re's
one more big one that I'm blanking on at the moment.

> I thought one should either use in-kernel IRQCHIP or doesn't use any.
>=20
> >=20
> > > Forgot to ask:
> > >=20
> > > Since this new Kconfig option is not only for IOAPIC but also include=
s PIC and
> > > PIT, is CONFIG_KVM_IRQCHIP a better name?
> >=20
> > I much prefer IOAPIC, because IRQCHIP is far too ambiguous and confusin=
g, e.g.
> > just look at KVM's internal APIs, where these:
> >=20
> >   irqchip_in_kernel()
> >   irqchip_kernel()
> >=20
> > are not equivalent.  In practice, no modern guest kernel is going to ut=
ilize the
> > PIC, and the PIT isn't an IRQ chip, i.e. isn't strictly covered by IRQC=
HIP either.
>=20
> Right.
>=20
> Maybe it is worth to further have dedicated Kconfig for PIC, PIT and IOAP=
IC?

Nah.  PIC and I/O APIC can't be split (without new uAPI and non-trivial com=
plexity),
and I highly doubt there is any use case that would want an in-kernel I/O A=
PIC
with a userspace PIT.  I.e. in practice, the threealmost always come as a g=
roup;
either a setup wants all, or a setup wants none.

> But hmm, I am not sure whether emulating IOAPIC has more value than PIC.

AIUI, it's not really an either or, since most software expects both an I/O=
 APIC
and PIC.  Any remotely modern kernel will definitely prefer the I/O APIC, b=
ut I
don't think it's something that can be guaranteed.

> For modern guests all emulated/assigned devices should just use MSI/MSI-X=
?

Not all emulated devices, since some legacy hang off the I/O APIC, i.e. are=
n't
capable of generating MISs.

> > So I think/hope the vast majority of users/readers will be able to intu=
it that
> > CONFIG_KVM_IOAPIC also covers the PIC and PIT.
>=20
> Sure.
>=20
> Btw, I also find irqchip_in_kernel() and irqchip_kernel() confusing.  I a=
m not
> sure the value of having irqchip_in_kernel() in fact.  The guest should a=
lways
> have an in-kernel APIC for modern guests.  I am wondering whether we can =
get rid
> of it completely (the logic will be it is always be true), or we can have=
 a
> Kconfig to only build it when user truly wants it.

For better or worse, an in-kernel local APIC is still optional.  I do hope/=
want
to make it mandatory, but that's not a small ABI change.

