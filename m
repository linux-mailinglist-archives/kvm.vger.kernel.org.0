Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14FF379CFC
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 04:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhEKCoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 22:44:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:7532 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhEKCoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 22:44:05 -0400
IronPort-SDR: t90OgSPonnSFugn6KNmpCRaXLXGCw1VrmI6oPV/n6Ex+nQ7HYShStgIaKXZ53HFvTz2K+F48Ys
 hzlIMfgY6ovQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="199391164"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="199391164"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 19:42:59 -0700
IronPort-SDR: Z03bXJI/8do50E4Zh/vuxfVx4lcNmGPAzxpCKCVzDAQOxyR7ZK16WbZZ5UGca0UvBrj9eW3gE4
 Mmd+gitL6BwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="468591513"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga002.fm.intel.com with ESMTP; 10 May 2021 19:42:55 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v6 00/16] KVM: x86/pmu: Add *basic* support to enable guest PEBS via DS
Date:   Tue, 11 May 2021 10:41:58 +0800
Message-Id: <20210511024214.280733-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A new kernel cycle has begun, and this version looks promising.

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
https://lore.kernel.org/kvm/20210415032016.166201-1-like.xu@linux.intel.com/

[0] https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/
[1] https://lore.kernel.org/kvm/20210115191113.nktlnmivc3edstiv@two.firstfloor.org/

V5 -> V6 Changelog:
- Rebased on the latest kvm/queue tree;
- Fix a git rebase issue (Liuxiangdong);
- Adjust the patch sequence 06/07 for bisection (Liuxiangdong);

Like Xu (16):
  perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
  perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
  perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
  KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
  KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
  KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
  KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
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
 arch/x86/events/intel/core.c      | 129 ++++++++++++++++++++++++------
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
 15 files changed, 368 insertions(+), 96 deletions(-)

-- 
2.31.1

