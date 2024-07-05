Return-Path: <kvm+bounces-21027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB7D19280B5
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73961286955
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D33145348;
	Fri,  5 Jul 2024 02:56:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE39413C810;
	Fri,  5 Jul 2024 02:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148189; cv=none; b=ZnatvDWL3XTIxkK3/ibTwxLcC3IkkntGSeaipJckfW+uHQqedFv5lPcLnAIci9gbwQM1sOM/5Kts+TVNj4A5r2W/IU749jYMEiD3KPkWzjn6es+BheRpk8g0Pm2BBK710htfZ9bjZTcJa8CSCRxJCf1rc1ZxsSq9QCmfTWNppYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148189; c=relaxed/simple;
	bh=38kZtlSZsb5tzxGLmK0gNB0z5wQD098BIIKOrbo23sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DT7SvoxmK++kHCaCqW4cFjyLTT/j+YYN+CFDghjb5nRROUmmF5zJRAyCcVFpXGx2f1ddtAqBR/sFgPQTUVYEdMaG1wOBeZKr6d+DJxGj+qMNL6c0ghsZSbd2lEEiafGVtBnrYnb/HRY4yXRKYDAa9k96olTKFmGkHQQhn+pE2yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8AxjuvZYIdmCiUBAA--.3408S3;
	Fri, 05 Jul 2024 10:56:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWcbRYIdm3tE7AA--.7292S12;
	Fri, 05 Jul 2024 10:56:23 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Min Zhou <zhoumin@loongson.cn>,
	Paolo Bonzini <pbonzini@redhat.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH 10/11] LoongArch: KVM: Add PCHPIC user mode read and write functions
Date: Fri,  5 Jul 2024 10:38:53 +0800
Message-Id: <20240705023854.1005258-11-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20240705023854.1005258-1-lixianglai@loongson.cn>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxWcbRYIdm3tE7AA--.7292S12
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implements the communication interface between the user mode
program and the kernel in PCHPIC interrupt control simulation,
which is used to obtain or send the simulation data of the
interrupt controller in the user mode process, and is used
in VM migration or VM saving and restoration.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Min Zhou <zhoumin@loongson.cn> 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/uapi/asm/kvm.h |   4 +
 arch/loongarch/kvm/intc/pch_pic.c     | 128 +++++++++++++++++++++++++-
 2 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 6d5ad95fcb75..ba7f473bc8b6 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -113,4 +113,8 @@ struct kvm_iocsr_entry {
 
 #define KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS	1
 
+#define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL	0
+#define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT	0
+#define KVM_DEV_LOONGARCH_PCH_PIC_GRP_REGS	1
+
 #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index 4ad85277fced..abb7bab84f2d 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -313,16 +313,140 @@ static const struct kvm_io_device_ops kvm_loongarch_pch_pic_ops = {
 	.write	= kvm_loongarch_pch_pic_write,
 };
 
+static int kvm_loongarch_pch_pic_init(struct kvm_device *dev, u64 addr)
+{
+	int ret;
+	struct loongarch_pch_pic *s = dev->kvm->arch.pch_pic;
+	struct kvm_io_device *device;
+	struct kvm *kvm = dev->kvm;
+
+	s->pch_pic_base = addr;
+	device = &s->device;
+	/* init device by pch pic writing and reading ops */
+	kvm_iodevice_init(device, &kvm_loongarch_pch_pic_ops);
+	mutex_lock(&kvm->slots_lock);
+	/* register pch pic device */
+	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, addr, PCH_PIC_SIZE, device);
+	mutex_unlock(&kvm->slots_lock);
+	if (ret < 0)
+		return -EFAULT;
+
+	return 0;
+}
+
+/* used by user space to get or set pch pic registers */
+static int kvm_loongarch_pch_pic_regs_access(struct kvm_device *dev,
+					struct kvm_device_attr *attr,
+					bool is_write)
+{
+	int addr, len = 8, ret = 0;
+	void __user *data;
+	void *p = NULL;
+	struct loongarch_pch_pic *s;
+
+	s = dev->kvm->arch.pch_pic;
+	addr = attr->attr;
+	data = (void __user *)attr->addr;
+
+	spin_lock(&s->lock);
+	/* get pointer to pch pic register by addr */
+	switch (addr) {
+	case PCH_PIC_MASK_START:
+		p = &s->mask;
+		break;
+	case PCH_PIC_HTMSI_EN_START:
+		p = &s->htmsi_en;
+		break;
+	case PCH_PIC_EDGE_START:
+		p = &s->edge;
+		break;
+	case PCH_PIC_AUTO_CTRL0_START:
+		p = &s->auto_ctrl0;
+		break;
+	case PCH_PIC_AUTO_CTRL1_START:
+		p = &s->auto_ctrl1;
+		break;
+	case PCH_PIC_ROUTE_ENTRY_START:
+		p = s->route_entry;
+		len = 64;
+		break;
+	case PCH_PIC_HTMSI_VEC_START:
+		p = s->htmsi_vector;
+		len = 64;
+		break;
+	case PCH_PIC_INT_IRR_START:
+		p = &s->irr;
+		break;
+	case PCH_PIC_INT_ISR_START:
+		p = &s->isr;
+		break;
+	case PCH_PIC_POLARITY_START:
+		p = &s->polarity;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	/* write or read value according to is_write */
+	if (is_write) {
+		if (copy_from_user(p, data, len))
+			ret = -EFAULT;
+	} else {
+		if (copy_to_user(data, p, len))
+			ret = -EFAULT;
+	}
+
+	spin_unlock(&s->lock);
+	return ret;
+}
+
 static int kvm_loongarch_pch_pic_get_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	return 0;
+	/* only support pch pic group registers */
+	if (attr->group == KVM_DEV_LOONGARCH_PCH_PIC_GRP_REGS)
+		return kvm_loongarch_pch_pic_regs_access(dev, attr, false);
+
+	return -EINVAL;
 }
 
 static int kvm_loongarch_pch_pic_set_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	return 0;
+	int ret = -EINVAL;
+	u64 addr;
+	void __user *uaddr = (void __user *)(long)attr->addr;
+
+	switch (attr->group) {
+	case KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT:
+			if (copy_from_user(&addr, uaddr, sizeof(addr)))
+				return -EFAULT;
+
+			if (!dev->kvm->arch.pch_pic) {
+				kvm_err("%s: please create pch_pic irqchip first!\n", __func__);
+				ret = -EFAULT;
+				break;
+			}
+
+			ret = kvm_loongarch_pch_pic_init(dev, addr);
+			break;
+		default:
+			kvm_err("%s: unknown group (%d) attr (%lld)\n", __func__, attr->group,
+					attr->attr);
+			ret = -EINVAL;
+			break;
+		}
+		break;
+	case KVM_DEV_LOONGARCH_PCH_PIC_GRP_REGS:
+		ret = kvm_loongarch_pch_pic_regs_access(dev, attr, true);
+		break;
+	default:
+			break;
+	}
+
+	return ret;
 }
 
 static void kvm_loongarch_pch_pic_destroy(struct kvm_device *dev)
-- 
2.39.1


