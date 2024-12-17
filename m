Return-Path: <kvm+bounces-33958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 618F89F4F11
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60C987A3B97
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14921F76BF;
	Tue, 17 Dec 2024 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pH1ZKaeU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EA01F7561;
	Tue, 17 Dec 2024 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734448445; cv=none; b=szYLQ8tNeLqg7VU6b+Hi3HZ4TTFptSlBGZVRleccXUKT1WuYGzyu3YllGC5FUZkiMa5PJD/8gKpTkTQpWGZsgHJlTRp7+7/x1kO4wqaiHBwswclAFpmhRDlcjJCK64ytmjGL8pgmKAQJibTCo8T3z/JDMgJqEkZdf5VUKD+/1pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734448445; c=relaxed/simple;
	bh=GlgUN4izxMEky7tzraNnnv/jpJYjLpUaIla9Xa9CfCY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=caJ44FIM/Hr4w9e67hU0eAB2HuTI2eXA0xjftVa0ORdyhB5c0HSQqmpikPA5zZwQhFjoNvtocTmdrqmrdc0/6dL4gGnbO3eh9QFQ3GqnaHHnimI011ldnJ3DOAA1YfcqZlkYhMB/3lr4Gt78T3St0+JH80+UvB9/4Su9CBkkErY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pH1ZKaeU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85822C4CED3;
	Tue, 17 Dec 2024 15:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734448444;
	bh=GlgUN4izxMEky7tzraNnnv/jpJYjLpUaIla9Xa9CfCY=;
	h=From:To:Cc:Subject:Date:From;
	b=pH1ZKaeUHV0XgCBkPG3x79QX0bgIRWkcZYCDBfqVdQk0ouMtb4eq+bgo9ItZxZBpW
	 Cd0JIrPBsVM5/kVT/F1lbjKtU9lCDKi4GbCfOr7EPGx6dggzuTNqF4tBjSFS4bY9P0
	 qp16qxE18aOu0vY8v18ygZuHawbjv7sh2SWqS2h/6WnFZhabhH8sDUfaI2g2d9uYYd
	 hyRG692otoYTmhGRPlSdEe/PFrp7o3pRGvdafW7JAAjUtcfAQwZdLnBaEwUL9rblg0
	 fiZ5o5+yzqCTmwNMQgiUkVreTroXW8/7V1iPR53Av2J5HWHRwhNjeIzSCx3KOdPqZ6
	 uUqVVYSrd8wRA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNZGs-004bWV-Cs;
	Tue, 17 Dec 2024 15:14:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eauger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH 00/16] KVM: arm64: Add NV GICv3 support
Date: Tue, 17 Dec 2024 15:13:15 +0000
Message-Id: <20241217151331.934077-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eauger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As a pendant to the timer code, here's the basic support for GICv3 for
NV.

Compared to the versions that have existed in the past, this is a
significant improvement, as the maintenance interrupt is finally
behaving correctly, and I have dropped the horrible hacks that only
gave the impression something was working.

The code is much simpler, isolated, and can even make some sense if
you have the correct pink-ish glasses.

As for the timer code, this has been tested as part of my integration
branch [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-next

Andre Przywara (1):
  KVM: arm64: nv: Allow userland to set VGIC maintenance IRQ

Jintack Lim (1):
  KVM: arm64: nv: Respect virtual HCR_EL2.TWx setting

Marc Zyngier (12):
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

Oliver Upton (2):
  KVM: arm64: Move host SVE/SME state flags out of vCPU
  KVM: arm64: nv: Request vPE doorbell upon nested ERET to L2

 .../virt/kvm/devices/arm-vgic-v3.rst          |  12 +-
 arch/arm64/include/asm/kvm_emulate.h          |  13 +
 arch/arm64/include/asm/kvm_host.h             |  71 ++-
 arch/arm64/include/asm/kvm_hyp.h              |   2 +
 arch/arm64/include/asm/sysreg.h               |  30 --
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |  13 +-
 arch/arm64/kvm/emulate-nested.c               |  18 +-
 arch/arm64/kvm/fpsimd.c                       |  12 +-
 arch/arm64/kvm/handle_exit.c                  |   6 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  16 +-
 arch/arm64/kvm/nested.c                       |  12 +
 arch/arm64/kvm/sys_regs.c                     |  95 +++-
 arch/arm64/kvm/vgic-sys-reg-v3.c              |   8 +-
 arch/arm64/kvm/vgic/vgic-init.c               |  22 +
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
 27 files changed, 841 insertions(+), 133 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

-- 
2.39.2


