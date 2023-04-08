Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4774F6DB8CA
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 06:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDHEYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 00:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDHEYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 00:24:09 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA9ED339
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 21:24:08 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id r13-20020a17090a940d00b0023f07253a2cso271649pjo.3
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 21:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680927847;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SUf3WfCxOVdR+3bfJfHcevGewv4Q85VTTJ9AWC0Fz3A=;
        b=M6ule4MSP61kRkiYLQckGXwG36BBy88n1C4e4q/MbZ4jPqsZVxpVsrW+/hlEu7cN4G
         FKgL1hm9EUnD+E3l6NWRfNX/pk0kMMRdrk7sKYqtgBw+WvVLXQ43L+1XGc/goQjDKAvm
         RMJm0fFNsmJ7KSHZ8BKfwumaTdqFvuKSJbBM1/pAhegO7TuebsgCRh6TXBAVcKeDnJPn
         2i/5MYzTFKIJnJyF+ZJeuQeOLzPiskkObGSLAXorpBG6Vs/bsZw25NSL+3d2TtaVb0IV
         u8q5yj/zReQ5zpMmXo6izob23ZS5U5FQV5R6UGXk9rJSP/7Bf9Kh2saPavjcW7g4AKXm
         +Jdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680927847;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SUf3WfCxOVdR+3bfJfHcevGewv4Q85VTTJ9AWC0Fz3A=;
        b=xwbgJLKjTXSfGtibfyiuBZfr7g0og4AwIOH/QxYohz2C9jrswG6TIiZdc/TtosMJXY
         U5l22hDfv7TFmd7FJDjMdwJ5oe+V1qRmZj1h8NLUM8lE5qPAvqPGpfMg9ybXGKyMKiqd
         3U0hIpAdhEBQzCqRsZP93TRh05n/OGrVtihVi5YtublE3Qcz7zycXuQW7qJU+TlM9iJJ
         7fBaJS/vhL5li6ZCj9AHvxwfpxZxMeKrSqPtm4ypKhEWsR+dTmCxqXH2v6z6J4XFWjMo
         +C8HlWd9wgyzWg9v6Fh0B1y+nuFjlytLRU4KYgfJAhgN99H8pCM7qVgP/vLEtsO7NoeH
         KWWQ==
X-Gm-Message-State: AAQBX9fBaChJLn6nYc8z3SqMtUo37G9xN3pKNPJ3QlqXOGImKRg80xGe
        dx1//T389WXbiISHzewMW7A29g==
X-Google-Smtp-Source: AKy350aTojRcwvS7asuLQjO5JCzvuwE9tyORjUy8gTe5GSqRwTu1Ft3j89YC+lFknwdCZLTFDWHdww==
X-Received: by 2002:a17:90b:33c4:b0:237:161d:f5ac with SMTP id lk4-20020a17090b33c400b00237161df5acmr4835643pjb.36.1680927847525;
        Fri, 07 Apr 2023 21:24:07 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id l11-20020a17090270cb00b0019a997bca5csm3621258plt.121.2023.04.07.21.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 21:24:07 -0700 (PDT)
Message-ID: <28b356e3-fae0-c3b2-e40f-d32bb75f46bb@linaro.org>
Date:   Fri, 7 Apr 2023 21:24:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 04/10] hw/intc/arm_gic: Rename 'first_cpu' argument
Content-Language: en-US
From:   Richard Henderson <richard.henderson@linaro.org>
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-5-philmd@linaro.org>
 <e6e1a695-1dde-4109-e0f7-cd1c9ff73af5@linaro.org>
In-Reply-To: <e6e1a695-1dde-4109-e0f7-cd1c9ff73af5@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/23 21:23, Richard Henderson wrote:
> On 4/5/23 09:04, Philippe Mathieu-Daudé wrote:
>> "hw/core/cpu.h" defines 'first_cpu' as QTAILQ_FIRST_RCU(&cpus).
>>
>> arm_gic_common_reset_irq_state() calls its second argument
>> 'first_cpu', producing a build failure when "hw/core/cpu.h"
>> is included:
>>
>>    hw/intc/arm_gic_common.c:238:68: warning: omitting the parameter name in a function 
>> definition is a C2x extension [-Wc2x-extensions]
>>      static inline void arm_gic_common_reset_irq_state(GICState *s, int first_cpu,
>>                                                                         ^
>>    include/hw/core/cpu.h:451:26: note: expanded from macro 'first_cpu'
>>      #define first_cpu        QTAILQ_FIRST_RCU(&cpus)
>>                               ^
>>
>> KISS, rename the function argument.
>>
>> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
>> ---
>>   hw/intc/arm_gic_common.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Wow, that's ugly.  But a reasonable work-around.

Duh.
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

