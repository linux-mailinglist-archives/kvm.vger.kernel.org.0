Return-Path: <kvm+bounces-12192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EC20880850
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:57:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DD6A1F22B8E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 23:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4905FBB3;
	Tue, 19 Mar 2024 23:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YdbXE44Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5173FBAF;
	Tue, 19 Mar 2024 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710892619; cv=none; b=SlLg02jBD8L1Qu4O0TmI6cU1FL/ZtFEiR5rXhvd0lRDjbXAfnCRaYJ73LOGt9aSF7p9ySoQL9sqVEdmeYhrSRYCnTXMFEcP1D4LdM31RRp8UTPjQ7Q+xHsHPM/7jVLJIqlQYM/7zpQM9hbx9eWciAXo7+bBRRic8brJmkfZMdTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710892619; c=relaxed/simple;
	bh=xAQ54bb5DATBkchqYBlDNiISG+vhHK0QxIY50S0dNOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VsFh6zZJqXoHOxwdfRhWtCrwIFNQxZBPj/CZNgrEYaGYLIzXw3CK6oXooWLFArk1ye6LSYzE6or97eV8m5M0XmcHeb6sbJjSHMLPuiM+V29iOBWfl2s0GzR+uADIS8pQjfrY4FuD9LG66xFeP055UqD1+ZpJtpVQ7PTqilHck8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YdbXE44Q; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710892616; x=1742428616;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xAQ54bb5DATBkchqYBlDNiISG+vhHK0QxIY50S0dNOo=;
  b=YdbXE44QBEax67bfJbGvAfNTloypIrIZEE2BeHv2nmYWZmgR5OrFt2my
   Aim6/9ss2G5QJfKq9mnC8t9nAJSeV/treAPwXxYXsbpLI4uIpHIfZWx3S
   RuWnx2eAmfwnGD7pEL8EJyNwxL1hmz0u+rww6fF8JnK1G1gXIbvbJA35m
   2XQ1BDuH5dTCUFwQ4fN/23zlgqlZeg1YGsEGTMQwyrknZQqRyvuGQHQ5f
   Oo5pDuDvp9mfgySHxSUJbeQZASQ2Wri7BE/AUgx7A2KoHZstj/KZIVbRE
   MDgRJzf9FK02iUkEDqNGHq5j3BO+0xIKlN5DHwCSNJvToK5XoWXD6QZjS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="5971856"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="5971856"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 16:56:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="18697127"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 16:56:55 -0700
Date: Tue, 19 Mar 2024 16:56:54 -0700
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
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240319235654.GC1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>

On Mon, Mar 18, 2024 at 11:46:11PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:26 -0800, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > TDX supports only write-back(WB) memory type for private memory
> > architecturally so that (virtualized) memory type change doesn't make
> > sense
> > for private memory.  Also currently, page migration isn't supported
> > for TDX
> > yet. (TDX architecturally supports page migration. it's KVM and
> > kernel
> > implementation issue.)
> > 
> > Regarding memory type change (mtrr virtualization and lapic page
> > mapping
> > change), pages are zapped by kvm_zap_gfn_range().  On the next KVM
> > page
> > fault, the SPTE entry with a new memory type for the page is
> > populated.
> > Regarding page migration, pages are zapped by the mmu notifier. On
> > the next
> > KVM page fault, the new migrated page is populated.  Don't zap
> > private
> > pages on unmapping for those two cases.
> 
> Is the migration case relevant to TDX?

We can forget about it because the page migration isn't supported yet.


> > When deleting/moving a KVM memory slot, zap private pages. Typically
> > tearing down VM.  Don't invalidate private page tables. i.e. zap only
> > leaf
> > SPTEs for KVM mmu that has a shared bit mask. The existing
> > kvm_tdp_mmu_invalidate_all_roots() depends on role.invalid with read-
> > lock
> > of mmu_lock so that other vcpu can operate on KVM mmu concurrently. 
> > It
> > marks the root page table invalid and zaps SPTEs of the root page
> > tables. The TDX module doesn't allow to unlink a protected root page
> > table
> > from the hardware and then allocate a new one for it. i.e. replacing
> > a
> > protected root page table.  Instead, zap only leaf SPTEs for KVM mmu
> > with a
> > shared bit mask set.
> 
> I get the part about only zapping leafs and not the root and mid-level
> PTEs. But why the MTRR, lapic page and migration part? Why should those
> not be zapped? Why is migration a consideration when it is not
> supported?


