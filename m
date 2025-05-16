Return-Path: <kvm+bounces-46764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B2CAB95D6
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 08:12:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23F091B65827
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 06:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E20822332E;
	Fri, 16 May 2025 06:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/wWULno"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57CF288DA;
	Fri, 16 May 2025 06:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747375954; cv=none; b=TUaSdDXlBJh3fbaiVFzt2rzq/yvwWv8x1zxItd4pKEp/BAtIyleN1MjVMNaphE8ZrsDVaYvlNI/I8x/I1FtZ35XYrHl0lAOa6YRKkIp9Fg5RW922STdq0C8UAfgjrIorxgYl64F9isIkv3f0sCF30vauQyULBIK/lgIA5TUN318=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747375954; c=relaxed/simple;
	bh=FXJJuD5jXOT+dSjJ8hYrzWm4ZIuQAV4ZkWc07jObaR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gi1Bx0YSo8QPwoge6c1wmr9mLShp9qT7OXg7HhvhbBaXX5YIYAByyupzy3+4cGBXelYOsxxm9LIqe427xjNVV83uTohkvMqr4VszJGJse1dHYApTZo/LxCNSppDUeIJ5545kMNjGuW71HHqhfmBF/P2wGLE6DUUwB2qgbZVsur8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/wWULno; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747375953; x=1778911953;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FXJJuD5jXOT+dSjJ8hYrzWm4ZIuQAV4ZkWc07jObaR0=;
  b=j/wWULnoLBLaLnccm+7RpPtL6AlBDL/XFHtai176Xv/NVzsQyeRzuFQj
   t5O1CutE5Ej5lOEL9kqYds6iJGW1BFxovwL2v78o2T9ZfK1qW8ujk7vgG
   CTCLqLWL7CDACp5hAQNSnLXijOGZ9PBLHKYMQlO/oNz3J8++F+uLaYxL9
   xZAh952OOn++KW+clbda2FVvJfSnknVb1I9127gEseLe0NVhMgM1Gx/5O
   bOgIXxxpGlRacFWsK6SClBGurJR5QtsNsI0Vezb9kDrfKr847/HKGAa3g
   m5TCyxMjfFNsVQ136wYIPPbuT/e9FSgmOErKv/2eKDylLW+WJwBphwdmd
   w==;
X-CSE-ConnectionGUID: cqaMnoj+RgezVE/nuYwjrA==
X-CSE-MsgGUID: cmqJAakUTtCvw5j1zo+F7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="71841926"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="71841926"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:12:31 -0700
X-CSE-ConnectionGUID: a30BiE9MSKaJm3NirxBLdg==
X-CSE-MsgGUID: t1KXl3QeSYmAIJXFwsvjDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="142601145"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:12:25 -0700
Message-ID: <f105f60b-5823-451f-ae26-8a103aa003d4@intel.com>
Date: Fri, 16 May 2025 14:12:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 12/21] KVM: TDX: Determine max mapping level according
 to vCPU's ACCEPT level
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "Shutemov, Kirill" <kirill.shutemov@intel.com>,
 "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
 <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "tabba@google.com" <tabba@google.com>, "Li, Zhiquan1"
 <zhiquan1.li@intel.com>, "Du, Fan" <fan.du@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "michael.roth@amd.com" <michael.roth@amd.com>,
 "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Peng, Chao P" <chao.p.peng@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>,
 "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
 "pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030713.403-1-yan.y.zhao@intel.com>
 <7307f6308d6e506bad00749307400fc6e65bc6e4.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <7307f6308d6e506bad00749307400fc6e65bc6e4.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/2025 5:20 AM, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:07 +0800, Yan Zhao wrote:
