Return-Path: <kvm+bounces-43424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEAB2A90495
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 15:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2976C17C8CE
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 13:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE8271AF0A4;
	Wed, 16 Apr 2025 13:43:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8531A23B0;
	Wed, 16 Apr 2025 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811008; cv=none; b=tZGnasikt4XTr+6we0P9a+XTWs+b7Qv+MpcFKJB3yEwuDbH4KPCdgkIleM5Jo49i+9Z/mZv8SENwG64yQ+MrObyYbi8cPsKD4OEVIdWTBbyodsdbH25+cyy5TL1p0xw3IhVtwP6e0EL0CKOiLfswF3rHbEpWY3WQXVif4ihghFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811008; c=relaxed/simple;
	bh=uZrx/R+c96B6f1yZ874Z3PH13AxzGewggazq0D+ga7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ksnxp033dbQCw8Z6A+sFsXSxdhnjtz9cwVSh95th+RU3OOeCMH3eZN2l6Fam3IQ4Rx0ifPrWXV5mbiSoKV2JYV2kc4qu57C5oXPqkn33FczlGy6B4iSoyzP0IO+f3fF/qN3W+SF87TfbqMuSZv7TkkquFF9yl+Ey98nElF9+l3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56EED1595;
	Wed, 16 Apr 2025 06:43:22 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.90.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B111A3F59E;
	Wed, 16 Apr 2025 06:43:19 -0700 (PDT)
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
Subject: [PATCH v8 00/43] arm64: Support for Arm CCA in KVM
Date: Wed, 16 Apr 2025 14:41:22 +0100
Message-ID: <20250416134208.383984-1-steven.price@arm.com>
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

The related guest support was merged for v6.14-rc1 so you no longer need
that separately.

There are a few changes since v7, many thanks for the review
comments. The highlights are below, and individual patches have a changelog.

 * More documentation - the new ioctls and capabilties are now all
   documented.

 * Initial patch adding "only_private"/"only_shared" to struct
   kvm_gfn_range replaced with already upstream "attr_filter".

 * Improvement in variable naming and error codes, and some improved/new
   comments. All following valuable review feedback (thanks!).

 * Drop the final WIP patch for enabling large PAGE_SIZE support. It's
   not ready for merging and I want to focus on landing the 4k support.

 * Rebased onto v6.15-rc1.

Things to note:

 * The magic numbers for capabilities and ioctls have been updated. So
   you'll need to update your VMM. See below for update kvmtool branch.

 * Patch 42 increases KVM_VCPU_MAX_FEATURES to expose the new feature.
   This also exposes the NV features (as they are currently numbered
   lower). This will resolve when Marc's NV series has landed, see [2].

 * There are some conflicts with v6.15-rc2, mostly documentation, but
   also commit 26fbdf369227 ("KVM: arm64: Don't translate FAR if
   invalid/unsafe") 'hijacks' HPFAR_EL2_NS as a valid bit. This will
   require corresponding changes to the CCA code.

The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[1].

This series is based on v6.15-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v8

Work in progress changes for kvmtool are available from the git
repository below:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v6

[1] https://developer.arm.com/documentation/den0137/1-0rel0/
[2] https://lore.kernel.org/r/20250408105225.4002637-17-maz%40kernel.org

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
  arm64: RME: allow userspace to inject aborts
  arm64: RME: support RSI_HOST_CALL

Steven Price (31):
  arm64: RME: Handle Granule Protection Faults (GPFs)
  arm64: RME: Add SMC definitions for calling the RMM
  arm64: RME: Add wrappers for RMI calls
  arm64: RME: Check for RME support at KVM init
  arm64: RME: Define the user ABI
  arm64: RME: ioctls to create and configure realms
  KVM: arm64: Allow passing machine type in KVM creation
  arm64: RME: RTT tear down
  arm64: RME: Allocate/free RECs to match vCPUs
  KVM: arm64: vgic: Provide helper for number of list registers
  arm64: RME: Support for the VGIC in realms
  KVM: arm64: Support timers in realm RECs
  arm64: RME: Allow VMM to set RIPAS
  arm64: RME: Handle realm enter/exit
  arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
  KVM: arm64: Handle realm MMIO emulation
  arm64: RME: Allow populating initial contents
  arm64: RME: Runtime faulting of memory
  KVM: arm64: Handle realm VCPU load
  KVM: arm64: Validate register access for a Realm VM
  KVM: arm64: Handle Realm PSCI requests
  KVM: arm64: WARN on injected undef exceptions
  arm64: Don't expose stolen time for realm guests
  arm64: RME: Always use 4k pages for realms
  arm64: RME: Prevent Device mappings for Realms
  arm_pmu: Provide a mechanism for disabling the physical IRQ
  arm64: RME: Enable PMU support with a realm guest
  arm64: RME: Hide KVM_CAP_READONLY_MEM for realm guests
  KVM: arm64: Expose support for private memory
  KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
  KVM: arm64: Allow activating realms

Suzuki K Poulose (3):
  kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  kvm: arm64: Don't expose debug capabilities for realm guests
  arm64: RME: Allow checking SVE on VM instance

 Documentation/virt/kvm/api.rst       |   91 +-
 arch/arm64/include/asm/kvm_emulate.h |   40 +
 arch/arm64/include/asm/kvm_host.h    |   17 +-
 arch/arm64/include/asm/kvm_rme.h     |  137 +++
 arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
 arch/arm64/include/asm/rmi_smc.h     |  259 ++++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/include/uapi/asm/kvm.h    |   49 +
 arch/arm64/kvm/Kconfig               |    1 +
 arch/arm64/kvm/Makefile              |    3 +-
 arch/arm64/kvm/arch_timer.c          |   48 +-
 arch/arm64/kvm/arm.c                 |  160 ++-
 arch/arm64/kvm/guest.c               |  104 +-
 arch/arm64/kvm/hypercalls.c          |    4 +-
 arch/arm64/kvm/inject_fault.c        |    5 +-
 arch/arm64/kvm/mmio.c                |   16 +-
 arch/arm64/kvm/mmu.c                 |  201 ++-
 arch/arm64/kvm/pmu-emul.c            |    6 +
 arch/arm64/kvm/psci.c                |   30 +
 arch/arm64/kvm/reset.c               |   23 +-
 arch/arm64/kvm/rme-exit.c            |  199 +++
 arch/arm64/kvm/rme.c                 | 1708 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            |   49 +-
 arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
 arch/arm64/kvm/vgic/vgic-v3.c        |    6 +-
 arch/arm64/kvm/vgic/vgic.c           |   54 +-
 arch/arm64/mm/fault.c                |   31 +-
 drivers/perf/arm_pmu.c               |   15 +
 include/kvm/arm_arch_timer.h         |    2 +
 include/kvm/arm_pmu.h                |    4 +
 include/kvm/arm_psci.h               |    2 +
 include/linux/perf/arm_pmu.h         |    5 +
 include/uapi/linux/kvm.h             |   29 +-
 33 files changed, 3709 insertions(+), 100 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rme.h
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 arch/arm64/include/asm/rmi_smc.h
 create mode 100644 arch/arm64/kvm/rme-exit.c
 create mode 100644 arch/arm64/kvm/rme.c

-- 
2.43.0


