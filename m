Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F054B6A7C6B
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 09:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCBIU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 03:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCBIU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 03:20:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009DE1A640
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 00:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677745182;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3QJC7xrknqCUo3QneAi3gtan/QiuwSf0HXodYL5voFQ=;
        b=aPmyZbwLCW7pAtAxAOs0YXKXxtqCOYcky8vM0S10zFDKSJzgMhPjZuvHQ7A3+XJSTd6aAO
        85Tx9oAjVNJUnDC1H2DeNqCuhM4z9hUk27mEpCRkoHiYjt/CqTsiZP0Zt6UAF1u3BBNPjk
        bj2upZwNyrqmXh+scT07dc4i622ZvNs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-278-TKrkba8uMf-OBtneiNu1Pg-1; Thu, 02 Mar 2023 03:19:41 -0500
X-MC-Unique: TKrkba8uMf-OBtneiNu1Pg-1
Received: by mail-qk1-f197.google.com with SMTP id 19-20020a370c13000000b007428253bb55so9626703qkm.23
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 00:19:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3QJC7xrknqCUo3QneAi3gtan/QiuwSf0HXodYL5voFQ=;
        b=HCCvl6b24pHf9qgiMkwC+mCT+YWvJjqP80z/4WVvoX8lFdb0Ttr/CY9AQOCpxDQp6Z
         XouOvCy6e+p1NLIWzwGR9BKrrRWZn2d82wP5+7mCAThWnOe1jzD8YvkD1V1HK9kIjmj8
         b7pEXwatyllbnPH1h/ZGd8a9sUm6lhHfzOJHUz271DrSdMQr/Rho2h8ls0sqSN3wCSmt
         ISVI+2Bsf8IsKmdt+hGAWRR2jchaH9br/9uHVu4mfnDsfPSSnmT/wMg4sjoTOND13hNW
         EwJrvnnOPCiOJC4xQ71NvxU3MGxCSyBD+p8qdcrkuacs0mOv4ahgJiID8SenCFG5ina+
         V/hQ==
X-Gm-Message-State: AO0yUKWUoziEu6o7Fn+NLj5d5zDLmD9EQSAiat93XKcPLqXVq8y6xArK
        MxAx7QlYZ/V/Io0bxaP7XruEPHpVZGXyvxqEVHlrdVDU8WVxJT5mejxVXr1MMUOOBxjgAeIJBWt
        ffj/xM9ohRIIbwcgaBQ==
X-Received: by 2002:a05:622a:1306:b0:3bd:1835:b001 with SMTP id v6-20020a05622a130600b003bd1835b001mr17100248qtk.20.1677745180484;
        Thu, 02 Mar 2023 00:19:40 -0800 (PST)
X-Google-Smtp-Source: AK7set9aLD2f3rBaPdQofL9Ou9Zba6yEy0mtfG4HkKo550DSwBneHUAn/2VtsAVxHAqpjBANLxb/Kg==
X-Received: by 2002:a05:622a:1306:b0:3bd:1835:b001 with SMTP id v6-20020a05622a130600b003bd1835b001mr17100237qtk.20.1677745180263;
        Thu, 02 Mar 2023 00:19:40 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f7-20020ac80147000000b003b2957fb45bsm9910169qtg.8.2023.03.02.00.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 00:19:39 -0800 (PST)
Message-ID: <a9799d3b-e7c5-89fd-a910-b574cff67913@redhat.com>
Date:   Thu, 2 Mar 2023 09:19:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [RESEND kvm-unit-tests 1/3] arm: gic: Write one bit per time in
 gic_irq_set_clr_enable()
Content-Language: en-US
To:     Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        "open list:ARM" <kvm@vger.kernel.org>
References: <20230302030238.158796-1-shahuang@redhat.com>
 <20230302030238.158796-2-shahuang@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230302030238.158796-2-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shaoqin,

On 3/2/23 04:02, Shaoqin Huang wrote:
> When use gic_irq_set_clr_enable() to disable an interrupt, it will
> disable all interrupt since it first read from Interrupt Clear-Enable
> Registers and then write this value with a mask back.

nit: it first read from Interrupt Clear-Enable Registers where '1' indicates that forwarding of the corresponding interrupt is enabled

>
> So diretly write one bit per time to enable or disable interrupt.
directly
> Fixes: cb573c2 ("arm: gic: Introduce gic_irq_set_clr_enable() helper")
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eirc
> ---
>  lib/arm/gic.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 1bfcfcf..89a15fe 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -176,7 +176,6 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
>  void gic_irq_set_clr_enable(int irq, bool enable)
>  {
>  	u32 offset, split = 32, shift = (irq % 32);
> -	u32 reg, mask = BIT(shift);
>  	void *base;
>  
>  	assert(irq < 1020);
> @@ -199,8 +198,7 @@ void gic_irq_set_clr_enable(int irq, bool enable)
>  		assert(0);
>  	}
>  	base += offset + (irq / split) * 4;
> -	reg = readl(base);
> -	writel(reg | mask, base);
> +	writel(BIT(shift), base);
>  }
>  
>  enum gic_irq_state gic_irq_state(int irq)

