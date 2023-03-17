Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C422F6BE9C9
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 14:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCQNCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 09:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCQNCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 09:02:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C06B3E0C
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 06:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679058080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+u4rPc5mt4tMfyMFk62LMmPtglIUJiHWEfglpwOcBE=;
        b=cykm+2t8lT0p0kaca6FtxkzrLMqCgFFwvFjCcnZSx9cAEPwkgQMvzvH5V6yZXk2/TLQiwb
        TpvM5UySWHoXRUgTwUdvOZV69rGmRUkvh5ZzzPcAO2uZV+TAu3nMT7n5kLwqEWhb1SR5k7
        JgY8zN6VhYhYtIJfkckfebzmu398rqI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-PHFeaADaPQWWUthjTvfH4w-1; Fri, 17 Mar 2023 09:01:19 -0400
X-MC-Unique: PHFeaADaPQWWUthjTvfH4w-1
Received: by mail-wr1-f70.google.com with SMTP id n2-20020adf8b02000000b002d26515fc49so759259wra.17
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 06:01:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679058078;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1+u4rPc5mt4tMfyMFk62LMmPtglIUJiHWEfglpwOcBE=;
        b=BpNWjn0ICaWr3KEE6kXCtQAuX3wtUwrSshRFHyfOA3FJWfAMjUUlbP5ThgtD2oYtLi
         S+tF3Yyy3yx7K6PfRMZIsZS/q7tFFuR3rD3Imu79aPYLl4lPSdmkBmy13oiyYW7UOpxJ
         FuoxR+ZkcAdnaR6e6o6GjzagOpgTTlWNEc+8K5oiJY5v2sE7hSsQ95zF0XhKZHby4kwO
         rfFpj9OgZRpMxIR23Qwoy4ASUsyC/cWRO3YuTOvpCNujoFV9Zi5JHpBxJlEs1s1v2xjL
         4kyVn6frO2k2vsq2A29Pqh4k21sJEiXxQmB/zxoDzNvqnFNPPcfh8MMmBXltyFvnRj+1
         YqpQ==
X-Gm-Message-State: AO0yUKUAk1Dj0J6bGAtvkWieiDx3cQlqWf8cnbcQxyWU7PL966jBWSsi
        /VFzKtknsfdgbvCt+JlUAB6MA7MCYnIRHWhdJ4/mbWCUGfrQzHpSXBGb3xte966VEQZRZI47uCN
        03yIE1pDEDfB5
X-Received: by 2002:a5d:6a4a:0:b0:2cf:3a99:9c1e with SMTP id t10-20020a5d6a4a000000b002cf3a999c1emr6967525wrw.49.1679058077172;
        Fri, 17 Mar 2023 06:01:17 -0700 (PDT)
X-Google-Smtp-Source: AK7set8gg7IA5IehSqTBkPUO4p/6PxmQbiymlGRfGMggrJxSBZOE5w2PIq38aJdSRa6vZG/TH2Td7g==
X-Received: by 2002:a5d:6a4a:0:b0:2cf:3a99:9c1e with SMTP id t10-20020a5d6a4a000000b002cf3a999c1emr6967492wrw.49.1679058076455;
        Fri, 17 Mar 2023 06:01:16 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-176-33.web.vodafone.de. [109.43.176.33])
        by smtp.gmail.com with ESMTPSA id g9-20020a5d4889000000b002c559843748sm1941036wrq.10.2023.03.17.06.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 06:01:15 -0700 (PDT)
Message-ID: <d65643cf-ea6e-7263-8263-52a6c4223aac@redhat.com>
Date:   Fri, 17 Mar 2023 14:01:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH 3/7] powerpc: abstract H_CEDE calls into a
 sleep() function
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230317123614.3687163-1-npiggin@gmail.com>
 <20230317123614.3687163-3-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230317123614.3687163-3-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/2023 13.36, Nicholas Piggin wrote:
> This consolidates several implementations, and it no longer leaves
> MSR[EE] enabled after the decrementer interrupt is handled, but
> rather disables it on return.
> 
> The handler no longer allows a continuous ticking, but rather dec
> has to be re-armed and EE re-enabled (e.g., via H_CEDE hcall) each
> time.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
...
> diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> index ec85b9d..f1fb50f 100644
> --- a/lib/powerpc/processor.c
> +++ b/lib/powerpc/processor.c
> @@ -10,6 +10,8 @@
>   #include <asm/ptrace.h>
>   #include <asm/setup.h>
>   #include <asm/barrier.h>
> +#include <asm/hcall.h>
> +#include <asm/handlers.h>
>   
>   static struct {
>   	void (*func)(struct pt_regs *, void *data);
> @@ -54,3 +56,32 @@ void udelay(uint64_t us)
>   {
>   	delay((us * tb_hz) / 1000000);
>   }
> +
> +void sleep(uint64_t cycles)

When I see a sleep() in a C program, I automatically assume that it's 
parameter is "seconds", so having a sleep() function here that is taking 
cycles as a parameter is confusing. Could you please name the function 
differently?

> +{
> +	uint64_t start, end, now;
> +
> +	start = now = get_tb();
> +	end = start + cycles;
> +
> +	while (end > now) {
> +		uint64_t left = end - now;
> +
> +		/* Could support large decrementer */
> +		if (left > 0x7fffffff)
> +			left = 0x7fffffff;
> +
> +		asm volatile ("mtdec %0" : : "r" (left));
> +		handle_exception(0x900, &dec_handler_oneshot, NULL);
> +		if (hcall(H_CEDE) != H_SUCCESS) {
> +			printf("H_CEDE failed\n");
> +			abort();
> +		}
> +		handle_exception(0x900, NULL, NULL);
> +
> +		if (left < 0x7fffffff)
> +			break;

Shouldn't that be covered by the "end > now" in the while loop condition 
check already?

> +		now = get_tb();
> +	}
> +}

  Thomas

