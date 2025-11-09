Return-Path: <kvm+bounces-62425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E6DC443B6
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:16:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4FE904E8014
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DAB306492;
	Sun,  9 Nov 2025 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFhLtFYG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACD03043A2;
	Sun,  9 Nov 2025 17:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708590; cv=none; b=J/6m/lsK9SaXaLuhcz59HkTizYyUS5+kYCZ2fEv626i+1RStMSobQhvP6g8xvVr5vLZug6IJEyvBeGBu9Xa5rMHH2vwh8limXS90+dX15IHm/ygqsCHToSb1Sl2ExSDd+13657xJ+gDODk3iLfEwjoMt8RafgLjkjufXUcM9E4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708590; c=relaxed/simple;
	bh=LU5ZFdx4EUgvb0p/xCvsj9L4R5ggGs+NLiMz5m9HfUc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qQiWzg9qOikP1U4n/Gf1qfa+jdS7pev2uOKg0AowiVY5pk0Dfc+UoOcSGrDULFVOVVbTFyF4rBJZWDTpVgYN4N1/qC8Tlel1vNjQXO8i12lTzCnJkKfEgNAKuHAg7ORRvos4Zgzci6IOMSoGVIDl3SxWJ5V6TAk1rQ8ZHXr9p3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFhLtFYG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D55C4CEF7;
	Sun,  9 Nov 2025 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708590;
	bh=LU5ZFdx4EUgvb0p/xCvsj9L4R5ggGs+NLiMz5m9HfUc=;
	h=From:To:Cc:Subject:Date:From;
	b=sFhLtFYG3Z+0+DBLaN0LKpKwk6ur3WVl9zuRVWr+46ey1p8gnSk5u84BNs3sDaDIE
	 xdxfHpDB6jXpaFnestxrxmSbo2SH6uT0tb39tuZ/bqdinwzFXQezUHtMcnkuIBrsJG
	 sBRNdRp8+1bfyr/uS5NkAICDk/7HrUhatH/4LUS791pDgy4X5N6+vSELUJOt3xqHLL
	 ppFpYzfLxGH7bM7u9xwpxv/FENRGsy5LoTRk5f8tVl54DyXNYGZvdWaYdaZapLZnqH
	 7KY/1aX8n3+lfVefc4tTGgb73zfXyfq+x76oXQoA6LQ1Lt0y6neYjIRroarqRGNKbZ
	 E7RqSzBrRLYSA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91f-00000003exw-3VIj;
	Sun, 09 Nov 2025 17:16:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 00/45] KVM: arm64: Add LR overflow infrastructure
Date: Sun,  9 Nov 2025 17:15:34 +0000
Message-ID: <20251109171619.1507205-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the 2nd version of the series originally posted at [1]. The
series has significantly evolved with a bunch of bug fixes, some
additional optimisations, and a number of test cases.

This has now been extensively tested on much of what I have access to,
specially on some of the most broken stuff (Apple, Qualcomm, Cavium,
ARMv8.0 CPUs without TDIR), but also on some less shitty systems
(which are the minority, unsurprisingly).

Given that this is fixing some really ugly vgic bugs, I'm aiming this
at 6.19, though these bugs being 10 year old, any form of urgency is
very questionable.

Patches still against -rc4.