>> Determine the max mapping level of a private GFN according to the vCPU's
>> ACCEPT level specified in the TDCALL TDG.MEM.PAGE.ACCEPT.
>>
>> When an EPT violation occurs due to a vCPU invoking TDG.MEM.PAGE.ACCEPT
>> before any actual memory access, the vCPU's ACCEPT level is available in
>> the extended exit qualification. Set the vCPU's ACCEPT level as the max
>> mapping level for the faulting GFN. This is necessary because if KVM
>> specifies a mapping level greater than the vCPU's ACCEPT level, and no
>> other vCPUs are accepting at KVM's mapping level, TDG.MEM.PAGE.ACCEPT will
>> produce another EPT violation on the vCPU after re-entering the TD, with
>> the vCPU's ACCEPT level indicated in the extended exit qualification.
> 
> Maybe a little more info would help. It's because the TDX module wants to
> "accept" the smaller size in the real S-EPT, but KVM created a huge page. It
> can't demote to do this without help from KVM.
> 
>>
>> Introduce "violation_gfn_start", "violation_gfn_end", and
>> "violation_request_level" in "struct vcpu_tdx" to pass the vCPU's ACCEPT
>> level to TDX's private_max_mapping_level hook for determining the max
>> mapping level.
>>
>> Instead of taking some bits of the error_code passed to
>> kvm_mmu_page_fault() and requiring KVM MMU core to check the error_code for
>> a fault's max_level, having TDX's private_max_mapping_level hook check for
>> request level avoids changes to the KVM MMU core. This approach also
>> accommodates future scenarios where the requested mapping level is unknown
>> at the start of tdx_handle_ept_violation() (i.e., before invoking
>> kvm_mmu_page_fault()).
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>> ---
>>   arch/x86/kvm/vmx/tdx.c      | 36 +++++++++++++++++++++++++++++++++++-
>>   arch/x86/kvm/vmx/tdx.h      |  4 ++++
>>   arch/x86/kvm/vmx/tdx_arch.h |  3 +++
>>   3 files changed, 42 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 86775af85cd8..dd63a634e633 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -1859,10 +1859,34 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
>>   	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
>>   }
>>   
>> +static inline void tdx_get_accept_level(struct kvm_vcpu *vcpu, gpa_t gpa)
>> +{
>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +	int level = -1;
>> +
>> +	u64 eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
>> +
>> +	u32 eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
>> +			TDX_EXT_EXIT_QUAL_INFO_SHIFT;
>> +
>> +	if (eeq_type == TDX_EXT_EXIT_QUAL_TYPE_ACCEPT) {
>> +		level = (eeq_info & GENMASK(2, 0)) + 1;
>> +
>> +		tdx->violation_gfn_start = gfn_round_for_level(gpa_to_gfn(gpa), level);
>> +		tdx->violation_gfn_end = tdx->violation_gfn_start + KVM_PAGES_PER_HPAGE(level);
>> +		tdx->violation_request_level = level;
>> +	} else {
>> +		tdx->violation_gfn_start = -1;
>> +		tdx->violation_gfn_end = -1;
>> +		tdx->violation_request_level = -1;
> 
> We had some internal conversations on how KVM used to stuff a bunch of fault
> stuff in the vcpu so it didn't have to pass it around, but now uses the fault
> struct for this. The point was (IIRC) to prevent stale data from getting
> confused on future faults, and it being hard to track what came from where.
> 
> In the TDX case, I think the potential for confusion is still there. The MMU
> code could use stale data if an accept EPT violation happens and control returns
> to userspace, at which point userspace does a KVM_PRE_FAULT_MEMORY. Then it will
> see the stale  tdx->violation_*. Not exactly a common case, but better to not
> have loose ends if we can avoid it.
> 
> Looking more closely, I don't see why it's too hard to pass in a max_fault_level
> into the fault struct. Totally untested rough idea, what do you think?

the original huge page support patch did encode the level info in 
error_code. So it has my vote.

https://lore.kernel.org/all/4d61104bff388a081ff8f6ae4ac71e05a13e53c3.1708933624.git.isaku.yamahata@intel.com/

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index faae82eefd99..3dc476da6391 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -282,7 +282,11 @@ enum x86_intercept_stage;
>    * when the guest was accessing private memory.
>    */
>   #define PFERR_PRIVATE_ACCESS   BIT_ULL(49)
> -#define PFERR_SYNTHETIC_MASK   (PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS)
> +
> +#define PFERR_FAULT_LEVEL_MASK (BIT_ULL(50) | BIT_ULL(51) | BIT_ULL(52))
> +#define PFERR_FAULT_LEVEL_SHIFT 50
> +
> +#define PFERR_SYNTHETIC_MASK   (PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS |
> PFERR_FAULT_LEVEL_MASK)
>   
>   /* apic attention bits */
>   #define KVM_APIC_CHECK_VAPIC   0
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1c1764f46e66..bdb1b0eabd67 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -361,7 +361,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu
> *vcpu, gpa_t cr2_or_gpa,
>                  .nx_huge_page_workaround_enabled =
>                          is_nx_huge_page_enabled(vcpu->kvm),
>   
> -               .max_level = KVM_MAX_HUGEPAGE_LEVEL,
> +               .max_level = (err & PFERR_FAULT_LEVEL_MASK) >>
> PFERR_FAULT_LEVEL_SHIFT,
>                  .req_level = PG_LEVEL_4K,
>                  .goal_level = PG_LEVEL_4K,
>                  .is_private = err & PFERR_PRIVATE_ACCESS,
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 8f46a06e2c44..2f22b294ef8b 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -83,7 +83,8 @@ static inline bool vt_is_tdx_private_gpa(struct kvm *kvm,
> gpa_t gpa)
>   }
>   
>   static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
> -                                            unsigned long exit_qualification)
> +                                            unsigned long exit_qualification,
> +                                            u8 max_fault_level)
>   {
>          u64 error_code;
>   
> @@ -107,6 +108,10 @@ static inline int __vmx_handle_ept_violation(struct
> kvm_vcpu *vcpu, gpa_t gpa,
>          if (vt_is_tdx_private_gpa(vcpu->kvm, gpa))
>                  error_code |= PFERR_PRIVATE_ACCESS;
>   
> +       BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL >= (1 <<
> hweight64(PFERR_FAULT_LEVEL_MASK)));
> +
> +       error_code |= (u64)max_fault_level << PFERR_FAULT_LEVEL_SHIFT;
> +
>          return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>   }
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e994a6c08a75..19047de4d98d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2027,7 +2027,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>           * handle retries locally in their EPT violation handlers.
>           */
>          while (1) {
> -               ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
> +               ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual,
> KVM_MAX_HUGEPAGE_LEVEL);
>   
>                  if (ret != RET_PF_RETRY || !local_retry)
>                          break;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ef2d7208dd20..b70a2ff35884 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5782,7 +5782,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>          if (unlikely(allow_smaller_maxphyaddr && !kvm_vcpu_is_legal_gpa(vcpu,
> gpa)))
>                  return kvm_emulate_instruction(vcpu, 0);
>   
> -       return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
> +       return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification,
> KVM_MAX_HUGEPAGE_LEVEL);
>   }
>   
>   static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
> 
> 


