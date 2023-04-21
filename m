Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914056EA83F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 12:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjDUKW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 06:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjDUKWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 06:22:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DBEAD17
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 03:21:26 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L9c6Dm020581;
        Fri, 21 Apr 2023 10:20:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CHyoc1nL94cwAgjwn9aRGY8k7rTNaRgymZY0um5quak=;
 b=UAZu+6Bk5pxm5c1AyMiy1XEDBJFDHxm/GRS3ezCWfczidzJF1aB/vI307sCbBQztCOpC
 ylBrULKg80MNgZ0kcga5qw+uWrAjbm6Lj+PILksN3WwvmB6YJUQshM3agoqkkjaPzl0E
 xEB1AGSz3/6scK3EOPL2y7AOgY5RuStbVhce6Ovv2S419oguTAat7Hkv/uwkRXw9uapS
 5xTzELnpZlNkg6OZwSTe4RU+KT+z6FGsKS0oGwjXbL1pjhw/lJtgCv3UmJggL4TTvOVM
 KEDwrKW7phjCg7TtEzYP+oN3h5zSjB1zOGzghylahmmHlQDM9cIl5zfJFKonbYCTxERG jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3qussudv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 10:20:41 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33LAJOIR010046;
        Fri, 21 Apr 2023 10:20:41 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3qussucd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 10:20:40 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33L0dMi4030533;
        Fri, 21 Apr 2023 10:20:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3pykj6k9mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 10:20:38 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33LAKWft3867188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 10:20:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5246E20075;
        Fri, 21 Apr 2023 10:20:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED14820076;
        Fri, 21 Apr 2023 10:20:30 +0000 (GMT)
Received: from [9.179.5.153] (unknown [9.179.5.153])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 21 Apr 2023 10:20:30 +0000 (GMT)
Message-ID: <4ddd3177-58a8-c9f0-a9a8-ee71baf0511b@linux.ibm.com>
Date:   Fri, 21 Apr 2023 12:20:30 +0200
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
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <66d9ba0e9904f035326aca609a767976b94547cf.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Mnk0jUmITtFWYs5ai7S1ztW7ORYff-n3
X-Proofpoint-ORIG-GUID: m1BbpUqSc-TPXVCMBYNfIqSxvy3bs8tM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_04,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210087
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/20/23 10:59, Nina Schoetterl-Glausch wrote:
> On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
>> The topology information are attributes of the CPU and are
>> specified during the CPU device creation.
>>
>> On hot plug we:
>> - calculate the default values for the topology for drawers,
>>    books and sockets in the case they are not specified.
>> - verify the CPU attributes
>> - check that we have still room on the desired socket
>>
>> The possibility to insert a CPU in a mask is dependent on the
>> number of cores allowed in a socket, a book or a drawer, the
>> checking is done during the hot plug of the CPU to have an
>> immediate answer.
>>
>> If the complete topology is not specified, the core is added
>> in the physical topology based on its core ID and it gets
>> defaults values for the modifier attributes.
>>
>> This way, starting QEMU without specifying the topology can
>> still get some advantage of the CPU topology.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   MAINTAINERS                        |   1 +
>>   include/hw/s390x/cpu-topology.h    |  44 +++++
>>   include/hw/s390x/s390-virtio-ccw.h |   1 +
>>   hw/s390x/cpu-topology.c            | 282 +++++++++++++++++++++++++++++
>>   hw/s390x/s390-virtio-ccw.c         |  22 ++-
>>   hw/s390x/meson.build               |   1 +
>>   6 files changed, 349 insertions(+), 2 deletions(-)
>>   create mode 100644 hw/s390x/cpu-topology.c
> [...]
>
>>   #endif
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-virtio-ccw.h
>> index 9bba21a916..ea10a6c6e1 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>>       bool dea_key_wrap;
>>       bool pv;
>>       uint8_t loadparm[8];
>> +    bool vertical_polarization;
> Why is this here and not in s390_topology?
> This splits up the topology state somewhat.
> I don't quite recall, did you use to have s390_topology in S390CcwMachineState at some point?
> I think putting everything in S390CcwMachineState might make sense too.

Hum.

This is a left over from an abandoned try.

I put it back where it was, in s390_topology.


