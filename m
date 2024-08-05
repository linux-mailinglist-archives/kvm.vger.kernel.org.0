Return-Path: <kvm+bounces-23221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B60947A4C
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 13:16:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E536281313
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 11:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38EE5155351;
	Mon,  5 Aug 2024 11:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G3fIuZz6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A7E14B09E
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 11:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722856599; cv=none; b=uTuMb9aAmXTs7kQ/T7+jMbvW6bPn5T/0JJenu2zQcSog7qTflavAn+iZ5jVNENLPrlY2NSvpm0kpVqQkYig8F9O/HealcWvwmRE6g21ehOBwa47WilOSIj0faVsYZ6GjHFlokgNPQrgkHbV5ab6LdKD7t8JzsmeeFNyki1TeoMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722856599; c=relaxed/simple;
	bh=FEFOjMGCighyUbVzguwmxIfF/mrmGPVjVKfWVE3W1Vg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=udJwPHR65p9dRiRNXLLCPtfM79lK1n2nQ0v6F0bVHkKaTNBoEFnbJuTUH+PXe/LIdu+uzD3KTc5ttz8s7EnVU0TceK2P8qVbNscTfaZJcUV2ghECzKqpNN0MvAra/dYBObRt5MP+Xp3AvVI4Xr8cP3R9lJcacUXfYeBAPvIh0FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G3fIuZz6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722856596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iu6gdPHmgLfjv375G6ZfsnMZNsHu+T1DeSLpi4rR0Yk=;
	b=G3fIuZz6ziR+k+9Z9TbbXO2tikIybzwgn3q8SFjrHLcFa9vQKQ9Sb8dxocngoW3DpDtoGy
	92QSD4xHajnG4PZHCQJ71TbMBvjhDmdy3SGdgCxZllPXtnR1pPxnfsHnQcJSEK1th/YUv8
	Dr/cCS6tvJCXtf9wzHV+caHEHYmdjt0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-Ar1FL8wJN8i5S3Q7pQhGzg-1; Mon, 05 Aug 2024 07:16:35 -0400
X-MC-Unique: Ar1FL8wJN8i5S3Q7pQhGzg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3687f4f9fecso7435460f8f.1
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 04:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722856594; x=1723461394;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iu6gdPHmgLfjv375G6ZfsnMZNsHu+T1DeSLpi4rR0Yk=;
        b=tczio9eK/S8l22N9pcQcsg/oTDe6gqiEi9YeaXo1sOkC/cMrI9d9C0ydxRUN0sHiTi
         aYzSIrHzj47EtdrbBueC2ZGtkUTo9otwcx/VQ+TXfgWqmLY4jTkF9sWm9ZOJha7m7kR1
         Jr7Nj3gI7joUmh/K+M43pPdGQDWlzQLm+NNawas9fUXBLbOBbem7kHPcpsEmLZo77cjQ
         otGu7Hj9KioMig8EDY5Pd/mG7Mj9Q/NXryFWoCHKCVfu4bU7d7GYUFSI1kbvOEmz4+Lp
         fn/d9sgnn6cQZpwSSPRYe8z3IRvVNc1SZSBYAOxu0HU1DZuWx8gBTZMLxUD/J7kyyikV
         jKTg==
X-Forwarded-Encrypted: i=1; AJvYcCW/sYh/LXQwtD66BnME0rMASusNhImMi3+BQUH6gNFgOCZ3izkmCId4O3FhmBnzHzYTfP8XG/G0Yp361crC/d3VRGoL
X-Gm-Message-State: AOJu0YxP7rNSGuAy8KgQrdH873CEDIXZdg7XmXcwrIkGZyMGGgy33lcq
	MJONtSWkm0UnYJ80ZmYipJfkPIYZWOJx8JH7VwSYMlmVg+qcNl+lYzg2URlhv7K/7PVX0fp/NHy
	I+FNR1zr3mPlnJMXfNx6znGu4yPohPOO0tq5EawMeZfy3XX1Saw==
X-Received: by 2002:a5d:5d84:0:b0:36b:d3eb:17a5 with SMTP id ffacd0b85a97d-36bd3eb18ccmr4975171f8f.36.1722856594054;
        Mon, 05 Aug 2024 04:16:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESeLaIeVOoQq707+nC4LbDZtsEwVCxZ1Fh5+mMjXD0hfd8Q7y9yV3sOzjn/AyUtSUgkaMt9g==
X-Received: by 2002:a5d:5d84:0:b0:36b:d3eb:17a5 with SMTP id ffacd0b85a97d-36bd3eb18ccmr4975128f8f.36.1722856593315;
        Mon, 05 Aug 2024 04:16:33 -0700 (PDT)
