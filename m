Return-Path: <kvm+bounces-62388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 000DAC42C7C
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 13:06:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A14F2188D0AB
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 12:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF5F2FF143;
	Sat,  8 Nov 2025 12:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpOULasz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6231F222560;
	Sat,  8 Nov 2025 12:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762603565; cv=none; b=CnoYkv4m+nRxoOlJrnKi1yDi6EqbRIPRl+yLLoy2OAQcaLMV5C1sspkoQFqhZ6g0HfkG4/R6RoEazZbUIsElc8P/B8qIBUqSRwgNCqNuYSCrxpfXEIx+TqTV19VA9Dcd8HAFUA/rzS/E7gwQBxrH1BiRWHBJubr7lxreFn6dE1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762603565; c=relaxed/simple;
	bh=BqxvbyHZr/XGWKF/eN0lTVeCKAfJuLLL6a2EREHic88=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u5PeWAHB97jKFpJblO1kkMmNIzcIHoxg9azfcpxhSgKHYL+w8rRNhuA4b4Ttp3/JbLrBNQ5NEj8jGGrg7h28A3Yc9GxTZOOPVUeNY09X57PyO1Lf4DC4RklAJfXTQg6yI1utSWQ1fm21SWqnJObkh3xDd+vy5AwfHQvIqcMUMn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpOULasz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0158C16AAE;
	Sat,  8 Nov 2025 12:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762603564;
	bh=BqxvbyHZr/XGWKF/eN0lTVeCKAfJuLLL6a2EREHic88=;
	h=From:To:Cc:Subject:Date:From;
	b=gpOULaszBBOdYMiNvXpJkrW80awPsF2l2D99okxCG+rj9Iok75GMS3Wgvm8ezpukH
	 wak9qG2xuH3B8n64DDScG/UzTLXR+Ny89QNwauRHmXYmX6bVuCqrd6KuJ3gO7GIS7p
	 Hgsxd4tQPgjyNXb22rkEqz83rshYnjKNt0+3p7V3bkWiE6rsrOPojLNM8lVmr3ajhJ
	 3SOmjoBPMoIjg+SjP8YcWJP3Y03c9OvRsdNlUJ/6KHUWMBwVI7l2TcnA1tUHoTUcHK
	 /u31rPctV8AP4VaP92NWfUi300N7IhyR6T9mzOKb+ei9SDirUAGhBV21oa8EQ4rTZT
	 O+xHBiVXlGzJQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vHhhi-00000003Tka-3aFc;
	Sat, 08 Nov 2025 12:06:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Brown <broonie@kernel.org>,
	Maximilian Dittgen <mdittgen@amazon.de>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Sebastian Ott <sebott@redhat.com>,
	stable@vger.kernel.org,
	Vincent Donnefort <vdonnefort@google.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.18, take #2
Date: Sat,  8 Nov 2025 12:05:59 +0000
Message-ID: <20251108120559.1201561-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, broonie@kernel.org, mdittgen@amazon.de, oupton@kernel.org, peter.maydell@linaro.org, sascha.bischoff@arm.com, sebastianene@google.com, sebott@redhat.com, stable@vger.kernel.org, vdonnefort@google.com, will@kernel.org, yuzenghui@huawei.com, joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Much later than expected, but here's the second set of fixes KVM/arm64
for 6.18. The core changes are mostly fixes for a bunch of recent
regressions, plus a couple that address the way pKVM deals with
untrusted data. The rest address a couple of selftests, and Oliver's
new email address.

Please pull,

	M.

The following changes since commit ca88ecdce5f51874a7c151809bd2c936ee0d3805:

  arm64: Revamp HCR_EL2.E2H RES1 detection (2025-10-14 08:18:40 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.18-2

for you to fetch changes up to 4af235bf645516481a82227d82d1352b9788903a:

  MAINTAINERS: Switch myself to using kernel.org address (2025-11-08 11:21:20 +0000)

----------------------------------------------------------------
KVM/arm654 fixes for 6.18, take #2

* Core fixes

  - Fix trapping regression when no in-kernel irqchip is present
    (20251021094358.1963807-1-sascha.bischoff@arm.com)

  - Check host-provided, untrusted ranges and offsets in pKVM
    (20251016164541.3771235-1-vdonnefort@google.com)
    (20251017075710.2605118-1-sebastianene@google.com)

  - Fix regression restoring the ID_PFR1_EL1 register
    (20251030122707.2033690-1-maz@kernel.org

  - Fix vgic ITS locking issues when LPIs are not directly injected
    (20251107184847.1784820-1-oupton@kernel.org)

* Test fixes

  - Correct target CPU programming in vgic_lpi_stress selftest
    (20251020145946.48288-1-mdittgen@amazon.de)

  - Fix exposure of SCTLR2_EL2 and ZCR_EL2 in get-reg-list selftest
    (20251023-b4-kvm-arm64-get-reg-list-sctlr-el2-v1-1-088f88ff992a@kernel.org)
    (20251024-kvm-arm64-get-reg-list-zcr-el2-v1-1-0cd0ff75e22f@kernel.org)

* Misc

  - Update Oliver's email address
    (20251107012830.1708225-1-oupton@kernel.org)

----------------------------------------------------------------
Marc Zyngier (3):
      KVM: arm64: Make all 32bit ID registers fully writable
      KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured
      KVM: arm64: Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace irqchip

Mark Brown (2):
      KVM: arm64: selftests: Add SCTLR2_EL2 to get-reg-list
      KVM: arm64: selftests: Filter ZCR_EL2 in get-reg-list

Maximilian Dittgen (1):
      KVM: selftests: fix MAPC RDbase target formatting in vgic_lpi_stress

Oliver Upton (3):
      KVM: arm64: vgic-v3: Reinstate IRQ lock ordering for LPI xarray
      KVM: arm64: vgic-v3: Release reserved slot outside of lpi_xa's lock
      MAINTAINERS: Switch myself to using kernel.org address

Sascha Bischoff (1):
      KVM: arm64: vgic-v3: Trap all if no in-kernel irqchip

Sebastian Ene (1):
      KVM: arm64: Check the untrusted offset in FF-A memory share

Vincent Donnefort (1):
      KVM: arm64: Check range args for pKVM mem transitions

 .mailmap                                           |  3 +-
 MAINTAINERS                                        |  2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |  9 ++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              | 28 +++++++++
 arch/arm64/kvm/sys_regs.c                          | 71 ++++++++++++----------
 arch/arm64/kvm/vgic/vgic-debug.c                   | 16 +++--
 arch/arm64/kvm/vgic/vgic-init.c                    | 16 ++++-
 arch/arm64/kvm/vgic/vgic-its.c                     | 18 +++---
 arch/arm64/kvm/vgic/vgic-v3.c                      |  3 +-
 arch/arm64/kvm/vgic/vgic.c                         | 23 ++++---
 tools/testing/selftests/kvm/arm64/get-reg-list.c   |  3 +
 tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c |  9 ++-
 12 files changed, 137 insertions(+), 64 deletions(-)

