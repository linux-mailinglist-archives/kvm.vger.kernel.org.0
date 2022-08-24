Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0351659F45B
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 09:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbiHXHbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 03:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiHXHa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 03:30:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253C461124
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 00:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661326256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iZI6L+XW0+joKvXX7bCcDey2XinRX/8HVHi6ehaHZCs=;
        b=B/3cER11SRHcOFNzX24oiBHs+r4D70JrS3HvpBKQjUONDO/OU9hxJUYrllsGLmXOlHNezG
        u9XsaXjECQDLoJqXVNrkOYaAfXFKid0QHVRCacfCGRs9Qr9atuvOajiQ65yLl1kyMMMRCu
        NAX2Z/o6SezmYEbjoKfD/9lCBsT4zrY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-501-efIT273WP9Gef_xxlImeiQ-1; Wed, 24 Aug 2022 03:30:55 -0400
X-MC-Unique: efIT273WP9Gef_xxlImeiQ-1
Received: by mail-wm1-f71.google.com with SMTP id n1-20020a7bc5c1000000b003a682987306so204960wmk.1
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 00:30:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=iZI6L+XW0+joKvXX7bCcDey2XinRX/8HVHi6ehaHZCs=;
        b=mdGZpu6lOwZFsf2x6OGWk2cwjs9WdwrEdKs4Tyc0elJe+C751tJrKWHVAYQIku5/FA
         ujb/rnvsg5UHhDFAb3/bbTIYvnlpyGPW+nvJb8OlIxI25j6HFkTUCWAS1MVU066hd0G6
         +z0UAnIdYrpiVWUHzC7AK+QB46ZgcxIq3vf547ebsZTT9YaEV5OO7GRgBCccnGBFK0Qx
         YYqT68fWebAY/9hj7m9MolunL7wEGfpRU7CN9MIRk1lqe6Wx2T5PwIDJ2f4gx/Jl5ijE
         bcT/8zdJCDn1z0zPtEffBhtKjdotNLkQrKX2gWPtFsuFvAGf8nd8nG9YOUaZ3soBx767
         PigQ==
X-Gm-Message-State: ACgBeo0TjCu6lhbHpFd8mndHpvVsn9jgQFkTCb2eCB9xlZv5e2SPrszO
        1/Au4gOZcTospvRN4VwUBMD2WOMqvMG6n2Hhk4GrAqGET6F6wLht9CDKvtuDNi49wu+F/GR1jlf
        Es6KbX1fDsSkr
X-Received: by 2002:a1c:a187:0:b0:3a5:e055:715b with SMTP id k129-20020a1ca187000000b003a5e055715bmr4403982wme.171.1661326253836;
        Wed, 24 Aug 2022 00:30:53 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4BPVVDRWnSINI3f3hTjZ7cML9UdqfHfnNc0yFnEsBaCCTsHq+eBrnlQaRMVx9bq4TShjn41Q==
X-Received: by 2002:a1c:a187:0:b0:3a5:e055:715b with SMTP id k129-20020a1ca187000000b003a5e055715bmr4403962wme.171.1661326253560;
        Wed, 24 Aug 2022 00:30:53 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-177.web.vodafone.de. [109.43.176.177])
        by smtp.gmail.com with ESMTPSA id d3-20020a05600c34c300b003a60f0f34b7sm948562wmq.40.2022.08.24.00.30.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 00:30:53 -0700 (PDT)
Message-ID: <be11a5fd-1955-2d26-38d9-3a8b9ffaf42f@redhat.com>
Date:   Wed, 24 Aug 2022 09:30:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v8 02/12] s390x/cpu_topology: CPU topology objects and
 structures
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-3-pmorel@linux.ibm.com>
 <b6c981e0-56f5-25c3-3422-ed72c8561712@redhat.com>
 <ca410180-1699-7a04-6417-b59540edc87d@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <ca410180-1699-7a04-6417-b59540edc87d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/08/2022 19.41, Pierre Morel wrote:
