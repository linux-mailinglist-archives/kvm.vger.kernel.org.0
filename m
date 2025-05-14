Return-Path: <kvm+bounces-46423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C2CAAB635E
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 08:43:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD4CC4A1574
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 06:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B930E201262;
	Wed, 14 May 2025 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mlHtb/UC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5654820102C;
	Wed, 14 May 2025 06:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747204992; cv=none; b=GMI53cU+PwfWrg4HQsBo7D8e1synPAxrwbHD9sqszv8z4vl/feWdu/ncPKj13SNIL6XB7rGUgYZCs6sLFixksjAdP40U+OaYmWgJFXf6ZVEqYlHIeH09aO15DjLERGBNFTbZEaHH+PnNjci/8SM9CegdvwAFq7j5X/zY3ZvMFnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747204992; c=relaxed/simple;
	bh=kFHkCxWs6VPQE47pxI+eiEDzhqKDD4j49CqEU63h/ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udyJqLQYtqnS1JXrfTYe2+gKGbv9T9TDNtF70Zv/FKvo/ycFuen4OcQFdVjebvvUXqoiQIcarUguZ5+Vjbz5f0OXgb5CspZmlhDYPdHisqgrjE4iWun5ivwKq0aGmP4mCaU5BCZSsbd9JE9QP05SA4kZ5wJfyEDoidUIz8dtplY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mlHtb/UC; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747204991; x=1778740991;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=kFHkCxWs6VPQE47pxI+eiEDzhqKDD4j49CqEU63h/ck=;
  b=mlHtb/UC8IbDr1zyS3Ps3hIdqPWT5DdsNN2iZEuyM3/i4ELX3JqafmTN
   O5JnF/O32tGhslnfEs4AFpq3W49Hje8DjezrGvydeicJFZLUGF9x5GyKl
   pl7YIJps7mZDkgi5nFAsNKJVuto0VcNAm8z/eqbxxzo3YElKTIJKt1Y9+
   SLggtX1TtHaq7pnwgotaJVEThaCRZcpvBfEs+LtqYMxtMXJ5yd5PSGEvy
   Wy+ejO/2e9L8lyMWnu70stQYVjsUm8GcSZy4JlYrzg0k9xiwSP0M17koE
   CPeXapO0f7oHxLPI5u7D0QF8+xeJc5tusBeQDEGS/SE7P6xbfajNbAhsM
   g==;
X-CSE-ConnectionGUID: 1sT9Ar0WR3aA1srgFjJleA==
X-CSE-MsgGUID: FCBBfcZkQQiXCUsgCtnosw==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="59310560"
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="59310560"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 23:43:10 -0700
X-CSE-ConnectionGUID: S9yAEpEIQe2bWP7fO6rrTQ==
X-CSE-MsgGUID: 8z4kgyjUQQKeb9yxGsH6zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="143060552"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa005.jf.intel.com with ESMTP; 13 May 2025 23:43:07 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 150621FD; Wed, 14 May 2025 09:43:06 +0300 (EEST)
Date: Wed, 14 May 2025 09:43:06 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Message-ID: <6b5pkr4eh3l6c2ovp6t2m7phonp4kr2z5k5facrsktcmsyztqo@2hjgi7c455km>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
 <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>
 <t2im27kgcfsl2qltxbf3cear35szyoafczgvmmwootxthnbcdp@dasmg4bdfd6i>
 <aB1ZplDCPkDCkhQr@yzhao56-desk.sh.intel.com>
 <2bi4cz2ulrki62odprol253mhxkvjdu3xtq4p6dbndowsufnmu@7kzlzywmi22s>
 <8668efe87d6e538b5a49a3c7508ade612a6d766b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8668efe87d6e538b5a49a3c7508ade612a6d766b.camel@intel.com>

On Wed, May 14, 2025 at 12:00:17AM +0000, Huang, Kai wrote:
> On Mon, 2025-05-12 at 12:55 +0300, Kirill A. Shutemov wrote:
> > On Fri, May 09, 2025 at 09:25:58AM +0800, Yan Zhao wrote:
> > > On Thu, May 08, 2025 at 04:23:56PM +0300, Kirill A. Shutemov wrote:
> > > > On Tue, May 06, 2025 at 07:55:17PM +0800, Yan Zhao wrote:
> > > > > On Fri, May 02, 2025 at 04:08:24PM +0300, Kirill A. Shutemov wrote:
> > > > > > The functions kvm_x86_ops::link_external_spt() and
> > > > > > kvm_x86_ops::set_external_spte() are used to assign new memory to a VM.
> > > > > > When using TDX with Dynamic PAMT enabled, the assigned memory must be
> > > > > > covered by PAMT.
> > > > > > 
> > > > > > The new function kvm_x86_ops::phys_prepare() is called before
> > > > > > link_external_spt() and set_external_spte() to ensure that the memory is
> > > > > > ready to be assigned to the virtual machine. In the case of TDX, it
> > > > > > makes sure that the memory is covered by PAMT.
> > > > > > 
> > > > > > kvm_x86_ops::phys_prepare() is called in a context where struct kvm_vcpu
> > > > > > is available, allowing the implementation to allocate memory from a
> > > > > > per-VCPU pool.
> > > > > > 
> > > > > Why not invoke phys_prepare() and phys_cleanup() in set_external_spte_present()?
> > > > > Or in tdx_sept_set_private_spte()/tdx_sept_link_private_spt()?
> > > > 
> > > > Because the memory pool we allocated from is per-vcpu and we lost access
> > > > to vcpu by then. And not all callers provide vcpu.
> > > Maybe we can get vcpu via kvm_get_running_vcpu(), as in [1].
> > > Then for callers not providing vcpu (where vcpu is NULL), we can use per-KVM
> > > cache? 
> > 
> > Hm. I was not aware of kvm_get_running_vcpu(). Will play with it, thanks.
> 
> I am not sure why per-vcpu cache matters.
> 
> For non-leaf SEPT pages, AFAICT the "vcpu->arch.mmu_external_spt_cache" is just
> an empty cache, and eventually __get_free_page() is used to allocate in:
>                                                                                             
>   sp->external_spt = 
> 	kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
> 
> So why not we actually create a kmem_cache for it with an actual 'ctor', and we
> can call tdx_alloc_page() in that.  This makes sure when the "external_spt" is
> allocated, the underneath PAMT entry is there.

This would make hard to debug PAMT memory leaks. external_spt pages in the
pool will have PAMT memory tied to them, so we will have non-zero PAMT
memory usage with zero TDs running.

> For the last level guest memory page, similar to SEV, we can hook the
> kvm_arch_gmem_prepare() to call tdx_alloc_page() to make PAMT entry ready.

I don't think kvm_arch_gmem_prepare() is right place to allocate PAMT
memory. THPs are dynamic and page order can change due to split or
collapse between the time the page is allocated and gets mapped into EPT.
I am not sure if SEV code is correct in this regard.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

