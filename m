Return-Path: <kvm+bounces-38031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4A1EA3495E
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 17:15:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19149163EFB
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 16:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C4F2036E4;
	Thu, 13 Feb 2025 16:14:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819C1201271;
	Thu, 13 Feb 2025 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463287; cv=none; b=Dl82/aKaBmM3CWy/4JHBx/vxrfyUgMz+HE8bD1EVhzkcfjI/k5stQeW173p9cjRDIf0hOWbVKX3LvRsCRDBuU2AdfWDS4aPDtM58Uj8089sq43A8nMFgJNrzfq4TU81ufgLAv+ldVELROCHJ8Uef5LiD7qA+7QdvXx4zJs2jln4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463287; c=relaxed/simple;
	bh=cMqkENu/ZOxocimQK5jA1C0TnU51He0yJud7qqZnxT0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LZ/6maVNOgsXAeuO1gKNRyzIWGRGiv26ncvgbArWZcZaJPwHs48MUOgk8jy8g2T+4IDcGUS9n4wKgaPP+GvLpWsFdRWDTxj1997ddNkrPP1P+8HkaMHYYNJe29vcsVDfkdDRHrFeo7tlyQNXKA9WilmabqmlUVXsrO2uX7uYgGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 660F8106F;
	Thu, 13 Feb 2025 08:15:05 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.32.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 569483F6A8;
	Thu, 13 Feb 2025 08:14:40 -0800 (PST)
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
Subject: [PATCH v7 00/45] arm64: Support for Arm CCA in KVM
Date: Thu, 13 Feb 2025 16:13:40 +0000
Message-ID: <20250213161426.102987-1-steven.price@arm.com>
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

There are several changes since v6, many thanks for the review
comments. The highlights are below, and individual patches have a changelog.

 * Separation of the concepts of RMM granule size and PAGE_SIZE. It's
   now possible to run with a host PAGE_SIZE larger than 4k (but see
   below).

 * Return with -EFAULT error for KVM_EXIT_MEMORY_FAULT as per the
   documentation.

 * Return -EPERM rather than -EINVAL in cases where a realm function is
   performed on a non-realm guest.

 * Several improvements to names of functions/defines and other minor
   changes following review feedback - thanks!

Things to note:

 * You will need an updated kvmtool because of the KVM_EXIT_MEMORY_FAULT
   change mentioned above. See below for a link.

 * KVM_VCPU_MAX_FEATURES is incremented. *NOTE*: This effectively
   exposes the nested virtualisation feature. So this series as it
   stands has a dependency on that being finished before it can be
   merged. See [2] for more details.

 * The final patch enables the host's page size to be larger than 4k.
   The support is all in the previous patches, but there is more work to
   do before I consider this ready, specifically:

   - The code to allocate RTTs (stage 2 page tables) for the RMM still
     conflates pages and granules. This means that for every RTT an
     entire host page is allocated potentially using 16x the required
     memory for the RTTs.

   - Having the guest's page size smaller than the host's currently
     doesn't work. The issue is the guest needs to know what granulatity
     it can transition pages between shared and private.  Exactly how
     this should work is an open area of discussion.

   - This configuration isn't well tested, I would be unsurprised if
     there are major bugs! ;) But a simple Linux guest of the same page
     size works.

The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[1].

This series is based on v6.14-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v7

Work in progress changes for kvmtool are available from the git
repository below:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v5

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

Steven Price (32):
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
  arm64: rme: Prevent Device mappings for Realms
  arm_pmu: Provide a mechanism for disabling the physical IRQ
  arm64: rme: Enable PMU support with a realm guest
  kvm: rme: Hide KVM_CAP_READONLY_MEM for realm guests
  arm64: kvm: Expose support for private memory
  KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
  KVM: arm64: Allow activating realms
  WIP: Enable support for PAGE_SIZE>4k

Suzuki K Poulose (3):
  kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  kvm: arm64: Expose debug HW register numbers for Realm
  arm64: rme: Allow checking SVE on VM instance

 Documentation/virt/kvm/api.rst       |    3 +
 arch/arm64/include/asm/kvm_emulate.h |   40 +
 arch/arm64/include/asm/kvm_host.h    |   17 +-
 arch/arm64/include/asm/kvm_rme.h     |  128 ++
 arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
 arch/arm64/include/asm/rmi_smc.h     |  259 ++++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/include/uapi/asm/kvm.h    |   49 +
 arch/arm64/kvm/Kconfig               |    1 +
 arch/arm64/kvm/Makefile              |    3 +-
 arch/arm64/kvm/arch_timer.c          |   45 +-
 arch/arm64/kvm/arm.c                 |  173 ++-
 arch/arm64/kvm/guest.c               |  104 +-
 arch/arm64/kvm/hypercalls.c          |    4 +-
 arch/arm64/kvm/inject_fault.c        |    5 +-
 arch/arm64/kvm/mmio.c                |   16 +-
 arch/arm64/kvm/mmu.c                 |  199 ++-
 arch/arm64/kvm/pmu-emul.c            |    6 +
 arch/arm64/kvm/psci.c                |   30 +
 arch/arm64/kvm/reset.c               |   23 +-
 arch/arm64/kvm/rme-exit.c            |  199 +++
 arch/arm64/kvm/rme.c                 | 1710 ++++++++++++++++++++++++++
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
 35 files changed, 3658 insertions(+), 104 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rme.h
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 arch/arm64/include/asm/rmi_smc.h
 create mode 100644 arch/arm64/kvm/rme-exit.c
 create mode 100644 arch/arm64/kvm/rme.c

-- 
2.43.0


