Return-Path: <kvm+bounces-32147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D069D3A13
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 12:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DE99B2CEFD
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 11:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D88BA1A2540;
	Wed, 20 Nov 2024 11:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ao/sPRCX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601A219F41D;
	Wed, 20 Nov 2024 11:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732103727; cv=none; b=mJDemItN9rP6cwc5kjID8Ts3dEY/EySpIcjCSkHjc20X9faiyOwcAIpILV3+LN24GLhuOt9U0Pje+bquaY2uiJgqR4vY9bqFN8KFsvnlGOEfnH+j/bWvh0NqDEmRLbwVIVBBkoOzU+L7LEe9J6g12VZtqpw72sp1hL9wYiKBplE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732103727; c=relaxed/simple;
	bh=NN/lVO43V0HzE2VkTzl5HsnGEhgfbjC646pOp2BgBUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gq8O0YbXCxT+6jbyZdIJeH9Hk0hRkUBpaR5+sixkOYQYC5KGTl2jsyIIbvlheGuwAaJvPO+pRgoI/2do46xy3z2c1DuGtn3u2bj+s/Q1uXnzYeRWEteqrRQubVyXGEJclgj6cXBEnX2uQM4/2WJ12CNewga0boFo+h4M6+XyYyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ao/sPRCX; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732103726; x=1763639726;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NN/lVO43V0HzE2VkTzl5HsnGEhgfbjC646pOp2BgBUg=;
  b=ao/sPRCXm4rE6SgiC/K08TibSzg9MpyZ0V/IrKTV+v0bWCTUVjIykMN4
   fcbAAIj8hSFvQcD0B1FSfJy/+jd3whWnJ1i3GffMwnE0/eMSqwVLy9qZD
   CLLJJBt0fJtQc2nTXXIj63TCoSAa1TC+/jhIAVT43417RagMsTmIs6e18
   xdUncHLrgPDkIu/aX9kkk8h2KZIvianXH/RLwoRZHoXmq+r2EzqjScdkF
   F+DCINIBOGd4Azbn1ouD1I796vbUbO6YzfyWBj0cyVU/vdzNyCQwReEqg
   lHlqZDmaDE/BmeVoQoCcHDihpNkj5tFnJtnJSjywlPXTUng/nnwpYoQ9E
   g==;
X-CSE-ConnectionGUID: L4SIgHx6TDyQr/6ctFLutw==
X-CSE-MsgGUID: YAobSXWVSK6Vr1hv4zPL9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="32016373"
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="32016373"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 03:55:25 -0800
X-CSE-ConnectionGUID: MT4qSu9QRuiyhPiCUOimBg==
X-CSE-MsgGUID: TSxaehrzSHiNGdbyXByUQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="93957159"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 03:55:19 -0800
Message-ID: <d99691ff-906d-4209-9636-4b18915e1afc@linux.intel.com>
Date: Wed, 20 Nov 2024 19:55:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 00/58] Mediated Passthrough vPMU 3.0 for x86
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sean,

Do you think we can remove the "RFC" tag in next version patchset? You and
Peter have reviewed the proposal thoroughly (Thanks for your reviewing
efforts) and it seems there are no hard obstacles besides the
implementation details? Thanks.


