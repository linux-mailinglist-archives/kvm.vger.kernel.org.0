Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907CF183F9B
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 04:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgCMDXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 23:23:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:36154 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgCMDXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 23:23:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 20:23:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="232280339"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.82]) ([10.238.4.82])
  by orsmga007.jf.intel.com with ESMTP; 12 Mar 2020 20:23:29 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH] KVM: VMX: Micro-optimize vmexit time when not exposing
 PMU
To:     Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1584007547-4802-1-git-send-email-wanpengli@tencent.com>
 <87r1xxrhb0.fsf@vitty.brq.redhat.com>
 <CANRm+Cwawew=Xygxmzr2jmgPAKqDxvkqxxzjvoxnRRjC_Jx9Xw@mail.gmail.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <79141339-3506-1fe4-2e69-8430f4c202bd@intel.com>
Date:   Fri, 13 Mar 2020 11:23:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cwawew=Xygxmzr2jmgPAKqDxvkqxxzjvoxnRRjC_Jx9Xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Wanpeng,

On 2020/3/12 19:05, Wanpeng Li wrote:
> On Thu, 12 Mar 2020 at 18:36, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> Wanpeng Li <kernellwp@gmail.com> writes:
>>
>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>
>>> PMU is not exposed to guest by most of cloud providers since the bad performance
>>> of PMU emulation and security concern. However, it calls perf_guest_switch_get_msrs()
>>> and clear_atomic_switch_msr() unconditionally even if PMU is not exposed to the
>>> guest before each vmentry.
>>>
>>> ~1.28% vmexit time reduced can be observed by kvm-unit-tests/vmexit.flat on my
>>> SKX server.
>>>
>>> Before patch:
>>> vmcall 1559
>>>
>>> After patch:
>>> vmcall 1539
>>>
>>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>>> ---
>>>   arch/x86/kvm/vmx/vmx.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 40b1e61..fd526c8 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -6441,6 +6441,9 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>>>        int i, nr_msrs;
>>>        struct perf_guest_switch_msr *msrs;
>>>
>>> +     if (!vcpu_to_pmu(&vmx->vcpu)->version)
>>> +             return;
>>> +
>>>        msrs = perf_guest_get_msrs(&nr_msrs);
>>>
>>>        if (!msrs)
>> Personally, I'd prefer this to be expressed as
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 40b1e6138cd5..ace92076c90f 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -6567,7 +6567,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>
>>          pt_guest_enter(vmx);
>>
>> -       atomic_switch_perf_msrs(vmx);
>> +       if (vcpu_to_pmu(&vmx->vcpu)->version)
We may use 'vmx->vcpu.arch.pmu.version'.

I would vote in favor of adding the "unlikely (vmx->vcpu.arch.pmu.version)"
check to the atomic_switch_perf_msrs(), which follows pt_guest_enter(vmx).

>> +               atomic_switch_perf_msrs(vmx);
>> +
> I just hope the beautiful codes before, I testing this version before
> sending out the patch, ~30 cycles can be saved which means that ~2%
> vmexit time, will update in next version. Let's wait Paolo for other
> opinions below.

You may factor the cost of the "pmu-> version check' itself (~10 cycles)
into your overall 'micro-optimize' revenue.

Thanks,
Like Xu
>
>      Wanpeng
>
>> Also, (not knowing much about PMU), is
>> "vcpu_to_pmu(&vmx->vcpu)->version" check correct?
>>
>> E.g. in intel_is_valid_msr() correct for Intel PMU or is it stated
>> somewhere that it is generic rule?
>>
>> Also, speaking about cloud providers and the 'micro' nature of this
>> optimization, would it rather make sense to introduce a static branch
>> (the policy to disable vPMU is likely to be host wide, right)?
>>
>> --
>> Vitaly
>>

