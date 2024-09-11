Return-Path: <kvm+bounces-26511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF209754A7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 947081F2786D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F7F1A3A83;
	Wed, 11 Sep 2024 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PVIAQbyv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9871A2642;
	Wed, 11 Sep 2024 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062718; cv=none; b=WsLq1bv40Q//r5pIRc6qXJ6JSqslBF1/pHPb+ATBgRVczR3Cru9akEn06prNkqdA02/mLUnLjYuwwjAjQGkHKfDVidDxfVJvXXQy5SrsBpdFa50NDwOO23wAeZMwZdQvj/lvjuCGjefmYtygXmkRm2Xeebm0KSw9Lp4fANR6pgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062718; c=relaxed/simple;
	bh=wO+H1x7RpunI39z5g6QQtUvPj7qwwksh4Ah0uJkrFLE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rw/PENJTKz9rz6KWNTY1XM5h00osLZb9b1dGQCcsTRTU0+GNtALYe4R2t6g2sYMkTyXf4gAdglVn0UVwC5CftpN1shEBZFQJusRA6XJyF8ah2NUgqbHlfl4Ld9WNWvxiUshXtlkHlSt0lh6Lw4Nk0UeHsXFrq3sX9ZUuc/bwSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PVIAQbyv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8411BC4CEC0;
	Wed, 11 Sep 2024 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062718;
	bh=wO+H1x7RpunI39z5g6QQtUvPj7qwwksh4Ah0uJkrFLE=;
	h=From:To:Cc:Subject:Date:From;
	b=PVIAQbyvTmBKzZc8GMOcpEMjA1U8Ip58tOgkLvur+UCu0ygdjB74YvSN6CACy1jQf
	 pbKiOr/duVQ7wmo+jNBqrANTjLbcI2lIHZNO8Pn+xYxY+wcg8BOn81FZj/EaizREXr
	 Oi/iQziLKJLbLJOkSXhvGdbzwaI2p3twd9Ta0dwRYX9T1dmo3Nn5uaosuXwTjxROjh
	 bVe3xG62EDcdYoLmY2p1QlS1hWH3V09Sn0xZwo1YsNYF7sEnTo0oHdWPviJyc31Gr2
	 SymSnLlR7woYJ1zprgqdpF0Tr6YawTCaT1acpEuI7jeD55QteQouLsZq0/IfoYzdxr
	 KXx/gj8OFPJcg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlE-00C7tL-6c;
	Wed, 11 Sep 2024 14:51:56 +0100
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
Subject: [PATCH v3 00/24] KVM: arm64: Add EL2 support to FEAT_S1PIE
Date: Wed, 11 Sep 2024 14:51:27 +0100
Message-Id: <20240911135151.401193-1-maz@kernel.org>
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

* From v2 [2]:

  - Correctly reprogram the context for AT in the fast path when S1PIE
    is in use

  - Generalised sysreg RES0/RES1 masking, and added TCR2_EL2 RES0/RES1
    bit handling

  - Fix TCR2_EL1, PIR_EL1, PIRE0_EL1 access with VHE

  - Add a bunch of missing registers to get_el2_to_el1_mapping()

  - Correctly map {TCR2,PIR,PIRE0}_EL2 to their EL1 equivalent on NV

  - Disable hierarchical permissions when S1PIE is enabled

  - Make EL2 world switch directly act on the vcpu rather than an
    arbitrary context

  - Remove SKL{0,1} from the TCR2_EL2 description

* From the initial posting [1]:

- Rebased on top of the AT support branch, which is currently sitting
  in kvmarm/next

- Add handling for S1 indirect permission in AT, which I'm sure will
  give Alexandru another king-sized headache

- Picked Mark Brown's series [3] dealing with TCRX and S1PIE
  visibility, and slapped an extra fix on top for good measure

- Picked up RBs from Joey, with thanks.

[0] https://developer.arm.com/documentation/102105/ka-04/
[1] https://lore.kernel.org/r/20240813144738.2048302-1-maz@kernel.org
[2] https://lore.kernel.org/r/20240903153834.1909472-1-maz@kernel.org
[3] https://lore.kernel.org/r/20240822-kvm-arm64-hide-pie-regs-v2-0-376624fa829c@kernel.org

Marc Zyngier (21):
  arm64: Drop SKL0/SKL1 from TCR2_EL2
  arm64: Remove VNCR definition for PIRE0_EL2
  arm64: Add encoding for PIRE0_EL2
  KVM: arm64: nv: Add missing EL2->EL1 mappings in
    get_el2_to_el1_mapping()
  KVM: arm64: nv: Handle CNTHCTL_EL2 specially
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: Correctly access TCR2_EL1, PIR_EL1, PIRE0_EL1 with VHE
  KVM: arm64: Extend masking facility to arbitrary registers
  arm64: Define ID_AA64MMFR1_EL1.HAFDBS advertising FEAT_HAFT
  KVM: arm64: Add TCR2_EL2 to the sysreg arrays
  KVM: arm64: Sanitise TCR2_EL2
  KVM: arm64: Add save/restore for TCR2_EL2
  KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
  KVM: arm64: Add save/restore for PIR{,E0}_EL2
  KVM: arm64: Handle PIR{,E0}_EL2 traps
  KVM: arm64: Sanitise ID_AA64MMFR3_EL1
  KVM: arm64: Add AT fast-path support for S1PIE
  KVM: arm64: Split S1 permission evaluation into direct and
    hierarchical parts
  KVM: arm64: Disable hierarchical permissions when S1PIE is enabled
  KVM: arm64: Implement AT S1PIE support
  KVM: arm64: Rely on visibility to let PIR*_ELx/TCR2_ELx UNDEF

Mark Brown (3):
  KVM: arm64: Define helper for EL2 registers with custom visibility
  KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
  KVM: arm64: Hide S1PIE registers from userspace when disabled for
    guests

 arch/arm64/include/asm/kvm_host.h          |  34 ++-
 arch/arm64/include/asm/vncr_mapping.h      |   1 -
 arch/arm64/kvm/at.c                        | 322 +++++++++++++++++----
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   5 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c        |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 155 +++++++++-
 arch/arm64/kvm/nested.c                    |  34 ++-
 arch/arm64/kvm/sys_regs.c                  | 129 ++++++++-
 arch/arm64/tools/sysreg                    |   8 +-
 include/kvm/arm_arch_timer.h               |   3 +
 10 files changed, 597 insertions(+), 96 deletions(-)

-- 
2.39.2


