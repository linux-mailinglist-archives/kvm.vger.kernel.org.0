Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A789428AC8E
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 05:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgJLDdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 23:33:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:62770 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbgJLDdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Oct 2020 23:33:33 -0400
IronPort-SDR: NCP7zwpDyJfGpqtjqBMPAvrywDOMs2I/4USfx2fjw6CgB1bYwi1JrTEm/mL2ukVoY5VJDrZt/k
 1GWvDpmm0k5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9771"; a="163046217"
X-IronPort-AV: E=Sophos;i="5.77,365,1596524400"; 
   d="scan'208";a="163046217"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2020 20:33:31 -0700
IronPort-SDR: I4kBjAynaAr6A8rjDbaP6xW9BLdI7JcpeqY7/MH778QiFWLbJ8RS12E/HvdYKaLk02EziWOFiF
 DQ0MvsYVhM9Q==
X-IronPort-AV: E=Sophos;i="5.77,365,1596524400"; 
   d="scan'208";a="529780076"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2020 20:33:28 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v4 0/2] Add bus lock VM exit support
Date:   Mon, 12 Oct 2020 11:35:40 +0800
Message-Id: <20201012033542.4696-1-chenyi.qiang@intel.com>
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

