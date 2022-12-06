Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773D5644151
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 11:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbiLFKdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 05:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234051AbiLFKdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 05:33:15 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1CB63AA
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 02:33:14 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B68rK89023151;
        Tue, 6 Dec 2022 10:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sBUpfkt4je8E+ciXGtMEQZVkXZ6iroEOkZfNlo8PCAo=;
 b=iSGrP2RoH8cQePhPcpXlNYdQP15zbGme4R4zJhSyYRcKBh/zm9fE/L8yIcZwI7qDDZOH
 91zCX0zAh/vkiX4iBmVFzUOCVIeAGp6KX4b2jkkFk1F/XBErOCBx6MnnzBoe5PZszjE8
 yEJTfKe6nvlu9Cpqz/CtiIp0JNRS0e+A3RDwTfp/Zq1t3vWS4Nj7o0cKQOdNGCnDy8gB
 zsxawBHI9kJ+e/uDKD+WMONV3VteX4G6j6oCYdJ5mtgvDXad35elfciIWsWpb2o8Lszj
 jfdHuKHBF/dRJhzBRz3FBogWnJz6a2PhQ4kzjrEVBIbDoLfrsHi4v7KscE/SZEmEIQ8m uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8g4kfvvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 10:33:01 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6AAHpj005662;
        Tue, 6 Dec 2022 10:33:00 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m8g4kfvve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 10:33:00 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2B5K5Iwj004900;
        Tue, 6 Dec 2022 10:32:58 GMT
Received: from smtprelay08.fra02v.mail.ibm.com ([9.218.2.231])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3m9pv9rqf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 10:32:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com ([9.149.105.58])
        by smtprelay08.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B6AWsgF26345734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Dec 2022 10:32:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF5664C040;
        Tue,  6 Dec 2022 10:32:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4AD34C044;
        Tue,  6 Dec 2022 10:32:53 +0000 (GMT)
Received: from [9.171.52.4] (unknown [9.171.52.4])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Dec 2022 10:32:53 +0000 (GMT)
Message-ID: <cb4abea1-b585-2753-12e9-6b75999d7d2e@linux.ibm.com>
Date:   Tue, 6 Dec 2022 11:32:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v12 1/7] s390x/cpu topology: Creating CPU topology device
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-2-pmorel@linux.ibm.com>
 <92e30cf1f091329b2076195e9c159be16c13f7f9.camel@linux.ibm.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <92e30cf1f091329b2076195e9c159be16c13f7f9.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FXEe1R7N3ROrk9FmpS7jn_R5I7IU22zj
X-Proofpoint-ORIG-GUID: qRJkqoddZLZvc_NUdIV1pYeWM2eic7Rn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_05,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060078
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/22 10:31, Janis Schoetterl-Glausch wrote:
> On Tue, 2022-11-29 at 18:42 +0100, Pierre Morel wrote:
>> We will need a Topology device to transfer the topology
>> during migration and to implement machine reset.
>>
>> The device creation is fenced by s390_has_topology().
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h    | 44 +++++++++++++++
>>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>>   hw/s390x/cpu-topology.c            | 87 ++++++++++++++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c         | 25 +++++++++
>>   hw/s390x/meson.build               |  1 +
>>   5 files changed, 158 insertions(+)
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>   create mode 100644 hw/s390x/cpu-topology.c
>>
> [...]
> 
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
>> index 9bba21a916..47ce0aa6fa 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>>       bool dea_key_wrap;
>>       bool pv;
>>       uint8_t loadparm[8];
>> +    DeviceState *topology;
> 
> Why is this a DeviceState, not S390Topology?
> It *has* to be a S390Topology, right? Since you cast it to one in patch 2.

Yes, currently it is the S390Topology.
The idea of Cedric was to have something more generic for future use.

> 
>>   };
>>   
>>   struct S390CcwMachineClass {
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> new file mode 100644
>> index 0000000000..bbf97cd66a
>> --- /dev/null
>> +++ b/hw/s390x/cpu-topology.c
>>
> [...]
>>   
>> +static DeviceState *s390_init_topology(MachineState *machine, Error **errp)
>> +{
>> +    DeviceState *dev;
>> +
>> +    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
>> +
>> +    object_property_add_child(&machine->parent_obj,
>> +                              TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
> 
> Why set this property, and why on the machine parent?

For what I understood setting the num_cores and num_sockets as 
properties of the CPU Topology object allows to have them better 
integrated in the QEMU object framework.

The topology is added to the S390CcwmachineState, it is the parent of 
the machine.


> 
>> +    object_property_set_int(OBJECT(dev), "num-cores",
>> +                            machine->smp.cores * machine->smp.threads, errp);
>> +    object_property_set_int(OBJECT(dev), "num-sockets",
>> +                            machine->smp.sockets, errp);
>> +
>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
> 
> I must admit that I haven't fully grokked qemu's memory management yet.
> Is the topology devices now owned by the sysbus?

Yes it is so we see it on the qtree with its properties.


> If so, is it fine to have a pointer to it S390CcwMachineState?

Why not?
It seems logical to me that the sysbus belong to the virtual machine.
But sometime the way of QEMU are not very transparent for me :)
so I can be wrong.

Regards,
Pierre

>> +
>> +    return dev;
>> +}
>> +
> [...]

-- 
Pierre Morel
IBM Lab Boeblingen
