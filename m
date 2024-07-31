Return-Path: <kvm+bounces-22805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E5C294368D
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A5641C21EA8
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2982815FA7A;
	Wed, 31 Jul 2024 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jirpesr8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F42235280;
	Wed, 31 Jul 2024 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454855; cv=none; b=UVyzzUNvSdIraYMrOSGoatPSU3NocSZgo1DvIHlL0DhX5WOqdnbxb8b1VP2iyu66b5cOACTsYqhnjyBnIXnj5JaeGs3EN/X73KarMibP09C9nHHrBrOg5ty5oRUY77XwGKse4z0EfdzZpSl7GJlvW0SsTMTnp0PD/pu3M1s/TVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454855; c=relaxed/simple;
	bh=nZsTfRkPRsBDTl7KWkqYsSA/btlrP7383aII6HM3n8A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=thsYnDj8l7HYxm/cpyJ11SxY7VMwjA5cUWBgxqwGaRCVz8J7UUhmiVTj/v967UTo1tndJExlMnJDSBMDm42z2eblcyR+JayWAJlzCqw1l6xOcC/f7yqwMRSP1MHe5+tie7GADFKm2CspjdYGHpBpgKoopZZUyOZ+yiN7CtNtAcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jirpesr8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D05C4AF0C;
	Wed, 31 Jul 2024 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454855;
	bh=nZsTfRkPRsBDTl7KWkqYsSA/btlrP7383aII6HM3n8A=;
	h=From:To:Cc:Subject:Date:From;
	b=Jirpesr8hL0Saat3zFCWd82wVd9xlaiYSjjEt4PXnxNews/E66FXNGAXW4/rhqRI1
	 +SKwK9CU4UOFatLuZodIc9h/ZX1hCSxFNS/WeFi/FAMN/dVhI8mTihgLe3gu7YUg10
	 JAttELO5VpzlUJizWP45nE4nmyY9ydtkIqwdB2q687Rci+HL9aYMIX/ln8k2u04OzS
	 fQdCvcl7ccXf3gwrmL9r1NH51GRjSRORWzEniRm36b5wNRBHGpVjTAO2GVZsYPl13q
	 ADVhYnqe6saqNH6l7Hl1ShCTR1857iSir3CmGlNy/9V55dXrmeyLvV8TCXDJKcDhfM
	 PsO54X91NPNrg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBs-00H6Gh-U0;
	Wed, 31 Jul 2024 20:40:52 +0100
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
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 00/17] KVM: arm64: nv: Add support for address translation instructions
Date: Wed, 31 Jul 2024 20:40:13 +0100
Message-Id: <20240731194030.1991237-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the second revision of the address translation emulation for
NV support on arm64 initially posted at [1]. I haven't kept an
detailed change log of what happened since, but here are the
highlights:

  * A fair amount has changed in the series, starting with a lot of
    bugs being fixed thanks to Alex's hard work comparing the
    implementation and the pseudocode. All credits to him, this is a
    lot harder than writing code.

  * At Alex's request, the code structure is now a bit closer to the
    pseudocode in a number of aspects, so that people can eyeball it
    more easily.

  * Whenever I could, I added references to ARM ARM rules to help with
    cross-referencing the implementation and the requirements.

  * FEAT_PAN2 support is now implemented using the... FEAT_PAN2
    instructions (surprise!) instead of the previous version that was
    using three different AT instructions.

  * The code now has the notion of translation regime, which makes it
    somehow clearer what is going on. I was pretty sceptical about it
    initially, but it turned out rather OK.

  * The series has been resplit to make it more digestable. Patch 13
    is still on a mission to make you puke.

I've added the usual reviewers on Cc, plus people who explicitly asked
to be on it, and people who seem to be super keen on NV.

Patches on top of 6.11-rc1, tested on my usual M2 (so VHE only).

[1] https://lore.kernel.org/r/20240625133508.259829-1-maz@kernel.org

Joey Gouly (1):
  KVM: arm64: Make kvm_at() take an OP_AT_*

Marc Zyngier (16):
  arm64: Add missing APTable and TCR_ELx.HPD masks
  arm64: Add PAR_EL1 field description
  arm64: Add system register encoding for PSTATE.PAN
  arm64: Add ESR_ELx_FSC_ADDRSZ_L() helper
  KVM: arm64: nv: Turn upper_attr for S2 walk into the full descriptor
  KVM: arm64: nv: Honor absence of FEAT_PAN2
  KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}
  KVM: arm64: nv: Add basic emulation of AT S1E1{R,W}P
  KVM: arm64: nv: Add basic emulation of AT S1E2{R,W}
  KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
  KVM: arm64: nv: Make ps_to_output_size() generally available
  KVM: arm64: nv: Add SW walker for AT S1 emulation
  KVM: arm64: nv: Sanitise SCTLR_EL1.EPAN according to VM configuration
  KVM: arm64: nv: Make AT+PAN instructions aware of FEAT_PAN3
  KVM: arm64: nv: Plumb handling of AT S1* traps from EL2
  KVM: arm64: nv: Add support for FEAT_ATS1A

 arch/arm64/include/asm/esr.h           |    5 +-
 arch/arm64/include/asm/kvm_arm.h       |    1 +
 arch/arm64/include/asm/kvm_asm.h       |    6 +-
 arch/arm64/include/asm/kvm_nested.h    |   18 +-
 arch/arm64/include/asm/pgtable-hwdef.h |    9 +
 arch/arm64/include/asm/sysreg.h        |   22 +
 arch/arm64/kvm/Makefile                |    2 +-
 arch/arm64/kvm/at.c                    | 1058 ++++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c        |    2 +
 arch/arm64/kvm/hyp/include/hyp/fault.h |    2 +-
 arch/arm64/kvm/nested.c                |   34 +-
 arch/arm64/kvm/sys_regs.c              |   60 ++
 12 files changed, 1192 insertions(+), 27 deletions(-)
 create mode 100644 arch/arm64/kvm/at.c

-- 
2.39.2


