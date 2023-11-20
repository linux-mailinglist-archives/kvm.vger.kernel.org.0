Return-Path: <kvm+bounces-2058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE7977F114A
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:06:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 72ECEB216FE
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 11:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D4E134B1;
	Mon, 20 Nov 2023 11:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VJ6302By"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326A3CF;
	Mon, 20 Nov 2023 03:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700478347; x=1732014347;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kLUkhWA7nu+d56b6TrdPL9i8bfhz5RDkdDJy89fQBCY=;
  b=VJ6302Bya1nSXxSY5oWfiZgiMtQzfJfPjaMVbb97jYgFs47b89zuQPyr
   Q780LVUGB0hFczIQJ1N00Wq2PFnd8XC09IO0XsY4AYCkveh3uVjyu0ud7
   aqBVDNC2HEep3QayhCIBf18wmyz9UTSal9gjWGNqzdzZvOOJhj3sfcHrA
   HdyZCsLd0R+JLCOXmXssNHxyGEXn+BdQ4TVGjVu/vEwehVWlbzdb0wf+4
   Y9trZ/ibT/AFpsQ/HBK3MRGE2ywKjuvihwjwVqrE4cNQ27uf9JQyroTwg
   UdRS14MLU/YUGvBKW/c5QAXTTkMUh3B9zbYY7FEQYYA2GGk012/z3/2Wj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10899"; a="477807616"
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="477807616"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 03:05:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,213,1695711600"; 
   d="scan'208";a="7521450"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.180]) ([10.93.8.180])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 03:05:42 -0800
Message-ID: <c62e8f7e-46ed-47e3-b7ff-231bd1f343e5@linux.intel.com>
Date: Mon, 20 Nov 2023 19:05:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/16] KVM: TDX: Pin pages via get_page() right before
 ADD/AUG'ed to TDs
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <c8d8b880963cc6799b681f7905a956022e47f16f.1699368363.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <c8d8b880963cc6799b681f7905a956022e47f16f.1699368363.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> When kvm_faultin_pfn(), it doesn't have the info regarding which page level
> will the gfn be mapped at. Hence it doesn't know to pin a 4K page or a
> 2M page.
>
> Move the guest private pages pinning logic right before
> TDH_MEM_PAGE_ADD/AUG() since at that time it knows the page level info.
This patch looks strange, the code has nothing to do with the shortlog.
It seems that the change of this patch has already been covered by 06/16.

Something went wrong when formatting the patch?

>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e4167f08b58b..7b81811eb404 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1454,7 +1454,8 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
>   	}
>   }
>   
> -static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn, int level)
> +static void tdx_unpin(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +		      enum pg_level level)
>   {
>   	int i;
>   
> @@ -1476,7 +1477,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
>   
>   	err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
>   	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
> -		tdx_unpin(kvm, pfn, level);
> +		tdx_unpin(kvm, gfn, pfn, level);
>   		return -EAGAIN;
>   	}
>   	if (unlikely(err == (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))) {
> @@ -1493,7 +1494,7 @@ static int tdx_sept_page_aug(struct kvm *kvm, gfn_t gfn,
>   	}
>   	if (KVM_BUG_ON(err, kvm)) {
>   		pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
> -		tdx_unpin(kvm, pfn, level);
> +		tdx_unpin(kvm, gfn, pfn, level);
>   		return -EIO;
>   	}
>   
> @@ -1529,7 +1530,7 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
>   	 * always uses vcpu 0's page table and protected by vcpu->mutex).
>   	 */
>   	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
> -		tdx_unpin(kvm, pfn, level);
> +		tdx_unpin(kvm, gfn, pfn, level);
>   		return -EINVAL;
>   	}
>   
> @@ -1547,7 +1548,7 @@ static int tdx_sept_page_add(struct kvm *kvm, gfn_t gfn,
>   	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
>   	if (KVM_BUG_ON(err, kvm)) {
>   		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
> -		tdx_unpin(kvm, pfn, level);
> +		tdx_unpin(kvm, gfn, pfn, level);
>   		return -EIO;
>   	} else if (measure)
>   		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
> @@ -1600,7 +1601,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   		err = tdx_reclaim_page(hpa, level);
>   		if (KVM_BUG_ON(err, kvm))
>   			return -EIO;
> -		tdx_unpin(kvm, pfn, level);
> +		tdx_unpin(kvm, gfn, pfn, level);
>   		return 0;
>   	}
>   
> @@ -1633,7 +1634,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   			r = -EIO;
>   		} else {
>   			tdx_clear_page(hpa, PAGE_SIZE);
> -			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
> +			tdx_unpin(kvm, gfn + i, pfn + i, PG_LEVEL_4K);
>   		}
>   		hpa += PAGE_SIZE;
>   	}


