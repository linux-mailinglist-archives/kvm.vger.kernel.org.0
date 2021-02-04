Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723FC30D873
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhBCLWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:22:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:28325 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233970AbhBCLWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 06:22:46 -0500
IronPort-SDR: nJYUJ1hUw0sE/6CINFu/oJyXBm/DjWXiGFwm+B4i5TwHEDIo8M6CLS5Z6V+QQuaC/hPi/N3XwZ
 hhtJ3DP/Ng7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="199981235"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="199981235"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 03:22:06 -0800
IronPort-SDR: 4CwbJBiVuhCqSMw5YwctAc1JDpfNvzeY0EsZquY01+60QuHSBNKdG9QPE4NkimN5J3MVal+fiL
 mHZzIEH+bipA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="480311057"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 03:22:04 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v15 00/14] Introduce support for guest CET feature
Date:   Wed,  3 Feb 2021 19:34:07 +0800
Message-Id: <20210203113421.5759-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Control-flow Enforcement Technology (CET) provides protection against
Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
subfeatures: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
SHSTK is to prevent ROP and IBT is to prevent JOP.

Several parts in KVM have been updated to provide guest CET support, including:
CPUID/XSAVES settings, MSR passthrough, user-space MSR access interface, 
vmentry/vmexit config, nested VM etc. These patches are dependent on CET
kernel patches for XSAVES support and CET definitions, e.g., MSR and related
feature flags.

CET kernel patches: refer to [1], [2].

Previous CET KVM patches: refer to [3].

CET QEMU patches: refer to [4].

CET KVM unit-test patch: refer to [5].

[1]: CET Shadow Stack patches v18:
https://lkml.kernel.org/linux-api/20210127212524.10188-1-yu-cheng.yu@intel.com/

[2]: Indirect Branch Tracking patches v18:
https://lkml.kernel.org/linux-api/20210127213028.11362-1-yu-cheng.yu@intel.com/

[3]: CET KVM patches v14:
https://lkml.kernel.org/kvm/20201106011637.14289-1-weijiang.yang@intel.com/

[4]: CET QEMU patches:
https://patchwork.ozlabs.org/project/qemu-devel/patch/20201013051935.6052-2-weijiang.yang@intel.com/

[5]: CET KVM unit-test patch:
https://patchwork.kernel.org/project/kvm/patch/20200506082110.25441-12-weijiang.yang@intel.com/

Changes in v15:
- Changed patches per Paolo's review feedback on v14.
- Added a new patch for GUEST_SSP save/restore in guest SMM case.
- Fixed guest call-trace issue due to CET MSR interception.
- Removed unnecessary guest CET state cleanup in VMCS.
- Rebased patches to 5.11-rc6.


Sean Christopherson (2):
  KVM: x86: Report XSS as an MSR to be saved if there are supported
    features
  KVM: x86: Load guest fpu state when accessing MSRs managed by XSAVES

Yang Weijiang (12):
  KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
  KVM: x86: Add #CP support in guest exception dispatch
  KVM: VMX: Introduce CET VMCS fields and flags
  KVM: x86: Add fault checks for CR4.CET
  KVM: VMX: Emulate reads and writes to CET MSRs
  KVM: VMX: Add a synthetic MSR to allow userspace VMM to access
    GUEST_SSP
  KVM: x86: Report CET MSRs as to-be-saved if CET is supported
  KVM: x86: Enable CET virtualization for VMX and advertise CET to
    userspace
  KVM: VMX: Pass through CET MSRs to the guest when supported
  KVM: nVMX: Add helper to check the vmcs01 MSR bitmap for MSR
    pass-through
  KVM: nVMX: Enable CET support for nested VMX
  KVM: x86: Save/Restore GUEST_SSP to/from SMRAM

 arch/x86/include/asm/kvm_host.h      |   4 +-
 arch/x86/include/asm/vmx.h           |   8 ++
 arch/x86/include/uapi/asm/kvm.h      |   1 +
 arch/x86/include/uapi/asm/kvm_para.h |   1 +
 arch/x86/kvm/cpuid.c                 |  26 +++-
 arch/x86/kvm/emulate.c               |  11 ++
 arch/x86/kvm/vmx/capabilities.h      |   5 +
 arch/x86/kvm/vmx/nested.c            |  57 ++++++--
 arch/x86/kvm/vmx/vmcs12.c            |   6 +
 arch/x86/kvm/vmx/vmcs12.h            |  14 +-
 arch/x86/kvm/vmx/vmx.c               | 202 ++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c                   |  67 ++++++++-
 arch/x86/kvm/x86.h                   |  10 +-
 13 files changed, 387 insertions(+), 25 deletions(-)

-- 
2.26.2

