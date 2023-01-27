Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED9667E39B
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjA0Lkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbjA0Lki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:40:38 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E9EE10250;
        Fri, 27 Jan 2023 03:40:20 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3F152B;
        Fri, 27 Jan 2023 03:40:30 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4372C3F64C;
        Fri, 27 Jan 2023 03:39:46 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     suzuki.poulose@arm.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC kvmtool 00/31] arm64: Support for Arm Confidential Compute Architecture
Date:   Fri, 27 Jan 2023 11:39:01 +0000
Message-Id: <20230127113932.166089-1-suzuki.poulose@arm.com>
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

This series is an initial version of the support for running VMs under the
Arm Confidential Compute Architecture. The purpose of the series is to gather
feedback on the proposed UABI changes for running Confidential VMs with KVM.
More information on the Arm CCA and instructions for how to get, build and run
the entire software stack is available here [0].

A new option, `--realm` is added to the the `run` command to mark the VM as a
confidential compute VM. This version doesn't use the Guest private memory [1]
support yet, instead uses normal anonymous/hugetlbfs backed memory. Our aim is
to switch to the guest private memory for the Realm.

The host including the kernel and kvmtool, must not access any memory allocated
to the protected IPA of the Realm.

The series adds the support for managing the lifecycle of the Realm, which includes:
   * Configuration
   * Creation of Realm (RD)
   * Load initial memory images
   * Creation of Realm Execution Contexts (RECs aka VCPUs)a
   * Activation of the Realm.

Patches are split as follows :

Patches 1 and 2 are fixes to existing code.
Patch 3 adds a new option --nocompat to disable compat warnings
Patches 4 - 6 are some preparations for Realm specific changes.

The remaining patches adds Realm support and using the --realm option is
enabled in patch 30.

The v1.0 of the Realm Management Monitor (RMM) specification doesn't support
paging protected memory of a Realm. Thus all of the memory backing the RAM
is locked by the VMM.

Since the IPA space of a Realm is split into Protected and Unprotected, with
one alias of the other, the VMM doubles the IPA Size for a Realm VM.

The KVM support for Arm CCA is advertised with a new cap KVM_CAP_ARM_RME.
A new "VM type" field is defined in the vm_type for CREATE_VM ioctl to indicate
that a VM is "Realm". Once the VM is created, the life cycle of the Realm is
managed via KVM_ENABLE_CAP of KVM_CAP_ARM_RME.

Command line options are also added to configure the Realm parameters.
These include :
 - Hash algorithm for measurements
 - Realm personalisation value
 - SVE vector Length (Optional feature in v1.0 RMM spec. Not yet supported
   by the TF-RMM. coming soon).

Support for PMU and self-hosted debug (number of watchpoint/breakpoit registers)
are not supported yet in the KVM/RMM implementation. This will be added soon.

The UABI doesn't support discovering the "supported" configuration values. In
real world, the Realm configuration 'affects' the initial measurement of the
Realms and which may be verified by a remote entity. Thus, the VMM is not at
liberty to make choices for configurations based on the "host" capabilities.
Instead, VMM should launch a Realm with the user requested parameters. If this
cannot be satisfied, there is no point in running the Realm. We are happy to
change this if there is interest.

Special actions are required to load the initial memory images (e.g, kernel,
firmware, DTB, initrd) in to the Realm memory.

For VCPUs, we add a new feature KVM_ARM_VCPU_REC, which will be used to control
the creation of the REC object (via KVM_ARM_VCPU_FINALIZE). This must be done
after the initial register state of the VCPUs are set.
RMM imposes an order in which the RECs are created. i.e., they must be created
in the ascending order of the MPIDR. This is for now a responsibility of the
VMM.

Once the Realm images are loaded, VCPUs created, Realm is activated before
the first vCPU is run.

virtio for the Realms enforces VIRTIO_F_ACCESS_PLATFORM flag.

Also, added support for injecting SEA into the VM for unhandled MMIO.

A tree with the patches are also available here :

	https://gitlab.arm.com/linux-arm/kvmtool-cca cca/rfc-v1

Running the Realm
------------------

A realm VM can be launched using :

 $ lkvm run						\
	 --realm					\
	 --disable-sve					\
	 [ --measurement-algo="sha256","sha512" ]	\
	 [ --realm-pv="<realm-pv>" ]			\
	 <normal-VM options>

[0] https://lkml.kernel.org/r/20230127112248.136810-1-suzuki.poulose@arm.com
[1] https://lkml.kernel.org/r/20221202061347.1070246-1-chao.p.peng@linux.intel.com

