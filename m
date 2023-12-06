Return-Path: <kvm+bounces-3661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1BF6806677
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 06:18:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EB33282133
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 05:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B76FC01;
	Wed,  6 Dec 2023 05:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E06NyFeD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A820518F;
	Tue,  5 Dec 2023 21:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701839872; x=1733375872;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y5/P58aNVpKUNoICGBsX+fZr9CJIgnK2Uh0KLwFcSJ8=;
  b=E06NyFeDJ8YigGQL6TByZDLUfQxiqEeLt+reTkJYT1aYvPS9Dee87VOu
   Oaarue5pOiidN/be62lijAr8sIPJ1XAK54bdeh6e+vGcfLVWeLsYjWc6O
   sIBkmKLQ+vrYPlRTxfYkrI9kKgdLR75i3Z5qbTJoxwhy4nuD+LZDi3/Yy
   6hoV018eumKYaYCPaf+YJmeNKfjeYtiFUBLtGvjR9N9PGTIZN/6mo0AN7
   Xy1NO+6ieZewuCAuCK9iRXG6WvXqVmMIbpWZaI7U5qaag3aLopaxpflQ4
   JFEnk95vWl/sHvYGuuMjCmrx9gcfh+t/vulFty7V6Vbw2qmZehwI+XY5t
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="7357262"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="7357262"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 21:17:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="915055169"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="915055169"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 21:17:47 -0800
Message-ID: <47892232-6ae3-44e6-aef8-5c5987f9b208@linux.intel.com>
Date: Wed, 6 Dec 2023 13:17:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 011/116] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <27d60b4bf79499c3bcda00cdb969ea215ecf05e9.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <27d60b4bf79499c3bcda00cdb969ea215ecf05e9.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> A VMM interacts with the TDX module using a new instruction (SEAMCALL).
> For instance, a TDX VMM does not have full access to the VM control
> structure corresponding to VMX VMCS.  Instead, a VMM induces the TDX module
> to act on behalf via SEAMCALLs.
>
> Export __seamcall and define C wrapper functions for SEAMCALLs for
> readability.
>
> Some SEAMCALL APIs donate host pages to TDX module or guest TD, and the
> donated pages are encrypted.  Those require the VMM to flush the cache
> lines to avoid cache line alias.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

