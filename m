Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F5A245B0F
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 05:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgHQDeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 23:34:03 -0400
Received: from mga04.intel.com ([192.55.52.120]:53823 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgHQDeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 23:34:03 -0400
IronPort-SDR: YIEa31w2swtxAqRNFC2VcIuSpRjC1bc2I1laB9FVuIoqlFZeNEighA1RlH2eA51OEHD9el+0Bx
 bHC9g54/ePfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="152033205"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="152033205"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2020 20:34:02 -0700
IronPort-SDR: PltlBRmDYfP48D4atAeBMnSdSCFuNuJtAkGrZLnksfFXSV/qsc/iEobDyooZkb6XAUgGi1yR2C
 PrCS7L9mYB/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="400075235"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by fmsmga001.fm.intel.com with ESMTP; 16 Aug 2020 20:34:00 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND RFC v2 0/2] add bus lock VM exit support
Date:   Mon, 17 Aug 2020 11:36:02 +0800
Message-Id: <20200817033604.5836-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Resend to rebase on 5.9-rc1.

---

Add the support for bus lock VM exit in KVM. It is a sub-feature of bus
lock detection. Another sub-feature named bus lock debug exception is
blocked due to requirement to rework the HW design:
https://lore.kernel.org/lkml/87r1stmi1x.fsf@nanos.tec.linutronix.de/

In this patch series, the first patch applies Sean's refactor to
vcpu_vmx.exit_reason available at
https://patchwork.kernel.org/patch/11500659.
It is necessary as bus lock VM exit adds a new modifier bit(bit 26) in
exit_reason field in VMCS.

The second patch is the enabling work for bus lock VM exit. Add the
support to set the capability to enable bus lock vm exit. The current
implementation just exit to user space when handling the bus lock
detected in guest.

The concrete throttling policy in user space still needs to be
discussed. We can enforce ratelimit on bus lock in guest, just inject
some sleep time, or any other ideas?

Document for Bus Lock Detection is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html


v1->v2 Changelogs:
- resolve Vitaly's comment to introduce the KVM_EXIT_BUS_LOCK and a
  capability to enable it.
- add the support to exit to user space when handling bus locks.
- extend the vcpu->run->flags to indicate bus lock detected for other
  exit reasons when exiting to user space.

Chenyi Qiang (1):
  KVM: VMX: Enable bus lock VM exit

Sean Christopherson (1):
  KVM: VMX: Convert vcpu_vmx.exit_reason to a union

 arch/x86/include/asm/kvm_host.h    |  9 +++
 arch/x86/include/asm/vmx.h         |  1 +
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  1 +
 arch/x86/include/uapi/asm/vmx.h    |  4 +-
 arch/x86/kvm/vmx/capabilities.h    |  6 ++
 arch/x86/kvm/vmx/nested.c          | 42 ++++++++-----
 arch/x86/kvm/vmx/vmx.c             | 97 ++++++++++++++++++++----------
 arch/x86/kvm/vmx/vmx.h             | 25 +++++++-
 arch/x86/kvm/x86.c                 | 36 ++++++++++-
 arch/x86/kvm/x86.h                 |  5 ++
 include/uapi/linux/kvm.h           |  2 +
 12 files changed, 179 insertions(+), 50 deletions(-)

-- 
2.17.1

