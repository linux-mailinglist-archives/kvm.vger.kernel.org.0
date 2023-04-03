Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C026D4D96
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjDCQ0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDCQ0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:26:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44C335A9
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680539073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2dtn/3tfgzjBswPmQVVT+/QVSt2Ly63w7qUT7Of+sn0=;
        b=Onr9HNwSI1X2O3OTMhWqW1f73ZHWSzphTqDyD5GEfZWcoBl6r9e7GYr6htEKS45vazsNu1
        HtKnIBW9+xQ9MrMKKhAhKWG3ruSTZa85/8t/i0Maec2xkw9n/OzVEsJNoTRHaRNcwdAp5b
        QxX/QMtIqhyIV9uborBX2ag/SOwrOaw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-58edEMTgNau8F1Y2NbHF8Q-1; Mon, 03 Apr 2023 12:24:31 -0400
X-MC-Unique: 58edEMTgNau8F1Y2NbHF8Q-1
Received: by mail-ed1-f72.google.com with SMTP id i42-20020a0564020f2a00b004fd23c238beso41883464eda.0
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 09:24:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680539070; x=1683131070;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2dtn/3tfgzjBswPmQVVT+/QVSt2Ly63w7qUT7Of+sn0=;
        b=TFZ4uW7u+jSGR+cHXl131Fuei/RR5t7EOwWtBcq/R1/s5/WlcrDc2ycyLUQHT3oTVV
         l11wGOAssh0xPWsE0jywhKbKODm7syH2nKbJ60S8/nxwLE6GsSWYNdzbyvAAY4sq6EBQ
         vSC0fBWdccK4bjFq7bg+vngsQ7RnvaVanUP4CFR9HzpX8zpYUiH58pTkdz+fyGh+dT3N
         aYPMUzd45rPTYDaFNP10LSwjeoECuhvMTsE/70CcciQR8P/GCyR6ZbM1g6AcC6ifWMf2
         LZgmtiQ4bkSkqYIYfvuHR6lgEZYYny2XjdZrtm2uJqn/kM86r3kDjVaSLU1HEvD+vMNB
         cMiQ==
X-Gm-Message-State: AAQBX9fBgh/0exu+6kOM8KGKildKVoG60pyq5Qz7pQgNQmYnvDWDrSFW
        c5CBlXV4On6sZ+xvlNLQesclCwNi/6ZtDRhqOzsGzRDMgJyLcyof3PQC5llSwIU2unRZ9VRPdNV
        uIGovPorBpm1BHQ5lCXOSBvY=
X-Received: by 2002:a05:6402:6d1:b0:502:24a4:b0ae with SMTP id n17-20020a05640206d100b0050224a4b0aemr35639450edy.14.1680539070113;
        Mon, 03 Apr 2023 09:24:30 -0700 (PDT)
X-Google-Smtp-Source: AKy350aPQtV/cJJU+yhQh4WxUAA1DgWzReONmq36ZEnd3lJiFuuUO7mxxdN8B7lGlB9GQ3jK4v/Xew==
X-Received: by 2002:a05:6402:6d1:b0:502:24a4:b0ae with SMTP id n17-20020a05640206d100b0050224a4b0aemr35639438edy.14.1680539069800;
        Mon, 03 Apr 2023 09:24:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j18-20020a17090623f200b00947a749fc3esm4513520ejg.33.2023.04.03.09.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 09:24:28 -0700 (PDT)
Message-ID: <3b8e64f5-6099-9e80-d0d8-4a5ea4e6c6f3@redhat.com>
Date:   Mon, 3 Apr 2023 18:24:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH] ci/cirrus-ci-fedora.yml: Disable the
 "memory" test in the KVM job
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20230403112625.63833-1-thuth@redhat.com>
 <ZCrvwEhb45cqGhmP@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZCrvwEhb45cqGhmP@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/3/23 17:24, Sean Christopherson wrote:
> An alternative would be to force emulation when using KVM, but KVM doesn't currently
> emulating pcommit (deprecated by Intel), clwb, or any of the fence instructions
> (at least, not afaict; I'm somewhat surprised *fence isn't "required").
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index f324e32d..5afb5dad 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -185,6 +185,7 @@ arch = x86_64
>   
>   [memory]
>   file = memory.flat
> +accel = tcg
>   extra_params = -cpu max
>   arch = x86_64
> 

I think we should just drop the "CPUID bit non-present" case.

Paolo

