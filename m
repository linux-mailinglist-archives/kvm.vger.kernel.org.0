Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3D332CAAD
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 04:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhCDDDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 22:03:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:17919 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232102AbhCDDDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 22:03:10 -0500
IronPort-SDR: dvQBDC9pkS5tMZJA4Ns29E66bzQIqGTGF42ixSx5E2eQgyKPGzbYsUaB8xmk2PLKi1Mz+JauIw
 8VMYfn6y1K1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="186674934"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="186674934"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 19:02:29 -0800
IronPort-SDR: Cfmd6zW4Klj1dIlCxFCLxjPUOXywJAhceDtM7lI6c6/ciDnBy44aUlHYVa4arFRrwaMmoD83Oe
 XLDjK2QQix+g==
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="400284153"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 19:02:25 -0800
Subject: Re: [PATCH v3 7/9] KVM: vmx/pmu: Add Arch LBR emulation and its VMCS
 field
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-8-like.xu@linux.intel.com>
 <YD/GrQAl1NMPHXFj@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <267c408c-6999-649b-d733-8d64f9cf0594@intel.com>
Date:   Thu, 4 Mar 2021 11:02:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YD/GrQAl1NMPHXFj@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/4 1:26, Sean Christopherson wrote:
> On Wed, Mar 03, 2021, Like Xu wrote:
>> New VMX controls bits for Arch LBR are added. When bit 21 in vmentry_ctrl
>> is set, VM entry will write the value from the "Guest IA32_LBR_CTL" guest
>> state field to IA32_LBR_CTL. When bit 26 in vmexit_ctrl is set, VM exit
>> will clear IA32_LBR_CTL after the value has been saved to the "Guest
>> IA32_LBR_CTL" guest state field.
> ...
>
>> @@ -2529,7 +2532,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   	      VM_EXIT_LOAD_IA32_EFER |
>>   	      VM_EXIT_CLEAR_BNDCFGS |
>>   	      VM_EXIT_PT_CONCEAL_PIP |
>> -	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
>> +	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
>> +	      VM_EXIT_CLEAR_IA32_LBR_CTL;
> So, how does MSR_ARCH_LBR_CTL get restored on the host?  What if the host wants
> to keep _its_ LBR recording active while the guest is running?

Thank you!

I will add "host_lbrctlmsr" field to "struct vcpu_vmx" and
repeat the update/get_debugctlmsr() stuff.

>>   	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
>>   				&_vmexit_control) < 0)
>>   		return -EIO;
>> @@ -2553,7 +2557,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   	      VM_ENTRY_LOAD_IA32_EFER |
>>   	      VM_ENTRY_LOAD_BNDCFGS |
>>   	      VM_ENTRY_PT_CONCEAL_PIP |
>> -	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
>> +	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
>> +	      VM_ENTRY_LOAD_IA32_LBR_CTL;
>>   	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
>>   				&_vmentry_control) < 0)
>>   		return -EIO;
>> -- 
>> 2.29.2
>>

