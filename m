Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D2A360038
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 05:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhDODUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 23:20:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:1119 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhDODUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 23:20:44 -0400
IronPort-SDR: MvtThNtlQbDIBqgp0OMkHAsK5PywN3eZ3bRp6GVDkbolpFm9AMcRf+DVXQU8otXgTojmwwrvuZ
 f9LTA9h4BaRg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="191592800"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="191592800"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 20:20:22 -0700
IronPort-SDR: rUVRvKC/Gm3Y4LS+iYj8dSpAzd5yzaHoxZL634jMBaF2PjGggWq3JduNDB7CQvIhw15ZY6uyU1
 Kmv8mFkj9MFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425013845"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2021 20:20:18 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v5 00/16] KVM: x86/pmu: Add basic support to enable guest PEBS via DS
Date:   Thu, 15 Apr 2021 11:20:00 +0800
Message-Id: <20210415032016.166201-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest Precise Event Based Sampling (PEBS) feature can provide
an architectural state of the instruction executed after the guest
instruction that exactly caused the event. It needs new hardware
facility only available on Intel Ice Lake Server platforms. This
patch set enables the basic PEBS feature for KVM guests on ICX.

We can use PEBS feature on the Linux guest like native:

  # perf record -e instructions:ppp ./br_instr a
  # perf record -c 100000 -e instructions:pp ./br_instr a

To emulate guest PEBS facility for the above perf usages,
we need to implement 2 code paths:

1) Fast path

This is when the host assigned physical PMC has an identical index as
the virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
This path is used in most common use cases.

2) Slow path

This is when the host assigned physical PMC has a different index
from the virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0)
In this case, KVM needs to rewrite the PEBS records to change the
applicable counter indexes to the virtual PMC indexes, which would
otherwise contain the physical counter index written by PEBS facility,
and switch the counter reset values to the offset corresponding to
the physical counter indexes in the DS data structure.

The previous version [0] enables both fast path and slow path, which
seems a bit more complex as the first step. In this patchset, we want
to start with the fast path to get the basic guest PEBS enabled while
keeping the slow path disabled. More focused discussion on the slow
path [1] is planned to be put to another patchset in the next step.

Compared to later versions in subsequent steps, the functionality
to support host-guest PEBS both enabled and the functionality to
emulate guest PEBS when the counter is cross-mapped are missing
in this patch set (neither of these are typical scenarios).

With the basic support, the guest can retrieve the correct PEBS
information from its own PEBS records on the Ice Lake servers.
And we expect it should work when migrating to another Ice Lake
and no regression about host perf is expected.

Here are the results of pebs test from guest/host for same workload:

perf report on guest:
# Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1473377250
# Overhead  Command   Shared Object      Symbol
  57.74%  br_instr  br_instr           [.] lfsr_cond
  41.40%  br_instr  br_instr           [.] cmp_end
   0.21%  br_instr  [kernel.kallsyms]  [k] __lock_acquire

perf report on host:
# Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1462721386
# Overhead  Command   Shared Object     Symbol
  57.90%  br_instr  br_instr          [.] lfsr_cond
  41.95%  br_instr  br_instr          [.] cmp_end
   0.05%  br_instr  [kernel.vmlinux]  [k] lock_acquire
   Conclusion: the profiling results on the guest are similar tothat on the host.

A minimum guest kernel version may be v5.4 or a backport version
support Icelake server PEBS.

Please check more details in each commit and feel free to comment.

Previous:
https://lore.kernel.org/kvm/20210329054137.120994-1-like.xu@linux.intel.com/

[0] https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/
[1] https://lore.kernel.org/kvm/20210115191113.nktlnmivc3edstiv@two.firstfloor.org/

v4->v5 Changelog:
- Rewrite intel_guest_get_msrs() to address Peter's comments;
- Fix coding style including indentation and {};
- Use __test_and_set_bit in the kvm_perf_overflow_intr();
- Return void for x86_pmu_handle_guest_pebs();
- Always drain pebs buffer on the host side;

Like Xu (16):
  perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
  perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
  perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
  KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
  KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
  KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
  KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
  KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
  KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
  KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
  KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
  KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
  KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
  KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
  KVM: x86/cpuid: Refactor host/guest CPU model consistency check
  KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64

 arch/x86/events/core.c            |   5 +-
 arch/x86/events/intel/core.c      | 130 ++++++++++++++++++++++++------
 arch/x86/events/perf_event.h      |   5 +-
 arch/x86/include/asm/kvm_host.h   |  16 ++++
 arch/x86/include/asm/msr-index.h  |   6 ++
 arch/x86/include/asm/perf_event.h |   5 +-
 arch/x86/kvm/cpuid.c              |  24 ++----
 arch/x86/kvm/cpuid.h              |   5 ++
 arch/x86/kvm/pmu.c                |  50 +++++++++---
 arch/x86/kvm/pmu.h                |  38 +++++++++
 arch/x86/kvm/vmx/capabilities.h   |  26 ++++--
 arch/x86/kvm/vmx/pmu_intel.c      | 115 +++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c            |  24 +++++-
 arch/x86/kvm/vmx/vmx.h            |   2 +-
 arch/x86/kvm/x86.c                |  14 ++--
 15 files changed, 369 insertions(+), 96 deletions(-)

-- 
2.30.2

