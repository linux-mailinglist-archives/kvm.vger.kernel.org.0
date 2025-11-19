Return-Path: <kvm+bounces-63668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9327FC6CD4E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 06:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 488132D22C
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 05:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89767311C30;
	Wed, 19 Nov 2025 05:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T2rgld2F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE723064A5;
	Wed, 19 Nov 2025 05:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763531558; cv=none; b=pKOcEfCufMBvut58CV5YiM8ad2LrqFomJ6EKq0jL52AM2E2YKXFbTLnM2aJkZ4V82zfjEaHzunbdDq8LOr3RaxTP1CthedIshmQT1HJtjRW/zeHDSGZs5dWBgMkQcE1aUUXmNz3ol7FHpdyNJcb+P+3utSKPw2pOu5ad7NhtCbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763531558; c=relaxed/simple;
	bh=r0RzjmQT6aQeEokLX6LSQGwSXaSLAxevXYi/Ofey0XE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KAZvg2QZ5FeA5bUXk7e8Ol5G70fI7Zg2ov44S8X0tcz+bBPUEAC3u2Okf6A44IZGFfR1C28MEauWbZ1IqGwwbIhbmLsLRGiHgRrZi7siVoAe54VRLrin4JEzQYemy4euCpveLdjQ9T3372UjZg7jFNlwiCdO8Q+PDkuBh5m2kII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T2rgld2F; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763531556; x=1795067556;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r0RzjmQT6aQeEokLX6LSQGwSXaSLAxevXYi/Ofey0XE=;
  b=T2rgld2FRW95zF6IaMNREtoXKSd/HPfeiyorSAyXj63R9aKjgsofi+c+
   JC2RtEAUeMRrTHLUJMZQ1h1S54uDK/5C2PSZ5/PCy8php0TswuZvfP9Aa
   M7oW8E2XhiqTo58e3XUNYeO3J/rh/5+xnGNyMqgFY3ZRhovHO3ovLX1bq
   w9cwHHUgXSjsqPxvhjT3joU2THCSr4HVAQtuEaCMkNeklG+Lf8hR84nBR
   BXiaJF3TPcMdbVH8lJ/f4x79Lrz66UvZODoykm6a+y2WONMimMXnf6J1P
   ZbZWbcgSslHTOwzcRkS14qKYHx9IlOF9+akqqmgB4fm59vOvRIRHBlpsq
   w==;
X-CSE-ConnectionGUID: DQaa27ByTciqkycQBee3Eg==
X-CSE-MsgGUID: /8AvoGTGQDeNt6yNSQOMog==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="88217927"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="88217927"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 21:51:35 -0800
X-CSE-ConnectionGUID: qDM0So4yRzWK32xWcePmVQ==
X-CSE-MsgGUID: GmmmpvcORCK/nprIPTOyCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="196093625"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 21:51:29 -0800
Message-ID: <141fd258-e561-4646-8d86-280b14e7ca32@linux.intel.com>
Date: Wed, 19 Nov 2025 13:51:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings if
 a VMExit carries level info
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kas@kernel.org, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094423.4644-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094423.4644-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/7/2025 5:44 PM, Yan Zhao wrote:
> TDX requires guests to accept S-EPT mappings created by the host KVM. Due
> to the current implementation of the TDX module, if a guest accepts a GFN
> at a lower level after KVM maps it at a higher level, the TDX module will
> emulate an EPT violation VMExit to KVM instead of returning a size mismatch
> error to the guest. If KVM fails to perform page splitting in the VMExit
> handler, the guest's accept operation will be triggered again upon
> re-entering the guest, causing a repeated EPT violation VMExit.
>
> The TDX module thus enables the EPT violation VMExit to carry the guest's
> accept level when the VMExit is caused by the guest's accept operation.
>
> Therefore, in TDX's EPT violation handler
> (1) Set the guest inhibit bit in the lpage info to prevent KVM MMU core
>      from mapping at a higher a level than the guest's accept level.
                              ^
                             an extra 'a'

>
> (2) Split any existing huge mapping at the fault GFN to avoid unsupported
>      splitting under the shared mmu_lock by TDX.
>
> Use write mmu_lock to pretect (1) and (2) for now. If future KVM TDX can

pretect -> protect

