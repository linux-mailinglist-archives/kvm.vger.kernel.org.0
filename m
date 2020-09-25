Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A10B27804D
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 08:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgIYGHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 02:07:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:55277 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbgIYGHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 02:07:50 -0400
IronPort-SDR: lvmoOJ7cxx+OSy93Tf+Jmb2exemsfAS8eFLXRXsKpEj10izfbTfEZlr/KvE6iheJTWdYD8eEGq
 km97jihPb0tA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="160701140"
X-IronPort-AV: E=Sophos;i="5.77,300,1596524400"; 
   d="scan'208";a="160701140"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 23:07:49 -0700
IronPort-SDR: emxH2a79R33KMfvAjN1EI3RhwfEmtTDslXirqzGK0nSKKSmoMPxHhbT1tNJNZuB1NsJK/mwXTs
 NiaREVJhUXzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,300,1596524400"; 
   d="scan'208";a="487325183"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005.jf.intel.com with ESMTP; 24 Sep 2020 23:07:47 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] Add bus lock VM exit support
Date:   Fri, 25 Sep 2020 14:10:00 +0800
Message-Id: <20200925061002.28336-1-chenyi.qiang@intel.com>
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

This first patch applies Sean's refactor for vcpu_vmx.exit_reason
available at https://patchwork.kernel.org/patch/11500659.
It is necessary as bus lock VM exit adds a new modifier bit(bit 26) in
exit_reason field in VMCS.

The second patch is the enabling work for bus lock VM exit. Add the
support to set the capability to enable bus lock vm exit. The current
implementation just exit to user space when handling the bus lock
detected in guest.

The concrete throttling policy in user space is still to be discussed.
We can enforce ratelimit on bus lock in guest, inject some sleep time or
maybe other ideas.

Document for Bus Lock Detection is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

---

Changelogs

v3->v4:
- rebase on top of v5.9-rc6
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

Chenyi Qiang (1):
  KVM: VMX: Enable bus lock VM exit

Sean Christopherson (1):
  KVM: VMX: Convert vcpu_vmx.exit_reason to a union

 arch/x86/include/asm/kvm_host.h    |   7 ++
 arch/x86/include/asm/vmx.h         |   1 +
 arch/x86/include/asm/vmxfeatures.h |   1 +
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/include/uapi/asm/vmx.h    |   4 +-
 arch/x86/kvm/vmx/capabilities.h    |   6 ++
 arch/x86/kvm/vmx/nested.c          |  42 +++++++-----
 arch/x86/kvm/vmx/vmx.c             | 103 +++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx.h             |  25 ++++++-
 arch/x86/kvm/x86.c                 |  29 +++++++-
 include/uapi/linux/kvm.h           |   5 ++
 11 files changed, 172 insertions(+), 52 deletions(-)

-- 
2.17.1

