Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CDE6825B0
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 08:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjAaHmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 02:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjAaHmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 02:42:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4654436442
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 23:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675150923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pOekOPQEicd305LCzeaI3ahxQ6p+zMshj5HVCg0TAMQ=;
        b=iPFVZuOtoEBABaIKyiSfzFGpCS3lC4MiFYq7tBvZ+wPkznvVgcW3Ht3kFu9gDcDp27OUgG
        1Bmf7FtPfsTzbIaoD3WI9FuthuDHfFx91zzYDjCQBmluwE8I0/gAG5mozUdhlK0i5nOxTR
        IOcWSBI6ThJr/nIERD66Ex303vy4F2Q=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-IWfCtACpM5qY3nzYUO72Jg-1; Tue, 31 Jan 2023 02:41:44 -0500
X-MC-Unique: IWfCtACpM5qY3nzYUO72Jg-1
Received: by mail-qt1-f199.google.com with SMTP id hf20-20020a05622a609400b003abcad051d2so6160851qtb.12
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 23:41:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pOekOPQEicd305LCzeaI3ahxQ6p+zMshj5HVCg0TAMQ=;
        b=gO6koENbuWjA/pMQQDa9KxCUOcfCm8nR9yRg1qkMiHiBgQdeN44HhgM+ESMV9/rbKp
         k6I1HDoAZyBOjwREMSE1j4ANn+sCuF74cwU5qfSGzS0DmB0xuYZdRN7PbTUbYqkxrVha
         e/scOFM4LfG+f7/TuP0CcuEFKG6j5+9QFBjsz9nMbGVkVdzI8vHPhVrdf3MXrAPSwsqO
         /6kBf74vAWuy0+v870alqXWsIGYwEW6LeMGYTpWZgSw2tlSA0gygX3e8j6R5ed/TWjnN
         a6V9XWSqk1vZsk9gV4igyFW272P+XFWWEylWDXZSEOMNtKsA/MF5QXsXLBRoNtCVdmiE
         fT7g==
X-Gm-Message-State: AO0yUKW2aKITohyohlLXkx+a+BFpwtJ2WkvmHyz3nYK0NSyaXtJLj1lN
        vZtdF4qyYUas47Alt0YEs4tdwvQYn1HtNAEgYnoi3V5VF7Gv3mpRsq6aMb657htvumI0TrNOWNI
        CLIVDJHmsub8t
X-Received: by 2002:a05:622a:1316:b0:3b8:4a9e:7445 with SMTP id v22-20020a05622a131600b003b84a9e7445mr13398952qtk.21.1675150903772;
        Mon, 30 Jan 2023 23:41:43 -0800 (PST)
X-Google-Smtp-Source: AK7set8vKgpqG5EZrQ39ZZwl0nxZEVrPjxIbjUt/DuiD8RTXQH5Ffm24PmuSXQoKgbfm1kG+1FG/IA==
X-Received: by 2002:a05:622a:1316:b0:3b8:4a9e:7445 with SMTP id v22-20020a05622a131600b003b84a9e7445mr13398938qtk.21.1675150903529;
        Mon, 30 Jan 2023 23:41:43 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-155.web.vodafone.de. [109.43.176.155])
        by smtp.gmail.com with ESMTPSA id e11-20020ac8010b000000b003b630ea0ea1sm9406960qtg.19.2023.01.30.23.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 23:41:42 -0800 (PST)
Message-ID: <03662bf9-1c92-085b-7418-f3a218093051@redhat.com>
Date:   Tue, 31 Jan 2023 08:41:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
Content-Language: en-US
To:     Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>
Cc:     pbonzini@redhat.com, nrb@linux.ibm.com, imbrenda@linux.ibm.com,
        marcorr@google.com, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20230130195700.729498-1-coltonlewis@google.com>
 <20230130195700.729498-2-coltonlewis@google.com>
 <20230131063203.67qgjf2ispi2k6hd@orel>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230131063203.67qgjf2ispi2k6hd@orel>
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

On 31/01/2023 07.32, Andrew Jones wrote:
> On Mon, Jan 30, 2023 at 07:57:00PM +0000, Colton Lewis wrote:
>> Replace the MAX_SMP probe loop in favor of reading a number directly
>> from the QEMU error message. This is equally safe as the existing code
>> because the error message has had the same format as long as it has
>> existed, since QEMU v2.10. The final number before the end of the
>> error message line indicates the max QEMU supports. A short awk
> 
> awk is not used, despite the comment also being updated to say it's
> being used.
> 
>> program is used to extract the number, which becomes the new MAX_SMP
>> value.
>>
>> This loop logic is broken for machines with a number of CPUs that
>> isn't a power of two. This problem was noticed for gicv2 tests on
>> machines with a non-power-of-two number of CPUs greater than 8 because
>> tests were running with MAX_SMP less than 8. As a hypthetical example,

s/hypthetical/hypothetical/

>> a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
>> 6. This can, in rare circumstances, lead to different test results
>> depending only on the number of CPUs the machine has.
>>
>> A previous comment explains the loop should only apply to kernels
>> <=v4.3 on arm and suggests deletion when it becomes tiresome to
>> maintian. However, it is always theoretically possible to test on a

s/maintian/maintain/

>> machine that has more CPUs than QEMU supports, so it makes sense to
>> leave some check in place.
>>
>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   scripts/runtime.bash | 16 +++++++---------
>>   1 file changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>> index f8794e9a..587ffe30 100644
>> --- a/scripts/runtime.bash
>> +++ b/scripts/runtime.bash
>> @@ -188,12 +188,10 @@ function run()
>>   # Probe for MAX_SMP, in case it's less than the number of host cpus.
>>   #
>>   # This probing currently only works for ARM, as x86 bails on another
> 
> It just occurred to me that this code runs on all architectures, even
> though it only works for Arm. We should wrap this code in $ARCH
> checks or put it in a function which only Arm calls. That change
> should be a separate patch though.

Or we just grep for "max CPUs", since this seems to be used on other 
architectures, too:

$ qemu-system-x86_64 -smp 12345
qemu-system-x86_64: Invalid SMP CPUs 12345. The max CPUs supported by 
machine 'pc-i440fx-8.0' is 255

?

  Thomas

