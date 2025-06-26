Return-Path: <kvm+bounces-50863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77FD1AEA475
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 19:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80AD4188938A
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8292E2ECE8F;
	Thu, 26 Jun 2025 17:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="de+lQjDt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1199E2E763F
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 17:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750959286; cv=none; b=SivCYlYcFTvRmMMPBaVXovihEGeLO5msoLZYffTrrhnobasbJM0nJTUB6VIhAb5/CWHG3qea+fsMgfRCVsa0kwT+Xu7LLEUoW0zGJq5ggbBZj9KJ1uk/DIzDGOkXoqwvwnu549otHlsor6UsiLASt6IdRl/50KNJfRKHk1PcxU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750959286; c=relaxed/simple;
	bh=Fm7OXsTPzhqvXnDiVTwsw4b/QRazbLf0sV35ZjXHK/Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cst7SWijzF6uYUduKGvIBfpIOOeSjQ9noI4v0yDIs2igsD5/b6bUsN0V34EQaYZRFpSNXXImlXeJ8uI9M9n6W84DFIhVU14fJbWP85Av1Dv5I15QUNrQ4ExZqtnzeIibGahYpUcFJ+Jw5jd6r52aR35dX6Ed7kecLt/guGYlIjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=de+lQjDt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750959284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ccgRMg8Dfr12xc0dnqWKHwWSVpDRdG1c9yQQ1X6tT4w=;
	b=de+lQjDtP0C5UD4SeGiUExLpClstX5h/U2ra5jR9x1m5cdVZSTfoJJx1hvbsYdq8XTbcuc
	irphY37I0hUuomG5vFmAanKDedNpdoqg5O6PJAnv+paPjw0E2apjihgGPykoax+fzSYzZf
	SYVBuvqPqoFFXI7YGTMTF0lt0lcuVFQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-nOS6nj63PeqD_kSiXF_9Xg-1; Thu, 26 Jun 2025 13:34:37 -0400
X-MC-Unique: nOS6nj63PeqD_kSiXF_9Xg-1
X-Mimecast-MFC-AGG-ID: nOS6nj63PeqD_kSiXF_9Xg_1750959277
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6fabd295d12so25489626d6.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 10:34:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750959277; x=1751564077;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ccgRMg8Dfr12xc0dnqWKHwWSVpDRdG1c9yQQ1X6tT4w=;
        b=dhmvUfQnZbSUyfkaBEzSUq0x746EXEi6ynK42w/UYaZDVVF4K49fs0rO0U0s0xau+P
         01WbiVUwFlsRd5APhe5w8j+BUqtTnvt5sllRZ0RmIbKFznKr7l0k3HSrWKBAS4ejI5og
         TdVdQeGKSwvOZlBCc17InvWVBNJd1/dN+qEGzp6131lDiz/PM/fEuIHTqy9LBJzBG4Cd
         Q7uuflnqtjhyFQ3NOucgA+SJNGlPCaiLUCjQC7FS7GeDbVEBCeK+tBSB0jP7s/hPDbDQ
         0HaxamPNzw1IvPLetR1bvb2GEY14N7wvcN7SOIV9fMq84aUAiAvdKf5whThDmeKQFn6Q
         XFKA==
X-Gm-Message-State: AOJu0YzMazk2vID+ZHvkD9cJszCNuV6ldqYIr2UQKkQDN7lHtnEF0ybI
	r35/V8GQN21NX2fAB6zRLRLu5CWOxyZeHSb9NHJaPrE3BW5b+K8DDBvP1wvP2Qdf7N/N+CMFmhW
	4J3QLNeiuIpzJXmVpYBDEI/ovX6JcoMyYdvuWNDv9fM/c5G5S85Wk+Q==
X-Gm-Gg: ASbGncuxOjWMo9MaWW19iMAEJGsyBx/nVFF9vY54KQPhazTseeDv8ZpWAnahYJWJdjV
	445fXbPj1vA/rPeiZwDUZ167WUSDHkWBdMDpQc4ZSmNdx7yr6wqe6THuyZkod4BSOZG/yJwHJdD
	CjnFr9vJx+jwwcbvxPXwPJ/HJi45kfc8QHzVhxZ+5Yih08jBEQCkekd9FUrjFf2iHc4y5jFtPn6
	XPBmWo4HE7/X4WALoE6ofR7PvKZ7+yafWm/FKjgbn8WwsnbgrjIsZt50alytKug1JgexhT3zkSp
	hFzscDf8h8F8KiChbx74sqtDYVeV8ajlfYtoLBFO9VIzTx68dg6A+xJ9egVkNKJwG+Hrmg==
X-Received: by 2002:a05:6214:460a:b0:6fa:9e00:d458 with SMTP id 6a1803df08f44-70014038d71mr4969766d6.45.1750959276512;
        Thu, 26 Jun 2025 10:34:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGy1nkyeeijB2E3MzKV27+9pONkSIoGZJqYCAjcnplHXSYdDKuOM4E39tl8BR8u5eF5xIy/qQ==
X-Received: by 2002:a05:6214:460a:b0:6fa:9e00:d458 with SMTP id 6a1803df08f44-70014038d71mr4969316d6.45.1750959276040;
        Thu, 26 Jun 2025 10:34:36 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd7718e635sm10091926d6.3.2025.06.26.10.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 10:34:35 -0700 (PDT)
