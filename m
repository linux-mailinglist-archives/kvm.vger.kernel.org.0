Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3845C17129D
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 09:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgB0IfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 03:35:25 -0500
Received: from mga05.intel.com ([192.55.52.43]:49942 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbgB0IfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 03:35:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 00:35:25 -0800
X-IronPort-AV: E=Sophos;i="5.70,491,1574150400"; 
   d="scan'208";a="231749398"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.169.149]) ([10.249.169.149])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 27 Feb 2020 00:35:20 -0800
Subject: Re: [PATCH 1/2] kvm: vmx: Use basic exit reason to check if it's the
 specific VM EXIT
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200224020751.1469-1-xiaoyao.li@intel.com>
 <20200224020751.1469-2-xiaoyao.li@intel.com>
 <87lfosp9xs.fsf@vitty.brq.redhat.com>
 <d9744594-4a66-d867-f785-64ce4d42b848@intel.com>
 <87imjwp24x.fsf@vitty.brq.redhat.com>
 <20200224161728.GC29865@linux.intel.com>
 <50134028-ef7a-46c6-7602-095c47406ed7@intel.com>
 <20200225061317.GV29865@linux.intel.com>
 <bb2d36b4-a077-691e-d59e-f65bf534d1ff@intel.com>
 <20200226235924.GW9940@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <022bf970-1b86-d952-5563-0d18c9eea6e2@intel.com>
Date:   Thu, 27 Feb 2020 16:35:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226235924.GW9940@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/27/2020 7:59 AM, Sean Christopherson wrote:
> On Tue, Feb 25, 2020 at 02:41:20PM +0800, Xiaoyao Li wrote:
>> On 2/25/2020 2:13 PM, Sean Christopherson wrote:
>>> On Tue, Feb 25, 2020 at 08:13:15AM +0800, Xiaoyao Li wrote:
>>>> On 2/25/2020 12:17 AM, Sean Christopherson wrote:
>>>> I have thought about union, but it seems
>>>>
>>>> union {
>>>> 	u16 exit_reason;
>>>> 	u32 full_exit_reason;
>>>> }
>>>>
>>>> is not a good name. Since there are many codes in vmx.c and nested.c assume
>>>> that exit_reason stands for 32-bit EXIT REASON vmcs field as well as
>>>> evmcs->vm_exit_reason and vmcs12->vm_exit_reason. Do we really want to also
>>>> rename them to full_exit_reason?
>>>
>>> It's actually the opposite, almost all of the VMX code assumes exit_reason
>>> holds only the basic exit reason, i.e. a 16-bit value.  For example, SGX
>>> adds a modifier flag to denote a VM-Exit was from enclave mode, and that
>>> bit needs to be stripped from exit_reason, otherwise all the checks like
>>> "if (exit_reason == blah_blah_blah)" fail.
>>>
>>> Making exit_reason a 16-bit alias of the full/extended exit_reason neatly
>>> sidesteps that issue.  And it is an issue that has caused actual problems
>>> in the past, e.g. see commit beb8d93b3e42 ("KVM: VMX: Fix handling of #MC
>>> that occurs during VM-Entry").  Coincidentally, that commit also removes a
>>> local "u16 basic_exit_reason" :-).
>>>
>>> Except for one mistake, the pseudo-patch below is the entirety of required
>>> changes.  Most (all?) of the functions that take "u32 exit_reason" can (and
>>> should) continue to take a u32.
>>>
>>> As for the name, I strongly prefer keeping the exit_reason name for the
>>> basic exit reason.  The vast majority of VM-Exits do not have modifiers
>>> set, i.e. "basic exit reason" == vmcs.EXIT_REASON for nearly all normal
>>> usage.  This holds true in every form of communication, e.g. when discussing
>>> VM-Exit reasons, it's never qualified with "basic", it's simply the exit
>>> reason.  IMO the code is better off following the colloquial usage of "exit
>>> reason".  A simple comment above the union would suffice to clear up any
>>> confusion with respect to the SDM.
>>
>> Well, for this reason we can keep exit_reason for 16-bit usage, and define
>> full/extended_exit_reason for 32-bit cases. This makes less code churn.
>>
>> But after we choose to use exit_reason and full/extended_exit_reason, what
>> if someday new modifier flags are added and we want to enable some modifier
>> flags for nested case?
>> I guess we need to change existing exit_reason to full/extended_exit_reason
>> in nested.c/nested.h to keep the naming rule consistent.
> 
> Ah, good point.  But, that's just another bug in my psuedo patch :-)
> It's literally one call site that needs to be updated.  E.g.
> 
> 	if (is_guest_mode(vcpu) && nested_vmx_exit_reflected(vcpu, exit_reason))
> 		return nested_vmx_reflect_vmexit(vcpu, full_exit_reason);
> 

shouldn't we also pass full_exit_reason to nested_vmx_exit_reflected()?

> Everywhere else KVM calls nested_vmx_reflect_vmexit() is (currently) done

I guess you wanted to say nested_vmx_vmexit() not 
nested_vmx_reflect_vmexit() here.

> with a hardcoded value (except handle_vmfunc(), but I actually want to
> change that one).
> 

