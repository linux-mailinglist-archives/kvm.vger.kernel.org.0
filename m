Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2746A7C6D
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 09:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjCBIUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 03:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjCBIUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 03:20:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2F222006
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 00:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677745191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zIjaXDXp4WiF/PZhzlcAElDicG/m9VQA0incK69mGeo=;
        b=DlKKPiFvHmXpMEA1i04yqeUuVQFV+cBs+oyF4djGp6GbKsIZxOkcumfi0epNA3S3nL3oHB
        oTTXBBjjfM+uOHy2vupu8+8cLnAsU54eEl12SoEYQoqKUdYDYabEOHVheAP1IuWcLCYTBZ
        9qLePY5iXS0CCOQK8NvyAXnuGRkF7qs=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-FEB20ttcMbmqYKEAePzx2A-1; Thu, 02 Mar 2023 03:19:49 -0500
X-MC-Unique: FEB20ttcMbmqYKEAePzx2A-1
Received: by mail-qv1-f69.google.com with SMTP id l13-20020ad44d0d000000b004c74bbb0affso8430981qvl.21
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 00:19:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zIjaXDXp4WiF/PZhzlcAElDicG/m9VQA0incK69mGeo=;
        b=h/Pm0bjCl0cVEXqUvLSiGEju8TnS9ywWTIGbr4oSvUuFOgz2pr+oZ/ByjQDi9pCJWd
         9A3uuyT9nX4/LEm6nwEm2WpI93iaA2meKGFYRSydQ6QZfDS5YDiNbrM35CB83K8zl1MV
         JkOvEYCtFXxB4NNDSd/UQ0D2RxJI8gNpv4StHQvJ0x7vQjKxGr0/f7nSDq1PHxW/zlsz
         javh8D+FuFp+CyFgH9NzzgyEHvLt7bfG2LvjRhpFMiIEqYpwp2HGVnEdFNeqQmovC1xf
         uWh4d0Kcbg9yFm6PCbFSahFOOV92MfMqHh+/fY6x8jBTRBdzyjL6k3O8fW8jAIIqEzx/
         NaiQ==
X-Gm-Message-State: AO0yUKXX4jhRjgRSdP1BQkk1IsjJ6p1hsqN/YZ0NcAyRMwQz+bIkfh4X
        RXhDtfsA/0Im7WGgAZvS2l+osyqWwFajIIMBi2MwMHysxhF4WM8bh14enZSvTFPdMXfUMPzESvi
        AgKzEEqUyUUro
X-Received: by 2002:a05:6214:29e9:b0:56b:fa99:7866 with SMTP id jv9-20020a05621429e900b0056bfa997866mr15509750qvb.7.1677745189315;
        Thu, 02 Mar 2023 00:19:49 -0800 (PST)
X-Google-Smtp-Source: AK7set9DC0uf3w5/KZdo3iDCN05BT27ad4JPBOOjlaA8gZ1f4js38pJNLws5TY6JsybSloz9MoJvIQ==
X-Received: by 2002:a05:6214:29e9:b0:56b:fa99:7866 with SMTP id jv9-20020a05621429e900b0056bfa997866mr15509741qvb.7.1677745189084;
        Thu, 02 Mar 2023 00:19:49 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id g1-20020a37b601000000b00743049c2b15sm1221359qkf.66.2023.03.02.00.19.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 00:19:48 -0800 (PST)
Message-ID: <830e41b7-2e78-caff-7115-81be321bdad9@redhat.com>
Date:   Thu, 2 Mar 2023 09:19:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RESEND kvm-unit-tests 2/3] arm64: timer: Use
 gic_enable/disable_irq() macro in timer test
Content-Language: en-US
To:     Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        "open list:ARM" <kvm@vger.kernel.org>
References: <20230302030238.158796-1-shahuang@redhat.com>
 <20230302030238.158796-3-shahuang@redhat.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230302030238.158796-3-shahuang@redhat.com>
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



On 3/2/23 04:02, Shaoqin Huang wrote:
> Use gic_enable/disable_irq() to clean up the code.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Thanks

Eric

> ---
>  arm/timer.c | 20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index c4e7b10..c0a8388 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -14,9 +14,6 @@
>  #include <asm/gic.h>
>  #include <asm/io.h>
>  
> -static void *gic_isenabler;
> -static void *gic_icenabler;
> -
>  static bool ptimer_unsupported;
>  
>  static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
> @@ -139,12 +136,12 @@ static struct timer_info ptimer_info = {
>  
>  static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
>  {
> -	u32 val = 1 << PPI(info->irq);
> +	u32 irq = PPI(info->irq);
>  
>  	if (enabled)
> -		writel(val, gic_isenabler);
> +		gic_enable_irq(irq);
>  	else
> -		writel(val, gic_icenabler);
> +		gic_disable_irq(irq);
>  }
>  
>  static void irq_handler(struct pt_regs *regs)
> @@ -366,17 +363,6 @@ static void test_init(void)
>  
>  	gic_enable_defaults();
>  
> -	switch (gic_version()) {
> -	case 2:
> -		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
> -		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
> -		break;
> -	case 3:
> -		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
> -		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
> -		break;
> -	}
> -
>  	install_irq_handler(EL1H_IRQ, irq_handler);
>  	set_timer_irq_enabled(&ptimer_info, true);
>  	set_timer_irq_enabled(&vtimer_info, true);

