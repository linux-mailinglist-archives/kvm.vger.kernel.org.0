Return-Path: <kvm+bounces-25751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5915D96A2F1
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 751331C23A88
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18364189533;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJWTojUM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B192187552;
	Tue,  3 Sep 2024 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377921; cv=none; b=AEVUYkHFhvE/4R6eEqANn+eD9Ynj5AeEapiyaN9JCErmTVLkAAR2LiPw/vckqbAdhf12xDytqW4jqMJ0awf9qt6Qrgoj7u3FUgnIG5SOyty/CziNtFzB5fDjqYoK0GCp/ZM/5F7c+zyMWiEqc3tixN1MsLU1tyZFz9tDtdzhhBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377921; c=relaxed/simple;
	bh=XrW/cKYLr+6PTjBoU7yH2dU4ZzW4CFoX1auS2BCTSnM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E9oZs4n6KPm8grzS2Ya0Txrp9K8n98rKsTX3A19KNkEEoE+aay6pydK6nPWryUwDp8D9pn/mayjuGqX+HTn2X44PkCMWOfMAe1zF9FTpNeRAoO6vtWEMLDCJRm0hHsWh/QjzLVWLwbO13opMd8/2OuFFB1T0E4S1NtqW/tb7rug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJWTojUM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB69AC4CEC8;
	Tue,  3 Sep 2024 15:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377920;
	bh=XrW/cKYLr+6PTjBoU7yH2dU4ZzW4CFoX1auS2BCTSnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJWTojUM2pP/Qdzpy8Apm7ev5ENIEg0NwT/ZoqJy+o2SSt+hw2sR1xlaoy/v1v162
	 9RkXB3Dli31SHZt8mo7i2q3ivBECAh03/tkA0DsfFEbKGBgE2GN0tbMdiYkbTdYkPX
	 ZtdzEr7RLW/wR+SDwqeXRflBHbvyQJULuwV00Pu5WRIe8m2wxGPaUVhEEYo5YZJoI4
	 g/C+GyBJ/Q5lYU/OqgffWWMrMtX37Da0X296WNTVQF95xSRmBPUisbWCyLFi5rDXzc
	 Menr6O8fRPGjncgdUlkVhHkGwxN6tVXtfKuzPil51y51oQ0emH2QtpOISpiDfckswW
	 FEfhxx5MGt9Pg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc6-009Hr9-Ml;
	Tue, 03 Sep 2024 16:38:38 +0100
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
Subject: [PATCH v2 01/16] KVM: arm64: nv: Handle CNTHCTL_EL2 specially
Date: Tue,  3 Sep 2024 16:38:19 +0100
Message-Id: <20240903153834.1909472-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240903153834.1909472-1-maz@kernel.org>
References: <20240903153834.1909472-1-maz@kernel.org>
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
index 5ab0b2799393..7563826f286a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -140,6 +140,21 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
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
@@ -190,6 +205,19 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
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
index c819c5d16613..fd650a8789b9 100644
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


