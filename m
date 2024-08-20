Return-Path: <kvm+bounces-24589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9EB958391
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FFD31C23EDE
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B91D18CBED;
	Tue, 20 Aug 2024 10:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jked5c9Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A1318E37C;
	Tue, 20 Aug 2024 10:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148371; cv=none; b=sgk4LzMXXXlwjy+he3SS2NtD2SAR7Li/Vv2mGubVdiu0uBxlOUGqlzxpv1V78qKJUOJmrDEW2q3lHeP+zaTdr2sTAU0d3bciWzVhQJCYohTJoZMhIhXcQdRGXIAoEjuNFJHCYe7tutfCSEq8QMo6IKeurv9zCZmKsQitMXrNMYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148371; c=relaxed/simple;
	bh=t6UjUCrk7iYKNeT1/6lJ/Hw6tKG7Wt94gouQstR7+5Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZIwtNwhu0zWB2mnwMmu/l5A9OamNYxvf98qVle9E3QneD3/ayFob70BqhpTeFdeVswdDQ3y2+GmSYG3UBAafSVpm7r7ZjksuDR+3AQNXMzckHE/VVjOLqwT8/KdtKS+r/BFJIv4rX7nUGtPNaRZNSfmpENGCKbZG5FqRn9ZXoBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jked5c9Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E95CC4AF10;
	Tue, 20 Aug 2024 10:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148371;
	bh=t6UjUCrk7iYKNeT1/6lJ/Hw6tKG7Wt94gouQstR7+5Y=;
	h=From:To:Cc:Subject:Date:From;
	b=Jked5c9YXbRbDBn8D4vQzWbHx1b81PIpjBvFmOKaSV3M7jbR6/i+CmFu6yonxLwS2
	 LAYapBtVU4rvwFPixF3cTDP0LP1Im7xJ4B79Uwrak8XX4fQ6AWatgTW0Ow4jbQ/D3M
	 h3EZGatbQbPINLkzGVKkWwrcfvwd4bnBpIqcLNZ2xMNMptVbII1EuAFYX0ucqKEYn8
	 1Rb4AXEQeuSQiNHCx13eFnz5+WnA+hpGTTQgnUUYN942k/l4Qvi2eWpHkCRnI8NpqR
	 SFysrdBeCkw28PIt5HQjIO1ZnCMFMVh5QVxBeEbjR3lz/ZMoT8MsKp2PI6wW40fdNb
	 7aj0Ybr/xsACQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLil-005Dk2-Oc;
	Tue, 20 Aug 2024 11:06:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 00/12] KVM: arm64: Handle the lack of GICv3 exposed to a guest
Date: Tue, 20 Aug 2024 11:03:37 +0100
Message-Id: <20240820100349.3544850-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It recently appeared that, when running on a GICv3-equipped platform
(which is what non-ancient arm64 HW has), *not* configuring a GICv3
for the guest could result in less than desirable outcomes.

We have multiple issues to fix:

- for registers that *always* trap (the SGI registers) or that *may*
  trap (the SRE register), we need to check whether a GICv3 has been
  instantiated before acting upon the trap.

- for registers that only conditionally trap, we must actively trap
  them even in the absence of a GICv3 being instantiated, and handle
  those traps accordingly.

- finally, ID registers must reflect the absence of a GICv3, so that
  we are consistent.

This series goes through all these requirements. The main complexity
here is to apply a GICv3 configuration on the host in the absence of a
GICv3 in the guest. This is pretty hackish, but I don't have a much
better solution so far.

As part of making wider use of of the trap bits, we fully define the
trap routing as per the architecture, something that we eventually
need for NV anyway.

Note that patch #1 is a candidate for immediate merge in 6.11 as a
fix, to be backported to all stable versions. We can live without the
rest.

Finally, I have added two additional changes:

- a file-wide cleanup of sys_regs.c, unifying the way we inject an
  UNDEF from the trap handling array

- a selftest that checks for the implemented trapping behaviour (yes,
  I actually wrote a test -- hated every minute of it).

Note that the effects of this series when a GICv2 is configured on a
GICv3 host capable of emulation are imperfect: For some of the
registers, the guest may take a system register trap at EL1 (EC=0x18),
and there is nothing that KVM can do about it (this is a consequence
of ICC_SRE_EL1.SRE being 0, which GICv2 requires). But at least that's
a guest problem, not the host's.

PAtches on top of v6.11-rc4, tested on the usual lot of terrible HW:
Synquacer, TX1 and M1.

Marc Zyngier (12):
  KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
  KVM: arm64: Move GICv3 trap configuration to kvm_calculate_traps()
  KVM: arm64: Force SRE traps when SRE access is not enabled
  KVM: arm64: Force GICv3 traps activa when no irqchip is configured on
    VHE
  KVM: arm64: Add helper for last ditch idreg adjustments
  KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the
    guest
  KVM: arm64: Add ICH_HCR_EL2 to the vcpu state
  KVM: arm64: Add trap routing information for ICH_HCR_EL2
  KVM: arm64: Honor guest requested traps in GICv3 emulation
  KVM: arm64: Make most GICv3 accesses UNDEF if they trap
  KVM: arm64: Unify UNDEF injection helpers
  KVM: arm64: Add selftest checking how the absence of GICv3 is handled

 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/kvm/arm.c                          |  10 +-
 arch/arm64/kvm/emulate-nested.c               |  77 +++++-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  97 ++++++-
 arch/arm64/kvm/nested.c                       |  15 +-
 arch/arm64/kvm/sys_regs.c                     | 236 +++++++++++-------
 arch/arm64/kvm/sys_regs.h                     |   9 +
 arch/arm64/kvm/vgic/vgic-v3.c                 |  12 +
 arch/arm64/kvm/vgic/vgic.c                    |  14 +-
 arch/arm64/kvm/vgic/vgic.h                    |   9 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/no-vgic-v3.c        | 170 +++++++++++++
 12 files changed, 526 insertions(+), 126 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c

-- 
2.39.2


