Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB8D32E247
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 07:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhCEGgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 01:36:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:45346 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhCEGgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 01:36:06 -0500
IronPort-SDR: vtv4XS9sQQYA+jov34aDTMi3NisvRjcjSSK54EJ24hVuPDKKdbZYbfxjA34jDeW1/r9QoYon3b
 HC8sDMJS558Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="187641956"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="187641956"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 22:36:05 -0800
IronPort-SDR: L/1Rakrn0nPUwl8ADcVyGcPU8fhOU6QO3BmPgqolDprzfIJ2lZtgsamH2Fss42/ezLA7Y4j5Nv
 sJkx+JVso6QQ==
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="401171163"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 22:36:01 -0800
Subject: Re: [PATCH v3 7/9] KVM: vmx/pmu: Add Arch LBR emulation and its VMCS
 field
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-8-like.xu@linux.intel.com>
 <YD/GrQAl1NMPHXFj@google.com>
 <267c408c-6999-649b-d733-8d64f9cf0594@intel.com>
 <YEEXqf3b4uaSdNKv@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <dfaf5f35-c288-64a7-bbb6-bdee52784121@intel.com>
Date:   Fri, 5 Mar 2021 14:35:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YEEXqf3b4uaSdNKv@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/5 1:23, Sean Christopherson wrote:
> On Thu, Mar 04, 2021, Xu, Like wrote:
>> On 2021/3/4 1:26, Sean Christopherson wrote:
>>> On Wed, Mar 03, 2021, Like Xu wrote:
>>>> New VMX controls bits for Arch LBR are added. When bit 21 in vmentry_ctrl
>>>> is set, VM entry will write the value from the "Guest IA32_LBR_CTL" guest
>>>> state field to IA32_LBR_CTL. When bit 26 in vmexit_ctrl is set, VM exit
>>>> will clear IA32_LBR_CTL after the value has been saved to the "Guest
>>>> IA32_LBR_CTL" guest state field.
>>> ...
>>>
>>>> @@ -2529,7 +2532,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>>>    	      VM_EXIT_LOAD_IA32_EFER |
>>>>    	      VM_EXIT_CLEAR_BNDCFGS |
>>>>    	      VM_EXIT_PT_CONCEAL_PIP |
>>>> -	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
>>>> +	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
>>>> +	      VM_EXIT_CLEAR_IA32_LBR_CTL;
>>> So, how does MSR_ARCH_LBR_CTL get restored on the host?  What if the host wants
>>> to keep _its_ LBR recording active while the guest is running?
>> Thank you!
>>
>> I will add "host_lbrctlmsr" field to "struct vcpu_vmx" and
>> repeat the update/get_debugctlmsr() stuff.
> I am not remotely confident that tracking LBRCTL via vcpu_vmx is correct, and
> I'm far less confident that the existing DEBUGCTL logic is correct.  As Jim
> pointed out[*], intel_pmu_handle_irq() can run at any time, and it's not at all
> clear to me that the DEBUGCTL coming out of the NMI handler is guaranteed to be
> the same value going in.  Ditto for LBRCTL.

It's not true for "Ditto for LBRCTL".

Because the usage of ARCH_LBR_CTL is specified for LBR,
not the shared case of DEBUGCTL. And all LBR events created from
KVM or host perf syscall are all under the control of host perf subsystem.

The irq handler would restore the original value of the ARCH_LBR_CTL
even it's called after the KVM snapshots DEBUCTL on vCPU load.
The change is transparent to the update_lbrctlmsr() and get_lbrctlmsr().

> Actually, NMIs aside, KVM's DEBUGCTL handling is provably broken since writing
> /sys/devices/cpu/freeze_on_smi is propagated to other CPUs via IRQ, and KVM
> snapshots DEBUCTL on vCPU load, i.e. runs with IRQs enabled long after grabbing
> the value.
>
>    WARNING: CPU: 5 PID: 0 at arch/x86/events/intel/core.c:4066 flip_smm_bit+0xb/0x30
>    RIP: 0010:flip_smm_bit+0xb/0x30
>    Call Trace:
>     <IRQ>
>     flush_smp_call_function_queue+0x118/0x1a0
>     __sysvec_call_function+0x2c/0x90
>     asm_call_irq_on_stack+0x12/0x20
>     </IRQ>

This kind of bug with the keyword "flip_smm_bit" did not appear on the 
mailing list.
Would you mind to share testcases or more details about the steps to 
reproduce ?

>
> So, rather than pile on more MSR handling that is at best dubious, and at worst
> broken, I would like to see KVM properly integrate with perf to ensure KVM
> restores the correct, fresh values of all MSRs that are owned by perf.  Or at
> least add something that guarantees that intel_pmu_handle_irq() preserves the
> MSRs.  As is, it's impossible to review these KVM changes without deep, deep
> knowledge of what perf is doing.

Jim complained more about the inconsistent maintenance of
MSR_IA32_PEBS_ENABLE between KVM and perf subsystem.

The issue bothers the host due to the subsystem integration,
but the guest's use of PBES will be safe and reliable.

We could cover more details in the guest PEBS enabling thread.

>
> https://lkml.kernel.org/r/20210209225653.1393771-1-jmattson@google.com

