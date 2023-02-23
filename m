Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159676A08FC
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 13:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbjBWMyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 07:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbjBWMyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 07:54:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402074499
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 04:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677156796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gxRHoavd4MDmnqbIu/ZiSEYwI9vrqzu7Su5XsON/qAY=;
        b=Sbo+IF3mdjZpAs8zE/qcLvnIz0RltK5cas/arTfQOVTSEH7YCz8UhrSqwWkNNZHTxoXAcN
        56jcK3jsGqlJq2uwmZs/Jb22fT4J953AZ3zb5Ar34m1RhhkWJafGX3LrR05gjX3zYFbpQV
        B2eDlj/wSnbyTbu4FLs68PzUZ6Ldtu4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-GSscDYoGO7uBC6Sz9pxj3g-1; Thu, 23 Feb 2023 07:53:15 -0500
X-MC-Unique: GSscDYoGO7uBC6Sz9pxj3g-1
Received: by mail-wm1-f72.google.com with SMTP id z6-20020a7bc7c6000000b003e0107732f4so4987706wmk.1
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 04:53:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gxRHoavd4MDmnqbIu/ZiSEYwI9vrqzu7Su5XsON/qAY=;
        b=XQOARXOZNwIiXs0joWaLtTq3142yLW05vNVGwfD9QYo61Pkvl6bcbHLSqqbh6O2EXl
         le+kLU5wO3kIclJNlB4/biCV76yKpGF+9Tb56tJGleDJ2Usl1BDu6OKod0SHcYl/u8+z
         M1w0Y5L5w6L6hljVGhxcg7N4s/OdJd6tY97qjVg4rA1EmgplkcOgcNyzR4Q7vhFfHG9k
         g/9AWIVAbB6x2x6m1dcVa7PZp76cIoLindND92HUU2YPll03uoO0mWMETWSl0prFxo16
         O7ErmeMzrdoYXNcb0iZ5uaOZIsTAMZPSLk+qPSyU4Mxa8fs4SqsoO5PsqUOcL8c11vBC
         PnkA==
X-Gm-Message-State: AO0yUKXWDNLUcSC5dQX4vwSO2eOVYvfxKKidam/mtjyQWO8t3gPTcOhE
        nfnjGBNIiRH7bBFQd73RqMWigwR4UhBd52GWLRZIrimF1chJMdBFh1Fn6ESvPo99bYg4v7abZZN
        hy6dgIxUEs2Wj
X-Received: by 2002:a5d:6950:0:b0:2bf:cfb4:2e1 with SMTP id r16-20020a5d6950000000b002bfcfb402e1mr10823686wrw.45.1677156794180;
        Thu, 23 Feb 2023 04:53:14 -0800 (PST)
X-Google-Smtp-Source: AK7set/L9zPBxv9S/OC02opzujXuGfsuJlgG4MIe0xcMDd7fYDFMq1nf+trYQ1oVjS/UdxtdoNUF0A==
X-Received: by 2002:a5d:6950:0:b0:2bf:cfb4:2e1 with SMTP id r16-20020a5d6950000000b002bfcfb402e1mr10823662wrw.45.1677156793883;
        Thu, 23 Feb 2023 04:53:13 -0800 (PST)
Received: from [192.168.8.104] (tmo-100-40.customers.d1-online.com. [80.187.100.40])
        by smtp.gmail.com with ESMTPSA id v26-20020a5d591a000000b002c573cff730sm7162515wrd.68.2023.02.23.04.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 04:53:12 -0800 (PST)
Message-ID: <4bd16293-62e8-d7ea-dab4-9e5cb0208812@redhat.com>
Date:   Thu, 23 Feb 2023 13:53:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-3-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v16 02/11] s390x/cpu topology: add topology entries on CPU
 hotplug
In-Reply-To: <20230222142105.84700-3-pmorel@linux.ibm.com>
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

