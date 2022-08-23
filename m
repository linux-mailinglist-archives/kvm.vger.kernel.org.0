Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E4C59E83B
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 19:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343688AbiHWRBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 13:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245654AbiHWQ7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 12:59:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A70A4B2F
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 06:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661261415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QZDMxaEuIdQKSuQqZQtMIgaw5oE1Md/xws3HZ974gr8=;
        b=ZxZVDYSnuW1vYvEbwXR1D6XyFObT0+Nvd2fwJLd26BGEXNOenbmKjDKls6gn8js5d5TeJn
        AqXxv6dPRPbn4bHlcIcBvVL8Y+ANyP7s5AKMjBMHpsG0O6tyhxPX+9/4YwQlLSBimTLyKv
        dxYyUdIiqJ+yRAc/uT77B8QOG0XZtv8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-437-c9FJaDohNnu4Q9rlzIjsxQ-1; Tue, 23 Aug 2022 09:30:13 -0400
X-MC-Unique: c9FJaDohNnu4Q9rlzIjsxQ-1
Received: by mail-wm1-f71.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso10269558wmq.4
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 06:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=QZDMxaEuIdQKSuQqZQtMIgaw5oE1Md/xws3HZ974gr8=;
        b=PChLA7BekfHKSQUZIwdIWnPGMknU3eE3KhRPXXNopRfXl7NDY8iJDj3pUQsfEUVY9Z
         4VHqsahF+Pfz+rN6nAsevmTOYmUzVO2uXRmDbDIx4QAOY2ueAcTOZEGilpvclNkejzl/
         bdrn4gRDi3NnZWjf+dk9t3B2uoNFHWFh0yyb7k6eWkvRX3Ykf6gBwkkCto3OzVynpiNa
         0sUpdxtgfScKeXW81GFWAMxM7JX1vkgY2z6qDByu2+UoyRakCNtKaSWf6lcfdPq5b9n5
         ctoRMFQ2zH2L0WgFzJpsEtAWXE7P+pLJr7HQEzjEd/CKmn+Ax0uDF8+DClen+j49Ey7s
         3sjA==
X-Gm-Message-State: ACgBeo0iLZm/wEcZog38Y4fTzzDPJGKhNeU2IT7VNMYKLRIkU1mRCqwc
        ke/D3NHl3QCO/Oia5Uz75aDYY+JtH3d5nXOy0+YDLUNeXcVLfmSpXz2LZlasxsRN/Rd9g3c/1U7
        9tGKMXO9dw0kI
X-Received: by 2002:a5d:4a11:0:b0:225:2f5e:c704 with SMTP id m17-20020a5d4a11000000b002252f5ec704mr13245445wrq.703.1661261412712;
        Tue, 23 Aug 2022 06:30:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4VPkqgtQASFvl0VXnyU15NJEWveqermBmzG/wRBBcecNvhy3MAC1nD76g/an01GGNmmOFi7Q==
X-Received: by 2002:a5d:4a11:0:b0:225:2f5e:c704 with SMTP id m17-20020a5d4a11000000b002252f5ec704mr13245419wrq.703.1661261412440;
        Tue, 23 Aug 2022 06:30:12 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-178-217.web.vodafone.de. [109.43.178.217])
        by smtp.gmail.com with ESMTPSA id g1-20020adffc81000000b0022520aba90asm14595051wrr.107.2022.08.23.06.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 06:30:11 -0700 (PDT)
Message-ID: <b6c981e0-56f5-25c3-3422-ed72c8561712@redhat.com>
Date:   Tue, 23 Aug 2022 15:30:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
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
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v8 02/12] s390x/cpu_topology: CPU topology objects and
 structures
