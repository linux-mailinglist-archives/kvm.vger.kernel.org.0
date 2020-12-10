Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FE42D60CC
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392189AbgLJQB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392107AbgLJQBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:01:12 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1501523D50;
        Thu, 10 Dec 2020 16:00:30 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knOMl-0008Di-V5; Thu, 10 Dec 2020 16:00:28 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v3 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
Date:   Thu, 10 Dec 2020 15:58:56 +0000
Message-Id: <20201210160002.1407373-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a rework of the NV series that I posted 10 months ago[1], as a
lot of the KVM code has changed since, and the series apply anymore
(not that anybody really cares as the the HW is, as usual, made of
unobtainium...).

From the previous version:

- Integration with the new page-table code
- New exception injection code
- No more messing with the nVHE code
- No AArch32!!!!
- Rebased on v5.10-rc4 + kvmarm/next for 5.11

From a functionality perspective, you can expect a L2 guest to work,
but don't even think of L3, as we only partially emulate the
ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,
as well as anything that would require a Stage-1 PTW. What we want to
achieve is that with NV disabled, there is no performance overhead and
no regression.

The series is roughly divided in 5 parts: exception handling, memory
virtualization, interrupts and timers for ARMv8.3, followed by the
ARMv8.4 support. There are of course some dependencies, but you'll
hopefully get the gist of it.

For the most courageous of you, I've put out a branch[2]. Of course,
you'll need some userspace. Andre maintains a hacked version of
kvmtool[3] that takes a --nested option, allowing the guest to be
started at EL2. You can run the whole stack in the Foundation
model. Don't be in a hurry ;-).

And to be clear: although Jintack and Christoffer have written tons of
the stuff originaly, I'm the one responsible for breaking it!

[1] https://lore.kernel.org/r/20200211174938.27809-1-maz@kernel.org
[2] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-5.11.-WIP
[3] git://linux-arm.org/kvmtool.git nv/nv-wip-5.2-rc5

Andre Przywara (1):
  KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ

Christoffer Dall (15):
  KVM: arm64: nv: Introduce nested virtualization VCPU feature
  KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
  KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
  KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
  KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values
  KVM: arm64: nv: Handle trapped ERET from virtual EL2
  KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
  KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
  KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2
    changes
  KVM: arm64: nv: Implement nested Stage-2 page table walk logic
  KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
  KVM: arm64: nv: arch_timer: Support hyp timer emulation
  KVM: arm64: nv: vgic: Emulate the HW bit in software
  KVM: arm64: nv: Add nested GICv3 tracepoints
  KVM: arm64: nv: Sync nested timer state with ARMv8.4

Jintack Lim (19):
  arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
  KVM: arm64: nv: Handle HCR_EL2.NV system register traps
  KVM: arm64: nv: Support virtual EL2 exceptions
  KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
  KVM: arm64: nv: Trap SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2
  KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
  KVM: arm64: nv: Handle PSCI call via smc from the guest
  KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
  KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
  KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting
  KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
  KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit setting
  KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
  KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
  KVM: arm64: nv: Introduce sys_reg_desc.forward_trap
  KVM: arm64: nv: Set a handler for the system instruction traps
  KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
  KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
  KVM: arm64: nv: Nested GICv3 Support

