Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202941873E2
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 21:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbgCPURn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 16:17:43 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53107 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732467AbgCPURn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 16:17:43 -0400
Received: by mail-pj1-f65.google.com with SMTP id ng8so1925033pjb.2
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 13:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2yW7S1n3gr0Wmk0qZ8ztP7NorwmiXCsES5nj7/m/l2s=;
        b=lOL79TOmLAhOOPelKaD2VIxJ8azSNOLBXgkxGer1aFJdDHP1Q15mIaKCKsAgieJfCz
         iIsEJkPjvaqmZEBsjzvL2OfIMhCplUv5MXEUi2QHyfxqNMcNyDUnbUlgZMcu/zB81WtH
         gRPCUc9FTR/GDj9vkyF+6dJ36N5oG9FH4E9MiIECxl+I+Pysp0cAa/7hTZjJTOJSvfzD
         rve3rydC76PoRy2zpe7yIq+aTMVo1jrxNDx4FlH5ctnoM0x+4GcHTYqoXUVrdl6Reelu
         DUiHA7eEtnUl8ivnyP9PPFykGKHZQD4J8Qd3cdyT0+2oRf05TyfA9ktCteVYvHQAPHwv
         l0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2yW7S1n3gr0Wmk0qZ8ztP7NorwmiXCsES5nj7/m/l2s=;
        b=JKKzZ6HccSeuCmwOIYvXUKULhLuOSSlTPJk9nWHt8LjpbwE0CcbJNvcgkA6iT9cX2m
         t0PylifvU4/N0hVjKGpwkxUB8Q5Q1H9+H98V3euxmgOzYJQ2vYVZjmqC3ltI5fLRL5Ay
         gdZdqOZTUufu/8BXUqkqw03cf3duYh4RsSF12voB5+35hkcGXCd9HeaDKV4patotqwyo
         TYYFR05o/8mgH5VIQKGYBlGcJc164Ro2VuBn8XWpTfzd9+dsKd+ezO3PAVM+QLBW2jvl
         jWtkvGnPAK1yf9xhIg7AEK393TwVgiypJyypiZFF5Vgt/JJB8r3wfUxacAtVTM7t6/eh
         Erpw==
X-Gm-Message-State: ANhLgQ1VyVcffCgJrPy/BB8/xKItcNQ2ZB+8EWvOUKcBTEmCDrnJOQOM
        5pTY4ki25EXeS+A8bJjEt0NIgA==
X-Google-Smtp-Source: ADFU+vth/TIZRKQ+ne19YZSby2Ty7zpQb7LvvexFS2GGoAPSTqzbmzzEvmtJN4ay/ktxRf/Mc3hJDw==
X-Received: by 2002:a17:90a:e384:: with SMTP id b4mr1234622pjz.89.1584389862018;
        Mon, 16 Mar 2020 13:17:42 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id gc16sm593969pjb.8.2020.03.16.13.17.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 13:17:41 -0700 (PDT)
Subject: Re: [PATCH v3 05/19] target/arm: Restrict Virtualization Host
 Extensions instructions to TCG
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-6-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <9cff4a7a-e404-fcc4-eb04-fdbc48ceb7c2@linaro.org>
Date:   Mon, 16 Mar 2020 13:17:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-6-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> Under KVM the ARMv8.1-VHE instruction will trap.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  target/arm/helper.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)

What happened to the uses of these functions?


r~

> 
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index a5280c091b..ce6778283d 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -2897,16 +2897,6 @@ static void gt_virt_ctl_write(CPUARMState *env, const ARMCPRegInfo *ri,
>      gt_ctl_write(env, ri, GTIMER_VIRT, value);
>  }
>  
> -static void gt_cntvoff_write(CPUARMState *env, const ARMCPRegInfo *ri,
> -                              uint64_t value)
> -{
> -    ARMCPU *cpu = env_archcpu(env);
> -
> -    trace_arm_gt_cntvoff_write(value);
> -    raw_write(env, ri, value);
> -    gt_recalc_timer(cpu, GTIMER_VIRT);
> -}
> -
>  static uint64_t gt_virt_redir_cval_read(CPUARMState *env,
>                                          const ARMCPRegInfo *ri)
>  {
> @@ -2949,6 +2939,17 @@ static void gt_virt_redir_ctl_write(CPUARMState *env, const ARMCPRegInfo *ri,
>      gt_ctl_write(env, ri, timeridx, value);
>  }
>  
> +#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
> +static void gt_cntvoff_write(CPUARMState *env, const ARMCPRegInfo *ri,
> +                              uint64_t value)
> +{
> +    ARMCPU *cpu = env_archcpu(env);
> +
> +    trace_arm_gt_cntvoff_write(value);
> +    raw_write(env, ri, value);
> +    gt_recalc_timer(cpu, GTIMER_VIRT);
> +}
> +
>  static void gt_hyp_timer_reset(CPUARMState *env, const ARMCPRegInfo *ri)
>  {
>      gt_timer_reset(env, ri, GTIMER_HYP);
> @@ -2976,6 +2977,7 @@ static void gt_hyp_ctl_write(CPUARMState *env, const ARMCPRegInfo *ri,
>  {
>      gt_ctl_write(env, ri, GTIMER_HYP, value);
>  }
> +#endif /* !CONFIG_USER_ONLY && CONFIG_TCG */
>  
>  static void gt_sec_timer_reset(CPUARMState *env, const ARMCPRegInfo *ri)
>  {
> 

