Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4179343F9FC
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 11:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhJ2Jhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 05:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229927AbhJ2Jhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 05:37:53 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 591D860F93;
        Fri, 29 Oct 2021 09:35:25 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mgOIF-002O2i-3C; Fri, 29 Oct 2021 10:35:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Scull <ascull@google.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Fuad Tabba <tabba@google.com>, Jia He <justin.he@arm.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Oliver Upton <oupton@google.com>,
        Quentin Perret <qperret@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 updates for 5.16
Date:   Fri, 29 Oct 2021 10:35:10 +0100
Message-Id: <20211029093510.3682241-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, ascull@google.com, dbrazdil@google.com, eric.auger@redhat.com, tabba@google.com, justin.he@arm.com, joey.gouly@arm.com, oupton@google.com, qperret@google.com, rananta@google.com, reijiw@google.com, ricarkol@google.com, seanjc@google.com, suzuki.poulose@arm.com, will@kernel.org, james.morse@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the bulk of KVM/arm64 updates for 5.16. The changes are more or
less equaly split between new features (more pKVM stuff trickling in
as it gets written), a bunch of new selftests (timer, vgic), and bug
fixes.

Please pull,

	M.

The following changes since commit 9e1ff307c779ce1f0f810c7ecce3d95bbae40896:

  Linux 5.15-rc4 (2021-10-03 14:08:47 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.16

for you to fetch changes up to 5a2acbbb0179a7ffbb5440b9fa46689f619705ac:

  Merge branch kvm/selftests/memslot into kvmarm-master/next (2021-10-21 11:40:03 +0100)

----------------------------------------------------------------
KVM/arm64 updates for Linux 5.16

- More progress on the protected VM front, now with the full
  fixed feature set as well as the limitation of some hypercalls
  after initialisation.

- Cleanup of the RAZ/WI sysreg handling, which was pointlessly
  complicated

- Fixes for the vgic placement in the IPA space, together with a
  bunch of selftests

- More memcg accounting of the memory allocated on behalf of a guest

- Timer and vgic selftests

- Workarounds for the Apple M1 broken vgic implementation

- KConfig cleanups

- New kvmarm.mode=none option, for those who really dislike us

----------------------------------------------------------------
Alexandru Elisei (4):
      KVM: arm64: Return early from read_id_reg() if register is RAZ
      KVM: arm64: Use get_raz_reg() for userspace reads of PMSWINC_EL0
      KVM: arm64: Replace get_raz_id_reg() with get_raz_reg()
      Documentation: admin-guide: Document side effects when pKVM is enabled

Fuad Tabba (8):
      KVM: arm64: Pass struct kvm to per-EC handlers
      KVM: arm64: Add missing field descriptor for MDCR_EL2
      KVM: arm64: Simplify masking out MTE in feature id reg
      KVM: arm64: Add handlers for protected VM System Registers
      KVM: arm64: Initialize trap registers for protected VMs
      KVM: arm64: Move sanitized copies of CPU features
      KVM: arm64: Trap access to pVM restricted features
      KVM: arm64: Handle protected guests at 32 bits

Jia He (2):
      KVM: arm64: vgic: Add memcg accounting to vgic allocations
      KVM: arm64: Add memcg accounting to KVM allocations

Marc Zyngier (33):
      KVM: arm64: Turn __KVM_HOST_SMCCC_FUNC_* into an enum (mostly)
      Merge branch kvm-arm64/pkvm/restrict-hypercalls into kvmarm-master/next
      Merge branch kvm-arm64/vgic-ipa-checks into kvmarm-master/next
      KVM: arm64: Allow KVM to be disabled from the command line
      Merge branch kvm-arm64/misc-5.16 into kvmarm-master/next
      Merge branch kvm-arm64/raz-sysregs into kvmarm-master/next
      KVM: arm64: Move __get_fault_info() and co into their own include file
      KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
      KVM: arm64: Move early handlers to per-EC handlers
      Merge branch kvm-arm64/pkvm/restrict-hypercalls into kvmarm-master/next
      KVM: arm64: Fix reporting of endianess when the access originates at EL0
      Merge branch kvm-arm64/misc-5.16 into kvmarm-master/next
      KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3
      KVM: arm64: vgic-v3: Work around GICv3 locally generated SErrors
      KVM: arm64: vgic-v3: Reduce common group trapping to ICV_DIR_EL1 when possible
      KVM: arm64: vgic-v3: Don't advertise ICC_CTLR_EL1.SEIS
      KVM: arm64: vgic-v3: Align emulated cpuif LPI state machine with the pseudocode
      Merge branch kvm-arm64/vgic-fixes-5.16 into kvmarm-master/next
      Merge branch kvm-arm64/selftest/timer into kvmarm-master/next
      Merge branch kvm-arm64/memory-accounting into kvmarm-master/next
      KVM: arm64: Fix early exit ptrauth handling
      KVM: arm64: pkvm: Use a single function to expose all id-regs
      KVM: arm64: pkvm: Make the ERR/ERX*_EL1 registers RAZ/WI
      KVM: arm64: pkvm: Drop AArch32-specific registers
      KVM: arm64: pkvm: Drop sysregs that should never be routed to the host
      KVM: arm64: pkvm: Handle GICv3 traps as required
      KVM: arm64: pkvm: Preserve pending SError on exit from AArch32
      KVM: arm64: pkvm: Consolidate include files
      KVM: arm64: pkvm: Move kvm_handle_pvm_restricted around
      KVM: arm64: pkvm: Pass vpcu instead of kvm to kvm_get_exit_handler_array()
      KVM: arm64: pkvm: Give priority to standard traps over pvm handling
      Merge branch kvm-arm64/pkvm/fixed-features into kvmarm-master/next
      Merge branch kvm/selftests/memslot into kvmarm-master/next

Raghavendra Rao Ananta (14):
      KVM: arm64: selftests: Add MMIO readl/writel support
      tools: arm64: Import sysreg.h
      KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
      KVM: arm64: selftests: Add support for cpu_relax
      KVM: arm64: selftests: Add basic support for arch_timers
      KVM: arm64: selftests: Add basic support to generate delays
      KVM: arm64: selftests: Add support to disable and enable local IRQs
      KVM: arm64: selftests: Maintain consistency for vcpuid type
      KVM: arm64: selftests: Add guest support to get the vcpuid
      KVM: arm64: selftests: Add light-weight spinlock support
      KVM: arm64: selftests: Add basic GICv3 support
      KVM: arm64: selftests: Add host support for vGIC
      KVM: arm64: selftests: Add arch_timer test
      KVM: arm64: selftests: arch_timer: Support vCPU migration

Ricardo Koller (13):
      kvm: arm64: vgic: Introduce vgic_check_iorange
      KVM: arm64: vgic-v3: Check redist region is not above the VM IPA size
      KVM: arm64: vgic-v2: Check cpu interface region is not above the VM IPA size
      KVM: arm64: vgic-v3: Check ITS region is not above the VM IPA size
      KVM: arm64: vgic: Drop vgic_check_ioaddr()
      KVM: arm64: selftests: Make vgic_init gic version agnostic
      KVM: arm64: selftests: Make vgic_init/vm_gic_create version agnostic
      KVM: arm64: selftests: Add some tests for GICv2 in vgic_init
      KVM: arm64: selftests: Add tests for GIC redist/cpuif partially above IPA range
      KVM: arm64: selftests: Add test for legacy GICv3 REDIST base partially above IPA range
      KVM: arm64: selftests: Add init ITS device test
      KVM: selftests: Make memslot_perf_test arch independent
      KVM: selftests: Build the memslot tests for arm64

Sean Christopherson (2):
      KVM: arm64: Unconditionally include generic KVM's Kconfig
      KVM: arm64: Depend on HAVE_KVM instead of OF

Will Deacon (5):
      arm64: Prevent kexec and hibernation if is_protected_kvm_enabled()
      KVM: arm64: Reject stub hypercalls after pKVM has been initialised
      KVM: arm64: Propagate errors from __pkvm_prot_finalize hypercall
      KVM: arm64: Prevent re-finalisation of pKVM for a given CPU
      KVM: arm64: Disable privileged hypercalls after pKVM finalisation

 Documentation/admin-guide/kernel-parameters.txt    |    6 +-
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/include/asm/kvm_arm.h                   |    1 +
 arch/arm64/include/asm/kvm_asm.h                   |   48 +-
 arch/arm64/include/asm/kvm_emulate.h               |    5 +-
 arch/arm64/include/asm/kvm_host.h                  |    3 +
 arch/arm64/include/asm/kvm_hyp.h                   |    5 +
 arch/arm64/include/asm/sysreg.h                    |    3 +
 arch/arm64/kernel/smp.c                            |    3 +-
 arch/arm64/kvm/Kconfig                             |   10 +-
 arch/arm64/kvm/arm.c                               |   94 +-
 arch/arm64/kvm/hyp/include/hyp/fault.h             |   75 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  235 ++--
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     |  200 +++
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h     |    2 +
 arch/arm64/kvm/hyp/nvhe/Makefile                   |    2 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |   26 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   48 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   11 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  185 +++
 arch/arm64/kvm/hyp/nvhe/setup.c                    |    3 +
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   99 ++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |  487 ++++++++
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   22 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   16 +
 arch/arm64/kvm/mmu.c                               |    2 +-
 arch/arm64/kvm/pmu-emul.c                          |    2 +-
 arch/arm64/kvm/reset.c                             |    2 +-
 arch/arm64/kvm/sys_regs.c                          |   41 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |    2 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c                   |    2 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |   18 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |   25 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |    8 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   27 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |    2 +-
 arch/arm64/kvm/vgic/vgic.h                         |    5 +-
 tools/arch/arm64/include/asm/sysreg.h              | 1296 ++++++++++++++++++++
 tools/testing/selftests/kvm/.gitignore             |    1 +
 tools/testing/selftests/kvm/Makefile               |    5 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |  479 ++++++++
 .../selftests/kvm/aarch64/debug-exceptions.c       |   30 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c       |    2 +-
 tools/testing/selftests/kvm/aarch64/vgic_init.c    |  369 ++++--
 .../selftests/kvm/include/aarch64/arch_timer.h     |  142 +++
 .../testing/selftests/kvm/include/aarch64/delay.h  |   25 +
 tools/testing/selftests/kvm/include/aarch64/gic.h  |   21 +
 .../selftests/kvm/include/aarch64/processor.h      |   90 +-
 .../selftests/kvm/include/aarch64/spinlock.h       |   13 +
 tools/testing/selftests/kvm/include/aarch64/vgic.h |   20 +
 tools/testing/selftests/kvm/include/kvm_util.h     |    2 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c      |   95 ++
 .../selftests/kvm/lib/aarch64/gic_private.h        |   21 +
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c   |  240 ++++
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h   |   70 ++
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   24 +-
 tools/testing/selftests/kvm/lib/aarch64/spinlock.c |   27 +
 tools/testing/selftests/kvm/lib/aarch64/vgic.c     |   70 ++
 tools/testing/selftests/kvm/memslot_perf_test.c    |   56 +-
 59 files changed, 4373 insertions(+), 451 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
 create mode 100644 tools/arch/arm64/include/asm/sysreg.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c
