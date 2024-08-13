Return-Path: <kvm+bounces-23955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37040950216
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C658B2A9D1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C7B192B65;
	Tue, 13 Aug 2024 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWqSpkWr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2FC17B4FA;
	Tue, 13 Aug 2024 10:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543580; cv=none; b=WZD+1KEC+VUsGNP/d1gkVxtxjyVi3YO9nVmd//erxzpPTSSCzv2gcUkbsm8mP2F6MnvfcxtMegRMJxsAPV0K7rGU2ryaXhAO6gJHNKH/pq/Ui/3UdneYu5Qah2xiQlotXueQmCR2FnMZaLfcFxU0SL+1QtLHZ4NYw2V/m8D+6kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543580; c=relaxed/simple;
	bh=v/WFY2PsBYnRktkH3GEMaO5LRP0wVQZKrpi3TzcVUkc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WWYMmxDrfEsTB69p1joDKEErlLSheG03Bxrba+5+ghUInoc7zn279ajdOocAH3vxEpqp/ye2K5dCdNGDUEmezq558NlJh4ki85Cr3ruqA9nJFUiGLaSHq/+PaJzCBDKnkZytdDrpAJXU0vx29orUZyPsvSUkuvmHjiRPmgDwCOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWqSpkWr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0DFC4AF0B;
	Tue, 13 Aug 2024 10:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543580;
	bh=v/WFY2PsBYnRktkH3GEMaO5LRP0wVQZKrpi3TzcVUkc=;
	h=From:To:Cc:Subject:Date:From;
	b=HWqSpkWrryMEx0xAuWvwA4ROoJdE0G1dowAP7Ybg+iljVMNhqKKqr8Mi/B/APvD9k
	 vK/RIu6lpTzkVq2dcY6ZscL+X1idcHltZzi/+44YP2gDTFQanVhacvncUFzqcJV22E
	 tcbo7pZsreFZOTC3oSNTi0HcjSHWThG/dwn/+W0ld3EnEZiGZC00+ExGBFldYNgPsH
	 YIvLVzRDlCQxZYEjgFSni+3ldDBix7RhD/6Le7AgOVeuTSIpCq9XYjxR6mMUBtXdfl
	 geKT5s3KQxtdDNWYJjcJQjf1r839LH9XnfnawLdI9W/f305HzgN49mh6yC8ch1Ztvp
	 w+L3DPABQivpg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoPx-003INM-NW;
	Tue, 13 Aug 2024 11:06:18 +0100
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
Subject: [PATCH v3 00/18] KVM: arm64: nv: Add support for address translation instructions
Date: Tue, 13 Aug 2024 11:05:22 +0100
Message-Id: <20240813100540.1955263-1-maz@kernel.org>
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

This is the third revision of the address translation emulation for
NV support on arm64 previously posted at [1].

Thanks again to Alex for his continuous (contiguous? ;-) scrutiny on
this series.

* From v2:

  - Correct handling of the alignment implied by the contiguous bit in
    both S1 and S2 walkers

  - Correct handling of EL1&0 translation being disabled when
    HCR_EL2.{E2H,TGE} = {0,1}

  - Force S2 being enabled when HCR_EL2.DC = 1

  - Handle PAR_EL1.NSE as RES1

  - Report the full PA on a successful translation

  - Various cleanups

I've added the usual reviewers on Cc, plus people who explicitly asked
to be on it, and people who seem to be super keen on NV.

Patches on top of 6.11-rc1, tested on my usual M2 (so VHE only). FWIW,
I plan to take this into 6.12.

[1] https://lore.kernel.org/r/20240731194030.1991237-1-maz@kernel.org

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
 arch/arm64/kvm/at.c                    | 1098 ++++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c        |    2 +
 arch/arm64/kvm/hyp/include/hyp/fault.h |    2 +-
 arch/arm64/kvm/nested.c                |   41 +-
 arch/arm64/kvm/sys_regs.c              |   60 ++
 12 files changed, 1256 insertions(+), 32 deletions(-)
 create mode 100644 arch/arm64/kvm/at.c

-- 
2.39.2


