Return-Path: <kvm+bounces-12715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D539988CB88
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 19:06:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62E111F82E2A
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 18:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF716FE1A;
	Tue, 26 Mar 2024 18:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iM8JsJWJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A0D127B43;
	Tue, 26 Mar 2024 18:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476370; cv=none; b=uV59Ijr8NjZEamNi4Ehs7S/xPU7gOLV5XEewxgf+4tpdOUXkHHX8fcS2Os7fPoV4v5TtSO/YZQjWKiUujM12W9nluhR+TCUTA13If+3/etjqOHvKg/nTTBaOlvHkzOSuAxA/Td5pOq+YvU54AUIU6lhZ89P4y1XlPxJphAsrQD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476370; c=relaxed/simple;
	bh=Gk8fI9iUrOUGQ34gEWUgllLORmfKWRcrBsMtW1W/wiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgiuXpCNjHEuPLhHGsKloN8h//qhlvtNjCByohoN/wRMV3DB//lio/1i9ixfyWSdP6ZONhYcWzUfn4vq12tJ3HWuJJdHtrkJcH/ChIzqkD6TwF3GWo9vXBdtQ/UzKSQAwMbnuiCQsGyMraJaQ2mn/j7bZ6s6k193RAlQgFGOGEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iM8JsJWJ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711476367; x=1743012367;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Gk8fI9iUrOUGQ34gEWUgllLORmfKWRcrBsMtW1W/wiw=;
  b=iM8JsJWJ3SEBhFsdOL6NMy/FWO9TGj3g/UxqPa++BjABa6K22HBgWR31
   ym05mROOBBmFFMd841C+nifesnZoRr87N5u/W+B/HAk/42SkD/0OZwDHQ
   yfpsOD/89vVBh1Uxk4u/X/iBVtf8km4jIK63+CAFXzLp4/CAP6TbWhWf7
   nowa4CWMxDl2x0kYe88tdzhAFyXAj3QZmT7LglHYQPYe++YyIJs1WvSlk
   Oz3ingKaGHzAqiARmLvChKLYrar+r8coXb6uM/e8sbyouDpLyPOCA1qJn
   kDiDqNZ8UatvsWMfWTA6lacXdU3ylwAaOk3YXPNWnLZHMxI0qcLDXLQ2e
   g==;
X-CSE-ConnectionGUID: +OdF6dRDTv652QICOYGp5A==
X-CSE-MsgGUID: x5iLw7TrRFi2qzaQkm7aYQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="17931530"
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="17931530"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 11:06:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="20744583"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 11:06:06 -0700
Date: Tue, 26 Mar 2024 11:06:05 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <20240326180605.GC2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
 <7b76900a42b4044cbbcb0c42922c935562993d1e.camel@intel.com>
 <20240325200122.GH2357401@ls.amr.corp.intel.com>
 <ad203761cf0f93e9feb4ea7037c9b9c1f39714ae.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad203761cf0f93e9feb4ea7037c9b9c1f39714ae.camel@intel.com>

On Mon, Mar 25, 2024 at 10:31:49PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-03-25 at 13:01 -0700, Isaku Yamahata wrote:
> >  Also, kvm_tdp_mmu_alloc_root() never returns non-zero, even though mmu_alloc_direct_roots() does.
> > > Probably today when there is one caller it makes mmu_alloc_direct_roots() cleaner to just have
> > > it
> > > return the always zero value from kvm_tdp_mmu_alloc_root(). Now that there are two calls, I
> > > think we
> > > should refactor kvm_tdp_mmu_alloc_root() to return void, and have kvm_tdp_mmu_alloc_root()
> > > return 0
> > > manually in this case.
> > > 
> > > Or maybe instead change it back to returning an hpa_t and then kvm_tdp_mmu_alloc_root() can lose
> > > the
> > > "if (private)" logic at the end too.
> > 
> > Probably we can make void kvm_tdp_mmu_alloc_root() instead of returning always
> > zero as clean up.
> 
> Why is it better than returning an hpa_t once we are calling it twice for mirror and shared roots.

You mean split out "if (private)" from the core part? Makes sense.


