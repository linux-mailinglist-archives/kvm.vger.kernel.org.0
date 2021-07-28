Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFF13D8901
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 09:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhG1HkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 03:40:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:62218 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233407AbhG1HkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 03:40:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10058"; a="276388920"
X-IronPort-AV: E=Sophos;i="5.84,275,1620716400"; 
   d="scan'208";a="276388920"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 00:40:08 -0700
X-IronPort-AV: E=Sophos;i="5.84,275,1620716400"; 
   d="scan'208";a="506323868"
Received: from yzhao56-desk.sh.intel.com ([10.239.13.16])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2021 00:40:06 -0700
Date:   Wed, 28 Jul 2021 15:25:15 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: A question of TDP unloading.
Message-ID: <20210728072514.GA375@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 02:56:05PM +0800, Yu Zhang wrote:
> Thanks a lot for your reply, Sean.
> 
> On Tue, Jul 27, 2021 at 06:07:35PM +0000, Sean Christopherson wrote:
> > On Wed, Jul 28, 2021, Yu Zhang wrote:
> > > Hi all,
> > > 
> > >   I'd like to ask a question about kvm_reset_context(): is there any
> > >   reason that we must alway unload TDP root in kvm_mmu_reset_context()?
> > 
> > The short answer is that mmu_role is changing, thus a new root shadow page is
> > needed.
> 
> I saw the mmu_role is recalculated, but I have not figured out how this
> change would affect TDP. May I ask a favor to give an example? Thanks!
> 
> I realized that if we only recalculate the mmu role, but do not unload
> the TDP root(e.g., when guest efer.nx flips), base role of the SPs will
> be inconsistent with the mmu context. But I do not understand why this
> shall affect TDP. 
> 
> > 
> > >   As you know, KVM MMU needs to track guest paging mode changes, to
> > >   recalculate the mmu roles and reset callback routines(e.g., guest
> > >   page table walker). These are done in kvm_mmu_reset_context(). Also,
> > >   entering SMM, cpuid updates, and restoring L1 VMM's host state will
> > >   trigger kvm_mmu_reset_context() too.
> > >   
> > >   Meanwhile, another job done by kvm_mmu_reset_context() is to unload
> > >   the KVM MMU:
> > >   
> > >   - For shadow & legacy TDP, it means to unload the root shadow/TDP
> > >     page and reconstruct another one in kvm_mmu_reload(), before
> > >     entering guest. Old shadow/TDP pages will probably be reused later,
> > >     after future guest paging mode switches.
> > >   
> > >   - For TDP MMU, it is even more aggressive, all TDP pages will be
> > >     zapped, meaning a whole new TDP page table will be recontrustred,
> > >     with each paging mode change in the guest. I witnessed dozens of
> > >     rebuildings of TDP when booting a Linux guest(besides the ones
> > >     caused by memslots rearrangement).
> > >   
> > >   However, I am wondering, why do we need the unloading, if GPA->HPA
> > >   relationship is not changed? And if this is not a must, could we
> > >   find a way to refactor kvm_mmu_reset_context(), so that unloading
> > >   of TDP root is only performed when necessary(e.g, SMM switches and
> > >   maybe after cpuid updates which may change the level of TDP)? 
> > >   
> > >   I tried to add a parameter in kvm_mmu_reset_context(), to make the
> > >   unloading optional:  
> > > 
> > > +void kvm_mmu_reset_context(struct kvm_vcpu *vcpu, bool force_tdp_unload)
> > >  {
> > > -       kvm_mmu_unload(vcpu);
> > > +       if (!tdp_enabled || force_tdp_unload)
> > > +               kvm_mmu_unload(vcpu);
> > > +
> > >         kvm_init_mmu(vcpu);
> > >  }
> > > 
> > >   But this change brings another problem - if we keep the TDP root, the
> > >   role of existing SPs will be obsolete after guest paging mode changes.
> > >   Altough I guess most role flags are irrelevant in TDP, I am not sure
> > >   if this could cause any trouble.
> > >   
> > >   Is there anyone looking at this issue? Or do you have any suggestion?
> > 
> > What's the problem you're trying to solve?  kvm_mmu_reset_context() is most
> > definitely a big hammer, e.g. kvm_post_set_cr0() and kvm_post_set_cr4() in
> > particular could be reworked to do something like kvm_mmu_new_pgd() + kvm_init_mmu(),
> > but modifying mmu_role bits in CR0/CR4 should be a rare event, i.e. there hasn't
> > sufficient motivation to optimize CR0/CR4 changes.
> 
> Well, I noticed this when I was trying to find the reason why a single GFN
> can have multiple rmaps in TDP(not the SMM case, which uses different memslot).
> And the fact that guest paging mode change will cause the unloading of TDP
> looks counter-intuitive. I know I must have missed something important, and
> I have a strong desire to figure out why. :)
> 
> Then I tried with TDP MMU, yet to find the unloading is performed even more
> aggressively... 
> 
> > 
> > Note, most CR4 bits and CR0.PG are tracked in kvm_mmu_extended_role, not
> > kvm_mmu_page_role, which adds a minor wrinkle to the logic.
> > 
> 
> The extended role is another pain point for me when reading KVM MMU code.
> I can understand it is useful in shadow, but does it also matters in TDP?
> 

hi
I noticed that shadow page's role is of type union kvm_mmu_page_role.
so, can I understand that we actually only need to do kvm_mmu_unload() when
base roles of new mmu role and the old context mmu role are different?

Thanks
Yan


