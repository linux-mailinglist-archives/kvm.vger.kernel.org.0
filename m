Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433DC32C637
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351473AbhCDA2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:28:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:43761 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236519AbhCCOHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 09:07:33 -0500
IronPort-SDR: 9C8E4IaBV2kj7QWL1rcfhaZyHm9BhYqJnUxwyq2SPRkhg/rl/SSk4OOiFrGiO9QegGKXW/xoKM
 JSi+cdHRsGeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="183818811"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="183818811"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 06:05:09 -0800
IronPort-SDR: 3nDB5CeV1duZECtnvPtLokAJ0U+5IhSeIT7jJWM8qQ+5Agpkmk4po+VdNzVfz4/mumv8wQ7bYC
 FmkQ5o5QGjKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="399729229"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2021 06:05:05 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v3 0/9] KVM: x86/pmu: Guest Architectural LBR Enabling
Date:   Wed,  3 Mar 2021 21:57:46 +0800
Message-Id: <20210303135756.1546253-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi geniuses,

Please help review the new version of Arch LBR enabling patch set.

The Architectural Last Branch Records (LBRs) is publiced
in the 319433-040 release of Intel Architecture Instruction
Set Extensions and Future Features Programming Reference[0].

The main advantages for the Arch LBR users are [1]:
- Faster context switching due to XSAVES support and faster reset of
  LBR MSRs via the new DEPTH MSR
- Faster LBR read for a non-PEBS event due to XSAVES support, which
  lowers the overhead of the NMI handler.
- Linux kernel can support the LBR features without knowing the model
  number of the current CPU.

It's based on the kvm/queue tree plus two commits from kvm/intel tree:
- 'fea4ab260645 ("KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS")'
- '0ccd14126cb2 ("KVM: x86: Report XSS as an MSR to be saved if there are supported features")'

Please check more details in each commit and feel free to comment.

[0] https://software.intel.com/content/www/us/en/develop/download/
intel-architecture-instruction-set-extensions-and-future-features-programming-reference.html
[1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/

---
v2->v3 Changelog:
- Add host patches (0001-0004) to support guest Arch LBR;
- Fix arch_lbr_depth_is_valid() check condition; [Sean]
- Fix usage of KVM_ARCH_LBR_CTL_MASK;
- Fix intel_pmu_legacy_freezing_lbrs_on_pmi();
- Reset GUEST_IA32_LBR_CTL in the vmx_vcpu_reset();
- Refine intel_pmu_lbr_is_compatible();
- Simplify lbr_enable check and its usage;
- Add Arch LBR msrs to is_valid_passthrough_msr();
- Make XSAVE support for Arch LBR as a separate patch;

Previous:
https://lore.kernel.org/kvm/20210203135714.318356-1-like.xu@linux.intel.com/

Like Xu (9):
  perf/x86/intel: Fix a comment about guest LBR support
  perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
  perf/x86/lbr: Skip checking for the existence of LBR_TOS for Arch LBR
  perf/x86/lbr: Use GFP_ATOMIC for cpuc->lbr_xsave memory allocation
  KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for Arch LBR
  KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for Arch LBR
  KVM: vmx/pmu: Add Arch LBR emulation and its VMCS field
  KVM: x86: Expose Architectural LBR CPUID leaf
  KVM: x86: Add XSAVE Support for Architectural LBRs

 arch/x86/events/intel/core.c    |  5 +-
 arch/x86/events/intel/lbr.c     |  6 +-
 arch/x86/include/asm/vmx.h      |  4 ++
 arch/x86/kvm/cpuid.c            | 25 ++++++++-
 arch/x86/kvm/vmx/capabilities.h | 25 ++++++---
 arch/x86/kvm/vmx/pmu_intel.c    | 99 +++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c          | 22 +++++++-
 arch/x86/kvm/vmx/vmx.h          |  3 +
 arch/x86/kvm/x86.c              |  2 +
 9 files changed, 164 insertions(+), 27 deletions(-)

-- 
2.29.2

