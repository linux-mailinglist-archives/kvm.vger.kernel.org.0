Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7AA6A7C6E
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 09:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCBIU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 03:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCBIU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 03:20:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B991D1D901
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 00:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677745199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoJEO/rrhsWrElsDeh33FRv7UGKPrM+4RlG9La9lfTc=;
        b=BKjth3dLh1BS288iPIR9SKu7NpJ3vjw3QJW5M4gORM5jU3YSYoTH56YjQ6oQg4YFNgcvTa
        JE9Lh/awKYdESEtdA2RBWuHXqn4+ZDOzEi5a9Ki/ZQTBvAlPTJdmOkcmgmOd1atxK5Omph
        FL4uq+orCxoUb36O/up+SEQaJ2as0Z4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-D0vJy8MLNrCBUMLrxQeo2A-1; Thu, 02 Mar 2023 03:19:58 -0500
X-MC-Unique: D0vJy8MLNrCBUMLrxQeo2A-1
Received: by mail-qk1-f198.google.com with SMTP id eb13-20020a05620a480d00b00742be8a1a17so6275338qkb.18
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 00:19:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XoJEO/rrhsWrElsDeh33FRv7UGKPrM+4RlG9La9lfTc=;
        b=IM0NvUVICx/ylq/vksAnwF68O66KNdqGNMfIsRBVL/jxz0cdqcomBMgZtBOsml4/uZ
         O0wql1yLoALZZ6IwylyZwzpriaziNH9vNCnuz5mYX3wtPOxWkw60MoHGSng/xS7vG61z
         Fl/WXUGiGtr12l66Zqv8H42QkYZ/06IWrQDAZ0z05LmfCwKGxvqrHvUuWwAfetxsKhTx
         l3GhPG7y64ebBhBORiApAZ044Mr1OiH1J8JVq1ed5wXusRn4h5hmsCc3AkW4WZzPFjz8
         p/qCVayeG028GQ79ImEr++9Qp31B563Zr4Yxq2HbdCzQn88cTyaCTVixIfCNIs48YryM
         TBTw==
X-Gm-Message-State: AO0yUKWfnPxDPIiIgavsR8fFdFusS0s35qeUGX2GVOrpKPP5ezr+gGu6
        6g+Gt8zcXzr6DO9ayMk3Xx+ZRE91H9J9qfCFOj6qvH7IvXZVdZwZ1Sqv0dcK4WRTbYh05xXimVQ
        4HQ2xzOZLauC8rpnafw==
X-Received: by 2002:a05:622a:1a84:b0:3bf:b6ba:1c1f with SMTP id s4-20020a05622a1a8400b003bfb6ba1c1fmr17689093qtc.10.1677745197468;
        Thu, 02 Mar 2023 00:19:57 -0800 (PST)
X-Google-Smtp-Source: AK7set/f8FUy6jS5OC2id5Rsy6kJpPekovC1uYs9hy0AcMyf273M0RdPVTwqpf0GUC63NUgSX9UIcQ==
X-Received: by 2002:a05:622a:1a84:b0:3bf:b6ba:1c1f with SMTP id s4-20020a05622a1a8400b003bfb6ba1c1fmr17689082qtc.10.1677745197262;
        Thu, 02 Mar 2023 00:19:57 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d5-20020ac86685000000b003bfaf01af24sm9894512qtp.46.2023.03.02.00.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 00:19:56 -0800 (PST)
Message-ID: <58de2175-62f1-a873-872b-dff79c53fec9@redhat.com>
Date:   Thu, 2 Mar 2023 09:19:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RESEND kvm-unit-tests 3/3] arm64: microbench: Use
 gic_enable_irq() macro in microbench test
Content-Language: en-US
To:     Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        "open list:ARM" <kvm@vger.kernel.org>
References: <20230302030238.158796-1-shahuang@redhat.com>
 <20230302030238.158796-4-shahuang@redhat.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230302030238.158796-4-shahuang@redhat.com>
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
> Use gic_enable_irq() to clean up code.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/micro-bench.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 8436612..090fda6 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -212,24 +212,11 @@ static void lpi_exec(void)
>  
>  static bool timer_prep(void)
>  {
> -	void *gic_isenabler;
> -
>  	gic_enable_defaults();
>  	install_irq_handler(EL1H_IRQ, gic_irq_handler);
>  	local_irq_enable();
>  
> -	switch (gic_version()) {
> -	case 2:
> -		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
> -		break;
> -	case 3:
> -		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
> -		break;
> -	default:
> -		assert_msg(0, "Unreachable");
> -	}
> -
> -	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
> +	gic_enable_irq(PPI(TIMER_VTIMER_IRQ));
>  	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>  	isb();
>  

