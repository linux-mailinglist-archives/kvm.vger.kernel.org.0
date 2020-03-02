Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6429D17654D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 21:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgCBUsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 15:48:50 -0500
Received: from goliath.siemens.de ([192.35.17.28]:50115 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgCBUsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 15:48:50 -0500
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 022KmR6k007017
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Mar 2020 21:48:29 +0100
Received: from [139.25.68.37] ([139.25.68.37])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 022KmQfk011003;
        Mon, 2 Mar 2020 21:48:26 +0100
Subject: Re: [PATCH 5/6] KVM: x86: Rename "found" variable in kvm_cpuid() to
 "exact_entry_exists"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-6-sean.j.christopherson@intel.com>
 <680d85ee-948c-6968-2d1a-d563d4863140@siemens.com>
 <20200302203510.GF6244@linux.intel.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <42135019-bbb8-40e0-35c7-070365a5ad79@siemens.com>
Date:   Mon, 2 Mar 2020 21:48:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302203510.GF6244@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.03.20 21:35, Sean Christopherson wrote:
> On Mon, Mar 02, 2020 at 09:20:52PM +0100, Jan Kiszka wrote:
>> On 02.03.20 20:57, Sean Christopherson wrote:
>>> Rename "found" in kvm_cpuid() to "exact_entry_exists" to better convey
>>> that the intent of the tracepoint's "found/not found" output is to trace
>>> whether the output values are for the actual requested leaf or for some
>>> other (likely unrelated) leaf that was found while processing entries to
>>> emulate funky CPU behavior, e.g. the max basic leaf on Intel CPUs when
>>> the requested CPUID leaf is out of range.
>>>
>>> Suggested-by: Jan Kiszka <jan.kiszka@siemens.com>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>>   arch/x86/kvm/cpuid.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 869526930cf7..b0a4f3c17932 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -1002,10 +1002,10 @@ void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>>>   {
>>>   	const u32 function = *eax, index = *ecx;
>>>   	struct kvm_cpuid_entry2 *entry;
>>> -	bool found;
>>> +	bool exact_entry_exists;
>>>   	entry = kvm_find_cpuid_entry(vcpu, function, index);
>>> -	found = entry;
>>> +	exact_entry_exists = !!entry;
>>>   	/*
>>>   	 * Intel CPUID semantics treats any query for an out-of-range
>>>   	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
>>> @@ -1047,7 +1047,7 @@ void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>>>   			}
>>>   		}
>>>   	}
>>> -	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
>>> +	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, exact_entry_exists);
>>
>> Actually, I think we also what to change output in the tracepoint.
> 
> Oh, I definitely want to change it, but AIUI it's ABI and shouldn't be
> changed.  Paolo?
> 

This can be discovered via the format string in sysfs and handled by the 
consumer. But I'm not an expert in the tracing ABI.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
