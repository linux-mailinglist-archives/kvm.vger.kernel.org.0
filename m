Return-Path: <kvm+bounces-62443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E90C443FE
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:19:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0762D3B57AA
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC68D30C63D;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7XUCFoF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF42030B505;
	Sun,  9 Nov 2025 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708595; cv=none; b=hVbSXAQUnwwwRQJCqchii/6CddEfFf3mMyXMWOH+30GycVQ1yZNWPLEtgGgPdVbUizg/WKlX5WcDmnwIwPiUzyeU/Yi5izLPZ5dLJ0iuPQ8/ip38c6ePNUajkb7jOCH9z9EwptKa0KzrUdm9q2eubPM9JTHgHD55DSCEOsBbshg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708595; c=relaxed/simple;
	bh=lwZelCb2zI/5hNTrYmrdSX93P6CsTCa7DxiK7pZCVY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcvmkzRpjYbXjMJaKoF/Zn7a493qeHY1tbKAe1t15NzfHGatJIKgKS/SbT26fM25boTIJLhQ+56Cff/SKFB7FwE2TY8Z0QWHz/9ocfeBMwiMpn7wXiaXQHsA2Mplp+sGwF4AC4QOfqFxIU9W4sfGOZuY4G0O5d2XHPcxtaDlSQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7XUCFoF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E803C4CEFB;
	Sun,  9 Nov 2025 17:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708595;
	bh=lwZelCb2zI/5hNTrYmrdSX93P6CsTCa7DxiK7pZCVY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7XUCFoFea+DVrlRjIq87gU2Gu3ljOn2SBXdqibwOuVFPAeUcmds9nLIQEzLQBWsO
	 NzhFxqsK9pft16aacZPoN2/o5YNxKbKsHz1OVV7K4l3PHRfBej75oJm8KtKF1tB8/k
	 nQdPOmvOTyi4rmpRgYSUKaiv/KAj87I4ym/MvMwuF8xhH2pYM4UFy/POjHHf+b9+Mg
	 vEImaFR+Y3zS0+Lclu05Mun4kyGuUddqd/nHvBLrgs63N6aY74taWIkPQAVir4btCD
	 FDMrznYrYhlhe/i1Y+w1HSZGtkSA9pqqMyps6sH/sdWBZ2hETNMC1+wJX//yG65yqd
	 aCBiZ6tEBqhug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91l-00000003exw-1JI1;
	Sun, 09 Nov 2025 17:16:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 21/45] KVM: arm64: Turn kvm_vgic_vcpu_enable() into kvm_vgic_vcpu_reset()
Date: Sun,  9 Nov 2025 17:15:55 +0000
Message-ID: <20251109171619.1507205-22-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we always reconfigure the vgic HCR register on entry,
the "enable" part of kvm_vgic_vcpu_enable() is pretty useless.

Removing the enable bits from these functions makes it plain that
they are just about computing the reset state. Just rename the
functions accordingly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 8 ++++----
 arch/arm64/kvm/vgic/vgic-v2.c   | 5 +----
 arch/arm64/kvm/vgic/vgic-v3.c   | 5 +----
 arch/arm64/kvm/vgic/vgic.h      | 4 ++--
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1796b1a22a72a..6d5e5d708f23a 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -353,12 +353,12 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void kvm_vgic_vcpu_enable(struct kvm_vcpu *vcpu)
+static void kvm_vgic_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_enable(vcpu);
+		vgic_v2_reset(vcpu);
 	else
-		vgic_v3_enable(vcpu);
+		vgic_v3_reset(vcpu);
 }
 
 /*
@@ -405,7 +405,7 @@ int vgic_init(struct kvm *kvm)
 	}
 
 	kvm_for_each_vcpu(idx, vcpu, kvm)
-		kvm_vgic_vcpu_enable(vcpu);
+		kvm_vgic_vcpu_reset(vcpu);
 
 	ret = kvm_vgic_setup_default_irq_routing(kvm);
 	if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index f53bc55288978..18856186be7be 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -285,7 +285,7 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 			GICH_VMCR_PRIMASK_SHIFT) << GICV_PMR_PRIORITY_SHIFT;
 }
 
-void vgic_v2_enable(struct kvm_vcpu *vcpu)
+void vgic_v2_reset(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * By forcing VMCR to zero, the GIC will restore the binary
@@ -293,9 +293,6 @@ void vgic_v2_enable(struct kvm_vcpu *vcpu)
 	 * anyway.
 	 */
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = 0;
-
-	/* Get the show on the road... */
-	vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr = GICH_HCR_EN;
 }
 
 /* check for overlapping regions and for regions crossing the end of memory */
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index d23db8f7b450a..5a57f3c299b56 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -290,7 +290,7 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 	GIC_BASER_CACHEABILITY(GICR_PENDBASER, OUTER, SameAsInner)	| \
 	GIC_BASER_SHAREABILITY(GICR_PENDBASER, InnerShareable))
 
-void vgic_v3_enable(struct kvm_vcpu *vcpu)
+void vgic_v3_reset(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *vgic_v3 = &vcpu->arch.vgic_cpu.vgic_v3;
 
@@ -320,9 +320,6 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 						    kvm_vgic_global_state.ich_vtr_el2);
 	vcpu->arch.vgic_cpu.num_pri_bits = FIELD_GET(ICH_VTR_EL2_PRIbits,
 						     kvm_vgic_global_state.ich_vtr_el2) + 1;
-
-	/* Get the show on the road... */
-	vgic_v3->vgic_hcr = ICH_HCR_EL2_En;
 }
 
 void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4a0733869cb5f..e48294521541e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -285,7 +285,7 @@ int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			  int offset, u32 *val);
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
-void vgic_v2_enable(struct kvm_vcpu *vcpu);
+void vgic_v2_reset(struct kvm_vcpu *vcpu);
 int vgic_v2_probe(const struct gic_kvm_info *info);
 int vgic_v2_map_resources(struct kvm *kvm);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
@@ -320,7 +320,7 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu, struct ap_list_summary *als);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
-void vgic_v3_enable(struct kvm_vcpu *vcpu);
+void vgic_v3_reset(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
-- 
2.47.3


