Return-Path: <kvm+bounces-19187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2551D9022CF
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1A772827F4
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FEEA8286D;
	Mon, 10 Jun 2024 13:42:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBD326AF6;
	Mon, 10 Jun 2024 13:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718026941; cv=none; b=Goi7RLiQlsywrFjb2K0oZRenrzoE/R2hkZYt0KupISU1JKhN1lWUsSwIQJ3Q23d+akPGj98hT8rdp60VQYhAYyfIPCPds0LwnN92mNV6Jt8WvwATacyz+ELkiUJ3/o9mW+T1wKuw2w+Cr3Hrl2xerS90JH+sN5jTX4izrRurMA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718026941; c=relaxed/simple;
	bh=CEUlyeHbL/OFV0uTnSbSzGQH4b6WsppEET6oTsS5oiI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Tmy5Rb6FdjenBLQbaIDm0sfrR2sDe+gOU9Gq6b2Ui43xN7WE2Hx7TO4AqNvbOn5pj+nCZ4Wga9OYdNk1s9BtlKKdhIaH0PxykOVRJN19Flcc+EAWuUWEkK9cTlJPfaQ3++/3rXev737MEVdWBO7/wUmSrtDUKBXf5f+QDkGw9tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79F79106F;
	Mon, 10 Jun 2024 06:42:42 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32EA93F58B;
	Mon, 10 Jun 2024 06:42:14 -0700 (PDT)
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
Subject: [PATCH v3 00/43] arm64: Support for Arm CCA in KVM
Date: Mon, 10 Jun 2024 14:41:19 +0100
Message-Id: <20240610134202.54893-1-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
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

The related guest support was posted[1] last week but the two series are
separate (i.e. you can mix-and-match v2/v3 between the two series).
Unlike the guest series this one is a bit more "work in progress" and
there are some rough edges (see below). The aim is to focus on merging
the guest support first before moving onto the host side patches for
KVM. Review comments are very welcome though!

Individual patches have their own changelog, but the bulk of the changes
(from v2) are updating to match more closely with the spec and making
the code more readable. There's also the 'minor' fix to prevent leaking
all the guest's pages which v2 suffered from! ;) Thanks for all the
review comments on v2 - I've attempted to address everything that was
raised.

Major limitations:
 * Only supports 4k host PAGE_SIZE (if PAGE_SIZE != 4k then the realm
   extensions are disabled).
 * No support for huge pages when mapping the guest's pages. There is
   some 'dead' code left over from before guest_mem was supported. This
   is partly a current limitation of guest_memfd.

The ABI to the RMM (the RMI) is based on the final RMM v1.0 (EAC 5)
specification[2].

This series is based on v6.10-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/v3

Work in progress changes for kvmtool are available from the git
repository below, these changes are based on Fuad Tabba's repository for
pKVM to provide some alignment with the ongoing pKVM work:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v2

Introduction (unchanged from v2)
============
A more general introduction to Arm CCA is available on the Arm
website[3], and links to the other components involved are available in
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

[1] https://lore.kernel.org/r/20240605093006.145492-1-steven.price%40arm.com
[2] https://developer.arm.com/documentation/den0137/1-0eac5/
[3] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture

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
  arm64: RME: RTT tear down
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
 arch/arm64/include/asm/kvm_host.h    |   15 +-
 arch/arm64/include/asm/kvm_pgtable.h |    2 +
 arch/arm64/include/asm/kvm_rme.h     |  155 +++
 arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
 arch/arm64/include/asm/rmi_smc.h     |  251 ++++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/include/uapi/asm/kvm.h    |   49 +
 arch/arm64/kvm/Kconfig               |    1 +
 arch/arm64/kvm/Makefile              |    3 +-
 arch/arm64/kvm/arch_timer.c          |   45 +-
 arch/arm64/kvm/arm.c                 |  166 ++-
 arch/arm64/kvm/guest.c               |   99 +-
 arch/arm64/kvm/hyp/pgtable.c         |    5 +-
 arch/arm64/kvm/hypercalls.c          |    4 +-
 arch/arm64/kvm/inject_fault.c        |    2 +
 arch/arm64/kvm/mmio.c                |   10 +-
 arch/arm64/kvm/mmu.c                 |  177 ++-
 arch/arm64/kvm/pmu-emul.c            |    7 +-
 arch/arm64/kvm/psci.c                |   29 +
 arch/arm64/kvm/reset.c               |   23 +-
 arch/arm64/kvm/rme-exit.c            |  212 ++++
 arch/arm64/kvm/rme.c                 | 1620 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            |   83 +-
 arch/arm64/kvm/vgic/vgic-v3.c        |    8 +-
 arch/arm64/kvm/vgic/vgic.c           |   37 +-
 arch/arm64/mm/fault.c                |   31 +-
 drivers/perf/arm_pmu.c               |   15 +
 include/kvm/arm_arch_timer.h         |    2 +
 include/kvm/arm_pmu.h                |    4 +
 include/kvm/arm_psci.h               |    2 +
 include/linux/kvm_host.h             |    2 +
 include/linux/perf/arm_pmu.h         |    5 +
 include/uapi/linux/kvm.h             |   30 +-
 virt/kvm/kvm_main.c                  |    7 +
 36 files changed, 3550 insertions(+), 98 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rme.h
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 arch/arm64/include/asm/rmi_smc.h
 create mode 100644 arch/arm64/kvm/rme-exit.c
 create mode 100644 arch/arm64/kvm/rme.c

-- 
2.34.1


