Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A9136DAF
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 09:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfFFHoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 03:44:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:24992 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFHoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 03:44:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:44:24 -0700
X-ExtLoop1: 1
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 00:44:21 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v6 00/12] Guest LBR Enabling
Date:   Thu,  6 Jun 2019 15:02:19 +0800
Message-Id: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
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
    - perf/x86:
        - Patch 7:
                - define "no counter" as a new PERF_EV cap and keep it
                  used in the kernel, instead of esposing it in the user
                  ABI (if defined in perf_event_attr)
                - add a new API, perf_event_create, which can be used to
                  create a perf event without counter assignment (e.g.
                  a perf event simply to get the perf core's help of
                  switching lbr stack on thread switching, please see
                  patch 8)
    - KVM/vPMU:
	- Patch 8: use perf_event_create to create a perf event without
                   the need of a perf counter
	- Patch 12: set the GLOBAL_STATUS_COUNTERS_FROZEN bit when
                   injecting a vPMI.
previous:
	https://lkml.org/lkml/2019/2/14/210

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
 arch/x86/kvm/cpuid.h              |   8 +
 arch/x86/kvm/pmu.c                |  29 ++-
 arch/x86/kvm/pmu.h                |  12 +-
 arch/x86/kvm/pmu_amd.c            |   7 +-
 arch/x86/kvm/vmx/pmu_intel.c      | 397 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c            |   4 +-
 arch/x86/kvm/vmx/vmx.h            |   2 +
 arch/x86/kvm/x86.c                |  32 +--
 include/linux/perf_event.h        |  13 ++
 include/uapi/linux/kvm.h          |   1 +
 kernel/events/core.c              |  37 ++--
 17 files changed, 574 insertions(+), 52 deletions(-)

-- 
2.7.4

