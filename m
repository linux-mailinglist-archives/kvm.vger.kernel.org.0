Return-Path: <kvm+bounces-61863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 259AAC2D49D
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:56:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9EF7334B906
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269DC31C56E;
	Mon,  3 Nov 2025 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqWSnBGN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE9031A812;
	Mon,  3 Nov 2025 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188928; cv=none; b=LhSjwE0t2pear/2MNSBLbtKwEI1+c8Ca7j+tkR9zsYfCLa+HyV+PCoFSgdrKyNrkmwHQOyOY5ZwgaW21EzL2/XaQOfaoIGW38QHfrlamaGnrxl7IjzGBiQBXv7t4QWSUogBut54lrNTTjMi+eYpuKH2+AeLlI6qMQO7cyMB/Qbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188928; c=relaxed/simple;
	bh=uxqxONCxQb07aq+pAmmeWEuPks4VE/qou86gzLQIzEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZgE/lpZqQjbtUqjYegqcKXkVBZEONu4szRk4NT8xeEX73XSIAFZIGd54VzDLYqkImTZp7teZn5G3hRJdvsG2Cez5YbKFmGXjK/omXJYuY2eiwsysuKPWF6H6U1cjDfOpXY/x2Ag+owz37zbEMozFEMY8WGkipbgzN/Ey+vIlJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqWSnBGN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C183BC4CEFD;
	Mon,  3 Nov 2025 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188927;
	bh=uxqxONCxQb07aq+pAmmeWEuPks4VE/qou86gzLQIzEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqWSnBGNzJcBRBzAUZ7N9ddNmpqQDnWKmPtLqskVAYrv8BWtXpANnr4IxJjV0/TFM
	 WX/kfZS3cWPQ3C5CUzSAt2IdxLA+8/eH8+nO7yY9d/EKm5F3rdyZ10elHR5jeZTnlj
	 kVkk0gh5demfEZCjsRKrm2Cy2ZF3eGBbqHWs3B3nkugSxG7KyPm2gg2110Y1vdHrNt
	 G2Na3+T6OGjSwJsrlSn9J5zAfuwD6vv0jsSWxgs4daSThnaqz4aI1EjGB0WtOYxYHp
	 zE73W2ONuMIh7jQDOPst+4NJEvfU71oL5y6zO10FkVC8E4y8YBj7k8wsCmalz48HTI
	 Cwn59NYJJeX7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq1-000000021VN-3XtQ;
	Mon, 03 Nov 2025 16:55:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 05/33] KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping
Date: Mon,  3 Nov 2025 16:54:49 +0000
Message-ID: <20251103165517.2960148-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

A long time ago, an unsuspecting architect forgot to add a trap
bit for ICV_DIR_EL1 in ICH_HCR_EL2. Which was unfortunate, but
what's a bit of spec between friends? Thankfully, this was fixed
in a later revision, and ARM "deprecates" the lack of trapping
ability.

Unfortuantely, a few (billion) CPUs went out with that defect,
anything ARMv8.0 from ARM, give or take. And on these CPUs,
you can't trap DIR on its own, full stop.

As the next best thing, we can trap everything in the common group,
which is a tad expensive, but hey ho, that's what you get. You can
otherwise recycle the HW in the neaby bin.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/virt.h  |  7 ++++++-
 arch/arm64/kernel/cpufeature.c | 34 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/hyp-stub.S   |  5 +++++
 arch/arm64/kvm/vgic/vgic-v3.c  |  3 +++
 arch/arm64/tools/cpucaps       |  1 +
 5 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index aa280f356b96a..8eb63d3294974 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -40,8 +40,13 @@
  */
 #define HVC_FINALISE_EL2	3
 
+/*
+ * HVC_GET_ICH_VTR_EL2 - Retrieve the ICH_VTR_EL2 value
+ */
+#define HVC_GET_ICH_VTR_EL2	4
+
 /* Max number of HYP stub hypercalls */
-#define HVC_STUB_HCALL_NR 4
+#define HVC_STUB_HCALL_NR 5
 
 /* Error returned when an invalid stub number is passed into x0 */
 #define HVC_STUB_ERR	0xbadca11
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5ed401ff79e3e..44103ad98805d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2303,6 +2303,31 @@ static bool has_gic_prio_relaxed_sync(const struct arm64_cpu_capabilities *entry
 }
 #endif
 
+static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
+				 int scope)
+{
+	struct arm_smccc_res res = {};
+
+	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDS <= ARM64_HAS_GICV3_CPUIF);
+	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDS <= ARM64_HAS_GICV5_LEGACY);
+	if (!cpus_have_cap(ARM64_HAS_GICV3_CPUIF) ||
+	    !cpus_have_cap(ARM64_HAS_GICV3_CPUIF))
+		return false;
+
+	if (!is_hyp_mode_available())
+		return false;
+
+	if (is_kernel_in_hyp_mode())
+		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
+	else
+		arm_smccc_1_1_hvc(HVC_GET_ICH_VTR_EL2, &res);
+
+	if (res.a0 == HVC_STUB_ERR)
+		return false;
+
+	return res.a1 & ICH_VTR_EL2_TDS;
+}
+
 #ifdef CONFIG_ARM64_BTI
 static void bti_enable(const struct arm64_cpu_capabilities *__unused)
 {
@@ -2814,6 +2839,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_gic_prio_relaxed_sync,
 	},
 #endif
+	{
+		/*
+		 * Depends on having GICv3
+		 */
+		.desc = "ICV_DIR_EL1 trapping",
+		.capability = ARM64_HAS_ICH_HCR_EL2_TDS,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = can_trap_icv_dir_el1,
+	},
 #ifdef CONFIG_ARM64_E0PD
 	{
 		.desc = "E0PD",
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 36e2d26b54f5c..ab60fa685f6d8 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -54,6 +54,11 @@ SYM_CODE_START_LOCAL(elx_sync)
 1:	cmp	x0, #HVC_FINALISE_EL2
 	b.eq	__finalise_el2
 
+	cmp	x0, #HVC_GET_ICH_VTR_EL2
+	b.ne	2f
+	mrs	x1, ich_vtr_el2
+	b	9f
+
 2:	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	3f
 	mov	x0, x2
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 236d0beef561d..e0c6e03bf9411 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -648,6 +648,9 @@ void noinstr kvm_compute_ich_hcr_trap_bits(struct alt_instr *alt,
 		dir_trap = true;
 	}
 
+	if (!cpus_have_cap(ARM64_HAS_ICH_HCR_EL2_TDS))
+		common_trap = true;
+
 	if (group0_trap)
 		hcr |= ICH_HCR_EL2_TALL0;
 	if (group1_trap)
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 1b32c1232d28d..77f1bd230722d 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -40,6 +40,7 @@ HAS_GICV5_CPUIF
 HAS_GICV5_LEGACY
 HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
+HAS_ICH_HCR_EL2_TDS
 HAS_HCR_NV1
 HAS_HCX
 HAS_LDAPR
-- 
2.47.3


