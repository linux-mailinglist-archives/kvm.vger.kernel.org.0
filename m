Return-Path: <kvm+bounces-25752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E1796A2F5
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DBB10B24872
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1824A189530;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDRUJ73n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1C2188910;
	Tue,  3 Sep 2024 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377921; cv=none; b=gvJzVYmupARyGWaR/7RztbxwYrnRFvx9DRDPcpZv+Yn8jDfelP82F9SO8Ph9AKqrZFHJgPGzKLweWKlQkyvlKu7mV0Q6p1uH0YDLkhhNJdu7+LqdNSeq/mrSQpocNxqbgA7EAHd6D6i+uPdEo1cx18evuhkwdy2rMtbY93Bkl8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377921; c=relaxed/simple;
	bh=sXJfA8yocIirH64sdVHVPy+2Rap5C+AsvH487B5sjXU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gOeiI6xX6TzdNBfOG0xKxwr7n/UlP7PQuadKFENzdbP90Ef22Zf7u/yV+MHecz1/Bw8pFm903Mgdsewim/rLFh+aoKf8pG5OP+USqcp7HspEGMnYvVB6ltR0cRR84qmlgQcYib7j01zC5frrxuVzz3QKDoA9u7a/PhJeFWvwoR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NDRUJ73n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB79EC4AF0C;
	Tue,  3 Sep 2024 15:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377920;
	bh=sXJfA8yocIirH64sdVHVPy+2Rap5C+AsvH487B5sjXU=;
	h=From:To:Cc:Subject:Date:From;
	b=NDRUJ73nNbA+fDvnPwHrallvW66hmfkrnEylnywTOdN8iSM62caLt5VMYE93/DAms
	 AmJoDr+/qBJYaROT0H0nIzRwukgKzN9rsjutR2xVd7Cj5gO6VNs+HngULrgpF3mgYp
	 JtWqlUWFi6vd+vYzwyF0tQYXurTzzES6z8EugdVCHEo4J8QVR04BDiEpbGXvSR/9E/
	 qAD2XrXhZnrZlcNSR7DZlFHZhdnnF/WL4qj0ChruSzHpdc2aGHzzzeTfVAQH01EMnr
	 aC3KoQcdsNGltLZYlcB2/vzFyeGp1dTM6XXRQNhCy1uZ17mUCSDg6tYHbo0Z6ELOvb
	 kjcpff3n9HWJg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc6-009Hr9-Db;
	Tue, 03 Sep 2024 16:38:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 00/16] KVM: arm64: Add EL2 support to FEAT_S1PIE
Date: Tue,  3 Sep 2024 16:38:18 +0100
Message-Id: <20240903153834.1909472-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This series serves a few purposes:

- Complete the S1PIE support to include EL2
- Sneak in the EL2 system register world switch

As mentioned in few of the patches, this implementation relies on a
very recent fix to the architecture (D22677 in [0]).

This series has seen a few changes since the initial posting [1]:

- Rebased on top of the AT support branch, which is currently sitting
  in kvmarm/next

- Add handling for S1 indirect permission in AT, which I'm sure will
  give Alexandru another king-sized headache

- Picked Mark Brown's series [2] dealing with TCRX and S1PIE
  visibility, and slapped an extra fix on top for good measure

- Picked up RBs from Joey, with thanks.

[0] https://developer.arm.com/documentation/102105/ka-04/
[1] https://lore.kernel.org/r/20240813144738.2048302-1-maz@kernel.org
[2] https://lore.kernel.org/r/20240822-kvm-arm64-hide-pie-regs-v2-0-376624fa829c@kernel.org

Marc Zyngier (13):
  KVM: arm64: nv: Handle CNTHCTL_EL2 specially
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: Add TCR2_EL2 to the sysreg arrays
  KVM: arm64: Add save/restore for TCR2_EL2
  arm64: Add encoding for PIRE0_EL2
  arm64: Remove VNCR definition for PIRE0_EL2
  KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
  KVM: arm64: Add save/restore for PIR{,E0}_EL2
  KVM: arm64: Handle  PIR{,E0}_EL2 traps
  KVM: arm64: Sanitise ID_AA64MMFR3_EL1
  KVM: arm64: Split S1 permission evaluation into direct and
    hierarchical parts
  KVM: arm64: Implement AT S1PIE support
  KVM: arm64: Rely on visibility to let PIR*_ELx/TCR2_ELx UNDEF

Mark Brown (3):
  KVM: arm64: Define helper for EL2 registers with custom visibility
  KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
  KVM: arm64: Hide S1PIE registers from userspace when disabled for
    guests

 arch/arm64/include/asm/kvm_host.h          |   9 +
 arch/arm64/include/asm/vncr_mapping.h      |   1 -
 arch/arm64/kvm/at.c                        | 296 ++++++++++++++++-----
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   5 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c        |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 155 ++++++++++-
 arch/arm64/kvm/sys_regs.c                  | 114 +++++++-
 arch/arm64/tools/sysreg                    |   4 +
 include/kvm/arm_arch_timer.h               |   3 +
 9 files changed, 505 insertions(+), 84 deletions(-)

-- 
2.39.2


