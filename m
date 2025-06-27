Return-Path: <kvm+bounces-50983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB61AEB657
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 13:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A16647B478B
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 11:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6713729DB6C;
	Fri, 27 Jun 2025 11:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aqcb+DMb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34ED2951CE;
	Fri, 27 Jun 2025 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751023675; cv=none; b=pd20xDmvfrQ0ILnmchOH1hXna2H5Pxtwn6UKHc9H8AOnEKcKXcAJ0anVDe37zRWM/GPuNKhRnfD+OY5b6X6T87B+sHzO/Ti5ZlqYpX1cPOzbaoVXc2y5DubPrpDKOJ1aT6SkJgE/tBUPKs+ZkJg41mHu6EKIBxlIBbsk7Qxvopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751023675; c=relaxed/simple;
	bh=8EKBwF3UEgDc0s6UNcFoXNMx2drDH3hAbAsVHH9R09g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pL5yykucsdpyQjnRIp+f85QOVmdVR4ZOznWHlIZtvNMZDExOvdWLL8imYqZOjPsD1A/eIa5fgmU3GLnq0uYxCrASLAd51k3ax0nFOeNmVlW3uAGC9qYi8Z4/lN2xmLfwt7ZpbQOTZSMHJY8OmshZ+Wt9U9OTWyqI8M5+uBfP0+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aqcb+DMb; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751023674; x=1782559674;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8EKBwF3UEgDc0s6UNcFoXNMx2drDH3hAbAsVHH9R09g=;
  b=aqcb+DMbmKmJvQ7KAMMq8eKIbPXrQaMh1geoWNR66pA7kA+vHlPmxB2Y
   q5BmtchzbdRjz3qj3XctkMWaJ34s24Xq21JYOWFWYpQEPtBbVquC9UXNC
   S+pAgJf38jMWekZgfQ29UB7Hg9JIVR0EcYanIExXSxxzwVk51Iy7z5S2d
   Uk2UgByDzXbfAoG/HtO5sM3wBOVUwF+yRWN1EjGjR1XQA/BQUrMi52qaz
   d65DAQWXlKrUU+KK9YPNDBxNF+miK+Rn8H5A6tyOjTBK13Ip31qQKE085
   bQkSxZhqaPJGGGfXP9oXFdOz/6xFkKvcpu1mqb0JNMlgNmJ5k+SeL7KuM
   A==;
X-CSE-ConnectionGUID: hHHgzwyLTKqi/SOQ3uK+yw==
X-CSE-MsgGUID: Dwo9fmyGR9axMdJJHzLV2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53196953"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="53196953"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 04:27:54 -0700
X-CSE-ConnectionGUID: +vvECPPrSN2CRG0KI/fgvA==
X-CSE-MsgGUID: F9jAR9ozQli7QyH18ZpgHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="153499376"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa010.fm.intel.com with ESMTP; 27 Jun 2025 04:27:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 2CBC36A; Fri, 27 Jun 2025 14:27:48 +0300 (EEST)
Date: Fri, 27 Jun 2025 14:27:48 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com, 
	rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, kai.huang@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 03/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Message-ID: <pihazgqmsx4ltuvi2imgwsgvjsg2jsnxjnrdpxblwe2vc24opf@glsj2t3xosvb>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-4-kirill.shutemov@linux.intel.com>
 <fb5addcb-1cfc-45be-978c-e7cee4126b38@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb5addcb-1cfc-45be-978c-e7cee4126b38@intel.com>

On Wed, Jun 25, 2025 at 12:26:09PM -0700, Dave Hansen wrote:
> On 6/9/25 12:13, Kirill A. Shutemov wrote:
> > The PAMT memory holds metadata for TDX-protected memory. With Dynamic
> > PAMT, PAMT_4K is allocated on demand. The kernel supplies the TDX module
> > with a page pair that covers 2M of host physical memory.
> > 
> > The kernel must provide this page pair before using pages from the range
> > for TDX. If this is not done, any SEAMCALL that attempts to use the
> > memory will fail.
> > 
> > Allocate reference counters for every 2M range to track PAMT memory
> > usage. This is necessary to accurately determine when PAMT memory needs
> > to be allocated and when it can be freed.
> > 
> > This allocation will consume 2MiB for every 1TiB of physical memory.
> 
> ... and yes, this is another boot-time allocation that seems to be
> counter to the goal of reducing the boot-time TDX memory footprint.
> 
> Please mention the 0.4%=>0.0004% overhead here in addition to the cover
> letter. It's important.

