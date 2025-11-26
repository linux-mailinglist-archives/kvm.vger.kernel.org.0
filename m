Return-Path: <kvm+bounces-64679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35021C8ACC0
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:02:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26CDE3B8F91
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AD433C538;
	Wed, 26 Nov 2025 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YF9z44E5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9C133B6E9;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764172801; cv=none; b=McQBDdosZo/v2WMfatg/oYdWDZDSgj08psAqEhh7oMNZhsB4p9cSgnt7DiL7lozQw8ov8vVq/g5I2xOPbtBCFstVHHRJPZlx5WQtdHRsIlCMSAP2UY7kpd/YpDjtdLqyKqmnY+e0kaxMgYcVZZamAO6XhE2Xv14G4+zvXrLT3xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764172801; c=relaxed/simple;
	bh=+BV4THtYsQfcXI7IsOiiCra+PKb2lEDeuC2fbyHx94E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tgtmryyQULkia5RTD2wAmBYKStUswGMjEO+c2oG9x1q+DerrDLfrPocIN1QRnKESJxFc8PmvrfbeHiBAu/7Xllg58uFxEQG20+QXhN5JbZZpqnJ3S/RNNISfopcLyJIZWxBF0lyNqhPptyzMk93CAKTv+r0sEakMjI68+yNYTr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YF9z44E5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C936C116B1;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764172801;
	bh=+BV4THtYsQfcXI7IsOiiCra+PKb2lEDeuC2fbyHx94E=;
	h=From:To:Cc:Subject:Date:From;
	b=YF9z44E5JESLD5d1T4C1tdQX09Ei64wnllaj1pF7GgnSEPVlsMh75pmmVQ3tVA/Rg
	 /q08fZDQTARboGe2lRON/sXRoPNXSl9rzgBpPdvl3Zc+sFtUtJyrdgeghOkG9e/Eeu
	 Ao1s76QSGpGnryGXrPcZu5JGIszepPuKsoJ3llFP8jsZ0U8R1YFSE4vkpHKWIOO+sK
	 ZKBFNTVwarwcwn/33LXaFnENMmh5/7BbQFaRzE1Hp2Mt4G2R8j1zk6OAUG+bmBRgZU
	 FP+EfQPKbe/9uMvMtfmUu0ahsj+vGzY+LD5cPWqDzacJXdcITJWhiThMpEDS6PS7Vq
	 f7azhSdV3moNw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vOHvy-00000008WrH-132B;
	Wed, 26 Nov 2025 15:59:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v2 0/5] KVM: arm64: Add support for FEAT_IDST
Date: Wed, 26 Nov 2025 15:59:46 +0000
Message-ID: <20251126155951.1146317-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_IDST appeared in ARMv8.4, and allows ID registers to be trapped
if they are not implemented. This only concerns 3 registers (GMID_EL1,
CCSIDR2_EL1 and SMIDR_EL1), which are part of features that may not be
exposed to the guest even if present on the host.

For these registers, the HW should report them with EC=0x18, even if
the feature isn't implemented.

Add support for this feature by handling these registers in a specific
way and implementing GMID_EL1 support in the process. A very basic
selftest checks that these registers behave as expected.

* From v1: [1]

  - Fixed commit message in patch #4 (Ben)
  - Collected RB, with thanks (Joey)

[1] https://lore.kernel.org/r/20251120133202.2037803-1-maz@kernel.org

Marc Zyngier (5):
  KVM: arm64: Add routing/handling for GMID_EL1
  KVM: arm64: Force trap of GMID_EL1 when the guest doesn't have MTE
  KVM: arm64: Add a generic synchronous exception injection primitive
  KVM: arm64: Report optional ID register traps with a 0x18 syndrome
  KVM: arm64: selftests: Add a test for FEAT_IDST

 arch/arm64/include/asm/kvm_emulate.h          |   1 +
 arch/arm64/kvm/emulate-nested.c               |   8 ++
 arch/arm64/kvm/inject_fault.c                 |  10 +-
 arch/arm64/kvm/sys_regs.c                     |  17 ++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/arm64/idreg-idst.c  | 117 ++++++++++++++++++
 6 files changed, 149 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/idreg-idst.c

-- 
2.47.3


