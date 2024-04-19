Return-Path: <kvm+bounces-15229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F044C8AACD0
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC1F42826A7
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C7CA7F46C;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QENCkbaa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3177E7E118;
	Fri, 19 Apr 2024 10:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522592; cv=none; b=K9y1fL9HKYk3r2EMgmHk3yggbDkvvECEw+kogW3HGg5UkcJPogzbVcBu5d7zDdio6li/6Q3sr72s9WyK3K4bvxCc+Ifk+e0ob7dg41pG8oF9VgmNQCMnEr852/fdQHVYQMIy/mW4WuLYs9V5xJiyynvWX5/MXyWjTB0vShm3QRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522592; c=relaxed/simple;
	bh=jcT2AAMivrMamGwKhwibZMsBtTKuKUz+xyxpJw2vBKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p3TSEEUdNqOlb/9qN2QJ+4rOHY/xrnvhI9sfyu6bcVxNKrF6uDS5boMlIkh0pW69t19Ngh0yGtzVKnL2URIwUnJXq38nWSLM7/ExL8hfBoKvlB+qjWGBwCVf3CFX9LydRYM4xzitDhbI43ueQxcPyOIGhCVRtkaQPVOvyTfyiIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QENCkbaa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDA0C4AF09;
	Fri, 19 Apr 2024 10:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522591;
	bh=jcT2AAMivrMamGwKhwibZMsBtTKuKUz+xyxpJw2vBKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QENCkbaa5mfk/0RzuthjoiFjs8B4WlTUxdNtLnVFY1pJUmY7QEGQSRFLhN6tUCE9B
	 6x9bb19i9zvxXsSnfzhWGvg/wmG6PgxDCkH2RdVynT1VMDNgxEErIpM/dhZmdz/rsr
	 DuIbWLZCewu9tG5SLEJqZ7kngrQAJubphxyeZ7/ur11+cOqDucKG+OceXLhCOUBuPU
	 73jYwde/6aiMReNWMWPIVhSkr+YpjteXzFxXkmcB2mkCGfzJ+r0PVWh+EaWVALtQxR
	 e8u2C19nNyijWMki04IpEFebuOokmeUDNp/NtH6cF+j4S+zEwU95jlqC2pzR/iVMcg
	 kzJgfSXiTfBQg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV8-00636W-1F;
	Fri, 19 Apr 2024 11:29:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 05/15] KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
Date: Fri, 19 Apr 2024 11:29:25 +0100
Message-Id: <20240419102935.1935571-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the HCR_EL2 configuration for FEAT_NV2, adding the required
bits for running a guest hypervisor, and overall merging the
allowed bits provided by the guest.

This heavily replies on unavaliable features being sanitised
when the HCR_EL2 shadow register is accessed, and only a couple
of bits must be explicitly disabled.

Non-NV guests are completely unaffected by any of this.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +--
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 35 ++++++++++++++++++++++++-
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e3fcf8c4d5b4..f5f701f309a9 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -271,10 +271,8 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	__deactivate_traps_hfgxtr(vcpu);
 }
 
-static inline void ___activate_traps(struct kvm_vcpu *vcpu)
+static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
 {
-	u64 hcr = vcpu->arch.hcr_el2;
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
 		hcr |= HCR_TVM;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c50f8459e4fc..4103625e46c5 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -40,7 +40,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
-	___activate_traps(vcpu);
+	___activate_traps(vcpu, vcpu->arch.hcr_el2);
 	__activate_traps_common(vcpu);
 
 	val = vcpu->arch.cptr_el2;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 07fd9f70f870..6b82f0907882 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -33,11 +33,44 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+/*
+ * HCR_EL2 bits that the NV guest can freely change (no RES0/RES1
+ * semantics, irrespective of the configuration), but that cannot be
+ * applied to the actual HW as things would otherwise break badly.
+ *
+ * - TGE: we want the guest to use EL1, which is incompatible with
+ *   this bit being set
+ *
+ * - API/APK: for hysterical raisins, we enable PAuth lazily, which
+ *   means that the guest's bits cannot be directly applied (we really
+ *   want to see the traps). Revisit this at some point.
+ */
+#define NV_HCR_GUEST_EXCLUDE	(HCR_TGE | HCR_API | HCR_APK)
+
+static u64 __compute_hcr(struct kvm_vcpu *vcpu)
+{
+	u64 hcr = vcpu->arch.hcr_el2;
+
+	if (!vcpu_has_nv(vcpu))
+		return hcr;
+
+	if (is_hyp_ctxt(vcpu)) {
+		hcr |= HCR_NV | HCR_NV2 | HCR_AT | HCR_TTLB;
+
+		if (!vcpu_el2_e2h_is_set(vcpu))
+			hcr |= HCR_NV1;
+
+		write_sysreg_s(vcpu->arch.ctxt.vncr_array, SYS_VNCR_EL2);
+	}
+
+	return hcr | (__vcpu_sys_reg(vcpu, HCR_EL2) & ~NV_HCR_GUEST_EXCLUDE);
+}
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
-	___activate_traps(vcpu);
+	___activate_traps(vcpu, __compute_hcr(vcpu));
 
 	if (has_cntpoff()) {
 		struct timer_map map;
-- 
2.39.2


