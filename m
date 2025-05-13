Return-Path: <kvm+bounces-46344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A24DBAB5367
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 13:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 673418C0211
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF91A28C5BF;
	Tue, 13 May 2025 11:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dFte1JTC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F75028C5CF
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 11:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747134153; cv=none; b=WeEJVHOIdoPIr7ntu0EvsGyWOsz8m337hRvLqgoYia/3kxi06xjUGTUz1nsxwP7/9BX82dUvzYNR2ptYCRISNSf8envexR6aM7JthFI7w8m4bkbYGQP8dZE1j61qkckbj0A0vKsrTyewg/BFc0ACeD4ciUFgUXAwZLbAZy3EkzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747134153; c=relaxed/simple;
	bh=Ef3oQwx/YJSruqdy5LyU1Qd5lKDQekSutnpGgGzzaLg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KjI9HBye3OgVHSm08UTBx48/bug6NJoPod9a06SVSp9aKX9+IxcvKGsehzC7YG1sXceJ0oK17PIVFsorLMyElEBUZaFMVSy0Wn4meyqH8zhUb8tYzHr+FDkYqJN9g+xG2BJ/SITFN/qjpuZEnCI+WP5PgdqajJFfPBimSYmg9ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dFte1JTC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747134150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JW7oK2CyI854OSLqH48Mzg+zv/icPx31EwbrZmKAXLE=;
	b=dFte1JTCn8AaqZu8USYBX4bcvPfK70r1gKb7jC0UZAQ8bcduGTYez+UCfSvFUzI9bR/y1Y
	fCdyAi1I5FttYoJvWYmgO00H5hG+9jtUMcK70UXsuDnxYS9NASIHSOqSTCAdnUl/sO2EJv
	TxXKbQ2hXnCugACEDTKulCRB2Jgg8No=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-FzwDOMQ5OUumdADOTDFZBA-1; Tue, 13 May 2025 07:02:29 -0400
X-MC-Unique: FzwDOMQ5OUumdADOTDFZBA-1
X-Mimecast-MFC-AGG-ID: FzwDOMQ5OUumdADOTDFZBA_1747134147
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-441c96c1977so36043875e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 04:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747134147; x=1747738947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JW7oK2CyI854OSLqH48Mzg+zv/icPx31EwbrZmKAXLE=;
        b=noQ1Mkc/jcH1hnIm3ggYm9hKf4nXuGX86hOCTv1ilEechJwd5icejU09U650hdG2nb
         AYjL4X8KlBoZCXkbRM9txeH8BHPkl7oBB92CH0NcKuLHKB7lwdLUoT7pRvu1TXDJmVTu
         6ok2+gC/X4z5PtwAppC3elWgYIAC27I+hLUIEKFREGlCWqziLSSsNHYTIhLHkDKDT62d
         BvTnQzOtqbIesc1wCRzMOFINhnUfIefx9bae8wkF6KrPkdK8kXvyw1dNMOE9J/EsZZWe
         3g/lIrw+ADZ6zOmsA3XJbLhzaST6uR/hwya9MDIEHkj+sGsroWxW1k62spnVbO2MLEs+
         6nEA==
X-Forwarded-Encrypted: i=1; AJvYcCVwckrw15Xdyp38NG9osBTbww0iJvTEUxUVMHbHSYKs+W42yiMmPoO8X9uTvjBtT42+uv0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0xXStGj8Ow4HVldx/scpuoffo/gNTI5yy7MlgQk6dJGsePgrH
	R2UdoxsfYnupLULo6izAvkS7zBw784HjRYq9mmv9vKAa1XH8q5I0c2nr4o47lxy7lRh13oj+zuM
	f7MrKdCkTULPNjfLfxczFa45XT2IjWOqSQB+jPxGdfd0UEFkD6g==
