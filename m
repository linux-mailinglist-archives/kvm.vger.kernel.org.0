Return-Path: <kvm+bounces-33588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 636A49EEE72
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 16:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C3CD286CF7
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 15:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4446222D7D;
	Thu, 12 Dec 2024 15:56:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8527A2210F2;
	Thu, 12 Dec 2024 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019001; cv=none; b=j57r/802gxmk8LuLcdw/1IWVBY9aCQX18IErNbXHlpnQvEAPHQa+rm1LMt+4tgWy9gI68LVoZ+Eg0+2wUBeLz5Sl6pb6TkzLvuXXx7WPc6s70FPBUEdVJ7aaKDCHOpDnbTohD7czD3p0tiLiEM/3aeGXPlBLXUt3Cg2kxddB/ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019001; c=relaxed/simple;
	bh=G96xLoC/eSHXYXHq+4DeBJeMDS2lbNoxJbax3AUA8J0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NWP2F1TmrHqwdNRQs1gr/0vjnd4OQFo+fcmpI4g8HB5sco0voNeYcHIadJtE9DaqSM3iN0pUKITuej+lMkaWGneXUBXFpCtv9uEwQLWDyYssMibJWMVlB+YcZx48m8oEllL+Jn4qEh5bSqLSDveseRkt4qgfKOtyvmiDwINhaQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E36B71762;
	Thu, 12 Dec 2024 07:57:05 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.39.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B30E53F720;
	Thu, 12 Dec 2024 07:56:33 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v6 00/43] arm64: Support for Arm CCA in KVM
Date: Thu, 12 Dec 2024 15:55:25 +0000
Message-ID: <20241212155610.76522-1-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds support for running protected VMs using KVM under the
Arm Confidential Compute Architecture (CCA).

The related guest support was merged for v6.13-rc1 so you no longer need
that separately.

There are numerous changes since v5, many thanks for the review
comments. The highlights are below, and individual patches have a changelog.

 * KVM_VCPU_MAX_FEATURES is incremented. *NOTE*: This effectively
   exposes the nested virtualisation feature. So this series as it
   stands has a dependency on that being finished before it can be
   merged. See [2] for more details.

 * Properly support the RMM providing a more limited number of GIC LRs
   than the hardware.

 * Drop patch tracking number of pages for the top level PGD, it's
   easier calculating it when we need it.

 * Drop the "spare page" - it was causing code complexity and it's a bit
   premature to start making such optimisations before we've got real
   platforms to benchmark.

Major limitations:

 * Only supports 4k host PAGE_SIZE (if PAGE_SIZE != 4k then the realm
   extensions are disabled). I'm looking at removing this restriction,
   but I didn't want to delay this posting.

 * No support for huge pages when mapping the guest's pages. There is
   some 'dead' code left over from before guest_mem was supported. This
   is partly a current limitation of guest_memfd. It's also on my todo list to
   look at improving this.

The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[1].

This series is based on v6.13-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v6

Work in progress changes for kvmtool are available from the git
repository below:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v4

[1] https://developer.arm.com/documentation/den0137/1-0rel0/
[2] https://lore.kernel.org/r/a7011738-a084-46fa-947f-395d90b37f8b%40arm.com

Jean-Philippe Brucker (7):
  arm64: RME: Propagate number of breakpoints and watchpoints to
    userspace
  arm64: RME: Set breakpoint parameters through SET_ONE_REG
  arm64: RME: Initialize PMCR.N with number counter supported by RMM
  arm64: RME: Propagate max SVE vector length from RMM
  arm64: RME: Configure max SVE vector length for a Realm
  arm64: RME: Provide register list for unfinalized RME RECs
  arm64: RME: Provide accurate register list

Joey Gouly (2):
  arm64: rme: allow userspace to inject aborts
  arm64: rme: support RSI_HOST_CALL

Sean Christopherson (1):
  KVM: Prepare for handling only shared mappings in mmu_notifier events

