Return-Path: <kvm+bounces-24003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC86695081A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 846E4B2264E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 14:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5E41A01C4;
	Tue, 13 Aug 2024 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lm42YvMY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182381D68F;
	Tue, 13 Aug 2024 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560479; cv=none; b=HM7FqfXjHS7hDuOwFv9Tg8psgXXQ15RYLJiRWwd0DD7+tKAj8nDtf/FoMQE7IM4ccTlL/Y8oWQwSuOmvGpdxnTcPkCQvHm1oopxGJmK/HKwUPNY1zo28mFdgG7elNbsLHj62y2N9H8vVOJOJd8Vhl1y4aYtI+7nXP26XOj9rETA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560479; c=relaxed/simple;
	bh=/44hNubfAJPoo02XSxaPr9+x1CFGhuefxVXsc2EW9QQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ut1arZXJI8eFw8CdjT1gA1/fHIKgmzy+rjSiEhh23TVv2srm1ir1fO0Ptri6fZnuS9JNVmN0jPd2MJl1amblMo4kig+8mUZKMFKCQDn+HwkV0FBpnpOJFdVU8J0YlGWto15IzvnmIYZ1bsa84KF0SNv0dXs3AfKQMBYago9X7KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lm42YvMY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A890EC4AF0F;
	Tue, 13 Aug 2024 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723560478;
	bh=/44hNubfAJPoo02XSxaPr9+x1CFGhuefxVXsc2EW9QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm42YvMY/V/0fQfMmYVV8Edn24AkcsvAv93AsDpQCZc5R2j9H0gcw5BxxJqODy1Rb
	 nQRvbz86dE2sOTZnhbLtUyUNp437A++RSXsgaNMaq1sW67fOGaeMVQUBPDH/3wFEsP
	 cMFQc4ZP0OhuzPyBBv7h/MBmv0CKrI/2FQAwzP078qO9kmiE7kqUNgjLtqG4dkNhEL
	 +u3MaEg9RVNfOPxJegv3H2mpZ0mAQnb9MqYucc4EHIMAsOmBLw30VRTKw2JtuT87Nv
	 FRDFJzFiJs73PS/+0Nwc0ZW0/KOnU0Y05pQpTcfUKs6tkyKdmpH/rLzQecuQCR2d7Q
	 v6ikXH9ku7HTw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdsoW-003O27-P4;
	Tue, 13 Aug 2024 15:47:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 03/10] KVM: arm64: Add TCR2_EL2 to the sysreg arrays
Date: Tue, 13 Aug 2024 15:47:31 +0100
Message-Id: <20240813144738.2048302-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813144738.2048302-1-maz@kernel.org>
References: <20240813144738.2048302-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the TCR2_EL2 register to the per-vcpu sysreg register
array, as well as the sysreg descriptor array.

Access to this register is conditionned on ID_AA64MMFR3_EL1.TCRX
being advertised.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f..5a9e0ad35580 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -462,6 +462,7 @@ enum vcpu_sysreg {
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
+	TCR2_EL2,	/* Extended Translation Control Register (EL2) */
 	SPSR_EL2,	/* EL2 saved program status register */
 	ELR_EL2,	/* EL2 exception link register */
 	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 95832881fd66..52250db3c122 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -436,6 +436,18 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_tcr2_el2(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	return access_rw(vcpu, p, r);
+}
+
 static bool access_actlr(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
@@ -2783,6 +2795,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
+	EL2_REG(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
 
-- 
2.39.2


