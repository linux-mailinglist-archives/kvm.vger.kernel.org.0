Return-Path: <kvm+bounces-54142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7777CB1CCC5
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 21:58:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 748707ADB88
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 19:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790842BE65A;
	Wed,  6 Aug 2025 19:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gss35WQe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5472BD03E
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510251; cv=none; b=ZwhrHDxTkHgq1etzPRD/zoYCSRjeoCQ57ZbMPaB8uT/rVUskcHDqfKF4rh9N4DLJK7DZ2hZ0zvNBz2WnWBp0bVLHW9rG4alFx3g+hq1xlod2YjJFKtDPI6+8xVumDFCe17jizwy75JfzsKprbD4GQWkg62ulPYmRI5uhnOX0JZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510251; c=relaxed/simple;
	bh=7ItWeP68jXOqxjRGL8UcVyhL0v+vsphGfvNRONop5fg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cN9g2TNT8uGpjDPhIUugxn7JB/hSqeYOh9NVecvOtJF/XwrM9fgu7ePkG7AkNI9NknKjYSF06lxQNUdX6EKfvv+OSCF4Aefvl4MXSMBWvxvFq3XsO8vjeN6GK8xGlsI/hKeTXSBDClfR9X5MClw9/Qt/cRXbTn38i5DAoQWeWh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gss35WQe; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ea14cc097so281518a91.3
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510249; x=1755115049; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YiSAi80MlZj2ytBXJIndfL/QD0SGw7awSa7/LhzXfd4=;
        b=gss35WQe3Hfg2qFAZRNqoOWx6LB3Uis/B+dIFLtUObxQV5qGepSFMKUyiOCpPJhKES
         OznpmiH0cQQEjDKmjIJVtJ/RY6YujNoUiUnOiUztbaWxrJSKAERS/RxvQwDtgTPauxqG
         MvRSuS7UfqrClRvfdqPPncx41sOpTnay7nJqnKI6tuml+kVr2wHrBhlwIOzqhmO4FCTD
         bUYZUyGm89RC/8rUlJ2EJPPlO0r8I8H1XNVrHqGbhT35aMEhtU55ktO21gfLWRz0v8bV
         axWuK61B4NjhejdQ2TPCTQN+Lv/57WnDUvQYextzgpXzxUhJW8gk4TtFtZF+kqoSf2uW
         cLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510249; x=1755115049;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YiSAi80MlZj2ytBXJIndfL/QD0SGw7awSa7/LhzXfd4=;
        b=jxQrXFBs/n89vqx7OWFiTqPE2WAdOd2t9upqI8MgDDQUHUB8jIYryLKwB8CgjvdhTD
         jXOQRV0NXoscnYZ1qpB/H6SZlPEVUlmG02TcRzj8zyVijRcGiaBuuL4/2fynp2uSiatg
         K2fAMlpmNX6ivm+SAXhLBJxiEYcFcJHh/nZxOY36zKZH+NUZkEHRgx2Oj0H7XVG/k50H
         UqHNHOsWKP9a1scva74nNZtkQZIPeK+xAGwo7/apJAwS+gYGwTJd/+QPWtfP/3iRqxy8
         A65FmmwWQz2D1BsigcBo9wJh/pT71QrQPrp7QMM8Or+qrAo7S/Olq49ipI6fwPORJ8I6
         XC1g==
X-Forwarded-Encrypted: i=1; AJvYcCVZ4w2TYmFr28hsjkj0eD5a7zH7n2iM9GaoR3HmhUBUYsHDQuWbiy6HGxLP/VI8YlEq3Xc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhO3+qHpkJqpJs+UCUwpGDM40nXh3BWjZj05j2C44sUHtMyOWR
	KtVzksEs0P6A5jnXN8sn2GmhqGWnchCMKboJYqwAMb3WE5Vx6DJIaI2tO8ybU5GQLFU4n2idO1b
	qwQ/zJQ==
