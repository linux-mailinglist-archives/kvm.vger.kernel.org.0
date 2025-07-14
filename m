Return-Path: <kvm+bounces-52320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C06B03E92
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BABA17E073
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14281248F47;
	Mon, 14 Jul 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YV8VUAEE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327F224729A;
	Mon, 14 Jul 2025 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496004; cv=none; b=QFhzuhYlFFxR4GswJhzADmbqNhYfKAWXbRXi9fnejuQ6dHZ0G69xyww5prl/0sXW5gxjnqjMs6E3EqZYR3YFRmNZgSIQ75menPQMuQMEY9MleXm4GiX/FI68sipI4YKYCzbhix8YHITB8CDqKEjf/4vuLDvTV77Urw334EPywjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496004; c=relaxed/simple;
	bh=ewJOgRj9eRRY+naXw54wKcAU6+y3/kMWLXLEIv8d//M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bK/z85b3OSjgh1kr7BoLkNOMZN+4m3W0iAq3hasff8Xlais5HYvwo05xLmL+4qlRxpx3zRip5AoZ+ozhCYtEd3R6PP9lCitSH/lc1tvwjRsKsZgMgs4o5g5Tb0Vi8Ic7DpGp6Yaqtp5C578dV4M/wf0/y/PMJKgS1SdZJ1e4m6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YV8VUAEE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A652C4CEED;
	Mon, 14 Jul 2025 12:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496003;
	bh=ewJOgRj9eRRY+naXw54wKcAU6+y3/kMWLXLEIv8d//M=;
	h=From:To:Cc:Subject:Date:From;
	b=YV8VUAEEvUHnI4f8WE/EcPpt+WMASmIMFPkeRf44ltsof5XqXSEOUT8RxEE2bBp+p
	 CYyEhYdA5NMZRyqY44H3DKKbW2Jv/nrgTvRF2YvAgsOU/vBcSEcRJjpnvrN6nSjIIq
	 GbNE6codrQ1XNxtzO6t77JwXsEXcAo3d2Zs+mqLVw2I1nBhErusJXfXFSCXUZXUWHV
	 G1KfGCl/7s8G1APlejBO7N9osBKUC9TbvVeET5mTs26Aj00PjQ0DkltoC0eYNUke0g
	 27anZPIvVgnxaONb4gGZvIiuXlwb8pC21eZvrx/9sZLQu6nMCvGlQRz3Ad/G+4CU8o
	 Ai3BFuEahadyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGX-00FW7V-Jv;
	Mon, 14 Jul 2025 13:26:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 00/11] KVM: arm64: nv: Userspace register visibility fixes
Date: Mon, 14 Jul 2025 13:26:23 +0100
Message-Id: <20250714122634.3334816-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Peter recently pointed out that we don't expose the EL2 GICv3
registers in a consistent manner, as they are presented through the
ONE_REG interface instead of KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS, despite
the latter already exposing the EL1 GICv3 regs.

While I was looking at this, I ended up finding a small number of
equally small problems:

- RVBAR_EL2 shouldn't be a thing at all

- FEAT_FGT registers should only be exposed to userspace if the
  feature is presented to the guest (and actually exists)

- FEAT_FGT2 registers are not exposed at all, and that's bad (though
  the machine that has FGT2 hasn't been built yet)

- Nothing documents which registers are exposed by
  KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS

So I cooked up a handful of fixes for those. And because I was feeling
generous, I hacked the get-reg-list test to check for the EL2
registers reported via ONE_REG /mindblown/.

Eric, I'd really appreciate if you could give this a go with QEMU to
check that you can now correctly get to the GIC El2 registers via the
expected interface.

Marc Zyngier (11):
  KVM: arm64: Make RVBAR_EL2 accesses UNDEF
  KVM: arm64: Don't advertise ICH_*_EL2 registers through GET_ONE_REG
  KVM: arm64: Define constant value for ICC_SRE_EL2
  KVM: arm64: Define helper for ICH_VTR_EL2
  KVM: arm64: Let GICv3 save/restore honor visibility attribute
  KVM: arm64: Expose GICv3 EL2 registers via
    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
  KVM: arm64: Condition FGT registers on feature availability
  KVM: arm64: Advertise FGT2 registers to userspace
  KVM: arm64: selftests: get-reg-list: Simplify feature dependency
  KVM: arm64: selftests: get-reg-list: Add base EL2 registers
  KVM: arm64: Document registers exposed via
    KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS

 .../virt/kvm/devices/arm-vgic-v3.rst          |  63 +++++-
 arch/arm64/kvm/sys_regs.c                     | 111 ++++++----
 arch/arm64/kvm/vgic-sys-reg-v3.c              | 121 ++++++++++-
 arch/arm64/kvm/vgic/vgic.h                    |  18 ++
 .../selftests/kvm/arm64/get-reg-list.c        | 197 +++++++++++++++---
 5 files changed, 432 insertions(+), 78 deletions(-)

-- 
2.39.2


