Return-Path: <kvm+bounces-1853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 838457ED8EE
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 02:32:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1D6EB20B3C
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 01:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6607F138A;
	Thu, 16 Nov 2023 01:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dVDBt8wm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9517298;
	Wed, 15 Nov 2023 17:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700098349; x=1731634349;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ztb1OMvgUbABuanoDYwKGsqiwumi8JvW3rZjOdH8eyY=;
  b=dVDBt8wmbGuUTRvF3IzMZk6sVPJO/Q/KY72hHSntr2W/5sXy1XLkbAF4
   C4qdhYJgGfpXmU310wgDSJVIE+1YQ5ZfH1lQ2CfP3qCpkEdEQ1tH2Xhxm
   ZiUu/p5l8QkYx4I5b1OvPrPA9gr6QqVz2daILmyOsF5/8sDDFyziF76/H
   bEj6EFQfoIEnjTV2gXxJFIO6ahXGCUyMBnMQ1XgiM/EfBMVBa3THo+qGG
   EAOr9MidRrM/Q86tbMaR2mynSck9cBrZuuuAUIh2i9mOYaAfaNnI11+So
   WEat7EuUjrMPPQP8UigLRrYWlVcCG4K4ebpawtvjn767qMuzpJ1e4T94U
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="388156216"
X-IronPort-AV: E=Sophos;i="6.03,306,1694761200"; 
   d="scan'208";a="388156216"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 17:32:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="794331762"
X-IronPort-AV: E=Sophos;i="6.03,306,1694761200"; 
   d="scan'208";a="794331762"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 17:32:24 -0800
Message-ID: <52b01c03-15eb-4151-b94b-2433a117cf3d@linux.intel.com>
Date: Thu, 16 Nov 2023 09:32:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/16] KVM: TDP_MMU: Go to next level if smaller
 private mapping exists
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <439c7be59c35a03bced88a44567431e721fab3da.1699368363.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <439c7be59c35a03bced88a44567431e721fab3da.1699368363.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> Cannot map a private page as large page if any smaller mapping exists.
>
> It has to wait for all the not-mapped smaller page to be mapped and
> promote it to larger mapping.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 2c5257628881..d806574f7f2d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1287,7 +1287,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
>   		int r;
>   
> -		if (fault->nx_huge_page_workaround_enabled)
> +		if (fault->nx_huge_page_workaround_enabled ||
> +		    kvm_gfn_shared_mask(vcpu->kvm))
As I mentioned in 
https://lore.kernel.org/kvm/fef75d54-e319-5170-5f76-f5abc4856315@linux.intel.com/,
The change of this patch will not take effect.
If "fault->nx_huge_page_workaround_enabled" is false, the condition
"spte_to_child_sp(spte)->nx_huge_page_disallowed" will not be true.

IIUC, the function disallowed_hugepage_adjust() currently is only to handle
nx_huge_page_workaround, it seems no special handling needed for TD.
>   			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
>   
>   		/*


