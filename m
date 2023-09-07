Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D40C79700C
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 07:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjIGF0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 01:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjIGF03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 01:26:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B19019BD;
        Wed,  6 Sep 2023 22:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694064386; x=1725600386;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a+CnBpZXNmyM5tfD9DJaj6QY3hwokBtai7WP/L4Atto=;
  b=DT6iNe9ZsyqhmOsnf9hMIqVRTVRGfMJtjOI/7M9NGEuOKM9UxW0DS264
   iGqcoKgYsx7xZ9ttuLBzYqMnQ84XHw8YuHR2rgi0L+nWpCUUlPT8sMght
   EtS8+aG0N9DvmHAZZuqMNT+RKjHXJuzhU41Luw9I2muKpfXLVTy4BPHty
   B2CrIgiYJgR/fsNBLyYSiD5CVoXn0TejVJTExwFynupKGFt2d27NboEru
   xknoKoCE5+Z/chm33G8Om8mu9588zqEEtl5ZE6bLNcupPVddZMUlVVOSV
   87+1M+HGYCkDsJ365JkxTbFjvkaMHLbFkwqT3bMvXiwmsfsM0CnMp0lRe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="463639642"
X-IronPort-AV: E=Sophos;i="6.02,234,1688454000"; 
   d="scan'208";a="463639642"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 22:26:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="865476693"
X-IronPort-AV: E=Sophos;i="6.02,234,1688454000"; 
   d="scan'208";a="865476693"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.2.177]) ([10.238.2.177])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 22:26:21 -0700
Message-ID: <9552800c-6f32-6677-7dc2-2774e6ea6348@linux.intel.com>
Date:   Thu, 7 Sep 2023 13:26:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [RFC PATCH v4 08/16] KVM: TDX: Pin pages via get_page() right
 before ADD/AUG'ed to TDs
To:     isaku.yamahata@intel.com, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1690323516.git.isaku.yamahata@intel.com>
 <1519e0b3af4df9de3fe07f750896b44896cdc591.1690323516.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <1519e0b3af4df9de3fe07f750896b44896cdc591.1690323516.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/26/2023 6:23 AM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> When kvm_faultin_pfn(), it doesn't have the info regarding which page level
> will the gfn be mapped at. Hence it doesn't know to pin a 4K page or a
> 2M page.
>
> Move the guest private pages pinning logic right before
> TDH_MEM_PAGE_ADD/AUG() since at that time it knows the page level info.
The code change of the patch doesn't match the changelog.

>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c122160142fd..bd1582e6b693 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1361,7 +1361,8 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
>   	}
>   }
>   
> -static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn, int level)
> +static void tdx_unpin(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +		      enum pg_level level)
>   {
>   	int i;
>   
> @@ -1397,12 +1398,12 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>   	if (likely(is_td_finalized(kvm_tdx))) {
>   		err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
>   		if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
> -			tdx_unpin(kvm, pfn, level);
> +			tdx_unpin(kvm, gfn, pfn, level);
>   			return -EAGAIN;
>   		}
>   		if (KVM_BUG_ON(err, kvm)) {
>   			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
> -			tdx_unpin(kvm, pfn, level);
> +			tdx_unpin(kvm, gfn, pfn, level);
>   			return -EIO;
>   		}
>   		return 0;
> @@ -1425,7 +1426,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>   	 * always uses vcpu 0's page table and protected by vcpu->mutex).
>   	 */
>   	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
> -		tdx_unpin(kvm, pfn, level);
> +		tdx_unpin(kvm, gfn, pfn, level);
>   		return -EINVAL;
>   	}
>   
> @@ -1443,7 +1444,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>   	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
>   	if (KVM_BUG_ON(err, kvm)) {
>   		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
> -		tdx_unpin(kvm, pfn, level);
> +		tdx_unpin(kvm, gfn, pfn, level);
>   		return -EIO;
>   	} else if (measure)
>   		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
> @@ -1472,7 +1473,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   		err = tdx_reclaim_page(hpa, level, false, 0);
>   		if (KVM_BUG_ON(err, kvm))
>   			return -EIO;
> -		tdx_unpin(kvm, pfn, level);
> +		tdx_unpin(kvm, gfn, pfn, level);
>   		return 0;
>   	}
>   
> @@ -1505,7 +1506,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   			r = -EIO;
>   		} else {
>   			tdx_clear_page(hpa, PAGE_SIZE);
> -			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
> +			tdx_unpin(kvm, gfn + i, pfn + i, PG_LEVEL_4K);
>   		}
>   		hpa += PAGE_SIZE;
>   	}