Okay.

> > Tracking PAMT memory usage on the kernel side duplicates what TDX module
> > does.  It is possible to avoid this by lazily allocating PAMT memory on
> > SEAMCALL failure and freeing it based on hints provided by the TDX
> > module when the last user of PAMT memory is no longer present.
> > 
> > However, this approach complicates serialization.
> > 
> > The TDX module takes locks when dealing with PAMT: a shared lock on any
> > SEAMCALL that uses explicit HPA and an exclusive lock on PAMT.ADD and
> > PAMT.REMOVE. Any SEAMCALL that uses explicit HPA as an operand may fail
> > if it races with PAMT.ADD/REMOVE.
> > 
> > Since PAMT is a global resource, to prevent failure the kernel would
> > need global locking (per-TD is not sufficient). Or, it has to retry on
> > TDX_OPERATOR_BUSY.
> > 
> > Both options are not ideal, and tracking PAMT usage on the kernel side
> > seems like a reasonable alternative.
> 
> Just a nit on changelog formatting: It would be ideal if you could make
> it totally clear that you are transitioning from "what this patch does"
> to "alternate considered designs".

Will do.

> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/acpi.h>
> >  #include <linux/suspend.h>
> >  #include <linux/idr.h>
> > +#include <linux/vmalloc.h>
> >  #include <asm/page.h>
> >  #include <asm/special_insns.h>
> >  #include <asm/msr-index.h>
> > @@ -50,6 +51,8 @@ static DEFINE_PER_CPU(bool, tdx_lp_initialized);
> >  
> >  static struct tdmr_info_list tdx_tdmr_list;
> >  
> > +static atomic_t *pamt_refcounts;
> 
> Comments, please. How big is this? When is it allocated?
> 
> In this case, it's even sparse, right? That's *SUPER* unusual for a
> kernel data structure.

Will do.

> >  static enum tdx_module_status_t tdx_module_status;
> >  static DEFINE_MUTEX(tdx_module_lock);
> >  
> > @@ -182,6 +185,102 @@ int tdx_cpu_enable(void)
> >  }
> >  EXPORT_SYMBOL_GPL(tdx_cpu_enable);
> >  
> > +static atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
> > +{
> > +	return &pamt_refcounts[hpa / PMD_SIZE];
> > +}
> 
> "get refcount" usually means "get a reference". This is looking up the
> location of the refcount.
> 
> I think this needs a better name.

tdx_get_pamt_ref_ptr()?

