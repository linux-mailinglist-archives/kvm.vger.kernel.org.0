Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4D769209F
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 15:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbjBJORM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 09:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjBJORL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 09:17:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6D9302B7
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:17:10 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AEBqGo011604;
        Fri, 10 Feb 2023 14:17:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tVDk1rEP0VaCBaus9lBDDgaSjt+TFN/TR8SbNhdk7wo=;
 b=tDuy+iDU0vkQO+agcaXvueIb5CwXcY3OUXAVpTjLkoCVd/Xmov7lPkbLMQ7GbUTXktaj
 T4lz4aEVDsT9yUY/QCjzWMm+jRkwXyuSqVzIl++1myjKZD+OFMIDHBvpGLe1iyVgY8xo
 HuolR1p0nyre4dno3AcAraCxBCuKcB+FM+Ix2X+FqEDmUtdofLGZ2PrKPi2mnK4NF+Kg
 690+AhVF/Nsq7zzyWC1JJZ1EUEOFD8x90mNKB1vtb5tfptgyS0fVkWn4zhRNmOUU0wa/
 R59/5W17GbWzp6/es4820Dw8mdCn0RYI72FNlxdSzjozWEUogVN1xDtvgX9C1YYFKNhT Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnqfrg4u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:17:01 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31AEDLTi020565;
        Fri, 10 Feb 2023 14:17:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnqfrg4t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:17:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31A5nqm8002355;
        Fri, 10 Feb 2023 14:16:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06qkdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:16:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31AEGsT050921906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 14:16:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1CC72004B;
        Fri, 10 Feb 2023 14:16:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8007120040;
        Fri, 10 Feb 2023 14:16:53 +0000 (GMT)
Received: from [9.171.75.239] (unknown [9.171.75.239])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Feb 2023 14:16:53 +0000 (GMT)
Message-ID: <fd2dbec5-d167-af22-b5c8-d65fc2a95c10@linux.ibm.com>
Date:   Fri, 10 Feb 2023 15:16:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v15 03/11] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-4-pmorel@linux.ibm.com>
 <224677259469c69c61e120a24b7fd0754fd52956.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <224677259469c69c61e120a24b7fd0754fd52956.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BajB6IbkJeCuJdWLXah737a8S2FIUMoT
X-Proofpoint-ORIG-GUID: F9-N7fTfBaPkl5OnKOKjPf0DkurEJ0kb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_08,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100115
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/9/23 17:39, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
>> On interception of STSI(15.1.x) the System Information Block
>> (SYSIB) is built from the list of pre-ordered topology entries.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/cpu-topology.h |  22 +++
>>   include/hw/s390x/sclp.h         |   1 +
>>   target/s390x/cpu.h              |  72 +++++++
>>   hw/s390x/cpu-topology.c         |  10 +
>>   target/s390x/kvm/cpu_topology.c | 335 ++++++++++++++++++++++++++++++++
>>   target/s390x/kvm/kvm.c          |   5 +-
>>   target/s390x/kvm/meson.build    |   3 +-
>>   7 files changed, 446 insertions(+), 2 deletions(-)
>>   create mode 100644 target/s390x/kvm/cpu_topology.c
>>
> [...]
>> +
>> +/**
>> + * s390_topology_from_cpu:
>> + * @cpu: The S390CPU
>> + *
>> + * Initialize the topology id from the CPU environment.
>> + */
>> +static s390_topology_id s390_topology_from_cpu(S390CPU *cpu)
>> +{
>> +    s390_topology_id topology_id = {0};
>> +
>> +    topology_id.drawer = cpu->env.drawer_id;
>> +    topology_id.book = cpu->env.book_id;
>> +    topology_id.socket = cpu->env.socket_id;
>> +    topology_id.origin = cpu->env.core_id / 64;
>> +    topology_id.type = S390_TOPOLOGY_CPU_IFL;
>> +    topology_id.dedicated = cpu->env.dedicated;
>> +
>> +    if (s390_topology.polarity == POLARITY_VERTICAL) {
>> +        /*
>> +         * Vertical polarity with dedicated CPU implies
>> +         * vertical high entitlement.
>> +         */
>> +        if (topology_id.dedicated) {
>> +            topology_id.polarity |= POLARITY_VERTICAL_HIGH;
>> +        } else {
>> +            topology_id.polarity |= cpu->env.entitlement;
>> +        }
> 
> Why |= instead of an assignment?
> Anyway, I think you can get rid of this in the next version.
> If you define the entitlement via qapi you can just put a little switch
> here and convert it to the hardware definition of polarization.
> (Or you just do +1, but I think the switch is easier to understand)

Oh! right thanks, it is a leftover from when dedication and polarity 
were in the same variable.

I change it with the QAPI enum.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
