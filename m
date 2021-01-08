Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2270E2EED9C
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 07:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbhAHGxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 01:53:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:45891 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbhAHGxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 01:53:15 -0500
IronPort-SDR: evJpOUl1qTWeW74AbrMiSgXs3Jgn2nWA2VURMbK20uWg9hmWdFf1TF/1pOHBs4Ajc4/IRyxYQe
 j4wg1hGNJIUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="164628707"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="164628707"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 22:52:31 -0800
IronPort-SDR: PTIsgJy2yblsUzrrYnvAAM4Fzh0srEgdQnKRopIlH6MLJVfQheFDCBKRi6T1mA9AsebcHLBp10
 UQbWoV9K91Jw==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="570660387"
Received: from chenyi-pc.sh.intel.com ([10.239.159.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 22:52:30 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v5 0/4] Add bus lock VM exit support
Date:   Fri,  8 Jan 2021 14:55:26 +0800
Message-Id: <20210108065530.2135-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Resend a rebased version. Hope to receive your comments.

---

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

v5->v5:
- rebase on top of v5.11-rc1
- no difference compared with the last version
- v5:https://lore.kernel.org/lkml/20201106090315.18606-1-chenyi.qiang@intel.com/

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