> > +static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void *data)
> > +{
> 
> This is getting to be severely under-commented.
> 
> I also got this far into the patch and I'd forgotten about the sparse
> allocation and was scratching my head about what pte's have to do with
> dynamically allocating part of the PAMT.
> 
> That point to a pretty severe deficit in the cover letter, changelogs
> and comments leading up to this point.

Ack.

> > +	unsigned long vaddr;
> > +	pte_t entry;
> > +
> > +	if (!pte_none(ptep_get(pte)))
> > +		return 0;
> 
> This ^ is an optimization, right? Could it be comment appropriately, please?

Not optimization.

Calls of apply_to_page_range() can overlap by one page due to
round_up()/round_down() in alloc_pamt_refcount(). We don't need to
populate these pages again if they are already populated.

Will add a comment.

> > +	vaddr = __get_free_page(GFP_KERNEL | __GFP_ZERO);
> > +	if (!vaddr)
> > +		return -ENOMEM;
> > +
> > +	entry = pfn_pte(PFN_DOWN(__pa(vaddr)), PAGE_KERNEL);
> > +
> > +	spin_lock(&init_mm.page_table_lock);
> > +	if (pte_none(ptep_get(pte)))
> > +		set_pte_at(&init_mm, addr, pte, entry);
> > +	else
> > +		free_page(vaddr);
> > +	spin_unlock(&init_mm.page_table_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static int pamt_refcount_depopulate(pte_t *pte, unsigned long addr,
> > +				    void *data)
> > +{
> > +	unsigned long vaddr;
> > +
> > +	vaddr = (unsigned long)__va(PFN_PHYS(pte_pfn(ptep_get(pte))));
> 
> Gah, we really need a kpte_to_vaddr() helper here. This is really ugly.
> How many of these are in the tree?

I only found such chain in KASAN code.

What about this?

      pte_t entry = ptep_get(pte);
      struct page *page = pte_page(entry);

and use __free_page(page) instead free_page(vaddr)?

The similar thing can be don on allocation side.

> 
> > +	spin_lock(&init_mm.page_table_lock);
> > +	if (!pte_none(ptep_get(pte))) {
> 
> Is there really a case where this gets called on unpopulated ptes? How?

On error, we free metadata from the whole range that covers upto max_pfn.
There's no tracking which portion is populated.

> > +		pte_clear(init_mm, addr, pte);
> > +		free_page(vaddr);
> > +	}
> > +	spin_unlock(&init_mm.page_table_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static int alloc_pamt_refcount(unsigned long start_pfn, unsigned long end_pfn)
> > +{
> > +	unsigned long start, end;
> > +
> > +	start = (unsigned long)tdx_get_pamt_refcount(PFN_PHYS(start_pfn));
> > +	end = (unsigned long)tdx_get_pamt_refcount(PFN_PHYS(end_pfn + 1));
> > +	start = round_down(start, PAGE_SIZE);
> > +	end = round_up(end, PAGE_SIZE);
> > +
> 
> Please try to vertically align these:
> 
> 	start = (...)tdx_get_pamt_refcount(PFN_PHYS(start_pfn));
> 	end   = (...)tdx_get_pamt_refcount(PFN_PHYS(end_pfn + 1));
> 	start = round_down(start, PAGE_SIZE);
> 	end   = round_up(    end, PAGE_SIZE);
> 

Okay.

> > +	return apply_to_page_range(&init_mm, start, end - start,
> > +				   pamt_refcount_populate, NULL);
> > +}
> 
> But, I've staring at these for maybe 5 minutes. I think I've made sense
> of it.
> 
> alloc_pamt_refcount() is taking a relatively arbitrary range of pfns.
> Those PFNs come from memory map and NUMA layout so they don't have any
> real alignment guarantees.
> 
> This code translates the memory range into a range of virtual addresses
> in the *virtual* refcount table. That table is sparse and might not be
> allocated. It is populated 4k at a time and since the start/end_pfn
> don't have any alignment guarantees, there's no telling onto which page
> they map into the refcount table. This has to be conservative and round
> 'start' down and 'end' up. This might overlap with previous refcount
> table populations.
> 
> Is that all correct?

Yes.

> That seems ... medium to high complexity to me. Is there some reason
> none of it is documented or commented? Like, I think it's not been
> mentioned a single time anywhere.

I found it understandable when I wrote it, but it is misjudgement on my
part.

Will work on readability and comments.

> > +static int init_pamt_metadata(void)
> > +{
> > +	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
> > +	struct vm_struct *area;
> > +
> > +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> > +		return 0;
> > +
> > +	/*
> > +	 * Reserve vmalloc range for PAMT reference counters. It covers all
> > +	 * physical address space up to max_pfn. It is going to be populated
> > +	 * from init_tdmr() only for present memory that available for TDX use.
> > +	 */
> > +	area = get_vm_area(size, VM_IOREMAP);
> > +	if (!area)
> > +		return -ENOMEM;
> > +
> > +	pamt_refcounts = area->addr;
> > +	return 0;
> > +}
> Finally, we get to a description of what's actually going on. But, still
> nothing has told me why this is necessary directly.
> 
> If it were me, I'd probably split this up into two patches. The first
> would just do:
> 
> 	area = vmalloc(size);
> 
> The second would do all the fancy sparse population.

Makes sense.

> But either way, I've hit a wall on this. This is too impenetrable as it
> stands to review further. I'll eagerly await a more approachable v3.

Got it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

