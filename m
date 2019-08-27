Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4BCB9F55E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 23:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbfH0Vkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 17:40:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:50844 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbfH0Vkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 17:40:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 14:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="182919738"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2019 14:40:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 00/14] KVM: x86: Remove emulation_result enums
Date:   Tue, 27 Aug 2019 14:40:26 -0700
Message-Id: <20190827214040.18710-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the emulator and its users to handle failure scenarios entirely
within the emulator.

{x86,kvm}_emulate_instruction() currently returns a tri-state value to
indicate success/continue, userspace exit needed, and failure.  The
intent of returning EMULATE_FAIL is to let the caller handle failure in
a manner that is appropriate for the current context.  In practice,
the emulator has ended up with a mixture of failure handling, i.e.
whether or not the emulator takes action on failure is dependent on the
specific flavor of emulation.

The mixed handling has proven to be rather fragile, e.g. many flows
incorrectly assume their specific flavor of emulation cannot fail or
that the emulator sets state to report the failure back to userspace.

Move everything inside the emulator, piece by piece, so that the
emulation routines can return '0' for exit to userspace and '1' for
resume the guest, just like every other VM-Exit handler.

Patch 13/14 is a tangentially related bug fix that conflicts heavily with
this series, so I tacked it on here.

Patch 14/14 documents the emulation types.  I added it as a separate
patch at the very end so that the comments could reference the final
state of the code base, e.g. incorporate the rule change for using
EMULTYPE_SKIP that is introduced in patch 13/14.

v1:
  - https://patchwork.kernel.org/cover/11110331/

v2:
  - Collect reviews. [Vitaly and Liran]
  - Squash VMware emultype changes into a single patch. [Liran]
  - Add comments in VMX/SVM for VMware #GP handling. [Vitaly]
  - Tack on the EPT misconfig bug fix.
  - Add a patch to comment/document the emultypes. [Liran]

Sean Christopherson (14):
  KVM: x86: Relocate MMIO exit stats counting
  KVM: x86: Clean up handle_emulation_failure()
  KVM: x86: Refactor kvm_vcpu_do_singlestep() to remove out param
  KVM: x86: Don't attempt VMWare emulation on #GP with non-zero error
    code
  KVM: x86: Move #GP injection for VMware into x86_emulate_instruction()
  KVM: x86: Add explicit flag for forced emulation on #UD
  KVM: x86: Move #UD injection for failed emulation into emulation code
  KVM: x86: Exit to userspace on emulation skip failure
  KVM: x86: Handle emulation failure directly in kvm_task_switch()
  KVM: x86: Move triple fault request into RM int injection
  KVM: VMX: Remove EMULATE_FAIL handling in handle_invalid_guest_state()
  KVM: x86: Remove emulation_result enums, EMULATE_{DONE,FAIL,USER_EXIT}
  KVM: VMX: Handle single-step #DB for EMULTYPE_SKIP on EPT misconfig
  KVM: x86: Add comments to document various emulation types

 arch/x86/include/asm/kvm_host.h |  40 +++++++--
 arch/x86/kvm/mmu.c              |  16 +---
 arch/x86/kvm/svm.c              |  62 ++++++--------
 arch/x86/kvm/vmx/vmx.c          | 147 +++++++++++++-------------------
 arch/x86/kvm/x86.c              | 133 ++++++++++++++++-------------
 arch/x86/kvm/x86.h              |   2 +-
 6 files changed, 195 insertions(+), 205 deletions(-)

-- 
2.22.0

