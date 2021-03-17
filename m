Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C6033E934
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 06:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhCQFrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 01:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCQFqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 01:46:38 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8106FC06174A;
        Tue, 16 Mar 2021 22:46:38 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so735967pjv.1;
        Tue, 16 Mar 2021 22:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sFTz8R2vigLKi9iWMm18EDY9PtezCXHbF1qxsbTA9V8=;
        b=kF9n2d9+uTFBuq2VaPeXXOyF8Qnw1Wsqzb7UKEXl7ar5PrLbwd81nsHSLfxkTVnISc
         +aXQilVPfyfwK44D51PHoVex0TA1TPmC5yROYAtk5/cWEu0NJaxjaIKTV82p7wDXu48H
         eGEfJjAB7swZi1FGw/A1cKBUeKM3puivg64cJMimefTVBOwVIUjs3wrelmPY2qhBPKvM
         Mlb5FAQgk8+sfP8ZqpdF9fJLdVjTQ5fJW4d0wG82iON+8xSnqJHEygMj5nwAUhB/urvB
         bC8jVOerxWilrEloQm+MyCipAiKexn7GicaUl2sqkrE6Gn/GYZvJPCmBcU6jmntoJbrX
         GyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sFTz8R2vigLKi9iWMm18EDY9PtezCXHbF1qxsbTA9V8=;
        b=bXfV/2qHCxjHTuXMuiXcu20UY4GkFbgCdrQg9YcEqq66uwJ4+6CfDAv1BuhtuxMfEM
         iZCej1br8/IKlkzt1Gbod4h0V9rJ0Qk7lkQlfTgT6q+6icBS07NiomyYq2dLMx4/ymZP
         ml6o3qdOeiu0T/UBXrNBLwCwMbHBMScYriQ8ySxgi0kwn95I3bEc19Fj9NaHHOZSmlOH
         ZC6xEHWeVIm2JI9gvq4t+pebsdPd/iNSrpPTCUO6cjVqgpl5uu6aPJJQ0bbVqttC6SkL
         xeC7EQmI55vyfbVENIVhLmGuwjX3WXrh3iEluYBpGNv+GDSMKrZV/Kg6+0ZN4WXpE3JG
         JAig==
X-Gm-Message-State: AOAM533turufVoFXQ4la5n/8KUWy0LaEnZShuyFtllP8Vxf88bMpVSZW
        4dcB8NHcU6mnqWzEUrNliQFuKGf/DW8=
X-Google-Smtp-Source: ABdhPJyUgQR7mBw9H3mhAkzBcPXVCK0KCgfJTy/xGnHVDgoL/DbAKl8A/M7m1DsNAdhvsQmkHpXT3g==
X-Received: by 2002:a17:902:9786:b029:e6:508a:7b8c with SMTP id q6-20020a1709029786b02900e6508a7b8cmr2928412plp.44.1615959997715;
        Tue, 16 Mar 2021 22:46:37 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id gw20sm1183198pjb.3.2021.03.16.22.46.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Mar 2021 22:46:36 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: arm: memcg awareness
Date:   Wed, 17 Mar 2021 13:46:24 +0800
Message-Id: <1615959984-7122-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

KVM allocations in the arm kvm code which are tied to the life 
of the VM process should be charged to the VM process's cgroup.
This will help the memcg controler to do the right decisions.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/arm64/kvm/arm.c               |  5 +++--
 arch/arm64/kvm/hyp/pgtable.c       |  4 ++--
 arch/arm64/kvm/mmu.c               |  4 ++--
 arch/arm64/kvm/pmu-emul.c          |  2 +-
 arch/arm64/kvm/reset.c             |  2 +-
 arch/arm64/kvm/vgic/vgic-debug.c   |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c   |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c     | 14 +++++++-------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  2 +-
 arch/arm64/kvm/vgic/vgic-v4.c      |  2 +-
 11 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7f06ba7..8040874 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -278,9 +278,10 @@ long kvm_arch_dev_ioctl(struct file *filp,
 struct kvm *kvm_arch_alloc_vm(void)
 {
 	if (!has_vhe())
-		return kzalloc(sizeof(struct kvm), GFP_KERNEL);
+		return kzalloc(sizeof(struct kvm), GFP_KERNEL_ACCOUNT);
 
-	return vzalloc(sizeof(struct kvm));
+	return __vmalloc(sizeof(struct kvm),
+			GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 }
 
 void kvm_arch_free_vm(struct kvm *kvm)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 926fc07..a0845d3 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -366,7 +366,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
-	childp = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
+	childp = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!childp)
 		return -ENOMEM;
 
@@ -401,7 +401,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits)
 {
 	u64 levels = ARM64_HW_PGTABLE_LEVELS(va_bits);
 
-	pgt->pgd = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
+	pgt->pgd = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!pgt->pgd)
 		return -ENOMEM;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8711894..8c9dc49 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -370,7 +370,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 		return -EINVAL;
 	}
 
-	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL);
+	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL_ACCOUNT);
 	if (!pgt)
 		return -ENOMEM;
 
