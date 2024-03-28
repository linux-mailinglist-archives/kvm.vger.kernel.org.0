Return-Path: <kvm+bounces-12913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 774AF88F362
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAE1C1F2A9BB
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C5B4A18;
	Thu, 28 Mar 2024 00:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FPF5b7nX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B119620;
	Thu, 28 Mar 2024 00:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711584129; cv=none; b=ijLF5uyQqsjlyo/vic4tyea4j3dr+5EXI2H+hfY+7nAX+rFvcTDfhf1urKWsH0rs7m9BeEb3YePqmo8urUipJaeW2pWWpfxBGEmGZpsH4AerlU+tZh5Rmsuomk2P9xcFU2SVGi7OKtXuhxJsokvWJG6hhvzKckvzHGkN+fJEp0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711584129; c=relaxed/simple;
	bh=ehCURjPDH0bWZCXEKOnfCcIV3SG5PydW3duDhNeYwys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GpE/h4ll1HfaboBeoYedDUF9PP9FlXj2FEX2gKrgFgZtPQfEhGNUp54GHR6eoV7GXS7WnQ0+4i1OBzFKchgwpx3XkNNWSqRkBu+WUF9KWA41qiwhhzywPfBQTN6stCc0F4M68PlFt0vA5mrV60DgAuWCDBWJ8fSF6MdRCdSeTS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FPF5b7nX; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711584127; x=1743120127;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ehCURjPDH0bWZCXEKOnfCcIV3SG5PydW3duDhNeYwys=;
  b=FPF5b7nXrFvysFuVnpCJQOFFONORwBD0kk+jG+T6hbwHsO9AzR5mm0DS
   WRjeL8p8Q+eBNWeCYi14ks6pNlEF09N7pcjXvKwJ6XZUhTGDCMzxPTqdR
   0GdXqlUBNKJQ6pRPre6m9P3iYklLtjVLbv3hYK2swoOf+itDrQpYLi7+q
   Mu8maQAx/ayCr3vfF8yyETCPZrMQjlGrjyivr9zw93cSSNoPxuhJFXZjT
   pGmyE5mQCB/6JNitq0bOo4Uy134rfrloYDZ0qBJXixJCpik8KA73dSFnJ
   EBQFW4bylhaaxlkSsXMnxbUUd1wMbMwDgVS634RKq0UJ7kXa2xOX1kKRH
   A==;
X-CSE-ConnectionGUID: EzFcRKeARqGxegn1krt22Q==
X-CSE-MsgGUID: LCPqfNiZQna0IkxKJIUPYQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="9677786"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="9677786"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:02:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16916865"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:02:05 -0700
Date: Wed, 27 Mar 2024 17:02:05 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Message-ID: <20240328000205.GJ2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
 <50dc7be78be29bbf412e1d6a330d97b29adadb76.camel@intel.com>
 <20240314181000.GC1258280@ls.amr.corp.intel.com>
 <bfde1328-2d1c-4b75-970f-69c74f3a74f9@intel.com>
 <ada65e3e977c8cde0044b7fa9de5f918e3b1b638.camel@intel.com>
 <20240315010940.GE1258280@ls.amr.corp.intel.com>
 <35090f7e-4f4d-403c-b95e-f09248fc272d@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <35090f7e-4f4d-403c-b95e-f09248fc272d@linux.intel.com>

On Wed, Mar 27, 2024 at 09:49:14PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 3/15/2024 9:09 AM, Isaku Yamahata wrote:
> > Here is the updated one. Renamed dummy -> mirroed.
> > 
> > When KVM resolves the KVM page fault, it walks the page tables.  To reuse
> > the existing KVM MMU code and mitigate the heavy cost of directly walking
> > the private page table, allocate one more page to copy the mirrored page
> 
> Here "copy" is a bit confusing for me.
> The mirrored page table is maintained by KVM, not copied from anywhere.

How about, "maintain" or "keep"?

> 
> > table for the KVM MMU code to directly walk.  Resolve the KVM page fault
> > with the existing code, and do additional operations necessary for the
> > private page table.  To distinguish such cases, the existing KVM page table
> > is called a shared page table (i.e., not associated with a private page
> > table), and the page table with a private page table is called a mirrored
> > page table.  The relationship is depicted below.
> > 
> > 
> >                KVM page fault                     |
> >                       |                           |
> >                       V                           |
> >          -------------+----------                 |
> >          |                      |                 |
> >          V                      V                 |
> >       shared GPA           private GPA            |
> >          |                      |                 |
> >          V                      V                 |
> >      shared PT root      mirrored PT root         |    private PT root
> >          |                      |                 |           |
> >          V                      V                 |           V
> >       shared PT           mirrored PT ----propagate---->  private PT
> >          |                      |                 |           |
> >          |                      \-----------------+------\    |
> >          |                                        |      |    |
> >          V                                        |      V    V
> >    shared guest page                              |    private guest page
> >                                                   |
> >                             non-encrypted memory  |    encrypted memory
> >                                                   |
> > PT: Page table
> > Shared PT: visible to KVM, and the CPU uses it for shared mappings.
> > Private PT: the CPU uses it, but it is invisible to KVM.  TDX module
> >              updates this table to map private guest pages.
> > Mirrored PT: It is visible to KVM, but the CPU doesn't use it.  KVM uses it
> >               to propagate PT change to the actual private PT.
> > 
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

