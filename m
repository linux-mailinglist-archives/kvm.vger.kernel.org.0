Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1284964CDB
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 21:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfGJThF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 15:37:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44474 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfGJThE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 15:37:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AJY9HC134173;
        Wed, 10 Jul 2019 19:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=7QurGGzL6LHCnxggTaim/0QNy9muiJ1Qg4UJsjWJFxI=;
 b=oqdg1ETR8t/eoo9/Suxz+gBRAkfwkbK7BHmH0smcYGaoUezb1ZlBKYz64/j06eJ91JOM
 WXhyjoEY3ezexs0aBr9edcGGDjcBgeN2pXDoEtioXvbPjANxOQB73YBWYgejVY0fyd/U
 oPQpjmnRw4ckZ0MmaRhAit/iQPm10thVvrobT82jTLPGhIm9RLHaZ7Cv6ovczU7GILKX
 qK968IzXDC4QaRnYzCp1PSPHQAzA1A1FFFqan/RPSpNNb2584QaUkgeFyksodiciEPBt
 Vs/7iAXnCFeSfZL9fUdkxQiGXnVePJmTQtPaSJrn5jh2Hp4jcQNukclympdAk36MT1wT Rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tjk2tv6c6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 19:36:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AJXQeR035677;
        Wed, 10 Jul 2019 19:34:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tnc8t2e1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 19:34:27 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6AJYQx3028175;
        Wed, 10 Jul 2019 19:34:27 GMT
Received: from [10.159.238.2] (/10.159.238.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Jul 2019 12:34:26 -0700
Subject: Re: [PATCH 5/5] KVM: nVMX: Skip Guest State Area vmentry checks that
 are necessary only if VMCS12 is dirty
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190707071147.11651-6-krish.sadhukhan@oracle.com>
 <dedc725a-0810-a981-0ceb-a48a7f2f8b09@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <aacc1c45-9bf1-93e7-cb29-bd094689ce27@oracle.com>
Date:   Wed, 10 Jul 2019 12:34:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <dedc725a-0810-a981-0ceb-a48a7f2f8b09@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100223
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100223
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/10/19 9:33 AM, Paolo Bonzini wrote:
> On 07/07/19 09:11, Krish Sadhukhan wrote:
>>    ..so that every nested vmentry is not slowed down by those checks.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Here I think only the EFER check needs to be done always (before it
> refers GUEST_CR0 which is shadowed).


Should I send v2 ?

Also, I forgot to add  the following to the patchset,

            Suggested-by: Paolo Bonzini <pbonzini@redhat.com>

>
> Paolo
>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 20 ++++++++++++++++----
>>   1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index b610f389a01b..095923b1d765 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2748,10 +2748,23 @@ static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
>>   	return 0;
>>   }
>>   
>> +static int nested_vmx_check_guest_state_full(struct kvm_vcpu *vcpu,
>> +					     struct vmcs12 *vmcs12,
>> +					     u32 *exit_qual)
>> +{
>> +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS) &&
>> +	    (is_noncanonical_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu) ||
>> +	     (vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD)))
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>>   static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>>   					struct vmcs12 *vmcs12,
>>   					u32 *exit_qual)
>>   {
>> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>   	bool ia32e;
>>   
>>   	*exit_qual = ENTRY_FAIL_DEFAULT;
>> @@ -2788,10 +2801,9 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>>   			return -EINVAL;
>>   	}
>>   
>> -	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS) &&
>> -	    (is_noncanonical_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu) ||
>> -	     (vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD)))
>> -		return -EINVAL;
>> +	if (vmx->nested.dirty_vmcs12 &&
>> +	    nested_vmx_check_guest_state_full(vcpu, vmcs12, exit_qual))
>> +			return -EINVAL;
>>   
>>   	if (nested_check_guest_non_reg_state(vmcs12))
>>   		return -EINVAL;
>>
