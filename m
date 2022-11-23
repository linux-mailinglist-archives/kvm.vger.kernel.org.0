Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7861E636DAF
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 23:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiKWW5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 17:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiKWW5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 17:57:38 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E75271D;
        Wed, 23 Nov 2022 14:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244255; x=1700780255;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nbcy9sYYQ21ddpqNbtcQLkzP7qnkCuH1u1wrwKLYh4k=;
  b=Q1bzROTYK9c6eM8dklnCqGs08JJ78odLFPdUUwyYQVbufVik8qlRvXV1
   cwXUhIxns/xI8zCrb1fcBH+aCWIeMXuFkic5X6WyI6wudpgVnHdqrwlX4
   1NSUYFmoqnRvo/M5foQ+I3jT5ZNO5sFgY1tjiCos23sNKqTQ5q048lZvF
   NTuq1RE/CSfyjyEM6K4CB0EQRm7rGAhZQf5renjfrGnOIYhQBzzjdATye
   0lFWJRp8WMl0411HyyAmNrQoUybP4qre02qJENrLPCPItSgL4rqwGck2E
   By6lhdiZUZKvd1rLVUYAwTC2Jx8hzZgc+i1ckkUCUAYQKtvtnEaobTAV4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315324154"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315324154"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 14:57:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="710749796"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="710749796"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 14:57:29 -0800
Message-ID: <74723e2b-3094-d04b-aed7-2789268b00ab@intel.com>
Date:   Wed, 23 Nov 2022 14:57:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 13/20] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <ef6cdab2c371b9f068f2b4bf493b1dd0c9bb3c99.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ef6cdab2c371b9f068f2b4bf493b1dd0c9bb3c99.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> The TDX module uses additional metadata to record things like which
> guest "owns" a given page of memory.  This metadata, referred as
> Physical Address Metadata Table (PAMT), essentially serves as the
> 'struct page' for the TDX module.  PAMTs are not reserved by hardware
> up front.  They must be allocated by the kernel and then given to the
> TDX module.

... during module initialization.

> TDX supports 3 page sizes: 4K, 2M, and 1G.  Each "TD Memory Region"
> (TDMR) has 3 PAMTs to track the 3 supported page sizes.  Each PAMT must
> be a physically contiguous area from a Convertible Memory Region (CMR).
> However, the PAMTs which track pages in one TDMR do not need to reside
> within that TDMR but can be anywhere in CMRs.  If one PAMT overlaps with
> any TDMR, the overlapping part must be reported as a reserved area in
> that particular TDMR.
> 
> Use alloc_contig_pages() since PAMT must be a physically contiguous area
> and it may be potentially large (~1/256th of the size of the given TDMR).
> The downside is alloc_contig_pages() may fail at runtime.  One (bad)
> mitigation is to launch a TD guest early during system boot to get those
> PAMTs allocated at early time, but the only way to fix is to add a boot
> option to allocate or reserve PAMTs during kernel boot.

FWIW, we all agree that this is a bad permanent way to leave things.
You can call me out here as proposing that this wart be left in place
while this series is merged and is a detail we can work on afterword
with new module params, boot options, Kconfig or whatever.

> TDX only supports a limited number of reserved areas per TDMR to cover
> both PAMTs and memory holes within the given TDMR.  If many PAMTs are
> allocated within a single TDMR, the reserved areas may not be sufficient
> to cover all of them.
> 
> Adopt the following policies when allocating PAMTs for a given TDMR:
> 
>   - Allocate three PAMTs of the TDMR in one contiguous chunk to minimize
>     the total number of reserved areas consumed for PAMTs.
>   - Try to first allocate PAMT from the local node of the TDMR for better
>     NUMA locality.
> 
> Also dump out how many pages are allocated for PAMTs when the TDX module
> is initialized successfully.

... this helps answer the eternal "where did all my memory go?" questions.

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b36129183035..b86a333b860f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1960,6 +1960,7 @@ config INTEL_TDX_HOST
>  	depends on KVM_INTEL
>  	depends on X86_X2APIC
>  	select ARCH_KEEP_MEMBLOCK
> +	depends on CONTIG_ALLOC
>  	help
>  	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>  	  host and certain physical attacks.  This option enables necessary TDX
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 57b448de59a0..9d76e70de46e 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -586,6 +586,187 @@ static int create_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
>  	return 0;
>  }
>  
> +/*
> + * Calculate PAMT size given a TDMR and a page size.  The returned
> + * PAMT size is always aligned up to 4K page boundary.
> + */
> +static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz)
> +{
> +	unsigned long pamt_sz, nr_pamt_entries;
> +
> +	switch (pgsz) {
> +	case TDX_PS_4K:
> +		nr_pamt_entries = tdmr->size >> PAGE_SHIFT;
> +		break;
> +	case TDX_PS_2M:
> +		nr_pamt_entries = tdmr->size >> PMD_SHIFT;
> +		break;
> +	case TDX_PS_1G:
> +		nr_pamt_entries = tdmr->size >> PUD_SHIFT;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return 0;
> +	}
> +
> +	pamt_sz = nr_pamt_entries * tdx_sysinfo.pamt_entry_size;
> +	/* TDX requires PAMT size must be 4K aligned */
> +	pamt_sz = ALIGN(pamt_sz, PAGE_SIZE);
> +
> +	return pamt_sz;
> +}
> +
> +/*
> + * Pick a NUMA node on which to allocate this TDMR's metadata.
> + *
> + * This is imprecise since TDMRs are 1G aligned and NUMA nodes might
> + * not be.  If the TDMR covers more than one node, just use the _first_
> + * one.  This can lead to small areas of off-node metadata for some
> + * memory.
> + */
> +static int tdmr_get_nid(struct tdmr_info *tdmr)
> +{
> +	struct tdx_memblock *tmb;
> +
> +	/* Find the first memory region covered by the TDMR */
> +	list_for_each_entry(tmb, &tdx_memlist, list) {
> +		if (tmb->end_pfn > (tdmr_start(tdmr) >> PAGE_SHIFT))
> +			return tmb->nid;
> +	}

Aha, the first use of tmb->nid!  I wondered why that was there.

> +
> +	/*
> +	 * Fall back to allocating the TDMR's metadata from node 0 when
> +	 * no TDX memory block can be found.  This should never happen
> +	 * since TDMRs originate from TDX memory blocks.
> +	 */
> +	WARN_ON_ONCE(1);

That's probably better a pr_warn() or something.  A backtrace and all
that jazz seems a bit overly dramatic for this.

> +	return 0;
> +}
The rest of this actually looks fine.  It's nearing ack'able state.
