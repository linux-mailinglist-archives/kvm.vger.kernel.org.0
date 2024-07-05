Return-Path: <kvm+bounces-21023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0438F9280AE
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD3D31F21B4F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4235B139D05;
	Fri,  5 Jul 2024 02:56:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43BA73450;
	Fri,  5 Jul 2024 02:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148187; cv=none; b=C3iHyj/cfpVk+rBmY1xe5/flSEd4WhedKydaEO+oMGPe2qpVXwtyJ5Yjxh4DtlPHiCfjwkUX3jQa5GviAP3x61lQr1SdA6OWJ9qQUfMdvLLcjt79R+fptd+uEOr3G/CvmMW6c1TDSy0JNjbsGGhaOXDwcgtebeFv7wR4NGXyg68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148187; c=relaxed/simple;
	bh=T0F7IAqUwa9SsHCrQyrVXamK5Ph6zq6dwU1MiAUJ6qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a+4eGJCLiBmeUV10af7hIsPnPsxxHMyYFaTJw/j4+Nj8XjpXJxUKe4oxT21PO27ZdJnKGrOhWRUHKRc2NoKHfyfq36QF0SplvVR83ka/3Tk6jVATe8h3MzljMgLK0XRh2MOxXaenj8BRe60XCAO1mBKlQwE4PURvrqVgbqWKeZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8AxnfDXYIdm+yQBAA--.3831S3;
	Fri, 05 Jul 2024 10:56:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWcbRYIdm3tE7AA--.7292S9;
	Fri, 05 Jul 2024 10:56:22 +0800 (CST)
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
Subject: [PATCH 07/11] LoongArch: KVM: Add EXTIOI user mode read and write functions
Date: Fri,  5 Jul 2024 10:38:50 +0800
Message-Id: <20240705023854.1005258-8-lixianglai@loongson.cn>
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
X-CM-TRANSID:AQAAf8BxWcbRYIdm3tE7AA--.7292S9
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implements the communication interface between the user mode
program and the kernel in EXTIOI interrupt control simulation,
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

 arch/loongarch/include/uapi/asm/kvm.h |   2 +
 arch/loongarch/kvm/intc/extioi.c      | 103 +++++++++++++++++++++++++-
 2 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index ec39a3cd4f22..9cdcb5e2a731 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -110,4 +110,6 @@ struct kvm_iocsr_entry {
 
 #define KVM_DEV_LOONGARCH_IPI_GRP_REGS		1
 
+#define KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS	1
+
 #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/arch/loongarch/kvm/intc/extioi.c b/arch/loongarch/kvm/intc/extioi.c
index dd18b7a7599a..48141823aaa3 100644
--- a/arch/loongarch/kvm/intc/extioi.c
+++ b/arch/loongarch/kvm/intc/extioi.c
@@ -47,6 +47,26 @@ static void extioi_update_irq(struct loongarch_extioi *s, int irq, int level)
 	kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
 }
 
+static void extioi_set_sw_coreisr(struct loongarch_extioi *s)
+{
+	int ipnum, cpu, irq_index, irq_mask, irq;
+
+	for (irq = 0; irq < EXTIOI_IRQS; irq++) {
+		ipnum = s->ipmap.reg_u8[irq / 32];
+		ipnum = count_trailing_zeros(ipnum);
+		ipnum = (ipnum >= 0 && ipnum < 4) ? ipnum : 0;
+		irq_index = irq / 32;
+		/* length of accessing core isr is 4 bytes */
+		irq_mask = 1 << (irq & 0x1f);
+
+		cpu = s->coremap.reg_u8[irq];
+		if (!!(s->coreisr.reg_u32[cpu][irq_index] & irq_mask))
+			set_bit(irq, s->sw_coreisr[cpu][ipnum]);
+		else
+			clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
+	}
+}
+
 void extioi_set_irq(struct loongarch_extioi *s, int irq, int level)
 {
 	unsigned long *isr = (unsigned long *)s->isr.reg_u8;
@@ -599,16 +619,95 @@ static const struct kvm_io_device_ops kvm_loongarch_extioi_ops = {
 	.write	= kvm_loongarch_extioi_write,
 };
 
+static int kvm_loongarch_extioi_regs_access(struct kvm_device *dev,
+					struct kvm_device_attr *attr,
+					bool is_write)
+{
+	int len, addr;
+	void __user *data;
+	void *p = NULL;
+	struct loongarch_extioi *s;
+	unsigned long flags;
+
+	s = dev->kvm->arch.extioi;
+	addr = attr->attr;
+	data = (void __user *)attr->addr;
+
+	loongarch_ext_irq_lock(s, flags);
+	switch (addr) {
+	case EXTIOI_NODETYPE_START:
+		p = s->nodetype.reg_u8;
+		len = sizeof(s->nodetype);
+		break;
+	case EXTIOI_IPMAP_START:
+		p = s->ipmap.reg_u8;
+		len = sizeof(s->ipmap);
+		break;
+	case EXTIOI_ENABLE_START:
+		p = s->enable.reg_u8;
+		len = sizeof(s->enable);
+		break;
+	case EXTIOI_BOUNCE_START:
+		p = s->bounce.reg_u8;
+		len = sizeof(s->bounce);
+		break;
+	case EXTIOI_ISR_START:
+		p = s->isr.reg_u8;
+		len = sizeof(s->isr);
+		break;
+	case EXTIOI_COREISR_START:
+		p = s->coreisr.reg_u8;
+		len = sizeof(s->coreisr);
+		break;
+	case EXTIOI_COREMAP_START:
+		p = s->coremap.reg_u8;
+		len = sizeof(s->coremap);
+		break;
+	case EXTIOI_SW_COREMAP_FLAG:
+		p = s->sw_coremap;
+		len = sizeof(s->sw_coremap);
+		break;
+	default:
+		loongarch_ext_irq_unlock(s, flags);
+		kvm_err("%s: unknown extioi register, addr = %d\n", __func__, addr);
+		return -EINVAL;
+	}
+
+	loongarch_ext_irq_unlock(s, flags);
+
+	if (is_write) {
+		if (copy_from_user(p, data, len))
+			return -EFAULT;
+	} else {
+		if (copy_to_user(data, p, len))
+			return -EFAULT;
+	}
+
+	if ((addr == EXTIOI_COREISR_START) && is_write) {
+		loongarch_ext_irq_lock(s, flags);
+		extioi_set_sw_coreisr(s);
+		loongarch_ext_irq_unlock(s, flags);
+	}
+
+	return 0;
+}
+
 static int kvm_loongarch_extioi_get_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	return 0;
+	if (attr->group == KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS)
+		return kvm_loongarch_extioi_regs_access(dev, attr, false);
+
+	return -EINVAL;
 }
 
 static int kvm_loongarch_extioi_set_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	return 0;
+	if (attr->group == KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS)
+		return kvm_loongarch_extioi_regs_access(dev, attr, true);
+
+	return -EINVAL;
 }
 
 static void kvm_loongarch_extioi_destroy(struct kvm_device *dev)
-- 
2.39.1


