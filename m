Return-Path: <kvm+bounces-50747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C7DC7AE8EAA
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 21:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C216F4A6B0C
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 19:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD942DCC1C;
	Wed, 25 Jun 2025 19:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fpy5a7Ld"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5E72DBF66;
	Wed, 25 Jun 2025 19:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750879574; cv=none; b=RJ38P7xZIM15iinlcGQ06yj6CdN9J05w3cL1sbENYQuVA9dh3ihSFqhUPAE1F0xjwWvzd14Fcm3wJhjAPwcvlNseWYJKI1gGaKr3SEDgzV9+oD1zVhwMX/BTXw5W4LskI55O40NXqo88dsouQi2glwHID6TvL9g+j74t1IWlR08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750879574; c=relaxed/simple;
	bh=STCW0Ble9JAfnjY2ffDHzXPQLbDsHhsDIG/HFSdoeUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UOQQQ1GP62b5VQ/kQafuHzP8OML0YrEfCNwVWU52hoxuG4HcJJaLAA5U5az7SpUJzbDKDx2jmTlhsI7ZUZ1InKp3DMYWajF6Aw9iio4gTOzKcNrogKnCXjEQWXgUEBcQqmKSbWEUOsUR9gXS47QTL+aoVfOWtrTJg6QtDKC1mBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fpy5a7Ld; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750879572; x=1782415572;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=STCW0Ble9JAfnjY2ffDHzXPQLbDsHhsDIG/HFSdoeUc=;
  b=fpy5a7Ld7d8ef2VksH/dHQdmwYCTPlE7S3bysINeqWgN+6A2O9BIZPU9
   AFgKjRx/8sWLaRpAvyiHO8kvc6hIxdmZzdSKXav7II3jcSSIPFmQQDuqB
   mlcRWPPRRTjmsYUMbJdsDzVAHYv+Mz2xwOLnFrZpowzSU43652xz4memT
   bZtI/mgr/fnJjjNcHzPoEGgl4HMiKz+i9TBO8xWYOfANIKpvdHYUb1OHp
   PGhQD15WQAyonwr5TwRgRgd31+H74v3JlAXAWj5xHlBL0kXGkZYP2WzLn
   X3KiUuN/0sHoa5GL07mIhf1k3Fsyzwul4MN5nTEMg0E6Ztn4XB4Ql/1cn
   A==;
X-CSE-ConnectionGUID: ox0n6paUTrKzqsi46NVDDw==
X-CSE-MsgGUID: ZVB8/MUcQ3y7RU/+srQI2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="64598523"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="64598523"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 12:26:11 -0700
X-CSE-ConnectionGUID: mpA8a4WkQNWjvzIc+WzlxQ==
X-CSE-MsgGUID: GClNW5waSSaWcZVRiVVU7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="152430668"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.108.244]) ([10.125.108.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 12:26:10 -0700
Message-ID: <fb5addcb-1cfc-45be-978c-e7cee4126b38@intel.com>
Date: Wed, 25 Jun 2025 12:26:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 03/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, isaku.yamahata@intel.com,
 kai.huang@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, kvm@vger.kernel.org,
 x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-4-kirill.shutemov@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250609191340.2051741-4-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/9/25 12:13, Kirill A. Shutemov wrote:
> The PAMT memory holds metadata for TDX-protected memory. With Dynamic
> PAMT, PAMT_4K is allocated on demand. The kernel supplies the TDX module
> with a page pair that covers 2M of host physical memory.
> 
> The kernel must provide this page pair before using pages from the range
> for TDX. If this is not done, any SEAMCALL that attempts to use the
> memory will fail.
> 
> Allocate reference counters for every 2M range to track PAMT memory
> usage. This is necessary to accurately determine when PAMT memory needs
> to be allocated and when it can be freed.
> 
> This allocation will consume 2MiB for every 1TiB of physical memory.

... and yes, this is another boot-time allocation that seems to be
counter to the goal of reducing the boot-time TDX memory footprint.

Please mention the 0.4%=>0.0004% overhead here in addition to the cover
letter. It's important.

> Tracking PAMT memory usage on the kernel side duplicates what TDX module
> does.  It is possible to avoid this by lazily allocating PAMT memory on
> SEAMCALL failure and freeing it based on hints provided by the TDX
> module when the last user of PAMT memory is no longer present.
> 
> However, this approach complicates serialization.
> 
> The TDX module takes locks when dealing with PAMT: a shared lock on any
> SEAMCALL that uses explicit HPA and an exclusive lock on PAMT.ADD and
> PAMT.REMOVE. Any SEAMCALL that uses explicit HPA as an operand may fail
> if it races with PAMT.ADD/REMOVE.
> 
> Since PAMT is a global resource, to prevent failure the kernel would
> need global locking (per-TD is not sufficient). Or, it has to retry on
> TDX_OPERATOR_BUSY.
> 
> Both options are not ideal, and tracking PAMT usage on the kernel side
> seems like a reasonable alternative.

Just a nit on changelog formatting: It would be ideal if you could make
it totally clear that you are transitioning from "what this patch does"
to "alternate considered designs".

> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -29,6 +29,7 @@
>  #include <linux/acpi.h>
>  #include <linux/suspend.h>
>  #include <linux/idr.h>
> +#include <linux/vmalloc.h>
>  #include <asm/page.h>
>  #include <asm/special_insns.h>
>  #include <asm/msr-index.h>
> @@ -50,6 +51,8 @@ static DEFINE_PER_CPU(bool, tdx_lp_initialized);
>  
>  static struct tdmr_info_list tdx_tdmr_list;
>  
> +static atomic_t *pamt_refcounts;

Comments, please. How big is this? When is it allocated?

In this case, it's even sparse, right? That's *SUPER* unusual for a
kernel data structure.

>  static enum tdx_module_status_t tdx_module_status;
>  static DEFINE_MUTEX(tdx_module_lock);
>  
> @@ -182,6 +185,102 @@ int tdx_cpu_enable(void)
>  }
>  EXPORT_SYMBOL_GPL(tdx_cpu_enable);
>  
> +static atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
> +{
> +	return &pamt_refcounts[hpa / PMD_SIZE];
> +}

"get refcount" usually means "get a reference". This is looking up the
location of the refcount.

I think this needs a better name.

> +static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void *data)
> +{

This is getting to be severely under-commented.

I also got this far into the patch and I'd forgotten about the sparse
allocation and was scratching my head about what pte's have to do with
dynamically allocating part of the PAMT.

That point to a pretty severe deficit in the cover letter, changelogs
and comments leading up to this point.

> +	unsigned long vaddr;
> +	pte_t entry;
> +
> +	if (!pte_none(ptep_get(pte)))
> +		return 0;

This ^ is an optimization, right? Could it be comment appropriately, please?

> +	vaddr = __get_free_page(GFP_KERNEL | __GFP_ZERO);
> +	if (!vaddr)
> +		return -ENOMEM;
> +
> +	entry = pfn_pte(PFN_DOWN(__pa(vaddr)), PAGE_KERNEL);
> +
> +	spin_lock(&init_mm.page_table_lock);
> +	if (pte_none(ptep_get(pte)))
> +		set_pte_at(&init_mm, addr, pte, entry);
> +	else
> +		free_page(vaddr);
> +	spin_unlock(&init_mm.page_table_lock);
> +
> +	return 0;
> +}
> +
> +static int pamt_refcount_depopulate(pte_t *pte, unsigned long addr,
> +				    void *data)
> +{
> +	unsigned long vaddr;
> +
> +	vaddr = (unsigned long)__va(PFN_PHYS(pte_pfn(ptep_get(pte))));

Gah, we really need a kpte_to_vaddr() helper here. This is really ugly.
How many of these are in the tree?

> +	spin_lock(&init_mm.page_table_lock);
> +	if (!pte_none(ptep_get(pte))) {

Is there really a case where this gets called on unpopulated ptes? How?

> +		pte_clear(&init_mm, addr, pte);
> +		free_page(vaddr);
> +	}
> +	spin_unlock(&init_mm.page_table_lock);
> +
> +	return 0;
> +}
> +
> +static int alloc_pamt_refcount(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	unsigned long start, end;
> +
> +	start = (unsigned long)tdx_get_pamt_refcount(PFN_PHYS(start_pfn));
> +	end = (unsigned long)tdx_get_pamt_refcount(PFN_PHYS(end_pfn + 1));
> +	start = round_down(start, PAGE_SIZE);
> +	end = round_up(end, PAGE_SIZE);
> +

Please try to vertically align these:

	start = (...)tdx_get_pamt_refcount(PFN_PHYS(start_pfn));
	end   = (...)tdx_get_pamt_refcount(PFN_PHYS(end_pfn + 1));
	start = round_down(start, PAGE_SIZE);
	end   = round_up(    end, PAGE_SIZE);

> +	return apply_to_page_range(&init_mm, start, end - start,
> +				   pamt_refcount_populate, NULL);
> +}

But, I've staring at these for maybe 5 minutes. I think I've made sense
of it.

alloc_pamt_refcount() is taking a relatively arbitrary range of pfns.
Those PFNs come from memory map and NUMA layout so they don't have any
real alignment guarantees.

This code translates the memory range into a range of virtual addresses
in the *virtual* refcount table. That table is sparse and might not be
allocated. It is populated 4k at a time and since the start/end_pfn
don't have any alignment guarantees, there's no telling onto which page
they map into the refcount table. This has to be conservative and round
'start' down and 'end' up. This might overlap with previous refcount
table populations.

Is that all correct?

That seems ... medium to high complexity to me. Is there some reason
none of it is documented or commented? Like, I think it's not been
mentioned a single time anywhere.

> +static int init_pamt_metadata(void)
> +{
> +	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
> +	struct vm_struct *area;
> +
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return 0;
> +
> +	/*
> +	 * Reserve vmalloc range for PAMT reference counters. It covers all
> +	 * physical address space up to max_pfn. It is going to be populated
> +	 * from init_tdmr() only for present memory that available for TDX use.
> +	 */
> +	area = get_vm_area(size, VM_IOREMAP);
> +	if (!area)
> +		return -ENOMEM;
> +
> +	pamt_refcounts = area->addr;
> +	return 0;
> +}
Finally, we get to a description of what's actually going on. But, still
nothing has told me why this is necessary directly.

If it were me, I'd probably split this up into two patches. The first
would just do:

	area = vmalloc(size);

The second would do all the fancy sparse population.

But either way, I've hit a wall on this. This is too impenetrable as it
stands to review further. I'll eagerly await a more approachable v3.

