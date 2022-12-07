Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84396456FF
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 11:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiLGKAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 05:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiLGKAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 05:00:35 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9B63E087
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 02:00:33 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B79M5Ot001333;
        Wed, 7 Dec 2022 10:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VvEVt8sset1UIfIRXH/O8Z7oILc9wDDZCb0VOkxpzFo=;
 b=f6IEkxRF8xpZ8ba2SX5LetJmuqP2B87wwjwzelaADIZS9C1410BH3ceQrPk+1RK24dd1
 qXPCVNbdtbvgLhe9qeADiq6c+Iv3bjHSr3dP49wuKBTm1MS8myVcLJTNoGIphP3veE0Y
 eb1Y8cqfYRM2p990+66eB04OsAeV6m/cWVR4qZUoLmcZRpxPt4IQ+/AzgB/Egj/z/gMZ
 J4D0PJmxwM9mj/lrKClA6kGXjwSWFrFRQXQwqCsHFbGHY7rbT2g53LR84LPlP6bfyu1h
 ID/lu+Du7fGJ5chmQbbCrDZG2Gbvy+KkybXxlUndEqk7DGzTHcVrnK9wZsHBNkAxA61v SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mar4vrufk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 10:00:24 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B79RBFq019387;
        Wed, 7 Dec 2022 10:00:23 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mar4vrudy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 10:00:23 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2B78o2T1004862;
        Wed, 7 Dec 2022 10:00:21 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3m9pv9suf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 10:00:21 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B7A0H2m22217048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Dec 2022 10:00:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A64442005A;
        Wed,  7 Dec 2022 10:00:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50F7320043;
        Wed,  7 Dec 2022 10:00:16 +0000 (GMT)
Received: from [9.171.6.120] (unknown [9.171.6.120])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Dec 2022 10:00:16 +0000 (GMT)
Message-ID: <1c63d7e3-008b-5347-02eb-538e091f3639@linux.ibm.com>
Date:   Wed, 7 Dec 2022 11:00:16 +0100
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
 <cb4abea1-b585-2753-12e9-6b75999d7d2e@linux.ibm.com>
 <3f6f1ab828c9608fabf7ad855098cd6cae1874c4.camel@linux.ibm.com>
 <ffb9b474-e29d-c790-611e-549846b939e4@linux.ibm.com>
 <34e774fc372e41f352ccf03761a78eff22728f89.camel@linux.ibm.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <34e774fc372e41f352ccf03761a78eff22728f89.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XCBByXkLT3B9eauZok5L9tIu_08MD_xY
X-Proofpoint-ORIG-GUID: wsdTc7qWLTVlmJ08w-PmEdY0oBhitXgq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_04,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212070080
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/22 22:06, Janis Schoetterl-Glausch wrote:
> On Tue, 2022-12-06 at 15:35 +0100, Pierre Morel wrote:
>>
>> On 12/6/22 14:35, Janis Schoetterl-Glausch wrote:
>>> On Tue, 2022-12-06 at 11:32 +0100, Pierre Morel wrote:
>>>>
>>>> On 12/6/22 10:31, Janis Schoetterl-Glausch wrote:
>>>>> On Tue, 2022-11-29 at 18:42 +0100, Pierre Morel wrote:
>>>>>> We will need a Topology device to transfer the topology
>>>>>> during migration and to implement machine reset.
>>>>>>
>>>>>> The device creation is fenced by s390_has_topology().
>>>>>>
>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>> ---
>>>>>>     include/hw/s390x/cpu-topology.h    | 44 +++++++++++++++
>>>>>>     include/hw/s390x/s390-virtio-ccw.h |  1 +
>>>>>>     hw/s390x/cpu-topology.c            | 87 ++++++++++++++++++++++++++++++
>>>>>>     hw/s390x/s390-virtio-ccw.c         | 25 +++++++++
>>>>>>     hw/s390x/meson.build               |  1 +
>>>>>>     5 files changed, 158 insertions(+)
>>>>>>     create mode 100644 include/hw/s390x/cpu-topology.h
>>>>>>     create mode 100644 hw/s390x/cpu-topology.c
>>>>>
> [...]
>>>>>>     
>>>>>> +static DeviceState *s390_init_topology(MachineState *machine, Error **errp)
>>>>>> +{
>>>>>> +    DeviceState *dev;
>>>>>> +
>>>>>> +    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
>>>>>> +
>>>>>> +    object_property_add_child(&machine->parent_obj,
>>>>>> +                              TYPE_S390_CPU_TOPOLOGY, OBJECT(dev));
>>>>>
>>>>> Why set this property, and why on the machine parent?
>>>>
>>>> For what I understood setting the num_cores and num_sockets as
>>>> properties of the CPU Topology object allows to have them better
>>>> integrated in the QEMU object framework.
>>>
>>> That I understand.
>>>>
>>>> The topology is added to the S390CcwmachineState, it is the parent of
>>>> the machine.
>>>
>>> But why? And is it added to the S390CcwMachineState, or its parent?
>>
>> it is added to the S390CcwMachineState.
>> We receive the MachineState as the "machine" parameter here and it is
>> added to the "machine->parent_obj" which is the S390CcwMachineState.
> 
> Oh, I was confused. &machine->parent_obj is just a cast of MachineState* to Object*.
> It's the very same object.
> And what is the reason to add the topology as child property?
> Just so it shows up in the qtree? Wouldn't it anyway under the sysbus?

Yes it would appear on the info qtree but not in the qom-tree


>>
>>
>>
>>>>
>>>>
>>>>>
>>>>>> +    object_property_set_int(OBJECT(dev), "num-cores",
>>>>>> +                            machine->smp.cores * machine->smp.threads, errp);
>>>>>> +    object_property_set_int(OBJECT(dev), "num-sockets",
>>>>>> +                            machine->smp.sockets, errp);
>>>>>> +
>>>>>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), errp);
>>>>>
>>>>> I must admit that I haven't fully grokked qemu's memory management yet.
>>>>> Is the topology devices now owned by the sysbus?
>>>>
>>>> Yes it is so we see it on the qtree with its properties.
>>>>
>>>>
>>>>> If so, is it fine to have a pointer to it S390CcwMachineState?
>>>>
>>>> Why not?
>>>
>>> If it's owned by the sysbus and the object is not explicitly referenced
>>> for the pointer, it might be deallocated and then you'd have a dangling pointer.
>>
>> Why would it be deallocated ?
> 
> That's beside the point, if you transfer ownership, you have no control over when
> the deallocation happens.
> It's going to be fine in practice, but I don't think you should rely on it.
> I think you could just do sysbus_realize instead of ..._and_unref,
> but like I said, I haven't fully understood qemu memory management.
> (It would also leak in a sense, but since the machine exists forever that should be fine)

If I understand correctly:

- qdev_new adds a reference count to the new created object, dev.

- object_property_add_child adds a reference count to the child also 
here the new created device dev so the ref count of dev is 2 .

after the unref on dev, the ref count of dev get down to 1

then it seems OK. Did I miss something?

Regards,
Pierre

> 
>> as long it is not unrealized it belongs to the sysbus doesn't it?
>>
>> Regards,
>> Pierre
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
