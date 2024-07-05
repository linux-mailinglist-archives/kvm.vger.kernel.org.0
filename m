Return-Path: <kvm+bounces-21026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA7F9280B4
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB13F286413
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB95514532F;
	Fri,  5 Jul 2024 02:56:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22C113A88B;
	Fri,  5 Jul 2024 02:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148189; cv=none; b=nK6WPiWzIOsX+kEpD6UkaOf5xhBf+ghzBlc1gKlbzMrpcBUFd7MhnlfqGg5dSv4pmySQPlnMga8v8QQph9ujU7KDKyeMoyUE74+JN3fivvVq29RE1YnvRXbvqjdokWbVWhJnPwPbjX+r7iFsjVM1np0ulI4WH2SOJ39T1PZ83Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148189; c=relaxed/simple;
	bh=/j9uWvl0fpK2RC+meqAj9BTLxLyQwoB2y3VKrRCFwng=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D903MTBUP4z1OYgvIE9/9Q6RiDOhDlJAjolckaoyCLaSqGJRnXWet8iDlDWmEnxdeR4qwmbBR+3lUSEfP2dxIGMHJSO6b0dYFfnTEP4QDxdRgUtVdbneUHLvTXlX49uCUcu6pHbyH3P3r/o5/8Ikkk2cEyd4LiEpglxLKRTlTuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxvfDXYIdm9iQBAA--.3761S3;
	Fri, 05 Jul 2024 10:56:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWcbRYIdm3tE7AA--.7292S8;
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
Subject: [PATCH 06/11] LoongArch: KVM: Add EXTIOI read and write functions
Date: Fri,  5 Jul 2024 10:38:49 +0800
Message-Id: <20240705023854.1005258-7-lixianglai@loongson.cn>
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
X-CM-TRANSID:AQAAf8BxWcbRYIdm3tE7AA--.7292S8
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
Cc: Min Zhou <zhoumin@loongson.cn> 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/asm/kvm_extioi.h |  17 +
 arch/loongarch/include/asm/kvm_host.h   |   2 +
 arch/loongarch/kvm/intc/extioi.c        | 577 +++++++++++++++++++++++-
 3 files changed, 594 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_extioi.h b/arch/loongarch/include/asm/kvm_extioi.h
index 48a117b2be5d..d2af039a7d6f 100644
--- a/arch/loongarch/include/asm/kvm_extioi.h
+++ b/arch/loongarch/include/asm/kvm_extioi.h
@@ -19,8 +19,25 @@
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
+#define EXTIOI_COREISR_END		0x71f
+#define EXTIOI_COREMAP_START		0x800
+#define EXTIOI_COREMAP_END		0x8ff
+
 #define LS3A_INTC_IP			8
 
