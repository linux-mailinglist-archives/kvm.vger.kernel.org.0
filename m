Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A29354B27
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 05:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243532AbhDFDTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 23:19:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:37950 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231620AbhDFDTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 23:19:38 -0400
IronPort-SDR: bJnfiOWR15TmoSqnQjYYgKh9FUMOMFRPOjettzB6PzUHVZCWb0o2xHqOvXwkrMvv9SXtAcx3Uy
 SsOKvo3q2xHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="256957998"
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="256957998"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 20:19:30 -0700
IronPort-SDR: qFrrEfOaOypP8Es0u+Z0lLUPd6o7qANb9FjPShyZMpOjW6lvn9MwNHMEN1bb5U9XtiYo9dVD1N
 PmfjpNOGlgdQ==
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="421005662"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 20:19:25 -0700
Subject: Re: [PATCH v4 00/16] KVM: x86/pmu: Add basic support to enable Guest
 PEBS via DS
To:     peterz@infradead.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     eranian@google.com, andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <4a39a825-7d18-b9ca-b0c3-eafec57b3921@intel.com>
Date:   Tue, 6 Apr 2021 11:19:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210329054137.120994-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all, do we have any comments on this patch set?

On 2021/3/29 13:41, Like Xu wrote:
> The guest Precise Event Based Sampling (PEBS) feature can provide
> an architectural state of the instruction executed after the guest
> instruction that exactly caused the event. It needs new hardware
> facility only available on Intel Ice Lake Server platforms. This
> patch set enables the basic PEBS via DS feature for KVM guests on ICX.
>
> We can use PEBS feature on the Linux guest like native:
>
>    # perf record -e instructions:ppp ./br_instr a
>    # perf record -c 100000 -e instructions:pp ./br_instr a
>
> To emulate guest PEBS facility for the above perf usages,
> we need to implement 2 code paths:
>
> 1) Fast path
>
> This is when the host assigned physical PMC has an identical index as
> the virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
> This path is used in most common use cases.
>
> 2) Slow path
>
> This is when the host assigned physical PMC has a different index
> from the virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0)
> In this case, KVM needs to rewrite the PEBS records to change the
> applicable counter indexes to the virtual PMC indexes, which would
> otherwise contain the physical counter index written by PEBS facility,
> and switch the counter reset values to the offset corresponding to
> the physical counter indexes in the DS data structure.
>
> The previous version [0] enables both fast path and slow path, which
> seems a bit more complex as the first step. In this patchset, we want
> to start with the fast path to get the basic guest PEBS enabled while
> keeping the slow path disabled. More focused discussion on the slow
> path [1] is planned to be put to another patchset in the next step.
>
> Compared to later versions in subsequent steps, the functionality
> to support host-guest PEBS both enabled and the functionality to
> emulate guest PEBS when the counter is cross-mapped are missing
> in this patch set (neither of these are typical scenarios).
>
> With the basic support, the guest can retrieve the correct PEBS
> information from its own PEBS records on the Ice Lake servers.
> And we expect it should work when migrating to another Ice Lake
> and no regression about host perf is expected.
>
> Here are the results of pebs test from guest/host for same workload:
>
> perf report on guest:
> # Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1473377250
> # Overhead  Command   Shared Object      Symbol
>    57.74%  br_instr  br_instr           [.] lfsr_cond
>    41.40%  br_instr  br_instr           [.] cmp_end
>     0.21%  br_instr  [kernel.kallsyms]  [k] __lock_acquire
>
> perf report on host:
> # Samples: 2K of event 'instructions:ppp', # Event count (approx.): 1462721386
> # Overhead  Command   Shared Object     Symbol
>    57.90%  br_instr  br_instr          [.] lfsr_cond
>    41.95%  br_instr  br_instr          [.] cmp_end
>     0.05%  br_instr  [kernel.vmlinux]  [k] lock_acquire
>     Conclusion: the profiling results on the guest are similar tothat on the host.
>
> Please check more details in each commit and feel free to comment.
>
> Previous:
> [0] https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/
> [1] https://lore.kernel.org/kvm/20210115191113.nktlnmivc3edstiv@two.firstfloor.org/
>
> v3->v4 Changelog:
> - Update this cover letter and propose a new upstream plan;
> [PERF]
> - Drop check host DS and move handler to handle_pmi_common();
> - Pass "struct kvm_pmu *" to intel_guest_get_msrs();
> - Propose new assignment logic for perf_guest_switch_msr();
> - Introduce x86_pmu.pebs_vmx for future capability maintenance;
> [KVM]
> - Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability;
> - Raising PEBS PMI only when OVF_BIT 62 is not set;
> - Make vmx_icl_pebs_cpu specific for PEBS-PDIR emulation;
> - Fix a bug for fixed_ctr_ctrl_mask;
> - Add two minor refactoring patches for reuse;
>
> Like Xu (16):
>    perf/x86/intel: Add x86_pmu.pebs_vmx for Ice Lake Servers
>    perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
>    perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
>    KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
>    KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
>    KVM: x86/pmu: Reprogram guest PEBS event to emulate guest PEBS counter
>    KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
>    KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to manage guest DS buffer
>    KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
>    KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
>    KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
>    KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
>    KVM: x86/pmu: Disable guest PEBS before vm-entry in two cases
>    KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
>    KVM: x86/cpuid: Refactor host/guest CPU model consistency check
>    KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
>
>   arch/x86/events/core.c            |   5 +-
>   arch/x86/events/intel/core.c      |  93 +++++++++++++++++++++++---
>   arch/x86/events/perf_event.h      |   5 +-
>   arch/x86/include/asm/kvm_host.h   |  16 +++++
>   arch/x86/include/asm/msr-index.h  |   6 ++
>   arch/x86/include/asm/perf_event.h |   5 +-
>   arch/x86/kvm/cpuid.c              |  24 ++-----
>   arch/x86/kvm/cpuid.h              |   5 ++
>   arch/x86/kvm/pmu.c                |  49 ++++++++++----
>   arch/x86/kvm/pmu.h                |  37 +++++++++++
>   arch/x86/kvm/vmx/capabilities.h   |  26 ++++++--
>   arch/x86/kvm/vmx/pmu_intel.c      | 105 ++++++++++++++++++++++++------
>   arch/x86/kvm/vmx/vmx.c            |  25 ++++++-
>   arch/x86/kvm/vmx/vmx.h            |   2 +-
>   arch/x86/kvm/x86.c                |  14 ++--
>   15 files changed, 339 insertions(+), 78 deletions(-)
>

