Return-Path: <kvm+bounces-24254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF1A952EA6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87DDD1C23A43
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 13:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD5719FA87;
	Thu, 15 Aug 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvRK+wAL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BE619DF97;
	Thu, 15 Aug 2024 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723726805; cv=none; b=owAtRtA1GPbbZvVRfiY6UNqf8nPIyUb/rR+iHBlMThxmuyvWazDZXLQKaAEu9MI6oU1uCNG1JSu3AXLJxBsgHj0PhU+H/sSb4w3tW0B3IX8gJ5DZbFb+vyTGw2pzfKhhbevLR/jdjxokcTxvypu+2/3iKXwRNiIQqIR1M0YvJEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723726805; c=relaxed/simple;
	bh=knD9A7RR7k7dMVag/IIKZfs9Lw12TkLZBEesnE10nOo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NU7m5y7Z+D6iFkCzRNcuMcZBoTaSV8K5U63d/LRqphzOyT+vZKlyXQXBJ85em3a3kYlmGqQXhQPj1HVJsn3TY9RAcRoq4Ui5TSz5pKalXPVkmlQj1pM/6BzVdJ8MBo/xeEXG3USD3rqmzjjC6RAYmiEmkMGypD1n7zM+EmHPVUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvRK+wAL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3029CC4AF10;
	Thu, 15 Aug 2024 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723726805;
	bh=knD9A7RR7k7dMVag/IIKZfs9Lw12TkLZBEesnE10nOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvRK+wALz4hW7ifjNRqAIPfJLWftvRDM60N0Fvie6ozLb6jGSKr+pS7hEFYZMC7JY
	 2z+1iGut81owXtFGPJ1QrNrqmholXgmtIwh/k8rsrUUT8bOn0jWZCYdo4q+XqxHOPM
	 ghcHv05TU7L7Yb4FiManOYVkrMV8LJ1Of+A+jnT+ilptClj2xNZmW1zud4eAhl9uP6
	 bquBuQwd/Fiy30Xy8r/26RVKZj16Q3UZVPtV+Fuq7rWG89W99XeaLlYBg+xsi5FmwY
	 bRY3YfG7rTUbx0KK5suuzkepDstEdKNre+XIF5EkqknqNtOoCJyBYdagywqf/O7cBe
	 98bQcQ8pX5KAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sea5D-003xld-8c;
	Thu, 15 Aug 2024 14:00:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 03/11] KVM: arm64: Add ACCDATA_EL1 to the sysreg array
Date: Thu, 15 Aug 2024 13:59:51 +0100
Message-Id: <20240815125959.2097734-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240815125959.2097734-1-maz@kernel.org>
References: <20240815125959.2097734-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make ACCDATA_EL1 a first-class citizen, and add it to the sysreg
array. Visibility is conditioned on the feature being enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f..25ee4e5f55f1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -446,6 +446,9 @@ enum vcpu_sysreg {
 	GCR_EL1,	/* Tag Control Register */
 	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
 
+	/* Random stuff */
+	ACCDATA_EL1,	/* Accelerator Data */
+
 	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..7b540811aa38 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2233,6 +2233,15 @@ static unsigned int sve_el2_visibility(const struct kvm_vcpu *vcpu,
 	return sve_visibility(vcpu, rd);
 }
 
+static unsigned int accdata_visibility(const struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *rd)
+{
+	if (kvm_has_feat(vcpu->kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
@@ -2519,7 +2528,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
 	{ SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
 
-	{ SYS_DESC(SYS_ACCDATA_EL1), undef_access },
+	{ SYS_DESC(SYS_ACCDATA_EL1), undef_access, reset_val, ACCDATA_EL1, 0,
+	  .visibility = accdata_visibility},
 
 	{ SYS_DESC(SYS_SCXTNUM_EL1), undef_access },
 
-- 
2.39.2


