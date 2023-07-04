Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C1B746EC2
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 12:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjGDKdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 06:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjGDKc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 06:32:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D20A137
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 03:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688466734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2l0qlPws7gg83P1+QCgcrNRMwEpM6U8h1zURy0OM0og=;
        b=YWR82CWaMem+TpgspIREaA/qM7z6nv+6nEsVmGFyC/XIfCqoJ+H76aNudsOazi+gHtgRDq
        8PFPSUaHhmD/clNtVJZzTzS9VCXdFHdiXzTXPwxlrYhlCVKgLHERqZ20uqT9eJUKHlKM3L
        yfQ4i+x9qxzl0KefE8VSAjxbYk8PgO0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-PgY46QeyMuCvpZ8D_U8R9g-1; Tue, 04 Jul 2023 06:32:13 -0400
X-MC-Unique: PgY46QeyMuCvpZ8D_U8R9g-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7659d103147so627876085a.3
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 03:32:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688466733; x=1691058733;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2l0qlPws7gg83P1+QCgcrNRMwEpM6U8h1zURy0OM0og=;
        b=cc8HdITHScbU7cnD4b6IquKOs8HjaVg+FK2sY/857rpgAsQnawxjVu47eAK5VQSDy1
         YHGsvrR63T2LNDTx8dha9Vcdp2LkLwf3OpdlXD+Ozhw+6TPhQ1wNI+MSkId9e3mlVgtb
         TIlThzXCixRpPVJkFBaEjFQLJPHtyZd7GwEpVYE7nO4jz2JTRfE26PuQnc7aWO0jfRvC
         I95TYxDS3g1cOQsIM8QM+nHcz6F0FAIg1BA9uQk0Qv4UYojnz4jqczVydFWs6ZIYOxBX
         Dk8PglgcdBYOplA3oneB0WzPud3RH0+Sh+etgE2Ign4hLyOFcFLAjALR3IPgILcjPB8N
         LiTA==
X-Gm-Message-State: ABy/qLYeHZMXVj+nbmiBv0mVxR1I7kRs+RvKcafevHPb3aAHHT7++uN/
        qsQTy8NvhW5iyxMx34KRy55MHzR2kcGnm6ZRNYI4E6fP+p7h+IkGNuJTiwal559QxwnK7PXh0rS
        JFLGqXXLrWMhT
X-Received: by 2002:a05:620a:4611:b0:767:494f:4ab5 with SMTP id br17-20020a05620a461100b00767494f4ab5mr13842688qkb.39.1688466733199;
        Tue, 04 Jul 2023 03:32:13 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGd0lPmlaBsk9KtMvCrye5XU1GwODMt8mZEeO7IrAKMtzO6KQm0C7i4wu11X2vRrubkWxQCxA==
X-Received: by 2002:a05:620a:4611:b0:767:494f:4ab5 with SMTP id br17-20020a05620a461100b00767494f4ab5mr13842658qkb.39.1688466732864;
        Tue, 04 Jul 2023 03:32:12 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-126.web.vodafone.de. [109.43.179.126])
        by smtp.gmail.com with ESMTPSA id e3-20020a05620a12c300b007671cfe8a18sm6950610qkl.13.2023.07.04.03.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 03:32:12 -0700 (PDT)
Message-ID: <71bd9791-cdfe-3930-fdd3-64b27b180c6d@redhat.com>
Date:   Tue, 4 Jul 2023 12:32:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-3-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v21 02/20] s390x/cpu topology: add topology entries on CPU
 hotplug
In-Reply-To: <20230630091752.67190-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
> The topology information are attributes of the CPU and are
> specified during the CPU device creation.
> 
> On hot plug we:
> - calculate the default values for the topology for drawers,
>    books and sockets in the case they are not specified.
> - verify the CPU attributes
> - check that we have still room on the desired socket
> 
> The possibility to insert a CPU in a mask is dependent on the
> number of cores allowed in a socket, a book or a drawer, the
> checking is done during the hot plug of the CPU to have an
> immediate answer.
> 
> If the complete topology is not specified, the core is added
> in the physical topology based on its core ID and it gets
> defaults values for the modifier attributes.
> 
> This way, starting QEMU without specifying the topology can
> still get some advantage of the CPU topology.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> new file mode 100644
> index 0000000000..9164ac00a7
> --- /dev/null
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -0,0 +1,54 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022,2023

