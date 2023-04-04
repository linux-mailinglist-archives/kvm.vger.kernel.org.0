Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862966D604C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 14:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbjDDM0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 08:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbjDDM0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 08:26:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E831730CF
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 05:26:20 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334COssU016373;
        Tue, 4 Apr 2023 12:26:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lhpLjR6BXG1mgdq8uWZsC1HdWY+0psylr0Xyk6SqHJA=;
 b=m67y04VWvJ12KAJWrDKaTQrKeaYQNfhAzVjugBjFqfvj8qVW/6kouyPREeRRHOy1UNh8
 WOWtX/4ht76atCi4YEL9e1I2J4+P26+a6yTBx+nSBgFtF6ypLtyo4fTeZ5rKQkNqyDAJ
 pjMPFzX0mGy0f1tUSlOeBWcDI+v4jiwzVYXfXRxEnz9d2A8ALC62da5OnfpJ+Y2fp324
 S2lxO97WbKVhrLjZOXeoo+uoL8zD0MVfLcoqQqx4FgcWPZE0Dr9Ka8LsLLfbbHdr1CQ8
 /SMfC8Ahpq9BNyClV+wnXjlzTbvxiS0UipVZpm29Oi7Xm95s93DLrVpE+sl8ZC1mAAUE AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhqd3jpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 12:26:13 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334BrEnS012104;
        Tue, 4 Apr 2023 12:26:13 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhqd3jnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 12:26:12 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3342i6PF004214;
        Tue, 4 Apr 2023 12:26:11 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3ppc86svwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 12:26:10 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334CQ7S718743948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 12:26:07 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52DDB2004B;
        Tue,  4 Apr 2023 12:26:07 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37EB420040;
        Tue,  4 Apr 2023 12:26:06 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  4 Apr 2023 12:26:06 +0000 (GMT)
Message-ID: <bd5cc488-20a7-54d1-7c3e-86136db77f84@linux.ibm.com>
Date:   Tue, 4 Apr 2023 14:26:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-2-pmorel@linux.ibm.com>
 <4118bb4e-0505-26d3-3ffe-49245eae5364@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <4118bb4e-0505-26d3-3ffe-49245eae5364@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zo_miAIhagiWzHZGSEIXp87iItCyCD7f
