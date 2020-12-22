Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B122D9E35
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 18:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438801AbgLNRuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 12:50:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440510AbgLNRuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 12:50:12 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19CD121534;
        Mon, 14 Dec 2020 17:49:30 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1koryR-001EtV-Lu; Mon, 14 Dec 2020 17:49:27 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        James Morse <james.morse@arm.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Shenming Lu <lushenming@huawei.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [GIT PULL] KVM/arm64 updates for 5.11
Date:   Mon, 14 Dec 2020 17:48:48 +0000
Message-Id: <20201214174848.1501502-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, catalin.marinas@arm.com, dbrazdil@google.com, james.morse@arm.com, zhukeqian1@huawei.com, mark.rutland@arm.com, lushenming@huawei.com, steven.price@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the initial set of KVM/arm64 updates for 5.11. The most notable
change is the "PSCI relay" at EL2, which is the first "user visible"
feature required by the Protected KVM effort. The rest is a mixed bag
of architecture compliance (PMU accesses when no PMU is present, cache
hierarchy discovery), cleanups (EL2 vector allocation, AArch32 sysreg
handling), internal rework (exception injection, EL2 function
pointers), and general improvements (advertising CSV3, reduced GICv4
entry latency).

Note that this pull request comes with some additional bonuses in the
shape of a shared branch with the arm64 tree (arm64/for-next/uaccess),
as it was conflicting *very* badly with the new PSCI relay code.

I already have a bunch of fixes earmarked for after the merge window,
but that is probably something for another year!

Happy Christmas (and please pull)!

	M.

