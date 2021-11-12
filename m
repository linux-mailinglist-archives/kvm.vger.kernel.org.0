Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B9C44EA79
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbhKLPkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:40:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:34471 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235315AbhKLPkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:40:33 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233093140"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="233093140"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:37:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="453182022"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2021 07:37:34 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     xiaoyao.li@intel.com, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 00/11] KVM: x86: TDX preparation of introducing vm_type and blocking ioctls based on vm_type
Date:   Fri, 12 Nov 2021 23:37:22 +0800
Message-Id: <20211112153733.2767561-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is split from the TDX series[1].

It introduces vm_type for x86 at Patch 1, which leaves vaule 0 for normal
VM and adds a new type KVM_X86_TDX_VM for upcoming TDX guest. Following
patches (2, 4 - 11) block the ioctls that doesn't support for TDX from
userspace for TDX by checking the VM type.

Patch 3 is a cleanup.

Note, it doesn't block the ioctls for SEV-ES at all because I'm not sure
if each one applied to SEV-ES or not. Folks can introduce new vm_type for
SEV-* and extend each helper function kvm_xxx_feature_disallowed() for
SEV-* vm type. 

Paolo,

Please let us know if you want this series sent together with whole
TDX support.

[1] https://lore.kernel.org/all/cover.1625186503.git.isaku.yamahata@intel.com/T/#u

Isaku Yamahata (1):
  KVM: Disallow read-only memory for x86 TDX

Kai Huang (1):
  KVM: x86: Disable in-kernel I/O APIC and level routes for TDX

Sean Christopherson (6):
  KVM: x86: Introduce vm_type to differentiate normal VMs from
    confidential VMs
  KVM: x86: Disable direct IRQ injection for TDX
  KVM: x86: Disable MCE related stuff for TDX
  KVM: x86: Disallow tsc manipulation for TDX
  KVM: x86: Block ioctls to access guest state for TDX
  KVM: Disallow dirty logging for x86 TDX

Xiaoyao Li (3):
  KVM: x86: Clean up kvm_vcpu_ioctl_x86_setup_mce()
  KVM: x86: Disable SMM for TDX
  KVM: x86: Disable INIT/SIPI for TDX

 Documentation/virt/kvm/api.rst        |  15 ++
 arch/x86/include/asm/kvm-x86-ops.h    |   1 +
 arch/x86/include/asm/kvm_host.h       |   2 +
 arch/x86/include/uapi/asm/kvm.h       |   3 +
 arch/x86/kvm/ioapic.c                 |   5 +
 arch/x86/kvm/irq_comm.c               |  13 +-
 arch/x86/kvm/lapic.c                  |   3 +-
 arch/x86/kvm/svm/svm.c                |   6 +
 arch/x86/kvm/vmx/vmx.c                |   6 +
 arch/x86/kvm/x86.c                    | 199 +++++++++++++++++++++-----
 arch/x86/kvm/x86.h                    |  35 +++++
 include/linux/kvm_host.h              |   2 +
 include/uapi/linux/kvm.h              |   1 +
 tools/arch/x86/include/uapi/asm/kvm.h |   3 +
 tools/include/uapi/linux/kvm.h        |   1 +
 virt/kvm/kvm_main.c                   |  25 +++-
 16 files changed, 278 insertions(+), 42 deletions(-)

-- 
2.27.0