> > > >         } else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> > > >                 root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
> > > > @@ -4627,7 +4632,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault
> > > > *fault)
> > > >         if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
> > > >                 for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
> > > >                         int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
> > > > -                       gfn_t base = gfn_round_for_level(fault->gfn,
> > > > +                       gfn_t base = gfn_round_for_level(gpa_to_gfn(fault->addr),
> > > >                                                          fault->max_level);
> > > >  
> > > >                         if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
> > > > @@ -4662,6 +4667,7 @@ int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64
> > > > error_code,
> > > >         };
> > > >  
> > > >         WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
> > > > +       fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
> > > >         fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> > > >  
> > > >         r = mmu_topup_memory_caches(vcpu, false);
> > > > @@ -6166,6 +6172,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> > > >  
> > > >         mmu->root.hpa = INVALID_PAGE;
> > > >         mmu->root.pgd = 0;
> > > > +       mmu->private_root_hpa = INVALID_PAGE;
> > > >         for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> > > >                 mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> > > >  
> > > > @@ -7211,6 +7218,12 @@ int kvm_mmu_vendor_module_init(void)
> > > >  void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
> > > >  {
> > > >         kvm_mmu_unload(vcpu);
> > > > +       if (tdp_mmu_enabled) {
> > > > +               write_lock(&vcpu->kvm->mmu_lock);
> > > > +               mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
> > > > +                               NULL);
> > > > +               write_unlock(&vcpu->kvm->mmu_lock);
> > > 
> > > What is the reason for the special treatment of private_root_hpa here? The rest of the roots are
> > > freed in kvm_mmu_unload(). I think it is because we don't want the mirror to get freed during
> > > kvm_mmu_reset_context()?
> > 
> > It reflects that we don't free Secure-EPT pages during runtime, and free them
> > when destroying the guest.
> 
> Right. If would be great if we could do something like warn on freeing role.private = 1 sp's during
> runtime. It could cover several cases that get worried about in other patches.

Ok, let me move it to kvm_mmu_unload() and try to sprinkle warn-on.


> While looking at how we could do this, I noticed that kvm_arch_vcpu_create() calls kvm_mmu_destroy()
> in an error path. So this could end up zapping/freeing a private root. It should be bad userspace
> behavior too I guess. But the number of edge cases makes me think the case of zapping private sp
> while a guest is running is something that deserves a VM_BUG_ON().

Let me clean the code.  I think we can clean them up.


> > > Oof. For the sake of trying to justify the code, I'm trying to keep track of the pros and cons
> > > of
> > > treating the mirror/private root like a normal one with just a different role bit.
> > > 
> > > The whole “list of roots” thing seems to date from the shadow paging, where there is is critical
> > > to
> > > keep multiple cached shared roots of different CPU modes of the same shadowed page tables. Today
> > > with non-nested TDP, AFAICT, the only different root is for SMM. I guess since the machinery for
> > > managing multiple roots in a list already exists it makes sense to use it for both.
> > > 
> > > For TDX there are also only two, but the difference is, things need to be done in special ways
> > > for
> > > the two roots. You end up with a bunch of loops (for_each_*tdp_mmu_root(), etc) that essentially
> > > process a list of two different roots, but with inner logic tortured to work for the
> > > peculiarities
> > > of both private and shared. An easier to read alternative could be to open code both cases.
> > > 
> > > I guess the major benefit is to keep one set of logic for shadow paging, normal TDP and TDX, but
> > > it
> > > makes the logic a bit difficult to follow for TDX compared to looking at it from the normal
> > > guest
> > > perspective. So I wonder if making special versions of the TDX root traversing operations might
> > > make
> > > the code a little easier to follow. I’m not advocating for it at this point, just still working
> > > on
> > > an opinion. Is there any history around this design point?
> > 
> > The original desire to keep the modification contained, and not introduce a
> > function for population and zap.  With the open coding, do you want something
> > like the followings?  We can try it and compare the outcome.
> > 
> > For zapping
> >   if (private) {
> >      __for_each_tdp_mmu_root_yield_safe_private()
> >        private case
> >   } else {
> >      __for_each_tdp_mmu_root_yield_safe()
> >         shared case
> >   }
> > 
> > For fault,
> > kvm_tdp_mmu_map()
> >   if (private) {
> >     tdp_mmu_for_each_pte_private(iter, mmu, raw_gfn, raw_gfn + 1)
> >       private case
> >   } else {
> >     tdp_mmu_for_each_pte_private(iter, mmu, raw_gfn, raw_gfn + 1)
> >       shared case
> >   }
> 
> I was wondering about something limited to the operations that iterate over the roots. So not
> keeping private_root_hpa in the list of roots where it has to be carefully protected from getting
> zapped or get its gfn adjusted, and instead open coding the private case in the higher level zapping
> operations. For normal VM's the private case would be a NOP.
> 
> Since kvm_tdp_mmu_map() already grabs private_root_hpa manually, it wouldn't change in this idea. I
> don't know how much better it would be though. I think you are right we would have to create them
> and compare. 

Given the large page support gets complicated, it would be worthwhile to try,
I think.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

