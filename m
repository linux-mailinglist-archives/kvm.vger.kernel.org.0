Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2503D1D8D
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 07:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhGVFBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 01:01:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:13805 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhGVFBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 01:01:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="191845634"
X-IronPort-AV: E=Sophos;i="5.84,260,1620716400"; 
   d="scan'208";a="191845634"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 22:42:21 -0700
X-IronPort-AV: E=Sophos;i="5.84,260,1620716400"; 
   d="scan'208";a="512372243"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 22:42:17 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V9 00/18] KVM: x86/pmu: Add *basic* support to enable guest PEBS via DS
Date:   Thu, 22 Jul 2021 13:41:41 +0800
Message-Id: <20210722054159.4459-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest Precise Event Based Sampling (PEBS) feature can provide an
architectural state of the instruction executed after the guest instruction
that exactly caused the event. It needs new hardware facility only available
on Intel Ice Lake Server platforms. This patch set enables the basic PEBS
feature for KVM guests on ICX.

We can use PEBS feature on the Linux guest like native:

   # echo 0 > /proc/sys/kernel/watchdog (on the host)
   # perf record -e instructions:ppp ./br_instr a
   # perf record -c 100000 -e instructions:pp ./br_instr a

To emulate guest PEBS facility for the above perf usages,
we need to implement 2 code paths:

1) Fast path

This is when the host assigned physical PMC has an identical index as the
virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
This path is used in most common use cases.

2) Slow path

This is when the host assigned physical PMC has a different index from the
virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0) In this case,
KVM needs to rewrite the PEBS records to change the applicable counter indexes
to the virtual PMC indexes, which would otherwise contain the physical counter
index written by PEBS facility, and switch the counter reset values to the
offset corresponding to the physical counter indexes in the DS data structure.

The previous version [0] enables both fast path and slow path, which seems
a bit more complex as the first step. In this patchset, we want to start with
the fast path to get the basic guest PEBS enabled while keeping the slow path
disabled. More focused discussion on the slow path [1] is planned to be put to
another patchset in the next step.

Compared to later versions in subsequent steps, the functionality to support
host-guest PEBS both enabled and the functionality to emulate guest PEBS when
the counter is cross-mapped are missing in this patch set
(neither of these are typical scenarios).

With the basic support, the guest can retrieve the correct PEBS information from
its own PEBS records on the Ice Lake servers. And we expect it should work when
migrating to another Ice Lake and no regression about host perf is expected.

Here are the results of pebs test from guest/host for same workload:

perf report on guest:
# Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1473377250 # Overhead  Command   Shared Object      Symbol
   57.74%  br_instr  br_instr           [.] lfsr_cond
   41.40%  br_instr  br_instr           [.] cmp_end
    0.21%  br_instr  [kernel.kallsyms]  [k] __lock_acquire

perf report on host:
# Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1462721386 # Overhead  Command   Shared Object     Symbol
   57.90%  br_instr  br_instr          [.] lfsr_cond
   41.95%  br_instr  br_instr          [.] cmp_end
    0.05%  br_instr  [kernel.vmlinux]  [k] lock_acquire
    Conclusion: the profiling results on the guest are similar tothat on the host.

A minimum guest kernel version may be v5.4 or a backport version support
Icelake server PEBS.

Please check more details in each commit and feel free to comment.

Previous:
https://lkml.org/lkml/2021/7/16/214

[0]
https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/
[1]
https://lore.kernel.org/kvm/20210115191113.nktlnmivc3edstiv@two.firstfloor.org/

V8 -> V9 Changelog:
-fix a brackets error in xen_guest_state()

V7 -> V8 Changelog:
- fix coding style, add {} for single statement of multiple lines(Peter Z)
- fix coding style in xen_guest_state() (Boris Ostrovsky)
- s/pmu/kvm_pmu/ in intel_guest_get_msrs() (Peter Z)
- put lower cost branch in the first place for x86_pmu_handle_guest_pebs() (Peter Z)

V6 -> V7 Changelog:
- Fix conditions order and call x86_pmu_handle_guest_pebs() unconditionally; (PeterZ)
- Add a new patch to make all that perf_guest_cbs stuff suck less; (PeterZ)
- Document IA32_MISC_ENABLE[7] that that behavior matches bare metal; (Sean & Venkatesh)
- Update commit message for fixed counter mask refactoring;(PeterZ)
- Clarifying comments about {.host and .guest} for intel_guest_get_msrs(); (PeterZ)
- Add pebs_capable to store valid PEBS_COUNTER_MASK value; (PeterZ)
- Add more comments for perf's precise_ip field; (Andi & PeterZ)
- Refactor perf_overflow_handler_t and make it more legible; (PeterZ)
- Use "(unsigned long)cpuc->ds" instead of __this_cpu_read(cpu_hw_events.ds); (PeterZ)
- Keep using "(struct kvm_pmu *)data" to follow K&R; (Andi)

Like Xu (17):
  perf/core: Use static_call to optimize perf_guest_info_callbacks
  perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
  perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
  perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
  KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
  KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
  KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
  KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
  KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
  KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
  KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
  KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
  KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
  KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
  KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
  KVM: x86/cpuid: Refactor host/guest CPU model consistency check
  KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64

Peter Zijlstra (Intel) (1):
  x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value

 arch/arm/kernel/perf_callchain.c   |  16 +--
 arch/arm64/kernel/perf_callchain.c |  29 +++--
 arch/arm64/kvm/perf.c              |  22 ++--
 arch/csky/kernel/perf_callchain.c  |   4 +-
 arch/nds32/kernel/perf_event_cpu.c |  16 +--
 arch/riscv/kernel/perf_callchain.c |   4 +-
 arch/x86/events/core.c             |  44 ++++++--
 arch/x86/events/intel/core.c       | 165 +++++++++++++++++++++++------
 arch/x86/events/perf_event.h       |   6 +-
 arch/x86/include/asm/kvm_host.h    |  18 +++-
 arch/x86/include/asm/msr-index.h   |   6 ++
 arch/x86/include/asm/perf_event.h  |   5 +-
 arch/x86/kvm/cpuid.c               |  24 ++---
 arch/x86/kvm/cpuid.h               |   5 +
 arch/x86/kvm/pmu.c                 |  60 ++++++++---
 arch/x86/kvm/pmu.h                 |  38 +++++++
 arch/x86/kvm/vmx/capabilities.h    |  26 +++--
 arch/x86/kvm/vmx/pmu_intel.c       | 116 ++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c             |  24 ++++-
 arch/x86/kvm/vmx/vmx.h             |   2 +-
 arch/x86/kvm/x86.c                 |  51 +++++----
 arch/x86/xen/pmu.c                 |  33 +++---
 include/linux/perf_event.h         |  12 ++-
 kernel/events/core.c               |   9 ++
 24 files changed, 545 insertions(+), 190 deletions(-)

-- 
2.27.0

