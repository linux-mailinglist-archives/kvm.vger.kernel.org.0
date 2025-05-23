Return-Path: <kvm+bounces-47580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD83AC224E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 14:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C548C1BC2B1D
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 12:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69352236451;
	Fri, 23 May 2025 12:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nxHUTEje"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002A32036ED;
	Fri, 23 May 2025 12:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748001663; cv=none; b=hh0j+rpKQtcDlq1TXA2jfo6PIjWVQ7PWk3I/LAophVFZf3hxYrArYQaP8+oqaLeiW7QCm5sBLotObi8ZZEus/a89+pfWVRN8fVda5LsLdPzieP7bKrheEKv8UCjh4ssa/5Ytu5A7WVCBq4mISHVqnSTmXQUJe8Y/oiqh/P4wVgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748001663; c=relaxed/simple;
	bh=7IjIckS/eHld9WifYNay9DZZv9Fs5Z1uq608lkoIXkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYQY65v78qAduUeDMz7cshtgQ1aQjLX7qCGprRAzUpdDZAO7R1OQ9UAp3CDGbi4B8sSrV4PgNpIgRoLA2EUSaRvr2aKrlCHllhl3HUKJh55kMuBHlWJMlMQhVX0vEMuEeu3PFzX+CjTaWVJzhuovdrKBP/rC5Fqkkhn28uR3xfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nxHUTEje; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748001662; x=1779537662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=7IjIckS/eHld9WifYNay9DZZv9Fs5Z1uq608lkoIXkI=;
  b=nxHUTEjeRckz0pihB027tb/94QuYG4HV3b5v1rEib/k/2qgaPQExy4ij
   HRVc7bxLeCrpqNg0Y5BQR3NtwJyeZXEtE9iY6C+8f/MKevm4/6Lt/WIAs
   gsvseR7rn+NuACa67HRsk5Hcexhtrp1fniZeNpvM5FOgLLHmrw21rLXpH
   w1Xs4GDKY7Tr47jbKnvjqGeJc+izqBEJyXusYME85+pZxvR2/PVsh9HIm
   yIFRHKkKV7egxzi9QS2ciOB8W81wR8bYw22Pu64muIfe9CkxV8Xi8nwxI
   kjYkuWAT7PcHTQs5x8D2CJErT36Dg3uyUDoSFCrHzXdX8FqKzK6qy/oYx
   Q==;
X-CSE-ConnectionGUID: GXi5kTDVTe2MItB97A3lUw==
X-CSE-MsgGUID: GieZnZyMSRW9inJwlotmSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50220491"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="50220491"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 05:01:01 -0700
X-CSE-ConnectionGUID: 7NjLot7PTG2we7A1X3P5lw==
X-CSE-MsgGUID: 7qugAWUHQgK6aOkQIYfU1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="141178468"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa007.fm.intel.com with ESMTP; 23 May 2025 05:00:58 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id ACD931F6; Fri, 23 May 2025 15:00:56 +0300 (EEST)
Date: Fri, 23 May 2025 15:00:56 +0300
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
Message-ID: <mgu7at7d3qy4h55bchxfmxj6yzqyi7gh4ieds4ecdvlv243frl@bzou376shiak>
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

I looked closer to this and while it is good idea, but ctor in kmem_cache
cannot fail which makes this approach not viable.

I guess we can a constructor directly into struct kvm_mmu_memory_cache.
Let me play with this.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

