Return-Path: <kvm+bounces-47880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43CF5AC69B8
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 14:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1334C16FABA
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 12:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADC0286402;
	Wed, 28 May 2025 12:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQ0pdLNS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB987E9;
	Wed, 28 May 2025 12:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748436554; cv=none; b=ijbKhnV7f62l5OD/HOR14l5r1JvpWc+TiqKCweu9rMPuEh1FgpD7j/qwJ7gXO70XkN4tzxbCxuVwj2dNWeIyTFzBs8IM0aEz+KVqRF9RY8arbKUCcQ7ZKoIGZchDBi3THEDGVBJ89xO/QNbXiGBtKdDhMvcH1/UHUXLsWBGnE5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748436554; c=relaxed/simple;
	bh=X/IS5lYHsTDLAlHNttA49/Zy4IooIj/ybKO85yqOzZs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bEcNcsiquFFEh28Acu4PTy9rTKYfKQT7yl1uwaESBIQflm9roIug4S6AfFRc1YK4vcELFx2ExbAwuXNbbp8yFh2N6Gzhsr3uuiDWkg09ljkuZAVvmGaiD+ElFa5NDI/XBA/lreEP0E661E6MIxHiqFNSuNR55/uS3DIuNkBoF/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQ0pdLNS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6E7C4CEE7;
	Wed, 28 May 2025 12:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748436554;
	bh=X/IS5lYHsTDLAlHNttA49/Zy4IooIj/ybKO85yqOzZs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=VQ0pdLNSXlcJDrxExPgrTgBQHlndAfRHjuHPwTXmzv9hkc+vs7XxAQT7+EMZsemIF
	 y0evmUYyrUqpbMHIavufzd27jC2r4qWw7onRO+R6kAY3HWO+I8Lau2VkC/QOIq0gZd
	 17VkioiZo/xzynYTnKfU76gZ12EuJJUL9A6W+evAXhHHK4Fern4qD0m6dRM7if9CCr
	 5MVAtL+w42aAryy+bBv3/tesy0RX7Yi/Bzwcs99L3vxYSEqVLAMFUjj4vQussOA2ku
	 livtepZlNPeOhU0Rx1rG3WjLnsI2mpVOPwH0fQESkP9a+E+0J4x6H7Y5cIMdpsm43a
	 Ly/OFuG9A+feA==
Message-ID: <c4adbc456e702b6e04b160efb996212fe3ee9d04.camel@kernel.org>
Subject: Re: [PATCH v5 1/1] x86: kvm: svm: set up ERAPS support for guests
From: Amit Shah <amit@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org
Cc: bp@alien8.de, tglx@linutronix.de, peterz@infradead.org,
 jpoimboe@kernel.org, 	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net,
 mingo@redhat.com, 	dave.hansen@linux.intel.com, hpa@zytor.com,
 seanjc@google.com, pbonzini@redhat.com, 	daniel.sneddon@linux.intel.com,
 kai.huang@intel.com, sandipan.das@amd.com, 	boris.ostrovsky@oracle.com,
 Babu.Moger@amd.com, david.kaplan@amd.com, 	dwmw@amazon.co.uk,
 andrew.cooper3@citrix.com, amit.shah@amd.com
Date: Wed, 28 May 2025 14:49:07 +0200
In-Reply-To: <43bbb306-782b-401d-ac96-cc8ca550af7d@amd.com>
References: <20250515152621.50648-1-amit@kernel.org>
	 <20250515152621.50648-2-amit@kernel.org>
	 <43bbb306-782b-401d-ac96-cc8ca550af7d@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-05-19 at 16:22 -0500, Tom Lendacky wrote:
> On 5/15/25 10:26, Amit Shah wrote:
>=20

[...]

> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 571c906ffcbf..0cca1865826e 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1187,6 +1187,9 @@ void kvm_set_cpu_caps(void)
> > =C2=A0		F(SRSO_USER_KERNEL_NO),
> > =C2=A0	);
> > =C2=A0
> > +	if (tdp_enabled)
> > +		kvm_cpu_cap_check_and_set(X86_FEATURE_ERAPS);
>=20
> Should this be moved to svm_set_cpu_caps() ? And there it can be
>=20
> 	if (npt_enabled)
> 		kvm_cpu_cap...

Yea, I don't mind moving that to svm-only code.  Will do.

> > =C2=A0	case 0x80000021:
> > -		entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
> > +		entry->ecx =3D entry->edx =3D 0;
> > =C2=A0		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
> > +		if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
> > +			entry->ebx &=3D GENMASK(23, 16);
> > +		else
> > +			entry->ebx =3D 0;
> > +
>=20
> Extra blank line.

Hm, helps with visual separation of the if-else and the break.  I
prefer to keep it, unless it breaks style guidelines.

> > =C2=A0		break;
> > =C2=A0	/* AMD Extended Performance Monitoring and Debug */
> > =C2=A0	case 0x80000022: {
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index a89c271a1951..a2b075ed4133 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1363,6 +1363,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
> > =C2=A0	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > =C2=A0		set_msr_interception(vcpu, svm->msrpm,
> > MSR_IA32_SPEC_CTRL, 1, 1);
> > =C2=A0
> > +	if (boot_cpu_has(X86_FEATURE_ERAPS) && npt_enabled)
>=20
> Should this be:
>=20
> 	if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
>=20
> ?

Indeed this is better.  There was some case I wanted to cover
initially, but I don't think it needs to only depend on the host caps
in the current version at least.

[...]
=C2=A0
> > +static inline void vmcb_set_flush_guest_rap(struct vmcb *vmcb)
> > +{
> > +	vmcb->control.erap_ctl |=3D ERAP_CONTROL_FLUSH_RAP;
> > +}
> > +
> > +static inline void vmcb_clr_flush_guest_rap(struct vmcb *vmcb)
> > +{
> > +	vmcb->control.erap_ctl &=3D ~ERAP_CONTROL_FLUSH_RAP;
> > +}
> > +
> > +static inline void vmcb_enable_extended_rap(struct vmcb *vmcb)
>=20
> s/extended/larger/ to match the bit name ?

I also prefer it with the "larger" name, but that is a confusing bit
name -- so after the last round of review, I renamed the accessor
functions to be "better", while leaving the bit defines match what the
CPU has.

I don't mind switching this back - anyone else have any other opinions?

>=20
> > +{
> > +	vmcb->control.erap_ctl |=3D ERAP_CONTROL_ALLOW_LARGER_RAP;
> > +}
> > +
> > +static inline bool vmcb_is_extended_rap(struct vmcb *vmcb)
>=20
> s/is_extended/has_larger/
>=20
> Thanks,
> Tom

Thanks for the review!

		Amit

