Return-Path: <kvm+bounces-14431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A538A29A6
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 080E4B27031
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC9D51009;
	Fri, 12 Apr 2024 08:43:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA1E22625;
	Fri, 12 Apr 2024 08:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911399; cv=none; b=WbiOcCvIp1lifATcRp4rCPdy6gY17z30AZUFgui/DUaNx3ZuWoAcX/JRPzqWeR0p8KkFRsXpU0Lt1Rv6Xps8ntF3St3j08h4c3KNxt5tIaAEhqTjFkCon6R2EbthdzBwjN57JCxABWWbU6srXTojbtOzrneIVozG2jFTloMtDd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911399; c=relaxed/simple;
	bh=PrnauYr3z3W77LWu86/5V+U1l1W7Y+gdHbsn01XUGrs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QmeIIT1Dcn8AZZ2+yC1oQAR2VJdc70F1DUagC/crOfNQlB7PfqbLI6aL5lLWARdzF9TrI5/9Pwlqt96+x1Hc8XBO9nSifp9qSKbS2PQWJ5AcB2ncWES/6vs5Oh252cIhWUn1HDqHqz9TCN64DFhy/EYRfIiEVwClXOZYTbaYrZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FF76339;
	Fri, 12 Apr 2024 01:43:47 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B790B3F6C4;
	Fri, 12 Apr 2024 01:43:15 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 00/43] arm64: Support for Arm CCA in KVM
Date: Fri, 12 Apr 2024 09:42:26 +0100
Message-Id: <20240412084309.1733783-1-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084056.1733704-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds support for running protected VMs using KVM under the
Arm Confidential Compute Architecture (CCA). The purpose of this
series is to gather feedback on the proposed changes to the architecture
code for CCA.

The main change from the previous RFC is that it updates the code to use
a guest_memfd descriptor to back the private memory of the guest. This
avoids any issues where a malicious VMM could potentially cause a fatal
Granule Protection Fault elsewhere in the kernel.

The ABI to the RMM (the RMI) is based on the final RMM v1.0 (EAC 5)
specification[1].

This series is based on v6.9-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v2

Work in progress changes for kvmtool are available from the git
repository below, these changes are based on Fuad Tabba's repository for
pKVM to provide some alignment with the ongoing pKVM work:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v2

Introduction
============
A more general introduction to Arm CCA is available on the Arm
website[2], and links to the other components involved are available in
the overall cover letter.

Arm Confidential Compute Architecture adds two new 'worlds' to the
architecture: Root and Realm. A new software component known as the RMM
(Realm Management Monitor) runs in Realm EL2 and is trusted by both the
Normal World and VMs running within Realms. This enables mutual
distrust between the Realm VMs and the Normal World.

Virtual machines running within a Realm can decide on a (4k)
page-by-page granularity whether to share a page with the (Normal World)
host or to keep it private (protected). This protection is provided by
the hardware and attempts to access a page which isn't shared by the
Normal World will trigger a Granule Protection Fault. The series starts
by adding handling for these; faults within user space can be handled by
killing the process, faults within kernel space are considered fatal.

The Normal World host can communicate with the RMM via an SMC interface
known as RMI (Realm Management Interface), and Realm VMs can communicate
with the RMM via another SMC interface known as RSI (Realm Services
Interface). This series adds wrappers for the full set of RMI commands
and uses them to manage the realm guests.

The Normal World can use RMI commands to delegate pages to the Realm
world and to create, manage and run Realm VMs. Once delegated the pages
are inaccessible to the Normal World (unless explicitly shared by the
guest). However the Normal World may destroy the Realm VM at any time to
be able to reclaim (undelegate) the pages.

Realm VMs are identified by the KVM_CREATE_VM command, where the 'type'
argument has a new field to describe whether the guest is 'normal' or a
'realm'.

