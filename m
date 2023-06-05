Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A271721BB8
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 03:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbjFEB5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 21:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjFEB5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 21:57:47 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478389E;
        Sun,  4 Jun 2023 18:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685930266; x=1717466266;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QBoebP1n4VeEjg1QFqOqDuX/jdvuOnD7tkDfTVYNhA8=;
  b=XXXO4XikMcYE/zQGSvSZsvaAr75VTbHrsOs105MpZcvoSr5INt1LDCvq
   Ge0n2p6v1dt6LbVFSjBa4OUHCllvENwAh/qK3II4YvbcOTlcCbPjpb+V0
   l9z9H44lhHKzEz16WTMZty5vZk9I2QLq57E+aESEfBTB8z+IMed2J4pzs
   4sfxuGqzgoy4pQQbdvkjbl6YhebLZjonIqtYXDq+zN92Do377Snm2Chxs
   6VYdUu8FOmAOjo3K+VfF8HtueSvsdEb/FAU5mFm3mv+onHyqbE8CMdPaT
   WaP96T1zqI/NnHu+fI8PzW9qtp0F9/oEoBbau5Q9vushw6y5acke8BTJ0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="340893871"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="340893871"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 18:57:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="852807827"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="852807827"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.1.148]) ([10.238.1.148])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 18:57:43 -0700
Message-ID: <7335a53b-5b6a-f186-d3b9-99569aa2559c@linux.intel.com>
Date:   Mon, 5 Jun 2023 09:57:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v1 2/6] KVM: x86: Virtualize CR4.LASS
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-3-guang.zeng@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230601142309.6307-3-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/1/2023 10:23 PM, Zeng Guang wrote:
> Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
> as CR4.LASS generally set once for each vCPU at boot time and won't be
> toggled at runtime. Besides, only if VM has LASS capability enumerated with
> CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to be able
> to set CR4.LASS.
>
> Updating cr4_fixed1 to set CR4.LASS bit in the emulated IA32_VMX_CR4_FIXED1
> MSR for guests and allow guests to enable LASS in nested VMX operaion as well.
s/operaion/operation

>
> Notes: Setting CR4.LASS to 1 enable LASS in IA-32e mode. It doesn't take
> effect in legacy mode even if CR4.LASS is set.
>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 2 +-
>   arch/x86/kvm/vmx/vmx.c          | 3 +++
>   arch/x86/kvm/x86.h              | 2 ++
>   3 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fb9d1f2d6136..92d8e65fe88c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -125,7 +125,7 @@
>   			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>   			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>   			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP | X86_CR4_LASS))
Suppose there is some bare-matel linux patch to define the LASS related 
macros.
May be better to describe the dependent patch(es) in cover letter.


>   
>   #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 44fb619803b8..a33205ded85c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7603,6 +7603,9 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>   	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
>   	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
>   
> +	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
> +	cr4_fixed1_update(X86_CR4_LASS,       eax, feature_bit(LASS));
> +
>   #undef cr4_fixed1_update
>   }
>   
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index c544602d07a3..e1295f490308 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -529,6 +529,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>   		__reserved_bits |= X86_CR4_VMXE;        \
>   	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
>   		__reserved_bits |= X86_CR4_PCIDE;       \
> +	if (!__cpu_has(__c, X86_FEATURE_LASS))          \
> +		__reserved_bits |= X86_CR4_LASS;        \
>   	__reserved_bits;                                \
>   })
>   

