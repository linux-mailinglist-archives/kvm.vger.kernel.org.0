Return-Path: <kvm+bounces-22833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C099894424C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 06:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D41F1F22D0F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 04:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FE4140366;
	Thu,  1 Aug 2024 04:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dRJqbEqI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAA813CF98
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488354; cv=none; b=MscSanVwZ9LmL6MLLpxI8YLLFW8o53+YMqLOiDXF6uvNVXC56pXShjkVpZkOzzSs+rDc2kh5bugTlk/0xOshT52jkrF2ivbZD3ZcO+XEml0GweFfO6QyqeC6jzYa3xVPkpJAZnBf31CCk+eLvV5Uy9/8cc/UCw4wOeXXaUbyx7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488354; c=relaxed/simple;
	bh=cnYUtcLkKDwrx8q7PB7R3AI9ZMKMgOksdzfeM4b8Ekk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ph0Or9fAP8P8yrQ5ezA0OKF942RrC97VGhbAWtNxnWd48i0hJbrmvjF84IKUCeCHRrKYwAGwyr/MLMOqlqjgCj6U5bb0zWMcEcLkeHloCKim9NjcDTVDL2LM65p7oOw2DeNG84JDAie+dnZ+lF94d/jD6gf/48R04Y8ze1MByHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dRJqbEqI; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a28217cfecso6768057a12.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488351; x=1723093151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b+sYPfnW1nm04zGQigeTvGjQYkaeXqC8//s6SNVDAX4=;
        b=dRJqbEqIBSqLi+V+A6EdFZVrT0fTOlzw5Mn6GzhfERSVJc2GWFDZ/Mxp7TCUzTABP7
         PPyScKDr2Ih61OGY/Vz0dnEndPP+yY1ryeH1cTxR7RjcEI8JNijgY5o0sEVia18dkWwd
         oPS8Cetmz1pdM/Khp52FxKVvFlr1bkQ6u+VJJH52ct5257qTIxBTou9No5gpFbNeANol
         w742e7rVIGlYt5BP7A6PbUDiJJrf/NYV0oN8YBCjXsA9x+2AC0U2mZ8e9n+ITzuD9Syd
         kI0PGbd7k1ViIcQYke+thPzfFuU18cjxPu1xUnkogieYYoJ8dDEkr47E04xF3esewm6w
         oVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488351; x=1723093151;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b+sYPfnW1nm04zGQigeTvGjQYkaeXqC8//s6SNVDAX4=;
        b=h40GZCkTiShm6fRi3hACoStzgQA5uJXXgMQdw4OPpmXSnpF41hRsIuqt0Ep+6gvWRz
         pdzpSjEsRjofXfgVhsoDFM7ifHW2+DV1lrm8VF61DRg9NrdUoI23FQAeZ4g1w58gKEVG
         AkmX0pkl2a9iZbJt7LHlZTK5aXBbhlwqJTO0ijrHz2STLbzrqYjFbnQ/RCAK//+DyQDG
         MvMJvvrPlYvd1AVyw52VRtjwFejJ++VoRU7CDUnK9cHplzDZoN9sqmzI6yVVrODrgRhO
         qQTF+UoNx90kCwbRK087xse4dVqNStdyNFWMWCW2QxrbleL+ShuCm5AC8+MEZHyJCB8F
         KFZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVB2Q2wcs9u+AD1xOAGDaHJ5f3leZyawH0HPQ/66WaSKwmCg1sUp5da9t/AMRHrEZEK3a7I2Fl21o1gCQG6CZxeeH3a
X-Gm-Message-State: AOJu0YypeFaT9/jSzqOzw5roBThIsaYhLAQ+J7q0UI7HRmC6W5EhdYUy
	jf2oSGNWJz7wBImjZilZIgvEE+smAaHLC1rFlpZBUmoI/JjMUyBToStyOw76SYlXdF8dJn1YvEN
	1Uyh5Fw==
