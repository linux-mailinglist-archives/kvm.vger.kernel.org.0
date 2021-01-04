Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7002E95D5
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 14:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbhADNXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 08:23:45 -0500
Received: from mga07.intel.com ([134.134.136.100]:23242 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbhADNXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 08:23:45 -0500
IronPort-SDR: z3GaPBpNJXsp3hPwymkFdKkGh4l7rgaWDTqIRgyRe6G0uwFvusOIdtN1DW06KozexoOPqJuZVD
 1EXxE5CwSsxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="241034275"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="241034275"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 05:21:58 -0800
IronPort-SDR: lzkg6p1+6NNiOiPW0WCngqzsAykXSvhzo6MF0xRaVv+20Y4hbGs1eCqQOjmuombyCV/BN9xHlb
 OGno8NOe65Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="461944497"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 04 Jan 2021 05:21:55 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS via DS
Date:   Mon,  4 Jan 2021 21:15:25 +0800
Message-Id: <20210104131542.495413-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Precise Event Based Sampling (PEBS) facility on Intel Ice Lake Server
platforms can provide an architectural state of the instruction executed
after the guest instruction that caused the event. This patch set enables
the PEBS via DS feature for KVM guests on the Ice Lake Server.

We can use PEBS feature on the linux guest like native:

  # perf record -e instructions:ppp ./br_instr a
  # perf record -c 100000 -e instructions:pp ./br_instr a

The guest PEBS will be disabled on purpose when host is using PEBS. 
By default, KVM disables the co-existence of guest PEBS and host PEBS.

The whole patch set could be divided into three parts and the first two
parts enables the basic PEBS via DS feature which could be considered
to be merged and no regression about host perf is expected.

Compared to the first version, an important change here is the removal
of the forced 1-1 mapping of the virtual to physical PMC and we handle
the cross-mapping issue carefully in the part 3 which may address
artificial competition concern from PeterZ.

In general, there are 2 code paths to emulate guest PEBS facility.

1) Fast path (part 2, patch 0004-0012)

This is when the host assigned physical PMC has an identical index as
the virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
It works as the 1-1 mapping that we did in the first version.

2) Slow path (part 3, patch 0012-0017)

This is when the host assigned physical PMC has a different index
from the virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0)
In this case, KVM needs to rewrite the PEBS records to change the
applicable counter indexes to the virtual PMC indexes, which would
otherwise contain the physical counter index written by PEBS facility,
and switch the counter reset values to the offset corresponding to
the physical counter indexes in the DS data structure. 

Large PEBS needs to be disabled by KVM rewriting the
pebs_interrupt_threshold filed in DS to only one record in
the slow path.  This is because a guest may implicitly drain PEBS buffer,
e.g., context switch. KVM doesn't get a chance to update the PEBS buffer.
The physical PMC index will confuse the guest. The difficulty comes
when multiple events get rescheduled inside the guest. Hence disabling
large PEBS in this case might be an easy and safe way to keep it corrects
as an initial step here. 

We don't expect this change would break any guest 
code, which can generally tolerate
earlier PMIs. In the fast path with 1:1 mapping this is not needed.

The rewriting work is performed before delivering a vPMI to the guest to
notify the guest to read the record (before entering the guest, where
interrupt has been disabled so no counter reschedule would happen
at that point on the host).

For the DS area virtualization, the PEBS hardware is registered with the
guest virtual address (gva) of the guest DS memory.
In the past, the difficulty is that the host needs to pin the guest
DS memory, as the page fault caused by the PEBS hardware can't be fixed.
This isn't needed from ICX thanks to the hardware support.

KVM rewriting the guest DS area needs to walk the guest page tables to
translate gva to host virtual address (hva).

To reduce the translation overhead, we cache the translation on the first
time of DS memory rewriting. The cached translation is valid to use by
KVM until the guest disables PEBS (VMExits to KVM), which means the guest
may do re-allocation of the PEBS buffer next time and KVM needs
to re-walk the guest pages tables to update the cached translation.

In summary, this patch set enables the guest PEBS to retrieve the correct
information from its own PEBS records on the Ice Lake server platforms
when host is not using PEBS facility at the same time. And we expect it
should work when migrating to another Ice Lake.

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
   
Conclusion: the profiling results on the guest are similar to that on the host.

Please check more details in each commit and feel free to comment.

v2->v3 Changelog:
- drop the counter_freezing check and disable guest PEBS when host uses PEBS;
- use kvm_read/write_guest_[offset]_cached() to reduce memory rewrite overhead;
- use GLOBAL_STATUS_BUFFER_OVF_BIT instead of 62;
- make intel_pmu_handle_event() static;
- rebased to kvm-queue d45f89f7437d;

Previous:
https://lore.kernel.org/kvm/20201109021254.79755-1-like.xu@linux.intel.com/

Like Xu (17):
  KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
  KVM: vmx/pmu: Use IA32_PERF_CAPABILITIES to adjust features visibility
  KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
  perf: x86/ds: Handle guest PEBS overflow PMI and inject it to guest
  KVM: x86/pmu: Reprogram guest PEBS event to emulate guest PEBS counter
  KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
  KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to manage guest DS buffer
  KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
  KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
  KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
  KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
  KVM: x86/pmu: Disable guest PEBS when counters are cross-mapped
  KVM: x86/pmu: Add hook to emulate pebs for cross-mapped counters
  KVM: vmx/pmu: Limit pebs_interrupt_threshold in the guest DS area
  KVM: vmx/pmu: Rewrite applicable_counters field in guest PEBS records
  KVM: x86/pmu: Save guest pebs reset values when pebs is configured
  KVM: x86/pmu: Adjust guest pebs reset values for crpss-mapped counters

 arch/x86/events/intel/core.c     |  45 +++++
 arch/x86/events/intel/ds.c       |  62 +++++++
 arch/x86/include/asm/kvm_host.h  |  18 ++
 arch/x86/include/asm/msr-index.h |   6 +
 arch/x86/kvm/pmu.c               |  92 +++++++--
 arch/x86/kvm/pmu.h               |  20 ++
 arch/x86/kvm/vmx/capabilities.h  |  17 +-
 arch/x86/kvm/vmx/pmu_intel.c     | 310 ++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c           |  29 +++
 arch/x86/kvm/x86.c               |  12 +-
 10 files changed, 592 insertions(+), 19 deletions(-)

-- 
2.29.2

