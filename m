Return-Path: <kvm+bounces-11206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C368742A1
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85AD51F25877
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C0C1BDDB;
	Wed,  6 Mar 2024 22:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UsGKdnS5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62C01BC2A;
	Wed,  6 Mar 2024 22:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709763758; cv=none; b=mo/FCPU1P+2yeP86erNuPVnDIm21zzJqyrm3+T6ysdhfCvOK8H8pQhvOSV2jgxOGrp2BJUELnfQbmPWNi2Qi6/MUJ9MxtK9VyfhHkNRGD/0ecxIRDxskkoGB+EFEvXWY51mY+72dcEFvkof0LjLXPZfanOUjhON11R7fDi0oZ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709763758; c=relaxed/simple;
	bh=gSMvrjqg6OWr7a6MSmXKqgtJStuHqg4PqNfDg92nbTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a55tKWGfuIIUMHlp/vfU/mRJj6D7xtP6xUJZnnkqO/XmLIMQoj5DMpCCi4a0y8nc1i3PdAGnA54KMfsa/q8Wrm+2AjjjzODFGkbBM3cTKLkoicpm1Z1YlnvmAmrq8aoWkw/XSWvt5F0n2C52/QEYXDdQb3uibEzNGsNrGt5zcSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UsGKdnS5; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709763756; x=1741299756;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gSMvrjqg6OWr7a6MSmXKqgtJStuHqg4PqNfDg92nbTA=;
  b=UsGKdnS5Ncf4c7SyhF+9YOHfEmmMZQug76OUKfZiJIUZYVMCXmldiV8c
   Mn35xXN504bpfE5fhGeFRPUIRMACk/F6iJ718NGzEsPvz8W/ZJ70tDreo
   Fh3izXBHLuH5X+c39GI2KwUZHiW96ZzuRQ8zji034YJX5r2OI42sSCehy
   /ADYCLPo7MephQovnZTSikBUGBAujdI12oMkjnR2SpBTCGvQ15Xrmp2a3
   xyVZFaJKeeuinGTqyq6YDdm5BUhlC8b+tgIQzbELBriQsy6XwL0dXuImz
   2f1agSftTfMs3MrePwsEQp29XKvAwe2dSKMTEvDDJBeEdz1WM9QWgM6CL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="14980539"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="14980539"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 14:22:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9798692"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 14:22:34 -0800
Date: Wed, 6 Mar 2024 14:22:34 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 016/130] KVM: x86/mmu: Introduce
 kvm_mmu_map_tdp_page() for use by TDX
Message-ID: <20240306222234.GC368614@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b2b7eeb1bab4cbf5421bf18647357a59b472dabe.1708933498.git.isaku.yamahata@intel.com>
 <4555c300-5934-4563-a639-3e43d2ce405f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4555c300-5934-4563-a639-3e43d2ce405f@linux.intel.com>

On Wed, Mar 06, 2024 at 03:13:22PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Introduce a helper to directly (pun intended) fault-in a TDP page
> > without having to go through the full page fault path.  This allows
> > TDX to get the resulting pfn and also allows the RET_PF_* enums to
> > stay in mmu.c where they belong.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> > v19:
> > - Move up for KVM_MEMORY_MAPPING.
> > - Add goal_level for the caller to know how many pages are mapped.
> > 
> > v14 -> v15:
> > - Remove loop in kvm_mmu_map_tdp_page() and return error code based on
> >    RET_FP_xxx value to avoid potential infinite loop.  The caller should
> >    loop on -EAGAIN instead now.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/mmu.h     |  3 +++
> >   arch/x86/kvm/mmu/mmu.c | 58 ++++++++++++++++++++++++++++++++++++++++++
> >   2 files changed, 61 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 60f21bb4c27b..d96c93a25b3b 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -183,6 +183,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> >   	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
> >   }
> > +int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> > +			 u8 max_level, u8 *goal_level);
> > +
> >   /*
> >    * Check if a given access (described through the I/D, W/R and U/S bits of a
> >    * page fault error code pfec) causes a permission fault with the given PTE
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 61674d6b17aa..ca0c91f14063 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4615,6 +4615,64 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   	return direct_page_fault(vcpu, fault);
> >   }
> > +int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> > +			 u8 max_level, u8 *goal_level)
> > +{
> > +	int r;
> > +	struct kvm_page_fault fault = (struct kvm_page_fault) {
> > +		.addr = gpa,
> > +		.error_code = error_code,
> > +		.exec = error_code & PFERR_FETCH_MASK,
> > +		.write = error_code & PFERR_WRITE_MASK,
> > +		.present = error_code & PFERR_PRESENT_MASK,
> > +		.rsvd = error_code & PFERR_RSVD_MASK,
> > +		.user = error_code & PFERR_USER_MASK,
> > +		.prefetch = false,
> > +		.is_tdp = true,
> > +		.is_private = error_code & PFERR_GUEST_ENC_MASK,
> > +		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
> > +	};
> > +
> > +	WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
> > +	fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> > +
> > +	r = mmu_topup_memory_caches(vcpu, false);
> 
> Does it need a cache topup here?
> Both kvm_tdp_mmu_page_fault() and direct_page_fault() will call
> mmu_topup_memory_caches() when needed.

You're right. As the called function has changed, I missed to remove it.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

