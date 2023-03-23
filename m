Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11D06C6E5F
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 18:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjCWRFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 13:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCWRFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 13:05:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596DAC5
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679591090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lnksJrkfhjSBGNHksqpdl9+nfgVKyykIRUKtqbomLq8=;
        b=ckMMNVm9VFeQ7ro1GzZixdiVJ9woyNThnU//yJEBxSkpFPyPpi6LzsB+7IVeDqWrKwrtn5
        r0tiqSwtJD+hhU1kilErJtw9+4/4QlO5OLt3DjV9gqYFYzOpnAb3JYFKUbGKFaBgA53W+N
        3Uh8e3AbuNzI14b3TAnil6G8FJ9nb5E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-1xrWVZWnMmikWTk7dcXqZg-1; Thu, 23 Mar 2023 13:04:49 -0400
X-MC-Unique: 1xrWVZWnMmikWTk7dcXqZg-1
Received: by mail-wm1-f69.google.com with SMTP id bh19-20020a05600c3d1300b003ee93fac4a9so947951wmb.2
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679591088;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lnksJrkfhjSBGNHksqpdl9+nfgVKyykIRUKtqbomLq8=;
        b=PrZlSrdN1DzsVBWLCenlId7OVEs9AbI/JUIdId7mlm+3yQVFKoHgtjzaECE2SrXLXj
         av+fowcw/ImtyWLsBtlcTY2nanJbQVoBJgofFuLM/vnt8DWB4eXANPdSsEClO3mhy12Y
         tp4mT4SdU2NLYHLyOi7bVHesTaPDGkvBuBuYlgVcAVtIpv7AvE7MZFmfSnor3nUfEn0Y
         x9wlBEs3x64yqMQFtCZRNb08s3FUwQg34JNbilxbxnCCcxPSoKaiusGKnCwyVjIt1WIr
         qJxN7QFn9k9rASGIiAaza9aujbWTRkllA40It0pA7YdG4WxCTHe/oM8d4s4ufDLpnZVt
         c6fA==
X-Gm-Message-State: AO0yUKUbOuMcpJmtWo4hwlsECBzXFyqpdBKgzzzsiGsPn2Km/hHHMLwm
        6/Z3YR2aNgoDWBDhPgj/DXsq2Gl9ZwI4HCIYvL2zmzatCwPBwZGUR6OPfpgusooYN8PEtg/cBF+
        hL3WGc15zXpxO
X-Received: by 2002:a05:600c:4452:b0:3df:9858:c039 with SMTP id v18-20020a05600c445200b003df9858c039mr2735753wmn.14.1679591087896;
        Thu, 23 Mar 2023 10:04:47 -0700 (PDT)
X-Google-Smtp-Source: AK7set8PtkSVaAR9PKdwEUGUS+uRyn7eqstlCPAwa6K3mCbm6YoMHzKI4Z1CBcdveIR2HLgbS2b8Hg==
X-Received: by 2002:a05:600c:4452:b0:3df:9858:c039 with SMTP id v18-20020a05600c445200b003df9858c039mr2735738wmn.14.1679591087675;
        Thu, 23 Mar 2023 10:04:47 -0700 (PDT)
Received: from [192.168.8.106] (tmo-098-12.customers.d1-online.com. [80.187.98.12])
        by smtp.gmail.com with ESMTPSA id bg19-20020a05600c3c9300b003ede2c4701dsm2550769wmb.14.2023.03.23.10.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 10:04:46 -0700 (PDT)
Message-ID: <1ac1507d-ab5d-4001-886a-f7b055fdad39@redhat.com>
Date:   Thu, 23 Mar 2023 18:04:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH 0/2] x86/pmu: Add TSX testcase and fix
 force_emulation_prefix
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20221226075412.61167-1-likexu@tencent.com>
 <c5da9a9c-b411-5a44-4255-eb49399cf4c0@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <c5da9a9c-b411-5a44-4255-eb49399cf4c0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/2023 07.47, Like Xu wrote:
> CC more KUT maintainers, could anyone pick up these two minor x86 tests ?

Your patches never made it to my inbox - I guess they got stuck in a mail 
filter on the way ... Paolo, Sean, did you get them?

  Thomas


> On 26/12/2022 3:54 pm, Like Xu wrote:
>> We have adopted a test-driven development approach for vPMU's features,
>> and these two fixes below cover the paths for at least two corner use cases.
>>
>> Like Xu (2):
>>    x86/pmu: Add Intel Guest Transactional (commited) cycles testcase
>>    x86/pmu: Wrap the written counter value with gp_counter_width
>>
>>   x86/pmu.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 44 insertions(+), 3 deletions(-)
>>
> 

