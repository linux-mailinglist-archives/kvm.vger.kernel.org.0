Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDF25EFC05
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 19:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiI2RbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 13:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiI2Ra7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 13:30:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C641E0C60
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:30:58 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28THKHa0010721;
        Thu, 29 Sep 2022 17:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sgy89uzxa05j3Z4zk2FFgOfEvrE99AOZs9+ZWWJCVVU=;
 b=VXaxvLxdg2zdPyAD4fnHX3Jt/l6cYlF2pzDm0BH5nPwj2q+D3CSNTSaz0FRMZGuIyzc/
 AmnlvSqBcYydI9DgDo5R+gfl2joYZdJq6P33csMOBQpoDo5kNp98enJ3Z9xQCGiY/PHB
 2SMuyR+w4y2L47+IY0Y9nXbjIhUHNT9JfkEsbcglnkGP/rXRaD6QWLUwVrUM8P+TTHHH
 lDQuOWaAW+3vdoY8RLQ5MMwRFqDX96uV+D8iVlxtAqlBHLx7IXdqRZQtYW2sZ3MeD6yw
 mA7cEDc0OLFxJOkZmAUDpNvY7enZFBO8kjDKOM9O/Fe+meU2vgBpHMf4gCVM1n17ubEk Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jwfp309b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 17:30:51 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28THLmVp015450;
        Thu, 29 Sep 2022 17:30:50 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jwfp309ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 17:30:50 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28THJq3X005197;
        Thu, 29 Sep 2022 17:30:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3jssh9f0es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 17:30:48 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28THUjl162783894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 17:30:45 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BDF94C044;
        Thu, 29 Sep 2022 17:30:45 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EEC14C040;
        Thu, 29 Sep 2022 17:30:44 +0000 (GMT)
Received: from [9.171.77.209] (unknown [9.171.77.209])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Sep 2022 17:30:44 +0000 (GMT)
Message-ID: <2c0f0483-a161-d08b-438e-d59cde87cdae@linux.ibm.com>
Date:   Thu, 29 Sep 2022 19:30:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v9 07/10] s390x/cpu_topology: CPU topology migration
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-8-pmorel@linux.ibm.com>
 <5f127a8be58d0842c6d94d682538af55f4eef64f.camel@linux.ibm.com>
 <c4dca971-175f-5d51-ac6f-e73582583e56@linux.ibm.com>
In-Reply-To: <c4dca971-175f-5d51-ac6f-e73582583e56@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Lf3GmjzAAudGD9tHX1_yiMK2L23a7K0_
X-Proofpoint-GUID: c8gj-QKPd979vbbq4SXkjrj7KP6cYY1W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290107
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/28/22 10:34, Pierre Morel wrote:
> 
> 
> On 9/8/22 20:04, Janis Schoetterl-Glausch wrote:
>> On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
>>> The migration can only take place if both source and destination
>>> of the migration both use or both do not use the CPU topology
>>> facility.
>>>
>>> We indicate a change in topology during migration postload for the
>>> case the topology changed between source and destination.
>>
>> You always set the report bit after migration, right?
>> In the last series you actually migrated the bit.
>> Why the change? With the code you have actually migrating the bit isn't
>> hard.
> 
> As for the moment the vCPU do not migrate from real CPU I thought based 
> on the remark of Nico that there is no need to set the bit after a 
> migration.
> 
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   hw/s390x/cpu-topology.c         | 79 +++++++++++++++++++++++++++++++++
>>>   include/hw/s390x/cpu-topology.h |  1 +
>>>   target/s390x/cpu-sysemu.c       |  8 ++++
>>>   target/s390x/cpu.h              |  1 +
>>>   4 files changed, 89 insertions(+)
>>>
>>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>>> index 6098d6ea1f..b6bf839e40 100644
>>> --- a/hw/s390x/cpu-topology.c
>>> +++ b/hw/s390x/cpu-topology.c
>>> @@ -19,6 +19,7 @@
>>>   #include "target/s390x/cpu.h"
>>>   #include "hw/s390x/s390-virtio-ccw.h"
>>>   #include "hw/s390x/cpu-topology.h"
>>> +#include "migration/vmstate.h"
>>>   S390Topology *s390_get_topology(void)
>>>   {
>>> @@ -132,6 +133,83 @@ static void s390_topology_reset(DeviceState *dev)
>>>       s390_cpu_topology_reset();
>>>   }
>>> +/**
>>> + * cpu_topology_postload
>>> + * @opaque: a pointer to the S390Topology
>>> + * @version_id: version identifier
>>> + *
>>> + * We check that the topology is used or is not used
>>> + * on both side identically.
>>> + *
>>> + * If the topology is in use we set the Modified Topology Change Report
>>> + * on the destination host.
>>> + */
>>> +static int cpu_topology_postload(void *opaque, int version_id)
>>> +{
>>> +    S390Topology *topo = opaque;
>>> +    int ret;
>>> +
>>> +    if (topo->topology_needed != 
>>> s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
>>
>> Does this function even run if topology_needed is false?
>> In that case there is no data saved, so no reason to load it either.
>> If so you can only check that both the source and the destination have
>> the feature enabled. You would need to always send the topology VMSD in
>> order to check that the feature is disabled.
>>
>> Does qemu allow you to attempt to migrate to a host with another cpu
>> model?
>> If it disallowes that you wouldn't need to do any checks, right?
> 
> hum yes I must rework this
> 
> Thanks,
> Pierre
> 
> 

I think my answer was wrong but it helped to correct a bug:
- Only machines > 7.x will be able to use topology and it is correct 
that migration to another machine is not possible.

- However we keep the possibility to not use the topology in 7.x and we 
are not able to migrate if one end use the topology and the other do not.

So I think cpu_topology_needed() must return true (no test needed) but 
the implementation of presave and postload are OK.

Regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
