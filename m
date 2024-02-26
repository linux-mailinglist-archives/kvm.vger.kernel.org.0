Return-Path: <kvm+bounces-9795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D32CA8670DE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E67C7B21E58
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D148A56762;
	Mon, 26 Feb 2024 10:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cftFMEGW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015D456467;
	Mon, 26 Feb 2024 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942057; cv=none; b=AGnPKpTrWzae4IhWdtKic5J+9YKOZfB6ZOR60sSFOermig33itXLsCA1KgjZDcuVLASn84CYd5JXPfk9XgH9tOpmcXRQVk7tXo8Hu2ulcTbza2BMj3YdNO7LPyDrmAP+SLEhNN8Whh3apkjX10s5m/ABIQAoH0AAREhup4rNqVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942057; c=relaxed/simple;
	bh=nuP68np28bnX5e9ek2TaXzYB9gLQsB4wYLjkmlaziwg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=psgEBGrjqJBFHflta4RAOJebnrIVUeZ/mBcHgji5ihezo78mBp8ejV7r7568SoaClDO7Ze/ImZcHJE6Z5eWgbFnbKWE/5k0aZPo0rf7wl/21avv0kIWbSsosvKUi5KjbINvfbFEtRLMtWcBeatbXzbyw1vNRiZjzdC1BbqQYcr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cftFMEGW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76D1C43399;
	Mon, 26 Feb 2024 10:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942056;
	bh=nuP68np28bnX5e9ek2TaXzYB9gLQsB4wYLjkmlaziwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cftFMEGW011VnLjXiOPHIhMu2vHQ39I4h9WtAjhnm2MqvakiBkC6O53EQw0OtQZgv
	 RHJOhE6OA8zAGqOWyhe81q6Lk6Hfa1ck7OfusC/0zZvafvsr7gbtZ1ms3OjuGVxZaG
	 TdFmriarGG6qedNmZnRZeTLDd6NyVWWZuFQ8YquSaeepIJKT4t+b6DjD/Xas2IexXu
	 AFyuhl7kzz2OjOQV/HcKGLuIs2bEOqZvolQ30UST7jLfxK3fQukfPrnXSm4klirVmv
	 +3MNQ+9FNn9auZBykJO4ZuhsQ22pjRO4JJrRzNFbYK4Qw27ajo7kBREBmfM6YYQE4U
	 zdBc1Sc64VD4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXtW-006nQ5-9P;
	Mon, 26 Feb 2024 10:07:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 04/13] KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2
Date: Mon, 26 Feb 2024 10:05:52 +0000
Message-Id: <20240226100601.2379693-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100601.2379693-1-maz@kernel.org>
References: <20240226100601.2379693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
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
index 58415783fd53..d5fdcea2b366 100644
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


