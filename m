Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DC66B446
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 04:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfGQCDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 22:03:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:45638 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbfGQCDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 22:03:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 19:03:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,272,1559545200"; 
   d="scan'208";a="366860947"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.165]) ([10.239.196.165])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jul 2019 19:03:28 -0700
Subject: Re: [PATCH v7 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
From:   Tao Xu <tao3.xu@intel.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, fenghua.yu@intel.com,
        xiaoyao.li@linux.intel.com, jingqi.liu@intel.com
References: <20190712082907.29137-1-tao3.xu@intel.com>
 <20190712082907.29137-3-tao3.xu@intel.com>
 <20190716160358.GE26800@habkost.net>
 <ec13a518-6dcb-fc87-36e6-31befd62281e@intel.com>
Message-ID: <bcc75abe-44a8-acd8-570b-4dbc0ad97c09@intel.com>
Date:   Wed, 17 Jul 2019 10:03:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ec13a518-6dcb-fc87-36e6-31befd62281e@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/17/2019 9:17 AM, Tao Xu wrote:
> On 7/17/2019 12:03 AM, Eduardo Habkost wrote:
>> On Fri, Jul 12, 2019 at 04:29:06PM +0800, Tao Xu wrote:
>>> UMWAIT and TPAUSE instructions use IA32_UMWAIT_CONTROL at MSR index E1H
>>> to determines the maximum time in TSC-quanta that the processor can 
>>> reside
>>> in either C0.1 or C0.2.
>>>
>>> This patch emulates MSR IA32_UMWAIT_CONTROL in guest and differentiate
>>> IA32_UMWAIT_CONTROL between host and guest. The variable
>>> mwait_control_cached in arch/x86/power/umwait.c caches the MSR value, so
>>> this patch uses it to avoid frequently rdmsr of IA32_UMWAIT_CONTROL.
>>>
>>> Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
>>> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
>>> Signed-off-by: Tao Xu <tao3.xu@intel.com>
>>> ---
>> [...]
>>> +static void atomic_switch_umwait_control_msr(struct vcpu_vmx *vmx)
>>> +{
>>> +    if (!vmx_has_waitpkg(vmx))
>>> +        return;
>>> +
>>> +    if (vmx->msr_ia32_umwait_control != umwait_control_cached)
>>> +        add_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL,
>>> +            vmx->msr_ia32_umwait_control,
>>> +            umwait_control_cached, false);
>>
>> How exactly do we ensure NR_AUTOLOAD_MSRS (8) is still large enough?
>>
>> I see 3 existing add_atomic_switch_msr() calls, but the one at
>> atomic_switch_perf_msrs() is in a loop.  Are we absolutely sure
>> that perf_guest_get_msrs() will never return more than 5 MSRs?
>>
> 
> Quote the code of intel_guest_get_msrs:
> 
> static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
> {
> [...]
>      arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>      arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
>      arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
>      if (x86_pmu.flags & PMU_FL_PEBS_ALL)
>          arr[0].guest &= ~cpuc->pebs_enabled;
>      else
>          arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
>      *nr = 1;
> 
>      if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
> [...]
>          arr[1].msr = MSR_IA32_PEBS_ENABLE;
>          arr[1].host = cpuc->pebs_enabled;
>          arr[1].guest = 0;
>          *nr = 2;
> [...]
> 
> There are most 2 msrs now. By default umwait is disabled in KVM. So by 
> default there is no MSR_IA32_UMWAIT_CONTROL added into 
> add_atomic_switch_msr().
> 
> Thanks.

And for old hardware, kvm use core_guest_get_msrs, but umwait is for now 
hardware, and if hardware in host doesn't have the cpuid, there is no 
MSR_IA32_UMWAIT_CONTROL in kvm as well.

>>
>>> +    else
>>> +        clear_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL);
>>> +}
>>> +
>>>   static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
>>>   {
>>>       vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
>> [...]
>>
>>
> 

