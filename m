Return-Path: <kvm+bounces-31218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7169C14FF
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 04:58:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DA0C1F2509C
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 03:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180041C9ECE;
	Fri,  8 Nov 2024 03:57:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45A5F19E99F;
	Fri,  8 Nov 2024 03:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731038244; cv=none; b=UlnMb/2h4eUhXJb3XfV2IIlXJxq6cKZjyV5GOD+G6sAjFIF+dkZ4+yaroJcBOLDQKLC519ZYWIEnZ2E9f+aygBzpI95JPW2oKPAU11vahzosmZ1WQhRP8/fO4/uHqgUAak1NVAgcRIt63RawKF11MB8fskt+691zSEJJdLanzNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731038244; c=relaxed/simple;
	bh=Ik6ld/RSptB++IqxGIktdrXNIb/ZbvGMiVA0WGyvObM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hxDq4wXx+lvCiux2LJLWB2YfPvx6gyjV7qx/2J6LZHLZqroKR5WW2Fm8XDSYJLpIJ12FWciaHel3io/JPadaeNHP+iz5uNJ0SviP+jM2ozkqv00cTHwe5EiCDtz3xc5JZ9j8Cj4Ks1bXqX8J+6DGU10npY/0ej/RUjzSwrDuGDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8DxmeEcjC1nLdo4AA--.48690S3;
	Fri, 08 Nov 2024 11:57:16 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMBxbcIajC1n0jVMAA--.31622S2;
	Fri, 08 Nov 2024 11:57:14 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Huacai Chen <chenhuacai@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH V4 07/11] LoongArch: KVM: Add EIOINTC user mode read and write functions
Date: Fri,  8 Nov 2024 11:38:48 +0800
Message-Id: <20241108033852.2727684-1-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20241108033437.2727574-1-lixianglai@loongson.cn>
References: <20241108033437.2727574-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxbcIajC1n0jVMAA--.31622S2
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implement the communication interface between the user mode programs
and the kernel in EIOINTC interrupt controller simulation, which is
used to obtain or send the simulation data of the interrupt controller
in the user mode process, and is also used in VM migration or VM saving
and restoration.

Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/uapi/asm/kvm.h |  12 ++
 arch/loongarch/kvm/intc/eiointc.c     | 178 +++++++++++++++++++++++++-
 2 files changed, 188 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index c6bbbb34cef4..98126c034eb8 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -134,4 +134,16 @@ struct kvm_iocsr_entry {
 
 #define KVM_DEV_LOONGARCH_IPI_GRP_REGS			0x40000001
 
+#define KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS		0x40000002
+
+#define KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS		0x40000003
+#define KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_NUM_CPU	0x0
+#define KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_FEATURE	0x1
+#define KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_STATE	0x2
+
+#define KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL		0x40000004
+#define KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU	0x0
+#define KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE	0x1
+#define KVM_DEV_LOONGARCH_EXTIOI_CTRL_LOAD_FINISHED	0x3
+
 #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 17b453f94668..414e4ffd6917 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -797,16 +797,190 @@ static const struct kvm_io_device_ops kvm_eiointc_virt_ops = {
 	.write	= kvm_eiointc_virt_write,
 };
 
