Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF57793379
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 03:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240123AbjIFBsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 21:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235707AbjIFBsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 21:48:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D4BCC3;
        Tue,  5 Sep 2023 18:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693964922; x=1725500922;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fYYFtNWj+tfNf1oQ6hUYicydoS8jbncijGmtmunyLD0=;
  b=WzwS0oa2sTkMh9iL8TJC9ffp5mZoz5jd5gcWlZxiW0q1/cnpToDTivT/
   r/VKRJV96tTQ8/CPXtCDJgu0SA1sSzXbzlDigt71WdSSnSA2R9IO/K17t
   5bpqDAv0Mugng/Wwkly0WRu3TBykoxCgiK/lyd6mHM9ITCzggTocMYAB4
   ACYrHg4XpR2hEToa2QwR1eOldVIMcduyVuZVYJpBJGodLz1vi1SXQa028
   h/dTb1TIpTnDJAA8TQtqO8vS3AWnFiy0zsQ6jeqc6kyhKlQ74UdWqvqaV
   Gc7sFH6T3QNc2BBGF0QZxSjMgXsTiwTY+3CkLc9IHrcqQDPPvS1wxXvRm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="379661451"
X-IronPort-AV: E=Sophos;i="6.02,230,1688454000"; 
   d="scan'208";a="379661451"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 18:48:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="744489502"
X-IronPort-AV: E=Sophos;i="6.02,230,1688454000"; 
   d="scan'208";a="744489502"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 18:48:38 -0700
Message-ID: <383cf8d1-1d6f-f0d3-08de-fe4dc3ce1778@linux.intel.com>
Date:   Wed, 6 Sep 2023 09:48:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [RFC PATCH v4 05/16] KVM: TDX: Pass size to reclaim_page()
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
 <48b900ccfa2257ddbfeea475b9b43ee36fb52080.1690323516.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <48b900ccfa2257ddbfeea475b9b43ee36fb52080.1690323516.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/26/2023 6:23 AM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> A 2MB large page can be tdh_mem_page_aug()'ed to TD directly. In this case,
> it needs to reclaim and clear the page as 2MB size.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 24 ++++++++++++++----------
>   1 file changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 3522ee232eda..86cfbf435671 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -198,12 +198,13 @@ static void tdx_disassociate_vp_on_cpu(struct kvm_vcpu *vcpu)
>   	smp_call_function_single(cpu, tdx_disassociate_vp_arg, vcpu, 1);
>   }
>   
> -static void tdx_clear_page(unsigned long page_pa)
> +static void tdx_clear_page(unsigned long page_pa, int size)
>   {
>   	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
>   	void *page = __va(page_pa);
>   	unsigned long i;
>   
> +	WARN_ON_ONCE(size % PAGE_SIZE);
>   	/*
>   	 * When re-assign one page from old keyid to a new keyid, MOVDIR64B is
>   	 * required to clear/write the page with new keyid to prevent integrity
> @@ -212,7 +213,7 @@ static void tdx_clear_page(unsigned long page_pa)
>   	 * clflush doesn't flush cache with HKID set.  The cache line could be
>   	 * poisoned (even without MKTME-i), clear the poison bit.
>   	 */
> -	for (i = 0; i < PAGE_SIZE; i += 64)
> +	for (i = 0; i < size; i += 64)
>   		movdir64b(page + i, zero_page);
>   	/*
>   	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> @@ -221,7 +222,8 @@ static void tdx_clear_page(unsigned long page_pa)
>   	__mb();
>   }
>   
> -static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
> +static int tdx_reclaim_page(hpa_t pa, enum pg_level level,
> +			    bool do_wb, u16 hkid)
>   {
>   	struct tdx_module_output out;
>   	u64 err;
> @@ -239,8 +241,10 @@ static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
>   		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
>   		return -EIO;
>   	}
> +	/* out.r8 == tdx sept page level */
> +	WARN_ON_ONCE(out.r8 != pg_level_to_tdx_sept_level(level));
>   
> -	if (do_wb) {
> +	if (do_wb && level == PG_LEVEL_4K) {
I was wondering if it is better to add a WARN_ON_ONCE() to ensure level is
PG_LEVEL_4K instead of skipping it silently. But later, I found the 
warning of
comparing out.r8 and level has guaranteed that there will be a warning 
if there
is a mismatch between do_wb and level.

>   		/*
>   		 * Only TDR page gets into this path.  No contention is expected
>   		 * because of the last page of TD.
> @@ -252,7 +256,7 @@ static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
>   		}
>   	}
>   
> -	tdx_clear_page(pa);
> +	tdx_clear_page(pa, KVM_HPAGE_SIZE(level));
>   	return 0;
>   }
>   
> @@ -266,7 +270,7 @@ static void tdx_reclaim_td_page(unsigned long td_page_pa)
>   	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
>   	 * cache doesn't need to be flushed again.
>   	 */
> -	if (tdx_reclaim_page(td_page_pa, false, 0))
> +	if (tdx_reclaim_page(td_page_pa, PG_LEVEL_4K, false, 0))
>   		/*
>   		 * Leak the page on failure:
>   		 * tdx_reclaim_page() returns an error if and only if there's an
> @@ -474,7 +478,7 @@ void tdx_vm_free(struct kvm *kvm)
>   	 * while operating on TD (Especially reclaiming TDCS).  Cache flush with
>   	 * TDX global HKID is needed.
>   	 */
> -	if (tdx_reclaim_page(kvm_tdx->tdr_pa, true, tdx_global_keyid))
> +	if (tdx_reclaim_page(kvm_tdx->tdr_pa, PG_LEVEL_4K, true, tdx_global_keyid))
>   		return;
>   
>   	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
> @@ -1468,7 +1472,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   		 * The HKID assigned to this TD was already freed and cache
>   		 * was already flushed. We don't have to flush again.
>   		 */
> -		err = tdx_reclaim_page(hpa, false, 0);
> +		err = tdx_reclaim_page(hpa, level, false, 0);
>   		if (KVM_BUG_ON(err, kvm))
>   			return -EIO;
>   		tdx_unpin(kvm, pfn);
> @@ -1501,7 +1505,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
>   		return -EIO;
>   	}
> -	tdx_clear_page(hpa);
> +	tdx_clear_page(hpa, PAGE_SIZE);
>   	tdx_unpin(kvm, pfn);
>   	return 0;
>   }
> @@ -1612,7 +1616,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
>   	 * already flushed. We don't have to flush again.
>   	 */
>   	if (!is_hkid_assigned(kvm_tdx))
> -		return tdx_reclaim_page(__pa(private_spt), false, 0);
> +		return tdx_reclaim_page(__pa(private_spt), PG_LEVEL_4K, false, 0);
>   
>   	/*
>   	 * free_private_spt() is (obviously) called when a shadow page is being

