Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB4D6909A6
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 14:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjBINP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 08:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjBINP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 08:15:26 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D655FB6E
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 05:14:58 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319DDo0w009793;
        Thu, 9 Feb 2023 13:14:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FwyOYX2SShSmncmXz1UnTHi5I7coZZqMI3Ba4yi4sSo=;
 b=CAufNiIVHnl/3uzSk0y1IjIRsPLjI93wD7XDzM4jD091Y6/p6bsnP1onwjjKCV0RVghX
 MCfFjN2b8HpZkjBfOPDRmOn+Xp5AD5xBk7UX/NP+RDkPhYWjXnWB9bU8scVnYVnD7k0w
 mv+5MF1SS159GX0ineVqMQ5H8OdGJA0nDZLMjzMgY8p5VDpNOVMlYTFMm/VqThCqFbUO
 MKB2gLdvBnWaROcQd18GhyXeCJLZW93Bj1XgtNeFfFHjgcmlxxjezLhyqmqVBDjENr4K
 e8C4w967BsUSk0Q2VYFBkCtTZYg1gOXXG6MFTRjtsHOjQg2rmvpwr32j9dKeFWrqpUOp 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn1hgr0b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 13:14:27 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319DEQsk012313;
        Thu, 9 Feb 2023 13:14:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn1hgr0ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 13:14:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 319CXVMN023824;
        Thu, 9 Feb 2023 13:14:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06x890-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 13:14:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319DEKWq24773016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 13:14:20 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B36062004B;
        Thu,  9 Feb 2023 13:14:20 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47BF920040;
        Thu,  9 Feb 2023 13:14:19 +0000 (GMT)
Received: from [9.179.24.44] (unknown [9.179.24.44])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 13:14:19 +0000 (GMT)
Message-ID: <71a18622-ad84-834c-7981-9f5b6da6dc84@linux.ibm.com>
Date:   Thu, 9 Feb 2023 14:14:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v15 08/11] qapi/s390x/cpu topology: x-set-cpu-topology
 monitor command
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
 <20230201132051.126868-9-pmorel@linux.ibm.com>
 <5775d58faf9505e561c81baa3807f01a1e0621b4.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5775d58faf9505e561c81baa3807f01a1e0621b4.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CYqsLdtJU5yG64TLrTjvKZUaNX3ttDp1
X-Proofpoint-ORIG-GUID: cS0mPsPUKjeVd5_c9ZOHLrNMpFNvhoeL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090125
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/8/23 19:40, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
>> The modification of the CPU attributes are done through a monitor
>> command.
>>
>> It allows to move the core inside the topology tree to optimise
>> the cache usage in the case the host's hypervisor previously
>> moved the CPU.
>>
>> The same command allows to modify the CPU attributes modifiers
>> like polarization entitlement and the dedicated attribute to notify
>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>
>> With this knowledge the guest has the possibility to optimize the
>> usage of the vCPUs.
>>
>> The command is made experimental for the moment.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine-target.json | 29 +++++++++++++
>>   include/monitor/hmp.h    |  1 +
>>   hw/s390x/cpu-topology.c  | 88 ++++++++++++++++++++++++++++++++++++++++
>>   hmp-commands.hx          | 16 ++++++++
>>   4 files changed, 134 insertions(+)
>>
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index 2e267fa458..58df0f5061 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -342,3 +342,32 @@
>>                      'TARGET_S390X',
>>                      'TARGET_MIPS',
>>                      'TARGET_LOONGARCH64' ] } }
>> +
>> +##
>> +# @x-set-cpu-topology:
>> +#
>> +# @core: the vCPU ID to be moved
>> +# @socket: the destination socket where to move the vCPU
>> +# @book: the destination book where to move the vCPU
>> +# @drawer: the destination drawer where to move the vCPU
> 
> I wonder if it wouldn't be more convenient for the caller if everything is optional.

Yes, it is a good point.

> 
>> +# @polarity: optional polarity, default is last polarity set by the guest
>> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
>> +#
>> +# Modifies the topology by moving the CPU inside the topology
>> +# tree or by changing a modifier attribute of a CPU.
>> +#
>> +# Returns: Nothing on success, the reason on failure.
>> +#
>> +# Since: <next qemu stable release, eg. 1.0>
>> +##
>> +{ 'command': 'x-set-cpu-topology',
>> +  'data': {
>> +      'core': 'int',
>> +      'socket': 'int',
>> +      'book': 'int',
>> +      'drawer': 'int',
> 
> Did you consider naming those core-id, etc.? It would be consistent with
> query-cpus-fast/CpuInstanceProperties. Also all your variables end with _id.
> I don't care really just wanted to point it out.

OK, core-id etc. looks better

> 
>> +      '*polarity': 'int',
>> +      '*dedicated': 'bool'
>> +  },
>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>> +}
> 
> So apparently this is the old way of doing an experimental api.
> 
>> Names beginning with ``x-`` used to signify "experimental".  This
>> convention has been replaced by special feature "unstable".
> 
>> Feature "unstable" marks a command, event, enum value, or struct
>> member as unstable.  It is not supported elsewhere so far.  Interfaces
>> so marked may be withdrawn or changed incompatibly in future releases.

