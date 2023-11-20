Return-Path: <kvm+bounces-2050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F8517F10E1
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 11:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B61611F23767
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 10:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42F18830;
	Mon, 20 Nov 2023 10:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GHGuLlS1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009B69D;
	Mon, 20 Nov 2023 02:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700477655; x=1732013655;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3iDX7dVKder9KQMVZYc3X0MGJbgyOtOSKFpY5c1P79w=;
  b=GHGuLlS1Dl18+vSO7adnYW0qXOScr5d5xqcCr+vT0ndKaH7wOy++dbJm
   5V/xN0B5BxDhvhHAv3xahnpK0BQBnX0atWMA6kVSE1J05SDCkO5563MVi
   UK1Y9mK2tierNKHyAqT59dKw72UOJPIak6KwdLtXopCe6BWStrZixNaHz
   GKkEQrlc+jimD7BQFZ+fto4MhXzTPdx39mL/VQ3iaMrF8wbwr9686MFNc
   Q6I5aSWO9tjDw8ptdsIVMKnuht2rZrjG+fTslek8yA/ujS2S5x4DKRyQ7
   Lg7VB+z5GBE3b9EP16CPwI9qDKkFP2O4RIv4tHN5clu/7M+DkTtj0RQuG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10899"; a="371773076"
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="371773076"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 02:54:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10899"; a="742691083"
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="742691083"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.180]) ([10.93.8.180])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 02:54:10 -0800
Message-ID: <8e0934a0-c478-413a-8a58-36f7d20c23e9@linux.intel.com>
Date: Mon, 20 Nov 2023 18:54:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/16] KVM: MMU: Introduce level info in PFERR code
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <ea9057ece714a919664e0403a3e7f774e4b3fedf.1699368363.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ea9057ece714a919664e0403a3e7f774e4b3fedf.1699368363.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> For TDX, EPT violation can happen when TDG.MEM.PAGE.ACCEPT.
> And TDG.MEM.PAGE.ACCEPT contains the desired accept page level of TD guest.
>
> 1. KVM can map it with 4KB page while TD guest wants to accept 2MB page.
>
>    TD geust will get TDX_PAGE_SIZE_MISMATCH and it should try to accept
s/geust/guest

>    4KB size.
>
> 2. KVM can map it with 2MB page while TD guest wants to accept 4KB page.
>
>    KVM needs to honor it because
>    a) there is no way to tell guest KVM maps it as 2MB size. And
>    b) guest accepts it in 4KB size since guest knows some other 4KB page
>       in the same 2MB range will be used as shared page.
>
> For case 2, it need to pass desired page level to MMU's
> page_fault_handler. Use bit 29:31 of kvm PF error code for this purpose.

The level info is needed not only for case 2, KVM also needs the info so 
that
it can map a 2MB page when TD guest wants to accept a 2MB page.


>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 +++
>   arch/x86/kvm/mmu/mmu.c          |  5 +++++
>   arch/x86/kvm/vmx/common.h       |  6 +++++-
>   arch/x86/kvm/vmx/tdx.c          | 15 ++++++++++++++-
>   arch/x86/kvm/vmx/tdx.h          | 19 +++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c          |  2 +-
>   6 files changed, 47 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index edcafcd650db..eed36c1eedb7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -261,6 +261,8 @@ enum x86_intercept_stage;
>   #define PFERR_FETCH_BIT 4
>   #define PFERR_PK_BIT 5
>   #define PFERR_SGX_BIT 15
> +#define PFERR_LEVEL_START_BIT 29
> +#define PFERR_LEVEL_END_BIT 31
>   #define PFERR_GUEST_FINAL_BIT 32
>   #define PFERR_GUEST_PAGE_BIT 33
>   #define PFERR_GUEST_ENC_BIT 34
> @@ -273,6 +275,7 @@ enum x86_intercept_stage;
>   #define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
>   #define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
>   #define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
> +#define PFERR_LEVEL_MASK	GENMASK_ULL(PFERR_LEVEL_END_BIT, PFERR_LEVEL_START_BIT)
>   #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
>   #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
>   #define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index eb17a508c5d1..265177cedf37 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4615,6 +4615,11 @@ bool __kvm_mmu_honors_guest_mtrrs(bool vm_has_noncoherent_dma)
>   
>   int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   {
> +	u8 err_level = (fault->error_code & PFERR_LEVEL_MASK) >> PFERR_LEVEL_START_BIT;
> +
> +	if (err_level)
> +		fault->max_level = min(fault->max_level, err_level);
> +
>   	/*
>   	 * If the guest's MTRRs may be used to compute the "real" memtype,
>   	 * restrict the mapping level to ensure KVM uses a consistent memtype
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 027aa4175d2c..bb00433932ee 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -67,7 +67,8 @@ static inline void vmx_handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
>   }
>   
>   static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
> -					     unsigned long exit_qualification)
> +					     unsigned long exit_qualification,
> +					     int err_page_level)
>   {
>   	u64 error_code;
>   
> @@ -90,6 +91,9 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>   	if (kvm_is_private_gpa(vcpu->kvm, gpa))
>   		error_code |= PFERR_GUEST_ENC_MASK;
>   
> +	if (err_page_level > 0)
> +		error_code |= (err_page_level << PFERR_LEVEL_START_BIT) & PFERR_LEVEL_MASK;
> +
>   	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>   }
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 31598b84811f..e4167f08b58b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1803,7 +1803,20 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>   
>   static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>   {
> +	union tdx_ext_exit_qualification ext_exit_qual;
>   	unsigned long exit_qual;
> +	int err_page_level = 0;
> +
> +	ext_exit_qual.full = tdexit_ext_exit_qual(vcpu);
> +
> +	if (ext_exit_qual.type >= NUM_EXT_EXIT_QUAL) {
Can we add unlikely() hint here?

> +		pr_err("EPT violation at gpa 0x%lx, with invalid ext exit qualification type 0x%x\n",
> +			tdexit_gpa(vcpu), ext_exit_qual.type);
> +		kvm_vm_bugged(vcpu->kvm);
> +		return 0;
> +	} else if (ext_exit_qual.type == EXT_EXIT_QUAL_ACCEPT) {
> +		err_page_level = tdx_sept_level_to_pg_level(ext_exit_qual.req_sept_level);
> +	}
>   
>   	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
>   		/*
> @@ -1830,7 +1843,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>   	}
>   
>   	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
> -	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
> +	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual, err_page_level);
>   }
>   
>   static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 54c3f6b83571..37ee944c36a1 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -72,6 +72,25 @@ union tdx_exit_reason {
>   	u64 full;
>   };
>   
> +union tdx_ext_exit_qualification {
> +	struct {
> +		u64 type		: 4;
> +		u64 reserved0		: 28;
> +		u64 req_sept_level	: 3;
> +		u64 err_sept_level	: 3;
> +		u64 err_sept_state	: 8;
> +		u64 err_sept_is_leaf	: 1;
> +		u64 reserved1		: 17;
> +	};
> +	u64 full;
> +};
> +
> +enum tdx_ext_exit_qualification_type {
> +	EXT_EXIT_QUAL_NONE,
> +	EXT_EXIT_QUAL_ACCEPT,
> +	NUM_EXT_EXIT_QUAL,
> +};
> +
>   struct vcpu_tdx {
>   	struct kvm_vcpu	vcpu;
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 28732925792e..ae9ba0731521 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5753,7 +5753,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>   	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
>   		return kvm_emulate_instruction(vcpu, 0);
>   
> -	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
> +	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification, 0);
>   }
>   
>   static int handle_ept_misconfig(struct kvm_vcpu *vcpu)


