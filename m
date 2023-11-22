Return-Path: <kvm+bounces-2254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D2B7F3F3A
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 08:51:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A04D1C20C7C
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 07:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB1820B18;
	Wed, 22 Nov 2023 07:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YDcxlJpV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D42110;
	Tue, 21 Nov 2023 23:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700639449; x=1732175449;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rnM1XrjEopEa5PyFu+BAEV7mf+8XNMj46MO9QuiExjg=;
  b=YDcxlJpViwwqZZvOWIYh+eTnK5bUN9UXCBtTHlHqMuEFH0XXOI4haqD9
   wovkr0/swYXRLbKK4mKefv7fCOe4/IiexTevv1b9um106bqhJnyCYXSkB
   zlAa27PXq7BbIH76yfAi0bodn/COZAK1noko/thBdzjUKwVt2E+YhNojT
   98DLDXwoTVwYtzth79jLHH8Xr0sRo291s4niQoWPNB9vo8gCUqB/urO9O
   tV1WmSJxzGb2qduND3Eh1Yr1r1bKGx6rGD7UaiZTgineaU4+APHdc8NNb
   +69GNe8pwYtRA8EZcWmBpBpUDx4CnTEjTslLxpt/ekFFuCipxo/0hAEGY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="382400676"
X-IronPort-AV: E=Sophos;i="6.04,218,1695711600"; 
   d="scan'208";a="382400676"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 23:50:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="1098317199"
X-IronPort-AV: E=Sophos;i="6.04,218,1695711600"; 
   d="scan'208";a="1098317199"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 23:50:45 -0800
Message-ID: <9f322fd0-2c9e-4f34-9705-8e94224c68fd@linux.intel.com>
Date: Wed, 22 Nov 2023 15:50:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/16] KVM: x86/tdp_mmu: TDX: Implement merge pages
 into a large page
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <db6681db72a7667c06687923232277ddde2d9949.1699368363.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <db6681db72a7667c06687923232277ddde2d9949.1699368363.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Implement merge_private_stp callback.

Not just merge_private_stp, but also unzap_private_spte.

Also, for the shortlog, should it be "KVM: VMX" instead of "KVM: 
x86/tdp_mmu"?

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c       | 72 ++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx_arch.h  |  1 +
>   arch/x86/kvm/vmx/tdx_errno.h |  2 +
>   arch/x86/kvm/vmx/tdx_ops.h   |  6 +++
>   4 files changed, 81 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 91eca578a7da..df53a971ff21 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1684,6 +1684,49 @@ static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
>   	return 0;
>   }
>   
> +static int tdx_sept_merge_private_spt(struct kvm *kvm, gfn_t gfn,
> +				      enum pg_level level, void *private_spt)
> +{
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct tdx_module_args out;
> +	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
> +	u64 err;
> +
> +	/* See comment in tdx_sept_set_private_spte() */
> +	err = tdh_mem_page_promote(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
> +	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
> +		return -EAGAIN;
> +	if (unlikely(err == (TDX_EPT_INVALID_PROMOTE_CONDITIONS |
> +			     TDX_OPERAND_ID_RCX)))
> +		/*
> +		 * Some pages are accepted, some pending.  Need to wait for TD
> +		 * to accept all pages.  Tell it the caller.
> +		 */
> +		return -EAGAIN;
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MEM_PAGE_PROMOTE, err, &out);
> +		return -EIO;
> +	}
> +	WARN_ON_ONCE(out.rcx != __pa(private_spt));
> +
> +	/*
> +	 * TDH.MEM.PAGE.PROMOTE frees the Secure-EPT page for the lower level.
Is it better to use "unlink" instead of "free" to avoid confusion?

> +	 * Flush cache for reuse.
> +	 */
> +	do {
> +		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(__pa(private_spt),
> +							     to_kvm_tdx(kvm)->hkid));
> +	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +		return -EIO;
> +	}
> +
> +	tdx_clear_page(__pa(private_spt), PAGE_SIZE);
> +	return 0;
> +}
> +
>   static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>   				      enum pg_level level)
>   {
> @@ -1758,6 +1801,33 @@ static void tdx_track(struct kvm *kvm)
>   
>   }
>   
> +static int tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn,
> +				       enum pg_level level)
> +{
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
> +	struct tdx_module_args out;
> +	u64 err;
> +
> +	do {
> +		err = tdh_mem_range_unblock(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
> +
> +		/*
> +		 * tdh_mem_range_block() is accompanied with tdx_track() via kvm
> +		 * remote tlb flush.  Wait for the caller of
> +		 * tdh_mem_range_block() to complete TDX track.
> +		 */
> +	} while (err == (TDX_TLB_TRACKING_NOT_DONE | TDX_OPERAND_ID_SEPT));
> +	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
> +		return -EAGAIN;
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MEM_RANGE_UNBLOCK, err, &out);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
>   static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
>   				     enum pg_level level, void *private_spt)
>   {
> @@ -3204,9 +3274,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   	x86_ops->link_private_spt = tdx_sept_link_private_spt;
>   	x86_ops->free_private_spt = tdx_sept_free_private_spt;
>   	x86_ops->split_private_spt = tdx_sept_split_private_spt;
> +	x86_ops->merge_private_spt = tdx_sept_merge_private_spt;
>   	x86_ops->set_private_spte = tdx_sept_set_private_spte;
>   	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
>   	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
> +	x86_ops->unzap_private_spte = tdx_sept_unzap_private_spte;
>   
>   	return 0;
>   
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index cab6a74446a0..fb7e54953a85 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -29,6 +29,7 @@
>   #define TDH_MNG_KEY_FREEID		20
>   #define TDH_MNG_INIT			21
>   #define TDH_VP_INIT			22
> +#define TDH_MEM_PAGE_PROMOTE		23
>   #define TDH_MEM_SEPT_RD			25
>   #define TDH_VP_RD			26
>   #define TDH_MNG_KEY_RECLAIMID		27
> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> index bb093e292fef..940d6de332eb 100644
> --- a/arch/x86/kvm/vmx/tdx_errno.h
> +++ b/arch/x86/kvm/vmx/tdx_errno.h
> @@ -23,6 +23,8 @@
>   #define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
>   #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
>   #define TDX_EPT_ENTRY_NOT_FREE			0xC0000B0200000000ULL
> +#define TDX_TLB_TRACKING_NOT_DONE		0xC0000B0800000000ULL
> +#define TDX_EPT_INVALID_PROMOTE_CONDITIONS	0xC0000B0900000000ULL
>   #define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
>   
>   /*
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index 38ab0ab1509c..774fee3b2d46 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -190,6 +190,12 @@ static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t pag
>   	return tdx_seamcall_sept(TDH_MEM_PAGE_DEMOTE, gpa | level, tdr, page, 0, out);
>   }
>   
> +static inline u64 tdh_mem_page_promote(hpa_t tdr, gpa_t gpa, int level,
> +				       struct tdx_module_args *out)
> +{
> +	return tdx_seamcall_sept(TDH_MEM_PAGE_PROMOTE, gpa | level, tdr, 0, 0, out);
> +}
> +
>   static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
>   				struct tdx_module_args *out)
>   {


