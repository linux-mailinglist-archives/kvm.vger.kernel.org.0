Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4053747D73
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 08:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjGEGuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 02:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjGEGuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 02:50:17 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E745D1992;
        Tue,  4 Jul 2023 23:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688539786; x=1720075786;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TlI3CJyZkfplORXdOj9BwhzuYizpl4qib4+3VTIeKgU=;
  b=LOGDrml2n14XkIUkcu5lCcgjLcFFphMZMIqoUyDwdBPn+x8QaRnm2Nzf
   BBpWXsfxOP+q5Bc5mK0MKjMt4ZftzesEYmLvBbfcp2+gQoByOb5RJSi+9
   Ow80hgqhn+4Ctx7H+fWWTk2tDQo+m+LGtX7ZXull+SSZiuv62cLTYGrNx
   VaGPMnrp88QNZcVLLzDDevSy9/+BTa3grV2cfx+BRNNP4SiYXHb7zZlpg
   WXNezwYNzO7hhQrAjXu5vJg2OjgoCFmUXgiAi6ZFpKAS0cKym+heAdhfe
   FMz9ypk+eR4dk+3iPCFMjRxXvKbJM/oDagugDVtgI83t8zgAMGD6+yaI+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="353094389"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="353094389"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2023 23:49:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="1049598121"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="1049598121"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga005.fm.intel.com with ESMTP; 04 Jul 2023 23:49:19 -0700
Date:   Wed, 5 Jul 2023 14:49:19 +0800
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
Subject: Re: [PATCH v12 14/22] x86/virt/tdx: Configure TDX module with the
 TDMRs and global KeyID
Message-ID: <20230705064919.e774z63uxbjw2vmt@yy-desk-7060>
References: <cover.1687784645.git.kai.huang@intel.com>
 <0978700f954d311a5580b746ec44124d1cb65c28.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0978700f954d311a5580b746ec44124d1cb65c28.1687784645.git.kai.huang@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:44AM +1200, Kai Huang wrote:
> The TDX module uses a private KeyID as the "global KeyID" for mapping
> things like the PAMT and other TDX metadata.  This KeyID has already
> been reserved when detecting TDX during the kernel early boot.
>
> After the list of "TD Memory Regions" (TDMRs) has been constructed to
> cover all TDX-usable memory regions, the next step is to pass them to
> the TDX module together with the global KeyID.

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
>  arch/x86/virt/vmx/tdx/tdx.c | 41 ++++++++++++++++++++++++++++++++++++-
>  arch/x86/virt/vmx/tdx/tdx.h |  2 ++
>  2 files changed, 42 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 2bcace5cb25c..1992245290de 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -26,6 +26,7 @@
>  #include <linux/pfn.h>
>  #include <linux/align.h>
>  #include <linux/sort.h>
> +#include <linux/log2.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/archrandom.h>
> @@ -864,6 +865,39 @@ static int construct_tdmrs(struct list_head *tmb_list,
>  	return ret;
>  }
>
> +static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
> +{
> +	u64 *tdmr_pa_array;
> +	size_t array_sz;
> +	int i, ret;
> +
> +	/*
> +	 * TDMRs are passed to the TDX module via an array of physical
> +	 * addresses of each TDMR.  The array itself also has certain
> +	 * alignment requirement.
> +	 */
> +	array_sz = tdmr_list->nr_consumed_tdmrs * sizeof(u64);
> +	array_sz = roundup_pow_of_two(array_sz);
> +	if (array_sz < TDMR_INFO_PA_ARRAY_ALIGNMENT)
> +		array_sz = TDMR_INFO_PA_ARRAY_ALIGNMENT;
> +
> +	tdmr_pa_array = kzalloc(array_sz, GFP_KERNEL);
> +	if (!tdmr_pa_array)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++)
> +		tdmr_pa_array[i] = __pa(tdmr_entry(tdmr_list, i));
> +
> +	ret = seamcall(TDH_SYS_CONFIG, __pa(tdmr_pa_array),
> +				tdmr_list->nr_consumed_tdmrs,
> +				global_keyid, 0, NULL, NULL);
> +
> +	/* Free the array as it is not required anymore. */
> +	kfree(tdmr_pa_array);
> +
> +	return ret;
> +}
> +
>  static int init_tdx_module(void)
>  {
>  	struct tdsysinfo_struct *sysinfo;
> @@ -917,16 +951,21 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_free_tdmrs;
>
> +	/* Pass the TDMRs and the global KeyID to the TDX module */
> +	ret = config_tdx_module(&tdmr_list, tdx_global_keyid);
> +	if (ret)
> +		goto out_free_pamts;
> +
>  	/*
>  	 * TODO:
>  	 *
> -	 *  - Configure the TDMRs and the global KeyID to the TDX module.
>  	 *  - Configure the global KeyID on all packages.
>  	 *  - Initialize all TDMRs.
>  	 *
>  	 *  Return error before all steps are done.
>  	 */
>  	ret = -EINVAL;
> +out_free_pamts:
>  	if (ret)
>  		tdmrs_free_pamt_all(&tdmr_list);
>  	else
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 9b5a65f37e8b..c386aa3afe2a 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -24,6 +24,7 @@
>  #define TDH_SYS_INFO		32
>  #define TDH_SYS_INIT		33
>  #define TDH_SYS_LP_INIT		35
> +#define TDH_SYS_CONFIG		45
>
>  struct cmr_info {
>  	u64	base;
> @@ -88,6 +89,7 @@ struct tdmr_reserved_area {
>  } __packed;
>
>  #define TDMR_INFO_ALIGNMENT	512
> +#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
>
>  struct tdmr_info {
>  	u64 base;
> --
> 2.40.1
>
