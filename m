Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AC96A7FB3
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 11:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCBKKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 05:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCBKKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 05:10:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C7C12048
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 02:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677751782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lXbERUV6OXXNEd4Glxe8uKPGB9Paw5omeac0WMLVgtU=;
        b=QcznqyG8F3tv+OUPIm37nztmVItkvFGJblWls/+FSjzqvcODHkrv45zix9aqH6TRSwaaze
        K8KsKCv/grP1PvxowVJJPsJyX7bhrFKtFv6tN0MEQjE7kqZjaKu2DQ3mtc33n5bxr3SFsP
        1YpBCFmO42fsSYKRvqd60sNdSlgo8lg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-HUfIWUPgM2KUxc56rKuIKg-1; Thu, 02 Mar 2023 05:09:41 -0500
X-MC-Unique: HUfIWUPgM2KUxc56rKuIKg-1
Received: by mail-qk1-f197.google.com with SMTP id ou5-20020a05620a620500b007423e532628so9684106qkn.5
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 02:09:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677751781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lXbERUV6OXXNEd4Glxe8uKPGB9Paw5omeac0WMLVgtU=;
        b=j8tDnbkOchzhigpHAErfeKeT7mg9j3TWL6S7kZ2oVFtCsWEDgezoeGPN6xF5LOoQfK
         UQmNFxQ0zui6r2I4MjgoyqkZoVT56rUyOJ52dftF0sUF/2oXU98m+FebJMeddYiPlfL+
         fhZXrCHlZg7RETd8gaqgQt/8OpmtYtwkJ+ED1PgRKe307x8PyfiqVKn0I/YGZOa1Jxgt
         jC/23iPvjzWWDFFL/zdmf63jNF2aG8HZ3Nngh7hmT/fjHoB5mO+CAHHW+RYL9n15cjEn
         2pD/8jg5Ajsahj72oxXpZTkhCX6f2Cmr30BcOAX3ULNwHIebyvtZUr8fiQvK1EaAoJHS
         xPzQ==
X-Gm-Message-State: AO0yUKUnpRkC5TUznAbECRfXI3uU2bKGOUJ40/L2Wm7hO/ZdaPC0LMT6
        Ta9nyqx+SWsl6cwNDZbNm3GN0N9yRvBrY8yfWPRBnXe/KdF5IvVCoKd0HKM20IAC8cKU9wdZiY9
        SRTLmokveFLbWmPSaBdvf
X-Received: by 2002:a05:622a:15d4:b0:3b9:a4d4:7f37 with SMTP id d20-20020a05622a15d400b003b9a4d47f37mr17574704qty.3.1677751781217;
        Thu, 02 Mar 2023 02:09:41 -0800 (PST)
X-Google-Smtp-Source: AK7set/8Saqx1K2uJdBaEuchwtQIsZTeWAw6wUQDOhc6/0sKADQ5BeeC69pCKk48cWVerK4+pDG8yA==
X-Received: by 2002:a05:622a:15d4:b0:3b9:a4d4:7f37 with SMTP id d20-20020a05622a15d400b003b9a4d47f37mr17574677qty.3.1677751780978;
        Thu, 02 Mar 2023 02:09:40 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x7-20020ac87007000000b003c00573aaffsm697711qtm.3.2023.03.02.02.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 02:09:40 -0800 (PST)
Message-ID: <5b019bd3-cc57-017a-e0f6-bf9ebc97ad11@redhat.com>
Date:   Thu, 2 Mar 2023 18:09:36 +0800
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

Hi drew,

On 3/1/23 20:50, Andrew Jones wrote:
> On Wed, Mar 01, 2023 at 02:17:37AM -0500, Shaoqin Huang wrote:
>> The qemu script used to detect the testdev is obsoleted, replace it
>> with the modern way to detect if testdev exists.
> 
> Hi Shaoqin,
> 
> Can you please point out the oldest QEMU version for which the modern
> way works?
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
> 

This just remind me if we could also change

if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then

to

if ! $qemu $M -device '?' | grep -q virtconsole; then

And all other place like that.

Thanks,

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

