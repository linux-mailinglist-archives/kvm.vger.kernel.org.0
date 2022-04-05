Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E1A4F4971
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384083AbiDEWQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573220AbiDESZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 14:25:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5577CE81
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 11:23:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB5BD618E1
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 18:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F43C385A7;
        Tue,  5 Apr 2022 18:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649183027;
        bh=ZrnXsHBiZRWUJYaEeIvp3oOr1cjkMN1M11qiZbsnzyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsMG6TEgg3vQvp6ZPz2VS2n6kN7zm6/l+yTbJhKClC9PMB4UTkGD0mZ4DPou1xZax
         BZ1mA3/80i8GMs6Eo43IZHDd36+aue06EI+qWk/f5W61pAI+B3J6mMLySaImudRe9/
         qvEmzEA+7MJqBJjxOUz0FMJA4GaU4IZ8QptHjoDofgVxvTaoStWrUsj0vH31Ni09Wp
         b2NU1jjL7cH0de/rj+XbsMkjBHqrVxIhTFBzsgkxNaJ5ezAKMrscVrEecFbr5RLVaI
         nvlYhv5FCQD/ppM8niQwuUeWCZACUSH4RKesUgcx3gzvEMJUCSjcrsAnWLSGySpkHb
         nA7LEO4KOxpZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nbnqC-001tdH-RL; Tue, 05 Apr 2022 19:23:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 4/4] KVM: arm64: vgic-v3: Advertise GICR_CTLR.{IR,CES} as a new GICD_IIDR revision
Date:   Tue,  5 Apr 2022 19:23:27 +0100
Message-Id: <20220405182327.205520-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220405182327.205520-1-maz@kernel.org>
References: <20220405182327.205520-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, oupton@google.com, lorenzo.pieralisi@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since adversising GICR_CTLR.{IC,CES} is directly observable from
a guest, we need to make it selectable from userspace.

For that, bump the default GICD_IIDR revision and let userspace
downgrade it to the previous default. For GICv2, the two distributor
revisions are strictly equivalent.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  7 ++++++-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c | 18 +++++++++++++++---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 23 +++++++++++++++++++++--
 arch/arm64/kvm/vgic/vgic.h         |  5 +++++
 include/kvm/arm_vgic.h             |  3 +++
 5 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index fc00304fe7d8..f84e04f334c6 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -319,7 +319,12 @@ int vgic_init(struct kvm *kvm)
 
 	vgic_debug_init(kvm);
 
-	dist->implementation_rev = 2;
+	/*
+	 * If userspace didn't set the GIC implementation revision,
+	 * default to the latest and greatest. You know want it.
+	 */
+	if (!dist->implementation_rev)
+		dist->implementation_rev = KVM_VGIC_IMP_REV_LATEST;
 	dist->initialized = true;
 
 out:
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index 12e4c223e6b8..77a67e9d3d14 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -73,9 +73,13 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
 					   gpa_t addr, unsigned int len,
 					   unsigned long val)
 {
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	u32 reg;
+
 	switch (addr & 0x0c) {
 	case GIC_DIST_IIDR:
-		if (val != vgic_mmio_read_v2_misc(vcpu, addr, len))
+		reg = vgic_mmio_read_v2_misc(vcpu, addr, len);
+		if ((reg ^ val) & ~GICD_IIDR_REVISION_MASK)
 			return -EINVAL;
 
 		/*
@@ -87,8 +91,16 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
 		 * migration from old kernels to new kernels with legacy
 		 * userspace.
 		 */
-		vcpu->kvm->arch.vgic.v2_groups_user_writable = true;
-		return 0;
+		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, reg);
+		switch (reg) {
+		case KVM_VGIC_IMP_REV_2:
+		case KVM_VGIC_IMP_REV_3:
+			vcpu->kvm->arch.vgic.v2_groups_user_writable = true;
+			dist->implementation_rev = reg;
+			return 0;
+		default:
+			return -EINVAL;
+		}
 	}
 
 	vgic_mmio_write_v2_misc(vcpu, addr, len, val);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 9824c773427d..f7aa7bcd6fb8 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -155,13 +155,27 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 					   unsigned long val)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	u32 reg;
 
 	switch (addr & 0x0c) {
 	case GICD_TYPER2:
-	case GICD_IIDR:
 		if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
 			return -EINVAL;
 		return 0;
+	case GICD_IIDR:
+		reg = vgic_mmio_read_v3_misc(vcpu, addr, len);
+		if ((reg ^ val) & ~GICD_IIDR_REVISION_MASK)
+			return -EINVAL;
+
+		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, reg);
+		switch (reg) {
+		case KVM_VGIC_IMP_REV_2:
+		case KVM_VGIC_IMP_REV_3:
+			dist->implementation_rev = reg;
+			return 0;
+		default:
+			return -EINVAL;
+		}
 	case GICD_CTLR:
 		/* Not a GICv4.1? No HW SGIs */
 		if (!kvm_vgic_global_state.has_gicv4_1)
@@ -232,8 +246,13 @@ static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
 					     gpa_t addr, unsigned int len)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	unsigned long val;
+
+	val = atomic_read(&vgic_cpu->ctlr);
+	if (vgic_get_implementation_rev(vcpu) >= KVM_VGIC_IMP_REV_3)
+		val |= GICR_CTLR_IR | GICR_CTLR_CES;
 
-	return vgic_cpu->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
+	return val;
 }
 
 static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 1d04a900f3e3..4c6bdd321faa 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -98,6 +98,11 @@
 #define DEBUG_SPINLOCK_BUG_ON(p)
 #endif
 
+static inline u32 vgic_get_implementation_rev(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.vgic.implementation_rev;
+}
+
 /* Requires the irq_lock to be held by the caller. */
 static inline bool irq_is_pending(struct vgic_irq *irq)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 401236f97cf2..2d8f2e90edc2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -231,6 +231,9 @@ struct vgic_dist {
 
 	/* Implementation revision as reported in the GICD_IIDR */
 	u32			implementation_rev;
+#define KVM_VGIC_IMP_REV_2	2 /* GICv2 restorable groups */
+#define KVM_VGIC_IMP_REV_3	3 /* GICv3 GICR_CTLR.{IW,CES,RWP} */
+#define KVM_VGIC_IMP_REV_LATEST	KVM_VGIC_IMP_REV_3
 
 	/* Userspace can write to GICv2 IGROUPR */
 	bool			v2_groups_user_writable;
-- 
2.34.1