X-Gm-Gg: ASbGncv3pwZhM8NxmIxoBj/8qgvs4n+6fipQm1lMUTDtdFe8MzyE9Z5USNJLWP+m4KS
	ckGmqzXilIp83LQegrq49uJNMMq8YWzIgkZGOxwEhPa0YC4hTRVTIvCeupgCMTHJB7lpPChEklD
	Ffh2bnpuHUeX/eGlXoCu0+iEt14M7lOG0PgtGdJfMgq2YA8N/4pkOgrncDe6QVaIqUrK898Or3X
	Bp/WTyKIBMG5AE93j3vT9pkvAdh38A244ZGVhglytH7N4ickoxld9Bar/7M1p/TL4m+AHrnaSBS
	En34lTLFluI21rXBeEC3khgeRkmxw8bS
X-Received: by 2002:a05:600c:83ca:b0:43c:fb95:c752 with SMTP id 5b1f17b1804b1-442d6d18b68mr175998565e9.3.1747134146799;
        Tue, 13 May 2025 04:02:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFk13HL4XgRMNtBFAgcztyAjoi+/4X2BhOPn1zg6pOI7KXkFzTEKIuNaNeRmT7l0ksWgMhSRA==
X-Received: by 2002:a05:600c:83ca:b0:43c:fb95:c752 with SMTP id 5b1f17b1804b1-442d6d18b68mr175998075e9.3.1747134146360;
        Tue, 13 May 2025 04:02:26 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442ea45c209sm38283135e9.17.2025.05.13.04.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 04:02:25 -0700 (PDT)
Date: Tue, 13 May 2025 13:02:24 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>, Gerd Hoffmann
 <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Laurent
 Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu
 <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-riscv@nongnu.org, Weiwei Li
 <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, Zhao Liu
 <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>, Helge Deller
 <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha
 <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, Jason
 Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 19/27] target/i386/cpu: Remove
 CPUX86State::full_cpuid_auto_level field
Message-ID: <20250513130224.3aa2e837@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250508133550.81391-20-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
	<20250508133550.81391-20-philmd@linaro.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:42 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> The CPUX86State::full_cpuid_auto_level boolean was only
> disabled for the pc-q35-2.7 and pc-i440fx-2.7 machines,
> which got removed. Being now always %true, we can remove
> it and simplify x86_cpu_expand_features().

I've found field being mentioned only by some external rust library,
that's likely shouldn't concern QEMU qemu though.

