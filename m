Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27736234062
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731736AbgGaHqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:46:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:55461 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731670AbgGaHqI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:46:08 -0400
IronPort-SDR: P0pTLrC5X5xLd5ERjA6tMkhJlgyVWn8dX9hAHM5E2bzNjcQyMkqjjtm4dBmLl4AfbvxSPxGbaO
 /7nx2oWJCxFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149570521"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="149570521"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 00:46:08 -0700
IronPort-SDR: UpyMh/lK9an/C14G0mcuFItCYfbx42J98CpGfhEs5WwhxLcoUUULVYX086lVu3do3W9g9gCw7V
 4WngttTE+nFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="323160568"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jul 2020 00:46:05 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH 0/6] Guest Architectural LBR Enabling
Date:   Fri, 31 Jul 2020 15:43:56 +0800
Message-Id: <20200731074402.8879-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All (especially developers who use perf in guest),

Please help review the ssuccessor pacthes to enable Arch LBR on KVM.
(The prerequisite v13 LBR patchset [2] seems more eager to get
the attention of reviewers and maintainer).

LBR (Last Branch Records) enables recording of software path history
by logging taken branches and other control flows within architectural
registers. Intel CPUs have had model-specific LBRs for quite some time
but this evolves them into an architectural feature now.

The Architectural Last Branch Records (LBRS) is already publiced
in the 319433-040 release of Intel® Architecture Instruction
Set Extensions and Future Features Programming Reference [0].

The main advantages for the Arch LBR users are [1]:
- Faster context switching due to XSAVES support and faster reset of
  LBR MSRs via the new DEPTH MSR
- Faster LBR read for a non-PEBS event due to XSAVES support, which
  lowers the overhead of the NMI handler. (For a PEBS event, the LBR
  information is recorded in the PEBS records. There is no impact on
  the PEBS event.)
- Linux kernel can support the LBR features without knowing the model
  number of the current CPU.

The Kernel 5.9 will enable Arch LBR on the host based on
tip/perf/core, so this patchset happens to enable it on KVM as well.

Before 'git am' this patchset, you may need merge the latest
tip/perf/core branch and the legacy LBR enabling patches
[PATCH v13 00/10] Guest Last Branch Recording Enabling [2].
or just wait for the above pacthes to be merged upstream.

[0] https://software.intel.com/content/www/us/en/develop/download/
intel-architecture-instruction-set-extensions-and-future-features-programming-reference.html
[1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/
[2] https://lore.kernel.org/kvm/20200726153229.27149-1-like.xu@linux.intel.com/

Please check more details in each commit and feel free to comment.

Like Xu (6):
  KVM: vmx/pmu: Add VMCS field check before exposing LBR_FMT
  perf/x86/lbr: Unify LBR_INFO registers exposure check condition
  KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for Arch LBR
  KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for Arch LBR
  KVM: vmx/pmu: Add Arch LBR emulation and its VMCS field
  KVM: x86: Expose Architectural LBR CPUID and its XSAVES bit

 arch/x86/events/intel/lbr.c     |  4 +-
 arch/x86/include/asm/vmx.h      |  4 ++
 arch/x86/kvm/cpuid.c            | 19 +++++++++
 arch/x86/kvm/vmx/capabilities.h | 16 ++++++-
 arch/x86/kvm/vmx/pmu_intel.c    | 74 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c          | 16 ++++++-
 arch/x86/kvm/vmx/vmx.h          |  3 ++
 arch/x86/kvm/x86.c              |  6 +++
 8 files changed, 133 insertions(+), 9 deletions(-)

-- 
2.21.3

