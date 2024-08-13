Return-Path: <kvm+bounces-23970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68B1295020F
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 248E2286F8A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8771219D06B;
	Tue, 13 Aug 2024 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRC/4bmT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B182719CD01;
	Tue, 13 Aug 2024 10:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543586; cv=none; b=j043kRr60/jsQxP5ZWCwjKh/hc7izUAE3OI/kQTjfQ182rnUuW2ZmO7Loo7JWDyl1KqC+oRdPCC6GE3vOAy4XD+MtfRXMuxbAhSSZX4GMOBBJ1QB5LciFJtMEVtBLRQelBJdGbWbxrMk+37Zo1M+acl9r4wfUBuCFH6PYWentVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543586; c=relaxed/simple;
	bh=k5pYh1Yp0jxWFeMrnF7ay2rjkHNJ1NpYhUlOrVS5zOE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ihyUQCxedCUXJCTE28bVZ4BpVJLCLBr7vKewW5WizLrS03gKc4PpDbtTRAyeaXsdnOYsNeBX0RMy0SBFysxzD3FM4hNCf2we26r+DNT+m0pXw7KLGAt1niawSPSlcrLa2kBUCDKtyfafxGo4HP7swQF0UelBwS/ZBK3Qb3uF/9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRC/4bmT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6ABC4AF0B;
	Tue, 13 Aug 2024 10:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543586;
	bh=k5pYh1Yp0jxWFeMrnF7ay2rjkHNJ1NpYhUlOrVS5zOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRC/4bmTLyuwuolk24h8yGyazcih61qk3FA3U81mB3P4P6iCtXl7pc877i74eExNQ
	 lwsAMXihYCyGN2NYFJJJ81g8Y8cCq0PF6FXaeSFoYu+9Z1WadfUnahvgcjLKHjNXCD
	 SxaQr6oEBkEh4nOTKpyFhltmAaWOAgHzJKHLnaMBLkdR0kw0fFOVGKERAKlbw9HKly
	 MH9QMkiBrMk+EI9+q578Y3qtJX1c7HXJHzIy0wxJhcwObTUEwMjch00CGuygVDdkTA
	 YFXFCDQ00K2RdRBKkexmPoSyb1cV7PEz2IKy1ye4X+M9t2I0zpHsB5ZSGxdxRZAa8K
	 HD6fd9KLJAnqw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ4-003INM-GQ;
	Tue, 13 Aug 2024 11:06:24 +0100
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
Subject: [PATCH v3 15/18] KVM: arm64: nv: Sanitise SCTLR_EL1.EPAN according to VM configuration
Date: Tue, 13 Aug 2024 11:05:37 +0100
Message-Id: <20240813100540.1955263-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
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

Ensure that SCTLR_EL1.EPAN is RES0 when FEAT_PAN3 isn't supported.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9c8573493d80..133cc2f9530d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1178,6 +1178,14 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
 		res0 |= ~(res0 | res1);
 	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
+
+	/* SCTLR_EL1 */
+	res0 = SCTLR_EL1_RES0;
+	res1 = SCTLR_EL1_RES1;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
+		res0 |= SCTLR_EL1_EPAN;
+	set_sysreg_masks(kvm, SCTLR_EL1, res0, res1);
+
 out:
 	mutex_unlock(&kvm->arch.config_lock);
 
-- 
2.39.2


