Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37456C6673
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 12:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjCWLYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 07:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjCWLYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 07:24:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68951912F
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679570644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3N+CKRtfUVJAYw78KROWLKzIsho1cqPaJZ2vvMVYpHM=;
        b=QOuLeGnfhVd0R+wQb18SaKwL21WdgPtbbc2OFUROeDg9g089+CMdDu6fExSzREfTzMPIHX
        ag8kOvJD4+VDIdOpgwDWi1yzTG0NZpIhx8UTKjlybWN0fejw+sd0QwLPSjtqagvF9GiE5U
        45t4fJVjO/VPdzCCIq0I7WJnTVdTKoc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-eHT3IU9wMT-9o_Go7vUFFQ-1; Thu, 23 Mar 2023 07:24:02 -0400
X-MC-Unique: eHT3IU9wMT-9o_Go7vUFFQ-1
Received: by mail-wm1-f71.google.com with SMTP id bh19-20020a05600c3d1300b003ee93fac4a9so499847wmb.2
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 04:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679570641;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3N+CKRtfUVJAYw78KROWLKzIsho1cqPaJZ2vvMVYpHM=;
        b=ZbLLZXvFKv5Uks9kSkEsb+fjWHNbn46sgstBYFO14958reSr5b28fsSi5/BzQtLd2X
         aN85qVypj/gRst854ET5mYOvcXTKgyVyk6Jbfp3lQigg93t7THCzQoymBP6Y8YposLJL
         fq5Xhb4LdKF5o8SrkfKG4YqVEOdzY4PdHAsmWeLBc7UMen/ksPkd1X8HRBzcmmKSD5Eq
         Fs+/SyejRIHUZSlPWVwBpV0PGnhKGJuaXVlE4Im2BOAyXUM77Og8LwU/Kpog7i3R7W/5
         4qq643TQEckbaiCL5yPEIBAiwQ3Wqa8wbW5egc/CLht+Tp03RaIwo36/w2e83N2GKAfX
         wGtg==
X-Gm-Message-State: AAQBX9eueRXZqkjdVgtGHhwk5AHWH6M1032uqFe58F2IKH6ifG6yM2Ca
        a3QPJLvlrx2wB75KinjfAHEBj0jKzOIhJ5Bqkmn33eNqMMxzZAlPLqjxREEQ9LS0Eg6ec5RBny8
        ej4co7Ga+8x9QZcUK1fEbFts=
X-Received: by 2002:a5d:4848:0:b0:2d2:3b59:cbd4 with SMTP id n8-20020a5d4848000000b002d23b59cbd4mr1989626wrs.12.1679570641661;
        Thu, 23 Mar 2023 04:24:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350bvcuszABwhnciDhZmUHoYcWm5BDwzo6Ssfedx3Ofwchw0V4Xwy8PJwJe8IGH0zzAZyKxkT5g==
X-Received: by 2002:a5d:4848:0:b0:2d2:3b59:cbd4 with SMTP id n8-20020a5d4848000000b002d23b59cbd4mr1989617wrs.12.1679570641433;
        Thu, 23 Mar 2023 04:24:01 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-146.web.vodafone.de. [109.43.179.146])
        by smtp.gmail.com with ESMTPSA id n16-20020adffe10000000b002cfe63ded49sm15962459wrr.26.2023.03.23.04.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 04:24:00 -0700 (PDT)
Message-ID: <a99184db-430e-624f-5c6b-44f773aab6d4@redhat.com>
Date:   Thu, 23 Mar 2023 12:23:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v2 01/10] MAINTAINERS: Update powerpc list
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-2-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230320070339.915172-2-npiggin@gmail.com>
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
> KVM development on powerpc has moved to the Linux on Power mailing list,
> as per linux.git commit 19b27f37ca97d ("MAINTAINERS: Update powerpc KVM
> entry").
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 649de50..b545a45 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -79,7 +79,7 @@ M: Laurent Vivier <lvivier@redhat.com>
>   M: Thomas Huth <thuth@redhat.com>
>   S: Maintained
>   L: kvm@vger.kernel.org
> -L: kvm-ppc@vger.kernel.org
> +L: linuxppc-dev@lists.ozlabs.org
>   F: powerpc/
>   F: lib/powerpc/
>   F: lib/ppc64/

Reviewed-by: Thomas Huth <thuth@redhat.com>

