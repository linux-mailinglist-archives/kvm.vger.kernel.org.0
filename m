Return-Path: <kvm+bounces-50876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82772AEA62F
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 21:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CED714E0193
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 19:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783892EF9B1;
	Thu, 26 Jun 2025 19:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dCX/15+H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E8A2EF66C
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 19:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750965289; cv=none; b=PDwBJoN83Py7hp062sfSR1OandPUjci3nxuCvmTDoZKNFHKYZl9PnM6CQ61UmdT1QRRh1/3qdRWG7m+v+z7eXNgyUHFNaLLXeROWQAvmAv3o6+F5192UEdoqjYaRGsSERGvS9fv1uFdDFNE8j1oAnigSLmaHy/08sZSCqIQKL2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750965289; c=relaxed/simple;
	bh=gqmT11iHH/hY9qDqQMx4+Kz2ypnqGc3/6sNjexCpCtA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vfev1cDrcfvqakwOdyAR4l+wxMKpqLlAeTNf7rnzXaQGkO4irnn1YQmq5rSUcfZTjzXSsOD/yAb4QaLx7EaunTBCUKIQMkT/nTQN79LiKVl4BD+iOccq3HJFW5Amm4Zdro3lcWwlXi3oMapAN2Ph0O+p9PdxNKtcKcE9PU4AYtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dCX/15+H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750965286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Brpulx3UE0Do2+9EzrBbzVKTCmn4CwWx8OE8MS5L6Ck=;
	b=dCX/15+Hl0HfGK14I6SR3SMIhaV4R8Lbevqf/czZ5/O3ra+iECR6SXG0UT8f2iuNMuy3Y2
	biW+0BV9zpzsn4y/iYJRU3cfGFN3jPdBRNU01+8qWkbaKdKgabNT0APYbXCY+eqWO72Q1m
	rj/YtgZlq2MChye1DM6mhfem2jnrmbk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-23T99hzjOB27lcbC5VJQAA-1; Thu, 26 Jun 2025 15:14:45 -0400
X-MC-Unique: 23T99hzjOB27lcbC5VJQAA-1
X-Mimecast-MFC-AGG-ID: 23T99hzjOB27lcbC5VJQAA_1750965285
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4a44e608379so46699511cf.2
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 12:14:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750965285; x=1751570085;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Brpulx3UE0Do2+9EzrBbzVKTCmn4CwWx8OE8MS5L6Ck=;
        b=IV5Sul3GRV9Z82NeBkLfRrcmuRJUgazRT4FUXflpOOgP7QjFSvbAoISO8C5mifBmqO
         cLrhBXgfnNLc77pd8EYgj5fWGG///iSFmABKcJKiUFBq1lVfonwWxe8nw7Rq5Ks8MKCi
         YtAtIDsS+RVdOlar03xoBeKPUp3e9ulHNTiE6h0I3dILeG4Op5MK30DbCUsApdsxywf+
         /DrxIAsWe9lCba/ASzQHcbR50yQAPsN/UdbUFrx6yhUAfTE8dmQTazjTbv049g/7r+GN
         q1bbDHw1pXPNuxiEeH6DieFRCjSWtp2a3qmo6LsqRJSNLuVU3289a+A9pTiRxiX2eBqY
         rnFA==
X-Forwarded-Encrypted: i=1; AJvYcCVOVaCpsqgc9sxb3+u4vblwGJty2jruR5koTrE2OiD3yuGThl9R4NrRYAyxIHw2oiatJuY=@vger.kernel.org
X-Gm-Message-State: AOJu0YydHq5B+3Xm5ig1WKO6HE7CRlstqWOCtzTZmPjf4R0CBE1A7yyN
	BH8u7yT4XWW+fvHiGisFP6Fr6RAmoovLaEwpKZXqP0bj64tX0PV2rahHDy61gctZULRJSXtAhcc
	q4pRM98IJGPSDqF3v/BFStrHxhO0r85Sp41xIjqwAuT67eWcfnAHdyg==
