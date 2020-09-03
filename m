Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2B525C5E6
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgICP4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbgICP4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:56:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 855B6208CA;
        Thu,  3 Sep 2020 15:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599148571;
        bh=aS/t6svxjVTLIqQIL8YmKTnPTqDezWb7MZUb4MsYTCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ai05p6rz3xI0in+U7g0P8DQj9BwcgAHYcO7VsuZpqZbc+BACTixZS2zLSPMCWJLZA
         1QmYwzBmJyIkEJrhL4v+N3ACQQO5MWDbgb6AR+Fsc+qNw7U85HGPFNxDS5650i/8Oo
         d9GrPQfF29SnaMWCO4QJ6ExxmtDepMmXy4qvH2DY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr88-008vT9-T3; Thu, 03 Sep 2020 16:26:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 13/23] KVM: arm64: Move vgic resource mapping on first run to irqchip_flow
Date:   Thu,  3 Sep 2020 16:26:00 +0100
Message-Id: <20200903152610.1078827-14-maz@kernel.org>
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

The "first run" part of the vgic init is pretty cumbersome, as
it leaks all over the place. Reduce its footprint by moving it
to an actual per-vcpu "first run" callback, and let it deal
with the resource mapping.

This allows the vgic_ready() macro to be made vgic-private,
and placed in the common vgic code instead of the architecture
backends.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_irq.h |  4 ++++
 arch/arm64/kvm/arm.c             | 12 +++---------
 arch/arm64/kvm/vgic/vgic-init.c  | 13 ++++++++++---
 arch/arm64/kvm/vgic/vgic-v2.c    |  5 -----
 arch/arm64/kvm/vgic/vgic-v3.c    |  4 ----
 arch/arm64/kvm/vgic/vgic.h       |  2 ++
 include/kvm/arm_vgic.h           |  2 --
 7 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
index e7a244176ade..7d888f10aabe 100644
--- a/arch/arm64/include/asm/kvm_irq.h
+++ b/arch/arm64/include/asm/kvm_irq.h
@@ -25,6 +25,7 @@ struct kvm_irqchip_flow {
 	void (*irqchip_vcpu_load)(struct kvm_vcpu *);
 	void (*irqchip_vcpu_put)(struct kvm_vcpu *);
 	int  (*irqchip_vcpu_pending_irq)(struct kvm_vcpu *);
+	int  (*irqchip_vcpu_first_run)(struct kvm_vcpu *);
 };
 
 /*
@@ -74,4 +75,7 @@ struct kvm_irqchip_flow {
 #define kvm_irqchip_vcpu_pending_irq(v)			\
 	__vcpu_irqchip_action_ret((v), vcpu_pending_irq, (v))
 
+#define kvm_irqchip_vcpu_first_run(v)			\
+	__vcpu_irqchip_action_ret((v), vcpu_first_run, (v))
+
 #endif
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3496d200e488..0db71d2a38a4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -503,15 +503,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.has_run_once = true;
 
 	if (likely(irqchip_in_kernel(kvm))) {
-		/*
-		 * Map the VGIC hardware resources before running a vcpu the
-		 * first time on this VM.
-		 */
-		if (unlikely(!vgic_ready(kvm))) {
-			ret = kvm_vgic_map_resources(kvm);
-			if (ret)
-				return ret;
-		}
+		ret = kvm_irqchip_vcpu_first_run(vcpu);
+		if (ret)
+			return ret;
 	} else {
 		/*
 		 * Tell the rest of the code that there are userspace irqchip
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 8bb847045ef9..8ec8064467a7 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -12,6 +12,7 @@
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
+static int kvm_vgic_vcpu_first_run(struct kvm_vcpu *vcpu);
 static int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
 static void kvm_vgic_destroy(struct kvm *kvm);
 
@@ -23,6 +24,7 @@ static struct kvm_irqchip_flow vgic_irqchip_flow = {
 	.irqchip_vcpu_load		= kvm_vgic_load,
 	.irqchip_vcpu_put		= kvm_vgic_put,
 	.irqchip_vcpu_pending_irq	= kvm_vgic_vcpu_pending_irq,
+	.irqchip_vcpu_first_run		= kvm_vgic_vcpu_first_run,
 };
 
 /*
@@ -440,14 +442,17 @@ int vgic_lazy_init(struct kvm *kvm)
  * Also map the virtual CPU interface into the VM.
  * v2/v3 derivatives call vgic_init if not already done.
  * vgic_ready() returns true if this function has succeeded.
- * @kvm: kvm struct pointer
+ * @vcpu: vcpu struct pointer
  */
-int kvm_vgic_map_resources(struct kvm *kvm)
+static int kvm_vgic_vcpu_first_run(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	int ret = 0;
 
 	mutex_lock(&kvm->lock);
-	if (!irqchip_in_kernel(kvm))
+
+	if (vgic_ready(kvm))
 		goto out;
 
 	if (irqchip_is_gic_v2(kvm))
@@ -457,6 +462,8 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 
 	if (ret)
 		__kvm_vgic_destroy(kvm);
+	else
+		dist->ready = true;
 
 out:
 	mutex_unlock(&kvm->lock);
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index ebf53a4e1296..a6aaffd2124f 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -306,9 +306,6 @@ int vgic_v2_map_resources(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	int ret = 0;
 
-	if (vgic_ready(kvm))
-		goto out;
-
 	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
 	    IS_VGIC_ADDR_UNDEF(dist->vgic_cpu_base)) {
 		kvm_err("Need to set vgic cpu and dist addresses first\n");
@@ -348,8 +345,6 @@ int vgic_v2_map_resources(struct kvm *kvm)
 		}
 	}
 
-	dist->ready = true;
-
 out:
 	return ret;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index c6fdb1222453..d176ad9bab85 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -496,9 +496,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
 	int ret = 0;
 	int c;
 
-	if (vgic_ready(kvm))
-		goto out;
-
 	kvm_for_each_vcpu(c, vcpu, kvm) {
 		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
@@ -538,7 +535,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
 
 	if (kvm_vgic_global_state.has_gicv4_1)
 		vgic_v4_configure_vsgis(kvm);
-	dist->ready = true;
 
 out:
 	return ret;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c5511823eec5..48e9efda9d8b 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -98,6 +98,8 @@
 #define DEBUG_SPINLOCK_BUG_ON(p)
 #endif
 
+#define vgic_ready(k)		((k)->arch.vgic.ready)
+
 /* Requires the irq_lock to be held by the caller. */
 static inline bool irq_is_pending(struct vgic_irq *irq)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b2adf9cca334..fad523007e2b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -336,7 +336,6 @@ extern struct static_key_false vgic_v3_cpuif_trap;
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
-int kvm_vgic_map_resources(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
 void kvm_vgic_init_cpu_hardware(void);
 
@@ -348,7 +347,6 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-#define vgic_ready(k)		((k)->arch.vgic.ready)
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
 
-- 
2.27.0

