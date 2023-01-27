Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6897767E359
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbjA0Lb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbjA0LbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:31:10 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CD702278F;
        Fri, 27 Jan 2023 03:29:44 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5AB92F;
        Fri, 27 Jan 2023 03:30:23 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.16])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C33CD3F64C;
        Fri, 27 Jan 2023 03:29:38 -0800 (PST)
From:   Steven Price <steven.price@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: [RFC PATCH 00/28] arm64: Support for Arm CCA in KVM
Date:   Fri, 27 Jan 2023 11:29:04 +0000
Message-Id: <20230127112932.38045-1-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127112248.136810-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is an RFC adding support for running protected VMs using KVM
under the new Arm Confidential Compute Architecture (CCA). The purpose
of this series is to gather feedback on the proposed changes to the
architecture code for CCA.

The user ABI is not in it's final form, we plan to make use of the
memfd_restricted() allocator[1] and associated infrastructure which will
avoid problems in the current user ABI where a malicious VMM may be able
to cause a Granule Protection Fault in the kernel (which is fatal).

The ABI to the RMM (the RMI) is based on the Beta 0 specification[2] and
will be updated in the future when a final version of the specification
is published.

This series is based on v6.2-rc1. It is also available as a git
repository:

https://gitlab.arm.com/linux-arm/linux-cca cca-host/rfc-v1

Introduction
============
A more general introduction to Arm CCA is available on the Arm
website[3], and links to the other components involved are available in
the overall cover letter[4].

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

Entry/exit of a Realm VM attempts to reuse the KVM infrastructure, but
ultimately the final mechanism is different. So this series has a bunch
of commits handling the differences. As much as possible is placed in a
two new files: rme.c and rme-exit.c.

The RMM specification provides a new mechanism for a guest to
communicate with host which goes by the name "Host Call". For now this
is simply hooked up to the existing support for HVC calls from a normal
guest.

[1] https://lore.kernel.org/r/20221202061347.1070246-1-chao.p.peng%40linux.intel.com
[2] https://developer.arm.com/documentation/den0137/1-0bet0/
[3] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
[4] .. cover letter ..

Joey Gouly (2):
  arm64: rme: allow userspace to inject aborts
  arm64: rme: support RSI_HOST_CALL

Steven Price (25):
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
  KVM: arm64: Allow activating realms
  arm64: RME: Always use 4k pages for realms
  HACK: Accept prototype RMI versions

Suzuki K Poulose (1):
  arm64: rme: Allow checking SVE on VM instance

 Documentation/virt/kvm/api.rst       |    3 +
 arch/arm64/include/asm/kvm_emulate.h |   29 +
 arch/arm64/include/asm/kvm_host.h    |    7 +
 arch/arm64/include/asm/kvm_rme.h     |   98 ++
 arch/arm64/include/asm/rmi_cmds.h    |  259 +++++
 arch/arm64/include/asm/rmi_smc.h     |  242 +++++
 arch/arm64/include/asm/virt.h        |    1 +
 arch/arm64/include/uapi/asm/kvm.h    |   63 ++
 arch/arm64/kvm/Kconfig               |    8 +
 arch/arm64/kvm/Makefile              |    3 +-
 arch/arm64/kvm/arch_timer.c          |   53 +-
 arch/arm64/kvm/arm.c                 |  105 +-
 arch/arm64/kvm/guest.c               |   50 +
 arch/arm64/kvm/inject_fault.c        |    2 +
 arch/arm64/kvm/mmio.c                |    7 +
 arch/arm64/kvm/mmu.c                 |   80 +-
 arch/arm64/kvm/psci.c                |   23 +
 arch/arm64/kvm/reset.c               |   41 +
 arch/arm64/kvm/rme-exit.c            |  194 ++++
 arch/arm64/kvm/rme.c                 | 1453 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c        |    9 +-
 arch/arm64/kvm/vgic/vgic.c           |   37 +-
 arch/arm64/mm/fault.c                |   29 +-
 include/kvm/arm_arch_timer.h         |    2 +
 include/uapi/linux/kvm.h             |   21 +-
 25 files changed, 2772 insertions(+), 47 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rme.h
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h
 create mode 100644 arch/arm64/include/asm/rmi_smc.h
 create mode 100644 arch/arm64/kvm/rme-exit.c
 create mode 100644 arch/arm64/kvm/rme.c

-- 
2.34.1

