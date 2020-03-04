Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1372E179A1F
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 21:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388484AbgCDUgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 15:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388444AbgCDUgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 15:36:36 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24DDB2146E;
        Wed,  4 Mar 2020 20:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583354195;
        bh=OxW33vG8amINBWpsA6a/7SuajrxWzQXpmqfc135Ap3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fOumOn8dP8ZB9p5ZHSQX1gR39c285clqrI5hU/Y4ZJ8zZryWnlb3EhTMFAK8JAEM
         5rVV74tjDItMpmTLNOfAJNJNqL1JZj7YHx8GHsf6OaIX1T0EXpZEOq1PaDqm1iO4x0
         6QNNhMY4ZQiq0PMbcBAfXjEAfgmm4XZBq4S3XnpU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j9ajG-00A59R-E3; Wed, 04 Mar 2020 20:34:54 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation selection in the distributor
Date:   Wed,  4 Mar 2020 20:33:27 +0000
Message-Id: <20200304203330.4967-21-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304203330.4967-1-maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The GICv4.1 architecture gives the hypervisor the option to let
the guest choose whether it wants the good old SGIs with an
active state, or the new, HW-based ones that do not have one.

For this, plumb the configuration of SGIs into the GICv3 MMIO
handling, present the GICD_TYPER2.nASSGIcap to the guest,
and handle the GICD_CTLR.nASSGIreq setting.

In order to be able to deal with the restore of a guest, also
apply the GICD_CTLR.nASSGIreq setting at first run so that we
can move the restored SGIs to the HW if that's what the guest
had selected in a previous life.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 48 ++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-v3.c      |  2 ++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index de89da76a379..442f3b8c2559 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -3,6 +3,7 @@
  * VGICv3 MMIO handling functions
  */
 
+#include <linux/bitfield.h>
 #include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
@@ -70,6 +71,8 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 		if (vgic->enabled)
 			value |= GICD_CTLR_ENABLE_SS_G1;
 		value |= GICD_CTLR_ARE_NS | GICD_CTLR_DS;
+		if (kvm_vgic_global_state.has_gicv4_1 && vgic->nassgireq)
+			value |= GICD_CTLR_nASSGIreq;
 		break;
 	case GICD_TYPER:
 		value = vgic->nr_spis + VGIC_NR_PRIVATE_IRQS;
@@ -81,6 +84,10 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 			value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
 		}
 		break;
+	case GICD_TYPER2:
+		if (kvm_vgic_global_state.has_gicv4_1)
+			value = GICD_TYPER2_nASSGIcap;
+		break;
 	case GICD_IIDR:
 		value = (PRODUCT_ID_KVM << GICD_IIDR_PRODUCT_ID_SHIFT) |
 			(vgic->implementation_rev << GICD_IIDR_REVISION_SHIFT) |
@@ -98,17 +105,43 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 				    unsigned long val)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-	bool was_enabled = dist->enabled;
 
 	switch (addr & 0x0c) {
-	case GICD_CTLR:
+	case GICD_CTLR: {
+		bool was_enabled, is_hwsgi;
+
+		mutex_lock(&vcpu->kvm->lock);
+
+		was_enabled = dist->enabled;
+		is_hwsgi = dist->nassgireq;
+
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
 
+		/* Not a GICv4.1? No HW SGIs */
+		if (!kvm_vgic_global_state.has_gicv4_1)
+			val &= ~GICD_CTLR_nASSGIreq;
+
+		/* Dist stays enabled? nASSGIreq is RO */
+		if (was_enabled && dist->enabled) {
+			val &= ~GICD_CTLR_nASSGIreq;
+			val |= FIELD_PREP(GICD_CTLR_nASSGIreq, is_hwsgi);
+		}
+
+		/* Switching HW SGIs? */
+		dist->nassgireq = val & GICD_CTLR_nASSGIreq;
+		if (is_hwsgi != dist->nassgireq)
+			vgic_v4_configure_vsgis(vcpu->kvm);
+
 		if (!was_enabled && dist->enabled)
 			vgic_kick_vcpus(vcpu->kvm);
+
+		mutex_unlock(&vcpu->kvm->lock);
 		break;
+	}
 	case GICD_TYPER:
+	case GICD_TYPER2:
 	case GICD_IIDR:
+		/* This is at best for documentation purposes... */
 		return;
 	}
 }
@@ -117,10 +150,21 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 					   gpa_t addr, unsigned int len,
 					   unsigned long val)
 {
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+
 	switch (addr & 0x0c) {
 	case GICD_IIDR:
 		if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
 			return -EINVAL;
+		return 0;
+	case GICD_CTLR:
+		/* Not a GICv4.1? No HW SGIs */
+		if (!kvm_vgic_global_state.has_gicv4_1)
+			val &= ~GICD_CTLR_nASSGIreq;
+
+		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
+		dist->nassgireq = val & GICD_CTLR_nASSGIreq;
+		return 0;
 	}
 
 	vgic_mmio_write_v3_misc(vcpu, addr, len, val);
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 1bc09b523486..2c9fc13e2c59 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -540,6 +540,8 @@ int vgic_v3_map_resources(struct kvm *kvm)
 		goto out;
 	}
 
+	if (kvm_vgic_global_state.has_gicv4_1)
+		vgic_v4_configure_vsgis(kvm);
 	dist->ready = true;
 
 out:
-- 
2.20.1

