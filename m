Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AC27410DA
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 14:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjF1MXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 08:23:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:34335 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230339AbjF1MXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 08:23:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687955032; x=1719491032;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=C3DgP6Fkxxe9p5bn588wcInDqX31hZVPVaT7AmQDj98=;
  b=P2e3gPx4NEbIF7BfxWjVLpOzNuxhN5vvjBuiKaf5zwzltApqACPnYa5C
   +Y9RzK6bLzezDwsk5vlI0eVnBkQVEZ8q2mwsXh+x8rTD9gx2Teeo2Kxz2
   GuxHCZf1Y3Q+n6THcU/hhFMK+JD2KOIflzFA0yzsTZUMOnQRv/Wr2+99p
   p4OdGPJRtBYHMJPG1WZTMdgRiLRGL5EVf8Vw6TE3Z0dTslvEQAY94mUkE
   9VjEHyPoS3XpEuCQrW+Baxj/IWuNDsqWJZ/BtcT0dRRfMLi0egrzqoeNU
   fLzV9h6gcRAH8E1QNYrZdoPSUtadEp43ORDVEIHgQrybyEnHTKmUOyMh4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="351613988"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="351613988"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 05:23:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="830091017"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="830091017"
Received: from rajritu-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.47.187])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 05:23:45 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 889041095C8; Wed, 28 Jun 2023 15:23:42 +0300 (+03)
Date:   Wed, 28 Jun 2023 15:23:42 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 18/22] x86/virt/tdx: Keep TDMRs when module
 initialization is successful
