Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67AA119961E
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgCaMRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 08:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730380AbgCaMRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 08:17:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9188D20714;
        Tue, 31 Mar 2020 12:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585657029;
        bh=F2K4f2e4n0MRNDdO8Chjt10dQUBdb5AxXSgbnvLKozc=;
        h=From:To:Cc:Subject:Date:From;
        b=2AB5UCxbjIpn8b/N4rORh7uuvYIGKvWS/mL+/amkOrj5EW4b+l7tbZWMHdYl4npI1
         x47HjS4BedkoUT39IsIAUvK3hhwNIWftSCpfg9RtJ270NK1NsNqLNV4+QhUUUVUzSm
         Cp3vJZxfZoQDe6slQ21Fie/hAOQC9EjvcwCsQjC8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jJFpL-00HBlI-QV; Tue, 31 Mar 2020 13:17:07 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [GIT PULL] KVM/arm updates for Linux 5.7
Date:   Tue, 31 Mar 2020 13:16:30 +0100
Message-Id: <20200331121645.388250-1-maz@kernel.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@arm.com, eric.auger@redhat.com, karahmed@amazon.de, linus.walleij@linaro.org, olof@lixom.net, vladimir.murzin@arm.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's the main set of KVM/arm updates for Linux 5.7. Two items on the menu
this time:

- Support for GICv4.1, which allows for the direct injection of more
  interrupt classes than GICv4.0, and a much more sensible set of
  interactions with the hypervisor.

- Removal of the 32bit host support. It has been a fun ride, but with a
  general lack of interest as well as the 32bit Linux/ARM port being in "odd
  fixes" mode, there is little point in pretending that we care (100% of the
  activity is in the arm64 camp). This will, over time, result in cleaner
  code (less pointless abstractions) and be easier for arm64 to gain new
  features.

Please note that pulling from this tag will drag the GICv4.1 dependencies,
as they are part a shared branch between the irqchip and kvmarm trees. These
patches are already in Linus' tree as of this morning.

Please pull,

	M.

