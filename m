Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63727494FF
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 07:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbjGFFcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 01:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbjGFFcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 01:32:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D561BC7;
        Wed,  5 Jul 2023 22:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688621527; x=1720157527;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KVUs4bhGOt3/uYXQH2AZkEfvp9H4c7HOkrp0u7M/8fQ=;
  b=aBdYe7U2BT31atEpq1sLqj5cmXWPRU+YYYcMNeVEs10BUrivbvDXa3mM
   zFe26kG550XNcFn9M6yCx/kSLovZrWCik7dZIMvpwlfjJQcFgkG11QO6K
   uVymlm0cdrRg1RaqzLR0eV6Rfz+4DBhQqVy67DnNRaxOh1GWj/4j9Ysym
   kVFYzYwLDqMARNDe+nK0ZqGJKrn5U3VGPgGDYvWxMdR685DunLUTC/+D8
   c3lzABYNy2/5XQuA786582ipSz125qmGK1g3nVQtBmOfZiUVjp99iJcFw
   w89lxcUjmq6Ly2x1GMoGhbkCSxFZzN8k0h4Ig1kZmCa2uZz7Om5L4XVOM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362379815"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="362379815"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 22:32:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="719477423"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="719477423"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 05 Jul 2023 22:31:59 -0700
Date:   Thu, 6 Jul 2023 13:31:58 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 16/22] x86/virt/tdx: Initialize all TDMRs
Message-ID: <20230706053158.73plfugwqvwwkdeo@yy-desk-7060>
References: <cover.1687784645.git.kai.huang@intel.com>
 <e01bbbc3ff4611adea84df683d83664714cd200f.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e01bbbc3ff4611adea84df683d83664714cd200f.1687784645.git.kai.huang@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:46AM +1200, Kai Huang wrote:
> After the global KeyID has been configured on all packages, initialize
> all TDMRs to make all TDX-usable memory regions that are passed to the
> TDX module become usable.
>
> This is the last step of initializing the TDX module.
>
> Initializing TDMRs can be time consuming on large memory systems as it
> involves initializing all metadata entries for all pages that can be
> used by TDX guests.  Initializing different TDMRs can be parallelized.
> For now to keep it simple, just initialize all TDMRs one by one.  It can
> be enhanced in the future.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>
> v11 -> v12:
>  - Added Kirill's tag
>
> v10 -> v11:
>  - No update
>
> v9 -> v10:
>  - Code change due to change static 'tdx_tdmr_list' to local 'tdmr_list'.
>
> v8 -> v9:
>  - Improved changlog to explain why initializing TDMRs can take long
>    time (Dave).
>  - Improved comments around 'next-to-initialize' address (Dave).
>
> v7 -> v8: (Dave)
>  - Changelog:
>    - explicitly call out this is the last step of TDX module initialization.
>    - Trimed down changelog by removing SEAMCALL name and details.
>  - Removed/trimmed down unnecessary comments.
>  - Other changes due to 'struct tdmr_info_list'.
>
> v6 -> v7:
>  - Removed need_resched() check. -- Andi.
>
>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 60 ++++++++++++++++++++++++++++++++-----
>  arch/x86/virt/vmx/tdx/tdx.h |  1 +
>  2 files changed, 53 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index f5d4dbc11aee..52b7267ea226 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -994,6 +994,56 @@ static int config_global_keyid(void)
>  	return ret;
>  }
>
> +static int init_tdmr(struct tdmr_info *tdmr)
> +{
> +	u64 next;
> +
> +	/*
> +	 * Initializing a TDMR can be time consuming.  To avoid long
> +	 * SEAMCALLs, the TDX module may only initialize a part of the
> +	 * TDMR in each call.
> +	 */
> +	do {
> +		struct tdx_module_output out;
> +		int ret;
> +
> +		/* All 0's are unused parameters, they mean nothing. */
> +		ret = seamcall(TDH_SYS_TDMR_INIT, tdmr->base, 0, 0, 0, NULL,
> +				&out);
> +		if (ret)
> +			return ret;
> +		/*
> +		 * RDX contains 'next-to-initialize' address if
> +		 * TDH.SYS.TDMR.INIT did not fully complete and
> +		 * should be retried.
> +		 */
> +		next = out.rdx;
> +		cond_resched();
> +		/* Keep making SEAMCALLs until the TDMR is done */
> +	} while (next < tdmr->base + tdmr->size);
> +
> +	return 0;
> +}
> +
> +static int init_tdmrs(struct tdmr_info_list *tdmr_list)
> +{
> +	int i;
> +
> +	/*
> +	 * This operation is costly.  It can be parallelized,
> +	 * but keep it simple for now.
> +	 */
> +	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
> +		int ret;
> +
> +		ret = init_tdmr(tdmr_entry(tdmr_list, i));
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int init_tdx_module(void)
>  {
>  	struct tdsysinfo_struct *sysinfo;
> @@ -1067,14 +1117,8 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_reset_pamts;
>
> -	/*
> -	 * TODO:
> -	 *
> -	 *  - Initialize all TDMRs.
> -	 *
> -	 *  Return error before all steps are done.
> -	 */
> -	ret = -EINVAL;
> +	/* Initialize TDMRs to complete the TDX module initialization */
> +	ret = init_tdmrs(&tdmr_list);
>  out_reset_pamts:
>  	if (ret) {
>  		/*
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index a0438513bec0..f6b4e153890d 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -25,6 +25,7 @@
>  #define TDH_SYS_INFO		32
>  #define TDH_SYS_INIT		33
>  #define TDH_SYS_LP_INIT		35
> +#define TDH_SYS_TDMR_INIT	36
>  #define TDH_SYS_CONFIG		45
>
>  struct cmr_info {
> --
> 2.40.1
>
