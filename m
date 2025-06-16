Return-Path: <kvm+bounces-49578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C79ADA98B
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 09:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF6A91709A7
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 07:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A69D2045AD;
	Mon, 16 Jun 2025 07:36:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CEC1F3BB5;
	Mon, 16 Jun 2025 07:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750059360; cv=none; b=enEK+QpZgmlWqOwjtX4eIaDbDqEft4y+9GvXfflvgsuMqiTD4hWHc67MW5m80vVn6OzhJxz19R4U8iqB+6zuQDuJzItjJnp2FjA0svpFZZSCWuNdgOpc1xdv6ZLej0hcTBId40Q0DkrMTgwvchHWC4vzimOa1hQZ6dQsnN06bCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750059360; c=relaxed/simple;
	bh=UfhgvnXbrQAyNf1/lL9bn8vZlRy3tdLsBFdat30BWwo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PatJYiku4LHDqlgQ/KAR00i7h2LGhIzPZyuL46Hh7Frl3J5fR35+2o6eGzk5jF961tgF1AViQsJX2v7Yw/XLMORsyS5Jndzfbmvbyzix3XsNWurFrLylJFnKUGW/rNZ6gnJA5yeESRzJHsLLVd15HUOYe3AB19VDbT915QPjNLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxNHBayU9o040XAQ--.54243S3;
	Mon, 16 Jun 2025 15:35:54 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxvhtLyU9okMEcAQ--.34084S4;
	Mon, 16 Jun 2025 15:35:47 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] LoongArch: KVM: INTC: Add IOCSR MISC register emulation
Date: Mon, 16 Jun 2025 15:35:39 +0800
Message-Id: <20250616073539.129365-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250616073539.129365-1-maobibo@loongson.cn>
References: <20250616073539.129365-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxvhtLyU9okMEcAQ--.34084S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

IOCSR MISC register 0x420 controlls some features of eiointc, such
as BIT48 enables eiointc and BIT49 set interrupt encoding mode. Here
add IOCSR MISC register emulation in eiointc driver.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_eiointc.h |   4 +
 arch/loongarch/include/asm/loongarch.h   |   1 +
 arch/loongarch/kvm/intc/eiointc.c        | 136 ++++++++++++++++++++++-
 3 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch/include/asm/kvm_eiointc.h
index a3a40aba8acf..77cd2b3a6f76 100644
--- a/arch/loongarch/include/asm/kvm_eiointc.h
+++ b/arch/loongarch/include/asm/kvm_eiointc.h
@@ -17,6 +17,9 @@
 /* map to ipnum per 32 irqs */
 #define EIOINTC_IRQS_NODETYPE_COUNT	16
 
+#define MISC_BASE			0x420
+#define MISC_SIZE			0x8
+
 #define EIOINTC_BASE			0x1400
 #define EIOINTC_SIZE			0x900
 