The following changes since commit 09162bc32c880a791c6c0668ce0745cf7958f576:

  Linux 5.10-rc4 (2020-11-15 16:44:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.11

for you to fetch changes up to 3a514592b698588326924625b6948a10c35fadd5:

  Merge remote-tracking branch 'origin/kvm-arm64/psci-relay' into kvmarm-master/next (2020-12-09 10:00:24 +0000)

----------------------------------------------------------------
KVM/arm64 updates for Linux 5.11

- PSCI relay at EL2 when "protected KVM" is enabled
- New exception injection code
- Simplification of AArch32 system register handling
- Fix PMU accesses when no PMU is enabled
- Expose CSV3 on non-Meltdown hosts
- Cache hierarchy discovery fixes
- PV steal-time cleanups
- Allow function pointers at EL2
- Various host EL2 entry cleanups
- Simplification of the EL2 vector allocation

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: Refuse to run VCPU if PMU is not initialized

Andrew Jones (2):
      KVM: arm64: CSSELR_EL1 max is 13
      KVM: arm64: selftests: Filter out DEMUX registers

David Brazdil (26):
      KVM: arm64: Add kvm-arm.mode early kernel parameter
      KVM: arm64: Add ARM64_KVM_PROTECTED_MODE CPU capability
      psci: Support psci_ops.get_version for v0.1
      psci: Split functions to v0.1 and v0.2+ variants
      psci: Replace psci_function_id array with a struct
      psci: Add accessor for psci_0_1_function_ids
      arm64: Make cpu_logical_map() take unsigned int
      arm64: Extract parts of el2_setup into a macro
      KVM: arm64: Remove vector_ptr param of hyp-init
      KVM: arm64: Move hyp-init params to a per-CPU struct
      KVM: arm64: Init MAIR/TCR_EL2 from params struct
      KVM: arm64: Add .hyp.data..ro_after_init ELF section
      KVM: arm64: Support per_cpu_ptr in nVHE hyp code
      KVM: arm64: Create nVHE copy of cpu_logical_map
      KVM: arm64: Add SMC handler in nVHE EL2
      KVM: arm64: Bootstrap PSCI SMC handler in nVHE EL2
      KVM: arm64: Add offset for hyp VA <-> PA conversion
      KVM: arm64: Forward safe PSCI SMCs coming from host
      KVM: arm64: Extract __do_hyp_init into a helper function
      KVM: arm64: Add function to enter host from KVM nVHE hyp code
      KVM: arm64: Intercept host's CPU_ON SMCs
      KVM: arm64: Intercept host's CPU_SUSPEND PSCI SMCs
      KVM: arm64: Intercept host's SYSTEM_SUSPEND PSCI SMCs
      KVM: arm64: Keep nVHE EL2 vector installed
      KVM: arm64: Trap host SMCs in protected mode
      KVM: arm64: Fix EL2 mode availability checks

Keqian Zhu (2):
      KVM: arm64: Some fixes of PV-time interface document
      KVM: arm64: Use kvm_write_guest_lock when init stolen time

Marc Zyngier (47):
      KVM: arm64: Add kimg_hyp_va() helper
      KVM: arm64: Turn host HVC handling into a dispatch table
      KVM: arm64: Don't adjust PC on SError during SMC trap
      KVM: arm64: Move kvm_vcpu_trap_il_is32bit into kvm_skip_instr32()
      KVM: arm64: Make kvm_skip_instr() and co private to HYP
      KVM: arm64: Move PC rollback on SError to HYP
      KVM: arm64: Move VHE direct sysreg accessors into kvm_host.h
      KVM: arm64: Add basic hooks for injecting exceptions from EL2
      KVM: arm64: Inject AArch64 exceptions from HYP
      KVM: arm64: Inject AArch32 exceptions from HYP
      KVM: arm64: Remove SPSR manipulation primitives
      KVM: arm64: Consolidate exception injection
      KVM: arm64: Get rid of the AArch32 register mapping code
      KVM: arm64: Introduce handling of AArch32 TTBCR2 traps
      KVM: arm64: Move AArch32 exceptions over to AArch64 sysregs
      KVM: arm64: Add AArch32 mapping annotation
      KVM: arm64: Map AArch32 cp15 register to AArch64 sysregs
      KVM: arm64: Map AArch32 cp14 register to AArch64 sysregs
      KVM: arm64: Drop is_32bit trap attribute
      KVM: arm64: Drop is_aarch32 trap attribute
      KVM: arm64: Drop legacy copro shadow register
      KVM: arm64: Drop kvm_coproc.h
      KVM: arm64: Patch kimage_voffset instead of loading the EL1 value
      KVM: arm64: Simplify __kvm_enable_ssbs()
      KVM: arm64: Avoid repetitive stack access on host EL1 to EL2 exception
      Merge branch 'kvm-arm64/el2-pc' into kvmarm-master/next
      Merge branch 'kvm-arm64/copro-no-more' into kvmarm-master/next
      Merge branch 'kvm-arm64/host-hvc-table' into kvmarm-master/next
      KVM: arm64: Add kvm_vcpu_has_pmu() helper
      KVM: arm64: Set ID_AA64DFR0_EL1.PMUVer to 0 when no PMU support
      KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at reset time
      KVM: arm64: Inject UNDEF on PMU access when no PMU configured
      KVM: arm64: Remove PMU RAZ/WI handling
      KVM: arm64: Remove dead PMU sysreg decoding code
      KVM: arm64: Gate kvm_pmu_update_state() on the PMU feature
      KVM: arm64: Get rid of the PMU ready state
      Merge branch 'kvm-arm64/pmu-undef' into kvmarm-master/next
      Merge branch 'kvm-arm64/vector-rework' into kvmarm-master/next
      Merge branch 'kvm-arm64/cache-demux' into kvmarm-master/next
      Merge branch 'kvm-arm64/misc-5.11' into kvmarm-master/next
      arm64: Make the Meltdown mitigation state available
      KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV3=1 if the CPUs are Meltdown-safe
      Merge remote-tracking branch 'origin/kvm-arm64/csv3' into kvmarm-master/queue
      Merge remote-tracking branch 'arm64/for-next/uaccess' into HEAD
      Merge remote-tracking branch 'origin/kvm-arm64/misc-5.11' into kvmarm-master/queue
      KVM: arm64: Fix nVHE boot on VHE systems
      Merge remote-tracking branch 'origin/kvm-arm64/psci-relay' into kvmarm-master/next

Mark Rutland (18):
      arm64: uaccess: move uao_* alternatives to asm-uaccess.h
      arm64: ensure ERET from kthread is illegal
      arm64: add C wrappers for SET_PSTATE_*()
      arm64: head.S: rename el2_setup -> init_kernel_el
      arm64: head.S: cleanup SCTLR_ELx initialization
      arm64: head.S: always initialize PSTATE
      arm64: sdei: move uaccess logic to arch/arm64/
      arm64: sdei: explicitly simulate PAN/UAO entry
      arm64: uaccess: rename privileged uaccess routines
      arm64: uaccess: simplify __copy_user_flushcache()
      arm64: uaccess: refactor __{get,put}_user
      arm64: uaccess: split user/kernel routines
      arm64: uaccess cleanup macro naming
      arm64: uaccess: remove set_fs()
      arm64: uaccess: remove addr_limit_user_check()
      arm64: uaccess: remove redundant PAN toggling
      arm64: uaccess: remove vestigal UAO support
      arm64: mark __system_matches_cap as __maybe_unused

Shenming Lu (1):
      KVM: arm64: Delay the polling of the GICR_VPENDBASER.Dirty bit

Will Deacon (17):
      arm64: alternatives: Split up alternative.h
      arm64: cpufeatures: Add capability for LDAPR instruction
      arm64: alternatives: Remove READ_ONCE() usage during patch operation
      arm64: lto: Strengthen READ_ONCE() to acquire when CONFIG_LTO=y
      KVM: arm64: Remove redundant Spectre-v2 code from kvm_map_vector()
      KVM: arm64: Tidy up kvm_map_vector()
      KVM: arm64: Move kvm_get_hyp_vector() out of header file
      KVM: arm64: Make BP hardening globals static instead
      KVM: arm64: Move BP hardening helpers into spectre.h
      KVM: arm64: Re-jig logic when patching hardened hyp vectors
      KVM: arm64: Allocate hyp vectors statically
      arm64: spectre: Rename ARM64_HARDEN_EL2_VECTORS to ARM64_SPECTRE_V3A
      arm64: spectre: Consolidate spectre-v3a detection
      KVM: arm64: Remove redundant hyp vectors entry
      KVM: arm64: Move 'struct kvm_arch_memory_slot' out of uapi/
      KVM: arm64: Remove kvm_arch_vm_ioctl_check_extension()
      KVM: arm64: Remove unused __extended_idmap_trampoline() prototype

 Documentation/admin-guide/kernel-parameters.txt    |  10 +
 Documentation/arm64/memory.rst                     |   2 +-
 Documentation/virt/kvm/arm/pvtime.rst              |   4 +-
 arch/arm64/Kconfig                                 |  25 +-
 arch/arm64/include/asm/alternative-macros.h        | 217 ++++++++++++
 arch/arm64/include/asm/alternative.h               | 267 +-------------
 arch/arm64/include/asm/asm-uaccess.h               |  31 +-
 arch/arm64/include/asm/cpucaps.h                   |   8 +-
 arch/arm64/include/asm/cpufeature.h                |  20 +-
 arch/arm64/include/asm/el2_setup.h                 | 181 ++++++++++
 arch/arm64/include/asm/exec.h                      |   1 -
 arch/arm64/include/asm/futex.h                     |   8 +-
 arch/arm64/include/asm/insn.h                      |   3 +-
 arch/arm64/include/asm/kvm_arm.h                   |   1 +
 arch/arm64/include/asm/kvm_asm.h                   |  17 +-
 arch/arm64/include/asm/kvm_coproc.h                |  38 --
 arch/arm64/include/asm/kvm_emulate.h               |  70 +---
 arch/arm64/include/asm/kvm_host.h                  | 206 ++++++++---
 arch/arm64/include/asm/kvm_hyp.h                   |   4 +-
 arch/arm64/include/asm/kvm_mmu.h                   | 110 +++---
 arch/arm64/include/asm/mmu.h                       |  29 --
 arch/arm64/include/asm/percpu.h                    |   6 +
 arch/arm64/include/asm/processor.h                 |   4 +-
 arch/arm64/include/asm/ptrace.h                    |   8 +-
 arch/arm64/include/asm/rwonce.h                    |  73 ++++
 arch/arm64/include/asm/sections.h                  |   1 +
 arch/arm64/include/asm/smp.h                       |   4 +-
 arch/arm64/include/asm/spectre.h                   |  65 ++++
 arch/arm64/include/asm/sysreg.h                    |  23 +-
 arch/arm64/include/asm/thread_info.h               |  10 +-
 arch/arm64/include/asm/uaccess.h                   | 174 ++++-----
 arch/arm64/include/asm/virt.h                      |  26 ++
 arch/arm64/include/uapi/asm/kvm.h                  |   3 -
 arch/arm64/kernel/alternative.c                    |   7 +-
 arch/arm64/kernel/armv8_deprecated.c               |   4 +-
 arch/arm64/kernel/asm-offsets.c                    |   8 +-
 arch/arm64/kernel/cpu_errata.c                     |  19 +-
 arch/arm64/kernel/cpufeature.c                     |  88 +++--
 arch/arm64/kernel/entry.S                          |  19 +-
 arch/arm64/kernel/head.S                           | 180 +++-------
 arch/arm64/kernel/image-vars.h                     |  11 +-
 arch/arm64/kernel/process.c                        |  29 +-
 arch/arm64/kernel/proton-pack.c                    |  89 ++---
 arch/arm64/kernel/sdei.c                           |  33 +-
 arch/arm64/kernel/setup.c                          |   2 +-
 arch/arm64/kernel/signal.c                         |   3 -
 arch/arm64/kernel/sleep.S                          |   2 +-
 arch/arm64/kernel/suspend.c                        |   1 -
 arch/arm64/kernel/vdso/Makefile                    |   2 +-
 arch/arm64/kernel/vdso32/Makefile                  |   2 +-
 arch/arm64/kernel/vmlinux.lds.S                    |  12 +-
 arch/arm64/kvm/Makefile                            |   4 +-
 arch/arm64/kvm/aarch32.c                           | 232 ------------
 arch/arm64/kvm/arm.c                               | 281 ++++++++++++---
 arch/arm64/kvm/guest.c                             |  29 +-
 arch/arm64/kvm/handle_exit.c                       |  24 +-
 arch/arm64/kvm/hyp/Makefile                        |   2 +-
 arch/arm64/kvm/hyp/aarch32.c                       |   4 +-
 arch/arm64/kvm/hyp/exception.c                     | 331 +++++++++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S                     |  71 ++--
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h         |  62 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  17 +
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h     |  18 +
 arch/arm64/kvm/hyp/nvhe/Makefile                   |   5 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |  58 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 | 152 +++++---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 | 243 ++++++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c                  |  40 +++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S                  |   1 +
 arch/arm64/kvm/hyp/nvhe/psci-relay.c               | 324 +++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   8 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c                |  11 -
 arch/arm64/kvm/hyp/smccc_wa.S                      |  32 --
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |   2 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   2 +
 arch/arm64/kvm/hyp/vhe/Makefile                    |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   3 +
 arch/arm64/kvm/inject_fault.c                      | 167 +++------
 arch/arm64/kvm/mmio.c                              |   2 +-
 arch/arm64/kvm/mmu.c                               |   2 +-
 arch/arm64/kvm/pmu-emul.c                          |  19 +-
 arch/arm64/kvm/pvtime.c                            |   6 +-
 arch/arm64/kvm/regmap.c                            | 224 ------------
 arch/arm64/kvm/reset.c                             |  57 +--
 arch/arm64/kvm/sys_regs.c                          | 390 ++++++++-------------
 arch/arm64/kvm/sys_regs.h                          |   9 +-
 arch/arm64/kvm/va_layout.c                         | 104 +++++-
 arch/arm64/kvm/vgic-sys-reg-v3.c                   |   4 -
 arch/arm64/kvm/vgic/vgic-v4.c                      |  12 +
 arch/arm64/kvm/vgic/vgic.c                         |   3 +
 arch/arm64/lib/clear_user.S                        |   8 +-
 arch/arm64/lib/copy_from_user.S                    |   8 +-
 arch/arm64/lib/copy_in_user.S                      |  16 +-
 arch/arm64/lib/copy_to_user.S                      |   8 +-
 arch/arm64/lib/mte.S                               |   6 +-
 arch/arm64/lib/uaccess_flushcache.c                |   4 +-
 arch/arm64/mm/fault.c                              |   5 -
 arch/arm64/mm/proc.S                               |   2 +-
 drivers/firmware/arm_sdei.c                        |  14 -
 drivers/firmware/psci/psci.c                       | 126 ++++---
 drivers/irqchip/irq-gic-v3-its.c                   |  12 +-
 drivers/irqchip/irq-gic-v4.c                       |  19 +
 include/kvm/arm_pmu.h                              |   3 -
 include/kvm/arm_vgic.h                             |   1 +
 include/linux/irqchip/arm-gic-v4.h                 |   4 +
 include/linux/psci.h                               |   9 +
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |  39 ++-
 107 files changed, 3110 insertions(+), 2291 deletions(-)
 create mode 100644 arch/arm64/include/asm/alternative-macros.h
 create mode 100644 arch/arm64/include/asm/el2_setup.h
 delete mode 100644 arch/arm64/include/asm/kvm_coproc.h
 create mode 100644 arch/arm64/include/asm/rwonce.h
 delete mode 100644 arch/arm64/kvm/aarch32.c
 create mode 100644 arch/arm64/kvm/hyp/exception.c
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-smp.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/psci-relay.c
 delete mode 100644 arch/arm64/kvm/hyp/smccc_wa.S
 delete mode 100644 arch/arm64/kvm/regmap.c
