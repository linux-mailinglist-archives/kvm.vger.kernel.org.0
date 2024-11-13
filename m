Return-Path: <kvm+bounces-31713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90FD99C693E
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 07:28:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6101B1F23962
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 06:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D02E417B4E1;
	Wed, 13 Nov 2024 06:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I+DWPjRI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D71C1714BC
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 06:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731479314; cv=none; b=OFpgTlPmUvmVyx9/hdOYCTnVtafxA1nnbO5HbBPkKZ+zb4bBUwh5ehglLuVtg0d6FZe4zwSkRahx/Kk67ml7ZoUmqSet0As4GrQrn+ashqLmLKdZgEXqoVsFPQ+vZejPsXEI7RCrck5LJ7bOsO0/B7oWeG0fg74YDwbZsMRadNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731479314; c=relaxed/simple;
	bh=bJpEoLa9wR6aB8KQXz8zxFwUUi3xAhl87Kw/wI78IZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qy8tQW7ZHICfxgs190g01/xBHzJE+XU8Bt6vgonkEVa9m92mYgTQ7lmtFL2pyYfaxoXWYj5Y1V53ltA2mhtDuy/6akTTMaq0yQsGRrDix1CufNSrXUhmB/dfZ6n7ZjC5gj1kmNHPiP+E9Bb1QNFqQoYnaejJEUn38g1GKjVs710=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=I+DWPjRI; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2fb4af0b6beso88883321fa.3
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 22:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731479310; x=1732084110; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7MydHF9t/w/ct/1EMVG3dItdPgKvgvLeI/8cIryhFm4=;
        b=I+DWPjRIY0umYiv7S6Fr+Rczcy/Tw9MhcNF5u+WgIgTrQZg8XW3Th1Bf/McAkGQ6ot
         qNIz2QAqWlj2P6fDgtm5bcW5Klsg7aFwIoEhGYKvvpUPCQcbhWFjzmlRdbRDMKxZemtt
         Aroh3ZajG6ZT/a2WyigCdetb0y56dMdjq8bkrJJYJlXXVdZQ/kNroFrc88BUb19XqLyJ
         cgnZNo25Sn/SBJRfIcecZuWLu5fORiG9Si8FhU2T8IHjt9+/0NMZDwMhmZUSNPfOR//H
         3+ENkmSOjU7uQsKUGQr+m1Zw7fJ2L7zJv2iOKzVBEVTgaEbryDt0qQo5D1XChcxixENZ
         tCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731479310; x=1732084110;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7MydHF9t/w/ct/1EMVG3dItdPgKvgvLeI/8cIryhFm4=;
        b=tVMYOg0pb8JYX2GUGLwtKbGdnlWRXvkNFVhJJlO1VfBUPr+CUI/2/mAjijOpYxDZ40
         mWpac4Jo6tBQe20puimq9sdlZioQKvmeJr6fkEjMWVvzedNPVwU0dxWZ+4H6Q7IsYS08
         s0ncWCla2CjtfaNGEn+yQEm8WEXf3fw4NaTRqlld/dPH5PN/y3RH84f67tBy7FkcZmEA
         Xjc7V/4U50U+Q8sa/ADltWMSA3NCiahS5KjjP4yYEhdsFsHuU1z5UKpQ7HN4VMuHagVR
         gQM69IdxpA42p6Z/KA2dl3O5AR8j/l7d9b+7GmvjKIVNxMKbRkJU/E8VoTCeRd1rDUvD
         Yj+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXrWYKrX88JO1WKdG+NmkWYtX1K1JCRhQEsRlwonaCjhQ9fStYVG0IPi2OlmVF38Cka3wY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXvsCmn5D2a8pUgFcCrr+35L2BfuZjVWU5S2CVHQiAAo1rwYHp
	4xunkp3mBNDnjJPLN+VLAoYg/70uSfQZD/Ez3B76IxZsOYqc2PzOQJ+Y8Tp4G34=
X-Google-Smtp-Source: AGHT+IGKzyDVFYR5ZYN3HiQLZfu0/jwK8IkxuMCc19BP0lOmLqZNHBgQkW5X9nnsF64mV94mzsXOqQ==
X-Received: by 2002:a2e:a551:0:b0:2fa:cdac:8732 with SMTP id 38308e7fff4ca-2ff2028ad8fmr133177161fa.30.1731479310254;
        Tue, 12 Nov 2024 22:28:30 -0800 (PST)
Received: from [192.168.69.126] (cnf78-h01-176-184-27-250.dsl.sta.abo.bbox.fr. [176.184.27.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a17b64sm816138766b.39.2024.11.12.22.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 22:28:29 -0800 (PST)
Message-ID: <fbe5da1d-9a0e-4aa4-91f9-dfb729f39dc9@linaro.org>
Date: Wed, 13 Nov 2024 07:28:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/60] kvm: Introduce kvm_arch_pre_create_vcpu()
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-8-xiaoyao.li@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20241105062408.3533704-8-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 5/11/24 06:23, Xiaoyao Li wrote:
> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
> work prior to create any vcpu. This is for i386 TDX because it needs
> call TDX_INIT_VM before creating any vcpu.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
> Changes in v3:
> - pass @errp to kvm_arch_pre_create_vcpu(); (Per Daniel)
> ---
>   accel/kvm/kvm-all.c  | 10 ++++++++++
>   include/sysemu/kvm.h |  1 +
>   2 files changed, 11 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 930a5bfed58f..1732fa1adecd 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -523,6 +523,11 @@ void kvm_destroy_vcpu(CPUState *cpu)
>       }
>   }
>   
> +int __attribute__ ((weak)) kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)

We don't use the weak attribute. Maybe declare stubs for each arch?

> +{
> +    return 0;
> +}
> +
>   int kvm_init_vcpu(CPUState *cpu, Error **errp)
>   {
>       KVMState *s = kvm_state;
> @@ -531,6 +536,11 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>   
>       trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
>   
> +    ret = kvm_arch_pre_create_vcpu(cpu, errp);
> +    if (ret < 0) {
> +        goto err;
> +    }
> +
>       ret = kvm_create_vcpu(cpu);
>       if (ret < 0) {
>           error_setg_errno(errp, -ret,
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index c3a60b28909a..643ca4950543 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -374,6 +374,7 @@ int kvm_arch_get_default_type(MachineState *ms);
>   
>   int kvm_arch_init(MachineState *ms, KVMState *s);
>   
> +int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
>   int kvm_arch_init_vcpu(CPUState *cpu);
>   int kvm_arch_destroy_vcpu(CPUState *cpu);
>   


