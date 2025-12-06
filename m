Return-Path: <kvm+bounces-65393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 935D0CA9AF8
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:17:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AB3F5302D2F5
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C05171F4CA9;
	Sat,  6 Dec 2025 00:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1s/kbyYI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656F01624D5
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980249; cv=none; b=ColElum2w660WZkW/5KHudzzeL3DgNb5Zsb1effelflKoZKRNY6yI5ZTR1+hJcPUTMOMj7/vWydwQahx0IHmnMjt3cjOamIeMQLyrozLYVHH4Usti5D6xdo8kneaZvHwkHyYJ+RrryrWM0ozp+u384w7mqnjOqVpLEg0xGVaZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980249; c=relaxed/simple;
	bh=QP4QmjQc8T/z9AHHPL+vtIizHhyRAFvn2jC5o5eQuqk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=J8HpaXwyXgWJByFBTLrV8sm9WmRWCK2dFLKTJavk8Q3Yu5XEec9im33+yZSzoJ8jwoolhH+qbdpoNai6tCHk0aiPdldY6Pitfo+4Bm6OZizWi6QOiDcPlH/AyF27YF8b7DL8gVuEmHgdCBajblzbikFOI7M3lUazBW4qoQQfWmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1s/kbyYI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34740cc80d5so5030745a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980247; x=1765585047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSezsuUP7GVTeuW3G7Ce0Uw2WU7zDAG2YHGHXFi0nCo=;
        b=1s/kbyYIDh9rjpZEOA2j4wWDrA27EKxbOyzMptUfo7z2W5BDJTi+e4SD2j3aaSewJ9
         y4x4Fb+3F2IzXj73cEnur5fmqusxqAlMhDzqUHFGcZsoEIqZoFhnlHPinX7h6KYVk/J5
         +hWZyFruptjrexsCFIXnDQ5Ap1Divi36okobyFW312ck2g+8QQESPsyQ/rgQxTraiucG
         A6L7lGYf0R++Lze5H2BtvdMlKirGePUNSO2IHXVSLn6JljW1gxvBmaowlY3tw0Cz8jO/
         sKtAne5BVD0IvD1WKjKt18nA6NzWvttUF0XUTHmyzF+r46cs0e+HmiSUTKwYDWM2qCi+
         xF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980247; x=1765585047;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MSezsuUP7GVTeuW3G7Ce0Uw2WU7zDAG2YHGHXFi0nCo=;
        b=NbRkAJHMd7CEF9+HnkDxG3KI1HAVlsks6jqGO+A79IOxm4WWkMWS3BOWMbzyoIK7wl
         p12P0Mb/5WG3n/VMR2rjRalirELoWA1IeHB1VuV8VZ1kwYZMwv7t1stZf3p+njYqnsgi
         m1s0tu+5CoipWMjATACi/+TDK5jZ2dvpdXjwKe66v741PHrPy2pkiu3U0iIvwz1ASQCk
         2qshR8NxQ7hAgBghoPr0P3D+9m7AJD7DBUkfEGFl+9wIkOvbqXpNTM9SqBzwXE5U/Kdx
         HfyrenycYoQWNo3dDn36+Z++PY7DKzXWyzr9XsemRIPWW7p332HmhZvk5Nw2nTWK/2xc
         kxEw==
X-Forwarded-Encrypted: i=1; AJvYcCUdMPllUzsOoO8pKo6IfguMxFDs88e91R+ZuANxvIq+CCdNt66e1d5fJ+mXU4jh9BBxAUk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzXRNGu16SJr3rYuA9d891YgduAvz6pPwdVAYztmIMkjHZX3wn
	InArJPxFaHycZcjSrKMCxxZ7Qup1jXVmYsdUkFoQU7Vchf6DpxoNIS0+W7LS+EV5/uJHo5eYbkA
	AskojeQ==
X-Google-Smtp-Source: AGHT+IHiJ1XwjkPyv/XDZ8mYgHFlbVY/itlRL8b0SyPq+8tYW9JzQWXLcb2ZnJiXZieINXSPzEO7L5r7ZNs=
X-Received: from pjbfv10.prod.google.com ([2002:a17:90b:e8a:b0:32b:58d1:a610])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5903:b0:349:162d:ae1e
 with SMTP id 98e67ed59e1d1-349a260b09amr679545a91.33.1764980246735; Fri, 05
 Dec 2025 16:17:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:36 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-1-seanjc@google.com>
