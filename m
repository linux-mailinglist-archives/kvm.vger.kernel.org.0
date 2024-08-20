Return-Path: <kvm+bounces-24592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B99A958393
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50A741F24880
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C02E18DF60;
	Tue, 20 Aug 2024 10:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwt0GMdX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A2118CBFF;
	Tue, 20 Aug 2024 10:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148373; cv=none; b=BhkdC7LMDk83MfwBjPy/WeBhpNaz7GJyVBEUZKoIndIcvAZZMY387+EBFOua2aLkBPuM/gAUIs7mtWOwEzJSvY+YniuFhHpJGiB6jNtPyP8bmEneynWxe8Tqyb59/LtK2m9p2EuGd4LDu/qU5UR9TmDpiDcSO6vf1JsHyC5xGxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148373; c=relaxed/simple;
	bh=euMf5tH8DhCXHxP9a0R6MM/IbJ5jecC+4Ci0Nz8ABRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nwe3xtKGs7DxJtpxINwBcVUv3xV+h0qg70hKzk48R7UE++hFzG92HBIB6RjsJbuG1RVSoTMC/tHy5iZfBASlnH/HdaJ1nGzP37dLjWOC1aWWTrofK0xKhxdk0LFkvBMcbeMD6Q7Q481WK8Y1PiDrA6l/Pjrk3I09SwOkAirQNew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwt0GMdX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F995C4AF10;
	Tue, 20 Aug 2024 10:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148373;
	bh=euMf5tH8DhCXHxP9a0R6MM/IbJ5jecC+4Ci0Nz8ABRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwt0GMdXkwTfHJF+Zlu7DWzlfUTOLsCAv5A4p076ZdyFO7C8jPl6Ht69ZPNmu5KaC
	 Ipc3LaZyu4HpPxzVEsfvLTgw+PF8EU0fP31VrWgZSCeEj2R4C8Vh/bOy/MAT4hhVEj
	 avAd+AT00HGGUX5HFqRPkmvi80IBzY4Rw8b9Jgd1ms8f5vKMwXYG8eU94mliftVmD2
	 CziuDepaGLHcu6IJbEQhNxrzk8pxGGWskk/SKDobJ9QkOW9PWneyMA281Lez9Y9xwY
	 Jj23JvSX9lMcneC3RJzvjwDfoFqYEwi3KA9/ZzWzzcOPAmWs0+lu0EMOeNGRqUR5Ai
	 uEVzX1UVXVvAQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLkf-005Dk2-9g;
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
Subject: [PATCH 02/12] KVM: arm64: Move GICv3 trap configuration to kvm_calculate_traps()
Date: Tue, 20 Aug 2024 11:03:39 +0100
Message-Id: <20240820100349.3544850-3-maz@kernel.org>
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

Follow the pattern introduced with vcpu_set_hcr(), and introduce
vcpu_set_ich_hcr(), which configures the GICv3 traps at the same
point.

This will allow future changes to introduce trap configuration on
a per-VM basis.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c     | 1 +
 arch/arm64/kvm/vgic/vgic-v3.c | 9 +++++++++
 arch/arm64/kvm/vgic/vgic.h    | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 31e49da867ff..257c8da23a4e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4551,6 +4551,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&kvm->arch.config_lock);
 	vcpu_set_hcr(vcpu);
+	vcpu_set_ich_hcr(vcpu);
 
 	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
 		/*
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 3eecdd2f4b8f..11718412921f 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -292,6 +292,15 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 
 	/* Get the show on the road... */
 	vgic_v3->vgic_hcr = ICH_HCR_EN;
+}
+
+void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *vgic_v3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (!kvm_has_gicv3(vcpu->kvm))
+		return;
+
 	if (group0_trap)
 		vgic_v3->vgic_hcr |= ICH_HCR_TALL0;
 	if (group1_trap)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 8532bfe3fed4..c72c38b44234 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -346,6 +346,8 @@ void vgic_v4_configure_vsgis(struct kvm *kvm);
 void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val);
 int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq);
 
+void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu);
+
 static inline bool kvm_has_gicv3(struct kvm *kvm)
 {
 	return (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
-- 
2.39.2