* From v1 [1]:

  - Fixed the ICH_HCR_EL2.TDIR detection code to include the Apple
    stuff, and to deal with GICv5's legacy mode

  - Fixed compilation issue for old toolchains that don't understand
    the GICv3 sysreg names

  - Allow GICv3 in-LR deactivation even when DIR trapping is enabled

  - Dropped the split overflow list, once I convinced myself it wasn't
    bringing much to the table

  - Turned kvm_vgic_vcpu_enable() into a vgic reset helper

  - Remove IPI-ing on GICv3 systems without TDIR

  - Fixed the out-of-LR deactivation when dealing with asymmetric SPI
    deactivation

  - Fixed broken MMIO offset computation

  - Added group enable to the GIC selftest library

  - Added fixes and improvements to the vgic_irq selftest:

    - Fixed definition of spurious interrupt

    - Fixed config/enable ordering

    - Prevent timer interrupts from being injected from userspace

    - Removed limit of 4 interrupts being injected at any given time

    - Added an asymmetric SPI deactivation test case

    - Added a Group-0 enable test case

    - Added a timer interrupt + SPI interrupt test case

  - Fixed a couple of spelling mistakes (and added many more, I'm sure)

  - Reordered the series slightly

[1] https://lore.kernel.org/r/20251103165517.2960148-1-maz@kernel.org

Marc Zyngier (45):
  irqchip/gic: Add missing GICH_HCR control bits
  irqchip/gic: Expose CPU interface VA to KVM
  irqchip/apple-aic: Spit out ICH_MISR_EL2 value on spurious vGIC MI
  KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant
  KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1
    trapping
  KVM: arm64: Repack struct vgic_irq fields
  KVM: arm64: Add tracking of vgic_irq being present in a LR
  KVM: arm64: Add LR overflow handling documentation
  KVM: arm64: GICv3: Drop LPI active state when folding LRs
  KVM: arm64: GICv3: Preserve EOIcount on exit
  KVM: arm64: GICv3: Decouple ICH_HCR_EL2 programming from LRs
  KVM: arm64: GICv3: Extract LR folding primitive
  KVM: arm64: GICv3: Extract LR computing primitive
  KVM: arm64: GICv2: Preserve EOIcount on exit
  KVM: arm64: GICv2: Decouple GICH_HCR programming from LRs being loaded
  KVM: arm64: GICv2: Extract LR folding primitive
  KVM: arm64: GICv2: Extract LR computing primitive
  KVM: arm64: Compute vgic state irrespective of the number of
    interrupts
  KVM: arm64: Eagerly save VMCR on exit
  KVM: arm64: Revamp vgic maintenance interrupt configuration
  KVM: arm64: Turn kvm_vgic_vcpu_enable() into kvm_vgic_vcpu_reset()
  KVM: arm64: Make vgic_target_oracle() globally available
  KVM: arm64: Invert ap_list sorting to push active interrupts out
  KVM: arm64: Move undeliverable interrupts to the end of ap_list
  KVM: arm64: Use MI to detect groups being enabled/disabled
  KVM: arm64: GICv3: Handle LR overflow when EOImode==0
  KVM: arm64: GICv3: Handle deactivation via ICV_DIR_EL1 traps
  KVM: arm64: GICv3: Add GICv2 SGI handling to deactivation primitive
  KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when interrupts overflow LR
    capacity
  KVM: arm64: GICv3: Add SPI tracking to handle asymmetric deactivation
  KVM: arm64: GICv3: Handle in-LR deactivation when possible
  KVM: arm64: GICv3: Avoid broadcast kick on CPUs lacking TDIR
  KVM: arm64: GICv2: Handle LR overflow when EOImode==0
  KVM: arm64: GICv2: Handle deactivation via GICV_DIR traps
  KVM: arm64: GICv2: Always trap GICV_DIR register
  KVM: arm64: selftests: gic_v3: Add irq group setting helper
  KVM: arm64: selftests: gic_v3: Disable Group-0 interrupts by default
  KVM: arm64: selftests: vgic_irq: Fix GUEST_ASSERT_IAR_EMPTY() helper
  KVM: arm64: selftests: vgic_irq: Change configuration before enabling
    interrupt
  KVM: arm64: selftests: vgic_irq: Exclude timer-controlled interrupts
  KVM: arm64: selftests: vgic_irq: Remove LR-bound limitation
  KVM: arm64: selftests: vgic_irq: Perform EOImode==1 deactivation in
    ack order
  KVM: arm64: selftests: vgic_irq: Add asymmetric SPI deaectivation test
  KVM: arm64: selftests: vgic_irq: Add Group-0 enable test
  KVM: arm64: selftests: vgic_irq: Add timer deactivation test

 arch/arm64/include/asm/kvm_asm.h              |   2 +-
 arch/arm64/include/asm/kvm_host.h             |   1 +
 arch/arm64/include/asm/kvm_hyp.h              |   2 +-
 arch/arm64/include/asm/virt.h                 |   7 +-
 arch/arm64/kernel/cpufeature.c                |  52 +++
 arch/arm64/kernel/hyp-stub.S                  |   5 +
 arch/arm64/kernel/image-vars.h                |   1 +
 arch/arm64/kvm/arm.c                          |   7 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   7 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c      |   4 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  87 ++--
 arch/arm64/kvm/sys_regs.c                     |  19 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   9 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c            |  24 +
 arch/arm64/kvm/vgic/vgic-mmio.h               |   1 +
 arch/arm64/kvm/vgic/vgic-v2.c                 | 291 +++++++++---
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |  11 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 | 421 ++++++++++++++----
 arch/arm64/kvm/vgic/vgic-v4.c                 |   5 +-
 arch/arm64/kvm/vgic/vgic.c                    | 294 +++++++-----
 arch/arm64/kvm/vgic/vgic.h                    |  42 +-
 arch/arm64/tools/cpucaps                      |   1 +
 drivers/irqchip/irq-apple-aic.c               |   7 +-
 drivers/irqchip/irq-gic.c                     |   3 +
 include/kvm/arm_vgic.h                        |  29 +-
 include/linux/irqchip/arm-gic.h               |   6 +
 include/linux/irqchip/arm-vgic-info.h         |   2 +
 tools/testing/selftests/kvm/arm64/vgic_irq.c  | 285 +++++++++++-
 .../testing/selftests/kvm/include/arm64/gic.h |   1 +
 tools/testing/selftests/kvm/lib/arm64/gic.c   |   6 +
 .../selftests/kvm/lib/arm64/gic_private.h     |   1 +
 .../testing/selftests/kvm/lib/arm64/gic_v3.c  |  17 +
 32 files changed, 1276 insertions(+), 374 deletions(-)

-- 
2.47.3


