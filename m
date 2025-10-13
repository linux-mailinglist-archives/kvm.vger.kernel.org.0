Return-Path: <kvm+bounces-59878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 70DDDBD2102
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 10:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D9C564EE126
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFCF92F6194;
	Mon, 13 Oct 2025 08:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pT6kW/yC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0106B2F5472;
	Mon, 13 Oct 2025 08:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760344339; cv=none; b=YCeH0CIxVMhdRfMDB10X8pgMu8tVo0jQ1/fvgmYlXTktmLK9/DuDsIL+T5S0j+gjfKB7Ob16n8J42OJEx9meAKK1bmmU8rKN9tqYUoS4QI/mmKPFjt6Kr4hOroop4gfyBioDs9A7Nm4mJizi5DMJrZud1Az1LR6RouyNnYVAB+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760344339; c=relaxed/simple;
	bh=/r+3j0SKLRbol6b7Xk7E08I5lDJ39fKkIbvrxbt9VW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LsByHbXi01IkRVXcpKbSyEZ9aAQM7oMjr1ayeAMkGOTVjzNah6bME4/4WFBWXz66dt3dSmKC8XyY6jtCfZYoPZt8cDoADJ9zdTX+27i3Ia1Jc9b74BwjvWn2tmo5Y0G8jj1P0q22HhrjXKuJiyhoFkqYfw/fiPkQpVcBptqbKKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pT6kW/yC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FC1C4CEE7;
	Mon, 13 Oct 2025 08:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760344338;
	bh=/r+3j0SKLRbol6b7Xk7E08I5lDJ39fKkIbvrxbt9VW0=;
	h=From:To:Cc:Subject:Date:From;
	b=pT6kW/yC/Ig0omWUPcmGNTGFRBBXXAJUfyHWDC9NnpkJvGYeWNLjznPjQMpcTpUuR
	 5TBrC8O1347fgAE+GJb3MqYttL52FJMkwJ/T63OQrs6PV7Nb3AkVN4e2Xj7eaV2/6w
	 rTwN9zlyfqQTwN5k6wjVKAv2Fnoek/LO6DcOtuh/kiC9P5xIrc6hGupJt3579Cir4K
	 2EO9R/H+tvfjl6VvrHOiqNPFVoS/x7iagqY6X/iPnNjfjFtFUePi4ibV2J8z3M3q/M
	 zi0fPyEL53yqoX237As6mE+HC397mJzkasuihdYlRY5cm/pPt+MWe1vc9prLPqpDn0
	 3Mk6oP2G6qcXw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8Dya-0000000DRrP-2UGy;
	Mon, 13 Oct 2025 08:32:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 0/3] KVM: arm64: Fix handling of ID_PFR1_EL1.GIC
Date: Mon, 13 Oct 2025 09:32:04 +0100
Message-ID: <20251013083207.518998-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Peter reported[1] that restoring a GICv2 VM fails badly, and correctly
points out that ID_PFR1_EL1.GIC isn't writable, while its 64bit
equivalent is. I broke that in 6.12.

The other thing is that fixing the ID regs at runtime isn't great.
specially when we could adjust them at the point where the GIC gets
created.

This small series aims at fixing these issues. I've only tagged the
first one as a stable candidate. With these fixes, I can happily
save/restore a GICv2 VM (both 32 and 64bit) on my trusty Synquacer.

[1] https://lore.kernel.org/r/CAFEAcA8TpQduexT=8rdRYC=yxm_073COjzgWJAvc26_T+-F5vA@mail.gmail.com

Marc Zyngier (3):
  KVM: arm64: Make ID_PFR1_EL1.GIC writable
  KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured
  KVM: arm64: Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace
    irqchip

 arch/arm64/kvm/sys_regs.c       | 12 ++++++++----
 arch/arm64/kvm/vgic/vgic-init.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 6 deletions(-)

-- 
2.47.3


