Return-Path: <kvm+bounces-65119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 563D0C9C000
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 16:42:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C96B3A5E37
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 15:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECE52BE020;
	Tue,  2 Dec 2025 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZB5K+anm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3132E27700D
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 15:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764690156; cv=none; b=ozJee4OL+7a4QPV+mt4DNHrj9sNRQfMgERQd4YWzoI+w4lVcLK4mUfF5WrqE7sqC7YG08E3yA6tqYYzdkRmCOyAU0AlL1Km129luvRD+9U9MtEDPiS8xP4HArb2NmjGdy79icu++6/liWaxy4lBaZxvF2YrL/g4daaqQ6jE+0U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764690156; c=relaxed/simple;
	bh=DqlNcYHT1cLxMDHQ5KVjYxLZbA4r6B8CjVwcad5T8FQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F72G0ZlenC8SUWw6wSiaCiZFZwKAEgMWjNc0vju5Ryxz/UaiRfTIU8C0x5KD2YFMNhnSBlvA+2KXsSCnEiMFqP5dxyQJzvr5d28GFcv+LrqBiAnkiOCBl28E89jomHh+sJub9e47nNY7wJ5mlIN4LofYxGjXXQQt9dd87i6xoMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZB5K+anm; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34377900dbcso11102858a91.2
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 07:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764690154; x=1765294954; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fDN3QSKzES9CXDIDoJGh3wAHnGpvojjUpvTx9h25lnM=;
        b=ZB5K+anmnR0vt9xU2aBkNwf/bKNzG0Ru4BcE7K2mJFJOyAIHrGjnhI9RA3kDxAYeZQ
         n66vBusWb7+kRYyPnPm4UkoCtRYYaqc2kruUR0+o3S9azlUujO8mjS1hRJHwG4LCEMYr
         3uwaTEx3QQ4oNc5m9ByNAo/Q1Pz7+ompfp9CWZ5GJ7izy47Ql6giU+n9uWAoJSp8wWXb
         fFyu2sOPhKEanT29fFBXJA7DZb1yqaVgUSz2RlTlWhw5TYEi5xpgyl8vKcCnDFI/+JSA
         ZLJeG6FagdlOJiyyAvDZNr76RjklMxk+4Y9BN9u7uQXvNWwafsyro640wxAE9FLDRaaj
         ArBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764690154; x=1765294954;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fDN3QSKzES9CXDIDoJGh3wAHnGpvojjUpvTx9h25lnM=;
        b=WvtQs+snVVqjhfAIQLXr5wOSlzkuBBfqbruZ+t+i2Kto3CEOERBOg+zau+ZAmCNTk1
         9QS3ir/UsBVE9QXpvSM/5sHJVmC6hhKWf8iRljUVaTKm3LXnOFH9fdpX8U5G/MZWnJoH
         ddAsRQMXRWofQezwqypiH7+PDqvFgGnaBx420PFxtgQjx3hnMgFQt+oSMAJtA50s0IPL
         xEkWmmkNF3L85Mi2L/69zmVsx5FAaIX7oraMqEEVgy0qU455CLN29gu6aoKnIFhRS08R
         4qDDm7JGjgQAYrUS2gyFscF7eOC4HV1UjOga/F2bFDie9tfYbp0WV1MZMRTDwrRCgh2d
         MD0A==
X-Forwarded-Encrypted: i=1; AJvYcCUsLVI3MVPnmneoZb5Il2Kkx4FejoB8UyfKObGBPmzcSxMYp3Nt2g/tpJnHvAr0aK/3eOw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtE90O5iZ2VC68Xb0ki1Q+8ep+9Rz5OvG02Y0KHWEVL1+O0zfR
	vaAfcH7EBn86gHcUZ4w06LsBA2lm8ciKUeghwsdgtuDjoc9AHQnMErA/HdN7bOFXBWuvTiSNEGi
	Ka7cwSg==
