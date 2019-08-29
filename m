Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB51CA127E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 09:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfH2HVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 03:21:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48542 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfH2HVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 03:21:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7T7ImCN123561;
        Thu, 29 Aug 2019 07:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=7JEnzSTTsiFc7/xQTLAtdCrcmOCgQUl8kyBCxDQFrNM=;
 b=Zp3iCb5V4fOVh02+LS3kPC851AEnTW2YtQDtetsKp7IyLL/m/+72Iw9Zu164yFbz9hvr
 0aoVU0EVuxRHp13q+UU9+NAIfrExO91p50/G3OgCGmTXB5rqVQx/9FqZuqkXL3QzoKTo
 q+wljwRq++vUi5g9sYKh4w1NoQm3DdXZ2O8UFdtUkymbRBtR5vL1SvJyiFUGh2arlZUK
 Am0mANZPK/USuALGtcOJzkbB2JlFCx9ZYOwT1kvvS01WV1OjYgyGUR1vlfXfeBx1Z9Qh
 jh4RSpTbuuwZ9bEsLXp4FflDUquVO/LT+TdsqmsBZtQPbKFe4j8OyStALM7A4yqrgSfh iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2upa5281dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 07:21:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7T7DgiR172257;
        Thu, 29 Aug 2019 07:19:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2up98shu8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 07:19:23 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7T7JNxs031202;
        Thu, 29 Aug 2019 07:19:23 GMT
Received: from [10.159.244.5] (/10.159.244.5)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 07:19:23 +0000
Subject: Re: [PATCH 1/7] KVM: nVMX: Use kvm_set_msr to load
 IA32_PERF_GLOBAL_CTRL on vmexit
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
References: <20190828234134.132704-1-oupton@google.com>
 <20190828234134.132704-2-oupton@google.com>
 <ed9ae8fc-d4d6-3dde-bac3-3c9068f0fc42@oracle.com>
 <20190829020241.GA186746@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <10942c78-eb43-4373-79bb-b0c67a1a8744@oracle.com>
Date:   Thu, 29 Aug 2019 00:19:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190829020241.GA186746@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290079
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/28/19 7:02 PM, Oliver Upton wrote:
> On Wed, Aug 28, 2019 at 06:30:29PM -0700, Krish Sadhukhan wrote:
>>
>> On 08/28/2019 04:41 PM, Oliver Upton wrote:
>>> The existing implementation for loading the IA32_PERF_GLOBAL_CTRL MSR
>>> on VM-exit was incorrect, as the next call to atomic_switch_perf_msrs()
>>> could cause this value to be overwritten. Instead, call kvm_set_msr()
>>> which will allow atomic_switch_perf_msrs() to correctly set the values.
>>>
>>> Suggested-by: Jim Mattson <jmattson@google.com>
>>> Signed-off-by: Oliver Upton <oupton@google.com>
>>> ---
>>>    arch/x86/kvm/vmx/nested.c | 13 ++++++++++---
>>>    1 file changed, 10 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index ced9fba32598..b0ca34bf4d21 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -3724,6 +3724,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>>>    				   struct vmcs12 *vmcs12)
>>>    {
>>>    	struct kvm_segment seg;
>>> +	struct msr_data msr_info;
>>>    	u32 entry_failure_code;
>>>    	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
>>> @@ -3800,9 +3801,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>>>    		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
>>>    		vcpu->arch.pat = vmcs12->host_ia32_pat;
>>>    	}
>>> -	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
>>> -		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
>>> -			vmcs12->host_ia32_perf_global_ctrl);
>>> +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
>>> +		msr_info.host_initiated = false;
>>> +		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
>>> +		msr_info.data = vmcs12->host_ia32_perf_global_ctrl;
>>> +		if (kvm_set_msr(vcpu, &msr_info))
>>> +			pr_debug_ratelimited(
>>> +				"%s cannot write MSR (0x%x, 0x%llx)\n",
>>> +				__func__, msr_info.index, msr_info.data);
>>> +	}
>>>    	/* Set L1 segment info according to Intel SDM
>>>    	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
>> These patches are what I am already working on. I sent the following:
>>
>>          [KVM nVMX]: Check "load IA32_PERF_GLOBAL_CTRL" on vmentry of nested
>> guests
>>          [PATCH 0/4][kvm-unit-test nVMX]: Test "load
>> IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests
>>
>> a few months back. I got feedback from the alias and am working on v2 which
>> I will send soon...
>>
> Yes, I saw your previous mail for this feature. I started work on this
> because of a need for this feature
I understand. I know that I have been bit late on this...
> + mentioned you in the cover letter.
> However, it would be better to give codeveloper credit with your
> permission.
>
> May I resend this patchset with a 'Co-Developed-by' tag crediting you?

Sure. Thank you !

