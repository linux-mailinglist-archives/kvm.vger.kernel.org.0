Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1685F6608F4
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 22:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbjAFVxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 16:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjAFVxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 16:53:42 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606D87D1C8;
        Fri,  6 Jan 2023 13:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673042021; x=1704578021;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=700/gsUIjT1YnoH0baKzs/gmLcJb6q0I2gHbT2Y3JXA=;
  b=D2h8bAzzOlVb9mX5dmnIIA1fB/WLPDDeZRn7AEpiof8gV4WT7D6cBJyj
   +UMzQv40pD3PMqKPqL0j+MntN+PHoXnVY8ohq81SaiMe6yGCfKRE49aaj
   pJsKZOHbb4BRjZODckfLm5yTj8WzLcaElKGnlILaC5MAkDqsFfcPHhU3I
   TiDWG0OwO/AZgPD20j4AnIgw4BKLfF/gEbo4m27CGO0+uyyUHS57lMlS/
   mBjpfkXAkyCrnU2jmCE1QWR/V4BCuzZvVRXd3DcpT8f9CVxSmiRt8svG2
   710NOya3HJ7kiaYYxSItY8jET+B7TQPLnpsiowKSugwPw+2mW+UdiLoux
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="320277682"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="320277682"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 13:53:40 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="830033783"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="830033783"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 13:53:40 -0800
Message-ID: <50ad132f-463f-3b61-6aab-b96a57b6f3a1@intel.com>
Date:   Fri, 6 Jan 2023 13:53:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 10/16] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1670566861.git.kai.huang@intel.com>
 <76a17c574da18c10ad7a4f96e010697aaa5f7c04.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <76a17c574da18c10ad7a4f96e010697aaa5f7c04.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good so far.

> +/*
> + * Allocate PAMTs from the local NUMA node of some memory in @tmb_list
> + * within @tdmr, and set up PAMTs for @tdmr.
> + */
> +static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
> +			    struct list_head *tmb_list,
> +			    u16 pamt_entry_size)
> +{
> +	unsigned long pamt_base[TDX_PS_1G + 1];
> +	unsigned long pamt_size[TDX_PS_1G + 1];

Nit: please define a TDX_PS_NR rather than open-coding this.

> +	unsigned long tdmr_pamt_base;
> +	unsigned long tdmr_pamt_size;
> +	struct page *pamt;
> +	int pgsz, nid;
> +
> +	nid = tdmr_get_nid(tdmr, tmb_list);
> +
> +	/*
> +	 * Calculate the PAMT size for each TDX supported page size
> +	 * and the total PAMT size.
> +	 */
> +	tdmr_pamt_size = 0;
> +	for (pgsz = TDX_PS_4K; pgsz <= TDX_PS_1G ; pgsz++) {
> +		pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz,
> +				pamt_entry_size);

This alignment is wonky.  Should be way over here:

> +						   pamt_entry_size);