@@ -59,6 +62,7 @@ struct loongarch_eiointc {
 	struct kvm *kvm;
 	struct kvm_io_device device;
 	struct kvm_io_device device_vext;
+	struct kvm_io_device misc;
 	uint32_t num_cpu;
 	uint32_t features;
 	uint32_t status;
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index d84dac88a584..e30d330d497e 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -1141,6 +1141,7 @@
 #define  IOCSR_MISC_FUNC_SOFT_INT	BIT_ULL(10)
 #define  IOCSR_MISC_FUNC_TIMER_RESET	BIT_ULL(21)
 #define  IOCSR_MISC_FUNC_EXT_IOI_EN	BIT_ULL(48)
+#define  IOCSR_MISC_FUNC_INT_ENCODE	BIT_ULL(49)
 #define  IOCSR_MISC_FUNC_AVEC_EN	BIT_ULL(51)
 
 #define LOONGARCH_IOCSR_CPUTEMP		0x428
diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index d9c4fe93405d..26b8e52d74f1 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -781,6 +781,129 @@ static const struct kvm_io_device_ops kvm_eiointc_virt_ops = {
 	.write	= kvm_eiointc_virt_write,
 };
 
+
+static int kvm_misc_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			gpa_t addr, int len, void *val)
+{
+	unsigned long flags, data, status;
+	unsigned int shift;
+	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
+
+	if (!eiointc) {
+		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	addr -= MISC_BASE;
+	if (addr & (len - 1)) {
+		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&eiointc->lock, flags);
+	status = eiointc->status;
+	spin_unlock_irqrestore(&eiointc->lock, flags);
+
+	data = 0;
+	if (status & BIT(EIOINTC_ENABLE))
+		data |= IOCSR_MISC_FUNC_EXT_IOI_EN;
+	if (status & BIT(EIOINTC_ENABLE_INT_ENCODE))
+		data |= IOCSR_MISC_FUNC_INT_ENCODE;
+
+	shift = (addr & 7) * 8;
+	data = data >> shift;
+	switch (len) {
+	case 1:
+		*(unsigned char *)val = (unsigned char)data;
+		break;
+
+	case 2:
+		*(unsigned short *)val = (unsigned short)data;
+		break;
+
+	case 4:
+		*(unsigned int *)val = (unsigned int)data;
+		break;
+
+	default:
+		*(unsigned long *)val = data;
+		break;
+	}
+
+	return 0;
+}
+
+static int kvm_misc_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			gpa_t addr, int len, const void *val)
+{
+	unsigned long flags, data, mask, old;
+	unsigned int shift;
+	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
+
+	if (!eiointc) {
+		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	addr -= MISC_BASE;
+	if (addr & (len - 1)) {
+		kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
+		return -EINVAL;
+	}
+
+	shift = (addr & 7) * 8;
+	switch (len) {
+	case 1:
+		data = *(unsigned char *)val;
+		mask = 0xFF;
+		mask = mask << shift;
+		data = data << shift;
+		break;
+
+	case 2:
+		data = *(unsigned short *)val;
+		mask = 0xFFFF;
+		mask = mask << shift;
+		data = data << shift;
+		break;
+
+	case 4:
+		data = *(unsigned int *)val;
+		mask = UINT_MAX;
+		mask = mask << shift;
+		data = data << shift;
+		break;
+
+	default:
+		data = *(unsigned long *)val;
+		mask = ULONG_MAX;
+		mask = mask << shift;
+		data = data << shift;
+		break;
+	}
+
+	spin_lock_irqsave(&eiointc->lock, flags);
+	old = 0;
+	if (eiointc->status & BIT(EIOINTC_ENABLE))
+		old |= IOCSR_MISC_FUNC_EXT_IOI_EN;
+	if (eiointc->status & BIT(EIOINTC_ENABLE_INT_ENCODE))
+		old |= IOCSR_MISC_FUNC_INT_ENCODE;
+
+	data = (old & ~mask) | data;
+	eiointc->status &= ~(BIT(EIOINTC_ENABLE_INT_ENCODE) | BIT(EIOINTC_ENABLE));
+	if (data & IOCSR_MISC_FUNC_INT_ENCODE)
+		eiointc->status |= BIT(EIOINTC_ENABLE_INT_ENCODE);
+	if (data & IOCSR_MISC_FUNC_EXT_IOI_EN)
+		eiointc->status |= BIT(EIOINTC_ENABLE);
+	spin_unlock_irqrestore(&eiointc->lock, flags);
+	return 0;
+}
+
+static const struct kvm_io_device_ops kvm_misc_ops = {
+	.read   = kvm_misc_read,
+	.write  = kvm_misc_write,
+};
+
 static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
 					struct kvm_device_attr *attr)
 {
@@ -993,8 +1116,18 @@ static int kvm_eiointc_create(struct kvm_device *dev, u32 type)
 		kfree(s);
 		return ret;
 	}
-	kvm->arch.eiointc = s;
 
+	device = &s->misc;
+	kvm_iodevice_init(device, &kvm_misc_ops);
+	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS, MISC_BASE, MISC_SIZE, device);
+	if (ret < 0) {
+		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device);
+		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device_vext);
+		kfree(s);
+		return ret;
+	}
+
+	kvm->arch.eiointc = s;
 	return 0;
 }
 
@@ -1010,6 +1143,7 @@ static void kvm_eiointc_destroy(struct kvm_device *dev)
 	eiointc = kvm->arch.eiointc;
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device);
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device_vext);
+	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->misc);
 	kfree(eiointc);
 }
 
-- 
2.39.3


