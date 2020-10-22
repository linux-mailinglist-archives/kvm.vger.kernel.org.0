Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5EE29603E
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 15:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900350AbgJVNn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 09:43:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21230 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2508260AbgJVNn5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 09:43:57 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MDeBEN005458
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 09:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EnqaksF3sc+NEYunXju5cBf0KESNqs+ZeA+WfpI4aSw=;
 b=m5wMNCdTAhxN1JQcz7x7cuu49Mv7zHZFX+1AHqtvb/rpF9CuthsG3gzhlnTyRftUJ1Em
 FvcnVsgfn3sL1AbYLqlk3eg48k7rlJNeVOV4jhRIhOKn1lCMavnC1ewJdG6vV/7MXKiz
 w8pb+x0O37tQeCjQFHq0pMSfifIiSxLuJB4iUCZIAdNxq0zzG3vhs9bjpyocOBHMKLKr
 Oc+goHiscMCL5tGwvOXVwYV9W+vO5YEXkHiQcYO3uuWpWpvuVIglK8gnpW8OhX/0MWRW
 9zY2bXAkAYYTx+9U8DAX1sPE9VsaLe5P7PhHZlGbj0Ye7s7C9LQc5Q60USfN08r04G/D vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ay4jvm83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 09:43:55 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09MDeFR9005869
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 09:43:55 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ay4jvm7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 09:43:55 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09MDcM4c001283;
        Thu, 22 Oct 2020 13:43:54 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 347r89thv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:43:54 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09MDhjTm6160846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 13:43:45 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9C4FBE051;
        Thu, 22 Oct 2020 13:43:52 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 460A7BE054;
        Thu, 22 Oct 2020 13:43:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.200.244])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 22 Oct 2020 13:43:52 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] s390/kvm: fix diag318 reset
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com
References: <20201015195913.101065-1-walling@linux.ibm.com>
 <20201015195913.101065-2-walling@linux.ibm.com>
 <eb8dc053-d8e6-7ef4-e722-101ab3135266@linux.ibm.com>
 <246ad72a-a081-d25a-33fd-843edaeb9248@de.ibm.com>
Message-ID: <5cb6294a-b1ff-ba09-a47b-76f39a5e844a@linux.ibm.com>
Date:   Thu, 22 Oct 2020 09:43:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <246ad72a-a081-d25a-33fd-843edaeb9248@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_06:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/20 3:44 AM, Christian Borntraeger wrote:
> 
> 
> On 16.10.20 09:34, Janosch Frank wrote:
>> On 10/15/20 9:59 PM, Collin Walling wrote:
>>> The DIAGNOSE 0x0318 instruction must be reset on a normal and clear
>>> reset. However, this was missed for the clear reset case.
>>>
>>> Let's fix this by resetting the information during a normal reset. 
>>> Since clear reset is a superset of normal reset, the info will
>>> still reset on a clear reset.
>>
>> The architecture really confuses me here but I think we don't want this
>> in the kernel VCPU reset handlers at all.
>>
>> This needs to be reset per VM *NOT* per VCPU.
>> Hence the resets are bound to diag308 and not SIGP.
>>
>> I.e. we need to clear it in QEMU's VM reset handler.
>> It's still early and I have yet to consume my first coffee, am I missing
>> something?
> 
> I agree with Janosch. architecture indicates that this should only be reset
> for VM-wide resets, e.g. sigp orders 11 and 12 are explicitly mentioned
> to NOT reset the value.
> 

A few questions regarding how resets for diag318 should work here:

The AR states that any copies retained by the diag318 should be set to 0
on a clear reset and load normal -- I thought both of those resets were
implicitly called by diag308 as well?

Should the register used to store diag318 info not be set to 0 *by KVM*
then? Should the values be set *by QEMU* and a subsequent sync_regs will
ensure things are sane on the KVM side?

>>
>>>
>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>>> ---
>>>  arch/s390/kvm/kvm-s390.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index 6b74b92c1a58..b0cf8367e261 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -3516,6 +3516,7 @@ static void kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
>>>  	vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_RI;
>>>  	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
>>>  	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));
>>> +	vcpu->run->s.regs.diag318 = 0;
>>>  
>>>  	kvm_clear_async_pf_completion_queue(vcpu);
>>>  	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
>>> @@ -3582,7 +3583,6 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
>>>  
>>>  	regs->etoken = 0;
>>>  	regs->etoken_extension = 0;
>>> -	regs->diag318 = 0;
>>>  }
>>>  
>>>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>>>
>>
>>


-- 
Regards,
Collin

Stay safe and stay healthy
