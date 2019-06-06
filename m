Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97DBF37A40
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfFFQzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:55:18 -0400
Received: from foss.arm.com ([217.140.101.70]:50804 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729641AbfFFQzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:55:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80A1E1688;
        Thu,  6 Jun 2019 09:55:17 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B44903F690;
        Thu,  6 Jun 2019 09:55:15 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
Subject: [PATCH 6/8] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on disabling LPIs
Date:   Thu,  6 Jun 2019 17:54:53 +0100
Message-Id: <20190606165455.162478-7-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190606165455.162478-1-marc.zyngier@arm.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a vcpu disables LPIs at its redistributor level, we need to make sure
we won't pend more interrupts. For this, we need to invalidate the LPI
translation cache.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c     | 2 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 4 +++-
 virt/kvm/arm/vgic/vgic.h         | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 62917aa15493..bd76683781e8 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -577,7 +577,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 }
 
-static void vgic_its_invalidate_cache(struct kvm *kvm)
+void vgic_its_invalidate_cache(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_translation_cache_entry *cte;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 9f4843fe9cda..2aea9f40fecd 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -200,8 +200,10 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 
 	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
 
-	if (was_enabled && !vgic_cpu->lpis_enabled)
+	if (was_enabled && !vgic_cpu->lpis_enabled) {
 		vgic_flush_pending_lpis(vcpu);
+		vgic_its_invalidate_cache(vcpu->kvm);
+	}
 
 	if (!was_enabled && vgic_cpu->lpis_enabled)
 		vgic_enable_lpis(vcpu);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 80cd40575bc9..04335e997907 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -318,6 +318,7 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
 void vgic_lpi_translation_cache_init(struct kvm *kvm);
+void vgic_its_invalidate_cache(struct kvm *kvm);
 
 #define LPI_CACHE_SIZE(kvm)	(atomic_read(&(kvm)->online_vcpus) * 4)
 
-- 
2.20.1

