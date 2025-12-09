Return-Path: <kvm+bounces-65594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 336AFCB1105
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 21:52:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2CE7A30D8107
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 20:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC159307AFC;
	Tue,  9 Dec 2025 20:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i14oFPpD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381A62FF646
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313548; cv=none; b=FhR74mcJWeFB9Gf9dK6C4OYq3f2XCfVVRK2DZilL6SIIAvIxIe/bL2VJzr/bajX/AP7aYi1WpR1+8xcFo4EG0/tq/FHYT31oiBK+E3hu7jipUl5x1rgVKWAq7ZwmlCgGgCdDld8nJpe3SSPxBDE1Pe278mIOLr28U8mpK91r3lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313548; c=relaxed/simple;
	bh=4Qd4+z11xSZNUdv2pVaSUA3BrnQtfQ6vuGOkRvpiMn8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IaTgRA96HFcUwtYHGYbibz+oYEU5B5cHw120fgnDtykZAOV+ZpSCYvruLWotv3Xm2x7mJgmIHEmPzhonUzph/3fHk+zprf5x0IyT/cJodRzug5VON/abNUqXU9r7SABPdZz22cphcY4dm44+iizLkPWvt+CdPnbNtQ4MNdl/CYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i14oFPpD; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7c754daf77fso386586a34.1
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 12:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313545; x=1765918345; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+QORDO0iv5GAAoB+pw+bKtlaMCX74MUcRSdh9R6YR0E=;
        b=i14oFPpDES/7WYsveRHu8p0+/IO+34ZdhAMzaEb5x/6O9pePiLRCi2Gn4vn0ACB/hU
         Wi6PbXheZFYDYgkETKUBmducjUucwmUIjoKb62atMv7OJNS9LLtlYrrykZ87JxJaCNdo
         J/+BDpM5sPpgN27t17bzryUF7oO9b3KsccVsXE2/j12Z1xTQpV2gWBtJc+IcCewp2r47
         JC04c4Su8qguQBMfQR5HjehuXOE8G1B1lA1oBG9y6yog/gMELBU2c2I2usez/9llReNg
         E6J4xuRyyquDGh8IEPanYYefZvEjQAu+9g+VB6Aq4+jPx2qzST0MHXjVxlsQgMoAkpn/
         C7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313545; x=1765918345;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+QORDO0iv5GAAoB+pw+bKtlaMCX74MUcRSdh9R6YR0E=;
        b=kXYTpF6plyf/gMNf/4jBsWKU30hCtq+JSo+WjMIDSKVtBzALPZwzOEHrVpMTGp4u7S
         1zcPu42wFaOXbbWaUACbW9AQhFwaJkW6H2Trcikt+8TmfuzHGkzYdlrpBDVxsH87/ZWh
         7bQA44ZO99KBjacnnpaSiEaxeYjSsZa9K5UwvZDCT1LrxQuke9d2A36Rb+wX15H6AQbQ
         ePCyL12WBBGlmd4gGbvIOyHHlIpFkmIV7WY0SF5gmkqtgb9+Re2nlZBwJt0fKmw+9/2y
         Zgzn50WJKje/PfQ7kTzaDogaoi9H4mo4muPSPvQFwpsCPs60TTKlniUeD5AiBzOwPkVe
         D9EA==
X-Gm-Message-State: AOJu0Yw7JSYye4xCK4PGQB2e3P8XtOWcmrQUX/3HG8FhNtEIgYQOA/cZ
	V8+N8dwpUzXG4cnSiTvAd/0sTA7fP6W9b0ujqKX8BHLLufIPzG2Y60KunN72iDEy7XzdU0jck1D
	DxelP3xsoqx0GolmEYQ6NXyHVsg0VqpmVrCJnx54ytDpYuzahEeoWr39/j1lEc47HAciauoNMzc
	d2dMtlUwBCB00sCwnML0eQrgzMPF5WggZlH8rCF57luLPEnHGyAOOYmjMUr5k=