> +		tdmr_pamt_size += pamt_size[pgsz];
> +	}
> +
> +	/*
> +	 * Allocate one chunk of physically contiguous memory for all
> +	 * PAMTs.  This helps minimize the PAMT's use of reserved areas
> +	 * in overlapped TDMRs.
> +	 */
> +	pamt = alloc_contig_pages(tdmr_pamt_size >> PAGE_SHIFT, GFP_KERNEL,
> +			nid, &node_online_map);
> +	if (!pamt)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Break the contiguous allocation back up into the
> +	 * individual PAMTs for each page size.
> +	 */
> +	tdmr_pamt_base = page_to_pfn(pamt) << PAGE_SHIFT;
> +	for (pgsz = TDX_PS_4K; pgsz <= TDX_PS_1G; pgsz++) {
> +		pamt_base[pgsz] = tdmr_pamt_base;
> +		tdmr_pamt_base += pamt_size[pgsz];
> +	}
> +
> +	tdmr->pamt_4k_base = pamt_base[TDX_PS_4K];
> +	tdmr->pamt_4k_size = pamt_size[TDX_PS_4K];
> +	tdmr->pamt_2m_base = pamt_base[TDX_PS_2M];
> +	tdmr->pamt_2m_size = pamt_size[TDX_PS_2M];
> +	tdmr->pamt_1g_base = pamt_base[TDX_PS_1G];
> +	tdmr->pamt_1g_size = pamt_size[TDX_PS_1G];
> +
> +	return 0;
> +}
> +
> +static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_pfn,
> +			  unsigned long *pamt_npages)
> +{
> +	unsigned long pamt_base, pamt_sz;
> +
> +	/*
> +	 * The PAMT was allocated in one contiguous unit.  The 4K PAMT
> +	 * should always point to the beginning of that allocation.
> +	 */
> +	pamt_base = tdmr->pamt_4k_base;
> +	pamt_sz = tdmr->pamt_4k_size + tdmr->pamt_2m_size + tdmr->pamt_1g_size;
> +
> +	*pamt_pfn = PHYS_PFN(pamt_base);
> +	*pamt_npages = pamt_sz >> PAGE_SHIFT;
> +}
> +
> +static void tdmr_free_pamt(struct tdmr_info *tdmr)
> +{
> +	unsigned long pamt_pfn, pamt_npages;
> +
> +	tdmr_get_pamt(tdmr, &pamt_pfn, &pamt_npages);
> +
> +	/* Do nothing if PAMT hasn't been allocated for this TDMR */
> +	if (!pamt_npages)
> +		return;
> +
> +	if (WARN_ON_ONCE(!pamt_pfn))
> +		return;
> +
> +	free_contig_range(pamt_pfn, pamt_npages);
> +}
> +
> +static void tdmrs_free_pamt_all(struct tdmr_info_list *tdmr_list)
> +{
> +	int i;
> +
> +	for (i = 0; i < tdmr_list->nr_tdmrs; i++)
> +		tdmr_free_pamt(tdmr_entry(tdmr_list, i));
> +}
> +
> +/* Allocate and set up PAMTs for all TDMRs */
> +static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
> +				 struct list_head *tmb_list,
> +				 u16 pamt_entry_size)
> +{
> +	int i, ret = 0;
> +
> +	for (i = 0; i < tdmr_list->nr_tdmrs; i++) {
> +		ret = tdmr_set_up_pamt(tdmr_entry(tdmr_list, i), tmb_list,
> +				pamt_entry_size);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	tdmrs_free_pamt_all(tdmr_list);
> +	return ret;
> +}
> +
> +static unsigned long tdmrs_count_pamt_pages(struct tdmr_info_list *tdmr_list)
> +{
> +	unsigned long pamt_npages = 0;
> +	int i;
> +
> +	for (i = 0; i < tdmr_list->nr_tdmrs; i++) {
> +		unsigned long pfn, npages;
> +
> +		tdmr_get_pamt(tdmr_entry(tdmr_list, i), &pfn, &npages);
> +		pamt_npages += npages;
> +	}
> +
> +	return pamt_npages;
> +}
> +
>  /*
>   * Construct a list of TDMRs on the preallocated space in @tdmr_list
>   * to cover all TDX memory regions in @tmb_list based on the TDX module
> @@ -506,15 +702,19 @@ static int construct_tdmrs(struct list_head *tmb_list,
>  	if (ret)
>  		goto err;
>  
> +	ret = tdmrs_set_up_pamt_all(tdmr_list, tmb_list,
> +			sysinfo->pamt_entry_size);
> +	if (ret)
> +		goto err;
>  	/*
>  	 * TODO:
>  	 *
> -	 *  - Allocate and set up PAMTs for each TDMR.
>  	 *  - Designate reserved areas for each TDMR.
>  	 *
>  	 * Return -EINVAL until constructing TDMRs is done
>  	 */
>  	ret = -EINVAL;
> +	tdmrs_free_pamt_all(tdmr_list);
>  err:
>  	return ret;
>  }
> @@ -574,6 +774,11 @@ static int init_tdx_module(void)
>  	 *  Return error before all steps are done.
>  	 */
>  	ret = -EINVAL;
> +	if (ret)
> +		tdmrs_free_pamt_all(&tdmr_list);
> +	else
> +		pr_info("%lu pages allocated for PAMT.\n",
> +				tdmrs_count_pamt_pages(&tdmr_list));
>  out_free_tdmrs:
>  	/*
>  	 * Free the space for the TDMRs no matter the initialization is

Other than the two nits:

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>

