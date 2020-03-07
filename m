Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF3D617CA7D
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 02:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCGBfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 20:35:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58278 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgCGBfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 20:35:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0271YEK5174321;
        Sat, 7 Mar 2020 01:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PbQUxrRcvnBhgB9zACPzqhbzr3oDdrTvmkqMm9T8DrI=;
 b=BFWHfNZMOYZoyDbucUc0ikaOBFRq+Plc5QWsIgyXSrTsVM/Siqw7AYWnuMrz9i5KeBt5
 +PUPpnMwHOQjVKbpN5PxurB1F/WwWSFlBlZV/Ht1YrSqqoV2WTqmILDZSsR8Hvvzc9O5
 WqZrBsA0UpUzPme9PNVOWUI8kie0we3Px1KndpjdR0dRsL2WD6YAcKKF+7iPYlifCYZ4
 gd1f1T/Z6vkOb82SbSw/EbpSKdhooQqv+Fy5G+w7E51UX+dC92vsvGXd/BA/Ppw25fVI
 ZtqMCiMKn8/C8O1Nf5gjLdZsmQu/k0V7G1hn84WAwTQeLUOhnDhqM2nhz/4bR5jVDd22 Iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yffwre7v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Mar 2020 01:34:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0271Y1HV096404;
        Sat, 7 Mar 2020 01:34:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ym1ndgk5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Mar 2020 01:34:13 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0271YC1c022890;
        Sat, 7 Mar 2020 01:34:12 GMT
