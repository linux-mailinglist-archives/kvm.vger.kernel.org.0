Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F442CFB38
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 13:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgLEMAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Dec 2020 07:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729433AbgLELXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Dec 2020 06:23:33 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA5AC0613D1
        for <kvm@vger.kernel.org>; Sat,  5 Dec 2020 03:15:05 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id e7so7807046wrv.6
        for <kvm@vger.kernel.org>; Sat, 05 Dec 2020 03:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vm0kTYRfsbbw/uXa2uKVACoRIfxCWD5Snf9/ZZBS4vI=;
        b=Yr1ZIzDR77DcgbQbUxzYZI0kWHLoTvxPJi6yJox554/E5iE4d4BfyXrcjh9kQanIFl
         7NUcFENYX8B+GnaTBmEk6JDJKwmS3wq9B0aXsIA8x8tpTNywbdy33TOjYqbDxWKM/e5Q
         GRv5p43UpM6pr6oc14g2NF+YOtjmyBxBAasEiVBayB1JolLmXIoOUQwDotq0qLvYgOEH
         eFPxAA3AeVwMsrNQr85hrxbLRcNd892rbKdnEljiKEWwEbUKYagkfFOxrGz4Htc+Iwaw
         sFsVJz1U5Y6deBeak6EVLnN/0xjRCdFKrdESHIIoBJu1LHenlWG1SSleFpgFQYpnxFZ6
         fQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vm0kTYRfsbbw/uXa2uKVACoRIfxCWD5Snf9/ZZBS4vI=;
        b=kVyzzZFCD9Mn6pGYquOKcJGVVbg5S33kRo+SoIKVbF8/eenJL/2laeRI9r7NFCcTZw
         yQ0Xx/QDWB9JGq/p7cwpCc4i0b9myD3ygaiRL4I/GMko9QmMFU+lmB6x5yPw28/+wHqC
         o8HbR/hl+E4VuMe7U6mw6HOZkZnzI9JhUUkH/lHUAMNLCNicoiDviCWiOxsQYhvFot9Z
         XwiALYGuZg6bbV7yKjlaxLvqYsf10PhpcmOxHKezHynjkSxm18y8w8eeQxeLsa+QWHwW
         fIDnalLhx+sx7cJ2ImRFzpM27OmWcp750zl1bJ9fLt820WeQ7xbQ2YMUfhGPewfd0pTq
         q8Fw==
X-Gm-Message-State: AOAM531GA9tgRt67kga9sD8EM7NkxvnRHdsADKP94Wdm4D6iI2XgE0+I
        ri7wd74ORrntLVqMlXN/t7WkAY0yxK7Ujg==
X-Google-Smtp-Source: ABdhPJzidHN37LYdbiTj7YPUSYlEeuJWU1/5ZyiN4M4YFSu2jXb2xdJ0Tww0x7DtBdcHudzvJvASzA==
X-Received: by 2002:adf:a3d1:: with SMTP id m17mr9487100wrb.289.1607166904041;
        Sat, 05 Dec 2020 03:15:04 -0800 (PST)
Received: from ?IPv6:2a01:e34:ed2f:f020:8165:c1cc:d736:b53f? ([2a01:e34:ed2f:f020:8165:c1cc:d736:b53f])
        by smtp.googlemail.com with ESMTPSA id a65sm6470758wmc.35.2020.12.05.03.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 03:15:03 -0800 (PST)
Subject: Re: [PATCH v3 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
To:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        wanghaibin.wang@huawei.com
References: <20201204073126.6920-1-zhukeqian1@huawei.com>
 <20201204073126.6920-3-zhukeqian1@huawei.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <a82cf9ff-f18d-ce0a-f7a2-82a56cbbec40@linaro.org>
Date:   Sat, 5 Dec 2020 12:15:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201204073126.6920-3-zhukeqian1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi Marc,

are you fine with this patch ?


On 04/12/2020 08:31, Keqian Zhu wrote:
> ARM virtual counter supports event stream, it can only trigger an event
> when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0 changes,
> so the actual period of event stream is 2^(cntkctl_evnti + 1). For example,
> when the trigger bit is 0, then virtual counter trigger an event for every
> two cycles.
> 
> Fixes: 037f637767a8 ("drivers: clocksource: add support for ARM architected timer event stream")
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 777d38cb39b0..d0177824c518 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -822,15 +822,24 @@ static void arch_timer_evtstrm_enable(int divider)
>  
>  static void arch_timer_configure_evtstream(void)
>  {
> -	int evt_stream_div, pos;
> +	int evt_stream_div, lsb;
> +
> +	/*
> +	 * As the event stream can at most be generated at half the frequency
> +	 * of the counter, use half the frequency when computing the divider.
> +	 */
> +	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ / 2;
> +
> +	/*
> +	 * Find the closest power of two to the divisor. If the adjacent bit
> +	 * of lsb (last set bit, starts from 0) is set, then we use (lsb + 1).
> +	 */
> +	lsb = fls(evt_stream_div) - 1;
> +	if (lsb > 0 && (evt_stream_div & BIT(lsb - 1)))
> +		lsb++;
>  
> -	/* Find the closest power of two to the divisor */
> -	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
> -	pos = fls(evt_stream_div);
> -	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
> -		pos--;
>  	/* enable event stream */
> -	arch_timer_evtstrm_enable(min(pos, 15));
> +	arch_timer_evtstrm_enable(max(0, min(lsb, 15)));
>  }
>  
>  static void arch_counter_set_user_access(void)
> 


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