The following changes since commit 009384b38034111bf2c0c7bfb2740f5bd45c176c:

  irqchip/gic-v4.1: Eagerly vmap vPEs (2020-03-24 12:15:51 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvmarm-5.7

for you to fetch changes up to 463050599742a89e0508355e626e032e8d0dab8d:

  Merge tag 'kvm-arm-removal' into kvmarm-master/next (2020-03-24 17:43:53 +0000)

----------------------------------------------------------------
KVM/arm updates for Linux 5.7

- GICv4.1 support
- 32bit host removal

----------------------------------------------------------------
KarimAllah Ahmed (1):
      KVM: arm64: Use the correct timer structure to access the physical counter

Marc Zyngier (16):
      arm: Unplug KVM from the build system
      arm: Remove KVM from config files
      arm: Remove 32bit KVM host support
      arm: Remove HYP/Stage-2 page-table support
      arm: Remove GICv3 vgic compatibility macros
      arm: Remove the ability to set HYP vectors outside of the decompressor
      MAINTAINERS: RIP KVM/arm
      KVM: arm64: GICv4.1: Let doorbells be auto-enabled
      KVM: arm64: GICv4.1: Add direct injection capability to SGI registers
      KVM: arm64: GICv4.1: Allow SGIs to switch between HW and SW interrupts
      KVM: arm64: GICv4.1: Plumb SGI implementation selection in the distributor
      KVM: arm64: GICv4.1: Reload VLPI configuration on distributor enable/disable
      KVM: arm64: GICv4.1: Allow non-trapping WFI when using HW SGIs
      KVM: arm64: GICv4.1: Expose HW-based SGIs in debugfs
      Merge branch 'kvm-arm64/gic-v4.1' into kvmarm-master/next
      Merge tag 'kvm-arm-removal' into kvmarm-master/next

 Documentation/virt/kvm/arm/hyp-abi.rst |    5 +
 MAINTAINERS                            |    5 +-
 arch/arm/Kconfig                       |    2 -
 arch/arm/Makefile                      |    1 -
 arch/arm/configs/axm55xx_defconfig     |    2 -
 arch/arm/include/asm/arch_gicv3.h      |  114 ---
 arch/arm/include/asm/kvm_arm.h         |  239 ------
 arch/arm/include/asm/kvm_asm.h         |   77 --
 arch/arm/include/asm/kvm_coproc.h      |   36 -
 arch/arm/include/asm/kvm_emulate.h     |  372 --------
 arch/arm/include/asm/kvm_host.h        |  456 ----------
 arch/arm/include/asm/kvm_hyp.h         |  127 ---
 arch/arm/include/asm/kvm_mmu.h         |  435 ----------
 arch/arm/include/asm/kvm_ras.h         |   14 -
 arch/arm/include/asm/pgtable-3level.h  |   20 -
 arch/arm/include/asm/pgtable.h         |    9 -
 arch/arm/include/asm/sections.h        |    6 +-
 arch/arm/include/asm/stage2_pgtable.h  |   75 --
 arch/arm/include/asm/virt.h            |   17 -
 arch/arm/include/uapi/asm/kvm.h        |  314 -------
 arch/arm/kernel/asm-offsets.c          |   11 -
 arch/arm/kernel/hyp-stub.S             |   39 +-
 arch/arm/kernel/vmlinux-xip.lds.S      |    8 -
 arch/arm/kernel/vmlinux.lds.S          |    8 -
 arch/arm/kernel/vmlinux.lds.h          |   10 -
 arch/arm/kvm/Kconfig                   |   59 --
 arch/arm/kvm/Makefile                  |   43 -
 arch/arm/kvm/coproc.c                  | 1455 --------------------------------
 arch/arm/kvm/coproc.h                  |  130 ---
 arch/arm/kvm/coproc_a15.c              |   39 -
 arch/arm/kvm/coproc_a7.c               |   42 -
 arch/arm/kvm/emulate.c                 |  166 ----
 arch/arm/kvm/guest.c                   |  387 ---------
 arch/arm/kvm/handle_exit.c             |  175 ----
 arch/arm/kvm/hyp/Makefile              |   34 -
 arch/arm/kvm/hyp/banked-sr.c           |   70 --
 arch/arm/kvm/hyp/cp15-sr.c             |   72 --
 arch/arm/kvm/hyp/entry.S               |  121 ---
 arch/arm/kvm/hyp/hyp-entry.S           |  295 -------
 arch/arm/kvm/hyp/s2-setup.c            |   22 -
 arch/arm/kvm/hyp/switch.c              |  242 ------
 arch/arm/kvm/hyp/tlb.c                 |   68 --
 arch/arm/kvm/hyp/vfp.S                 |   57 --
 arch/arm/kvm/init.S                    |  157 ----
 arch/arm/kvm/interrupts.S              |   36 -
 arch/arm/kvm/irq.h                     |   16 -
 arch/arm/kvm/reset.c                   |   86 --
 arch/arm/kvm/trace.h                   |   86 --
 arch/arm/kvm/vgic-v3-coproc.c          |   27 -
 arch/arm/mach-exynos/Kconfig           |    2 +-
 arch/arm/mm/mmu.c                      |   26 -
 arch/arm64/include/asm/kvm_emulate.h   |    3 +-
 arch/arm64/include/asm/kvm_host.h      |    1 +
 include/kvm/arm_vgic.h                 |    3 +
 virt/kvm/arm/arch_timer.c              |    2 +-
 virt/kvm/arm/arm.c                     |    8 +
 virt/kvm/arm/vgic/vgic-debug.c         |   14 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c       |   81 +-
 virt/kvm/arm/vgic/vgic-mmio.c          |   88 +-
 virt/kvm/arm/vgic/vgic-v3.c            |    2 +
 virt/kvm/arm/vgic/vgic-v4.c            |  107 ++-
 virt/kvm/arm/vgic/vgic.h               |    1 +
 62 files changed, 311 insertions(+), 6314 deletions(-)
 delete mode 100644 arch/arm/include/asm/kvm_arm.h
 delete mode 100644 arch/arm/include/asm/kvm_asm.h
 delete mode 100644 arch/arm/include/asm/kvm_coproc.h
 delete mode 100644 arch/arm/include/asm/kvm_emulate.h
 delete mode 100644 arch/arm/include/asm/kvm_host.h
 delete mode 100644 arch/arm/include/asm/kvm_hyp.h
 delete mode 100644 arch/arm/include/asm/kvm_mmu.h
 delete mode 100644 arch/arm/include/asm/kvm_ras.h
 delete mode 100644 arch/arm/include/asm/stage2_pgtable.h
 delete mode 100644 arch/arm/include/uapi/asm/kvm.h
 delete mode 100644 arch/arm/kvm/Kconfig
 delete mode 100644 arch/arm/kvm/Makefile
 delete mode 100644 arch/arm/kvm/coproc.c
 delete mode 100644 arch/arm/kvm/coproc.h
 delete mode 100644 arch/arm/kvm/coproc_a15.c
 delete mode 100644 arch/arm/kvm/coproc_a7.c
 delete mode 100644 arch/arm/kvm/emulate.c
 delete mode 100644 arch/arm/kvm/guest.c
 delete mode 100644 arch/arm/kvm/handle_exit.c
 delete mode 100644 arch/arm/kvm/hyp/Makefile
 delete mode 100644 arch/arm/kvm/hyp/banked-sr.c
 delete mode 100644 arch/arm/kvm/hyp/cp15-sr.c
 delete mode 100644 arch/arm/kvm/hyp/entry.S
 delete mode 100644 arch/arm/kvm/hyp/hyp-entry.S
 delete mode 100644 arch/arm/kvm/hyp/s2-setup.c
 delete mode 100644 arch/arm/kvm/hyp/switch.c
 delete mode 100644 arch/arm/kvm/hyp/tlb.c
 delete mode 100644 arch/arm/kvm/hyp/vfp.S
 delete mode 100644 arch/arm/kvm/init.S
 delete mode 100644 arch/arm/kvm/interrupts.S
 delete mode 100644 arch/arm/kvm/irq.h
 delete mode 100644 arch/arm/kvm/reset.c
 delete mode 100644 arch/arm/kvm/trace.h
 delete mode 100644 arch/arm/kvm/vgic-v3-coproc.c