+static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
+					struct kvm_device_attr *attr)
+{
+	unsigned long  type = (unsigned long)attr->attr;
+	unsigned long flags;
+	struct loongarch_eiointc *s = dev->kvm->arch.eiointc;
+	void __user *data;
+	u32 i, start_irq;
+	int len, ret = 0;
+
+	data = (void __user *)attr->addr;
+	loongarch_ext_irq_lock(s, flags);
+	switch (type) {
+	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
+		len = 4;
+		if (copy_from_user(&s->num_cpu, data, len))
+			ret = -EFAULT;
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE:
+		len = 4;
+		if (copy_from_user(&s->features, data, len))
+			ret = -EFAULT;
+		if (!(s->features & BIT(EIOINTC_HAS_VIRT_EXTENSION)))
+			s->status |= BIT(EIOINTC_ENABLE);
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_LOAD_FINISHED:
+		eiointc_set_sw_coreisr(s);
+		for (i = 0; i < (EIOINTC_IRQS / 4); i++) {
+			start_irq = i * 4;
+			eiointc_update_sw_coremap(s, start_irq,
+					(void *)&s->coremap.reg_u32[i],
+					sizeof(u32), false);
+		}
+		break;
+	default:
+		break;
+	}
+	loongarch_ext_irq_unlock(s, flags);
+	return ret;
+}
+
+static int kvm_eiointc_regs_access(struct kvm_device *dev,
+					struct kvm_device_attr *attr,
+					bool is_write)
+{
+	int len, addr, cpuid, offset, ret = 0;
+	void __user *data;
+	void *p = NULL;
+	struct loongarch_eiointc *s;
+	unsigned long flags;
+
+	len = 4;
+	s = dev->kvm->arch.eiointc;
+	addr = attr->attr;
+	cpuid = addr >> 16;
+	addr &= 0xffff;
+	data = (void __user *)attr->addr;
+	switch (addr) {
+	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
+		offset = (addr - EIOINTC_NODETYPE_START) / 4;
+		p = &s->nodetype.reg_u32[offset];
+		break;
+	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
+		offset = (addr - EIOINTC_IPMAP_START) / 4;
+		p = &s->ipmap.reg_u32[offset];
+		break;
+	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
+		offset = (addr - EIOINTC_ENABLE_START) / 4;
+		p = &s->enable.reg_u32[offset];
+		break;
+	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
+		offset = (addr - EIOINTC_BOUNCE_START) / 4;
+		p = &s->bounce.reg_u32[offset];
+		break;
+	case EIOINTC_ISR_START ... EIOINTC_ISR_END:
+		offset = (addr - EIOINTC_ISR_START) / 4;
+		p = &s->isr.reg_u32[offset];
+		break;
+	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		offset = (addr - EIOINTC_COREISR_START) / 4;
+		p = &s->coreisr.reg_u32[cpuid][offset];
+		break;
+	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
+		offset = (addr - EIOINTC_COREMAP_START) / 4;
+		p = &s->coremap.reg_u32[offset];
+		break;
+	default:
+		kvm_err("%s: unknown eiointc register, addr = %d\n", __func__, addr);
+		return -EINVAL;
+	}
+
+	loongarch_ext_irq_lock(s, flags);
+	if (is_write) {
+		if (copy_from_user(p, data, len))
+			ret = -EFAULT;
+	} else {
+		if (copy_to_user(data, p, len))
+			ret = -EFAULT;
+	}
+	loongarch_ext_irq_unlock(s, flags);
+	return ret;
+}
+
+static int kvm_eiointc_sw_status_access(struct kvm_device *dev,
+					struct kvm_device_attr *attr,
+					bool is_write)
+{
+	int len, addr, ret = 0;
+	void __user *data;
+	void *p = NULL;
+	struct loongarch_eiointc *s;
+	unsigned long flags;
+
+	len = 4;
+	s = dev->kvm->arch.eiointc;
+	addr = attr->attr;
+	addr &= 0xffff;
+
+	data = (void __user *)attr->addr;
+	switch (addr) {
+	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_NUM_CPU:
+		p = &s->num_cpu;
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_FEATURE:
+		p = &s->features;
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_STATE:
+		p = &s->status;
+		break;
+	default:
+		kvm_err("%s: unknown eiointc register, addr = %d\n", __func__, addr);
+		return -EINVAL;
+	}
+	loongarch_ext_irq_lock(s, flags);
+	if (is_write) {
+		if (copy_from_user(p, data, len))
+			ret = -EFAULT;
+	} else {
+		if (copy_to_user(data, p, len))
+			ret = -EFAULT;
+	}
+	loongarch_ext_irq_unlock(s, flags);
+	return ret;
+}
+
 static int kvm_eiointc_get_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	return 0;
+	__u32	group = attr->group;
+	int ret = -EINVAL;
+
+	switch (group) {
+	case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
+		ret = kvm_eiointc_regs_access(dev, attr, false);
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
+		ret = kvm_eiointc_sw_status_access(dev, attr, false);
+		break;
+	default:
+		break;
+	}
+	return ret;
 }
 
 static int kvm_eiointc_set_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	return 0;
+	__u32	group = attr->group;
+	int ret = -EINVAL;
+
+	switch (group) {
+	case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
+		ret = kvm_eiointc_regs_access(dev, attr, true);
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
+		ret = kvm_eiointc_sw_status_access(dev, attr, true);
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL:
+		ret = kvm_eiointc_ctrl_access(dev, attr);
+		break;
+	default:
+		break;
+	}
+	return ret;
 }
 
 static void kvm_eiointc_destroy(struct kvm_device *dev)
-- 
2.39.1


