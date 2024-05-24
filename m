Return-Path: <kvm+bounces-18136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51CF68CE6DF
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BC60281E57
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1103B12C55D;
	Fri, 24 May 2024 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u6XfOWo8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3049686279;
	Fri, 24 May 2024 14:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560413; cv=none; b=s3CswXJ+HJ9jMCrX9J09Yc09Vzq7WE4ApxvDbVynoCJWlfusDK+VoKohUdJ4Bk60+F7qMsBPNarFhZdz9wXGN/KDuL1TT6xgeBWjRIH0cPm89z0qexpcZcQ8QNX/Lp+U8xwItU6lkXY2/bUj/OQU6pTd8PYuoujsFaHeMvMdGh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560413; c=relaxed/simple;
	bh=YBi+a6DVfeuDyoA3vrhAmhhyd6I32xXQvbZRZPEE1vM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SEJM6gPwNTz3VZJozpnPMSH9zHrjdpNobJqX5l/U1rNkl7VK2IENz+T6GArEl6ZGxAGiZ59MrHPS1Gb6xEnJ38A46EIL4mj2coaIy9AUOYDOBLpESUX5ymrRxkwmxE9ysBWweLISZG7+nZ+DajF05L6dxj6BL4A76PoYPcOOrhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u6XfOWo8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD007C2BD11;
	Fri, 24 May 2024 14:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716560412;
	bh=YBi+a6DVfeuDyoA3vrhAmhhyd6I32xXQvbZRZPEE1vM=;
	h=From:To:Cc:Subject:Date:From;
	b=u6XfOWo8jW/W+2/vjwiF0UL/ieFeF6FBwhwAovskkv/t//4Jk7nPJogDiaMCRqFzl
	 sEUpFvZHGMqNwwQh3I2jBLquhKBtrsM2Mz1NAeEdks/GUpG++y/dNqkANwKVNwbQsj
	 Y/jwfnwY1dv58fuNZpd1bLD0N4x//uzqGliUl6TFgb1SSpXvh5/zQqLESuZQVZwEL3
	 hCP4XQGuZxWYic1/3sto9Bi0ahAEwI7I+RD7pOFGRLnb3hHWTSQc53h42On08Uu25a
	 uY5o1KfkY5nhrAMwW4FG2uwhAeUxEnIlGfm2oegfQqEIXhWdED4MrYjst8ZheFOO14
	 0NrUlBpE9n3Cw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sAVmE-00FRdK-I3;
	Fri, 24 May 2024 15:20:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/3] KVM/arm64 fixes for AArch32 handling
Date: Fri, 24 May 2024 15:19:53 +0100
Message-Id: <20240524141956.1450304-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, nsg@linux.ibm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The (very much unloved) AArch32 handling has recently been found
lacking in a number of ways:

- Nina spotted a brown paper-bag quality bug in the register narrowing
  code when writing one of the core registers (GPRs, PSTATE) from
  userspace

- We never allowed System mode to be restored. Nobody ever complained,
  but this is wrong nonetheless

- The handling of traps failing their condition check went from dodgy
  to outright broken when the handling of ESR_EL2 was upgraded from 32
  to 64 bit (patch already posted).

All these are stable material, and I plan to merge them after -rc1
is released.

        M.

Marc Zyngier (3):
  KVM: arm64: Fix AArch32 register narrowing on userspace write
  KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
  KVM: arm64: AArch32: Fix spurious trapping of conditional instructions

 arch/arm64/kvm/guest.c       |  3 ++-
 arch/arm64/kvm/hyp/aarch32.c | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

-- 
2.39.2


