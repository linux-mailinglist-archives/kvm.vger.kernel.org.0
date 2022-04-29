Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E25514365
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 09:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355239AbiD2Htb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 03:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245158AbiD2Ht3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 03:49:29 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52910A66DD;
        Fri, 29 Apr 2022 00:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651218371; x=1682754371;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pJ1NtxgSMXpPx7nH2L8yOizHHNsDkFgvdLjPcvxnm8s=;
  b=eXyiXZwViOhXCnlMGOFDLp7utzCgbEgMrpdayIey+Xp9LONywztEJ/Er
   fJZCOqXm7NadhuEYoJpM7n5pqGZrGQfJGIQ7URaoW74EBgCkkhS0K41P8
   XxEQe4AcE05MPiVPgAR5JfD3TAsrdmnueB8oWrBc4E2/Sjo0oIhKH00Jv
   ehhXlZ4jQAmb/rtV1E4zBx45G0a/9gTYe+m6rEL1jsclh8RNorgmDUtzF
   zh6FAgZsO5WSI4W2Gsuk5NoX+B3x0YAQSWqBDk1KNz3ygKqDm+BaTox31
   QX3MijLOPGzuLhQFHSmfYO9bg7lQfr3im8lE6ZtRWqMyPNMkvzOAVZr06
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="247123028"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="247123028"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 00:46:10 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="534360918"
Received: from jenegret-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.59.236])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 00:46:07 -0700
Message-ID: <3664ab2a8e0b0fcbb4b048b5c3aa5a6e85f9618a.camel@intel.com>
Subject: Re: [PATCH v3 13/21] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Fri, 29 Apr 2022 19:46:05 +1200
In-Reply-To: <c9b17e50-e665-3fc6-be8c-5bb16afa784e@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <ffc2eefdd212a31278978e8bfccd571355db69b0.1649219184.git.kai.huang@intel.com>
         <c9b17e50-e665-3fc6-be8c-5bb16afa784e@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 10:12 -0700, Dave Hansen wrote:
> On 4/5/22 21:49, Kai Huang wrote:
> > In order to provide crypto protection to guests, the TDX module uses
> > additional metadata to record things like which guest "owns" a given
> > page of memory.  This metadata, referred as Physical Address Metadata
> > Table (PAMT), essentially serves as the 'struct page' for the TDX
> > module.  PAMTs are not reserved by hardware upfront.  They must be
> > allocated by the kernel and then given to the TDX module.
> > 
> > TDX supports 3 page sizes: 4K, 2M, and 1G.  Each "TD Memory Region"
> > (TDMR) has 3 PAMTs to track the 3 supported page sizes respectively.
> 
> s/respectively//
> 

Will remove.

> > Each PAMT must be a physically contiguous area from the Convertible
> 
> 							^ s/the/a/

OK.

> 
> > Memory Regions (CMR).  However, the PAMTs which track pages in one TDMR
> > do not need to reside within that TDMR but can be anywhere in CMRs.
> > If one PAMT overlaps with any TDMR, the overlapping part must be
> > reported as a reserved area in that particular TDMR.
> > 
> > Use alloc_contig_pages() since PAMT must be a physically contiguous area
> > and it may be potentially large (~1/256th of the size of the given TDMR).
> 
> This is also a good place to note the downsides of using
> alloc_contig_pages().

For instance:

	The allocation may fail when memory usage is under pressure.

?

> 
> > The current version of TDX supports at most 16 reserved areas per TDMR
> > to cover both PAMTs and potential memory holes within the TDMR.  If many
> > PAMTs are allocated within a single TDMR, 16 reserved areas may not be
> > sufficient to cover all of them.
> > 
> > Adopt the following policies when allocating PAMTs for a given TDMR:
> > 
> >   - Allocate three PAMTs of the TDMR in one contiguous chunk to minimize
> >     the total number of reserved areas consumed for PAMTs.
> >   - Try to first allocate PAMT from the local node of the TDMR for better
> >     NUMA locality.
> > 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/Kconfig            |   1 +
> >  arch/x86/virt/vmx/tdx/tdx.c | 165 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 166 insertions(+)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 7414625b938f..ff68d0829bd7 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1973,6 +1973,7 @@ config INTEL_TDX_HOST
> >  	depends on CPU_SUP_INTEL
> >  	depends on X86_64
> >  	select NUMA_KEEP_MEMINFO if NUMA
> > +	depends on CONTIG_ALLOC
> >  	help
> >  	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> >  	  host and certain physical attacks.  This option enables necessary TDX
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index 82534e70df96..1b807dcbc101 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -21,6 +21,7 @@
> >  #include <asm/cpufeatures.h>
> >  #include <asm/virtext.h>
> >  #include <asm/e820/api.h>
> > +#include <asm/pgtable.h>
> >  #include <asm/tdx.h>
> >  #include "tdx.h"
> >  
> > @@ -66,6 +67,16 @@
> >  #define TDMR_START(_tdmr)	((_tdmr)->base)
> >  #define TDMR_END(_tdmr)		((_tdmr)->base + (_tdmr)->size)
> >  
> > +/* Page sizes supported by TDX */
> > +enum tdx_page_sz {
> > +	TDX_PG_4K = 0,
> > +	TDX_PG_2M,
> > +	TDX_PG_1G,
> > +	TDX_PG_MAX,
> > +};
> 
> Is that =0 required?  I thought the first enum was defined to be 0.

