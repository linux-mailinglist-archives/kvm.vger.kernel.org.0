Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2F5671A33
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 12:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjARLQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 06:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjARLPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 06:15:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D47392AB
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 02:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674037577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eFemePCEp1/bfwSzBa9WjqHldOuSGzjyVm7zYuBjk4U=;
        b=dWnsIRP+M2k01inDBPeInR1zINxFz3aNBq7GfNIARLACUW0s1MHPQYASubJR4Y9xH9d4yy
        jtnW+xlKXsHWB5lm/hkyrTSKEWnuGt+bEzrK0WteW8zQzNai+S5+KjtAwIIWElUaZzlmCL
        3xrahhqsdalj2+tO6L/p7CnR4OZANCk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-365-T3rlcHthPnWLV3Grg3-R6w-1; Wed, 18 Jan 2023 05:26:16 -0500
X-MC-Unique: T3rlcHthPnWLV3Grg3-R6w-1
Received: by mail-qk1-f200.google.com with SMTP id v7-20020a05620a0f0700b006faffce43b2so24540703qkl.9
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 02:26:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eFemePCEp1/bfwSzBa9WjqHldOuSGzjyVm7zYuBjk4U=;
        b=O+SWRO9yF+cb8OPNCYIxZ2tUEuYR6F9LGaydCcC18fAhKX4NdWVyAOrS7WjUjOl3En
         hZvSA02+XNpGQATO3du2hxbieJCll/rJ12wTL2qzKXsSVHktY5ona58AswdfbAJNVt94
         whyS0tgIRtRITP2fn84B/x4MHKV9DcA2tvv52RbvluITjMc1iX43NEDuGyY8pTVjTYk1
         nRVhMnCIXqqhnYnXBKpWvGjKRRqz1fLQOHmBtJHDopDnLGzylgBeJTl6W469O9OlYZfK
         /9XNFpRSlnFfIhSezkxdH81xBNSoiVWBja+qQ7BXx2yGiURSBPRrOOKxsoAqKwFo/9Mj
         h/dA==
X-Gm-Message-State: AFqh2kqcVPZXeHcYqiNebFAZ0I9HDjnXTzdEfnq/ngQnpNIo76YQqmvY
        4KhsJ/KaKk3bgo07JMCMcVwwPPKYCI5xUrrD1dV+WPmuDrCvQvbo/aFD1PnMdIr59t3AeVfeUoE
        JOMWImdtpZLt9
X-Received: by 2002:a05:622a:995:b0:3ad:797e:7314 with SMTP id bw21-20020a05622a099500b003ad797e7314mr10364228qtb.1.1674037576229;
        Wed, 18 Jan 2023 02:26:16 -0800 (PST)
X-Google-Smtp-Source: AMrXdXudDkWgwOi9ZwnyExyAX7M8A9ZGc6gHYBf0AT5S02JnfiUXAryiHYP0Veq6K1X+LW6lTWflvg==
X-Received: by 2002:a05:622a:995:b0:3ad:797e:7314 with SMTP id bw21-20020a05622a099500b003ad797e7314mr10364203qtb.1.1674037575988;
        Wed, 18 Jan 2023 02:26:15 -0800 (PST)
Received: from [192.168.8.105] (tmo-099-5.customers.d1-online.com. [80.187.99.5])
        by smtp.gmail.com with ESMTPSA id r3-20020ac84243000000b003a5430ee366sm17142668qtm.60.2023.01.18.02.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 02:26:15 -0800 (PST)
Message-ID: <9bf4841b-57a6-b08d-3d39-cd79ad0036e3@redhat.com>
Date:   Wed, 18 Jan 2023 11:26:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        frankja@linux.ibm.com
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-4-pmorel@linux.ibm.com>
 <5cf19913-b2d7-d72d-4332-27aa484f72e4@redhat.com>
 <01782d4e-4c84-f958-b427-ff294f6c3c3f@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v14 03/11] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
In-Reply-To: <01782d4e-4c84-f958-b427-ff294f6c3c3f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/01/2023 17.56, Pierre Morel wrote:
> 
> 
> On 1/10/23 15:29, Thomas Huth wrote:
>> On 05/01/2023 15.53, Pierre Morel wrote:
>>> On interception of STSI(15.1.x) the System Information Block
>>> (SYSIB) is built from the list of pre-ordered topology entries.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
...
>>> +typedef struct SysIBTl_container {
>>> +        uint8_t nl;
>>> +        uint8_t reserved[6];
>>> +        uint8_t id;
>>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
>>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
>>> +
>>> +/* CPU type Topology List Entry */
>>> +typedef struct SysIBTl_cpu {
>>> +        uint8_t nl;
>>> +        uint8_t reserved0[3];
>>> +        uint8_t reserved1:5;
>>> +        uint8_t dedicated:1;
>>> +        uint8_t polarity:2;
>>
>> Hmmm, yet another bitfield...
> 
> Yes, this is the firmware interface.
> If it makes problem I can use masks and logic arithmetic

It depends ... if we are sure that this will ever only be used with KVM on 
real s390x hardware, then bitfields are OK. If we think that this is 
something that could be implemented in TCG, too, I'd scratch the bitfields 
and use logic arithmetic instead...

I'm not too experienced with this CPU topology stuff, but it sounds like it 
could be implemented in TCG without too much efforts one day, too, so I'd 
rather go with the logic arithmetic immediately instead if it is not too 
annoying for you right now.

>>> diff --git a/target/s390x/kvm/cpu_topology.c 
>>> b/target/s390x/kvm/cpu_topology.c
>>> new file mode 100644
>>> index 0000000000..3831a3264c
>>> --- /dev/null
>>> +++ b/target/s390x/kvm/cpu_topology.c
>>> @@ -0,0 +1,136 @@
>>> +/*
>>> + * QEMU S390x CPU Topology
>>> + *
>>> + * Copyright IBM Corp. 2022
>>
>> Happy new year?
> 
> So after Nina's comment what do I do?
> let it be 22 because I started last year or update because what is important 
> is when it comes into mainline?

Honestly, I don't have a really good clue either... But keeping 2022 is 
certainly fine for me, too.

  Thomas

