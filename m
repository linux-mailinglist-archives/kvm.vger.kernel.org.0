Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9093EFA0D
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 07:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbhHRF2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 01:28:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:64949 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229768AbhHRF2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 01:28:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="203452354"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="203452354"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 22:27:29 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="520759454"
Received: from yxu32-mobl.ccr.corp.intel.com (HELO [10.255.28.25]) ([10.255.28.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 22:27:25 -0700
Subject: Re: [PATCH V10 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <4d1bd44a-2828-3705-e4c5-d0e3ba23dd06@intel.com>
Date:   Wed, 18 Aug 2021 13:27:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210806133802.3528-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Do you have any comments on this series(already reviewed by Peter)?

Or any chance to queue it in next merge window?

Thanks,
Zhu Lingshan

On 8/6/2021 9:37 PM, Zhu Lingshan wrote:
> The guest Precise Event Based Sampling (PEBS) feature can provide an
> architectural state of the instruction executed after the guest instruction
> that exactly caused the event. It needs new hardware facility only available
> on Intel Ice Lake Server platforms. This patch set enables the basic PEBS
> feature for KVM guests on ICX.
>
> We can use PEBS feature on the Linux guest like native:
>
>     # echo 0 > /proc/sys/kernel/watchdog (on the host)
>     # perf record -e instructions:ppp ./br_instr a
>     # perf record -c 100000 -e instructions:pp ./br_instr a
>
> To emulate guest PEBS facility for the above perf usages,
> we need to implement 2 code paths:
>
> 1) Fast path
>
> This is when the host assigned physical PMC has an identical index as the
> virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
> This path is used in most common use cases.
>
> 2) Slow path
>
> This is when the host assigned physical PMC has a different index from the
> virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0) In this case,
> KVM needs to rewrite the PEBS records to change the applicable counter indexes
> to the virtual PMC indexes, which would otherwise contain the physical counter
> index written by PEBS facility, and switch the counter reset values to the
> offset corresponding to the physical counter indexes in the DS data structure.
>
> The previous version [0] enables both fast path and slow path, which seems
> a bit more complex as the first step. In this patchset, we want to start with
> the fast path to get the basic guest PEBS enabled while keeping the slow path
> disabled. More focused discussion on the slow path [1] is planned to be put to
> another patchset in the next step.
>
> Compared to later versions in subsequent steps, the functionality to support
> host-guest PEBS both enabled and the functionality to emulate guest PEBS when
> the counter is cross-mapped are missing in this patch set
> (neither of these are typical scenarios).
>
> With the basic support, the guest can retrieve the correct PEBS information from
> its own PEBS records on the Ice Lake servers. And we expect it should work when
> migrating to another Ice Lake and no regression about host perf is expected.
>
> Here are the results of pebs test from guest/host for same workload:
>
> perf report on guest:
> # Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1473377250 # Overhead  Command   Shared Object      Symbol
>     57.74%  br_instr  br_instr           [.] lfsr_cond
>     41.40%  br_instr  br_instr           [.] cmp_end
>      0.21%  br_instr  [kernel.kallsyms]  [k] __lock_acquire
>
> perf report on host:
> # Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1462721386 # Overhead  Command   Shared Object     Symbol
>     57.90%  br_instr  br_instr          [.] lfsr_cond
>     41.95%  br_instr  br_instr          [.] cmp_end
>      0.05%  br_instr  [kernel.vmlinux]  [k] lock_acquire
>      Conclusion: the profiling results on the guest are similar tothat on the host.
>
> A minimum guest kernel version may be v5.4 or a backport version support
> Icelake server PEBS.
>
> Please check more details in each commit and feel free to comment.
>
> Previous:
> https://lore.kernel.org/kvm/20210722054159.4459-1-lingshan.zhu@intel.com/
>
> [0]
> https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/
> [1]
> https://lore.kernel.org/kvm/20210115191113.nktlnmivc3edstiv@two.firstfloor.org/
>
> V9->V10:
> - improve readability in core.c(Peter Z)
> - reuse guest_pebs_idxs(Liu XiangDong)
> V8 -> V9 Changelog:
> -fix a brackets error in xen_guest_state()
>
> V7 -> V8 Changelog:
> - fix coding style, add {} for single statement of multiple lines(Peter Z)
> - fix coding style in xen_guest_state() (Boris Ostrovsky)
> - s/pmu/kvm_pmu/ in intel_guest_get_msrs() (Peter Z)
> - put lower cost branch in the first place for x86_pmu_handle_guest_pebs() (Peter Z)
>
> V6 -> V7 Changelog:
> - Fix conditions order and call x86_pmu_handle_guest_pebs() unconditionally; (PeterZ)
> - Add a new patch to make all that perf_guest_cbs stuff suck less; (PeterZ)
> - Document IA32_MISC_ENABLE[7] that that behavior matches bare metal; (Sean & Venkatesh)
> - Update commit message for fixed counter mask refactoring;(PeterZ)
> - Clarifying comments about {.host and .guest} for intel_guest_get_msrs(); (PeterZ)
> - Add pebs_capable to store valid PEBS_COUNTER_MASK value; (PeterZ)
> - Add more comments for perf's precise_ip field; (Andi & PeterZ)
> - Refactor perf_overflow_handler_t and make it more legible; (PeterZ)
> - Use "(unsigned long)cpuc->ds" instead of __this_cpu_read(cpu_hw_events.ds); (PeterZ)
> - Keep using "(struct kvm_pmu *)data" to follow K&R; (Andi)
>
> Like Xu (17):
>    perf/core: Use static_call to optimize perf_guest_info_callbacks
>    perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
>    perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
>    perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
>    KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
>    KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
>    KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
>    KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
>    KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
>    KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
>    KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
>    KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
>    KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
>    KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
>    KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
>    KVM: x86/cpuid: Refactor host/guest CPU model consistency check
>    KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
>
> Peter Zijlstra (Intel) (1):
>    x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value
>
>   arch/arm/kernel/perf_callchain.c   |  16 +--
>   arch/arm64/kernel/perf_callchain.c |  29 +++--
>   arch/arm64/kvm/perf.c              |  22 ++--
>   arch/csky/kernel/perf_callchain.c  |   4 +-
>   arch/nds32/kernel/perf_event_cpu.c |  16 +--
>   arch/riscv/kernel/perf_callchain.c |   4 +-
>   arch/x86/events/core.c             |  44 ++++++--
>   arch/x86/events/intel/core.c       | 167 +++++++++++++++++++++++------
>   arch/x86/events/perf_event.h       |   6 +-
>   arch/x86/include/asm/kvm_host.h    |  18 +++-
>   arch/x86/include/asm/msr-index.h   |   6 ++
>   arch/x86/include/asm/perf_event.h  |   5 +-
>   arch/x86/kvm/cpuid.c               |  26 ++---
>   arch/x86/kvm/cpuid.h               |   5 +
>   arch/x86/kvm/pmu.c                 |  60 ++++++++---
>   arch/x86/kvm/pmu.h                 |  38 +++++++
>   arch/x86/kvm/vmx/capabilities.h    |  26 +++--
>   arch/x86/kvm/vmx/pmu_intel.c       | 116 ++++++++++++++++----
>   arch/x86/kvm/vmx/vmx.c             |  24 ++++-
>   arch/x86/kvm/vmx/vmx.h             |   2 +-
>   arch/x86/kvm/x86.c                 |  51 +++++----
>   arch/x86/xen/pmu.c                 |  33 +++---
>   include/linux/perf_event.h         |  12 ++-
>   kernel/events/core.c               |   9 ++
>   24 files changed, 548 insertions(+), 191 deletions(-)
>

