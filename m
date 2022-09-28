Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8B35ED778
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 10:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbiI1IRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 04:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbiI1IQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 04:16:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69AA8B2CB
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 01:15:53 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28S8AIFD021624;
        Wed, 28 Sep 2022 08:15:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WF3+TiSTGRpzyY5Df9WZgnXBJUWaiUHQ1BOOyxTTxcY=;
 b=TJkkikOr+pLY/UNtsd90dbLg1DvU6wh+YLOXSJZK+wFJ8hwRFpUlaUOwm53COjLq2XUs
 nklvG+3Bh3s+9Iv4zVm3+IyBVO4lm/RPPisg0rl570SDtz3PL6tuA8mlyUK0OwAdkH7U
 Knd//HbUkFK4ZECciSYGTfIjSjDDs0/oTUTEUHBMW7L52U4g5PaP/0oBW+HmmBJGah5X
 1+gMb+TXyZD+d4M7T0k7EgnK32t8UFZFGYekiHMOYut7V03X3MU/BUyMCi5y5INPQd3w
 LqDVrSdoGZoIJhlZ/mVywyZe1RZwUdVW0AfJCZLBLVB4aFFLsYmQGPvt3dzwF5HkPvDb SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvgkmbfnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:15:40 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28S8FVi2012159;
        Wed, 28 Sep 2022 08:15:40 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvgkmbfmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:15:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28S86GhF015023;
        Wed, 28 Sep 2022 08:15:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3jss5hupq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 08:15:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28S8FYlM4522650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 08:15:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 600414C046;
        Wed, 28 Sep 2022 08:15:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B5534C04A;
        Wed, 28 Sep 2022 08:15:33 +0000 (GMT)
Received: from [9.171.31.212] (unknown [9.171.31.212])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 08:15:33 +0000 (GMT)
Message-ID: <803ab5a6-5c74-02c6-a2c2-a4a49c818b39@linux.ibm.com>
Date:   Wed, 28 Sep 2022 10:15:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v9 09/10] s390x/cpu_topology: activating CPU topology
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-10-pmorel@linux.ibm.com>
 <b54249b3-3639-80e9-3c5c-f556e605e6e6@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b54249b3-3639-80e9-3c5c-f556e605e6e6@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N7-vJSJziYTwnzoWqkPnFqeujZ9egaZr
X-Proofpoint-ORIG-GUID: 78jc9sjfUwk2hKF4ALViiJWEgFXqGs1k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_03,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 clxscore=1011 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280048
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Cedric,

On 9/27/22 16:41, Cédric Le Goater wrote:
> On 9/2/22 09:55, Pierre Morel wrote:
>> Starting with a new machine, s390-virtio-ccw-7.2, the machine
>> property topology-disable is set to false while it is kept to
>> true for older machine.
> 
> We probably need a machine class option also because we don't want
> this to be possible :
> 
>     -M s390-ccw-virtio-7.1,topology-disable=false

hum, you are right it has little interest to do this.

