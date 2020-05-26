Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEAB1B5276
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgDWCZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:25:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:43420 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgDWCZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:54 -0400
IronPort-SDR: B6yYB+czKgIza8u3p+/gOOdQgnLyCR5cNN3u4OjX10pwcWGNqnyUVHrWgMNRNXhy3CEUMSDe0R
 Iz1tHWhm8N3Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:54 -0700
IronPort-SDR: TAOiyz6URTSwcAdFpQTxkoZlu8HG4C1DvtPgwh6a5fmqoAhwOgfIkxG96kZe2au79BPHH6yisI
 AP5IWivucX7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273930"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2020 19:25:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 00/13] KVM: x86: Event fixes and cleanup
Date:   Wed, 22 Apr 2020 19:25:37 -0700
Message-Id: <20200423022550.15113-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most of this series only really affects nVMX, but there are a few x86
changes sprinkled in.

Patches 1 and 2 are alternative fixes[1][2] for bugs where a #DB destined
for L2 is dropped because a lower priority event, e.g. VMX preemption
timer, is serviced and triggers VM-Exit, and where correctly handling the
#DB can result in the preemption timer being dropped.

Patch 3 fixes a semi-theoretical bug.  I've been intermittently observing
failures when running the preemption timer unit test in L1, but have never
been able to consistently reproduce the bug.  I suspect the issue is
KVM_REQ_EVENT being lost, but can't really confirm this is the case due to
lack of a reproducer.

Patches 4-7 are cleanup/refactoring to fix non-exiting NMI/INTR priority
bugs (similar to above) in patch 8.  Although patch 8 is technically a bug
fix, I don't think it's stable material (no sane L1 will notice), which is
why I prioritized (da-dum ching) a clean implementation over an easily
backported patch (a single patch would have been ugly).

Patch 9 fixes a similar issue with SMI priority, and again is probably not
stable material.

Patch 10 addresses a gap in WARN coverage that's effectively introduced
by the bug fix in patch 1.

Patches 11 and 12 replace the extra call to check_nested_events() with a
more precise hack-a-fix.  This is a very small step towards a pipe dream
of processing each event class exactly once per run loop (more below).

Patch 13 is a random optimization that caught my eye when starting at this
code over and over.


I really, really dislike KVM's event handling flow.  In the (distant)
future I'd love to rework the event injection to process each event
exactly once per loop, as opposed to the current behavior where
check_nested_events() can be called at least twice, if not more depending
on blocking behavior.  That would make it much cleaner to correctly handle
event prioritization and likely to maintain the code, but getting there is
a significant rework with a fair number of scary changes.

[1] https://lkml.kernel.org/r/20200414000946.47396-2-jmattson@google.com
[2] https://lkml.kernel.org/r/20200414000946.47396-1-jmattson@google.com

Sean Christopherson (13):
  KVM: nVMX: Preserve exception priority irrespective of exiting
    behavior
  KVM: nVMX: Open a window for pending nested VMX preemption timer
  KVM: x86: Set KVM_REQ_EVENT if run is canceled with req_immediate_exit
    set
  KVM: x86: Make return for {interrupt_nmi}_allowed() a bool instead of
    int
  KVM: nVMX: Move nested_exit_on_nmi() to nested.h
  KVM: nVMX: Report NMIs as allowed when in L2 and Exit-on-NMI is set
  KVM: VMX: Split out architectural interrupt/NMI blocking checks
  KVM: nVMX: Preserve IRQ/NMI priority irrespective of exiting behavior
  KVM: nVMX: Prioritize SMI over nested IRQ/NMI
  KVM: x86: WARN on injected+pending exception even in nested case
  KVM: VMX: Use vmx_interrupt_blocked() directly from vmx_handle_exit()
  KVM: x86: Replace late check_nested_events() hack with more precise
    fix
  KVM: VMX: Use vmx_get_rflags() to query RFLAGS in
    vmx_interrupt_blocked()

 arch/x86/include/asm/kvm_host.h |  6 ++-
 arch/x86/kvm/svm/svm.c          | 10 ++--
 arch/x86/kvm/vmx/nested.c       | 42 +++++++++++------
 arch/x86/kvm/vmx/nested.h       |  5 ++
 arch/x86/kvm/vmx/vmx.c          | 84 +++++++++++++++++++++------------
 arch/x86/kvm/vmx/vmx.h          |  2 +
 arch/x86/kvm/x86.c              | 32 +++++--------
 7 files changed, 113 insertions(+), 68 deletions(-)

-- 
2.26.0

