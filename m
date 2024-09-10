Return-Path: <kvm+bounces-26253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E539736BB
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0ACB11F27234
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC4E191466;
	Tue, 10 Sep 2024 12:02:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9596D1885BD;
	Tue, 10 Sep 2024 12:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725969758; cv=none; b=HSlX8BIbHcf/YZtwOfUBkuEsvYZ10AkGzpX8EZcNltbS8QJFxUQ9lGzouwsJha2fRLlmRKwKvGrEzPOq7mgpHLHYxTpLhlRq2YuhZFEVyK8Je4AYLXMNCs8Bc7bHx+PEZjaoxShBz9vpw3gWuXrY7D8YZPinMSyieK84MvOW9U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725969758; c=relaxed/simple;
	bh=29lkZjII4TvYdI0L43CWnuug9kOhfGs63bi+G2YUc20=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s7RRwI8Eo90ZMmfDxcrGyoKlvKForm9nRMUIRS9nTMF/RlUelquhOA6NqsU+CzS1uQZWJj0KsFCRR+9taAiVlZ5YXTLpEPQ64pSPU2Cl+4yozKj+kRIyNsd/72iKieH3v6SKAQTH8XGX/ejnXqfEupzKGR8WsjfMhEB05dw2FgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8AxKOlXNeBmjq8DAA--.7618S3;
	Tue, 10 Sep 2024 20:02:31 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front2 (Coremail) with SMTP id qciowMDx_OVVNeBmE2MDAA--.16225S2;
	Tue, 10 Sep 2024 20:02:29 +0800 (CST)
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
Subject: [PATCH V3 06/11] LoongArch: KVM: Add EIOINTC read and write functions
Date: Tue, 10 Sep 2024 19:44:56 +0800
Message-Id: <20240910114501.4062476-1-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qciowMDx_OVVNeBmE2MDAA--.16225S2
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implementation of EIOINTC interrupt controller address
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

 arch/loongarch/include/asm/kvm_eiointc.h |  29 +
 arch/loongarch/include/asm/kvm_host.h    |   2 +
 arch/loongarch/kvm/intc/eiointc.c        | 762 ++++++++++++++++++++++-
 3 files changed, 788 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch/include/asm/kvm_eiointc.h
index abbc4ce6d86b..4da98c7cb7d1 100644
--- a/arch/loongarch/include/asm/kvm_eiointc.h
+++ b/arch/loongarch/include/asm/kvm_eiointc.h
@@ -20,9 +20,38 @@
 #define EIOINTC_BASE			0x1400
 #define EIOINTC_SIZE			0x900
 
+#define EIOINTC_NODETYPE_START		0xa0
+#define EIOINTC_NODETYPE_END		0xbf
+#define EIOINTC_IPMAP_START		0xc0
+#define EIOINTC_IPMAP_END		0xc7
+#define EIOINTC_ENABLE_START		0x200
+#define EIOINTC_ENABLE_END		0x21f
+#define EIOINTC_BOUNCE_START		0x280
+#define EIOINTC_BOUNCE_END		0x29f
+#define EIOINTC_ISR_START		0x300
+#define EIOINTC_ISR_END			0x31f
+#define EIOINTC_COREISR_START		0x400
+#define EIOINTC_COREISR_END		0x41f
+#define EIOINTC_COREMAP_START		0x800
+#define EIOINTC_COREMAP_END		0x8ff
+
 #define EIOINTC_VIRT_BASE		(0x40000000)
 #define EIOINTC_VIRT_SIZE		(0x1000)
 
