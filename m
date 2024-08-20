Return-Path: <kvm+bounces-24595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E91958397
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:06:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2940E1C233BF
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9C718DF95;
	Tue, 20 Aug 2024 10:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ni5Ig6jx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657E418D637;
	Tue, 20 Aug 2024 10:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148374; cv=none; b=Zi/MxYe7lXg7O7aPLZg5dNRzG3govQlL9QzbTOXKBcv3nj1lEwtPwehsgIeRxtHH9ZQ/jswXoYNRCcGs1avyFR28bZaxZQkSg5AmwRT90H1I0BLgpXK+lYNI8vn3iAk+5uQ41PtT1sa4RkgP1v+EsZSQHY15fMtl8Ah9RUu0orA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148374; c=relaxed/simple;
	bh=s6DwZrvfjDEG5/5UIRQDo131wlA6C66neRxQ2BfCud8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=loWTGOAGTR2kX+u/0LWu3s7DikDP6Q0tP8ySggkjy87AWJc8CrmJpuTCsoxZ+mgGp1NBvxflVd7f2AtHaDaeSi7c8/J90EdfQcrC+F7zsF7AnbqmVHyJDqFBJxmZvLWL3EYMJd79VRQJJLeboiubP6PXwBqMYKLfivPMhzQVaT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ni5Ig6jx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A1BC4AF17;
	Tue, 20 Aug 2024 10:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148373;
	bh=s6DwZrvfjDEG5/5UIRQDo131wlA6C66neRxQ2BfCud8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ni5Ig6jxXvK4j/m9SixjQmWyCfezsMapVZlzQA8MV/nd5/7Futnkis4m2uNP4YccP
	 gUgc2225cP3iz/9DKNj0Ghs8rmszjwaSEj/YjcGG3mCpULFsCQyjhp2E8js86kPEbo
	 4r70vMIsMYiuUnUAN/7zT6a/AC09W4hOc8p+fLY2ZJO52J7k9y+CqEglJLQhJmPa9d
	 JmBe1UgxfDJsw4Jj426POSItTSoOWXPAweYs37lPldo+5BeZihoLIBsbKRz0HNt75L
	 QT+DwhXBJtQFaySjXq7C5gXxx3t+4pvZy5pk+GDTjGlYhzFqRzDUAnl8+D1Ri4LCt9
	 Ujn1gU2LrXmXA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLkh-005Dk2-SR;
	Tue, 20 Aug 2024 11:06:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 05/12] KVM: arm64: Add helper for last ditch idreg adjustments
Date: Tue, 20 Aug 2024 11:03:42 +0100
Message-Id: <20240820100349.3544850-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820100349.3544850-1-maz@kernel.org>
References: <20240820100349.3544850-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We already have to perform a set of last-chance adjustments for
NV purposes. We will soon have to do the same for the GIC, so
introduce a helper for that exact purpose.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c      | 10 +++++-----
 arch/arm64/kvm/nested.c   | 15 +++++----------
 arch/arm64/kvm/sys_regs.c | 23 +++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.h |  2 ++
 4 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9bef7638342e..fc46457d38d6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -46,6 +46,8 @@
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
 
+#include "sys_regs.h"
+
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
 
 enum kvm_wfx_trap_policy {
@@ -821,11 +823,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	if (vcpu_has_nv(vcpu)) {
-		ret = kvm_init_nv_sysregs(vcpu->kvm);
-		if (ret)
-			return ret;
-	}
+	ret = kvm_finalize_sys_regs(vcpu);
+	if (ret)
+		return ret;
 
 	/*
 	 * This needs to happen after NV has imposed its own restrictions on
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index bab27f9d8cc6..e2067c594e4a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -954,19 +954,16 @@ static void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
 int kvm_init_nv_sysregs(struct kvm *kvm)
 {
 	u64 res0, res1;
-	int ret = 0;
 
-	mutex_lock(&kvm->arch.config_lock);
+	lockdep_assert_held(&kvm->arch.config_lock);
 
 	if (kvm->arch.sysreg_masks)
-		goto out;
+		return 0;
 
 	kvm->arch.sysreg_masks = kzalloc(sizeof(*(kvm->arch.sysreg_masks)),
 					 GFP_KERNEL_ACCOUNT);
-	if (!kvm->arch.sysreg_masks) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!kvm->arch.sysreg_masks)
+		return -ENOMEM;
 
 	limit_nv_id_regs(kvm);
 
@@ -1195,8 +1192,6 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
 		res0 |= ~(res0 | res1);
 	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
-out:
-	mutex_unlock(&kvm->arch.config_lock);
 
-	return ret;
+	return 0;
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 257c8da23a4e..bc2d54da3827 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4620,6 +4620,29 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	mutex_unlock(&kvm->arch.config_lock);
 }
 
+/*
+ * Perform last adjustments to the ID registers that are implied by the
+ * configuration outside of the ID regs themselves, as well as any
+ * initialisation that directly depend on these ID registers (such as
+ * RES0/RES1 behaviours). This is not the place to configure traps though.
+ *
+ * Because this can be called once per CPU, changes must be idempotent.
+ */
+int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	if (vcpu_has_nv(vcpu)) {
+		int ret = kvm_init_nv_sysregs(kvm);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 int __init kvm_sys_reg_table_init(void)
 {
 	bool valid = true;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 997eea21ba2a..7c9b4eb0baa6 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -235,6 +235,8 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 
 bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index);
 
+int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu);
+
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x
 #define Op1(_x) 	.Op1 = _x
-- 
2.39.2