X-Google-Smtp-Source: AGHT+IGdRrFZwTyyzV2AtNYCuaLjencyIHRHAj3IdwT3n+8P0sgFpuY/232AseTu5ibZEgNLLaD+S5fwza8C4ASYxA==
X-Received: from ilbbq10.prod.google.com ([2002:a05:6e02:238a:b0:438:12c7:3d1b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2291:b0:659:9a49:8e26 with SMTP id 006d021491bc7-65b2353b404mr1189023eaf.24.1765313545232;
 Tue, 09 Dec 2025 12:52:25 -0800 (PST)
Date: Tue,  9 Dec 2025 20:50:57 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-1-coltonlewis@google.com>
Subject: [PATCH v5 00/24] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This series creates a new PMU scheme on ARM, a partitioned PMU that
allows reserving a subset of counters for more direct guest access,
significantly reducing overhead. More details, including performance
benchmarks, can be read in the v1 cover letter linked below.

An overview of what this series accomplishes was presented at KVM
Forum 2025. Slides [1] and video [2] are linked below.

The long duration between v4 and v5 is due to time spent on this
project being monopolized preparing this feature for internal
production. As a result, there are too many improvements to fully list
here, but I will cover the notable ones.

v5:

* Rebase onto v6.18-rc7. This required pulling some reorganization
  patches from Anish and Sean that were dependencies from previous
  versions based on kvm/queue but never made it to upstream.

* Ensure FGTs (fine-grained traps) are correctly programmed at vCPU
  load using kvm_vcpu_load_fgt() and helpers introduced by Oliver
  Upton.

* Cleanly separate concerns of whether the partitioned PMU is enabled
  for the guest and whether FGT should be enabled. This allows that
  the capability can be VM-scoped while the implementation detail of
  whether FGT and context switching are in effect can remain
  vCPU-scoped.

* Shrink the uAPI change. Instead of a cap and corresponding ioctl,
  the feature can be controlled by just a cap with an argument. The
  cap is now also VM-scoped and enforces ordering that it should be
  decided before vCPUs are created. Whether the cap is enabled is now
  tracked by the new flag KVM_ARCH_ARM_PARTITIONED_PMU_ENABLED.

* Improve log messages when partitioning in the PMUv3 driver.

* Introduce a global variable armv8pmu_hpmn_max in the PMUv3 driver so
  KVM code can read if a value was set before the PMU is probed. This
  is needed to properly test if we have the capability before vCPUs
  are created.

* Make it possible for a VMM to filter the HPMN0 feature bit.

* Fix event filter problems with PMEVTYPER handling in
  writethrough_pmevtyper() and kvm_pmu_apply_event_filter() by using
  kvm_pmu_event_mask() in the right spots. And if an event is
  filtered, write the physical register with the appropriate exclude
  bits set but keep the virtual register exactly what the guest wrote.

* Fix register access problems with the PMU register fast path handler
  by lifting some static PMU access checks from sys_regs.c to use them
  in the fast path too and make bit masking more strict for better ARM
  compliance.

* Fix the readability and logic of programming the MDCR_EL2 register
  when entering the guest. Make sure to set the HPME bit to allow host
  counters to count guest events. Set TPM and TPMCR by default and
  clear them if partitioning is enabled rather than the previous
  inverted logic of leaving them clear and setting them if
  partitioning is not enabled. Make the HPMN field computation more
  clear.

* As part of lazy context switching, do a load when the guest is
  switching to physical access to ensure any previous writes that only
  reached the virtual registers reach the physical ones as well and
  are not clobbered by the next vcpu_put().

* Other fixes and improvements that are too small to mention or left
  out from my personal notes.

v4:
https://lore.kernel.org/kvmarm/20250714225917.1396543-1-coltonlewis@google.com/

v3:
https://lore.kernel.org/kvm/20250626200459.1153955-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvm/20250620221326.1261128-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20250602192702.2125115-1-coltonlewis@google.com/

[1] https://gitlab.com/qemu-project/kvm-forum/-/raw/main/_attachments/2025/Optimizing__itvHkhc.pdf
[2] https://www.youtube.com/watch?v=YRzZ8jMIA6M&list=PLW3ep1uCIRfxwmllXTOA2txfDWN6vUOHp&index=9

Anish Ghulati (1):
  KVM: arm64: Move arm_{psci,hypercalls}.h to an internal KVM path

Colton Lewis (20):
  arm64: cpufeature: Add cpucap for HPMN0
  KVM: arm64: Reorganize PMU functions
  perf: arm_pmuv3: Introduce method to partition the PMU
  perf: arm_pmuv3: Generalize counter bitmasks
  perf: arm_pmuv3: Keep out of guest counter partition
  KVM: arm64: Set up FGT for Partitioned PMU
  KVM: arm64: Writethrough trapped PMEVTYPER register
  KVM: arm64: Use physical PMSELR for PMXEVTYPER if partitioned
  KVM: arm64: Writethrough trapped PMOVS register
  KVM: arm64: Write fast path PMU register handlers
  KVM: arm64: Setup MDCR_EL2 to handle a partitioned PMU
  KVM: arm64: Account for partitioning in PMCR_EL0 access
  KVM: arm64: Context swap Partitioned PMU guest registers
  KVM: arm64: Enforce PMU event filter at vcpu_load()
  KVM: arm64: Implement lazy PMU context swaps
  perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters
  KVM: arm64: Inject recorded guest interrupts
  KVM: arm64: Add KVM_CAP to partition the PMU
  KVM: selftests: Add find_bit to KVM library
  KVM: arm64: selftests: Add test case for partitioned PMU

Marc Zyngier (1):
  KVM: arm64: Reorganize PMU includes

Sean Christopherson (2):
  KVM: arm64: Include KVM headers to get forward declarations
  KVM: arm64: Move ARM specific headers in include/kvm to arch directory

 Documentation/virt/kvm/api.rst                |  24 +
 arch/arm/include/asm/arm_pmuv3.h              |  28 +
 arch/arm64/include/asm/arm_pmuv3.h            |  61 +-
 .../arm64/include/asm/kvm_arch_timer.h        |   2 +
 arch/arm64/include/asm/kvm_host.h             |  24 +-
 .../arm64/include/asm/kvm_pmu.h               | 142 ++++
 arch/arm64/include/asm/kvm_types.h            |   7 +-
 .../arm64/include/asm/kvm_vgic.h              |   0
 arch/arm64/kernel/cpufeature.c                |   8 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arch_timer.c                   |   5 +-
 arch/arm64/kvm/arm.c                          |  23 +-
 {include => arch/arm64}/kvm/arm_hypercalls.h  |   0
 {include => arch/arm64}/kvm/arm_psci.h        |   0
 arch/arm64/kvm/config.c                       |  34 +-
 arch/arm64/kvm/debug.c                        |  31 +-
 arch/arm64/kvm/guest.c                        |   2 +-
 arch/arm64/kvm/handle_exit.c                  |   2 +-
 arch/arm64/kvm/hyp/Makefile                   |   6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 211 ++++-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   4 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   4 +-
 arch/arm64/kvm/hypercalls.c                   |   4 +-
 arch/arm64/kvm/pmu-direct.c                   | 464 +++++++++++
 arch/arm64/kvm/pmu-emul.c                     | 678 +---------------
 arch/arm64/kvm/pmu.c                          | 726 ++++++++++++++++++
 arch/arm64/kvm/psci.c                         |   4 +-
 arch/arm64/kvm/pvtime.c                       |   2 +-
 arch/arm64/kvm/reset.c                        |   3 +-
 arch/arm64/kvm/sys_regs.c                     | 110 +--
 arch/arm64/kvm/trace_arm.h                    |   2 +-
 arch/arm64/kvm/trng.c                         |   2 +-
 arch/arm64/kvm/vgic/vgic-debug.c              |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   2 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c              |   2 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c            |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio.c               |   4 +-
 arch/arm64/kvm/vgic/vgic-v2.c                 |   2 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |   3 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |   2 +-
 arch/arm64/kvm/vgic/vgic-v5.c                 |   2 +-
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/sysreg                       |   6 +-
 drivers/perf/arm_pmuv3.c                      | 137 +++-
 include/linux/perf/arm_pmu.h                  |   1 +
 include/linux/perf/arm_pmuv3.h                |  14 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/include/uapi/linux/kvm.h                |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/vpmu_counter_access.c |  77 +-
 tools/testing/selftests/kvm/lib/find_bit.c    |   1 +
 53 files changed, 2049 insertions(+), 831 deletions(-)
 rename include/kvm/arm_arch_timer.h => arch/arm64/include/asm/kvm_arch_timer.h (98%)
 rename include/kvm/arm_pmu.h => arch/arm64/include/asm/kvm_pmu.h (61%)
 rename include/kvm/arm_vgic.h => arch/arm64/include/asm/kvm_vgic.h (100%)
 rename {include => arch/arm64}/kvm/arm_hypercalls.h (100%)
 rename {include => arch/arm64}/kvm/arm_psci.h (100%)
 create mode 100644 arch/arm64/kvm/pmu-direct.c
 create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c


base-commit: ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
--
2.52.0.239.gd5f0c6e74e-goog

