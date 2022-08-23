Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB52259EAC2
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 20:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiHWSQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 14:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiHWSPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 14:15:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509CE5A3F0
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:30:45 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NGK9K4029405;
        Tue, 23 Aug 2022 16:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qXljrg6/IFBhzTuxVsk4Ecjx+sf0yAItsDw2fiI4Zqs=;
 b=MX1E21kgpXWXr5D1ttb2vaJj2HNg++Vy4JAsZUxFZyP4e1Qq7ePulsrZwWE9DbvxahUZ
 PJZtXVGBFf0k5ecL2VpzBliU5RzT+9wpDQmM/Wjjb4VZlSuqOUnKlLPye4cZPBm3Q/gC
 BoctB+SY8NgiGtw+u61TSt4unfgJi9ajuL4mWE3+xiwQ62+9tyTYFpKyQfrAICJV1dmp
 3mSvWnrSey4BOVW8Di9jF8fPhl7UHOXuinZkqlu8yG3bxzn6GLinRUUbp2PSXa346ECA
 k/nrIjTmwob8z5Ue/0lu2Fdt7Rf3drIH89vA+rrYeEtY1xXTBnwhLdRdwP+iu1/9vxNn oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5159k9jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 16:30:39 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NF0X35029392;
        Tue, 23 Aug 2022 16:30:38 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5159k9gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 16:30:38 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NG73Fb024966;
        Tue, 23 Aug 2022 16:30:36 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3j2q88v2gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 16:30:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NGUWKx35258676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 16:30:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3283A405C;
        Tue, 23 Aug 2022 16:30:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0495A405B;
        Tue, 23 Aug 2022 16:30:31 +0000 (GMT)
Received: from [9.171.74.130] (unknown [9.171.74.130])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 16:30:31 +0000 (GMT)
Message-ID: <c4b9bae1-3a49-abcc-d914-538567d09ef5@linux.ibm.com>
Date:   Tue, 23 Aug 2022 18:30:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 02/12] s390x/cpu_topology: CPU topology objects and
 structures
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-3-pmorel@linux.ibm.com>
 <b6c981e0-56f5-25c3-3422-ed72c8561712@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b6c981e0-56f5-25c3-3422-ed72c8561712@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jJ2G0bqOSaQI5C5cSDgK_geuwxyn3d8Z
