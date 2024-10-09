Return-Path: <kvm+bounces-28316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 172DF997538
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40AA31C2250E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73ACB1E282B;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TI2Djvuy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC44B1E1A29;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500443; cv=none; b=WVFhOaQHBsrTULAQ0XhvOSaWydIpBxbHj3Asl62LjEYXJ2qw2Uj/A/xAxfpFY/xca3g6PgHBAzQjl87W3Cqo4c29iYJ+e0aB8ICFxKD5D2cSOGaSV+QnVNRkX8Jc1LTxm7Lm/ts+Jr1p7vb6fCjcD62EUEM94n8ugPjo4PRzw0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500443; c=relaxed/simple;
	bh=OpE1g1dXxLnO5r+wMmDCsiL9pglyj4L3QL+7VK1XQcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P5vK0COKCgZPTb97qwwKm9TfR9Qp6exUKLeF37awqWz8Ue5NmdUq6p89lZHsnTMu2uEwSsewt1jUISGSItg/vuARTkM6YISO4DWgs3vEQxCbG7Q0kCUrUj/M4TYby+7BRhFJvSMn11pDtfya3PxI5M09NKyBp650JfJ/sZwRfFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TI2Djvuy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E42C4CECC;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500443;
	bh=OpE1g1dXxLnO5r+wMmDCsiL9pglyj4L3QL+7VK1XQcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TI2DjvuyxL++VMijuizoWJO0ikf+NEzDOj8r6dO/mgwI8iCaL1WATmUyWDM9MDJDp
	 29UWwnE7kGeMNbJMHZ+GgMFPy5zHSpfbAwDQ+fOjmj5cuySPQ5TdDDf8u4woBqooZW
	 YCCawanJNjH4bybcy+tdWbdCiaPlOxN2k5RA3+ZX9pO2pjZKeJ1qAzybekadCfIuOk
	 KLDH+7cSZB/9/6g/LusANySEzfBjN0d4PClChLReqo6/R8bfx7JQQDFnL6skKIdPxw
	 E2G5PpR7A6y3CgihQzegCsY+RIOocfvr8dl62f8EXVFK1HkWauY6WbluB6gFU8fyaC
	 vqpXsBBS4wiPQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvN-001wcY-Pq;
	Wed, 09 Oct 2024 20:00:41 +0100
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
Subject: [PATCH v4 06/36] KVM: arm64: nv: Handle CNTHCTL_EL2 specially
Date: Wed,  9 Oct 2024 19:59:49 +0100
Message-Id: <20241009190019.3222687-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
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


