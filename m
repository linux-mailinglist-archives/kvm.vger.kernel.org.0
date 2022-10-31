Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2484B612E5F
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 01:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJaAjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 20:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJaAja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 20:39:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13FD95BF
        for <kvm@vger.kernel.org>; Sun, 30 Oct 2022 17:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667176718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=grdRprUQKNyQoVxwZKCiULgME4MZrUwACLwcip/PECs=;
        b=Bjk1ekTXbUtR6erZqAAX2i8d91VUqdc8O+gZoxQqg1AJM7/5H5BBwony27kXgSkfs9VsVo
        +yw9U9qGwWI9pqltH3v4qW3cJSDbZ3Iej4U9Miqn8I28eU29lwhVAp8GE/oe9KIe0CzJgO
        32r1umX8GE2kc4ENDA5cDQ80vDG+ukE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-LN1dxmwqPrKULuYAHtY2Gg-1; Sun, 30 Oct 2022 20:38:34 -0400
X-MC-Unique: LN1dxmwqPrKULuYAHtY2Gg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07B29833AED;
        Mon, 31 Oct 2022 00:38:34 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-151.bne.redhat.com [10.64.54.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39BA140C6F9F;
        Mon, 31 Oct 2022 00:38:26 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, ajones@ventanamicro.com, maz@kernel.org,
        bgardon@google.com, catalin.marinas@arm.com, dmatlack@google.com,
        will@kernel.org, pbonzini@redhat.com, peterx@redhat.com,
        oliver.upton@linux.dev, seanjc@google.com, james.morse@arm.com,
        shuah@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v7 5/9] KVM: arm64: Improve no-running-vcpu report for dirty ring
Date:   Mon, 31 Oct 2022 08:36:17 +0800
Message-Id: <20221031003621.164306-6-gshan@redhat.com>
In-Reply-To: <20221031003621.164306-1-gshan@redhat.com>
References: <20221031003621.164306-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP should be enabled only when KVM
device "kvm-arm-vgic-its" is used by userspace. Currently, it's the
only case where a running VCPU is missed for dirty ring. However,
there are potentially other devices introducing similar error in
future.

In order to report those broken devices only, the no-running-vcpu
warning message is escaped from KVM device "kvm-arm-vgic-its". For
this, the function vgic_has_its() needs to be exposed with a more
generic function name (kvm_vgic_has_its()).

Link: https://lore.kernel.org/kvmarm/Y1ghIKrAsRFwSFsO@google.com
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/mmu.c               | 14 ++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c    |  4 ++--
 arch/arm64/kvm/vgic/vgic-irqfd.c   |  4 ++--
 arch/arm64/kvm/vgic/vgic-its.c     |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 18 ++++--------------
 arch/arm64/kvm/vgic/vgic.c         | 10 ++++++++++
 arch/arm64/kvm/vgic/vgic.h         |  1 -
 include/kvm/arm_vgic.h             |  1 +
 include/linux/kvm_dirty_ring.h     |  1 +
 virt/kvm/dirty_ring.c              |  5 +++++
 virt/kvm/kvm_main.c                |  2 +-
 11 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 60ee3d9f01f8..e0855b2b3d66 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -932,6 +932,20 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
+/*
+ * kvm_arch_allow_write_without_running_vcpu - allow writing guest memory
+ * without the running VCPU when dirty ring is enabled.
+ *
+ * The running VCPU is required to track dirty guest pages when dirty ring
+ * is enabled. Otherwise, the backup bitmap should be used to track the
+ * dirty guest pages. When vgic/its is enabled, we need to use the backup
+ * bitmap to track the dirty guest pages for it.
+ */
+bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
+{
+	return kvm->dirty_ring_with_bitmap && kvm_vgic_has_its(kvm);
+}
+
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index f6d4f4052555..4c7f443c6d3d 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -296,7 +296,7 @@ int vgic_init(struct kvm *kvm)
 		}
 	}
 
