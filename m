Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D979037493E
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 22:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhEEUV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 16:21:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:12098 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234027AbhEEUV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 16:21:26 -0400
IronPort-SDR: P1fqeTO68nwXcURW9IQPYDq/yUS47WRUk1xuAEeh0YlEEv3/aTKW+jifbs5mY7PP8zy2hP6g2L
 9UveFor+NAqw==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="219166886"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="219166886"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 13:20:07 -0700
IronPort-SDR: A0HIRXsRDQtl/UWQY7oVZ1I1C+3TmKW6L+/3dKIGEBk3/Y7RN84R5CvW7QRz08mC8Po2kUOT+x
 FbifZ7d2Smvg==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="464264304"
Received: from asharm3-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.239.162])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 13:20:00 -0700
Message-ID: <c7148ea6aa95ee2c53d0893b0ba966169f303789.camel@intel.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: Fix TDP MMU page table level
From:   Kai Huang <kai.huang@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Date:   Thu, 06 May 2021 08:19:56 +1200
In-Reply-To: <CANgfPd-Dv-x9=t1DQrukCpRQJufEcN4ZUTw7mOe=p-zcS=hQDw@mail.gmail.com>
References: <cover.1620200410.git.kai.huang@intel.com>
         <817eae486273adad0a622671f628c5a99b72a375.1620200410.git.kai.huang@intel.com>
         <CANgfPd_gWZB9NMjzsZ-v61e=p53WytCR1qm_28vRg6bdESD1fQ@mail.gmail.com>
         <CANgfPd-Dv-x9=t1DQrukCpRQJufEcN4ZUTw7mOe=p-zcS=hQDw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-05-05 at 10:01 -0700, Ben Gardon wrote:
> On Wed, May 5, 2021 at 9:28 AM Ben Gardon <bgardon@google.com> wrote:
> > 
> > On Wed, May 5, 2021 at 2:38 AM Kai Huang <kai.huang@intel.com> wrote:
> > > 
> > > TDP MMU iterator's level is identical to page table's actual level.  For
> > > instance, for the last level page table (whose entry points to one 4K
> > > page), iter->level is 1 (PG_LEVEL_4K), and in case of 5 level paging,
> > > the iter->level is mmu->shadow_root_level, which is 5.  However, struct
> > > kvm_mmu_page's level currently is not set correctly when it is allocated
> > > in kvm_tdp_mmu_map().  When iterator hits non-present SPTE and needs to
> > > allocate a new child page table, currently iter->level, which is the
> > > level of the page table where the non-present SPTE belongs to, is used.
> > > This results in struct kvm_mmu_page's level always having its parent's
> > > level (excpet root table's level, which is initialized explicitly using
> > > mmu->shadow_root_level).  This is kinda wrong, and not consistent with
> > > existing non TDP MMU code.  Fortuantely the sp->role.level is only used
> > > in handle_removed_tdp_mmu_page(), which apparently is already aware of
> > > this, and handles correctly.  However to make it consistent with non TDP
> > > MMU code (and fix the issue that both root page table and any child of
> > > it having shadow_root_level), fix this by using iter->level - 1 in
> > > kvm_tdp_mmu_map().  Also modify handle_removed_tdp_mmu_page() to handle
> > > such change.
> > 
> > Ugh. Thank you for catching this. This is going to take me a bit to
> > review as I should audit the code more broadly for this problem in the
> > TDP MMU.
> > It would probably also be a good idea to add a comment on the level
> > field to say that it represents the level of the SPTEs in the
> > associated page, not the level of the SPTE that links to the
> > associated page.
> > Hopefully that will prevent similar future misunderstandings.
> 
> I went through and manually audited the code. I think the only case
> that needs to be added to this is for nx recovery:
> 
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -31,7 +31,7 @@ static inline bool kvm_tdp_mmu_zap_gfn_range(struct
> kvm *kvm, int as_id,
>  }
>  static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -       gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
> +       gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level + 1);
> 
>         /*
>          * Don't allow yielding, as the caller may have a flush pending.  Note,
> 
> Otherwise we won't zap the full page with this change, resulting in
> ineffective or less reliable NX recovery.

Oh correct. I missed this. I'll add this in next version. Thanks.

> 
> > 
> > > 
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index debe8c3ec844..bcfb87e1c06e 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -335,7 +335,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> > > 
> > >         for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> > >                 sptep = rcu_dereference(pt) + i;
> > > -               gfn = base_gfn + (i * KVM_PAGES_PER_HPAGE(level - 1));
> > > +               gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
> > > 
> > >                 if (shared) {
> > >                         /*
> > > @@ -377,12 +377,12 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> > >                         WRITE_ONCE(*sptep, REMOVED_SPTE);
> > >                 }
> > >                 handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> > > -                                   old_child_spte, REMOVED_SPTE, level - 1,
> > > +                                   old_child_spte, REMOVED_SPTE, level,
> > >                                     shared);
> > >         }
> > > 
> > >         kvm_flush_remote_tlbs_with_address(kvm, gfn,
> > > -                                          KVM_PAGES_PER_HPAGE(level));
> > > +                                          KVM_PAGES_PER_HPAGE(level + 1));
> > > 
> > >         call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> > >  }
> > > @@ -1009,7 +1009,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> > >                 }
> > > 
> > >                 if (!is_shadow_present_pte(iter.old_spte)) {
> > > -                       sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
> > > +                       sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
> > >                         child_pt = sp->spt;
> > > 
> > >                         new_spte = make_nonleaf_spte(child_pt,
> > > --
> > > 2.31.1
> > > 


