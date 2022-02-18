Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC3C4BBE60
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238584AbiBRR1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:27:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238607AbiBRRZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:25:45 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7232B5BB7;
        Fri, 18 Feb 2022 09:25:28 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IGmNxr011958;
        Fri, 18 Feb 2022 17:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BgJF4+iBfRUdTv+ZkZ/QvT1Df8l0FdeC+4KjBvugA/Y=;
 b=sdyYdin9aZ8m/rOPZ9jB7L4C6Oqk0aR2cYxOvxhMs2WSp8Nlyf9xv8quel/RJmC2vCfF
 th7wVk45vIPuIos1IHvCRKAtdysbrzf/RAIa6Plam6mNOuWOoNbFOSF10N2zSkkD6Z+h
 8bx81LQ2sXZCU0aJU7Q21pJzfd9krHqFKQS2W16qrrBQ96m7CaD8jRIkPgn3HDjKxZPF
 5el1b35ZV5UY1oClH8WJXOc4pt9tLj2hVWu1U8LSS2GOKF1MDPtNm7F5qJ4bSsrKr1/4
 Uh4NYXa4FofEba5lbHOM0mval2CLe4d5VtaSWkcMCcjltN8XrUAjQpLEocKX90avaWXN RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eafa4rxma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 17:25:27 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21IGrTf1040071;
        Fri, 18 Feb 2022 17:25:27 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eafa4rxkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 17:25:27 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21IHERBG015590;
        Fri, 18 Feb 2022 17:25:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3e64hagx1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 17:25:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21IHPHx837683630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 17:25:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D657DA4053;
        Fri, 18 Feb 2022 17:25:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F4AFA4055;
        Fri, 18 Feb 2022 17:25:17 +0000 (GMT)
Received: from [9.171.47.189] (unknown [9.171.47.189])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Feb 2022 17:25:17 +0000 (GMT)
Message-ID: <aecc2b93-3e07-be78-81a2-594d2bc6b64a@linux.ibm.com>
Date:   Fri, 18 Feb 2022 18:27:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 1/1] s390x: KVM: guest support for topology function
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com
References: <20220217095923.114489-1-pmorel@linux.ibm.com>
 <20220217095923.114489-2-pmorel@linux.ibm.com>
 <f0bf737abf480d6d16af6e5335bb195061f3d076.camel@linux.ibm.com>
 <97af6268-ff7a-cfb6-5ea4-217b5162cfe7@linux.ibm.com>
 <b9828696-f5d4-dd72-9b0e-a27b1480b799@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b9828696-f5d4-dd72-9b0e-a27b1480b799@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CAR3S1WKxESgA-1ZYFZnNLQCkDaN0mTc
X-Proofpoint-GUID: PzHFCpBiNEmoOHiwfismNQcd8iD5lvdO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_07,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0
 suspectscore=0 clxscore=1015 spamscore=0 adultscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/18/22 15:28, Janosch Frank wrote:
> On 2/18/22 14:13, Pierre Morel wrote:
>>
>>
>> On 2/17/22 18:17, Nico Boehr wrote:
>>> On Thu, 2022-02-17 at 10:59 +0100, Pierre Morel wrote:
>>> [...]
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index 2296b1ff1e02..af7ea8488fa2 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> [...]
> 
> Why is there no interface to clear the SCA_UTILITY_MTCR on a subsystem 
> reset?

Right, I had one in my first version based on interception but I forgot 
to implement an equivalent for KVM as I modified the implementation for 
interpretation.
I will add this.

> 
> 
>>>> -void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>>> +/**
>>>> + * kvm_s390_vcpu_set_mtcr
>>>> + * @vcp: the virtual CPU
>>>> + *
>>>> + * Is only relevant if the topology facility is present.
>>>> + *
>>>> + * Updates the Multiprocessor Topology-Change-Report to signal
>>>> + * the guest with a topology change.
>>>> + */
>>>> +static void kvm_s390_vcpu_set_mtcr(struct kvm_vcpu *vcpu)
>>>>    {
>>>> +       struct esca_block *esca = vcpu->kvm->arch.sca;
>>>
>>> utility is at the same offset for the bsca and the esca, still
>>> wondering whether it is a good idea to assume esca here...
>>
>> We can take bsca to be coherent with the include file where we define
>> ESCA_UTILITY_MTCR inside the bsca.
>> And we can rename the define to SCA_UTILITY_MTCR as it is common for
>> both BSCA and ESCA the (E) is too much.
> 
> Yes and maybe add a comment that it's at the same offset for esca so 
> there won't come up further questions in the future.

OK

> 
>>
>>>
>>> [...]
>>>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>>>> index 098831e815e6..af04ffbfd587 100644
>>>> --- a/arch/s390/kvm/kvm-s390.h
>>>> +++ b/arch/s390/kvm/kvm-s390.h
>>>> @@ -503,4 +503,29 @@ void kvm_s390_vcpu_crypto_reset_all(struct kvm
>>>> *kvm);
>>>>     */
>>>>    extern unsigned int diag9c_forwarding_hz;
>>>> +#define S390_KVM_TOPOLOGY_NEW_CPU -1
>>>> +/**
>>>> + * kvm_s390_topology_changed
>>>> + * @vcpu: the virtual CPU
>>>> + *
>>>> + * If the topology facility is present, checks if the CPU toplogy
>>>> + * viewed by the guest changed due to load balancing or CPU hotplug.
>>>> + */
>>>> +static inline bool kvm_s390_topology_changed(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +       if (!test_kvm_facility(vcpu->kvm, 11))
>>>> +               return false;
>>>> +
>>>> +       /* A new vCPU has been hotplugged */
>>>> +       if (vcpu->arch.prev_cpu == S390_KVM_TOPOLOGY_NEW_CPU)
>>>> +               return true;
>>>> +
>>>> +       /* The real CPU backing up the vCPU moved to another socket
>>>> */
>>>> +       if (topology_physical_package_id(vcpu->cpu) !=
>>>> +           topology_physical_package_id(vcpu->arch.prev_cpu))
>>>> +               return true;
>>>
>>> Why is it OK to look just at the physical package ID here? What if the
>>> vcpu for example moves to a different book, which has a core with the
>>> same physical package ID?
> 
> I'll need to look up stsi 15* output to understand this.
> But the architecture states that any change to the stsi 15 output sets 
> the change bit so I'd guess Nico is correct.
>

Yes, Nico is correct, as I already answered, however it is not any 
change of stsi(15) but a change of stsi(15.1.2) output which sets the 
change bit.
However the socket identifier is relative to the book and not unique for 
the all system.
The solution given by Heiko is, of course, the most elegant so I will 
use it.

Thanks,

regards,
Pierre

> 

-- 
Pierre Morel
IBM Lab Boeblingen
