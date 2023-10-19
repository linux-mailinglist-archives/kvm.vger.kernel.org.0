Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F07CF215
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 10:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjJSILP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 04:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjJSILN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 04:11:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749BA126
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697703023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=gFzBQsQLH3SD8BE7XzDKm6uTkm7oXxwAL1t7dApRKz4=;
        b=KKqEAYOowz2THnapD/jTUYaUPRaD7Y4b+rDCUeFi2RfUr2QAsNzJgQwzYKLCt/C9dLRhcB
        BMXWlkovLTNpnXlQzeUjWZHnwlVF2gFUoNRzNkK3utkIM++XRZkNd2atBP3Ya/u6uVfK0w
        UoY5Yyfc5cVYXEoK68xN+lDvEoarhwM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-S0bIwj-HMuG8yB_4f53tiw-1; Thu, 19 Oct 2023 04:10:21 -0400
X-MC-Unique: S0bIwj-HMuG8yB_4f53tiw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7788fb069abso87823085a.0
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 01:10:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697703021; x=1698307821;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gFzBQsQLH3SD8BE7XzDKm6uTkm7oXxwAL1t7dApRKz4=;
        b=GyFCuXF4lVpzMn2VBEGVzDngT06/BjAnb2pNvanrozCU43DhXzCgs9c8Sct1kjsKXv
         qndXpxDoIMoJg1svBSddCI92kE0d4W4OZ+KySn1SBYRrpuDKsoGrKTpayk81sBfg7R2J
         h0iEideg9LJUUfs9yJZzxAyANOh107fNcXHuBoWpIw18PYQRp7V1/35x/KSA2gjeBmeY
         TLicfVeNd0X957OTkgSaZpQnsZ+vOewbNVsEbu/6W1QOccAh0WbXh9TkdX2DSPfqZO96
         st2V1kbFUIFfzir+2hkXAQOp+EEOB2zU7Cq0wf1lER5VpF9rPIDG+70XP8pp/3YPtVct
         gh/w==
X-Gm-Message-State: AOJu0Yzo2Q2vuz13m/SZqdgLJWYrqaOwvC9uKCiCeSYHBBku63h3bTyw
        d3Xsx1mdMeCsGTQqzT762O/pVnrRTTfw3qj1asMkfcXfd7znDkr0K+rd6gqn+dtE7WTRPgl4JQv
        A0nEMNHvFch6e
X-Received: by 2002:a05:620a:371a:b0:777:6c53:c090 with SMTP id de26-20020a05620a371a00b007776c53c090mr1481624qkb.24.1697703021131;
        Thu, 19 Oct 2023 01:10:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuufvg4wrGtnNVLBhAL7c2lwZgJsbUsO0jM9ANTEHwmyZZZYM4d96g+fAOwnRBVzVSXmF2wA==
X-Received: by 2002:a05:620a:371a:b0:777:6c53:c090 with SMTP id de26-20020a05620a371a00b007776c53c090mr1481608qkb.24.1697703020859;
        Thu, 19 Oct 2023 01:10:20 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-141.web.vodafone.de. [109.43.176.141])
        by smtp.gmail.com with ESMTPSA id o8-20020a0cc388000000b0065b0d9b4ee7sm602221qvi.20.2023.10.19.01.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 01:10:20 -0700 (PDT)
Message-ID: <78f0966b-a4a9-4f9b-9bc9-5fa0ecbad934@redhat.com>
Date:   Thu, 19 Oct 2023 10:10:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/3] migration: Fix test harness hang if
 source does not reach migration point
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
References: <20230725033937.277156-1-npiggin@gmail.com>
 <20230725033937.277156-3-npiggin@gmail.com>
 <169052965551.15205.2179571087904012453@t14-nrb>
 <CUFF6E1RB78K.QT91UG08M495@wheely>
 <169564046337.31925.7932230191015216618@t14-nrb>
 <880f77b3-2af1-43fb-bfa9-a80a7fc8053c@redhat.com>
 <169770213169.68756.904215339391644985@t14-nrb>
From:   Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <169770213169.68756.904215339391644985@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/2023 09.55, Nico Boehr wrote:
> Quoting Thomas Huth (2023-10-16 20:32:47)
>> On 25/09/2023 13.14, Nico Boehr wrote:
>>> Quoting Nicholas Piggin (2023-07-30 12:03:36)
>>>> On Fri Jul 28, 2023 at 5:34 PM AEST, Nico Boehr wrote:
>>>>> Quoting Nicholas Piggin (2023-07-25 05:39:36)
>>>>>> After starting the test, the harness waits polling for "migrate" in the
>>>>>> output. If the test does not print for some reason, the harness hangs.
>>>>>>
>>>>>> Test that the pid is still alive while polling to fix this hang.
>>>>>>
>>>>>> While here, wait for the full string "Now migrate the VM", which I think
>>>>>> makes it more obvious to read and could avoid an unfortunate collision
>>>>>> with some debugging output in a test case.
>>>>>>
>>>>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>>>>
>>>>> Thanks for attempting to fix this!
>>>>>
>>>>>> ---
>>>>>>    scripts/arch-run.bash | 10 +++++++++-
>>>>>>    1 file changed, 9 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
>>>>>> index 518607f4..30e535c7 100644
>>>>>> --- a/scripts/arch-run.bash
>>>>>> +++ b/scripts/arch-run.bash
>>>>>> @@ -142,6 +142,7 @@ run_migration ()
>>>>>>    
>>>>>>           eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
>>>>>>                   -mon chardev=mon1,mode=control | tee ${migout1} &
>>>>>> +       live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
>>>>>
>>>>> Pardon my ignorance, but why would $! not work here?
>>>>
>>>> My mastery of bash is poor, I copied the incoming_pid line. It seems
>>>> to work, but if you think $! is better I can try it.
>>>
>>> Sorry, this fell off of my radar after going to summer holiday...
>>>
>>> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>>
>>    Hi Nicholas & Nico,
>>
>> do you want me to pick up this patch as is, or do you want to respin with $!
>> instead?
> 
> Let's not discuss too much and get this fixed, I am fine with this as-is.
> Thanks.

Ok, pushed it now.

  Thomas

