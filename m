Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6F7610E10
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 12:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJ1KF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 06:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJ1KFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 06:05:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7414A119
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:05:23 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29S9jB4Y020314;
        Fri, 28 Oct 2022 10:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jW0Uj7CrwXtvNdIkoHIObB/2212+rsG9oZK4WVOd13g=;
 b=ByUFBnJLpWnDX9k4+aqPEli1otELX20H40rd7wdzsoOfdCikDJlJ0lflXoox+avOucqq
 chIC7iipJPdC1FiK+Gf6calzY7TmpntmRZHfL4BYiuiE6JtqH/VYjXq+WZwYWWLQUB+6
 jkMqxS0wiCGpgWJVzYnqlxvqMASQCA2YJIfaY1IJo68ohz8VkrKcigB3nTJPLdgKTuvl
 SNfGlNUbFrz8+hWFBWNclctfLuNwRSyUcLnj2qu/T962WsNlrviIQMYqIR8xqoQMJmNL
 TtRXCHknkbcEPFCsNMI8ZywaJHe5086w5tcBAtg2zrIXPj+pWOGhDiwE3iuigDK8qZOv Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kgcqh0nfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 10:05:11 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29S9jHwE020466;
        Fri, 28 Oct 2022 10:05:10 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kgcqh0ndb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 10:05:10 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29S9omwj009579;
        Fri, 28 Oct 2022 10:00:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3kfahmjf7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Oct 2022 10:00:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29SA03A91770042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 10:00:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02E47A405B;
        Fri, 28 Oct 2022 10:00:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FD7BA405C;
        Fri, 28 Oct 2022 10:00:02 +0000 (GMT)
Received: from [9.171.52.200] (unknown [9.171.52.200])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Oct 2022 10:00:01 +0000 (GMT)
Message-ID: <d82372a9-581a-9544-eb6d-7b3e125926f5@linux.ibm.com>
Date:   Fri, 28 Oct 2022 12:00:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v10 2/9] s390x/cpu topology: reporting the CPU topology to
 the guest
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
 <20221012162107.91734-3-pmorel@linux.ibm.com>
 <4c5afcb5754cb829cd8b9ddbf4f74e610d5f6012.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <4c5afcb5754cb829cd8b9ddbf4f74e610d5f6012.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wU3N3xZkj8sK_7Lu3A8MVcMxik0Kkysv
X-Proofpoint-ORIG-GUID: 7WWEcAIxT8Xf3NB84fUnndrlfoBgPLnN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_04,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/27/22 22:42, Janis Schoetterl-Glausch wrote:
> On Wed, 2022-10-12 at 18:21 +0200, Pierre Morel wrote:
>> The guest can use the STSI instruction to get a buffer filled
>> with the CPU topology description.
>>
>> Let us implement the STSI instruction for the basis CPU topology
>> level, level 2.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h |   3 +
>>   target/s390x/cpu.h              |  48 ++++++++++++++
>>   hw/s390x/cpu-topology.c         |   8 ++-
>>   target/s390x/cpu_topology.c     | 109 ++++++++++++++++++++++++++++++++
>>   target/s390x/kvm/kvm.c          |   6 +-
>>   target/s390x/meson.build        |   1 +
>>   6 files changed, 172 insertions(+), 3 deletions(-)
>>   create mode 100644 target/s390x/cpu_topology.c
>>
>> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
>> index 66c171d0bc..61c11db017 100644
>> --- a/include/hw/s390x/cpu-topology.h
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -13,6 +13,8 @@
>>   #include "hw/qdev-core.h"
>>   #include "qom/object.h"
>>   
>> +#define S390_TOPOLOGY_POLARITY_H  0x00
>> +
>>   typedef struct S390TopoContainer {
>>       int active_count;
>>   } S390TopoContainer;
>> @@ -29,6 +31,7 @@ struct S390Topology {
>>       S390TopoContainer *socket;
>>       S390TopoTLE *tle;
>>       MachineState *ms;
>> +    QemuMutex topo_mutex;
>>   };
>>   
>>   #define TYPE_S390_CPU_TOPOLOGY "s390-topology"
>> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
>> index 7d6d01325b..d604aa9c78 100644
>> --- a/target/s390x/cpu.h
>> +++ b/target/s390x/cpu.h
>>
> [...]
>> +
>> +/* Maxi size of a SYSIB structure is when all CPU are alone in a container */
> 
> Max or Maximum.
> 
>> +#define S390_TOPOLOGY_SYSIB_SIZE (sizeof(SysIB_151x) +                         \
>> +                                  S390_MAX_CPUS * (sizeof(SysIBTl_container) + \
>> +                                                   sizeof(SysIBTl_cpu)))
> 
> Currently this is 16+248*3*8 == 5968 and will grow with books, drawer support to
> 16+248*5*8 == 9936 ...
> 
> [...]
>>
>> +
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>> +{
>> +    uint64_t page[S390_TOPOLOGY_SYSIB_SIZE / sizeof(uint64_t)] = {};
> 
> ... so calling this page is a bit misleading. Also why not make it a char[]?
> And maybe use a union for type punning.

OK, what about:

     union {
         char place_holder[S390_TOPOLOGY_SYSIB_SIZE];
         SysIB_151x sysib;
     } buffer QEMU_ALIGNED(8);


> 
>> +    SysIB_151x *sysib = (SysIB_151x *) page;
>> +    int len;
>> +
>> +    if (s390_is_pv() || !s390_has_topology() ||
>> +        sel2 < 2 || sel2 > S390_TOPOLOGY_MAX_MNEST) {
>> +        setcc(cpu, 3);
>> +        return;
>> +    }
>> +
>> +    len = setup_stsi(sysib, sel2);
> 
> This should now be memory safe, but might be larger than 4k,
> the maximum size of the SYSIB. I guess you want to set cc code 3
> in this case and return.

I do not find why the SYSIB can not be larger than 4k.
Can you point me to this restriction?


Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
