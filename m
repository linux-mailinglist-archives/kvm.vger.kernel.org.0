Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B08682B0B
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 12:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjAaLBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 06:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjAaLBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 06:01:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48778470B7
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 03:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675162850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/vEsADki5Q+vuh8+dW4Sfzn1JKelRrET+KVQthmdvnY=;
        b=LhfHc5vs2/UTtylEO8yOAXjuC/o0qVK68Z9naL8p7Jk98HTfuoQ7E1GFioraBFBUlqTwv8
        vyqYcIDw1UnvRImD4TNUPvtXQ8cxInsTTlLMdWZ8CUdW9mg7agbA5OdZ0jRtIVhL1Fw1oU
        JIRSUs1Lgus/EpmVz2H32SpIUw+wJg8=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-391-5FKixHJBPVGglBl_LJ26eQ-1; Tue, 31 Jan 2023 06:00:49 -0500
X-MC-Unique: 5FKixHJBPVGglBl_LJ26eQ-1
Received: by mail-qt1-f198.google.com with SMTP id hf20-20020a05622a609400b003abcad051d2so6349578qtb.12
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 03:00:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/vEsADki5Q+vuh8+dW4Sfzn1JKelRrET+KVQthmdvnY=;
        b=MeEhT8iD9d5tWCm5cFu9YT7+UtazL4OA3MFqjyZVbMTHgAhh+c/2T0CFxfNngs3X+f
         cPt55DMXWN17WciJDPBeFSs9M2YAy1Btom01BAWEz9W136W17lP0/yGs11h+X74RJ3h1
         FwZOX3//BFd+ApDmfWf9sS9GnCROiJpogZpG8/VkkPTk/uucUId3AckBPgASz+IUxARY
         zzi4d3Y/GriEGaN2A+j+dEo6IR0QNpkrKCJIcxUYyv2Fu5KOIzy4pjnQTRTuayJaBqYZ
         2B5Q4FTCM8yKSbA4o35wc/+meUwCLHTbgGvO7wxdlD7gfknMVOYdpc+j7H6Xv0lkANsY
         QlKQ==
X-Gm-Message-State: AO0yUKVXvVU6/GfoczztRrbyZVT69zRUNhJmxAqk6YemYt3PHgdX4ukv
        20jVgbAKZ6CKcGt+DGI5nOeov6GqTPRlmv9Tz+mzYK4zueHP/tligMRj/hrKd84buDfqyxVP+jp
        Hdbwk0OKL9Uzu
X-Received: by 2002:a05:622a:15c5:b0:3b8:6d92:bf62 with SMTP id d5-20020a05622a15c500b003b86d92bf62mr8431740qty.46.1675162848826;
        Tue, 31 Jan 2023 03:00:48 -0800 (PST)
X-Google-Smtp-Source: AK7set/mF94pWQd+qQNFN9TC5e4kLKvyGLJUhAz/q6EAFVu/nFoMdMZzTxlkBcszPUc11acZsafETg==
X-Received: by 2002:a05:622a:15c5:b0:3b8:6d92:bf62 with SMTP id d5-20020a05622a15c500b003b86d92bf62mr8431703qty.46.1675162848602;
        Tue, 31 Jan 2023 03:00:48 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-155.web.vodafone.de. [109.43.176.155])
        by smtp.gmail.com with ESMTPSA id o11-20020ac8428b000000b003b63b8df24asm2119653qtl.36.2023.01.31.03.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 03:00:48 -0800 (PST)
Message-ID: <0fac7f76-d74d-0ed1-f810-617e9e80165f@redhat.com>
Date:   Tue, 31 Jan 2023 12:00:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
Content-Language: en-US
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Colton Lewis <coltonlewis@google.com>, pbonzini@redhat.com,
        nrb@linux.ibm.com, imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20230130195700.729498-1-coltonlewis@google.com>
 <20230130195700.729498-2-coltonlewis@google.com>
 <20230131063203.67qgjf2ispi2k6hd@orel>
 <03662bf9-1c92-085b-7418-f3a218093051@redhat.com>
 <20230131105746.yypnggzz7ifjmp4d@orel>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230131105746.yypnggzz7ifjmp4d@orel>
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

On 31/01/2023 11.57, Andrew Jones wrote:
> On Tue, Jan 31, 2023 at 08:41:39AM +0100, Thomas Huth wrote:
>> On 31/01/2023 07.32, Andrew Jones wrote:
>>> On Mon, Jan 30, 2023 at 07:57:00PM +0000, Colton Lewis wrote:
>>>> Replace the MAX_SMP probe loop in favor of reading a number directly
>>>> from the QEMU error message. This is equally safe as the existing code
>>>> because the error message has had the same format as long as it has
>>>> existed, since QEMU v2.10. The final number before the end of the
>>>> error message line indicates the max QEMU supports. A short awk
>>>
>>> awk is not used, despite the comment also being updated to say it's
>>> being used.
>>>
>>>> program is used to extract the number, which becomes the new MAX_SMP
>>>> value.
>>>>
>>>> This loop logic is broken for machines with a number of CPUs that
>>>> isn't a power of two. This problem was noticed for gicv2 tests on
>>>> machines with a non-power-of-two number of CPUs greater than 8 because
>>>> tests were running with MAX_SMP less than 8. As a hypthetical example,
>>
>> s/hypthetical/hypothetical/
>>
>>>> a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
>>>> 6. This can, in rare circumstances, lead to different test results
>>>> depending only on the number of CPUs the machine has.
>>>>
>>>> A previous comment explains the loop should only apply to kernels
>>>> <=v4.3 on arm and suggests deletion when it becomes tiresome to
>>>> maintian. However, it is always theoretically possible to test on a
>>
>> s/maintian/maintain/
>>
>>>> machine that has more CPUs than QEMU supports, so it makes sense to
>>>> leave some check in place.
>>>>
>>>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>>>> ---
>>>>    scripts/runtime.bash | 16 +++++++---------
>>>>    1 file changed, 7 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>>>> index f8794e9a..587ffe30 100644
>>>> --- a/scripts/runtime.bash
>>>> +++ b/scripts/runtime.bash
>>>> @@ -188,12 +188,10 @@ function run()
>>>>    # Probe for MAX_SMP, in case it's less than the number of host cpus.
>>>>    #
>>>>    # This probing currently only works for ARM, as x86 bails on another
>>>
>>> It just occurred to me that this code runs on all architectures, even
>>> though it only works for Arm. We should wrap this code in $ARCH
>>> checks or put it in a function which only Arm calls. That change
>>> should be a separate patch though.
>>
>> Or we just grep for "max CPUs", since this seems to be used on other
>> architectures, too:
>>
>> $ qemu-system-x86_64 -smp 12345
>> qemu-system-x86_64: Invalid SMP CPUs 12345. The max CPUs supported by
>> machine 'pc-i440fx-8.0' is 255
>>
>> ?
>>
> 
> Yes, if we can find an arch-common way to set MAX_SMP, then the variable
> could be used in their test configs and gitlab-ci scripts. For example,
> afaict, x86 doesn't have any tests that run with more than 4 cpus at the
> moment. Being able to bump that up for some tests might increase test
> coverage. That said, it might be stretching the scope of this patch a bit
> much. How about we keep the grep the same for now and guard with $ARCH.
> Other architectures can either share Arm's grep, tweak the grep and share
> it, or add their own grep, when/if they want to start using MAX_SMP.

Ok, fair point, we still can adjust later.

  Thomas


