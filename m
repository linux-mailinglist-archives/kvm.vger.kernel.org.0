Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D68747016
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 13:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjGDLlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 07:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjGDLk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 07:40:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129E9103
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 04:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688470809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oi6fVChjqae5v2x+1gleSkBXpAtNet65KNmyndopOAY=;
        b=VyRpScN/903BU/CYWlLofuE7nwc22Xk1r4MzlvXREeFMrFio2Ybg2q5LMLstsp+CN429Ph
        7nO6sgqqxwl95hYbGXxNh3L9sG7EUd4rZByjzvplO9XH+LdXwxs5JQNoJi5KbcjRMXVZUg
        9XmWGiHiq65IFHfNGtWgD9ZySOjTeig=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-h5V-BghPOSKyOTgarAXyEw-1; Tue, 04 Jul 2023 07:40:08 -0400
X-MC-Unique: h5V-BghPOSKyOTgarAXyEw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-76594ad37fcso568228185a.2
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 04:40:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688470807; x=1691062807;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oi6fVChjqae5v2x+1gleSkBXpAtNet65KNmyndopOAY=;
        b=C6zww+3EAdtx+uL20CdDrpjgmP2yPgG+POmoV1c1pjIyz2HfE3hY8OJcgxw0g1aU0E
         yCqoanhkWwu6VzZI4i6PMra7C98Df1X6hy6lPOpEgbU4sCHVMzdCn7jwWD0V713AEhzr
         cCTdh0sjl16dw+MK5UlShKi9AJ/FoTtpmMvzc2lGe3eoLqrSKrVlkwanOTWIlsABhQMv
         wvmyTIPTU2+/2DlYtGZohDX8Yk3BnxR6kwyDHPaHXBV0Dt9pBp9j8Soswl4Q+rdhBczO
         romuW3DstdyJDNUq035U38x6fT2ey1NY/smqCZDHS97zMQYWya3RQSEFlYEpittZqDHg
         dPjg==
X-Gm-Message-State: AC+VfDxv4MQ17YtxC5bCgh5yLxWqYH0rzxDHLCtRFSjN7k2L77rFTjzq
        4V48p7pQkMBhRJPcW4jhQ9f/cR9/cpD6dasB6RUOHLOgd+zCyctMtpmoWSDLSmVQ+Ls3yjSvxMH
        IVqF4EbxGTiG9
X-Received: by 2002:a05:620a:284d:b0:75b:23a1:8336 with SMTP id h13-20020a05620a284d00b0075b23a18336mr14626831qkp.49.1688470807341;
        Tue, 04 Jul 2023 04:40:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ57/KZK051cWfKBlielsxVcW9v/ThO2sEG2UQ+GVFRGHpOjBox0dzhwCZvweXhfNF82MbRaPw==
X-Received: by 2002:a05:620a:284d:b0:75b:23a1:8336 with SMTP id h13-20020a05620a284d00b0075b23a18336mr14626806qkp.49.1688470806973;
        Tue, 04 Jul 2023 04:40:06 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-126.web.vodafone.de. [109.43.179.126])
        by smtp.gmail.com with ESMTPSA id p3-20020a05620a15e300b007654bb4a842sm4787728qkm.104.2023.07.04.04.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 04:40:06 -0700 (PDT)
