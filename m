Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C5766DFB5
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjAQN52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjAQN4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:56:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1A43D084
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:56:14 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HDgnWE019402;
        Tue, 17 Jan 2023 13:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=K2EglMWMY9Achu743Wi1HWI8smes8b+0IqAFTL8sYz4=;
 b=p+4rAdw1Z9U03VAxcEqM1K1VUTjmKUNi9I0XLT445skuZbWvSgsdpUMH91meIzn33dm9
 1ptl9NRxL00A+wMbMxDVD6osDaZJOZ55/c8GGrRPZ8+yisVtjb17MsgVQM+gYv5Mbq7a
 eU9MNbYSkbgd47jwBi2Dy2zjsCQqZSJlZ0KNOzCRKdifjpiJuFSEKgUxCXtq/NrUz7Z4
 UOfca0ZTSq1KhSclmLJD81gHNRm9SC8ZB7HLyUG5kcmg0j3VQWD6DSkj28RcCtu3Qfe8
 9hoPeRfc2ng/ePhW1mctvfkisex1nBg/vknOMLMym3wW+SJgkzoxXG1PpmQPkLGRVOmO 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5p809n25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 13:55:59 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HCWr4d014414;
        Tue, 17 Jan 2023 13:55:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5p809n1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 13:55:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30H5HJPu017351;
        Tue, 17 Jan 2023 13:55:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16kxcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 13:55:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HDtqg751577318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 13:55:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B1382004B;
        Tue, 17 Jan 2023 13:55:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1FF720040;
        Tue, 17 Jan 2023 13:55:50 +0000 (GMT)
Received: from [9.171.42.216] (unknown [9.171.42.216])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 13:55:50 +0000 (GMT)
Message-ID: <8063592a-971a-d029-e8ac-0fb6286199d5@linux.ibm.com>
Date:   Tue, 17 Jan 2023 14:55:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 02/11] s390x/cpu topology: add topology entries on CPU
 hotplug
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-3-pmorel@linux.ibm.com>
 <666b9711b23d807525be06992fffd4d782ee80c7.camel@linux.ibm.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <666b9711b23d807525be06992fffd4d782ee80c7.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f8nCsPfU5gNMBMh6kMPSMxhgij2A3FDI
X-Proofpoint-ORIG-GUID: mZLhTPvhuTr4zyWd07Zl2wbTJ-DreB5y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_05,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 clxscore=1015 spamscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170112
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/13/23 19:15, Nina Schoetterl-Glausch wrote:
> On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
>> The topology information are attributes of the CPU and are
>> specified during the CPU device creation.
>>
>> On hot plug, we gather the topology information on the core,
>> creates a list of topology entries, each entry contains a single
>> core mask of each core with identical topology and finaly we
> s/finaly/finally/

thx

>> orders the list in topological order.
> s/orders/order/

thx

>> The topological order is, from higher to lower priority:
>> - physical topology
>>      - drawer
>>      - book
>>      - socket
>>      - core origin, offset in 64bit increment from core 0.
>> - modifier attributes
>>      - CPU type
>>      - polarization entitlement
>>      - dedication
>>
>> The possibility to insert a CPU in a mask is dependent on the
>> number of cores allowed in a socket, a book or a drawer, the
>> checking is done during the hot plug of the CPU to have an
>> immediate answer.
>>
>> If the complete topology is not specified, the core is added
>> in the physical topology based on its core ID and it gets
>> defaults values for the modifier attributes.
>>
>> This way, starting QEMU without specifying the topology can
>> still get some adventage of the CPU topology.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h |  48 ++++++
>>   hw/s390x/cpu-topology.c         | 293 ++++++++++++++++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c      |  10 ++
>>   hw/s390x/meson.build            |   1 +
>>   4 files changed, 352 insertions(+)
>>   create mode 100644 hw/s390x/cpu-topology.c
>>
>> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
>> index d945b57fc3..b3fd752d8d 100644
>> --- a/include/hw/s390x/cpu-topology.h
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -10,7 +10,11 @@
>>   #ifndef HW_S390X_CPU_TOPOLOGY_H
>>   #define HW_S390X_CPU_TOPOLOGY_H
>>   
>> +#include "qemu/queue.h"
>> +#include "hw/boards.h"
>> +
>>   #define S390_TOPOLOGY_CPU_IFL   0x03
>> +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
>>   
>>   #define S390_TOPOLOGY_POLARITY_HORIZONTAL      0x00
>>   #define S390_TOPOLOGY_POLARITY_VERTICAL_LOW    0x01
>> @@ -20,4 +24,48 @@
>>   #define S390_TOPOLOGY_SHARED    0x00
>>   #define S390_TOPOLOGY_DEDICATED 0x01
>>   
>> +typedef union s390_topology_id {
>> +    uint64_t id;
>> +    struct {
>> +        uint64_t level_6:8; /* byte 0 BE */
>> +        uint64_t level_5:8; /* byte 1 BE */
>> +        uint64_t drawer:8;  /* byte 2 BE */
>> +        uint64_t book:8;    /* byte 3 BE */
>> +        uint64_t socket:8;  /* byte 4 BE */
>> +        uint64_t rsrv:5;
>> +        uint64_t d:1;
>> +        uint64_t p:2;       /* byte 5 BE */
>> +        uint64_t type:8;    /* byte 6 BE */
>> +        uint64_t origin:2;
> 
> This is two bits because it's the core divided by 64, and we have 248 cores at most?
> Where is this set?

right, must be set so does the core offset in the mask.

> 
>> +        uint64_t core:6;    /* byte 7 BE */
>> +    };
>> +} s390_topology_id;
> 
> This struct seems to do double duty, 1. it represents a cpu and 2. a topology entry.
> You also use it for sorting.
> I would suggest to just use a cpu object when referring to a specific cpu and
> put the relevant fields directly into the topology entry.

