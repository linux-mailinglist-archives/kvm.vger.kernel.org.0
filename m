Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED3F6BE9AA
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 13:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjCQMxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 08:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCQMxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 08:53:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B7B55518
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679057544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1vHGDmUcm1FSb8Ot+w6EwhZZd8hgraBnIv5bRhFqLac=;
        b=SaKiWh5lSsA8LsJ0b1+QwHWeWxpO1U1zFqba6sG8B7TUBfeZZiZqgepjfklPtpT6XSN180
        +vlTJWDQHKKgCyt4zx/5Qj2WnoKBzlA5c5UV2OK1hUewgkpCj28RaIifcj5nImJ4hE/RcI
        jPHQTghDkixjs80+fjAkj6YMgPMwFCI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-169hKs68MHu4e0JGtBKyzg-1; Fri, 17 Mar 2023 08:52:23 -0400
X-MC-Unique: 169hKs68MHu4e0JGtBKyzg-1
Received: by mail-wm1-f72.google.com with SMTP id m10-20020a05600c4f4a00b003ed74161838so1331317wmq.6
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679057542;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1vHGDmUcm1FSb8Ot+w6EwhZZd8hgraBnIv5bRhFqLac=;
        b=k9JAD4vk+zNO9QTFbxqzwpmXMMtFureSpBlgD74tpJmLCVoprIrEN0q6EOiwI1QSRB
         RzRA/76TmB6QJCjTJENKB86HV4WTjPZIt59pWE8Gd6HYgiNFuL17mBQ6d+VdBl6kTRyE
         4AJoSHV9it8UVmKV+N0e78lch5kgWwqnTbWy1N1t47Zi3cpJljnMpYFQbl8f1z2eHsFp
         ziwRuuLU0pdQ9LnKWUCE8rQS1F8QSB2W19GRMvXjqL0IQr5tpKL6Wjsg70jr62T8xyKt
         Af/FJzN/0dMYwX5nd4A8RRANlmW4qNmj2VSo34giPElJH0wQ2hHPYrdJTrmOZ7ELzJqW
         9QeA==
X-Gm-Message-State: AO0yUKUCy7jo0p2fjMFD1Mv5vOdwE9CAkOT9ZoPChcBMe1YU/yqmCR09
        bAu2NT0iwPb53d1Jkueuz9HaaQkqBxtpYatzJFQVyE+nZAsgZLtJO38AfnQVh/gfKIzc5I1onpU
        8NOL5IfoICEK9
X-Received: by 2002:a05:600c:4511:b0:3ed:307e:3f69 with SMTP id t17-20020a05600c451100b003ed307e3f69mr9951096wmo.7.1679057542578;
        Fri, 17 Mar 2023 05:52:22 -0700 (PDT)
X-Google-Smtp-Source: AK7set+PecfKfOrJrhR/QICpygEjaPHQnC3TpgmLa0II646fjrceLyUW0i4IkLgx03pYVVUshExAnQ==
X-Received: by 2002:a05:600c:4511:b0:3ed:307e:3f69 with SMTP id t17-20020a05600c451100b003ed307e3f69mr9951084wmo.7.1679057542349;
        Fri, 17 Mar 2023 05:52:22 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-176-33.web.vodafone.de. [109.43.176.33])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c028400b003eb192787bfsm1920747wmk.25.2023.03.17.05.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 05:52:21 -0700 (PDT)
Message-ID: <a2bdc644-0300-13f4-701f-e77cfab77f65@redhat.com>
Date:   Fri, 17 Mar 2023 13:52:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH 2/7] powerpc: add local variant of SPR test
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230317123614.3687163-1-npiggin@gmail.com>
 <20230317123614.3687163-2-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230317123614.3687163-2-npiggin@gmail.com>
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
> This adds the non-migration variant of the SPR test to the matrix,
> which can be simpler to run and debug.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/unittests.cfg | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
> index 1e74948..3e41598 100644
> --- a/powerpc/unittests.cfg
> +++ b/powerpc/unittests.cfg
> @@ -68,5 +68,9 @@ groups = h_cede_tm
>   
>   [sprs]
>   file = sprs.elf
> +groups = sprs
> +
> +[sprs-migration]
> +file = sprs.elf
>   extra_params = -append '-w'
>   groups = migration

Reviewed-by: Thomas Huth <thuth@redhat.com>