In-Reply-To: <20220620140352.39398-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/06/2022 16.03, Pierre Morel wrote:
> We use new objects to have a dynamic administration of the CPU topology.
> The highest level object in this implementation is the s390 book and
> in this first implementation of CPU topology for S390 we have a single
> book.
> The book is built as a SYSBUS bridge during the CPU initialization.
> Other objects, sockets and core will be built after the parsing
> of the QEMU -smp argument.
> 
> Every object under this single book will be build dynamically
> immediately after a CPU has be realized if it is needed.
> The CPU will fill the sockets once after the other, according to the
> number of core per socket defined during the smp parsing.
> 
> Each CPU inside a socket will be represented by a bit in a 64bit
> unsigned long. Set on plug and clear on unplug of a CPU.
> 
> For the S390 CPU topology, thread and cores are merged into
> topology cores and the number of topology cores is the multiplication
> of cores by the numbers of threads.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   hw/s390x/cpu-topology.c         | 391 ++++++++++++++++++++++++++++++++
>   hw/s390x/meson.build            |   1 +
>   hw/s390x/s390-virtio-ccw.c      |   6 +
>   include/hw/s390x/cpu-topology.h |  74 ++++++
>   target/s390x/cpu.h              |  47 ++++
>   5 files changed, 519 insertions(+)
>   create mode 100644 hw/s390x/cpu-topology.c
>   create mode 100644 include/hw/s390x/cpu-topology.h
...
> +bool s390_topology_new_cpu(MachineState *ms, int core_id, Error **errp)
> +{
> +    S390TopologyBook *book;
> +    S390TopologySocket *socket;
> +    S390TopologyCores *cores;
> +    int nb_cores_per_socket;
> +    int origin, bit;
> +
> +    book = s390_get_topology();
> +
> +    nb_cores_per_socket = ms->smp.cores * ms->smp.threads;
> +
> +    socket = s390_get_socket(ms, book, core_id / nb_cores_per_socket, errp);
> +    if (!socket) {
> +        return false;
> +    }
> +
> +    /*
> +     * At the core level, each CPU is represented by a bit in a 64bit
> +     * unsigned long. Set on plug and clear on unplug of a CPU.
> +     * The firmware assume that all CPU in the core description have the same
> +     * type, polarization and are all dedicated or shared.
> +     * In the case a socket contains CPU with different type, polarization
> +     * or dedication then they will be defined in different CPU containers.
> +     * Currently we assume all CPU are identical and the only reason to have
> +     * several S390TopologyCores inside a socket is to have more than 64 CPUs
> +     * in that case the origin field, representing the offset of the first CPU
> +     * in the CPU container allows to represent up to the maximal number of
> +     * CPU inside several CPU containers inside the socket container.
> +     */
> +    origin = 64 * (core_id / 64);

Maybe faster:

	origin = core_id & ~63;

By the way, where is this limitation to 64 coming from? Just because we're 
using a "unsigned long" for now? Or is this a limitation from the architecture?

> +    cores = s390_get_cores(ms, socket, origin, errp);
> +    if (!cores) {
> +        return false;
> +    }
> +
> +    bit = 63 - (core_id - origin);
> +    set_bit(bit, &cores->mask);
> +    cores->origin = origin;
> +
> +    return true;
> +}
...
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index cc3097bfee..a586875b24 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -43,6 +43,7 @@
>   #include "sysemu/sysemu.h"
>   #include "hw/s390x/pv.h"
>   #include "migration/blocker.h"
> +#include "hw/s390x/cpu-topology.h"
>   
>   static Error *pv_mig_blocker;
>   
> @@ -89,6 +90,7 @@ static void s390_init_cpus(MachineState *machine)
>       /* initialize possible_cpus */
>       mc->possible_cpu_arch_ids(machine);
>   
> +    s390_topology_setup(machine);

Is this safe with regards to migration? Did you tried a ping-pong migration 
from an older QEMU to a QEMU with your modifications and back to the older 
one? If it does not work, we might need to wire this setup to the machine 
types...

>       for (i = 0; i < machine->smp.cpus; i++) {
>           s390x_new_cpu(machine->cpu_type, i, &error_fatal);
>       }
> @@ -306,6 +308,10 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
>       g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>       ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
>   
> +    if (!s390_topology_new_cpu(ms, cpu->env.core_id, errp)) {
> +        return;
> +    }
> +
>       if (dev->hotplugged) {
>           raise_irq_cpu_hotplug();
>       }

  Thomas

