Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23B668D3C0
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 11:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjBGKLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 05:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjBGKLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 05:11:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D38365A3
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 02:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675764648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GaJ1eqGYVO2m1fzMUCWDV4TzJSQxwVKtY4hpu6q92yM=;
        b=DFGHNCTnf/36GodMf+WbL+yhuu7ULj5gkDolB9oUGT76gvT/BMeTg1lHiFeYvio13QQd/A
        wZyASlJ+PMD33ejTZbxJWXv8YFtzO3zE1K9NTzI1ZmCAmEwQ66HemisJzsIuJsXei+8yWM
        n0kl+zqDcMe5TBWYKxYkntC3wsQ3Kcg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-81-JAseBXVwOZi-k6ubSQow_w-1; Tue, 07 Feb 2023 05:10:47 -0500
X-MC-Unique: JAseBXVwOZi-k6ubSQow_w-1
Received: by mail-qt1-f198.google.com with SMTP id v8-20020a05622a144800b003ba0dc5d798so6128684qtx.22
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 02:10:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GaJ1eqGYVO2m1fzMUCWDV4TzJSQxwVKtY4hpu6q92yM=;
        b=CCrFxDfupW7dJ0qoJ7PCNAAYIWM2vxYp3As4asUFwO03DhcGdsMjxyXy6dOGsRCzzZ
         KYxWpJYJ35SESiuQhfHhh+/+a56hujdmh0JQZkKuxZ6njfEfJwz1FNzQ+LeIIjMfvh5y
         GUHDLq98ZD2VN5KSENsHPY5bo20cjfIh+YIbIuUJUKWtW9CFDJ48lIBfglIaBuurvjN9
         1tnUuv8w/TOwj9KamNDJ6r9EpEHwbaNTu0iN+H9WtOzR08QpVb3Zy9Coatr/VJ8hstoI
         LzCFckegcft/ig12pnYo9v3Gtf37m6QTphu3eCm6frw5qObvetFsW/9UxRJlkmubJfxU
         OXRg==
X-Gm-Message-State: AO0yUKW+O/0wosQxBGpG04KoPfCi/OaM3axO23TMKLT0guB0alCQAOQ7
        1RAvBNojIgVaVRRYPe7KPXaZsmtWiBIbS+6LDYskOVZzfgvPgLqrWMIVsFbYRojfhzkIhA+ahuI
        sSEOn1JPdcxF8
X-Received: by 2002:a05:6214:5191:b0:56b:4e51:acd5 with SMTP id kl17-20020a056214519100b0056b4e51acd5mr4038563qvb.12.1675764646775;
        Tue, 07 Feb 2023 02:10:46 -0800 (PST)
X-Google-Smtp-Source: AK7set8brvIiymTcOybCkThVC+EK+7hv6UVOws47+1hKcCfznHu8FN7x3UaTighSEXeQRFrtWTpMiA==
X-Received: by 2002:a05:6214:5191:b0:56b:4e51:acd5 with SMTP id kl17-20020a056214519100b0056b4e51acd5mr4038547qvb.12.1675764646545;
        Tue, 07 Feb 2023 02:10:46 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-120.web.vodafone.de. [109.43.176.120])
        by smtp.gmail.com with ESMTPSA id g12-20020a05620a13cc00b00706a452c074sm8989347qkl.104.2023.02.07.02.10.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 02:10:45 -0800 (PST)
Message-ID: <969ce73e-1266-7c15-991b-e56c0d748335@redhat.com>
Date:   Tue, 7 Feb 2023 11:10:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v15 09/11] machine: adding s390 topology to query-cpu-fast
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     armbru@redhat.com, Michael Roth <michael.roth@amd.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-10-pmorel@linux.ibm.com>
 <a7a235d5-4ded-b83d-dcb6-2cf81ad5f283@redhat.com>
 <Y+D3PH0EkUPshIMO@redhat.com>
 <e1828071-551a-b5cb-8da5-cea91f075548@redhat.com>
 <Y+ETxSadUGC/UJGY@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <Y+ETxSadUGC/UJGY@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/02/2023 15.50, Daniel P. Berrangé wrote:
> On Mon, Feb 06, 2023 at 02:09:57PM +0100, Thomas Huth wrote:
>> On 06/02/2023 13.49, Daniel P. Berrangé wrote:
>>> On Mon, Feb 06, 2023 at 01:41:44PM +0100, Thomas Huth wrote:
>>>> On 01/02/2023 14.20, Pierre Morel wrote:
>>>>> S390x provides two more topology containers above the sockets,
>>>>> books and drawers.
>>>>>
>>>>> Let's add these CPU attributes to the QAPI command query-cpu-fast.
>>>>>
>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>> ---
>>>>>     qapi/machine.json          | 13 ++++++++++---
>>>>>     hw/core/machine-qmp-cmds.c |  2 ++
>>>>>     2 files changed, 12 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/qapi/machine.json b/qapi/machine.json
>>>>> index 3036117059..e36c39e258 100644
>>>>> --- a/qapi/machine.json
>>>>> +++ b/qapi/machine.json
>>>>> @@ -53,11 +53,18 @@
>>>>>     #
>>>>>     # Additional information about a virtual S390 CPU
>>>>>     #
>>>>> -# @cpu-state: the virtual CPU's state
>>>>> +# @cpu-state: the virtual CPU's state (since 2.12)
>>>>> +# @dedicated: the virtual CPU's dedication (since 8.0)
>>>>> +# @polarity: the virtual CPU's polarity (since 8.0)
>>>>>     #
>>>>>     # Since: 2.12
>>>>>     ##
>>>>> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
>>>>> +{ 'struct': 'CpuInfoS390',
>>>>> +    'data': { 'cpu-state': 'CpuS390State',
>>>>> +              'dedicated': 'bool',
>>>>> +              'polarity': 'int'
>>>>
>>>> I think it would also be better to mark the new fields as optional and only
>>>> return them if the guest has the topology enabled, to avoid confusing
>>>> clients that were written before this change.
>>>
>>> FWIW, I would say that the general expectation of QMP clients is that
>>> they must *always* expect new fields to appear in dicts that are
>>> returned in QMP replies. We add new fields at will on a frequent basis.
>>
>> Did we change our policy here? I slightly remember I've been told
>> differently in the past ... but I can't recall where this was, it's
>> certainly been a while.
>>
>> So a question to the QAPI maintainers: What's the preferred handling for new
>> fields nowadays in such situations?
> 
> I think you're mixing it up with policy for adding new fields to *input*
> parameters. You can't add a new mandatory field to input params of a
> command because no existing client will be sending that. Only optional
> params are viable, without a deprecation cycle. For output parameters
> such as this case, there's no compatibilty problem.

Ah, right, I likely mixed it up with that. Thanks for the clarification!

  Thomas


