Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E57761930
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 04:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbfGHCGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 22:06:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:44741 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbfGHCGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 22:06:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 19:06:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,464,1557212400"; 
   d="scan'208";a="364083502"
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jul 2019 19:06:17 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v7 00/12] Guest LBR Enabling
Date:   Mon,  8 Jul 2019 09:23:07 +0800
Message-Id: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Last Branch Recording (LBR) is a performance monitor unit (PMU) feature
on Intel CPUs that captures branch related info. This patch series enables
this feature to KVM guests.

Here is a conclusion of the fundamental methods that we use:
1) the LBR feature is enabled per guest via QEMU setting of
   KVM_CAP_X86_GUEST_LBR;
2) the LBR stack is passed through to the guest for direct accesses after
   the guest's first access to any of the lbr related MSRs;
3) the host will help save/resotre the LBR stack when the vCPU is
   scheduled out/in.

ChangeLog:
    pmu.c:
        - patch 4: remove guest_cpuid_is_intel, which can be avoided by
                   directly checking pmu_ops->lbr_enable.
    pmu_intel.c:
        - patch 10: include MSR_LBR_SELECT into is_lbr_msr check, and pass
                    this msr through to the guest, instead of trapping
                    accesses.
        - patch 12: fix the condition check of setting LBRS_FROZEN and
                    COUNTERS_FROZEN;
                    update the global_ovf_ctrl_mask for LBRS_FROZEN and
                    COUNTERS_FROZEN.

previous:
https://lkml.org/lkml/2019/6/6/133

Like Xu (1):
  KVM/x86/vPMU: Add APIs to support host save/restore the guest lbr
    stack

Wei Wang (11):
  perf/x86: fix the variable type of the LBR MSRs
  perf/x86: add a function to get the lbr stack
  KVM/x86: KVM_CAP_X86_GUEST_LBR
  KVM/x86: intel_pmu_lbr_enable
  KVM/x86/vPMU: tweak kvm_pmu_get_msr
  KVM/x86: expose MSR_IA32_PERF_CAPABILITIES to the guest
  perf/x86: no counter allocation support
  perf/x86: save/restore LBR_SELECT on vCPU switching
  KVM/x86/lbr: lazy save the guest lbr stack
  KVM/x86: remove the common handling of the debugctl msr
  KVM/VMX/vPMU: support to report GLOBAL_STATUS_LBRS_FROZEN

 arch/x86/events/core.c            |  12 ++
 arch/x86/events/intel/lbr.c       |  43 ++++-
 arch/x86/events/perf_event.h      |   6 +-
 arch/x86/include/asm/kvm_host.h   |   5 +
 arch/x86/include/asm/perf_event.h |  16 ++
 arch/x86/kvm/cpuid.c              |   2 +-
 arch/x86/kvm/pmu.c                |  29 ++-
 arch/x86/kvm/pmu.h                |  12 +-
 arch/x86/kvm/pmu_amd.c            |   7 +-
 arch/x86/kvm/vmx/pmu_intel.c      | 393 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c            |   4 +-
 arch/x86/kvm/vmx/vmx.h            |   2 +
 arch/x86/kvm/x86.c                |  32 ++--
 include/linux/perf_event.h        |  13 ++
 include/uapi/linux/kvm.h          |   1 +
 kernel/events/core.c              |  37 ++--
 16 files changed, 562 insertions(+), 52 deletions(-)

-- 
2.7.4