Received: from intellaptop.lan ([2a06:c701:778d:5201:3e8a:4c9c:25dd:6ccc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbd059801sm9536625f8f.83.2024.08.05.04.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 04:16:32 -0700 (PDT)
Message-ID: <2d77b69729354b016eb76537523c9e32e7c011c5.camel@redhat.com>
Subject: Re: [PATCH v2 26/49] KVM: x86: Add a macro to init CPUID features
 that KVM emulates in software
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Mon, 05 Aug 2024 14:16:31 +0300
In-Reply-To: <ZqQ6DWUou8hvu0qE@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-27-seanjc@google.com>
	 <2e0f3fb63c810dd924907bccf9256f6f193b02ec.camel@redhat.com>
	 <ZoxooTvO5vIEnS5V@google.com>
	 <2e531204c32c05c96e852748d490424a6f69a018.camel@redhat.com>
	 <ZqQ6DWUou8hvu0qE@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

=D0=A3 =D0=BF=D1=82, 2024-07-26 =D1=83 17:06 -0700, Sean Christopherson =D0=
=BF=D0=B8=D1=88=D0=B5:
> > On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> > > > On Mon, 2024-07-08 at 15:30 -0700, Sean Christopherson wrote:
> > > > > > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > > > > > > On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrot=
e:
> > > > > > > > There are several advantages to this:
> > > > > > > >=20
> > > > > > > > - more readability, plus if needed each statement can be am=
ended with a comment.
> > > > > > > > - No weird hacks in 'F*' macros, which additionally eventua=
lly evaluate into a bit,
> > > > > > > > =C2=A0 which is confusing.
> > > > > > > > =C2=A0 In fact no need to even have them at all.
> > > > > > > > - No need to verify that bitmask belongs to a feature word.
> > > > > >=20
> > > > > > Yes, but the downside is that there is no enforcement of featur=
es in a word being
> > > > > > bundled together.
> > > >=20
> > > > As I explained earlier, this is not an issue in principle, even if =
the caps are not
> > > > grouped together, the code will still work just fine.
> >=20
> > I agree that functionally it'll all be fine, but I also want the code t=
o bunch
> > things together for readers.=C2=A0 We can force that with functions, th=
ough it means
> > passing in more state to kvm_cpu_cap_init_{begin,end}().
> >=20
> > > > kvm_cpu_cap_init_begin(CPUID_1_ECX);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* TMA is not passed though b=
ecause: xyz*/
> > > > kvm_cpu_cap_init(TMA,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0);
> > > > kvm_cpu_cap_init(SSSE3,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 CAP_PASSTHOUGH);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* CNXT_ID is not passed thou=
gh because: xyz*/
> > > > kvm_cpu_cap_init(CNXT_ID,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0);
> > > > kvm_cpu_cap_init(RESERVED,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0);
> > > > kvm_cpu_cap_init(FMA,=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 CAP_PASSTHOUGH);
> > > > ...
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* KVM always emulates TSC_AD=
JUST */
> > > > kvm_cpu_cap_init(TSC_ADJUST,=C2=A0=C2=A0=C2=A0 CAP_EMULATED | CAP_S=
CATTERED);
> > > >=20
> > > > kvm_cpu_cap_init_end(CPUID_1_ECX);
> > > >=20
> > > > ...
> > > >=20
> > > > ...
> > > >=20
> > > > And kvm_cpu_cap_init_begin, can set some cap_in_progress variable.
> >=20
> > Ya, but then compile-time asserts become run-time asserts.

Not really, it all can be done with macros, in exactly the same way IMHO,
we do have BUILD_BUG_ON after all.

I am not against using macros, I am only against collecting a bitmask
while applying various side effects, and then passing the bitmask to
the kvm_cpu_cap_init.

> >=20
> > > > > > > > - Merge friendly - each capability has its own line.
> > > > > >=20
> > > > > > That's almost entirely convention though.=C2=A0 Other than iner=
tia, nothing is stopping
> > > > > > us from doing:
> > > > > >=20
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_cpu_cap_ini=
t(CPUID_12_EAX,
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SF(SGX1) |
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SF(SGX2) |
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SF(SGX_EDECCSSA)
> > > >=20
> > > > That trivial change is already an improvement, although it still le=
aves the problem
> > > > of thinking that this is one bit 'or', which was reasonable before =
this patch series,
> > > > because it was indeed one big 'or' but now there is lots of things =
going on behind
> > > > the scenes and that violates the principle of the least surprise.
> > > >=20
> > > > My suggestion fixes this, because when the user sees a series of fu=
nction calls,
> > > > and nobody will assume anything about these functions calls in cont=
rast with series
> > > > of 'ors'. It's just how I look at it.
> >=20
> > If it's the macro styling that's misleading, we could do what we did fo=
r the
> > static_call() wrappers and make them look like functions.=C2=A0 E.g.
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_cpu_cap_init(CPUID_=
12_EAX,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0scattered_f(SGX1) |
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0scattered_f(SGX2) |
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0scattered_f(SGX_EDECCSSA)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0);



> >=20
> > though that probably doesn't help much and is misleading in its own rig=
ht.=C2=A0 Does
> > it help if the names are more verbose?=20

Verbose names are a good thing, I already mentioned this.

> > =C2=A0
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0);
> > > > > >=20
> > > > > > I don't see a clean way of avoiding the addition of " |" on the=
 last existing
> > > > > > line, but in practice I highly doubt that will ever be a source=
 of meaningful pain.
> > > > > >=20
> > > > > > Same goes for the point about adding comments.=C2=A0 We could d=
o that with either
> > > > > > approach, we just don't do so today.
> > > >=20
> > > > Yes, from the syntax POV there is indeed no problem, and I do agree=
 that putting
> > > > each feature on its own line, together with comments for the featur=
es that need it
> > > > is a win-win improvement over what we have after this patch series.
> > > >=20
> > > > > >=20
> > > > > > > > Disadvantages:
> > > > > > > >=20
> > > > > > > > - Longer list - IMHO not a problem, since it is very easy t=
o read / search
> > > > > > > > =C2=A0 and can have as much comments as needed.
> > > > > > > > =C2=A0 For example this is how the kernel lists the CPUID f=
eatures and this list IMHO
> > > > > > > > =C2=A0 is very manageable.
> > > > > >=20
> > > > > > There's one big difference: KVM would need to have a line for e=
very feature that
> > > > > > KVM _doesn't_ support.
> > > >=20
> > > > Could you elaborate on why?
> > > > If we zero the whole leaf and then set specific bits there, one bit=
 per kvm_cpu_cap_init.
> >=20
> > Ah, if we move the the handling of boot_cpu_data[*] into the helpers, t=
hen yes,
> > there's no need to explicitly initialize features that aren't supported=
 by KVM.
> >=20
> > That said, I still don't like using functions instead of macros, mainly=
 because
> > a number of compile-assertions become run-time assertions.

I'm almost sure that we can do everything with compile time asserts with se=
ries of functions.




> > =C2=A0 To provide equivalent
> > functionality, we also would need to pass in extra state to begin/end()=
 (as
> > mentioned earlier).

Besides the number of leaf currently initialized, I don't see which other e=
xtra state we need.

In fact I can prove that this is possible:

Roughly like this:

#define kvm_cpu_cap_init_begin(leaf)							\
do {											\
 const u32 __maybe_unused kvm_cpu_cap_init_in_progress =3D leaf; 				\
 u32 kvm_cpu_cap_emulated =3D 0; 								\
 u32 kvm_cpu_cap_synthesized =3D 0; 							\
	u32 kvm_cpu_cap_regular =3D 0;


#define feature_scattered(name) 							\
 BUILD_BUG_ON(X86_FEATURE_##name >=3D MAX_CPU_FEATURES); 					\
 KVM_VALIDATE_CPU_CAP_USAGE(name); 							\
											\
	if (boot_cpu_has(X86_FEATURE_##name) 						\
		kvm_cpu_cap_regular |=3D feature_bit(name);


#define kvm_cpu_cap_init_end() 								\
	const struct cpuid_reg cpuid =3D x86_feature_cpuid(leaf * 32);			\
											\
	if (kvm_cpu_cap_init_in_progress < NCAPINTS) 					\
 		kvm_cpu_caps[kvm_cpu_cap_init_in_progress] &=3D kvm_cpu_cap_regular; 	\
 	else 										\
 		kvm_cpu_caps[kvm_cpu_cap_init_in_progress] =3D kvm_cpu_cap_regular; 	\
 											\
 	kvm_cpu_caps[kvm_cpu_cap_init_in_progress] &=3D (raw_cpuid_get(cpuid) | 	=
	\
 	kvm_cpu_cap_synthesized); 							\
 	kvm_cpu_caps[kvm_cpu_cap_init_in_progress] |=3D kvm_cpu_cap_emulated; 		\
} while(0);


And now we have:

kvm_cpu_cap_init_begin(CPUID_12_EAX);
 feature_scattered(SGX1);
 feature_scattered(SGX2);
 feature_scattered(SGX_EDECCSSA);
kvm_cpu_cap_init_end();

In my book this looks much less misleading than the current version - I did=
n't put
much effort into naming variables though, the kvm_cpu_cap_regular name can =
be better IMHO.


Best regards,
	Maxim Levitsky


> > =C2=A0 Getting compile-time assertions on usage, e.g. via
> > guest_cpu_cap_has(), would also be trickier, though still doable, I thi=
nk.
> > Lastly, it adds an extra step (calling _end()) to each flow, i.e. adds =
one more
> > thing for developers to mess up.=C2=A0 But that's a very minor concern =
and definitely
> > not a sticking point.
> >=20
> > I agree that the macro shenanigans are aggressively clever, but for me,=
 the
> > benefits of compile-time asserts make it worth dealing with the clevern=
ess.
> >=20
> > [*] https://lore.kernel.org/all/ZqKlDC11gItH1uj9@google.com
> >=20


