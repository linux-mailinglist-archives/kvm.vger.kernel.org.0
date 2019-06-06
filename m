Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F53D37A42
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbfFFQzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:55:22 -0400
Received: from foss.arm.com ([217.140.101.70]:50836 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728718AbfFFQzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:55:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 988431713;
        Thu,  6 Jun 2019 09:55:21 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB8453F690;
        Thu,  6 Jun 2019 09:55:19 -0700 (PDT)
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
Subject: [PATCH 8/8] KVM: arm/arm64: vgic-irqfd: Implement kvm_arch_set_irq_inatomic
Date:   Thu,  6 Jun 2019 17:54:55 +0100
Message-Id: <20190606165455.162478-9-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190606165455.162478-1-marc.zyngier@arm.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have a cache of MSI->LPI translations, it is pretty
easy to implement kvm_arch_set_irq_inatomic (this cache can be
parsed without sleeping).

Hopefully, this will improve some LPI-heavy workloads.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-irqfd.c | 36 ++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index 99e026d2dade..9f203ed8c8f3 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -77,6 +77,15 @@ int kvm_set_routing_entry(struct kvm *kvm,
 	return r;
 }
 
+static void kvm_populate_msi(struct kvm_kernel_irq_routing_entry *e,
+			     struct kvm_msi *msi)
+{
+	msi->address_lo = e->msi.address_lo;
+	msi->address_hi = e->msi.address_hi;
+	msi->data = e->msi.data;
+	msi->flags = e->msi.flags;
+	msi->devid = e->msi.devid;
+}
 /**
  * kvm_set_msi: inject the MSI corresponding to the
  * MSI routing entry
@@ -90,21 +99,36 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 {
 	struct kvm_msi msi;
 
-	msi.address_lo = e->msi.address_lo;
-	msi.address_hi = e->msi.address_hi;
-	msi.data = e->msi.data;
-	msi.flags = e->msi.flags;
-	msi.devid = e->msi.devid;
-
 	if (!vgic_has_its(kvm))
 		return -ENODEV;
 
 	if (!level)
 		return -1;
 
+	kvm_populate_msi(e, &msi);
 	return vgic_its_inject_msi(kvm, &msi);
 }
 
+/**
+ * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
+ *
+ * Currently only direct MSI injecton is supported.
+ */
+int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
+			      struct kvm *kvm, int irq_source_id, int level,
+			      bool line_status)
+{
+	if (e->type == KVM_IRQ_ROUTING_MSI && vgic_has_its(kvm) && level) {
+		struct kvm_msi msi;
+
+		kvm_populate_msi(e, &msi);
+		if (!vgic_its_inject_cached_translation(kvm, &msi))
+			return 0;
+	}
+
+	return -EWOULDBLOCK;
+}
+
 int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
 {
 	struct kvm_irq_routing_entry *entries;
-- 
2.20.1

