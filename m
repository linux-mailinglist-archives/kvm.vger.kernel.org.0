Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD27B175B
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfIMCrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:47:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:58608 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfIMCqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159501"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Sep 2019 19:46:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>
Subject: [PATCH 00/11] KVM: x86/mmu: Restore fast invalidate/zap flow
Date:   Thu, 12 Sep 2019 19:46:01 -0700
Message-Id: <20190913024612.28392-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restore the fast invalidate flow for zapping shadow pages and use it
whenever vCPUs can be active in the VM.  This fixes (in theory, not yet
confirmed) a regression reported by James Harvey where KVM can livelock
in kvm_mmu_zap_all() when it's invoked in response to a memslot update.

The fast invalidate flow was removed as it was deemed to be unnecessary
after its primary user, memslot flushing, was reworked to zap only the
memslot in question instead of all shadow pages.  Unfortunately, zapping
only the memslot being (re)moved during a memslot update introduced a
regression for VMs with assigned devices.  Because we could not discern
why zapping only the relevant memslot broke device assignment, or if the
regression extended beyond device assignment, we reverted to zapping all
shadow pages when a memslot is (re)moved.

The revert to "zap all" failed to account for subsequent changes that
have been made to kvm_mmu_zap_all() between then and now.  Specifically,
kvm_mmu_zap_all() now conditionally drops reschedules and drops mmu_lock
if a reschedule is needed or if the lock is contended.  Dropping the lock
allows other vCPUs to add shadow pages, and, with enough vCPUs, can cause
kvm_mmu_zap_all() to get stuck in an infinite loop as it can never zap all
pages before observing lock contention or the need to reschedule.

The reasoning behind having kvm_mmu_zap_all() conditionally reschedule was
that it would only be used when the VM is inaccesible, e.g. when its
mm_struct is dying or when the VM itself is being destroyed.  In that case,
playing nice with the rest of the kernel instead of hogging cycles to free
unused shadow pages made sense.

Since it's unlikely we'll root cause the device assignment regression any
time soon, and that simply removing the conditional rescheduling isn't
guaranteed to return us to a known good state, restore the fast invalidate
flow for zapping on memslot updates, including mmio generation wraparound.
Opportunisticaly tack on a bug fix and a couple enhancements.

Alex and James, it probably goes without saying... please test, especially
patch 01/11 as a standalone patch as that'll likely need to be applied to
stable branches, assuming it works.  Thanks!

Sean Christopherson (11):
  KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot
  KVM: x86/mmu: Treat invalid shadow pages as obsolete
  KVM: x86/mmu: Use fast invalidate mechanism to zap MMIO sptes
  KVM: x86/mmu: Revert "Revert "KVM: MMU: show mmu_valid_gen in shadow
    page related tracepoints""
  KVM: x86/mmu: Revert "Revert "KVM: MMU: add tracepoint for
    kvm_mmu_invalidate_all_pages""
  KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""
  KVM: x86/mmu: Revert "Revert "KVM: MMU: collapse TLB flushes when zap
    all pages""
  KVM: x86/mmu: Revert "Revert "KVM: MMU: reclaim the zapped-obsolete
    page first""
  KVM: x86/mmu: Revert "KVM: x86/mmu: Remove is_obsolete() call"
  KVM: x86/mmu: Explicitly track only a single invalid mmu generation
  KVM: x86/mmu: Skip invalid pages during zapping iff root_count is zero

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu.c              | 154 ++++++++++++++++++++++++++++----
 arch/x86/kvm/mmutrace.h         |  42 +++++++--
 arch/x86/kvm/x86.c              |   1 +
 4 files changed, 173 insertions(+), 28 deletions(-)

-- 
2.22.0