I'm not confident enough to ack it but I won't object either
=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  target/i386/cpu.h |   3 --
>  target/i386/cpu.c | 106 ++++++++++++++++++++++------------------------
>  2 files changed, 51 insertions(+), 58 deletions(-)
>=20
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 7585407da54..b5cbd91c156 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2241,9 +2241,6 @@ struct ArchCPU {
>       */
>      bool legacy_multi_node;
> =20
> -    /* Enable auto level-increase for all CPUID leaves */
> -    bool full_cpuid_auto_level;
> -
>      /* Only advertise CPUID leaves defined by the vendor */
>      bool vendor_cpuid_only;
> =20
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index fb505d13122..6b9a1f2251a 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7843,68 +7843,65 @@ void x86_cpu_expand_features(X86CPU *cpu, Error *=
*errp)
> =20
>      /* CPUID[EAX=3D7,ECX=3D0].EBX always increased level automatically: =
*/
>      x86_cpu_adjust_feat_level(cpu, FEAT_7_0_EBX);
> -    if (cpu->full_cpuid_auto_level) {
> -        x86_cpu_adjust_feat_level(cpu, FEAT_1_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_1_ECX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_6_EAX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_7_0_ECX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EAX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_7_2_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_ECX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0007_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0008_EBX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_C000_0001_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_SVM);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_XSAVE);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_1_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_1_ECX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_6_EAX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_7_0_ECX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EAX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_7_2_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_ECX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0007_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0008_EBX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_C000_0001_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_SVM);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_XSAVE);
> =20
> -        /* Intel Processor Trace requires CPUID[0x14] */
> -        if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT)) {
> -            if (cpu->intel_pt_auto_level) {
> -                x86_cpu_adjust_level(cpu, &cpu->env.cpuid_min_level, 0x1=
4);
> -            } else if (cpu->env.cpuid_min_level < 0x14) {
> -                mark_unavailable_features(cpu, FEAT_7_0_EBX,
> -                    CPUID_7_0_EBX_INTEL_PT,
> -                    "Intel PT need CPUID leaf 0x14, please set by \"-cpu=
 ...,intel-pt=3Don,min-level=3D0x14\"");
> -            }
> +    /* Intel Processor Trace requires CPUID[0x14] */
> +    if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT)) {
> +        if (cpu->intel_pt_auto_level) {
> +            x86_cpu_adjust_level(cpu, &cpu->env.cpuid_min_level, 0x14);
> +        } else if (cpu->env.cpuid_min_level < 0x14) {
> +            mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_I=
NTEL_PT,
> +                "Intel PT need CPUID leaf 0x14, please set by \"-cpu ...=
,intel-pt=3Don,min-level=3D0x14\"");
>          }
> +    }
> =20
> -        /*
> -         * Intel CPU topology with multi-dies support requires CPUID[0x1=
F].
> -         * For AMD Rome/Milan, cpuid level is 0x10, and guest OS should =
detect
> -         * extended toplogy by leaf 0xB. Only adjust it for Intel CPU, u=
nless
> -         * cpu->vendor_cpuid_only has been unset for compatibility with =
older
> -         * machine types.
> -         */
> -        if (x86_has_extended_topo(env->avail_cpu_topo) &&
> -            (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
> -            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
> -        }
> +    /*
> +     * Intel CPU topology with multi-dies support requires CPUID[0x1F].
> +     * For AMD Rome/Milan, cpuid level is 0x10, and guest OS should dete=
ct
> +     * extended toplogy by leaf 0xB. Only adjust it for Intel CPU, unless
> +     * cpu->vendor_cpuid_only has been unset for compatibility with older
> +     * machine types.
> +     */
> +    if (x86_has_extended_topo(env->avail_cpu_topo) &&
> +        (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
> +        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
> +    }
> =20
> -        /* Advanced Vector Extensions 10 (AVX10) requires CPUID[0x24] */
> -        if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10) {
> -            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x24);
> -        }
> +    /* Advanced Vector Extensions 10 (AVX10) requires CPUID[0x24] */
> +    if (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10) {
> +        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x24);
> +    }
> =20
> -        /* SVM requires CPUID[0x8000000A] */
> -        if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM) {
> -            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000000A=
);
> -        }
> +    /* SVM requires CPUID[0x8000000A] */
> +    if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM) {
> +        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000000A);
> +    }
> =20
> -        /* SEV requires CPUID[0x8000001F] */
> -        if (sev_enabled()) {
> -            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000001F=
);
> -        }
> +    /* SEV requires CPUID[0x8000001F] */
> +    if (sev_enabled()) {
> +        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000001F);
> +    }
> =20
> -        if (env->features[FEAT_8000_0021_EAX]) {
> -            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000021=
);
> -        }
> +    if (env->features[FEAT_8000_0021_EAX]) {
> +        x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000021);
> +    }
> =20
> -        /* SGX requires CPUID[0x12] for EPC enumeration */
> -        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
> -            x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
> -        }
> +    /* SGX requires CPUID[0x12] for EPC enumeration */
> +    if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
> +        x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
>      }
> =20
>      /* Set cpuid_*level* based on cpuid_min_*level, if not explicitly se=
t */
> @@ -8820,7 +8817,6 @@ static const Property x86_cpu_properties[] =3D {
>      DEFINE_PROP_UINT32("min-xlevel2", X86CPU, env.cpuid_min_xlevel2, 0),
>      DEFINE_PROP_UINT8("avx10-version", X86CPU, env.avx10_version, 0),
>      DEFINE_PROP_UINT64("ucode-rev", X86CPU, ucode_rev, 0),
> -    DEFINE_PROP_BOOL("full-cpuid-auto-level", X86CPU, full_cpuid_auto_le=
vel, true),
>      DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
>      DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, t=
rue),
>      DEFINE_PROP_BOOL("x-amd-topoext-features-only", X86CPU, amd_topoext_=
features_only, true),


