Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8DB30DC2F
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 15:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhBCOFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 09:05:34 -0500
Received: from mga06.intel.com ([134.134.136.31]:50299 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231646AbhBCOFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 09:05:32 -0500
IronPort-SDR: J6RfAnz3w2KbZR6c6ww9bgFRo3skTRoUfvdP49C2Es3zwc300ejkBVIxWjhR/7nT8s+KMUmm5c
 CpR9+bJxHFTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="242555093"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="242555093"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 06:03:45 -0800
IronPort-SDR: 1MkfoKdoUismecvhxu1hC99BL3+koMNB4qoNTQZ0hV59SwN7IsNt5R2pa3IzQUm5fqa7/p3sOk
 0yqZMHs+8s1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="371490636"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2021 06:03:43 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: x86/pmu: Guest Architectural LBR Enabling
Date:   Wed,  3 Feb 2021 21:57:10 +0800
Message-Id: <20210203135714.318356-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi geniuses,

Please help review the new version of Arch LBR enabling on
KVM based on the latest kvm/queue tree.

The Architectural Last Branch Records (LBRs) is publiced
in the 319433-040 release of Intel Architecture Instruction
Set Extensions and Future Features Programming Reference[0].

The main advantages for the Arch LBR users are [1]:
- Faster context switching due to XSAVES support and faster reset of
  LBR MSRs via the new DEPTH MSR
- Faster LBR read for a non-PEBS event due to XSAVES support, which
  lowers the overhead of the NMI handler. (For a PEBS event, the LBR
  information is recorded in the PEBS records. There is no impact on
  the PEBS event.)
- Linux kernel can support the LBR features without knowing the model
  number of the current CPU.

Please check more details in each commit and feel free to comment.

[0] https://software.intel.com/content/www/us/en/develop/download/
intel-architecture-instruction-set-extensions-and-future-features-programming-reference.html
[1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/

---
v1->v2 Changelog:
- rebased on the latest kvm/queue tree;
- refine some comments for guest usage;

Previous:
https://lore.kernel.org/kvm/20200731074402.8879-1-like.xu@linux.intel.com/

Like Xu (4):
  KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for Arch LBR
  KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for Arch LBR
  KVM: vmx/pmu: Add Arch LBR emulation and its VMCS field
  KVM: x86: Expose Architectural LBR CPUID and its XSAVES bit

 arch/x86/include/asm/vmx.h      |  4 ++
 arch/x86/kvm/cpuid.c            | 23 ++++++++++
 arch/x86/kvm/vmx/capabilities.h | 25 +++++++----
 arch/x86/kvm/vmx/pmu_intel.c    | 74 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c          | 15 ++++++-
 arch/x86/kvm/vmx/vmx.h          |  3 ++
 arch/x86/kvm/x86.c              | 10 ++++-
 7 files changed, 140 insertions(+), 14 deletions(-)

-- 
2.29.2

