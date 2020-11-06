Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65652A91EE
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 10:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgKFJA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 04:00:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:4550 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgKFJA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 04:00:56 -0500
IronPort-SDR: lsSwtWDvaGXhvgyFTk7sQb9GWdz72WMflXLwqsZX0qWv5YQlYU9HgRv0gbd4OhY4mEDE5o+f2v
 vZiW9UUsTWzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="169670225"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="169670225"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 01:00:55 -0800
IronPort-SDR: t2MbEemj6vFM6wgVQZwHgK0M0sP+tvKKecZPtEXbbtpIgA5AI059nyVhiq15BeJmL0cyh14xGR
 CilcI/RY9vNA==
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="472000251"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 01:00:52 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/4] Add bus lock VM exit support
Date:   Fri,  6 Nov 2020 17:03:11 +0800
Message-Id: <20201106090315.18606-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series add the support for bus lock VM exit in KVM. It is a
sub-feature of bus lock detection. When it is enabled by the VMM, the
processor generates a "Bus Lock" VM exit following execution of an
instruction if the processor detects that one or more bus locks were
caused the instruction was being executed (due to either direct access
by the instruction or stuffed accesses like through A/D updates).

Bus lock VM exit will introduce a new modifier bit (bit 26) in
exit_reason field in VMCS which indicates bus lock VM exit is preempted
by a higher priority VM exit. The first patch is to apply Sean's
refactor for vcpu_vmx.exit_reason as a preparation patch for bus lock
VM exit support.

The second patch is the refactor for vcpu->run->flags. Bus lock VM exit
will introduce a new field in the flags to inform the userspace that
there's a bus lock detected in guest. It's also a preparation patch.

The third patch is the concrete enabling working for bus lock VM exit.
Add the support to set the capability to enable bus lock VM exit. The
current implementation is just exiting to userspace when handling the
bus lock detected in guest.

The detail of throttling policy in user space is still to be discussed.
We may enforce ratelimit on bus lock in guest, inject some sleep time,
or... We hope to get more ideas on this.

Document for Bus Lock Detection is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

---

Changelogs

v4->v5:
- rebase on top on v5.10-rc2
- add preparation patch that reset the vcpu->run->flags at the beginning
  of the vcpu_run.(Suggested by Sean)
- set the KVM_RUN_BUS_LOCK for all bus lock exit to avoid checking both
  exit_reason and run->flags
- add the document to introduce the new kvm capability
  (KVM_CAP_X86_BUS_LOCK_EXIT)
- v4:https://lore.kernel.org/lkml/20201012033542.4696-1-chenyi.qiang@intel.com/


v3->v4:
- rebase on top of v5.9
- some code cleanup.
- v3:https://lore.kernel.org/lkml/20200910083751.26686-1-chenyi.qiang@intel.com/

v2->v3:
- use a bitmap to get/set the capability of bus lock detection. we support
  exit and off mode currently.
- put the handle of exiting to userspace in vmx.c, thus no need to
  define a shadow to track vmx->exit_reason.bus_lock_detected.
- remove the vcpu->stats.bus_locks since every bus lock exits to userspace.
- v2:https://lore.kernel.org/lkml/20200817033604.5836-1-chenyi.qiang@intel.com/ 

v1->v2:
- resolve Vitaly's comment to introduce the KVM_EXIT_BUS_LOCK and a
  capability to enable it.
- add the support to exit to user space when handling bus locks.
- extend the vcpu->run->flags to indicate bus lock detected for other
  exit reasons when exiting to user space.
- v1:https://lore.kernel.org/lkml/20200628085341.5107-1-chenyi.qiang@intel.com/

---

Chenyi Qiang (3):
  KVM: X86: Reset the vcpu->run->flags at the beginning of vcpu_run
  KVM: VMX: Enable bus lock VM exit
  KVM: X86: Add the Document for KVM_CAP_X86_BUS_LOCK_EXIT

Sean Christopherson (1):
  KVM: VMX: Convert vcpu_vmx.exit_reason to a union

 Documentation/virt/kvm/api.rst     |  45 ++++++++++++-
 arch/x86/include/asm/kvm_host.h    |   7 ++
 arch/x86/include/asm/vmx.h         |   1 +
 arch/x86/include/asm/vmxfeatures.h |   1 +
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/include/uapi/asm/vmx.h    |   4 +-
 arch/x86/kvm/vmx/capabilities.h    |   6 ++
 arch/x86/kvm/vmx/nested.c          |  42 +++++++-----
 arch/x86/kvm/vmx/vmx.c             | 105 +++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx.h             |  25 ++++++-
 arch/x86/kvm/x86.c                 |  28 +++++++-
 include/uapi/linux/kvm.h           |   5 ++
 12 files changed, 214 insertions(+), 56 deletions(-)

-- 
2.17.1

