Return-Path: <kvm+bounces-24636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFFF59587B8
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F7A51F22CE8
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30A91917FA;
	Tue, 20 Aug 2024 13:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3oUGGqa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69704190670;
	Tue, 20 Aug 2024 13:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724159889; cv=none; b=BKlcgF3wrkl6LjbGfDqoM7mRXSEAgCqa5oZbwuEfuAyR7o2qI51l39vEt+NLtOj8fwenJQeblDAu+fxWTXziENa/G+wXOhj7nOBJbFdAqrk6SR/oqXupgVRad0oJhqD1AGz20FfrfaZpXAN1KehqLs3sOBlCEAt3RFEoM+nTaIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724159889; c=relaxed/simple;
	bh=c3Z1JxPnPDc0JyvzdjgMda935deX6eK6ajc0Q+Qvets=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kYvtNClYsX0O2OOM6Us14077AqvqpSnlOWb2q0Ty1qK23LD07FkQW5HS9qC9u29THL96DOFPyrjm15+snieBlMFWxK4aAkHClUGeG8AX7ZwVb+W14J/KY2+7Bv/A0SZ1g2Tzb9EyK3HG1JPmE1KocgyKcS1xLttv6b6nxc7xub4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3oUGGqa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05488C4AF0C;
	Tue, 20 Aug 2024 13:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724159889;
	bh=c3Z1JxPnPDc0JyvzdjgMda935deX6eK6ajc0Q+Qvets=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3oUGGqa9JMkDJxqUXk/CcBrIuxgjMWcBc9qmIxU6Nq5JjKDLBW2+EJZ7F6OlZqMU
	 2F308LEUA0WiSLyqNVLEU+PChu0YG4v/lQRnDSwflYiEenxT0IRwfyT74z4ByryWWu
	 aJH0kGPfDKz+unolps36LKFZc0sq4LULPAcQha6OLIgJPXh+s/fuWFACs8QEINbKsi
	 UN/o1VDz9oPfx+PQNsENz30yircLteHmcei6fr2Ub304dB+V6rpweIoi+J3CaL8aQp
	 wUHKOSD0sO5r8d3u+4hUSDaoLSvPD6SlehkquYq15kFIIDyviDjNyX5k8u0CZTq30S
	 rP97TWzutFUiQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgOkR-005HMQ-6n;
	Tue, 20 Aug 2024 14:18:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 6/8] KVM: arm64: Expose ID_AA64FPFR0_EL1 as a writable ID reg
Date: Tue, 20 Aug 2024 14:18:00 +0100
Message-Id: <20240820131802.3547589-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820131802.3547589-1-maz@kernel.org>
References: <20240820131802.3547589-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ID_AA64FPFR0_EL1 contains all sort of bits that contain a description
of which FP8 subfeatures are implemented.

We don't really care about them, so let's just expose that register
and allow userspace to disable subfeatures at will.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 79d67f19130d..4c2f7c0af537 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2386,7 +2386,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
 	ID_UNALLOCATED(4,6),
-	ID_UNALLOCATED(4,7),
+	ID_WRITABLE(ID_AA64FPFR0_EL1, ~ID_AA64FPFR0_EL1_RES0),
 
 	/* CRm=5 */
 	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
-- 
2.39.2


