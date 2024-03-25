Return-Path: <kvm+bounces-12614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 458FA88B0B6
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF7C1295583
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 20:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D913F3FBA0;
	Mon, 25 Mar 2024 20:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L7ilTwVD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1C7224FB;
	Mon, 25 Mar 2024 20:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711396886; cv=none; b=jOBLCcbRVcltwr7645tKi0rJ9DstfNPuqJJZXw62U11J1dYhL3g+yPBWlNgqKVz79G6AJW+tH6gXTVHaRzPkdx9tVmixLCDuflCnV8NWBwYsXvd5fbfhR9M0JSazUw+e96tDTjJMLKloSs7lmhzIzpRH6t0n6az0jRpKm3EsqHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711396886; c=relaxed/simple;
	bh=PzK6PkwyR4PuLMrgS8c3IKNuEVta0emqQ29NV/exg8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oUQ2sV4j3JFCCE7qHTe6dvJ84mZJcHtbw8rIdKTYYZDcNUespDnco/7RcSuKllhd9d58a1XL4i09Ty4UAnUFJZwGL1F8gcmg8NjLky9uCJrD5KyuJFzL01arZ/7avTSKXfhNoDPFoWduSc+8rR17ICSX/vUHXFpAbkQmYs3BniU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L7ilTwVD; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711396884; x=1742932884;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=PzK6PkwyR4PuLMrgS8c3IKNuEVta0emqQ29NV/exg8o=;
  b=L7ilTwVDX4BwWxU+832zX7bipRnRTjxMryb01g7sNeTNe0jTcdQtmVjS
   RkJm49y0qFxkvrHsNn1T0g/+XGn07eui1OXNODz2O3UzqDkUrslh5zQx6
   H/6eLz6HtNBIRNRKoXnoMlblhR0dKm1XKbDJ+rrklZVNgDU/HjCPEmMdl
   TS0wanL7E+sG26vCv+PcK2f9eJtBDEfykJ4YJocauIgkM14XtOk9QTV8M
   6JL2NzF0dhNdbVoeH5OqYkx9IJc8Ank7TMfUFGmk7wlLHRSky8B/Ujrsr
   CLZCPB+VvTHZlztYp3OX8etcGcvWzi8LxwvzsVY6Ezun7DWUntAZBbp+S
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="7017540"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="7017540"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 13:01:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="38843069"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 13:01:22 -0700
Date: Mon, 25 Mar 2024 13:01:22 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <20240325200122.GH2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
 <7b76900a42b4044cbbcb0c42922c935562993d1e.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b76900a42b4044cbbcb0c42922c935562993d1e.camel@intel.com>

