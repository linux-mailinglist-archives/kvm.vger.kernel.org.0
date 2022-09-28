Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FF35ED7E0
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 10:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiI1If1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 04:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbiI1IfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 04:35:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2709779ECB
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 01:35:13 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28S81GGD018858;
        Wed, 28 Sep 2022 08:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=A8hyOLYWcfo7I++4mtqYegVv66r9HdmGJTE/Mgd1xbA=;
 b=JcvyQfFoiDlbBc1Hl3DibHlZOjc3LR63y6hwV0KkVVGL1V8R37qGSrvG2zlnIxA1L3zQ
 NwNhj7CO6KJshSQRHOUImxwQZbAgR0hoq4LXJ4syZWZEvYrD4ozbiS6APHRbp5z6RjIB
 shzDn8AAfZwHi8qsB45+qdH90hYrlStUyLbqPaJiWDXDtEhMjoW3Z+zCuNLwUJBl4xVm
 4LlEVA/LU/O0IltKqrcCOGin7r7b/6AUjFGerLZYeSZZvip7m5lIAm6oRL9FGdzj9qdE
 +xHt5fR+N3sylcvESGpNodfs4Mo1lxM2yTY7KKk4pOtYmYBD1nA7g5QEzNx3irIyGqVL Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvjd0ryyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:34:52 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28S8P6a7027928;
        Wed, 28 Sep 2022 08:34:52 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvjd0rywy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:34:52 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28S8LqNK023713;
        Wed, 28 Sep 2022 08:34:49 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3jss5j4xx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:34:49 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28S8YkxY2491026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 08:34:46 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AC314C046;
        Wed, 28 Sep 2022 08:34:46 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A56A04C044;
        Wed, 28 Sep 2022 08:34:45 +0000 (GMT)
Received: from [9.171.31.212] (unknown [9.171.31.212])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 08:34:45 +0000 (GMT)
Message-ID: <c4dca971-175f-5d51-ac6f-e73582583e56@linux.ibm.com>
Date:   Wed, 28 Sep 2022 10:34:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v9 07/10] s390x/cpu_topology: CPU topology migration
Content-Language: en-US
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
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5f127a8be58d0842c6d94d682538af55f4eef64f.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0-B756vJ-4C4tLTNQaFKDsBWNQCwhREM
X-Proofpoint-GUID: g2-uQyEWaP1aQM951z1pTrUXfb9vLZjL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_03,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280051
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/8/22 20:04, Janis Schoetterl-Glausch wrote:
> On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
>> The migration can only take place if both source and destination
>> of the migration both use or both do not use the CPU topology
>> facility.
>>
>> We indicate a change in topology during migration postload for the
>> case the topology changed between source and destination.
> 
> You always set the report bit after migration, right?
> In the last series you actually migrated the bit.
> Why the change? With the code you have actually migrating the bit isn't
> hard.

As for the moment the vCPU do not migrate from real CPU I thought based 
on the remark of Nico that there is no need to set the bit after a 
migration.

>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/s390x/cpu-topology.c         | 79 +++++++++++++++++++++++++++++++++
>>   include/hw/s390x/cpu-topology.h |  1 +
>>   target/s390x/cpu-sysemu.c       |  8 ++++
>>   target/s390x/cpu.h              |  1 +
>>   4 files changed, 89 insertions(+)
>>
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index 6098d6ea1f..b6bf839e40 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -19,6 +19,7 @@
>>   #include "target/s390x/cpu.h"
>>   #include "hw/s390x/s390-virtio-ccw.h"
>>   #include "hw/s390x/cpu-topology.h"
>> +#include "migration/vmstate.h"
>>   
>>   S390Topology *s390_get_topology(void)
>>   {
>> @@ -132,6 +133,83 @@ static void s390_topology_reset(DeviceState *dev)
>>       s390_cpu_topology_reset();
>>   }
>>   
>> +/**
>> + * cpu_topology_postload
>> + * @opaque: a pointer to the S390Topology
>> + * @version_id: version identifier
>> + *
>> + * We check that the topology is used or is not used
>> + * on both side identically.
>> + *
>> + * If the topology is in use we set the Modified Topology Change Report
>> + * on the destination host.
>> + */
>> +static int cpu_topology_postload(void *opaque, int version_id)
>> +{
>> +    S390Topology *topo = opaque;
>> +    int ret;
>> +
>> +    if (topo->topology_needed != s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
> 
> Does this function even run if topology_needed is false?
> In that case there is no data saved, so no reason to load it either.
> If so you can only check that both the source and the destination have
> the feature enabled. You would need to always send the topology VMSD in
> order to check that the feature is disabled.
> 
> Does qemu allow you to attempt to migrate to a host with another cpu
> model?
> If it disallowes that you wouldn't need to do any checks, right?

hum yes I must rework this

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
