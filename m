Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B127C107ABF
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKVWkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:61220 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfKVWkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029625"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/13] KVM: x86: Allow userspace to disable the emulator
Date:   Fri, 22 Nov 2019 14:39:46 -0800
Message-Id: <20191122223959.13545-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The primary intent of this series is to dynamically allocate the emulator
and get KVM to a state where the emulator *could* be disabled at some
point in the future.  Actually allowing userspace to disable the emulator
was a minor change at that point, so I threw it in.

Dynamically allocating the emulator shrinks the size of x86 vcpus by
~2.5k bytes, which is important because 'struct vcpu_vmx' has once again
fattened up and squeaked past the PAGE_ALLOC_COSTLY_ORDER threshold.
Moving the emulator to its own allocation gives us some breathing room
for the near future, and has some other nice side effects.

As for disabling the emulator... in the not-too-distant future, I expect
there will be use cases that can truly disable KVM's emulator, e.g. for
security (KVM's and/or the guests).  I don't have a strong opinion on
whether or not KVM should actually allow userspace to disable the emulator
without a concrete use case, which is why that part is done in its own
tiny patch.  I also expect that any real use case would want "no emulator"
to be a per-VM toggle, but since this is basically an experimental feature
I added it as a module param.

Running without an emulator has been "tested" in the sense that the
selftests that don't require emulation continue to pass, and everything
else fails with the expected "emulation error".

Sean Christopherson (13):
  KVM: x86: Refactor I/O emulation helpers to provide vcpu-only variant
  KVM: x86: Explicitly pass an exception struct to check_intercept
  KVM: x86: Move emulation-only helpers to emulate.c
  KVM: x86: Refactor R/W page helper to take the emulation context
  KVM: x86: Refactor emulated exception injection to take the emul
    context
  KVM: x86: Refactor emulate tracepoint to explicitly take context
  KVM: x86: Refactor init_emulate_ctxt() to explicitly take context
  KVM: x86: Dynamically allocate per-vCPU emulation context
  KVM: x86: Move kvm_emulate.h into KVM's private directory
  KVM: x86: Shrink the usercopy region of the emulation context
  KVM: x86: Add helper to "handle" internal emulation error
  KVM: x86: Add variable to control existence of emulator
  KVM: x86: Allow userspace to disable the kernel's emulator

 arch/x86/include/asm/kvm_host.h             |  12 +-
 arch/x86/kvm/emulate.c                      |  17 +-
 arch/x86/{include/asm => kvm}/kvm_emulate.h |   9 +-
 arch/x86/kvm/mmu/mmu.c                      |   1 +
 arch/x86/kvm/svm.c                          |   5 +-
 arch/x86/kvm/trace.h                        |  22 +--
 arch/x86/kvm/vmx/vmx.c                      |  15 +-
 arch/x86/kvm/x86.c                          | 194 ++++++++++++++------
 arch/x86/kvm/x86.h                          |  16 +-
 9 files changed, 189 insertions(+), 102 deletions(-)
 rename arch/x86/{include/asm => kvm}/kvm_emulate.h (99%)

-- 
2.24.0