> 
> 
>> This allows migrating older machine without disabling the ctop
>> CPU feature for older machine, thus keeping existing start scripts.
>>
>> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
>> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
>> the topology facility for the guest in the case the topology
>> is not disabled.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/core/machine.c                  |  5 +++
>>   hw/s390x/s390-virtio-ccw.c         | 55 ++++++++++++++++++++++++++----
>>   include/hw/boards.h                |  3 ++
>>   include/hw/s390x/s390-virtio-ccw.h |  1 +
>>   target/s390x/kvm/kvm.c             | 14 ++++++++
>>   5 files changed, 72 insertions(+), 6 deletions(-)
>>
>> diff --git a/hw/core/machine.c b/hw/core/machine.c
>> index 4c5c8d1655..cbcdd40763 100644
>> --- a/hw/core/machine.c
>> +++ b/hw/core/machine.c
>> @@ -40,6 +40,11 @@
>>   #include "hw/virtio/virtio-pci.h"
>>   #include "qom/object_interfaces.h"
>> +GlobalProperty hw_compat_7_1[] = {
>> +    { "s390x-cpu", "ctop", "off"},
>> +};
>> +const size_t hw_compat_7_1_len = G_N_ELEMENTS(hw_compat_7_1);
>> +
>>   GlobalProperty hw_compat_7_0[] = {
>>       { "arm-gicv3-common", "force-8-bit-prio", "on" },
>>       { "nvme-ns", "eui64-default", "on"},
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index 1fa98740de..3078e68df7 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -249,11 +249,16 @@ static void ccw_init(MachineState *machine)
>>       /* init memory + setup max page size. Required for the CPU model */
>>       s390_memory_init(machine->ram);
>> -    /* Adding the topology must be done before CPU intialization*/
>> -    dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
>> -    object_property_add_child(qdev_get_machine(), 
>> TYPE_S390_CPU_TOPOLOGY,
>> -                              OBJECT(dev));
>> -    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>> +    /*
>> +     * Adding the topology must be done before CPU intialization but
>> +     * only in the case it is not disabled for migration purpose.
>> +     */
>> +    if (!S390_CCW_MACHINE(machine)->topology_disable) {
>> +        dev = qdev_new(TYPE_S390_CPU_TOPOLOGY);
>> +        object_property_add_child(qdev_get_machine(), 
>> TYPE_S390_CPU_TOPOLOGY,
>> +                                  OBJECT(dev));
>> +        sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>> +    }
>>       /* init CPUs (incl. CPU model) early so s390_has_feature() works */
>>       s390_init_cpus(machine);
>> @@ -676,6 +681,21 @@ static inline void 
>> machine_set_zpcii_disable(Object *obj, bool value,
>>       ms->zpcii_disable = value;
>>   }
>> +static inline bool machine_get_topology_disable(Object *obj, Error 
>> **errp)
>> +{
>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
>> +
>> +    return ms->topology_disable;
>> +}
>> +
>> +static inline void machine_set_topology_disable(Object *obj, bool value,
>> +                                                Error **errp)
>> +{
>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
>> +
>> +    ms->topology_disable = value;
>> +}
>> +
>>   static S390CcwMachineClass *current_mc;
>>   /*
>> @@ -778,6 +798,13 @@ static inline void s390_machine_initfn(Object *obj)
>>       object_property_set_description(obj, "zpcii-disable",
>>               "disable zPCI interpretation facilties");
>>       object_property_set_bool(obj, "zpcii-disable", false, NULL);
>> +
>> +    object_property_add_bool(obj, "topology-disable",
>> +                             machine_get_topology_disable,
>> +                             machine_set_topology_disable);
>> +    object_property_set_description(obj, "topology-disable",
>> +            "disable zPCI interpretation facilties");
>> +    object_property_set_bool(obj, "topology-disable", false, NULL);
>>   }
>>   static const TypeInfo ccw_machine_info = {
>> @@ -830,14 +857,29 @@ bool css_migration_enabled(void)
>>       
>> }                                                                         \
>>       type_init(ccw_machine_register_##suffix)
>> +static void ccw_machine_7_2_instance_options(MachineState *machine)
>> +{
>> +}
>> +
>> +static void ccw_machine_7_2_class_options(MachineClass *mc)
>> +{
>> +}
>> +DEFINE_CCW_MACHINE(7_2, "7.2", true);
>> +
>>   static void ccw_machine_7_1_instance_options(MachineState *machine)
>>   {
>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
>> +
>> +    ccw_machine_7_2_instance_options(machine);
>> +    ms->topology_disable = true;
>>   }
>>   static void ccw_machine_7_1_class_options(MachineClass *mc)
>>   {
>> +    ccw_machine_7_2_class_options(mc);
>> +    compat_props_add(mc->compat_props, hw_compat_7_1, 
>> hw_compat_7_1_len);
>>   }
>> -DEFINE_CCW_MACHINE(7_1, "7.1", true);
>> +DEFINE_CCW_MACHINE(7_1, "7.1", false);
>>   static void ccw_machine_7_0_instance_options(MachineState *machine)
>>   {
>> @@ -847,6 +889,7 @@ static void 
>> ccw_machine_7_0_instance_options(MachineState *machine)
>>       ccw_machine_7_1_instance_options(machine);
>>       s390_set_qemu_cpu_model(0x8561, 15, 1, qemu_cpu_feat);
>>       ms->zpcii_disable = true;
>> +
>>   }
>>   static void ccw_machine_7_0_class_options(MachineClass *mc)
>> diff --git a/include/hw/boards.h b/include/hw/boards.h
>> index 69e20c1252..6e9803aa2d 100644
>> --- a/include/hw/boards.h
>> +++ b/include/hw/boards.h
>> @@ -387,6 +387,9 @@ struct MachineState {
>>       } \
>>       type_init(machine_initfn##_register_types)
>> +extern GlobalProperty hw_compat_7_1[];
>> +extern const size_t hw_compat_7_1_len;
>> +
>>   extern GlobalProperty hw_compat_7_0[];
>>   extern const size_t hw_compat_7_0_len;
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h 
>> b/include/hw/s390x/s390-virtio-ccw.h
>> index 9e7a0d75bc..b14660eecb 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>>       bool dea_key_wrap;
>>       bool pv;
>>       bool zpcii_disable;
>> +    bool topology_disable;
>>       uint8_t loadparm[8];
>>   };
>> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
>> index cb14bcc012..6b7efee511 100644
>> --- a/target/s390x/kvm/kvm.c
>> +++ b/target/s390x/kvm/kvm.c
>> @@ -2385,6 +2385,7 @@ bool kvm_s390_cpu_models_supported(void)
>>   void kvm_s390_get_host_cpu_model(S390CPUModel *model, Error **errp)
>>   {
>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(qdev_get_machine());
>>       struct kvm_s390_vm_cpu_machine prop = {};
>>       struct kvm_device_attr attr = {
>>           .group = KVM_S390_VM_CPU_MODEL,
>> @@ -2466,6 +2467,19 @@ void kvm_s390_get_host_cpu_model(S390CPUModel 
>> *model, Error **errp)
>>           set_bit(S390_FEAT_UNPACK, model->features);
>>       }
>> +    /*
>> +     * If we have the CPU Topology implemented in KVM activate
>> +     * the CPU TOPOLOGY feature.
>> +     */
>> +    if ((!ms->topology_disable) &&
> 
> 'topology_disable' is a platform level configuration. May be instead,
> the feature could be cleared at the machine level ?

thanks, I will try this way.

regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen
