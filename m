Return-Path: <kvm+bounces-64130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1FE6C79235
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id AFA552DB72
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A48D33CE84;
	Fri, 21 Nov 2025 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CLJi7yG7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1886E34403C;
	Fri, 21 Nov 2025 13:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730561; cv=none; b=nYtChJoJzaWbBoKzAUbWGwsjBGWpPJyk7597uoXDnNhlSsaYi2y3qV0rJ/OFw+3Yzx6xXBV68zclge8QZrffuejdO/jDzEY1qPbFFc48xrNV01i7qeC6NpoIOIqziW5JopK1H7sFMGOD/6lOXxHXnUyH3Mdsqqk4CdcljumrrPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730561; c=relaxed/simple;
	bh=Mx8HU1WWOmumCvnpOXz2MRvFcRa3p7T/im80j8iH4Jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTWgghs/9upKn+B3Q2YFPpQu+0SesviGd6rX2mU8LnXrTKRvnApD6jDfMS7TiB54OnE2NG4Im3QfXYyhJOMHRoDeGyyeEbIPv4nQ1NSxQM3Pc0VmtZe3P86P++dAyeVmnletnoKSO0hIewcqwNYoIKjZmCaOY16JOSNP4AKYsBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CLJi7yG7; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763730558; x=1795266558;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mx8HU1WWOmumCvnpOXz2MRvFcRa3p7T/im80j8iH4Jc=;
  b=CLJi7yG7bAdPAIHdMYvdxurMrIkWkuS1gAUgR5E2DxVeyS5AzBUKxcp4
   RWW38KupGIRGV2WqCexdli4IdIUp//Kbit8lsXGeDWsZ+bgvvr8rSSn1K
   R/7A/rWJ8Wttu1VKXMC/ewuC5MrUfeRQtL0aE1B8dDoM03SDd5KEnoNdt
   UfoTZOjIQHfvibuJcFQgbKoiLhxDGAuZbuwz2aNYGrPALiECgkPYbF4Rm
   GYbjpv161Q7E6LT/Ny8kyDVVWJrRQbnqPxajHm9b9lcIF6nxModBQNZGC
   Rd0YFSY5LVnydieQyedRd9YiZRj+FuD9c3LhymEERHQVSUdK15sGPhRwS
   Q==;
X-CSE-ConnectionGUID: sT3uQNS2Q7GZw+O1lL/9kQ==
X-CSE-MsgGUID: uyY17x6gSd+jQ4JxrY3FdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="76505775"
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="76505775"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 05:09:17 -0800
X-CSE-ConnectionGUID: cglKvljOQ4ad6mlqkP7kKg==
X-CSE-MsgGUID: rBcSODACTTC7Ti6Rcm0ksg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="191368929"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa007.fm.intel.com with ESMTP; 21 Nov 2025 05:09:14 -0800
Date: Fri, 21 Nov 2025 20:54:19 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
Message-ID: <aSBg+5rS1Y498gHx@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
 <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
 <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
 <62bec236-4716-4326-8342-1863ad8a3f24@intel.com>
 <aR6ws2yzwQumApb9@yilunxu-OptiPlex-7050>
 <13e894a8-474f-465a-a13a-5d892efbfadb@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13e894a8-474f-465a-a13a-5d892efbfadb@intel.com>

> I want an overview of how this new memory fits into the overall scheme.
> I'd argue that these "control pages" are most similar to the PAMT:
> There's some back-and-forth with the module about how much memory it
> needs, the kernel allocates it, hands it over, and never gets it back.
> 
> That's the level that this needs to be presented at: a high-level
> logical overview.

OK. I can split out a patch dedicate to the memory feeding, and put
the overview in changelog.


x86/virt/tdx: Add extra memory to TDX Module for Extentions

Currently, TDX module memory use is relatively static. But, some new
features (called "TDX Module Extensions") need to use memory more
dynamically. While 'static' here means the kernel provides necessary
amount of memory to TDX Module for its initialization, 'dynamic' means
extra memory be added after TDX Module initialization and before the
first optional usage of TDX Module Extension. So add a new memory
feeding process backed by a new SEAMCALL TDH.EXT.MEM.ADD.

The process is mostly the same as adding PAMT. The kernel queries TDX
Module how much memory needed, allocates it, hands it over and never
gets it back.

more details...

For now, TDX Module Extensions consume quite large amount of memory
(12800 pages), print this readout value on TDX Module Extentions
initialization.

> 
> ...> I think it may be too heavy. We have a hundred SEAMCALLs and I expect
> > few needs version 1. I actually think v2 is nothing different from a new

Sorry for typo, there is no v2 yet.

> > leaf. How about something like:
> > 
> > --- a/arch/x86/virt/vmx/tdx/tdx.h
> > +++ b/arch/x86/virt/vmx/tdx/tdx.h
> > @@ -46,6 +46,7 @@
> >  #define TDH_PHYMEM_PAGE_WBINVD         41
> >  #define TDH_VP_WR                      43
> >  #define TDH_SYS_CONFIG                 45
> > +#define TDH_SYS_CONFIG_V1              (TDH_SYS_CONFIG | (1ULL << TDX_VERSION_SHIFT))
> > 
> > And if a SEAMCALL needs export, add new tdh_foobar() helper. Anyway
> > the parameter list should be different.
> 
> I'd need quite a bit of convincing that this is the right way.
> 
> What is the scenario where there's a:
> 
> 	TDH_SYS_CONFIG_V1
> and
> 	TDH_SYS_CONFIG_V2
> 
> in the tree at the same time?

I assume you mean TDH_SYS_CONFIG & TDH_SYS_CONFIG_V1.

If you want to enable optional features via this seamcall, you must use
v1, otherwise v0 & v1 are all good. Mm... I suddenly don't see usecase
they must co-exist. Unconditionally use v1 is fine. So does TDH_VP_INIT.

Does that mean we don't have to keep versions, always use the latest is
good? (Proper Macro to be used...)

 -#define TDH_SYS_CONFIG                 45
 +#define TDH_SYS_CONFIG                 (45 | (1ULL << TDX_VERSION_SHIFT))

> 
> Second, does it hurt to pass the version along with other calls, like
> ... (naming a random one) ... TDH_PHYMEM_PAGE_WBINVD ?

I see no runtime hurt, just an extra zero parameter passed around.

And version change always goes with more parameters, if we add version
parameter, it looks like:

 u64 tdh_phymem_page_wbinvd_tdr(int version, struct tdx_td *td, int new_param1, int new_param2);

For readability, I prefer the following, they provide clear definitions:

 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 u64 tdh_phymem_page_wbinvd_tdr_1(struct tdx_td *td, int new_param1, int new_param2);


But I hope eventually we don't have to keep versions, then we don't have to choose:

 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td, int new_param1, int new_param2);


> 
> Even if we did this, we wouldn't copy and paste "(1ULL <<
> TDX_VERSION_SHIFT)" all over the place, right? We'd create a more
> concise, cleaner macro and then use it everywhere. Right?

Sure. Will do.

...

> >>>> 	while (1)
> >>>> 		fill(&array);
> >>>> 	while (1)
> >>>> 		tell_tdx_module(&array);
> >>>
> >>> The consideration is, no need to create as much supporting
> >>> structures (struct tdx_page_array *, struct page ** and root page) for
> >>> each 512-page bulk. Use one and re-populate it in loop is efficient.

Sorry, I went through the history again and thought I got off track from
here. I was trying to explain why I choose to let struct tdx_page_array
not restricted by 512 pages. But that's not your question.

For your question why:

  while (1) {
        fill(&array);
        tell_tdx_module(&array);
  }

not:

  while (1)
        fill(&array);
  while (1)
        tell_tdx_module(&array);

The TDX Module can only accept one root page (i.e. 512 HPAs at most), while
struct tdx_page_array contains the whole EXT memory (12800 pages). So we
can't populate all pages into one root page then tell TDX Module. We need to
populate one batch, tell tdx module, then populate the next batch, tell
tdx module...

I assume when you said "Great! That is useful information to have here,
in the code." The concern was solved.

> I suspect we're not really talking about the same thing here.

Sorry I deviated from the question.

> 
> In any case, I'm not a super big fan of how tdx_ext_mempool_setup() is
> written. Can you please take another pass at it and try to simplify it
> and make it easier to follow?

Yes. I plan to remove the __free(). This gives the chance to re-organize
things from the start.

> 
> This would be a great opportunity to bring in some of your colleagues to
> take a look. You can solicit them for suggestions.

Yes.

...

> >> I'd kinda rather the code was improved. Why cram everything into a
> >> pointer if you don't need to. This would be just fine, no?
> >>
> >> 	ret = tdx_ext_mempool_setup(&mempool);
> >> 	if (ret)
> >> 		return ret;
> > 
> > It's good.
> > 
> > The usage of pointer is still about __free(). In order to auto-free
> > something, we need an object handler for something. I think this is a
> > more controversial usage of __free() than pure allocation. We setup
> > something and want auto-undo something on failure.
> I'm not sure what you are trying to say here. By saying "It's good" are
> you agreeing that my suggested structure is good and that you will use
> it? Or are you saying that the original structure is good?

I mean your suggestion is good. I'll use it since I will remove
__free().

> 
> Second, what is an "object handler"? Are you talking about the function
> that is pointed to by __free()?

Sorry, should be object handle, it refers to the pointer, the
struct tdx_page_array *mempool

> 
> Third, are you saying that the original code structure is somehow
> connected to __free()?

Yes.

> I thought that all of these were logically
> equivalent:
> 
> 	void *foo __free(foofree) = alloc_foo();
> 
> 	void *foo __free(foofree) = NULL:
> 	foo = alloc_foo();
> 
> 	void *foo __free(foofree) = NULL;
> 	populate_foo(&foo);
> 
> Is there something special about doing the variable assignment at the
> variable declaration spot?

Yes, Dan explained it.

