Return-Path: <kvm+bounces-66261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A6A3ECCC3A6
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0AA153028FF0
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCD63451AA;
	Thu, 18 Dec 2025 13:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eCEzJ7ZF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BxvgHyP2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AB03446C7
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065911; cv=none; b=rgWxAealMOZFYeebQzy/o+BveY2zClILLsmfrhOLK2hobqOUWEeL5cgIf/mFddo6ZDD6Mh1I7Xtt77M3FsODhu0/g+p53DxGfOko4ZNzmiwPZCK+Iozjpt9IHP/xu+FJuJT7TZ0j9qCwNONUOJX1ZVUx/TMOXn31fVb2JRYbYuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065911; c=relaxed/simple;
	bh=XOldvZM4GVTYoj21mCztdV8pOLLqVzHHQisZnZAbu+k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0qTMeWKv/4Mo0elu42ioltKAzciff8Da+ZIwUq00++07NIW6gDcaVOnPpKf0C0EPVUpNtf6zcLN9jea85APF3Bp5hOKSUpDhg8l97GeyE0BOtGofTrs0hv+DY8QcDiQcHSUtW5x5gzTlhBK3LLwdOX2VCq9TIyp6JwR1zWDedg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eCEzJ7ZF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BxvgHyP2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766065908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0ri+3+P9kmZqLA6W5PjkdvgB9+zIG9sNloSxhOLmgI=;
	b=eCEzJ7ZFOwi92mYhGFBscx3tm/WdJqlZ+/HhZS4Ud8719mVsrlOjsqUf0tSzYvRbZasLw7
	N+NLHCke1Zl9Ox0dOGDmK+z9Bix62U6hV8kPnwDsMdLR1jVTX9RiQVX0CIFYjrtk52ZMuk
	ZTXBT64/wXWc/e3hLeo6L1VZHrIXo/Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-ySlOMxuDPaanUNYMn3H2Sg-1; Thu, 18 Dec 2025 08:51:47 -0500
X-MC-Unique: ySlOMxuDPaanUNYMn3H2Sg-1
X-Mimecast-MFC-AGG-ID: ySlOMxuDPaanUNYMn3H2Sg_1766065906
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430fcb6b2ebso415121f8f.2
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 05:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766065906; x=1766670706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t0ri+3+P9kmZqLA6W5PjkdvgB9+zIG9sNloSxhOLmgI=;
        b=BxvgHyP2aAjKE/CHn6KZjb5QQoRIsugAl70YPwYpJw7R59P+zeLymoF3f2Y5XbJtww
         9+b8gdBmNFrB2q/wAFfZoYk4+mc3WQaH8JwTkTkw1T7R7AQbfvENipw/kmnh7Qg6DPfS
         LUePjen1ydnpYwILpkrK4cjPvWVUkgbWOV2/sV2pwldhCD/v1ZiPLU+r5UYgguH7Upf4
         TTHd6ZC3xObDEFA7baURSWhPbAQMFPAcM4C64QF7fejt0YqoLkTBN+EDjbuGJJjDNq69
         IQhdttN2zSyHI0jxTaBseGFqneQ9Bx/jsyq5cNUJ9Jnx77N5mPvBmN92EB/N/XLSZ5/k
         D6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766065906; x=1766670706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t0ri+3+P9kmZqLA6W5PjkdvgB9+zIG9sNloSxhOLmgI=;
        b=uKENOW3M/pge7Yn/3wLf0Kww3nz55HLm38ZiJhX+zWnADsbhb9yvETcTIC4/hCq4rG
         s47pgi4iM3V0AMWFXYsAyn1NNit7lC9swDYdqFaLmZ5gLaXUTtAUEIUXKibXl7uO6vRD
         z36TeHfM6JomRY4J/hZCclpuZwTnGE0q8CCDt3L4+ld1SOI4FIIbHGTHwWojz2IP1/o5
         Biur+orQVv5DIP+nBr8j1bWzCcLyeF6bjZdgjOMdeDTA9w2HMWVyMP4P/XjnEHzzXMRZ
         O/opWEEiWfDrHwlNjKhzlKTKoG5KW+jYDBmNX3HiXJqe1SAli6zJIFrsLm9M37WvPtbO
         mLnA==
X-Forwarded-Encrypted: i=1; AJvYcCWhw9NAvgWeEmNfcdfLyqSF2nK9ZcDlZIW0J5yBPB82qPAGCy/pguzmrc4aZ28YM/J3444=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlnqQJX1x5B9uEVUzUlt3tqTUWJMoDg3x/oXq1Qn7ooJ4iu4Fu
	1GWXF8Imyyt+vX9Xw9iaoumndtYQ62X1JCm/XCN7hGpJmBZnQuv5YaegADYAZaFiilLuAHkYGur
	63TyLYzsgPEcJNzRv/TxuSq/aOQewIa1qgIccTc+yJEBM8pl02sO5nQ==
X-Gm-Gg: AY/fxX7LJdgrARYwvtXsKX7rPb+z+ieXD9J/052nJwjOfkViBheiNV57fW1FVdPu+Rf
	IktyQiMYwxUbiBJoQOaiGYJ1id0xDhTsyhrbmmn5o0moQSzPF+VxRwR/cAM3j12qVlZwJwhve7P
	hs/lKkELcD7mpfHZfa8toZF/ePs/UGxhGMwP/wbJ81Zt7DBacCmQi9zG7N/Mere6IwU0SrUCayD
	PWBmme4r80Tw8uiGMmmwIiER9SASdv2MFhVR16ozK01BkqUvlG1vDxvXnE1im6pGkN4s/sQ1aaR
	Wu92vgDbiqAKh/rOywMbrynR9dZVcg7uZ/QWEIKgKCUEk4epdvutrLhp+SOusn7uc8WyKg==
