Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA467102C7
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 04:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbjEYCRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 22:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjEYCRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 22:17:31 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92E9D3;
        Wed, 24 May 2023 19:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684981049; x=1716517049;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WrWZq5A0Y0+gKqSzJZLWZdy8D3Hmwx0TVD7g+39zT+Q=;
  b=ACrzPIDFPo6tbUiwCFZBt8l2DbVUeG+yRtvWpq5pDnK2I/bianW10JrL
   1X/QdVO2kYUMi7q8Rr1laCUUsEpNveju5npcuVpI1UEd/SaiifWm6YEwx
   ZplkNjvaNEjxE/M8AW9PrzH4acjLkY/mCc0SU7V/XurJyQC/Njbnz9Qi5
   QcLE5UL1Vn2157fdSRRRABvAKB41tx+4ioe0yOG0qHkQmhmFuxCH+2tR/
   9yzEDX54WkJwBHgAASCTihruerUEbx0JHdb/q8+NWiAPEMJCjQg6r3rhv
   0REwNvIDJOpPeGiO+SpJ8zaL90RJmfIN+DJBrTjvPRxbWh3+h2OeBEUpO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="338327655"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="338327655"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 19:17:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="1034787206"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="1034787206"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.126]) ([10.249.175.126])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 19:17:26 -0700
Message-ID: <9fb5109e-1ac0-750e-ccc5-759a04f18475@intel.com>
Date:   Thu, 25 May 2023 10:17:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v2 1/3] KVM: x86: Track supported ARCH_CAPABILITIES in
 kvm_caps
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230524061634.54141-1-chao.gao@intel.com>
 <20230524061634.54141-2-chao.gao@intel.com>
 <fc72da6d-2f70-63c8-dd6b-f8f8df862b89@intel.com>
 <ZG3LpLR7itO4dI8U@chao-email>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZG3LpLR7itO4dI8U@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/2023 4:32 PM, Chao Gao wrote:
> On Wed, May 24, 2023 at 04:14:10PM +0800, Xiaoyao Li wrote:
>> On 5/24/2023 2:16 PM, Chao Gao wrote:
>>> to avoid computing the supported value at runtime every time.
>>>
>>> Toggle the ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit when l1tf_vmx_mitigation
>>> is modified to achieve the same result as runtime computing.
>>
>> It's not the same result.
> 
> it is because ...
> 
>>
>> In kvm_get_arch_capabilities(), host's value is honored. I.e., when host
>> supports ARCH_CAP_SKIP_VMENTRY_L1DFLUSH, l1tf_vmx_mitigation doesn't make any
>> difference to the result.
> 
> ... l1tf_vmx_mitigation should be VMENTER_L1D_FLUSH_NOT_REQUIRED in this
> case. l1tf_vmx_mitigation cannot be VMENTER_L1D_FLUSH_NEVER.

yes. you are right. Maybe we can clarify it in the changelog

anyway,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>>
>>> Opportunistically, add a comment to document the problem of allowing
>>> changing the supported value of ARCH_CAPABILITIES and the reason why
>>> we don't fix it.
>>>
>>> No functional change intended.
>>>
>>> Link: https://lore.kernel.org/all/ZGZhW%2Fx5OWPmx1qD@google.com/
>>> Link: https://lore.kernel.org/all/ZGeU9sYTPxqNGSqI@google.com/
>>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>>> ---
>>>    arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++++++--
>>>    arch/x86/kvm/x86.c     |  7 ++++---
>>>    arch/x86/kvm/x86.h     |  1 +
>>>    3 files changed, 28 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 44fb619803b8..8274ef5e89e5 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -309,10 +309,31 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
>>>    	l1tf_vmx_mitigation = l1tf;
>>> -	if (l1tf != VMENTER_L1D_FLUSH_NEVER)
>>> +	/*
>>> +	 * Update static keys and supported arch capabilities according to
>>> +	 * the new mitigation state.
>>> +	 *
>>> +	 * ARCH_CAP_SKIP_VMENTRY_L1DFLUSH is toggled because if we do cache
>>> +	 * flushes for L1 guests on (nested) vmlaunch/vmresume to L2, L1
>>> +	 * guests can skip the flush and if we don't, then L1 guests need
>>> +	 * to do a flush.
>>> +	 *
>>> +	 * Toggling ARCH_CAP_SKIP_VMENTRY_L1DFLUSH may present inconsistent
>>> +	 * model to the guest, e.g., if userspace isn't careful, a VM can
>>> +	 * have vCPUs with different values for ARCH_CAPABILITIES. But
>>> +	 * there is almost no chance to fix the issue. Because, to present
>>> +	 * a consistent model, KVM essentially needs to disallow changing
>>> +	 * the module param after VMs/vCPUs have been created, but that
>>> +	 * would prevent userspace from toggling the param while VMs are
>>> +	 * running, e.g., in response to a new vulnerability.
>>> +	 */
>>> +	if (l1tf != VMENTER_L1D_FLUSH_NEVER) {
>>>    		static_branch_enable(&vmx_l1d_should_flush);
>>> -	else
>>> +		kvm_caps.supported_arch_cap |= ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
>>> +	} else {
>>>    		static_branch_disable(&vmx_l1d_should_flush);
>>> +		kvm_caps.supported_arch_cap &= ~ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
>>> +	}
>>>    	if (l1tf == VMENTER_L1D_FLUSH_COND)
>>>    		static_branch_enable(&vmx_l1d_flush_cond);
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index c0778ca39650..2408b5f554b7 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -1672,7 +1672,7 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>>>    {
>>>    	switch (msr->index) {
>>>    	case MSR_IA32_ARCH_CAPABILITIES:
>>> -		msr->data = kvm_get_arch_capabilities();
>>> +		msr->data = kvm_caps.supported_arch_cap;
>>>    		break;
>>>    	case MSR_IA32_PERF_CAPABILITIES:
>>>    		msr->data = kvm_caps.supported_perf_cap;
>>> @@ -7156,7 +7156,7 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>>>    			return;
>>>    		break;
>>>    	case MSR_IA32_TSX_CTRL:
>>> -		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
>>> +		if (!(kvm_caps.supported_arch_cap & ARCH_CAP_TSX_CTRL_MSR))
>>>    			return;
>>>    		break;
>>>    	default:
>>> @@ -9532,6 +9532,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>>>    		kvm_caps.max_guest_tsc_khz = max;
>>>    	}
>>>    	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
>>> +	kvm_caps.supported_arch_cap = kvm_get_arch_capabilities();
>>>    	kvm_init_msr_lists();
>>>    	return 0;
>>> @@ -11895,7 +11896,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>>    	if (r)
>>>    		goto free_guest_fpu;
>>> -	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
>>> +	vcpu->arch.arch_capabilities = kvm_caps.supported_arch_cap;
>>>    	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>>>    	kvm_xen_init_vcpu(vcpu);
>>>    	kvm_vcpu_mtrr_init(vcpu);
>>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>>> index c544602d07a3..d3e524bcc169 100644
>>> --- a/arch/x86/kvm/x86.h
>>> +++ b/arch/x86/kvm/x86.h
>>> @@ -29,6 +29,7 @@ struct kvm_caps {
>>>    	u64 supported_xcr0;
>>>    	u64 supported_xss;
>>>    	u64 supported_perf_cap;
>>> +	u64 supported_arch_cap;
>>>    };
>>>    void kvm_spurious_fault(void);
>>

