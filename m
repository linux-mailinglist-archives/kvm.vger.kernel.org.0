Return-Path: <kvm+bounces-4308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4281D810CEE
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 10:05:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F9642815E4
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 09:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2048F1EB50;
	Wed, 13 Dec 2023 09:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rp6PUIPp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF95AB;
	Wed, 13 Dec 2023 01:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702458301; x=1733994301;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XMwYb6E5n1kkH4le2ypm2BfDPNi79ZDLCGsQ36e5vtM=;
  b=Rp6PUIPpJHYvter17GtaYEzSswpetDVBB9P9NHqv31Xdqj0ygvXtKa+i
   knZfOB6UC2kWbY8/vJ/IxWTey17f/Z/HVlxkMZC9xLxwAvJN2EXJu2Eaw
   DstebmC8ynTpuRAGHxp8gRBC0P0YzY0mOMDXBIlTHe049wIoMBkjSYy3U
   0O5tuRcePTmuZ2mcebr5PtzEZzBIpHUEm4OAVmC6LZVR0/Bo5PMyDse2y
   rhCd/CmTjoOdDoNZQoDCNt4nLWwvqKFs077d/hNvFn9Nn0leY15OTTzpY
   NAz8fRrAyBcQDtw49oYbCp8Yfls9qOADX0bXQ681Edh9C+3fEZmPgc91v
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="13631240"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="13631240"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 01:05:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="17664934"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.2.128]) ([10.238.2.128])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 01:04:56 -0800
Message-ID: <c8e33fa0-49a1-43d2-9500-a94e951a0d45@linux.intel.com>
Date: Wed, 13 Dec 2023 17:04:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 029/116] KVM: x86/mmu: Add address conversion
 functions for TDX shared bit of GPA
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <6457cfa5898ae1ab0effb2dd95a3ad9da7fd45f5.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <6457cfa5898ae1ab0effb2dd95a3ad9da7fd45f5.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) to
> indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
> GPA.shared is set, GPA is covered by the existing conventional EPT pointed
> by EPTP.  If GPA.shared bit is cleared, GPA is covered by TDX module.
> VMM has to issue SEAMCALLs to operate.
>
> Add a member to remember GPA shared bit for each guest TDs, add address
> conversion functions between private GPA and shared GPA and test if GPA
> is private.
>
> Because struct kvm_arch (or struct kvm which includes struct kvm_arch. See
> kvm_arch_alloc_vm() that passes __GPF_ZERO) is zero-cleared when allocated,
> the new member to remember GPA shared bit is guaranteed to be zero with
> this patch unless it's initialized explicitly.
>
> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h |  4 ++++
>   arch/x86/kvm/mmu.h              | 27 +++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.c          |  5 +++++
>   3 files changed, 36 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 78aa844f4dba..babdc3a6ba5e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1475,6 +1475,10 @@ struct kvm_arch {
>   	 */
>   #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>   	struct kvm_mmu_memory_cache split_desc_cache;
> +
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +	gfn_t gfn_shared_mask;
> +#endif
>   };
>   
>   struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index bb8c86eefac0..f64bb734fbb6 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -311,4 +311,31 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
>   		return gpa;
>   	return translate_nested_gpa(vcpu, gpa, access, exception);
>   }
> +
> +static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
> +{
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +	return kvm->arch.gfn_shared_mask;
> +#else
> +	return 0;
> +#endif
> +}
> +
> +static inline gfn_t kvm_gfn_to_shared(const struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn | kvm_gfn_shared_mask(kvm);
> +}
> +
> +static inline gfn_t kvm_gfn_to_private(const struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn & ~kvm_gfn_shared_mask(kvm);
> +}
> +
> +static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
> +{
> +	gfn_t mask = kvm_gfn_shared_mask(kvm);
> +
> +	return mask && !(gpa_to_gfn(gpa) & mask);
> +}
> +
>   #endif
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c1a8560981a3..fe793425d393 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -878,6 +878,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>   	kvm_tdx->attributes = td_params->attributes;
>   	kvm_tdx->xfam = td_params->xfam;
>   
> +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
> +	else
> +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
> +
>   out:
>   	/* kfree() accepts NULL. */
>   	kfree(init_vm);


