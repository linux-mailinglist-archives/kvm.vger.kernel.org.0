Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7E36C9E1A
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 10:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbjC0IjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 04:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbjC0Iis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 04:38:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420806190;
        Mon, 27 Mar 2023 01:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679905993; x=1711441993;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CwTyyQW4iRIx73+0zahTMIDt9YZj2NtiJZJdq6G+7h0=;
  b=ApuILe9cBktejN28MVyRD6iRQF3dZ/EZR6lPaFMGUzZgKMRO9khle6DO
   q7xjUBfFjlWygEfbLYeCQArUCuPFIBRoL22a0hzUyrWoCEbBE2+KyvnGZ
   VFn42pcLsp+hbmiVd9/Xqv+4d6iinluqx4rXQ/npCN28frrtLaiTH7rMO
   a6vRngSOo+U++wn+I4orpuit5haBNyHbsoR7B7eFGP9xPbytjRjYZWND3
   81Z3zVc8l4+oJcrCTDWmarWtJ+zGCG9TsxdeFXLd+vIqYCFOtRxItHYYd
   XYXu40072yRBwatROpVU8jd+l4iaE5Swn8Rw1Wf+oXo3C9fAy9eHvXUTd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="367953307"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="367953307"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 01:33:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="929381007"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="929381007"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.174.244]) ([10.249.174.244])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 01:33:10 -0700
Message-ID: <9261e319-084b-b6fe-550e-31b3683776c4@intel.com>
Date:   Mon, 27 Mar 2023 16:33:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH v4 6/6] KVM: VMX: Make CR0.WP a guest owned bit
Content-Language: en-US
To:     Mathias Krause <minipli@grsecurity.net>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-7-minipli@grsecurity.net>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230322013731.102955-7-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/2023 9:37 AM, Mathias Krause wrote:
> Guests like grsecurity that make heavy use of CR0.WP to implement kernel
> level W^X will suffer from the implied VMEXITs.
> 
> With EPT there is no need to intercept a guest change of CR0.WP, so
> simply make it a guest owned bit if we can do so.

I'm interested in the performance gain. Do you have data like Patch 2?

> This implies that a read of a guest's CR0.WP bit might need a VMREAD.
> However, the only potentially affected user seems to be kvm_init_mmu()
> which is a heavy operation to begin with. But also most callers already
> cache the full value of CR0 anyway, so no additional VMREAD is needed.
> The only exception is nested_vmx_load_cr3().
> 
> This change is VMX-specific, as SVM has no such fine grained control
> register intercept control.
> 
> Suggested-and-co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>   arch/x86/kvm/kvm_cache_regs.h |  2 +-
>   arch/x86/kvm/vmx/nested.c     |  4 ++--
>   arch/x86/kvm/vmx/vmx.c        |  2 +-
>   arch/x86/kvm/vmx/vmx.h        | 18 ++++++++++++++++++
>   4 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 4c91f626c058..e50d353b5c1c 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -4,7 +4,7 @@
>   
>   #include <linux/kvm_host.h>
>   
> -#define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
> +#define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
>   #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
>   	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
>   	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f63b28f46a71..61d940fc91ba 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4481,7 +4481,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>   	 * CR0_GUEST_HOST_MASK is already set in the original vmcs01
>   	 * (KVM doesn't change it);
>   	 */
> -	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
>   	vmx_set_cr0(vcpu, vmcs12->host_cr0);
>   
>   	/* Same as above - no reason to call set_cr4_guest_host_mask().  */
> @@ -4632,7 +4632,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
>   	 */
>   	vmx_set_efer(vcpu, nested_vmx_get_vmcs01_guest_efer(vmx));
>   
> -	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
>   	vmx_set_cr0(vcpu, vmcs_readl(CR0_READ_SHADOW));
>   
>   	vcpu->arch.cr4_guest_owned_bits = ~vmcs_readl(CR4_GUEST_HOST_MASK);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8fc1a0c7856f..e501f6864a72 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4790,7 +4790,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>   	/* 22.2.1, 20.8.1 */
>   	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
>   
> -	vmx->vcpu.arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
>   	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
>   
>   	set_cr4_guest_host_mask(vmx);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 2acdc54bc34b..423e9d3c9c40 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -640,6 +640,24 @@ BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
>   				(1 << VCPU_EXREG_EXIT_INFO_1) | \
>   				(1 << VCPU_EXREG_EXIT_INFO_2))
>   
> +static inline unsigned long vmx_l1_guest_owned_cr0_bits(void)
> +{
> +	unsigned long bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +
> +	/*
> +	 * CR0.WP needs to be intercepted when KVM is shadowing legacy paging
> +	 * in order to construct shadow PTEs with the correct protections.
> +	 * Note!  CR0.WP technically can be passed through to the guest if
> +	 * paging is disabled, but checking CR0.PG would generate a cyclical
> +	 * dependency of sorts due to forcing the caller to ensure CR0 holds
> +	 * the correct value prior to determining which CR0 bits can be owned
> +	 * by L1.  Keep it simple and limit the optimization to EPT.
> +	 */
> +	if (!enable_ept)
> +		bits &= ~X86_CR0_WP;
> +	return bits;
> +}
> +
>   static __always_inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
>   {
>   	return container_of(kvm, struct kvm_vmx, kvm);

