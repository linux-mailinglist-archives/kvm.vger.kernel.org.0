Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE59758E74E
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiHJG37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiHJG35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:29:57 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AE76D9E5;
        Tue,  9 Aug 2022 23:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660112992; x=1691648992;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/Ds8O1YzSAsNmagYl2xaHo5bsSvzjPd1whfcQT8kpU0=;
  b=YsUmCycusRtcc0NO6oug1IUVKfqzzylcRuwBq63mj+anKCVyv7QU1lb2
   7Qp8TiOhCgbcYTmhDRqigHgx74m4Kowfu7xuXqM8tQI5ocq9pnuycbqqd
   S739npVbpjsiK+txbSHpwyUfPbRUQhW1GsuE5NdCnzqBy4KWlEAEls+ow
   98OJWHB18xJKdU5yHX7N8/MaX/jqt65XdXnghHRI5jfj3lZsTcyC/maSe
   eMtKzIuTL36e84e4lDWZ0V6Km5m5cpeTFAazx+5bwBw6c6qT1db5yxukH
   7KCjVFD56W6G1y9lV4m7ZwfYqmPlzwdDFYUWco+a8wNJgw5czzcA9FWSS
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="355010827"
X-IronPort-AV: E=Sophos;i="5.93,226,1654585200"; 
   d="scan'208";a="355010827"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 23:29:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,226,1654585200"; 
   d="scan'208";a="664761300"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.173.89]) ([10.249.173.89])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 23:29:50 -0700
Message-ID: <40c9ecc1-e223-160b-4939-07e4f7200781@intel.com>
Date:   Wed, 10 Aug 2022 14:29:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [RFC PATCH 3/3] KVM: x86: Disallow writes to immutable feature
 MSRs after KVM_RUN
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20220805172945.35412-1-seanjc@google.com>
 <20220805172945.35412-4-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220805172945.35412-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/6/2022 1:29 AM, Sean Christopherson wrote:
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
>   arch/x86/kvm/x86.c | 37 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 37 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1c65b77fb16..4da26a1f14c1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1541,6 +1541,26 @@ static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
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
> +
>   static u64 kvm_get_arch_capabilities(void)
>   {
>   	u64 data = 0;
> @@ -2136,6 +2156,23 @@ static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
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

can we extract "vcpu->arch.last_vmentry_cpu != -1" into a function like 
kvm_vcpu_has_runned() ?

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

