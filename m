Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3476897A2
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 12:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbjBCLWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 06:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjBCLWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 06:22:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FDC20D2C
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 03:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675423273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qC5KX9oA+s0yDAQv5Vu1JAndP1FtDrSNVvzF24V+jHQ=;
        b=EiaoBYV//iH9DVm4cwOZ5/VfuaP9/7etl9V7GB63TwY20lKimni4qE7eAfcIUJ+g7szAiV
        zVLv4aj9F8Gx9zWSyeYJf++SudWGOEJrII44SBc/KX1yhoMMoLflgnY5Dk6kHD5BjNEWWo
        2/r0A2JTBi5dw6bG1kHpOf8/+47WqjE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-91-HD_Y8reXODq36K0g0Gw-4A-1; Fri, 03 Feb 2023 06:21:12 -0500
X-MC-Unique: HD_Y8reXODq36K0g0Gw-4A-1
Received: by mail-qk1-f199.google.com with SMTP id 130-20020a370588000000b0072fcbe20069so106001qkf.22
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 03:21:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qC5KX9oA+s0yDAQv5Vu1JAndP1FtDrSNVvzF24V+jHQ=;
        b=FaOyP5dEhkwnv823leTOmWzyhE6cUzJw+o/8winWdNMgMUfS4d65zstlyoDh8+vV5l
         GKHoW/OLoECfRqHwGup4vT1W/2KO8i9vTagYgKb6hlD8ajtRwwmqav/4t8czOUTaKH0w
         54kgR+7jQ3DEpNsenfj7a93GyIhSHmHy0mRLV4wT/vMzSEkoYH5H/qRCGscVAq8BvZIW
         /58zV9lzUhKjCqOwt6Pode16Lbx3asz02Kn/UnvPjKE4lzsT0FPex0CBLySs4iNiyH5p
         wMsVdxVnoZR/4VcHVhRwti4V0fwm0YLfvdIysdb8QE02BgpsnBDY+xlYGoua4hexx8KW
         aWNg==
X-Gm-Message-State: AO0yUKUJOVzhSHKmSpqqRVYBGeypZIBLcb6U6UD8CoFM0IIqjBB5G2y/
        2myBHigKY7Vk6LiS12T1uSc+RDWQHbaL2Q54oUBiNdm3jTA0YJjLNmV4BKA3pRkHXe4HuJWztp2
        2rEsrX6kT/4Ef
X-Received: by 2002:a0c:c349:0:b0:53b:bcf5:843f with SMTP id j9-20020a0cc349000000b0053bbcf5843fmr14485000qvi.36.1675423271800;
        Fri, 03 Feb 2023 03:21:11 -0800 (PST)
X-Google-Smtp-Source: AK7set+xoSXGyg8lTuml8la4W/ra3P+BuT+ZKC30r0i0uqVwXdk5dZAeJuu7odItq/RD9ap+vOSnUQ==
X-Received: by 2002:a0c:c349:0:b0:53b:bcf5:843f with SMTP id j9-20020a0cc349000000b0053bbcf5843fmr14484965qvi.36.1675423271545;
        Fri, 03 Feb 2023 03:21:11 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-179-40.web.vodafone.de. [109.43.179.40])
        by smtp.gmail.com with ESMTPSA id g19-20020ac84b73000000b003b8558eabd0sm1400316qts.23.2023.02.03.03.21.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 03:21:10 -0800 (PST)
Message-ID: <95b6cc32-77f6-5364-5293-be0f9944517c@redhat.com>
Date:   Fri, 3 Feb 2023 12:21:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v15 01/11] s390x/cpu topology: adding s390 specificities
 to CPU topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-2-pmorel@linux.ibm.com>
 <9fed7aba2819a6564b785e90c2284b2a83f35431.camel@linux.ibm.com>
 <4ef7d6a2-c9aa-9994-48ac-21d6ed865a45@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <4ef7d6a2-c9aa-9994-48ac-21d6ed865a45@linux.ibm.com>
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

