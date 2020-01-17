Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CC51403FA
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 07:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgAQG07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 01:26:59 -0500
Received: from mga17.intel.com ([192.55.52.151]:14600 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgAQG0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 01:26:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 22:26:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,329,1574150400"; 
   d="scan'208";a="424342466"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jan 2020 22:26:29 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Derek Yerger <derek@djy.llc>,
        kernel@najdan.com, Thomas Lambertz <mail@thomaslambertz.de>,
        Rik van Riel <riel@surriel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/4] KVM: x86: TIF_NEED_FPU_LOAD bug fixes
Date:   Thu, 16 Jan 2020 22:26:24 -0800
Message-Id: <20200117062628.6233-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Three bug fixes related to deferring FPU loading to return to userspace,
or in this case, deferring to entering a KVM guest.  And a cleanup patch I
couldn't resist throwing on top.

The crux of the matter is that TIF_FPU_NEED_LOAD can be set any time
control is transferred out of KVM, e.g. via IRQ->softirq, not just when
KVM is preempted.  The previous attempt to fix the underlying bug(s)
by handling TIF_FPU_NEED_LOAD during kvm_sched_in() only made the bug(s)
harder to hit, i.e. it resolved the preemption case but only shrunk the
window where a softirq could corrupt state.

Paolo, patch 01 will conflict with commit 95145c25a78c ("KVM: x86: Add a
WARN on TIF_NEED_FPU_LOAD in kvm_load_guest_fpu()") that is sitting in
kvm/queue.  The kvm/queue commit should simply be dropped.

Patch 01 fixes the original underlying bug, which is that KVM doesn't
handle TIF_FPU_NEED_LOAD when swapping between guest and userspace FPU
state.

Patch 02 fixes (unconfirmed) issues similar to the reported bug where KVM
doesn't ensure CPU FPU state is fresh when accessing it during emulation.
This patch is smoke tested only (via kvm-unit-tests' emulator tests).

Patch 03 reverts the preemption bug fix, which simultaneously restores the
handling of TIF_FPU_NEED_LOAD in vcpu_enter_guest() to fix the reported
bugs[1][2] and removes the now-unnecessary preemption workaround.

Alternatively, the handling of TIF_NEED_FPU_LOAD in the kvm_sched_in()
path could be left in place, i.e it doesn't cause immediate damage, but
as stated before, restoring FPU state after KVM is preempted only makes
it harder to find the actual bugs.  Case in point, I originally split
the revert into two separate patches (so that removing the kvm_sched_in()
call wouldn't be tagged for stable), but that only hid the underlying
kvm_put_guest_fpu() bug until I fully reverted the commit.

Patch 04 removes an unused emulator context param from several of the
functions that are fixed in patch 02.  The param was left behind during
a previous KVM FPU state rework.

Tested via Thomas Lambertz's mprime reproducer[3], which detected issues
with buggy KVMs on my system in under a minute.  Ran clean for ~30 minutes
on each of the first two patches and several hours with all three patches
applied.

[1] https://lore.kernel.org/kvm/1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc
[2] https://lore.kernel.org/kvm/bug-206215-28872@https.bugzilla.kernel.org%2F
[3] https://lore.kernel.org/lkml/217248af-e980-9cb0-ff0d-9773413b9d38@thomaslambertz.de

Sean Christopherson (4):
  KVM: x86: Handle TIF_NEED_FPU_LOAD in kvm_{load,put}_guest_fpu()
  KVM: x86: Ensure guest's FPU state is loaded when accessing for
    emulation
  KVM: x86: Revert "KVM: X86: Fix fpu state crash in kvm guest"
  KVM: x86: Remove unused ctxt param from emulator's FPU accessors

 arch/x86/kvm/emulate.c | 67 ++++++++++++++++++++++++++++++++----------
 arch/x86/kvm/x86.c     | 36 +++++++++++++++++------
 2 files changed, 79 insertions(+), 24 deletions(-)

-- 
2.24.1