X-Proofpoint-GUID: kucrRBm9vTmrSgMl0s0qJO-rCdWs2zsm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040112
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/23 09:03, Cédric Le Goater wrote:
> On 4/3/23 18:28, Pierre Morel wrote:
>> S390 adds two new SMP levels, drawers and books to the CPU
>> topology.
>> The S390 CPU have specific topology features like dedication
>> and entitlement to give to the guest indications on the host
>> vCPUs scheduling and help the guest take the best decisions
>> on the scheduling of threads on the vCPUs.
>>
>> Let us provide the SMP properties with books and drawers levels
>> and S390 CPU with dedication and entitlement,
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
> Some minor comments below,
>
>> ---
>>   MAINTAINERS                     |  5 ++++
>>   qapi/machine-common.json        | 22 ++++++++++++++
>>   qapi/machine-target.json        | 12 ++++++++
>>   qapi/machine.json               | 17 +++++++++--
>>   include/hw/boards.h             | 10 ++++++-
>>   include/hw/s390x/cpu-topology.h | 15 ++++++++++
>>   target/s390x/cpu.h              |  5 ++++
>>   hw/core/machine-smp.c           | 53 ++++++++++++++++++++++++++++-----
>>   hw/core/machine.c               |  4 +++
>>   hw/s390x/s390-virtio-ccw.c      |  2 ++
>>   softmmu/vl.c                    |  6 ++++
>>   target/s390x/cpu.c              |  7 +++++
>>   qapi/meson.build                |  1 +
>>   qemu-options.hx                 |  7 +++--
>>   14 files changed, 152 insertions(+), 14 deletions(-)
>>   create mode 100644 qapi/machine-common.json
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 5340de0515..9b1f80739e 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1654,6 +1654,11 @@ F: hw/s390x/event-facility.c
>>   F: hw/s390x/sclp*.c
>>   L: qemu-s390x@nongnu.org
>>   +S390 CPU topology
>> +M: Pierre Morel <pmorel@linux.ibm.com>
>> +S: Supported
>> +F: include/hw/s390x/cpu-topology.h
>> +
>>   X86 Machines
>>   ------------
>>   PC
>> diff --git a/qapi/machine-common.json b/qapi/machine-common.json
>> new file mode 100644
>> index 0000000000..73ea38d976
>> --- /dev/null
>> +++ b/qapi/machine-common.json
>> @@ -0,0 +1,22 @@
>> +# -*- Mode: Python -*-
>> +# vim: filetype=python
>> +#
>> +# This work is licensed under the terms of the GNU GPL, version 2 or 
>> later.
>> +# See the COPYING file in the top-level directory.
>> +
>> +##
>> +# = Machines S390 data types
>> +##
>> +
>> +##
>> +# @CpuS390Entitlement:
>> +#
>> +# An enumeration of cpu entitlements that can be assumed by a virtual
>> +# S390 CPU
>> +#
>> +# Since: 8.1
>> +##
>> +{ 'enum': 'CpuS390Entitlement',
>> +  'prefix': 'S390_CPU_ENTITLEMENT',
>> +  'data': [ 'horizontal', 'low', 'medium', 'high' ] }
>> +
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index 2e267fa458..42a6a40333 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -342,3 +342,15 @@
>>                      'TARGET_S390X',
>>                      'TARGET_MIPS',
>>                      'TARGET_LOONGARCH64' ] } }
>> +
>> +##
>> +# @CpuS390Polarization:
>> +#
>> +# An enumeration of cpu polarization that can be assumed by a virtual
>> +# S390 CPU
>> +#
>> +# Since: 8.1
>> +##
>> +{ 'enum': 'CpuS390Polarization',
>> +  'prefix': 'S390_CPU_POLARIZATION',
>> +  'data': [ 'horizontal', 'vertical' ] }
>> diff --git a/qapi/machine.json b/qapi/machine.json
>> index 604b686e59..1cdd83f3fd 100644
>> --- a/qapi/machine.json
>> +++ b/qapi/machine.json
>> @@ -9,6 +9,7 @@
>>   ##
>>     { 'include': 'common.json' }
>> +{ 'include': 'machine-common.json' }
>>     ##
>>   # @SysEmuTarget:
>> @@ -70,7 +71,7 @@
>>   #
>>   # @thread-id: ID of the underlying host thread
>>   #
>> -# @props: properties describing to which node/socket/core/thread
>> +# @props: properties describing to which 
>> node/drawer/book/socket/core/thread
>>   #         virtual CPU belongs to, provided if supported by board
>>   #
>>   # @target: the QEMU system emulation target, which determines which
>> @@ -902,13 +903,15 @@
>>   # a CPU is being hotplugged.
>>   #
>>   # @node-id: NUMA node ID the CPU belongs to
>> -# @socket-id: socket number within node/board the CPU belongs to
>> +# @drawer-id: drawer number within node/board the CPU belongs to 
>> (since 8.1)
>> +# @book-id: book number within drawer/node/board the CPU belongs to 
>> (since 8.1)
>> +# @socket-id: socket number within book/node/board the CPU belongs to
>>   # @die-id: die number within socket the CPU belongs to (since 4.1)
>>   # @cluster-id: cluster number within die the CPU belongs to (since 
>> 7.1)
>>   # @core-id: core number within cluster the CPU belongs to
>>   # @thread-id: thread number within core the CPU belongs to
>>   #
>> -# Note: currently there are 6 properties that could be present
>> +# Note: currently there are 8 properties that could be present
>>   #       but management should be prepared to pass through other
>>   #       properties with device_add command to allow for future
>>   #       interface extension. This also requires the filed names to 
>> be kept in
>> @@ -918,6 +921,8 @@
>>   ##
>>   { 'struct': 'CpuInstanceProperties',
>>     'data': { '*node-id': 'int',
>> +            '*drawer-id': 'int',
>> +            '*book-id': 'int',
>>               '*socket-id': 'int',
>>               '*die-id': 'int',
>>               '*cluster-id': 'int',
>> @@ -1467,6 +1472,10 @@
>>   #
>>   # @cpus: number of virtual CPUs in the virtual machine
>>   #
>> +# @drawers: number of drawers in the CPU topology (since 8.1)
>> +#
>> +# @books: number of books in the CPU topology (since 8.1)
>> +#
>>   # @sockets: number of sockets in the CPU topology
>>   #
>>   # @dies: number of dies per socket in the CPU topology
>> @@ -1483,6 +1492,8 @@
>>   ##
>>   { 'struct': 'SMPConfiguration', 'data': {
>>        '*cpus': 'int',
>> +     '*drawers': 'int',
>> +     '*books': 'int',
>>        '*sockets': 'int',
>>        '*dies': 'int',
>>        '*clusters': 'int',
>> diff --git a/include/hw/boards.h b/include/hw/boards.h
>> index 6fbbfd56c8..9ef0bb76cf 100644
>> --- a/include/hw/boards.h
>> +++ b/include/hw/boards.h
>> @@ -131,12 +131,16 @@ typedef struct {
>>    * @clusters_supported - whether clusters are supported by the machine
>>    * @has_clusters - whether clusters are explicitly specified in the 
>> user
>>    *                 provided SMP configuration
>> + * @books_supported - whether books are supported by the machine
>> + * @drawers_supported - whether drawers are supported by the machine
>>    */
>>   typedef struct {
>>       bool prefer_sockets;
>>       bool dies_supported;
>>       bool clusters_supported;
>>       bool has_clusters;
>> +    bool books_supported;
>> +    bool drawers_supported;
>>   } SMPCompatProps;
>>     /**
>> @@ -301,7 +305,9 @@ typedef struct DeviceMemoryState {
>>   /**
>>    * CpuTopology:
>>    * @cpus: the number of present logical processors on the machine
>> - * @sockets: the number of sockets on the machine
>> + * @drawers: the number of drawers on the machine
>> + * @books: the number of books in one drawer
>> + * @sockets: the number of sockets in one book
>>    * @dies: the number of dies in one socket
>>    * @clusters: the number of clusters in one die
>>    * @cores: the number of cores in one cluster
>> @@ -310,6 +316,8 @@ typedef struct DeviceMemoryState {
>>    */
>>   typedef struct CpuTopology {
>>       unsigned int cpus;
>> +    unsigned int drawers;
>> +    unsigned int books;
>>       unsigned int sockets;
>>       unsigned int dies;
>>       unsigned int clusters;
>> diff --git a/include/hw/s390x/cpu-topology.h 
>> b/include/hw/s390x/cpu-topology.h
>> new file mode 100644
>> index 0000000000..83f31604cc
>> --- /dev/null
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -0,0 +1,15 @@
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
>
> Shouldn't we have some range : 2022-2023 ?

There was a discussion on this in the first spins, I think to remember 
that Nina wanted 22 and Thomas 23,

now we have a third opinion :) .

I must say that all three have their reasons and I take what the 
majority wants.

A vote?


>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 
>> or (at
>> + * your option) any later version. See the COPYING file in the 
>> top-level
>> + * directory.
>> + */
>
> QEMU uses a SPDX tag like the kernel now :
>
> /* SPDX-License-Identifier: GPL-2.0-or-later */


OK, so I will add it on all .c and .h new files


>
>> +#ifndef HW_S390X_CPU_TOPOLOGY_H
>> +#define HW_S390X_CPU_TOPOLOGY_H
>> +
>> +#define S390_TOPOLOGY_CPU_IFL   0x03
>
> This definition is only used in patch 3. May be introduce it then,
> it would cleaner.


yes.


>
>> +
>> +#endif
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index 7d6d01325b..f2b2a38fe7 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>> @@ -131,6 +131,11 @@ struct CPUArchState {
>>     #if !defined(CONFIG_USER_ONLY)
>>       uint32_t core_id; /* PoP "CPU address", same as cpu_index */
>> +    int32_t socket_id;
>> +    int32_t book_id;
>> +    int32_t drawer_id;
>> +    bool dedicated;
>> +    uint8_t entitlement;        /* Used only for vertical 
>> polarization */
>>       uint64_t cpuid;
>>   #endif
>>   diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
>> index c3dab007da..6f5622a024 100644
>> --- a/hw/core/machine-smp.c
>> +++ b/hw/core/machine-smp.c
>> @@ -30,8 +30,19 @@ static char *cpu_hierarchy_to_string(MachineState 
>> *ms)
>>   {
>>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>>       GString *s = g_string_new(NULL);
>> +    const char *multiply = " * ", *prefix = "";
>>   -    g_string_append_printf(s, "sockets (%u)", ms->smp.sockets);
>> +    if (mc->smp_props.drawers_supported) {
>> +        g_string_append_printf(s, "drawers (%u)", ms->smp.drawers);
>> +    prefix = multiply;
>
> indent issue.

right, seems I forgot to update the patch set after the checkpatch.


>
>> +    }
>> +
>> +    if (mc->smp_props.books_supported) {
>> +        g_string_append_printf(s, "%sbooks (%u)", prefix, 
>> ms->smp.books);
>> +    prefix = multiply;
>
> ditto.
>
>> +    }
>> +

[...]

Thanks

Regards,

Pierre

