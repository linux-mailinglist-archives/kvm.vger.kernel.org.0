Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A779230960D
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 15:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhA3OvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 09:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbhA3Osu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 09:48:50 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5BEC06174A
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 06:48:08 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v15so11803169wrx.4
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 06:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GlgDHR3ZqZqWGwjAMNZSIHStR7gOfs1UN1h7d6dVVjA=;
        b=WVUeCXW/DrQyxBNC0dV2M+zXhJprCPvF3rX8dxM6GE61Gd9pjyJPsux/WYUSLPsU3f
         brfFGowIJbC1H0wT7zBYlscqqF6lAQBoRvVvfAC+FjmXq8RKrtDy7kaW4Jjpn14qEtsm
         FObrStJiF4166Vpj+I9yzLm8+SMdBorTwUJ3vLxuYg7LriBN0oqmTcAc4rYYkSnRXyXI
         ScxXum9So4d2fVh8nhyHwgXy1T3AILQPEvikuL/+gIdEEGVL9Gdt237B0/v5l2cVhgb2
         DqEG+m+c/fqfuQsrg73OlP2VqbvkoYJxa8+SdU/JLnfe38m0hTg97pW/+aizmGTlhMqC
         C1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GlgDHR3ZqZqWGwjAMNZSIHStR7gOfs1UN1h7d6dVVjA=;
        b=IQXuVBs9au7rhEXvdBki+dujCI2hZYVf0szcAQ0WStBAfDxhzIhBDJCuAD22xE+gqI
         vl5HEWkDGFN8DeRmZZOy/I55eMGkntuFZPMaJWq/9syTLd4KkS+a/aeZx7LVWJeemdqy
         cEkE2/zq1cm6jVRbXsoSK373uad+45mbPFSjnJ9X1/MmuEAmz9NEeZnANDEKPEXtfgf+
         zM7GhpE0yaFalArLgSMZ08HqutDaJv0Kh0Kz/oKECJssukd6/STpxhOuRebi3UiyClAy
         GZRvgPrQXgPJkwd1Yd2cqYonyeLhGw5PrV2Gdx+MhyvTAQ/vjuzQH70mG/65iONBsZTJ
         fQng==
X-Gm-Message-State: AOAM530Mym9TfxsA2QMS/3YjxORyRPteWc1fary4w3+9xu/gfQXiILSx
        ft/EEUY9BXK1xk4JNQBas0U=
X-Google-Smtp-Source: ABdhPJyXHSQk9hGaa07ZqC3MAbMC1wI3kpYj4cKTrV66w37uTSTBJ2RNMrzGc4nxVNR1fl9GP0/TVw==
X-Received: by 2002:adf:ed45:: with SMTP id u5mr9773679wro.358.1612018087373;
        Sat, 30 Jan 2021 06:48:07 -0800 (PST)
Received: from [192.168.1.36] (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id a17sm14650465wrx.63.2021.01.30.06.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jan 2021 06:48:06 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v5 03/11] target/arm: Restrict ARMv4 cpus to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org
References: <20210130015227.4071332-1-f4bug@amsat.org>
 <20210130015227.4071332-4-f4bug@amsat.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <e8502280-5c49-a81a-a1f1-b677adb8d8b3@amsat.org>
Date:   Sat, 30 Jan 2021 15:48:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210130015227.4071332-4-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/30/21 2:52 AM, Philippe Mathieu-Daudé wrote:
> KVM requires a cpu based on (at least) the ARMv7 architecture.
> 
> Only enable the following ARMv4 CPUs when TCG is available:
> 
>   - StrongARM (SA1100/1110)
>   - OMAP1510 (TI925T)
> 
> The following machines are no more built when TCG is disabled:
> 
>   - cheetah              Palm Tungsten|E aka. Cheetah PDA (OMAP310)
>   - sx1                  Siemens SX1 (OMAP310) V2
>   - sx1-v1               Siemens SX1 (OMAP310) V1
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  default-configs/devices/arm-softmmu.mak | 2 --
>  hw/arm/Kconfig                          | 8 ++++++++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
> index 341d439de6f..8a53e637d23 100644
> --- a/default-configs/devices/arm-softmmu.mak
> +++ b/default-configs/devices/arm-softmmu.mak
> @@ -14,8 +14,6 @@ CONFIG_INTEGRATOR=y
>  CONFIG_FSL_IMX31=y
>  CONFIG_MUSICPAL=y
>  CONFIG_MUSCA=y
> -CONFIG_CHEETAH=y
> -CONFIG_SX1=y
>  CONFIG_NSERIES=y
>  CONFIG_STELLARIS=y
>  CONFIG_REALVIEW=y
> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
> index 223016bb4e8..7126d82f6ce 100644
> --- a/hw/arm/Kconfig
> +++ b/hw/arm/Kconfig
> @@ -1,3 +1,7 @@
> +config ARM_V4
> +    bool
> +    depends on TCG
> +
>  config ARM_VIRT
>      bool
>      imply PCI_DEVICES
> @@ -31,6 +35,8 @@ config ARM_VIRT
>  
>  config CHEETAH
>      bool
> +    default y if TCG

This doesn't work as being added to all targets...

> +    select ARM_V4
>      select OMAP
>      select TSC210X
