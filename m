Return-Path: <kvm+bounces-11598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62570878B03
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 23:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF5F71F21A8C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 22:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B0C58AD1;
	Mon, 11 Mar 2024 22:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CsQiYdIz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAAD58229;
	Mon, 11 Mar 2024 22:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710197841; cv=none; b=p6S4PHl2HcQKxaYAqkc1UAhWT716nrdVTeJuu6Zu9Gg9SZfoQH2LZ2Dp5DHMlCK5LUh0Qo2ZYPSoiUdP6Jlap8HVukcGPte71jAA9mXoLhpHLsyaiLDkmRXi3wH6c6z/vvRKUdON/tSVy692ITAj4rel/sWmGuwti/eEJqI8G0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710197841; c=relaxed/simple;
	bh=At91YnFA+zD7WzNl/tKfPuU3u/VczJAEILP0HPgM8GQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAiMX367iOVZxzJjqgom7/ssFnqYDsl5x5jJ5LZEG2sAWG1jrl18gjqmZ7M7LhZ1t0PvTCoK20JiZa2sYDya/jwvEUlD5yRSmvIRAnoz+TBKF5G86G8hW8P/y1CbvSGqUUPmkHsN+g5TJWWzdeWjcMX5jKsK3sLNG66Z05hY7fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CsQiYdIz; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710197840; x=1741733840;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=At91YnFA+zD7WzNl/tKfPuU3u/VczJAEILP0HPgM8GQ=;
  b=CsQiYdIzW9OTftrIkmWw/vnq/KGBdX6UymTHkYrmiHgLPKLcQBk5WhZA
   14aphPCQ6cWob1K/mb01G63CHyZeLzXsl0iWlAn8BDdPFhz84b6etGHY4
   eXebC3AjGsRPs/BLUA6d/NOBxTJmlO6JrbSeqTVrpZieoFMB9sEfQ5uuQ
   QJfDhT4ESoPoXP5zdU2C4h0k7q2BJdR4J4ULCSA8+Nfx6dH1fVTEjrP2b
   Pc3Eqd0YVwrO6nfJ4tQlSutbqYvTG36T3FNUNJn0I45YlBCBck6nIc1ks
   RY4VC3iEKAaVVa9esQDe1CdVuZL0oWatvS36Ll1isghhKRLJUd1KVLqNH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="27362116"
X-IronPort-AV: E=Sophos;i="6.07,117,1708416000"; 
   d="scan'208";a="27362116"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 15:57:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,117,1708416000"; 
   d="scan'208";a="11388636"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 15:57:18 -0700
Date: Mon, 11 Mar 2024 15:57:18 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 5/8] KVM: x86/mmu: Introduce kvm_mmu_map_page() for
 prepopulating guest memory
Message-ID: <20240311225718.GC935089@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <7b7dd4d56249028aa0b84d439ffdf1b79e67322a.1709288671.git.isaku.yamahata@intel.com>
 <Ze8_XfMN_mZBabKP@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ze8_XfMN_mZBabKP@google.com>

On Mon, Mar 11, 2024 at 10:29:01AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Mar 01, 2024, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Introduce a helper function to call kvm fault handler.  This allows
> > a new ioctl to invoke kvm fault handler to populate without seeing
> > RET_PF_* enums or other KVM MMU internal definitions.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu.h     |  3 +++
> >  arch/x86/kvm/mmu/mmu.c | 30 ++++++++++++++++++++++++++++++
> >  2 files changed, 33 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 60f21bb4c27b..48870c5e08ec 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -183,6 +183,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> >  	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
> >  }
> >  
> > +int kvm_mmu_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> > +		     u8 max_level, u8 *goal_level);
> > +
> >  /*
> >   * Check if a given access (described through the I/D, W/R and U/S bits of a
> >   * page fault error code pfec) causes a permission fault with the given PTE
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e4cc7f764980..7d5e80d17977 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4659,6 +4659,36 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  	return direct_page_fault(vcpu, fault);
> >  }
> >  
> > +int kvm_mmu_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> > +		     u8 max_level, u8 *goal_level)
> > +{
> > +	struct kvm_page_fault fault = KVM_PAGE_FAULT_INIT(vcpu, gpa, error_code,
> > +							  false, max_level);
> > +	int r;
> > +
> > +	r = __kvm_mmu_do_page_fault(vcpu, &fault);
> > +
> > +	if (is_error_noslot_pfn(fault.pfn) || vcpu->kvm->vm_bugged)
> > +		return -EFAULT;
> 
> This clobbers a non-zero 'r'.  And KVM return -EIO if the VM is bugged/dead, not
> -EFAULT.  I also don't see why KVM needs to explicitly check is_error_noslot_pfn(),
> that should be funneled to RET_PF_EMULATE.

I'll drop this check.

> > +
> > +	switch (r) {
> > +	case RET_PF_RETRY:
> > +		return -EAGAIN;
> > +
> > +	case RET_PF_FIXED:
> > +	case RET_PF_SPURIOUS:
> > +		*goal_level = fault.goal_level;
> > +		return 0;
> > +
> > +	case RET_PF_CONTINUE:
> > +	case RET_PF_EMULATE:
> 
> -EINVAL woud be more appropriate for RET_PF_EMULATE.
> 
> > +	case RET_PF_INVALID:
> 
> CONTINUE and INVALID should be WARN conditions.

Will update them.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

