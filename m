Return-Path: <kvm+bounces-26528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC1A9754B7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDFF11C22F7D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2041ABED6;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HrIOgC5b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B113B1AAE1E;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062721; cv=none; b=ntxfqouP2KrexescwAy4QVqxjzdHAGre72pXbs+BN8XMN14ZoBM3VczqJ0rh7YJFdO6qxWBYtA81L81cFE1+tMT8JW19eRhc80Il8KrBGRvmBkCawkMIMmqAfkcHuxbIBF3JzkqQTFegZ3K3CUPpdw5z4rSOEj7Mm88qBojOn9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062721; c=relaxed/simple;
	bh=+yWXTlkyNh9DGnM2EE+8vyShwZ/LmaWgUS9BwEYwMk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HVdedHRtnombol0SY6iTPq7RxKg59sZ/YwIyJeZaMovnKurq8ZoGgPnyPnueco4qiaffyjI2VJpsyuRo6yycR5BeaiwVFWFdTwnIUm9Y3MS1nlZVbzv9M649fDsTWYz/l6FyVtRexyBwQUhxSV82AwmknUxzW2mOhfDWqaoTH7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HrIOgC5b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2628AC4CEC0;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062721;
	bh=+yWXTlkyNh9DGnM2EE+8vyShwZ/LmaWgUS9BwEYwMk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrIOgC5bFRs9x0G6A6FkDDQ/N9bJObrm4k9VL8RzJdWFte4NDnPat3DA3l+v1D+na
	 DF5UTbTxRe4gOX7n82Z4nFcAY+Sd7yPYx5NkykPjq1uFFWpzUBUyuwxlJ1nCWPD+MX
	 3kv3tnS0PpQiS+tq7r+Y5KPm8oLwCazQvTBJsedEDxG5+9wGMMpmyHbRkZkfV4lM+9
	 TjTKGjZv/7vWmlUfL+jFLy7FlDvD6U+s3SgGcqLM8JRWq+kjw3qLWsptUIrag8a0OJ
	 dX6ZjjduIYG150IvCDCHWYk7z9eXm9r7IklcDcBCsMfv2FBUiJdYllLrIOc3zdlUil
	 NqSVt7zGDnKEA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlH-00C7tL-Aj;
	Wed, 11 Sep 2024 14:51:59 +0100
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
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 15/24] KVM: arm64: Handle PIR{,E0}_EL2 traps
Date: Wed, 11 Sep 2024 14:51:42 +0100
Message-Id: <20240911135151.401193-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
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
index c109f9c8c5c64..81c7099a7a825 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -361,6 +361,18 @@ static bool access_rw(struct kvm_vcpu *vcpu,
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
@@ -2842,6 +2854,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
+	EL2_REG(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0),
+	EL2_REG(PIR_EL2, check_s1pie_access_rw, reset_val, 0),
 	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
-- 
2.39.2