X-Proofpoint-ORIG-GUID: y_o3xKfolGCAKHnbGZgf5DNIucwhDyV0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/23/22 15:30, Thomas Huth wrote:
> On 20/06/2022 16.03, Pierre Morel wrote:
>> We use new objects to have a dynamic administration of the CPU topology.
>> The highest level object in this implementation is the s390 book and
>> in this first implementation of CPU topology for S390 we have a single
>> book.
>> The book is built as a SYSBUS bridge during the CPU initialization.
>> Other objects, sockets and core will be built after the parsing
>> of the QEMU -smp argument.
>>
>> Every object under this single book will be build dynamically
>> immediately after a CPU has be realized if it is needed.
>> The CPU will fill the sockets once after the other, according to the
>> number of core per socket defined during the smp parsing.
>>
>> Each CPU inside a socket will be represented by a bit in a 64bit
>> unsigned long. Set on plug and clear on unplug of a CPU.
>>
>> For the S390 CPU topology, thread and cores are merged into
>> topology cores and the number of topology cores is the multiplication
>> of cores by the numbers of threads.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/s390x/cpu-topology.c         | 391 ++++++++++++++++++++++++++++++++
>>   hw/s390x/meson.build            |   1 +
>>   hw/s390x/s390-virtio-ccw.c      |   6 +
>>   include/hw/s390x/cpu-topology.h |  74 ++++++
>>   target/s390x/cpu.h              |  47 ++++
>>   5 files changed, 519 insertions(+)
>>   create mode 100644 hw/s390x/cpu-topology.c
>>   create mode 100644 include/hw/s390x/cpu-topology.h
> ...
>> +bool s390_topology_new_cpu(MachineState *ms, int core_id, Error **errp)
>> +{
>> +    S390TopologyBook *book;
>> +    S390TopologySocket *socket;
>> +    S390TopologyCores *cores;
>> +    int nb_cores_per_socket;
>> +    int origin, bit;
>> +
>> +    book = s390_get_topology();
>> +
>> +    nb_cores_per_socket = ms->smp.cores * ms->smp.threads;
>> +
>> +    socket = s390_get_socket(ms, book, core_id / nb_cores_per_socket, 
>> errp);
>> +    if (!socket) {
>> +        return false;
>> +    }
>> +
>> +    /*
>> +     * At the core level, each CPU is represented by a bit in a 64bit
>> +     * unsigned long. Set on plug and clear on unplug of a CPU.
>> +     * The firmware assume that all CPU in the core description have 
>> the same
>> +     * type, polarization and are all dedicated or shared.
>> +     * In the case a socket contains CPU with different type, 
>> polarization
>> +     * or dedication then they will be defined in different CPU 
>> containers.
>> +     * Currently we assume all CPU are identical and the only reason 
>> to have
>> +     * several S390TopologyCores inside a socket is to have more than 
>> 64 CPUs
>> +     * in that case the origin field, representing the offset of the 
>> first CPU
>> +     * in the CPU container allows to represent up to the maximal 
>> number of
>> +     * CPU inside several CPU containers inside the socket container.
>> +     */
>> +    origin = 64 * (core_id / 64);
> 
> Maybe faster:
> 
>      origin = core_id & ~63;

yes thanks

> 
> By the way, where is this limitation to 64 coming from? Just because 
> we're using a "unsigned long" for now? Or is this a limitation from the 
> architecture?
> 

It is a limitation from the architecture who use a 64bit field to 
represent the CPUs in a CPU TLE mask.

but this patch serie is quite old now and I changed some things 
according to the comments I received
I plan to send the new version before the end of the week.


>> +    cores = s390_get_cores(ms, socket, origin, errp);
>> +    if (!cores) {
>> +        return false;
>> +    }
>> +
>> +    bit = 63 - (core_id - origin);
>> +    set_bit(bit, &cores->mask);
>> +    cores->origin = origin;
>> +
>> +    return true;
>> +}
> ...
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index cc3097bfee..a586875b24 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -43,6 +43,7 @@
>>   #include "sysemu/sysemu.h"
>>   #include "hw/s390x/pv.h"
>>   #include "migration/blocker.h"
>> +#include "hw/s390x/cpu-topology.h"
>>   static Error *pv_mig_blocker;
>> @@ -89,6 +90,7 @@ static void s390_init_cpus(MachineState *machine)
>>       /* initialize possible_cpus */
>>       mc->possible_cpu_arch_ids(machine);
>> +    s390_topology_setup(machine);
> 
> Is this safe with regards to migration? Did you tried a ping-pong 
> migration from an older QEMU to a QEMU with your modifications and back 
> to the older one? If it does not work, we might need to wire this setup 
> to the machine types...

I did not, I will add this test.


> 
>>       for (i = 0; i < machine->smp.cpus; i++) {
>>           s390x_new_cpu(machine->cpu_type, i, &error_fatal);
>>       }
>> @@ -306,6 +308,10 @@ static void s390_cpu_plug(HotplugHandler 
>> *hotplug_dev,
>>       g_assert(!ms->possible_cpus->cpus[cpu->env.core_id].cpu);
>>       ms->possible_cpus->cpus[cpu->env.core_id].cpu = OBJECT(dev);
>> +    if (!s390_topology_new_cpu(ms, cpu->env.core_id, errp)) {
>> +        return;
>> +    }
>> +
>>       if (dev->hotplugged) {
>>           raise_irq_cpu_hotplug();
>>       }
> 
>   Thomas
> 

Thanks Thomas,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
