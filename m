Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BCB6C67B4
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 13:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCWMNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 08:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCWMNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 08:13:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FFB2410B
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 05:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679573543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=47IZCbNDSGg7hhxdLu0FQ8d8WHV90o4g2qwBwc+O/G8=;
        b=Ln0VVTKTL0L/XPi324YMOEtcsDN6+yv0lFk0dW4EkStzHPjp4EpqKr+dqTRopLsQZeVeoG
        GY+z5alLOR9lhmAxSlmlP2dI0iF3VD+ZVPu2j8PJc31Zt+St7dHirN1JvVm5X/wKhDhcBJ
        rbDgerXFuaYbotfSjBEFRCPU7/EVFtE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-e8h8YcijMaaIuMeY3CwMEA-1; Thu, 23 Mar 2023 08:12:20 -0400
X-MC-Unique: e8h8YcijMaaIuMeY3CwMEA-1
Received: by mail-wm1-f71.google.com with SMTP id iv18-20020a05600c549200b003ee21220fccso4553872wmb.1
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 05:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679573539;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47IZCbNDSGg7hhxdLu0FQ8d8WHV90o4g2qwBwc+O/G8=;
        b=YAjYELCstx7W1025fh6f0PItQEBHKPorPtU26gTEaMZm05uILoY630du2h5yoyYcr1
         E05knNNhkU3xAoZ6QXuHi6u7/uHZS2ctysWmFHuHnZ44iQDaoKaphLXQqj+4LJft3HTn
         4L64PAPT5vothyy6YDLpe0fSycihPI9AZAwr2R85TpuLHCx2obsvzY+ymFZS6vhVuAlc
         IcBW1FNI9KneeOFAwg/DzwAgXs/sFmwY7pSVYD5IVquXU0wzojVi0PcRjWcGe5jz62kb
         GMyD9u5zDX9663O5jFJJ3L2y2sZvTsAzvQGMklphASHqnhU4h4j3gqs8XJxLm7OQvfso
         MhgQ==
X-Gm-Message-State: AO0yUKUejL6anZ8Kdqm7eUWde7e8n/2e7WPUVwogN7t1Ss6jjpv6yEMP
        1VZBrUDvTJukO6+E3GtWq8Q8vEpG8a67jpnF/iBBJZ0rZxMPDDJNkDuYx0bcWDOtjIWAK/Sloxm
        +q9tI9DnPYYaanuYWVUNcQUs=
X-Received: by 2002:a1c:7512:0:b0:3ee:9909:acc8 with SMTP id o18-20020a1c7512000000b003ee9909acc8mr728904wmc.32.1679573539687;
        Thu, 23 Mar 2023 05:12:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set/9iEyxce5NHUdHspeWWBLcGBNstlDq/wdzeMG5S5aJQ+Gtr/kX09u0bOWRqllPlg5DVjy8xg==
X-Received: by 2002:a1c:7512:0:b0:3ee:9909:acc8 with SMTP id o18-20020a1c7512000000b003ee9909acc8mr728889wmc.32.1679573539350;
        Thu, 23 Mar 2023 05:12:19 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-146.web.vodafone.de. [109.43.179.146])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c510900b003ed793d9de0sm6272651wms.1.2023.03.23.05.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 05:12:18 -0700 (PDT)
