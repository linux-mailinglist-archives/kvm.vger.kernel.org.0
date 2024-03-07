Return-Path: <kvm+bounces-11315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2B648754E5
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 18:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85EB71F23BDD
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 17:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E72130E48;
	Thu,  7 Mar 2024 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HBnJ+36P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F48130AF8;
	Thu,  7 Mar 2024 17:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709831442; cv=none; b=ES5FJeyD6SwQuMhIr9EjrLBzLxXy/YBg3i1bfnNfQVzOMtQStOd07Ao0tV4m9mrtkrdo8MvWQDM/cHVIycoEIlJeCyQWz54RGbURvZbrDE3ZH2eTJeFUU8x4q37qW8AYbxDXaNU/8PqG6An39fNgzVAmtdo0WBzYbfPcjQLHJFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709831442; c=relaxed/simple;
	bh=6CqTY8Cis5LdvB3OJwKtmRzxNEBIBumnzKN3pG/9xm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G73DAyXEsSh0JNSWRthUYzK166f6cKVWaPRQvKtASf1eOrVG5lJDVYdQE1TrKmvGGy3jcjprMU+LQxWQGwJZP4FTRss+lod0QSaOuFARRAzNDZnFmdvY+tuNC6P1QUB8TbsBK+5sTMCNDTcaKkO8bH4Jj9xZOwJban6LKIvEK5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HBnJ+36P; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709831440; x=1741367440;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6CqTY8Cis5LdvB3OJwKtmRzxNEBIBumnzKN3pG/9xm4=;
  b=HBnJ+36PvEa9E0kGB6zIwPqUd1hxivIB7XOp68QY11qxCBdcfbJaT4v6
   AMQdbyU8QgHdhBWR/Ohs7d1DtrCOOV+lMx3rig9KLMGn8ZrHi3WA0al6J
   QMnJZYoVdwhSt9PsTNTxGhhdmSqV+7aK5Y3SsM/WiqkjqEr4s9NqyZen6
   e80ZALT9EBA5g10OEvgPiEbbZvv2sWLSVGxv9QskUGzYnV0zvPywf7vuV
   MZL5GkquFn9T3oiovnm5XawHQYtdalCXS2w2a7SBZiF0nJf/r21y8OBQa
   FFS6H2ZAv9Wp1OGCr8eoVWTALo04ncEhfnjnC9fvTaZrEVqNQDToY7IK7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4393828"
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="4393828"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 09:10:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="937046416"
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="937046416"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 07 Mar 2024 09:10:22 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 85F8A128; Thu,  7 Mar 2024 19:10:21 +0200 (EET)
Date: Thu, 7 Mar 2024 19:10:21 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 11/16] KVM: x86/mmu: Explicitly disallow private accesses
 to emulated MMIO
Message-ID: <3acw6nkfyre4t46i5gmd4lzxxlveiaksp55hunidfhi6lr6brh@7oqn63pu3flb>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-12-seanjc@google.com>
 <0a05d5ec-5352-4bab-96ae-2fa35235477c@intel.com>
 <ZejxqaEBi3q0TU_d@google.com>
 <5f230626-2738-41cc-875d-ab1a7ef19f64@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f230626-2738-41cc-875d-ab1a7ef19f64@intel.com>

On Thu, Mar 07, 2024 at 11:49:11AM +1300, Huang, Kai wrote:
> 
> 
> On 7/03/2024 11:43 am, Sean Christopherson wrote:
> > On Thu, Mar 07, 2024, Kai Huang wrote:
> > > 
> > > 
> > > On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> > > > Explicitly detect and disallow private accesses to emulated MMIO in
> > > > kvm_handle_noslot_fault() instead of relying on kvm_faultin_pfn_private()
> > > > to perform the check.  This will allow the page fault path to go straight
> > > > to kvm_handle_noslot_fault() without bouncing through __kvm_faultin_pfn().
> > > > 
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >    arch/x86/kvm/mmu/mmu.c | 5 +++++
> > > >    1 file changed, 5 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 5c8caab64ba2..ebdb3fcce3dc 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -3314,6 +3314,11 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
> > > >    {
> > > >    	gva_t gva = fault->is_tdp ? 0 : fault->addr;
> > > > +	if (fault->is_private) {
> > > > +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > > > +		return -EFAULT;
> > > > +	}
> > > > +
> > > 
> > > As mentioned in another reply in this series, unless I am mistaken, for TDX
> > > guest the _first_ MMIO access would still cause EPT violation with MMIO GFN
> > > being private.
> > > 
> > > Returning to userspace cannot really help here because the MMIO mapping is
> > > inside the guest.
> > 
> > That's a guest bug.  The guest *knows* it's a TDX VM, it *has* to know.  Accessing
> > emulated MMIO and thus taking a #VE before enabling paging is nonsensical.  Either
> > enable paging and setup MMIO regions as shared, or go straight to TDCALL.
> 
> +Kirill,
> 
> I kinda forgot the detail, but what I am afraid is there might be bunch of
> existing TDX guests (since TDX guest code is upstream-ed) using unmodified
> drivers, which doesn't map MMIO regions as shared I suppose.

Unmodified drivers gets their MMIO regions mapped with ioremap() that sets
shared bit, unless asked explicitly to make it private (encrypted).

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

