Return-Path: <kvm+bounces-8559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 767F9851748
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 15:48:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31E5D28290F
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 14:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7423BB28;
	Mon, 12 Feb 2024 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="be8tDfyA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BEB3B2B6;
	Mon, 12 Feb 2024 14:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707749273; cv=none; b=hmcAoU5+30lnmUmFW/UBDb9+o0qlu3IGGKsWKhDbxXHPqKR+gg43m6x5YCJ0ChKt1un3pnE5ZYG0Af3fOAi9rVEJ5UzseiqfPvcfKUbpPu7iihQ5qPSGKbwOvQrW5sK/+O6wVaxLrdtLANAohfX8Ni0zstyD5ZSzK1JA1wV9BtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707749273; c=relaxed/simple;
	bh=e/tWxSOkmw6htrhwgmxgeclP5tKG6yp5OWGwNwdixWg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NzaDSJ/hqvYp62Tb6qXr5MF14krtnjCor9BToyhValp7qzb2d/sk6lqDiKnsoiPKYd1vG9TwJHFssjdR+MMMI1IO3dW1Bmxw57ttSSFxNZ7K29qfqS0SFQJfCAgc60x4TYHD35AY3T7kLh9qG6Fa6CQby/L0Lh5L54cIsFfAH/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=be8tDfyA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89688C433C7;
	Mon, 12 Feb 2024 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707749272;
	bh=e/tWxSOkmw6htrhwgmxgeclP5tKG6yp5OWGwNwdixWg=;
	h=From:To:Cc:Subject:Date:From;
	b=be8tDfyAPs4RBfXpCJMaVeDrEo0197DTqvmpTzQEEAkB0YjCl5Bkqgd5y134Ko+R1
	 IR8iNdRuQK+IQvLZMePTdfPp6iL4uevAYsMyHqSBRwlPUO6yqujzD3Zy7OAEcv0HI7
	 37ZExq41ciTRS8EzaYvAh4Qo72Vjj4VtkhM7sA4Ep7I5hvCf+FI3AEtwgirYxOHjhp
	 oXuGAClU3zWE1oytTmTzDQaQKhueo6qhW+3T7CTMtDykNe5qEySBhltIfFgN3cbuTE
	 mskMW/n7iwgZdwMtJcpGX8fFyKLsXRYVMeVAS/+2vPcYxZpyBLxdU3tQShXp1mgSE+
	 Z0YYEnIqcDDBA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rZXb4-002SFp-4p;
	Mon, 12 Feb 2024 14:47:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 0/2] ARM64: Fixes for FEAT_E2H0 handling
Date: Mon, 12 Feb 2024 14:47:34 +0000
Message-Id: <20240212144736.1933112-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, m.szyprowski@samsung.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As the FEAT_E2H0 handling series has made it to -next, some of its
shortcomings are becoming apparent:

- A missing ID register in __read_sysreg_by_encoding() is causing CPU
  hotplug to explode (reported by Marek)

- NV1 is getting advertised on HW that doesn't have FEAT_NV, which is
  fairly harmless, but still annoying

These fixes should directly apply on the feat_e2h0 branch that Oliver
has pushed to kvmarm/next.

Marc Zyngier (2):
  arm64: cpufeatures: Add missing ID_AA64MMFR4_EL1 to
    __read_sysreg_by_encoding()
  arm64: cpufeatures: Only check for NV1 if NV is present

 arch/arm64/kernel/cpufeature.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.39.2


