Return-Path: <kvm+bounces-64929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BFFF5C917A1
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 10:38:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7A282350194
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 09:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C8E3064A1;
	Fri, 28 Nov 2025 09:36:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF6D30595B;
	Fri, 28 Nov 2025 09:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764322562; cv=none; b=HQ8kFBLqaARk3upX1vWQpkP6cZJF3CAGUCzVjzkkWTo4zHTGtwgLICjYQQVLGdLm0yIRehO5/rV2VUPPuhjpkkBxluhLgqC/GReN1v9EPaU0Y0/LdUoaOCFf74a76jDldCtdYLaePmD//mvwT4A29jHVdowD3mIZ88ISaj7J/jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764322562; c=relaxed/simple;
	bh=pX474aXD6ixPIpIVrAhMvFxXS0vaXyAVl4RUUhzVnJc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W7vEH3xGg7q8fx88S17XrNWWUduQxawSVRslO3YoYxr+YZGTP2EhivKT7bhsA8e7hD0SWDvb06Jgo95bMm0OZpJP5ICzN8ahcE70cPRwP57762Rv4Xr+l26SY//8oz5RgHO86yDIdzw58iinfUAhbyKEKceY+lQE/ChsbN4tbwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Cxrr_vbClpSA8pAA--.21102S3;
	Fri, 28 Nov 2025 17:35:43 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx2sDtbClpo+xBAQ--.23356S5;
	Fri, 28 Nov 2025 17:35:43 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] LongArch: KVM: Add irqfd set dintc msi
Date: Fri, 28 Nov 2025 17:11:24 +0800
Message-Id: <20251128091125.2720148-4-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20251128091125.2720148-1-gaosong@loongson.cn>
References: <20251128091125.2720148-1-gaosong@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2sDtbClpo+xBAQ--.23356S5
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add irqfd choice dintc to set msi irq by the msg_addr and
implement dintc set msi irq.

Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/kvm_dintc.h |  1 +
 arch/loongarch/kvm/intc/dintc.c        |  6 ++++++
 arch/loongarch/kvm/irqfd.c             | 28 +++++++++++++++++++++++++-
 3 files changed, 34 insertions(+), 1 deletion(-)

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
index d30616ded1b1..ae0d61e2b8f0 100644
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
index 9a39627aecf0..fdcce472abb1 100644
--- a/arch/loongarch/kvm/irqfd.c
+++ b/arch/loongarch/kvm/irqfd.c
@@ -6,6 +6,7 @@
 #include <linux/kvm_host.h>
 #include <trace/events/kvm.h>
 #include <asm/kvm_pch_pic.h>
+#include <asm/kvm_vcpu.h>
 
 static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id, int level, bool line_status)
@@ -16,6 +17,22 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
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
+
 /*
  * kvm_set_msi: inject the MSI corresponding to the
  * MSI routing entry
@@ -26,10 +43,19 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id, int level, bool line_status)
 {
+	u64 msg_addr;
+
 	if (!level)
 		return -1;
 
-	pch_msi_set_irq(kvm, e->msi.data, level);
+	msg_addr = (((u64)e->msi.address_hi) << 32) | e->msi.address_lo;
+	if (cpu_has_msgint && kvm->arch.dintc &&
+		msg_addr >= kvm->arch.dintc->msg_addr_base &&
+		msg_addr < (kvm->arch.dintc->msg_addr_base  + kvm->arch.dintc->msg_addr_size)) {
+		return kvm_dintc_set_msi_irq(kvm, msg_addr, e->msi.data, level);
+	} else if (msg_addr == 0) {
+		pch_msi_set_irq(kvm, e->msi.data, level);
+	}
 
 	return 0;
 }
-- 
2.39.3