>
>>   };
>>   
>>   struct S390CcwMachineClass {
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> new file mode 100644
>> index 0000000000..96da67bd7e
>> --- /dev/null
>> +++ b/hw/s390x/cpu-topology.c
> [...]
>
>> +/**
>> + * s390_topology_cpu_default:
>> + * @cpu: pointer to a S390CPU
>> + * @errp: Error pointer
>> + *
>> + * Setup the default topology if no attributes are already set.
>> + * Passing a CPU with some, but not all, attributes set is considered
>> + * an error.
>> + *
>> + * The function calculates the (drawer_id, book_id, socket_id)
>> + * topology by filling the cores starting from the first socket
>> + * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
>> + *
>> + * CPU type and dedication have defaults values set in the
>> + * s390x_cpu_properties, entitlement must be adjust depending on the
>> + * dedication.
>> + */
>> +static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
>> +{
>> +    CpuTopology *smp = s390_topology.smp;
>> +    CPUS390XState *env = &cpu->env;
>> +
>> +    /* All geometry topology attributes must be set or all unset */
>> +    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer_id < 0) &&
>> +        (env->socket_id >= 0 || env->book_id >= 0 || env->drawer_id >= 0)) {
>> +        error_setg(errp,
>> +                   "Please define all or none of the topology geometry attributes");
>> +        return;
>> +    }
>> +
>> +    /* Check if one of the geometry topology is unset */
>> +    if (env->socket_id < 0) {
>> +        /* Calculate default geometry topology attributes */
>> +        env->socket_id = s390_std_socket(env->core_id, smp);
>> +        env->book_id = s390_std_book(env->core_id, smp);
>> +        env->drawer_id = s390_std_drawer(env->core_id, smp);
>> +    }
>> +
>> +    /*
>> +     * Even the user can specify the entitlement as horizontal on the
>> +     * command line, qemu will only use env->entitlement during vertical
>> +     * polarization.
>> +     * Medium entitlement is chosen as the default entitlement when the CPU
>> +     * is not dedicated.
>> +     * A dedicated CPU always receives a high entitlement.
>> +     */
>> +    if (env->entitlement >= S390_CPU_ENTITLEMENT__MAX ||
>> +        env->entitlement == S390_CPU_ENTITLEMENT_HORIZONTAL) {
>> +        if (env->dedicated) {
>> +            env->entitlement = S390_CPU_ENTITLEMENT_HIGH;
>> +        } else {
>> +            env->entitlement = S390_CPU_ENTITLEMENT_MEDIUM;
>> +        }
>> +    }
> As you know, in my opinion there should be not possibility for the user
> to set the entitlement to horizontal and dedicated && != HIGH should be
> rejected as an error.
> If you do this, you can delete this.

In the next version with entitlement being an enum it is right.

However, deleting this means that the default value for entitlement 
depends on dedication.

If we have only low, medium, high and default for entitlement is medium.

If the user specifies the dedication true without specifying entitlement 
we could force entitlement to high.

But we can not distinguish this from the user specifying dedication true 
with a medium entitlement, which is wrong.

So three solution:

1) We ignore what the user say if dedication is specified as true

2) We specify that both dedication and entitlement must be specified if 
dedication is true

3) We set an impossible default to distinguish default from medium 
entitlement


For me the solution 3 is the best one, it is more flexible for the user.

Solution 1 is obviously bad.

Solution 2 forces the user to specify entitlement high and only high if 
it specifies dedication true.

AFAIU, you prefer the solution 2, forcing user to specify both 
dedication and entitlement to suppress a default value in the enum.
Why is it bad to have a default value in the enum that we do not use to 
specify that the value must be calculated?


>
>> +}
>> +
>> +/**
>> + * s390_topology_check:
>> + * @socket_id: socket to check
>> + * @book_id: book to check
>> + * @drawer_id: drawer to check
>> + * @entitlement: entitlement to check
>> + * @dedicated: dedication to check
>> + * @errp: Error pointer
>> + *
>> + * The function checks if the topology
>> + * attributes fits inside the system topology.
> fitS
>
> The function checks the validity of the provided topology arguments,
> namely that they're in bounds and non contradictory.


OK, thanks.


>
>> + */
>> +static void s390_topology_check(uint16_t socket_id, uint16_t book_id,
> I'd prefer if you stick to one id type. There defined as int32_t in env,
> here you use uint16_t and below int.
>
> In env, you want a signed type with sufficient range, int16_t should suffice there,
> but bigger is also fine.
> You don't want the user to pass a negative id, so by using an unsigned type you
> can avoid this without extra code.
> But IMO there should be one point where a type conversion occurs.

OK


>
>> +                                uint16_t drawer_id, uint16_t entitlement,
>> +                                bool dedicated, Error **errp)
>> +{
>> +    CpuTopology *smp = s390_topology.smp;
>> +    ERRP_GUARD();
>> +
>> +    if (socket_id >= smp->sockets) {
>> +        error_setg(errp, "Unavailable socket: %d", socket_id);
>> +        return;
>> +    }
>> +    if (book_id >= smp->books) {
>> +        error_setg(errp, "Unavailable book: %d", book_id);
>> +        return;
>> +    }
>> +    if (drawer_id >= smp->drawers) {
>> +        error_setg(errp, "Unavailable drawer: %d", drawer_id);
>> +        return;
>> +    }
>> +    if (entitlement >= S390_CPU_ENTITLEMENT__MAX) {
>> +        error_setg(errp, "Unknown entitlement: %d", entitlement);
>> +        return;
>> +    }
> I think you can delete this, too, there is no way that entitlement is > MAX.

With entitlement being an enum in CPU properties yes.


>
>> +    if (dedicated && (entitlement == S390_CPU_ENTITLEMENT_LOW ||
>> +                      entitlement == S390_CPU_ENTITLEMENT_MEDIUM)) {
> Without HORIZONTAL you can do != HIGH and save one line, but that is
> cosmetic only.

Right, HORIZONTAL is eliminated during s390_topology_cpu_default()


Regards,

Pierre

