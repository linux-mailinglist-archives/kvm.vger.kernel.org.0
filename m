Return-Path: <kvm+bounces-55139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDDD7B2E02D
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E03C58023F
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 14:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4335132254A;
	Wed, 20 Aug 2025 14:57:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5532F2741AC;
	Wed, 20 Aug 2025 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701834; cv=none; b=oAqnSBOTfmiSkcb0UMtPp+OipOOQjZgoHGrN5Uby2fA1jfgiUgm+sEAH3sPtM8XV+2Efv2Wl4u3VZnNnbtiQh/2JDWg0KH9RxAk0Mb9BA+k+sN5jd6qvlT4gjZ/E9ek1ZJw60cIyDGgTvqyPg8mFmwzAb28BY+19xX2WXpWWeRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701834; c=relaxed/simple;
	bh=oSPqbo2u7ZObVyUOWqaQ8fy1CTPqbAxH2ZdEDH89NVg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LP7P6KfFtQzORvH0CW+mjezUo1oz2vllQnCa6B149pkBzOF9OZmt68lSf0rvv72+cTKZnALago6H36LoB5dJ7U6kLuCAiIo8fyaTKTwp/Tqa9pJKWnHy4RBl2U3BgDWCbZ1wGrB3hbktG7Zt47nTIwm7rez1ld/OrbqsD0O5x2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FD581D31;
	Wed, 20 Aug 2025 07:57:03 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.2.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A90E83F738;
	Wed, 20 Aug 2025 07:57:06 -0700 (PDT)
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v10 00/43] arm64: Support for Arm CCA in KVM
Date: Wed, 20 Aug 2025 15:55:20 +0100
Message-ID: <20250820145606.180644-1-steven.price@arm.com>
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

There are a few changes since v9, many thanks for the review
comments. The highlights are below, and individual patches have a changelog.

 * Fix a potential issue where the host was walking the stage 2 page tables on
   realm destruction. If the RMM didn't zero when undelegated (which it isn't
   required to) then the kernel would attempt to work the junk values and crash.

 * Avoid RCU stall warnings by correctly settign may_block in
   kvm_free_stage2_pgd().

 * Rebased onto v6.17-rc1.

Things to note:

 * The magic numbers for capabilities and ioctls have been updated. So
   you'll need to update your VMM. See below for the updated kvmtool branch.

 * This series doesn't attempt to integrate with the guest-memfd changes that
   are being discussed (see below).

 * Vishal raised an important question about what to do in the case of
   undelegate failures (also see below).

guest-memfd
===========

This series still implements the same API as previous versions, which means
only the private memory of the guest is backed by guest-memfd, and the shared
portion is accessed using VMAs from the VMM. This approach is compatible with
the proposed changes to support guest-memfd backing shared memory but would
require the VMM to mmap() the shared memory at the appropriate time so that
KVM can access via the VMM's VMAs.

Changing to access both shared and private through the guest-memfd API
shouldn't be difficult and could be done in a backwards compatible manner
(with the VMM choosing which method to use). It's not clear to me whether we
want to hold things up waiting for the full guest-memfd (and only support that
uAPI) or if it would be fine to just support both approaches and let VMM's
switch when they are ready.

There is a slight wrinkle around the 'populate' uAPI
(KVM_CAP_ARM_RME_POPULATE). At the moment this expects 'double mapping' - the
contents to be populated should be in the shared memory region, but the
physical pages for the private region are also allocated from the guest_memfd.
Arm CCA doesn't support a true 'in-place' conversion so this is required in
some form. However it may make sense to allow the populate call to take a user
space pointer for the data to be copied rather than require it to be in the
shared memory region. We do already have a "flags" argument so there's also
scope for easily supporting both options. The current approach integrates
quite nicely in kvmtool with the existing logic for setting up a normal
(non-CoCo) guest. But I'm aware kvmtool isn't entirely representative of what
VMMs do, so I'd welcome feedback on what a good populate uAPI would look like.

Undelegation failure
====================

When the kernel is tearing down a CCA VM, it will attempt to "undelegate"
pages allowing them to be used by the Normal World again. Assuming no bugs
then these operations will always succeed. However, the RMM has the ability to
return a failure if it considers these pages to still be in use. A failure
like this is always a bug in the code, but it would be good to be able to
handle these without resorting to an immediate BUG_ON().

The current approach in the code is to simply WARN() and use get_page() to
take an extra reference to the page to stop it being reused (as it will
immediately cause a GPF if the Normal World attempts to access the page).

However this will cause problems when we start supporting huge pages. It may
be possible to use the HWPOISON infrastructure to flag the page as unusable
(although note there is no way of 'scrubbing' a page to recover from this
situation). The other option is to just accept this this "should never happen"
and upgrade the WARN() to a BUG_ON() so we don't have to deal with the
situation. A third option is to do nothing (other than WARN) and let the
system run until the inevitable GPF which will probably bring it down (and
hope there's enough time for the user to save work etc).

I'd welcome thoughts on the best solution.

====================

The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[1].

This series is based on v6.17-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v10

Work in progress changes for kvmtool are available from the git
repository below:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v8

[1] https://developer.arm.com/documentation/den0137/1-0rel0/

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

 Documentation/virt/kvm/api.rst       |   92 +-
 arch/arm64/include/asm/kvm_emulate.h |   38 +
 arch/arm64/include/asm/kvm_host.h    |   13 +-
 arch/arm64/include/asm/kvm_rme.h     |  135 ++
 arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
 arch/arm64/include/asm/rmi_smc.h     |  269 ++++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/include/uapi/asm/kvm.h    |   49 +
 arch/arm64/kvm/Kconfig               |    1 +
 arch/arm64/kvm/Makefile              |    2 +-
 arch/arm64/kvm/arch_timer.c          |   44 +-
 arch/arm64/kvm/arm.c                 |  169 ++-
 arch/arm64/kvm/guest.c               |  108 +-
 arch/arm64/kvm/hypercalls.c          |    4 +-
 arch/arm64/kvm/inject_fault.c        |    5 +-
 arch/arm64/kvm/mmio.c                |   16 +-
 arch/arm64/kvm/mmu.c                 |  209 ++-
 arch/arm64/kvm/pmu-emul.c            |    6 +
 arch/arm64/kvm/psci.c                |   30 +
 arch/arm64/kvm/reset.c               |   23 +-
 arch/arm64/kvm/rme-exit.c            |  207 +++
 arch/arm64/kvm/rme.c                 | 1746 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            |   53 +-
 arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
 arch/arm64/kvm/vgic/vgic.c           |   61 +-
 arch/arm64/mm/fault.c                |   31 +-
 drivers/perf/arm_pmu.c               |   15 +
 include/kvm/arm_arch_timer.h         |    2 +
 include/kvm/arm_pmu.h                |    4 +
 include/kvm/arm_psci.h               |    2 +
 include/linux/perf/arm_pmu.h         |    5 +
 include/uapi/linux/kvm.h             |   29 +-
 32 files changed, 3778 insertions(+), 101 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rme.h
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 arch/arm64/include/asm/rmi_smc.h
 create mode 100644 arch/arm64/kvm/rme-exit.c
 create mode 100644 arch/arm64/kvm/rme.c

-- 
2.43.0