On 03/02/2023 10.39, Pierre Morel wrote:
> 
> @Thomas, these changes look good to me.
> What do you think, do I make the change and keep your RB ?

Yes, splitting that enum sounds cleaner, indeed.

  Thomas


> On 2/2/23 17:05, Nina Schoetterl-Glausch wrote:
>> Nit patch title: s390x/cpu topology: add s390 specifics to CPU topology ?
>>
> 
> OK
> 
>> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
>>> S390 adds two new SMP levels, drawers and books to the CPU
>>> topology.
>>> The S390 CPU have specific toplogy features like dedication
>>                                  ^o
> 
> Yes thx
> 
>>> and polarity to give to the guest indications on the host
>>> vCPUs scheduling and help the guest take the best decisions
>>> on the scheduling of threads on the vCPUs.
>>>
>>> Let us provide the SMP properties with books and drawers levels
>>> and S390 CPU with dedication and polarity,
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   qapi/machine.json               | 14 ++++++++--
>>>   include/hw/boards.h             | 10 ++++++-
>>>   include/hw/s390x/cpu-topology.h | 24 +++++++++++++++++
>>>   target/s390x/cpu.h              |  5 ++++
>>>   hw/core/machine-smp.c           | 48 ++++++++++++++++++++++++++++-----
>>>   hw/core/machine.c               |  4 +++
>>>   hw/s390x/s390-virtio-ccw.c      |  2 ++
>>>   softmmu/vl.c                    |  6 +++++
>>>   target/s390x/cpu.c              |  7 +++++
>>>   qemu-options.hx                 |  7 +++--
>>>   10 files changed, 115 insertions(+), 12 deletions(-)
>>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>>
>> [...]
>>>
>>> diff --git a/include/hw/s390x/cpu-topology.h 
>>> b/include/hw/s390x/cpu-topology.h
>>> new file mode 100644
>>> index 0000000000..7a84b30a21
>>> --- /dev/null
>>> +++ b/include/hw/s390x/cpu-topology.h
>>> @@ -0,0 +1,24 @@
>>> +/*
>>> + * CPU Topology
>>> + *
>>> + * Copyright IBM Corp. 2022
>>> + *
>>> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
>>> + * your option) any later version. See the COPYING file in the top-level
>>> + * directory.
>>> + */
>>> +#ifndef HW_S390X_CPU_TOPOLOGY_H
>>> +#define HW_S390X_CPU_TOPOLOGY_H
>>> +
>>> +#define S390_TOPOLOGY_CPU_IFL   0x03
>>> +
>>> +enum s390_topology_polarity {
>>> +    POLARITY_HORIZONTAL,
>>> +    POLARITY_VERTICAL,
>>> +    POLARITY_VERTICAL_LOW = 1,
>>> +    POLARITY_VERTICAL_MEDIUM,
>>> +    POLARITY_VERTICAL_HIGH,
>>> +    POLARITY_MAX,
>>> +};
>>
>> Probably a good idea to keep the S390 prefix.
>> This works, but aliasing VERTICAL and VERTICAL_LOW is not
>> entirely straight forward.
>>
>> Why not have two enum?
>> enum s390_topology_polarity {
>>     S390_POLARITY_HORIZONTAL,
>>     S390_POLARITY_VERTICAL,
>> };
>>
>> enum s390_topology_entitlement {
>>     S390_ENTITLEMENT_LOW = 1,
>>     S390_ENTITLEMENT_MEDIUM,
>>     S390_ENTITLEMENT_HIGH,
>>     S390_ENTITLEMENT_MAX,
>> };
>> Maybe add an ENTITLEMENT_INVALID/NONE, if you need that, as first value.
>>
> 
> If Thomas agree, I do the changes.
> 
> Regards,
> Pierre
> 
> 

