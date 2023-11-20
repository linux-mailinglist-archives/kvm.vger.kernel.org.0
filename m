Return-Path: <kvm+bounces-2071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3E57F13F3
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB26C1C216AC
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEDDC1B27D;
	Mon, 20 Nov 2023 13:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MRyaX1Ve"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD14919471;
	Mon, 20 Nov 2023 13:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0708AC433C8;
	Mon, 20 Nov 2023 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485851;
	bh=pUlvWG8M+SDFFekGUUNwGmvmaHh6AlEO/Ns2Nv06A+8=;
	h=From:To:Cc:Subject:Date:From;
	b=MRyaX1Ve/0g33CQZjPv2j6YAzlgjXzLJYjGUCzE1Q1Peo2IlOtp/DBi261sVBnEYh
	 w1iMjx1gAQBBATzNFxe429GgVTmo1AqcaU3Oufm8KbpbOLKX/OzhLuiSAyaUlAhGb/
	 oCx6cZAFOP162rS6v3F9Pu8Z2cS+JiDm2r80J6UhMmOA6aokjBLVd2qONOYLG6yy62
	 yd0k9L2aaFMO4ptWFTRTIOr5nJkgA7eZi5U3eOskGljWhL3UUQkGVd8nTPu4PqGNJI
	 24P9M4LQW8mHLckjPjNmHpRQz0isHMECcFxXDdYTVnAIKp3N9E4WgxNWi7WUByKJJh
	 gZnWAX5jvK4Qg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r5436-00EjnU-UB;
	Mon, 20 Nov 2023 13:10:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
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
Subject: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support (FEAT_NV2 only)
Date: Mon, 20 Nov 2023 13:09:44 +0000
Message-Id: <20231120131027.854038-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the 5th drop of NV support on arm64 for this year, and most
probably the last one for this side of Christmas.

For the previous episodes, see [1].

What's changed:

- Drop support for the original FEAT_NV. No existing hardware supports
  it without FEAT_NV2, and the architecture is deprecating the former
  entirely. This results in fewer patches, and a slightly simpler
  model overall.

- Reorganise the series to make it a bit more logical now that FEAT_NV
  is gone.

- Apply the NV idreg restrictions on VM first run rather than on each
  access.

- Make the nested vgic shadow CPU interface a per-CPU structure rather
  than per-vcpu.

- Fix the EL0 timer fastpath

- Work around the architecture deficiencies when trapping WFI from a
  L2 guest.

- Fix sampling of nested vgic state (MISR, ELRSR, EISR)

- Drop the patches that have already been merged (NV trap forwarding,
  per-MMU VTCR)

- Rebased on top of 6.7-rc2 + the FEAT_E2H0 support [2].

The branch containing these patches (and more) is at [3]. As for the
previous rounds, my intention is to take a prefix of this series into
6.8, provided that it gets enough reviewing.

