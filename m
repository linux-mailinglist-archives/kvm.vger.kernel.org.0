Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0A566D6FD
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 08:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbjAQHeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 02:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235904AbjAQHd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 02:33:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6910298EE
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 23:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673940666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=97RK27ckw8/r+KYWQgIrxRst7KulfFflGfzx+fO9zRs=;
        b=QNa9hJ6f07PYhDzAnyhtOFFYKcjvHZ6QUXiB4NVc7T61UmKsI3yMvSLIhY1mhUUsND41+a
        UFgbzXnECfJn5f3pi3YBaxK3y128Fqlu+P5rRYXp/7Y2tZ365FOLwDySpv8/3uazexRJ4G
        LXI7edxzhN1hfvqQ69hGMrQMjD9NBLs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-638-QeUFNXWdMKyWHRJcTJEOdA-1; Tue, 17 Jan 2023 02:31:04 -0500
X-MC-Unique: QeUFNXWdMKyWHRJcTJEOdA-1
Received: by mail-qv1-f72.google.com with SMTP id r10-20020ad4522a000000b004d28fcbfe17so15524182qvq.4
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 23:31:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=97RK27ckw8/r+KYWQgIrxRst7KulfFflGfzx+fO9zRs=;
        b=DP6sbS82P+10kGDYSA4dbznaTam/4hzEVMJoqsycZpDa001qPcp9o94+4ARZihNZDX
         w4MI8dIt74V9GbCIF1v+UucehgqXd2c9zenODUPDlmRIVaLuOhpzUjlknfUgJMaESH/c
         q5U+p0IAOvoQRQO3ptXAe4u9xB1BTpBRouB7E/WCeMYtsBUOYniEiMt6JGHXSoOhL78G
         2SIr8eLAc3+LC7fJviJoM09I4yjZLTn3a0gNJqt3a5xfpQDYZXcjUKZcpTXQIpzl9cyb
         rgQzlSbQ8ownqJgSI6miwgj+3kHLqw60DKahf+GM3oz0QVutKB7MzMP8n5o/yvBIMrzo
         Pptg==
X-Gm-Message-State: AFqh2ko+pCkqX3tqJ5cfTkH83tUEkL2/dsNCTgsHE7OntJ0gbBpzkl7Z
        R/hM8gxasbko3d6BgQuVLvTqbS+Gw+5Vx25uTnFYDmABVpirHGhCU6MlfsXdklVh6f/TjwnYfpB
        ojf2sWgtuu0i4
X-Received: by 2002:ac8:776f:0:b0:3a7:e426:2892 with SMTP id h15-20020ac8776f000000b003a7e4262892mr33783118qtu.28.1673940664017;
        Mon, 16 Jan 2023 23:31:04 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtzZ7EW5Lb8eu56Fos1h5kpdcYpwG9mTkEqgzzm8sbzMR6n0vImc79K4Th2JSuaaB/pXAbRpg==
X-Received: by 2002:ac8:776f:0:b0:3a7:e426:2892 with SMTP id h15-20020ac8776f000000b003a7e4262892mr33783104qtu.28.1673940663770;
        Mon, 16 Jan 2023 23:31:03 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-26.web.vodafone.de. [109.43.177.26])
        by smtp.gmail.com with ESMTPSA id p16-20020a05620a057000b006fa12a74c53sm19391429qkp.61.2023.01.16.23.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 23:31:03 -0800 (PST)
Message-ID: <cd9e0c88-c2a8-1eca-d146-3fd6639af3e7@redhat.com>
Date:   Tue, 17 Jan 2023 08:30:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology: change-topology monitor
 command
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-9-pmorel@linux.ibm.com>
 <72baa5b42abe557cdf123889b33b845b405cc86c.camel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <72baa5b42abe557cdf123889b33b845b405cc86c.camel@linux.ibm.com>
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

On 16/01/2023 22.09, Nina Schoetterl-Glausch wrote:
> On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
>> The modification of the CPU attributes are done through a monitor
>> commands.
>>
>> It allows to move the core inside the topology tree to optimise
>> the cache usage in the case the host's hypervizor previously
>> moved the CPU.
>>
>> The same command allows to modifiy the CPU attributes modifiers
>> like polarization entitlement and the dedicated attribute to notify
>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>
>> With this knowledge the guest has the possibility to optimize the
>> usage of the vCPUs.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
...
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index b69955a1cd..0faffe657e 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -18,6 +18,10 @@
>>   #include "target/s390x/cpu.h"
>>   #include "hw/s390x/s390-virtio-ccw.h"
>>   #include "hw/s390x/cpu-topology.h"
>> +#include "qapi/qapi-commands-machine-target.h"
>> +#include "qapi/qmp/qdict.h"
>> +#include "monitor/hmp.h"
>> +#include "monitor/monitor.h"
>>   
>>   /*
>>    * s390_topology is used to keep the topology information.
>> @@ -203,6 +207,21 @@ static void s390_topology_set_entry(S390TopologyEntry *entry,
>>       s390_topology.sockets[s390_socket_nb(id)]++;
>>   }
>>   
>> +/**
>> + * s390_topology_clear_entry:
>> + * @entry: Topology entry to setup
>> + * @id: topology id to use for the setup
>> + *
>> + * Clear the core bit inside the topology mask and
>> + * decrements the number of cores for the socket.
>> + */
>> +static void s390_topology_clear_entry(S390TopologyEntry *entry,
>> +                                      s390_topology_id id)
>> +{
>> +    clear_bit(63 - id.core, &entry->mask);
> 
> This doesn't take the origin into account.
> 
>> +    s390_topology.sockets[s390_socket_nb(id)]--;
> 
> I suppose this function cannot run concurrently, so the same CPU doesn't get removed twice.

QEMU has the so-called BQL - the Big Qemu Lock. Instructions handlers are 
normally called with the lock taken, see qemu_mutex_lock_iothread() in 
target/s390x/kvm/kvm.c.

(if you feel unsure, you can add a "assert(qemu_mutex_iothread_locked())" 
statement, but I think it is not necessary here)

  Thomas

