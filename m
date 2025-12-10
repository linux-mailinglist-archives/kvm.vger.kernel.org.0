Return-Path: <kvm+bounces-65645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B662CB1C25
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 03:56:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B1B8B30865D3
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 02:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5476627A10F;
	Wed, 10 Dec 2025 02:56:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251B114F9D6;
	Wed, 10 Dec 2025 02:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765335394; cv=none; b=ee64s8IQwToIDUhUsyA+YDZDJcFI0dZsslWHrhxXzIf37yMnk68Ce6i0o/A4CABb9lHs3ct2Eo2b4DjK3ClTaGu01KriSDlj7psUxo796GZMXGm/tsmZGpVVmrpTwbPHHvnmt7KKHsTH7icX/vo3ODtM0IJb87WOaa1jaiOv/BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765335394; c=relaxed/simple;
	bh=XiCc5SLAmYACbqw0SxPq0GIjJC9JsoeYxgqmBlRe+gc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gs2UV0U6me5J2Kxs2mjzoe1mG9rTCE8DceoRWVI6taypxq9RR6RMEPmB5i/PthdKCNUaVM1jArIIjld6kZL+tr0khhJAwL22BkU/mmFfLyTsoFb5Tge9LgyHK5Bsg7GxKhui0VIJi8GcqAIYnObDjgFeJeEdR/bhsPFmBtBcxy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxVNBa4ThpY+EsAA--.31606S3;
	Wed, 10 Dec 2025 10:56:26 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxTMFZ4ThpGalHAQ--.1424S2;
	Wed, 10 Dec 2025 10:56:25 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: [PATCH] LoongArch: KVM: Set default return value in kvm IO bus ops
Date: Wed, 10 Dec 2025 10:56:21 +0800
Message-Id: <20251210025623.343511-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxTMFZ4ThpGalHAQ--.1424S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

When irqchip in kernel is enabled, its register area is registered
in the IO bus list with API kvm_io_bus_register_dev(). In MMIO/IOCSR
register access emulation, kvm_io_bus_write/kvm_io_bus_read is called
firstly. If it returns 0, it shows that in kernel irqchip handles
the emulation already, else it returns to VMM and lets VMM emulate
the register access.

Once irqchip in kernel is enabled, it should return 0 if the address
is within range of the registered IO bus. It should not return to VMM
since VMM does not know how to handle it, and irqchip is handled in
kernel already.

Here set default return value with 0 in KVM IO bus operations.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 28 ++++++++++++----------------
 arch/loongarch/kvm/intc/ipi.c     | 10 ++--------
 arch/loongarch/kvm/intc/pch_pic.c | 31 ++++++++++++++-----------------
 3 files changed, 28 insertions(+), 41 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 29886876143f..7ca9dfea7f39 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -119,7 +119,7 @@ void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level)
 static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
 				gpa_t addr, unsigned long *val)
 {
-	int index, ret = 0;
+	int index;
 	u64 data = 0;
 	gpa_t offset;
 
@@ -150,30 +150,29 @@ static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarch_eioint
 		data = s->coremap[index];
 		break;
 	default:
-		ret = -EINVAL;
 		break;
 	}
 	*val = data;
 
