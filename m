Return-Path: <kvm+bounces-15358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AED8AB509
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 20:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9715C281FA1
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD7B13C3F2;
	Fri, 19 Apr 2024 18:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jF3Igy20"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74901137C32;
	Fri, 19 Apr 2024 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713551178; cv=none; b=PxSOSn3kFjEA4FCeS6ocw0zayizeOV+sJFka3A9PjxWPBgyvcMvOO0+RgF69mdg2S1lCcXkL+FPyXzj4kovoIQfVvRIP8abDhhaoAGShksuC5xqw97x+9kpSliK43+DjcyjcGgOOu2jEA6aTQGc9cSpbGw2E5NG/5dYYyCk1zvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713551178; c=relaxed/simple;
	bh=FcmgegUL0KYISrNVi5jFjXyRdn4R5c69I7t4CMevUMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YsrAt1gimkqIGKQq8FPZ2OJSpBx1qmMQ/b+nWPJl5EEsJy9xeb/rWdinquSjUMEZ3pqND1Dn0AqnrVyVj2gq1b7G/uczsrMJp0HjKO3su47Xomxx/IZHd6UDGGmLi4aWzAHv+fWB5p8hrRKQu8Mg8MGFum7tRT81mQhNPIq5bFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jF3Igy20; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713551176; x=1745087176;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FcmgegUL0KYISrNVi5jFjXyRdn4R5c69I7t4CMevUMg=;
  b=jF3Igy20rK9jQWvuDRSCehJCqWhDmrz6KMNh0uVa4B+r/atvCFmdbKL5
   3stUrXbN5K3dxgix11gngHLTHcecyH2FEXyk5k7KQCd1e0uy/s6jp6UPF
   YiLml+xJYit59Mi2CoLEOELspu0GT+ell494MJrxSdJ/839/115EDmqgO
   /ZNVCzA23cogOq33CVz0wSHbWzM57j2jcYh6FCOvdOhioNBsfeGz6+mti
   oEIYgxv0Cs/NsuFY4P2Ncv1WBGyziTFqLqoan5PvKk67gdx+6qY92rIB/
   MPVRY7wCfaUnk3CJKmz60laxzcuBCLmFtEG+Ki4A04wJfIlNVNOGMRwu2
   Q==;
X-CSE-ConnectionGUID: e6o0rx2jSEmeDC6BoTM6zw==
X-CSE-MsgGUID: 68/s4jOASQ2M3nIhAZSO9A==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="9289011"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="9289011"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:26:16 -0700
X-CSE-ConnectionGUID: kXBs05T+T+GC/MSIHYuqOA==
X-CSE-MsgGUID: Hh88V84MTNWo9xl64ooMFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="28054243"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:26:15 -0700
Date: Fri, 19 Apr 2024 11:26:15 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, seanjc@google.com, isaku.yamahata@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 11/11] KVM: x86: Add gmem hook for determining max NPT
 mapping level
Message-ID: <20240419182615.GH3596705@ls.amr.corp.intel.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
 <20240404185034.3184582-12-pbonzini@redhat.com>
 <20240409234632.fb5mly7mkgvzbtqo@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240409234632.fb5mly7mkgvzbtqo@amd.com>

On Tue, Apr 09, 2024 at 06:46:32PM -0500,
Michael Roth <michael.roth@amd.com> wrote:

> On Thu, Apr 04, 2024 at 02:50:33PM -0400, Paolo Bonzini wrote:
> > From: Michael Roth <michael.roth@amd.com>
> > 
> > In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
> > 2MB mapping in the guest's nested page table depends on whether or not
> > any subpages within the range have already been initialized as private
> > in the RMP table. The existing mixed-attribute tracking in KVM is
> > insufficient here, for instance:
> > 
> >   - gmem allocates 2MB page
> >   - guest issues PVALIDATE on 2MB page
> >   - guest later converts a subpage to shared
> >   - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
> >   - KVM MMU splits NPT mapping to 4K
> 
> Binbin caught that I'd neglected to document the last step in the
> theoretical sequence here. It should state something to the effect
> of:
> 
>   - guest later converts that shared page back to private
> 
> -Mike
> 
> > 
> > At this point there are no mixed attributes, and KVM would normally
> > allow for 2MB NPT mappings again, but this is actually not allowed
> > because the RMP table mappings are 4K and cannot be promoted on the
> > hypervisor side, so the NPT mappings must still be limited to 4K to
> > match this.
> > 
> > Add a hook to determine the max NPT mapping size in situations like
> > this.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > Message-Id: <20231230172351.574091-31-michael.roth@amd.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h | 1 +
> >  arch/x86/include/asm/kvm_host.h    | 2 ++
> >  arch/x86/kvm/mmu/mmu.c             | 8 ++++++++
> >  3 files changed, 11 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index c81990937ab4..2db87a6fd52a 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -140,6 +140,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> >  KVM_X86_OP_OPTIONAL(get_untagged_addr)
> >  KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
> >  KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
> > +KVM_X86_OP_OPTIONAL_RET0(gmem_validate_fault)
> >  KVM_X86_OP_OPTIONAL(gmem_invalidate)
> >  
> >  #undef KVM_X86_OP
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 59c7b95034fc..67dc108dd366 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1811,6 +1811,8 @@ struct kvm_x86_ops {
> >  	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
> >  	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
> >  	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> > +	int (*gmem_validate_fault)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
> > +				   u8 *max_level);
> >  };

I think you added is_private due to the TDX patches.  As Yan pointed out at
https://lore.kernel.org/kvm/ZiHGoUUcGlZObQvx@yzhao56-desk.sh.intel.com/

It's guaranteed that is_private is always true because the caller check it.

  if (fault->is_private)
    kvm_faultin_pfn_private()

So we can drop is_private parameter.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

