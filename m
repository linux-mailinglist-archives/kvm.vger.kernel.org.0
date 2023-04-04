Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE016D5B82
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 11:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbjDDJHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 05:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbjDDJHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 05:07:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430C31990
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 02:07:29 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3347O879011242;
        Tue, 4 Apr 2023 09:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LtYzJ1e+FxahVkD/XXuROe/QwjD9fm8As8cNegASnag=;
 b=bIQCoTcIuTDTKXYC430omPdVeTGxATGKXuuy194MVtJJwiBBrl+aHO9sjPdVpAi7FI3R
 Odfiwt3qJb/ctCpYGdx1QXVIXn5IGCYRprJd91fJL7NJQrkRFHh+D4jGhwS7Y1I3GhFi
 GM29xHoL5T8eP7sWepBal43tBfp3fYuSDEDR1MqAgjJgg/b/+lAeVgctLe6lQsL+u8ue
 l79WyJMMkJAOkN9+uHkvs2jD+g1glJkFmxP9NKt42TlI73AJKEriOZTgLkg9g4Xj59rR
 hN5Z8lsDNMPRYafmxEHp/cWhJ/aa1QO0AxlnP/AWE0bMjOZEHa+ctnHf7QUFxLP8EQWY DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr3gs27w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 09:07:16 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33497ClL007551;
        Tue, 4 Apr 2023 09:07:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr3gs27vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 09:07:15 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3341PM0e004923;
        Tue, 4 Apr 2023 09:07:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ppc87adc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 09:07:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334979KY48103742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 09:07:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0528520043;
        Tue,  4 Apr 2023 09:07:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 805FC2004E;
        Tue,  4 Apr 2023 09:07:08 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  4 Apr 2023 09:07:08 +0000 (GMT)
Message-ID: <01ad25d3-7c91-d184-56c8-9f28f4044de9@linux.ibm.com>
Date:   Tue, 4 Apr 2023 11:07:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 06/21] s390x/cpu topology: interception of PTF
 instruction
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
 <20230403162905.17703-7-pmorel@linux.ibm.com>
 <227eb09d-e5dc-2662-32b0-0b9ca4e8ef34@kaod.org>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <227eb09d-e5dc-2662-32b0-0b9ca4e8ef34@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bRTNnqSvAFuAqUkWDbff2X79xsGEMl8P
