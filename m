Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636F6707CF1
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 11:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjERJcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 05:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjERJcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 05:32:39 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF741990;
        Thu, 18 May 2023 02:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684402356; x=1715938356;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ufC3GRA8nPg5qrCMUy5LcfZUCIfhhLVoJdgjOUeXBI0=;
  b=aedFIOrwH6fDk4Y6PpJj4Y2A4UxzBemDge7EQ+3QT5lsjx8HxPeacNVx
   t4mAJdPwXlitE/oz2NPL8CXQm83y6m6XA06e1kV7etZRHwJTIwQ9zV8/F
   Og3ueWtNNGaIWTWi31Hl1aryQ+wF3rhzBa0LFod7mxUtwfERMAaZWwJp/
   d+RmLCIZOsTHgUVLG16PqUIA4skmdhUk1OGHBQeR3vlT34wHKOfKhUrj6
   AVlrw/3ZTxf0CG0K/05dFbveAanSvmAZN90n8FKSRNnVF2CioyhQ/4QOs
   3rYassVzV3hgI7nBY0tt1riwehiKMRwSLPf4crj8RbGXF7RT36eTh+Lyx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="350854788"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="350854788"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:32:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="771809523"
X-IronPort-AV: E=Sophos;i="5.99,284,1677571200"; 
   d="scan'208";a="771809523"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.211.142]) ([10.254.211.142])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 02:32:33 -0700
Message-ID: <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
Date:   Thu, 18 May 2023 17:32:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230506030435.80262-1-chao.gao@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230506030435.80262-1-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/2023 11:04 AM, Chao Gao wrote:
> to avoid computing the supported value at runtime every time.
> 
> No functional change intended.

the value of kvm_get_arch_capabilities() can be changed due to

	if (l1tf_vmx_mitigation != VMENTER_L1D_FLUSH_NEVER)
		data |= ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;

and l1tf_vmx_mitigation can be runtime changed by vmentry_l1d_flush 
module param.

We need a detailed analysis that in no real case can 
ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit change runtime.

> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
> 
> A new call site of kvm_get_arch_capabilities() is added by [1]. It should be
> replaced with the cached value in kvm_caps.
> 
> [1] https://lore.kernel.org/all/20230504181827.130532-1-mizhang@google.com/
> 
> 
>   arch/x86/kvm/x86.c | 5 +++--
>   arch/x86/kvm/x86.h | 1 +
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 523c39a03c00..94aa70ec169c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1670,7 +1670,7 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>   {
>   	switch (msr->index) {
>   	case MSR_IA32_ARCH_CAPABILITIES:
> -		msr->data = kvm_get_arch_capabilities();
> +		msr->data = kvm_caps.supported_arch_cap;
>   		break;
>   	case MSR_IA32_PERF_CAPABILITIES:
>   		msr->data = kvm_caps.supported_perf_cap;
> @@ -9523,6 +9523,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   		kvm_caps.max_guest_tsc_khz = max;
>   	}
>   	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
> +	kvm_caps.supported_arch_cap = kvm_get_arch_capabilities();
>   	kvm_init_msr_lists();
>   	return 0;
>   
> @@ -11879,7 +11880,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	if (r)
>   		goto free_guest_fpu;
>   
> -	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
> +	vcpu->arch.arch_capabilities = kvm_caps.supported_arch_cap;
>   	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>   	kvm_xen_init_vcpu(vcpu);
>   	kvm_vcpu_mtrr_init(vcpu);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index c544602d07a3..d3e524bcc169 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -29,6 +29,7 @@ struct kvm_caps {
>   	u64 supported_xcr0;
>   	u64 supported_xss;
>   	u64 supported_perf_cap;
> +	u64 supported_arch_cap;
>   };
>   
>   void kvm_spurious_fault(void);
> 
> base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac

