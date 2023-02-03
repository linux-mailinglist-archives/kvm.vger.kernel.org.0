Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A945468938A
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 10:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjBCJXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 04:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbjBCJWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 04:22:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7591A233FF
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 01:21:41 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3139Foc3006214;
        Fri, 3 Feb 2023 09:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/SpxLm0icDfmPLEieqsygGvAPco70jvF6k7/DAn+KIg=;
 b=kjEYOyjJqlfloDkeYb7TdZpK9k6qkehAleyoR+IwdlIYu95LnRSiNKarAD4Y0VXH7P/H
 guHgVLc1xta/dwBXF7klHdzoWPr07PFMAMeEYI0qpd/QiIztYTVRL5EfoyAYhQjgDHoQ
 scjFNxLFy7uuUwiqQ2jM8kSJK7FUGAsTAB4uzJWfinzJoX36Z5NE4fe1Ntjpl/uL/eYy
 NhJENAOfZj0RsM0J/VU6SjND4GYQ5bV2Ac+HLmjyHtgiMJRnUXyev3nOGdgwkNnuoD9D
 SK05kMeVwJ5F3PS5s4N5N2Sw+gHm9BDgqle1mXBuB8xtGq7J6SJSEMgPWy6pbqXrphNJ YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngyg0r3qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 09:21:25 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3139GWNm008012;
        Fri, 3 Feb 2023 09:21:25 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngyg0r3q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 09:21:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31375BGM026900;
        Fri, 3 Feb 2023 09:21:22 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ncvs7q8a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 09:21:22 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3139LIJn50659720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 09:21:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A7B920043;
        Fri,  3 Feb 2023 09:21:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D13F20040;
        Fri,  3 Feb 2023 09:21:17 +0000 (GMT)
Received: from [9.171.57.15] (unknown [9.171.57.15])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Feb 2023 09:21:17 +0000 (GMT)
Message-ID: <c2c502ca-2a1f-d29f-8931-4be7389557ee@linux.ibm.com>
Date:   Fri, 3 Feb 2023 10:21:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 02/11] s390x/cpu topology: add topology entries on CPU
 hotplug
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-3-pmorel@linux.ibm.com>
 <6345131acfb04e353ca2eba620bf27609bfeb535.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <6345131acfb04e353ca2eba620bf27609bfeb535.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gT1ws5a4b0szb2nSfhrn69wxYpiJeQea
X-Proofpoint-ORIG-GUID: p2vxv7Iow6SwbtI7ZQcu-x94hzHne4ET
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_05,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/2/23 17:42, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
>> The topology information are attributes of the CPU and are
>> specified during the CPU device creation.
>>
>> On hot plug we:
>> - calculate the default values for the topology for drawers,
>>    books and sockets in the case they are not specified.
>> - verify the CPU attributes
>> - check that we have still room on the desired socket
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
>> still get some advantage of the CPU topology.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h |  24 +++
>>   hw/s390x/cpu-topology.c         | 256 ++++++++++++++++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c      |  23 ++-
>>   hw/s390x/meson.build            |   1 +
>>   4 files changed, 302 insertions(+), 2 deletions(-)
>>   create mode 100644 hw/s390x/cpu-topology.c
>>
> [...]
>>
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> new file mode 100644
>> index 0000000000..12df4eca6c
>> --- /dev/null
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -0,0 +1,256 @@
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
> 
> .list doesn't exist yet.

right, I move it to the corresponding patch.

> 
>> + * .socket: tracks information on the count of cores per socket.
>> + * .smp: keeps track of the machine topology.
>> + *
>> + */
>> +S390Topology s390_topology = {
>> +    /* will be initialized after the cpu model is realized */
>> +    .cores_per_socket = NULL,
>> +    .smp = NULL,
>> +};
>>
> [...]
>> +
>> +/**
>> + * s390_topology_cpu_default:
>> + * @cpu: pointer to a S390CPU
>> + * @errp: Error pointer
>> + *
>> + * Setup the default topology for unset attributes.
> 
> My suggestion:
> Setup the default topology if no attributes are already set.
> Passing a CPU with some, but not all, attributes set is considered an error.

Thanks, I take your suggestion.

> 
>> + *
>> + * The function accept only all all default values or all set values
>> + * for the geometry topology.
> 
> acceptS, all all
> If you take my suggestion, you can just drop this sentence.
> 
>> + *
>> + * The function calculates the (drawer_id, book_id, socket_id)
>> + * topology by filling the cores starting from the first socket
>> + * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
>> + *
>> + * CPU type, polarity and dedication have defaults values set in the
>> + * s390x_cpu_properties.
>> + */
>> +static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
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
>>
> [...]
>> +
>> +/**
>> + * s390_set_core_in_socket:
>> + * @cpu: the new S390CPU to insert in the topology structure
>> + * @drawer_id: new drawer_id
>> + * @book_id: new book_id
>> + * @socket_id: new socket_id
>> + * @creation: if is true the CPU is a new CPU and there is no old socket
>> + *            to handle.
>> + *            if is false, this is a moving the CPU and old socket count
>> + *            must be decremented.
>> + * @errp: the error pointer
>> + *
>> + */
>> +static void s390_set_core_in_socket(S390CPU *cpu, int drawer_id, int book_id,
> 
> Maybe name it s390_(topology_)?add_core_to_socket instead.

OK, it is better

> 
>> +                                    int socket_id, bool creation, Error **errp)
>> +{
>> +    int old_socket = s390_socket_nb(cpu);
>> +    int new_socket;
>> +
>> +    if (creation) {
>> +        new_socket = old_socket;
>> +    } else {
> 
> You need parentheses here.
> 
>> +        new_socket = drawer_id * s390_topology.smp->books +
>                         (
>> +                     book_id * s390_topology.smp->sockets +
>                                 )
>> +                     socket_id;

If you prefer I can us parentheses.


>> +    }
>> +
>> +    /* Check for space on new socket */
>> +    if ((new_socket != old_socket) &&
>> +        (s390_topology.cores_per_socket[new_socket] >=
>> +         s390_topology.smp->cores)) {
>> +        error_setg(errp, "No more space on this socket");
>> +        return;
>> +    }
>> +
>> +    /* Update the count of cores in sockets */
>> +    s390_topology.cores_per_socket[new_socket] += 1;
>> +    if (!creation) {
>> +        s390_topology.cores_per_socket[old_socket] -= 1;
>> +    }
>> +}
>>
> [...]
> 
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
> 
> The name is rather non informative.
> s390_topology_setup_cpu ?