No it's not required.  Will remove.

> 
> > +#define TDX_HPAGE_SHIFT	9
> > +
> >  /*
> >   * TDX module status during initialization
> >   */
> > @@ -959,6 +970,148 @@ static int create_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
> >  	return ret;
> >  }
> >  
> > +/* Calculate PAMT size given a TDMR and a page size */
> > +static unsigned long __tdmr_get_pamt_sz(struct tdmr_info *tdmr,
> > +					enum tdx_page_sz pgsz)
> > +{
> > +	unsigned long pamt_sz;
> > +
> > +	pamt_sz = (tdmr->size >> ((TDX_HPAGE_SHIFT * pgsz) + PAGE_SHIFT)) *
> > +		tdx_sysinfo.pamt_entry_size;
> 
> That 'pgsz' thing is just hideous.  I'd *much* rather see something like
> this:
> 
> static int tdx_page_size_shift(enum tdx_page_sz page_sz)
> {
> 	switch (page_sz) {
> 	case TDX_PG_4K:
> 		return PAGE_SIZE;
> 	...
> 	}
> }
> 
> That's easy to figure out what's going on.

OK. Will do.

> 
> > +	/* PAMT size must be 4K aligned */
> > +	pamt_sz = ALIGN(pamt_sz, PAGE_SIZE);
> > +
> > +	return pamt_sz;
> > +}
> > +
> > +/* Calculate the size of all PAMTs for a TDMR */
> > +static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr)
> > +{
> > +	enum tdx_page_sz pgsz;
> > +	unsigned long pamt_sz;
> > +
> > +	pamt_sz = 0;
> > +	for (pgsz = TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++)
> > +		pamt_sz += __tdmr_get_pamt_sz(tdmr, pgsz);
> > +
> > +	return pamt_sz;
> > +}
> 
> But, there are 3 separate pointers pointing to 3 separate PAMTs.  Why do
> they all have to be contiguously allocated?

It is also explained in the changelog (the last two paragraphs).

> 
> > +/*
> > + * Locate the NUMA node containing the start of the given TDMR's first
> > + * RAM entry.  The given TDMR may also cover memory in other NUMA nodes.
> > + */
> 
> Please add a sentence or two on the implications here of what this means
> when it happens.  Also, the joining of e820 regions seems like it might
> span NUMA nodes.  What prevents that code from just creating one large
> e820 area that leads to one large TDMR and horrible NUMA affinity for
> these structures?

How about adding:

	When TDMR is created, it stops spanning at NUAM boundary.

