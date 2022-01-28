Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC62749F910
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348386AbiA1MT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243048AbiA1MT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:19:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB213C061714
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:19:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8911A61345
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6349C340E6;
        Fri, 28 Jan 2022 12:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372366;
        bh=hsG3ROQDWq32IhFhvaa0G4T355RjVp+ePhiZfPfoVUk=;
        h=From:To:Cc:Subject:Date:From;
        b=oJusbHPx++gfx9M9z0bDuy92tZsjSEfsnefJvRDGFR3dk7jHsPiWYvv51Q6/MErj8
         8C2pIUgKUEvg4xQDzcsJfZjzskNH8Jm/fA+iGtAui9SNJTI3Pn0TI75HgbwwiYkcKL
         ZGld2oIYcsDq9alvbq9200ArvqD/Iyx4rPqn3lPQ3WLSjEN9ytRNTswOz/DS/2HX8s
         AaCmx38qxuRPH4RSRj0MfHynlfJSlz9FTqmfLFDEKu9ZyQiboVlWNO14v9OJ1GpqG+
         dODf/O9Sd+VzLXjsKA7RavjJBzPFYeXfgyZQfudww8Z0a9+ACUow/MqHvJcXZYDwBf
         zT+GpNWhjVpcQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQDr-003njR-M5; Fri, 28 Jan 2022 12:19:23 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 00/64] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
Date:   Fri, 28 Jan 2022 12:18:08 +0000
Message-Id: <20220128121912.509006-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here the first drop of the KVM/arm64 NV support code for 2022. Nothing
to worry about, it certainly isn't going to be the last!

A number of changes since [1]:

- The exposure of the EL2 sysregs to userspace is now gated by NV
  being enabled, as you'd expect. Which means we shouldn't break live
  migration anymore (yay!).

- We now correctly detect and handle an Illegal Exception Return from
  vEL2. Don't try this at home, kids!

- Non-nested exception injection when executing at EL0 has been fixed.

- We forbid NV+SVE for now. This is a change in ABI, and I hope to
  remove this requirement at some point. I've pushed out a kvmtool
  change that enforces this [2], and QEMU will need similar surgery
  for now.

- nested_virt_in_use() is now renamed to vcpu_has_nv() (resp
  vcpu_has_nv2() for the v8.4 support).

- A bunch of small nits being tidied up, thanks to our eagle eyed
  reviewers.

Many thanks to Alexandru, Chase, Ganapatrao and Russell for spending a
lot of time reviewing this and actively spotting issues. There is a
pending issue that Ganapatrao mentioned when running L0 with 4kB and
L1 with 64kB, resulting in no forward progress. I haven't investigated
this yet, but I strongly suspect that something is amiss in the S2 PTW
at the point where we combine the L2 IPA with the L1 IPA.

As usual, blame me for any bug, and nobody else. It has been tested on
my usual zoo, and nothing caught fire. Which means nothing, of course.
Obviously, it isn't feature complete, and it is quite easy to write a
guest that will not behave as intended. The current goal is to make
sure that non-NV KVM is unaffected by the NV stuff.

It is massively painful to run on the FVP, but if you have a Neoverse
V1 or N2 system (or anything else with ARMv8.4-NV) that is collecting
dust, I have the right stuff to keep it busy.

	M.

[1] https://lore.kernel.org/r/20211129200150.351436-1-maz@kernel.org
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/log/?h=arm64/nv-5.16

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
  KVM: arm64: nv: Set a handler for the system instruction traps
  KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
  KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
  KVM: arm64: nv: Nested GICv3 Support

Marc Zyngier (30):
  KVM: arm64: nv: Add EL2 system registers to vcpu context
  KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
  KVM: arm64: nv: Handle virtual EL2 registers in
    vcpu_read/write_sys_reg()
  KVM: arm64: nv: Handle SPSR_EL2 specially
  KVM: arm64: nv: Handle HCR_EL2.E2H specially
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: nv: Allow a sysreg to be hidden from userspace only
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
 arch/arm64/include/asm/esr.h                  |    5 +
 arch/arm64/include/asm/kvm_arm.h              |   27 +-
 arch/arm64/include/asm/kvm_asm.h              |    4 +
 arch/arm64/include/asm/kvm_emulate.h          |  143 +-
 arch/arm64/include/asm/kvm_host.h             |  185 ++-
 arch/arm64/include/asm/kvm_hyp.h              |    2 +
 arch/arm64/include/asm/kvm_mmu.h              |   18 +-
 arch/arm64/include/asm/kvm_nested.h           |  156 ++
 arch/arm64/include/asm/sysreg.h               |  101 +-
 arch/arm64/include/asm/vncr_mapping.h         |   74 +
 arch/arm64/include/uapi/asm/kvm.h             |    2 +
 arch/arm64/kernel/cpufeature.c                |   34 +
 arch/arm64/kvm/Makefile                       |    4 +-
 arch/arm64/kvm/arch_timer.c                   |  202 ++-
 arch/arm64/kvm/arm.c                          |   42 +-
 arch/arm64/kvm/at.c                           |  219 +++
 arch/arm64/kvm/emulate-nested.c               |  211 +++
 arch/arm64/kvm/guest.c                        |    6 +
 arch/arm64/kvm/handle_exit.c                  |   81 +-
 arch/arm64/kvm/hyp/exception.c                |   49 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   12 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   24 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |    2 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |    2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |    2 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |  181 ++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |  125 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                  |   83 ++
 arch/arm64/kvm/inject_fault.c                 |   68 +-
 arch/arm64/kvm/mmu.c                          |  206 ++-
 arch/arm64/kvm/nested.c                       |  915 ++++++++++++
 arch/arm64/kvm/reset.c                        |   30 +-
 arch/arm64/kvm/sys_regs.c                     | 1252 ++++++++++++++++-
 arch/arm64/kvm/sys_regs.h                     |   14 +-
 arch/arm64/kvm/trace_arm.h                    |   65 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   30 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   22 +
 arch/arm64/kvm/vgic/vgic-nested-trace.h       |  137 ++
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |  242 ++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |   39 +-
 arch/arm64/kvm/vgic/vgic.c                    |   44 +
 arch/arm64/kvm/vgic/vgic.h                    |   10 +
 arch/arm64/tools/cpucaps                      |    2 +
 include/kvm/arm_arch_timer.h                  |    9 +-
 include/kvm/arm_vgic.h                        |   16 +
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm/include/uapi/asm/kvm.h         |    1 +
 49 files changed, 4947 insertions(+), 171 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h
 create mode 100644 arch/arm64/kvm/at.c
 create mode 100644 arch/arm64/kvm/emulate-nested.c
 create mode 100644 arch/arm64/kvm/nested.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-nested-trace.h
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

-- 
2.30.2

