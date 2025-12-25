Return-Path: <kvm+bounces-66689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1236CDD9AC
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 10:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC78B30698C2
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 09:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31FC31960B;
	Thu, 25 Dec 2025 09:37:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B59314A7D;
	Thu, 25 Dec 2025 09:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766655429; cv=none; b=FUNQjJ6I8HAoSS340V/WI5Qmek4hYRwRDYq8cHOjVHOP7KTWlrmxVn/dxES8oeP1/inCmaaptprFcTcQlMGA22x3nhjLLgpYh/OTwvuXcUsSuPQh/auwErwYqeK6tUk8P8UkFYLoAlsEO/db43mBmfWgDvRhViY1WfOZBGu7gow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766655429; c=relaxed/simple;
	bh=9htsw+Ldh0tUhKhhlg467QyeZM/gjVsTjsVYCpzZmYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eq4mTHLciQ6DI6LfTwlPxpvCRkOuEZ/QQf8UQi6NsNRg+Lj3AdPOZqUD8YwA9o00Dg6GNL9o7cXMkBG+xGXPT/8PSUQSmFJjMsnenNWu5Fo+yq3jvx2GlNlM/LA2fMbm4MNGC0Ku+hBnRh1ez9RNZ4n4NZ3GBMRuUBT6j5oe5pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8AxjsO_BU1ppRoDAA--.10484S3;
	Thu, 25 Dec 2025 17:37:03 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJAx38K4BU1p0rEEAA--.13879S4;
	Thu, 25 Dec 2025 17:37:02 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/2] LongArch: KVM: Add dmsintc inject msi to the dest vcpu
Date: Thu, 25 Dec 2025 17:12:24 +0800
Message-Id: <20251225091224.2893389-3-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20251225091224.2893389-1-gaosong@loongson.cn>
References: <20251225091224.2893389-1-gaosong@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAx38K4BU1p0rEEAA--.13879S4
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implement irqfd deliver msi to vcpu and vcpu dmsintc inject irq.
Add irqfd choice dmsintc to set msi irq by the msg_addr and
implement dmsintc set msi irq.

Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/kvm_dmsintc.h |  1 +
 arch/loongarch/include/asm/kvm_host.h    |  5 ++
 arch/loongarch/kvm/intc/dmsintc.c        |  6 +++
 arch/loongarch/kvm/interrupt.c           |  1 +
 arch/loongarch/kvm/irqfd.c               | 42 +++++++++++++++--
 arch/loongarch/kvm/vcpu.c                | 58 ++++++++++++++++++++++++
 6 files changed, 109 insertions(+), 4 deletions(-)

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
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 5e9e2af7312f..91e0190aeaec 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -258,6 +258,11 @@ struct kvm_vcpu_arch {
 	} st;
 };
 
+void loongarch_dmsintc_inject_irq(struct kvm_vcpu *vcpu);
+int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
+				struct kvm_vcpu *vcpu,
+				u32 vector, int level);
+
 static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
 {
 	return csr->csrs[reg];
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
diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
index a6d42d399a59..893a81ca1079 100644
--- a/arch/loongarch/kvm/interrupt.c
+++ b/arch/loongarch/kvm/interrupt.c
@@ -33,6 +33,7 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 		irq = priority_to_irq[priority];
 
 	if (cpu_has_msgint && (priority == INT_AVEC)) {
+		loongarch_dmsintc_inject_irq(vcpu);
 		set_gcsr_estat(irq);
 		return 1;
 	}
diff --git a/arch/loongarch/kvm/irqfd.c b/arch/loongarch/kvm/irqfd.c
index 9a39627aecf0..3bbb26f4e2b7 100644
--- a/arch/loongarch/kvm/irqfd.c
+++ b/arch/loongarch/kvm/irqfd.c
@@ -6,6 +6,7 @@
 #include <linux/kvm_host.h>
 #include <trace/events/kvm.h>
 #include <asm/kvm_pch_pic.h>
+#include <asm/kvm_vcpu.h>
 
 static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id, int level, bool line_status)
@@ -16,6 +17,38 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
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
@@ -29,9 +62,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	if (!level)
 		return -1;
 
-	pch_msi_set_irq(kvm, e->msi.data, level);
-
-	return 0;
+	return loongarch_set_msi(e, kvm, level);
 }
 
 /*
@@ -71,12 +102,15 @@ int kvm_set_routing_entry(struct kvm *kvm,
 int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id, int level, bool line_status)
 {
+	if (!level)
+		return -EWOULDBLOCK;
+
 	switch (e->type) {
 	case KVM_IRQ_ROUTING_IRQCHIP:
 		pch_pic_set_irq(kvm->arch.pch_pic, e->irqchip.pin, level);
 		return 0;
 	case KVM_IRQ_ROUTING_MSI:
-		pch_msi_set_irq(kvm, e->msi.data, level);
+		loongarch_set_msi(e, kvm, level);
 		return 0;
 	default:
 		return -EWOULDBLOCK;
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 656b954c1134..325bb084d704 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -14,6 +14,64 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+void loongarch_dmsintc_inject_irq(struct kvm_vcpu *vcpu)
+{
+	struct dmsintc_state *ds = &vcpu->arch.dmsintc_state;
+	unsigned int i;
+	unsigned long temp[4], old;
+
+	if (!ds)
+		return;
+
+	for (i = 0; i < 4; i++) {
+		old = atomic64_read(&(ds->vector_map[i]));
+		if (old)
+			temp[i] = atomic64_xchg(&(ds->vector_map[i]), 0);
+	}
+
+	if (temp[0]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR0);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR0, temp[0]|old);
+	}
+
+	if (temp[1]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR1);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR1, temp[1]|old);
+	}
+
+	if (temp[2]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR2);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR2, temp[2]|old);
+	}
+
+	if (temp[3]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR3);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR3, temp[3]|old);
+	}
+}
+
+int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
+				struct kvm_vcpu *vcpu,
+				u32 vector, int level)
+{
+	struct kvm_interrupt vcpu_irq;
+	struct dmsintc_state *ds;
+
+	if (!level)
+		return 0;
+	if (!vcpu || vector >= 256)
+		return -EINVAL;
+	ds = &vcpu->arch.dmsintc_state;
+	if (!ds)
+		return -ENODEV;
+	set_bit(vector, (unsigned long *)&ds->vector_map);
+	vcpu_irq.irq = INT_AVEC;
+	kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
+	kvm_vcpu_kick(vcpu);
+	return 0;
+}
+
+
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, int_exits),
-- 
2.39.3