> 
> > +static int tdmr_get_nid(struct tdmr_info *tdmr)
> > +{
> > +	u64 start, end;
> > +	int i;
> > +
> > +	/* Find the first RAM entry covered by the TDMR */
> > +	e820_for_each_mem(i, start, end)
> > +		if (end > TDMR_START(tdmr))
> > +			break;
> 
> Brackets around the big loop, please.

OK.

> 
> > +	/*
> > +	 * One TDMR must cover at least one (or partial) RAM entry,
> > +	 * otherwise it is kernel bug.  WARN_ON() in this case.
> > +	 */
> > +	if (WARN_ON_ONCE((start >= end) || start >= TDMR_END(tdmr)))
> > +		return 0;
> > +
> > +	/*
> > +	 * The first RAM entry may be partially covered by the previous
> > +	 * TDMR.  In this case, use TDMR's start to find the NUMA node.
> > +	 */
> > +	if (start < TDMR_START(tdmr))
> > +		start = TDMR_START(tdmr);
> > +
> > +	return phys_to_target_node(start);
> > +}
> > +
> > +static int tdmr_setup_pamt(struct tdmr_info *tdmr)
> > +{
> > +	unsigned long tdmr_pamt_base, pamt_base[TDX_PG_MAX];
> > +	unsigned long pamt_sz[TDX_PG_MAX];
> > +	unsigned long pamt_npages;
> > +	struct page *pamt;
> > +	enum tdx_page_sz pgsz;
> > +	int nid;
> 
> Sooooooooooooooooooo close to reverse Christmas tree, but no cigar.
> Please fix it.

Will fix.  Thanks.

> 
> > +	/*
> > +	 * Allocate one chunk of physically contiguous memory for all
> > +	 * PAMTs.  This helps minimize the PAMT's use of reserved areas
> > +	 * in overlapped TDMRs.
> > +	 */
> 
> Ahh, this explains it.  Considering that tdmr_get_pamt_sz() is really
> just two lines of code, I'd probably just the helper and open-code it
> here.  Then you only have one place to comment on it.

It has a loop and internally calls __tdmr_get_pamt_sz().  It looks doesn't fit
if we open-code it here.

How about move this comment to tdmr_get_pamt_sz()?

	
> 
> > +	nid = tdmr_get_nid(tdmr);
> > +	pamt_npages = tdmr_get_pamt_sz(tdmr) >> PAGE_SHIFT;
> > +	pamt = alloc_contig_pages(pamt_npages, GFP_KERNEL, nid,
> > +			&node_online_map);
> > +	if (!pamt)
> > +		return -ENOMEM;
> > +
> > +	/* Calculate PAMT base and size for all supported page sizes. */
> > +	tdmr_pamt_base = page_to_pfn(pamt) << PAGE_SHIFT;
> > +	for (pgsz = TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
> > +		unsigned long sz = __tdmr_get_pamt_sz(tdmr, pgsz);
> > +
> > +		pamt_base[pgsz] = tdmr_pamt_base;
> > +		pamt_sz[pgsz] = sz;
> > +
> > +		tdmr_pamt_base += sz;
> > +	}
> > +
> > +	tdmr->pamt_4k_base = pamt_base[TDX_PG_4K];
> > +	tdmr->pamt_4k_size = pamt_sz[TDX_PG_4K];
> > +	tdmr->pamt_2m_base = pamt_base[TDX_PG_2M];
> > +	tdmr->pamt_2m_size = pamt_sz[TDX_PG_2M];
> > +	tdmr->pamt_1g_base = pamt_base[TDX_PG_1G];
> > +	tdmr->pamt_1g_size = pamt_sz[TDX_PG_1G];
> 
> This would all vertically align nicely if you renamed pamt_sz -> pamt_size.

OK.

> 
> > +	return 0;
> > +}
> > +
> > +static void tdmr_free_pamt(struct tdmr_info *tdmr)
> > +{
> > +	unsigned long pamt_pfn, pamt_sz;
> > +
> > +	pamt_pfn = tdmr->pamt_4k_base >> PAGE_SHIFT;
> 
> Comment, please:
> 
> 	/*
> 	 * The PAMT was allocated in one contiguous unit.  The 4k PAMT
> 	 * should always point to the beginning of that allocation.
> 	 */

Thanks will add.

> 
> > +	pamt_sz = tdmr->pamt_4k_size + tdmr->pamt_2m_size + tdmr->pamt_1g_size;
> > +
> > +	/* Do nothing if PAMT hasn't been allocated for this TDMR */
> > +	if (!pamt_sz)
> > +		return;
> > +
> > +	if (WARN_ON(!pamt_pfn))
> > +		return;
> > +
> > +	free_contig_range(pamt_pfn, pamt_sz >> PAGE_SHIFT);
> > +}
> > +
> > +static void tdmrs_free_pamt_all(struct tdmr_info **tdmr_array, int tdmr_num)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < tdmr_num; i++)
> > +		tdmr_free_pamt(tdmr_array[i]);
> > +}
> > +
> > +/* Allocate and set up PAMTs for all TDMRs */
> > +static int tdmrs_setup_pamt_all(struct tdmr_info **tdmr_array, int tdmr_num)
> 
> 	"set_up", please, not "setup".

OK.

> 
> > +{
> > +	int i, ret;
> > +
> > +	for (i = 0; i < tdmr_num; i++) {
> > +		ret = tdmr_setup_pamt(tdmr_array[i]);
> > +		if (ret)
> > +			goto err;
> > +	}
> > +
> > +	return 0;
> > +err:
> > +	tdmrs_free_pamt_all(tdmr_array, tdmr_num);
> > +	return -ENOMEM;
> > +}
> > +
> >  static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
> >  {
> >  	int ret;
> > @@ -971,8 +1124,14 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
> >  	if (ret)
> >  		goto err;
> >  
> > +	ret = tdmrs_setup_pamt_all(tdmr_array, *tdmr_num);
> > +	if (ret)
> > +		goto err_free_tdmrs;
> > +
> >  	/* Return -EFAULT until constructing TDMRs is done */
> >  	ret = -EFAULT;
> > +	tdmrs_free_pamt_all(tdmr_array, *tdmr_num);
> > +err_free_tdmrs:
> >  	free_tdmrs(tdmr_array, *tdmr_num);
> >  err:
> >  	return ret;
> > @@ -1022,6 +1181,12 @@ static int init_tdx_module(void)
> >  	 * initialization are done.
> >  	 */
> >  	ret = -EFAULT;
> > +	/*
> > +	 * Free PAMTs allocated in construct_tdmrs() when TDX module
> > +	 * initialization fails.
> > +	 */
> > +	if (ret)
> > +		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
> >  out_free_tdmrs:
> >  	/*
> >  	 * TDMRs are only used during initializing TDX module.  Always
> 
> In a follow-on patch, I'd like this to dump out (in a pr_debug() or
> pr_info()) how much memory is consumed by PAMT allocations.

OK.


