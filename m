Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBA76920AE
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 15:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbjBJOT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 09:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbjBJOT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 09:19:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA72302A1
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:19:25 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31ADqLxf001533;
        Fri, 10 Feb 2023 14:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VWkwMjff/bJ2N96x32b1PqQ0TL0iGmCETddv4szqwYU=;
 b=SpA1FP04z2cKT1ermiitF2DmOkb3WgxFWzOiEiqn1w6t4h68MFZdrPgJZqdt2llq3FKv
 8pAvHZ2MAUpC7cShhBViFSSw0KmcAvO1+Zzrd1+K5es53KTj8tQy1HEZ0uqlb2UpI50Z
 SfsK4i7pCxMtPSZC9L+08p7On4E9vHDTJvLQQco1/67l9SOsPBpmHPTezwcioDE8eXHu
 CC6gFFr1vYnUxFx9vyi/hibhtYuqF5aBFsc5hWiYhS5v8GQ6GgzuZKodM7qRd9m4bz4o
 X54EVrh5K+3VOMjleJQhPCYsJ7XyygwTAyLI7/ZVKbEpYyJj0/1axa/YOP9PdZBoPCjt AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnq6m8ymw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:19:17 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31ADrr1R006942;
        Fri, 10 Feb 2023 14:19:16 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnq6m8ykx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:19:16 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 319Gt4M6024491;
        Fri, 10 Feb 2023 14:19:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3nhemfnff6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:19:13 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31AEJ99G46072156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 14:19:09 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B760120040;
        Fri, 10 Feb 2023 14:19:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71ED020049;
        Fri, 10 Feb 2023 14:19:08 +0000 (GMT)
Received: from [9.171.75.239] (unknown [9.171.75.239])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Feb 2023 14:19:08 +0000 (GMT)
Message-ID: <33df27d9-0003-ff54-a676-9a24e80ef4e0@linux.ibm.com>
Date:   Fri, 10 Feb 2023 15:19:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v15 01/11] s390x/cpu topology: adding s390 specificities
 to CPU topology
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
 <20230201132051.126868-2-pmorel@linux.ibm.com>
 <776aa71584e93d552871f966e9c89cb062e2af6c.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <776aa71584e93d552871f966e9c89cb062e2af6c.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GBYyGEIgtdT0UEl2Pgk5Awr5A1Vsubqi
X-Proofpoint-GUID: 37i0E03BKKzOlUFNXgpV2lvVcCpGWUmw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_08,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 adultscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 spamscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100115
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/8/23 18:50, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
>> S390 adds two new SMP levels, drawers and books to the CPU
>> topology.
>> The S390 CPU have specific toplogy features like dedication
>> and polarity to give to the guest indications on the host
>> vCPUs scheduling and help the guest take the best decisions
>> on the scheduling of threads on the vCPUs.
>>
>> Let us provide the SMP properties with books and drawers levels
>> and S390 CPU with dedication and polarity,
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine.json               | 14 ++++++++--
>>   include/hw/boards.h             | 10 ++++++-
>>   include/hw/s390x/cpu-topology.h | 24 +++++++++++++++++
>>   target/s390x/cpu.h              |  5 ++++
>>   hw/core/machine-smp.c           | 48 ++++++++++++++++++++++++++++-----
>>   hw/core/machine.c               |  4 +++
>>   hw/s390x/s390-virtio-ccw.c      |  2 ++
>>   softmmu/vl.c                    |  6 +++++
>>   target/s390x/cpu.c              |  7 +++++
>>   qemu-options.hx                 |  7 +++--
>>   10 files changed, 115 insertions(+), 12 deletions(-)
>>   create mode 100644 include/hw/s390x/cpu-topology.h
>>
> [...]
>>
>> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
>> new file mode 100644
>> index 0000000000..7a84b30a21
>> --- /dev/null
>> +++ b/include/hw/s390x/cpu-topology.h
>> @@ -0,0 +1,24 @@
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
>> + * your option) any later version. See the COPYING file in the top-level
>> + * directory.
>> + */
>> +#ifndef HW_S390X_CPU_TOPOLOGY_H
>> +#define HW_S390X_CPU_TOPOLOGY_H
>> +
>> +#define S390_TOPOLOGY_CPU_IFL   0x03
>> +
>> +enum s390_topology_polarity {
>> +    POLARITY_HORIZONTAL,
>> +    POLARITY_VERTICAL,
>> +    POLARITY_VERTICAL_LOW = 1,
>> +    POLARITY_VERTICAL_MEDIUM,
>> +    POLARITY_VERTICAL_HIGH,
>> +    POLARITY_MAX,
>> +};
> 
> IMO you should define the polarization and entitlement enums as
> qapi enums.
> The polarization is passed as data in the qapi event when the polarization
> changes.
> And the entitlement is passed to qemu when modifying the topology.

(Thought I already answered but... seems no.)

looks good, thanks, I change this.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