OK

> 
>> diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
>> index 1b3bdcb446..12827479cf 100644
>> --- a/include/monitor/hmp.h
>> +++ b/include/monitor/hmp.h
>> @@ -151,5 +151,6 @@ void hmp_human_readable_text_helper(Monitor *mon,
>>                                       HumanReadableText *(*qmp_handler)(Error **));
>>   void hmp_info_stats(Monitor *mon, const QDict *qdict);
>>   void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
>> +void hmp_x_set_cpu_topology(Monitor *mon, const QDict *qdict);
>>   
>>   #endif
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index c33378577b..6c50050991 100644
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
>> @@ -379,3 +383,87 @@ void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp)
>>       /* topology tree is reflected in props */
>>       s390_update_cpu_props(ms, cpu);
>>   }
>> +
>> +/*
>> + * qmp and hmp implementations
>> + */
>> +
>> +static void s390_change_topology(int64_t core_id, int64_t socket_id,
>> +                                 int64_t book_id, int64_t drawer_id,
>> +                                 int64_t polarity, bool dedicated,
>> +                                 Error **errp)
>> +{
>> +    MachineState *ms = current_machine;
>> +    S390CPU *cpu;
>> +    ERRP_GUARD();
>> +
>> +    cpu = (S390CPU *)ms->possible_cpus->cpus[core_id].cpu;
>> +    if (!cpu) {
>> +        error_setg(errp, "Core-id %ld does not exist!", core_id);
>> +        return;
>> +    }
>> +
>> +    /* Verify the new topology */
>> +    s390_topology_check(cpu, errp);
>> +    if (*errp) {
>> +        return;
>> +    }
>> +
>> +    /* Move the CPU into its new socket */
>> +    s390_set_core_in_socket(cpu, drawer_id, book_id, socket_id, true, errp);
> 
> The cpu isn't being created, so that should be false instead of true, right?

Yes right, should be "false"

> 
>> +
>> +    /* All checks done, report topology in environment */
>> +    cpu->env.drawer_id = drawer_id;
>> +    cpu->env.book_id = book_id;
>> +    cpu->env.socket_id = socket_id;
>> +    cpu->env.dedicated = dedicated;
>> +    cpu->env.entitlement = polarity;
>> +
>> +    /* topology tree is reflected in props */
>> +    s390_update_cpu_props(ms, cpu);
>> +
>> +    /* Advertise the topology change */
>> +    s390_cpu_topology_set_modified();
>> +}
>> +
>> +void qmp_x_set_cpu_topology(int64_t core, int64_t socket,
>> +                         int64_t book, int64_t drawer,
>> +                         bool has_polarity, int64_t polarity,
>> +                         bool has_dedicated, bool dedicated,
>> +                         Error **errp)
>> +{
>> +    ERRP_GUARD();
>> +
>> +    if (!s390_has_topology()) {
>> +        error_setg(errp, "This machine doesn't support topology");
>> +        return;
>> +    }
>> +    if (!has_polarity) {
>> +        polarity = POLARITY_VERTICAL_MEDIUM;
>> +    }
>> +    if (!has_dedicated) {
>> +        dedicated = false;
>> +    }
>> +    s390_change_topology(core, socket, book, drawer, polarity, dedicated, errp);
>> +}
>> +
>> +void hmp_x_set_cpu_topology(Monitor *mon, const QDict *qdict)
>> +{
>> +    const int64_t core = qdict_get_int(qdict, "core");
>> +    const int64_t socket = qdict_get_int(qdict, "socket");
>> +    const int64_t book = qdict_get_int(qdict, "book");
>> +    const int64_t drawer = qdict_get_int(qdict, "drawer");
>> +    bool has_polarity    = qdict_haskey(qdict, "polarity");
>> +    const int64_t polarity = qdict_get_try_int(qdict, "polarity", 0);
>> +    bool has_dedicated    = qdict_haskey(qdict, "dedicated");
>> +    const bool dedicated = qdict_get_try_bool(qdict, "dedicated", false);
>> +    Error *local_err = NULL;
>> +
>> +    qmp_x_set_cpu_topology(core, socket, book, drawer,
>> +                           has_polarity, polarity,
>> +                           has_dedicated, dedicated,
>> +                           &local_err);
>> +    if (hmp_handle_error(mon, local_err)) {
>> +        return;
>> +    }
> 
> What is the if for? The function ends anyway.

Right, I take it away.
Thanks.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
