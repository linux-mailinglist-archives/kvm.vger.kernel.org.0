Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C874D6679
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 17:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350549AbiCKQiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 11:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350408AbiCKQhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 11:37:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E47C81C65C7
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 08:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647016608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6iV6PzyNn8RULyHZxri/N0ee8Slwz+DlYnq8A+sMdcA=;
        b=U9262J9DawfaFT06UxeKKAqur+UefJQYDfWr6RlcGpkGLDS8qI1snKdI9+Gs1Syf7zZKWP
        mJ0tKuPyLlhqnFinpwRXXCs74TnMIWcCuT0SqouT3F5q9vcNKnwYtNWJQiY0Da4Dp80zfj
        b/GHK1ItxWzHcG7L9QQ900H6CGePFL0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-HN2lh0psN1Go4RAACCNOng-1; Fri, 11 Mar 2022 11:36:46 -0500
X-MC-Unique: HN2lh0psN1Go4RAACCNOng-1
Received: by mail-wm1-f69.google.com with SMTP id o21-20020a05600c511500b003818c4b98b5so3200953wms.0
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 08:36:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6iV6PzyNn8RULyHZxri/N0ee8Slwz+DlYnq8A+sMdcA=;
        b=OkJ6eKGiP/IBfQl0hpcAr3/t5G5IkX/T4FEs027gHNLsHqjP3b8d08M0rttF2T9wvq
         OuNopeAX/CtFlLy3kKvEHPvHWxfnyyl0QDKJ4fK1n1oAgOvlVcqAoNhKrgb8ZL5iGc/v
         RLWMb5LdK5C0jCYUUKb/2sgJvArgLAZvfwKL/sCUv36Uh1uBRdqm2otRY2p6/P/1zTdR
         3Vo51wx/BWF/EN/0QZkvyCaJnuQ+Y3D6VZb3S9o5wTolvnpD0vaiPNWY1z6mugziGxyq
         h3J/d/kBAI949mzlCNS4cO5o/CigxyXNfVxozgYbVMx8FcX9TdBWhX8GKQWiyazJb20D
         AyRA==
X-Gm-Message-State: AOAM532Mnvzd/mHW2qPLJ9fzRclPmJlr2beRC+E85rvF2XDFbmwJAOzl
        okt9+bCXgRndkm7uY+vRolC/PMjel+As1x5WdvHs3A9P4zk4xlzYyfbmEjWgc+HROOaxZsTuIrp
        1mP8tdje5OBaJ
X-Received: by 2002:a05:6000:15cb:b0:1f1:e283:fcc0 with SMTP id y11-20020a05600015cb00b001f1e283fcc0mr7892693wry.18.1647016605730;
        Fri, 11 Mar 2022 08:36:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxAHa73hakSAWL1S5ih1aRAwF6xW1UdKMTfQZY/xa2pcKsHFHB68E6Wp0O6FpeZjalssPpl8Q==
X-Received: by 2002:a05:6000:15cb:b0:1f1:e283:fcc0 with SMTP id y11-20020a05600015cb00b001f1e283fcc0mr7892672wry.18.1647016605423;
        Fri, 11 Mar 2022 08:36:45 -0800 (PST)
Received: from [192.168.8.104] (tmo-098-218.customers.d1-online.com. [80.187.98.218])
        by smtp.gmail.com with ESMTPSA id v6-20020a5d5906000000b001f0639f69e6sm7312188wrd.55.2022.03.11.08.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 08:36:43 -0800 (PST)
Message-ID: <dc4ddb94-7714-b242-92ec-051de3d7e648@redhat.com>
Date:   Fri, 11 Mar 2022 17:36:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: Test full-width counter writes
 support
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Andrew Jones <drjones@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>
References: <20200529074347.124619-1-like.xu@linux.intel.com>
 <20200529074347.124619-4-like.xu@linux.intel.com>
 <CALMp9eQNZsk-odGHNkLkkakk+Y01qqY5Mzm3x8n0A3YizfUJ7Q@mail.gmail.com>
 <7c44617d-39f5-4e82-ee45-f0d142ba0dbc@linux.intel.com>
 <CALMp9eTYPqZ-NMuBKkoNX+ZvomzSsCgz1=C2n+Ajaq-ttMys1Q@mail.gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <CALMp9eTYPqZ-NMuBKkoNX+ZvomzSsCgz1=C2n+Ajaq-ttMys1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/2022 01.06, Jim Mattson wrote:
> On Tue, May 11, 2021 at 11:33 PM Like Xu <like.xu@linux.intel.com> wrote:
>>
>> On 2021/5/12 5:27, Jim Mattson wrote:
>>> On Fri, May 29, 2020 at 12:44 AM Like Xu <like.xu@linux.intel.com> wrote:
>>>>
>>>> When the full-width writes capability is set, use the alternative MSR
>>>> range to write larger sign counter values (up to GP counter width).
>>>>
>>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>>> ---
>>>
>>>> +       /*
>>>> +        * MSR_IA32_PMCn supports writing values â€‹â€‹up to GP counter width,
>>>> +        * and only the lowest bits of GP counter width are valid.
>>>> +        */
>>>
>>> Could you rewrite this comment in ASCII, please? I would do it, but
>>> I'm not sure what the correct translation is.
>>>
>>
>> My first submitted patch says that
>> they are just Unicode "ZERO WIDTH SPACE".
>>
>> https://lore.kernel.org/kvm/20200508083218.120559-2-like.xu@linux.intel.com/
>>
>> Here you go:
>>
>> ---
>>
>>   From 1b058846aabcd7a85b5c5f41cb2b63b6a348bdc4 Mon Sep 17 00:00:00 2001
>> From: Like Xu <like.xu@linux.intel.com>
>> Date: Wed, 12 May 2021 14:26:40 +0800
>> Subject: [PATCH] x86: pmu: Fix a comment about full-width counter writes
>>    support
>>
>> Remove two Unicode characters 'ZERO WIDTH SPACE' (U+200B).
>>
>> Fixes: 22f2901a0e ("x86: pmu: Test full-width counter writes support")
>> Reported-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>    x86/pmu.c | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 5a3d55b..6cb3506 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -510,7 +510,7 @@ static void  check_gp_counters_write_width(void)
>>           }
>>
>>           /*
>> -        * MSR_IA32_PMCn supports writing values Ã¢â‚¬â€¹Ã¢â‚¬â€¹up to GP
>> counter width,
>> +        * MSR_IA32_PMCn supports writing values up to GP counter width,
>>            * and only the lowest bits of GP counter width are valid.
>>            */
>>           for (i = 0; i < num_counters; i++) {
>> --
>> 2.31.1
> 
> Paolo:
> 
> Did this patch get overlooked? I'm still seeing the unicode characters
> in this comment.

Yes, seems like it felt through the cracks. It's better to send patches as a 
new mail thread instead of posting them in a reply, otherwise they might be 
overlooked. Anyway, I've pushed this patch now to the repo.

  Thomas

