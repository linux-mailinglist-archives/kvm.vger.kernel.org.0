Return-Path: <kvm+bounces-37493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24748A2ACF9
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:50:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D489E3A905F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE03B2451E5;
	Thu,  6 Feb 2025 15:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AE3Ya8vQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45BD1E5B9A;
	Thu,  6 Feb 2025 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738856982; cv=none; b=JmMI0cb/JsYyj/IVRoJxX/Kem5uquZqpc97F7mt+J14dvaSESjC5yNcpmJXyowFM3k1l2xwg85jfzG7rQ/w/F4FUOsjEc+7XvGCV1EoLYm4PKAcGNjS5VwFuomuldpm3Ycr1iNbjWnPpoX32n8/UpK259ID9keHXaH9c7oUcWQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738856982; c=relaxed/simple;
	bh=sEcaWTz1HzbI6p4xm1FOiu8u6g8i2Jl/cJgvVQbzt80=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a4syy3zShaw/ckT0bIxSLuJH7O3T3D6Lzm1e8BMFIVkbo3k6lmXiV+lr5WDt4EmrkJP/QG6xmUSvjrmT3RaidPhbp8BNXg4Fpus4VBxka+epTwiKa+97sm/q0UThfRmOP3rfUGPV+aYsPU3fGKo5yh+tQyG3A8onKxUYxnV8faQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AE3Ya8vQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9B4C4CEE3;
	Thu,  6 Feb 2025 15:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738856981;
	bh=sEcaWTz1HzbI6p4xm1FOiu8u6g8i2Jl/cJgvVQbzt80=;
	h=From:To:Cc:Subject:Date:From;
	b=AE3Ya8vQPrdhLDVKYr2mZ4DKLRn7CebXO5ghfD/NncwCZpql+pKD3RrCOxKP0VGHL
	 kiSzG/mrAdE+l9M+ZAZlAXxqezwpg27Z1p0TYJopH9UIvXkWfFQHdFiPYR8Bl8CDi4
	 4o/7tRtV7vyP/NLpP/BRX0eFXU6PWFaHaCcz4JmvNNG1RCEg7x0+H/oC0s4GnYVx0I
	 DHgTI1fQOMlu+j/qFxNajiwus8t7MEc+hQyN0sYAyUEGkwWy4NUA815Cmz+SfunonK
	 6wDz+7rfuwmqPUt/jHXvE+IZmxkpKyCYwKi1rku9nhZTjTLByRwRIrQ7M2abtTT0B7
	 Ok8XXLs1+x0sQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg48I-001BOX-Kz;
	Thu, 06 Feb 2025 15:49:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 00/16] KVM: arm64: Add NV GICv3 support
Date: Thu,  6 Feb 2025 15:49:09 +0000
Message-Id: <20250206154925.1109065-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Here's a respin of the NV support for GICv3. The integration branch
containing this (and the rest of the NV stack) is still at [3].

* From v2 [2]:

  - Picked RBs from Andre, with thanks

  - Rebased on 6.14-rc1

* From v1 [1]:

  - Fix the default value for the MI INTID to PPI9, instead of
    something fairly random...

  - Fail KVM initialisation if asking for NV on HW without a virtual
    GICv3.

[1] https://lore.kernel.org/r/20241217151331.934077-1-maz@kernel.org
[2] https://lore.kernel.org/r/20250112170845.1181891-1-maz@kernel.org
[3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-next

Andre Przywara (1):
  KVM: arm64: nv: Allow userland to set VGIC maintenance IRQ

Jintack Lim (1):
  KVM: arm64: nv: Respect virtual HCR_EL2.TWx setting

Marc Zyngier (13):
  arm64: sysreg: Add layout for ICH_HCR_EL2
  arm64: sysreg: Add layout for ICH_VTR_EL2
  arm64: sysreg: Add layout for ICH_MISR_EL2
  KVM: arm64: nv: Load timer before the GIC
  KVM: arm64: nv: Add ICH_*_EL2 registers to vpcu_sysreg
  KVM: arm64: nv: Plumb handling of GICv3 EL2 accesses
  KVM: arm64: nv: Sanitise ICH_HCR_EL2 accesses
  KVM: arm64: nv: Nested GICv3 emulation
  KVM: arm64: nv: Handle L2->L1 transition on interrupt injection
  KVM: arm64: nv: Add Maintenance Interrupt emulation
  KVM: arm64: nv: Propagate used_lrs between L1 and L0 contexts
  KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
  KVM: arm64: nv: Fail KVM init if asking for NV without GICv3

Oliver Upton (1):
  KVM: arm64: nv: Request vPE doorbell upon nested ERET to L2

 .../virt/kvm/devices/arm-vgic-v3.rst          |  12 +-
 arch/arm64/include/asm/kvm_emulate.h          |  13 +
 arch/arm64/include/asm/kvm_host.h             |  45 +-
 arch/arm64/include/asm/kvm_hyp.h              |   2 +
 arch/arm64/include/asm/sysreg.h               |  30 --
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |  20 +-
 arch/arm64/kvm/emulate-nested.c               |  18 +-
 arch/arm64/kvm/handle_exit.c                  |   6 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  16 +-
 arch/arm64/kvm/nested.c                       |  12 +
 arch/arm64/kvm/sys_regs.c                     |  95 +++-
 arch/arm64/kvm/vgic-sys-reg-v3.c              |   8 +-
 arch/arm64/kvm/vgic/vgic-init.c               |  29 ++
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  29 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          | 409 ++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |  44 +-
 arch/arm64/kvm/vgic/vgic-v4.c                 |  18 +-
 arch/arm64/kvm/vgic/vgic.c                    |  38 ++
 arch/arm64/kvm/vgic/vgic.h                    |   6 +
 arch/arm64/tools/sysreg                       |  48 ++
 drivers/irqchip/irq-apple-aic.c               |   8 +-
 include/kvm/arm_vgic.h                        |  10 +
 tools/arch/arm/include/uapi/asm/kvm.h         |   1 +
 tools/arch/arm64/include/asm/sysreg.h         |  30 --
 26 files changed, 833 insertions(+), 117 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

-- 
2.39.2


