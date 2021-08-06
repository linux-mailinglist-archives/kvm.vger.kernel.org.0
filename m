Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0A33E23FF
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 09:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243644AbhHFH3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 03:29:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:16349 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243626AbhHFH31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 03:29:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="299913729"
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="299913729"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:29:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="513102278"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Aug 2021 00:29:08 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     root <root@984fee009f2b.jf.intel.com>
Subject: [PATCH v7 00/15] Introduce Architectural LBR for vPMU
Date:   Fri,  6 Aug 2021 15:42:10 +0800
Message-Id: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: root <root@984fee009f2b.jf.intel.com>

The Architectural Last Branch Records (LBRs) is published in the 319433-040
release of Intel Architecture Instruction Set Extensions and Future Features
Programming Reference[0].

The main advantages of Arch LBR are [1]:
- Faster context switching due to XSAVES support and faster reset of
  LBR MSRs via the new DEPTH MSR
- Faster LBR read for a non-PEBS event due to XSAVES support, which
  lowers the overhead of the NMI handler.
- Linux kernel can support the LBR features without knowing the model
  number of the current CPU.

From end user's point of view, the usage of Arch LBR is the same as
the Legacy LBR that has been merged in the mainline.

Note, there's one limitations for current guest Arch LBR implementation:
Guest can only use the same LBR record depth as host, this is due to
the special behavior of MSR_ARCH_LBR_DEPTH: a) On write to the MSR,
it'll reset all Arch LBR recording MSRs to 0s. b) XRSTORS will reset all
recording MSRs to 0s if the saved depth mismatches MSR_ARCH_LBR_DEPTH.

But this limitation won't impact guest perf tool usage.

[0] https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-and-future-features-programming-reference.html
[1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/


Previous version:
v6: https://lkml.kernel.org/kvm/1626425406-18582-1-git-send-email-weijiang.yang@intel.com/

Changes in v7:
1. Added fix patch for nested VM entry failure issue, also fix warnings from reported from L1.
2. Added patches to flip LBREn bit upon guest state changes, e.g., on #SMI, #DB, warm reset.
3. Added kvm unit-test application for Arch LBR.
4. Rebased v6 patches to kernel v5.14-rc4.


Like Xu (6):
  perf/x86/intel: Fix the comment about guest LBR support on KVM
  perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
  KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
  KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest Arch LBR
  KVM: x86: Refine the matching and clearing logic for supported_xss
  KVM: x86: Add XSAVE Support for Architectural LBR

Sean Christopherson (1):
  KVM: x86: Report XSS as an MSR to be saved if there are supported
    features

Yang Weijiang (8):
  KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
  KVM: x86/pmu: Refactor code to support guest Arch LBR
  KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
  KVM: x86/vmx: Check Arch LBR config when return perf capabilities
  KVM: nVMX: Add necessary Arch LBR settings for nested VM
  KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
  KVM: x86/vmx: Flip Arch LBREn bit on guest state change
  KVM: x86/cpuid: Advise Arch LBR feature in CPUID

 arch/x86/events/intel/core.c     |   3 +-
 arch/x86/events/intel/lbr.c      |   6 +-
 arch/x86/include/asm/kvm_host.h  |   1 +
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/include/asm/vmx.h       |   4 +
 arch/x86/kvm/cpuid.c             |  54 +++++++++++++-
 arch/x86/kvm/vmx/capabilities.h  |  25 +++++--
 arch/x86/kvm/vmx/nested.c        |   6 +-
 arch/x86/kvm/vmx/pmu_intel.c     | 122 +++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmcs12.c        |   1 +
 arch/x86/kvm/vmx/vmcs12.h        |   3 +-
 arch/x86/kvm/vmx/vmx.c           |  54 ++++++++++++--
 arch/x86/kvm/x86.c               |  24 +++++-
 13 files changed, 261 insertions(+), 43 deletions(-)

-- 
2.25.1

