Return-Path: <kvm+bounces-65461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F363CAA244
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 08:14:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0EFD5318456C
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 07:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D712E1F11;
	Sat,  6 Dec 2025 07:11:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F79211706;
	Sat,  6 Dec 2025 07:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765005097; cv=none; b=fpZPy0cXKZY7YblZrBwD4n0jdegGvLZShIGBzN7b9Pq+2PGJ/uQynZFjO78uYbiwHxMJK9k6jkHlZ0h5c5EnGujaBCRMvdWrd4U4RTLK89RJavpzxXvjXm1cOj1xTfGoeOE/Bu1mo/Y/Q8pQqME1yem4wfpeoaEhz7szFK3JaVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765005097; c=relaxed/simple;
	bh=iXyUZ6fh5qMao8n7PmvqoJHNArwS3YyjBReiqby1M3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P2xs8L2Co+K8j7ji3z81JjnWxw5wMGYs/UCm4sxbCh34rrgLSOw+V02SlnWHdZ6pWSwuAugNpSY71yXuZC38A2tj1ytb4zTJpkS+cVVLdSClGhKueBx3Lh3/FfPqUDCMzAn449JhoX5bReeuqjE6VrMgglqOv5v1EIXy3jvk6gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8DxM9Ad1zNp+rMrAA--.29317S3;
	Sat, 06 Dec 2025 15:11:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx2sAX1zNpmFZGAQ--.33246S5;
	Sat, 06 Dec 2025 15:11:24 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org,
	lixianglai@loongson.cn
Subject: [PATCH v3 3/4] LongArch: KVM: Add irqfd set dintc msi
Date: Sat,  6 Dec 2025 14:46:57 +0800
Message-Id: <20251206064658.714100-4-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20251206064658.714100-1-gaosong@loongson.cn>
References: <20251206064658.714100-1-gaosong@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2sAX1zNpmFZGAQ--.33246S5
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add irqfd choice dintc to set msi irq by the msg_addr and
implement dintc set msi irq.

Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/kvm_dintc.h |  1 +
 arch/loongarch/kvm/intc/dintc.c        |  6 ++++
 arch/loongarch/kvm/irqfd.c             | 45 ++++++++++++++++++++++----
 3 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_dintc.h b/arch/loongarch/include/asm/kvm_dintc.h
index d980d39c0344..f87fb802a7bf 100644
--- a/arch/loongarch/include/asm/kvm_dintc.h
+++ b/arch/loongarch/include/asm/kvm_dintc.h
@@ -11,6 +11,7 @@ struct loongarch_dintc  {
 	struct kvm *kvm;
 	uint64_t msg_addr_base;
 	uint64_t msg_addr_size;
+	uint32_t cpu_mask;
 };
 
 struct dintc_state {
diff --git a/arch/loongarch/kvm/intc/dintc.c b/arch/loongarch/kvm/intc/dintc.c
index cd6cc9392adc..15e2ccd25a63 100644
--- a/arch/loongarch/kvm/intc/dintc.c
+++ b/arch/loongarch/kvm/intc/dintc.c
@@ -15,6 +15,7 @@ static int kvm_dintc_ctrl_access(struct kvm_device *dev,
 	void __user *data;
 	struct loongarch_dintc *s = dev->kvm->arch.dintc;
 	u64 tmp;
+	u32 cpu_bit;
 
 	data = (void __user *)attr->addr;
 	switch (addr) {
@@ -30,6 +31,11 @@ static int kvm_dintc_ctrl_access(struct kvm_device *dev,
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
 	case KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_SIZE:
diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
index 9a39627aecf0..d49a6c6471df 100644
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
 
+static int kvm_dintc_set_msi_irq(struct kvm *kvm, u32 addr, int data, int level)
+{
+	unsigned int virq, dest;
+	struct kvm_vcpu *vcpu;
+
+	virq = (addr >> AVEC_VIRQ_SHIFT) & AVEC_VIRQ_MASK;
+	dest = (addr >> AVEC_CPU_SHIFT) & kvm->arch.dintc->cpu_mask;
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
+	if (cpu_has_msgint && kvm->arch.dintc &&
+		msg_addr >= kvm->arch.dintc->msg_addr_base &&
+		msg_addr < (kvm->arch.dintc->msg_addr_base  + kvm->arch.dintc->msg_addr_size)) {
+		return kvm_dintc_set_msi_irq(kvm, msg_addr, e->msi.data, level);
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


