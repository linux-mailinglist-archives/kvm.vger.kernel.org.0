Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8830671E57
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 14:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjARNuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 08:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjARNtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 08:49:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C1CCD20F
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 05:19:24 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IDA4a4026579;
        Wed, 18 Jan 2023 13:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NYbbonmwmTKG18jwPn2PoTy0UGH6KHhJCyK8/m2jhmA=;
 b=lX+YErun+tZP1qW5s9eE8ylKRY4TFXCwKfmN+5/0NFedE541oycH1pEA/cOeiWScGNS9
 J3loaY/Ygcum5ccis9V4J3RfrZaVvYusnaEt9o9Lq/ff7DytFwq5+xqdDPBYgYmOKhZZ
 EjBg8nSEoMIBaxg+P04P0Shx4u0oeK4hT7LVDP6HJtFZzVgZU+mkODyO7ukYCYC/9pQO
 B4bqmimZ5lRvoXWXhKJZp4zX6WbQYMX/kvRxGRMl959k+kjtnXPG5w4oSGj56K8i312B
 t2+IihLfBSM659nMrkzOcQjDwgVXrxBCBIhkx7k7+1mi3MlP/OTxq1suqqVSIKa9fFSo Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f91ucjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 13:18:06 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30ICsRQY021892;
        Wed, 18 Jan 2023 13:18:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f91ucj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 13:18:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30ICtbA3006229;
        Wed, 18 Jan 2023 13:18:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfnam3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 13:18:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IDHxC145613382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 13:18:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D09A120040;
        Wed, 18 Jan 2023 13:17:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA0A820043;
        Wed, 18 Jan 2023 13:17:58 +0000 (GMT)
Received: from [9.171.39.117] (unknown [9.171.39.117])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 13:17:58 +0000 (GMT)
Message-ID: <2242c485-1f34-bf58-30a8-4f6443dc672d@linux.ibm.com>
Date:   Wed, 18 Jan 2023 14:17:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology: change-topology monitor
 command
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-9-pmorel@linux.ibm.com> <Y7/29cONlVoKukIP@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <Y7/29cONlVoKukIP@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ix2_0e-Bg8kkADjNgXQhKSQUG7rE5awk
X-Proofpoint-ORIG-GUID: sohAw0zDgTpzfYC4E6caP3uNw52okJuy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301180113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/23 13:03, Daniel P. Berrangé wrote:
> On Thu, Jan 05, 2023 at 03:53:10PM +0100, Pierre Morel wrote:
>> The modification of the CPU attributes are done through a monitor
>> commands.
>>
>> It allows to move the core inside the topology tree to optimise
>> the cache usage in the case the host's hypervizor previously
>> moved the CPU.
>>
>> The same command allows to modifiy the CPU attributes modifiers
>> like polarization entitlement and the dedicated attribute to notify
>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>
>> With this knowledge the guest has the possibility to optimize the
>> usage of the vCPUs.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine-target.json |  29 ++++++++
>>   include/monitor/hmp.h    |   1 +
>>   hw/s390x/cpu-topology.c  | 141 +++++++++++++++++++++++++++++++++++++++
>>   hmp-commands.hx          |  16 +++++
>>   4 files changed, 187 insertions(+)
>>
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index 2e267fa458..75b0aa254d 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -342,3 +342,32 @@
>>                      'TARGET_S390X',
>>                      'TARGET_MIPS',
>>                      'TARGET_LOONGARCH64' ] } }
>> +
>> +##
>> +# @change-topology:
>> +#
>> +# @core: the vCPU ID to be moved
>> +# @socket: the destination socket where to move the vCPU
>> +# @book: the destination book where to move the vCPU
>> +# @drawer: the destination drawer where to move the vCPU
> 
> This movement can be done while the guest OS is running ?
> What happens to guest OS apps ? Every I know will read
> topology once and assume it never changes at runtime.

Yes this can change while the guest is running.

The S390 Logical PARtition, where the Linux runs is already a first 
level of virtualization and the lpar CPU are already virtual CPU which 
can be moved from one real CPU to another, the guest is at a second 
level of virtualization.

On the LPAR host an admin can check the topology.
A lpar CPU can be moved to another real CPU because of multiple reasons: 
maintenance, failure, other decision from the first level hypervisor 
that I do not know, may be scheduling balancing.

There is a mechanism for the OS in which is running in LPAR to set a 
flag for the guest on a topology change.
The guest use a specific instruction to get this flag.
This instruction PTF(2) is interpreted by the firmware and does not 
appear in this patch series but in Linux patch series.

So we have, real CPU <-> lpar CPU <-> vCPU

> 
> What's the use case for wanting to re-arrange topology in
> this manner ? It feels like its going to be a recipe for
> hard to diagnose problems, as much code in libvirt and apps
> above will assuming the vCPU IDs are assigned sequentially
> starting from node=0,book=0,drawer=0,socket=0,core=0,
> incrementing core, then incrementing socket, then
> incrementing drawer, etc.

The goal to rearrange the vCPU is to give the guest the knowledge of the 
topology so it can takes benefit of it.
If a lpar CPU moved to another real CPU in another drawer we must move 
the guest vCPU to another drawer so the guest OS can take the best 
scheduling decisions.

Per default, if nothing is specified on the creation of a vCPU, the 
creation is done exactly like you said, starting from (0,0,0,0) and 
incrementing.

There are two possibility to set a vCPU at its place:

1) on creation by specifying the drawer,book,socket for a specific core-id

2) with this QAPI command to move the CPU while it is running.
Note that the core-id and the CPU address do not change when moving the 
CPU so that there is no problem with scheduling, all we do is to provide 
the topology up to the guest when it asks.

The period of checking by the Linux kernel if there is a change and if 
there is a need to ask the topology is one minute.

The migration of CPU is not supposed to happen very often, (not every day).

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
>> +{ 'command': 'change-topology',
> 
> 'set-cpu-topology'

OK, yes looks better.

> 
>> +  'data': {
>> +      'core': 'int',
>> +      'socket': 'int',
>> +      'book': 'int',
>> +      'drawer': 'int',
>> +      '*polarity': 'int',
>> +      '*dedicated': 'bool'
>> +  },
>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>> +}
> 
> 
> With regards,
> Daniel

Thanks,

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
