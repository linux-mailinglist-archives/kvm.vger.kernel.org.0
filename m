Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0142817A296
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 10:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCEJ6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:58:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:1764 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgCEJ6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:58:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 01:58:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366353"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 01:58:41 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, like.xu@linux.intel.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 00/11] PEBS virtualization enabling via DS
Date:   Fri,  6 Mar 2020 01:56:54 +0800
Message-Id: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Processor Event-Based Sampling(PEBS) supported on mainstream Intel
platforms can provide an architectural state of the instruction executed
after the instruction that caused the event. This patchset is going to
enable PEBS feature via DS on KVM for the Icelake server.
Although PEBS via DS supports EPT violations feature is supported starting
Skylake Server, but we have to pin DS area to avoid losing PEBS records due
to some issues.

BTW:
The PEBS virtualization via Intel PT patchset V1 has been posted out and the
later version will base on this patchset.
https://lkml.kernel.org/r/1572217877-26484-1-git-send-email-luwei.kang@intel.com/

Testing:
The guest can use PEBS feature like native. e.g.

# perf record -e instructions:ppp ./br_instr a

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


Kan Liang (4):
  perf/x86/core: Support KVM to assign a dedicated counter for guest
    PEBS
  perf/x86/ds: Handle guest PEBS events overflow and inject fake PMI
  perf/x86: Expose a function to disable auto-reload
  KVM: x86/pmu: Decouple event enablement from event creation

Like Xu (1):
  KVM: x86/pmu: Add support to reprogram PEBS event for guest counters

Luwei Kang (6):
  KVM: x86/pmu: Implement is_pebs_via_ds_supported pmu ops
  KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
  KVM: x86/pmu: PEBS MSRs emulation
  KVM: x86/pmu: Expose PEBS feature to guest
  KVM: x86/pmu: Introduce the mask value for fixed counter
  KVM: x86/pmu: Adaptive PEBS virtualization enabling

 arch/x86/events/intel/core.c      |  74 +++++++++++++++++++++-
 arch/x86/events/intel/ds.c        |  59 ++++++++++++++++++
 arch/x86/events/perf_event.h      |   1 +
 arch/x86/include/asm/kvm_host.h   |  12 ++++
 arch/x86/include/asm/msr-index.h  |   4 ++
 arch/x86/include/asm/perf_event.h |   2 +
 arch/x86/kvm/cpuid.c              |   9 ++-
 arch/x86/kvm/pmu.c                |  71 ++++++++++++++++++++-
 arch/x86/kvm/pmu.h                |   2 +
 arch/x86/kvm/svm.c                |  12 ++++
 arch/x86/kvm/vmx/capabilities.h   |  17 +++++
 arch/x86/kvm/vmx/pmu_intel.c      | 128 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c            |   6 +-
 arch/x86/kvm/vmx/vmx.h            |   4 ++
 arch/x86/kvm/x86.c                |  19 +++++-
 include/linux/perf_event.h        |   2 +
 kernel/events/core.c              |   1 +
 17 files changed, 414 insertions(+), 9 deletions(-)

-- 
1.8.3.1