X-Gm-Gg: ASbGnctnMi5cAx2VJU+XsO+aMBQv/2beB+s9BL11ljSGkJfuRpZ06iO3Az2aHxKOmK9
	uSCsmYORYaQrxXmB3Y9/kt9TJKIGcDbpAA0QZWQqETbM3YXICkBireoFXrLSvvOcjW+4+IHHUZW
	dbhiHEJIFvyFTWoNvXYkrA2YVVhL0eCQ9tWb7wdqNZLD+artBiG+hPjIkKBFa6vulOY/5/VZRke
	yp8TuoYclx8MAZb3ETGPT8zwTTGU1H7DNpLxBGw0PgxTNgG4OsXs3aBYZrYBWqa4mfw25EMTJLV
	X2qxIyiSV5TXeAebix7gUaZ83hE/6z0oX4UsbSeBsntI9JV3soK+dM5ZH4+mDun5oVCzrw==
X-Received: by 2002:a05:622a:1101:b0:477:6f6d:607a with SMTP id d75a77b69052e-4a7fc9cad46mr11225861cf.7.1750965284429;
        Thu, 26 Jun 2025 12:14:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+41CtLCXg5JSeVQqDV1ofydgdzJ+UqKT4sICPvsUklMuWrbMfCKHiJrAuIDKnNtQjCM/YTw==
X-Received: by 2002:a05:622a:1101:b0:477:6f6d:607a with SMTP id d75a77b69052e-4a7fc9cad46mr11225361cf.7.1750965283947;
        Thu, 26 Jun 2025 12:14:43 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a7fc1061c7sm2765181cf.4.2025.06.26.12.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 12:14:43 -0700 (PDT)
Message-ID: <4ae9c25e0ef8ce3fdd993a9b396183f3953c3de7.camel@redhat.com>
Subject: Re: [EARLY RFC] KVM: SVM: Enable AVIC by default from Zen 4
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: "Naveen N Rao (AMD)" <naveen@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>
Date: Thu, 26 Jun 2025 15:14:42 -0400
In-Reply-To: <aF2VCQyeXULVEl7b@google.com>
References: <20250626145122.2228258-1-naveen@kernel.org>
	 <66bab47847aa378216c39f46e072d1b2039c3e0e.camel@redhat.com>
	 <aF2VCQyeXULVEl7b@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-06-26 at 11:44 -0700, Sean Christopherson wrote:
> On Thu, Jun 26, 2025, mlevitsk@redhat.com=C2=A0wrote:
> > On Thu, 2025-06-26 at 20:21 +0530, Naveen N Rao (AMD) wrote:
> > > This is early RFC to understand if there are any concerns with enabli=
ng
> > > AVIC by default from Zen 4. There are a few issues related to irq win=
dow
> > > inhibits (*) that will need to be addressed before we can enable AVIC=
,
> > > but I wanted to understand if there are other issues that I may not b=
e
> > > aware of. I will split up the changes and turn this into a proper pat=
ch
> > > series once there is agreement on how to proceed.
> > >=20
> > > AVIC (and x2AVIC) is fully functional since Zen 4, and has so far bee=
n
> > > working well in our tests across various workloads. So, enable AVIC b=
y
> > > default from Zen 4.
> > >=20
> > > CPUs prior to Zen 4 are affected by hardware errata related to AVIC a=
nd
> > > workaround for those (erratum #1235) is only just landing upstream. S=
o,
> > > it is unlikely that anyone was using AVIC on those CPUs. Start requir=
ing
> > > users on those CPUs to pass force_avic=3D1 to explicitly enable AVIC =
going
> > > forward. This helps convey that AVIC isn't fully enabled (so users ar=
e
> > > aware of what they are signing up for), while allowing us to make
> > > kvm_amd module parameter 'avic' as an alias for 'enable_apicv'
> > > simplifying the code.=C2=A0 The only downside is that force_avic tain=
ts the
> > > kernel, but if this is otherwise agreeable, the taint can be restrict=
ed
> > > to the AVIC feature bit not being enabled.
> > >=20
> > > Finally, stop complaining that x2AVIC CPUID feature bit is present
> > > without basic AVIC feature bit, since that looks to be the way AVIC i=
s
> > > being disabled on certain systems and enabling AVIC by default will
> > > start printing this warning on systems that have AVIC disabled.
> > >=20
> >=20
> > Hi,
> >=20
> >=20
> > IMHO making AVIC default on on Zen4 is a good idea.
> >=20
> > About older systems, I don't know if I fully support the idea of hiding
> > the support under force_avic, because AFAIK, other that errata #1235
> > there are no other significant issues with AVIC.
>=20
> Agreed, force_avic should be reserved specifically for the case where AVI=
C exists
> in hardware, but is not enumerated in CPUID.
>=20
> > In fact errata #1235 is not present on Zen3, and I won't be surprised t=
hat
> > AVIC was soft-disabled on Zen3 wrongly.
>=20
> FWIW, the Zen3 systems I have access to don't support AVIC / APIC virtual=
ization
> in the IOMMU, so it's not just AVIC being soft-disabled in the CPU.

