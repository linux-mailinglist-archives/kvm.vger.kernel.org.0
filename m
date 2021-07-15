Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC15A3C9DCD
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 13:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241985AbhGOLez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 07:34:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232053AbhGOLez (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 07:34:55 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FB4Bf5021635;
        Thu, 15 Jul 2021 07:32:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=USMSKQAwftGexVdE6uZMqcABuwt0ejNR32T6iWVdDCc=;
 b=DIiQdFuE66neWEg6dazjmKaPedSYQvE1KJBrnSMJcSqZqN9sNQSdmm90iccpTYpmmjDr
 yw3/OHvbi21LkXTU3S6aqYckyyMTpv7PNBQyDdjt/9Y1aLGWoSLFWPj+vrQN5D2IZJpB
 +wQaMPlwzN3plUx2qzSWE6kPjOQr+Rj4Nhvi59AV21EtgglkbI5BRd/SKxanh9dIyV1j
 YfH126Rbs5mwWTLJR0HG6LbFIQlisxq6FyPOT1UFCioH2mNGQbqTdH6+/nnfZInYyI2a
 7Szewzt1PqLDlO6rhyQf0ugHACiW8Ii3CUp+ByffQW6mrO41vlLb6DRMEf6koj5Ffcm/ +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sph48j01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 07:32:02 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16FB4Z9T023611;
        Thu, 15 Jul 2021 07:32:01 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39sph48hyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 07:32:01 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16FBSoZS006751;
        Thu, 15 Jul 2021 11:31:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 39q2tha84m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 11:31:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16FBVuTP34210254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 11:31:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0899FAE04D;
        Thu, 15 Jul 2021 11:31:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C6B2AE045;
        Thu, 15 Jul 2021 11:31:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.77.125])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jul 2021 11:31:55 +0000 (GMT)
Subject: Re: [PATCH v1 1/2] s390x: KVM: accept STSI for CPU topology
 information
To:     Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <1626276343-22805-1-git-send-email-pmorel@linux.ibm.com>
 <1626276343-22805-2-git-send-email-pmorel@linux.ibm.com>
 <db788a8c-99a9-6d99-07ab-b49e953d91a2@redhat.com> <87fswfdiuu.fsf@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <7910990d-d396-7dd9-c4fe-7029aa03f751@linux.ibm.com>
