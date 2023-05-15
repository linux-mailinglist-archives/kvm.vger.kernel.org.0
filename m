Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE87B7038A6
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244332AbjEOReA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244323AbjEORdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94DA15256
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:31:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 058F462D39
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EF1C433D2;
        Mon, 15 May 2023 17:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684171885;
        bh=ziGWq7lYZDz8xrvrrzfOBOWj1WGLcR1dPeLaxFHAZ/c=;
        h=From:To:Cc:Subject:Date:From;
        b=i9gtPTUf6vxD07+Lqm4iA/8lymkzBuDwjsPAP61aYLRK1GCSZPWms6ZH1QmWIKWfT
         qjXhUlKLqRNmybZqz7jS53x1D/Y3c73TBNiVudwH1B4upG7pE+JesChUa23S44wsw9
         ewKuenDExy3TIIPcZbk6aM73Arhm6Mokd8dmZL6v3govrJvauCQ3Fa7F9a35juIpY+
         ll76lUDdt9dfty14evmn3D2IOiuVAd7OqcIPn98aFDESfnZj54BO4ambwY4ETp/4PK
         jglawf+SieCh6TvJFfWxuo7BgpdU5gLuYpNedM66wNPQX/bcsuEPwKoaL2CJ7CSdYe
         vc2s77YcPjpKg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc2d-00FJAF-41;
        Mon, 15 May 2023 18:31:23 +0100
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
Subject: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
Date:   Mon, 15 May 2023 18:30:04 +0100
Message-Id: <20230515173103.1017669-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the 4th drop of NV support on arm64 for this year.

For the previous episodes, see [1].

What's changed:

- New framework to track system register traps that are reinjected in
  guest EL2. It is expected to replace the discrete handling we have
  enjoyed so far, which didn't scale at all. This has already fixed a
  number of bugs that were hidden (a bunch of traps were never
  forwarded...). Still a work in progress, but this is going in the
  right direction.

- Allow the L1 hypervisor to have a S2 that has an input larger than
  the L0 IPA space. This fixes a number of subtle issues, depending on
  how the initial guest was created.

- Consequently, the patch series has gone longer again. Boo. But
  hopefully some of it is easier to review...

[1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org

Andre Przywara (1):
  KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ

Christoffer Dall (5):
  KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
  KVM: arm64: nv: Implement nested Stage-2 page table walk logic
  KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
  KVM: arm64: nv: vgic: Emulate the HW bit in software
  KVM: arm64: nv: Sync nested timer state with FEAT_NV2

Jintack Lim (7):
  KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
  KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
  KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
  KVM: arm64: nv: Respect virtual HCR_EL2.{NV,TSC) settings
  KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
  KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
  KVM: arm64: nv: Nested GICv3 Support

Marc Zyngier (46):
  KVM: arm64: Move VTCR_EL2 into struct s2_mmu
  arm64: Add missing Set/Way CMO encodings
  arm64: Add missing VA CMO encodings
  arm64: Add missing ERXMISCx_EL1 encodings
  arm64: Add missing DC ZVA/GVA/GZVA encodings
  arm64: Add TLBI operation encodings
  arm64: Add AT operation encodings
  KVM: arm64: Add missing HCR_EL2 trap bits
  KVM: arm64: nv: Add trap forwarding infrastructure
  KVM: arm64: nv: Add trap forwarding for HCR_EL2
  KVM: arm64: nv: Expose FEAT_EVT to nested guests
  KVM: arm64: nv: Add trap forwarding for MDCR_EL2
  KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
  KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
  KVM: arm64: nv: Handle virtual EL2 registers in
    vcpu_read/write_sys_reg()
  KVM: arm64: nv: Handle SPSR_EL2 specially
  KVM: arm64: nv: Handle HCR_EL2.E2H specially
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
  KVM: arm64: nv: Handle shadow stage 2 page faults
  KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
  KVM: arm64: nv: Set a handler for the system instruction traps
  KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
  KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
  KVM: arm64: nv: Hide RAS from nested guests
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
  KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
  KVM: arm64: nv: Publish emulated timer interrupt state in the
    in-memory state
  KVM: arm64: nv: Allocate VNCR page when required
  KVM: arm64: nv: Enable ARMv8.4-NV support
  KVM: arm64: nv: Fast-track 'InHost' exception returns
  KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
  KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
  KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on

 .../virt/kvm/devices/arm-vgic-v3.rst          |  12 +-
 arch/arm64/include/asm/esr.h                  |   1 +
 arch/arm64/include/asm/kvm_arm.h              |  14 +
 arch/arm64/include/asm/kvm_asm.h              |   4 +
 arch/arm64/include/asm/kvm_emulate.h          |  93 +-
 arch/arm64/include/asm/kvm_host.h             | 181 +++-
 arch/arm64/include/asm/kvm_hyp.h              |   2 +
 arch/arm64/include/asm/kvm_mmu.h              |  20 +-
 arch/arm64/include/asm/kvm_nested.h           | 133 +++
 arch/arm64/include/asm/stage2_pgtable.h       |   4 +-
 arch/arm64/include/asm/sysreg.h               | 196 ++++
 arch/arm64/include/asm/vncr_mapping.h         |  74 ++
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kernel/cpufeature.c                |  11 +
 arch/arm64/kvm/Makefile                       |   4 +-
 arch/arm64/kvm/arch_timer.c                   |  98 +-
 arch/arm64/kvm/arm.c                          |  33 +-
 arch/arm64/kvm/at.c                           | 219 ++++
 arch/arm64/kvm/emulate-nested.c               | 934 ++++++++++++++++-
 arch/arm64/kvm/handle_exit.c                  |  29 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   8 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   5 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   2 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |   6 +-
 arch/arm64/kvm/hyp/vhe/switch.c               | 206 +++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            | 124 ++-
 arch/arm64/kvm/hyp/vhe/tlb.c                  |  83 ++
 arch/arm64/kvm/mmu.c                          | 255 ++++-
 arch/arm64/kvm/nested.c                       | 799 ++++++++++++++-
 arch/arm64/kvm/pkvm.c                         |   2 +-
 arch/arm64/kvm/reset.c                        |   7 +
 arch/arm64/kvm/sys_regs.c                     | 958 +++++++++++++++++-
 arch/arm64/kvm/trace_arm.h                    |  19 +
 arch/arm64/kvm/vgic/vgic-init.c               |  33 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  32 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          | 248 +++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |  43 +-
 arch/arm64/kvm/vgic/vgic.c                    |  29 +
 arch/arm64/kvm/vgic/vgic.h                    |  10 +
 arch/arm64/tools/cpucaps                      |   1 +
 include/clocksource/arm_arch_timer.h          |   4 +
 include/kvm/arm_arch_timer.h                  |   1 +
 include/kvm/arm_vgic.h                        |  17 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/arch/arm/include/uapi/asm/kvm.h         |   1 +
 49 files changed, 4790 insertions(+), 183 deletions(-)
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h
 create mode 100644 arch/arm64/kvm/at.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

-- 
2.34.1

