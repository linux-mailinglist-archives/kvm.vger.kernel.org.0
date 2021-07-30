Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9F93DB62E
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 11:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbhG3Jma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 05:42:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:55054 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230462AbhG3Jm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 05:42:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10060"; a="234973596"
X-IronPort-AV: E=Sophos;i="5.84,281,1620716400"; 
   d="scan'208";a="234973596"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 02:42:24 -0700
X-IronPort-AV: E=Sophos;i="5.84,281,1620716400"; 
   d="scan'208";a="507920739"
Received: from bingdeng-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.174.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 02:42:22 -0700
Date:   Fri, 30 Jul 2021 17:42:34 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: A question of TDP unloading.
Message-ID: <20210730094234.evkjd5gockjekdqj@linux.intel.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <YQGj8gj7fpWDdLg5@google.com>
 <20210729032200.qqb4mlctgplzq6bb@linux.intel.com>
 <YQMX+Cvo8GKCo3Zt@google.com>
 <20210730024251.fpd2vtbkmdnooq6s@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730024251.fpd2vtbkmdnooq6s@linux.intel.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 10:42:51AM +0800, Yu Zhang wrote:
> On Thu, Jul 29, 2021 at 09:04:56PM +0000, Sean Christopherson wrote:
> > On Thu, Jul 29, 2021, Yu Zhang wrote:
> > > On Wed, Jul 28, 2021 at 06:37:38PM +0000, Sean Christopherson wrote:
> > > > On Wed, Jul 28, 2021, Yu Zhang wrote:
> > > In the caller, force_tdp_unload was set to false for CR0/CR4/EFER changes. For SMM and
> > > cpuid updates, it is set to true.
> > > 
> > > With this change, I can successfully boot a VM(and of course, number of unloadings is
> > > greatly reduced). But access test case in kvm-unit-test hangs, after CR4.SMEP is flipped.
> > > I'm trying to figure out why...
> > 
> > Hrm, I'll look into when I get around to making this into a proper patch.
> > 
> > Note, there's at least once bug, as is_root_usable() will compare the full role
> > against a root shadow page's modified role.  A common helper to derive the page
> > role for a direct/TDP page from an existing mmu_role is likely the way to go, as
> > kvm_tdp_mmu_get_vcpu_root_hpa() would want the same functionality.
> 
> So, if we know there are some bits meaningless in SP, could we use a 
> ignored_mask, each time we try to compare the full role.word? This may
> be also needed in kvm_mmu_get_page().

Oh. We do not need this, setting these flags to 0 shall be fine, because role flags
of the SP are all from kvm_mmu_get_page(). Sorry for the noise...

B.R.
Yu
> > 
> > > > I'll put this on my todo list, I've been looking for an excuse to update the
> > > > cr0/cr4/efer flows anyways :-).  If it works, the changes should be relatively
> > > > minor, if it works...
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index a8cdfd8d45c4..700664fe163e 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -2077,8 +2077,20 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > > >         role = vcpu->arch.mmu->mmu_role.base;
> > > >         role.level = level;
> > > >         role.direct = direct;
> > > > -       if (role.direct)
> > > > +       if (role.direct) {
> > > >                 role.gpte_is_8_bytes = true;
> > > > +
> > > > +               /*
> > > > +                * Guest PTE permissions do not impact SPTE permissions for
> > > > +                * direct MMUs.  Either there are no guest PTEs (CR0.PG=0) or
> > > > +                * guest PTE permissions are enforced by the CPU (TDP enabled).
> > > > +                */
> > > > +               WARN_ON_ONCE(access != ACC_ALL);
> > > > +               role.efer_nx = 0;
> > > > +               role.cr0_wp = 0;
> > > > +               role.smep_andnot_wp = 0;
> > > > +               role.smap_andnot_wp = 0;
> > > > +       }
> > > 
> > > How about we do this in kvm_calc_mmu_role_common()? :-)
> > 
> > No, because the role in struct kvm_mmu does need the correct bits, even for TDP,
> > as the role is used to detect whether or not the context needs to be re-initialized,
> > e.g. it would get a false negative on a cr0_wp change, not go through
> > update_permission_bitmask(), and use the wrong page permissions when walking the
> > guest page tables.
> 
> Oh yes. Regardless of what flags really matter in a SP, all of them are useful for mmu
> context. Thanks for correcting me.
> 
> B.R.
> Yu
> 