Subject: [PATCH v6 00/44] KVM: x86: Add support for mediated vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

This series is based on 'https://github.com/kvm-x86/linux next', but except
for one minor conflict in perf should apply on Linus' tree once the KVM 6.19
pull request lands.  I considered waiting until 6.19-rc1 to post this, but
I've had this in a "ready" state for a few weeks and want to get it out there.

My hope/plan is that the perf changes will go through the tip tree with a
stable tag/branch, and the KVM changes will go the kvm-x86 tree.

Non-x86 KVM folks, y'all are getting Cc'd due to minor changes in "KVM: Add a
simplified wrapper for registering perf callbacks".

The full set is also available at:

  https://github.com/sean-jc/linux.git tags/mediated-vpmu-v6

Add support for mediated vPMUs in KVM x86, where "mediated" aligns with the
standard definition of intercepting control operations (e.g. event selectors),
while allowing the guest to perform data operations (e.g. read PMCs, toggle
counters on/off) without KVM getting involed.

For an in-depth description of the what and why, please see the cover letter
from the original RFC:

  https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com

All KVM tests pass (or fail the same before and after), and I've manually
verified MSR/PMC are passed through as expected, but I haven't done much at all
to actually utilize the PMU in a guest.

Despite merging almost all of the tangentially related prep work for 6.19,
the patch count remains the same as v5 thanks to the VMX MSR auto-store
cleanup and support for pre-SPR Intel CPUs.

v6:
 - Add back support for pre-SPR Intel CPUs, i.e. CPUs with PMU v4 but not
   "save PERF_GLOBAL_CTRL on VM-Exit".  See 
   https://lore.kernel.org/all/aSUK8FuWT4lpMP3F@google.com for details.
 - Add an x86-only API to update the LVTPC entry on load/put of a mediated
   vPMU. [PeterZ]
 - Don't tie RDPMC interception to PERF_GLOBAL_CTRL interception, as AMD
   CPUs have scenarios where KVM needs to intercept PERF_GLOBAL_CTRL, but
   not all PMC accesses. [Sandipan]
 - Fix a s/Turing/Turin typo. [Manali]
 - Collect tags. [Anup, Sandipan, Xudong]

v5:
 -  https://lore.kernel.org/all/20250806195706.1650976-1-seanjc@google.com
 - Add a patch to call security_perf_event_free() from __free_event()
   instead of _free_event() (necessitated by the __cleanup() changes).
 - Add CONFIG_PERF_GUEST_MEDIATED_PMU to guard the new perf functionality.
 - Ensure the PMU is fully disabled in perf_{load,put}_guest_context() when
   when switching between guest and host context. [Kan, Namhyung]
 - Route the new system IRQ, PERF_GUEST_MEDIATED_PMI_VECTOR, through perf,
   not KVM, and play nice with FRED.
 - Rename and combine perf_{guest,host}_{enter,exit}() to a single set of
   APIs, perf_{load,put}_guest_context().
 - Rename perf_{get,put}_mediated_pmu() to perf_{create,release}_mediated_pmu()
   to (hopefully) better differentiate them from perf_{load,put}_guest_context().
 - Change the param to the load/put APIs from "u32 guest_lvtpc" to
   "unsigned long data" to decouple arch code as much as possible.  E.g. if
   a non-x86 arch were to ever support a mediated vPMU, @data could be used
   to pass a pointer to a struct.
 - Use pmu->version to detect if a vCPU has a mediated PMU.
 - Use a kvm_x86_ops hook to check for mediated PMU support.
 - Cull "passthrough" from as many places as I could find.
 - Improve the changelog/documentation related to RDPMC interception.
 - Check harware capabilities, not KVM capabilities, when calculating
   MSR and RDPMC intercepts.
 - Rework intercept (re)calculation to use a request and the existing (well,
   will be existing as of 6.17-rc1) vendor hooks for recalculating intercepts.
 - Always read PERF_GLOBAL_CTRL on VM-Exit if writes weren't intercepted while
   running the vCPU.
 - Call setup_vmcs_config() before kvm_x86_vendor_init() so that the golden
   VMCS configuration is known before kvm_init_pmu_capability() is called.
 - Keep as much refresh/init code in common x86 as possible.
 - Context switch PMCs and event selectors in common x86, not vendor code.
 - Bail from the VM-Exit fastpath if the guest is counting instructions
   retired and the mediated PMU is enabled (because guest state hasn't yet
   been synchronized with hardware).
 - Don't require an userspace to opt-in via KVM_CAP_PMU_CAPABILITY, and instead
   automatically "create" a mediated PMU on the first KVM_CREATE_VCPU call if
   the VM has an in-kernel local APIC.
 - Add entries in kernel-parameters.txt for the PMU params.
 - Add a patch to elide PMC writes when possible.
 - Many more fixups and tweaks...

