Return-Path: <kvm+bounces-62950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C72C6C548AE
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 22:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CE78A4E117C
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 21:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E222D9EE2;
	Wed, 12 Nov 2025 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k6+bOlBP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D497229DB64
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 21:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762981649; cv=none; b=LczTjy06A7zR+Qq7Z/rrw7OANQLBFLs45QUZ7s0kKZHQlXx8MnYckV/NpvXSYVNA+tJAOWCB35OIj4dKCiJ/Ay6QgUf3n8S+2KfPmUIylLSsy8r0xO9WuuBP5haP3yLA6ZhZO9TT3N/dvvgBBh3ijpDQeFvTSBamMfko7AFo20M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762981649; c=relaxed/simple;
	bh=Z2e8DoPZSUlsjdl9QhSqNgJm8pSP3JCCSTrBSJ21Zyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TSxEOC3IR0Am2/K46Ni19ZIOwWVp/ReHiQ7Yqzqu7p8YQKCsOIPGQWSh7I1WUO7xfLOaL2i4kPLzH7dxZJG57CtIRATLAsGIVrseeH0+2poV9bIYrzPwZcKXKKdoHjbAoI8QfsPr+Eael3YKRUqx8v9eskNb4QfFSTcEPRkovC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k6+bOlBP; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b3c965df5so59942f8f.1
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 13:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762981644; x=1763586444; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ndvKFCJtXmZXWNjsWlnfM9pmpLT2hMmXPRvFvrdoK9k=;
        b=k6+bOlBPL1B2luKR7q0Zb/V2BSIWsLW7brC4lwGUMbbOTTXv2WHp0/WpqBtgTLt4Cj
         W9WDzvnNLZh+mUvt3gJNP/EGCHdq5eD7WZ4d8B405Kh9v/lFtNMgG3VKaCuR1E5RrH90
         eGf+4Kx0upYNf7bOhStJi+KznFEt1gSFgboEIlmkYZUfSMHJJXYxTpGb3VcCZLFTMVrj
         xHPMFZ6CC78dK3t+IiZxpZYgR/W2KWeP2/2YfMqm/fXy9Ujn1SDF2csqKSkJAQJNEYxf
         HSrVEmeDwh568aa5gCQgE4Gmu7Bo7ae5yk1aCHYaM85PdHuyZCRGbf9Ca5QAGZ8+ZhuG
         HYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762981644; x=1763586444;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ndvKFCJtXmZXWNjsWlnfM9pmpLT2hMmXPRvFvrdoK9k=;
        b=oTE1BMRwyXLIUSxAXbRtlb80DzPkzGQlK460xv9WA78s5k9Ngn21Q2YeAm1pIi0fzZ
         MY4HNVvMzVZ20anBIL0g4bOTb+1eUw9Zdud06L3RSdt2xZAFZB66jx79p81xCmHnOo37
         V4Y8ga8T3Gi3qZdnC5TwYE98eTfOQ+k3aerwI2Lt1aDcC2CIvLdjs4qviYXpea5/vZFv
         cm1n/GOM3ZJwfeCi/Tks5GTH0r4oUxgfb5l+wzqFl41acdWZb5KfOIxBfOh5GYl3HARO
         XKOq8TbBJRhkET5Qzd5vofTBQwJ1mR9zhUtqBjn/E8ZToaXkNvajkoUDCkCw2/HO9pth
         wu1A==
X-Forwarded-Encrypted: i=1; AJvYcCVLi8KVDL6CPhjG6tcdAc6PJkpSMHrBsOkEBoP3TzC+r/1807hayvTLP9qgoJJD+TwdkvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXY1RXIzpsvDHYmBZS2nTpXosSNTUaF44QxM1M0ALFFrEPFIR+
	OTfW61lfjBs+HptcTdmrTE7wC6ambsbSNEgiZmvKfNs3hLDbAj4PvKJJtV0HMeVqY6s=
X-Gm-Gg: ASbGncvX5UlzN9r3kJiSjhmyPS60WwOWbp1AzoXa0veuqNkpjXk6Mpw1EmyyCiCjeuV
	lPRi3l9TncWnbsCvJdsVNkytJ02Et9De6rniPoIvtrEJKuzapYdJh302jXByR4AgNwDm2ook51f
	3av+X3xtzAhCKgu6IpEM9H+2XG6VGYyy8ZMYUMYREtGu0ItbfG/2TEGN0mJH1k29bfNSGCywW2m
	QrANk0aqnAfKTgEzK21tP1xtnaFdyO7S3oAZlefn0C71O2vFVQBXNf2uVN8nv88JdMb/JqRk2vQ
	5WZKFQeFU9l6o9GtMAmfwLaQ4473VgFPIsjdBD5HHxSKRCeLWC73z1PPNDhc8uMOa5veG06IO2u
	/P7Vf5LZ+z4lLXxUx1VyW3wNiIcDoRWMThrwuNZYcCzGVP8oSDnCs96JT7S9V4jBX138HqaN4Tn
	QoKd1DCP4jxA1sCR+R6faeLg1UQ/Oa2GSTlpwt0mxpd2g=
X-Google-Smtp-Source: AGHT+IGtaSx6QtlDHy/EycHh0/ZhW1Mmm/5WCyQeOiw9mC05LvLWss/kOLCaCs1PZ52vi6bPz95ITQ==
X-Received: by 2002:a05:6000:310b:b0:42b:3b4c:f411 with SMTP id ffacd0b85a97d-42b4bdb06f1mr4248875f8f.36.1762981643683;
        Wed, 12 Nov 2025 13:07:23 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b2e96441dsm28506596f8f.23.2025.11.12.13.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Nov 2025 13:07:23 -0800 (PST)
Message-ID: <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org>
Date: Wed, 12 Nov 2025 22:07:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251112181357.38999-1-sebott@redhat.com>
 <20251112181357.38999-3-sebott@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251112181357.38999-3-sebott@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 12/11/25 19:13, Sebastian Ott wrote:
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
> 
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>   docs/system/arm/cpu-features.rst |  5 +++
>   target/arm/cpu.h                 |  6 +++
>   target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>   3 files changed, 74 insertions(+), 1 deletion(-)


> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 0d57081e69..e91b1abfb8 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>       ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>   }
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


> @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>                                kvm_steal_time_set);
>       object_property_set_description(obj, "kvm-steal-time",
>                                       "Set off to disable KVM steal time.");
> +
> +    object_property_add_str(obj, "kvm-psci-version", kvm_get_psci_version,
> +                            kvm_set_psci_version);
> +    object_property_set_description(obj, "kvm-psci-version",
> +                                    "Set PSCI version. "
> +                                    "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3");

Could we enumerate from psci_versions[] here?

>   }
Thanks,

Phil.