-	if (vgic_has_its(kvm))
+	if (kvm_vgic_has_its(kvm))
 		vgic_lpi_translation_cache_init(kvm);
 
 	/*
@@ -352,7 +352,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
 	}
 
-	if (vgic_has_its(kvm))
+	if (kvm_vgic_has_its(kvm))
 		vgic_lpi_translation_cache_destroy(kvm);
 
 	if (vgic_supports_direct_msis(kvm))
diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 475059bacedf..e33cc34bf8f5 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -88,7 +88,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 {
 	struct kvm_msi msi;
 
-	if (!vgic_has_its(kvm))
+	if (!kvm_vgic_has_its(kvm))
 		return -ENODEV;
 
 	if (!level)
@@ -112,7 +112,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 	case KVM_IRQ_ROUTING_MSI: {
 		struct kvm_msi msi;
 
-		if (!vgic_has_its(kvm))
+		if (!kvm_vgic_has_its(kvm))
 			break;
 
 		kvm_populate_msi(e, &msi);
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 733b53055f97..40622da7348a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -698,7 +698,7 @@ struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
 	struct kvm_io_device *kvm_io_dev;
 	struct vgic_io_device *iodev;
 
-	if (!vgic_has_its(kvm))
+	if (!kvm_vgic_has_its(kvm))
 		return ERR_PTR(-ENODEV);
 
 	if (!(msi->flags & KVM_MSI_VALID_DEVID))
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 91201f743033..10218057c176 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -38,20 +38,10 @@ u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
 	return reg | ((u64)val << lower);
 }
 
-bool vgic_has_its(struct kvm *kvm)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-
-	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
-		return false;
-
-	return dist->has_its;
-}
-
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
 	return (kvm_vgic_global_state.has_gicv4_1 ||
-		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
+		(kvm_vgic_global_state.has_gicv4 && kvm_vgic_has_its(kvm)));
 }
 
 /*
@@ -78,7 +68,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 	case GICD_TYPER:
 		value = vgic->nr_spis + VGIC_NR_PRIVATE_IRQS;
 		value = (value >> 5) - 1;
-		if (vgic_has_its(vcpu->kvm)) {
+		if (kvm_vgic_has_its(vcpu->kvm)) {
 			value |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
 			value |= GICD_TYPER_LPIS;
 		} else {
@@ -262,7 +252,7 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	u32 ctlr;
 
-	if (!vgic_has_its(vcpu->kvm))
+	if (!kvm_vgic_has_its(vcpu->kvm))
 		return;
 
 	if (!(val & GICR_CTLR_ENABLE_LPIS)) {
@@ -326,7 +316,7 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
 	value |= ((target_vcpu_id & 0xffff) << 8);
 
-	if (vgic_has_its(vcpu->kvm))
+	if (kvm_vgic_has_its(vcpu->kvm))
 		value |= GICR_TYPER_PLPIS;
 
 	if (vgic_mmio_vcpu_rdist_is_last(vcpu))
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d97e6080b421..9ef7488ed0c7 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -21,6 +21,16 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
 	.gicv3_cpuif = STATIC_KEY_FALSE_INIT,
 };
 
+bool kvm_vgic_has_its(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+		return false;
+
+	return dist->has_its;
+}
+
 /*
  * Locking order is always:
  * kvm->lock (mutex)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0c8da72953f0..f91114ee1cd5 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -235,7 +235,6 @@ void vgic_v3_load(struct kvm_vcpu *vcpu);
 void vgic_v3_put(struct kvm_vcpu *vcpu);
 void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu);
 
-bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4df9e73a8bb5..72e9bc6c66a4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -374,6 +374,7 @@ int kvm_vgic_map_resources(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
 void kvm_vgic_init_cpu_hardware(void);
 
+bool kvm_vgic_has_its(struct kvm *kvm);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level, void *owner);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index b08b9afd8bdb..bb0a72401b5a 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -72,6 +72,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 
 int kvm_cpu_dirty_log_size(void);
 bool kvm_use_dirty_bitmap(struct kvm *kvm);
+bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm);
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
 
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 7ce6a5f81c98..f27e038043f3 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -26,6 +26,11 @@ bool kvm_use_dirty_bitmap(struct kvm *kvm)
 	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
 }
 
+bool __weak kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
+{
+	return kvm->dirty_ring_with_bitmap;
+}
+
 static u32 kvm_dirty_ring_used(struct kvm_dirty_ring *ring)
 {
 	return READ_ONCE(ring->dirty_index) - READ_ONCE(ring->reset_index);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0351c8fb41b9..e1be4f89df3b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3308,7 +3308,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
 		return;
 
-	if (WARN_ON_ONCE(!kvm->dirty_ring_with_bitmap && !vcpu))
+	if (WARN_ON_ONCE(!kvm_arch_allow_write_without_running_vcpu(kvm) && !vcpu))
 		return;
 #endif
 
-- 
2.23.0

