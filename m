Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A716F5386
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 10:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjECIoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 04:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjECIn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 04:43:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CAB4EF9
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 01:43:56 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3438gJkv021182;
        Wed, 3 May 2023 08:43:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sodRUcKamTTAvjrmh3X2hAUlgHQ86ZN4e7vziBUP6co=;
 b=Uv3LKnaSfaBaKrcJe3OZcRR1/QLCYte3LhgsSF0SWQlQHOi9Br6btt3Q2L6mlqxwmnlo
 IkfPnzt57TYgSy40IUajRjhU3RuDUcHkpMrlPef4yxq1TR+/MPsXJspB1v64S3EmWi5F
 3lKkheUWVqoJC8GT/WHi/xMXclzIK8/RMie1lPH2uwC/zv6CQSgR7l0aiis3wzzsWjQl
 opk/JBBN0x5bz/k8AVuVi27nBgJv4uGlooATvsZS/cnXHmckw9aQRZGFnKpnqgZgHirA
 KyPUhWTeIE7oBKf0AvPBALxoEefE9QMw/q06owDeyKAnzneGJtLn/lk5vyO0xLRUpbOJ 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbmb281jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 08:43:47 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3438hkZE029999;
        Wed, 3 May 2023 08:43:46 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbmb281hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 08:43:46 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34348kij021540;
        Wed, 3 May 2023 08:43:44 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q8tv6t2v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 08:43:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3438hcYH1704508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 08:43:38 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67FBC2004B;
        Wed,  3 May 2023 08:43:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7730620040;
        Wed,  3 May 2023 08:43:37 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  3 May 2023 08:43:37 +0000 (GMT)
Message-ID: <d1949e44-a4c1-4f7a-6a81-c909ecb610fa@linux.ibm.com>
Date:   Wed, 3 May 2023 10:43:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 03/21] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-4-pmorel@linux.ibm.com>
 <5f4fa29eaec7269350403b2d1b2b051e6aa59a39.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5f4fa29eaec7269350403b2d1b2b051e6aa59a39.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gxw9oRuJi7ozInr5AeY7QPZUUbUe9wgl
X-Proofpoint-GUID: -EpxY8oB395xfNvaHTwpOEI8ObvDDyUG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_04,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030070
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/2/23 19:22, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
>> On interception of STSI(15.1.x) the System Information Block
>> (SYSIB) is built from the list of pre-ordered topology entries.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   MAINTAINERS                     |   1 +
>>   include/hw/s390x/cpu-topology.h |  24 +++
>>   include/hw/s390x/sclp.h         |   1 +
>>   target/s390x/cpu.h              |  72 ++++++++
>>   hw/s390x/cpu-topology.c         |  13 +-
>>   target/s390x/kvm/cpu_topology.c | 308 ++++++++++++++++++++++++++++++++
>>   target/s390x/kvm/kvm.c          |   5 +-
>>   target/s390x/kvm/meson.build    |   3 +-
>>   8 files changed, 424 insertions(+), 3 deletions(-)
>>   create mode 100644 target/s390x/kvm/cpu_topology.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index bb7b34d0d8..de9052f753 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1659,6 +1659,7 @@ M: Pierre Morel <pmorel@linux.ibm.com>
>>   S: Supported
>>   F: include/hw/s390x/cpu-topology.h
>>   F: hw/s390x/cpu-topology.c
>> +F: target/s390x/kvm/cpu_topology.c
>>   
>>   X86 Machines
>>   ------------
>> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
>> index af36f634e0..87bfeb631e 100644
>> --- a/include/hw/s390x/cpu-topology.h
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -15,9 +15,33 @@
>>
> [...]
>
>> +typedef struct S390TopologyEntry {
>> +    QTAILQ_ENTRY(S390TopologyEntry) next;
>> +    s390_topology_id id;
>> +    uint64_t mask;
>> +} S390TopologyEntry;
>> +
>>   typedef struct S390Topology {
>>       uint8_t *cores_per_socket;
>> +    QTAILQ_HEAD(, S390TopologyEntry) list;
> Since you recompute the list on every STSI, you no longer need this in here.
> You can create it in insert_stsi_15_1_x.

Sure but why should we do that?

It does not change functionality or performance and I do not find it 
makes the code clearer.
On the other hand it changes the implementation and the initialization 
of the list with the sentinel becomes tricky.


>>       CpuTopology *smp;
>> +    bool vertical_polarization;
>>   } S390Topology;
> [...]
>
>> +/*
>> + * Macro to check that the size of data after increment
>> + * will not get bigger than the size of the SysIB.
>> + */
>> +#define SYSIB_GUARD(data, x) do {       \
>> +        data += x;                      \
>> +        if (data  > sizeof(SysIB)) {    \
>                      ^ two spaces

right, thanks


>
>> +            return 0;                   \
>> +        }                               \
>> +    } while (0)
>> +
> [...]
>
>> +/**
>> + * s390_topology_from_cpu:
>> + * @cpu: The S390CPU
>> + *
>> + * Initialize the topology id from the CPU environment.
>> + */
>> +static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
>> +{
>> +    s390_topology_id topology_id = {0};
>> +
>> +    topology_id.drawer = cpu->env.drawer_id;
>> +    topology_id.book = cpu->env.book_id;
>> +    topology_id.socket = cpu->env.socket_id;
>> +    topology_id.origin = cpu->env.core_id / 64;
>> +    topology_id.type = S390_TOPOLOGY_CPU_IFL;
>> +    topology_id.dedicated = cpu->env.dedicated;
>> +
>> +    if (s390_topology.vertical_polarization) {
>> +        /*
>> +         * Vertical polarization with dedicated CPU implies
>> +         * vertical high entitlement.
>> +         */
> This has already been adjusted or rejected when the entitlement was set.
>
>> +        if (topology_id.dedicated) {
>> +            topology_id.entitlement = S390_CPU_ENTITLEMENT_HIGH;
>> +        } else {
>> +            topology_id.entitlement = cpu->env.entitlement;
> You only need this assignment.


Right, thanks


Regards,

Pierre

