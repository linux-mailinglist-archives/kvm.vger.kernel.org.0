Return-Path: <kvm+bounces-63829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E7774C7365D
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 11:12:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id A1BAC2F665
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 10:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145C9313267;
	Thu, 20 Nov 2025 10:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LusjTbi6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895AD272E45
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 10:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763633515; cv=none; b=MCEaMFHondR6Fv2++zBKYEkiY1mtpTmSp4vCcF1+XS1ce2vIRVHovYKIrW6yT9ZLsCXcVG+SDaBG3rdqenFubAT3TXJzi1+c7zG98yI4DIvV6n1NzEPDf5wU3rVJDIbQUjml/FubBH46R9niu1reE/6dTgol9ysSz8p+mNWSv30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763633515; c=relaxed/simple;
	bh=eUZYgOFXqsq/wpUZk85PZ8AHLCMX6xa08fvCRqbQMys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q1ReWhYLPlMR90QMxmxPjnyiE6WvCr/sPR93+BoUr7eH1x6f5I7bJjS57H2e+EJJq6MI58/8Q/WiyPRedK4WuOUMHwbjjp6fB3PrP4zGd7jfy5spLOyvQ+UUGBt4PgHORwuCfF9fhpQY5b+YeG3NwWkfaqo5rVeTvfj9WAjWyqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LusjTbi6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763633512;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wiSt72GIoNCo+Zbs/Mg7U6K+qgO5xzGmnbJap4V+VSA=;
	b=LusjTbi6Dqq3559Nxrt9wbhfdgegWI2g11UHsuNRAaW9z3ybSGuoEuSRNlp25Sn84ANfRd
	c7FmDmOxw2T0DRUTYIPEv1Q5FFdsl2ADdbpXJASg6mfRPOsCd5KECxgvxRGjbxqYmxYRyT
	vEnqr3ZN4P/NzyjzG14zmVtkyC5RFlk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-twQ69RNiPzuUmfG8-W_y5A-1; Thu, 20 Nov 2025 05:11:50 -0500
X-MC-Unique: twQ69RNiPzuUmfG8-W_y5A-1
X-Mimecast-MFC-AGG-ID: twQ69RNiPzuUmfG8-W_y5A_1763633509
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso4706735e9.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 02:11:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763633509; x=1764238309;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wiSt72GIoNCo+Zbs/Mg7U6K+qgO5xzGmnbJap4V+VSA=;
        b=XQMO+TTR4P9P7deX5wdu89WGbt1txAK+mcmgfH1vlmbgnYyuAX7zJUcYacSeJQ+pWB
         GEE5r8ZXoxhTiSuuvF9wgiYMMHpuzyDcka6SpDcQuKa+z0xAIth3g0m1fHpzDN2wrMYr
         93pEwkTiiWLUqCZmO5GoL+XtVooGGTGNMLwPu6suiMdXJHjJj6DU7E6n1vuLmScWzlaN
         VMvnIR0gxQaHkj7Jos35XESPZk0CMOoTY1jyzmYtFMqj87NBmjm0qhlMoDi3JLvM+XmB
         9vr73wufAcggPrVmgbQdCZCMVCd81kgoaQ400pUI/HwSj+Yfa7Q7ICedImDN18MDB/3l
         WFPA==
X-Forwarded-Encrypted: i=1; AJvYcCVuOrPsbU65limU5tindrEbzEntnaqt1oUEtQsYIkNv6UvWjcoaOzHophBoFXsF0r2zqzk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaCVhEYMCHop8wPCAgMqAaQPr+5qXZexwg/ZcfbphcD+wBp2vZ
	TvwaPze8L2SOHeHKCSK69vsYPh8nPt14gJ16qJ2lAYdxQp+4a49RBVOtlhoiTCtjtuob2mliW5h
	/me6Nl4TQXloEnSt3+GEYpoXwhzkdD6sBmAhxeXO+HtU5FfxyjCvhGw==
X-Gm-Gg: ASbGncvGmhrs0hlAFFpFTgZcVG8T7RrUQFN87hfjdqnRcQw78vY8hmhBzw+fd8fc/bX
	+4qdXP8+ZeOiSjEwbTNSLZNq4+V1hT8i6IPP0G9bt0VLys7As9ghH8canEDk80uLzJtGzuTDjRt
	mYmqBFsbyjK7gU/8kEg4Yrcq7PiNCqJGuqHEoyapGbtPgWz5cJvrMiki5WgxGngLpiobxLOSZTK
	vyN+sqJw5/lcJis5yySYiRPmHJiDPAhn98dj3WFYRQVu44APe9wVIRwIl7eFEM9EHopH0hP9WTg
	4pqwYnOarQRKYHWkgYo6j9UExMoeom7cbctThtygrU9M4RXeYnBztRUFER4V8GL3T0MobJRGs/d
	mo/iVpV8FOhI3h0Gww4f17RX+xtUY89d/Ps7cdJs40BFls0sMUo1CQzuAKg==
