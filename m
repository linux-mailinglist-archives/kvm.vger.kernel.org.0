Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8882D375068
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 09:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhEFHxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 03:53:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:16107 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233486AbhEFHw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 03:52:59 -0400
IronPort-SDR: rxkymjNORqInhl5EfvGniu2+xFf0F5j5ir/9BeqvJtWo4K1uO2+NeuZU0caQYAtIe6oKz3/sOa
 +z73mqDK2dTA==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="198045532"
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="198045532"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 00:52:02 -0700
IronPort-SDR: 6Jywza20jYyDPiTeMJAISeHiCU+P7pG6BQGQDPY955+tKg2I0aC2CtNifxFBxksk/WJLfhsG5+
 QMzO7rs6ciuQ==
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="464607986"
Received: from jhagel-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.164.152])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 00:51:59 -0700
Message-ID: <193d473bdfcefa8a552a787025642eb90d3b9e18.camel@intel.com>
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Fix pf_fixed count in
 tdp_mmu_map_handle_target_level()
From:   Kai Huang <kai.huang@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Date:   Thu, 06 May 2021 19:51:57 +1200
In-Reply-To: <CANgfPd-hf-+trgTWe=pjjuWSEyVn8F4WyZ4p5kqaMiqghjseew@mail.gmail.com>
References: <cover.1620200410.git.kai.huang@intel.com>
         <23b565dd3b3dfa20aea1c13bce01163f9427a237.1620200410.git.kai.huang@intel.com>
         <CANgfPd-hf-+trgTWe=pjjuWSEyVn8F4WyZ4p5kqaMiqghjseew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-05-05 at 09:11 -0700, Ben Gardon wrote:
> On Wed, May 5, 2021 at 2:38 AM Kai Huang <kai.huang@intel.com> wrote:
> > 
> > Currently pf_fixed is increased even when page fault requires emulation,
> > or fault is spurious.  Fix by only increasing it when return value is
> > RET_PF_FIXED.
> 
> Revisiting __direct_map and mmu_set_spte, there are cases in the
> legacy MMU where RET_PF_EMULATE is returned but pf_fixed is still
> incremented.
> Perhaps it would make more sense to do the increment in the success
> case of tdp_mmu_set_spte_atomic as you suggested before. Sorry I
> didn't catch that earlier.

If I understand correctly, Sean's suggestion:

        if (ret != RET_PF_SPURIOUS)
                vcpu->stat.pf_fixed++;   

can handle things correctly. The spurious fault check in existing code should work
correctly -- it detects spurious fault early, but later it overwrites if emulation is
required. So with above code, it should work consistently with legacy MMU behavior.

Or did I miss anything?

> 
> It would probably also be worth putting a comment on pf_fixed so that
> people in the future know what it's supposed to mean and we don't get
> into archeology, reverse engineering the meaning of the stat again.

It seems the legacy MMU code path is a better place to add the comment to explain when
pf_fixed should be increased.  However I am not sure whether it is necessary for this
patch (and I confess I found it's hard to explain why to increase pf_fixed in case of
emulation :)).  Or perhaps Sean can write a patch to add comment to legacy MMU :)

I ended up with  below, by adding a comment in TDP MMU saying "to make it consistent with
legacy MMU...", and in the commit message, I put a lore link of this discussion, since I
found Sean's explanation is quite useful. When people are interested in, they can do a git
blame and find the commit msg of this change -- although it is not as straightforward as
having comment directly.

Is this OK to you?

And Sean?

------------------------------------------------------------------------

Currently pf_fixed is not increased when prefault is true.  This is not
correct, since prefault here really means "async page fault completed".
In that case, the original page fault from the guest was morphed into as
async page fault and pf_fixed was not increased.  So when prefault
indicates async page fault is completed, pf_fixed should be increased.

Additionally, currently pf_fixed is also increased even when page fault
is spurious, while legacy MMU increases pf_fixed when page fault returns
RET_PF_EMULATE or RET_PF_FIXED.

To fix above two issues, change to increase pf_fixed when return value
is not RET_PF_SPURIOUS (RET_PF_RETRY has already been ruled out by
reaching here).

More information:
https://lore.kernel.org/kvm/cover.1620200410.git.kai.huang@intel.com/T/#mbb5f8083e58a2cd262231512b9211cbe70fc3bd5

Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1cad4c9f7c34..5e28fbabcd35 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -942,7 +942,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int
write,
                                       rcu_dereference(iter->sptep));
        }

-       if (!prefault)
+       /*
+        * Increase pf_fixed in both RET_PF_EMULATE and RET_PF_FIXED to be
+        * consistent with legacy MMU behavior.
+        */
+       if (ret != RET_PF_SPURIOUS)
                vcpu->stat.pf_fixed++;

        return ret;
-- 
2.31.1

 
> 
> > 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 1cad4c9f7c34..debe8c3ec844 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -942,7 +942,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
> >                                        rcu_dereference(iter->sptep));
> >         }
> > 
> > -       if (!prefault)
> > +       if (!prefault && ret == RET_PF_FIXED)
> >                 vcpu->stat.pf_fixed++;
> > 
> >         return ret;
> > --
> > 2.31.1
> > 