X-Proofpoint-ORIG-GUID: hwSuVrplmOOHs9unM_6wM4MvBmsSYUV-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_02,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040083
X-Spam-Status: No, score=-2.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/23 09:41, Cédric Le Goater wrote:
> On 4/3/23 18:28, Pierre Morel wrote:
>> When the host supports the CPU topology facility, the PTF
>> instruction with function code 2 is interpreted by the SIE,
>> provided that the userland hypervisor activates the interpretation
>> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
>>
>> The PTF instructions with function code 0 and 1 are intercepted
>> and must be emulated by the userland hypervisor.
>>
>> During RESET all CPU of the configuration are placed in
>> horizontal polarity.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/s390-virtio-ccw.h |  6 ++++
>>   hw/s390x/cpu-topology.c            | 56 ++++++++++++++++++++++++++++--
>>   target/s390x/kvm/kvm.c             | 11 ++++++
>>   3 files changed, 71 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h 
>> b/include/hw/s390x/s390-virtio-ccw.h
>> index ea10a6c6e1..9aa9f48bd0 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -31,6 +31,12 @@ struct S390CcwMachineState {
>>       bool vertical_polarization;
>>   };
>>   +#define S390_PTF_REASON_NONE (0x00 << 8)
>> +#define S390_PTF_REASON_DONE (0x01 << 8)
>> +#define S390_PTF_REASON_BUSY (0x02 << 8)
>> +#define S390_TOPO_FC_MASK 0xffUL
>> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
>> +
>>   struct S390CcwMachineClass {
>>       /*< private >*/
>>       MachineClass parent_class;
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index 1d672d4d81..eec6c9a896 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -26,8 +26,6 @@
>>    * .smp: keeps track of the machine topology.
>>    * .list: queue the topology entries inside which
>>    *        we keep the information on the CPU topology.
>> - * .polarization: the current subsystem polarization
>> - *
>
> Please remove from patch 3 instead.


Yes of course

Thanks,

Pierre


>
>>    */
>>   S390Topology s390_topology = {
>>       /* will be initialized after the cpu model is realized */
>> @@ -86,6 +84,57 @@ static void s390_topology_init(MachineState *ms)
>>       QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>>   }
>>   +/*
>> + * s390_handle_ptf:
>> + *
>> + * @register 1: contains the function code
>> + *
>> + * Function codes 0 (horizontal) and 1 (vertical) define the CPU
>> + * polarization requested by the guest.
>> + *
>> + * Function code 2 is handling topology changes and is interpreted
>> + * by the SIE.
>> + */
>> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
>> +{
>> +    struct S390CcwMachineState *s390ms = 
>> S390_CCW_MACHINE(current_machine);
>> +    CPUS390XState *env = &cpu->env;
>> +    uint64_t reg = env->regs[r1];
>> +    int fc = reg & S390_TOPO_FC_MASK;
>> +
>> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
>> +        s390_program_interrupt(env, PGM_OPERATION, ra);
>> +        return;
>> +    }
>> +
>> +    if (env->psw.mask & PSW_MASK_PSTATE) {
>> +        s390_program_interrupt(env, PGM_PRIVILEGED, ra);
>> +        return;
>> +    }
>> +
>> +    if (reg & ~S390_TOPO_FC_MASK) {
>> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
>> +        return;
>> +    }
>> +
>> +    switch (fc) {
>> +    case S390_CPU_POLARIZATION_VERTICAL:
>> +    case S390_CPU_POLARIZATION_HORIZONTAL:
>> +        if (s390ms->vertical_polarization == !!fc) {
>> +            env->regs[r1] |= S390_PTF_REASON_DONE;
>> +            setcc(cpu, 2);
>> +        } else {
>> +            s390ms->vertical_polarization = !!fc;
>> +            s390_cpu_topology_set_changed(true);
>> +            setcc(cpu, 0);
>> +        }
>> +        break;
>> +    default:
>> +        /* Note that fc == 2 is interpreted by the SIE */
>> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
>> +    }
>> +}
>> +
>>   /**
>>    * s390_topology_reset:
>>    *
>> @@ -94,7 +143,10 @@ static void s390_topology_init(MachineState *ms)
>>    */
>>   void s390_topology_reset(void)
>>   {
>> +    struct S390CcwMachineState *s390ms = 
>> S390_CCW_MACHINE(current_machine);
>> +
>>       s390_cpu_topology_set_changed(false);
>> +    s390ms->vertical_polarization = false;
>>   }
>>     /**
>> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
>> index bc953151ce..fb63be41b7 100644
>> --- a/target/s390x/kvm/kvm.c
>> +++ b/target/s390x/kvm/kvm.c
>> @@ -96,6 +96,7 @@
>>     #define PRIV_B9_EQBS                    0x9c
>>   #define PRIV_B9_CLP                     0xa0
>> +#define PRIV_B9_PTF                     0xa2
>>   #define PRIV_B9_PCISTG                  0xd0
>>   #define PRIV_B9_PCILG                   0xd2
>>   #define PRIV_B9_RPCIT                   0xd3
>> @@ -1464,6 +1465,13 @@ static int kvm_mpcifc_service_call(S390CPU 
>> *cpu, struct kvm_run *run)
>>       }
>>   }
>>   +static void kvm_handle_ptf(S390CPU *cpu, struct kvm_run *run)
>> +{
>> +    uint8_t r1 = (run->s390_sieic.ipb >> 20) & 0x0f;
>> +
>> +    s390_handle_ptf(cpu, r1, RA_IGNORED);
>> +}
>> +
>>   static int handle_b9(S390CPU *cpu, struct kvm_run *run, uint8_t ipa1)
>>   {
>>       int r = 0;
>> @@ -1481,6 +1489,9 @@ static int handle_b9(S390CPU *cpu, struct 
>> kvm_run *run, uint8_t ipa1)
>>       case PRIV_B9_RPCIT:
>>           r = kvm_rpcit_service_call(cpu, run);
>>           break;
>> +    case PRIV_B9_PTF:
>> +        kvm_handle_ptf(cpu, run);
>> +        break;
>>       case PRIV_B9_EQBS:
>>           /* just inject exception */
>>           r = -1;
>