Entry/exit of a Realm VM attempts to reuse the KVM infrastructure, but
ultimately the final mechanism is different. So this series has a bunch
of commits handling the differences. As much as possible is placed in a
two new files: rme.c and rme-exit.c.

KVM also handles some of the PSCI requests for a realm and helps the RMM
complete the PSCI service requests.

Interrupts are managed by KVM, and are injected into the Realm with the
help of the RMM.

The RMM specification provides a new mechanism for a guest to
communicate with host which goes by the name "Host Call". This is simply
hooked up to the existing support for HVC calls from a normal
guest.

[1] https://developer.arm.com/documentation/den0137/1-0eac5/
[2] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture

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

Steven Price (29):
  arm64: RME: Handle Granule Protection Faults (GPFs)
  arm64: RME: Add SMC definitions for calling the RMM
  arm64: RME: Add wrappers for RMI calls
  arm64: RME: Check for RME support at KVM init
  arm64: RME: Define the user ABI
  arm64: RME: ioctls to create and configure realms
  arm64: kvm: Allow passing machine type in KVM creation
  arm64: RME: Keep a spare page delegated to the RMM
  arm64: RME: RTT handling
  arm64: RME: Allocate/free RECs to match vCPUs
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
  KVM: arm64: Allow activating realms

Suzuki K Poulose (4):
  kvm: arm64: pgtable: Track the number of pages in the entry level
  kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
  kvm: arm64: Expose debug HW register numbers for Realm
  arm64: rme: Allow checking SVE on VM instance

 Documentation/virt/kvm/api.rst       |    3 +
 arch/arm64/include/asm/kvm_emulate.h |   35 +
 arch/arm64/include/asm/kvm_host.h    |   13 +-
 arch/arm64/include/asm/kvm_pgtable.h |    2 +
 arch/arm64/include/asm/kvm_rme.h     |  154 +++
 arch/arm64/include/asm/rmi_cmds.h    |  509 +++++++++
 arch/arm64/include/asm/rmi_smc.h     |  250 ++++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/include/uapi/asm/kvm.h    |   49 +
 arch/arm64/kvm/Kconfig               |    1 +
 arch/arm64/kvm/Makefile              |    3 +-
 arch/arm64/kvm/arch_timer.c          |   45 +-
 arch/arm64/kvm/arm.c                 |  178 ++-
 arch/arm64/kvm/guest.c               |   99 +-
 arch/arm64/kvm/hyp/pgtable.c         |    5 +-
 arch/arm64/kvm/hypercalls.c          |    4 +-
 arch/arm64/kvm/inject_fault.c        |    2 +
 arch/arm64/kvm/mmio.c                |   10 +-
 arch/arm64/kvm/mmu.c                 |  172 ++-
 arch/arm64/kvm/pmu-emul.c            |    7 +-
 arch/arm64/kvm/psci.c                |   29 +
 arch/arm64/kvm/reset.c               |   23 +-
 arch/arm64/kvm/rme-exit.c            |  211 ++++
 arch/arm64/kvm/rme.c                 | 1590 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            |   83 +-
 arch/arm64/kvm/vgic/vgic-v3.c        |    9 +-
 arch/arm64/kvm/vgic/vgic.c           |   37 +-
 arch/arm64/mm/fault.c                |   29 +-
 drivers/perf/arm_pmu.c               |   15 +
 include/kvm/arm_arch_timer.h         |    2 +
 include/kvm/arm_psci.h               |    2 +
 include/linux/kvm_host.h             |    2 +
 include/linux/perf/arm_pmu.h         |    1 +
 include/uapi/linux/kvm.h             |   30 +-
 virt/kvm/kvm_main.c                  |    7 +
 35 files changed, 3514 insertions(+), 98 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rme.h
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 arch/arm64/include/asm/rmi_smc.h
 create mode 100644 arch/arm64/kvm/rme-exit.c
 create mode 100644 arch/arm64/kvm/rme.c

-- 
2.34.1


