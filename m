Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7023D9C25
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 05:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhG2DWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 23:22:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:50173 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233297AbhG2DWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 23:22:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10059"; a="209682890"
X-IronPort-AV: E=Sophos;i="5.84,276,1620716400"; 
   d="scan'208";a="209682890"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 20:22:04 -0700
X-IronPort-AV: E=Sophos;i="5.84,276,1620716400"; 
   d="scan'208";a="506879422"
Received: from wye1-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.174.73])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 20:22:03 -0700
Date:   Thu, 29 Jul 2021 11:22:00 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: A question of TDP unloading.
Message-ID: <20210729032200.qqb4mlctgplzq6bb@linux.intel.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <YQGj8gj7fpWDdLg5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQGj8gj7fpWDdLg5@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 06:37:38PM +0000, Sean Christopherson wrote:
> On Wed, Jul 28, 2021, Yu Zhang wrote:
> > Thanks a lot for your reply, Sean.
> > 
> > On Tue, Jul 27, 2021 at 06:07:35PM +0000, Sean Christopherson wrote:
> > > On Wed, Jul 28, 2021, Yu Zhang wrote:
> > > > Hi all,
> > > > 
> > > >   I'd like to ask a question about kvm_reset_context(): is there any
> > > >   reason that we must alway unload TDP root in kvm_mmu_reset_context()?
> > > 
> > > The short answer is that mmu_role is changing, thus a new root shadow page is
> > > needed.
> > 
> > I saw the mmu_role is recalculated, but I have not figured out how this
> > change would affect TDP. May I ask a favor to give an example? Thanks!
> > 
> > I realized that if we only recalculate the mmu role, but do not unload
> > the TDP root(e.g., when guest efer.nx flips), base role of the SPs will
> > be inconsistent with the mmu context. But I do not understand why this
> > shall affect TDP. 
> 
> The SPTEs themselves are not affected if the base mmu_role doesn't change; note,
> this holds true for shadow paging, too.  What changes is all of the kvm_mmu
> knowledge about how to walk the guest PTEs, e.g. if a guest toggles CR4.SMAP,
> then KVM needs to recalculate the #PF permissions for guest accesses so that
> emulating instructions at CPL=0 does the right thing.
> 
> As for EFER.NX and CR0.WP, they are in the base page role because they need to
> be there for shadow paging, e.g. if the guest toggles EFER.NX, then the reserved
> bit and executable permissions change, and reusing shadow paging for the old
> EFER.NX could result in missed reserved #PF and/or incorrect executable #PF
> behavior.
> 
> For simplicitly, it's far, far eaiser to reuse the same page role struct for
> TDP paging (both legacy and TDP MMUs) and shadow paging.
> 
> However, I think we can safely ignore NX, WP, SMEP, and SMAP in direct shadow
> pages, which would allow reusing a TDP root across changes.  This is only a baby
> step (assuming it even works), as further changes to set_cr0/cr4/efer would be
> needed to fully realize the optimizations, e.g. to avoid complete teardown if
> the root_count hits zero.

Thanks for your explaination, Sean. And I fully agree!

As you can see in my first mail, I kept reinitiate the mmu role in kvm_reset_context(),
so that guest paging mode change will be handled correctly, for guest page table walker.
As to shadow, the unload is always needed, because NX and WP of existing SPs matters.

+void kvm_mmu_reset_context(struct kvm_vcpu *vcpu, bool force_tdp_unload)
{
-       kvm_mmu_unload(vcpu);
+       if (!tdp_enabled || force_tdp_unload)
+               kvm_mmu_unload(vcpu);
+
        kvm_init_mmu(vcpu);
}

In the caller, force_tdp_unload was set to false for CR0/CR4/EFER changes. For SMM and
cpuid updates, it is set to true.

With this change, I can successfully boot a VM(and of course, number of unloadings is
greatly reduced). But access test case in kvm-unit-test hangs, after CR4.SMEP is flipped.
I'm trying to figure out why...

> 
> I'll put this on my todo list, I've been looking for an excuse to update the
> cr0/cr4/efer flows anyways :-).  If it works, the changes should be relatively
> minor, if it works...
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a8cdfd8d45c4..700664fe163e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2077,8 +2077,20 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>         role = vcpu->arch.mmu->mmu_role.base;
>         role.level = level;
>         role.direct = direct;
> -       if (role.direct)
> +       if (role.direct) {
>                 role.gpte_is_8_bytes = true;
> +
> +               /*
> +                * Guest PTE permissions do not impact SPTE permissions for
> +                * direct MMUs.  Either there are no guest PTEs (CR0.PG=0) or
> +                * guest PTE permissions are enforced by the CPU (TDP enabled).
> +                */
> +               WARN_ON_ONCE(access != ACC_ALL);
> +               role.efer_nx = 0;
> +               role.cr0_wp = 0;
> +               role.smep_andnot_wp = 0;
> +               role.smap_andnot_wp = 0;
> +       }

How about we do this in kvm_calc_mmu_role_common()? :-)

Thanks
Yu

>         role.access = access;
>         if (!direct_mmu && vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL) {
>                 quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
