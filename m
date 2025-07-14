Return-Path: <kvm+bounces-52312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1D59B03DCF
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A29754A0715
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D257A248F41;
	Mon, 14 Jul 2025 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnSCzGIK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018A32E3718;
	Mon, 14 Jul 2025 11:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752494115; cv=none; b=DbwFeEEno+4xUz00LE+lnQYnPMJyF5i/ZurObuJo7qFf6GBa29cargxXZ30EWLLRyEa+QXvZRZPod7nm8xf8iwK2MQvKrKCsLhT4cju6oSDwKK0rPJrajMEMuvIbvt03OgvMldc9NmGxDKSqpwQS287qdwN530fypuqO69+JLDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752494115; c=relaxed/simple;
	bh=KQgnlUjQYdLD1Hqbz0tCcapTT+nm1BoKMb7War2FM2c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q85CVwSt7hnHI6wzeJneAUna2E2RHO5esphTsx4FjgI/ZITYKNrptkaoeCreMJZEGFHcdoVjVtFrKFUZF2mZpeTMtnFuDTw/vrMwv3uvxwmmoEZUi9wpxLhNnoIIlCIPUJZJx+WgQ25gtzk1MmTMVKakIcrbTzcTbCl/N3qC4qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnSCzGIK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D624EC4CEED;
	Mon, 14 Jul 2025 11:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752494114;
	bh=KQgnlUjQYdLD1Hqbz0tCcapTT+nm1BoKMb7War2FM2c=;
	h=From:To:Cc:Subject:Date:From;
	b=mnSCzGIKJti7sYf3IagIZIHsK8M5/i38W+wicWYyP2WZ12Es2yG/oRdYPpddnJskE
	 vAyMoJkdfMdOQl+7VRfLzKrnqNcNaBjpa2gLp55V7vgqoGBjG9gLXY3Tm99DeXIKVf
	 KbAg9N3ftFrz14SA5GoJuW/POgzdjkC6T7+sz1WfwmyfZ2L6BsMsdg4HnZ777dYdu5
	 w1pLB9vBGBPBkuHPLeWWjmYdTzpmfWZz+EFDcz6ZyTyUg6zXHinc3SHqJ3qwmGtmQQ
	 c6/MZ2CP8uWGItXYlde8s375+WmyZKzIyyzAqryTogoTPcW/Vf5KcsyNsE+jpqbb9p
	 TMruml7ywCpIA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubHm4-00FVUo-K7;
	Mon, 14 Jul 2025 12:55:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/5] KVM: arm64: Config driven dependencies for TCR2/SCTLR/MDCR
Date: Mon, 14 Jul 2025 12:54:58 +0100
Message-Id: <20250714115503.3334242-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Here's a very short (and hopefully not too controversial) series
converting a few more registers to the config-driven sanitisation
framework (this is mostly a leftover from the corresponding 6.16
monster series).

Patches on top of -rc3.

	M.

Marc Zyngier (5):
  arm64: sysreg: Add THE/ASID2 controls to TCR2_ELx
  KVM: arm64: Convert TCR2_EL2 to config-driven sanitisation
  KVM: arm64: Convert SCTLR_EL1 to config-driven sanitisation
  KVM: arm64: Convert MDCR_EL2 to config-driven sanitisation
  KVM: arm64: Tighten the definition of FEAT_PMUv3p9

 arch/arm64/kvm/config.c | 227 +++++++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/nested.c |  60 +----------
 arch/arm64/tools/sysreg |  13 ++-
 3 files changed, 238 insertions(+), 62 deletions(-)

-- 
2.39.2


