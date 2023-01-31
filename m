Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B323C6828BD
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjAaJZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjAaJZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:25:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671CE2D50
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:25:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 909376146C
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F42C433EF;
        Tue, 31 Jan 2023 09:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675157132;
        bh=tGHkRbN3qMfNg/4XaLyH+u6pSLp2UzgLkcIcf96UEBs=;
        h=From:To:Cc:Subject:Date:From;
        b=LQ/kbQhwB51D/x3YuJ0AWT3FANX9yuzZFc5r1J44obkxEfKCdZcLAza9bVqJomNVe
         8QjBjMWitBm3tsl68DDRcNaEhbDnb0/DKGvlEfVxkOfdjsfMXSVrN+rhN925pKgL2w
         KgrzAqpPyc7mEw2G0Q1LR2woPsTdp1U/mMgrMox4ETYxLTrRNSBt2/EpluGAdov5Z/
         dzZCWAZCfoYnMEOQjMb9O7d2ycYepBLbyDKMeS9KQ/pJGTLlYK6+OG0MXjNmv9iLiK
         d5oc9l0VIdTfyjWQ6NrsRS7JXzPauphRUV3Sq3xoywedP24m+YdoJvbvf2yR99WUqB
         rEaIVLFHOSLjg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtN-0067U2-FG;
        Tue, 31 Jan 2023 09:25:29 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 00/69] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
Date:   Tue, 31 Jan 2023 09:23:55 +0000
Message-Id: <20230131092504.2880505-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the second drop of NV support on arm64 for this year. This
month even. Something is happening!

For the previous episodes, see [1].

What's changed:

- TLB invalidation has been fixed! A couple of terrible bugs were
  preventing the TLBI emulation code from selecting the correct MMU
  context, leading the shadow page-tables never being invalidated.

- As a consequence, EDK2 now works correctly at L2 with QEMU as the
  VMM, as we now teardown the S2 PTs when L1 unmaps the memslot on
  write to the emulated flash.

- As a consequence of the above consequence, the Debian installer
  passes with flying colors at L2. Yay!

- A few other fixes, such as better handling of AT instructions.

- All rebased on 6.2-rc4 + kvmarm-fixes-6.2-* + kvmarm/next. Full
  branch at [2].

Performance:

- This is surprisingly good. Specially after years of watching paint
  dry in a model. Of course, if your workload is exit/trap heavy, it
  will suck. But not quite as much as on the model, which is the
  benchmark.

- For CPU intensive workloads (kernel compilation), I have seen as
  little a 6% overhead between L0 and L2. YMMV.

Testing:

- No model involved this time around. I have solely run the series on
  an Apple M2 with 16k pages, because that's what I have, and I
  consider it the reference (HW you cannot get your hands on doesn't
  really count).

- Because the M2 is "pretty lax" with the architecture, a bunch of
  things cannot be tested (E2H=0 being the most obvious one).

- For the same reason, I may be relying on non-architectural
  behaviours. I've done my best not to, but you never know. Until I
  get a machine that *is* fully compliant with the architecture, it is
  a risk I'll have to take.

- The series has a number of hacks for the M2 to actually work (vgic
  emulation, mostly).

- I haven't tested FEAT_NV (only FEAT_NV2), and seriously considering
  dropping the support for it. I doubt there is any HW solely
  implementing FEAT_NV and not FEAT_NV2.

- There is a kvmtool branch that allows you to use the --nested option
  at [3]. I have no idea what became of the equivalent QEMU patches.

Merging:

- I would suggest that the first 12 patches are in a mergeable
  state. Only patch #2 hasn't been reviewed yet (because it is new),
  but it doesn't affect anything non-NV and makes NV work. I really
  want this in before CCA! :D

- I have a yet another fix for the Apple AIC driver, but I'll post
  that separately.

Many thanks to Alexandru, Chase, Ganapatrao and Russell for spending a
lot of time reviewing this, spotting issues and providing helpful
suggestions.