When we zap a page from the guest, and add it again on TDX even with the same
GPA, the page is zeroed.  We'd like to keep memory contents for those cases.

Ok, let me add those whys and drop migration part. Here is the updated one.

TDX supports only write-back(WB) memory type for private memory
architecturally so that (virtualized) memory type change doesn't make
sense for private memory.  When we remove the private page from the guest
and re-add it with the same GPA, the page is zeroed.

Regarding memory type change (mtrr virtualization and lapic page
mapping change), the current implementation zaps pages, and populate
the page with new memory type on the next KVM page fault.  It doesn't
work for TDX to have zeroed pages. Because TDX supports only WB, we
ignore the request for MTRR and lapic page change to not zap private
pages on unmapping for those two cases

TDX Secure-EPT requires removing the guest pages first and leaf
Secure-EPT pages in order. It doesn't allow zap a Secure-EPT entry
that has child pages.  It doesn't work with the current TDP MMU
zapping logic that zaps the root page table without touching child
pages.  Instead, zap only leaf SPTEs for KVM mmu that has a shared bit
mask.

> 
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     | 61
> > ++++++++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++----
> >  arch/x86/kvm/mmu/tdp_mmu.h |  5 ++--
> >  3 files changed, 92 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 0d6d4506ec97..30c86e858ae4 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6339,7 +6339,7 @@ static void kvm_mmu_zap_all_fast(struct kvm
> > *kvm)
> >          * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock
> > and yield.
> >          */
> >         if (tdp_mmu_enabled)
> > -               kvm_tdp_mmu_invalidate_all_roots(kvm);
> > +               kvm_tdp_mmu_invalidate_all_roots(kvm, true);
> >  
> >         /*
> >          * Notify all vcpus to reload its shadow page table and flush
> > TLB.
> > @@ -6459,7 +6459,16 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t
> > gfn_start, gfn_t gfn_end)
> >         flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
> >  
> >         if (tdp_mmu_enabled)
> > -               flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start,
> > gfn_end, flush);
> > +               /*
> > +                * zap_private = false. Zap only shared pages.
> > +                *
> > +                * kvm_zap_gfn_range() is used when MTRR or PAT
> > memory
> > +                * type was changed.  Later on the next kvm page
> > fault,
> > +                * populate it with updated spte entry.
> > +                * Because only WB is supported for private pages,
> > don't
> > +                * care of private pages.
> > +                */
> > +               flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start,
> > gfn_end, flush, false);
> >  
> >         if (flush)
> >                 kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end -
> > gfn_start);
> > @@ -6905,10 +6914,56 @@ void kvm_arch_flush_shadow_all(struct kvm
> > *kvm)
> >         kvm_mmu_zap_all(kvm);
> >  }
> >  
> > +static void kvm_mmu_zap_memslot(struct kvm *kvm, struct
> > kvm_memory_slot *slot)
> 
> What about kvm_mmu_zap_memslot_leafs() instead?

Ok.


