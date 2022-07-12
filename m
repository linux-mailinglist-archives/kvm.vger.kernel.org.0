Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA91571512
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 10:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiGLIvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 04:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiGLIu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 04:50:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA261A5E6E;
        Tue, 12 Jul 2022 01:50:58 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26C8gQ4f009831;
        Tue, 12 Jul 2022 08:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UTW3BCFfdy5DjQILSq4ThpzsOPHxU1LDL5TkrC4GeZw=;
 b=qO9l1Cjj21zlK2LpLGb8QNhWDlmesGiznkzfGFvjFjS/73xzKgYjmqOQ8WASjXonZ8k9
 h7TkEx/Vpte6h/o2/BQt6HserQxhAtU8IsVW/H8GIGc6RW8C0uOwwrF9Stin30zIhdCS
 /ntELEZfI/MFinA8v6Ld6FRNxGGynYTu5CDsVFgoiFlNNtzQD2i8u6IuohlA8Ge+3V1Y
 sLalfNG3lycB9CrHZD3NKzRC7og5/xXsSaeQYkZS0yqMn5wes2Y6y6JABdOW+QX7FGs7
 UcroCXsnLHo1is0HUT6w5Y4lhZVxV7SW23vkHUZQgPjmeFlzlZ5HPhRwlEJPjZ1ueIDo Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h95nyr61e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 08:50:58 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26C8iLGu018726;
        Tue, 12 Jul 2022 08:50:57 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h95nyr608-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 08:50:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26C8M4HR013441;
        Tue, 12 Jul 2022 08:50:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3h8rrn0txm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 08:50:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26C8p2cI18809274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 08:51:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 349A14203F;
        Tue, 12 Jul 2022 08:50:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A51542041;
        Tue, 12 Jul 2022 08:50:51 +0000 (GMT)
Received: from [9.171.80.212] (unknown [9.171.80.212])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jul 2022 08:50:51 +0000 (GMT)
Message-ID: <6124248a-24be-b43a-f827-b6bebf9e7f3d@linux.ibm.com>
Date:   Tue, 12 Jul 2022 10:50:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v12 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220711084148.25017-1-pmorel@linux.ibm.com>
 <20220711084148.25017-3-pmorel@linux.ibm.com>
 <92c6d13c-4494-de56-83f4-9d7384444008@linux.ibm.com>
 <1884bc26-b91b-83a7-7f8b-96b6090a0bac@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <1884bc26-b91b-83a7-7f8b-96b6090a0bac@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CDnBHqYE0UAd5LfSQqi8F7nhE3nHX5m8
X-Proofpoint-ORIG-GUID: 8SOaAYfrUuiANWQJE1fMhxoVV0Oxfj5y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_05,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/12/22 09:45, Pierre Morel wrote:
> 
> 
> On 7/11/22 14:30, Janis Schoetterl-Glausch wrote:
>> On 7/11/22 10:41, Pierre Morel wrote:
>>> We report a topology change to the guest for any CPU hotplug.
>>>
>>> The reporting to the guest is done using the Multiprocessor
>>> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
>>> SCA which will be cleared during the interpretation of PTF.
>>>
>>> On every vCPU creation we set the MCTR bit to let the guest know the
>>> next time it uses the PTF with command 2 instruction that the
>>> topology changed and that it should use the STSI(15.1.x) instruction
>>> to get the topology details.
>>>
>>> STSI(15.1.x) gives information on the CPU configuration topology.
>>> Let's accept the interception of STSI with the function code 15 and
>>> let the userland part of the hypervisor handle it when userland
>>> supports the CPU Topology facility.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>>
>> Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 
> Thanks.
> 
> 
>> See nit below.
>>> ---
>>>   arch/s390/include/asm/kvm_host.h | 18 +++++++++++++++---
>>>   arch/s390/kvm/kvm-s390.c         | 31 +++++++++++++++++++++++++++++++
>>>   arch/s390/kvm/priv.c             | 22 ++++++++++++++++++----
>>>   arch/s390/kvm/vsie.c             |  8 ++++++++
>>>   4 files changed, 72 insertions(+), 7 deletions(-)
>>>
>>
>> [...]
>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index 8fcb56141689..70436bfff53a 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -1691,6 +1691,32 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>>>       return ret;
>>>   }
>>>   +/**
>>> + * kvm_s390_update_topology_change_report - update CPU topology change report
>>> + * @kvm: guest KVM description
>>> + * @val: set or clear the MTCR bit
>>> + *
>>> + * Updates the Multiprocessor Topology-Change-Report bit to signal
>>> + * the guest with a topology change.
>>> + * This is only relevant if the topology facility is present.
>>> + *
>>> + * The SCA version, bsca or esca, doesn't matter as offset is the same.
>>> + */
>>> +static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
>>> +{
>>> +    union sca_utility new, old;
>>> +    struct bsca_block *sca;
>>> +
>>> +    read_lock(&kvm->arch.sca_lock);
>>> +    do {
>>> +        sca = kvm->arch.sca;
>>
>> I find this assignment being in the loop unintuitive, but it should not make a difference.
> 
> The price would be an ugly cast.

I don't get what you mean. Nothing about the types changes if you move it before the loop.
> 
> 
>>
>>> +        old = READ_ONCE(sca->utility);
>>> +        new = old;
>>> +        new.mtcr = val;
>>> +    } while (cmpxchg(&sca->utility.val, old.val, new.val) != old.val);
>>> +    read_unlock(&kvm->arch.sca_lock);
>>> +}
>>> +
>> [...]
>>
> 
> 

