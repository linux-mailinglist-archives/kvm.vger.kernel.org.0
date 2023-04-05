Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652926D821F
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238818AbjDEPke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238748AbjDEPkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:40:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59546E64
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF5EF629C0
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A6CC433D2;
        Wed,  5 Apr 2023 15:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709229;
        bh=KPgYIQCS5YdBLgtKx4rgFUkgOTXrIEnOsTzBy9exrHs=;
        h=From:To:Cc:Subject:Date:From;
        b=HiIVmpoupQ8Uhl1XLUXKxbkkwEi6rQTv+XjpLVJ4Xk4yh1x1ghKV4B5Mzu7l2ynmT
         COFlGr2mFHKtVKeR5Nw1NSQPta6bJrQ6IjZwimE49LHvrjtK2H97hBMtl+nSx4rKBi
         tiOqJMHLPozySfytERfhSDlWhI9a9LsFR3L6ylQCoOva7Cj/NWG/fbM5Ivfzgl34M5
         qoRy++RBB2UHOvO+bupncLa75ZLufIFUJbsfeXIK+HcvblDFMXClFike3a686gLJaJ
         Q6cV1UlJRxFDlsNZlX1PlwaLpURhrC2+17RkTvwUYqQFiQSXpvKSxUC0eirCyCWCUU
         T6RvDCWPcEm+w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5FK-0062PV-RE;
        Wed, 05 Apr 2023 16:40:26 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v9 00/50] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
Date:   Wed,  5 Apr 2023 16:39:18 +0100
Message-Id: <20230405154008.3552854-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the third drop of NV support on arm64 for this year. Holy crap!

For the previous episodes, see [1].

What's changed:

- The timer code has been completely revamped -- see the series at [4]
  which serves as the base for this series. We now properly deal with
  both global and per-CPU, per-timer offsets, and it will make it much
  easier to add full ECV support to nested.

- More TLB invalidation rework -- invalidation by VMID now matches the
  architecture requirements (it must invalidate all the use of that
  particular VMID, irrespective of the VTTRB_EL2.BADDR value). The
  good thing is that the invalidation code now makes much more sense!

- VGIC workarounds for M2 are now applied in L0 for L1, so L2 can do
  whatever it wants and cannot crash the system anymore...

- Rebased on v6.3-rc5 + the timer series, full branch at [2].

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
  really count). If you have a non-M2, NV-capable machine gathering
  dust somewhere and want to give a cosy home, let me know!

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
  at [3]. Miguel picked up Haibo Xu's patches[5], but I haven't tested
  them.

Merging:

- I've queued the timer patches for now. I'm also tempted to take the
  first 7 patches from this series, as they have been reviewed for
  most of them.

Many thanks to Alexandru, Chase, Ganapatrao and Russell for spending a
lot of time reviewing this, spotting issues and providing helpful
suggestions.

[1] https://lore.kernel.org/r/20230131092504.2880505-1-maz@kernel.org
[2] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-6.4-WIP
[3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/log/?h=arm64/nv-5.16
[4] https://lore.kernel.org/r/20230330174800.2677007-1-maz@kernel.org
[5] https://lore.kernel.org/r/20230227163718.62003-1-miguel.luis@oracle.com

Andre Przywara (1):
  KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ

Christoffer Dall (5):
  KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
  KVM: arm64: nv: Implement nested Stage-2 page table walk logic
  KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
  KVM: arm64: nv: vgic: Emulate the HW bit in software
  KVM: arm64: nv: Sync nested timer state with FEAT_NV2

Jintack Lim (9):
  KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
  KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
  KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
  KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting
  KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
  KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit setting
  KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
  KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
  KVM: arm64: nv: Nested GICv3 Support

Marc Zyngier (35):
  KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
  KVM: arm64: nv: Handle virtual EL2 registers in
    vcpu_read/write_sys_reg()
  KVM: arm64: nv: Handle SPSR_EL2 specially
  KVM: arm64: nv: Handle HCR_EL2.E2H specially
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: nv: Forward debug traps to the nested guest
  KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
  KVM: arm64: nv: Handle shadow stage 2 page faults
  KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
  KVM: arm64: nv: Set a handler for the system instruction traps
  KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
  KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
  KVM: arm64: nv: Hide RAS from nested guests
  KVM: arm64: nv: Add handling of EL2-specific timer registers
  KVM: arm64: nv: Forward timer traps to nested EL2
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
  KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
  KVM: arm64: nv: Publish emulated timer interrupt state in the
    in-memory state
  KVM: arm64: nv: Allocate VNCR page when required
  KVM: arm64: nv: Enable ARMv8.4-NV support
  KVM: arm64: nv: Fast-track 'InHost' exception returns
  KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
  KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
  KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on

 .../virt/kvm/devices/arm-vgic-v3.rst          |   12 +-
 arch/arm64/include/asm/esr.h                  |    1 +
 arch/arm64/include/asm/kvm_arm.h              |    8 +
 arch/arm64/include/asm/kvm_asm.h              |    4 +
 arch/arm64/include/asm/kvm_emulate.h          |   93 +-
 arch/arm64/include/asm/kvm_host.h             |  168 ++-
 arch/arm64/include/asm/kvm_hyp.h              |    2 +
 arch/arm64/include/asm/kvm_mmu.h              |   12 +
 arch/arm64/include/asm/kvm_nested.h           |  135 +++
 arch/arm64/include/asm/sysreg.h               |   61 +
 arch/arm64/include/asm/vncr_mapping.h         |   74 ++
 arch/arm64/include/uapi/asm/kvm.h             |    1 +
 arch/arm64/kernel/cpufeature.c                |   11 +
 arch/arm64/kvm/Makefile                       |    4 +-
 arch/arm64/kvm/arch_timer.c                   |   98 +-
 arch/arm64/kvm/arm.c                          |   33 +-
 arch/arm64/kvm/at.c                           |  219 ++++
 arch/arm64/kvm/emulate-nested.c               |   58 +-
 arch/arm64/kvm/handle_exit.c                  |   29 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   12 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |    5 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |    2 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |    2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |    6 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |  206 +++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |  125 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                  |   83 ++
 arch/arm64/kvm/mmu.c                          |  243 +++-
 arch/arm64/kvm/nested.c                       |  799 ++++++++++++
 arch/arm64/kvm/reset.c                        |    1 +
 arch/arm64/kvm/sys_regs.c                     | 1079 ++++++++++++++++-
 arch/arm64/kvm/vgic/vgic-init.c               |   33 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   29 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |  248 ++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |   43 +-
 arch/arm64/kvm/vgic/vgic.c                    |   29 +
 arch/arm64/kvm/vgic/vgic.h                    |   10 +
 arch/arm64/tools/cpucaps                      |    1 +
 include/clocksource/arm_arch_timer.h          |    4 +
 include/kvm/arm_arch_timer.h                  |    1 +
 include/kvm/arm_vgic.h                        |   17 +
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm/include/uapi/asm/kvm.h         |    1 +
 43 files changed, 3841 insertions(+), 162 deletions(-)
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h
 create mode 100644 arch/arm64/kvm/at.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

-- 
2.34.1