On 22/02/2023 15.20, Pierre Morel wrote:
> The topology information are attributes of the CPU and are
> specified during the CPU device creation.
...
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> index 83f31604cc..fa7f885a9f 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -10,6 +10,47 @@
>   #ifndef HW_S390X_CPU_TOPOLOGY_H
>   #define HW_S390X_CPU_TOPOLOGY_H
>   
> +#include "qemu/queue.h"
> +#include "hw/boards.h"
> +#include "qapi/qapi-types-machine-target.h"
> +
>   #define S390_TOPOLOGY_CPU_IFL   0x03
>   
> +typedef struct S390Topology {
> +    uint8_t *cores_per_socket;
> +    CpuTopology *smp;
> +    CpuS390Polarization polarization;
> +} S390Topology;
> +
> +#ifdef CONFIG_KVM
> +bool s390_has_topology(void);
> +void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp);
> +#else
> +static inline bool s390_has_topology(void)
> +{
> +       return false;
> +}
> +static inline void s390_topology_setup_cpu(MachineState *ms,
> +                                           S390CPU *cpu,
> +                                           Error **errp) {}
> +#endif
> +
> +extern S390Topology s390_topology;
> +int s390_socket_nb(S390CPU *cpu);
> +
> +static inline int s390_std_socket(int n, CpuTopology *smp)
> +{
> +    return (n / smp->cores) % smp->sockets;
> +}
> +
> +static inline int s390_std_book(int n, CpuTopology *smp)
> +{
> +    return (n / (smp->cores * smp->sockets)) % smp->books;
> +}
> +
> +static inline int s390_std_drawer(int n, CpuTopology *smp)
> +{
> +    return (n / (smp->cores * smp->sockets * smp->books)) % smp->books;

Shouldn't that be " % smp->drawers" instead?

> +}
> +
>   #endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..59f2cc15c7
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,270 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> +
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/boards.h"
> +#include "qemu/typedefs.h"
> +#include "target/s390x/cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
> +#include "hw/s390x/cpu-topology.h"
> +
> +/*
> + * s390_topology is used to keep the topology information.
> + * .cores_per_socket: tracks information on the count of cores
> + *                    per socket.
> + * .smp: keeps track of the machine topology.
> + *
> + */
> +S390Topology s390_topology = {
> +    /* will be initialized after the cpu model is realized */
> +    .cores_per_socket = NULL,
> +    .smp = NULL,
> +    .polarization = S390_CPU_POLARIZATION_HORIZONTAL,
> +};
> +
> +/**
> + * s390_socket_nb:
> + * @cpu: s390x CPU
> + *
> + * Returns the socket number used inside the cores_per_socket array
> + * for a cpu.
> + */
> +int s390_socket_nb(S390CPU *cpu)
> +{
> +    return (cpu->env.drawer_id * s390_topology.smp->books + cpu->env.book_id) *
> +           s390_topology.smp->sockets + cpu->env.socket_id;
> +}
> +
> +/**
> + * s390_has_topology:
> + *
> + * Return value: if the topology is supported by the machine.
> + */
> +bool s390_has_topology(void)
> +{
> +    return false;
> +}
> +
> +/**
> + * s390_topology_init:
> + * @ms: the machine state where the machine topology is defined
> + *
> + * Keep track of the machine topology.
> + *
> + * Allocate an array to keep the count of cores per socket.
> + * The index of the array starts at socket 0 from book 0 and
> + * drawer 0 up to the maximum allowed by the machine topology.
> + */
> +static void s390_topology_init(MachineState *ms)
> +{
> +    CpuTopology *smp = &ms->smp;
> +
> +    s390_topology.smp = smp;
> +    s390_topology.cores_per_socket = g_new0(uint8_t, smp->sockets *
> +                                            smp->books * smp->drawers);
> +}
> +
> +/**
> + * s390_topology_cpu_default:
> + * @cpu: pointer to a S390CPU
> + * @errp: Error pointer
> + *
> + * Setup the default topology if no attributes are already set.
> + * Passing a CPU with some, but not all, attributes set is considered
> + * an error.
> + *
> + * The function calculates the (drawer_id, book_id, socket_id)
> + * topology by filling the cores starting from the first socket
> + * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
> + *
> + * CPU type, entitlement and dedication have defaults values set in the
> + * s390x_cpu_properties, however entitlement is forced to 0 'none' when
> + * the polarization is horizontale.
> + */
> +static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
> +{
> +    CpuTopology *smp = s390_topology.smp;
> +    CPUS390XState *env = &cpu->env;
> +
> +    /* All geometry topology attributes must be set or all unset */
> +    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer_id < 0) &&
> +        (env->socket_id >= 0 || env->book_id >= 0 || env->drawer_id >= 0)) {
> +        error_setg(errp,
> +                   "Please define all or none of the topology geometry attributes");
> +        return;
> +    }
> +
> +    /* Check if one of the geometry topology is unset */
> +    if (env->socket_id < 0) {
> +        /* Calculate default geometry topology attributes */
> +        env->socket_id = s390_std_socket(env->core_id, smp);
> +        env->book_id = s390_std_book(env->core_id, smp);
> +        env->drawer_id = s390_std_drawer(env->core_id, smp);
> +    }
> +
> +    if (s390_topology.polarization == S390_CPU_POLARIZATION_HORIZONTAL) {
> +        env->entitlement = 0;

Should this be S390_CPU_ENTITLEMENT_HORIZONTAL instead of 0 ?

> +    }
> +}

  Thomas