-	return ret;
+	return 0;
 }
 
 static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, void *val)
 {
-	int ret = -EINVAL;
+	int ret = 0;
 	unsigned long flags, data, offset;
 	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
 
 	if (!eiointc) {
 		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	if (addr & (len - 1)) {
 		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
-		return -EINVAL;
+		return ret;
 	}
 
 	offset = addr & 0x7;
@@ -208,7 +207,7 @@ static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
 				gpa_t addr, u64 value, u64 field_mask)
 {
-	int index, irq, ret = 0;
+	int index, irq;
 	u8 cpu;
 	u64 data, old, mask;
 	gpa_t offset;
@@ -287,29 +286,28 @@ static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 		eiointc_update_sw_coremap(s, index * 8, data, sizeof(data), true);
 		break;
 	default:
-		ret = -EINVAL;
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, const void *val)
 {
-	int ret = -EINVAL;
+	int ret = 0;
 	unsigned long flags, value;
 	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
 
 	if (!eiointc) {
 		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	if (addr & (len - 1)) {
 		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
-		return -EINVAL;
+		return ret;
 	}
 
 	vcpu->stat.eiointc_write_exits++;
@@ -352,7 +350,7 @@ static int kvm_eiointc_virt_read(struct kvm_vcpu *vcpu,
 
 	if (!eiointc) {
 		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return 0;
 	}
 
 	addr -= EIOINTC_VIRT_BASE;
@@ -383,21 +381,19 @@ static int kvm_eiointc_virt_write(struct kvm_vcpu *vcpu,
 
 	if (!eiointc) {
 		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	addr -= EIOINTC_VIRT_BASE;
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (addr) {
 	case EIOINTC_VIRT_FEATURES:
-		ret = -EPERM;
 		break;
 	case EIOINTC_VIRT_CONFIG:
 		/*
 		 * eiointc features can only be set at disabled status
 		 */
 		if ((eiointc->status & BIT(EIOINTC_ENABLE)) && value) {
-			ret = -EPERM;
 			break;
 		}
 		eiointc->status = value & eiointc->features;
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index 05cefd29282e..311cbb66821d 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -174,7 +174,7 @@ static int any_send(struct kvm *kvm, uint64_t data)
 	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
 	if (unlikely(vcpu == NULL)) {
 		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
-		return -EINVAL;
+		return 0;
 	}
 	offset = data & 0xffff;
 
@@ -183,7 +183,6 @@ static int any_send(struct kvm *kvm, uint64_t data)
 
 static int loongarch_ipi_readl(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *val)
 {
-	int ret = 0;
 	uint32_t offset;
 	uint64_t res = 0;
 
@@ -211,19 +210,17 @@ static int loongarch_ipi_readl(struct kvm_vcpu *vcpu, gpa_t addr, int len, void
 		if (offset + len > IOCSR_IPI_BUF_38 + 8) {
 			kvm_err("%s: invalid offset or len: offset = %d, len = %d\n",
 				__func__, offset, len);
-			ret = -EINVAL;
 			break;
 		}
 		res = read_mailbox(vcpu, offset, len);
 		break;
 	default:
 		kvm_err("%s: unknown addr: %llx\n", __func__, addr);
-		ret = -EINVAL;
 		break;
 	}
 	*(uint64_t *)val = res;
 
-	return ret;
+	return 0;
 }
 
 static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, const void *val)
@@ -239,7 +236,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
 
 	switch (offset) {
 	case IOCSR_IPI_STATUS:
-		ret = -EINVAL;
 		break;
 	case IOCSR_IPI_EN:
 		spin_lock(&vcpu->arch.ipi_state.lock);
@@ -257,7 +253,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
 		if (offset + len > IOCSR_IPI_BUF_38 + 8) {
 			kvm_err("%s: invalid offset or len: offset = %d, len = %d\n",
 				__func__, offset, len);
-			ret = -EINVAL;
 			break;
 		}
 		write_mailbox(vcpu, offset, data, len);
@@ -273,7 +268,6 @@ static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr, int len, cons
 		break;
 	default:
 		kvm_err("%s: unknown addr: %llx\n", __func__, addr);
-		ret = -EINVAL;
 		break;
 	}
 
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index a698a73de399..773885f8d659 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -74,7 +74,7 @@ void pch_msi_set_irq(struct kvm *kvm, int irq, int level)
 
 static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t addr, int len, void *val)
 {
-	int ret = 0, offset;
+	int offset;
 	u64 data = 0;
 	void *ptemp;
 
@@ -121,34 +121,32 @@ static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t addr, int l
 		data = s->isr;
 		break;
 	default:
-		ret = -EINVAL;
+		break;
 	}
 	spin_unlock(&s->lock);
 
-	if (ret == 0) {
-		offset = (addr - s->pch_pic_base) & 7;
-		data = data >> (offset * 8);
-		memcpy(val, &data, len);
-	}
+	offset = (addr - s->pch_pic_base) & 7;
+	data = data >> (offset * 8);
+	memcpy(val, &data, len);
 
-	return ret;
+	return 0;
 }
 
 static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, void *val)
 {
-	int ret;
+	int ret = 0;
 	struct loongarch_pch_pic *s = vcpu->kvm->arch.pch_pic;
 
 	if (!s) {
 		kvm_err("%s: pch pic irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	if (addr & (len - 1)) {
 		kvm_err("%s: pch pic not aligned addr %llx len %d\n", __func__, addr, len);
-		return -EINVAL;
+		return ret;
 	}
 
 	/* statistics of pch pic reading */
@@ -161,7 +159,7 @@ static int kvm_pch_pic_read(struct kvm_vcpu *vcpu,
 static int loongarch_pch_pic_write(struct loongarch_pch_pic *s, gpa_t addr,
 					int len, const void *val)
 {
-	int ret = 0, offset;
+	int offset;
 	u64 old, data, mask;
 	void *ptemp;
 
@@ -226,29 +224,28 @@ static int loongarch_pch_pic_write(struct loongarch_pch_pic *s, gpa_t addr,
 	case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
 		break;
 	default:
-		ret = -EINVAL;
 		break;
 	}
 	spin_unlock(&s->lock);
 
-	return ret;
+	return 0;
 }
 
 static int kvm_pch_pic_write(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, const void *val)
 {
-	int ret;
+	int ret = 0;
 	struct loongarch_pch_pic *s = vcpu->kvm->arch.pch_pic;
 
 	if (!s) {
 		kvm_err("%s: pch pic irqchip not valid!\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	if (addr & (len - 1)) {
 		kvm_err("%s: pch pic not aligned addr %llx len %d\n", __func__, addr, len);
-		return -EINVAL;
+		return ret;
 	}
 
 	/* statistics of pch pic writing */

base-commit: c9b47175e9131118e6f221cc8fb81397d62e7c91
-- 
2.39.3