X-Google-Smtp-Source: AGHT+IE/f1ON3jJimd+0F0/bgjUarijGPlCqtUjB/ELLwBu9kX9JNdBkzAh5L3A+Mc8f1XLbi8odKf/Ga7o=
X-Received: from pjbms16.prod.google.com ([2002:a17:90b:2350:b0:33b:bb95:de6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ece:b0:340:6f9c:b25b
 with SMTP id 98e67ed59e1d1-34733e7681cmr42856527a91.11.1764690154386; Tue, 02
 Dec 2025 07:42:34 -0800 (PST)
Date: Tue, 2 Dec 2025 07:42:33 -0800
In-Reply-To: <118998075677b696104dcbbcda8d51ab7f1ffdfd.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251125180557.2022311-1-khushit.shah@nutanix.com>
 <6353f43f3493b436064068e6a7f55543a2cd7ae1.camel@infradead.org>
 <A922DCC2-4CB4-4DE8-82FA-95B502B3FCD4@nutanix.com> <118998075677b696104dcbbcda8d51ab7f1ffdfd.camel@infradead.org>
Message-ID: <aS8I6T3WtM1pvPNl@google.com>
Subject: Re: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Khushit Shah <khushit.shah@nutanix.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kai.huang@intel.com" <kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	Jon Kohler <jon@nutanix.com>, Shaju Abraham <shaju.abraham@nutanix.com>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2025, David Woodhouse wrote:
> On Tue, 2025-12-02 at 12:58 +0000, Khushit Shah wrote:
> > Thanks for the review!
> >=20
> > > On 2 Dec 2025, at 2:43=E2=80=AFPM, David Woodhouse <dwmw2@infradead.o=
rg> wrote:
> > >=20
> > > Firstly, excellent work debugging and diagnosing that!
> > >=20
> > > On Tue, 2025-11-25 at 18:05 +0000, Khushit Shah wrote:
> > > >=20
> > > > --- a/Documentation/virt/kvm/api.rst
> > > > +++ b/Documentation/virt/kvm/api.rst
> > > > @@ -7800,8 +7800,10 @@ Will return -EBUSY if a VCPU has already bee=
n created.
> > > > =C2=A0
> > > > =C2=A0Valid feature flags in args[0] are::
> > > > =C2=A0
> > > > -=C2=A0 #define KVM_X2APIC_API_USE_32BIT_IDS=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << 0)
> > > > -=C2=A0 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK=C2=A0 (1ULL =
<< 1)
> > > > +=C2=A0 #define KVM_X2APIC_API_USE_32BIT_IDS=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 (1ULL << 0)
> > > > +=C2=A0 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1ULL << 1)
> > > > +=C2=A0 #define KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAS=
T_QUIRK (1ULL << 2)
> > > > +=C2=A0 #define KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1=
ULL << 3)
> > > >=20
> > >=20
> > > I kind of hate these names. This part right here is what we leave
> > > behind for future generations, to understand the weird behaviour of
> > > KVM. To have "IGNORE" "SUPPRESS" "QUIRK" all in the same flag, quite
> > > apart from the length of the token, makes my brain hurt.

...

> > > Could we perhaps call them 'ENABLE_SUPPRESS_EOI_BROADCAST' and
> > > 'DISABLE_SUPPRESS_EOI_BROADCAST', with a note saying that modern VMMs
> > > should always explicitly enable one or the other, because for
> > > historical reasons KVM only *pretends* to support it by default but i=
t
> > > doesn't actually work correctly?

I don't disagree on the names being painful, but ENABLE_SUPPRESS_EOI_BROADC=
AST
vs. DISABLE_SUPPRESS_EOI_BROADCAST won't work, and is even more confusing I=
MO.

The issue is that KVM "enables" SUPPRESS_EOI_BROADCAST in that the feature =
is
exposed to the guest and can be enabled in local APICs, and that's one of t=
he
behaviors/configurations I want to preserve so that guests don't observe a =
feature
change.  Having an on/off switch doesn't work because KVM isn't fully disab=
ling
the feature, nor is KVM fully enabling the feature.  It's a weird, half-bak=
ed
state, hence the QUIRK.

More importantly, we can't use ENABLE bits because I want to preserve exist=
ing
behavior exactly as-is.  I.e. userspace needs to opt-in to disabling
SUPPRESS_EOI_BROADCAST and/or to disabling IGNORE_SUPPRESS_EOI_BROADCAST_QU=
IRK.

> > Yes, I agree the original name is too wordy. How about renaming it to
> > KVM_X2APIC_API_ACTUALLY_SUPPRESS_EOI_BROADCASTS?
> > That makes the intended KVM behaviour clear.
> >
> > I'm also not very keen on ENABLE_SUPPRESS_EOI_BROADCAST
> > it reads as if KVM is the one enabling the feature, which isn't the cas=
e.

Eh, there are myriad things that require enabling all both (or more) sides.

> > The guest decides whether to enable suppression; KVM should just
> > advertise the capability correctly and then respect whatever the guest
> > chooses.
>=20
>=20
> I think _ENABLE_ for enabling a feature for the guest to optionally use
> is reasonable enough; we'd generally say '_FORCE_' if we were going to
> turn it on unconditionally without the guest's knowledge.
>=20
> Not entirely sure why you're OK with ACTUALLY_SUPPRESS_EOI_BROADCAST
> when you aren't ok with ENABLE_SUPPRESS_EOI_BROADCAST. In both cases
> you'd need to append _BUT_ONLY_IF_THE_GUEST_ASKS_FOR_IT if you want to
> be pedantic. :)

+1, though as above I don't think we can use ENABLE for this particular mes=
s.

