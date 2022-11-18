Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8889C62EB8D
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 03:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbiKRCBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 21:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKRCBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 21:01:00 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABA169DD8;
        Thu, 17 Nov 2022 18:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668736860; x=1700272860;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CBSKmbJIiBhn1WZyJrBfdQmAQIH02WRbcY80uQNc7B8=;
  b=YwTSAEwZb1Z119Vrcvp8gN6l/ixz/hfOAajj0hZJEGqnw3xeq0nRL+Oj
   jJO/KAGXucIpPnb7YKy7zmQVJGxCKHTLInaUCTr/xR6C53NdKpLvox/iW
   XkQQYGzbqwiPklvzDDoTIRRnCl/MLVYMqkBzUyG/ivWfTYoX5hChByf32
   rL/lnEQWrnRy3Ek89xQWNmarmcIS/KX6+tMLvGLDQyXBUe1f52ZdmPvom
   roigb7g+JluHMoSFmdUt3QkYI84q/dguxIHo/YDE9l4ErZXtFyxdUxxqN
   V2gho5Ve0WOXTDvRRytqhSsjXL6Op0elRg37NgKQU9kp3NmK/eNa4AUmU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="377298247"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="377298247"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 18:00:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="671149357"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="671149357"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 17 Nov 2022 18:00:58 -0800
Message-ID: <11f5e652ca2c2a4507316c3426b25d0d5cd66120.camel@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: simplify kvm_tdp_mmu_map flow when guest
 has to retry
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Date:   Fri, 18 Nov 2022 10:00:57 +0800
In-Reply-To: <CALzav=cxtgaVV2tORqDo93AuUW+5BSLdjsah=YASQdPMwnf2iA@mail.gmail.com>
References: <20221117161449.114086-1-pbonzini@redhat.com>
         <CALzav=cxtgaVV2tORqDo93AuUW+5BSLdjsah=YASQdPMwnf2iA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-11-17 at 10:43 -0800, David Matlack wrote:
> On Thu, Nov 17, 2022 at 8:14 AM Paolo Bonzini <pbonzini@redhat.com>
> wrote:
> > 
> > A removed SPTE is never present, hence the "if" in kvm_tdp_mmu_map
> > only fails in the exact same conditions that the earlier loop
> > tested in order to issue a  "break". So, instead of checking twice
> > the
> > condition (upper level SPTEs could not be created or was frozen),
> > just
> > exit the loop with a goto---the usual poor-man C replacement for
> > RAII
> > early returns.
> > 
> > While at it, do not use the "ret" variable for return values of
> > functions that do not return a RET_PF_* enum.  This is clearer
> > and also makes it possible to initialize ret to RET_PF_RETRY.
> > 
> > Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 40 ++++++++++++++++++--------------
> > ------
> >  1 file changed, 19 insertions(+), 21 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c
> > b/arch/x86/kvm/mmu/tdp_mmu.c
> > index e08596775427..771210ce5181 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1159,7 +1159,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu,
> > struct kvm_page_fault *fault)
> >         struct kvm *kvm = vcpu->kvm;
> >         struct tdp_iter iter;
> >         struct kvm_mmu_page *sp;
> > -       int ret;
> > +       int ret = RET_PF_RETRY;
> > 
> >         kvm_mmu_hugepage_adjust(vcpu, fault);
> > 
> > @@ -1168,23 +1168,25 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu,
> > struct kvm_page_fault *fault)
> >         rcu_read_lock();
> > 
> >         tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1)
> > {
> > +               int r;
> > +
> >                 if (fault->nx_huge_page_workaround_enabled)
> >                         disallowed_hugepage_adjust(fault,
> > iter.old_spte, iter.level);
> > 
> >                 if (iter.level == fault->goal_level)
> >                         break;
> > 
> > -               /* Step down into the lower level page table if it
> > exists. */
> > -               if (is_shadow_present_pte(iter.old_spte) &&
> > -                   !is_large_pte(iter.old_spte))
> > -                       continue;
> > -
> >                 /*
> >                  * If SPTE has been frozen by another thread, just
> > give up and
> >                  * retry, avoiding unnecessary page table
> > allocation and free.
> >                  */
> >                 if (is_removed_spte(iter.old_spte))
> > -                       break;
> > +                       goto retry;
> > +
> > +               /* Step down into the lower level page table if it
> > exists. */
> > +               if (is_shadow_present_pte(iter.old_spte) &&
> > +                   !is_large_pte(iter.old_spte))
> > +                       continue;
> > 
> >                 /*
> >                  * The SPTE is either non-present or points to a
> > huge page that
> > @@ -1196,13 +1198,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu,
> > struct kvm_page_fault *fault)
> >                 sp->nx_huge_page_disallowed = fault-
> > >huge_page_disallowed;
> > 
> >                 if (is_shadow_present_pte(iter.old_spte))
> > -                       ret = tdp_mmu_split_huge_page(kvm, &iter,
> > sp, true);
> > +                       r = tdp_mmu_split_huge_page(kvm, &iter, sp,
> > true);
> >                 else
> > -                       ret = tdp_mmu_link_sp(kvm, &iter, sp,
> > true);
> > +                       r = tdp_mmu_link_sp(kvm, &iter, sp, true);
> 
> Can this fix be squashed into [1]? It seems like a serious enough
> bug.
> If 2 threads race to update the same PTE, KVM will return -EBUSY out
> to userspace from KVM_RUN, I think. I'm not sure about QEMU, but that
> would be fatal for the VM in Vanadium.
> 
> [1] 
> https://lore.kernel.org/kvm/20221109185905.486172-3-dmatlack@google.com/
> 
I think in you patch it's all right, since then before
kvm_tdp_mmu_map() returns, it must go through
tdp_mmu_map_handle_target_level(), it returns RET_PF_* enum.

> > 
> > -               if (ret) {
> > +               /*
> > +                * Also force the guest to retry the access if the
> > upper level SPTEs
> > +                * aren't in place.
> > +                */
> > +               if (r) {
> >                         tdp_mmu_free_sp(sp);
> > -                       break;
> > +                       goto retry;
> >                 }
> > 
> >                 if (fault->huge_page_disallowed &&
> > @@ -1213,18 +1219,10 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu,
> > struct kvm_page_fault *fault)
> >                 }
> >         }
> > 
> > -       /*
> > -        * Force the guest to retry the access if the upper level
> > SPTEs aren't
> > -        * in place, or if the target leaf SPTE is frozen by
> > another CPU.
> > -        */
> > -       if (iter.level != fault->goal_level ||
> > is_removed_spte(iter.old_spte)) {
> > -               rcu_read_unlock();
> > -               return RET_PF_RETRY;
> > -       }
> > -
> >         ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
> > -       rcu_read_unlock();
> > 
> > +retry:
> > +       rcu_read_unlock();
> >         return ret;
> >  }
> > 
> > --
> > 2.31.1
> > 