Message-ID: <de36dbe8-de4a-ba05-12f7-2b8a37ef552a@redhat.com>
Date:   Thu, 23 Mar 2023 13:12:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v2 03/10] powerpc: abstract H_CEDE calls into a
 sleep functions
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-4-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230320070339.915172-4-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/2023 08.03, Nicholas Piggin wrote:
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
>   lib/powerpc/asm/handlers.h  |  2 +-
>   lib/powerpc/asm/ppc_asm.h   |  1 +
>   lib/powerpc/asm/processor.h |  7 +++++++
>   lib/powerpc/handlers.c      | 10 ++++-----
>   lib/powerpc/processor.c     | 42 +++++++++++++++++++++++++++++++++++++
>   powerpc/sprs.c              |  6 +-----
>   powerpc/tm.c                | 20 +-----------------
>   7 files changed, 57 insertions(+), 31 deletions(-)
> 
> diff --git a/lib/powerpc/asm/handlers.h b/lib/powerpc/asm/handlers.h
> index 64ba727..e4a0cd4 100644
> --- a/lib/powerpc/asm/handlers.h
> +++ b/lib/powerpc/asm/handlers.h
> @@ -3,6 +3,6 @@
>   
>   #include <asm/ptrace.h>
>   
> -void dec_except_handler(struct pt_regs *regs, void *data);
> +void dec_handler_oneshot(struct pt_regs *regs, void *data);
>   
>   #endif /* _ASMPOWERPC_HANDLERS_H_ */
> diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
> index 1b85f6b..6299ff5 100644
> --- a/lib/powerpc/asm/ppc_asm.h
> +++ b/lib/powerpc/asm/ppc_asm.h
> @@ -36,6 +36,7 @@
>   #endif /* __BYTE_ORDER__ */
>   
>   /* Machine State Register definitions: */
> +#define MSR_EE_BIT	15			/* External Interrupts Enable */
>   #define MSR_SF_BIT	63			/* 64-bit mode */
>   
>   #endif /* _ASMPOWERPC_PPC_ASM_H */
> diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
> index ac001e1..ebfeff2 100644
> --- a/lib/powerpc/asm/processor.h
> +++ b/lib/powerpc/asm/processor.h
> @@ -20,6 +20,8 @@ static inline uint64_t get_tb(void)
>   
>   extern void delay(uint64_t cycles);
>   extern void udelay(uint64_t us);
> +extern void sleep_tb(uint64_t cycles);
> +extern void usleep(uint64_t us);
>   
>   static inline void mdelay(uint64_t ms)
>   {
> @@ -27,4 +29,9 @@ static inline void mdelay(uint64_t ms)
>   		udelay(1000);
>   }
>   
> +static inline void msleep(uint64_t ms)
> +{
> +	usleep(ms * 1000);
> +}
> +
>   #endif /* _ASMPOWERPC_PROCESSOR_H_ */
> diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
> index c8721e0..296f14f 100644
> --- a/lib/powerpc/handlers.c
> +++ b/lib/powerpc/handlers.c
> @@ -9,15 +9,13 @@
>   #include <libcflat.h>
>   #include <asm/handlers.h>
>   #include <asm/ptrace.h>
> +#include <asm/ppc_asm.h>
>   
>   /*
>    * Generic handler for decrementer exceptions (0x900)
> - * Just reset the decrementer back to the value specified when registering the
> - * handler
> + * Return with MSR[EE] disabled.
>    */
> -void dec_except_handler(struct pt_regs *regs __unused, void *data)
> +void dec_handler_oneshot(struct pt_regs *regs, void *data)
>   {
> -	uint64_t dec = *((uint64_t *) data);
> -
> -	asm volatile ("mtdec %0" : : "r" (dec));
> +	regs->msr &= ~(1UL << MSR_EE_BIT);
>   }
> diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> index ec85b9d..e77a240 100644
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
> @@ -54,3 +56,43 @@ void udelay(uint64_t us)
>   {
>   	delay((us * tb_hz) / 1000000);
>   }
> +
> +void sleep_tb(uint64_t cycles)
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

Wouldn't it be better to first call handle_exception() before moving 
something into the decrementer?

> +		/*
> +		 * H_CEDE is called with MSR[EE] clear and enables it as part
> +		 * of the hcall, returning with EE enabled. The dec interrupt
> +		 * is then taken immediately and the handler disables EE.
> +		 *
> +		 * If H_CEDE returned for any other interrupt than dec
> +		 * expiring, that is considered an unhandled interrupt and
> +		 * the test case would be stopped.
> +		 */
> +		if (hcall(H_CEDE) != H_SUCCESS) {
> +			printf("H_CEDE failed\n");
> +			abort();
> +		}
> +		handle_exception(0x900, NULL, NULL);
> +
> +		now = get_tb();
> +	}
> +}

  Thomas

