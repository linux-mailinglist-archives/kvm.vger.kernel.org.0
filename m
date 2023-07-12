Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC01750CF6
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjGLPqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjGLPqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:46:51 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178C21BB
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:46:51 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CFg0r3014260;
        Wed, 12 Jul 2023 15:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=URYayddAAoLBOT2mFubDD+YcUfU1qLeT9suZBiRFF3s=;
 b=NDlLpDIh8Gr/445/yvSCGEcfyv6Sp7d4C3qYw2zrIE+Ekoov3naABwa4iV5qBeJU2vi8
 9F4VnJjC8lP+QH/N8jVKSuZ4NipPvJo8/P8bDoqpR5UJrfcgAkKG3z7dMB+KO/VVIaZ5
 FdApNGo8gafwvh2GVpoVH3YoIaMtqtFe5ylEdM1gn1gUlZWphnK1VZQzBQ3IO+vCrLp4
 j7HiMuBjc+JhYZ41JfLG34Jh0NSHQjAxCopOSGBCdXKp3Bwlh/u13DAivNSNoVV21MtH
 OWNqDsezOVxM2GkJLfk58k9J6kbF62Ls5QB37sHoGxOeBXvXkiRQ/vYYIggvJ5/1ksDp sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsxp0sb6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 15:46:31 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CFg8n2014959;
        Wed, 12 Jul 2023 15:45:52 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsxp0s9kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 15:45:52 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36C4dLPq017376;
        Wed, 12 Jul 2023 15:44:15 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye5aqga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 15:44:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CFiAcp3146246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 15:44:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE80820043;
        Wed, 12 Jul 2023 15:44:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29BBB20040;
        Wed, 12 Jul 2023 15:44:10 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 12 Jul 2023 15:44:10 +0000 (GMT)
Message-ID: <c8cc5d6c-d0fa-c475-07ec-da6b2894cee4@linux.ibm.com>
Date:   Wed, 12 Jul 2023 17:44:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 09/20] machine: adding s390 topology to query-cpu-fast
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-10-pmorel@linux.ibm.com>
 <747a5678-6140-a0ca-b08c-841b2ae00802@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <747a5678-6140-a0ca-b08c-841b2ae00802@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IfSqUGhrUwnpW4IY6TsMkiE8UvSvRSoP
X-Proofpoint-ORIG-GUID: nJMNVdbHsDfr3eG8FIhWd03cv_9F7FeZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_11,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 mlxscore=0 impostorscore=0 adultscore=0
 clxscore=1015 phishscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2307120141
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/4/23 14:55, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> S390x provides two more topology attributes, entitlement and dedication.
>>
>> Let's add these CPU attributes to the QAPI command query-cpu-fast.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine.json  | 9 ++++++++-
>>   target/s390x/cpu.c | 4 ++++
>>   2 files changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/qapi/machine.json b/qapi/machine.json
>> index 08245beea1..a1920cb78d 100644
>> --- a/qapi/machine.json
>> +++ b/qapi/machine.json
>> @@ -56,10 +56,17 @@
>>   # Additional information about a virtual S390 CPU
>>   #
>>   # @cpu-state: the virtual CPU's state
>> +# @dedicated: the virtual CPU's dedication (since 8.1)
>> +# @entitlement: the virtual CPU's entitlement (since 8.1)
>>   #
>>   # Since: 2.12
>>   ##
>> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
>> +{ 'struct': 'CpuInfoS390',
>> +  'data': { 'cpu-state': 'CpuS390State',
>> +            'dedicated': 'bool',
>> +            'entitlement': 'CpuS390Entitlement'
>
> Would it make sense to make them optional and only report those if the 
> topology feature is enabled?
>
>  Thomas
>
I think you are right, I make them optional, it has no sense if the 
architecture does support topology.

Thanks,

Pierre


>
>> +  }
>> +}
>>     ##
>>   # @CpuInfoFast:
>> diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
>> index 74405beb51..01938635eb 100644
>> --- a/target/s390x/cpu.c
>> +++ b/target/s390x/cpu.c
>> @@ -146,6 +146,10 @@ static void s390_query_cpu_fast(CPUState *cpu, 
>> CpuInfoFast *value)
>>       S390CPU *s390_cpu = S390_CPU(cpu);
>>         value->u.s390x.cpu_state = s390_cpu->env.cpu_state;
>> +#if !defined(CONFIG_USER_ONLY)
>> +    value->u.s390x.dedicated = s390_cpu->env.dedicated;
>> +    value->u.s390x.entitlement = s390_cpu->env.entitlement;
>> +#endif
>>   }
>>     /* S390CPUClass::reset() */
>
