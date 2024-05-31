Return-Path: <kvm+bounces-18506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8029F8D5B66
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:27:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20ECA1F26396
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 07:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D5481729;
	Fri, 31 May 2024 07:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KwheFSxl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCE42B9AB
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 07:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717140423; cv=none; b=g85DEWuIrUzoIcEJHg+WaTN0nC69YxWfYsOFxNcU9gWymojrvh4NyTdUDt/MOr7QKsk+3+ZQVbahGdwWTD8b6f6wzOkMod3vQc1RF/fQQ0Cmu4ysyVZL0cVOrNUa3v1zuE6Q5y/t2fZxqJzP956Xm9/7mKgeyU920QpryAU//fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717140423; c=relaxed/simple;
	bh=xygDCF8bTfNRyqKUn1Ey5vxVlAoQdeZuaoHnz6ueYEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n3ZEyFoptP6QqtAqmRJtJ5phdkeOHd4JC58q4dweRihKC3cwxRjcedaSJWA6MEW/BachYlN38JvgIVY5PAU1iC54LTVpXYrfuF35bmk2Fvydchaox199+zGASKa8rGrqRte1GjyVfErQ+XdJVhoO1TerhiNfF2Yf7co5pi060P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KwheFSxl; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-420180b5922so22404555e9.2
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 00:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717140419; x=1717745219; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ant7jxHVRejyAoPAAXug0LhwHkLSC8vuMIfNaUfNm3s=;
        b=KwheFSxlmRn14o3qVFeXsOZ7DVcNp3rGtQFIDBZ4g+z0wgZbvAVmp3tbyFIEuITpHx
         /21VPsFsz3Bq/mu9iolw0/OtZTasDqzTAFTLmLT6oP7MaoNSujXdXDTo8awcATdmM7dq
         pVBc4CvXi545NlPycrfbThi+w9cnYfvqE8YBPMMbLX+3ulcIw84ihGRyRubmL6ZD+laq
         fapeoQq1hCbPAzDR7maHrwTya5cj9f7yjZpwcvSSl8ycCI9Z4GCgpIQTTj0hk13codjo
         JfUdLNlSTGnmsK2MdrPQRF45NZN6mGPDU5GPS/gwtpdSvH16NvwQfGlXRGmTxb/9wun0
         ap0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717140419; x=1717745219;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ant7jxHVRejyAoPAAXug0LhwHkLSC8vuMIfNaUfNm3s=;
        b=o6fYL38eZS1uApG5rbqxvihzwhVyvgJp9xD8uDSAlK3yFzpPWjhbj1xHTI1Q9fXRwP
         Otzoy9aKWYhIs5tyNQMRIQUyjRtD0UxKx1cg5o18mstT7RlDHGuZRPajUlE969hXzGs2
         PsXesZdST6O9ueIOP7HeZef7+dfBKW7GicFjMzo4NvUouJ7lNoBqq0lomEXlbOIj/VEd
         QicM3HYsjMokmakk/mRBBTMUH0w0LaNbBgOkf+C5suXMcrqFVBfyTVRe6scJ6dhEVdjT
         yIU0Oae2X8oMzeksAlq0l6UEesUINFMgmV9NbdOEl0253JMekleiIkgdItcOnsXLu3+v
         4/8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVfOWpH4/6eL3DYJrBr1iT9IDK31dw7ySvyp87/A+Abh4ShHFX6AZIGxZnqU28DU101Leqgyn2/lH2vbRO+G7vPvfoB
X-Gm-Message-State: AOJu0YyVqeNAimxhNyjeyBsq5gGGj0wzLpRDAuVv6nPlm2mkx5yCD9vb
	4aBXul0Jo9SKQQu7YfVUjSQELWbGt7yEDSZt4AuUjiEUwBTKqhi2VL3pfzukrmo=
X-Google-Smtp-Source: AGHT+IEm8tqDLqUjwwHRGtH66f8shMdjDJ8znW1PQcz/gPTM/wAUU0kQZP29ZFwTN/rBEBGKXt44jw==
X-Received: by 2002:a05:600c:198b:b0:420:71f7:9752 with SMTP id 5b1f17b1804b1-4212e075534mr11152275e9.18.1717140419395;
        Fri, 31 May 2024 00:26:59 -0700 (PDT)
Received: from [192.168.69.100] (sml13-h01-176-184-15-35.dsl.sta.abo.bbox.fr. [176.184.15.35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42127056366sm46039335e9.3.2024.05.31.00.26.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 00:26:58 -0700 (PDT)
Message-ID: <1c950cd6-9ee0-4b40-b9d6-3cc422046d65@linaro.org>
Date: Fri, 31 May 2024 09:26:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] core/cpu-common: initialise plugin state before
 thread creation
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Yanan Wang <wangyanan55@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Reinoud Zandijk
 <reinoud@netbsd.org>, kvm@vger.kernel.org,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
 <20240530194250.1801701-6-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240530194250.1801701-6-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/5/24 21:42, Alex Bennée wrote:
> Originally I tried to move where vCPU thread initialisation to later
> in realize. However pulling that thread (sic) got gnarly really
> quickly. It turns out some steps of CPU realization need values that
> can only be determined from the running vCPU thread.

FYI: 
https://lore.kernel.org/qemu-devel/20240528145953.65398-6-philmd@linaro.org/

> However having moved enough out of the thread creation we can now
> queue work before the thread starts (at least for TCG guests) and
> avoid the race between vcpu_init and other vcpu states a plugin might
> subscribe to.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   hw/core/cpu-common.c | 20 ++++++++++++--------
>   1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
> index 6cfc01593a..bf1a7b8892 100644
> --- a/hw/core/cpu-common.c
> +++ b/hw/core/cpu-common.c
> @@ -222,14 +222,6 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
>           cpu_resume(cpu);
>       }
>   
> -    /* Plugin initialization must wait until the cpu start executing code */
> -#ifdef CONFIG_PLUGIN
> -    if (tcg_enabled()) {
> -        cpu->plugin_state = qemu_plugin_create_vcpu_state();
> -        async_run_on_cpu(cpu, qemu_plugin_vcpu_init__async, RUN_ON_CPU_NULL);
> -    }
> -#endif
> -
>       /* NOTE: latest generic point where the cpu is fully realized */
>   }
>   
> @@ -273,6 +265,18 @@ static void cpu_common_initfn(Object *obj)
>       QTAILQ_INIT(&cpu->watchpoints);
>   
>       cpu_exec_initfn(cpu);
> +
> +    /*
> +     * Plugin initialization must wait until the cpu start executing
> +     * code, but we must queue this work before the threads are
> +     * created to ensure we don't race.
> +     */
> +#ifdef CONFIG_PLUGIN
> +    if (tcg_enabled()) {
> +        cpu->plugin_state = qemu_plugin_create_vcpu_state();

Per https://etherpad.opendev.org/p/QEMU_vCPU_life, plugin_state could
be initialized in AccelCPUClass::cpu_instance_init (although this
callback is called at CPUClass::instance_post_init which I haven't
yet figured why).

> +        async_run_on_cpu(cpu, qemu_plugin_vcpu_init__async, RUN_ON_CPU_NULL);
> +    }
> +#endif
>   }
>   
>   static void cpu_common_finalize(Object *obj)


