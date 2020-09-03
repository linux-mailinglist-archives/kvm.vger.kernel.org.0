Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA38225C54D
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgICP0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728522AbgICP03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:26:29 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011C720C09;
        Thu,  3 Sep 2020 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599146788;
        bh=HBjR8yqpG73ePWO3TJecMmjtceWadFNU+gdwbXpG+SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoFb6CdyZLtnPLWXFpdfmJZw1Tg/GSjEE+49gDnsyYj1dDONEVOOO9gWFO/X4RBdu
         L2nKnp4CiwzTNztHbRWuPqDjlDT7nCooNHLAAOts236MPkuqCBfVurtLJVZQwJpgMm
         AR7y41dXI4Dv20HN7jPrNyYF29q0uEuBi72gAeS4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr86-008vT9-DY; Thu, 03 Sep 2020 16:26:26 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 09/23] KVM: arm64: Move kvm_vgic_vcpu_init() to irqchip_flow
Date:   Thu,  3 Sep 2020 16:25:56 +0100
Message-Id: <20200903152610.1078827-10-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Abstract kvm_vgic_vcpu_init() by moving it to the irqchip_flow
structure. This results in a minor change of the way we initialize
vcpus:

VCPUs created prior to the creation of the vgic device don't have
their local view of the vgic initialized. This means that on vgic
instantiation, we must "catch up" and initialise the CPU interfaces
for these vcpus. VCPUs created after the vgic device will follow
the unusual flow. Special care must be taken to accomodate the
different locking contexts though.

The function can then be made static and the irqchip_in_kernel()
test dropped, as we only get here if a vgic has been created.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_irq.h |  4 ++++
 arch/arm64/kvm/arm.c             |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c  | 37 +++++++++++++++++++++++++-------
 include/kvm/arm_vgic.h           |  1 -
 4 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
index f83594257bc4..09df1f46d4de 100644
--- a/arch/arm64/include/asm/kvm_irq.h
+++ b/arch/arm64/include/asm/kvm_irq.h
@@ -19,6 +19,7 @@ enum kvm_irqchip_type {
 
 struct kvm_irqchip_flow {
 	void (*irqchip_destroy)(struct kvm *);
+	int  (*irqchip_vcpu_init)(struct kvm_vcpu *);
 };
 
 /*
@@ -50,4 +51,7 @@ struct kvm_irqchip_flow {
 #define kvm_irqchip_destroy(k)				\
 	__kvm_irqchip_action((k), destroy, (k))
 
+#define kvm_irqchip_vcpu_init(v)			\
+	__vcpu_irqchip_action_ret((v), vcpu_init, (v))
+
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 09b4bcb2c805..d82d348a36c3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -265,7 +265,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
 
-	err = kvm_vgic_vcpu_init(vcpu);
+	err = kvm_irqchip_vcpu_init(vcpu);
 	if (err)
 		return err;
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 4e2c23a7dab1..d845699c6966 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -12,10 +12,12 @@
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
+static int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
 static void kvm_vgic_destroy(struct kvm *kvm);
 
 static struct kvm_irqchip_flow vgic_irqchip_flow = {
 	.irqchip_destroy		= kvm_vgic_destroy,
+	.irqchip_vcpu_init		= kvm_vgic_vcpu_init,
 };
 
 /*
@@ -45,6 +47,8 @@ static struct kvm_irqchip_flow vgic_irqchip_flow = {
  *   allocation is allowed there.
  */
 
+static int __kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
+
 /* CREATION */
 
 /**
@@ -110,6 +114,17 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
 
+	/*
+	 * vcpus may have been created before the GIC. Initialize
+	 * them. Careful that kvm->lock is held already on the
+	 * KVM_CREATE_DEVICE path, so use the non-locking version.
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret = __kvm_vgic_vcpu_init(vcpu);
+		if (ret)
+			break;
+	}
+
 out_unlock:
 	unlock_all_vcpus(kvm);
 	return ret;
@@ -176,7 +191,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
  * Only do initialization, but do not actually enable the
  * VGIC CPU interface
  */
-int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
+static int __kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	int ret = 0;
@@ -211,18 +226,24 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (!irqchip_in_kernel(vcpu->kvm))
-		return 0;
-
 	/*
 	 * If we are creating a VCPU with a GICv3 we must also register the
 	 * KVM io device for the redistributor that belongs to this VCPU.
 	 */
-	if (irqchip_is_gic_v3(vcpu->kvm)) {
-		mutex_lock(&vcpu->kvm->lock);
+	if (irqchip_is_gic_v3(vcpu->kvm))
 		ret = vgic_register_redist_iodev(vcpu);
-		mutex_unlock(&vcpu->kvm->lock);
-	}
+
+	return ret;
+}
+
+static int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	mutex_lock(&vcpu->kvm->lock);
+	ret = __kvm_vgic_vcpu_init(vcpu);
+	mutex_unlock(&vcpu->kvm->lock);
+
 	return ret;
 }
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e8bdc304ec9b..b2fd0e39af11 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -335,7 +335,6 @@ extern struct static_key_false vgic_v2_cpuif_trap;
 extern struct static_key_false vgic_v3_cpuif_trap;
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
-int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
 int kvm_vgic_map_resources(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
-- 
2.27.0