On Sat, Mar 23, 2024 at 11:39:07PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:26 -0800, isaku.yamahata@intel.com wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index efd3fda1c177..bc0767c884f7 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -468,6 +468,7 @@ struct kvm_mmu {
> >         int (*sync_spte)(struct kvm_vcpu *vcpu,
> >                          struct kvm_mmu_page *sp, int i);
> >         struct kvm_mmu_root_info root;
> > +       hpa_t private_root_hpa;
> 
> Per the conversation about consistent naming between private, shared and mirror: I wonder if this
> should be named these with mirror instead of private. Like:
>   hpa_t mirror_root_hpa;
> 
> Since the actual private root is not tracked by KVM.

It's  mirrored only without direct associated Secure EPT page.  The association
is implicit, a part of TDCS pages.


> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 30c86e858ae4..0e0321ad9ca2 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3717,7 +3717,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >                 goto out_unlock;
> >  
> >         if (tdp_mmu_enabled) {
> > -               root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > +               if (kvm_gfn_shared_mask(vcpu->kvm) &&
> > +                   !VALID_PAGE(mmu->private_root_hpa)) {
> > +                       root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
> > +                       mmu->private_root_hpa = root;
> > +               }
> > +               root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
> >                 mmu->root.hpa = root;
> 
> This has changed now, due to rebase on,
> https://lore.kernel.org/lkml/20240111020048.844847-1-seanjc@google.com/
> 
> ...to this:
> -       if (tdp_mmu_enabled)
> -               return kvm_tdp_mmu_alloc_root(vcpu);
> +       if (tdp_mmu_enabled) {
> +               if (kvm_gfn_shared_mask(vcpu->kvm) &&
> +                   !VALID_PAGE(mmu->private_root_hpa)) {
> +                       r = kvm_tdp_mmu_alloc_root(vcpu, true);
> +                       if (r)
> +                               return r;
> +               }
> +               return kvm_tdp_mmu_alloc_root(vcpu, false);
> +       }
> 
> I don't see why the !VALID_PAGE(mmu->private_root_hpa) check is needed.
> kvm_tdp_mmu_get_vcpu_root_hpa() already has logic to prevent allocating multiple roots with the same
> role.

Historically we needed it.  We don't need it now. We can drop it.


> Also, kvm_tdp_mmu_alloc_root() never returns non-zero, even though mmu_alloc_direct_roots() does.
> Probably today when there is one caller it makes mmu_alloc_direct_roots() cleaner to just have it
> return the always zero value from kvm_tdp_mmu_alloc_root(). Now that there are two calls, I think we
> should refactor kvm_tdp_mmu_alloc_root() to return void, and have kvm_tdp_mmu_alloc_root() return 0
> manually in this case.
> 
> Or maybe instead change it back to returning an hpa_t and then kvm_tdp_mmu_alloc_root() can lose the
> "if (private)" logic at the end too.

Probably we can make void kvm_tdp_mmu_alloc_root() instead of returning always
zero as clean up.


> >         } else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> >                 root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
> > @@ -4627,7 +4632,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >         if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
> >                 for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
> >                         int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
> > -                       gfn_t base = gfn_round_for_level(fault->gfn,
> > +                       gfn_t base = gfn_round_for_level(gpa_to_gfn(fault->addr),
> >                                                          fault->max_level);
> >  
> >                         if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
> > @@ -4662,6 +4667,7 @@ int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> >         };
> >  
> >         WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
> > +       fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
> >         fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> >  
> >         r = mmu_topup_memory_caches(vcpu, false);
> > @@ -6166,6 +6172,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> >  
> >         mmu->root.hpa = INVALID_PAGE;
> >         mmu->root.pgd = 0;
> > +       mmu->private_root_hpa = INVALID_PAGE;
> >         for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> >                 mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> >  
> > @@ -7211,6 +7218,12 @@ int kvm_mmu_vendor_module_init(void)
> >  void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
> >  {
> >         kvm_mmu_unload(vcpu);
> > +       if (tdp_mmu_enabled) {
> > +               write_lock(&vcpu->kvm->mmu_lock);
> > +               mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
> > +                               NULL);
> > +               write_unlock(&vcpu->kvm->mmu_lock);
> 
> What is the reason for the special treatment of private_root_hpa here? The rest of the roots are
> freed in kvm_mmu_unload(). I think it is because we don't want the mirror to get freed during
> kvm_mmu_reset_context()?

It reflects that we don't free Secure-EPT pages during runtime, and free them
when destroying the guest.


> 
> Oof. For the sake of trying to justify the code, I'm trying to keep track of the pros and cons of
> treating the mirror/private root like a normal one with just a different role bit.
> 
> The whole “list of roots” thing seems to date from the shadow paging, where there is is critical to
> keep multiple cached shared roots of different CPU modes of the same shadowed page tables. Today
> with non-nested TDP, AFAICT, the only different root is for SMM. I guess since the machinery for
> managing multiple roots in a list already exists it makes sense to use it for both.
> 
> For TDX there are also only two, but the difference is, things need to be done in special ways for
> the two roots. You end up with a bunch of loops (for_each_*tdp_mmu_root(), etc) that essentially
> process a list of two different roots, but with inner logic tortured to work for the peculiarities
> of both private and shared. An easier to read alternative could be to open code both cases.
> 
> I guess the major benefit is to keep one set of logic for shadow paging, normal TDP and TDX, but it
> makes the logic a bit difficult to follow for TDX compared to looking at it from the normal guest
> perspective. So I wonder if making special versions of the TDX root traversing operations might make
> the code a little easier to follow. I’m not advocating for it at this point, just still working on
> an opinion. Is there any history around this design point?

The original desire to keep the modification contained, and not introduce a
function for population and zap.  With the open coding, do you want something
like the followings?  We can try it and compare the outcome.

For zapping
  if (private) {
     __for_each_tdp_mmu_root_yield_safe_private()
       private case
  } else {
     __for_each_tdp_mmu_root_yield_safe()
        shared case
  }

For fault,
kvm_tdp_mmu_map()
  if (private) {
    tdp_mmu_for_each_pte_private(iter, mmu, raw_gfn, raw_gfn + 1)
      private case
  } else {
    tdp_mmu_for_each_pte_private(iter, mmu, raw_gfn, raw_gfn + 1)
      shared case
  }

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