> perform the actual splitting under shared mmu_lock with enhanced TDX
> modules, (1) is possible to be called under shared mmu_lock, and (2) would
> become unnecessary.
>
> As an optimization, this patch calls hugepage_test_guest_inhibit() without
> holding the mmu_lock to reduce the frequency of acquiring the write
> mmu_lock. The write mmu_lock is thus only acquired if the guest inhibit bit
> is not already set. This is safe because the guest inhibit bit is set in a
> one-way manner while the splitting under the write mmu_lock is performed
> before setting the guest inhibit bit.
>
> Link: https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com
> Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> RFC v2
> - Change tdx_get_accept_level() to tdx_check_accept_level().
> - Invoke kvm_split_cross_boundary_leafs() and hugepage_set_guest_inhibit()
>    to change KVM mapping level in a global way according to guest accept
>    level. (Rick, Sean).
>
> RFC v1:
> - Introduce tdx_get_accept_level() to get guest accept level.
> - Use tdx->violation_request_level and tdx->violation_gfn* to pass guest
>    accept level to tdx_gmem_private_max_mapping_level() to detemine KVM
>    mapping level.
> ---
>   arch/x86/kvm/vmx/tdx.c      | 50 +++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx_arch.h |  3 +++
>   2 files changed, 53 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 035d81275be4..71115058e5e6 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2019,6 +2019,53 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
>   	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
>   }
>   
> +static inline int tdx_check_accept_level(struct kvm_vcpu *vcpu, gfn_t gfn)

The function name sounds like it is just doing check, but it may split a
hugepage on mismatch.

How about tdx_enforce_accept_level_mapping() or something else to reflect
the change could be make?



> +{
> +	struct kvm_memory_slot *slot = gfn_to_memslot(vcpu->kvm, gfn);
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 eeq_type, eeq_info;
> +	int level = -1;
> +
> +	if (!slot)
> +		return 0;
> +
> +	eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
> +	if (eeq_type != TDX_EXT_EXIT_QUAL_TYPE_ACCEPT)
> +		return 0;
> +
> +	eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
> +		   TDX_EXT_EXIT_QUAL_INFO_SHIFT;
> +
> +	level = (eeq_info & GENMASK(2, 0)) + 1;
> +
> +	if (level == PG_LEVEL_4K || level == PG_LEVEL_2M) {
> +		if (!hugepage_test_guest_inhibit(slot, gfn, level + 1)) {
> +			gfn_t base_gfn = gfn_round_for_level(gfn, level);
> +			struct kvm_gfn_range gfn_range = {
> +				.start = base_gfn,
> +				.end = base_gfn + KVM_PAGES_PER_HPAGE(level),
> +				.slot = slot,
> +				.may_block = true,
> +				.attr_filter = KVM_FILTER_PRIVATE,
> +			};
> +
> +			scoped_guard(write_lock, &kvm->mmu_lock) {
> +				int ret;
> +
> +				ret = kvm_split_cross_boundary_leafs(kvm, &gfn_range, false);
> +				if (ret)
> +					return ret;
> +
> +				hugepage_set_guest_inhibit(slot, gfn, level + 1);
> +				if (level == PG_LEVEL_4K)
> +					hugepage_set_guest_inhibit(slot, gfn, level + 2);
> +			}
> +		}
> +	}
> +	return 0;
> +}
> +
>   static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>   {
>   	unsigned long exit_qual;
> @@ -2044,6 +2091,9 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>   		 */
>   		exit_qual = EPT_VIOLATION_ACC_WRITE;
>   
> +		if (tdx_check_accept_level(vcpu, gpa_to_gfn(gpa)))
> +			return RET_PF_RETRY;
> +
>   		/* Only private GPA triggers zero-step mitigation */
>   		local_retry = true;
>   	} else {
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index a30e880849e3..af006a73ee05 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -82,7 +82,10 @@ struct tdx_cpuid_value {
>   #define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
>   
>   #define TDX_EXT_EXIT_QUAL_TYPE_MASK	GENMASK(3, 0)
> +#define TDX_EXT_EXIT_QUAL_TYPE_ACCEPT  1
>   #define TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION  6
> +#define TDX_EXT_EXIT_QUAL_INFO_MASK	GENMASK(63, 32)
> +#define TDX_EXT_EXIT_QUAL_INFO_SHIFT	32
>   /*
>    * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
>    */