Message-ID: <20230628122342.zdnqsgnugalqj6ix@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <7d06fe5fda0e330895c1c9043b881f3c2a2d4f3f.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d06fe5fda0e330895c1c9043b881f3c2a2d4f3f.1687784645.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:48AM +1200, Kai Huang wrote:
> On the platforms with the "partial write machine check" erratum, the
> kexec() needs to convert all TDX private pages back to normal before
> booting to the new kernel.  Otherwise, the new kernel may get unexpected
> machine check.
> 
> There's no existing infrastructure to track TDX private pages.  Change
> to keep TDMRs when module initialization is successful so that they can
> be used to find PAMTs.
> 
> With this change, only put_online_mems() and freeing the buffer of the
> TDSYSINFO_STRUCT and CMR array still need to be done even when module
> initialization is successful.  Adjust the error handling to explicitly
> do them when module initialization is successful and unconditionally
> clean up the rest when initialization fails.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v11 -> v12 (new patch):
>   - Defer keeping TDMRs logic to this patch for better review
>   - Improved error handling logic (Nikolay/Kirill in patch 15)
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 84 ++++++++++++++++++-------------------
>  1 file changed, 42 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 52b7267ea226..85b24b2e9417 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -49,6 +49,8 @@ static DEFINE_MUTEX(tdx_module_lock);
>  /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
>  static LIST_HEAD(tdx_memlist);
>  
> +static struct tdmr_info_list tdx_tdmr_list;
> +
>  /*
>   * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
>   * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
> @@ -1047,7 +1049,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
>  static int init_tdx_module(void)
>  {
>  	struct tdsysinfo_struct *sysinfo;
> -	struct tdmr_info_list tdmr_list;
>  	struct cmr_info *cmr_array;
>  	int ret;
>  
> @@ -1088,17 +1089,17 @@ static int init_tdx_module(void)
>  		goto out_put_tdxmem;
>  
>  	/* Allocate enough space for constructing TDMRs */
> -	ret = alloc_tdmr_list(&tdmr_list, sysinfo);
> +	ret = alloc_tdmr_list(&tdx_tdmr_list, sysinfo);
>  	if (ret)
>  		goto out_free_tdxmem;
>  
>  	/* Cover all TDX-usable memory regions in TDMRs */
> -	ret = construct_tdmrs(&tdx_memlist, &tdmr_list, sysinfo);
> +	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, sysinfo);
>  	if (ret)
>  		goto out_free_tdmrs;
>  
>  	/* Pass the TDMRs and the global KeyID to the TDX module */
> -	ret = config_tdx_module(&tdmr_list, tdx_global_keyid);
> +	ret = config_tdx_module(&tdx_tdmr_list, tdx_global_keyid);
>  	if (ret)
>  		goto out_free_pamts;
>  
> @@ -1118,51 +1119,50 @@ static int init_tdx_module(void)
>  		goto out_reset_pamts;
>  
>  	/* Initialize TDMRs to complete the TDX module initialization */
> -	ret = init_tdmrs(&tdmr_list);
> +	ret = init_tdmrs(&tdx_tdmr_list);
> +	if (ret)
> +		goto out_reset_pamts;
> +
> +	pr_info("%lu KBs allocated for PAMT.\n",
> +			tdmrs_count_pamt_kb(&tdx_tdmr_list));
> +
> +	/*
> +	 * @tdx_memlist is written here and read at memory hotplug time.
> +	 * Lock out memory hotplug code while building it.
> +	 */
> +	put_online_mems();
> +	/*
> +	 * For now both @sysinfo and @cmr_array are only used during
> +	 * module initialization, so always free them.
> +	 */
> +	free_page((unsigned long)sysinfo);
> +
> +	return 0;
>  out_reset_pamts:
> -	if (ret) {
> -		/*
> -		 * Part of PAMTs may already have been initialized by the
> -		 * TDX module.  Flush cache before returning PAMTs back
> -		 * to the kernel.
> -		 */
> -		wbinvd_on_all_cpus();
> -		/*
> -		 * According to the TDX hardware spec, if the platform
> -		 * doesn't have the "partial write machine check"
> -		 * erratum, any kernel read/write will never cause #MC
> -		 * in kernel space, thus it's OK to not convert PAMTs
> -		 * back to normal.  But do the conversion anyway here
> -		 * as suggested by the TDX spec.
> -		 */
> -		tdmrs_reset_pamt_all(&tdmr_list);
> -	}
> +	/*
> +	 * Part of PAMTs may already have been initialized by the
> +	 * TDX module.  Flush cache before returning PAMTs back
> +	 * to the kernel.
> +	 */
> +	wbinvd_on_all_cpus();
> +	/*
> +	 * According to the TDX hardware spec, if the platform
> +	 * doesn't have the "partial write machine check"
> +	 * erratum, any kernel read/write will never cause #MC
> +	 * in kernel space, thus it's OK to not convert PAMTs
> +	 * back to normal.  But do the conversion anyway here
> +	 * as suggested by the TDX spec.
> +	 */
> +	tdmrs_reset_pamt_all(&tdx_tdmr_list);
>  out_free_pamts:
> -	if (ret)
> -		tdmrs_free_pamt_all(&tdmr_list);
> -	else
> -		pr_info("%lu KBs allocated for PAMT.\n",
> -				tdmrs_count_pamt_kb(&tdmr_list));
> +	tdmrs_free_pamt_all(&tdx_tdmr_list);
>  out_free_tdmrs:
> -	/*
> -	 * Always free the buffer of TDMRs as they are only used during
> -	 * module initialization.
> -	 */
> -	free_tdmr_list(&tdmr_list);
> +	free_tdmr_list(&tdx_tdmr_list);
>  out_free_tdxmem:
> -	if (ret)
> -		free_tdx_memlist(&tdx_memlist);
> +	free_tdx_memlist(&tdx_memlist);
>  out_put_tdxmem:
> -	/*
> -	 * @tdx_memlist is written here and read at memory hotplug time.
> -	 * Lock out memory hotplug code while building it.
> -	 */
>  	put_online_mems();
>  out:
> -	/*
> -	 * For now both @sysinfo and @cmr_array are only used during
> -	 * module initialization, so always free them.
> -	 */
>  	free_page((unsigned long)sysinfo);
>  	return ret;
>  }

This diff is extremely hard to follow, but I think the change to error
handling Nikolay proposed has to be applied to the function from the
beginning, not changed drastically in this patch.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