+#define EXTIOI_SW_COREMAP_FLAG		(1 << 0)
+
 struct loongarch_extioi {
 	spinlock_t lock;
 	struct kvm *kvm;
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 0e4e46e06420..5c2adebd16b2 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -44,6 +44,8 @@ struct kvm_vm_stat {
 	u64 hugepages;
 	u64 ipi_read_exits;
 	u64 ipi_write_exits;
+	u64 extioi_read_exits;
+	u64 extioi_write_exits;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/loongarch/kvm/intc/extioi.c b/arch/loongarch/kvm/intc/extioi.c
index 2f1b93e95f97..dd18b7a7599a 100644
--- a/arch/loongarch/kvm/intc/extioi.c
+++ b/arch/loongarch/kvm/intc/extioi.c
@@ -7,18 +7,591 @@
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
+	ipnum = count_trailing_zeros(ipnum);
+	ipnum = (ipnum >= 0 && ipnum < 4) ? ipnum : 0;
+
+	cpu = s->sw_coremap[irq];
+	vcpu = kvm_get_vcpu(s->kvm, cpu);
+	irq_index = irq / 32;
+	/* length of accessing core isr is 4 bytes */
+	irq_mask = 1 << (irq & 0x1f);
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
+void extioi_set_irq(struct loongarch_extioi *s, int irq, int level)
+{
+	unsigned long *isr = (unsigned long *)s->isr.reg_u8;
+	unsigned long flags;
+
+	level ? set_bit(irq, isr) : clear_bit(irq, isr);
+	if (!level)
+		return;
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
+		val &= ~(1 << (irq - 1));
+		irq = ffs(val);
+	}
+}
+
+static int loongarch_extioi_writeb(struct kvm_vcpu *vcpu,
+				struct loongarch_extioi *s,
+				gpa_t addr, int len, const void *val)
+{
+	int index, irq, ret = 0;
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
+		irq = ffs(coreisr);
+		while (irq != 0) {
+			extioi_update_irq(s, irq - 1 + index * 8, 0);
+			coreisr &= ~(1 << (irq - 1));
+			irq = ffs(coreisr);
+		}
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		irq = offset - EXTIOI_COREMAP_START;
+		index = irq;
+		s->coremap.reg_u8[index] = data;
+
+		cpu = data & 0xff;
+		cpu = ffs(cpu) - 1;
+		cpu = (cpu >= 4) ? 0 : cpu;
+
+		if (s->sw_coremap[irq] == cpu)
+			break;
+
+		if (test_bit(irq, (unsigned long *)s->isr.reg_u8)) {
+			/*
+			 * lower irq at old cpu and raise irq at new cpu
+			 */
+			extioi_update_irq(s, irq, 0);
+			s->sw_coremap[irq] = cpu;
+			extioi_update_irq(s, irq, 1);
+		} else
+			s->sw_coremap[irq] = cpu;
+
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
+	int i, index, irq, ret = 0;
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
+		irq = ffs(coreisr);
+		while (irq != 0) {
+			extioi_update_irq(s, irq - 1 + index * 32, 0);
+			coreisr &= ~(1 << (irq - 1));
+			irq = ffs(coreisr);
+		}
+		break;
+	case EXTIOI_COREMAP_START ... EXTIOI_COREMAP_END:
+		irq = offset - EXTIOI_COREMAP_START;
+		index = irq >> 2;
+
+		s->coremap.reg_u32[index] = data;
+
+		for (i = 0; i < sizeof(data); i++) {
+			cpu = data & 0xff;
+			cpu = ffs(cpu) - 1;
+			cpu = (cpu >= 4) ? 0 : cpu;
+			data = data >> 8;
+
+			if (s->sw_coremap[irq + i] == cpu)
+				continue;
+
+			if (test_bit(irq, (unsigned long *)s->isr.reg_u8)) {
+				/*
+				 * lower irq at old cpu and raise irq at new cpu
+				 */
+				extioi_update_irq(s, irq + i, 0);
+				s->sw_coremap[irq + i] = cpu;
+				extioi_update_irq(s, irq + i, 1);
+			} else
+				s->sw_coremap[irq + i] = cpu;
+		}
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
+
+		bits = sizeof(u64) * 8;
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
+
+		for (i = 0; i < sizeof(data); i++) {
+			cpu = data & 0xff;
+			cpu = ffs(cpu) - 1;
+			cpu = (cpu >= 4) ? 0 : cpu;
+			data = data >> 8;
+
+			if (s->sw_coremap[irq + i] == cpu)
+				continue;
+
+			if (test_bit(irq, (unsigned long *)s->isr.reg_u8)) {
+				/*
+				 * lower irq at old cpu and raise irq at new cpu
+				 */
+				extioi_update_irq(s, irq + i, 0);
+				s->sw_coremap[irq + i] = cpu;
+				extioi_update_irq(s, irq + i, 1);
+			} else
+				s->sw_coremap[irq + i] = cpu;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
 static int kvm_loongarch_extioi_write(struct kvm_vcpu *vcpu,
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
+
+	switch (len) {
+	case 1:
+		ret = loongarch_extioi_writeb(vcpu, extioi, addr, len, val);
+		break;
+	case 4:
+		ret = loongarch_extioi_writew(vcpu, extioi, addr, len, val);
+		break;
+	case 8:
+		ret = loongarch_extioi_writel(vcpu, extioi, addr, len, val);
+		break;
+	default:
+		WARN_ONCE(1, "%s: Abnormal address access:addr 0x%llx,size %d\n",
+						__func__, addr, len);
+	}
+
+	loongarch_ext_irq_unlock(extioi, flags);
+
+
+	return ret;
+}
+
+static int loongarch_extioi_readb(struct kvm_vcpu *vcpu, struct loongarch_extioi *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u64 data;
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
+
+	*(u8 *)val = data;
+
+	return ret;
+}
+
+static int loongarch_extioi_readw(struct kvm_vcpu *vcpu, struct loongarch_extioi *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u64 data;
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
+
+	*(u32 *)val = data;
+
+	return ret;
+}
+
+static int loongarch_extioi_readl(struct kvm_vcpu *vcpu, struct loongarch_extioi *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u64 data;
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
+
+	*(u64 *)val = data;
+
+	return ret;
 }
 
 static int kvm_loongarch_extioi_read(struct kvm_vcpu *vcpu,
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
+
+	switch (len) {
+	case 1:
+		ret = loongarch_extioi_readb(vcpu, extioi, addr, len, val);
+		break;
+	case 4:
+		ret = loongarch_extioi_readw(vcpu, extioi, addr, len, val);
+		break;
+	case 8:
+		ret = loongarch_extioi_readl(vcpu, extioi, addr, len, val);
+		break;
+	default:
+		WARN_ONCE(1, "%s: Abnormal address access:addr 0x%llx,size %d\n",
+						__func__, addr, len);
+	}
+
+	loongarch_ext_irq_unlock(extioi, flags);
+
+	return ret;
 }
 
 static const struct kvm_io_device_ops kvm_loongarch_extioi_ops = {
-- 
2.39.1