X-Google-Smtp-Source: AGHT+IEiZF4ZVXP/srLo4kntXv21eK34Ewron2VGf18IaFFGcm86hQQPlcpG9BeCZl+mVxBNNadcXtcYKE4=
X-Received: from pjoa3.prod.google.com ([2002:a17:90a:8c03:b0:312:14e5:174b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c2:b0:31c:15d9:8aa
 with SMTP id 98e67ed59e1d1-32166cd17a9mr5063314a91.34.1754510248842; Wed, 06
 Aug 2025 12:57:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:22 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-1-seanjc@google.com>
Subject: [PATCH v5 00/44] KVM: x86: Add support for mediated vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

This series is based on the fastpath+PMU cleanups series[*] (which is based on
kvm/queue), but the non-KVM changes apply cleanly on v6.16 or Linus' tree.
I.e. if you only care about the perf changes, I would just apply on whatever
branch is convenient and stop when you hit the KVM changes.

My hope/plan is that the perf changes will go through the tip tree with a
stable tag/branch, and the KVM changes will go the kvm-x86 tree.

Non-x86 KVM folks, y'all are getting Cc'd due to minor changes in "KVM: Add a
simplified wrapper for registering perf callbacks".

The full set is also available at:

  https://github.com/sean-jc/linux.git tags/mediated-vpmu-v5

Add support for mediated vPMUs in KVM x86, where "mediated" aligns with the
standard definition of intercepting control operations (e.g. event selectors),
while allowing the guest to perform data operations (e.g. read PMCs, toggle
counters on/off) without KVM getting involed.

For an in-depth description of the what and why, please see the cover letter
from the original RFC:

  https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com

All KVM tests pass (or fail the same before and after), and I've manually
verified MSR/PMC are passed through as expected, but I haven't done much at all
to actually utilize the PMU in a guest.  I'll be amazed if I didn't make at
least one major goof.

Similarly, I tried to address all feedback, but there are many, many changes
relative to v4.  If I missed something, I apologize in advance.

In other words, please thoroughly review and test.

[*] https://lore.kernel.org/all/20250805190526.1453366-1-seanjc@google.com

v5:
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

Dapeng Mi (15):
  KVM: x86/pmu: Start stubbing in mediated PMU support
  KVM: x86/pmu: Implement Intel mediated PMU requirements and
    constraints
  KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
  KVM: x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h header
  KVM: VMX: Add helpers to toggle/change a bit in VMCS execution
    controls
  KVM: x86/pmu: Disable RDPMC interception for compatible mediated vPMU
  KVM: x86/pmu: Load/save GLOBAL_CTRL via entry/exit fields for mediated
    PMU
  KVM: x86/pmu: Use BIT_ULL() instead of open coded equivalents
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

Sean Christopherson (15):
  perf: Move security_perf_event_free() call to __free_event()
  perf: core/x86: Register a new vector for handling mediated guest PMIs
  perf/x86: Switch LVTPC to/from mediated PMI vector on guest load/put
    context
  KVM: VMX: Setup canonical VMCS config prior to kvm_x86_vendor_init()
  KVM: SVM: Check pmu->version, not enable_pmu, when getting PMC MSRs
  KVM: Add a simplified wrapper for registering perf callbacks
  KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
  KVM: x86/pmu: Implement AMD mediated PMU requirements
  KVM: x86: Rework KVM_REQ_MSR_FILTER_CHANGED into a generic
    RECALC_INTERCEPTS
  KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates
  KVM: x86/pmu: Move initialization of valid PMCs bitmask to common x86
  KVM: x86/pmu: Restrict GLOBAL_{CTRL,STATUS}, fixed PMCs, and PEBS to
    PMU v2+
  KVM: x86/pmu: Disallow emulation in the fastpath if mediated PMCs are
    active
  KVM: nSVM: Disable PMU MSR interception as appropriate while running
    L2
  KVM: x86/pmu: Elide WRMSRs when loading guest PMCs if values already
    match

Xiong Zhang (1):
  KVM: x86/pmu: Register PMI handler for mediated vPMU

 .../admin-guide/kernel-parameters.txt         |  49 ++
 arch/arm64/kvm/arm.c                          |   2 +-
 arch/loongarch/kvm/main.c                     |   2 +-
 arch/riscv/kvm/main.c                         |   2 +-
 arch/x86/entry/entry_fred.c                   |   1 +
 arch/x86/events/amd/core.c                    |   2 +
 arch/x86/events/core.c                        |  32 +-
 arch/x86/events/intel/core.c                  |   5 +
 arch/x86/include/asm/hardirq.h                |   3 +
 arch/x86/include/asm/idtentry.h               |   6 +
 arch/x86/include/asm/irq_vectors.h            |   4 +-
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   4 +
 arch/x86/include/asm/kvm_host.h               |   7 +-
 arch/x86/include/asm/msr-index.h              |  17 +-
 arch/x86/include/asm/perf_event.h             |   1 +
 arch/x86/include/asm/vmx.h                    |   1 +
 arch/x86/kernel/idt.c                         |   3 +
 arch/x86/kernel/irq.c                         |  19 +
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/cpuid.c                          |   2 +
 arch/x86/kvm/pmu.c                            | 272 ++++++++-
 arch/x86/kvm/pmu.h                            |  37 +-
 arch/x86/kvm/svm/nested.c                     |  18 +-
 arch/x86/kvm/svm/pmu.c                        |  51 +-
 arch/x86/kvm/svm/svm.c                        |  54 +-
 arch/x86/kvm/vmx/capabilities.h               |  11 +-
 arch/x86/kvm/vmx/main.c                       |  14 +-
 arch/x86/kvm/vmx/nested.c                     |  65 ++-
 arch/x86/kvm/vmx/pmu_intel.c                  | 169 ++++--
 arch/x86/kvm/vmx/pmu_intel.h                  |  15 +
 arch/x86/kvm/vmx/vmx.c                        | 143 +++--
 arch/x86/kvm/vmx/vmx.h                        |  11 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |  69 ++-
 arch/x86/kvm/x86.h                            |   1 +
 include/linux/kvm_host.h                      |  11 +-
 include/linux/perf_event.h                    |  38 +-
 init/Kconfig                                  |   4 +
 kernel/events/core.c                          | 521 ++++++++++++++----
 .../beauty/arch/x86/include/asm/irq_vectors.h |   3 +-
 virt/kvm/kvm_main.c                           |   6 +-
 42 files changed, 1385 insertions(+), 295 deletions(-)


base-commit: 53d61a43a7973f812caa08fa922b607574befef4
-- 
2.50.1.565.gc32cd1483b-goog


