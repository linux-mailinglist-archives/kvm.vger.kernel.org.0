Return-Path: <kvm+bounces-1879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 239367EDCC3
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 09:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29239B20C37
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 08:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF6E11704;
	Thu, 16 Nov 2023 08:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kyaZ9NZF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511FA196;
	Thu, 16 Nov 2023 00:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700122726; x=1731658726;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FbushCVIFv+PY/6S/x2mvxLk/35CqPa8wajnY9+0vW4=;
  b=kyaZ9NZFtCurrk4S7363ZlZlZU0rJgxG6Y3bk8e2V/SOoBdCPwY8zDZ2
   KXVnAJty3Ipi2UyPMJhHFzl6WlixeAv4ZeOSLiR8+zz99n0VqxEHXIS/Y
   7ATWbOqMJT5fD8IA698XwI5grXp5xDKvbxMkxYUmaTb1f5R2h8SJKNJh+
   6Zoyiz0p5ldzRx+/+qOGTAMXWb1+IScMV2ixy35uen+SL6UesCFW5J/91
   D4Gx9zD6wZl6yAG/dD1Ru0vTd52JjHaviENAcU03p/pp3GptHMBKDw07d
   wsWTeg3OGsiYtBshd/FdIPhtPlijA6BFuhbDL0cYIBO3kFANwg6BkC0Jn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="389899556"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="389899556"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 00:18:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="768846727"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="768846727"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 00:18:30 -0800
Message-ID: <ab5978fe-998f-4407-ae57-307606d5fb74@linux.intel.com>
Date: Thu, 16 Nov 2023 16:18:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/16] KVM: TDX: Pass KVM page level to
 tdh_mem_page_add() and tdh_mem_page_aug()
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <d3b140b63e0dc9773475724d97d566917d444791.1699368363.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d3b140b63e0dc9773475724d97d566917d444791.1699368363.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> Level info is needed in tdh_clflush_page() to generate the correct page
> size.

tdh_clflush_page() -> tdx_clflush_page()

>
> Besides, explicitly pass level info to SEAMCALL instead of assuming
> it's zero. It works naturally when 2MB support lands.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c     |  7 ++++---
>   arch/x86/kvm/vmx/tdx_ops.h | 19 ++++++++++++-------
>   2 files changed, 16 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8b58d91bda4e..2d5c86e06c5f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1468,7 +1468,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
>   	union tdx_sept_entry entry;
>   	u64 err;
>   
> -	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, hpa, &out);
> +	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
>   	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
>   		tdx_unpin(kvm, pfn);
>   		return -EAGAIN;
> @@ -1497,6 +1497,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
>   static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
>   			     enum pg_level level, kvm_pfn_t pfn)
>   {
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>   	hpa_t hpa = pfn_to_hpa(pfn);
>   	gpa_t gpa = gfn_to_gpa(gfn);
> @@ -1531,8 +1532,8 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
>   	kvm_tdx->source_pa = INVALID_PAGE;
>   
>   	do {
> -		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, hpa, source_pa,
> -				       &out);
> +		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, tdx_level, hpa,
> +				       source_pa, &out);
>   		/*
>   		 * This path is executed during populating initial guest memory
>   		 * image. i.e. before running any vcpu.  Race is rare.
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index e726102d3523..0f2df7198bde 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -63,6 +63,11 @@ static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
>   void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out);
>   #endif
>   
> +static inline enum pg_level tdx_sept_level_to_pg_level(int tdx_level)
> +{
> +	return tdx_level + 1;
> +}
> +
>   static inline void tdx_clflush_page(hpa_t addr, enum pg_level level)
>   {
>   	clflush_cache_range(__va(addr), KVM_HPAGE_SIZE(level));
> @@ -104,11 +109,11 @@ static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
>   	return tdx_seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
>   }
>   
> -static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
> -				   struct tdx_module_args *out)
> +static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
> +				   hpa_t source, struct tdx_module_args *out)
>   {
> -	tdx_clflush_page(hpa, PG_LEVEL_4K);
> -	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
> +	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
> +	return tdx_seamcall_sept(TDH_MEM_PAGE_ADD, gpa | level, tdr, hpa, source, out);
>   }

For TDH_MEM_PAGE_ADD, only 4K page is supported, is this change necessary?
Or maybe huge page can be supported by TDH_MEM_PAGE_ADD in the future?

>   
>   static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
> @@ -143,11 +148,11 @@ static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
>   	return tdx_seamcall_sept(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
>   }
>   
> -static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
> +static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, int level, hpa_t hpa,
>   				   struct tdx_module_args *out)
>   {
> -	tdx_clflush_page(hpa, PG_LEVEL_4K);
> -	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
> +	tdx_clflush_page(hpa, tdx_sept_level_to_pg_level(level));
> +	return tdx_seamcall_sept(TDH_MEM_PAGE_AUG, gpa | level, tdr, hpa, 0, out);
>   }
>   
>   static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,


