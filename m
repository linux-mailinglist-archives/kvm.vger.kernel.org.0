Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3546EDE78
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 10:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjDYIr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 04:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbjDYIr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 04:47:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94729CC3F
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 01:46:00 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33P8hiR7002296;
        Tue, 25 Apr 2023 08:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nPKv9ZAPAQuf69tA2yNDv+zouse37br2lRSRdQ7TSoU=;
 b=SOiRvka4+dD9uCE/aUW9IkrbcV3iC+HapZZ5itAW+iMyYJM7HBQfyExrsSzYazguoxbz
 XG1Tf86llPtkQjQ7G3tYxe9geXTzps/2D2D/88w3MJDkgJGCwhQaVTM8mtFq4M4aGiV7
 4wqRwbx9DSS9v3JZWUlEKYhdvPHVG79z8EyRnAxzUqshP9kmlKTRmilSnE7Ie0wDsQz5
 JiiNpwiTNkR0c0+thLn14S+RnKQllnEZi313Fm3RasTGL8D3fi6RQ1uYPs5rEcnNp+vX
 HIJ8gK0HcnXntYMmFwkm7fXI2x7Sqbv/9XyQI+DaOoDFzyw0Gak2/OMGuz8ektaLF8hM Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6bkx8277-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 08:45:46 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33P8jCfc008259;
        Tue, 25 Apr 2023 08:45:45 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6bkx825w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 08:45:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33P46tOw003680;
        Tue, 25 Apr 2023 08:45:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3q47771b9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 08:45:43 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33P8jcJ848169406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 08:45:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF6D620043;
        Tue, 25 Apr 2023 08:45:37 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56C8920040;
        Tue, 25 Apr 2023 08:45:37 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 25 Apr 2023 08:45:37 +0000 (GMT)
Message-ID: <9c2cb730-d307-f344-35e8-82017681816a@linux.ibm.com>
Date:   Tue, 25 Apr 2023 10:45:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 02/21] s390x/cpu topology: add topology entries on CPU
 hotplug
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-3-pmorel@linux.ibm.com>
 <66d9ba0e9904f035326aca609a767976b94547cf.camel@linux.ibm.com>
 <4ddd3177-58a8-c9f0-a9a8-ee71baf0511b@linux.ibm.com>
 <60aafc95dd0293ba8d5b4dbdc59fcda5e6c64f3e.camel@linux.ibm.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <60aafc95dd0293ba8d5b4dbdc59fcda5e6c64f3e.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -bsU6uGsoZAYYv-UHzGVIY5KW5VpKzOh
X-Proofpoint-ORIG-GUID: oIczCWFr5KchYLr4MVssOKdewKebH5XL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_03,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250068
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/24/23 17:32, Nina Schoetterl-Glausch wrote:
> On Fri, 2023-04-21 at 12:20 +0200, Pierre Morel wrote:
>>> On 4/20/23 10:59, Nina Schoetterl-Glausch wrote:
>>>>> On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
[..]
>>> In the next version with entitlement being an enum it is right.
>>>
>>> However, deleting this means that the default value for entitlement
>>> depends on dedication.
>>>
>>> If we have only low, medium, high and default for entitlement is medium.
>>>
>>> If the user specifies the dedication true without specifying entitlement
>>> we could force entitlement to high.
>>>
>>> But we can not distinguish this from the user specifying dedication true
>>> with a medium entitlement, which is wrong.
>>>
>>> So three solution:
>>>
>>> 1) We ignore what the user say if dedication is specified as true
>>>
>>> 2) We specify that both dedication and entitlement must be specified if
>>> dedication is true
>>>
>>> 3) We set an impossible default to distinguish default from medium
>>> entitlement
>>>
>>>
>>> For me the solution 3 is the best one, it is more flexible for the user.
>>>
>>> Solution 1 is obviously bad.
>>>
>>> Solution 2 forces the user to specify entitlement high and only high if
>>> it specifies dedication true.
>>>
>>> AFAIU, you prefer the solution 2, forcing user to specify both
>>> dedication and entitlement to suppress a default value in the enum.
>>> Why is it bad to have a default value in the enum that we do not use to
>>> specify that the value must be calculated?
> Yes, I'd prefer solution 2. I don't like adapting the internal state where only
> the three values make sense for the user interface.
> It also keeps things simple and requires less code.
> I also don't think it's a bad thing for the user, as it's not a thing done manually often.
> I'm also not a fan of a value being implicitly being changed even though it doesn't look
> like it from the command.
>
> However, what I really don't like is the additional state and naming it "horizontal",


No problem to use another name like "auto" as you propose later.


> not so much the adjustment if dedication is switched to true without an entitlement given.
> For the monitor command there is no problem, you currently have:


That is clear, the has_xxx does the job.

[..]


> So you can just set it if (!has_entitlement).
> There is also ways to set the value for cpus defined on the command line, e.g.:


Yes, thanks, I already said I find your proposition to use a 
DEFINE_PROP_CPUS390ENTITLEMENT good and will use it.