Message-ID: <aef8accb-3576-2b10-a946-191a6be3e3e0@redhat.com>
Date:   Tue, 4 Jul 2023 13:40:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        frankja@linux.ibm.com, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-4-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v21 03/20] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
In-Reply-To: <20230630091752.67190-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
> On interception of STSI(15.1.x) the System Information Block
> (SYSIB) is built from the list of pre-ordered topology entries.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index 7ebd5e05b6..6e7d041b01 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -569,6 +569,29 @@ typedef struct SysIB_322 {
>   } SysIB_322;
>   QEMU_BUILD_BUG_ON(sizeof(SysIB_322) != 4096);
>   
> +/*
> + * Topology Magnitude fields (MAG) indicates the maximum number of
> + * topology list entries (TLE) at the corresponding nesting level.
> + */
> +#define S390_TOPOLOGY_MAG  6
> +#define S390_TOPOLOGY_MAG6 0
> +#define S390_TOPOLOGY_MAG5 1
> +#define S390_TOPOLOGY_MAG4 2
> +#define S390_TOPOLOGY_MAG3 3
> +#define S390_TOPOLOGY_MAG2 4
> +#define S390_TOPOLOGY_MAG1 5
> +/* Configuration topology */
> +typedef struct SysIB_151x {
> +    uint8_t  reserved0[2];
> +    uint16_t length;
> +    uint8_t  mag[S390_TOPOLOGY_MAG];
> +    uint8_t  reserved1;
> +    uint8_t  mnest;
> +    uint32_t reserved2;
> +    char tle[];
> +} SysIB_151x;
> +QEMU_BUILD_BUG_ON(sizeof(SysIB_151x) != 16);
> +
>   typedef union SysIB {
>       SysIB_111 sysib_111;
>       SysIB_121 sysib_121;
> @@ -576,9 +599,62 @@ typedef union SysIB {
>       SysIB_221 sysib_221;
>       SysIB_222 sysib_222;
>       SysIB_322 sysib_322;
> +    SysIB_151x sysib_151x;
>   } SysIB;
>   QEMU_BUILD_BUG_ON(sizeof(SysIB) != 4096);
>   
> +/*
> + * CPU Topology List provided by STSI with fc=15 provides a list
> + * of two different Topology List Entries (TLE) types to specify
> + * the topology hierarchy.
> + *
> + * - Container Topology List Entry
> + *   Defines a container to contain other Topology List Entries
> + *   of any type, nested containers or CPU.
> + * - CPU Topology List Entry
> + *   Specifies the CPUs position, type, entitlement and polarization
> + *   of the CPUs contained in the last Container TLE.
> + *
> + * There can be theoretically up to five levels of containers, QEMU
> + * uses only three levels, the drawer's, book's and socket's level.
> + *
> + * A container with a nesting level (NL) greater than 1 can only
> + * contain another container of nesting level NL-1.
> + *
> + * A container of nesting level 1 (socket), contains as many CPU TLE
> + * as needed to describe the position and qualities of all CPUs inside
> + * the container.
> + * The qualities of a CPU are polarization, entitlement and type.
> + *
> + * The CPU TLE defines the position of the CPUs of identical qualities
> + * using a 64bits mask which first bit has its offset defined by
> + * the CPU address orgin field of the CPU TLE like in:
> + * CPU address = origin * 64 + bit position within the mask
> + *
> + */
> +/* Container type Topology List Entry */
> +typedef struct SysIBTl_container {
> +        uint8_t nl;
> +        uint8_t reserved[6];
> +        uint8_t id;
> +} SysIBTl_container;

Why mixing CamelCase with underscore-style here? SysIBTlContainer would look 
more natural, I think?

> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
> +
> +/* CPU type Topology List Entry */
> +typedef struct SysIBTl_cpu {
> +        uint8_t nl;
> +        uint8_t reserved0[3];
> +#define SYSIB_TLE_POLARITY_MASK 0x03
> +#define SYSIB_TLE_DEDICATED     0x04
> +        uint8_t flags;
> +        uint8_t type;
> +        uint16_t origin;
> +        uint64_t mask;
> +} SysIBTl_cpu;

dito, maybe better SysIBTlCpu ?

> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) != 16);
> +
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, uint64_t addr, uint8_t ar);
> +
>   /* MMU defines */
>   #define ASCE_ORIGIN           (~0xfffULL) /* segment table origin             */
>   #define ASCE_SUBSPACE         0x200       /* subspace group control           */
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index b163c17f8f..ca1634d0ce 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -29,11 +29,13 @@
>    * .cores_per_socket: tracks information on the count of cores
>    *                    per socket.
>    * .smp: keeps track of the machine topology.
> - *
> + * .list: queue the topology entries inside which
> + *        we keep the information on the CPU topology.

The comment does not match the code below.

