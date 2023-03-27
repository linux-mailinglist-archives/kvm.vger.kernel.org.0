Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BCD6CAD00
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 20:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjC0S0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 14:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjC0SZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 14:25:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD6F2D59
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 11:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679941515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/sArzJWw5iWwIUzUeDPltEnck8V+Nc5emccaqlU7aVM=;
        b=RM00e+lNjPH4FtLolNaTG6lM3rOf0bY7YsT0KVZ7j8AAXFuQ3Vh0GidZi7BX8JwDkIkhzP
        HNjV1DLWymVgq0gNHPFLOCTAvTyXk0+9sceyhJC0ch3n0eT4lj2WlE8lnqDvs5tYT1agDp
        yix86Bjjh8C/emydl6RWAxvPd6vQJFQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-iEymTRCzNgmwK55Wg4wq5A-1; Mon, 27 Mar 2023 14:25:13 -0400
X-MC-Unique: iEymTRCzNgmwK55Wg4wq5A-1
Received: by mail-qv1-f71.google.com with SMTP id e1-20020a0cd641000000b005b47df84f6eso3998920qvj.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 11:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679941513;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/sArzJWw5iWwIUzUeDPltEnck8V+Nc5emccaqlU7aVM=;
        b=ZGcjFFe27zszviGNwsNziJvW/CsSz88c2W2zR6HGUjeI89Tgtmc/d2nylGvh8NAzBk
         /Xvd5h9OVr/N2pjbr1qiHl/YrmqCPjPm5DRtmYJm59aUlMTmVbhnf66HVlb9eqS9AIkU
         dTTa4VkZCK7+jiDP7SJEu7QAio87o85W9nVunizdrDEpnC4EYpRXqj7KDBTFLYOZJSAw
         fNt/brgDZ5N7izqoG9tz5oVVNVZdqi7hQofuihRQbhC0IIX9+bsN8StUYA2IufnlLUsN
         RFe75o/b5qtnGfLBev4RRPssNLk3+USgFJ6+Wz85KU9GKrl0IK/iGftIImwVkR8KdkeR
         2VEw==
X-Gm-Message-State: AAQBX9cMeZ/2HEiT10OG4ZewXfd15JopUEvaFrmWpYLGVEFsPSTwswFa
        DMATsAumyu+AafI/97bYSDgBusi/bMA2aM6X2SqQCHh8hXOya3PQQZexlYXFjZZlcWzP/07xU69
        scX3mC7ReSS/G
X-Received: by 2002:a05:6214:dc9:b0:5ad:d8f9:63bf with SMTP id 9-20020a0562140dc900b005add8f963bfmr26636139qvt.0.1679941513213;
        Mon, 27 Mar 2023 11:25:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350bJKKDLVvr9aH5bzFkb5xrc73EcAcyl/5jc7xZ6chcol0D4u4jhQvqi/wox6cn3S5EOalPLRA==
X-Received: by 2002:a05:6214:dc9:b0:5ad:d8f9:63bf with SMTP id 9-20020a0562140dc900b005add8f963bfmr26636120qvt.0.1679941512996;
        Mon, 27 Mar 2023 11:25:12 -0700 (PDT)
Received: from [192.168.8.106] (tmo-097-40.customers.d1-online.com. [80.187.97.40])
        by smtp.gmail.com with ESMTPSA id ks10-20020a056214310a00b005dd8b934573sm3165431qvb.11.2023.03.27.11.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 11:25:12 -0700 (PDT)
Message-ID: <929e32fe-c011-4bbd-3a52-6d9e7b89d460@redhat.com>
Date:   Mon, 27 Mar 2023 20:25:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH] compiler.h: Make __always_inline match
 glibc definition, preventing redefine error
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>
References: <20230327122248.2693856-1-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230327122248.2693856-1-npiggin@gmail.com>
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

On 27/03/2023 14.22, Nicholas Piggin wrote:
> This makes __always_inline match glibc's cdefs.h file, which prevents
> redefinition errors which can happen e.g., if glibc limits.h is included
> before kvm-unit-tests compiler.h.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> I ran into this with some powerpc patches. I since changed include
> ordering in that series so it no longer depends on this change, but it
> might be good to have this to be less fragile.
> 
> Thanks,
> Nick
> 
>   lib/linux/compiler.h | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
> index 6f565e4..bf3313b 100644
> --- a/lib/linux/compiler.h
> +++ b/lib/linux/compiler.h
> @@ -45,7 +45,14 @@
>   
>   #define barrier()	asm volatile("" : : : "memory")
>   
> -#define __always_inline	inline __attribute__((always_inline))
> +/*
> + * As glibc's sys/cdefs.h does, this undefines __always_inline because
> + * Linux's stddef.h kernel header also defines it in an incompatible
> + * way.
> + */
> +#undef __always_inline
> +#define __always_inline __inline __attribute__ ((__always_inline__))
> +
>   #define noinline __attribute__((noinline))
>   #define __unused __attribute__((__unused__))
>   

Thanks, applied.

  Thomas

