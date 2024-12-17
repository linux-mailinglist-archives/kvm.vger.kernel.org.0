Return-Path: <kvm+bounces-33943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B589F4D89
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A092016AE12
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C401F5436;
	Tue, 17 Dec 2024 14:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6ti4CYA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55113398A;
	Tue, 17 Dec 2024 14:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445406; cv=none; b=ACybXAWebStetslo3CJp5hTnWL3tIjI/rLCgzFi8f753K+bVMWgrRcEWrl5B1LQCRLTh2DgX5F5A2mSRGKb6Kh9nNyR+G4KR1JBHgbVQTSJ3fvl7h1TgUtxdr32OoOStGu/PZacY4S6Mboa/Ew2DDC6Vy1kJKvMvPAcF4JPf7MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445406; c=relaxed/simple;
	bh=cqzDHLstDJY65pRGflLzfJn6LPL7Nl6rrznsIuKxP9c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YWAe7wV3UoA/IKHZ1Fv+9vFSdG3e4CfAGZ8NTwU7mVm/r914bOqZImLt348+YECecYA5e4yH2PUN1h/Wy3BTo5xPddh/HHycc736tjb/GmKwrndjxeYg1jFbsC9HhsqnlS+aNJ6iE+2ptohE7zPx2zdhHzH9hSF+1eEJQxamhoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N6ti4CYA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5870FC4CED3;
	Tue, 17 Dec 2024 14:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734445406;
	bh=cqzDHLstDJY65pRGflLzfJn6LPL7Nl6rrznsIuKxP9c=;
	h=From:To:Cc:Subject:Date:From;
	b=N6ti4CYATMYnZQXwVUJTFMXoD+FcXxODn4XcrSg14ZPqo1MqZM+fQht9zD3sM9t0T
	 EgJ1+txAmd4Nui2fI7cqneIcdHbqA+BReGaQ09BlcEf1EqhxmO306ccpHFfyA4n/6o
	 2wN03JhVbIDW7/rDKVngn1VnSBsh/cvY+ZatIesFbcj+KEUXBEv1t9dxThKiMEip4V
	 VPztgXxX+hQget0zuW+9Ho7xWcbo2VfCwUJexjbq+tqNphbDYHUlm3wzMsVoJhvzd6
	 Q5JYBU2TZP2EG8vTMeqX10AKwzAo0Cm4Hjh2HK2bCmAAuHvGyCaSZHHQnZfhvGlHxj
	 RqmLN1EkikBNw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNYTs-004aJx-92;
	Tue, 17 Dec 2024 14:23:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: [PATCH v2 00/12] KVM: arm64: Add NV timer support
Date: Tue, 17 Dec 2024 14:23:08 +0000
Message-Id: <20241217142321.763801-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, eauger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Here's another version of the series initially posted at [1], which
implements support for timers in NV context.

From v1:

- Repainted EL0->EL1 when rambling about the timers

- Simplified access to EL1 counters from HYP context

- Update the status register when handled as an early trap

- Added some documentation about the default PPI numbers

The whole thing has been tested with 6.13-rc3 as part of the my NV
integration branch [2], and is functional enough to run an L3 guest
with kvmtool as the VMM and EDK2 as the firmware. YMMV.

[1] https://lore.kernel.org/r/20241202172134.384923-1-maz@kernel.org
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-next

Marc Zyngier (12):
  KVM: arm64: nv: Add handling of EL2-specific timer registers
  KVM: arm64: nv: Sync nested timer state with FEAT_NV2
  KVM: arm64: nv: Publish emulated timer interrupt state in the
    in-memory state
  KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
  KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV in
    use
  KVM: arm64: nv: Accelerate EL0 counter accesses from hypervisor
    context
  KVM: arm64: Handle counter access early in non-HYP context
  KVM: arm64: nv: Add trap routing for
    CNTHCTL_EL2.EL1{NVPCT,NVVCT,TVT,TVCT}
  KVM: arm64: nv: Propagate CNTHCTL_EL2.EL1NV{P,V}CT bits
  KVM: arm64: nv: Sanitise CNTHCTL_EL2
  KVM: arm64: Work around x1e's CNTVOFF_EL2 bogosity
  KVM: arm64: nv: Document EL2 timer API

 Documentation/virt/kvm/devices/vcpu.rst |  15 +-
 arch/arm64/include/asm/cputype.h        |   2 +
 arch/arm64/include/asm/kvm_host.h       |   2 +-
 arch/arm64/include/asm/sysreg.h         |   4 +
 arch/arm64/kernel/cpu_errata.c          |   8 ++
 arch/arm64/kernel/image-vars.h          |   3 +
 arch/arm64/kvm/arch_timer.c             | 179 +++++++++++++++++++++---
 arch/arm64/kvm/arm.c                    |   3 +
 arch/arm64/kvm/emulate-nested.c         |  58 +++++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  39 ++++--
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      |  16 ++-
 arch/arm64/kvm/hyp/vhe/switch.c         | 107 ++++++++++++++
 arch/arm64/kvm/nested.c                 |  15 ++
 arch/arm64/kvm/sys_regs.c               | 146 ++++++++++++++++++-
 arch/arm64/tools/cpucaps                |   1 +
 include/clocksource/arm_arch_timer.h    |   6 +
 include/kvm/arm_arch_timer.h            |  23 +++
 17 files changed, 580 insertions(+), 47 deletions(-)

-- 
2.39.2


