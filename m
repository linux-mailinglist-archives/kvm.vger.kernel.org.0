Return-Path: <kvm+bounces-25164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1DFD961205
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96DEC281E88
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2071C9EAF;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KylIwLdT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2651C7B82;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772330; cv=none; b=sI+6Fc6Jveqzs6zonUAS8+gYGCFGnq4VNsiA2oQc6DNbbaglzeM1kWcqX8Ksi5TZYMcIWZ5SNxtXzyikSwNDmPIBY3iyBKnjaegGh6pdfAg4fhweK3jE/IrUXl+/TsdkKO4ShcENIewc/8Pz/LBErpZWwdM9WyiDjTriPWzDCWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772330; c=relaxed/simple;
	bh=F8okc6t0iSZwnR4FFgYJRiQd4jXOMYJgtLflxgGnfgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mc1F3H4X2nF9G+71qPKaIrxOCsr19au3sBiVmUq0uqMloZRyrTpsSmdIGbJ9KKaMA+kNpXAEPqaiaCxEdwNo2GWhLUCaDe9r128T9YAb+XK1ocOr2INRim7G9QFaAxnpEdXS0NPtLOffv0J2mTeLiF7dxu5wOmwTQit/xwwB9Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KylIwLdT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31F9C6107A;
	Tue, 27 Aug 2024 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724772329;
	bh=F8okc6t0iSZwnR4FFgYJRiQd4jXOMYJgtLflxgGnfgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KylIwLdT+eoNKy5yC399UkixlOwMpVxhf26c8TacZu+tjJh1/G0tOnHuDc8yoYrss
	 wRux5FajQOpKfCAWCFNzYqEQ8hkccBD3/rPWIfKBJ3RdtBQvf1s3qoqFtqiEbYLbgr
	 Fc72dq6QuWR0HWPEVRQF6vlwQsbdFEkySKTPYy/EkePIMH1y6METXIIZfG2Jn9HoRA
	 ZYQeHOYv/VjqnzqwEebUqqodr712aV/Qnzjlg43lcK++EPVSaiuxxlSUhwzOfh2N9d
	 NrM9MA43PSpuqvtLin9wQVAw5krIdJWm6CUDM33dxaMA0ARfXCzgvmISDOA9oHqQoy
	 xVKN6Hx+pNRyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1siy4W-007HOs-0V;
	Tue, 27 Aug 2024 16:25:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 03/11] KVM: arm64: Force GICv3 trap activation when no irqchip is configured on VHE
Date: Tue, 27 Aug 2024 16:25:09 +0100
Message-Id: <20240827152517.3909653-4-maz@kernel.org>
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

On a VHE system, no GICv3 traps get configured when no irqchip is
present. This is not quite matching the "no GICv3" semantics that
we want to present.

Force such traps to be configured in this case.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index abe29c7d85d0..f50274fd5581 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -922,10 +922,13 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
+		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
+	}
 
-	if (kvm_vgic_global_state.type == VGIC_V2)
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_load(vcpu);
 	else
 		vgic_v3_load(vcpu);
@@ -933,10 +936,13 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_put(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
+		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		return;
+	}
 
-	if (kvm_vgic_global_state.type == VGIC_V2)
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_put(vcpu);
 	else
 		vgic_v3_put(vcpu);
-- 
2.39.2


