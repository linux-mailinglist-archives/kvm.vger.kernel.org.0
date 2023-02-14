Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D5969594B
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjBNGja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjBNGj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:39:28 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B573D12F;
        Mon, 13 Feb 2023 22:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676356767; x=1707892767;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MwoImmZu74W1fLHqnSO9JDAEUROodv8SGTBU6Ro116Q=;
  b=Ge9T6rv6qz9uQ9asq9WYmoba5yf+de5PdhDu8CoyCBq8IDakxEFH38GA
   fTdjvgDREQbi/hLHc6CcyXp1Zp05RE4KWczjT3SNgakib9Javb9KQtjih
   sJ8YI7EdfvvNsHn5aONFz1o2xU8bM54dp2x9hEh1MQIDtgK3GfN2Sxyv/
   ymwR7FhCBkBiWUsQldD8n8i+OmYNtkYQkWSzsQu29kBlVBBqRU0RN5X8X
   Gx5/7qXetz3ThuLH+vHl5JqbZ8l8IC4mNvCGncf0L3qQ5ehuwnCiKNyjK
   jTealBFv/Bycr0I6AUU/ZG7WA/RTLn1T/S9sRIxfAjBFiTXrLTXSdGR7q
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314735682"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="314735682"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:39:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="662449700"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="662449700"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.2]) ([10.255.31.2])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:39:25 -0800
Message-ID: <eec89d0d-c1ef-1035-3383-3c5a29e6e8a2@intel.com>
Date:   Tue, 14 Feb 2023 14:39:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.2
Subject: Re: [PATCH v2 05/21] KVM: x86: Disallow writes to immutable feature
 MSRs after KVM_RUN
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-6-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230210003148.2646712-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maybe be more clearer in the title to reflect what the patch really does

KVM: x86: Disallow writes to immutable feature MSRs from user space 
after KVM_RUN

On 2/10/2023 8:31 AM, Sean Christopherson wrote:
> Disallow writes to feature MSRs after KVM_RUN to prevent userspace from
> changing the vCPU model after running the vCPU.  Similar to guest CPUID,
> KVM uses feature MSRs to configure intercepts, determine what operations
> are/aren't allowed, etc.  Changing the capabilities while the vCPU is
> active will at best yield unpredictable guest behavior, and at worst
> could be dangerous to KVM.
> 
> Allow writing the current value, e.g. so that userspace can blindly set
> all MSRs when emulating RESET, and unconditionally allow writes to
> MSR_IA32_UCODE_REV so that userspace can emulate patch loads.
> 
> Special case the VMX MSRs to keep the generic list small, i.e. so that
> KVM can do a linear walk of the generic list without incurring meaningful
> overhead.
> 
> Cc: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 36 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 36 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7b73a0b45041..186cb6a81643 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1554,6 +1554,25 @@ static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
>   			      (KVM_LAST_EMULATED_VMX_MSR - KVM_FIRST_EMULATED_VMX_MSR + 1)];
>   static unsigned int num_msr_based_features;
>   
> +/*
> + * All feature MSRs except uCode revID, which tracks the currently loaded uCode
> + * patch, are immutable once the vCPU model is defined.
> + */
> +static bool kvm_is_immutable_feature_msr(u32 msr)
> +{
> +	int i;
> +
> +	if (msr >= KVM_FIRST_EMULATED_VMX_MSR && msr <= KVM_LAST_EMULATED_VMX_MSR)
> +		return true;
> +
> +	for (i = 0; i < ARRAY_SIZE(msr_based_features_all_except_vmx); i++) {
> +		if (msr == msr_based_features_all_except_vmx[i])
> +			return msr != MSR_IA32_UCODE_REV;
> +	}
> +
> +	return false;
> +}
> +
>   /*
>    * Some IA32_ARCH_CAPABILITIES bits have dependencies on MSRs that KVM
>    * does not yet virtualize. These include:
> @@ -2168,6 +2187,23 @@ static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>   
>   static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>   {
> +	u64 val;
> +
> +	/*
> +	 * Disallow writes to immutable feature MSRs after KVM_RUN.  KVM does
> +	 * not support modifying the guest vCPU model on the fly, e.g. changing
> +	 * the nVMX capabilities while L2 is running is nonsensical.  Ignore
> +	 * writes of the same value, e.g. to allow userspace to blindly stuff
> +	 * all MSRs when emulating RESET.
> +	 */
> +	if (vcpu->arch.last_vmentry_cpu != -1 &&

after this replaced with the helper,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> +	    kvm_is_immutable_feature_msr(index)) {
> +		if (do_get_msr(vcpu, index, &val) || *data != val)
> +			return -EINVAL;
> +
> +		return 0;
> +	}
> +
>   	return kvm_set_msr_ignored_check(vcpu, index, *data, true);
>   }
>   

