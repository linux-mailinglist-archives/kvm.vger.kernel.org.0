Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AA237239E
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 01:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhECXdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 19:33:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:38491 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229926AbhECXdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 19:33:32 -0400
IronPort-SDR: KaOa5ys/63ow3JY/o04E4mo67uUM6xOw8SV32DeT0BP2HLHu77XROp2HQGXlwy1Yky5hhixs/y
 EsacrrRmoCxw==
X-IronPort-AV: E=McAfee;i="6200,9189,9973"; a="283262649"
X-IronPort-AV: E=Sophos;i="5.82,271,1613462400"; 
   d="scan'208";a="283262649"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 16:32:38 -0700
IronPort-SDR: C+JYQjmTDoYA50sXqVWLKZ0XZnVh6ng+Dx9ULTBhZlUynHPhisxbZRKEGAhRKAd/rXLLJqgWNo
 1Mo1kIEyz2ow==
X-IronPort-AV: E=Sophos;i="5.82,271,1613462400"; 
   d="scan'208";a="462835274"
Received: from mboota-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.249.101])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 16:32:36 -0700
Message-ID: <e5814ecab90a3df04ea862dd31927a8f9275af77.camel@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix some return value error in
 kvm_tdp_mmu_map()
From:   Kai Huang <kai.huang@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Date:   Tue, 04 May 2021 11:32:33 +1200
In-Reply-To: <CANgfPd_gWYaKbdD-fkLNwCSaVQhgcQaSKOEoG0a2B90GhB03zg@mail.gmail.com>
References: <20210430160138.100252-1-kai.huang@intel.com>
         <CANgfPd_gWYaKbdD-fkLNwCSaVQhgcQaSKOEoG0a2B90GhB03zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-03 at 10:07 -0700, Ben Gardon wrote:
> On Fri, Apr 30, 2021 at 9:03 AM Kai Huang <kai.huang@intel.com> wrote:
> > 
> > There are couple of issues in current tdp_mmu_map_handle_target_level()
> > regarding to return value which reflects page fault handler's behavior
> > -- whether it truely fixed page fault, or fault was suprious, or fault
> > requires emulation, etc:
> > 
> > 1) Currently tdp_mmu_map_handle_target_level() return 0, which is
> >    RET_PF_RETRY, when page fault is actually fixed.  This makes
> >    kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
> >    RET_PF_FIXED.
> 
> Ooof that was an oversight. Thank you for catching that.

Thanks for reviewing.

> 
> > 
> > 2) When page fault is spurious, tdp_mmu_map_handle_target_level()
> >    currently doesn't return immediately.  This is not correct, since it
> >    may, for instance, lead to double emulation for a single instruction.
> 
> Could you please add an example of what would be required for this to
> happen? What effect would it have?
> I don't doubt you're correct on this point, just having a hard time
> pinpointing where the issue is.

Hmm.. After reading your reply, I think I wasn't thinking correctly about the emulation
part :)

I was thinking the case that two threads simultaneously write to video ram (which is write
protected and requires emulation) which has been swapped out, in which case one thread
will succeed with setting up the mapping, and the other will get atomic exchange failure.
Since both threads are trying to setup the same mapping, I thought in this case for the
second thread (that gets atomic exchange failure) should just give up. But reading code
again, and with your reply, I think the right behavior is, actually both threads need to
do the emulation, because this is the correct behavior.'

That being said, I still believe that for spurious fault, we should return immediately
(otherwise it is not spurious fault). But I now also believe the spurious fault check in
existing code happens too early -- it has to be after write protection emulation check.
And I just checked the mmu_set_spte() code, if I read correctly, it exactly puts spurious
fault check after write protection emulation check.

Does this make sense?

If this looks good to you, I guess it would be better to split this patch into smaller
patches (for instance, one patch to handle case 1), and one to handle spurious fault
change)?

> 
> > 
> > 3) One case of spurious fault is missing: when iter->old_spte is not
> >    REMOVED_SPTE, but still tdp_mmu_set_spte_atomic() fails on atomic
> >    exchange. This case means the page fault has already been handled by
> >    another thread, and RET_PF_SPURIOUS should be returned. Currently
> >    this case is not distinguished with iter->old_spte == REMOVED_SPTE
> >    case, and RET_PF_RETRY is returned.
> 
> See comment on this point in the code below.
> 
> > 
> > Fix 1) by initializing ret to RET_PF_FIXED at beginning. Fix 2) & 3) by
> > explicitly adding is_removed_spte() check at beginning, and return
> > RET_PF_RETRY when it is true.  For other two cases (old spte equals to
> > new spte, and tdp_mmu_set_spte_atomic() fails), return RET_PF_SPURIOUS
> > immediately.
> > 
> > Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 84ee1a76a79d..a4dc7c9a4ebb 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -905,9 +905,12 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
> >                                           kvm_pfn_t pfn, bool prefault)
> >  {
> >         u64 new_spte;
> > -       int ret = 0;
> > +       int ret = RET_PF_FIXED;
> >         int make_spte_ret = 0;
> > 
> > +       if (is_removed_spte(iter->old_spte))
> > +               return RET_PF_RETRY;
> > +
> >         if (unlikely(is_noslot_pfn(pfn)))
> >                 new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
> >         else
> > @@ -916,10 +919,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
> >                                          map_writable, !shadow_accessed_mask,
> >                                          &new_spte);
> > 
> > -       if (new_spte == iter->old_spte)
> > -               ret = RET_PF_SPURIOUS;
> > -       else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> > -               return RET_PF_RETRY;
> > +       if (new_spte == iter->old_spte ||
> > +                       !tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> > +               return RET_PF_SPURIOUS;
> 
> 
> I'm not sure this is quite right. In mmu_set_spte, I see the following comment:
> 
> /*
> * The fault is fully spurious if and only if the new SPTE and old SPTE
> * are identical, and emulation is not required.
> */
> 
> Based on that comment, I think the existing code is correct. Further,
> if the cmpxchg fails, we have no guarantee that the value that was
> inserted instead resolved the page fault. For example, if two threads
> try to fault in a large page, but one access is a write and the other
> an instruction fetch, the thread with the write might lose the race to
> install its leaf SPTE to the instruction fetch thread installing a
> non-leaf SPTE for NX hugepages. In that case the fault might not be
> spurious and a retry could be needed.

Right. Thanks for educating me :)

> 
> We could do what the fast PF handler does and check
> is_access_allowed(error_code, spte) with whatever value we lost the
> cmpxchg to, but I don't know if that's worth doing or not. There's not
> really much control flow difference between the two return values, as
> far as I can tell.
> 
> It looks like we might also be incorrectly incrementing pf_fixed on a
> spurious PF.

Yes I also think for spurious fault we should return immediately.

> 
> It might be more interesting and accurate to introduce a separate
> return value for cmpxchg failures, just to see how often vCPUs
> actually collide like that.

It might be too complicated I guess, and probably won't worth doing that (and given my
double emulation is wrong).

> 