To: kvmarm@lists.linux.dev
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joey Gouly <Joey.Gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-coco@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Alexandru Elisei (11):
  Add --nocompat option to disable compat warnings
  arm64: Add --realm command line option
  arm64: Lock realm RAM in memory
  arm64: Create Realm Descriptor
  arm: Add kernel size to VM context
  arm64: Populate initial realm contents
  arm64: Finalize realm VCPU after reset
  init: Add last_{init, exit} list macros
  arm64: Activate realm before the first VCPU is run
  arm64: Don't try to debug a realm
  arm64: Allow the user to create a realm

Christoffer Dall (4):
  arm64: Create a realm virtual machine
  arm64: Add --measurement-algo command line option for a realm
  arm64: Don't try to set PSTATE for VCPUs belonging to a realm
  arm64: Specify SMC as the PSCI conduits for realms

Joey Gouly (2):
  mmio: add arch hook for an unhandled MMIO access
  arm64: realm: inject an abort on an unhandled MMIO access

Suzuki K Poulose (14):
  arm64: Disable MTE when CFI flash is emulated
  script: update_headers: Ignore missing architectures
  hw: cfi flash: Handle errors in memory transitions
  arm64: Check pvtime support against the KVM instance
  arm64: Check SVE capability on the VM instance
  arm64: Add option to disable SVE
  linux: Update kernel headers for RME support
  arm64: Add configuration step for Realms
  arm64: Add support for Realm Personalisation Value
  arm64: Add support for specifying the SVE vector length for Realm
  arm64: realm: Double the IPA space
  virtio: Add a wrapper for get_host_features
  virtio: Add arch specific hook for virtio host flags
  arm64: realm: Enforce virtio F_ACCESS_PLATFORM flag

 Makefile                                  |   1 +
 arm/aarch32/include/asm/realm.h           |  13 ++
 arm/aarch32/kvm.c                         |   5 +
 arm/aarch64/include/asm/kvm.h             |  64 ++++++
 arm/aarch64/include/asm/realm.h           |  13 ++
 arm/aarch64/include/kvm/kvm-config-arch.h |  16 +-
 arm/aarch64/kvm-cpu.c                     |  41 +++-
 arm/aarch64/kvm.c                         |  95 ++++++++-
 arm/aarch64/pvtime.c                      |   4 +-
 arm/aarch64/realm.c                       | 229 ++++++++++++++++++++++
 arm/fdt.c                                 |  15 +-
 arm/include/arm-common/kvm-arch.h         |   4 +
 arm/include/arm-common/kvm-config-arch.h  |   5 +
 arm/kvm-cpu.c                             |  13 ++
 arm/kvm.c                                 |  75 ++++++-
 builtin-run.c                             |   5 +-
 guest_compat.c                            |   1 +
 hw/cfi_flash.c                            |   4 +
 include/kvm/kvm-config.h                  |   1 +
 include/kvm/kvm-cpu.h                     |   2 +
 include/kvm/kvm.h                         |   2 +
 include/kvm/util-init.h                   |   6 +-
 include/kvm/virtio.h                      |   2 +
 include/linux/kernel.h                    |   1 +
 include/linux/kvm.h                       |  22 ++-
 include/linux/virtio_blk.h                |  19 --
 include/linux/virtio_net.h                |  14 +-
 include/linux/virtio_ring.h               |  16 +-
 mips/kvm-cpu.c                            |   4 +
 mips/kvm.c                                |   5 +
 mmio.c                                    |   3 +
 powerpc/kvm-cpu.c                         |   4 +
 powerpc/kvm.c                             |   5 +
 riscv/kvm-cpu.c                           |   4 +
 riscv/kvm.c                               |   5 +
 util/update_headers.sh                    |   1 +
 virtio/core.c                             |   8 +
 virtio/mmio-legacy.c                      |   2 +-
 virtio/mmio-modern.c                      |   2 +-
 virtio/pci-legacy.c                       |   2 +-
 virtio/pci-modern.c                       |   2 +-
 x86/kvm-cpu.c                             |   4 +
 x86/kvm.c                                 |   5 +
 43 files changed, 667 insertions(+), 77 deletions(-)
 create mode 100644 arm/aarch32/include/asm/realm.h
 create mode 100644 arm/aarch64/include/asm/realm.h
 create mode 100644 arm/aarch64/realm.c

-- 
2.34.1