v4:
 - https://lore.kernel.org/all/20250324173121.1275209-1-mizhang@google.com
 - Rebase whole patchset on 6.14-rc3 base.
 - Address Peter's comments on Perf part.
 - Address Sean's comments on KVM part.
   * Change key word "passthrough" to "mediated" in all patches
   * Change static enabling to user space dynamic enabling via KVM_CAP_PMU_CAPABILITY.
   * Only support GLOBAL_CTRL save/restore with VMCS exec_ctrl, drop the MSR
     save/retore list support for GLOBAL_CTRL, thus the support of mediated
     vPMU is constrained to SapphireRapids and later CPUs on Intel side.
   * Merge some small changes into a single patch.
 - Address Sandipan's comment on invalid pmu pointer.
 - Add back "eventsel_hw" and "fixed_ctr_ctrl_hw" to avoid to directly
   manipulate pmc->eventsel and pmu->fixed_ctr_ctrl.

v3: https://lore.kernel.org/all/20240801045907.4010984-1-mizhang@google.com
v2: https://lore.kernel.org/all/20240506053020.3911940-1-mizhang@google.com
v1: https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com

Dapeng Mi (11):
  KVM: x86/pmu: Start stubbing in mediated PMU support
  KVM: x86/pmu: Implement Intel mediated PMU requirements and
    constraints
  KVM: x86/pmu: Disable RDPMC interception for compatible mediated vPMU
  KVM: x86/pmu: Load/save GLOBAL_CTRL via entry/exit fields for mediated
    PMU
  KVM: x86/pmu: Disable interception of select PMU MSRs for mediated
    vPMUs
  KVM: x86/pmu: Bypass perf checks when emulating mediated PMU counter
    accesses
  KVM: x86/pmu: Reprogram mediated PMU event selectors on event filter
    updates
  KVM: x86/pmu: Load/put mediated PMU context when entering/exiting
    guest
  KVM: x86/pmu: Handle emulated instruction for mediated vPMU
  KVM: nVMX: Add macros to simplify nested MSR interception setting
  KVM: x86/pmu: Expose enable_mediated_pmu parameter to user space

Kan Liang (7):
  perf: Skip pmu_ctx based on event_type
  perf: Add generic exclude_guest support
  perf: Add APIs to create/release mediated guest vPMUs
  perf: Clean up perf ctx time
  perf: Add a EVENT_GUEST flag
  perf: Add APIs to load/put guest mediated PMU context
  perf/x86/intel: Support PERF_PMU_CAP_MEDIATED_VPMU

Mingwei Zhang (3):
  perf/x86/core: Plumb mediated PMU capability from x86_pmu to
    x86_pmu_cap
  KVM: x86/pmu: Introduce eventsel_hw to prepare for pmu event filtering
  KVM: nVMX: Disable PMU MSR interception as appropriate while running
    L2

Sandipan Das (3):
  perf/x86/core: Do not set bit width for unavailable counters
  perf/x86/amd: Support PERF_PMU_CAP_MEDIATED_VPMU for AMD host
  KVM: x86/pmu: Always stuff GuestOnly=1,HostOnly=0 for mediated PMCs on
    AMD