Received: from localhost.localdomain (/10.159.228.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Mar 2020 17:34:11 -0800
Subject: Re: [PATCH v3 2/2] KVM: VMX: untangle VMXON revision_id setting when
 using eVMCS
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200306130215.150686-1-vkuznets@redhat.com>
 <20200306130215.150686-3-vkuznets@redhat.com>
 <908345f1-9bfd-004f-3ba6-0d6dce67d11e@oracle.com>
 <20200306230747.GA27868@linux.intel.com>
 <ceb19682-4374-313a-cf05-8af6cd8d6c3b@oracle.com>
 <20200307002852.GA28225@linux.intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <6ce77a63-0505-36f8-3a92-f0f6b275fed1@oracle.com>
Date:   Fri, 6 Mar 2020 17:34:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200307002852.GA28225@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9552 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=2 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003070008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9552 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003070008
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/6/20 4:28 PM, Sean Christopherson wrote:
> On Fri, Mar 06, 2020 at 03:57:25PM -0800, Krish Sadhukhan wrote:
>> On 3/6/20 3:07 PM, Sean Christopherson wrote:
>>> On Fri, Mar 06, 2020 at 02:20:13PM -0800, Krish Sadhukhan wrote:
>>>>> @@ -2599,7 +2607,7 @@ void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
>>>>>   int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
>>>>>   {
>>>>> -	loaded_vmcs->vmcs = alloc_vmcs(false);
>>>>> +	loaded_vmcs->vmcs = alloc_vmcs(VMCS_REGION);
>>>>>   	if (!loaded_vmcs->vmcs)
>>>>>   		return -ENOMEM;
>>>>> @@ -2652,25 +2660,13 @@ static __init int alloc_vmxon_regions(void)
>>>>>   	for_each_possible_cpu(cpu) {
>>>>>   		struct vmcs *vmcs;
>>>>> -		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
>>>>> +		/* The VMXON region is really just a special type of VMCS. */
>>>> Not sure if this is the right way to correlate the two.
>>>>
>>>> AFAIU, the SDM calls VMXON region as a memory area that holds the VMCS data
>>>> structure and it calls VMCS the data structure that is used by software to
>>>> switch between VMX root-mode and not-root-mode. So VMXON is a memory area
>>>> whereas VMCS is the structure of the data that resides in that memory area.
>>>>
>>>> So if we follow this interpretation, your enum should rather look like,
>>>>
>>>> enum vmcs_type {
>>>> +    VMCS,
>>>> +    EVMCS,
>>>> +    SHADOW_VMCS
>>> No (to the EVMCS suggestion), because this allocation needs to happen for
>>> !eVMCS.  The SDM never explictly calls the VMXON region a VMCS, but it's
>>> just being coy.  E.g. VMCLEAR doesn't fail if you point it at random
>>> memory, but point it at the VMXON region and it yells.
>>>
>>> We could call it VMXON_VMCS if that helps.
>> Are you saying,
>>
>> + enum vmcs_type {
>> +     VMXON_REGION,
>> +     VMXON_VMCS,
>> +     SHADOW_VMCS_REGION,
>> +};
>>
>> ?
>>
>> In that case, "VMXON_REGION" and "VMXON_VMCS" are no different according to
>> your explanation.
>    enum vmcs_type {
> 	VMXON_VMCS,
> 	VMCS,
> 	SHADOW_VMCS,
>    };


It looks reasonable.


>
> alloc_vmcs_cpu() does more than just allocate the memory, it also
> initializes the data structure, e.g. "allocate and initalize a VMXON VMCS",
>
>>>   The SDM does call the memory
>>> allocation for regular VMCSes a "VMCS region":
>>>
>>>    A logical processor associates a region in memory with each VMCS. This
>>>    region is called the VMCS region.
>>>
>>> I don't think I've ever heard anyone differentiate that two though, i.e.
>>> VMCS is used colloquially to mean both the data structure itself and the
>>> memory region containing the data structure.
>>>
>>>>> +		vmcs = alloc_vmcs_cpu(VMXON_REGION, cpu, GFP_KERNEL);
>>>>>   		if (!vmcs) {
>>>>>   			free_vmxon_regions();
>>>>>   			return -ENOMEM;
>>>>>   		}
>>>>> -		/*
>>>>> -		 * When eVMCS is enabled, alloc_vmcs_cpu() sets
>>>>> -		 * vmcs->revision_id to KVM_EVMCS_VERSION instead of
>>>>> -		 * revision_id reported by MSR_IA32_VMX_BASIC.
>>>>> -		 *
>>>>> -		 * However, even though not explicitly documented by
>>>>> -		 * TLFS, VMXArea passed as VMXON argument should
>>>>> -		 * still be marked with revision_id reported by
>>>>> -		 * physical CPU.
>>>>> -		 */
>>>>> -		if (static_branch_unlikely(&enable_evmcs))
>>>>> -			vmcs->hdr.revision_id = vmcs_config.revision_id;
>>>>> -
>>>>>   		per_cpu(vmxarea, cpu) = vmcs;
>>>>>   	}
>>>>>   	return 0;
>>>>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>>>>> index e64da06c7009..a5eb92638ac2 100644
>>>>> --- a/arch/x86/kvm/vmx/vmx.h
>>>>> +++ b/arch/x86/kvm/vmx/vmx.h
>>>>> @@ -489,16 +489,22 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
>>>>>   	return &(to_vmx(vcpu)->pi_desc);
>>>>>   }
>>>>> -struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
>>>>> +enum vmcs_type {
>>>>> +	VMXON_REGION,
>>>>> +	VMCS_REGION,
>>>>> +	SHADOW_VMCS_REGION,
>>>>> +};
>>>>> +
>>>>> +struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags);
>>>>>   void free_vmcs(struct vmcs *vmcs);
>>>>>   int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
>>>>>   void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
>>>>>   void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs);
>>>>>   void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
>>>>> -static inline struct vmcs *alloc_vmcs(bool shadow)
>>>>> +static inline struct vmcs *alloc_vmcs(enum vmcs_type type)
>>>>>   {
>>>>> -	return alloc_vmcs_cpu(shadow, raw_smp_processor_id(),
>>>>> +	return alloc_vmcs_cpu(type, raw_smp_processor_id(),
>>>>>   			      GFP_KERNEL_ACCOUNT);
>>>>>   }
