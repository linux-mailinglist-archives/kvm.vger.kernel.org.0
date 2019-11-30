Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC9610DC31
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2019 03:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfK3Cp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 21:45:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:50510 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727177AbfK3Cp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 21:45:28 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 96812B9628629FE8062D;
        Sat, 30 Nov 2019 10:45:25 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Sat, 30 Nov 2019
 10:45:17 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <maz@kernel.org>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <christoffer.dall@arm.com>,
        <catalin.marinas@arm.com>, <eric.auger@redhat.com>,
        <gregkh@linuxfoundation.org>, <will@kernel.org>,
        <andre.przywara@arm.com>, <tglx@linutronix.de>
CC:     <steven.price@arm.com>, <linmiaohe@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v3] KVM: vgic: Use wrapper function to lock/unlock all vcpus in kvm_vgic_create()
Date:   Sat, 30 Nov 2019 10:45:18 +0800
Message-ID: <1575081918-11401-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Use wrapper function lock_all_vcpus()/unlock_all_vcpus()
in kvm_vgic_create() to remove duplicated code dealing
with locking and unlocking all vcpus in a vm.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
-v2:
	Fix some spelling mistake in patch title and commit log.
-v3:
	Remove the comment that no longer makes sense.
---
 virt/kvm/arm/vgic/vgic-init.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index b3c5de48064c..22ff73ecac80 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -70,7 +70,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
  */
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
-	int i, vcpu_lock_idx = -1, ret;
+	int i, ret;
 	struct kvm_vcpu *vcpu;
 
 	if (irqchip_in_kernel(kvm))
@@ -86,17 +86,9 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		!kvm_vgic_global_state.can_emulate_gicv2)
 		return -ENODEV;
 
-	/*
-	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
-	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
-	 * that no other VCPUs are run while we create the vgic.
-	 */
 	ret = -EBUSY;
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!mutex_trylock(&vcpu->mutex))
-			goto out_unlock;
-		vcpu_lock_idx = i;
-	}
+	if (!lock_all_vcpus(kvm))
+		return ret;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu->arch.has_run_once)
@@ -125,10 +117,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
 out_unlock:
-	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
-		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
-		mutex_unlock(&vcpu->mutex);
-	}
+	unlock_all_vcpus(kvm);
 	return ret;
 }
 
-- 
2.19.1

