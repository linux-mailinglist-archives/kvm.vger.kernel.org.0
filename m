Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C75B3DB4FF
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 10:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238050AbhG3IWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 04:22:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:56483 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231411AbhG3IWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 04:22:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="200227670"
X-IronPort-AV: E=Sophos;i="5.84,281,1620716400"; 
   d="scan'208";a="200227670"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 01:22:36 -0700
X-IronPort-AV: E=Sophos;i="5.84,281,1620716400"; 
   d="scan'208";a="507875541"
Received: from bingdeng-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.174.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 01:22:34 -0700
Date:   Fri, 30 Jul 2021 16:22:44 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: A question of TDP unloading.
Message-ID: <20210730082244.7bujzzbpc7z3wpc7@linux.intel.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <YQGj8gj7fpWDdLg5@google.com>
 <20210729032200.qqb4mlctgplzq6bb@linux.intel.com>
 <YQMX+Cvo8GKCo3Zt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQMX+Cvo8GKCo3Zt@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 09:04:56PM +0000, Sean Christopherson wrote:
> On Thu, Jul 29, 2021, Yu Zhang wrote:
> > On Wed, Jul 28, 2021 at 06:37:38PM +0000, Sean Christopherson wrote:
> > > On Wed, Jul 28, 2021, Yu Zhang wrote:
> > In the caller, force_tdp_unload was set to false for CR0/CR4/EFER changes. For SMM and
> > cpuid updates, it is set to true.
> > 
> > With this change, I can successfully boot a VM(and of course, number of unloadings is
> > greatly reduced). But access test case in kvm-unit-test hangs, after CR4.SMEP is flipped.
> > I'm trying to figure out why...
> 
> Hrm, I'll look into when I get around to making this into a proper patch.

Well, I think I found the reason why access test failed in access test, when guest flips
CR4.SMEP: the TLB needs to be flushed. 

Currently, this is done in kvm_mmu_reload() -> kvm_mmu_load(). Avoiding the unloading in
kvm_mmu_reset_context() will not set the root_hpa to INVALID_PAGE, thus will not trigger
the kvm_mmu_load().

After I flushed the TLB, all access test cases passed. :)

B.R.
Yu
> 
> Note, there's at least once bug, as is_root_usable() will compare the full role
> against a root shadow page's modified role.  A common helper to derive the page
> role for a direct/TDP page from an existing mmu_role is likely the way to go, as
> kvm_tdp_mmu_get_vcpu_root_hpa() would want the same functionality.
> 
> > > I'll put this on my todo list, I've been looking for an excuse to update the
> > > cr0/cr4/efer flows anyways :-).  If it works, the changes should be relatively
> > > minor, if it works...
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index a8cdfd8d45c4..700664fe163e 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -2077,8 +2077,20 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > >         role = vcpu->arch.mmu->mmu_role.base;
> > >         role.level = level;
> > >         role.direct = direct;
> > > -       if (role.direct)
> > > +       if (role.direct) {
> > >                 role.gpte_is_8_bytes = true;
> > > +
> > > +               /*
> > > +                * Guest PTE permissions do not impact SPTE permissions for
> > > +                * direct MMUs.  Either there are no guest PTEs (CR0.PG=0) or
> > > +                * guest PTE permissions are enforced by the CPU (TDP enabled).
> > > +                */
> > > +               WARN_ON_ONCE(access != ACC_ALL);
> > > +               role.efer_nx = 0;
> > > +               role.cr0_wp = 0;
> > > +               role.smep_andnot_wp = 0;
> > > +               role.smap_andnot_wp = 0;
> > > +       }
> > 
> > How about we do this in kvm_calc_mmu_role_common()? :-)
> 
> No, because the role in struct kvm_mmu does need the correct bits, even for TDP,
> as the role is used to detect whether or not the context needs to be re-initialized,
> e.g. it would get a false negative on a cr0_wp change, not go through
> update_permission_bitmask(), and use the wrong page permissions when walking the
> guest page tables.
> 