Nit: Add a space after the comma ?

> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
> + */
> +#ifndef HW_S390X_CPU_TOPOLOGY_H
> +#define HW_S390X_CPU_TOPOLOGY_H
> +
> +#ifndef CONFIG_USER_ONLY
> +
> +#include "qemu/queue.h"
> +#include "hw/boards.h"
> +#include "qapi/qapi-types-machine-target.h"
> +
> +typedef struct S390Topology {
> +    uint8_t *cores_per_socket;
> +} S390Topology;

So S390Topology has only one entry, "cores_per_socket" here...

...
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..b163c17f8f
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,264 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022,2023
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * S390 topology handling can be divided in two parts:
> + *
> + * - The first part in this file is taking care of all common functions
> + *   used by KVM and TCG to create and modify the topology.
> + *
> + * - The second part, building the topology information data for the
> + *   guest with CPU and KVM specificity will be implemented inside
> + *   the target/s390/kvm sub tree.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/boards.h"
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

... but the description talks about ".smp" here, too, which never seems to 
be added. Leftover from a previous iteration?
(also: please remove the empty line at the end of the comment)

> + */
> +S390Topology s390_topology = {
> +    /* will be initialized after the cpu model is realized */
> +    .cores_per_socket = NULL,
> +};
> +
> +/**
> + * s390_socket_nb:
> + * @cpu: s390x CPU
> + *
> + * Returns the socket number used inside the cores_per_socket array
> + * for a topology tree entry
> + */
> +static int __s390_socket_nb(int drawer_id, int book_id, int socket_id)

Please don't use function names starting with double underscores. This 
namespace is reserved by the C standard.
Maybe "s390_socket_nb_from_ids" ?