>
> diff --git a/include/hw/qdev-properties-system.h b/include/hw/qdev-properties-system.h
> index 0ac327ae60..41a605c5a7 100644
> --- a/include/hw/qdev-properties-system.h
> +++ b/include/hw/qdev-properties-system.h
> @@ -22,6 +22,7 @@ extern const PropertyInfo qdev_prop_audiodev;
>   extern const PropertyInfo qdev_prop_off_auto_pcibar;
>   extern const PropertyInfo qdev_prop_pcie_link_speed;
>   extern const PropertyInfo qdev_prop_pcie_link_width;
> +extern const PropertyInfo qdev_prop_cpus390entitlement;
>   
>   #define DEFINE_PROP_PCI_DEVFN(_n, _s, _f, _d)                   \
>       DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_pci_devfn, int32_t)
> @@ -73,5 +74,8 @@ extern const PropertyInfo qdev_prop_pcie_link_width;
>   #define DEFINE_PROP_UUID_NODEFAULT(_name, _state, _field) \
>       DEFINE_PROP(_name, _state, _field, qdev_prop_uuid, QemuUUID)
>   
> +#define DEFINE_PROP_CPUS390ENTITLEMENT(_n, _s, _f) \
> +    DEFINE_PROP(_n, _s, _f, qdev_prop_cpus390entitlement, int)
> +
>   
>   #endif
> diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> index 54541d2230..01308e0b94 100644
> --- a/target/s390x/cpu.h
> +++ b/target/s390x/cpu.h
> @@ -135,7 +135,7 @@ struct CPUArchState {
>       int32_t book_id;
>       int32_t drawer_id;
>       bool dedicated;
> -    uint8_t entitlement;        /* Used only for vertical polarization */
> +    int entitlement;        /* Used only for vertical polarization */


Isn't it better to use:

+    CpuS390Entitlement entitlement; /* Used only for vertical 
polarization */


>       uint64_t cpuid;
>   #endif
>   
> diff --git a/hw/core/qdev-properties-system.c b/hw/core/qdev-properties-system.c
> index d42493f630..db5c3d4fe6 100644
> --- a/hw/core/qdev-properties-system.c
> +++ b/hw/core/qdev-properties-system.c
> @@ -1143,3 +1143,14 @@ const PropertyInfo qdev_prop_uuid = {
>       .set   = set_uuid,
>       .set_default_value = set_default_uuid_auto,
>   };
> +
> +/* --- s390x cpu topology entitlement --- */
> +
> +QEMU_BUILD_BUG_ON(sizeof(CpuS390Entitlement) != sizeof(int));
> +
> +const PropertyInfo qdev_prop_cpus390entitlement = {
> +    .name = "CpuS390Entitlement",
> +    .enum_table = &CpuS390Entitlement_lookup,
> +    .get   = qdev_propinfo_get_enum,
> +    .set   = qdev_propinfo_set_enum,
> +};
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index b8a292340c..1b3f5c61ae 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -199,8 +199,7 @@ static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
>        * is not dedicated.
>        * A dedicated CPU always receives a high entitlement.
>        */
> -    if (env->entitlement >= S390_CPU_ENTITLEMENT__MAX ||
> -        env->entitlement == S390_CPU_ENTITLEMENT_HORIZONTAL) {
> +    if (env->entitlement < 0) {


Here we can have:

+    if (env->entitlement == S390_CPU_ENTITLEMENT_AUTO) {
...

>           if (env->dedicated) {
>               env->entitlement = S390_CPU_ENTITLEMENT_HIGH;
>           } else {
> diff --git a/target/s390x/cpu.c b/target/s390x/cpu.c
> index 57165fa3a0..dea50a3e06 100644
> --- a/target/s390x/cpu.c
> +++ b/target/s390x/cpu.c
> @@ -31,6 +31,7 @@
>   #include "qapi/qapi-types-machine.h"
>   #include "sysemu/hw_accel.h"
>   #include "hw/qdev-properties.h"
> +#include "hw/qdev-properties-system.h"
>   #include "fpu/softfloat-helpers.h"
>   #include "disas/capstone.h"
>   #include "sysemu/tcg.h"
> @@ -248,6 +249,7 @@ static void s390_cpu_initfn(Object *obj)
>       cs->exception_index = EXCP_HLT;
>   
>   #if !defined(CONFIG_USER_ONLY)
> +    cpu->env.entitlement = -1;


Then we do not need this initialization if here under we define 
DEFINE_PROP_CPUS390ENTITLEMENT differently


>       s390_cpu_init_sysemu(obj);
>   #endif
>   }
> @@ -264,8 +266,7 @@ static Property s390x_cpu_properties[] = {
>       DEFINE_PROP_INT32("book-id", S390CPU, env.book_id, -1),
>       DEFINE_PROP_INT32("drawer-id", S390CPU, env.drawer_id, -1),
>       DEFINE_PROP_BOOL("dedicated", S390CPU, env.dedicated, false),
> -    DEFINE_PROP_UINT8("entitlement", S390CPU, env.entitlement,
> -                      S390_CPU_ENTITLEMENT__MAX),
> +    DEFINE_PROP_CPUS390ENTITLEMENT("entitlement", S390CPU, env.entitlement),


+    DEFINE_PROP_CPUS390ENTITLEMENT("entitlement", S390CPU, env.entitlement,
                                    S390_CPU_ENTITLEMENT_AUTO),

>   #endif
>       DEFINE_PROP_END_OF_LIST()
>   };
>
> There are other ways to achieve the same, you could also
> implement get, set and set_default_value so that there is an additional
> "auto"/"uninitialized" value that is not in the enum.
> If you insist on having an additional state in the enum, name it "auto".

Yes, I think it is a better name.