OK

> 
>> +{
>> +    ERRP_GUARD();
>> +
>> +    /*
>> +     * We do not want to initialize the topology if the cpu model
>> +     * does not support topology consequently, we have to wait for
>                                     ^
> Still think there should be a comma here.

OK

> 
>> +     * the first CPU to be realized, which realizes the CPU model
>> +     * to initialize the topology structures.
>> +     *
>> +     * s390_topology_set_cpu() is called from the cpu hotplug.
>> +     */
>> +    if (!s390_topology.cores_per_socket) {
>> +        s390_topology_init(ms);
>> +    }
>> +
>> +    s390_topology_check(cpu, errp);
>> +    if (*errp) {
>> +        return;
>> +    }
>> +
>> +    /* Set the CPU inside the socket */
>> +    s390_set_core_in_socket(cpu, 0, 0, 0, true, errp);
>> +    if (*errp) {
>> +        return;
>> +    }
>> +
>> +    /* topology tree is reflected in props */
>> +    s390_update_cpu_props(ms, cpu);
>> +}
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index f3cc845d3b..9bc51a83f4 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -44,6 +44,7 @@
>>   #include "hw/s390x/pv.h"
>>   #include "migration/blocker.h"
>>   #include "qapi/visitor.h"
>> +#include "hw/s390x/cpu-topology.h"
>>   
>>   static Error *pv_mig_blocker;
>>   
>> @@ -310,10 +311,18 @@ static void s390_cpu_plug(HotplugHandler *hotplug_dev,
>>   {
>>       MachineState *ms = MACHINE(hotplug_dev);
>>       S390CPU *cpu = S390_CPU(dev);
>> +    ERRP_GUARD();
>>   
>>       g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>>       ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
>>   
>> +    if (s390_has_topology()) {
>> +        s390_topology_set_cpu(ms, cpu, errp);
>> +        if (*errp) {
>> +            return;
>> +        }
>> +    }
>> +
>>       if (dev->hotplugged) {
>>           raise_irq_cpu_hotplug();
>>       }
>> @@ -551,11 +560,21 @@ static const CPUArchIdList *s390_possible_cpu_arch_ids(MachineState *ms)
>>                                     sizeof(CPUArchId) * max_cpus);
>>       ms->possible_cpus->len = max_cpus;
>>       for (i = 0; i < ms->possible_cpus->len; i++) {
>> +        CpuInstanceProperties *props = &ms->possible_cpus->cpus[i].props;
>> +
>>           ms->possible_cpus->cpus[i].type = ms->cpu_type;
>>           ms->possible_cpus->cpus[i].vcpus_count = 1;
>>           ms->possible_cpus->cpus[i].arch_id = i;
>> -        ms->possible_cpus->cpus[i].props.has_core_id = true;
>> -        ms->possible_cpus->cpus[i].props.core_id = i;
>> +
>> +        props->has_core_id = true;
>> +        props->core_id = i;
>> +        props->has_socket_id = true;
>> +        props->socket_id = i / ms->smp.cores;
>> +        props->has_book_id = true;
>> +        props->book_id = i / (ms->smp.cores * ms->smp.sockets);
>> +        props->has_drawer_id = true;
>> +        props->drawer_id = i /
>> +                           (ms->smp.cores * ms->smp.sockets * ms->smp.books);
> 
> You need to calculate the modulus like in s390_topology_cpu_default, right?

!!! yes of course, good catch, I forgot that.

Since there are two uses of this calculation, what about using inlines?
like:

static inline int s390_std_socket(int n, CpuTopology *smp)
{
     return (n / smp->cores) % smp->sockets;
}

static inline int s390_std_book(int n, CpuTopology *smp)
{
     return (n / (smp->cores * smp->sockets)) % smp->books;
}

static inline int s390_std_drawer(int n, CpuTopology *smp)
{
     return (n / (smp->cores * smp->sockets * smp->books)) % smp->books;
}


Thanks for the comments.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
