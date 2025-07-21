Return-Path: <kvm+bounces-52960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28595B0C124
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 12:20:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AD9616C034
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 10:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F8E28DF57;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fI9Pu2MT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BD31DEFDB;
	Mon, 21 Jul 2025 10:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753093207; cv=none; b=QXEZkJ7gA1t2l2NIPxxssOyBvQmhNe+C6x9rBSEkg5nB0LOwtC35CVnL1rweNly1Dulfw5vjOJCi76Gik1tTum6Rvat0LR1iFQmRLgN71BS6eroLl1Kv8Lu4IZBp9liJAWfoHaV+flykgjAY4tiUktLr5hYYEUKR/u44G4nBCwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753093207; c=relaxed/simple;
	bh=uZLZ0nK2M/lar7zqTQyEJsNemSM7m128SJkqJMrBgy8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VQiT3M3c4GuVqqnsqCSUH6N8YnVwcVIsvJ4ZnCklDDnxsyZTKvXo5qgQiiJ4rDdMOyFVBrqdT/xMxd484aQM97jD+7cm5kPlL8x+5YRiDMUT/T8ZyOa4iL98+sNGFGFJ5JyAcKJKVsvVs8I0hUFLp5saRAv9DRejTsFsELZfznU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fI9Pu2MT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D904C4CEED;
	Mon, 21 Jul 2025 10:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753093207;
	bh=uZLZ0nK2M/lar7zqTQyEJsNemSM7m128SJkqJMrBgy8=;
	h=From:To:Cc:Subject:Date:From;
	b=fI9Pu2MTK5r7Nsu7I0bujcKmQTkvEBebgLAfduxnAcr24BQHeJLlFU0bszlC2rNMh
	 tcPJ6rDL60y67McSdZZK1jRVmSdoN0NZDC2EsYFFUOhciVKb29QTkxB0FKOnBd8QAz
	 lwW6CMuSejyhC0vwdV3v2iRoJGiSWrkvbLQprQH2fmRVfyYkGUqkuhJPDzlmDpTd3c
	 dHqGz4/9+DF+T96Ji30qCqZLZ4CrjQscTA+E3Mfvk+34tDYKhXSwfiR5q/exMGzuwN
	 1ONtpLqAAoNo0te6Em7NDB639HAhys9lqfTreiM4APeAN03P7YwBv/pPk1/2vaBMis
	 QVVF9rLo1X/pQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udncr-00HZDF-D0;
	Mon, 21 Jul 2025 11:20:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 0/7] KVM: arm64: FEAT_RASv1p1 support and RAS selection
Date: Mon, 21 Jul 2025 11:19:48 +0100
Message-Id: <20250721101955.535159-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As I was debugging some RAS-related issues[1], I realised that:

- My test box is implementing RASv1p1

- We unconditionally advertise it to guests

- Issuing RASv1p1 accesses doesn't end very well

- [...]

- Profit?

The overall goal of this is to allow the RAS support to be downgraded
to not much, as we're not implementing anything interesting yet, while
still offering the appearance of architecture compliance up to RASv1p1
(everything is RAZ/WI). Along the way, we plug the most glaring holes
(HCR_EL2 bits propagated at the wrong spot, HCR_EL2.FIEN not being
filtered out).

Unusually, this is on top of the DoubleFault2 series, as this is where
the problems started.

[1] https://lore.kernel.org/r/87tt37ulvf.wl-maz@kernel.org

Marc Zyngier (7):
  arm64: Add capability denoting FEAT_RASv1p1
  KVM: arm64: Filter out HCR_EL2 bits when running in hypervisor context
  KVM: arm64: Make RAS registers UNDEF when RAS isn't advertised
  KVM: arm64: Handle RASv1p1 registers
  KVM: arm64: Ignore HCR_EL2.FIEN set by L1 guest's EL2
  KVM: arm64: Expose FEAT_RASv1p1 in a canonical manner
  KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable

 arch/arm64/kernel/cpufeature.c  | 24 ++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c | 19 +++++++++--
 arch/arm64/kvm/sys_regs.c       | 56 +++++++++++++++++++++++++++------
 arch/arm64/tools/cpucaps        |  1 +
 4 files changed, 88 insertions(+), 12 deletions(-)

-- 
2.39.2


