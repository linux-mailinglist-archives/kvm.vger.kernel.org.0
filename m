Return-Path: <kvm+bounces-25162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 355A9961203
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:25:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3BC72820EC
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B996E1C9DC2;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPPcKj53"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE55A1C68BD;
	Tue, 27 Aug 2024 15:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772330; cv=none; b=J3/DtKNiKiSvKtsy7RlBj0KExQ206cV+cK2XBfTmJG6dYHFLp8FhlxVY7tKREkG7HjaUW7gHELZYuNiHv2H2cSjjibZPDp2W6OstMda0sNCT1+60YD6soyH0JZnvjqTHKQNosP3RznGYTpGN0A2GB7LWQ/munSFJqNLjDd84DlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772330; c=relaxed/simple;
	bh=c4iroNXWrqCbK3brxthl10TjLRTGDzGLQjuWGBMJdks=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DPtoJml3+F9sJXu6wY6lAgZ4wehfV6fWrgBWCnaROAnrfP7GIp/SK76WfXtmIs8RXcry7Ovn96k98iFCwueiCjcoof8L0JPg2fNSk0VXXU2OB82Rt77zqqEZdr7o0vjz5NObFYacL3wOi6Gii8EW1+AlGcce8wJNP2KClJm1Q5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPPcKj53; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20D2C6107C;
	Tue, 27 Aug 2024 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724772329;
	bh=c4iroNXWrqCbK3brxthl10TjLRTGDzGLQjuWGBMJdks=;
	h=From:To:Cc:Subject:Date:From;
	b=bPPcKj53eti0OzWLdfp3YFPYYpqaF53L79ZhIhlj6uaroKk8f8YE5KxscReXmMD56
	 lYOnVv7NnT6xD9MfUXihm41ezWpB3w4HrmrOnFFPhQr3rDcP0+KcwM+UXZVlNyfYOG
	 wAHTpfFs0d/U+d0HF4kLs76PXa3HoIfqDM9ytnDidu3sRjfKK82jJK+2rosJ/iNe21
	 iqr7JZFJ5C9l/GDmt426B2dpqB6U4CxJWG48tcRf/lTOenUsITvg59G6AeLsMyy4m+
	 36DTZ+D+f6cnTn09Rur3XdPMI3ZVXKWbDIykS/Pl7lNiOFjX9sea6mbcyGZnAdYQX1
	 uKie9zM7ZWL1A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1siy4V-007HOs-Cg;
	Tue, 27 Aug 2024 16:25:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 00/11] KVM: arm64: Handle the lack of GICv3 exposed to a guest
Date: Tue, 27 Aug 2024 16:25:06 +0100
Message-Id: <20240827152517.3909653-1-maz@kernel.org>
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

Patches on top of v6.11-rc5, tested on the usual lot of terrible HW:
Synquacer, TX1 and M1.

* From v1 [1]:

  - Drop the first patch of the series, as Oliver picked it up and
    ferried it into 6.11-rc5.

  - Fixed a number of comments involving GICv2

  - Rewrote kvm_has_gicv3() to look at the ID registers instead of the
    internal condition soup.

  - Hacked more of the selftest so that we check that even when
    ICC_SRE_EL1 doesn't trap, it is still RAO/WI.


[1] https://lore.kernel.org/r/20240820100349.3544850-1-maz@kernel.org

Marc Zyngier (11):
  KVM: arm64: Move GICv3 trap configuration to kvm_calculate_traps()
  KVM: arm64: Force SRE traps when SRE access is not enabled
  KVM: arm64: Force GICv3 trap activation when no irqchip is configured
    on VHE
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
 arch/arm64/kvm/arm.c                          |  14 +-
 arch/arm64/kvm/emulate-nested.c               |  71 +++++-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  97 ++++++-
 arch/arm64/kvm/nested.c                       |  15 +-
 arch/arm64/kvm/sys_regs.c                     | 240 ++++++++++--------
 arch/arm64/kvm/sys_regs.h                     |   9 +
 arch/arm64/kvm/vgic/vgic-v3.c                 |  12 +
 arch/arm64/kvm/vgic/vgic.c                    |  14 +-
 arch/arm64/kvm/vgic/vgic.h                    |   6 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/no-vgic-v3.c        | 175 +++++++++++++
 12 files changed, 521 insertions(+), 135 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c

-- 
2.39.2


