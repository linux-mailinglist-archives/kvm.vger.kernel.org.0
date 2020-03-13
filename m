Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE94018401F
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 05:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgCME6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 00:58:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:42565 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgCME6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 00:58:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 21:58:03 -0700
X-IronPort-AV: E=Sophos;i="5.70,547,1574150400"; 
   d="scan'208";a="246595174"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.82]) ([10.238.4.82])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 12 Mar 2020 21:57:51 -0700
Subject: Re: [PATCH] KVM: VMX: Micro-optimize vmexit time when not exposing
 PMU
To:     Wanpeng Li <kernellwp@gmail.com>, like.xu@intel.com
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1584007547-4802-1-git-send-email-wanpengli@tencent.com>
 <87r1xxrhb0.fsf@vitty.brq.redhat.com>
 <CANRm+Cwawew=Xygxmzr2jmgPAKqDxvkqxxzjvoxnRRjC_Jx9Xw@mail.gmail.com>
 <79141339-3506-1fe4-2e69-8430f4c202bd@intel.com>
 <CANRm+Cw-t2GXnHjOTPEV6BjwZPDZpwvK4QrUNz+AU21UL4rEww@mail.gmail.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <cf873f0b-8f80-29d4-fce6-9b0380934356@linux.intel.com>
Date:   Fri, 13 Mar 2020 12:57:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cw-t2GXnHjOTPEV6BjwZPDZpwvK4QrUNz+AU21UL4rEww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/13 11:39, Wanpeng Li wrote:
> On Fri, 13 Mar 2020 at 11:23, Xu, Like <like.xu@intel.com> wrote:
>>
>> Hi Wanpeng,
>>
>> On 2020/3/12 19:05, Wanpeng Li wrote:
>>> On Thu, 12 Mar 2020 at 18:36, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>>> Wanpeng Li <kernellwp@gmail.com> writes:
>>>>
>>>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>>>
>>>>> PMU is not exposed to guest by most of cloud providers since the bad performance
>>>>> of PMU emulation and security concern. However, it calls perf_guest_switch_get_msrs()
>>>>> and clear_atomic_switch_msr() unconditionally even if PMU is not exposed to the
>>>>> guest before each vmentry.
>>>>>
>>>>> ~1.28% vmexit time reduced can be observed by kvm-unit-tests/vmexit.flat on my
>>>>> SKX server.
>>>>>
>>>>> Before patch:
>>>>> vmcall 1559
>>>>>
>>>>> After patch:
>>>>> vmcall 1539
>>>>>
>>>>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>>>>> ---
>>>>>    arch/x86/kvm/vmx/vmx.c | 3 +++
>>>>>    1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>>> index 40b1e61..fd526c8 100644
>>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>>> @@ -6441,6 +6441,9 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>>>>>         int i, nr_msrs;
>>>>>         struct perf_guest_switch_msr *msrs;
>>>>>
>>>>> +     if (!vcpu_to_pmu(&vmx->vcpu)->version)
>>>>> +             return;
>>>>> +
>>>>>         msrs = perf_guest_get_msrs(&nr_msrs);
>>>>>
>>>>>         if (!msrs)
>>>> Personally, I'd prefer this to be expressed as
>>>>
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index 40b1e6138cd5..ace92076c90f 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -6567,7 +6567,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>>
>>>>           pt_guest_enter(vmx);
>>>>
>>>> -       atomic_switch_perf_msrs(vmx);
>>>> +       if (vcpu_to_pmu(&vmx->vcpu)->version)
>> We may use 'vmx->vcpu.arch.pmu.version'.
> 
> Thanks for confirm this. Maybe this is better:
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 40b1e61..b20423c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6567,7 +6567,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> 
>          pt_guest_enter(vmx);
> 
> -       atomic_switch_perf_msrs(vmx);
> +       if (vcpu_to_pmu(vcpu)->version)
> +               atomic_switch_perf_msrs(vmx);

>          atomic_switch_umwait_control_msr(vmx);
> 
>          if (enable_preemption_timer)
> 
>>
>> I would vote in favor of adding the "unlikely (vmx->vcpu.arch.pmu.version)"
>> check to the atomic_switch_perf_msrs(), which follows pt_guest_enter(vmx).
> 
> This is hotpath, let's save the cost of function call.

You're right, I measured both.
We may fix pt_guest_enter() with static_branch_unlikely
for a little bit more micro-optimize as well.

Thanks,
Like Xu

> 
>      Wanpeng
> 
>>
>>>> +               atomic_switch_perf_msrs(vmx);
>>>> +
>>> I just hope the beautiful codes before, I testing this version before
>>> sending out the patch, ~30 cycles can be saved which means that ~2%
>>> vmexit time, will update in next version. Let's wait Paolo for other
>>> opinions below.
>>
>> You may factor the cost of the "pmu-> version check' itself (~10 cycles)
>> into your overall 'micro-optimize' revenue.
>>
>> Thanks,
>> Like Xu
>>>
>>>       Wanpeng
>>>
>>>> Also, (not knowing much about PMU), is
>>>> "vcpu_to_pmu(&vmx->vcpu)->version" check correct?
>>>>
>>>> E.g. in intel_is_valid_msr() correct for Intel PMU or is it stated
>>>> somewhere that it is generic rule?
>>>>
>>>> Also, speaking about cloud providers and the 'micro' nature of this
>>>> optimization, would it rather make sense to introduce a static branch
>>>> (the policy to disable vPMU is likely to be host wide, right)?
>>>>
>>>> --
>>>> Vitaly
>>>>
>>