Sean Christopherson (19):
  perf: Move security_perf_event_free() call to __free_event()
  perf/x86/core: Register a new vector for handling mediated guest PMIs
  perf/x86/core: Add APIs to switch to/from mediated PMI vector (for
    KVM)
  KVM: Add a simplified wrapper for registering perf callbacks
  KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
  KVM: x86/pmu: Implement AMD mediated PMU requirements
  KVM: x86/pmu: Disallow emulation in the fastpath if mediated PMCs are
    active
  KVM: nSVM: Disable PMU MSR interception as appropriate while running
    L2
  KVM: x86/pmu: Elide WRMSRs when loading guest PMCs if values already
    match
  KVM: VMX: Drop intermediate "guest" field from msr_autostore
  KVM: nVMX: Don't update msr_autostore count when saving TSC for vmcs12
  KVM: VMX: Dedup code for removing MSR from VMCS's auto-load list
  KVM: VMX: Drop unused @entry_only param from add_atomic_switch_msr()
  KVM: VMX: Bug the VM if either MSR auto-load list is full
  KVM: VMX: Set MSR index auto-load entry if and only if entry is "new"
  KVM: VMX: Compartmentalize adding MSRs to host vs. guest auto-load
    list
  KVM: VMX: Dedup code for adding MSR to VMCS's auto list
  KVM: VMX: Initialize vmcs01.VM_EXIT_MSR_STORE_ADDR with list address
  KVM: VMX: Add mediated PMU support for CPUs without "save perf global
    ctrl"

Xiong Zhang (1):
  KVM: x86/pmu: Register PMI handler for mediated vPMU

 .../admin-guide/kernel-parameters.txt         |  49 ++
 arch/arm64/kvm/arm.c                          |   2 +-
 arch/loongarch/kvm/main.c                     |   2 +-
 arch/riscv/kvm/main.c                         |   2 +-
 arch/x86/entry/entry_fred.c                   |   1 +
 arch/x86/events/amd/core.c                    |   2 +
 arch/x86/events/core.c                        |  37 +-
 arch/x86/events/intel/core.c                  |   5 +
 arch/x86/include/asm/hardirq.h                |   3 +
 arch/x86/include/asm/idtentry.h               |   6 +
 arch/x86/include/asm/irq_vectors.h            |   4 +-
 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   4 +
 arch/x86/include/asm/kvm_host.h               |   3 +
 arch/x86/include/asm/msr-index.h              |   1 +
 arch/x86/include/asm/perf_event.h             |   6 +
 arch/x86/include/asm/vmx.h                    |   1 +
 arch/x86/kernel/idt.c                         |   3 +
 arch/x86/kernel/irq.c                         |  19 +
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/pmu.c                            | 271 ++++++++-
 arch/x86/kvm/pmu.h                            |  37 +-
 arch/x86/kvm/svm/nested.c                     |  18 +-
 arch/x86/kvm/svm/pmu.c                        |  44 ++
 arch/x86/kvm/svm/svm.c                        |  46 ++
 arch/x86/kvm/vmx/capabilities.h               |   9 +-
 arch/x86/kvm/vmx/nested.c                     | 144 ++---
 arch/x86/kvm/vmx/pmu_intel.c                  |  92 +++-
 arch/x86/kvm/vmx/pmu_intel.h                  |  15 +
 arch/x86/kvm/vmx/vmx.c                        | 212 +++++--
 arch/x86/kvm/vmx/vmx.h                        |   9 +-
 arch/x86/kvm/x86.c                            |  54 +-
 arch/x86/kvm/x86.h                            |   1 +
 include/linux/kvm_host.h                      |  11 +-
 include/linux/perf_event.h                    |  35 +-
 init/Kconfig                                  |   4 +
 kernel/events/core.c                          | 517 ++++++++++++++----
 .../beauty/arch/x86/include/asm/irq_vectors.h |   3 +-
 virt/kvm/kvm_main.c                           |   6 +-
 38 files changed, 1396 insertions(+), 283 deletions(-)


base-commit: 5d3e2d9ba9ed68576c70c127e4f7446d896f2af2
-- 
2.52.0.223.gf5cc29aaa4-goog