[1] https://lore.kernel.org/r/20230112191927.1814989-1-maz@kernel.org
[2] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-6.3-WIP
[3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/log/?h=arm64/nv-5.16

Andre Przywara (1):
  KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ

Christoffer Dall (13):
  KVM: arm64: nv: Introduce nested virtualization VCPU feature
  KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
  KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
  KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
  KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values
  KVM: arm64: nv: Handle trapped ERET from virtual EL2
  KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
  KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2
    changes
  KVM: arm64: nv: Implement nested Stage-2 page table walk logic
  KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
  KVM: arm64: nv: vgic: Emulate the HW bit in software
  KVM: arm64: nv: Add nested GICv3 tracepoints
  KVM: arm64: nv: Sync nested timer state with FEAT_NV2

Jintack Lim (16):
  arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
  KVM: arm64: nv: Handle HCR_EL2.NV system register traps
  KVM: arm64: nv: Support virtual EL2 exceptions
  KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
  KVM: arm64: nv: Add accessors for SPSR_EL1, ELR_EL1 and VBAR_EL1 from
    virtual EL2
  KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
  KVM: arm64: nv: Handle PSCI call via smc from the guest
  KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
  KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
  KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting
  KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
  KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit setting
  KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
  KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
  KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
  KVM: arm64: nv: Nested GICv3 Support

Marc Zyngier (39):
  KVM: arm64: Use the S2 MMU context to iterate over S2 table
  KVM: arm64: nv: Add EL2 system registers to vcpu context
  KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
  KVM: arm64: nv: Handle virtual EL2 registers in
    vcpu_read/write_sys_reg()
  KVM: arm64: nv: Handle SPSR_EL2 specially
  KVM: arm64: nv: Handle HCR_EL2.E2H specially
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
  KVM: arm64: nv: Allow a sysreg to be hidden from userspace only
  KVM: arm64: nv: Forward debug traps to the nested guest
  KVM: arm64: nv: Filter out unsupported features from ID regs
  KVM: arm64: nv: Hide RAS from nested guests
  KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
  KVM: arm64: nv: Handle shadow stage 2 page faults
  KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
  KVM: arm64: nv: Set a handler for the system instruction traps
  KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
  KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
  KVM: arm64: nv: arch_timer: Support hyp timer emulation
  KVM: arm64: nv: Add handling of EL2-specific timer registers
  KVM: arm64: nv: Load timer before the GIC
  KVM: arm64: nv: Don't load the GICv4 context on entering a nested
    guest
  KVM: arm64: nv: Implement maintenance interrupt forwarding
  KVM: arm64: nv: Deal with broken VGIC on maintenance interrupt
    delivery
  KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
  KVM: arm64: nv: Add handling of FEAT_TTL TLB invalidation
  KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like
    information
  KVM: arm64: nv: Tag shadow S2 entries with nested level
  KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
  KVM: arm64: nv: Map VNCR-capable registers to a separate page
  KVM: arm64: nv: Move nested vgic state into the sysreg file
  KVM: arm64: Add FEAT_NV2 cpu feature
  KVM: arm64: nv: Publish emulated timer interrupt state in the
    in-memory state
  KVM: arm64: nv: Allocate VNCR page when required
  KVM: arm64: nv: Enable ARMv8.4-NV support
  KVM: arm64: nv: Fast-track 'InHost' exception returns
  KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
  KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
  KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on

 .../admin-guide/kernel-parameters.txt         |    7 +-
 .../virt/kvm/devices/arm-vgic-v3.rst          |   12 +-
 arch/arm64/include/asm/esr.h                  |    5 +
 arch/arm64/include/asm/kvm_arm.h              |   27 +-
 arch/arm64/include/asm/kvm_asm.h              |    4 +
 arch/arm64/include/asm/kvm_emulate.h          |  159 +-
 arch/arm64/include/asm/kvm_host.h             |  195 ++-
 arch/arm64/include/asm/kvm_hyp.h              |    2 +
 arch/arm64/include/asm/kvm_mmu.h              |   23 +-
 arch/arm64/include/asm/kvm_nested.h           |  150 ++
 arch/arm64/include/asm/sysreg.h               |  102 +-
 arch/arm64/include/asm/vncr_mapping.h         |   74 +
 arch/arm64/include/uapi/asm/kvm.h             |    2 +
 arch/arm64/kernel/cpufeature.c                |   36 +
 arch/arm64/kvm/Makefile                       |    4 +-
 arch/arm64/kvm/arch_timer.c                   |  301 +++-
 arch/arm64/kvm/arm.c                          |   38 +-
 arch/arm64/kvm/at.c                           |  221 +++
 arch/arm64/kvm/emulate-nested.c               |  217 +++
 arch/arm64/kvm/guest.c                        |    6 +
 arch/arm64/kvm/handle_exit.c                  |   74 +-
 arch/arm64/kvm/hyp/exception.c                |   48 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   12 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   24 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |    2 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |    2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |    2 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |  230 ++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |  125 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                  |   83 +
 arch/arm64/kvm/inject_fault.c                 |   61 +-
 arch/arm64/kvm/mmu.c                          |  259 +++-
 arch/arm64/kvm/nested.c                       |  896 +++++++++++
 arch/arm64/kvm/reset.c                        |   17 +
 arch/arm64/kvm/sys_regs.c                     | 1377 ++++++++++++++++-
 arch/arm64/kvm/sys_regs.h                     |   14 +-
 arch/arm64/kvm/trace_arm.h                    |   65 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   33 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   29 +-
 arch/arm64/kvm/vgic/vgic-nested-trace.h       |  137 ++
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |  244 +++
 arch/arm64/kvm/vgic/vgic-v3.c                 |   39 +-
 arch/arm64/kvm/vgic/vgic.c                    |   44 +
 arch/arm64/kvm/vgic/vgic.h                    |   10 +
 arch/arm64/tools/cpucaps                      |    2 +
 include/clocksource/arm_arch_timer.h          |    4 +
 include/kvm/arm_arch_timer.h                  |    9 +-
 include/kvm/arm_vgic.h                        |   16 +
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm/include/uapi/asm/kvm.h         |    1 +
 50 files changed, 5221 insertions(+), 224 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h
 create mode 100644 arch/arm64/kvm/at.c
 create mode 100644 arch/arm64/kvm/emulate-nested.c
 create mode 100644 arch/arm64/kvm/nested.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-nested-trace.h
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

-- 
2.34.1

