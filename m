Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F9446249E
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhK2WW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbhK2WVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:21:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF305C08EAE0
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:02:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F218CE13D7
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183FAC53FC7;
        Mon, 29 Nov 2021 20:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216131;
        bh=E57fwUAn7dhFlq0k7rbnpzZ9o3Q/5kkZDl6gFXo5Vjw=;
        h=From:To:Cc:Subject:Date:From;
        b=QomiU2CEs57VZ1YhAlP4St8dmkOZOmC5IYkulRoE9+dJqNiicDf7DMfkLg6D6/cml
         14qRCW0qtzS9rNQLFmM9xxUaT08nA8W/25mxrnsF6bp3GdE7PbR6qVe8BGLxgK9zjq
         x9UMCgEoQTdYa3Z/V6f198N0cZM++a8jDOfdvtoPkUNNKWrt5rR5kt6TKs0goosty1
         AYQnAJEBv6qr36Hu7QoZLSdTUSV7okonBVN72MOL4QgoVXLk+KQPtDgOh3VyiRcRwh
         0xrRDe1yf4GW44WuERcWbm+TXUd0J8s3TfJ/uBmza8QBoJl2SDGOBQXekyB/td4cv9
         Y/yJa8oLCyD9Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqn-008gvR-2Q; Mon, 29 Nov 2021 20:02:09 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 00/69] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
Date:   Mon, 29 Nov 2021 20:00:41 +0000
Message-Id: <20211129200150.351436-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here the bi-annual drop of the KVM/arm64 NV support code, the least
loved series in the history of KVM!

Not a lot has changed since [1]: a number of bug fixes (wrong MMU
context being selected leading to failing TLB invalidations, fixes
around the handling of nested faults), a complete rewrite of the early
exit handling, a change in the way the NV support is enabled
("kvm-arm.mode=nested"), and a rebase on top of 5.16-rc1.

The first 2 patches are already on their way upstream as fixes, and
the third is a likely candidate too.

As usual, blame me for any bug, and nobody else. It has been tested on
my usual zoo, and nothing caught fire. Which means nothing, of course.
Obviously, it isn't feature complete, and it is quite easy to write a
guest that will not behave as intended. The current goal is to make
sure that non-NV KVM is unaffected by the NV stuff.

It is massively painful to run on the FVP, but if you have a Neoverse
V1 or N2 system (or anything else with ARMv8.4-NV) that is collecting
dust, I have the right stuff to keep it busy.

	M.

[1] https://lore.kernel.org/r/20210510165920.1913477-1-maz@kernel.org

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

Jintack Lim (18):
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
  KVM: arm64: nv: Nested GICv3 Support

Marc Zyngier (35):
  KVM: arm64: Save PSTATE early on exit
  KVM: arm64: Move pkvm's special 32bit handling into a generic
    infrastructure
  KVM: arm64: Add minimal handling for the ARMv8.7 PMU
  KVM: arm64: Rework kvm_pgtable initialisation
  KVM: arm64: Allow preservation of the S2 SW bits
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
  KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
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
  KVM: arm64: nv: Tag shadow S2 entries with nested level
  KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
  KVM: arm64: nv: Map VNCR-capable registers to a separate page
  KVM: arm64: nv: Move nested vgic state into the sysreg file
  KVM: arm64: Add ARMv8.4 Enhanced Nested Virt cpufeature
  KVM: arm64: nv: Allocate VNCR page when required
  KVM: arm64: nv: Enable ARMv8.4-NV support
  KVM: arm64: nv: Fast-track 'InHost' exception returns
  KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests

 .../admin-guide/kernel-parameters.txt         |    7 +-
 .../virt/kvm/devices/arm-vgic-v3.rst          |   12 +-
 arch/arm64/include/asm/esr.h                  |    6 +
 arch/arm64/include/asm/kvm_arm.h              |   29 +-
 arch/arm64/include/asm/kvm_asm.h              |    4 +
 arch/arm64/include/asm/kvm_emulate.h          |  145 +-
 arch/arm64/include/asm/kvm_host.h             |  185 ++-
 arch/arm64/include/asm/kvm_hyp.h              |    2 +
 arch/arm64/include/asm/kvm_mmu.h              |   18 +-
 arch/arm64/include/asm/kvm_nested.h           |  152 +++
 arch/arm64/include/asm/kvm_pgtable.h          |    9 +-
 arch/arm64/include/asm/sysreg.h               |  102 +-
 arch/arm64/include/asm/vncr_mapping.h         |   74 +
 arch/arm64/include/uapi/asm/kvm.h             |    2 +
 arch/arm64/kernel/cpufeature.c                |   34 +
 arch/arm64/kvm/Makefile                       |    4 +-
 arch/arm64/kvm/arch_timer.c                   |  202 ++-
 arch/arm64/kvm/arm.c                          |   42 +-
 arch/arm64/kvm/at.c                           |  231 ++++
 arch/arm64/kvm/emulate-nested.c               |  186 +++
 arch/arm64/kvm/guest.c                        |    6 +
 arch/arm64/kvm/handle_exit.c                  |   81 +-
 arch/arm64/kvm/hyp/exception.c                |   45 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   26 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   31 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |    4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   10 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |    2 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   13 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |    2 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |  185 ++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |  125 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                  |   83 ++
 arch/arm64/kvm/inject_fault.c                 |   68 +-
 arch/arm64/kvm/mmu.c                          |  205 ++-
 arch/arm64/kvm/nested.c                       |  922 +++++++++++++
 arch/arm64/kvm/pmu-emul.c                     |    1 +
 arch/arm64/kvm/reset.c                        |   11 +-
 arch/arm64/kvm/sys_regs.c                     | 1213 ++++++++++++++++-
 arch/arm64/kvm/sys_regs.h                     |    8 +
 arch/arm64/kvm/trace_arm.h                    |   65 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   30 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   22 +
 arch/arm64/kvm/vgic/vgic-nested-trace.h       |  137 ++
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |  240 ++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |   39 +-
 arch/arm64/kvm/vgic/vgic.c                    |   44 +
 arch/arm64/kvm/vgic/vgic.h                    |   10 +
 arch/arm64/tools/cpucaps                      |    2 +
 include/kvm/arm_arch_timer.h                  |    9 +-
 include/kvm/arm_vgic.h                        |   16 +
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm/include/uapi/asm/kvm.h         |    1 +
 53 files changed, 4918 insertions(+), 185 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h
 create mode 100644 arch/arm64/kvm/at.c
 create mode 100644 arch/arm64/kvm/emulate-nested.c
 create mode 100644 arch/arm64/kvm/nested.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-nested-trace.h
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

-- 
2.30.2