+#define  EIOINTC_VIRT_FEATURES		(0x0)
+#define  EIOINTC_HAS_VIRT_EXTENSION	(0)
+#define  EIOINTC_HAS_ENABLE_OPTION	(1)
+#define  EIOINTC_HAS_INT_ENCODE		(2)
+#define  EIOINTC_HAS_CPU_ENCODE		(3)
+#define  EIOINTC_VIRT_HAS_FEATURES	((1U << EIOINTC_HAS_VIRT_EXTENSION) \
+					| (1U << EIOINTC_HAS_ENABLE_OPTION) \
+					| (1U << EIOINTC_HAS_INT_ENCODE)    \
+					| (1U << EIOINTC_HAS_CPU_ENCODE))
+#define  EIOINTC_VIRT_CONFIG		(0x4)
+#define  EIOINTC_ENABLE			(1)
+#define  EIOINTC_ENABLE_INT_ENCODE	(2)
+#define  EIOINTC_ENABLE_CPU_ENCODE	(3)
+
 #define LS3A_IP_NUM			8
 
 struct loongarch_eiointc {
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index e80405bc3f4f..41d37e0aaabd 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -47,6 +47,8 @@ struct kvm_vm_stat {
 	u64 hugepages;
 	u64 ipi_read_exits;
 	u64 ipi_write_exits;
+	u64 eiointc_read_exits;
+	u64 eiointc_write_exits;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 3473150a5e90..b372cd4264ef 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -7,18 +7,718 @@
 #include <asm/kvm_vcpu.h>
 #include <linux/count_zeros.h>
 
+#define loongarch_ext_irq_lock(s, flags)	spin_lock_irqsave(&s->lock, flags)
+#define loongarch_ext_irq_unlock(s, flags)	spin_unlock_irqrestore(&s->lock, flags)
+
+static void eiointc_update_irq(struct loongarch_eiointc *s, int irq, int level)
+{
+	int ipnum, cpu, found, irq_index, irq_mask;
+	struct kvm_interrupt vcpu_irq;
+	struct kvm_vcpu *vcpu;
+
+	ipnum = s->ipmap.reg_u8[irq / 32];
+	if (!(s->status & BIT(EIOINTC_ENABLE_INT_ENCODE))) {
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
+		found = find_first_bit(s->sw_coreisr[cpu][ipnum], EIOINTC_IRQS);
+		set_bit(irq, s->sw_coreisr[cpu][ipnum]);
+	} else {
+		s->coreisr.reg_u32[cpu][irq_index] &= ~irq_mask;
+		clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
+		found = find_first_bit(s->sw_coreisr[cpu][ipnum], EIOINTC_IRQS);
+	}
+
+	if (found < EIOINTC_IRQS)
+		/* other irq is handling, need not update parent irq level */
+		return;
+
+	vcpu_irq.irq = level ? INT_HWI0 + ipnum : -(INT_HWI0 + ipnum);
+	kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
+}
+
+static void eiointc_set_sw_coreisr(struct loongarch_eiointc *s)
+{
+	int ipnum, cpu, irq_index, irq_mask, irq;
+
+	for (irq = 0; irq < EIOINTC_IRQS; irq++) {
+		ipnum = s->ipmap.reg_u8[irq / 32];
+		if (!(s->status & BIT(EIOINTC_ENABLE_INT_ENCODE))) {
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
+void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level)
+{
+	unsigned long *isr = (unsigned long *)s->isr.reg_u8;
+	unsigned long flags;
+
+	level ? set_bit(irq, isr) : clear_bit(irq, isr);
+	loongarch_ext_irq_lock(s, flags);
+	eiointc_update_irq(s, irq, level);
+	loongarch_ext_irq_unlock(s, flags);
+}
+
+static inline void eiointc_enable_irq(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
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
+		eiointc_update_irq(s, irq - 1 + index * 8, level);
+		val &= ~BIT(irq - 1);
+		irq = ffs(val);
+	}
+}
+
+static inline void eiointc_update_sw_coremap(struct loongarch_eiointc *s, int irq,
+					void *pvalue, u32 len, bool notify)
+{
+	int i, cpu;
+	u64 val = *(u64 *)pvalue;
+
+	for (i = 0; i < len; i++) {
+		cpu = val & 0xff;
+		val = val >> 8;
+
+		if (!(s->status & BIT(EIOINTC_ENABLE_CPU_ENCODE))) {
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
+			eiointc_update_irq(s, irq + i, 0);
+			s->sw_coremap[irq + i] = cpu;
+			eiointc_update_irq(s, irq + i, 1);
+		} else {
+			s->sw_coremap[irq + i] = cpu;
+		}
+	}
+}
+
+static int loongarch_eiointc_writeb(struct kvm_vcpu *vcpu,
+				struct loongarch_eiointc *s,
+				gpa_t addr, int len, const void *val)
+{
+	int index, irq, bits, ret = 0;
+	u8 data, old_data, cpu;
+	u8 coreisr, old_coreisr;
+	gpa_t offset;
+
+	data = *(u8 *)val;
+	offset = addr - EIOINTC_BASE;
+
+	switch (offset) {
+	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
+		index = (offset - EIOINTC_NODETYPE_START);
+		s->nodetype.reg_u8[index] = data;
+		break;
+	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
+		/*
+		 * ipmap cannot be set at runtime, can be set only at the beginning
+		 * of intr driver, need not update upper irq level
+		 */
+		index = (offset - EIOINTC_IPMAP_START);
+		s->ipmap.reg_u8[index] = data;
+		break;
+	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
+		index = (offset - EIOINTC_ENABLE_START);
+		old_data = s->enable.reg_u8[index];
+		s->enable.reg_u8[index] = data;
+		/*
+		 * 1: enable irq.
+		 * update irq when isr is set.
+		 */
+		data = s->enable.reg_u8[index] & ~old_data & s->isr.reg_u8[index];
+		eiointc_enable_irq(vcpu, s, index, data, 1);
+		/*
+		 * 0: disable irq.
+		 * update irq when isr is set.
+		 */
+		data = ~s->enable.reg_u8[index] & old_data & s->isr.reg_u8[index];
+		eiointc_enable_irq(vcpu, s, index, data, 0);
+		break;
+	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
+		/* do not emulate hw bounced irq routing */
+		index = offset - EIOINTC_BOUNCE_START;
+		s->bounce.reg_u8[index] = data;
+		break;
+	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EIOINTC_COREISR_START);
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
+			eiointc_update_irq(s, irq + index * bits, 0);
+			bitmap_clear((void *)&coreisr, irq, 1);
+			irq = find_first_bit((void *)&coreisr, bits);
+		}
+		break;
+	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
+		irq = offset - EIOINTC_COREMAP_START;
+		index = irq;
+		s->coremap.reg_u8[index] = data;
+		eiointc_update_sw_coremap(s, irq, (void *)&data,
+					sizeof(data), true);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
+				struct loongarch_eiointc *s,
+				gpa_t addr, int len, const void *val)
+{
+	int i, index, irq, bits, ret = 0;
+	u8 cpu;
+	u16 data, old_data;
+	u16 coreisr, old_coreisr;
+	gpa_t offset;
+
+	data = *(u16 *)val;
+	offset = addr - EIOINTC_BASE;
+
+	switch (offset) {
+	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
+		index = (offset - EIOINTC_NODETYPE_START) >> 1;
+		s->nodetype.reg_u16[index] = data;
+		break;
+	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
+		/*
+		 * ipmap cannot be set at runtime, can be set only at the beginning
+		 * of intr driver, need not update upper irq level
+		 */
+		index = (offset - EIOINTC_IPMAP_START) >> 1;
+		s->ipmap.reg_u16[index] = data;
+		break;
+	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
+		index = (offset - EIOINTC_ENABLE_START) >> 1;
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
+			eiointc_enable_irq(vcpu, s, index + i, mask, 1);
+		}
+		/*
+		 * 0: disable irq.
+		 * update irq when isr is set.
+		 */
+		data = ~s->enable.reg_u16[index] & old_data & s->isr.reg_u16[index];
+		for (i = 0; i < sizeof(data); i++) {
+			u8 mask = (data >> (i * 8)) & 0xff;
+
+			eiointc_enable_irq(vcpu, s, index, mask, 0);
+		}
+		break;
+	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
+		/* do not emulate hw bounced irq routing */
+		index = (offset - EIOINTC_BOUNCE_START) >> 1;
+		s->bounce.reg_u16[index] = data;
+		break;
+	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EIOINTC_COREISR_START) >> 1;
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
+			eiointc_update_irq(s, irq + index * bits, 0);
+			bitmap_clear((void *)&coreisr, irq, 1);
+			irq = find_first_bit((void *)&coreisr, bits);
+		}
+		break;
+	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
+		irq = offset - EIOINTC_COREMAP_START;
+		index = irq >> 1;
+
+		s->coremap.reg_u16[index] = data;
+		eiointc_update_sw_coremap(s, irq, (void *)&data,
+					sizeof(data), true);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
+				struct loongarch_eiointc *s,
+				gpa_t addr, int len, const void *val)
+{
+	int i, index, irq, bits, ret = 0;
+	u8 cpu;
+	u32 data, old_data;
+	u32 coreisr, old_coreisr;
+	gpa_t offset;
+
+	data = *(u32 *)val;
+	offset = addr - EIOINTC_BASE;
+
+	switch (offset) {
+	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
+		index = (offset - EIOINTC_NODETYPE_START) >> 2;
+		s->nodetype.reg_u32[index] = data;
+		break;
+	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
+		/*
+		 * ipmap cannot be set at runtime, can be set only at the beginning
+		 * of intr driver, need not update upper irq level
+		 */
+		index = (offset - EIOINTC_IPMAP_START) >> 2;
+		s->ipmap.reg_u32[index] = data;
+		break;
+	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
+		index = (offset - EIOINTC_ENABLE_START) >> 2;
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
+			eiointc_enable_irq(vcpu, s, index + i, mask, 1);
+		}
+		/*
+		 * 0: disable irq.
+		 * update irq when isr is set.
+		 */
+		data = ~s->enable.reg_u32[index] & old_data & s->isr.reg_u32[index];
+		for (i = 0; i < sizeof(data); i++) {
+			u8 mask = (data >> (i * 8)) & 0xff;
+
+			eiointc_enable_irq(vcpu, s, index, mask, 0);
+		}
+		break;
+	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
+		/* do not emulate hw bounced irq routing */
+		index = (offset - EIOINTC_BOUNCE_START) >> 2;
+		s->bounce.reg_u32[index] = data;
+		break;
+	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EIOINTC_COREISR_START) >> 2;
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
+			eiointc_update_irq(s, irq + index * bits, 0);
+			bitmap_clear((void *)&coreisr, irq, 1);
+			irq = find_first_bit((void *)&coreisr, bits);
+		}
+		break;
+	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
+		irq = offset - EIOINTC_COREMAP_START;
+		index = irq >> 2;
+
+		s->coremap.reg_u32[index] = data;
+		eiointc_update_sw_coremap(s, irq, (void *)&data,
+					sizeof(data), true);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
+				struct loongarch_eiointc *s,
+				gpa_t addr, int len, const void *val)
+{
+	int i, index, irq, bits, ret = 0;
+	u8 cpu;
+	u64 data, old_data;
+	u64 coreisr, old_coreisr;
+	gpa_t offset;
+
+	data = *(u64 *)val;
+	offset = addr - EIOINTC_BASE;
+
+	switch (offset) {
+	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
+		index = (offset - EIOINTC_NODETYPE_START) >> 3;
+		s->nodetype.reg_u64[index] = data;
+		break;
+	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
+		/*
+		 * ipmap cannot be set at runtime, can be set only at the beginning
+		 * of intr driver, need not update upper irq level
+		 */
+		index = (offset - EIOINTC_IPMAP_START) >> 3;
+		s->ipmap.reg_u64 = data;
+		break;
+	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
+		index = (offset - EIOINTC_ENABLE_START) >> 3;
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
+			eiointc_enable_irq(vcpu, s, index + i, mask, 1);
+		}
+		/*
+		 * 0: disable irq.
+		 * update irq when isr is set.
+		 */
+		data = ~s->enable.reg_u64[index] & old_data & s->isr.reg_u64[index];
+		for (i = 0; i < sizeof(data); i++) {
+			u8 mask = (data >> (i * 8)) & 0xff;
+
+			eiointc_enable_irq(vcpu, s, index, mask, 0);
+		}
+		break;
+	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
+		/* do not emulate hw bounced irq routing */
+		index = (offset - EIOINTC_BOUNCE_START) >> 3;
+		s->bounce.reg_u64[index] = data;
+		break;
+	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EIOINTC_COREISR_START) >> 3;
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
+			eiointc_update_irq(s, irq + index * bits, 0);
+			bitmap_clear((void *)&coreisr, irq, 1);
+			irq = find_first_bit((void *)&coreisr, bits);
+		}
+		break;
+	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
+		irq = offset - EIOINTC_COREMAP_START;
+		index = irq >> 3;
+
+		s->coremap.reg_u64[index] = data;
+		eiointc_update_sw_coremap(s, irq, (void *)&data,
+					sizeof(data), true);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
 static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, const void *val)
 {
-	return 0;
+	int ret;
+	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
+	unsigned long flags;
+
+	if (!eiointc) {
+		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	vcpu->kvm->stat.eiointc_write_exits++;
+	loongarch_ext_irq_lock(eiointc, flags);
+	switch (len) {
+	case 1:
+		ret = loongarch_eiointc_writeb(vcpu, eiointc, addr, len, val);
+		break;
+	case 2:
+		ret = loongarch_eiointc_writew(vcpu, eiointc, addr, len, val);
+		break;
+	case 4:
+		ret = loongarch_eiointc_writel(vcpu, eiointc, addr, len, val);
+		break;
+	case 8:
+		ret = loongarch_eiointc_writeq(vcpu, eiointc, addr, len, val);
+		break;
+	default:
+		WARN_ONCE(1, "%s: Abnormal address access:addr 0x%llx,size %d\n",
+						__func__, addr, len);
+	}
+	loongarch_ext_irq_unlock(eiointc, flags);
+	return ret;
+}
+
+static int loongarch_eiointc_readb(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u8 data = 0;
+
+	offset = addr - EIOINTC_BASE;
+	switch (offset) {
+	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
+		index = offset - EIOINTC_NODETYPE_START;
+		data = s->nodetype.reg_u8[index];
+		break;
+	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
+		index = offset - EIOINTC_IPMAP_START;
+		data = s->ipmap.reg_u8[index];
+		break;
+	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
+		index = offset - EIOINTC_ENABLE_START;
+		data = s->enable.reg_u8[index];
+		break;
+	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
+		index = offset - EIOINTC_BOUNCE_START;
+		data = s->bounce.reg_u8[index];
+		break;
+	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = offset - EIOINTC_COREISR_START;
+		data = s->coreisr.reg_u8[vcpu->vcpu_id][index];
+		break;
+	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
+		index = offset - EIOINTC_COREMAP_START;
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
+static int loongarch_eiointc_readw(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u16 data = 0;
+
+	offset = addr - EIOINTC_BASE;
+	switch (offset) {
+	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
+		index = (offset - EIOINTC_NODETYPE_START) >> 1;
+		data = s->nodetype.reg_u16[index];
+		break;
+	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
+		index = (offset - EIOINTC_IPMAP_START) >> 1;
+		data = s->ipmap.reg_u16[index];
+		break;
+	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
+		index = (offset - EIOINTC_ENABLE_START) >> 1;
+		data = s->enable.reg_u16[index];
+		break;
+	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
+		index = (offset - EIOINTC_BOUNCE_START) >> 1;
+		data = s->bounce.reg_u16[index];
+		break;
+	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EIOINTC_COREISR_START) >> 1;
+		data = s->coreisr.reg_u16[vcpu->vcpu_id][index];
+		break;
+	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
+		index = (offset - EIOINTC_COREMAP_START) >> 1;
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
+static int loongarch_eiointc_readl(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u32 data = 0;
+
+	offset = addr - EIOINTC_BASE;
+	switch (offset) {
+	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
+		index = (offset - EIOINTC_NODETYPE_START) >> 2;
+		data = s->nodetype.reg_u32[index];
+		break;
+	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
+		index = (offset - EIOINTC_IPMAP_START) >> 2;
+		data = s->ipmap.reg_u32[index];
+		break;
+	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
+		index = (offset - EIOINTC_ENABLE_START) >> 2;
+		data = s->enable.reg_u32[index];
+		break;
+	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
+		index = (offset - EIOINTC_BOUNCE_START) >> 2;
+		data = s->bounce.reg_u32[index];
+		break;
+	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EIOINTC_COREISR_START) >> 2;
+		data = s->coreisr.reg_u32[vcpu->vcpu_id][index];
+		break;
+	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
+		index = (offset - EIOINTC_COREMAP_START) >> 2;
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
+static int loongarch_eiointc_readq(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
+				gpa_t addr, int len, void *val)
+{
+	int index, ret = 0;
+	gpa_t offset;
+	u64 data = 0;
+
+	offset = addr - EIOINTC_BASE;
+	switch (offset) {
+	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
+		index = (offset - EIOINTC_NODETYPE_START) >> 3;
+		data = s->nodetype.reg_u64[index];
+		break;
+	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
+		index = (offset - EIOINTC_IPMAP_START) >> 3;
+		data = s->ipmap.reg_u64;
+		break;
+	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
+		index = (offset - EIOINTC_ENABLE_START) >> 3;
+		data = s->enable.reg_u64[index];
+		break;
+	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
+		index = (offset - EIOINTC_BOUNCE_START) >> 3;
+		data = s->bounce.reg_u64[index];
+		break;
+	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
+		/* length of accessing core isr is 8 bytes */
+		index = (offset - EIOINTC_COREISR_START) >> 3;
+		data = s->coreisr.reg_u64[vcpu->vcpu_id][index];
+		break;
+	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
+		index = (offset - EIOINTC_COREMAP_START) >> 3;
+		data = s->coremap.reg_u64[index];
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	*(u64 *)val = data;
+	return ret;
 }
 
 static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, void *val)
 {
-	return 0;
+	int ret;
+	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
+	unsigned long flags;
+
+	if (!eiointc) {
+		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	vcpu->kvm->stat.eiointc_read_exits++;
+	loongarch_ext_irq_lock(eiointc, flags);
+	switch (len) {
+	case 1:
+		ret = loongarch_eiointc_readb(vcpu, eiointc, addr, len, val);
+		break;
+	case 2:
+		ret = loongarch_eiointc_readw(vcpu, eiointc, addr, len, val);
+		break;
+	case 4:
+		ret = loongarch_eiointc_readl(vcpu, eiointc, addr, len, val);
+		break;
+	case 8:
+		ret = loongarch_eiointc_readq(vcpu, eiointc, addr, len, val);
+		break;
+	default:
+		WARN_ONCE(1, "%s: Abnormal address access:addr 0x%llx,size %d\n",
+						__func__, addr, len);
+	}
+	loongarch_ext_irq_unlock(eiointc, flags);
+	return ret;
 }
 
 static const struct kvm_io_device_ops kvm_eiointc_ops = {
@@ -30,6 +730,28 @@ static int kvm_eiointc_virt_read(struct kvm_vcpu *vcpu,
 				struct kvm_io_device *dev,
 				gpa_t addr, int len, void *val)
 {
+	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
+	unsigned long flags;
+	u32 *data = val;
+
+	if (!eiointc) {
+		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	addr -= EIOINTC_VIRT_BASE;
+	loongarch_ext_irq_lock(eiointc, flags);
+	switch (addr) {
+	case EIOINTC_VIRT_FEATURES:
+		*data = eiointc->features;
+		break;
+	case EIOINTC_VIRT_CONFIG:
+		*data = eiointc->status;
+		break;
+	default:
+		break;
+	}
+	loongarch_ext_irq_unlock(eiointc, flags);
 	return 0;
 }
 
@@ -37,7 +759,37 @@ static int kvm_eiointc_virt_write(struct kvm_vcpu *vcpu,
 				struct kvm_io_device *dev,
 				gpa_t addr, int len, const void *val)
 {
-	return 0;
+	int ret = 0;
+	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
+	unsigned long flags;
+	u32 value = *(u32 *)val;
+
+	if (!eiointc) {
+		kvm_err("%s: eiointc irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	addr -= EIOINTC_VIRT_BASE;
+	loongarch_ext_irq_lock(eiointc, flags);
+	switch (addr) {
+	case EIOINTC_VIRT_FEATURES:
+		ret = -EPERM;
+		break;
+	case EIOINTC_VIRT_CONFIG:
+		/*
+		 * eiointc features can only be set at disabled status
+		 */
+		if ((eiointc->status & BIT(EIOINTC_ENABLE)) && value) {
+			ret = -EPERM;
+			break;
+		}
+		eiointc->status = value & eiointc->features;
+		break;
+	default:
+		break;
+	}
+	loongarch_ext_irq_unlock(eiointc, flags);
+	return ret;
 }
 
 static const struct kvm_io_device_ops kvm_eiointc_virt_ops = {
@@ -95,7 +847,7 @@ static int kvm_eiointc_create(struct kvm_device *dev, u32 type)
 	kvm_iodevice_init(device, &kvm_eiointc_ops);
 	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS,
-			EXTIOI_BASE, EXTIOI_SIZE, device);
+			EIOINTC_BASE, EIOINTC_SIZE, device);
 	mutex_unlock(&kvm->slots_lock);
 	if (ret < 0) {
 		kfree(s);
@@ -105,7 +857,7 @@ static int kvm_eiointc_create(struct kvm_device *dev, u32 type)
 	device1 = &s->device_extern;
 	kvm_iodevice_init(device1, &kvm_eiointc_virt_ops);
 	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS,
-			EXTIOI_VIRT_BASE, EXTIOI_VIRT_SIZE, device1);
+			EIOINTC_VIRT_BASE, EIOINTC_VIRT_SIZE, device1);
 	if (ret < 0) {
 		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device);
 		kfree(s);
-- 
2.39.1