X-Google-Smtp-Source: AGHT+IGVWbHkaqkaGvNx4Ju9z8ssUCUpVOfTNWaVaFPiw0fsn9sS/4jHRoOmf4NWLIHMKKI4JZmc78h/ppkZ
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a63:2f86:0:b0:75d:16f9:c075 with SMTP id
 41be03b00d2f7-7b6363edff2mr2503a12.9.1722488351081; Wed, 31 Jul 2024 21:59:11
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:09 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-1-mizhang@google.com>
Subject: [RFC PATCH v3 00/58] Mediated Passthrough vPMU 3.0 for x86
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This series contains perf interface improvements to address Peter's
comments. In addition, fix several bugs for v2. This version is based on
6.10-rc4. The main changes are:

 - Use atomics to replace refcounts to track the nr_mediated_pmu_vms.
 - Use the generic ctx_sched_{in,out}() to switch PMU resources when a
   guest is entering and exiting.
 - Add a new EVENT_GUEST flag to indicate the context switch case of
   entering and exiting a guest. Updates the generic ctx_sched_{in,out}
   to specifically handle this case, especially for time management.
 - Switch PMI vector in perf_guest_{enter,exit}() as well. Add a new
   driver-specific interface to facilitate the switch.
 - Remove the PMU_FL_PASSTHROUGH flag and uses the PASSTHROUGH pmu
   capability instead.
 - Adjust commit sequence in PERF and KVM PMI interrupt functions.
 - Use pmc_is_globally_enabled() check in emulated counter increment [1]
 - Fix PMU context switch [2] by using rdpmc() instead of rdmsr().

AMD fixes:
 - Add support for legacy PMU MSRs in MSR interception.
 - Make MSR usage consistent if PerfMonV2 is available.
 - Avoid enabling passthrough vPMU when local APIC is not in kernel.
 - increment counters in emulation mode.

This series is organized in the following order:

Patches 1-3:
 - Immediate bug fixes that can be applied to Linux tip.
 - Note: will put immediate fixes ahead in the future. These patches
   might be duplicated with existing posts.
 - Note: patches 1-2 are needed for AMD when host kernel enables
   preemption. Otherwise, guest will suffer from softlockup.

Patches 4-17:
 - Perf side changes, infra changes in core pmu with API for KVM.

Patches 18-48:
 - KVM mediated passthrough vPMU framework + Intel CPU implementation.

Patches 49-58:
 - AMD CPU implementation for vPMU.

Reference (patches in v2):
[1] [PATCH v2 42/54] KVM: x86/pmu: Implement emulated counter increment for passthrough PMU
 - https://lore.kernel.org/all/20240506053020.3911940-43-mizhang@google.com/
[2] [PATCH v2 30/54] KVM: x86/pmu: Implement the save/restore of PMU state for Intel CPU
 - https://lore.kernel.org/all/20240506053020.3911940-31-mizhang@google.com/

V2: https://lore.kernel.org/all/20240506053020.3911940-1-mizhang@google.com/

Dapeng Mi (3):
  x86/msr: Introduce MSR_CORE_PERF_GLOBAL_STATUS_SET
  KVM: x86/pmu: Introduce macro PMU_CAP_PERF_METRICS
  KVM: x86/pmu: Add intel_passthrough_pmu_msrs() to pass-through PMU
    MSRs

Kan Liang (8):
  perf: Support get/put passthrough PMU interfaces
  perf: Skip pmu_ctx based on event_type
  perf: Clean up perf ctx time
  perf: Add a EVENT_GUEST flag
  perf: Add generic exclude_guest support
  perf: Add switch_interrupt() interface
  perf/x86: Support switch_interrupt interface
  perf/x86/intel: Support PERF_PMU_CAP_PASSTHROUGH_VPMU

Manali Shukla (1):
  KVM: x86/pmu/svm: Wire up PMU filtering functionality for passthrough
    PMU

Mingwei Zhang (24):
  perf/x86: Forbid PMI handler when guest own PMU
  perf: core/x86: Plumb passthrough PMU capability from x86_pmu to
    x86_pmu_cap
  KVM: x86/pmu: Introduce enable_passthrough_pmu module parameter
  KVM: x86/pmu: Plumb through pass-through PMU to vcpu for Intel CPUs
  KVM: x86/pmu: Add a helper to check if passthrough PMU is enabled
  KVM: x86/pmu: Add host_perf_cap and initialize it in
    kvm_x86_vendor_init()
  KVM: x86/pmu: Allow RDPMC pass through when all counters exposed to
    guest
  KVM: x86/pmu: Introduce PMU operator to check if rdpmc passthrough
    allowed
  KVM: x86/pmu: Create a function prototype to disable MSR interception
  KVM: x86/pmu: Avoid legacy vPMU code when accessing global_ctrl in
    passthrough vPMU
  KVM: x86/pmu: Exclude PMU MSRs in vmx_get_passthrough_msr_slot()
  KVM: x86/pmu: Add counter MSR and selector MSR index into struct
    kvm_pmc
  KVM: x86/pmu: Introduce PMU operation prototypes for save/restore PMU
    context
  KVM: x86/pmu: Implement the save/restore of PMU state for Intel CPU
  KVM: x86/pmu: Make check_pmu_event_filter() an exported function
  KVM: x86/pmu: Allow writing to event selector for GP counters if event
    is allowed
  KVM: x86/pmu: Allow writing to fixed counter selector if counter is
    exposed
  KVM: x86/pmu: Exclude existing vLBR logic from the passthrough PMU
  KVM: x86/pmu: Introduce PMU operator to increment counter
  KVM: x86/pmu: Introduce PMU operator for setting counter overflow
  KVM: x86/pmu: Implement emulated counter increment for passthrough PMU
  KVM: x86/pmu: Update pmc_{read,write}_counter() to disconnect perf API
  KVM: x86/pmu: Disconnect counter reprogram logic from passthrough PMU
  KVM: nVMX: Add nested virtualization support for passthrough PMU

