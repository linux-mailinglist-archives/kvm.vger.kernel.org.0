Return-Path: <kvm+bounces-29538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 216B49ACDED
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50B121C21D5A
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B396B205AB4;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jlUVfOdN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88162010FF;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695235; cv=none; b=tGMNhfnan3aC73o0eqWKpK8l2/IAIxWQL8D5Un4mDJVkM7TgGsi1m477Hx/Oz/CKM1b+cbX0hQgZMbcTVHnxxMok/rmpn46R9UZBUj53bljy0tpxY6zvUxYXYFsFGBQz8MPck0fuEXvBV94Wiutovh98IxkcYoJZ3QD3WAtg6fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695235; c=relaxed/simple;
	bh=uJ4Rms5/TwwuLBnZE1CwoSIgCLvL2ISzaxDlkow7KA8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VH/1tLH+clg/abDENqe3CvXoa5fQZ0A8q6Npxe4bUZDaBNV2E/Ch1c0v4aE0yAKhFpte8jEG8kldykpCkZBvFdEknOW3HmjoWCfWKcfchA85aL6WJCSSsdV9d4I9lzmtd33KN5zTDG7xn2mqIHxzNPp92LQr3vBBZ4nbC+DsFdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jlUVfOdN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B7EC4CEC6;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695234;
	bh=uJ4Rms5/TwwuLBnZE1CwoSIgCLvL2ISzaxDlkow7KA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlUVfOdNyPY/qOawWIZvhAV90nbCbqna/z9BqryZaqBSAz4FVOtQRANHmDx9riq5c
	 ICQk+6GljfWtfxWEKmKLfn+IIXVtnyXoOr4s5pzVIX6QLmSQzzyw7tj6/5i6VbNHfp
	 TTeMXiQsub15FRvGOByP0Lm5ZY8jwSbpTgisGcIgJQU4BjTfJ851hozMzNVKlDg6lu
	 kfWl0gPKzilHBLepw9e978sRXAYgQtUjCnClwIb5kVZTM1Q+gNt6eDMxysva8yDzS/
	 z9zKOGg/fT3pS62NBbx8PE9VACdhKn4FN4R35B9mODoJCuguttHds5ysf1TFW+wz9c
	 xHpj/MszXrBYA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckC-0068vz-R7;
	Wed, 23 Oct 2024 15:53:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 16/37] KVM: arm64: Handle PIR{,E0}_EL2 traps
Date: Wed, 23 Oct 2024 15:53:24 +0100
Message-Id: <20241023145345.1613824-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the FEAT_S1PIE EL2 registers the sysreg descriptor array so that
they can be handled as a trap.

Access to these registers is conditional based on ID_AA64MMFR3_EL1.S1PIE
being advertised.

Similarly to other other changes, PIRE0_EL2 is guaranteed to trap
thanks to the D22677 update to the architecture.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a85f62baebfba..c42f09a67a7c9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -369,6 +369,18 @@ static bool access_rw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool check_s1pie_access_rw(struct kvm_vcpu *vcpu,
+				  struct sys_reg_params *p,
+				  const struct sys_reg_desc *r)
+{
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	return access_rw(vcpu, p, r);
+}
+
 /*
  * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
  */
@@ -2873,6 +2885,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
+	EL2_REG(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0),
+	EL2_REG(PIR_EL2, check_s1pie_access_rw, reset_val, 0),
 	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
-- 
2.39.2


