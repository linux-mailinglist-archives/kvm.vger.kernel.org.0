Return-Path: <kvm+bounces-25161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE87D961202
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63F94281C2C
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98EC1C945D;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SxtuwGq5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE50C1C57AB;
	Tue, 27 Aug 2024 15:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772330; cv=none; b=d0aC0QJyHeDpThRIc1uJRjP9CuKhIp+TKXwdwlnDZ3bOHC/R5W79elMP/maw87DkS5CmJElf+Qww3NsU/ynHmwnQc/JFKwY14Lu0Il6A0zO5kQeQOIXxe1Pi8coN/XSTGUOuVbJ0lGksrIASPNKe4/lyN+KnDFI37s/8g1zIl5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772330; c=relaxed/simple;
	bh=euMf5tH8DhCXHxP9a0R6MM/IbJ5jecC+4Ci0Nz8ABRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bDNexfh8rFhyv6Kr37Ldz803j2e5yD841nTjj9ieL38o2IA83C0a2HY7b5yJbE2tU7VhhZS6lkfF8CXq/PLgJW5wyvYxyMEmV3DUqwzOEA3V8oOF6nwlQbtn7+Dde5JTjJwabYxr38j1wZ810l9+TfAXEygzx19RTEGP1XIE740=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SxtuwGq5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09CEC61071;
	Tue, 27 Aug 2024 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724772329;
	bh=euMf5tH8DhCXHxP9a0R6MM/IbJ5jecC+4Ci0Nz8ABRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxtuwGq5GSrbCZ0zKVS1qAIXpqujM4kQq0g7432ls49+8hye9lKbJMuLNvCHVVAM8
	 R4sHaA68djDpXToAI4W0fn48dGQHMpf3FzkL5zl6nwlffE556BCTbH9hmEWBMXFpml
	 mDotR0N25K019Hmg0oTrlSVGSxAL+f7SywnEYPTRcSR5wUI+TRaDAZHkgerh1y2j1+
	 iDNc0HEq/8BxhH3Q/JiGZ4HSaRqXekvVinqEVaJ4SfMDxQRxofeMmaBkg8M5+Qy+u/
	 FiTRUmcr9JUG4/W3BS+6iwTRUST2uavjjcCuaq/QIc37xCSzKo1XWN/0CMEBUemdLF
	 4ArPJulv07odw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1siy4V-007HOs-Kg;
	Tue, 27 Aug 2024 16:25:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 01/11] KVM: arm64: Move GICv3 trap configuration to kvm_calculate_traps()
Date: Tue, 27 Aug 2024 16:25:07 +0100
Message-Id: <20240827152517.3909653-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240827152517.3909653-1-maz@kernel.org>
References: <20240827152517.3909653-1-maz@kernel.org>
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


