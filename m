Return-Path: <kvm+bounces-24628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC999587B2
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:18:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D2CF283ABD
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79904190675;
	Tue, 20 Aug 2024 13:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYjJQoS/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A55318CC08;
	Tue, 20 Aug 2024 13:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724159888; cv=none; b=rUnV0jeMQ0SToxkXKe+Bh/tXv9Qqw1fkQ1AisEzcEKHmSSv7435e4nGQrfeYaHX3seNZkCJlR9EkQgLOI/lm9AIPjoWsnem6JecAR3F0zZtDf0JDKFZPRGeegnS9TiVyxTQVYHVPpMJGE753ZD3+4rh8ZFIJvs8IEJxSkHT5nho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724159888; c=relaxed/simple;
	bh=w66lr3+fWgepBhO+Q8813/VtQfHj20xrCsLXmI3bW6M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Vf+BRLAhEDTtEAAxEufmEDhuDcNn6EApQlExH1dMM+09PS7DUzsifeGcqYluwOs7UYPGvch2+BVAg9cHWCIvH7wKobImW2fzDePqZ8rd+HwujethjuTV5NPquaYH+wxh7OHt5IzvlvFZmzflOZnl6uWI5iN49WjeIDvn4uj7oQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gYjJQoS/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C9AC4AF10;
	Tue, 20 Aug 2024 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724159888;
	bh=w66lr3+fWgepBhO+Q8813/VtQfHj20xrCsLXmI3bW6M=;
	h=From:To:Cc:Subject:Date:From;
	b=gYjJQoS/JlQ57qP/qoqHQrvHgHuROkqDRoZLKpK5ymiqdRO8TrybmbFgITU1R48bX
	 RnUCq15ehC2D1VHfL3QlGS1M+8f0cj4tN2h0Uf1zBLEFHYVw6QWd2A1YVJNtJvn9m3
	 l3GJrswoIO26nqN/Xe6ZiHbfB0A2ix3qXMzGxB8psqHvqoSuFgkXnuARDtitLGJ96+
	 +rCEmOJd0xI/Z+9l0e6gHScBpVHZlaTFcy365K9GupYey9qae4GFATlRMmJDoH77Yy
	 h1p3uVBgO3LygW09xvIwkQaCBwWitUMqmwxecIvpi/cx+8TawvxU9misNXUs+OuTl3
	 degyNHG4XA1pw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgOkP-005HMQ-Qf;
	Tue, 20 Aug 2024 14:18:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 0/8] KVM: arm64: Add support for FP8
Date: Tue, 20 Aug 2024 14:17:54 +0100
Message-Id: <20240820131802.3547589-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although FP8 support was merged in 6.9, the KVM side was dropped, with
no sign of it being picked up again. Given that its absence is getting
in the way of NV upstreaming (HCRX_EL2 needs fleshing out), here's a
small series addressing it.

The support is following the save/restore model established for the
rest of the FP code, with FPMR being tied to it. The sole additions
are the handling of traps in a nested context, and the corresponding
ID registers being made writable. As an extra cleanup, SVCR and FPMR
are moved into the sysreg array.

Patches are on top of v6.11-rc1. Note that this is compile-tested
only, as I have no access to FP8 HW or model (and running NV in a
model is not something I wish to entertain ever again).

* From v3 [3]

  - Simplify handling of SYS_ID_AA64PFR2_EL1

* From v2 [2]

  - Add missing kern_hyp_va() when dereferencing vcpu->kvm on nVHE
    setups

* From v1 [1]

  - Correctly save/restore the guest state (duh), including pKVM
    (double duh)

  - Add a predicate for FPMR support in a VM, as this gets used more
    than twice...

[1] https://lore.kernel.org/r/20240708154438.1218186-1-maz@kernel.org
[2] https://lore.kernel.org/r/20240708154438.1218186-1-maz@kernel.org
[3] https://lore.kernel.org/r/20240813104400.1956132-1-maz@kernel.org

Marc Zyngier (8):
  KVM: arm64: Move SVCR into the sysreg array
  KVM: arm64: Add predicate for FPMR support in a VM
  KVM: arm64: Move FPMR into the sysreg array
  KVM: arm64: Add save/restore support for FPMR
  KVM: arm64: Honor trap routing for FPMR
  KVM: arm64: Expose ID_AA64FPFR0_EL1 as a writable ID reg
  KVM: arm64: Enable FP8 support when available and configured
  KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace and guests

 arch/arm64/include/asm/kvm_host.h       | 20 ++++++++++++++--
 arch/arm64/kvm/emulate-nested.c         |  8 +++++++
 arch/arm64/kvm/fpsimd.c                 |  5 ++--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  9 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  9 +++++++
 arch/arm64/kvm/hyp/vhe/switch.c         |  3 +++
 arch/arm64/kvm/sys_regs.c               | 32 ++++++++++++++++++++++---
 8 files changed, 82 insertions(+), 7 deletions(-)

-- 
2.39.2


