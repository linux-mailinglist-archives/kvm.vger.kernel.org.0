Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3FB6739B5
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 14:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjASNPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 08:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjASNOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 08:14:19 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBE37A50A
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 05:12:56 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JBOwVR002865;
        Thu, 19 Jan 2023 13:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VC6AU++I1H4lkZr9x1DgyNsfYQLYsqrdfEfMNGgokiw=;
 b=iKXZe7wF39p1FUQp8AGcPa0Yn6ErAm9dZdvIUgFzfzlcOtj5EEggenTsIUieOOUdxCcL
 q1Z+qXPtvPV3CQNUR3THiM+N/P5k9Oc6/rTmKVWbHPbmoQC6x7IMeX3TEoTD5rdenIFm
 7vyF1gHEqIgNtdQzFjvDVocZGFbuNcF/ZjJNyaCuUgoZVA3rAFAKp7p840fszWiyBcvy
 htrQaWDeicRw0JQeq67DboG1zNK0UlWqtIqgJVlMQrmsq3fNJmqfb3DoVQ1NPUQXR4Mv
 2Ro7CIU8riXS9TSdGPD3H8uvXmml4FR1J1RdVt7rmT22Zr3Buu3ZrybG+TDCxt5+Xu8H wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6jc04ag7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 13:12:43 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JCd4D4001619;
        Thu, 19 Jan 2023 13:12:42 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6jc04afj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 13:12:42 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J0WJXp017351;
        Thu, 19 Jan 2023 13:12:40 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16pq5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 13:12:40 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JDCbuN46989644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 13:12:37 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A91B20043;
        Thu, 19 Jan 2023 13:12:37 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FB7520040;
        Thu, 19 Jan 2023 13:12:35 +0000 (GMT)
Received: from [9.152.224.248] (unknown [9.152.224.248])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 13:12:35 +0000 (GMT)
Message-ID: <ca47fa76-21e9-ab2c-88cb-1745bb6cf30c@linux.ibm.com>
Date:   Thu, 19 Jan 2023 14:12:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 03/11] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org,
        frankja@linux.ibm.com
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-4-pmorel@linux.ibm.com>
 <5cf19913-b2d7-d72d-4332-27aa484f72e4@redhat.com>
 <01782d4e-4c84-f958-b427-ff294f6c3c3f@linux.ibm.com>
 <9bf4841b-57a6-b08d-3d39-cd79ad0036e3@redhat.com>
 <61a19c4397897283754ceedfd8673c63ef1c369b.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <61a19c4397897283754ceedfd8673c63ef1c369b.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ftSwUmcFxO3p0Y02KGou6srazAfTHjpR
X-Proofpoint-GUID: X_LzzUelAsgXPv221rhbQmqYZAPShgw8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190103
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/18/23 12:54, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-01-18 at 11:26 +0100, Thomas Huth wrote:
>> On 17/01/2023 17.56, Pierre Morel wrote:
>>>
>>>
>>> On 1/10/23 15:29, Thomas Huth wrote:
>>>> On 05/01/2023 15.53, Pierre Morel wrote:
>>>>> On interception of STSI(15.1.x) the System Information Block
>>>>> (SYSIB) is built from the list of pre-ordered topology entries.
>>>>>
>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>> ---
>> ...
>>>>> +typedef struct SysIBTl_container {
>>>>> +        uint8_t nl;
>>>>> +        uint8_t reserved[6];
>>>>> +        uint8_t id;
>>>>> +} QEMU_PACKED QEMU_ALIGNED(8) SysIBTl_container;
>>>>> +QEMU_BUILD_BUG_ON(sizeof(SysIBTl_container) != 8);
>>>>> +
>>>>> +/* CPU type Topology List Entry */
>>>>> +typedef struct SysIBTl_cpu {
>>>>> +        uint8_t nl;
>>>>> +        uint8_t reserved0[3];
>>>>> +        uint8_t reserved1:5;
>>>>> +        uint8_t dedicated:1;
>>>>> +        uint8_t polarity:2;
>>>>
>>>> Hmmm, yet another bitfield...
>>>
>>> Yes, this is the firmware interface.
>>> If it makes problem I can use masks and logic arithmetic
>>
>> It depends ... if we are sure that this will ever only be used with KVM on
>> real s390x hardware, then bitfields are OK. If we think that this is
>> something that could be implemented in TCG, too, I'd scratch the bitfields
>> and use logic arithmetic instead...
> 
> Is there something like linux' bitfield.h in qemu?
> In this case it's only two fields, and not too complicated, but I imagine it could
> get quite ugly to do it manually in other cases.
>>
>> I'm not too experienced with this CPU topology stuff, but it sounds like it
>> could be implemented in TCG without too much efforts one day, too, so I'd
>> rather go with the logic arithmetic immediately instead if it is not too
>> annoying for you right now.

No problem, I changed all fields to uint8_t and it fits in a uint64_t so 
I have only a single bit and a single mask to define.

>>
>>>>> diff --git a/target/s390x/kvm/cpu_topology.c
>>>>> b/target/s390x/kvm/cpu_topology.c
>>>>> new file mode 100644
>>>>> index 0000000000..3831a3264c
>>>>> --- /dev/null
>>>>> +++ b/target/s390x/kvm/cpu_topology.c
>>>>> @@ -0,0 +1,136 @@
>>>>> +/*
>>>>> + * QEMU S390x CPU Topology
>>>>> + *
>>>>> + * Copyright IBM Corp. 2022
>>>>
>>>> Happy new year?
>>>
>>> So after Nina's comment what do I do?
>>> let it be 22 because I started last year or update because what is important
>>> is when it comes into mainline?
>>
>> Honestly, I don't have a really good clue either... But keeping 2022 is
>> certainly fine for me, too.

OK then I keep 2022

Regards,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