> +{
> +    return (drawer_id * current_machine->smp.books + book_id) *
> +           current_machine->smp.sockets + socket_id;
> +}
> +
> +/**
> + * s390_socket_nb:
> + * @cpu: s390x CPU
> + *
> + * Returns the socket number used inside the cores_per_socket array
> + * for a cpu.
> + */
> +static int s390_socket_nb(S390CPU *cpu)
> +{
> +    return __s390_socket_nb(cpu->env.drawer_id, cpu->env.book_id,
> +                            cpu->env.socket_id);
> +}
> +
> +/**
> + * s390_has_topology:
> + *
> + * Return value: if the topology is supported by the machine.

"Return: true if the topology is supported by the machine"

(QEMU uses kerneldoc style, so it's just "Return:" and not "Return value:", 
see e.g. https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html )

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
> + * CPU type and dedication have defaults values set in the
> + * s390x_cpu_properties, entitlement must be adjust depending on the
> + * dedication.
> + *
> + * Returns false if it is impossible to setup a default topology
> + * true otherwise.
> + */
> +static bool s390_topology_cpu_default(S390CPU *cpu, Error **errp)
> +{
> +    CpuTopology *smp = &current_machine->smp;
> +    CPUS390XState *env = &cpu->env;
> +
> +    /* All geometry topology attributes must be set or all unset */
> +    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer_id < 0) &&
> +        (env->socket_id >= 0 || env->book_id >= 0 || env->drawer_id >= 0)) {
> +        error_setg(errp,
> +                   "Please define all or none of the topology geometry attributes");
> +        return false;
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
> +    /*
> +     * When the user specifies the entitlement as 'auto' on the command line,
> +     * qemu will set the entitlement as:

s/qemu/QEMU/

> +     * Medium when the CPU is not dedicated.
> +     * High when dedicated is true.
> +     */
> +    if (env->entitlement == S390_CPU_ENTITLEMENT_AUTO) {
> +        if (env->dedicated) {
> +            env->entitlement = S390_CPU_ENTITLEMENT_HIGH;
> +        } else {
> +            env->entitlement = S390_CPU_ENTITLEMENT_MEDIUM;
> +        }
> +    }
> +    return true;
> +}
> +
> +/**
> + * s390_topology_check:
> + * @socket_id: socket to check
> + * @book_id: book to check
> + * @drawer_id: drawer to check
> + * @entitlement: entitlement to check
> + * @dedicated: dedication to check
> + * @errp: Error pointer
> + *
> + * The function checks if the topology
> + * attributes fits inside the system topology.
> + *
> + * Returns false if the specified topology does not match with
> + * the machine topology.
> + */
> +static bool s390_topology_check(uint16_t socket_id, uint16_t book_id,
> +                                uint16_t drawer_id, uint16_t entitlement,
> +                                bool dedicated, Error **errp)
> +{
> +    CpuTopology *smp = &current_machine->smp;
> +    ERRP_GUARD();
> +
> +    if (socket_id >= smp->sockets) {
> +        error_setg(errp, "Unavailable socket: %d", socket_id);
> +        return false;
> +    }
> +    if (book_id >= smp->books) {
> +        error_setg(errp, "Unavailable book: %d", book_id);
> +        return false;
> +    }
> +    if (drawer_id >= smp->drawers) {
> +        error_setg(errp, "Unavailable drawer: %d", drawer_id);
> +        return false;
> +    }
> +    if (entitlement >= S390_CPU_ENTITLEMENT__MAX) {
> +        error_setg(errp, "Unknown entitlement: %d", entitlement);
> +        return false;
> +    }
> +    if (dedicated && (entitlement == S390_CPU_ENTITLEMENT_LOW ||
> +                      entitlement == S390_CPU_ENTITLEMENT_MEDIUM)) {
> +        error_setg(errp, "A dedicated cpu implies high entitlement");

s/cpu/CPU/ ?

> +        return false;
> +    }
> +    return true;
> +}
> +
> +/**
> + * s390_update_cpu_props:
> + * @ms: the machine state
> + * @cpu: the CPU for which to update the properties from the environment.
> + *
> + */
> +static void s390_update_cpu_props(MachineState *ms, S390CPU *cpu)
> +{
> +    CpuInstanceProperties *props;
> +
> +    props = &ms->possible_cpus->cpus[cpu->env.core_id].props;
> +
> +    props->socket_id = cpu->env.socket_id;
> +    props->book_id = cpu->env.book_id;
> +    props->drawer_id = cpu->env.drawer_id;
> +}
> +
> +/**
> + * s390_topology_setup_cpu:
> + * @ms: MachineState used to initialize the topology structure on
> + *      first call.
> + * @cpu: the new S390CPU to insert in the topology structure
> + * @errp: the error pointer
> + *
> + * Called from CPU hotplug to check and setup the CPU attributes
> + * before the CPU is inserted in the topology.
> + * There is no need to update the MTCR explicitly here because it
> + * will be updated by KVM on creation of the new CPU.
> + */
> +void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
> +{
> +    ERRP_GUARD();
> +    int entry;
> +
> +    /*
> +     * We do not want to initialize the topology if the cpu model

s/cpu/CPU/

> +     * does not support topology, consequently, we have to wait for
> +     * the first CPU to be realized, which realizes the CPU model
> +     * to initialize the topology structures.
> +     *
> +     * s390_topology_setup_cpu() is called from the cpu hotplug.
> +     */
> +    if (!s390_topology.cores_per_socket) {
> +        s390_topology_init(ms);
> +    }
> +
> +    if (!s390_topology_cpu_default(cpu, errp)) {
> +        return;
> +    }
> +
> +    if (!s390_topology_check(cpu->env.socket_id, cpu->env.book_id,
> +                             cpu->env.drawer_id, cpu->env.entitlement,
> +                             cpu->env.dedicated, errp)) {
> +        return;
> +    }
> +
> +    /* Do we still have space in the socket */
> +    entry = s390_socket_nb(cpu);
> +    if (s390_topology.cores_per_socket[entry] >= current_machine->smp.cores) {
> +        error_setg(errp, "No more space on this socket");
> +        return;
> +    }
> +
> +    /* Update the count of cores in sockets */
> +    s390_topology.cores_per_socket[entry] += 1;
> +
> +    /* topology tree is reflected in props */
> +    s390_update_cpu_props(ms, cpu);
> +}

  Thomas