> > +{
> > +       bool flush = false;
> 
> It doesn't need to be initialized if it passes false directly into
> kvm_tdp_mmu_unmap_gfn_range(). It would make the code easier to
> understand.
> 
> > +
> > +       write_lock(&kvm->mmu_lock);
> > +
> > +       /*
> > +        * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't
> > required, worst
> > +        * case scenario we'll have unused shadow pages lying around
> > until they
> > +        * are recycled due to age or when the VM is destroyed.
> > +        */
> > +       if (tdp_mmu_enabled) {
> > +               struct kvm_gfn_range range = {
> > +                     .slot = slot,
> > +                     .start = slot->base_gfn,
> > +                     .end = slot->base_gfn + slot->npages,
> > +                     .may_block = true,
> > +
> > +                     /*
> > +                      * This handles both private gfn and shared
> > gfn.
> > +                      * All private page should be zapped on memslot
> > deletion.
> > +                      */
> > +                     .only_private = true,
> > +                     .only_shared = true,
> 
> only_private and only_shared are both true? Shouldn't they both be
> false? (or just unset)

I replied at.
https://lore.kernel.org/kvm/ZUO1Giju0GkUdF0o@google.com/

> 
> > +               };
> > +
> > +               flush = kvm_tdp_mmu_unmap_gfn_range(kvm, &range,
> > flush);
> > +       } else {
> > +               /* TDX supports only TDP-MMU case. */
> > +               WARN_ON_ONCE(1);
> 
> How about a KVM_BUG_ON() instead? If somehow this is reached, we don't
> want the caller thinking the pages are zapped, then enter the guest
> with pages mapped that have gone elsewhere.
> 
> > +               flush = true;
> 
> Why flush?

Those are only safe guard. TDX supports only TDP MMU. Let me drop them.


> > +       }
> > +       if (flush)
> > +               kvm_flush_remote_tlbs(kvm);
> > +
> > +       write_unlock(&kvm->mmu_lock);
> > +}
> > +
> >  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> >                                    struct kvm_memory_slot *slot)
> >  {
> > -       kvm_mmu_zap_all_fast(kvm);
> > +       if (kvm_gfn_shared_mask(kvm))
> 
> There seems to be an attempt to abstract away the existence of Secure-
> EPT in mmu.c, that is not fully successful. In this case the code
> checks kvm_gfn_shared_mask() to see if it needs to handle the zapping
> in a way specific needed by S-EPT. It ends up being a little confusing
> because the actual check is about whether there is a shared bit. It
> only works because only S-EPT is the only thing that has a
> kvm_gfn_shared_mask().
> 
> Doing something like (kvm->arch.vm_type == KVM_X86_TDX_VM) looks wrong,
> but is more honest about what we are getting up to here. I'm not sure
> though, what do you think?

Right, I attempted and failed in zapping case.  This is due to the restriction
that the Secure-EPT pages must be removed from the leaves.  the VMX case (also
NPT, even SNP) heavily depends on zapping root entry as optimization.

I can think of
- add TDX check. Looks wrong
- Use kvm_gfn_shared_mask(kvm). confusing
- Give other name for this check like zap_from_leafs (or better name?)
  The implementation is same to kvm_gfn_shared_mask() with comment.
  - Or we can add a boolean variable to struct kvm
  

> >  void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index d47f0daf1b03..e7514a807134 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -37,7 +37,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
> >          * for zapping and thus puts the TDP MMU's reference to each
> > root, i.e.
> >          * ultimately frees all roots.
> >          */
> > -       kvm_tdp_mmu_invalidate_all_roots(kvm);
> > +       kvm_tdp_mmu_invalidate_all_roots(kvm, false);
> >         kvm_tdp_mmu_zap_invalidated_roots(kvm);
> >  
> >         WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
> > @@ -771,7 +771,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct
> > kvm_mmu_page *sp)
> >   * operation can cause a soft lockup.
> >   */
> >  static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page
> > *root,
> > -                             gfn_t start, gfn_t end, bool can_yield,
> > bool flush)
> > +                             gfn_t start, gfn_t end, bool can_yield,
> > bool flush,
> > +                             bool zap_private)
> >  {
> >         struct tdp_iter iter;
> >  
> > @@ -779,6 +780,10 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm,
> > struct kvm_mmu_page *root,
> >  
> >         lockdep_assert_held_write(&kvm->mmu_lock);
> >  
> > +       WARN_ON_ONCE(zap_private && !is_private_sp(root));
> 
> All the callers have zap_private as zap_private && is_private_sp(root).
> What badness is it trying to uncover?

I added this during debug. Let me drop it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

