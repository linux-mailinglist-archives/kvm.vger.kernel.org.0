Return-Path: <kvm+bounces-61881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F2E3C2D4D2
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:58:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 571A24E8A7A
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786ED325710;
	Mon,  3 Nov 2025 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="II+MAjDY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F5F322774;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188932; cv=none; b=Wf34JRm8HJjcbertw/sH5NjRcbWRAKqvTv1XOZipbPY+5SnQHsNjvjmnUUfdVjTL+5qVO5atC1g7gsyC4fX2gv+YNqoLUL5Tp3dNG+c4Lpy4ghY1Mm8qHnmnTwLdo7zwVXhcZtj7nbi1T0mYM5D1iFo5tEURPElS9Tsougae0bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188932; c=relaxed/simple;
	bh=eMdKgJvpXR9g6dp42ZCCeiki15cZjNTkDMh6Rl2Yf+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBuxLh2HPxBDJXSQ6GMZtwJF+JBXX7gWRn50cMUyvQNevV24LhouMblDsjnEC0+17UJ3TU7odv7f2hSvKKhj7ktENXxlRb27dNhhk3S3Jc47w1see+659zhHR4+Dd/JZONofoGFNWcnwo5JLFprWAaYfiXaMBFLYAh6qjlXtOtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=II+MAjDY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723B8C19425;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188931;
	bh=eMdKgJvpXR9g6dp42ZCCeiki15cZjNTkDMh6Rl2Yf+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=II+MAjDYqpAz1+2r2lnG0q+TPs1pPnfM/1YQGHah8NWXf+MRhriors07R+vBxUkXN
	 rf9t4wigWLKp3LxBO3N25kcm/6Vemio3zK9TSS2D3xUxCGo2qubpMHRoDXfJA91K17
	 2RkezM5Y3k4Rab26H9Av66oRbM6MlxcNf8PKD95tyCkJ3OeVO/HYc2fiMt8knYzQji
	 0DUigJZujrX3zZMioITICclEfS66Fi8DgIkPMglcOwcU3+si50vOjy1dJF1cWp7Nhq
	 dB4rkaoxvYJpNZoayYHQ5Lnnp3BFzW5qpym0dKfa9PkqJ76KE8mjl6ht6yyYFHeV0w
	 ldxcoc+6uf4BA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq5-000000021VN-2qmJ;
	Mon, 03 Nov 2025 16:55:29 +0000
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
Subject: [PATCH 21/33] KVM: arm64: Make vgic_target_oracle() globally available
Date: Mon,  3 Nov 2025 16:55:05 +0000
Message-ID: <20251103165517.2960148-22-maz@kernel.org>
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

Make the internal crystal ball global, so that implementation-specific
code can use it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 2 +-
 arch/arm64/kvm/vgic/vgic.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index c420f8262e4c1..570cc8fe42b87 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -237,7 +237,7 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
  *
  * Requires the IRQ lock to be held.
  */
-static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
+struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 {
 	lockdep_assert_held(&irq->irq_lock);
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f35410de1457b..7a44484acf93c 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -245,6 +245,7 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid);
 struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
+struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
 void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
-- 
2.47.3