X-Received: by 2002:a5d:5c84:0:b0:430:f272:3489 with SMTP id ffacd0b85a97d-430f2723770mr18910677f8f.28.1766065906155;
        Thu, 18 Dec 2025 05:51:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqTw6EaaSgOvc8aqRzlQOIS6p3UeBfp9gbhwXh+PofYa9MrFMQWpWZVlutgK2FCXVStBZkXw==
X-Received: by 2002:a5d:5c84:0:b0:430:f272:3489 with SMTP id ffacd0b85a97d-430f2723770mr18910634f8f.28.1766065905655;
        Thu, 18 Dec 2025 05:51:45 -0800 (PST)
Received: from imammedo ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43244940120sm5315826f8f.16.2025.12.18.05.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 05:51:45 -0800 (PST)
Date: Thu, 18 Dec 2025 14:51:43 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?=
 <philmd@linaro.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Thomas
 Huth <thuth@redhat.com>, qemu-devel@nongnu.org, devel@lists.libvirt.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org, Richard
 Henderson <richard.henderson@linaro.org>, Sergio Lopez <slp@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, Laurent Vivier <lvivier@redhat.com>, Jiaxun
 Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, Eduardo
 Habkost <eduardo@habkost.net>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Weiwei Li <liwei1518@gmail.com>, Amit Shah
 <amit@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, Yanan Wang
 <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, Palmer Dabbelt
 <palmer@dabbelt.com>, "Daniel P . =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, Ani Sinha <anisinha@redhat.com>, Fabiano Rosas
 <farosas@suse.de>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai
 Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>, Mark
 Cave-Ayland <mark.caveayland@nutanix.com>, BALATON Zoltan
 <balaton@eik.bme.hu>, Peter Krempa <pkrempa@redhat.com>, Jiri Denemark
 <jdenemar@redhat.com>
Subject: Re: [PATCH v5 23/28] target/i386/cpu: Remove
 CPUX86State::full_cpuid_auto_level field
Message-ID: <20251218145143.743ff111@imammedo>
In-Reply-To: <20251202162835.3227894-24-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-24-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Dec 2025 00:28:30 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>=20
> The CPUX86State::full_cpuid_auto_level boolean was only
> disabled for the pc-q35-2.7 and pc-i440fx-2.7 machines,
> which got removed. Being now always %true, we can remove
> it and simplify x86_cpu_expand_features().
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
> Note, although libvirt still uses this property in its test cases, it
> was confirmed this property is not exposed to user directly [*].
>=20
> [*]: https://lore.kernel.org/qemu-devel/aDmphSY1MSxu7L9R@orkuz.int.mamuti=
.net/
> ---
>  target/i386/cpu.c | 111 ++++++++++++++++++++++------------------------
>  target/i386/cpu.h |   3 --
>  2 files changed, 54 insertions(+), 60 deletions(-)
>=20
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 641777578637..72c69ba81c1b 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -9019,69 +9019,67 @@ void x86_cpu_expand_features(X86CPU *cpu, Error *=
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
> -        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_ECX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_7_2_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_ECX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0007_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_8000_0008_EBX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_C000_0001_EDX);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_SVM);
> -        x86_cpu_adjust_feat_level(cpu, FEAT_XSAVE);
> -
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
> +    x86_cpu_adjust_feat_level(cpu, FEAT_1_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_1_ECX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_6_EAX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_7_0_ECX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EAX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_ECX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_7_1_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_7_2_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0001_ECX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0007_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_8000_0008_EBX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_C000_0001_EDX);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_SVM);
> +    x86_cpu_adjust_feat_level(cpu, FEAT_XSAVE);
> +
> +    /* Intel Processor Trace requires CPUID[0x14] */
> +    if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT)) {
> +        if (cpu->intel_pt_auto_level) {
> +            x86_cpu_adjust_level(cpu, &cpu->env.cpuid_min_level, 0x14);
> +        } else if (cpu->env.cpuid_min_level < 0x14) {
> +            mark_unavailable_features(cpu, FEAT_7_0_EBX,
> +                CPUID_7_0_EBX_INTEL_PT,
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
> -        if (x86_has_cpuid_0x1f(cpu) &&
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
> +    if (x86_has_cpuid_0x1f(cpu) &&
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
> @@ -10010,7 +10008,6 @@ static const Property x86_cpu_properties[] =3D {
>      DEFINE_PROP_UINT32("min-xlevel2", X86CPU, env.cpuid_min_xlevel2, 0),
>      DEFINE_PROP_UINT8("avx10-version", X86CPU, env.avx10_version, 0),
>      DEFINE_PROP_UINT64("ucode-rev", X86CPU, ucode_rev, 0),
> -    DEFINE_PROP_BOOL("full-cpuid-auto-level", X86CPU, full_cpuid_auto_le=
vel, true),
>      DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
>      DEFINE_PROP_BOOL("cpuid-0xb", X86CPU, enable_cpuid_0xb, true),
>      DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, t=
rue),
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index cee1f692a1c3..8c3eb86fa0c7 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2292,9 +2292,6 @@ struct ArchCPU {
>      /* Force to enable cpuid 0x1f */
>      bool force_cpuid_0x1f;
> =20
> -    /* Enable auto level-increase for all CPUID leaves */
> -    bool full_cpuid_auto_level;
> -
>      /*
>       * Compatibility bits for old machine types (PC machine v6.0 and old=
er).
>       * Only advertise CPUID leaves defined by the vendor.


