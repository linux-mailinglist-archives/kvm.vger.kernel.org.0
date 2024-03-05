Return-Path: <kvm+bounces-10863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B45871473
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 04:55:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 669BE1C21A76
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4263C087;
	Tue,  5 Mar 2024 03:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FVOUEUva"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230AA27441;
	Tue,  5 Mar 2024 03:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709610933; cv=none; b=e0ZBj3smbXO4smG6F3mc7AZq1gSsVGFSUVf0FksVRzuVcKTbWd6gt3Wf3nxRyTxED0Zfid0KWHc01fWIOF1b7XvWJx0hjZHJf1kvYSpAEyAvE5iVV4SmpTvX3Wplb2uH7O8xNnNZpv3EBxR5iU5ZpMwFIr3Mca/0bNcnZi+2Ndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709610933; c=relaxed/simple;
	bh=VKB1fixRTwhbAOmMV/PfK3xoWcTLoDoP3w8zcVJSMvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cGMBkmKgczsD/iHzE4w3KSmJNvmZ/L303BvSHiQaJjDXRfKLZWQHvw1KPGatmZlc2Eh+4IgRWDtFDGlUZzWHPOUDxGujnzNGhqfe5pM9urTt+qWhkys2e2dnmy2A6EXl63Rlsp133XR0BblhbUr81c2YIcE9ZbP8l9/bud5Gz38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FVOUEUva; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709610931; x=1741146931;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VKB1fixRTwhbAOmMV/PfK3xoWcTLoDoP3w8zcVJSMvE=;
  b=FVOUEUvaAdjglnxU79DhN5UGLD4lLXiOw2rRwiYsHxZdkNBzYlE1XePs
   UbzPQo8NM5pQE5DXyoOL2KxdkaND23uHAEW+SZ+wqa0aMnBQL5QEiBgBr
   gxMLuSx6rgy6sBDWh/fccG1llJBu4Xc0RAysH//ggiTqkAy2UA9sWFR1E
   MfxXmy/vmhYytxgKYthdPuAKSI3ddJFah/jIFY+Zri/Ygl7Qk/kbxMy5V
   rV9foQVG3ep+ruSCz9VrO/CIR/ufYJGVFVoCB4Vn6MVPg/m7DhtefDflR
   5Y1PMwaT1MdBxQHXiznN39P20cAI5uaFWJfJ/KH7HmNHEmyO66EA4juT1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4001570"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4001570"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 19:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="9193182"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 19:55:28 -0800
Message-ID: <89d600e4-483f-46f3-945d-9e895f90d25b@intel.com>
Date: Tue, 5 Mar 2024 11:55:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Pass full 64-bit error code when
 handling page faults
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-5-seanjc@google.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240228024147.41573-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/2024 10:41 AM, Sean Christopherson wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Plumb the full 64-bit error code throughout the page fault handling code
> so that KVM can use the upper 32 bits, e.g. SNP's PFERR_GUEST_ENC_MASK
> will be used to determine whether or not a fault is private vs. shared.
> 
> Note, passing the 64-bit error code to FNAME(walk_addr)() does NOT change
> the behavior of permission_fault() when invoked in the page fault path, as
> KVM explicitly clears PFERR_IMPLICIT_ACCESS in kvm_mmu_page_fault().
> 
> Continue passing '0' from the async #PF worker, as guest_memfd() and thus
> private memory doesn't support async page faults.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> [mdr: drop references/changes on rebase, update commit message]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> [sean: drop truncation in call to FNAME(walk_addr)(), rewrite changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


> ---
>   arch/x86/kvm/mmu/mmu.c          | 3 +--
>   arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
>   arch/x86/kvm/mmu/mmutrace.h     | 2 +-
>   3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e2fd74e06ff8..408969ac1291 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5860,8 +5860,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>   	}
>   
>   	if (r == RET_PF_INVALID) {
> -		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
> -					  lower_32_bits(error_code), false,
> +		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
>   					  &emulation_type);
>   		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
>   			return -EIO;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 0eea6c5a824d..1fab1f2359b5 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -190,7 +190,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
>   struct kvm_page_fault {
>   	/* arguments to kvm_mmu_do_page_fault.  */
>   	const gpa_t addr;
> -	const u32 error_code;
> +	const u64 error_code;
>   	const bool prefetch;
>   
>   	/* Derived from error_code.  */
> @@ -288,7 +288,7 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>   }
>   
>   static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -					u32 err, bool prefetch, int *emulation_type)
> +					u64 err, bool prefetch, int *emulation_type)
>   {
>   	struct kvm_page_fault fault = {
>   		.addr = cr2_or_gpa,
> diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> index ae86820cef69..195d98bc8de8 100644
> --- a/arch/x86/kvm/mmu/mmutrace.h
> +++ b/arch/x86/kvm/mmu/mmutrace.h
> @@ -260,7 +260,7 @@ TRACE_EVENT(
>   	TP_STRUCT__entry(
>   		__field(int, vcpu_id)
>   		__field(gpa_t, cr2_or_gpa)
> -		__field(u32, error_code)
> +		__field(u64, error_code)
>   		__field(u64 *, sptep)
>   		__field(u64, old_spte)
>   		__field(u64, new_spte)