>
> ---
> v15 -> v16:
> - use struct tdx_module_args instead of struct tdx_module_output
> - Add tdh_mem_sept_rd() for SEPT_VE_DISABLE=1.
> ---
>   arch/x86/include/asm/asm-prototypes.h |   1 +
>   arch/x86/include/asm/tdx.h            |  12 ++
>   arch/x86/kvm/vmx/tdx_ops.h            | 226 ++++++++++++++++++++++++++
>   arch/x86/virt/vmx/tdx/seamcall.S      |   4 +
>   4 files changed, 243 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx_ops.h
>
> diff --git a/arch/x86/include/asm/asm-prototypes.h b/arch/x86/include/asm/asm-prototypes.h
> index b1a98fa38828..1a8feb440252 100644
> --- a/arch/x86/include/asm/asm-prototypes.h
> +++ b/arch/x86/include/asm/asm-prototypes.h
> @@ -6,6 +6,7 @@
>   #include <asm/page.h>
>   #include <asm/checksum.h>
>   #include <asm/mce.h>
> +#include <asm/tdx.h>
>   
>   #include <asm-generic/asm-prototypes.h>
>   
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index b2d9d569818e..b7cfdf084860 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -115,6 +115,18 @@ int tdx_enable(void);
>   void tdx_reset_memory(void);
>   bool tdx_is_private_mem(unsigned long phys);
>   #else
> +static inline u64 __seamcall(u64 fn, struct tdx_module_args *args)
> +{
> +	return TDX_SEAMCALL_UD;
> +}
> +static inline u64 __seamcall_ret(u64 fn, struct tdx_module_args *args)
> +{
> +	return TDX_SEAMCALL_UD;
> +}
> +static inline u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args)
> +{
> +	return TDX_SEAMCALL_UD;
> +}
>   static inline bool platform_tdx_enabled(void) { return false; }
>   static inline int tdx_cpu_enable(void) { return -ENODEV; }
>   static inline int tdx_enable(void)  { return -ENODEV; }
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> new file mode 100644
> index 000000000000..12fd6b8d49e0
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -0,0 +1,226 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* constants/data definitions for TDX SEAMCALLs */
> +
> +#ifndef __KVM_X86_TDX_OPS_H
> +#define __KVM_X86_TDX_OPS_H
> +
> +#include <linux/compiler.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/asm.h>
> +#include <asm/kvm_host.h>
> +
> +#include "tdx_errno.h"
> +#include "tdx_arch.h"
> +#include "x86.h"
> +
> +static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +			       struct tdx_module_args *out)
> +{
> +	u64 ret;
> +
> +	if (out) {
> +		*out = (struct tdx_module_args) {
> +			.rcx = rcx,
> +			.rdx = rdx,
> +			.r8 = r8,
> +			.r9 = r9,
> +		};
> +		ret = __seamcall_ret(op, out);
> +	} else {
> +		struct tdx_module_args args = {
> +			.rcx = rcx,
> +			.rdx = rdx,
> +			.r8 = r8,
> +			.r9 = r9,
> +		};
> +		ret = __seamcall(op, &args);
> +	}
> +	if (unlikely(ret == TDX_SEAMCALL_UD)) {
> +		/*
> +		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
> +		 * This can happen when the host gets rebooted or live
> +		 * updated. In this case, the instruction execution is ignored
> +		 * as KVM is shut down, so the error code is suppressed. Other
> +		 * than this, the error is unexpected and the execution can't
> +		 * continue as the TDX features reply on VMX to be on.
> +		 */
> +		kvm_spurious_fault();
> +		return 0;
> +	}
> +	return ret;
> +}
> +
> +static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
> +{
> +	clflush_cache_range(__va(addr), PAGE_SIZE);
> +	return tdx_seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
> +				   struct tdx_module_args *out)
> +{
> +	clflush_cache_range(__va(hpa), PAGE_SIZE);
> +	return tdx_seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, out);
> +}
> +
> +static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
> +				   struct tdx_module_args *out)
> +{
> +	clflush_cache_range(__va(page), PAGE_SIZE);
> +	return tdx_seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, out);
> +}
> +
> +static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
> +				  struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_MEM_SEPT_RD, gpa | level, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mem_sept_remove(hpa_t tdr, gpa_t gpa, int level,
> +				      struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_MEM_SEPT_REMOVE, gpa | level, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
> +{
> +	clflush_cache_range(__va(addr), PAGE_SIZE);
> +	return tdx_seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_page_relocate(hpa_t tdr, gpa_t gpa, hpa_t hpa,
> +					struct tdx_module_args *out)
> +{
> +	clflush_cache_range(__va(hpa), PAGE_SIZE);
> +	return tdx_seamcall(TDH_MEM_PAGE_RELOCATE, gpa, tdr, hpa, 0, out);
> +}
> +
> +static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
> +				   struct tdx_module_args *out)
> +{
> +	clflush_cache_range(__va(hpa), PAGE_SIZE);
> +	return tdx_seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, out);
> +}
> +
> +static inline u64 tdh_mem_range_block(hpa_t tdr, gpa_t gpa, int level,
> +				      struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_MEM_RANGE_BLOCK, gpa | level, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mng_key_config(hpa_t tdr)
> +{
> +	return tdx_seamcall(TDH_MNG_KEY_CONFIG, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
> +{
> +	clflush_cache_range(__va(tdr), PAGE_SIZE);
> +	return tdx_seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
> +{
> +	clflush_cache_range(__va(tdvpr), PAGE_SIZE);
> +	return tdx_seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_MNG_RD, tdr, field, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
> +				struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_MR_EXTEND, gpa, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mr_finalize(hpa_t tdr)
> +{
> +	return tdx_seamcall(TDH_MR_FINALIZE, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_flush(hpa_t tdvpr)
> +{
> +	return tdx_seamcall(TDH_VP_FLUSH, tdvpr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_vpflushdone(hpa_t tdr)
> +{
> +	return tdx_seamcall(TDH_MNG_VPFLUSHDONE, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_key_freeid(hpa_t tdr)
> +{
> +	return tdx_seamcall(TDH_MNG_KEY_FREEID, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mng_init(hpa_t tdr, hpa_t td_params,
> +			       struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_MNG_INIT, tdr, td_params, 0, 0, out);
> +}
> +
> +static inline u64 tdh_vp_init(hpa_t tdvpr, u64 rcx)
> +{
> +	return tdx_seamcall(TDH_VP_INIT, tdvpr, rcx, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_rd(hpa_t tdvpr, u64 field,
> +			    struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_VP_RD, tdvpr, field, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mng_key_reclaimid(hpa_t tdr)
> +{
> +	return tdx_seamcall(TDH_MNG_KEY_RECLAIMID, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_phymem_page_reclaim(hpa_t page,
> +					  struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_PHYMEM_PAGE_RECLAIM, page, 0, 0, 0, out);
> +}
> +
> +static inline u64 tdh_mem_page_remove(hpa_t tdr, gpa_t gpa, int level,
> +				      struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_MEM_PAGE_REMOVE, gpa | level, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_sys_lp_shutdown(void)
> +{
> +	return tdx_seamcall(TDH_SYS_LP_SHUTDOWN, 0, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_track(hpa_t tdr)
> +{
> +	return tdx_seamcall(TDH_MEM_TRACK, tdr, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_mem_range_unblock(hpa_t tdr, gpa_t gpa, int level,
> +					struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_MEM_RANGE_UNBLOCK, gpa | level, tdr, 0, 0, out);
> +}
> +
> +static inline u64 tdh_phymem_cache_wb(bool resume)
> +{
> +	return tdx_seamcall(TDH_PHYMEM_CACHE_WB, resume ? 1 : 0, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_phymem_page_wbinvd(hpa_t page)
> +{
> +	return tdx_seamcall(TDH_PHYMEM_PAGE_WBINVD, page, 0, 0, 0, NULL);
> +}
> +
> +static inline u64 tdh_vp_wr(hpa_t tdvpr, u64 field, u64 val, u64 mask,
> +			    struct tdx_module_args *out)
> +{
> +	return tdx_seamcall(TDH_VP_WR, tdvpr, field, val, mask, out);
> +}
> +
> +#endif /* __KVM_X86_TDX_OPS_H */
> diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
> index 5b1f2286aea9..73042f7f23be 100644
> --- a/arch/x86/virt/vmx/tdx/seamcall.S
> +++ b/arch/x86/virt/vmx/tdx/seamcall.S
> @@ -1,5 +1,6 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
>   #include <linux/linkage.h>
> +#include <asm/export.h>
>   #include <asm/frame.h>
>   
>   #include "tdxcall.S"
> @@ -21,6 +22,7 @@
>   SYM_FUNC_START(__seamcall)
>   	TDX_MODULE_CALL host=1
>   SYM_FUNC_END(__seamcall)
> +EXPORT_SYMBOL_GPL(__seamcall)
>   
>   /*
>    * __seamcall_ret() - Host-side interface functions to SEAM software
> @@ -40,6 +42,7 @@ SYM_FUNC_END(__seamcall)
>   SYM_FUNC_START(__seamcall_ret)
>   	TDX_MODULE_CALL host=1 ret=1
>   SYM_FUNC_END(__seamcall_ret)
> +EXPORT_SYMBOL_GPL(__seamcall_ret)
>   
>   /*
>    * __seamcall_saved_ret() - Host-side interface functions to SEAM software
> @@ -59,3 +62,4 @@ SYM_FUNC_END(__seamcall_ret)
>   SYM_FUNC_START(__seamcall_saved_ret)
>   	TDX_MODULE_CALL host=1 ret=1 saved=1
>   SYM_FUNC_END(__seamcall_saved_ret)
> +EXPORT_SYMBOL_GPL(__seamcall_saved_ret)


