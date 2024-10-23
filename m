Return-Path: <kvm+bounces-29527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9E69ACDE1
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 056531F22A7C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA882010EC;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLY9y0HZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71431C9B71;
	Wed, 23 Oct 2024 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695232; cv=none; b=rAljZ60JcGUMo7U9hGTZkwu5lnSlUj1pewM+k3LJhZR2pYO8nnOmbbTLRf7wJvfaFdUSELOuD8QMLH8DNNWz4bSruCGZ9B6p6JiSHZkx3d13LF/QVsbwwQTk51QaWbTIZXSDogSSzsAMIrfGBASTsSWc46F55OJJJkJA+M45ZY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695232; c=relaxed/simple;
	bh=OpE1g1dXxLnO5r+wMmDCsiL9pglyj4L3QL+7VK1XQcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JnJVJk6iVyZRzD6nLXjFkTb2+KIHp9aRMltknHWhzQeLVo2efu98rR7jqwK40zu5vtGbP2NjO/b8dFPXJlYHHWx81UCJpvWiQFcnJKjlJFwEc1WOQnARKE+A+ssnJlCkYdzYI+wi7CGxg4YPDzYaCarVdGhtX0Rt2uzBT9pzci0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLY9y0HZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0F6C4CEEA;
	Wed, 23 Oct 2024 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695232;
	bh=OpE1g1dXxLnO5r+wMmDCsiL9pglyj4L3QL+7VK1XQcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLY9y0HZDVBCHlMKE1/lmPlw7TDpuyoy6w6eXfNDPLlp+Ojh8scPg7jaIAmAt9Ogk
	 sXpWannjN/2WmZtad+xMRQ3wq188JPrQSexpqshjlDTbKlPPm4iE6dLmfmhix1PeDB
	 kyb0+IaXsXMsrIGalOuS9BNxnHo0eH+gZtkJ3tAEx3p8GPHKSxNLaICoSkGYMicoHN
	 R/YfXllqu6KUY9r83iXk7lBj6Z4aANpFr9897T2sW1OEf7qQM+MdIrfcR22Fw3zvMV
	 DVrhYEf9nA8YfTgI4lu+R+NTxqcqoNyd32GIke8sbKtVjN4qrrKaERN/5Ae5DTHJ80
	 Xnn/uCIaZfvBA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckA-0068vz-M9;
	Wed, 23 Oct 2024 15:53:50 +0100
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
Subject: [PATCH v5 06/37] KVM: arm64: nv: Handle CNTHCTL_EL2 specially
Date: Wed, 23 Oct 2024 15:53:14 +0100
Message-Id: <20241023145345.1613824-7-maz@kernel.org>
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

Accessing CNTHCTL_EL2 is fraught with danger if running with
HCR_EL2.E2H=1: half of the bits are held in CNTKCTL_EL1, and
thus can be changed behind our back, while the rest lives
in the CNTHCTL_EL2 shadow copy that is memory-based.

Yes, this is a lot of fun!

Make sure that we merge the two on read access, while we can
write to CNTKCTL_EL1 in a more straightforward manner.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c    | 28 ++++++++++++++++++++++++++++
 include/kvm/arm_arch_timer.h |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3cd54656a8e2f..932d2fb7a52a0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -157,6 +157,21 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 		if (!is_hyp_ctxt(vcpu))
 			goto memory_read;
 
+		/*
+		 * CNTHCTL_EL2 requires some special treatment to
+		 * account for the bits that can be set via CNTKCTL_EL1.
+		 */
+		switch (reg) {
+		case CNTHCTL_EL2:
+			if (vcpu_el2_e2h_is_set(vcpu)) {
+				val = read_sysreg_el1(SYS_CNTKCTL);
+				val &= CNTKCTL_VALID_BITS;
+				val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
+				return val;
+			}
+			break;
+		}
+
 		/*
 		 * If this register does not have an EL1 counterpart,
 		 * then read the stored EL2 version.
@@ -207,6 +222,19 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 		 */
 		__vcpu_sys_reg(vcpu, reg) = val;
 
+		switch (reg) {
+		case CNTHCTL_EL2:
+			/*
+			 * If E2H=0, CNHTCTL_EL2 is a pure shadow register.
+			 * Otherwise, some of the bits are backed by
+			 * CNTKCTL_EL1, while the rest is kept in memory.
+			 * Yes, this is fun stuff.
+			 */
+			if (vcpu_el2_e2h_is_set(vcpu))
+				write_sysreg_el1(val, SYS_CNTKCTL);
+			return;
+		}
+
 		/* No EL1 counterpart? We're done here.? */
 		if (reg == el1r)
 			return;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index c819c5d16613b..fd650a8789b91 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -147,6 +147,9 @@ u64 timer_get_cval(struct arch_timer_context *ctxt);
 void kvm_timer_cpu_up(void);
 void kvm_timer_cpu_down(void);
 
+/* CNTKCTL_EL1 valid bits as of DDI0487J.a */
+#define CNTKCTL_VALID_BITS	(BIT(17) | GENMASK_ULL(9, 0))
+
 static inline bool has_cntpoff(void)
 {
 	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
-- 
2.39.2


