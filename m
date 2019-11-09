Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDF2F5E46
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 10:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfKIJqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Nov 2019 04:46:42 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5755 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726143AbfKIJqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Nov 2019 04:46:42 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 39E474CDAB06F0AC8E99;
        Sat,  9 Nov 2019 17:46:39 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 9 Nov 2019
 17:46:28 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: APIC: add helper func to remove duplicate code in kvm_pv_send_ipi
Date:   Sat, 9 Nov 2019 17:46:49 +0800
Message-ID: <1573292809-18181-1-git-send-email-linmiaohe@huawei.com>
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

There are some duplicate code in kvm_pv_send_ipi when deal with ipi
bitmap. Add helper func to remove it, and eliminate odd out label,
get rid of unnecessary kvm_lapic_irq field init and so on.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/lapic.c | 65 ++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b29d00b661ff..2f8f10103f5f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -557,60 +557,53 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 			irq->level, irq->trig_mode, dest_map);
 }
 
+static int __pv_send_ipi(unsigned long *ipi_bitmap, struct kvm_apic_map *map,
+			 struct kvm_lapic_irq *irq, u32 min)
+{
+	int i, count = 0;
+	struct kvm_vcpu *vcpu;
+
+	if (min > map->max_apic_id)
+		return 0;
+
+	for_each_set_bit(i, ipi_bitmap,
+		min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
+		if (map->phys_map[min + i]) {
+			vcpu = map->phys_map[min + i]->vcpu;
+			count += kvm_apic_set_irq(vcpu, irq, NULL);
+		}
+	}
+
+	return count;
+}
+
 int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 		    unsigned long ipi_bitmap_high, u32 min,
 		    unsigned long icr, int op_64_bit)
 {
-	int i;
 	struct kvm_apic_map *map;
-	struct kvm_vcpu *vcpu;
 	struct kvm_lapic_irq irq = {0};
 	int cluster_size = op_64_bit ? 64 : 32;
-	int count = 0;
+	int count;
+
+	if (icr & (APIC_DEST_MASK | APIC_SHORT_MASK))
+		return -KVM_EINVAL;
 
 	irq.vector = icr & APIC_VECTOR_MASK;
 	irq.delivery_mode = icr & APIC_MODE_MASK;
 	irq.level = (icr & APIC_INT_ASSERT) != 0;
 	irq.trig_mode = icr & APIC_INT_LEVELTRIG;
 
-	if (icr & APIC_DEST_MASK)
-		return -KVM_EINVAL;
-	if (icr & APIC_SHORT_MASK)
-		return -KVM_EINVAL;
-
 	rcu_read_lock();
 	map = rcu_dereference(kvm->arch.apic_map);
 
-	if (unlikely(!map)) {
-		count = -EOPNOTSUPP;
-		goto out;
+	count = -EOPNOTSUPP;
+	if (likely(map)) {
+		count = __pv_send_ipi(&ipi_bitmap_low, map, &irq, min);
+		min += cluster_size;
+		count += __pv_send_ipi(&ipi_bitmap_high, map, &irq, min);
 	}
 
-	if (min > map->max_apic_id)
-		goto out;
-	/* Bits above cluster_size are masked in the caller.  */
-	for_each_set_bit(i, &ipi_bitmap_low,
-		min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
-		if (map->phys_map[min + i]) {
-			vcpu = map->phys_map[min + i]->vcpu;
-			count += kvm_apic_set_irq(vcpu, &irq, NULL);
-		}
-	}
-
-	min += cluster_size;
-
-	if (min > map->max_apic_id)
-		goto out;
-
-	for_each_set_bit(i, &ipi_bitmap_high,
-		min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
-		if (map->phys_map[min + i]) {
-			vcpu = map->phys_map[min + i]->vcpu;
-			count += kvm_apic_set_irq(vcpu, &irq, NULL);
-		}
-	}
-
-out:
 	rcu_read_unlock();
 	return count;
 }
-- 
2.19.1

