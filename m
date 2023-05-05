Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8E16F8010
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 11:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbjEEJfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 05:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjEEJfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 05:35:12 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB1310F3
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 02:35:11 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3459TsNL003180;
        Fri, 5 May 2023 09:34:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=s748wXFJcGFtSdTg9Z6/xOU8Wcx0M0o2gF1qGxb2Mtw=;
 b=L4mf86yGp75qcJMx69qcJvveLAliIkTPmcyq9tCsd1wghOdLWSo4t2PMeO72KAiqYyyq
 5ul1PQCdCnFOdkdbXGQQMcfGvDic4XVpYTg8eInfCuSZT3E+xH5Oeb+HPVDgvu4WUYcb
 JfdFTqwaIQ8PbQtbhx/7avr7j4/I3byEdNJAB+e/LQwASoQBVL48FvDloA9CdwJoXCrM
 i17C55Tk9X8JxP1ChD8FzUOSJ/6l3KQ+9/2SKpOkLyvqqg8A0DlGH3NIQb3aR8FvurQq
 tEYSOQvPrEaaehmrRxIQiW2n9kvJzMv4jn1uVLTmts2ohLnHhVsYCAaafvZ0f6hgg15R FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qcxhshbbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 May 2023 09:34:55 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3459XR7I017856;
        Fri, 5 May 2023 09:34:55 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qcxhshbap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 May 2023 09:34:55 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3455mjgF013667;
        Fri, 5 May 2023 09:34:53 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6tsem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 May 2023 09:34:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3459Ylew29098290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 May 2023 09:34:47 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 091562004B;
        Fri,  5 May 2023 09:34:47 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D99852004F;
        Fri,  5 May 2023 09:34:45 +0000 (GMT)
Received: from [9.171.52.9] (unknown [9.171.52.9])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri,  5 May 2023 09:34:45 +0000 (GMT)
Message-ID: <dc7ddef2-8932-406f-7786-b9f6f87a0a71@linux.ibm.com>
Date:   Fri, 5 May 2023 11:34:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 06/21] s390x/cpu topology: interception of PTF
 instruction
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
 <20230425161456.21031-7-pmorel@linux.ibm.com>
 <ffc6bf647f1d7238f15b9d08ae20683bdb116eb4.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <ffc6bf647f1d7238f15b9d08ae20683bdb116eb4.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0BiuVKWzA4V5oh-pMW4YkrO8S2DBb1LP
X-Proofpoint-GUID: tWpoBSPQkGQXq-XYicfsWw02WIURLg6F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-05_15,2023-05-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305050074
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/4/23 13:03, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
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
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Thanks


>
> See nit below.
>> ---
>>   include/hw/s390x/s390-virtio-ccw.h |  6 ++++
>>   hw/s390x/cpu-topology.c            | 51 ++++++++++++++++++++++++++++++
>>   target/s390x/kvm/kvm.c             | 11 +++++++
>>   3 files changed, 68 insertions(+)
>>
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
>> index 9bba21a916..c1d46e78af 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -30,6 +30,12 @@ struct S390CcwMachineState {
>>       uint8_t loadparm[8];
>>   };
>>   
>> +#define S390_PTF_REASON_NONE (0x00 << 8)
>> +#define S390_PTF_REASON_DONE (0x01 << 8)
>> +#define S390_PTF_REASON_BUSY (0x02 << 8)
>> +#define S390_TOPO_FC_MASK 0xffUL
>> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
>> +
>>   struct S390CcwMachineClass {
>>       /*< private >*/
>>       MachineClass parent_class;
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index c98439ff7a..3c7bbff4bc 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -96,6 +96,56 @@ static void s390_topology_init(MachineState *ms)
>>       QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>>   }
>>   
>> +/*
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
>> +    CPUS390XState *env = &cpu->env;
>> +    uint64_t reg = env->regs[r1];
>> +    int fc = reg & S390_TOPO_FC_MASK;
>> +
>> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
>> +        s390_program_interrupt(env, PGM_OPERATION, ra);
>> +        return;
>> +    }
>> +
>> +    if (env->psw.mask & PSW_MASK_PSTATE) {
>> +        s390_program_interrupt(env, PGM_PRIVILEGED, ra);
>> +        return;
>> +    }
>> +
>> +    if (reg & ~S390_TOPO_FC_MASK) {
>> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
>> +        return;
>> +    }
>> +
>> +    switch (fc) {
>> +    case S390_CPU_POLARIZATION_VERTICAL:
>> +    case S390_CPU_POLARIZATION_HORIZONTAL:
> I'd give this a name.
> bool requested_vertical = !!fc;


OK, looks good, I change this


Thanks.

Regards,

Pierre

>
>> +        if (s390_topology.vertical_polarization == !!fc) {
>> +            env->regs[r1] |= S390_PTF_REASON_DONE;
>> +            setcc(cpu, 2);
>> +        } else {
>> +            s390_topology.vertical_polarization = !!fc;
>> +            s390_cpu_topology_set_changed(true);
>> +            setcc(cpu, 0);
>> +        }
>> +        break;
>> +    default:
>> +        /* Note that fc == 2 is interpreted by the SIE */
>> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
>> +    }
>> +}
>> +
> [...]
>