Yes, I can remove the core:6.
After Thomas comment I will change all the bit field for uint8_t.
I think we should not use the real topology entry here if we want to use 
TGE in the future.

> You get rid of the bit field that way.
> You'd then need a comparison function for a cpu object and a topology entry.
> As long as that isn't the only type pair that shouldn't be too ugly.
> 
>> +#define TOPO_CPU_MASK       0x000000000000003fUL
>> +
>> +typedef struct S390TopologyEntry {
>> +    s390_topology_id id;
>> +    QTAILQ_ENTRY(S390TopologyEntry) next;
>> +    uint64_t mask;
>> +} S390TopologyEntry;
>> +
>> +typedef struct S390Topology {
>> +    QTAILQ_HEAD(, S390TopologyEntry) list;
>> +    uint8_t *sockets;
>> +    CpuTopology *smp;
>> +} S390Topology;
>> +
>> +#ifdef CONFIG_KVM
>> +bool s390_has_topology(void);
>> +void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp);
>> +#else
>> +static inline bool s390_has_topology(void)
>> +{
>> +       return false;
>> +}
>> +static inline void s390_topology_set_cpu(MachineState *ms,
>> +                                         S390CPU *cpu,
>> +                                         Error **errp) {}
>> +#endif
>> +extern S390Topology s390_topology;
>> +
>>   #endif
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> new file mode 100644
>> index 0000000000..438055c612
>> --- /dev/null
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -0,0 +1,293 @@
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
>> +
>> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qapi/error.h"
>> +#include "qemu/error-report.h"
>> +#include "hw/qdev-properties.h"
>> +#include "hw/boards.h"
>> +#include "qemu/typedefs.h"
>> +#include "target/s390x/cpu.h"
>> +#include "hw/s390x/s390-virtio-ccw.h"
>> +#include "hw/s390x/cpu-topology.h"
>> +
>> +/*
>> + * s390_topology is used to keep the topology information.
>> + * .list: queue the topology entries inside which
>> + *        we keep the information on the CPU topology.
>> + *
>> + * .smp: keeps track of the machine topology.
>> + *
>> + * .socket: tracks information on the count of cores per socket.
>> + *
>> + */
>> +S390Topology s390_topology = {
>> +    .list = QTAILQ_HEAD_INITIALIZER(s390_topology.list),
>> +    .sockets = NULL, /* will be initialized after the cpu model is realized */
> 
> I guess you should do the same for .smp then also.

OK

> 
>> +};
>> +
>> +/**
>> + * s390_socket_nb:
>> + * @id: s390_topology_id
>> + *
>> + * Returns the socket number used inside the socket array.
>> + */
>> +static int s390_socket_nb(s390_topology_id id)
>> +{
>> +    return (id.socket + 1) * (id.book + 1) * (id.drawer + 1);
> 
> This calculation doesn't make a whole lot of sense to me.
> It's symmetric with regards to the variables, so (s=0 b=1 d=1)
> will have the same result as (s=1 b=0 d=1).
> You want the "global" socket number right?
> So that would be (drawer * books_per_drawer + book) * sockets_per_book + socket.

yes, already changed

> 
>> +}
>> +
>> +/**
>> + * s390_has_topology:
>> + *
>> + * Return value: if the topology is supported by the machine.
>> + */
>> +bool s390_has_topology(void)
>> +{
>> +    return false;
>> +}
>> +
>> +/**
>> + * s390_topology_init:
>> + * @ms: the machine state where the machine topology is defined
>> + *
>> + * Keep track of the machine topology.
>> + * Allocate an array to keep the count of cores per socket.
>> + * The index of the array starts at socket 0 from book 0 and
>> + * drawer 0 up to the maximum allowed by the machine topology.
>> + */
>> +static void s390_topology_init(MachineState *ms)
>> +{
>> +    CpuTopology *smp = &ms->smp;
>> +
>> +    s390_topology.smp = smp;
>> +    if (!s390_topology.sockets) {
> 
> Is this function being called multiple times, or why the if?
> Use an assert instead?

I forgot to remove this test.
The caller already check this.

> 
>> +        s390_topology.sockets = g_new0(uint8_t, smp->sockets *
>> +                                       smp->books * smp->drawers);
>> +    }
>> +}
>> +
>> +/**
>> + * s390_topology_from_cpu:
>> + * @cpu: The S390CPU
>> + *
>> + * Initialize the topology id from the CPU environment.
>> + */
>> +static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
>> +{
>> +    s390_topology_id topology_id;
>> +
>> +    topology_id.core = cpu->env.core_id;
>> +    topology_id.type = cpu->env.cpu_type;
>> +    topology_id.p = cpu->env.polarity;
>> +    topology_id.d = cpu->env.dedicated;
>> +    topology_id.socket = cpu->env.socket_id;
>> +    topology_id.book = cpu->env.book_id;
>> +    topology_id.drawer = cpu->env.drawer_id;
>> +
>> +    return topology_id;
>> +}
>> +
>> +/**
>> + * s390_topology_set_entry:
>> + * @entry: Topology entry to setup
>> + * @id: topology id to use for the setup
>> + *
>> + * Set the core bit inside the topology mask and
>> + * increments the number of cores for the socket.
>> + */
>> +static void s390_topology_set_entry(S390TopologyEntry *entry,
> 
> Not sure if I like the name, what it does is to add a cpu to the entry.

s390_topology_add_cpu_to_entry() ?



> 
>> +                                    s390_topology_id id)
>> +{
>> +    set_bit(63 - id.core, &entry->mask);
> 
> You need to subtract the origin first or that might be negative.

yes, origin is not handled correctly

> 
>> +    s390_topology.sockets[s390_socket_nb(id)]++;
>> +}
>> +
>> +/**
>> + * s390_topology_new_entry:
>> + * @id: s390_topology_id to add
>> + *
>> + * Allocate a new entry and initialize it.
>> + *
>> + * returns the newly allocated entry.
>> + */
>> +static S390TopologyEntry *s390_topology_new_entry(s390_topology_id id)
>> +{
>> +    S390TopologyEntry *entry;
>> +
>> +    entry = g_malloc0(sizeof(S390TopologyEntry));
>> +    entry->id.id = id.id & ~TOPO_CPU_MASK;
>> +    s390_topology_set_entry(entry, id);
>> +
>> +    return entry;
>> +}
>> +
>> +/**
>> + * s390_topology_insert:
>> + *
>> + * @id: s390_topology_id to insert.
>> + *
>> + * Parse the topology list to find if the entry already
>> + * exist and add the core in it.
>> + * If it does not exist, allocate a new entry and insert
>> + * it in the queue from lower id to greater id.
>> + */
>> +static void s390_topology_insert(s390_topology_id id)
>> +{
>> +    S390TopologyEntry *entry;
>> +    S390TopologyEntry *tmp = NULL;
>> +    uint64_t new_id;
>> +
>> +    new_id = id.id & ~TOPO_CPU_MASK;
>> +
>> +    /* First CPU to add to an entry */
>> +    if (QTAILQ_EMPTY(&s390_topology.list)) {
>> +        entry = s390_topology_new_entry(id);
>> +        QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>> +        return;
>> +    }
>> +
>> +    QTAILQ_FOREACH(tmp, &s390_topology.list, next) {
>> +        if (new_id == tmp->id.id) {
>> +            s390_topology_set_entry(tmp, id);
>> +            return;
>> +        } else if (new_id < tmp->id.id) {
>> +            entry = s390_topology_new_entry(id);
>> +            QTAILQ_INSERT_BEFORE(tmp, entry, next);
>> +            return;
>> +        }
>> +    }
>> +
>> +    entry = s390_topology_new_entry(id);
>> +    QTAILQ_INSERT_TAIL(&s390_topology.list, entry, next);
> 
> Consider adding a sentinel entry "at infinity", then that whole code
> would simplify.

looks good, thanks.


> 
>> +}
>> +
>> +/**
>> + * s390_topology_check:
>> + * @errp: Error pointer
>> + * id: s390_topology_id to be verified
>> + *
>> + * The function checks if the topology id fits inside the
>> + * system topology.
>> + */
>> +static void s390_topology_check(Error **errp, s390_topology_id id)
>> +{
>> +    CpuTopology *smp = s390_topology.smp;
>> +
>> +    if (id.socket > smp->sockets) {
>> +            error_setg(errp, "Unavailable socket: %d", id.socket);
>> +            return;
>> +    }
>> +    if (id.book > smp->books) {
>> +            error_setg(errp, "Unavailable book: %d", id.book);
>> +            return;
>> +    }
>> +    if (id.drawer > smp->drawers) {
>> +            error_setg(errp, "Unavailable drawer: %d", id.drawer);
>> +            return;
>> +    }
>> +    if (id.type != S390_TOPOLOGY_CPU_IFL) {
>> +            error_setg(errp, "Unknown cpu type: %d", id.type);
>> +            return;
>> +    }
>> +    /* Polarity and dedication can never be wrong */
>> +}
>> +
>> +/**
>> + * s390_topology_cpu_default:
>> + * @errp: Error pointer
>> + * @cpu: pointer to a S390CPU
>> + *
>> + * Setup the default topology for unset attributes.
>> + *
>> + * The function accept only all all default values or all set values
>> + * for the geometry topology.
>> + *
>> + * The function calculates the (drawer_id, book_id, socket_id)
>> + * topology by filling the cores starting from the first socket
>> + * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
>> + *
>> + */
>> +static void s390_topology_cpu_default(Error **errp, S390CPU *cpu)
>> +{
>> +    CpuTopology *smp = s390_topology.smp;
>> +    CPUS390XState *env = &cpu->env;
>> +
>> +    /* All geometry topology attributes must be set or all unset */
>> +    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer_id < 0) &&
>> +        (env->socket_id >= 0 || env->book_id >= 0 || env->drawer_id >= 0)) {
>> +        error_setg(errp,
>> +                   "Please define all or none of the topology geometry attributes");
>> +        return;
>> +    }
>> +
>> +    /* Check if one of the geometry topology is unset */
>> +    if (env->socket_id < 0) {
>> +        /* Calculate default geometry topology attributes */
>> +        env->socket_id = (env->core_id / smp->cores) % smp->sockets;
>> +        env->book_id = (env->core_id / (smp->sockets * smp->cores)) %
>> +                       smp->books;
>> +        env->drawer_id = (env->core_id /
>> +                          (smp->books * smp->sockets * smp->cores)) %
>> +                         smp->drawers;
>> +    }
>> +}
>> +
>> +/**
>> + * s390_topology_set_cpu:
>> + * @ms: MachineState used to initialize the topology structure on
>> + *      first call.
>> + * @cpu: the new S390CPU to insert in the topology structure
>> + * @errp: the error pointer
>> + *
>> + * Called from CPU Hotplug to check and setup the CPU attributes
>> + * before to insert the CPU in the topology.
>> + */
>> +void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
>> +{
>> +    Error *local_error = NULL;
> 
> Can't you just use ERRP_GUARD ?

I do not think it is necessary and I find it obfuscating.
So, should I?

> 
>> +    s390_topology_id id;
>> +
>> +    /*
>> +     * We do not want to initialize the topology if the cpu model
>> +     * does not support topology consequently, we have to wait for
> 
> ", consequently," I think. Could you do the initialization some where else,
> after you know what the cpu model is? Not that I object to doing it this way.
> 

I did not find a better place, it must be done after the CPU model is 
initialize and before the first CPU is created.
The cpu model is initialized during the early creation of the first cpu.

Any idea?

Thanks.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