On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
> This series contains perf interface improvements to address Peter's
> comments. In addition, fix several bugs for v2. This version is based on
> 6.10-rc4. The main changes are:
>
>  - Use atomics to replace refcounts to track the nr_mediated_pmu_vms.
>  - Use the generic ctx_sched_{in,out}() to switch PMU resources when a
>    guest is entering and exiting.
>  - Add a new EVENT_GUEST flag to indicate the context switch case of
>    entering and exiting a guest. Updates the generic ctx_sched_{in,out}
>    to specifically handle this case, especially for time management.
>  - Switch PMI vector in perf_guest_{enter,exit}() as well. Add a new
>    driver-specific interface to facilitate the switch.
>  - Remove the PMU_FL_PASSTHROUGH flag and uses the PASSTHROUGH pmu
>    capability instead.
>  - Adjust commit sequence in PERF and KVM PMI interrupt functions.
>  - Use pmc_is_globally_enabled() check in emulated counter increment [1]
>  - Fix PMU context switch [2] by using rdpmc() instead of rdmsr().
>
> AMD fixes:
>  - Add support for legacy PMU MSRs in MSR interception.
>  - Make MSR usage consistent if PerfMonV2 is available.
>  - Avoid enabling passthrough vPMU when local APIC is not in kernel.
>  - increment counters in emulation mode.
>
> This series is organized in the following order:
>
> Patches 1-3:
>  - Immediate bug fixes that can be applied to Linux tip.
>  - Note: will put immediate fixes ahead in the future. These patches
>    might be duplicated with existing posts.
>  - Note: patches 1-2 are needed for AMD when host kernel enables
>    preemption. Otherwise, guest will suffer from softlockup.
>
> Patches 4-17:
>  - Perf side changes, infra changes in core pmu with API for KVM.
>
> Patches 18-48:
>  - KVM mediated passthrough vPMU framework + Intel CPU implementation.
>
> Patches 49-58:
>  - AMD CPU implementation for vPMU.
>
> Reference (patches in v2):
> [1] [PATCH v2 42/54] KVM: x86/pmu: Implement emulated counter increment for passthrough PMU
>  - https://lore.kernel.org/all/20240506053020.3911940-43-mizhang@google.com/
> [2] [PATCH v2 30/54] KVM: x86/pmu: Implement the save/restore of PMU state for Intel CPU
>  - https://lore.kernel.org/all/20240506053020.3911940-31-mizhang@google.com/
>
> V2: https://lore.kernel.org/all/20240506053020.3911940-1-mizhang@google.com/
>
> Dapeng Mi (3):
>   x86/msr: Introduce MSR_CORE_PERF_GLOBAL_STATUS_SET
>   KVM: x86/pmu: Introduce macro PMU_CAP_PERF_METRICS
>   KVM: x86/pmu: Add intel_passthrough_pmu_msrs() to pass-through PMU
>     MSRs
>
> Kan Liang (8):
>   perf: Support get/put passthrough PMU interfaces
>   perf: Skip pmu_ctx based on event_type
>   perf: Clean up perf ctx time
>   perf: Add a EVENT_GUEST flag
>   perf: Add generic exclude_guest support
>   perf: Add switch_interrupt() interface
>   perf/x86: Support switch_interrupt interface
>   perf/x86/intel: Support PERF_PMU_CAP_PASSTHROUGH_VPMU
>
> Manali Shukla (1):
>   KVM: x86/pmu/svm: Wire up PMU filtering functionality for passthrough
>     PMU
>
> Mingwei Zhang (24):
>   perf/x86: Forbid PMI handler when guest own PMU
>   perf: core/x86: Plumb passthrough PMU capability from x86_pmu to
>     x86_pmu_cap
>   KVM: x86/pmu: Introduce enable_passthrough_pmu module parameter
>   KVM: x86/pmu: Plumb through pass-through PMU to vcpu for Intel CPUs
>   KVM: x86/pmu: Add a helper to check if passthrough PMU is enabled
>   KVM: x86/pmu: Add host_perf_cap and initialize it in
>     kvm_x86_vendor_init()
>   KVM: x86/pmu: Allow RDPMC pass through when all counters exposed to
>     guest
>   KVM: x86/pmu: Introduce PMU operator to check if rdpmc passthrough
>     allowed
>   KVM: x86/pmu: Create a function prototype to disable MSR interception
>   KVM: x86/pmu: Avoid legacy vPMU code when accessing global_ctrl in
>     passthrough vPMU
>   KVM: x86/pmu: Exclude PMU MSRs in vmx_get_passthrough_msr_slot()
>   KVM: x86/pmu: Add counter MSR and selector MSR index into struct
>     kvm_pmc
>   KVM: x86/pmu: Introduce PMU operation prototypes for save/restore PMU
>     context
>   KVM: x86/pmu: Implement the save/restore of PMU state for Intel CPU
>   KVM: x86/pmu: Make check_pmu_event_filter() an exported function
>   KVM: x86/pmu: Allow writing to event selector for GP counters if event
>     is allowed
>   KVM: x86/pmu: Allow writing to fixed counter selector if counter is
>     exposed
>   KVM: x86/pmu: Exclude existing vLBR logic from the passthrough PMU
>   KVM: x86/pmu: Introduce PMU operator to increment counter
>   KVM: x86/pmu: Introduce PMU operator for setting counter overflow
>   KVM: x86/pmu: Implement emulated counter increment for passthrough PMU
>   KVM: x86/pmu: Update pmc_{read,write}_counter() to disconnect perf API
>   KVM: x86/pmu: Disconnect counter reprogram logic from passthrough PMU
>   KVM: nVMX: Add nested virtualization support for passthrough PMU
>
> Sandipan Das (12):
>   perf/x86: Do not set bit width for unavailable counters
>   x86/msr: Define PerfCntrGlobalStatusSet register
>   KVM: x86/pmu: Always set global enable bits in passthrough mode
>   KVM: x86/pmu/svm: Set passthrough capability for vcpus
>   KVM: x86/pmu/svm: Set enable_passthrough_pmu module parameter
>   KVM: x86/pmu/svm: Allow RDPMC pass through when all counters exposed
>     to guest
>   KVM: x86/pmu/svm: Implement callback to disable MSR interception
>   KVM: x86/pmu/svm: Set GuestOnly bit and clear HostOnly bit when guest
>     write to event selectors
>   KVM: x86/pmu/svm: Add registers to direct access list
>   KVM: x86/pmu/svm: Implement handlers to save and restore context
>   KVM: x86/pmu/svm: Implement callback to increment counters
>   perf/x86/amd: Support PERF_PMU_CAP_PASSTHROUGH_VPMU for AMD host
>
> Sean Christopherson (2):
>   sched/core: Move preempt_model_*() helpers from sched.h to preempt.h
>   sched/core: Drop spinlocks on contention iff kernel is preemptible
>
> Xiong Zhang (8):
>   x86/irq: Factor out common code for installing kvm irq handler
>   perf: core/x86: Register a new vector for KVM GUEST PMI
>   KVM: x86/pmu: Register KVM_GUEST_PMI_VECTOR handler
>   KVM: x86/pmu: Manage MSR interception for IA32_PERF_GLOBAL_CTRL
>   KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL at VM boundary
>   KVM: x86/pmu: Notify perf core at KVM context switch boundary
>   KVM: x86/pmu: Grab x86 core PMU for passthrough PMU VM
>   KVM: x86/pmu: Add support for PMU context switch at VM-exit/enter
>
>  .../admin-guide/kernel-parameters.txt         |   4 +-
>  arch/x86/events/amd/core.c                    |   2 +
>  arch/x86/events/core.c                        |  44 +-
>  arch/x86/events/intel/core.c                  |   5 +
>  arch/x86/include/asm/hardirq.h                |   1 +
>  arch/x86/include/asm/idtentry.h               |   1 +
>  arch/x86/include/asm/irq.h                    |   2 +-
>  arch/x86/include/asm/irq_vectors.h            |   5 +-
>  arch/x86/include/asm/kvm-x86-pmu-ops.h        |   6 +
>  arch/x86/include/asm/kvm_host.h               |   9 +
>  arch/x86/include/asm/msr-index.h              |   2 +
>  arch/x86/include/asm/perf_event.h             |   1 +
>  arch/x86/include/asm/vmx.h                    |   1 +
>  arch/x86/kernel/idt.c                         |   1 +
>  arch/x86/kernel/irq.c                         |  39 +-
>  arch/x86/kvm/cpuid.c                          |   3 +
>  arch/x86/kvm/pmu.c                            | 154 +++++-
>  arch/x86/kvm/pmu.h                            |  49 ++
>  arch/x86/kvm/svm/pmu.c                        | 136 +++++-
>  arch/x86/kvm/svm/svm.c                        |  31 ++
>  arch/x86/kvm/svm/svm.h                        |   2 +-
>  arch/x86/kvm/vmx/capabilities.h               |   1 +
>  arch/x86/kvm/vmx/nested.c                     |  52 +++
>  arch/x86/kvm/vmx/pmu_intel.c                  | 192 +++++++-
>  arch/x86/kvm/vmx/vmx.c                        | 197 ++++++--
>  arch/x86/kvm/vmx/vmx.h                        |   3 +-
>  arch/x86/kvm/x86.c                            |  45 ++
>  arch/x86/kvm/x86.h                            |   1 +
>  include/linux/perf_event.h                    |  38 +-
>  include/linux/preempt.h                       |  41 ++
>  include/linux/sched.h                         |  41 --
>  include/linux/spinlock.h                      |  14 +-
>  kernel/events/core.c                          | 441 ++++++++++++++----
>  .../beauty/arch/x86/include/asm/irq_vectors.h |   5 +-
>  34 files changed, 1373 insertions(+), 196 deletions(-)
>
>
> base-commit: 6ba59ff4227927d3a8530fc2973b80e94b54d58f