@@ -1244,7 +1244,7 @@ int kvm_mmu_init(void)
 		goto out;
 	}
 
-	hyp_pgtable = kzalloc(sizeof(*hyp_pgtable), GFP_KERNEL);
+	hyp_pgtable = kzalloc(sizeof(*hyp_pgtable), GFP_KERNEL_ACCOUNT);
 	if (!hyp_pgtable) {
 		kvm_err("Hyp mode page-table not allocated\n");
 		err = -ENOMEM;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e32c6e1..00cf750 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -967,7 +967,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		mutex_lock(&vcpu->kvm->lock);
 
 		if (!vcpu->kvm->arch.pmu_filter) {
-			vcpu->kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL);
+			vcpu->kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
 			if (!vcpu->kvm->arch.pmu_filter) {
 				mutex_unlock(&vcpu->kvm->lock);
 				return -ENOMEM;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index bd354cd..3cbcf6b 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -110,7 +110,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 		    vl > SVE_VL_ARCH_MAX))
 		return -EIO;
 
-	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL);
+	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL_ACCOUNT);
 	if (!buf)
 		return -ENOMEM;
 
diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index f38c40a..e6a01f2 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -92,7 +92,7 @@ static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
 		goto out;
 	}
 
-	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	iter = kmalloc(sizeof(*iter), GFP_KERNEL_ACCOUNT);
 	if (!iter) {
 		iter = ERR_PTR(-ENOMEM);
 		goto out;
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 052917d..27d1513 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -134,7 +134,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
 	int i;
 
-	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL);
+	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL_ACCOUNT);
 	if (!dist->spis)
 		return  -ENOMEM;
 
diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 79f8899..475059b 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -139,7 +139,7 @@ int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
 	u32 nr = dist->nr_spis;
 	int i, ret;
 
-	entries = kcalloc(nr, sizeof(*entries), GFP_KERNEL);
+	entries = kcalloc(nr, sizeof(*entries), GFP_KERNEL_ACCOUNT);
 	if (!entries)
 		return -ENOMEM;
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 40cbaca..bd90730 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -48,7 +48,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	if (irq)
 		return irq;
 
-	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL);
+	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL_ACCOUNT);
 	if (!irq)
 		return ERR_PTR(-ENOMEM);
 
@@ -332,7 +332,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	 * we must be careful not to overrun the array.
 	 */
 	irq_count = READ_ONCE(dist->lpi_list_count);
-	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL);
+	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL_ACCOUNT);
 	if (!intids)
 		return -ENOMEM;
 
@@ -985,7 +985,7 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
 	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
 		return E_ITS_MAPC_COLLECTION_OOR;
 
-	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
+	collection = kzalloc(sizeof(*collection), GFP_KERNEL_ACCOUNT);
 	if (!collection)
 		return -ENOMEM;
 
@@ -1029,7 +1029,7 @@ static struct its_ite *vgic_its_alloc_ite(struct its_device *device,
 {
 	struct its_ite *ite;
 
-	ite = kzalloc(sizeof(*ite), GFP_KERNEL);
+	ite = kzalloc(sizeof(*ite), GFP_KERNEL_ACCOUNT);
 	if (!ite)
 		return ERR_PTR(-ENOMEM);
 
@@ -1150,7 +1150,7 @@ static struct its_device *vgic_its_alloc_device(struct vgic_its *its,
 {
 	struct its_device *device;
 
-	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	device = kzalloc(sizeof(*device), GFP_KERNEL_ACCOUNT);
 	if (!device)
 		return ERR_PTR(-ENOMEM);
 
@@ -1847,7 +1847,7 @@ void vgic_lpi_translation_cache_init(struct kvm *kvm)
 		struct vgic_translation_cache_entry *cte;
 
 		/* An allocation failure is not fatal */
-		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
+		cte = kzalloc(sizeof(*cte), GFP_KERNEL_ACCOUNT);
 		if (WARN_ON(!cte))
 			break;
 
@@ -1888,7 +1888,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	if (type != KVM_DEV_TYPE_ARM_VGIC_ITS)
 		return -ENODEV;
 
-	its = kzalloc(sizeof(struct vgic_its), GFP_KERNEL);
+	its = kzalloc(sizeof(struct vgic_its), GFP_KERNEL_ACCOUNT);
 	if (!its)
 		return -ENOMEM;
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 15a6c98..22ab4ba 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -826,7 +826,7 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
 	if (vgic_v3_rdist_overlap(kvm, base, size))
 		return -EINVAL;
 
-	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL);
+	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL_ACCOUNT);
 	if (!rdreg)
 		return -ENOMEM;
 
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 66508b0..a80cc37 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -227,7 +227,7 @@ int vgic_v4_init(struct kvm *kvm)
 	nr_vcpus = atomic_read(&kvm->online_vcpus);
 
 	dist->its_vm.vpes = kcalloc(nr_vcpus, sizeof(*dist->its_vm.vpes),
-				    GFP_KERNEL);
+				    GFP_KERNEL_ACCOUNT);
 	if (!dist->its_vm.vpes)
 		return -ENOMEM;
 
-- 
2.7.4

