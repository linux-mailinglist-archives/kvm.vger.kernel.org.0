Return-Path: <kvm+bounces-24881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2640095C9BF
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 11:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7279E1F25D39
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 09:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C767F18734B;
	Fri, 23 Aug 2024 09:53:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6544D14A0BD;
	Fri, 23 Aug 2024 09:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724406832; cv=none; b=Q0QSoxfBxAmfBtsQebSnCl9ae3VvAYk4XmcycMba/S9hDXayNdqxUxf6A+MMxtB2Ae6C8Fx5lbnYYH6MBQp+YHjBqE9m96UuYA/pK7IhaH+X8zK01CVE4xGaFTu3UebR26qJzKUmBL29lHIOJ/u7y64c3PNRwsp1LFGQWFlZOog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724406832; c=relaxed/simple;
	bh=yLplZ4nj8oG9wirCZcs2qPNYfde4J9v6fMO6FfiwqWA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ifRmBlAYAqoMSheh49jdHPDJWsqjyS5xI4ZLEc2qMI71hMBktcHaFoBgN/RmHfcan+gJIrMxxRluVIpi2PiA9dyDcMKzmB6+1q75059uy3bLHUgrJOFYnEMp2f4TRgD5GNGY1eLWvKF8hCsWPhWGniJzRSH8XlDoCTJerHadM+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8DxSuorXMhm90odAA--.61998S3;
	Fri, 23 Aug 2024 17:53:47 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMDxkeEqXMhmtiwfAA--.5223S2;
	Fri, 23 Aug 2024 17:53:46 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [[PATCH V2 06/10] LoongArch: KVM: Add EXTIOI read and write functions
Date: Fri, 23 Aug 2024 17:36:20 +0800
Message-Id: <20240823093620.204512-1-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxkeEqXMhmtiwfAA--.5223S2
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implementation of EXTIOI interrupt controller address
space read and write function simulation.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/asm/kvm_extioi.h |  29 +
 arch/loongarch/include/asm/kvm_host.h   |   2 +
 arch/loongarch/include/uapi/asm/kvm.h   |  12 +
 arch/loongarch/kvm/intc/extioi.c        | 936 +++++++++++++++++++++++-
 4 files changed, 974 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_extioi.h b/arch/loongarch/include/asm/kvm_extioi.h
index d624b4aab73a..dc5a60349b51 100644
--- a/arch/loongarch/include/asm/kvm_extioi.h
+++ b/arch/loongarch/include/asm/kvm_extioi.h
@@ -20,9 +20,38 @@
 #define EXTIOI_BASE			0x1400
 #define EXTIOI_SIZE			0x900
 
+#define EXTIOI_NODETYPE_START		0xa0
+#define EXTIOI_NODETYPE_END		0xbf
+#define EXTIOI_IPMAP_START		0xc0
+#define EXTIOI_IPMAP_END		0xc7
+#define EXTIOI_ENABLE_START		0x200
+#define EXTIOI_ENABLE_END		0x21f
+#define EXTIOI_BOUNCE_START		0x280
+#define EXTIOI_BOUNCE_END		0x29f
+#define EXTIOI_ISR_START		0x300
+#define EXTIOI_ISR_END			0x31f
+#define EXTIOI_COREISR_START		0x400
+#define EXTIOI_COREISR_END		0x41f
+#define EXTIOI_COREMAP_START		0x800
+#define EXTIOI_COREMAP_END		0x8ff
+
 #define EXTIOI_VIRT_BASE		(0x40000000)
 #define EXTIOI_VIRT_SIZE		(0x1000)
 
+#define  EXTIOI_VIRT_FEATURES		(0x0)
+#define  EXTIOI_HAS_VIRT_EXTENSION	(0)
+#define  EXTIOI_HAS_ENABLE_OPTION	(1)
+#define  EXTIOI_HAS_INT_ENCODE		(2)
+#define  EXTIOI_HAS_CPU_ENCODE		(3)
+#define  EXTIOI_VIRT_HAS_FEATURES	((1U << EXTIOI_HAS_VIRT_EXTENSION) \
+					| (1U << EXTIOI_HAS_ENABLE_OPTION) \
+					| (1U << EXTIOI_HAS_INT_ENCODE)    \
+					| (1U << EXTIOI_HAS_CPU_ENCODE))
+#define  EXTIOI_VIRT_CONFIG		(0x4)
+#define  EXTIOI_ENABLE			(1)
+#define  EXTIOI_ENABLE_INT_ENCODE	(2)
+#define  EXTIOI_ENABLE_CPU_ENCODE	(3)
+
 #define LS3A_IP_NUM			8
 
 struct loongarch_extioi {
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index fa2b2617e54d..a06e559c16cd 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -47,6 +47,8 @@ struct kvm_vm_stat {
 	u64 hugepages;
 	u64 ipi_read_exits;
 	u64 ipi_write_exits;
+	u64 extioi_read_exits;
+	u64 extioi_write_exits;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index ec9fe4cbf949..d019f88b6286 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -114,4 +114,16 @@ struct kvm_iocsr_entry {
 
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
diff --git a/arch/loongarch/kvm/intc/extioi.c b/arch/loongarch/kvm/intc/extioi.c
index b8c796c41a00..c6fa21d076dd 100644
--- a/arch/loongarch/kvm/intc/extioi.c
+++ b/arch/loongarch/kvm/intc/extioi.c
@@ -7,18 +7,718 @@
 #include <asm/kvm_vcpu.h>
 #include <linux/count_zeros.h>
 
+#define loongarch_ext_irq_lock(s, flags)	spin_lock_irqsave(&s->lock, flags)
+#define loongarch_ext_irq_unlock(s, flags)	spin_unlock_irqrestore(&s->lock, flags)
+
+static void extioi_update_irq(struct loongarch_extioi *s, int irq, int level)
+{
+	int ipnum, cpu, found, irq_index, irq_mask;
+	struct kvm_interrupt vcpu_irq;
+	struct kvm_vcpu *vcpu;
+
+	ipnum = s->ipmap.reg_u8[irq / 32];
+	if (!(s->status & BIT(EXTIOI_ENABLE_INT_ENCODE))) {
+		ipnum = count_trailing_zeros(ipnum);
+		ipnum = (ipnum >= 0 && ipnum < 4) ? ipnum : 0;
+	}
+
+	cpu = s->sw_coremap[irq];
+	vcpu = kvm_get_vcpu(s->kvm, cpu);
+	irq_index = irq / 32;
+	/* length of accessing core isr is 4 bytes */
+	irq_mask = BIT(irq & 0x1f);
+
+	if (level) {
+		/* if not enable return false */
+		if (((s->enable.reg_u32[irq_index]) & irq_mask) == 0)
+			return;
+		s->coreisr.reg_u32[cpu][irq_index] |= irq_mask;
+		found = find_first_bit(s->sw_coreisr[cpu][ipnum], EXTIOI_IRQS);
+		set_bit(irq, s->sw_coreisr[cpu][ipnum]);
+	} else {
+		s->coreisr.reg_u32[cpu][irq_index] &= ~irq_mask;
+		clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
+		found = find_first_bit(s->sw_coreisr[cpu][ipnum], EXTIOI_IRQS);
+	}
+
+	if (found < EXTIOI_IRQS)
+		/* other irq is handling, need not update parent irq level */
+		return;
+
+	vcpu_irq.irq = level ? INT_HWI0 + ipnum : -(INT_HWI0 + ipnum);
+	kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
+}
+
+static void extioi_set_sw_coreisr(struct loongarch_extioi *s)
+{
+	int ipnum, cpu, irq_index, irq_mask, irq;
+
+	for (irq = 0; irq < EXTIOI_IRQS; irq++) {
+		ipnum = s->ipmap.reg_u8[irq / 32];
+		if (!(s->status & BIT(EXTIOI_ENABLE_INT_ENCODE))) {
+			ipnum = count_trailing_zeros(ipnum);
+			ipnum = (ipnum >= 0 && ipnum < 4) ? ipnum : 0;
+		}
+		irq_index = irq / 32;
+		/* length of accessing core isr is 4 bytes */
+		irq_mask = BIT(irq & 0x1f);
+
+		cpu = s->coremap.reg_u8[irq];
+		if (!!(s->coreisr.reg_u32[cpu][irq_index] & irq_mask))
+			set_bit(irq, s->sw_coreisr[cpu][ipnum]);
+		else
+			clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
+	}
+}
+
+void extioi_set_irq(struct loongarch_extioi *s, int irq, int level)
+{
+	unsigned long *isr = (unsigned long *)s->isr.reg_u8;
+	unsigned long flags;
+
+	level ? set_bit(irq, isr) : clear_bit(irq, isr);
+	loongarch_ext_irq_lock(s, flags);
+	extioi_update_irq(s, irq, level);
+	loongarch_ext_irq_unlock(s, flags);
+}
+
+static inline void extioi_enable_irq(struct kvm_vcpu *vcpu, struct loongarch_extioi *s,
+				int index, u8 mask, int level)
+{
+	u8 val;
+	int irq;
+
+	val = mask & s->isr.reg_u8[index];
+	irq = ffs(val);
+	while (irq != 0) {
+		/*
+		 * enable bit change from 0 to 1,
+		 * need to update irq by pending bits
+		 */
+		extioi_update_irq(s, irq - 1 + index * 8, level);
+		val &= ~BIT(irq - 1);
+		irq = ffs(val);
+	}
+}
+
+static inline void extioi_update_sw_coremap(struct loongarch_extioi *s, int irq,
+					void *pvalue, u32 len, bool notify)
+{
+	int i, cpu;
+	u64 val = *(u64 *)pvalue;
+
+	for (i = 0; i < len; i++) {
+		cpu = val & 0xff;
+		val = val >> 8;
+
+		if (!(s->status & BIT(EXTIOI_ENABLE_CPU_ENCODE))) {
+			cpu = ffs(cpu) - 1;
+			cpu = (cpu >= 4) ? 0 : cpu;
+		}
+
+		if (s->sw_coremap[irq + i] == cpu)
+			continue;
+
+		if (notify && test_bit(irq + i, (unsigned long *)s->isr.reg_u8)) {
+			/*
+			 * lower irq at old cpu and raise irq at new cpu
+			 */
+			extioi_update_irq(s, irq + i, 0);
+			s->sw_coremap[irq + i] = cpu;
+			extioi_update_irq(s, irq + i, 1);
+		} else {
+			s->sw_coremap[irq + i] = cpu;
+		}
+	}
+}
+
+static int loongarch_extioi_writeb(struct kvm_vcpu *vcpu,
+				struct loongarch_extioi *s,
+				gpa_t addr, int len, const void *val)
+{
+	int index, irq, bits, ret = 0;
+	u8 data, old_data, cpu;
+	u8 coreisr, old_coreisr;
+	gpa_t offset;
+
+	data = *(u8 *)val;
+	offset = addr - EXTIOI_BASE;
+
+	switch (offset) {
+	case EXTIOI_NODETYPE_START ... EXTIOI_NODETYPE_END:
+		index = (offset - EXTIOI_NODETYPE_START);
+		s->nodetype.reg_u8[index] = data;
+		break;
+	case EXTIOI_IPMAP_START ... EXTIOI_IPMAP_END:
+		/*
+		 * ipmap cannot be set at runtime, can be set only at the beginning
+		 * of intr driver, need not update upper irq level
+		 */
+		index = (offset - EXTIOI_IPMAP_START);
+		s->ipmap.reg_u8[index] = data;
+		break;
+	case EXTIOI_ENABLE_START ... EXTIOI_ENABLE_END:
+		index = (offset - EXTIOI_ENABLE_START);
+		old_data = s->enable.reg_u8[index];
+		s->enable.reg_u8[index] = data;
+		/*
+		 * 1: enable irq.
+		 * update irq when isr is set.
+		 */
+		data = s->enable.reg_u8[index] & ~old_data & s->isr.reg_u8[index];
+		extioi_enable_irq(vcpu, s, index, data, 1);
+		/*
+		 * 0: disable irq.
+		 * update irq when isr is set.
+		 */
+		data = ~s->enable.reg_u8[index] & old_data & s->isr.reg_u8[index];
+		extioi_enable_irq(vcpu, s, index, data, 0);
+		break;
+	case EXTIOI_BOUNCE_START ... EXTIOI_BOUNCE_END:
+		/* do not emulate hw bounced irq routing */
+		index = offset - EXTIOI_BOUNCE_START;
+		s->bounce.reg_u8[index] = data;
+		break;
+	case EXTIOI_COREISR_START ... EXTIOI_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EXTIOI_COREISR_START);
+		/* using attrs to get current cpu index */
+		cpu = vcpu->vcpu_id;
+		coreisr = data;
+		old_coreisr = s->coreisr.reg_u8[cpu][index];
+		/* write 1 to clear interrupt */
+		s->coreisr.reg_u8[cpu][index] = old_coreisr & ~coreisr;
+		coreisr &= old_coreisr;
+		bits = sizeof(data) * 8;
+		irq = find_first_bit((void *)&coreisr, bits);
+		while (irq < bits) {
+			extioi_update_irq(s, irq + index * bits, 0);
+			bitmap_clear((void *)&coreisr, irq, 1);
+			irq = find_first_bit((void *)&coreisr, bits);
+		}
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		irq = offset - EXTIOI_COREMAP_START;
+		index = irq;
+		s->coremap.reg_u8[index] = data;
+		extioi_update_sw_coremap(s, irq, (void *)&data,
+					sizeof(data), true);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int loongarch_extioi_writew(struct kvm_vcpu *vcpu,
+				struct loongarch_extioi *s,
+				gpa_t addr, int len, const void *val)
+{
+	int i, index, irq, bits, ret = 0;
+	u8 cpu;
+	u16 data, old_data;
+	u16 coreisr, old_coreisr;
+	gpa_t offset;
+
+	data = *(u16 *)val;
+	offset = addr - EXTIOI_BASE;
+
+	switch (offset) {
+	case EXTIOI_NODETYPE_START ... EXTIOI_NODETYPE_END:
+		index = (offset - EXTIOI_NODETYPE_START) >> 1;
+		s->nodetype.reg_u16[index] = data;
+		break;
+	case EXTIOI_IPMAP_START ... EXTIOI_IPMAP_END:
+		/*
+		 * ipmap cannot be set at runtime, can be set only at the beginning
+		 * of intr driver, need not update upper irq level
+		 */
+		index = (offset - EXTIOI_IPMAP_START) >> 1;
+		s->ipmap.reg_u16[index] = data;
+		break;
+	case EXTIOI_ENABLE_START ... EXTIOI_ENABLE_END:
+		index = (offset - EXTIOI_ENABLE_START) >> 1;
+		old_data = s->enable.reg_u32[index];
+		s->enable.reg_u16[index] = data;
+		/*
+		 * 1: enable irq.
+		 * update irq when isr is set.
+		 */
+		data = s->enable.reg_u16[index] & ~old_data & s->isr.reg_u16[index];
+		index = index << 1;
+		for (i = 0; i < sizeof(data); i++) {
+			u8 mask = (data >> (i * 8)) & 0xff;
+
+			extioi_enable_irq(vcpu, s, index + i, mask, 1);
+		}
+		/*
+		 * 0: disable irq.
+		 * update irq when isr is set.
+		 */
+		data = ~s->enable.reg_u16[index] & old_data & s->isr.reg_u16[index];
+		for (i = 0; i < sizeof(data); i++) {
+			u8 mask = (data >> (i * 8)) & 0xff;
+
+			extioi_enable_irq(vcpu, s, index, mask, 0);
+		}
+		break;
+	case EXTIOI_BOUNCE_START ... EXTIOI_BOUNCE_END:
+		/* do not emulate hw bounced irq routing */
+		index = (offset - EXTIOI_BOUNCE_START) >> 1;
+		s->bounce.reg_u16[index] = data;
+		break;
+	case EXTIOI_COREISR_START ... EXTIOI_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EXTIOI_COREISR_START) >> 1;
+		/* using attrs to get current cpu index */
+		cpu = vcpu->vcpu_id;
+		coreisr = data;
+		old_coreisr = s->coreisr.reg_u16[cpu][index];
+		/* write 1 to clear interrupt */
+		s->coreisr.reg_u16[cpu][index] = old_coreisr & ~coreisr;
+		coreisr &= old_coreisr;
+		bits = sizeof(data) * 8;
+		irq = find_first_bit((void *)&coreisr, bits);
+		while (irq < bits) {
+			extioi_update_irq(s, irq + index * bits, 0);
+			bitmap_clear((void *)&coreisr, irq, 1);
+			irq = find_first_bit((void *)&coreisr, bits);
+		}
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		irq = offset - EXTIOI_COREMAP_START;
+		index = irq >> 1;
+
+		s->coremap.reg_u16[index] = data;
+		extioi_update_sw_coremap(s, irq, (void *)&data,
+					sizeof(data), true);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int loongarch_extioi_writel(struct kvm_vcpu *vcpu,
+				struct loongarch_extioi *s,
+				gpa_t addr, int len, const void *val)
+{
+	int i, index, irq, bits, ret = 0;
+	u8 cpu;
+	u32 data, old_data;
+	u32 coreisr, old_coreisr;
+	gpa_t offset;
+
+	data = *(u32 *)val;
+	offset = addr - EXTIOI_BASE;
+
+	switch (offset) {
+	case EXTIOI_NODETYPE_START ... EXTIOI_NODETYPE_END:
+		index = (offset - EXTIOI_NODETYPE_START) >> 2;
+		s->nodetype.reg_u32[index] = data;
+		break;
+	case EXTIOI_IPMAP_START ... EXTIOI_IPMAP_END:
+		/*
+		 * ipmap cannot be set at runtime, can be set only at the beginning
+		 * of intr driver, need not update upper irq level
+		 */
+		index = (offset - EXTIOI_IPMAP_START) >> 2;
+		s->ipmap.reg_u32[index] = data;
+		break;
+	case EXTIOI_ENABLE_START ... EXTIOI_ENABLE_END:
+		index = (offset - EXTIOI_ENABLE_START) >> 2;
+		old_data = s->enable.reg_u32[index];
+		s->enable.reg_u32[index] = data;
+		/*
+		 * 1: enable irq.
+		 * update irq when isr is set.
+		 */
+		data = s->enable.reg_u32[index] & ~old_data & s->isr.reg_u32[index];
+		index = index << 2;
+		for (i = 0; i < sizeof(data); i++) {
+			u8 mask = (data >> (i * 8)) & 0xff;
+
+			extioi_enable_irq(vcpu, s, index + i, mask, 1);
+		}
+		/*
+		 * 0: disable irq.
+		 * update irq when isr is set.
+		 */
+		data = ~s->enable.reg_u32[index] & old_data & s->isr.reg_u32[index];
+		for (i = 0; i < sizeof(data); i++) {
+			u8 mask = (data >> (i * 8)) & 0xff;
+
+			extioi_enable_irq(vcpu, s, index, mask, 0);
+		}
+		break;
+	case EXTIOI_BOUNCE_START ... EXTIOI_BOUNCE_END:
+		/* do not emulate hw bounced irq routing */
+		index = (offset - EXTIOI_BOUNCE_START) >> 2;
+		s->bounce.reg_u32[index] = data;
+		break;
+	case EXTIOI_COREISR_START ... EXTIOI_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EXTIOI_COREISR_START) >> 2;
+		/* using attrs to get current cpu index */
+		cpu = vcpu->vcpu_id;
+		coreisr = data;
+		old_coreisr = s->coreisr.reg_u32[cpu][index];
+		/* write 1 to clear interrupt */
+		s->coreisr.reg_u32[cpu][index] = old_coreisr & ~coreisr;
+		coreisr &= old_coreisr;
+		bits = sizeof(data) * 8;
+		irq = find_first_bit((void *)&coreisr, bits);
+		while (irq < bits) {
+			extioi_update_irq(s, irq + index * bits, 0);
+			bitmap_clear((void *)&coreisr, irq, 1);
+			irq = find_first_bit((void *)&coreisr, bits);
+		}
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		irq = offset - EXTIOI_COREMAP_START;
+		index = irq >> 2;
+
+		s->coremap.reg_u32[index] = data;
+		extioi_update_sw_coremap(s, irq, (void *)&data,
+					sizeof(data), true);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int loongarch_extioi_writeq(struct kvm_vcpu *vcpu,
+				struct loongarch_extioi *s,
+				gpa_t addr, int len, const void *val)
+{
+	int i, index, irq, bits, ret = 0;
+	u8 cpu;
+	u64 data, old_data;
+	u64 coreisr, old_coreisr;
+	gpa_t offset;
+
+	data = *(u64 *)val;
+	offset = addr - EXTIOI_BASE;
+
+	switch (offset) {
+	case EXTIOI_NODETYPE_START ... EXTIOI_NODETYPE_END:
+		index = (offset - EXTIOI_NODETYPE_START) >> 3;
+		s->nodetype.reg_u64[index] = data;
+		break;
+	case EXTIOI_IPMAP_START ... EXTIOI_IPMAP_END:
+		/*
+		 * ipmap cannot be set at runtime, can be set only at the beginning
+		 * of intr driver, need not update upper irq level
+		 */
+		index = (offset - EXTIOI_IPMAP_START) >> 3;
+		s->ipmap.reg_u64 = data;
+		break;
+	case EXTIOI_ENABLE_START ... EXTIOI_ENABLE_END:
+		index = (offset - EXTIOI_ENABLE_START) >> 3;
+		old_data = s->enable.reg_u64[index];
+		s->enable.reg_u64[index] = data;
+		/*
+		 * 1: enable irq.
+		 * update irq when isr is set.
+		 */
+		data = s->enable.reg_u64[index] & ~old_data & s->isr.reg_u64[index];
+		index = index << 3;
+		for (i = 0; i < sizeof(data); i++) {
+			u8 mask = (data >> (i * 8)) & 0xff;
+
+			extioi_enable_irq(vcpu, s, index + i, mask, 1);
+		}
+		/*
+		 * 0: disable irq.
+		 * update irq when isr is set.
+		 */
+		data = ~s->enable.reg_u64[index] & old_data & s->isr.reg_u64[index];
+		for (i = 0; i < sizeof(data); i++) {
+			u8 mask = (data >> (i * 8)) & 0xff;
+
+			extioi_enable_irq(vcpu, s, index, mask, 0);
+		}
+		break;
+	case EXTIOI_BOUNCE_START ... EXTIOI_BOUNCE_END:
+		/* do not emulate hw bounced irq routing */
+		index = (offset - EXTIOI_BOUNCE_START) >> 3;
+		s->bounce.reg_u64[index] = data;
+		break;
+	case EXTIOI_COREISR_START ... EXTIOI_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EXTIOI_COREISR_START) >> 3;
+		/* using attrs to get current cpu index */
+		cpu = vcpu->vcpu_id;
+		coreisr = data;
+		old_coreisr = s->coreisr.reg_u64[cpu][index];
+		/* write 1 to clear interrupt */
+		s->coreisr.reg_u64[cpu][index] = old_coreisr & ~coreisr;
+		coreisr &= old_coreisr;
+		bits = sizeof(data) * 8;
+		irq = find_first_bit((void *)&coreisr, bits);
+		while (irq < bits) {
+			extioi_update_irq(s, irq + index * bits, 0);
+			bitmap_clear((void *)&coreisr, irq, 1);
+			irq = find_first_bit((void *)&coreisr, bits);
+		}
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		irq = offset - EXTIOI_COREMAP_START;
+		index = irq >> 3;
+
+		s->coremap.reg_u64[index] = data;
+		extioi_update_sw_coremap(s, irq, (void *)&data,
+					sizeof(data), true);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
 static int kvm_extioi_write(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, const void *val)
 {
-	return 0;
+	int ret;
+	struct loongarch_extioi *extioi = vcpu->kvm->arch.extioi;
+	unsigned long flags;
+
+	if (!extioi) {
+		kvm_err("%s: extioi irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	vcpu->kvm->stat.extioi_write_exits++;
+	loongarch_ext_irq_lock(extioi, flags);
+	switch (len) {
+	case 1:
+		ret = loongarch_extioi_writeb(vcpu, extioi, addr, len, val);
+		break;
+	case 2:
+		ret = loongarch_extioi_writew(vcpu, extioi, addr, len, val);
+		break;
+	case 4:
+		ret = loongarch_extioi_writel(vcpu, extioi, addr, len, val);
+		break;
+	case 8:
+		ret = loongarch_extioi_writeq(vcpu, extioi, addr, len, val);
+		break;
+	default:
+		WARN_ONCE(1, "%s: Abnormal address access:addr 0x%llx,size %d\n",
+						__func__, addr, len);
+	}
+	loongarch_ext_irq_unlock(extioi, flags);
+	return ret;
+}
+
+static int loongarch_extioi_readb(struct kvm_vcpu *vcpu, struct loongarch_extioi *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u8 data = 0;
+
+	offset = addr - EXTIOI_BASE;
+	switch (offset) {
+	case EXTIOI_NODETYPE_START ... EXTIOI_NODETYPE_END:
+		index = offset - EXTIOI_NODETYPE_START;
+		data = s->nodetype.reg_u8[index];
+		break;
+	case EXTIOI_IPMAP_START ... EXTIOI_IPMAP_END:
+		index = offset - EXTIOI_IPMAP_START;
+		data = s->ipmap.reg_u8[index];
+		break;
+	case EXTIOI_ENABLE_START ... EXTIOI_ENABLE_END:
+		index = offset - EXTIOI_ENABLE_START;
+		data = s->enable.reg_u8[index];
+		break;
+	case EXTIOI_BOUNCE_START ... EXTIOI_BOUNCE_END:
+		index = offset - EXTIOI_BOUNCE_START;
+		data = s->bounce.reg_u8[index];
+		break;
+	case EXTIOI_COREISR_START ... EXTIOI_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = offset - EXTIOI_COREISR_START;
+		data = s->coreisr.reg_u8[vcpu->vcpu_id][index];
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		index = offset - EXTIOI_COREMAP_START;
+		data = s->coremap.reg_u8[index];
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	*(u8 *)val = data;
+	return ret;
+}
+
+static int loongarch_extioi_readw(struct kvm_vcpu *vcpu, struct loongarch_extioi *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u16 data = 0;
+
+	offset = addr - EXTIOI_BASE;
+	switch (offset) {
+	case EXTIOI_NODETYPE_START ... EXTIOI_NODETYPE_END:
+		index = (offset - EXTIOI_NODETYPE_START) >> 1;
+		data = s->nodetype.reg_u16[index];
+		break;
+	case EXTIOI_IPMAP_START ... EXTIOI_IPMAP_END:
+		index = (offset - EXTIOI_IPMAP_START) >> 1;
+		data = s->ipmap.reg_u16[index];
+		break;
+	case EXTIOI_ENABLE_START ... EXTIOI_ENABLE_END:
+		index = (offset - EXTIOI_ENABLE_START) >> 1;
+		data = s->enable.reg_u16[index];
+		break;
+	case EXTIOI_BOUNCE_START ... EXTIOI_BOUNCE_END:
+		index = (offset - EXTIOI_BOUNCE_START) >> 1;
+		data = s->bounce.reg_u16[index];
+		break;
+	case EXTIOI_COREISR_START ... EXTIOI_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EXTIOI_COREISR_START) >> 1;
+		data = s->coreisr.reg_u16[vcpu->vcpu_id][index];
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		index = (offset - EXTIOI_COREMAP_START) >> 1;
+		data = s->coremap.reg_u16[index];
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	*(u16 *)val = data;
+	return ret;
+}
+
+static int loongarch_extioi_readl(struct kvm_vcpu *vcpu, struct loongarch_extioi *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u32 data = 0;
+
+	offset = addr - EXTIOI_BASE;
+	switch (offset) {
+	case EXTIOI_NODETYPE_START ... EXTIOI_NODETYPE_END:
+		index = (offset - EXTIOI_NODETYPE_START) >> 2;
+		data = s->nodetype.reg_u32[index];
+		break;
+	case EXTIOI_IPMAP_START ... EXTIOI_IPMAP_END:
+		index = (offset - EXTIOI_IPMAP_START) >> 2;
+		data = s->ipmap.reg_u32[index];
+		break;
+	case EXTIOI_ENABLE_START ... EXTIOI_ENABLE_END:
+		index = (offset - EXTIOI_ENABLE_START) >> 2;
+		data = s->enable.reg_u32[index];
+		break;
+	case EXTIOI_BOUNCE_START ... EXTIOI_BOUNCE_END:
+		index = (offset - EXTIOI_BOUNCE_START) >> 2;
+		data = s->bounce.reg_u32[index];
+		break;
+	case EXTIOI_COREISR_START ... EXTIOI_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EXTIOI_COREISR_START) >> 2;
+		data = s->coreisr.reg_u32[vcpu->vcpu_id][index];
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		index = (offset - EXTIOI_COREMAP_START) >> 2;
+		data = s->coremap.reg_u32[index];
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	*(u32 *)val = data;
+	return ret;
+}
+
+static int loongarch_extioi_readq(struct kvm_vcpu *vcpu, struct loongarch_extioi *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u64 data = 0;
+
+	offset = addr - EXTIOI_BASE;
+	switch (offset) {
+	case EXTIOI_NODETYPE_START ... EXTIOI_NODETYPE_END:
+		index = (offset - EXTIOI_NODETYPE_START) >> 3;
+		data = s->nodetype.reg_u64[index];
+		break;
+	case EXTIOI_IPMAP_START ... EXTIOI_IPMAP_END:
+		index = (offset - EXTIOI_IPMAP_START) >> 3;
+		data = s->ipmap.reg_u64;
+		break;
+	case EXTIOI_ENABLE_START ... EXTIOI_ENABLE_END:
+		index = (offset - EXTIOI_ENABLE_START) >> 3;
+		data = s->enable.reg_u64[index];
+		break;
+	case EXTIOI_BOUNCE_START ... EXTIOI_BOUNCE_END:
+		index = (offset - EXTIOI_BOUNCE_START) >> 3;
+		data = s->bounce.reg_u64[index];
+		break;
+	case EXTIOI_COREISR_START ... EXTIOI_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EXTIOI_COREISR_START) >> 3;
+		data = s->coreisr.reg_u64[vcpu->vcpu_id][index];
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		index = (offset - EXTIOI_COREMAP_START) >> 3;
+		data = s->coremap.reg_u64[index];
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	*(u64 *)val = data;
+	return ret;
 }
 
 static int kvm_extioi_read(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, void *val)
 {
-	return 0;
+	int ret;
+	struct loongarch_extioi *extioi = vcpu->kvm->arch.extioi;
+	unsigned long flags;
+
+	if (!extioi) {
+		kvm_err("%s: extioi irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	vcpu->kvm->stat.extioi_read_exits++;
+	loongarch_ext_irq_lock(extioi, flags);
+	switch (len) {
+	case 1:
+		ret = loongarch_extioi_readb(vcpu, extioi, addr, len, val);
+		break;
+	case 2:
+		ret = loongarch_extioi_readw(vcpu, extioi, addr, len, val);
+		break;
+	case 4:
+		ret = loongarch_extioi_readl(vcpu, extioi, addr, len, val);
+		break;
+	case 8:
+		ret = loongarch_extioi_readq(vcpu, extioi, addr, len, val);
+		break;
+	default:
+		WARN_ONCE(1, "%s: Abnormal address access:addr 0x%llx,size %d\n",
+						__func__, addr, len);
+	}
+	loongarch_ext_irq_unlock(extioi, flags);
+	return ret;
 }
 
 static const struct kvm_io_device_ops kvm_extioi_ops = {
@@ -30,6 +730,28 @@ static int kvm_extioi_virt_read(struct kvm_vcpu *vcpu,
 				struct kvm_io_device *dev,
 				gpa_t addr, int len, void *val)
 {
+	struct loongarch_extioi *extioi = vcpu->kvm->arch.extioi;
+	unsigned long flags;
+	u32 *data = val;
+
+	if (!extioi) {
+		kvm_err("%s: extioi irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	addr -= EXTIOI_VIRT_BASE;
+	loongarch_ext_irq_lock(extioi, flags);
+	switch (addr) {
+	case EXTIOI_VIRT_FEATURES:
+		*data = extioi->features;
+		break;
+	case EXTIOI_VIRT_CONFIG:
+		*data = extioi->status;
+		break;
+	default:
+		break;
+	}
+	loongarch_ext_irq_unlock(extioi, flags);
 	return 0;
 }
 
@@ -37,7 +759,37 @@ static int kvm_extioi_virt_write(struct kvm_vcpu *vcpu,
 				struct kvm_io_device *dev,
 				gpa_t addr, int len, const void *val)
 {
-	return 0;
+	int ret = 0;
+	struct loongarch_extioi *extioi = vcpu->kvm->arch.extioi;
+	unsigned long flags;
+	u32 value = *(u32 *)val;
+
+	if (!extioi) {
+		kvm_err("%s: extioi irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	addr -= EXTIOI_VIRT_BASE;
+	loongarch_ext_irq_lock(extioi, flags);
+	switch (addr) {
+	case EXTIOI_VIRT_FEATURES:
+		ret = -EPERM;
+		break;
+	case EXTIOI_VIRT_CONFIG:
+		/*
+		 * extioi features can only be set at disabled status
+		 */
+		if ((extioi->status & BIT(EXTIOI_ENABLE)) && value) {
+			ret = -EPERM;
+			break;
+		}
+		extioi->status = value & extioi->features;
+		break;
+	default:
+		break;
+	}
+	loongarch_ext_irq_unlock(extioi, flags);
+	return ret;
 }
 
 static const struct kvm_io_device_ops kvm_extioi_virt_ops = {
@@ -45,16 +797,190 @@ static const struct kvm_io_device_ops kvm_extioi_virt_ops = {
 	.write	= kvm_extioi_virt_write,
 };
 
+static int kvm_extioi_ctrl_access(struct kvm_device *dev,
+					struct kvm_device_attr *attr)
+{
+	unsigned long  type = (unsigned long)attr->attr;
+	unsigned long flags;
+	struct loongarch_extioi *s = dev->kvm->arch.extioi;
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
+		if (!(s->features & BIT(EXTIOI_HAS_VIRT_EXTENSION)))
+			s->status |= BIT(EXTIOI_ENABLE);
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_LOAD_FINISHED:
+		extioi_set_sw_coreisr(s);
+		for (i = 0; i < (EXTIOI_IRQS / 4); i++) {
+			start_irq = i * 4;
+			extioi_update_sw_coremap(s, start_irq,
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
+static int kvm_extioi_regs_access(struct kvm_device *dev,
+					struct kvm_device_attr *attr,
+					bool is_write)
+{
+	int len, addr, cpuid, offset, ret = 0;
+	void __user *data;
+	void *p = NULL;
+	struct loongarch_extioi *s;
+	unsigned long flags;
+
+	len = 4;
+	s = dev->kvm->arch.extioi;
+	addr = attr->attr;
+	cpuid = addr >> 16;
+	addr &= 0xffff;
+	data = (void __user *)attr->addr;
+	switch (addr) {
+	case EXTIOI_NODETYPE_START ... EXTIOI_NODETYPE_END:
+		offset = (addr - EXTIOI_NODETYPE_START) / 4;
+		p = &s->nodetype.reg_u32[offset];
+		break;
+	case EXTIOI_IPMAP_START ... EXTIOI_IPMAP_END:
+		offset = (addr - EXTIOI_IPMAP_START) / 4;
+		p = &s->ipmap.reg_u32[offset];
+		break;
+	case EXTIOI_ENABLE_START ... EXTIOI_ENABLE_END:
+		offset = (addr - EXTIOI_ENABLE_START) / 4;
+		p = &s->enable.reg_u32[offset];
+		break;
+	case EXTIOI_BOUNCE_START ... EXTIOI_BOUNCE_END:
+		offset = (addr - EXTIOI_BOUNCE_START) / 4;
+		p = &s->bounce.reg_u32[offset];
+		break;
+	case EXTIOI_ISR_START ... EXTIOI_ISR_END:
+		offset = (addr - EXTIOI_ISR_START) / 4;
+		p = &s->isr.reg_u32[offset];
+		break;
+	case EXTIOI_COREISR_START ... EXTIOI_COREISR_END:
+		offset = (addr - EXTIOI_COREISR_START) / 4;
+		p = &s->coreisr.reg_u32[cpuid][offset];
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		offset = (addr - EXTIOI_COREMAP_START) / 4;
+		p = &s->coremap.reg_u32[offset];
+		break;
+	default:
+		kvm_err("%s: unknown extioi register, addr = %d\n", __func__, addr);
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
+static int kvm_extioi_sw_status_access(struct kvm_device *dev,
+					struct kvm_device_attr *attr,
+					bool is_write)
+{
+	int len, addr, ret = 0;
+	void __user *data;
+	void *p = NULL;
+	struct loongarch_extioi *s;
+	unsigned long flags;
+
+	len = 4;
+	s = dev->kvm->arch.extioi;
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
+		kvm_err("%s: unknown extioi register, addr = %d\n", __func__, addr);
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
 static int kvm_extioi_get_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	return 0;
+	__u32	group = attr->group;
+	int ret = -EINVAL;
+
+	switch (group) {
+	case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
+		ret = kvm_extioi_regs_access(dev, attr, false);
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
+		ret = kvm_extioi_sw_status_access(dev, attr, false);
+		break;
+	default:
+		break;
+	}
+	return ret;
 }
 
 static int kvm_extioi_set_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	return 0;
+	__u32	group = attr->group;
+	int ret = -EINVAL;
+
+	switch (group) {
+	case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
+		ret = kvm_extioi_regs_access(dev, attr, true);
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
+		ret = kvm_extioi_sw_status_access(dev, attr, true);
+		break;
+	case KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL:
+		ret = kvm_extioi_ctrl_access(dev, attr);
+		break;
+	default:
+		break;
+	}
+	return ret;
 }
 
 static void kvm_extioi_destroy(struct kvm_device *dev)
-- 
2.39.1