> 
> 
> On 8/23/22 15:30, Thomas Huth wrote:
>> On 20/06/2022 16.03, Pierre Morel wrote:
>>> We use new objects to have a dynamic administration of the CPU topology.
>>> The highest level object in this implementation is the s390 book and
>>> in this first implementation of CPU topology for S390 we have a single
>>> book.
>>> The book is built as a SYSBUS bridge during the CPU initialization.
>>> Other objects, sockets and core will be built after the parsing
>>> of the QEMU -smp argument.
>>>
>>> Every object under this single book will be build dynamically
>>> immediately after a CPU has be realized if it is needed.
>>> The CPU will fill the sockets once after the other, according to the
>>> number of core per socket defined during the smp parsing.
>>>
>>> Each CPU inside a socket will be represented by a bit in a 64bit
>>> unsigned long. Set on plug and clear on unplug of a CPU.
>>>
>>> For the S390 CPU topology, thread and cores are merged into
>>> topology cores and the number of topology cores is the multiplication
>>> of cores by the numbers of threads.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   hw/s390x/cpu-topology.c         | 391 ++++++++++++++++++++++++++++++++
>>>   hw/s390x/meson.build            |   1 +
>>>   hw/s390x/s390-virtio-ccw.c      |   6 +
>>>   include/hw/s390x/cpu-topology.h |  74 ++++++
>>>   target/s390x/cpu.h              |  47 ++++
>>>   5 files changed, 519 insertions(+)
>>>   create mode 100644 hw/s390x/cpu-topology.c
>>>   create mode 100644 include/hw/s390x/cpu-topology.h
>> ...
>>> +bool s390_topology_new_cpu(MachineState *ms, int core_id, Error **errp)
>>> +{
>>> +    S390TopologyBook *book;
>>> +    S390TopologySocket *socket;
>>> +    S390TopologyCores *cores;
>>> +    int nb_cores_per_socket;
>>> +    int origin, bit;
>>> +
>>> +    book = s390_get_topology();
>>> +
>>> +    nb_cores_per_socket = ms->smp.cores * ms->smp.threads;
>>> +
>>> +    socket = s390_get_socket(ms, book, core_id / nb_cores_per_socket, 
>>> errp);
>>> +    if (!socket) {
>>> +        return false;
>>> +    }
>>> +
>>> +    /*
>>> +     * At the core level, each CPU is represented by a bit in a 64bit
>>> +     * unsigned long. Set on plug and clear on unplug of a CPU.
>>> +     * The firmware assume that all CPU in the core description have the 
>>> same
>>> +     * type, polarization and are all dedicated or shared.
>>> +     * In the case a socket contains CPU with different type, polarization
>>> +     * or dedication then they will be defined in different CPU containers.
>>> +     * Currently we assume all CPU are identical and the only reason to 
>>> have
>>> +     * several S390TopologyCores inside a socket is to have more than 64 
>>> CPUs
>>> +     * in that case the origin field, representing the offset of the 
>>> first CPU
>>> +     * in the CPU container allows to represent up to the maximal number of
>>> +     * CPU inside several CPU containers inside the socket container.
>>> +     */
>>> +    origin = 64 * (core_id / 64);
>>
>> Maybe faster:
>>
>>      origin = core_id & ~63;
>>
>> By the way, where is this limitation to 64 coming from? Just because we're 
>> using a "unsigned long" for now? Or is this a limitation from the 
>> architecture?
>>
>>> +    cores = s390_get_cores(ms, socket, origin, errp);
>>> +    if (!cores) {
>>> +        return false;
>>> +    }
>>> +
>>> +    bit = 63 - (core_id - origin);
>>> +    set_bit(bit, &cores->mask);
>>> +    cores->origin = origin;
>>> +
>>> +    return true;
>>> +}
>> ...
>>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>>> index cc3097bfee..a586875b24 100644
>>> --- a/hw/s390x/s390-virtio-ccw.c
>>> +++ b/hw/s390x/s390-virtio-ccw.c
>>> @@ -43,6 +43,7 @@
>>>   #include "sysemu/sysemu.h"
>>>   #include "hw/s390x/pv.h"
>>>   #include "migration/blocker.h"
>>> +#include "hw/s390x/cpu-topology.h"
>>>   static Error *pv_mig_blocker;
>>> @@ -89,6 +90,7 @@ static void s390_init_cpus(MachineState *machine)
>>>       /* initialize possible_cpus */
>>>       mc->possible_cpu_arch_ids(machine);
>>> +    s390_topology_setup(machine);
>>
>> Is this safe with regards to migration? Did you tried a ping-pong 
>> migration from an older QEMU to a QEMU with your modifications and back to 
>> the older one? If it does not work, we might need to wire this setup to 
>> the machine types...
> 
> I checked with the follow-up series :
> OLD-> NEW -> OLD -> NEW
> 
> It is working fine, of course we need to fence the CPU topology facility 
> with ctop=off on the new QEMU to avoid authorizing the new instructions, PTF 
> and STSI(15).

When using an older machine type, the facility should be disabled by 
default, so the user does not have to know that ctop=off has to be set ... 
so I think you should only do the s390_topology_setup() by default if using 
the 7.2 machine type (or newer).

  Thomas