Yes, I mentioned that, but still practically speaking AVIC on Zen2 is equiv=
alent
to APICv on Intel CPUs of the same generation, and on Zen3 AVIC is equavale=
nt to
many Intel client systems which do have APICv but not posted interrupts, li=
ke my
laptop (I hate this).

>=20
> > IMHO the cleanest way is probably:
> >=20
> > On Zen2 - enable_apicv off by default, when forced to 1, activate
> > the workaround for it. AFAIK with my workaround, there really should
> > not be any issues, but since hardware is quite old, I am OK to keep it =
disabled.
> >=20
> > On Zen3, AFAIK the errata #1235 is not present, so its likely that AVIC=
 is
> > fully functional as well, except that it is also disabled in IOMMU,
> > and that one AFAIK can't be force-enabled.
> >=20
> > I won't object if we remove force_avic altogether and just let the user=
 also explicitly=C2=A0
> > enable avic with enable_apicv=3D1 on Zen3 as well.
>=20
> I'm not comfortable ignoring lack of enumerated support without tainting =
the
> kernel.

The kernel can still be tainted in this case, just that it is technically p=
ossible to drop=C2=A0
force_avic, and instead just allow user to pass avic=3D1 instead, since it =
is
not on by default and KVM can still print the same warning and taint the ke=
rnel
when user passes avic=3D1 on Zen3.

Back when I implemented this, I just wanted to be a bit safer, a bit more e=
xplicit that
this uses an undocumented feature.

It doesn't matter much though.

>=20
> I don't see any reason to do major surgery, just give "avic" auto -1/0/1 =
behavior:

>=20
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ab11d1d0ec51..4aa5bec0b1e7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -158,12 +158,9 @@ module_param(lbrv, int, 0444);
> =C2=A0static int tsc_scaling =3D true;
> =C2=A0module_param(tsc_scaling, int, 0444);
> =C2=A0
> -/*
> - * enable / disable AVIC.=C2=A0 Because the defaults differ for APICv
> - * support between VMX and SVM we cannot use module_param_named.
> - */
> -static bool avic;
> -module_param(avic, bool, 0444);
> +/* Enable AVIC by default only for Zen4+ (negative value =3D default/aut=
o). */
> +static int avic =3D -1;
> +module_param(avic, int, 0444);
> =C2=A0module_param(enable_ipiv, bool, 0444);
> =C2=A0
> =C2=A0module_param(enable_device_posted_irqs, bool, 0444);
> @@ -5404,6 +5401,9 @@ static __init int svm_hardware_setup(void)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err=
;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (avic < 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 avic =3D boot_cpu_data.x86 > 0x19 || boot_cpu_has(X86_FEATURE_=
ZEN4);
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enable_apicv =3D avic =3D avic=
 && avic_hardware_setup();
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!enable_apicv) {
>=20

I also have nothing against this to be honest, its OK to keep it as is IMHO=
.

Best regards,
	Maxim Levitsky



