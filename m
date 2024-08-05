Return-Path: <kvm+bounces-23257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8D39482BF
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 21:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F8231C2182F
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 19:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC0116BE32;
	Mon,  5 Aug 2024 19:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q9ADq27S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF7C166F3B
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 19:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722887949; cv=none; b=Kwmo7Z416gDs5/sF9CHphUjYweSL7tkLC320nXbnRkyWyFtftg5AWSGZtbUVkJqcSr0hgCtBremuFWsCw03YfqrvuQmazLS1zUZoiseHedaOaNc88KH1xp+uW201301Q0uQzWlrBtKhox8tsmGjMJGkCM/h7rzYVnidqFglirAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722887949; c=relaxed/simple;
	bh=We8J6sAkv2hRPn2dQUeqt0EKdaMFbNwJMYIn4tfvtUU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e9eGepYYAMg49oZRDkfu82o9+yZECQEYL+wiXE3TWcebjRD4vb/osbmcZeAXlXnT+Ol/d7xXDQD3iUU+4cELpr1PQffkXis1W1NKTYYtfGXDmOQkw4RbeMPRIShrjWqnpoDI9ff4OflPXjlIoDZBL5Vzv1HP/zruUDTaJaM7plw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q9ADq27S; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc6ac9a4aaso658525ad.1
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 12:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722887948; x=1723492748; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KCfVeFmk0vjRk0S6rICOEsbUFhlV15eE9/mFKxpmxWE=;
        b=Q9ADq27SfCJJAbt/GJpOdghlPZPcH9YcUUgexBy3OLROaZekFv04VQg90lpLgnvX/m
         /p25ZSl22FCcLGsVJJVozgUbjLjaaNFZjhk1IIUBy1KulHyPDM+7HimYdi0xlxrBYQJc
         txM3IeytuMLdVNnsYCHn7vtYVqjFhQ15Q4jdHunoHHZt4vlnYSflnheOZlh/9DgjqLBe
         k2y5LwBgSzoFrquSl3xn0GMOUb+Hx/ZTODD9hQ7iFKAY5FWLIqQU2wAgTm2QI8+q2Yim
         n38OUWRuE+cWzvq7j0w0Q+ABNUiXBCLX+60KBFpN4IR0vPxVIYvKdgZY+DEYG0qOdnL7
         c38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722887948; x=1723492748;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KCfVeFmk0vjRk0S6rICOEsbUFhlV15eE9/mFKxpmxWE=;
        b=LvV10HbmTrvVeov6PS6PkW0uplcRQ4g7DXsAdWTM5FILp82kWPYIoXI4L7Xvs5p/1X
         TAxdXFZhAb8lY6pMqkPERnNzPFprJ/cTUfPsEEQVZIGP0KivO3XYMEXoVIe0aMcEZZJT
         WQppOKmcUiyFdXmgFF3TtVsYL7CcVWis0eoR2ajWewPzd3J0ngFnazaT1fANE4isyKax
         hkDHa1mkoG6F+4qB1t+v0sHMvrD63nQKa8XmfZ2+jX4oA6XyMIrjCt5m18t44HGewE8q
         j2bHNi3VbTBqG1MrcP+fmQyK9f5EIwHttHZ/B+PLj4G6ABhblluZVupiG5Oh09wfzQdM
         EFMA==
X-Forwarded-Encrypted: i=1; AJvYcCVymMZyxq2bu0i11oDJMO1VZwv+kAsFrkb+4yO8mtgsOASfAXT+QfcHTO4K6w+znuLzv0Ogp2UggN0mVNV9jzUI5HJT
X-Gm-Message-State: AOJu0YyfqJHqgLOVVVfOdlALDB3rkXctspvZNFmxrE+yGftUXx/urCfV
	Jy3ycriugOI2dBUoHAIRyfxhOxsoxsRPmMOYJkd/7XizHCqn1gM2pTayaHRDmI6QHOWeq2ygkcD
	ofQ==
X-Google-Smtp-Source: AGHT+IH9QJv5GQlKdgd7RYTTYiUltbtTEo2OVaMA/fSySKaYaveOiqCSAx146Nl7kJJ4VWnJgWpMPdzSPq8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c2:b0:1fd:9157:bd0d with SMTP id
 d9443c01a7336-1ff573db04bmr7632435ad.8.1722887947470; Mon, 05 Aug 2024
 12:59:07 -0700 (PDT)
Date: Mon, 5 Aug 2024 12:59:05 -0700
In-Reply-To: <2d77b69729354b016eb76537523c9e32e7c011c5.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-27-seanjc@google.com>
 <2e0f3fb63c810dd924907bccf9256f6f193b02ec.camel@redhat.com>
 <ZoxooTvO5vIEnS5V@google.com> <2e531204c32c05c96e852748d490424a6f69a018.camel@redhat.com>
 <ZqQ6DWUou8hvu0qE@google.com> <2d77b69729354b016eb76537523c9e32e7c011c5.camel@redhat.com>
Message-ID: <ZrEvCc6yYdT-cHxD@google.com>
Subject: Re: [PATCH v2 26/49] KVM: x86: Add a macro to init CPUID features
 that KVM emulates in software
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
> =D0=A3 =D0=BF=D1=82, 2024-07-26 =D1=83 17:06 -0700, Sean Christopherson =
=D0=BF=D0=B8=D1=88=D0=B5:
> > > > > And kvm_cpu_cap_init_begin, can set some cap_in_progress variable=
.
> > >=20
> > > Ya, but then compile-time asserts become run-time asserts.
>=20
> Not really, it all can be done with macros, in exactly the same way IMHO,
> we do have BUILD_BUG_ON after all.
>=20
> I am not against using macros, I am only against collecting a bitmask
> while applying various side effects, and then passing the bitmask to
> the kvm_cpu_cap_init.