X-Received: by 2002:a05:600c:4f4c:b0:477:7479:f081 with SMTP id 5b1f17b1804b1-477b895aff7mr32256115e9.12.1763633508840;
        Thu, 20 Nov 2025 02:11:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEyZsKxZ7eOZkXPyWcc4qYqZdgL9i/jMwKRrzVg9ugodScsHxJKDhP2GIBuvHdk1RA9oxypdg==
X-Received: by 2002:a05:600c:4f4c:b0:477:7479:f081 with SMTP id 5b1f17b1804b1-477b895aff7mr32255505e9.12.1763633508319;
        Thu, 20 Nov 2025 02:11:48 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b1025707sm95706595e9.6.2025.11.20.02.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 02:11:47 -0800 (PST)
Message-ID: <a4e05081-df69-4183-a585-f4bb1d0a6256@redhat.com>
Date: Thu, 20 Nov 2025 11:11:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251112181357.38999-1-sebott@redhat.com>
 <20251112181357.38999-3-sebott@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20251112181357.38999-3-sebott@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 11/12/25 7:13 PM, Sebastian Ott wrote:
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  5 +++
>  target/arm/cpu.h                 |  6 +++
>  target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>  3 files changed, 74 insertions(+), 1 deletion(-)
>
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 37d5dfd15b..1d32ce0fee 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
>    the guest scheduler behavior and/or be exposed to the guest
>    userspace.
>  
> +``kvm-psci-version``
> +  Override the default (as of kernel v6.13 that would be PSCI v1.3)
> +  PSCI version emulated by the kernel. Current valid values are:
> +  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
> +
>  TCG VCPU Features
>  =================
>  
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 39f2b2e54d..c2032070b7 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -981,6 +981,12 @@ struct ArchCPU {
>       */
>      uint32_t psci_version;
>  
> +    /*
> +     * Intermediate value used during property parsing.
> +     * Once finalized, the value should be read from psci_version.
> +     */
> +    uint32_t prop_psci_version;
nit: as it is a kvm only thingy, could could rename it with kvm_ prefix
and move this along with the other kvm_* elements
> +
>      /* Current power state, access guarded by BQL */
>      ARMPSCIState power_state;
>  
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 0d57081e69..e91b1abfb8 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>  
> +struct psci_version {
> +    uint32_t number;
> +    const char *str;
> +};
> +
> +static const struct psci_version psci_versions[] = {
> +    { QEMU_PSCI_VERSION_0_1, "0.1" },
> +    { QEMU_PSCI_VERSION_0_2, "0.2" },
> +    { QEMU_PSCI_VERSION_1_0, "1.0" },
> +    { QEMU_PSCI_VERSION_1_1, "1.1" },
> +    { QEMU_PSCI_VERSION_1_2, "1.2" },
> +    { QEMU_PSCI_VERSION_1_3, "1.3" },
> +    { -1, NULL },
> +};
> +
> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const struct psci_version *ver;
> +
> +    for (ver = psci_versions; ver->number != -1; ver++) {
> +        if (ver->number == cpu->psci_version)
> +            return g_strdup(ver->str);
> +    }
> +
> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
> +}
> +
> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const struct psci_version *ver;
> +
> +    for (ver = psci_versions; ver->number != -1; ver++) {
> +        if (!strcmp(value, ver->str)) {
> +            cpu->prop_psci_version = ver->number;
> +            return;
> +        }
> +    }
> +
> +    error_setg(errp, "Invalid PSCI-version value");
> +}
> +
>  /* KVM VCPU properties should be prefixed with "kvm-". */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>  {
> @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>                               kvm_steal_time_set);
>      object_property_set_description(obj, "kvm-steal-time",
>                                      "Set off to disable KVM steal time.");
> +
> +    object_property_add_str(obj, "kvm-psci-version", kvm_get_psci_version,
> +                            kvm_set_psci_version);
> +    object_property_set_description(obj, "kvm-psci-version",
> +                                    "Set PSCI version. "
> +                                    "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3");
>  }
>  
>  bool kvm_arm_pmu_supported(void)
> @@ -1959,7 +2008,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      if (cs->start_powered_off) {
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
>      }
> -    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
> +    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
> +        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
> +        /*
> +         * Versions >= v0.2 are backward compatible with v0.2
> +         * omit the feature flag for v0.1 .
> +         */
>          cpu->psci_version = QEMU_PSCI_VERSION_0_2;
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
>      }
> @@ -1998,6 +2052,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          }
>      }
>  
> +    if (cpu->prop_psci_version) {
> +        psciver = cpu->prop_psci_version;
> +        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
> +        if (ret) {
> +            error_report("PSCI version %"PRIx64" is not supported by KVM", psciver);
> +            return ret;
> +        }
> +    }
>      /*
>       * KVM reports the exact PSCI version it is implementing via a
>       * special sysreg. If it is present, use its contents to determine
Besides it looks good to me.
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Eric


