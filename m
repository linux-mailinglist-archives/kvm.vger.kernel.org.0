Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCE24CAFF3
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 21:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiCBUfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 15:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiCBUfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 15:35:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A46065A58E
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 12:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646253262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ciPi7kEieYIzL7jHIxoihLJhKMCmN1FlTisM2ES1jS0=;
        b=SLIOgY9pqeOhCi8K/erf9qNPVdC3hGTyOrgt+fXZBBkliptKE4wdwaBvYZ5Lt5fwV76rlE
        CDZTDvjWtZMDJiOnMxDztKY+5bhk0j80Ris+LfVcjoEyQiNffWWgetLBX1Y6ye0BcwW9TZ
        mBZWX1+8ZpxKvl87eN/G7O6xmC/wZ3E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-36s_1dx_NBiw7atDYXlrqw-1; Wed, 02 Mar 2022 15:34:21 -0500
X-MC-Unique: 36s_1dx_NBiw7atDYXlrqw-1
Received: by mail-wr1-f71.google.com with SMTP id f14-20020adfc98e000000b001e8593b40b0so1043518wrh.14
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 12:34:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ciPi7kEieYIzL7jHIxoihLJhKMCmN1FlTisM2ES1jS0=;
        b=7KjKNnfDwc26fnb9g1zF2WjXw3bMZUqxMOmmZGRd8F7to+6OteJtLm6kDjVd8GiQKO
         KGm8lWeSl9nKaWpDwULqeayLvK0hO/pbeVYr+MRafnAQ+FV3rpm+Ub/27zRxFG6NQlxg
         +K1jXdrVZlY90ToqQyJp7jhe+cSBjCWG3vtj40euCclQON7sCTiWvxRE+6xVZhsfSOW6
         0h1d2TYQEOodGZyOcXX59wEDNBvu2XAZQNWL/BEYtdYxV07cJI/LXylpnU4W/fEgMwL3
         JWyev9aKhitqvlX4uerWtSmog8MNgQyIEs9opwsMylnejXy6VBiZJ2O2HtxIj4xONncB
         I78A==
X-Gm-Message-State: AOAM530YP9mzbUmr/c5mlrB60hh0/nuXRSI7yINPjzqYKIi84W+4eq3W
        6A5LJw2HfhV6Ow/NZATS4p4j8wRJHugHnxbx2n4kYPnXkdcecpwaSla8BfUIqGL7mE0L/dy19A8
        UbVsI45Z84C3d
X-Received: by 2002:a05:600c:4b86:b0:385:2800:2915 with SMTP id e6-20020a05600c4b8600b0038528002915mr1275915wmp.117.1646253260021;
        Wed, 02 Mar 2022 12:34:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2O6/Xj2ckx7wehIcMtYYG9FcQzJTXkgZ3FuAFJk0jklxSJb0NHN6bt9gkRcKdQ0D6gF6kSA==
X-Received: by 2002:a05:600c:4b86:b0:385:2800:2915 with SMTP id e6-20020a05600c4b8600b0038528002915mr1275900wmp.117.1646253259779;
        Wed, 02 Mar 2022 12:34:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id r15-20020a05600c35cf00b003808165fbc2sm68947wmq.25.2022.03.02.12.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 12:34:18 -0800 (PST)
Message-ID: <bff2c7dc-bb5b-8a05-f122-b9cad7790d13@redhat.com>
Date:   Wed, 2 Mar 2022 21:34:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests PATCH RESEND 1/2] x86/pmu: Make "ref cycles" test
 to pass on the latest cpu
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20220302112634.15024-1-likexu@tencent.com>
 <CALMp9eRepNj4B8s6T25+Vy3r=8cHYkeEby8zoqYNFmVp79Hj2w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eRepNj4B8s6T25+Vy3r=8cHYkeEby8zoqYNFmVp79Hj2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 18:39, Jim Mattson wrote:
> On Wed, Mar 2, 2022 at 3:26 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> Expand the boundary for "ref cycles" event test as it has
>> been observed that the results do not fit on some CPUs [1]:
>>
>> FAIL: full-width writes: ref cycles-N
>>    100000 >= 87765 <= 30000000
>>    100000 >= 87926 <= 30000000
>>    100000 >= 87790 <= 30000000
>>    100000 >= 87687 <= 30000000
>>    100000 >= 87875 <= 30000000
>>    100000 >= 88043 <= 30000000
>>    100000 >= 88161 <= 30000000
>>    100000 >= 88052 <= 30000000
>>
>> [1] Intel(R) Xeon(R) Platinum 8374C CPU @ 2.70GHz
>>
>> Opportunistically fix cc1 warnings for commented print statement.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
> 
> This fix doesn't address the root cause of the problem, which is that
> the general purpose reference cycles event is, in many cases,
> decoupled from CPI. My proposed fix,
> https://lore.kernel.org/kvm/20220213082714.636061-1-jmattson@google.com/,
> does.
> 

Queued yours, together with Like's patch 2.

Paolo

