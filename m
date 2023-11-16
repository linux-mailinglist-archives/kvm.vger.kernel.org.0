Return-Path: <kvm+bounces-1880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2197B7EDD2E
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 09:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7314B280FAB
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 08:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5012414F7A;
	Thu, 16 Nov 2023 08:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HNe5gzl8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD4EA1;
	Thu, 16 Nov 2023 00:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700125054; x=1731661054;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6hF/KOy4geEzMKDye/KnnEK2zzobLNIQdCZGvFvFx7o=;
  b=HNe5gzl8rRw3i7yMvw7P0d7YAv8/iO5RuqzW1q3r70wBr8No8yvrZJL8
   WuGUilodLGmHGC7m5z9Ifpg0hiyxATSsjfsobYNNONri/1SHVeSrdR/Ar
   q9DUJMc7gd/8MSe8bJwObtLVstBWQxTqQMGbcUnOY9nibmMFAdowKCit7
   tVJ3KJwWZKRfCrEYLj03TsUI97/HFuPZhhUfKXvfD6Y/TDTb4zRXaaaez
   TMLXQ58DBMbEEyLAflsSrPVM/vUy9uxbdVxkNYd1BUn4x8LnLI3dGhu2+
   Ejsy/4Sl14DiRixdEryNMdrZuHUvgpk5hp2pWnaM/xRRunojDyUATEpry
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="9687822"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="9687822"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 00:57:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="794437255"
X-IronPort-AV: E=Sophos;i="6.03,307,1694761200"; 
   d="scan'208";a="794437255"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 00:57:28 -0800
Message-ID: <00b167fa-6635-47a4-a219-1f4117fe6c97@linux.intel.com>
Date: Thu, 16 Nov 2023 16:57:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/16] KVM: TDX: Pass size to tdx_measure_page()
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <7b024367db5909ffc22e6762acd0569c3a82ccd3.1699368363.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <7b024367db5909ffc22e6762acd0569c3a82ccd3.1699368363.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> Extend tdx_measure_page() to pass size info so that it can measure
> large page as well.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 2d5c86e06c5f..a728175c4a6d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1434,13 +1434,15 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>   	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
>   }
>   
> -static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa)
> +static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
IMHO, it's better to pass kvm page level instead of size here to align with
other APIs.

>   {
>   	struct tdx_module_args out;
>   	u64 err;
>   	int i;
>   
> -	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> +	WARN_ON_ONCE(size % TDX_EXTENDMR_CHUNKSIZE);

If passed level instead of size, then no need to check KVM_HPAGE_SIZE(level)
against TDX_EXTENDMR_CHUNKSIZE

But same qeustion, tdx_measure_page() is only for tdh_mem_page_add(), is 
this
change necessary?

> +
> +	for (i = 0; i < size; i += TDX_EXTENDMR_CHUNKSIZE) {
>   		err = tdh_mr_extend(kvm_tdx->tdr_pa, gpa + i, &out);
>   		if (KVM_BUG_ON(err, &kvm_tdx->kvm)) {
>   			pr_tdx_error(TDH_MR_EXTEND, err, &out);
> @@ -1544,7 +1546,7 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
>   		tdx_unpin(kvm, pfn);
>   		return -EIO;
>   	} else if (measure)
> -		tdx_measure_page(kvm_tdx, gpa);
> +		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
>   
>   	return 0;
>   


