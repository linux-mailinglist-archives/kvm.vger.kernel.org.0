Return-Path: <kvm+bounces-24604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A71B9584C0
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35970285D68
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD1118DF76;
	Tue, 20 Aug 2024 10:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2xhXLp8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485A418DF60;
	Tue, 20 Aug 2024 10:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150285; cv=none; b=sODcRBkamzWZZA2kxEdfsriRCzCrhwSHRi7uGFSBkX6xeqfZsiosBG65WPjNDj6Or3LntPGzof/8N9jdR5pGPho1/6xYeV9cDJRO0Yz9yQRXmlFF8Kqrtz3X0IL7EIU4aIS6WEKWjqjfoUb+IVjtF1LhmohrFzbWFQl/SkMFrxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150285; c=relaxed/simple;
	bh=/QE4muzh2v2LXOxJRIwLcce76QDDyAFeuyaiswcsKTc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TPKYjhgYBdXkTS2WfcQelHPhZ2arbLe0J/XENpqegqWcCdjKNXVn99FWxcQItI5aThdA1Pau9u4K4Q60cNawC64duVVBvMNa8ZOIu6xrSfF5bzwizhiNLxLDc51f0VFxeYFxz1OBePhdk3Jbc8bqFMmkGmXMI/vnEyIKW3rg2ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H2xhXLp8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C39C4AF11;
	Tue, 20 Aug 2024 10:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150284;
	bh=/QE4muzh2v2LXOxJRIwLcce76QDDyAFeuyaiswcsKTc=;
	h=From:To:Cc:Subject:Date:From;
	b=H2xhXLp87RDksENUEdF7vzXgRU7fIe+mMQPfhIBDYvlm8ovQdIl35XjmDofhwy1d1
	 aMbUmEsx/f0lUudOkesVnJwROttzRXqVwi9PNSf/vQLUoGJCMmctkV3OuyQy9uOxrR
	 nVqcVh2BgzKJ968iT8iWiAhI0IaQhCC98OEtUn1VJ7T2+St6oWJZR0xwijz2ZpTUid
	 M7k7luFhWaUIKkz4FB3twca2vahehHs9KxtU5zOuV1Ut9KCIhkX7oe85bz6Wfb53s/
	 8fWN/U7mrAktPaEGZYSheRO1AUfsqMz505Q9b2Tt7g7mDpUZpyW3eBvlQGonp4g9GQ
	 Vyn993vxXXXxQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFW-005Ea3-K5;
	Tue, 20 Aug 2024 11:38:02 +0100
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
Subject: [PATCH v4 00/18] KVM: arm64: nv: Add support for address translation instructions
Date: Tue, 20 Aug 2024 11:37:38 +0100
Message-Id: <20240820103756.3545976-1-maz@kernel.org>
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

This is the fourth revision of the address translation emulation for
NV support on arm64 previously posted at [1].

Thanks again to Alex for his continuous (contiguous? ;-) scrutiny on
this series.

* From v3:

  - Fix out of range conditions for TxSZ when LVA is implemented

  - Fix implementation of R_VPBBF to deliver an Address Size Fault

  - Don't grant PX if UW is set

  - Various cleanups

  - Collected Alex's RBs, with thanks.

I've added the usual reviewers on Cc, plus people who explicitly asked
to be on it, and people who seem to be super keen on NV.

Patches on top of 6.11-rc1, tested on my usual M2 (so VHE only). FWIW,
I plan to take this into 6.12.

[1] https://lore.kernel.org/r/20240813100540.1955263-1-maz@kernel.org

Joey Gouly (1):
  KVM: arm64: Make kvm_at() take an OP_AT_*

Marc Zyngier (17):
  arm64: Add missing APTable and TCR_ELx.HPD masks
  arm64: Add PAR_EL1 field description
  arm64: Add system register encoding for PSTATE.PAN
  arm64: Add ESR_ELx_FSC_ADDRSZ_L() helper
  KVM: arm64: nv: Enforce S2 alignment when contiguous bit is set
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
 arch/arm64/include/asm/kvm_nested.h    |   40 +-
 arch/arm64/include/asm/pgtable-hwdef.h |    9 +
 arch/arm64/include/asm/sysreg.h        |   22 +
 arch/arm64/kvm/Makefile                |    2 +-
 arch/arm64/kvm/at.c                    | 1101 ++++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c        |    2 +
 arch/arm64/kvm/hyp/include/hyp/fault.h |    2 +-
 arch/arm64/kvm/nested.c                |   41 +-
 arch/arm64/kvm/sys_regs.c              |   60 ++
 12 files changed, 1259 insertions(+), 32 deletions(-)
 create mode 100644 arch/arm64/kvm/at.c

-- 
2.39.2


