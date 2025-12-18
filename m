Return-Path: <kvm+bounces-66253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 08738CCBAC4
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 12:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 559DA3111CA5
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 11:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF7631B11F;
	Thu, 18 Dec 2025 11:43:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7469531AA86;
	Thu, 18 Dec 2025 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766058184; cv=none; b=OG4DLNdC38Ec7dDbIvnAnrjp/8m1qtJANbM1CJ3+wvHCMRHIeHUSMgLpojFKH/Wc9h8LRsZjMCmbKSUz8QhbXa2aL8xmxCAfrLpLe3rvn5jpCMcGMl3N/alJWR8qMgifLXMQXRA5BiVBj8L+mtNhAROYnP/BYimzfEQ12shR7LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766058184; c=relaxed/simple;
	bh=Ox30KXodUkBQZM4ADTFG2Sa0nEW2eIGMkgfy6aKBS5o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AWEyXU4pgBYQoDzyN9HD+qtUAwmhuZ/x03t3lCtsGEv6Hfj7ry/tvvKVx9pmRjtX3rvdJwCSTsIFtOXZWpRL/vOu2MHPWS56B/SMMvWT8MYbEyoWZM7372fvwyPrPZaiZxtp3de5+ySPK4HKbWQYnx0hFIu1Um2N7SXMPASCwig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8BxWcK86ENpZ3QAAA--.1317S3;
	Thu, 18 Dec 2025 19:42:52 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx2+C56ENpqFABAA--.5610S4;
	Thu, 18 Dec 2025 19:42:52 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] LongArch: KVM: Add irqfd set dmsintc msg irq
Date: Thu, 18 Dec 2025 19:18:21 +0800
Message-Id: <20251218111822.975455-3-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20251218111822.975455-1-gaosong@loongson.cn>
References: <20251218111822.975455-1-gaosong@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2+C56ENpqFABAA--.5610S4
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add irqfd choice dmsintc to set msi irq by the msg_addr and
implement dmsintc set msi irq.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/kvm_dmsintc.h |  1 +
 arch/loongarch/kvm/intc/dmsintc.c        |  6 ++++
 arch/loongarch/kvm/irqfd.c               | 45 ++++++++++++++++++++----
 3 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch/include/asm/kvm_dmsintc.h
index 1d4f66996f3c..9b5436a2fcbe 100644
--- a/arch/loongarch/include/asm/kvm_dmsintc.h
+++ b/arch/loongarch/include/asm/kvm_dmsintc.h
@@ -11,6 +11,7 @@ struct loongarch_dmsintc  {
 	struct kvm *kvm;
 	uint64_t msg_addr_base;
 	uint64_t msg_addr_size;
+	uint32_t cpu_mask;
 };
 
 struct dmsintc_state {
diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/dmsintc.c
index 3fdea81a08c8..9ecb2e3e352d 100644
--- a/arch/loongarch/kvm/intc/dmsintc.c
+++ b/arch/loongarch/kvm/intc/dmsintc.c
@@ -15,6 +15,7 @@ static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
 	void __user *data;
 	struct loongarch_dmsintc *s = dev->kvm->arch.dmsintc;
 	u64 tmp;
+	u32 cpu_bit;
 
 	data = (void __user *)attr->addr;
 	switch (addr) {
@@ -30,6 +31,11 @@ static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
 				s->msg_addr_base = tmp;
 			else
 				return  -EFAULT;
+			s->msg_addr_base = tmp;
+			cpu_bit = find_first_bit((unsigned long *)&(s->msg_addr_base), 64)
+						- AVEC_CPU_SHIFT;
+			cpu_bit = min(cpu_bit, AVEC_CPU_BIT);
+			s->cpu_mask = GENMASK(cpu_bit - 1, 0) & AVEC_CPU_MASK;
 		}
 		break;
 	case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
index 9a39627aecf0..11f980474552 100644
--- a/arch/loongarch/kvm/irqfd.c
+++ b/arch/loongarch/kvm/irqfd.c
@@ -6,6 +6,7 @@
 #include <linux/kvm_host.h>
 #include <trace/events/kvm.h>
 #include <asm/kvm_pch_pic.h>
+#include <asm/kvm_vcpu.h>
 
 static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id, int level, bool line_status)
@@ -16,6 +17,41 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 	return 0;
 }
 
+static int kvm_dmsintc_set_msi_irq(struct kvm *kvm, u32 addr, int data, int level)
+{
+	unsigned int virq, dest;
+	struct kvm_vcpu *vcpu;
+
+	virq = (addr >> AVEC_IRQ_SHIFT) & AVEC_IRQ_MASK;
+	dest = (addr >> AVEC_CPU_SHIFT) & kvm->arch.dmsintc->cpu_mask;
+	if (dest > KVM_MAX_VCPUS)
+		return -EINVAL;
+	vcpu = kvm_get_vcpu_by_cpuid(kvm, dest);
+	if (!vcpu)
+		return -EINVAL;
+	return kvm_loongarch_deliver_msi_to_vcpu(kvm, vcpu, virq, level);
+}
+
+static int loongarch_set_msi(struct kvm_kernel_irq_routing_entry *e,
+			struct kvm *kvm, int level)
+{
+	u64 msg_addr;
+
+	if (!level)
+		return -1;
+
+	msg_addr = (((u64)e->msi.address_hi) << 32) | e->msi.address_lo;
+	if (cpu_has_msgint && kvm->arch.dmsintc &&
+		msg_addr >= kvm->arch.dmsintc->msg_addr_base &&
+		msg_addr < (kvm->arch.dmsintc->msg_addr_base  + kvm->arch.dmsintc->msg_addr_size)) {
+		return kvm_dmsintc_set_msi_irq(kvm, msg_addr, e->msi.data, level);
+	} else {
+		pch_msi_set_irq(kvm, e->msi.data, level);
+	}
+
+	return 0;
+}
+
 /*
  * kvm_set_msi: inject the MSI corresponding to the
  * MSI routing entry
@@ -26,12 +62,7 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id, int level, bool line_status)
 {
-	if (!level)
-		return -1;
-
-	pch_msi_set_irq(kvm, e->msi.data, level);
-
-	return 0;
+	return loongarch_set_msi(e, kvm, level);
 }
 
 /*
@@ -76,7 +107,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 		pch_pic_set_irq(kvm->arch.pch_pic, e->irqchip.pin, level);
 		return 0;
 	case KVM_IRQ_ROUTING_MSI:
-		pch_msi_set_irq(kvm, e->msi.data, level);
+		loongarch_set_msi(e, kvm, level);
 		return 0;
 	default:
 		return -EWOULDBLOCK;
-- 
2.39.3


