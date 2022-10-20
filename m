Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18AF606275
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 16:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJTOIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 10:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJTOID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 10:08:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0DB170B40
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 07:08:01 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KE3dCb025909;
        Thu, 20 Oct 2022 14:07:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=39hzu+DwyXr3PJvAbHKBwjmsvsTqf1cGqLD6b5xQbLk=;
 b=HIOwlSrgFzkO1wFY+x8FKlT++SZG6nntpi/qWR6yFtbgjclyK/sN4r949zcZNhfyNyIx
 3d5p243uczJ4syI+doWhz5mzhumq79PyN6411sAqY/ZEbfBnNyzE7kqGvGLr3gvTdg8K
 v4sGScW7I7AVEr3o+HMZ7r1rU0cdLW/oGlkcGGJDS/EbRJw59fqrgmjQ/z8HUSJa3cAr
 Q6EKP32MMWncJl5O7y+bx17OQkMUW6V/Fqe8WrjFmkeYk80XVkL4bVXzddsnZtaDH9QK
 Z20QHGZGmCbcda7TQwlZt90tleTcqvZTEMtWZnlurV1X3RXsPXz8kieW+ou5MgC13c4p KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb7rrgcm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:07:48 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KE3tIL027732;
        Thu, 20 Oct 2022 14:07:39 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb7rrgbsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:07:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KDpD9Q018788;
        Thu, 20 Oct 2022 14:01:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg9925k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:01:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KE1oLw36504026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 14:01:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3AD44C044;
        Thu, 20 Oct 2022 14:01:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8C4F4C046;
        Thu, 20 Oct 2022 14:01:49 +0000 (GMT)
Received: from [9.171.54.135] (unknown [9.171.54.135])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 14:01:49 +0000 (GMT)
Message-ID: <e5ffddff-ace3-a1e6-5657-37d6e42193fc@linux.ibm.com>
Date:   Thu, 20 Oct 2022 16:01:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v10 6/9] s390x/cpu topology: add topology-disable machine
 property
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
 <20221012162107.91734-7-pmorel@linux.ibm.com>
 <08bbd6f8-6ae3-4a28-66ed-d5a290c1a30d@kaod.org>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <08bbd6f8-6ae3-4a28-66ed-d5a290c1a30d@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PZzwmeuqCbEI-zVuGe-WV5tScL7QFQGH
