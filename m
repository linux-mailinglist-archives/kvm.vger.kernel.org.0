Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2F9ADA41
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 15:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731219AbfIINsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 09:48:54 -0400
Received: from foss.arm.com ([217.140.110.172]:50504 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbfIINsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 09:48:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21E221570;
        Mon,  9 Sep 2019 06:48:53 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFB6F3F59C;
        Mon,  9 Sep 2019 06:48:50 -0700 (PDT)
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
Subject: [PATCH 01/17] KVM: arm/arm64: vgic: Add LPI translation cache definition
Date:   Mon,  9 Sep 2019 14:47:51 +0100
Message-Id: <20190909134807.27978-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the basic data structure that expresses an MSI to LPI
translation as well as the allocation/release hooks.

The size of the cache is arbitrarily defined as 16*nr_vcpus.

Tested-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/kvm/arm_vgic.h        |  3 +++
 virt/kvm/arm/vgic/vgic-init.c |  5 ++++
 virt/kvm/arm/vgic/vgic-its.c  | 49 +++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h      |  2 ++
 4 files changed, 59 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7a30524a80ee..ded50a30e2d5 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -249,6 +249,9 @@ struct vgic_dist {
 	struct list_head	lpi_list_head;
 	int			lpi_list_count;
 
+	/* LPI translation cache */
+	struct list_head	lpi_translation_cache;
+
 	/* used by vgic-debug */
 	struct vgic_state_iter *iter;
 
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index bdbc297d06fb..80127ca9269f 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -53,6 +53,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
 	INIT_LIST_HEAD(&dist->lpi_list_head);
+	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
 }
 
@@ -294,6 +295,7 @@ int vgic_init(struct kvm *kvm)
 	}
 
 	if (vgic_has_its(kvm)) {
+		vgic_lpi_translation_cache_init(kvm);
 		ret = vgic_v4_init(kvm);
 		if (ret)
 			goto out;
@@ -335,6 +337,9 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		INIT_LIST_HEAD(&dist->rd_regions);
 	}
 
+	if (vgic_has_its(kvm))
+		vgic_lpi_translation_cache_destroy(kvm);
+
 	if (vgic_supports_direct_msis(kvm))
 		vgic_v4_teardown(kvm);
 }
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 482036612adf..0e5c1519bbe2 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -138,6 +138,14 @@ struct its_ite {
 	u32 event_id;
 };
 
+struct vgic_translation_cache_entry {
+	struct list_head	entry;
+	phys_addr_t		db;
+	u32			devid;
+	u32			eventid;
+	struct vgic_irq		*irq;
+};
+
 /**
  * struct vgic_its_abi - ITS abi ops and settings
  * @cte_esz: collection table entry size
@@ -1657,6 +1665,45 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
 	return ret;
 }
 
+/* Default is 16 cached LPIs per vcpu */
+#define LPI_DEFAULT_PCPU_CACHE_SIZE	16
+
+void vgic_lpi_translation_cache_init(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	unsigned int sz;
+	int i;
+
+	if (!list_empty(&dist->lpi_translation_cache))
+		return;
+
+	sz = atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
+
+	for (i = 0; i < sz; i++) {
+		struct vgic_translation_cache_entry *cte;
+
+		/* An allocation failure is not fatal */
+		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
+		if (WARN_ON(!cte))
+			break;
+
+		INIT_LIST_HEAD(&cte->entry);
+		list_add(&cte->entry, &dist->lpi_translation_cache);
+	}
+}
+
+void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_translation_cache_entry *cte, *tmp;
+
+	list_for_each_entry_safe(cte, tmp,
+				 &dist->lpi_translation_cache, entry) {
+		list_del(&cte->entry);
+		kfree(cte);
+	}
+}
+
 #define INITIAL_BASER_VALUE						  \
 	(GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)		| \
 	 GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, SameAsInner)		| \
@@ -1685,6 +1732,8 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 			kfree(its);
 			return ret;
 		}
+
+		vgic_lpi_translation_cache_init(dev->kvm);
 	}
 
 	mutex_init(&its->its_lock);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 797e05004d80..a25b790ffa4e 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -307,6 +307,8 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
+void vgic_lpi_translation_cache_init(struct kvm *kvm);
+void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
 
 bool vgic_supports_direct_msis(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
-- 
2.20.1

