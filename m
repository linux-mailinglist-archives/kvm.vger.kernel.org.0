Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D861C759CB1
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 19:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjGSRrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 13:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjGSRq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 13:46:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B201735
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 10:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689788771;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xc6omUiqM4jPVbPJYgpEaaN+HCGov9iJZcDyC06CGAU=;
        b=NhKXUjcjVjbHmIajdZJ8x6okuRHWxbVH7nBaK3NOjp2Gg1vz/Q4G15dgm6M5OvEf4bQ+ES
        9rIRDWcLahljHuP4mKsDllUuaBTe32ihuaJAzhA4En9y80f0riAWUYwxE3lLhiPwC6A1ki
        ZXRqu6tMwyJLTWJhN57h3kqMFHMs5T0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-VZHgImW7OKG2Fp4Eds6vNg-1; Wed, 19 Jul 2023 13:46:10 -0400
X-MC-Unique: VZHgImW7OKG2Fp4Eds6vNg-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-765a6bbdd17so828255385a.0
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 10:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689788768; x=1690393568;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xc6omUiqM4jPVbPJYgpEaaN+HCGov9iJZcDyC06CGAU=;
        b=SM5TJ8qORTot8zF3W2PwIOFd1YiEYl0wbCB7B/nvAz+FcBofBG1XLPPTzekWLp+IsC
         JcD+eWqi5ElDNgeK0yvk3S6y+/PSSF4GmY2CNBePakRh1tEBe4r/5rET033u/m4D+Ez+
         moCzGjjqT/REB98mwRdiIJBLVJhwFVJmUkT+AuNXaEUgJ9IYtZFPpC7ZGhepE41cmKgw
         EDPXAoS/rmSeb/MN5UIW/JgvanmAVGvPRunceAzZkcLaVtMVh3VrEIcMpXeQM87gwxK1
         G1FuBEms+6J2K/tOrDFSZJJItLhTZ0vy7YFkoL/SvYU/86WXY+vj0/ygFQPPodng2SkG
         qokA==
X-Gm-Message-State: ABy/qLbW3lJvmab2P/Tmhp/zMxpt/N/EIE7+d5DdvK2r/0/hY+pVW/q+
        TlNL/carMzJSb8dnGE64x5ZKtC9S8Gza3BZqnoiO49K37GxbX5kpDKLqOx/HqHKoYZaAzbh1RhD
        d6CrdHZaFjC5AyT7B/txI
X-Received: by 2002:a05:620a:2446:b0:767:7eb0:f238 with SMTP id h6-20020a05620a244600b007677eb0f238mr307134qkn.27.1689788768213;
        Wed, 19 Jul 2023 10:46:08 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHsKHJqlSDvr/KchOU2+gq87SCeLGOEPTcS1CFerZXsbrHa5+k5zVbCPPD6YHYI4/uDsfhv9A==
X-Received: by 2002:a05:620a:2446:b0:767:7eb0:f238 with SMTP id h6-20020a05620a244600b007677eb0f238mr307122qkn.27.1689788767987;
        Wed, 19 Jul 2023 10:46:07 -0700 (PDT)
Received: from [192.168.43.95] ([37.169.27.8])
        by smtp.gmail.com with ESMTPSA id ou30-20020a05620a621e00b0075941df3365sm1412231qkn.52.2023.07.19.10.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 10:46:07 -0700 (PDT)
Message-ID: <4bf0d5e6-a879-c3ab-6538-a4e3bd762acc@redhat.com>
Date:   Wed, 19 Jul 2023 19:46:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm64: Replace the SCTLR_EL1 filed
 definition by _BITUL()
Content-Language: en-US
To:     Shaoqin Huang <shahuang@redhat.com>, andrew.jones@linux.dev
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20230719031926.752931-1-shahuang@redhat.com>
 <20230719031926.752931-2-shahuang@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230719031926.752931-2-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shaoqin,

On 7/19/23 05:19, Shaoqin Huang wrote:
> Currently the SCTLR_EL1_* is defined by (1 << x), all of them can be
> replaced by the _BITUL() macro to make the format consistent with the
> SCTLR_EL1_RES1 definition.

I would rephrase the commit title into arm64: Use _BITUL() to define
SCTLR_EL1 bit fields

Besides, since SCTLR_EL1 is 64b shouldn't we have _BITULL() everywhere
instead?

Eric
>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  lib/arm64/asm/sysreg.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index 18c4ed3..c7f529d 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -80,14 +80,14 @@ asm(
>  #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>  
>  /* System Control Register (SCTLR_EL1) bits */
> -#define SCTLR_EL1_EE	(1 << 25)
> -#define SCTLR_EL1_WXN	(1 << 19)
> -#define SCTLR_EL1_I	(1 << 12)
> -#define SCTLR_EL1_SA0	(1 << 4)
> -#define SCTLR_EL1_SA	(1 << 3)
> -#define SCTLR_EL1_C	(1 << 2)
> -#define SCTLR_EL1_A	(1 << 1)
> -#define SCTLR_EL1_M	(1 << 0)
> +#define SCTLR_EL1_EE		_BITUL(25)
> +#define SCTLR_EL1_WXN		_BITUL(19)
> +#define SCTLR_EL1_I		_BITUL(12)
> +#define SCTLR_EL1_SA0		_BITUL(4)
> +#define SCTLR_EL1_SA		_BITUL(3)
> +#define SCTLR_EL1_C		_BITUL(2)
> +#define SCTLR_EL1_A		_BITUL(1)
> +#define SCTLR_EL1_M		_BITUL(0)
>  
>  #define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
>  			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))