X-Proofpoint-ORIG-GUID: AIRC0GslVfXCbAZqsPfpzS1wSyqmmBvH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_05,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/18/22 19:34, Cédric Le Goater wrote:
> On 10/12/22 18:21, Pierre Morel wrote:
>> S390 CPU topology is only allowed for s390-virtio-ccw-7.3 and
>> newer S390 machines.
>> We keep the possibility to disable the topology on these newer
>> machines with the property topology-disable.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/boards.h                |  3 ++
>>   include/hw/s390x/cpu-topology.h    | 18 +++++++++-
>>   include/hw/s390x/s390-virtio-ccw.h |  2 ++
>>   hw/core/machine.c                  |  5 +++
>>   hw/s390x/s390-virtio-ccw.c         | 53 +++++++++++++++++++++++++++++-
>>   util/qemu-config.c                 |  4 +++
>>   qemu-options.hx                    |  6 +++-
>>   7 files changed, 88 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/hw/boards.h b/include/hw/boards.h
>> index 311ed17e18..67147c47bf 100644
>> --- a/include/hw/boards.h
>> +++ b/include/hw/boards.h
>> @@ -379,6 +379,9 @@ struct MachineState {
>>       } \
>>       type_init(machine_initfn##_register_types)
>> +extern GlobalProperty hw_compat_7_2[];
>> +extern const size_t hw_compat_7_2_len;
> 
> QEMU 7.2 is not out yet.

OK, thanks, I will use 7.2 instead of 7.3 as the new machine.
We see later if it goes to 8.0

> 
>> +
>>   extern GlobalProperty hw_compat_7_1[];
>>   extern const size_t hw_compat_7_1_len;
>> diff --git a/include/hw/s390x/cpu-topology.h 
>> b/include/hw/s390x/cpu-topology.h
>> index 35a8a981ec..747c9ab4c6 100644
>> --- a/include/hw/s390x/cpu-topology.h
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -12,6 +12,8 @@
>>   #include "hw/qdev-core.h"
>>   #include "qom/object.h"
>> +#include "cpu.h"
>> +#include "hw/s390x/s390-virtio-ccw.h"
>>   #define S390_TOPOLOGY_POLARITY_H  0x00
>> @@ -43,7 +45,21 @@ void s390_topology_new_cpu(int core_id);
>>   static inline bool s390_has_topology(void)
>>   {
>> -    return false;
>> +    static S390CcwMachineState *ccw;
> 
> hmm, s390_has_topology is a static inline. It would be preferable to
> change its definition to extern.

OK

> 
>> +    Object *obj;
>> +
>> +    if (ccw) {
>> +        return !ccw->topology_disable;
>> +    }
>> +
>> +    /* we have to bail out for the "none" machine */
>> +    obj = object_dynamic_cast(qdev_get_machine(),
>> +                              TYPE_S390_CCW_MACHINE);
>> +    if (!obj) {
>> +        return false;
>> +    }
>> +    ccw = S390_CCW_MACHINE(obj);
>> +    return !ccw->topology_disable;
>>   }
>>   #endif
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h 
>> b/include/hw/s390x/s390-virtio-ccw.h
>> index 9e7a0d75bc..6c4b4645fc 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>>       bool dea_key_wrap;
>>       bool pv;
>>       bool zpcii_disable;
>> +    bool topology_disable;
>>       uint8_t loadparm[8];
>>   };
>> @@ -46,6 +47,7 @@ struct S390CcwMachineClass {
>>       bool cpu_model_allowed;
>>       bool css_migration_enabled;
>>       bool hpage_1m_allowed;
>> +    bool topology_allowed;
> 
> 'topology_disable' in the state and 'topology_allowed' in the class.
> This is confusing :/
> 
> you should add 'topology_allowed' in its own patch and maybe call
> it 'topology_capable' ? it is a QEMU capability AIUI

yes, OK, I separate the two.

. topology_capable to know if the QEMU version is capable of handling 
topology

- topology_disable for migration if KVM is not able to handle the 
topology on one of the machines involved.

> 
>>   };
>>   /* runtime-instrumentation allowed by the machine */
>> diff --git a/hw/core/machine.c b/hw/core/machine.c
>> index aa520e74a8..93c497655e 100644
>> --- a/hw/core/machine.c
>> +++ b/hw/core/machine.c
>> @@ -40,6 +40,11 @@
>>   #include "hw/virtio/virtio-pci.h"
>>   #include "qom/object_interfaces.h"
>> +GlobalProperty hw_compat_7_2[] = {
>> +    { "s390-topology", "topology-disable", "true" },
> 
> May be use TYPE_S390_CPU_TOPOLOGY instead.
> 
> But again, this should only apply to 7.1 machines and below. 7.2 is
> not out yet.

OK

> 
> 
>> +};
>> +const size_t hw_compat_7_2_len = G_N_ELEMENTS(hw_compat_7_2);
>> +
>>   GlobalProperty hw_compat_7_1[] = {};
>>   const size_t hw_compat_7_1_len = G_N_ELEMENTS(hw_compat_7_1);
>> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
>> index 362378454a..3a13fad4df 100644
>> --- a/hw/s390x/s390-virtio-ccw.c
>> +++ b/hw/s390x/s390-virtio-ccw.c
>> @@ -616,6 +616,7 @@ static void ccw_machine_class_init(ObjectClass 
>> *oc, void *data)
>>       s390mc->cpu_model_allowed = true;
>>       s390mc->css_migration_enabled = true;
>>       s390mc->hpage_1m_allowed = true;
>> +    s390mc->topology_allowed = true;
>>       mc->init = ccw_init;
>>       mc->reset = s390_machine_reset;
>>       mc->block_default_type = IF_VIRTIO;
>> @@ -726,6 +727,27 @@ bool hpage_1m_allowed(void)
>>       return get_machine_class()->hpage_1m_allowed;
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
>> +    if (!get_machine_class()->topology_allowed) {
>> +        error_setg(errp, "Property topology-disable not available on 
>> machine %s",
>> +                   get_machine_class()->parent_class.name);
> 
> OK. I get it now. May be we should consider adding the capability concept
> David introduced in the pseries machine. Please take a look. That's not
> for this patchset though. It would be too much work.

Yes, interesting, would be something to do in the near future.

> 
>> +        return;
>> +    }
>> +
>> +    ms->topology_disable = value;
>> +}
>> +
>>   static char *machine_get_loadparm(Object *obj, Error **errp)
>>   {
>>       S390CcwMachineState *ms = S390_CCW_MACHINE(obj);
>> @@ -784,6 +806,13 @@ static inline void s390_machine_initfn(Object *obj)
>>       object_property_set_description(obj, "zpcii-disable",
>>               "disable zPCI interpretation facilties");
>>       object_property_set_bool(obj, "zpcii-disable", false, NULL);
>> +
>> +    object_property_add_bool(obj, "topology-disable",
>> +                             machine_get_topology_disable,
>> +                             machine_set_topology_disable);
>> +    object_property_set_description(obj, "topology-disable",
>> +            "disable CPU topology");
>> +    object_property_set_bool(obj, "topology-disable", false, NULL);
> 
> All the properties should be added in the machine class_init routine.
> There is a preliminary cleanup patch required to move them all :/

OK, I will move it to the class_init


>>   }
>>   static const TypeInfo ccw_machine_info = {
>> @@ -836,14 +865,36 @@ bool css_migration_enabled(void)
>>       
>> }                                                                         \
>>       type_init(ccw_machine_register_##suffix)
>> +static void ccw_machine_7_3_instance_options(MachineState *machine)
>> +{
>> +}
>> +
>> +static void ccw_machine_7_3_class_options(MachineClass *mc)
>> +{
>> +}
>> +DEFINE_CCW_MACHINE(7_3, "7.3", true);
> 
> That's too early.
> 
>> +
>>   static void ccw_machine_7_2_instance_options(MachineState *machine)
>>   {
>> +    S390CcwMachineState *ms = S390_CCW_MACHINE(machine);
>> +
>> +    ccw_machine_7_3_instance_options(machine);
>> +    ms->topology_disable = true;
>>   }
>>   static void ccw_machine_7_2_class_options(MachineClass *mc)
>>   {
>> +    S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
>> +    static GlobalProperty compat[] = {
>> +        { TYPE_S390_CPU_TOPOLOGY, "topology-allowed", "off", },
> 
> hmm, "topology-allowed" is not a TYPE_S390_CPU_TOPOLOGY property.

I do not understand what I did there and why.
I guess I better do nothing there.

Thanks for the comments,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
