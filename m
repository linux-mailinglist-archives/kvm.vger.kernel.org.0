Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C5C640728
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 13:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiLBMtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 07:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiLBMtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 07:49:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF26069315
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 04:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669985304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kWLaVpMH3LNUK0ZsjLgSAeP0hRbE36WtrPUN0txOrnY=;
        b=Z8ygpgz9Rq9z/6y5n8Fc/Qjk1U93Vmo5Y5wnNYhHesv+RS5eohHU5pdd2p2BkZMd83Q98T
        vLeo9XhBDyq+CpbnuGLUt21e0QiushvFgGBbc51sZKFcTX9V9sJp7gqs16MkuV/hPzlhnJ
        X+JKMrximppPhKcpJZB3+XOSMQMWe4U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-kGZtDOY1NtKTMFnTc7Hy2Q-1; Fri, 02 Dec 2022 07:48:21 -0500
X-MC-Unique: kGZtDOY1NtKTMFnTc7Hy2Q-1
Received: by mail-wr1-f70.google.com with SMTP id g14-20020adfa48e000000b00241f94bcd54so1061471wrb.23
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 04:48:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kWLaVpMH3LNUK0ZsjLgSAeP0hRbE36WtrPUN0txOrnY=;
        b=QROXVoIsvdDfURUdoP/BbLjrwRHA2ZDaOqPgftRxM+E5507C73n2L44x5PnFeKV9WG
         +s4Wr5xOrMMQcx9E1ZNlo32cybfIg8jO0+P31sbbe+0pwB92ZAc7g/tXUgV98FZ/pkBb
         GP27VPGZnGiBUIJ6u11Qpvl+dWi2S2MmmpOiravxZp/b7erwr6bIKmnqQq3scc3ozc6f
         Y5cRz+qZemD97vg0VtVFUkV5J0d3h7JcwgUNPzfWn1nKFB8It46GU+38QiiKJr3KTRBO
         EWrvTYVDPxuMKQTu4hPHtaRSG+nx5DldGu9lEBEd+CmuP60y/TzMWf1M7B8a4c/MyW+a
         bOLg==
X-Gm-Message-State: ANoB5plNuI96XEm2WCWInnR13AQhAGFtcqZDe/x4kFaR1JSnFlWYoKr7
        OHu6UmF1LR76gx1hoqHozVoQ4NePr90TI/CXVRPz9oEnZbuZnU05TCF4xh2ylMtgoo49NXryGKn
        1SWLL6GbHXsJ/
X-Received: by 2002:adf:f182:0:b0:241:d820:8996 with SMTP id h2-20020adff182000000b00241d8208996mr34314265wro.562.1669985299892;
        Fri, 02 Dec 2022 04:48:19 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6rTOSffEpx8ejRoYxl4ZLVE9sk7hzHFlXFQ2yMrOzT28yvuW4DKpQgOumXaEjJYDG4TNcarg==
X-Received: by 2002:adf:f182:0:b0:241:d820:8996 with SMTP id h2-20020adff182000000b00241d8208996mr34314256wro.562.1669985299696;
        Fri, 02 Dec 2022 04:48:19 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-178-86.web.vodafone.de. [109.43.178.86])
        by smtp.gmail.com with ESMTPSA id bk4-20020a0560001d8400b00241da0e018dsm6795429wrb.29.2022.12.02.04.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 04:48:19 -0800 (PST)
Message-ID: <77870647-0fb6-a9f8-4408-dd76b5156462@redhat.com>
Date:   Fri, 2 Dec 2022 13:48:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for skey-related
 functions
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, pbonzini@redhat.com
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
 <20221201084642.3747014-2-nrb@linux.ibm.com>
 <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com>
 <7a05af7b-96e0-7914-1415-62443f6646dd@redhat.com>
 <166997789077.186408.11144216448246779334@t14-nrb.local>
 <49c289b2-c7d7-7aec-c975-e056cb42927e@redhat.com>
 <cab7aa32-0d97-abe1-47f2-4d08c7aec6f0@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <cab7aa32-0d97-abe1-47f2-4d08c7aec6f0@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2022 12.56, Janosch Frank wrote:
> On 12/2/22 12:32, Thomas Huth wrote:
>> On 02/12/2022 11.44, Nico Boehr wrote:
>>> Quoting Thomas Huth (2022-12-02 10:09:03)
>>>> On 02/12/2022 10.03, Janosch Frank wrote:
>>>>> On 12/1/22 09:46, Nico Boehr wrote:
>>>>>> Upcoming changes will add a test which is very similar to the existing
>>>>>> skey migration test. To reduce code duplication, move the common
>>>>>> functions to a library which can be re-used by both tests.
>>>>>>
>>>>>
>>>>> NACK
>>>>>
>>>>> We're not putting test specific code into the library.
>>>>
>>>> Do we need a new file (in the third patch) for the new test at all, or 
>>>> could
>>>> the new test simply be added to s390x/migration-skey.c instead?
>>>
>>> Mh, not quite. One test wants to change storage keys *before* migrating, 
>>> the other *while* migrating. Since we can only migrate once, it is not 
>>> obvious to me how we could do that in one run.
>>>
>>> Speaking of one run, what we could do is add a command line argument 
>>> which decides which test to run and then call the same test with 
>>> different arguments in unittests.cfg.
>>
>> Yes, that's what I had in mind - use a command line argument to select the
>> test ... should be OK as long as both variants are listed in unittests.cfg,
>> shouldn't it?
>>
>>    Thomas
> 
> @Thomas @Claudio:
> I see two possible solutions if we want a "testlib" at some point (which for 
> the record I don't have anything against):
> 
> Putting the files into lib/s390x/testlib/* which will then be part of our 
> normal lib.
> That's a minimal effort solution. It still puts those files into lib/* but 
> they are at least contained in a directory.
> 
> Putting the files into s390x/testlib/* and creating a proper new lib.
> Which means we'd need a few more lines of makefile changes.

Though this is an excellent topic for a Friday afternoon bikeshedding ... I 
don't mind much either way. I maybe just got a small preference to not touch 
the main lib/ folder here. I guess you could even call it 
s390x/migration-skey-common.c and leave the lib logic out of the game ... 
but I don't really mind. Up to you to decide ;-)

  Thomas