Marc Zyngier (31):
  KVM: arm64: nv: Add EL2 system registers to vcpu context
  KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
  KVM: arm64: nv: Handle virtual EL2 registers in
    vcpu_read/write_sys_reg()
  KVM: arm64: nv: Handle SPSR_EL2 specially
  KVM: arm64: nv: Handle HCR_EL2.E2H specially
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: nv: Forward debug traps to the nested guest
  KVM: arm64: nv: Filter out unsupported features from ID regs
  KVM: arm64: nv: Hide RAS from nested guests
  KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
  KVM: arm64: nv: Handle shadow stage 2 page faults
  KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
  KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
  KVM: arm64: nv: Add handling of EL2-specific timer registers
  KVM: arm64: nv: Load timer before the GIC
  KVM: arm64: nv: Don't load the GICv4 context on entering a nested
    guest
  KVM: arm64: nv: Implement maintenance interrupt forwarding
  KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
  KVM: arm64: nv: Add handling of ARMv8.4-TTL TLB invalidation
  KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like
    information
  KVM: arm64: Allow populating S2 SW bits
  KVM: arm64: nv: Tag shadow S2 entries with nested level
  KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
  KVM: arm64: Map VNCR-capable registers to a separate page
  KVM: arm64: nv: Move nested vgic state into the sysreg file
  KVM: arm64: Add ARMv8.4 Enhanced Nested Virt cpufeature
  KVM: arm64: nv: Synchronize PSTATE early on exit
  KVM: arm64: nv: Allocate VNCR page when required
  KVM: arm64: nv: Enable ARMv8.4-NV support
  KVM: arm64: nv: Fast-track 'InHost' exception returns
  KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests

 .../admin-guide/kernel-parameters.txt         |    4 +
 .../virt/kvm/devices/arm-vgic-v3.rst          |   12 +-
 arch/arm64/include/asm/cpucaps.h              |    2 +
 arch/arm64/include/asm/esr.h                  |    6 +
 arch/arm64/include/asm/kvm_arm.h              |   28 +-
 arch/arm64/include/asm/kvm_asm.h              |    4 +
 arch/arm64/include/asm/kvm_emulate.h          |  145 +-
 arch/arm64/include/asm/kvm_host.h             |  175 ++-
 arch/arm64/include/asm/kvm_hyp.h              |    2 +
 arch/arm64/include/asm/kvm_mmu.h              |   17 +-
 arch/arm64/include/asm/kvm_nested.h           |  152 ++
 arch/arm64/include/asm/kvm_pgtable.h          |   10 +
 arch/arm64/include/asm/sysreg.h               |  104 +-
 arch/arm64/include/asm/vncr_mapping.h         |   73 +
 arch/arm64/include/uapi/asm/kvm.h             |    2 +
 arch/arm64/kernel/cpufeature.c                |   35 +
 arch/arm64/kvm/Makefile                       |    4 +-
 arch/arm64/kvm/arch_timer.c                   |  189 ++-
 arch/arm64/kvm/arm.c                          |   34 +-
 arch/arm64/kvm/at.c                           |  231 ++++
 arch/arm64/kvm/emulate-nested.c               |  186 +++
 arch/arm64/kvm/guest.c                        |    6 +
 arch/arm64/kvm/handle_exit.c                  |   81 +-
 arch/arm64/kvm/hyp/exception.c                |   44 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   31 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   28 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   10 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |    2 +-
 arch/arm64/kvm/hyp/pgtable.c                  |    6 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |    2 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |  207 ++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |  125 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                  |   83 ++
 arch/arm64/kvm/inject_fault.c                 |   62 +-
 arch/arm64/kvm/mmu.c                          |  183 ++-
 arch/arm64/kvm/nested.c                       |  908 ++++++++++++
 arch/arm64/kvm/reset.c                        |   14 +-
 arch/arm64/kvm/sys_regs.c                     | 1226 ++++++++++++++++-
 arch/arm64/kvm/sys_regs.h                     |    6 +
 arch/arm64/kvm/trace_arm.h                    |   65 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   30 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   22 +
 arch/arm64/kvm/vgic/vgic-nested-trace.h       |  137 ++
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |  240 ++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |   39 +-
 arch/arm64/kvm/vgic/vgic.c                    |   44 +
 arch/arm64/kvm/vgic/vgic.h                    |   10 +
 include/kvm/arm_arch_timer.h                  |    7 +
 include/kvm/arm_vgic.h                        |   16 +
 tools/arch/arm/include/uapi/asm/kvm.h         |    1 +
 50 files changed, 4890 insertions(+), 160 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h
 create mode 100644 arch/arm64/kvm/at.c
 create mode 100644 arch/arm64/kvm/emulate-nested.c
 create mode 100644 arch/arm64/kvm/nested.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-nested-trace.h
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

-- 
2.29.2

