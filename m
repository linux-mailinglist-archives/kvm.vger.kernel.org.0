Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A473C21D2
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 11:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhGIJxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 05:53:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:54426 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhGIJxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 05:53:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="295316490"
X-IronPort-AV: E=Sophos;i="5.84,226,1620716400"; 
   d="scan'208";a="295316490"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 02:51:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,226,1620716400"; 
   d="scan'208";a="498856272"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jul 2021 02:51:02 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, wei.w.wang@intel.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 00/13] Introduce Architectural LBR for vPMU
Date:   Fri,  9 Jul 2021 18:04:58 +0800
Message-Id: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

[0] https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-and-future-features-programming-reference.html
[1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/

Note: to make the patchset buildable with kernel tree, this series includes 3 queued
CET patches from Paolo's queued branch.

Previous version:
v4:
https://lkml.kernel.org/kvm/20210510081535.94184-1-like.xu@linux.intel.com/

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

Yang Weijiang (6):
  KVM: x86: Add arch LBR MSRs to msrs_to_save_all list
  KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL state
  KVM: x86/pmu: Refactor code to support guest Arch LBR
  KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
  KVM: x86/vmx: Check Arch LBR config  when return perf capabilities
  KVM: x86/cpuid: Advise Arch LBR feature in CPUID

 arch/x86/events/intel/core.c     |   3 +-
 arch/x86/events/intel/lbr.c      |   6 +-
 arch/x86/include/asm/kvm_host.h  |   1 +
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/include/asm/vmx.h       |   4 ++
 arch/x86/kvm/cpuid.c             |  44 ++++++++++--
 arch/x86/kvm/vmx/capabilities.h  |  25 ++++---
 arch/x86/kvm/vmx/pmu_intel.c     | 114 +++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c           |  50 ++++++++++++--
 arch/x86/kvm/vmx/vmx.h           |   4 ++
 arch/x86/kvm/x86.c               |  24 ++++++-
 11 files changed, 237 insertions(+), 39 deletions(-)

-- 
2.21.1