Steven Price (30):
  arm64: RME: Handle Granule Protection Faults (GPFs)
  arm64: RME: Add SMC definitions for calling the RMM
  arm64: RME: Add wrappers for RMI calls
  arm64: RME: Check for RME support at KVM init
  arm64: RME: Define the user ABI
  arm64: RME: ioctls to create and configure realms
  arm64: kvm: Allow passing machine type in KVM creation
  arm64: RME: RTT tear down
  arm64: RME: Allocate/free RECs to match vCPUs
  KVM: arm64: vgic: Provide helper for number of list registers
  arm64: RME: Support for the VGIC in realms
  KVM: arm64: Support timers in realm RECs
  arm64: RME: Allow VMM to set RIPAS
  arm64: RME: Handle realm enter/exit
  KVM: arm64: Handle realm MMIO emulation
  arm64: RME: Allow populating initial contents
  arm64: RME: Runtime faulting of memory
  KVM: arm64: Handle realm VCPU load
  KVM: arm64: Validate register access for a Realm VM
  KVM: arm64: Handle Realm PSCI requests
  KVM: arm64: WARN on injected undef exceptions
  arm64: Don't expose stolen time for realm guests
  arm64: RME: Always use 4k pages for realms
  arm64: rme: Prevent Device mappings for Realms
  arm_pmu: Provide a mechanism for disabling the physical IRQ
  arm64: rme: Enable PMU support with a realm guest
  kvm: rme: Hide KVM_CAP_READONLY_MEM for realm guests
  arm64: kvm: Expose support for private memory
  KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
  KVM: arm64: Allow activating realms

Suzuki K Poulose (3):
  kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  kvm: arm64: Expose debug HW register numbers for Realm
  arm64: rme: Allow checking SVE on VM instance

 Documentation/virt/kvm/api.rst       |    3 +
 arch/arm64/include/asm/kvm_emulate.h |   40 +
 arch/arm64/include/asm/kvm_host.h    |   17 +-
 arch/arm64/include/asm/kvm_rme.h     |  152 +++
 arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
 arch/arm64/include/asm/rmi_smc.h     |  259 +++++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/include/uapi/asm/kvm.h    |   49 +
 arch/arm64/kvm/Kconfig               |    1 +
 arch/arm64/kvm/Makefile              |    3 +-
 arch/arm64/kvm/arch_timer.c          |   45 +-
 arch/arm64/kvm/arm.c                 |  174 ++-
 arch/arm64/kvm/guest.c               |  107 +-
 arch/arm64/kvm/hypercalls.c          |    4 +-
 arch/arm64/kvm/inject_fault.c        |    6 +-
 arch/arm64/kvm/mmio.c                |   16 +-
 arch/arm64/kvm/mmu.c                 |  195 +++-
 arch/arm64/kvm/pmu-emul.c            |    6 +
 arch/arm64/kvm/psci.c                |   29 +
 arch/arm64/kvm/reset.c               |   23 +-
 arch/arm64/kvm/rme-exit.c            |  195 ++++
 arch/arm64/kvm/rme.c                 | 1588 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            |   79 +-
 arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
 arch/arm64/kvm/vgic/vgic-v3.c        |    5 +
 arch/arm64/kvm/vgic/vgic.c           |   54 +-
 arch/arm64/mm/fault.c                |   31 +-
 drivers/perf/arm_pmu.c               |   15 +
 include/kvm/arm_arch_timer.h         |    2 +
 include/kvm/arm_pmu.h                |    4 +
 include/kvm/arm_psci.h               |    2 +
 include/linux/kvm_host.h             |    2 +
 include/linux/perf/arm_pmu.h         |    5 +
 include/uapi/linux/kvm.h             |   31 +-
 virt/kvm/kvm_main.c                  |    7 +
 35 files changed, 3557 insertions(+), 103 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rme.h
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 arch/arm64/include/asm/rmi_smc.h
 create mode 100644 arch/arm64/kvm/rme-exit.c
 create mode 100644 arch/arm64/kvm/rme.c

-- 
2.43.0