Message-ID: <66bab47847aa378216c39f46e072d1b2039c3e0e.camel@redhat.com>
Subject: Re: [EARLY RFC] KVM: SVM: Enable AVIC by default from Zen 4
From: mlevitsk@redhat.com
To: "Naveen N Rao (AMD)" <naveen@kernel.org>, Sean Christopherson
	 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Vasant Hegde
 <vasant.hegde@amd.com>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>
Date: Thu, 26 Jun 2025 13:34:34 -0400
In-Reply-To: <20250626145122.2228258-1-naveen@kernel.org>
References: <20250626145122.2228258-1-naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-06-26 at 20:21 +0530, Naveen N Rao (AMD) wrote:
> This is early RFC to understand if there are any concerns with enabling
> AVIC by default from Zen 4. There are a few issues related to irq window
> inhibits (*) that will need to be addressed before we can enable AVIC,
> but I wanted to understand if there are other issues that I may not be
> aware of. I will split up the changes and turn this into a proper patch
> series once there is agreement on how to proceed.
>=20
> AVIC (and x2AVIC) is fully functional since Zen 4, and has so far been
> working well in our tests across various workloads. So, enable AVIC by
> default from Zen 4.
>=20
> CPUs prior to Zen 4 are affected by hardware errata related to AVIC and
> workaround for those (erratum #1235) is only just landing upstream. So,
> it is unlikely that anyone was using AVIC on those CPUs. Start requiring
> users on those CPUs to pass force_avic=3D1 to explicitly enable AVIC goin=
g
> forward. This helps convey that AVIC isn't fully enabled (so users are
> aware of what they are signing up for), while allowing us to make
> kvm_amd module parameter 'avic' as an alias for 'enable_apicv'
> simplifying the code.=C2=A0 The only downside is that force_avic taints t=
he
> kernel, but if this is otherwise agreeable, the taint can be restricted
> to the AVIC feature bit not being enabled.
>=20
> Finally, stop complaining that x2AVIC CPUID feature bit is present
> without basic AVIC feature bit, since that looks to be the way AVIC is
> being disabled on certain systems and enabling AVIC by default will
> start printing this warning on systems that have AVIC disabled.
>=20

Hi,


IMHO making AVIC default on on Zen4 is a good idea.

About older systems, I don't know if I fully support the idea of hiding
the support under force_avic, because AFAIK, other that errata #1235
there are no other significant issues with AVIC.

In fact errata #1235 is not present on Zen3, and I won't be surprised that
AVIC was soft-disabled on Zen3 wrongly.

IMHO the cleanest way is probably:

On Zen2 - enable_apicv off by default, when forced to 1, activate
the workaround for it. AFAIK with my workaround, there really should
not be any issues, but since hardware is quite old, I am OK to keep it disa=
bled.

On Zen3, AFAIK the errata #1235 is not present, so its likely that AVIC is
fully functional as well, except that it is also disabled in IOMMU,
and that one AFAIK can't be force-enabled.

I won't object if we remove force_avic altogether and just let the user als=
o explicitly=C2=A0
enable avic with enable_apicv=3D1 on Zen3 as well.

And on Zen4, enable_apicv can be true by default.

But if you insist on to have this patch instead I won't object strongly,
as long as it can be enabled by the user, it doesn't matter that much.

Best regards,
	Maxim Levitsky


> (*) http://lkml.kernel.org/r/Z6JoInXNntIoHLQ8@google.com
>=20
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
> =C2=A0arch/x86/kvm/svm/avic.c | 11 +++++------
> =C2=A0arch/x86/kvm/svm/svm.c=C2=A0 | 10 +++-------
> =C2=A02 files changed, 8 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index a34c5c3b164e..bf7f91f41a6e 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1101,12 +1101,11 @@ bool avic_hardware_setup(void)
> =C2=A0	if (!npt_enabled)
> =C2=A0		return false;
> =C2=A0
> -	/* AVIC is a prerequisite for x2AVIC. */
> -	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
> -		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
> -			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
> -			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
> -		}
> +	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic)
> +		return false;
> +
> +	if (!force_avic && (boot_cpu_data.x86 < 0x19 || boot_cpu_has(X86_FEATUR=
E_ZEN3))) {
> +		pr_warn("AVIC disabled due to hardware errata. Use force_avic=3D1 if y=
ou really want to enable AVIC.\n");
> =C2=A0		return false;
> =C2=A0	}
> =C2=A0
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ab11d1d0ec51..9b5356e74384 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -158,12 +158,7 @@ module_param(lbrv, int, 0444);
> =C2=A0static int tsc_scaling =3D true;
> =C2=A0module_param(tsc_scaling, int, 0444);
> =C2=A0
> -/*
> - * enable / disable AVIC.=C2=A0 Because the defaults differ for APICv
> - * support between VMX and SVM we cannot use module_param_named.
> - */
> -static bool avic;
> -module_param(avic, bool, 0444);
> +module_param_named(avic, enable_apicv, bool, 0444);
> =C2=A0module_param(enable_ipiv, bool, 0444);
> =C2=A0
> =C2=A0module_param(enable_device_posted_irqs, bool, 0444);
> @@ -5404,7 +5399,8 @@ static __init int svm_hardware_setup(void)
> =C2=A0			goto err;
> =C2=A0	}
> =C2=A0
> -	enable_apicv =3D avic =3D avic && avic_hardware_setup();
> +	if (enable_apicv)
> +		enable_apicv =3D avic_hardware_setup();
> =C2=A0
> =C2=A0	if (!enable_apicv) {
> =C2=A0		enable_ipiv =3D false;
>=20
> base-commit: 7ee45fdd644b138e7a213c6936474161b28d0e1a


