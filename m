Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A3402A09
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 15:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344833AbhIGNqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 09:46:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:61159 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344817AbhIGNqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 09:46:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10099"; a="207318430"
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="207318430"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 06:45:18 -0700
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="537981051"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.169.12]) ([10.249.169.12])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 06:45:14 -0700
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
To:     Sean Christopherson <seanjc@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <YQRkBI9RFf6lbifZ@google.com>
 <b0c90258-3f68-57a2-664a-e20a6d251e45@intel.com>
 <YQgTPakbT+kCwMLP@google.com>
 <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
 <YTD4l7L0CKMCQwd5@google.com> <YTD9kIIzAz34Ieeu@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <118cd1b9-1b50-3173-05b8-4293412ca78c@intel.com>
Date:   Tue, 7 Sep 2021 21:45:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTD9kIIzAz34Ieeu@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/2021 12:36 AM, Sean Christopherson wrote:
> On Thu, Sep 02, 2021, Sean Christopherson wrote:
>> On Tue, Aug 03, 2021, Xiaoyao Li wrote:
>>> On 8/2/2021 11:46 PM, Sean Christopherson wrote:
>>>>>>> @@ -5642,6 +5653,31 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
>>>>>>>     	return 0;
>>>>>>>     }
>>>>>>> +static int handle_notify(struct kvm_vcpu *vcpu)
>>>>>>> +{
>>>>>>> +	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
>>>>>>> +
>>>>>>> +	if (!(exit_qual & NOTIFY_VM_CONTEXT_INVALID)) {
>>>>>>
>>>>>> What does CONTEXT_INVALID mean?  The ISE doesn't provide any information whatsoever.
>>>>>
>>>>> It means whether the VM context is corrupted and not valid in the VMCS.
>>>>
>>>> Well that's a bit terrifying.  Under what conditions can the VM context become
>>>> corrupted?  E.g. if the context can be corrupted by an inopportune NOTIFY exit,
>>>> then KVM needs to be ultra conservative as a false positive could be fatal to a
>>>> guest.
>>>>
>>>
>>> Short answer is no case will set the VM_CONTEXT_INVALID bit.
>>
>> But something must set it, otherwise it wouldn't exist.  

For existing Intel silicon, no case will set it. Maybe in the future new 
case will set it.

> The condition(s) under
>> which it can be set matters because it affects how KVM should respond.  E.g. if
>> the guest can trigger VM_CONTEXT_INVALID at will, then we should probably treat
>> it as a shutdown and reset the VMCS.
> 
> Oh, and "shutdown" would be relative to the VMCS, i.e. if L2 triggers a NOTIFY
> exit with VM_CONTEXT_INVALID then KVM shouldn't kill the entire VM.  The least
> awful option would probably be to synthesize a shutdown VM-Exit to L1.  That
> won't communicate to L1 that vmcs12 state is stale/bogus, but I don't see any way
> to handle that via an existing VM-Exit reason :-/
> 
>> But if VM_CONTEXT_INVALID can occur if and only if there's a hardware/ucode
>> issue, then we can do:
>>
>> 	if (KVM_BUG_ON(exit_qual & NOTIFY_VM_CONTEXT_INVALID, vcpu->kvm))
>> 		return -EIO;
>>
>> Either way, to enable this by default we need some form of documentation that
>> describes what conditions lead to VM_CONTEXT_INVALID.

I still don't know why the conditions lead to it matters. I think the 
consensus is that once VM_CONTEXT_INVALID happens, the vcpu can no 
longer run. Either KVM_BUG_ON() or a specific EXIT to userspace should 
be OK?
