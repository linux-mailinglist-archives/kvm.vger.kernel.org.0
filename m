Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E2821AE14
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 06:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgGJE3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 00:29:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:2989 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgGJE3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 00:29:25 -0400
IronPort-SDR: tjFobKb2MMSutOITl6D+wzPRxYpcEUwdXCZjlUX55Q6YFDbeHqMfFLsOr3R3idZivVew7QX1sF
 kkV5vFS0D+jg==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="213038514"
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208,223";a="213038514"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 21:29:24 -0700
IronPort-SDR: cB1+QOOezwxeVMptN3mDk3xOc9OQ97oM3KfYGeQaL7kq67L+K4PaB4y3aeYj5hEddGnWBRp6i1
 HDGiuyEY/5fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208,223";a="484518895"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jul 2020 21:29:23 -0700
Date:   Thu, 9 Jul 2020 21:29:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Wayne Boyer <wayne.boyer@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the
 affected memslot
Message-ID: <20200710042922.GA24919@linux.intel.com>
References: <20200703025047.13987-1-sean.j.christopherson@intel.com>
 <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
 <20200709211253.GW24919@linux.intel.com>
 <49c7907a-3ab4-b5db-ccb4-190b990c8be3@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <49c7907a-3ab4-b5db-ccb4-190b990c8be3@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

+Alex, whom I completely spaced on Cc'ing.

Alex, this is related to the dreaded VFIO memslot zapping issue from last
year.  Start of thread: https://patchwork.kernel.org/patch/11640719/.

The TL;DR of below: can you try the attached patch with your reproducer
from the original bug[*]?  I honestly don't know whether it has a legitimate
chance of working, but it's the one thing in all of this that I know was
definitely a bug.  I'd like to test it out if only to sate my curiosity.
Absolutely no rush.

[*] https://patchwork.kernel.org/patch/10798453/#22817321

On Fri, Jul 10, 2020 at 12:18:17AM +0200, Paolo Bonzini wrote:
> On 09/07/20 23:12, Sean Christopherson wrote:
> >> It's bad that we have no clue what's causing the bad behavior, but I
> >> don't think it's wise to have a bug that is known to happen when you
> >> enable the capability. :/
> 
> (Note that this wasn't a NACK, though subtly so).
> 
> > I don't necessarily disagree, but at the same time it's entirely possible
> > it's a Qemu bug.
> 
> No, it cannot be.  QEMU is not doing anything but
> KVM_SET_USER_MEMORY_REGION, and it's doing that synchronously with
> writes to the PCI configuration space BARs.

I'm not saying it's likely, but it's certainly possible.  The failure
went away when KVM zapped SPTEs for seemingly unrelated addresses, i.e. the
error likely goes beyond just the memslot aspect.

> > Even if this is a kernel bug, I'm fairly confident at this point that it's
> > not a KVM bug.  Or rather, if it's a KVM "bug", then there's a fundamental
> > dependency in memslot management that needs to be rooted out and documented.
> 
> Heh, here my surmise is that  it cannot be anything but a KVM bug,
> because  Memslots are not used by anything outside KVM...  But maybe I'm
> missing something.

As above, it's not really a memslot issue, it's more of a paging/TLB issue,
or possibly none of the above.  E.g. it could be a timing bug that goes away
simply because zapping and rebuilding slows things down to the point where
the timing window is closed.

I should have qualified "fairly confident ... that it's not a KVM bug" as
"not a KVM bug related to removing SPTEs for the deleted/moved memslot _as
implemented in this patch_".

Digging back through the old thread, I don't think we ever tried passing
%true for @lock_flush_tlb when zapping rmaps.  And a comment from Alex also
caught my eye, where he said of the following: "If anything, removing this
chunk seems to make things worse."

	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
		kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
		flush = false;
		cond_resched_lock(&kvm->mmu_lock);
	}

A somewhat far fetched theory is that passing %false to kvm_zap_rmapp()
via slot_handle_all_level() created a window where a vCPU could have both
the old stale entry and the new memslot entry in its TLB if the equivalent
to above lock dropping in slot_handle_level_range() triggered.

Removing the above intermediate flush would exacerbate the theoretical
problem by further delaying the flush, i.e. would create a bigger window
for the guest to access the stale SPTE.

Where things get really far fetched is how zapping seemingly random SPTEs
fits in.  Best crazy guess is that zapping enough random things while holding
MMU lock would eventually zap a SPTE that caused the guest to block in the
EPT violation handler.

I'm not exactly confident that the correct zapping approach will actually
resolve the VFIO issue, but I think it's worth trying since not flushing
during rmap zapping was definitely a bug.

> > And we're kind of in a catch-22; it'll be extremely difficult to narrow down
> > exactly who is breaking what without being able to easily test the optimized
> > zapping with other VMMs and/or setups.
> 
> I agree with this, and we could have a config symbol that depends on
> BROKEN and enables it unconditionally.  However a capability is the
> wrong tool.

Ya, a capability is a bad idea.  I was coming at it from the angle that, if
there is a fundamental requirement with e.g. GPU passthrough that requires
zapping all SPTEs, then enabling the precise capability on a per-VM basis
would make sense.  But adding something to the ABI on pure speculation is
silly.

--PNTmBPCT7hxwcZjr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-KVM-x86-mmu-Zap-only-relevant-last-leaf-sptes-when-r.patch"

From b68a2e6095d76574322ce7cf6e63406436fef36d Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Thu, 9 Jul 2020 21:25:11 -0700
Subject: [PATCH] KVM: x86/mmu: Zap only relevant last/leaf sptes when removing
 a memslot

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3dd0af7e75151..9f468337f832c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5810,7 +5810,18 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
-	kvm_mmu_zap_all_fast(kvm);
+	bool flush;
+
+	/*
+	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
+	 * case scenario we'll have unused shadow pages lying around until they
+	 * are recycled due to age or when the VM is destroyed.
+	 */
+	spin_lock(&kvm->mmu_lock);
+	flush = slot_handle_all_level(kvm, slot, kvm_zap_rmapp, true);
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_mmu_init_vm(struct kvm *kvm)
-- 
2.26.0


--PNTmBPCT7hxwcZjr--