Sandipan Das (12):
  perf/x86: Do not set bit width for unavailable counters
  x86/msr: Define PerfCntrGlobalStatusSet register
  KVM: x86/pmu: Always set global enable bits in passthrough mode
  KVM: x86/pmu/svm: Set passthrough capability for vcpus
  KVM: x86/pmu/svm: Set enable_passthrough_pmu module parameter
  KVM: x86/pmu/svm: Allow RDPMC pass through when all counters exposed
    to guest
  KVM: x86/pmu/svm: Implement callback to disable MSR interception
  KVM: x86/pmu/svm: Set GuestOnly bit and clear HostOnly bit when guest
    write to event selectors
  KVM: x86/pmu/svm: Add registers to direct access list
  KVM: x86/pmu/svm: Implement handlers to save and restore context
  KVM: x86/pmu/svm: Implement callback to increment counters
  perf/x86/amd: Support PERF_PMU_CAP_PASSTHROUGH_VPMU for AMD host

Sean Christopherson (2):
  sched/core: Move preempt_model_*() helpers from sched.h to preempt.h
  sched/core: Drop spinlocks on contention iff kernel is preemptible

Xiong Zhang (8):
  x86/irq: Factor out common code for installing kvm irq handler
  perf: core/x86: Register a new vector for KVM GUEST PMI
  KVM: x86/pmu: Register KVM_GUEST_PMI_VECTOR handler
  KVM: x86/pmu: Manage MSR interception for IA32_PERF_GLOBAL_CTRL
  KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL at VM boundary
  KVM: x86/pmu: Notify perf core at KVM context switch boundary
  KVM: x86/pmu: Grab x86 core PMU for passthrough PMU VM
  KVM: x86/pmu: Add support for PMU context switch at VM-exit/enter

 .../admin-guide/kernel-parameters.txt         |   4 +-
 arch/x86/events/amd/core.c                    |   2 +
 arch/x86/events/core.c                        |  44 +-
 arch/x86/events/intel/core.c                  |   5 +
 arch/x86/include/asm/hardirq.h                |   1 +
 arch/x86/include/asm/idtentry.h               |   1 +
 arch/x86/include/asm/irq.h                    |   2 +-
 arch/x86/include/asm/irq_vectors.h            |   5 +-
 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   6 +
 arch/x86/include/asm/kvm_host.h               |   9 +
 arch/x86/include/asm/msr-index.h              |   2 +
 arch/x86/include/asm/perf_event.h             |   1 +
 arch/x86/include/asm/vmx.h                    |   1 +
 arch/x86/kernel/idt.c                         |   1 +
 arch/x86/kernel/irq.c                         |  39 +-
 arch/x86/kvm/cpuid.c                          |   3 +
 arch/x86/kvm/pmu.c                            | 154 +++++-
 arch/x86/kvm/pmu.h                            |  49 ++
 arch/x86/kvm/svm/pmu.c                        | 136 +++++-
 arch/x86/kvm/svm/svm.c                        |  31 ++
 arch/x86/kvm/svm/svm.h                        |   2 +-
 arch/x86/kvm/vmx/capabilities.h               |   1 +
 arch/x86/kvm/vmx/nested.c                     |  52 +++
 arch/x86/kvm/vmx/pmu_intel.c                  | 192 +++++++-
 arch/x86/kvm/vmx/vmx.c                        | 197 ++++++--
 arch/x86/kvm/vmx/vmx.h                        |   3 +-
 arch/x86/kvm/x86.c                            |  45 ++
 arch/x86/kvm/x86.h                            |   1 +
 include/linux/perf_event.h                    |  38 +-
 include/linux/preempt.h                       |  41 ++
 include/linux/sched.h                         |  41 --
 include/linux/spinlock.h                      |  14 +-
 kernel/events/core.c                          | 441 ++++++++++++++----
 .../beauty/arch/x86/include/asm/irq_vectors.h |   5 +-
 34 files changed, 1373 insertions(+), 196 deletions(-)


base-commit: 6ba59ff4227927d3a8530fc2973b80e94b54d58f
-- 
2.46.0.rc1.232.g9752f9e123-goog


