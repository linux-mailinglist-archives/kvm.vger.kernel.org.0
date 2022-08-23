Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA0B59E63A
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 17:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbiHWPme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 11:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiHWPmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 11:42:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF29C6B63
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 04:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661254578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWAIpqZCo/YbfxY6NPrKM8AVq0gUD7UTSGJxiD5/WhE=;
        b=WOtVRMm9400RGcDly/D9BpKAaaqQQWI9MRO1aIDJ7faGFZ6ESTdpGX3bQOGUgQAb4Ofy//
        90yUb7/x4b4re49XdMkuQhxS+zvDgJGj9mDBEOzjqYoppDJKw7r4rppEe76Nq+EwO565hr
        BgWJs3wAoh94tncrgLOHNP62LLvTKZI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-511-KnkyucaPNh2ik6qkoyCNzg-1; Tue, 23 Aug 2022 07:14:28 -0400
X-MC-Unique: KnkyucaPNh2ik6qkoyCNzg-1
Received: by mail-wm1-f70.google.com with SMTP id x16-20020a1c7c10000000b003a5cefa5578so2680089wmc.7
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 04:14:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=NWAIpqZCo/YbfxY6NPrKM8AVq0gUD7UTSGJxiD5/WhE=;
        b=pmuODF//J5Vtz48EpSnIZ4AfI4NNTOMK1bTo5lQzUXRelBEPpUrN8vvXueceu1IYhb
         eI4zbHL7H6aoV1LmUAbkFfkBK5jY3yWR2BdlE5PdfyhGP7ioUo21D7PcgssrofkclKbN
         CYtxhmqLfaniwi9UqrzHWYqD7UnALqLy0iHt8wU2NHE0yvmvKSCBEHYooSrOJtxdhiLd
         jmE3Q3nqq/UZIiDf/oHfvqJq1aJR31zEJNFP9tPCZz+W4A/mxZdRK4uGAro7UUYCUzDE
         A+h/44ea+GAXRBf7XlijcbfAbFlSdqNbM08eWecaeTkOGqWGcozZdvvBMZ+UftocAMVp
         Muyg==
X-Gm-Message-State: ACgBeo3VM7oKRD2nC4tR045v4tCpcxrA4yKWrrLyCni26YRwnNMMn0YV
        ETVCPqNlWIxeVLV/xKh2cRrYfyBIxL2Ta6RKYOszl6Ha3ZqPMbOl8P5SVKo5iL1+XsRfz/L0Ytv
        6BTYWWdF8T7Rf
X-Received: by 2002:a05:600c:3d93:b0:3a6:1ac3:adf8 with SMTP id bi19-20020a05600c3d9300b003a61ac3adf8mr1815223wmb.125.1661253267642;
        Tue, 23 Aug 2022 04:14:27 -0700 (PDT)
X-Google-Smtp-Source: AA6agR68Go7ZHgHFOzo8w3C0aDQJ8c1URuvw6YpLVzv0GheYFW146cV4UzgXTnPG7st7vtPmgI2vFQ==
X-Received: by 2002:a05:600c:3d93:b0:3a6:1ac3:adf8 with SMTP id bi19-20020a05600c3d9300b003a61ac3adf8mr1815219wmb.125.1661253267439;
        Tue, 23 Aug 2022 04:14:27 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-178-217.web.vodafone.de. [109.43.178.217])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c4ecb00b003a4c6e67f01sm24459880wmq.6.2022.08.23.04.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 04:14:27 -0700 (PDT)
Message-ID: <0ab27747-8087-8809-a65d-e752743140a4@redhat.com>
Date:   Tue, 23 Aug 2022 13:14:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v6 2/4] lib/s390x: add CPU timer related
 defines and functions
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220823103833.156942-1-nrb@linux.ibm.com>
 <20220823103833.156942-3-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220823103833.156942-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/08/2022 12.38, Nico Boehr wrote:
> Upcoming changes will make use of the CPU timer, so add some defines and
> functions to work with the CPU timer.
> 
> Since shifts for both CPU timer and TOD clock are the same, introduce a
> new constant S390_CLOCK_SHIFT_US for this value. The respective shifts
> for CPU timer and TOD clock reference it, so the semantic difference
> between the two defines is kept.
> 
> Also add a constant for the CPU timer subclass mask.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h |  1 +
>   lib/s390x/asm/time.h     | 17 ++++++++++++++++-
>   2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index e7ae454b3a33..b92291e8ae3f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -78,6 +78,7 @@ struct cpu {
>   #define CTL0_EMERGENCY_SIGNAL			(63 - 49)
>   #define CTL0_EXTERNAL_CALL			(63 - 50)
>   #define CTL0_CLOCK_COMPARATOR			(63 - 52)
> +#define CTL0_CPU_TIMER				(63 - 53)
>   #define CTL0_SERVICE_SIGNAL			(63 - 54)
>   #define CR0_EXTM_MASK			0x0000000000006200UL /* Combined external masks */
>   
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 7652a151e87a..d8d91d68a667 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -11,9 +11,13 @@
>   #ifndef _ASMS390X_TIME_H_
>   #define _ASMS390X_TIME_H_
>   
> -#define STCK_SHIFT_US	(63 - 51)
> +#define S390_CLOCK_SHIFT_US	(63 - 51)
> +
> +#define STCK_SHIFT_US	S390_CLOCK_SHIFT_US
>   #define STCK_MAX	((1UL << 52) - 1)
>   
> +#define CPU_TIMER_SHIFT_US	S390_CLOCK_SHIFT_US
> +
>   static inline uint64_t get_clock_us(void)
>   {
>   	uint64_t clk;
> @@ -45,4 +49,15 @@ static inline void mdelay(unsigned long ms)
>   	udelay(ms * 1000);
>   }
>   
> +static inline void cpu_timer_set_ms(int64_t timeout_ms)
> +{
> +	int64_t timer_value = (timeout_ms * 1000) << CPU_TIMER_SHIFT_US;
> +
> +	asm volatile (
> +		"spt %[timer_value]\n"
> +		:
> +		: [timer_value] "Q" (timer_value)
> +	);
> +}
> +
>   #endif

Reviewed-by: Thomas Huth <thuth@redhat.com>

