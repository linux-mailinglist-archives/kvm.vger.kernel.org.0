Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3046A79A3
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 03:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCBCq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 21:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCBCq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 21:46:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBEA44B3
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 18:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677725139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=agMmEvQOhXFEFHDtkSxYfBL1NNPQWWRtgjv9ldmiZF0=;
        b=QisoVaUsj/2BYKUqQi3HzEznckg9V87kFjaNANIkZxLDEvbRv1jzuDouC8zj7lSuQUc4UM
        x4Y9PRxXAVLbUYFMltc7Q9uNkNIhFkMPuxlhInhoAkGqoJAQBag7RUppLcHuUE1tINHIWP
        qUEwrZdSCsSEzjka+MQLB49WEncvTyA=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-441-4KWa8mM4Na-bPvAxuZis4g-1; Wed, 01 Mar 2023 21:45:38 -0500
X-MC-Unique: 4KWa8mM4Na-bPvAxuZis4g-1
Received: by mail-pf1-f197.google.com with SMTP id t12-20020aa7938c000000b005ac41980708so7838513pfe.7
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 18:45:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=agMmEvQOhXFEFHDtkSxYfBL1NNPQWWRtgjv9ldmiZF0=;
        b=NRIBgp2xm7lj3PhoJcPBCKZRvuI+CJn8DbARRbQw3n1wJDkSWdhEonNBeRktKuVlwh
         C6upx1qRclezeohDQpTEwJLATyDY+Ww74JLP9/iW6Q8+ghB52JUK9wARjDKBmrm7QTxs
         f/W/XbIGjOqojM2I44hWoW0Dbc0qQLe2loLcfpx6rMVDGl8TIYrHdJGaW7gMLneiwDCA
         Kn2P6l5FpgJo7vk/8m+M3QNygzfCX4hmIPFrOkmfOIQzDH12cfHGcZ92FYGn/n4voES/
         vEb69EY0dvUQvh5yYQ9lkmJNPLP9d7eusrrcWbq5ZJjYTYddJFAA1R7mTT4eqmcCQGqy
         iKcw==
X-Gm-Message-State: AO0yUKWKWEwKdBCFnVYzGGYZPbE3HikBI73K02Q2yYgYLoPE8qxrasvN
        yZMtiT+XgFK8p7yTGazbw+ik8PCtpSlWbH8IeasSAhRM9PDbZpGoyn/9QP3eIEu4feOyukKA85b
        jFkQV4r6yPf9e
X-Received: by 2002:a17:902:dace:b0:19a:af51:c282 with SMTP id q14-20020a170902dace00b0019aaf51c282mr9529313plx.0.1677725137248;
        Wed, 01 Mar 2023 18:45:37 -0800 (PST)
X-Google-Smtp-Source: AK7set+A+reeTdq/WElnggT6Nx8GvkrTgiDA90WOBPAEY8OgPArJQ+GuRp2VTFa4Qy7tq7ERH4hgHA==
X-Received: by 2002:a17:902:dace:b0:19a:af51:c282 with SMTP id q14-20020a170902dace00b0019aaf51c282mr9529298plx.0.1677725136863;
        Wed, 01 Mar 2023 18:45:36 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jc18-20020a17090325d200b001994e74c094sm9124572plb.275.2023.03.01.18.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 18:45:36 -0800 (PST)
Message-ID: <e595eb97-9702-e633-ac0e-0c2db2aa1904@redhat.com>
Date:   Thu, 2 Mar 2023 10:45:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests] arm: Replace the obsolete qemu script
Content-Language: en-US
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, "open list:ARM" <kvm@vger.kernel.org>
References: <20230301071737.43760-1-shahuang@redhat.com>
 <20230301125004.d5giadtz4yaqdjam@orel>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301125004.d5giadtz4yaqdjam@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/1/23 20:50, Andrew Jones wrote:
> On Wed, Mar 01, 2023 at 02:17:37AM -0500, Shaoqin Huang wrote:
>> The qemu script used to detect the testdev is obsoleted, replace it
>> with the modern way to detect if testdev exists.
> 
> Hi Shaoqin,
> 
> Can you please point out the oldest QEMU version for which the modern
> way works?

Hi drew,

This way was introduced by 517b3d4016 (chardev: Add 'help' option to 
print all available chardev backend types). Which the QEMU verison is 
v2.7.50.

> 
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   arm/run | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arm/run b/arm/run
>> index 1284891..9800cfb 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -59,8 +59,7 @@ if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
>>   	exit 2
>>   fi
>>   
>> -if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
>> -		| grep backend > /dev/null; then
>> +if ! $qemu $M -chardev '?' 2>&1 | grep testdev > /dev/null; then
>                                ^ This shouldn't be necessary. afaict,
> 			        only stdio is used
> 
> We can change the 'grep testdev >/dev/null' to 'grep -q testdev'

Thanks for advice. I will change it.

> 
>>   	echo "$qemu doesn't support chr-testdev. Exiting."
>>   	exit 2
>>   fi
>> -- 
>> 2.39.1
>>
> 
> Thanks,
> drew
> 

-- 
Shaoqin

