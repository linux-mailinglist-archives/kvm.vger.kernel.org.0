Return-Path: <kvm+bounces-16421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6108B9DB4
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 17:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60EE9B247E4
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 15:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB0E915B0E8;
	Thu,  2 May 2024 15:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NolV913d"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCA215B14D;
	Thu,  2 May 2024 15:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714664751; cv=none; b=TtpCT7tH+bcv2Da9FJ8wgpUe/W47dL04W1EDTDxnoGJD1DKE4/zoe+SgGn7VeE/p1D6L3rQqirH9Ei/3P2Mlcyj73n1EK3tdAW0/awLcrrnnWezQMxIOSJlv4xjTbKJcqi8J8zJIaE1/gAPanERrZDC4MW4T4C8PERtl50uTPv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714664751; c=relaxed/simple;
	bh=sVL3i1G+qWtlgcLovFJUo7mzzgMGFy6CJSAO5SSyXrA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=urYsGrD7bRi33+hJeIEdp7bCeBkzHSkD0OdhcbfeV6OFQFAGo+JpKcKL8wjhyG3wWWB+BVYnW0G/K6z0/FIKA3Q7ZYJGn/VRXTTXz9yQQAZzM+0s4/QJqSJs+fnoNY0eygpSETJwJWekUH/gmNLMbtfyujRDLtuzAoksKmfX4sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NolV913d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598E7C113CC;
	Thu,  2 May 2024 15:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714664751;
	bh=sVL3i1G+qWtlgcLovFJUo7mzzgMGFy6CJSAO5SSyXrA=;
	h=From:To:Cc:Subject:Date:From;
	b=NolV913dgUhdlrnrhnCtqNlOtdu6F0m4FyLSga7xmjZVxIvBhPnuKYmrgDsmpv3Aq
	 ldl67gAOi1qXF1jmMlba09PsiIvO1nq+nEDjOdVCbJ0Pij2vA1xi1bS/OItDFd/Ttf
	 5iD9dRR5lzphplLPZM2Aa+dhIoiTQBsxzBtxCMzjybGK+F2hJfzr+KKDRWAQ6upzTB
	 jceBHh8k78aGN8oncxxLIAwgjXT28sSbc2MdbzyoM2op4rfVejjF6E2bAUluU6gjnK
	 5GFPckjXdo5GLbwZR/tNO9AeS4rkcqg+8zhd+Shr61M3UnEKPiVF5gyb8BdhIwzQUX
	 XgAzlnaAa8ajA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s2Yd3-00A2p9-2T;
	Thu, 02 May 2024 16:45:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: vgic: Allocate private interrupts on demand
Date: Thu,  2 May 2024 16:45:45 +0100
Message-Id: <20240502154545.3012089-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Private interrupts are currently part of the CPU interface structure
that is part of each and every vcpu we create.

Currently, we have 32 of them per vcpu, resulting in a per-vcpu array
that is just shy of 4kB. On its own, that's no big deal, but it gets
in the way of other things:

- each vcpu gets mapped at EL2 on nVHE/hVHE configurations. This
  requires memory that is physically contiguous. However, the EL2
  code has no purpose looking that the interrupt structures and
  could do without them being mapped.

- supporting features such as EPPIs, which extend the number of
  privrate interrupts past the 32 limit would make the array
  even larger, even for VMs that do not use the EPPI feature.

Address these issues by moving the private interrupt array outside
of the vcpu, and replace it with a simple pointer. We take this
opportunity to make it obvious what gets initialised when, as
that path was remarkably opaque, and tighten the locking.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 82 +++++++++++++++++++++++++--------
 include/kvm/arm_vgic.h          |  2 +-
 2 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index aee6083d0da6..8f5b7a3e7009 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -180,27 +180,22 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	return 0;
 }
 
-/**
- * kvm_vgic_vcpu_init() - Initialize static VGIC VCPU data
- * structures and register VCPU-specific KVM iodevs
- *
- * @vcpu: pointer to the VCPU being created and initialized
- *
- * Only do initialization, but do not actually enable the
- * VGIC CPU interface
- */
-int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
+static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	int ret = 0;
 	int i;
 
-	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	lockdep_assert_held(&vcpu->kvm->arch.config_lock);
 
-	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
-	raw_spin_lock_init(&vgic_cpu->ap_list_lock);
-	atomic_set(&vgic_cpu->vgic_v3.its_vpe.vlpi_count, 0);
+	if (vgic_cpu->private_irqs)
+		return 0;
+
+	vgic_cpu->private_irqs = kcalloc(VGIC_NR_PRIVATE_IRQS,
+					 sizeof(struct vgic_irq),
+					 GFP_KERNEL_ACCOUNT);
+
+	if (!vgic_cpu->private_irqs)
+		return -ENOMEM;
 
 	/*
 	 * Enable and configure all SGIs to be edge-triggered and
@@ -225,9 +220,48 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	return 0;
+}
+
+static int vgic_allocate_private_irqs(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	ret = vgic_allocate_private_irqs_locked(vcpu);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
+
+	return ret;
+}
+
+/**
+ * kvm_vgic_vcpu_init() - Initialize static VGIC VCPU data
+ * structures and register VCPU-specific KVM iodevs
+ *
+ * @vcpu: pointer to the VCPU being created and initialized
+ *
+ * Only do initialization, but do not actually enable the
+ * VGIC CPU interface
+ */
+int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	int ret = 0;
+
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+
+	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	raw_spin_lock_init(&vgic_cpu->ap_list_lock);
+	atomic_set(&vgic_cpu->vgic_v3.its_vpe.vlpi_count, 0);
+
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return 0;
 
+	ret = vgic_allocate_private_irqs(vcpu);
+	if (ret)
+		return ret;
+
 	/*
 	 * If we are creating a VCPU with a GICv3 we must also register the
 	 * KVM io device for the redistributor that belongs to this VCPU.
@@ -283,10 +317,13 @@ int vgic_init(struct kvm *kvm)
 
 	/* Initialize groups on CPUs created before the VGIC type was known */
 	kvm_for_each_vcpu(idx, vcpu, kvm) {
-		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+		ret = vgic_allocate_private_irqs_locked(vcpu);
+		if (ret)
+			goto out;
 
 		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
-			struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
+			struct vgic_irq *irq = vgic_get_irq(kvm, vcpu, i);
+
 			switch (dist->vgic_model) {
 			case KVM_DEV_TYPE_ARM_VGIC_V3:
 				irq->group = 1;
@@ -298,8 +335,12 @@ int vgic_init(struct kvm *kvm)
 				break;
 			default:
 				ret = -EINVAL;
-				goto out;
 			}
+
+			vgic_put_irq(kvm, irq);
+
+			if (ret)
+				goto out;
 		}
 	}
 
@@ -373,6 +414,9 @@ static void __kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_flush_pending_lpis(vcpu);
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	kfree(vgic_cpu->private_irqs);
+	vgic_cpu->private_irqs = NULL;
+
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
 		vgic_unregister_redist_iodev(vcpu);
 		vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 94ccf0c8b62d..f5172549f9ba 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -331,7 +331,7 @@ struct vgic_cpu {
 		struct vgic_v3_cpu_if	vgic_v3;
 	};
 
-	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
+	struct vgic_irq *private_irqs;
 
 	raw_spinlock_t ap_list_lock;	/* Protects the ap_list */
 
-- 
2.39.2