[1] https://lore.kernel.org/r/20230515173103.1017669-1-maz@kernel.org
[2] https://lore.kernel.org/r/20231120123721.851738-1-maz@kernel.org
[3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.8-nv2-only

Andre Przywara (1):
  KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ

Christoffer Dall (2):
  KVM: arm64: nv: Implement nested Stage-2 page table walk logic
  KVM: arm64: nv: Unmap/flush shadow stage 2 page tables

Jintack Lim (3):
  KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
  KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
  KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2

Marc Zyngier (37):
  arm64: cpufeatures: Restrict NV support to FEAT_NV2
  KVM: arm64: nv: Hoist vcpu_has_nv() into is_hyp_ctxt()
  KVM: arm64: nv: Compute NV view of idregs as a one-off
  KVM: arm64: nv: Drop EL12 register traps that are redirected to VNCR
  KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
  KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
  KVM: arm64: Introduce a bad_trap() primitive for unexpected trap
    handling
  KVM: arm64: nv: Add EL2_REG_VNCR()/EL2_REG_REDIR() sysreg helpers
  KVM: arm64: nv: Map VNCR-capable registers to a separate page
  KVM: arm64: nv: Handle virtual EL2 registers in
    vcpu_read/write_sys_reg()
  KVM: arm64: nv: Handle HCR_EL2.E2H specially
  KVM: arm64: nv: Handle CNTHCTL_EL2 specially
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
  KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
  KVM: arm64: nv: Handle shadow stage 2 page faults
  KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
  KVM: arm64: nv: Set a handler for the system instruction traps
  KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
  KVM: arm64: nv: Hide RAS from nested guests
  KVM: arm64: nv: Add handling of EL2-specific timer registers
  KVM: arm64: nv: Sync nested timer state with FEAT_NV2
  KVM: arm64: nv: Publish emulated timer interrupt state in the
    in-memory state
  KVM: arm64: nv: Load timer before the GIC
  KVM: arm64: nv: Nested GICv3 Support
  KVM: arm64: nv: Don't block in WFI from nested state
  KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
  KVM: arm64: nv: Deal with broken VGIC on maintenance interrupt
    delivery
  KVM: arm64: nv: Add handling of FEAT_TTL TLB invalidation
  KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like
    information
  KVM: arm64: nv: Tag shadow S2 entries with nested level
  KVM: arm64: nv: Allocate VNCR page when required
  KVM: arm64: nv: Fast-track 'InHost' exception returns
  KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
  KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
  KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on
  KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT

 .../virt/kvm/devices/arm-vgic-v3.rst          |  12 +-
 arch/arm64/include/asm/esr.h                  |   1 +
 arch/arm64/include/asm/kvm_arm.h              |   3 +
 arch/arm64/include/asm/kvm_asm.h              |   4 +
 arch/arm64/include/asm/kvm_emulate.h          |  53 +-
 arch/arm64/include/asm/kvm_host.h             | 223 +++-
 arch/arm64/include/asm/kvm_hyp.h              |   2 +
 arch/arm64/include/asm/kvm_mmu.h              |  12 +
 arch/arm64/include/asm/kvm_nested.h           | 130 ++-
 arch/arm64/include/asm/sysreg.h               |   7 +
 arch/arm64/include/asm/vncr_mapping.h         | 102 ++
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kernel/cpufeature.c                |  22 +-
 arch/arm64/kvm/Makefile                       |   4 +-
 arch/arm64/kvm/arch_timer.c                   | 115 +-
 arch/arm64/kvm/arm.c                          |  46 +-
 arch/arm64/kvm/at.c                           | 219 ++++
 arch/arm64/kvm/emulate-nested.c               |  48 +-
 arch/arm64/kvm/handle_exit.c                  |  29 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   8 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   5 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   2 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |   2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |   6 +-
 arch/arm64/kvm/hyp/vhe/switch.c               | 211 +++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            | 133 ++-
 arch/arm64/kvm/hyp/vhe/tlb.c                  |  83 ++
 arch/arm64/kvm/mmu.c                          | 248 ++++-
 arch/arm64/kvm/nested.c                       | 813 ++++++++++++++-
 arch/arm64/kvm/reset.c                        |   7 +
 arch/arm64/kvm/sys_regs.c                     | 978 ++++++++++++++++--
 arch/arm64/kvm/vgic/vgic-init.c               |  35 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  29 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          | 270 +++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |  35 +-
 arch/arm64/kvm/vgic/vgic.c                    |  29 +
 arch/arm64/kvm/vgic/vgic.h                    |  10 +
 arch/arm64/tools/cpucaps                      |   2 +
 include/clocksource/arm_arch_timer.h          |   4 +
 include/kvm/arm_arch_timer.h                  |  19 +
 include/kvm/arm_vgic.h                        |  16 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/arch/arm/include/uapi/asm/kvm.h         |   1 +
 43 files changed, 3725 insertions(+), 255 deletions(-)
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h
 create mode 100644 arch/arm64/kvm/at.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

-- 
2.39.2


