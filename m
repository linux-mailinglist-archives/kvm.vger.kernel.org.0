Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B400C27A882
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 09:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgI1H0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 03:26:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46022 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI1H0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 03:26:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7JRdg104387;
        Mon, 28 Sep 2020 07:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=p1Zwmbr6X5/zZoe83MXTa6FVPFXouuWFbUhI0s+dFoA=;
 b=j2e9vdFe1Isuq9LDJZ9V6+fyp6aIdKlIHutiVXAGY820TR8GtYHBwnAfkCd67x/sBFct
 05VqxAYiCStAhS7BAmCbRbtP6mbvu2U7O2YSyy2yGOiHsp9kAz1WDU7AM7GDxSJZ7KlR
 uIrvdv/uv9Zv7/3fI1n0Z7BZ/WHM9XnMB7vet43xtGov1TMJk8pVpql2GTskacWivcc6
 Gbfb16Z3V4yOqdJGaIb2ZmxpF8GIDF7ZVsODSY4cKWihjdHHYUEHm9OvkN9kiP8iTWuT
 x3spSI0vq+pG3DrjZLN8+lWjkx3QYfdbkupsUEhgUsH+aNGHEN8ke9bp+mTfF/BYZVAL 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkkke7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 07:26:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7KfaX139928;
        Mon, 28 Sep 2020 07:24:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33tfdpmke9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 07:24:08 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08S7O70I032074;
        Mon, 28 Sep 2020 07:24:07 GMT
Received: from localhost.localdomain (/10.159.238.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 00:24:07 -0700
Subject: Re: [PATCH 2/3] KVM: nSVM: Add check for CR3 and CR4 reserved bits to
 svm_set_nested_state()
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com
References: <20200829004824.4577-1-krish.sadhukhan@oracle.com>
 <20200829004824.4577-3-krish.sadhukhan@oracle.com>
 <af85c9cb-2bce-6022-7640-f827673c26eb@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a16cc1cc-a3c1-c1c6-95f0-a651640f0f4b@oracle.com>
Date:   Mon, 28 Sep 2020 00:23:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <af85c9cb-2bce-6022-7640-f827673c26eb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/23/20 8:53 AM, Paolo Bonzini wrote:
> On 29/08/20 02:48, Krish Sadhukhan wrote:
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/kvm/svm/nested.c | 51 ++++++++++++++++++++++-----------------
>>   1 file changed, 29 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index fb68467e6049..7a51ce465f3e 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -215,9 +215,35 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>>   	return true;
>>   }
>>   
>> +static bool nested_vmcb_check_cr3_cr4(struct vcpu_svm *svm,
>> +				      struct vmcb_save_area *save)
>> +{
>> +	bool nested_vmcb_lma =
>> +	        (save->efer & EFER_LME) &&
>> +		(save->cr0 & X86_CR0_PG);
>> +
>> +	if (!nested_vmcb_lma) {
>> +		if (save->cr4 & X86_CR4_PAE) {
>> +			if (save->cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
>> +				return false;
>> +		} else {
>> +			if (save->cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
>> +				return false;
>> +		}
>> +	} else {
>> +		if (!(save->cr4 & X86_CR4_PAE) ||
>> +		    !(save->cr0 & X86_CR0_PE) ||
>> +		    (save->cr3 & MSR_CR3_LONG_MBZ_MASK))
>> +			return false;
>> +	}
>> +	if (kvm_valid_cr4(&svm->vcpu, save->cr4))
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>>   static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
>>   {
>> -	bool nested_vmcb_lma;
>>   	if ((vmcb->save.efer & EFER_SVME) == 0)
>>   		return false;
>>   
>> @@ -228,25 +254,7 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb)
>>   	if (!kvm_dr6_valid(vmcb->save.dr6) || !kvm_dr7_valid(vmcb->save.dr7))
>>   		return false;
>>   
>> -	nested_vmcb_lma =
>> -	        (vmcb->save.efer & EFER_LME) &&
>> -		(vmcb->save.cr0 & X86_CR0_PG);
>> -
>> -	if (!nested_vmcb_lma) {
>> -		if (vmcb->save.cr4 & X86_CR4_PAE) {
>> -			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
>> -				return false;
>> -		} else {
>> -			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
>> -				return false;
>> -		}
>> -	} else {
>> -		if (!(vmcb->save.cr4 & X86_CR4_PAE) ||
>> -		    !(vmcb->save.cr0 & X86_CR0_PE) ||
>> -		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
>> -			return false;
>> -	}
>> -	if (kvm_valid_cr4(&svm->vcpu, vmcb->save.cr4))
>> +	if (!nested_vmcb_check_cr3_cr4(svm, &(vmcb->save)))
>>   		return false;
>>   
>>   	return nested_vmcb_check_controls(&vmcb->control);
>> @@ -1114,9 +1122,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>>   	/*
>>   	 * Validate host state saved from before VMRUN (see
>>   	 * nested_svm_check_permissions).
>> -	 * TODO: validate reserved bits for all saved state.
>>   	 */
>> -	if (!(save.cr0 & X86_CR0_PG))
>> +	if (!nested_vmcb_check_cr3_cr4(svm, &save))
>>   		return -EINVAL;
> Removing the "if" is incorrect.
Sorry, my mistake.
>   Also are there really no more reserved
> bits to check?
I have sent v2 which has added checks for DR6, DR7 and EFER.
>
> Paolo
>
