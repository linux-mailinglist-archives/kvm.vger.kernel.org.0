Return-Path: <kvm+bounces-56674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47135B416DA
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 09:37:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 593C11BA2CEA
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 07:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7D82DCF6A;
	Wed,  3 Sep 2025 07:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bziX6glA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A252DFA25;
	Wed,  3 Sep 2025 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756885025; cv=none; b=iAHZ6RfeS51751oeZgCX+G48WQJm0DL0Zeb0kTwKdErR3sJwBzvkHaZyDut6uDMgCPGo1pQQrKspCRVt4I6uvTeJ7W/5hC2f3hErmAjmaTDscV8VMNqrz8j8taZGZ+XNHSfSUTK1umgQtpUEjJ/h0xGXlkloFL7wBRzotGn9YB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756885025; c=relaxed/simple;
	bh=BLF5TlJU7iqFCKd9lmubz5MXJtbBhyQ+Y2f4ebnTVUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DK6zfrxSHNxtRv+U+O4YrD/9q8DfKFWhtE17r3BECpEgB87OuNx6C4NnrvmtjaMhT2TmGTh65lTTuJktkZ1rkgANfizETbRqnmPVWOsi8OSFYWaUpVnmzSIRFk9QPCkGkN56lz9P6ckMJfemeqZ5SqRmlp5vWUm6UC4D5aRh1M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bziX6glA; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756885023; x=1788421023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BLF5TlJU7iqFCKd9lmubz5MXJtbBhyQ+Y2f4ebnTVUI=;
  b=bziX6glAyyDhR0ZZKK0W3kDMfzYRZc0DsyDco5EHk9OuUI8+ERHHgQYO
   EReRe/wpAJq+MiByn1mXZUslxjBkfHnPKm3qFk7CIeZswDlqeKT9XJPYT
   ZurRYHERMr2WlgLGGLqrPCHP47+2PV07b9ZrgQaoXwjnktkr1jZJLoVe7
   1i50lSs8JJ1c3ssoSTA+sBoBrmM9ioIa80GtGe5diqFcZ3I/ELjlYSbXr
   /EqhLZzJZZPwzZC/DBWZtnQ7Oq10buRr03ICc08pVEtToKHTDHYoil6vE
   lou5cZ6WO/mF3AGOm7FpOr1TqawSSAj3TjRGPwdmdE1KbeDowvzZsftiP
   Q==;
X-CSE-ConnectionGUID: TgDBgUv/SzqCokAeDqeieA==
X-CSE-MsgGUID: adPsxTNtQaeKmXhX7HjXcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="61827610"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="61827610"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 00:36:56 -0700
X-CSE-ConnectionGUID: OhSb2vhjSKGArF8drf0a5g==
X-CSE-MsgGUID: obNl1vPhTnCABuenjXnCWg==
X-ExtLoop1: 1
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 00:36:51 -0700
Message-ID: <ce8da923-ae46-4c8d-9efe-a43fd29749a4@linux.intel.com>
Date: Wed, 3 Sep 2025 15:36:49 +0800
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
Content-Transfer-Encoding: 7bit



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
>
> (2) Split any existing huge mapping at the fault GFN to avoid unsupported
>      splitting under the shared mmu_lock by TDX.
>
> Use write mmu_lock to pretect (1) and (2) for now. If future KVM TDX can
> perform the actual splitting under shared mmu_lock with enhanced TDX
> modules, (1) is possible to be called under shared mmu_lock, and (2) would
> become unnecessary.

The description for (1) and (2) reversed?

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

kvm_split_cross_boundary_leafs() calls kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(), which could return flush as 1 if any of the huge page crossing boundary is split, return directly when ret is non-zero seems not right. Also, the TLB flush should also be taken care because in kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(), TLB flush is only done for negative return value.


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


