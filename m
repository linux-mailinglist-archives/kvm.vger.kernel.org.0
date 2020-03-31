Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB174199647
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbgCaMVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 08:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730343AbgCaMVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 08:21:06 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAC2E20838;
        Tue, 31 Mar 2020 12:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585657265;
        bh=XFgOGztNav7cLSwhDbDR0xm2oUHbC/mKjfQIQOkZAm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4k3ALl7Bq4/5arvR6Y3KeSJ4X8G3hJtyl9J5kneyq29I9g6eCbD4yS+Lke3j/s8Z
         IrRqz3ov3FaNtcGX75C6ZcN1tLvN0HQtjueEoXjCNnehdm7mE/dJcz1isfi6Kc2MpX
         tATR2r/5NHkKSSSXZivg+I0erqNS9ty1QDOCyYvk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jJFpY-00HBlI-Fz; Tue, 31 Mar 2020 13:17:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 12/15] KVM: arm64: GICv4.1: Plumb SGI implementation selection in the distributor
Date:   Tue, 31 Mar 2020 13:16:42 +0100
Message-Id: <20200331121645.388250-13-maz@kernel.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200331121645.388250-1-maz@kernel.org>
References: <20200331121645.388250-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@arm.com, eric.auger@redhat.com, karahmed@amazon.de, linus.walleij@linaro.org, olof@lixom.net, vladimir.murzin@arm.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/r/20200304203330.4967-21-maz@kernel.org
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 49 ++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-v3.c      |  2 ++
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index f4da9d1a6bff..905032a03886 100644
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
+		if (vgic->nassgireq)
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
@@ -117,10 +150,22 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 					   gpa_t addr, unsigned int len,
 					   unsigned long val)
 {
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+
 	switch (addr & 0x0c) {
+	case GICD_TYPER2:
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
2.25.0

