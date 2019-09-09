Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A7BADA55
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 15:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404876AbfIINtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 09:49:17 -0400
Received: from foss.arm.com ([217.140.110.172]:50676 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731376AbfIINtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 09:49:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72D2719BF;
        Mon,  9 Sep 2019 06:49:16 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FDCE3F59C;
        Mon,  9 Sep 2019 06:49:14 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/17] KVM: arm/arm64: vgic-irqfd: Implement kvm_arch_set_irq_inatomic
Date:   Mon,  9 Sep 2019 14:48:00 +0100
Message-Id: <20190909134807.27978-11-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
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

Tested-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-irqfd.c | 36 ++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index c9304b88e720..d8cdfea5cc96 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -66,6 +66,15 @@ int kvm_set_routing_entry(struct kvm *kvm,
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
@@ -79,21 +88,36 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
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
+ * Currently only direct MSI injection is supported.
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

