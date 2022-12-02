Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136BE64085F
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 15:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbiLBO11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 09:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLBO10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 09:27:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72943CFE6E
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 06:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669991189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ktJw7/THvKJQoer2k/gtmvKNVq80OfR1EB/ZswF3ibA=;
        b=gxBameohcwia10bznSdzsiScaQTwB67T35sfORRDIFw3FQVIiitiAr8iN+GuOxBOUuVWkM
        8DTNdcm13iDPEqcqlyqtGHnEN1FCurUl5k7R3Y3xwm7jzDsBsrY+FACf0q+B/u07nl5T3y
        kxyHmHZcPxvtxBEcEwK+guQkWygAFfo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-400-WnX5blDsOr6rLw9D8dAIiw-1; Fri, 02 Dec 2022 09:26:25 -0500
X-MC-Unique: WnX5blDsOr6rLw9D8dAIiw-1
Received: by mail-wm1-f71.google.com with SMTP id h9-20020a1c2109000000b003cfd37aec58so2586914wmh.1
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 06:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ktJw7/THvKJQoer2k/gtmvKNVq80OfR1EB/ZswF3ibA=;
        b=nH1KeZ6KGII5y3SbBuFw87a5E2FfusZAwY2jVsdCLTNsES9g274gifE47KOM29JqpA
         f5bPSdpqFpqwQxLyZyiP+PSkic/YMnXWO4ocAKIu74H2CDKZhP8tmYxOgMLLHO6L62Wz
         J2QjnHx+YtTQNiVDtXJ5jEylmuwqHbhiyxv6Rw8yrNMzhfgza6S9UsWHUuzVF3wMwO+c
         vFWmzlrpI8tODvMh+8gSkqo7UKtjU5MaC00XpFkjWr9d3G5nUzWBFrA47vok3Y3oeLIF
         DU2Vr4jn2+tmH50NXB+P9Cq9+devOLUnvLog8OXZShzW0nukpCouDLCV2WEZqZ9OsesT
         Ek3w==
X-Gm-Message-State: ANoB5pkpmO6M77s9Hde13203RRCubRrYmAEoDI930601QxSgBPKz5ITH
        PFEEQJ088XsKbXuaZWrA+jCU2R2PxwXCkHuMpsi/OtvC8HSYfaH3yvn5Y5Z5/6lzBXnEAjzSCj0
        OAqYDRGD0pDxq
X-Received: by 2002:a5d:44c9:0:b0:242:ac5:e5e6 with SMTP id z9-20020a5d44c9000000b002420ac5e5e6mr19110881wrr.127.1669991184688;
        Fri, 02 Dec 2022 06:26:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf74xCjHk/8jPmEDg28xhITzDYfDfF6+mdxAi0ScwpscCS6wYsH4t8jqx+tup07nZhB63CHYJg==
X-Received: by 2002:a5d:44c9:0:b0:242:ac5:e5e6 with SMTP id z9-20020a5d44c9000000b002420ac5e5e6mr19110859wrr.127.1669991184430;
        Fri, 02 Dec 2022 06:26:24 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-178-86.web.vodafone.de. [109.43.178.86])
        by smtp.gmail.com with ESMTPSA id q1-20020a05600000c100b002422fddcc94sm6545678wrx.96.2022.12.02.06.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 06:26:23 -0800 (PST)
Message-ID: <2c65f234-688a-796b-b451-e1661b2c07a4@redhat.com>
Date:   Fri, 2 Dec 2022 15:26:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        david@redhat.com
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, cohuck@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-7-pmorel@linux.ibm.com>
 <fcedb98d-4333-9100-5366-8848727528f3@redhat.com>
 <ea965d1c-ab6a-5aa3-8ce3-65b8177f6320@linux.ibm.com>
 <37a20bee-a3fb-c421-b89d-c1760e77cb11@redhat.com>
 <59669e8e-6242-9c01-4c2e-5d70b9c31b2b@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v12 6/7] s390x/cpu_topology: activating CPU topology
In-Reply-To: <59669e8e-6242-9c01-4c2e-5d70b9c31b2b@linux.ibm.com>
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