Gah, I wasn't grokking that, obviously.  Sorry for not catching on earlier.

> > > To provide equivalent functionality, we also would need to pass in ex=
tra
> > > state to begin/end() (as mentioned earlier).
>=20
> Besides the number of leaf currently initialized, I don't see which other
> extra state we need.
>=20
> In fact I can prove that this is possible:
>=20
> Roughly like this:
>=20
> #define kvm_cpu_cap_init_begin(leaf)							\
> do {											\
>  const u32 __maybe_unused kvm_cpu_cap_init_in_progress =3D leaf; 				\
>  u32 kvm_cpu_cap_emulated =3D 0; 								\
>  u32 kvm_cpu_cap_synthesized =3D 0; 							\
> 	u32 kvm_cpu_cap_regular =3D 0;

Maybe "virtualized" instead of "regular"?

> #define feature_scattered(name) 							\
>  BUILD_BUG_ON(X86_FEATURE_##name >=3D MAX_CPU_FEATURES); 					\
>  KVM_VALIDATE_CPU_CAP_USAGE(name); 							\
> 											\
> 	if (boot_cpu_has(X86_FEATURE_##name) 						\
> 		kvm_cpu_cap_regular |=3D feature_bit(name);
>=20
>=20
> #define kvm_cpu_cap_init_end() 								\
> 	const struct cpuid_reg cpuid =3D x86_feature_cpuid(leaf * 32);			\
> 											\
> 	if (kvm_cpu_cap_init_in_progress < NCAPINTS) 					\
>  		kvm_cpu_caps[kvm_cpu_cap_init_in_progress] &=3D kvm_cpu_cap_regular; 	=
\
>  	else 										\
>  		kvm_cpu_caps[kvm_cpu_cap_init_in_progress] =3D kvm_cpu_cap_regular; 	\
>  											\
>  	kvm_cpu_caps[kvm_cpu_cap_init_in_progress] &=3D (raw_cpuid_get(cpuid) |=
 		\
>  	kvm_cpu_cap_synthesized); 							\
>  	kvm_cpu_caps[kvm_cpu_cap_init_in_progress] |=3D kvm_cpu_cap_emulated; 	=
	\
> } while(0);
>=20
>=20
> And now we have:
>=20
> kvm_cpu_cap_init_begin(CPUID_12_EAX);
>  feature_scattered(SGX1);
>  feature_scattered(SGX2);
>  feature_scattered(SGX_EDECCSSA);
> kvm_cpu_cap_init_end();

I don't love the syntax (mainly the need for a begin()+end()), but I'm a-ok
getting rid of the @mask param/input.

What about making kvm_cpu_cap_init() a variadic macro, with the relevant fe=
atures
"unpacked" in the context of the macro?  That would avoid the need for a tr=
ailing
macro, and would provide a clear indication of when/where the set of featur=
es is
"initialized".

The biggest downside I see is that the last entry can't have a trailing com=
ma,
i.e. adding a new feature would require updating the previous feature too.

#define kvm_cpu_cap_init(leaf, init_features...)			\
do {									\
	const struct cpuid_reg cpuid =3D x86_feature_cpuid(leaf * 32);	\
	const u32 __maybe_unused kvm_cpu_cap_init_in_progress =3D leaf;	\
	u32 kvm_cpu_cap_virtualized=3D 0;					\
	u32 kvm_cpu_cap_emulated =3D 0;					\
	u32 kvm_cpu_cap_synthesized =3D 0;				\
									\
	init_features;							\
									\
	kvm_cpu_caps[leaf] =3D kvm_cpu_cap_virtualized;			\
	kvm_cpu_caps[leaf] &=3D (raw_cpuid_get(cpuid) |			\
			       kvm_cpu_cap_synthesized);		\
	kvm_cpu_caps[leaf] |=3D kvm_cpu_cap_emulated;			\
} while (0)

	kvm_cpu_cap_init(CPUID_1_ECX,
		VIRTUALIZED_F(XMM3),
		VIRTUALIZED_F(PCLMULQDQ),
		VIRTUALIZED_F(SSSE3),
		VIRTUALIZED_F(FMA),
		VIRTUALIZED_F(CX16),
		VIRTUALIZED_F(PDCM),
		VIRTUALIZED_F(PCID),
		VIRTUALIZED_F(XMM4_1),
		VIRTUALIZED_F(XMM4_2),
		EMULATED_F(X2APIC),
		VIRTUALIZED_F(MOVBE),
		VIRTUALIZED_F(POPCNT),
		EMULATED_F(TSC_DEADLINE_TIMER),
		VIRTUALIZED_F(AES),
		VIRTUALIZED_F(XSAVE),
		// DYNAMIC_F(OSXSAVE),
		VIRTUALIZED_F(AVX),
		VIRTUALIZED_F(F16C),
		VIRTUALIZED_F(RDRAND),
		EMULATED_F(HYPERVISOR)
	);


Alternatively, we could force a trailing comma by omitting the semicolon af=
ter
init_features, but that looks weird for the the macro itself, and arguably =
a bit
weird for the users too.