>    */
>   S390Topology s390_topology = {
>       /* will be initialized after the cpu model is realized */
>       .cores_per_socket = NULL,
> +    .polarization = S390_CPU_POLARIZATION_HORIZONTAL,
>   };
>   
>   /**
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index 3ac7ec9acf..5ea358cbb0 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -1919,9 +1919,12 @@ static int handle_stsi(S390CPU *cpu)
>           if (run->s390_stsi.sel1 != 2 || run->s390_stsi.sel2 != 2) {
>               return 0;
>           }
> -        /* Only sysib 3.2.2 needs post-handling for now. */
>           insert_stsi_3_2_2(cpu, run->s390_stsi.addr, run->s390_stsi.ar);
>           return 0;
> +    case 15:
> +        insert_stsi_15_1_x(cpu, run->s390_stsi.sel2, run->s390_stsi.addr,
> +                           run->s390_stsi.ar);
> +        return 0;
>       default:
>           return 0;
>       }
> diff --git a/target/s390x/kvm/stsi-topology.c b/target/s390x/kvm/stsi-topology.c
> new file mode 100644
> index 0000000000..0b789450da
> --- /dev/null
> +++ b/target/s390x/kvm/stsi-topology.c
> @@ -0,0 +1,310 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * QEMU S390x CPU Topology
> + *
> + * Copyright IBM Corp. 2022,2023
> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + *
> + */
> +#include "qemu/osdep.h"
> +#include "cpu.h"
> +#include "hw/s390x/pv.h"
> +#include "hw/sysbus.h"
> +#include "hw/s390x/sclp.h"
> +#include "hw/s390x/cpu-topology.h"
> +
> +/**
> + * fill_container:
> + * @p: The address of the container TLE to fill
> + * @level: The level of nesting for this container
> + * @id: The container receives a unique ID inside its own container
> + *
> + * Returns the next free TLE entry.
> + */
> +static char *fill_container(char *p, int level, int id)
> +{
> +    SysIBTl_container *tle = (SysIBTl_container *)p;
> +
> +    tle->nl = level;
> +    tle->id = id;
> +    return p + sizeof(*tle);
> +}
> +
> +/**
> + * fill_tle_cpu:
> + * @p: The address of the CPU TLE to fill
> + * @entry: a pointer to the S390TopologyEntry defining this
> + *         CPU container.
> + *
> + * Returns the next free TLE entry.
> + */
> +static char *fill_tle_cpu(char *p, S390TopologyEntry *entry)
> +{
> +    SysIBTl_cpu *tle = (SysIBTl_cpu *)p;
> +    s390_topology_id topology_id = entry->id;
> +
> +    tle->nl = 0;
> +    if (topology_id.dedicated) {
> +        tle->flags = SYSIB_TLE_DEDICATED;
> +    }
> +    tle->flags |= topology_id.entitlement;

If it was not dedicated, the "|=" might operate with a random value here. 
Better pre-initialize flags with 0, or change the order of the operations here:

     tle->flags = topology_id.entitlement;
     if (topology_id.dedicated) {
         tle->flags |= SYSIB_TLE_DEDICATED;
     }

> +    tle->type = topology_id.type;
> +    tle->origin = cpu_to_be16(topology_id.origin * 64);
> +    tle->mask = cpu_to_be64(entry->mask);
> +    return p + sizeof(*tle);
> +}
> +
> +/*
> + * Macro to check that the size of data after increment
> + * will not get bigger than the size of the SysIB.
> + */
> +#define SYSIB_GUARD(data, x) do {       \
> +        data += x;                      \
> +        if (data > sizeof(SysIB)) {    \
> +            return 0;                   \
> +        }                               \
> +    } while (0)
> +
> +/**
> + * stsi_topology_fill_sysib:
> + * @p: A pointer to the position of the first TLE
> + * @level: The nested level wanted by the guest
> + *
> + * Fill the SYSIB with the topology information as described in
> + * the PoP, nesting containers as appropriate, with the maximum
> + * nesting limited by @level.
> + *
> + * Return value:
> + * On success: the size of the SysIB_15x after being filled with TLE.
> + * On error: 0 in the case we would overrun the end of the SysIB.
> + */
> +static int stsi_topology_fill_sysib(S390TopologyList *topology_list,
> +                                    char *p, int level)
> +{
> +    S390TopologyEntry *entry;
> +    int last_drawer = -1;
> +    int last_book = -1;
> +    int last_socket = -1;
> +    int drawer_id = 0;
> +    int book_id = 0;
> +    int socket_id = 0;
> +    int n = sizeof(SysIB_151x);
> +
> +    QTAILQ_FOREACH(entry, topology_list, next) {
> +        bool drawer_change = last_drawer != entry->id.drawer;
> +        bool book_change = drawer_change || last_book != entry->id.book;
> +        bool socket_change = book_change || last_socket != entry->id.socket;
> +
> +        /* If we reach the sentinel get out */
> +        if (entry->id.sentinel) {
> +            break;
> +        }
> +
> +        if (level > 3 && drawer_change) {
> +            SYSIB_GUARD(n, sizeof(SysIBTl_container));
> +            p = fill_container(p, 3, drawer_id++);
> +            book_id = 0;
> +        }
> +        if (level > 2 && book_change) {
> +            SYSIB_GUARD(n, sizeof(SysIBTl_container));
> +            p = fill_container(p, 2, book_id++);
> +            socket_id = 0;
> +        }
> +        if (socket_change) {
> +            SYSIB_GUARD(n, sizeof(SysIBTl_container));
> +            p = fill_container(p, 1, socket_id++);
> +        }
> +
> +        SYSIB_GUARD(n, sizeof(SysIBTl_cpu));
> +        p = fill_tle_cpu(p, entry);
> +        last_drawer = entry->id.drawer;
> +        last_book = entry->id.book;
> +        last_socket = entry->id.socket;
> +    }
> +
> +    return n;
> +}
> +
> +/**
> + * setup_stsi:
> + * sysib: pointer to a SysIB to be filled with SysIB_151x data
> + * level: Nested level specified by the guest
> + *
> + * Setup the SYSIB for STSI 15.1, the header as well as the description
> + * of the topology.
> + */
> +static int setup_stsi(S390TopologyList *topology_list, SysIB_151x *sysib,
> +                      int level)
> +{
> +    sysib->mnest = level;
> +    switch (level) {
> +    case 4:
> +        sysib->mag[S390_TOPOLOGY_MAG4] = current_machine->smp.drawers;
> +        sysib->mag[S390_TOPOLOGY_MAG3] = current_machine->smp.books;
> +        sysib->mag[S390_TOPOLOGY_MAG2] = current_machine->smp.sockets;
> +        sysib->mag[S390_TOPOLOGY_MAG1] = current_machine->smp.cores;
> +        break;
> +    case 3:
> +        sysib->mag[S390_TOPOLOGY_MAG3] = current_machine->smp.drawers *
> +                                         current_machine->smp.books;
> +        sysib->mag[S390_TOPOLOGY_MAG2] = current_machine->smp.sockets;
> +        sysib->mag[S390_TOPOLOGY_MAG1] = current_machine->smp.cores;
> +        break;
> +    case 2:
> +        sysib->mag[S390_TOPOLOGY_MAG2] = current_machine->smp.drawers *
> +                                         current_machine->smp.books *
> +                                         current_machine->smp.sockets;
> +        sysib->mag[S390_TOPOLOGY_MAG1] = current_machine->smp.cores;
> +        break;
> +    }
> +
> +    return stsi_topology_fill_sysib(topology_list, sysib->tle, level);
> +}
> +
> +/**
> + * s390_topology_add_cpu_to_entry:
> + * @entry: Topology entry to setup
> + * @cpu: the S390CPU to add
> + *
> + * Set the core bit inside the topology mask and
> + * increments the number of cores for the socket.

The second part of the sentence does not seem to be done here anymore?

> + */
> +static void s390_topology_add_cpu_to_entry(S390TopologyEntry *entry,
> +                                           S390CPU *cpu)
> +{
> +    set_bit(63 - (cpu->env.core_id % 64), &entry->mask);
> +}
> +
> +/**
> + * s390_topology_from_cpu:
> + * @cpu: The S390CPU
> + *
> + * Initialize the topology id from the CPU environment.
> + */
> +static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
> +{
> +    s390_topology_id topology_id = {0};
> +
> +    topology_id.drawer = cpu->env.drawer_id;
> +    topology_id.book = cpu->env.book_id;
> +    topology_id.socket = cpu->env.socket_id;
> +    topology_id.origin = cpu->env.core_id / 64;
> +    topology_id.type = S390_TOPOLOGY_CPU_IFL;
> +    topology_id.dedicated = cpu->env.dedicated;
> +
> +    if (s390_topology.polarization == S390_CPU_POLARIZATION_VERTICAL) {
> +        topology_id.entitlement = cpu->env.entitlement;
> +    }
> +
> +    return topology_id;
> +}
> +
> +/**
> + * s390_topology_insert:
> + * @cpu: s390CPU insert.

"s390CPU insert" sounds like a weird description for @cpu

> + *
> + * Parse the topology list to find if the entry already
> + * exist and add the core in it.
> + * If it does not exist, allocate a new entry and insert
> + * it in the queue from lower id to greater id.
> + */
> +static void s390_topology_insert(S390TopologyList *topology_list, S390CPU *cpu)
> +{
> +    s390_topology_id id = s390_topology_from_cpu(cpu);
> +    S390TopologyEntry *entry = NULL;
> +    S390TopologyEntry *tmp = NULL;
> +
> +    QTAILQ_FOREACH(tmp, topology_list, next) {
> +        if (id.id == tmp->id.id) {
> +            s390_topology_add_cpu_to_entry(tmp, cpu);
> +            return;
> +        } else if (id.id < tmp->id.id) {
> +            entry = g_malloc0(sizeof(S390TopologyEntry));
> +            entry->id.id = id.id;
> +            s390_topology_add_cpu_to_entry(entry, cpu);
> +            QTAILQ_INSERT_BEFORE(tmp, entry, next);
> +            return;
> +        }
> +    }
> +}
> +
> +/**
> + * s390_topology_fill_list_sorted:
> + *
> + * Loop over all CPU and insert it at the right place
> + * inside the TLE entry list.
> + * Fill the S390Topology list with entries according to the order
> + * specified by the PoP.
> + */
> +static void s390_topology_fill_list_sorted(S390TopologyList *topology_list)
> +{
> +    CPUState *cs;
> +
> +    CPU_FOREACH(cs) {
> +        s390_topology_insert(topology_list, S390_CPU(cs));
> +    }
> +}
> +
> +/**
> + * s390_topology_empty_list:
> + *
> + * Clear all entries in the S390Topology list except the sentinel.
> + */
> +static void s390_topology_empty_list(S390TopologyList *topology_list)
> +{
> +    S390TopologyEntry *entry = NULL;
> +    S390TopologyEntry *tmp = NULL;
> +
> +    QTAILQ_FOREACH_SAFE(entry, topology_list, next, tmp) {
> +        QTAILQ_REMOVE(topology_list, entry, next);
> +        g_free(entry);
> +    }
> +}
> +
> +/**
> + * insert_stsi_15_1_x:
> + * cpu: the CPU doing the call for which we set CC
> + * sel2: the selector 2, containing the nested level
> + * addr: Guest logical address of the guest SysIB
> + * ar: the access register number
> + *
> + * Create a list head for the Topology entries and initialize it.

s/Topology/topology/

> + * Insert the first entry as a sentinelle.

s/sentinelle/sentinel/

> + * Emulate STSI 15.1.x, that is, perform all necessary checks and
> + * fill the SYSIB.
> + * In case the topology description is too long to fit into the SYSIB,
> + * set CC=3 and abort without writing the SYSIB.
> + */
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, uint64_t addr, uint8_t ar)
> +{
> +    S390TopologyList topology_list;
> +    S390TopologyEntry *entry;
> +    SysIB sysib = {0};
> +    int length;
> +
> +    if (!s390_has_topology() || sel2 < 2 || sel2 > SCLP_READ_SCP_INFO_MNEST) {
> +        setcc(cpu, 3);
> +        return;
> +    }
> +
> +    QTAILQ_INIT(&topology_list);
> +    entry = g_malloc0(sizeof(S390TopologyEntry));
> +    entry->id.sentinel = 0xff;
> +    QTAILQ_INSERT_HEAD(&topology_list, entry, next);
> +
> +    s390_topology_fill_list_sorted(&topology_list);
> +
> +    length = setup_stsi(&topology_list, &sysib.sysib_151x, sel2);
> +
> +    if (!length) {
> +        setcc(cpu, 3);
> +        return;
> +    }
> +
> +    sysib.sysib_151x.length = cpu_to_be16(length);
> +    s390_cpu_virt_mem_write(cpu, addr, ar, &sysib, length);
> +    setcc(cpu, 0);

s390_cpu_virt_mem_write() could fail, I think in that case you should not 
change the CC value here?

Also, what about protected virtualization? Do you have to use 
s390_cpu_pv_mem_write() in case PV is enabled?

> +
> +    s390_topology_empty_list(&topology_list);
> +}
> diff --git a/target/s390x/kvm/meson.build b/target/s390x/kvm/meson.build
> index 37253f75bf..bcf014ba87 100644
> --- a/target/s390x/kvm/meson.build
> +++ b/target/s390x/kvm/meson.build
> @@ -1,6 +1,7 @@
>   
>   s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
> -  'kvm.c'
> +  'kvm.c',
> +  'stsi-topology.c'
>   ), if_false: files(
>     'stubs.c'
>   ))

  Thomas