On 02/12/2022 15.08, Pierre Morel wrote:
> 
> 
> On 12/2/22 10:05, Thomas Huth wrote:
>> On 01/12/2022 12.52, Pierre Morel wrote:
>>>
>>>
>>> On 12/1/22 11:15, Thomas Huth wrote:
>>>> On 29/11/2022 18.42, Pierre Morel wrote:
>>>>> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
>>>>> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
>>>>> the topology facility for the guest in the case the topology
>>>>> is available in QEMU and in KVM.
>>>>>
>>>>> The feature is fenced for SE (secure execution).
>>>>
>>>> Out of curiosity: Why does it not work yet?
>>>>
>>>>> To allow smooth migration with old QEMU the feature is disabled by
>>>>> default using the CPU flag -disable-topology.
>>>>
>>>> I stared at this code for a while now, but I have to admit that I don't 
>>>> quite get it. Why do we need a new "disable" feature flag here? I think 
>>>> it is pretty much impossible to set "ctop=on" with an older version of 
>>>> QEMU, since it would require the QEMU to enable 
>>>> KVM_CAP_S390_CPU_TOPOLOGY in the kernel for this feature bit - and older 
>>>> versions of QEMU don't set this capability yet.
>>>>
>>>> Which scenario would fail without this disable-topology feature bit? 
>>>> What do I miss?
>>>
>>> The only scenario it provides is that ctop is then disabled by default on 
>>> newer QEMU allowing migration between old and new QEMU for older machine 
>>> without changing the CPU flags.
>>>
>>> Otherwise, we would need -ctop=off on newer QEMU to disable the topology.
>>
>> Ah, it's because you added S390_FEAT_CONFIGURATION_TOPOLOGY to the default 
>> feature set here:
>>
>>   static uint16_t default_GEN10_GA1[] = {
>>       S390_FEAT_EDAT,
>>       S390_FEAT_GROUP_MSA_EXT_2,
>> +    S390_FEAT_DISABLE_CPU_TOPOLOGY,
>> +    S390_FEAT_CONFIGURATION_TOPOLOGY,
>>   };
>>
>> ?
>>
>> But what sense does it make to enable it by default, just to disable it by 
>> default again with the S390_FEAT_DISABLE_CPU_TOPOLOGY feature? ... sorry, 
>> I still don't quite get it, but maybe it's because my sinuses are quite 
>> clogged due to a bad cold ... so if you could elaborate again, that would 
>> be very appreciated!
>>
>> However, looking at this from a distance, I would not rather not add this 
>> to any default older CPU model at all (since it also depends on the kernel 
>> to have this feature enabled)? Enabling it in the host model is still ok, 
>> since the host model is not migration safe anyway.
>>
>>   Thomas
>>
> 
> I think I did not understand what is exactly the request that was made about 
> having a CPU flag to disable the topology when we decide to not have a new 
> machine with new machine property.
> 
> Let see what we have if the only change to mainline is to activate 
> S390_FEAT_CONFIGURATION_TOPOLOGY with the KVM capability:
> 
> In mainline, ctop is enabled in the full GEN10 only.
> 
> Consequently we have this feature activated by default for the host model 
> only and deactivated by default if we specify the CPU.
> It can be activated if we specify the CPU with the flag ctop=on.
> 
> This is what was in the patch series before the beginning of the discussion 
> about having a new machine property for new machines.

Sorry for all the mess ... I'm also not an expert when it comes to CPU model 
features paired with compatibility and migration, and I'm still in progress 
of learning ...

> If this what we want: activating the topology by the CPU flag ctop=on it is 
> perfect for me and I can take the original patch.
> We may later make it a default for new machines.

Given my current understanding, I think it's the best thing to do right now. 
Not enable it by default, except for the host model where the enablement is 
fine since migration is not supported any.

As you said, we could still decide later to change the default for new 
machines. Though, I recently learnt that features should also not be enable 
by default at all if they depend on the environment, like a Linux kernel 
that needs to have support for the feature. So maybe we should keep it off 
by default forever - or just enable it on new CPU models (>=z17?) that would 
require a new host kernel anyway.

  Thomas

