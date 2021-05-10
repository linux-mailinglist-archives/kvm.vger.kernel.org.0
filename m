Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92119377DCB
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhEJIRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:17:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:42716 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhEJIRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 04:17:20 -0400
IronPort-SDR: kTwoUV49CSQtICKqzAbwTsEW2M19tUkGb4igNiYrqFqcj05Rr00Kv4Fa3jbsgNgJHwyiFyqetM
 mjCsPXIRrmQQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="178727651"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="178727651"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:16:15 -0700
IronPort-SDR: AdPc4YmQaJF/PrgQns47ijYSAa+cNsQPEOSpQFr1r9goPyObksljui00Ajk2RGFoc90nxbmQJl
 uNZ9IZbIkiXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="408250810"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga002.jf.intel.com with ESMTP; 10 May 2021 01:16:13 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v4 00/10] KVM: x86/pmu: Guest Architectural LBR Enabling
Date:   Mon, 10 May 2021 16:15:24 +0800
Message-Id: <20210510081535.94184-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi geniuses,

A new kernel cycle has begun, and this version looks promising. 

From the end user's point of view, the usage of Arch LBR is the same as
the legacy LBR we have merged in the mainline, but it is much faster.

The Architectural Last Branch Records (LBRs) is published 
in the 319433-040 release of Intel Architecture Instruction
Set Extensions and Future Features Programming Reference[0].

The main advantages for the Arch LBR users are [1]:
- Faster context switching due to XSAVES support and faster reset of
  LBR MSRs via the new DEPTH MSR
- Faster LBR read for a non-PEBS event due to XSAVES support, which
  lowers the overhead of the NMI handler.
- Linux kernel can support the LBR features without knowing the model
  number of the current CPU.

Please check more details in each commit and feel free to comment.

[0] https://software.intel.com/content/www/us/en/develop/download/
intel-architecture-instruction-set-extensions-and-future-features-programming-reference.html
[1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/

---
v13->v13 RESEND Changelog:
- Rebase to kvm/queue tree tag: kvm-5.13-2;
- Includes two XSS dependency patches from kvm/intel tree;

v3->v4 Changelog:
- Add one more host patch to reuse ARCH_LBR_CTL_MASK;
- Add reserve_lbr_buffers() instead of using GFP_ATOMIC;
- Fia a bug in the arch_lbr_depth_is_valid();
- Add LBR_CTL_EN to unify DEBUGCTLMSR_LBR and ARCH_LBR_CTL_LBREN;
- Add vmx->host_lbrctlmsr to save/restore host values;
- Add KVM_SUPPORTED_XSS to refactoring supported_xss;
- Clear Arch_LBR ans its XSS bit if it's not supported;
- Add negative testing to the related kvm-unit-tests;
- Refine code and commit messages;

Previous:
v4: https://lore.kernel.org/kvm/20210314155225.206661-1-like.xu@linux.intel.com/
v3: https://lore.kernel.org/kvm/20210303135756.1546253-1-like.xu@linux.intel.com/

Like Xu (8):
  perf/x86/intel: Fix the comment about guest LBR support on KVM
  perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
  KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for Arch LBR
  KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for Arch LBR
  KVM: vmx/pmu: Add Arch LBR emulation and its VMCS field
  KVM: x86: Expose Architectural LBR CPUID leaf
  KVM: x86: Refine the matching and clearing logic for supported_xss
  KVM: x86: Add XSAVE Support for Architectural LBRs

Sean Christopherson (1):
  KVM: x86: Report XSS as an MSR to be saved if there are supported
    features

Yang Weijiang (1):
  KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS

 arch/x86/events/intel/core.c     |   3 +-
 arch/x86/events/intel/lbr.c      |   6 +-
 arch/x86/include/asm/kvm_host.h  |   1 +
 arch/x86/include/asm/msr-index.h |   1 +
 arch/x86/include/asm/vmx.h       |   4 ++
 arch/x86/kvm/cpuid.c             |  46 ++++++++++++--
 arch/x86/kvm/vmx/capabilities.h  |  25 +++++---
 arch/x86/kvm/vmx/pmu_intel.c     | 103 ++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c           |  50 +++++++++++++--
 arch/x86/kvm/vmx/vmx.h           |   4 ++
 arch/x86/kvm/x86.c               |  19 +++++-
 11 files changed, 226 insertions(+), 36 deletions(-)

-- 
2.31.1

