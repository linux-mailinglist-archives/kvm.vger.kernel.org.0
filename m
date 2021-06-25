Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7AA3B40CA
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 11:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhFYJso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 05:48:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:48795 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230436AbhFYJsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 05:48:41 -0400
IronPort-SDR: eO5CyTfrnZEsObQcmigS6sRp8Pn5kxuslsPxJmgh6jxfnvgGh1DX7w+LTM1KMntUW0tPmMb5aZ
 P8IxRTBa6ZFw==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="187330514"
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="187330514"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 02:46:20 -0700
IronPort-SDR: 95R/ahI4YnD5Nvebk0q4CHVFLsQO2IWiU84mQG/LCG5+NgWkXeiJ4uPdbBppEtn+F4H/5fsaBH
 n4mkpGGv6OUQ==
X-IronPort-AV: E=Sophos;i="5.83,298,1616482800"; 
   d="scan'208";a="488123034"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.28.148]) ([10.255.28.148])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 02:46:14 -0700
Subject: Re: [PATCH V7 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
To:     Liuxiangdong <liuxiangdong5@huawei.com>, peterz@infradead.org,
        pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        weijiang.yang@intel.com, kan.liang@linux.intel.com,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <60D5A487.8020507@huawei.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <37832cc0-788d-91b9-dc95-147eca133842@intel.com>
Date:   Fri, 25 Jun 2021 17:46:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <60D5A487.8020507@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/25/2021 5:40 PM, Liuxiangdong wrote:
>
>
> On 2021/6/22 17:42, Zhu Lingshan wrote:
>> The guest Precise Event Based Sampling (PEBS) feature can provide an 
>> architectural state of the instruction executed after the guest 
>> instruction that exactly caused the event. It needs new hardware 
>> facility only available on Intel Ice Lake Server platforms. This 
>> patch set enables the basic PEBS feature for KVM guests on ICX.
>>
>> We can use PEBS feature on the Linux guest like native:
>>
>>     # echo 0 > /proc/sys/kernel/watchdog (on the host)
>
> Only on the host?
> I cannot use pebs unless try with "echo 0 > /proc/sys/kernel/watchdog" 
> both on the host and guest on ICX.
Hi Xiangdong

I guess you may run into the "cross-map" case(slow path below), so I 
think you can disable them both in host and guest to make PEBS work.

Thanks
>
>>     # perf record -e instructions:ppp ./br_instr a
>>     # perf record -c 100000 -e instructions:pp ./br_instr a
>>
>> To emulate guest PEBS facility for the above perf usages, we need to 
>> implement 2 code paths:
>>
>> 1) Fast path
>>
>> This is when the host assigned physical PMC has an identical index as 
>> the virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
>> This path is used in most common use cases.
>>
>> 2) Slow path
>>
>> This is when the host assigned physical PMC has a different index 
>> from the virtual PMC (e.g. using physical PMC1 to emulate virtual 
>> PMC0) In this case, KVM needs to rewrite the PEBS records to change 
>> the applicable counter indexes to the virtual PMC indexes, which 
>> would otherwise contain the physical counter index written by PEBS 
>> facility, and switch the counter reset values to the offset 
>> corresponding to the physical counter indexes in the DS data structure.
>>
>> The previous version [0] enables both fast path and slow path, which 
>> seems a bit more complex as the first step. In this patchset, we want 
>> to start with the fast path to get the basic guest PEBS enabled while 
>> keeping the slow path disabled. More focused discussion on the slow 
>> path [1] is planned to be put to another patchset in the next step.
>>
>> Compared to later versions in subsequent steps, the functionality to 
>> support host-guest PEBS both enabled and the functionality to emulate 
>> guest PEBS when the counter is cross-mapped are missing in this patch 
>> set (neither of these are typical scenarios).
>>
>> With the basic support, the guest can retrieve the correct PEBS 
>> information from its own PEBS records on the Ice Lake servers.
>> And we expect it should work when migrating to another Ice Lake and 
>> no regression about host perf is expected.
>>
>> Here are the results of pebs test from guest/host for same workload:
>>
>> perf report on guest:
>> # Samples: 2K of event 'instructions:ppp', # Event count (approx.): 
>> 1473377250 # Overhead  Command   Shared Object Symbol
>>     57.74%  br_instr  br_instr           [.] lfsr_cond
>>     41.40%  br_instr  br_instr           [.] cmp_end
>>      0.21%  br_instr  [kernel.kallsyms]  [k] __lock_acquire
>>
>> perf report on host:
>> # Samples: 2K of event 'instructions:ppp', # Event count (approx.): 
>> 1462721386 # Overhead  Command   Shared Object Symbol
>>     57.90%  br_instr  br_instr          [.] lfsr_cond
>>     41.95%  br_instr  br_instr          [.] cmp_end
>>      0.05%  br_instr  [kernel.vmlinux]  [k] lock_acquire
>>      Conclusion: the profiling results on the guest are similar 
>> tothat on the host.
>>
>> A minimum guest kernel version may be v5.4 or a backport version 
>> support Icelake server PEBS.
>>
>> Please check more details in each commit and feel free to comment.
>>
>> Previous:
>> https://lore.kernel.org/kvm/20210511024214.280733-1-like.xu@linux.intel.com/ 
>>
>>
>> [0]
>> https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/ 
>>
>> [1]
>> https://lore.kernel.org/kvm/20210115191113.nktlnmivc3edstiv@two.firstfloor.org/ 
>>
>>
>> V6 -> V7 Changelog:
>> - Fix conditions order and call x86_pmu_handle_guest_pebs() 
>> unconditionally; (PeterZ)
>> - Add a new patch to make all that perf_guest_cbs stuff suck less; 
>> (PeterZ)
>> - Document IA32_MISC_ENABLE[7] that that behavior matches bare metal; 
>> (Sean & Venkatesh)
>> - Update commit message for fixed counter mask refactoring;(PeterZ)
>> - Clarifying comments about {.host and .guest} for 
>> intel_guest_get_msrs(); (PeterZ)
>> - Add pebs_capable to store valid PEBS_COUNTER_MASK value; (PeterZ)
>> - Add more comments for perf's precise_ip field; (Andi & PeterZ)
>> - Refactor perf_overflow_handler_t and make it more legible; (PeterZ)
>> - Use "(unsigned long)cpuc->ds" instead of 
>> __this_cpu_read(cpu_hw_events.ds); (PeterZ)
>> - Keep using "(struct kvm_pmu *)data" to follow K&R; (Andi)
>>
>> Like Xu (17):
>>    perf/core: Use static_call to optimize perf_guest_info_callbacks
>>    perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
>>    perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
>>    perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
>>    KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
>>    KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
>>    KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
>>    KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
>>    KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR 
>> counter
>>    KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
>>    KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive 
>> PEBS
>>    KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
>>    KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
>>    KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
>>    KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
>>    KVM: x86/cpuid: Refactor host/guest CPU model consistency check
>>    KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
>>
>> Peter Zijlstra (Intel) (1):
>>    x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK 
>> value
>>
>>   arch/arm/kernel/perf_callchain.c   |  16 +--
>>   arch/arm64/kernel/perf_callchain.c |  29 +++--
>>   arch/arm64/kvm/perf.c              |  22 ++--
>>   arch/csky/kernel/perf_callchain.c  |   4 +-
>>   arch/nds32/kernel/perf_event_cpu.c |  16 +--
>>   arch/riscv/kernel/perf_callchain.c |   4 +-
>>   arch/x86/events/core.c             |  43 ++++++--
>>   arch/x86/events/intel/core.c       | 165 +++++++++++++++++++++++------
>>   arch/x86/events/perf_event.h       |   6 +-
>>   arch/x86/include/asm/kvm_host.h    |  18 +++-
>>   arch/x86/include/asm/msr-index.h   |   6 ++
>>   arch/x86/include/asm/perf_event.h  |   5 +-
>>   arch/x86/kvm/cpuid.c               |  24 ++---
>>   arch/x86/kvm/cpuid.h               |   5 +
>>   arch/x86/kvm/pmu.c                 |  60 ++++++++---
>>   arch/x86/kvm/pmu.h                 |  38 +++++++
>>   arch/x86/kvm/vmx/capabilities.h    |  26 +++--
>>   arch/x86/kvm/vmx/pmu_intel.c       | 115 ++++++++++++++++----
>>   arch/x86/kvm/vmx/vmx.c             |  24 ++++-
>>   arch/x86/kvm/vmx/vmx.h             |   2 +-
>>   arch/x86/kvm/x86.c                 |  51 +++++----
>>   arch/x86/xen/pmu.c                 |  33 +++---
>>   include/linux/perf_event.h         |  12 ++-
>>   kernel/events/core.c               |   9 ++
>>   24 files changed, 544 insertions(+), 189 deletions(-)
>>
>