Date:   Thu, 15 Jul 2021 13:31:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87fswfdiuu.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mFpAzo4uP_YcQpXoncuMXJEm2hy4UIZz
X-Proofpoint-ORIG-GUID: 5MAPDR23YXm4_Mgb5OzTtXtkPMLZcaia
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-15_07:2021-07-14,2021-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 spamscore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107150081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/21 11:30 AM, Cornelia Huck wrote:
> On Thu, Jul 15 2021, David Hildenbrand <david@redhat.com> wrote:
> 
>> On 14.07.21 17:25, Pierre Morel wrote:
>>> STSI(15.1.x) gives information on the CPU configuration topology.
>>> Let's accept the interception of STSI with the function code 15 and
>>> let the userland part of the hypervisor handle it.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    arch/s390/kvm/priv.c | 11 ++++++++++-
>>>    1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>> index 9928f785c677..4ab5f8b7780e 100644
>>> --- a/arch/s390/kvm/priv.c
>>> +++ b/arch/s390/kvm/priv.c
>>> @@ -856,7 +856,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>    	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>>    		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>>    
>>> -	if (fc > 3) {
>>> +	if (fc > 3 && fc != 15) {
>>>    		kvm_s390_set_psw_cc(vcpu, 3);
>>>    		return 0;
>>>    	}
>>> @@ -893,6 +893,15 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>    			goto out_no_data;
>>>    		handle_stsi_3_2_2(vcpu, (void *) mem);
>>>    		break;
>>> +	case 15:
>>> +		if (sel1 != 1 || sel2 < 2 || sel2 > 6)
>>> +			goto out_no_data;
>>> +		if (vcpu->kvm->arch.user_stsi) {
>>> +			insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
>>> +			return -EREMOTE;
> 
> This bypasses the trace event further down.
> 

Right, I can add a trace.
Note that we had no trace in the past.

>>> +		}
>>> +		kvm_s390_set_psw_cc(vcpu, 3);
>>> +		return 0;
>>>    	}
>>>    	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>>>    		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
>>>
>>
>> 1. Setting GPRS to 0
>>
>> I was wondering why we have the "vcpu->run->s.regs.gprs[0] = 0;"
>> for existing fc 1,2,3 in case we set cc=0.
>>
>> Looking at the doc, all I find is:
>>
>> "CC 0: Requested configuration-level number placed in
>> general register 0 or requested SYSIB informa-
>> tion stored"
>>
>> But I don't find where it states that we are supposed to set
>> general register 0 to 0. Wouldn't we also have to do it for
>> fc=15 or for none?
>>
>> If fc 1,2,3 and 15 are to be handled equally, I suggest the following:
>>
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 9928f785c677..6eb86fa58b0b 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -893,17 +893,23 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>                           goto out_no_data;
>>                   handle_stsi_3_2_2(vcpu, (void *) mem);
>>                   break;
>> +       case 15:
>> +               if (sel1 != 1 || sel2 < 2 || sel2 > 6)
>> +                       goto out_no_data;
>> +               break;
>>           }
>> -       if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>> -               memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
>> -                      PAGE_SIZE);
>> -               rc = 0;
>> -       } else {
>> -               rc = write_guest(vcpu, operand2, ar, (void *)mem, PAGE_SIZE);
>> -       }
>> -       if (rc) {
>> -               rc = kvm_s390_inject_prog_cond(vcpu, rc);
>> -               goto out;
>> +       if (mem) {
>> +               if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>> +                       memcpy((void *)sida_origin(vcpu->arch.sie_block),
>> +                              (void *)mem, PAGE_SIZE);
>> +               } else {
>> +                       rc = write_guest(vcpu, operand2, ar, (void *)mem,
>> +                                        PAGE_SIZE);
>> +                       if (rc) {
>> +                               rc = kvm_s390_inject_prog_cond(vcpu, rc);
>> +                               goto out;
>> +                       }
>> +               }
>>           }
>>           if (vcpu->kvm->arch.user_stsi) {
>>                   insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
> 
> Something like that sounds good, the code is getting a bit convoluted.
> 

OK for me, in that case we can also suppress the check for FC=15 and let 
that to user space as it was suggested in a previous comment

>>
>>
>> 2. maximum-MNest facility
>>
>> "
>> 1. If the maximum-MNest facility is installed and
>> selector 2 exceeds the nonzero model-depen-
>> dent maximum-selector-2 value."
>>
>> 2. If the maximum-MNest facility is not installed and
>> selector 2 is not specified as two.
>> "
>>
>> We will we be handling the presence/absence of the maximum-MNest facility
>> (for our guest?) in QEMU, corect?
>>
>> I do wonder if we should just let any fc=15 go to user space let the whole
>> sel1 / sel2 checking be handled there. I don't think it's a fast path after all.
>> But no strong opinion.
> 
> If that makes handling easier, I think it would be a good idea.

OK too

> 
>>
>> How do we identify availability of maximum-MNest facility?
>>
>>
>> 3. User space awareness
>>
>> How can user space identify that we actually forward these intercepts?
>> How can it enable them? The old KVM_CAP_S390_USER_STSI capability
>> is not sufficient.
> 
> Why do you think that it is not sufficient? USER_STSI basically says
> "you may get an exit that tells you about a buffer to fill in some more
> data for a stsi command, and we also tell you which call". If userspace
> does not know what to add for a certain call, it is free to just do
> nothing, and if it does not get some calls it would support, that should
> not be a problem, either?
> 
>>
>> I do wonder if we want KVM_CAP_S390_USER_STSI_15 or sth like that to change
>> the behavior once enabled by user space.
>>
>>
>> 4. Without vcpu->kvm->arch.user_stsi, we indicate cc=0 to our guest,
>> also for fc 1,2,3. Is that actually what we want? (or do we simply not care
>> because the guest is not supposed to use stsi?)
> 
> If returning an empty buffer is ok, it should not be a problem, I
> guess. (I have not looked yet at the actual definitions.)
> 

When user_stsi is 0 for fc 1,2,3 the buffer is filled in the kernel, for 
15 the kernel can not do this.

-- 
Pierre Morel
IBM Lab Boeblingen
