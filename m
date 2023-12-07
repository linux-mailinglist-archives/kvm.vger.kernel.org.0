Return-Path: <kvm+bounces-3868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF9B3808B89
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:12:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94A361F21588
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC6F45C19;
	Thu,  7 Dec 2023 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hv2z+4jS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571CE44C7F;
	Thu,  7 Dec 2023 15:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8FDC433C9;
	Thu,  7 Dec 2023 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701961935;
	bh=vguCcJR1Jj091qVfq+Qnghxcjtym8hIKj5MARAlVG8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hv2z+4jS6KpsCq8RCfMC7GLLgvHAQ9EpC0ZsujY2FoKFXoMBUpiDWpIC9ZirRE3zA
	 dIgZRabnwLKuEEoo0TwNgbX4kCitue6NazUjcYsUnqr+oxj+DQLhak98kHsLvN6Gkr
	 9fmMciWned9LgTQ27aB8ozHUdZYGG0+OLxR+58TCHA10xBsP6h4DoNWHNp0oqSWPst
	 hcVgFQbLt8sYXYR6tw46XvHadwjmC4XAfZbjA0mfaiy4cgmBo+4QM0TzDBcjPA7i2u
	 eO5wjWlTMxC/gXp7+6HI3walxo9lMdu4LlmSCezPhpTEpoyLY/K0GDztKWLEx/2Egu
	 P7f/h5WKhGd7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rBG2v-002FcG-RR;
	Thu, 07 Dec 2023 15:12:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	vdonnefort@google.com,
	stable@vger.kernel.org
Subject: [PATCH 3/5] KVM: arm64: vgic: Force vcpu vgic teardown on vcpu destroy
Date: Thu,  7 Dec 2023 15:11:59 +0000
Message-Id: <20231207151201.3028710-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231207151201.3028710-1-maz@kernel.org>
References: <20231207151201.3028710-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, vdonnefort@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When failing to create a vcpu because (for example) it has a
duplicate vcpu_id, we destroy the vcpu. Amusingly, this leaves
the redistributor registered with the KVM_MMIO bus.

This is no good, and we should properly clean the mess. Force
a teardown of the vgic vcpu interface, including the RD device
before returning to the caller.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c               | 2 +-
 arch/arm64/kvm/vgic/vgic-init.c    | 5 ++++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 2 +-
 arch/arm64/kvm/vgic/vgic.h         | 1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e5f75f1f1085..4796104c4471 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -410,7 +410,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
-
+	kvm_vgic_vcpu_destroy(vcpu);
 	kvm_arm_vcpu_destroy(vcpu);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index a86f300321a7..e949e1d0fd9f 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -379,7 +379,10 @@ static void __kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_flush_pending_lpis(vcpu);
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
-	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		vgic_unregister_redist_iodev(vcpu);
+		vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	}
 }
 
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 89117ba2528a..0f039d46d4fc 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -820,7 +820,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
+void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 {
 	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0ab09b0d4440..8d134569d0a1 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -241,6 +241,7 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_v3_save_pending_tables(struct kvm *kvm);
 int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count);
 int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
+void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu);
 bool vgic_v3_check_base(struct kvm *kvm);
 
 void vgic_v3_load(struct kvm_vcpu *vcpu);
-- 
2.39.2


