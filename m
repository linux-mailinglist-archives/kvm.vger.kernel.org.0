Return-Path: <kvm+bounces-60010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDCFBD8AC7
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 12:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE6043A89CE
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 10:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAF52FD7BC;
	Tue, 14 Oct 2025 10:04:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 696B12E7178;
	Tue, 14 Oct 2025 10:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760436246; cv=none; b=FCHVMjhAU28FSiVAQ0ihdfgfWJYKwTwnREsowTdrg3y1fLce2u5o5uFg84qvdKqfTGRG7FrSnBiFTYo+B62bm8k/CUX6PESNKZ10X9aUx1MBNkbI+GLt93jHDQITcU1BWmHBe9JB3SeU3N7P6SFG7hsyRAMOHGRr/U0CNXzDtF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760436246; c=relaxed/simple;
	bh=yux0N1wsHRgrMVj6ghdITAuELHZsqQtYUNoXNs4NIPA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=czeTJB6x26WZukSiIwjG56PzzzN9NXDKLbjr3VpMi+HEBtJb2evOuiy/cUNhz7S1NWQpOaxJtuvqu3G14nUi+B2f1jL11tSPOuPeoUI7PVsFCjCGt9U66G6i8rFtnitu4TnyitVi4YZTL7wH5e7t64Pe6aU+gB1E+1Dg16uSUZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cxrr8QIO5oEfgVAA--.46018S3;
	Tue, 14 Oct 2025 18:04:00 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxT+YPIO5oAWLhAA--.35826S2;
	Tue, 14 Oct 2025 18:03:59 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Use 64-bit register definition with eiointc
Date: Tue, 14 Oct 2025 18:03:59 +0800
Message-Id: <20251014100359.1159754-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxT+YPIO5oAWLhAA--.35826S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With in-kernel emulated eiointc driver, hardware register can be
accessed by different size, there is reg_u8/reg_u16/reg_u32/reg_u64
union type with eiointc register.

Here use 64-bit type with register definition and remove union type
since most registers are accessed with 64-bit method. And it makes
eiointc emulated driver simpler.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_eiointc.h | 55 +++------------
 arch/loongarch/kvm/intc/eiointc.c        | 89 +++++++++++++-----------
 2 files changed, 57 insertions(+), 87 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch/include/asm/kvm_eiointc.h
index a3a40aba8acf..8b7a2fa3f7f8 100644
--- a/arch/loongarch/include/asm/kvm_eiointc.h
+++ b/arch/loongarch/include/asm/kvm_eiointc.h
@@ -10,10 +10,7 @@
 
 #define EIOINTC_IRQS			256
 #define EIOINTC_ROUTE_MAX_VCPUS		256
-#define EIOINTC_IRQS_U8_NUMS		(EIOINTC_IRQS / 8)
-#define EIOINTC_IRQS_U16_NUMS		(EIOINTC_IRQS_U8_NUMS / 2)
-#define EIOINTC_IRQS_U32_NUMS		(EIOINTC_IRQS_U8_NUMS / 4)
-#define EIOINTC_IRQS_U64_NUMS		(EIOINTC_IRQS_U8_NUMS / 8)
+#define EIOINTC_IRQS_U64_NUMS		(EIOINTC_IRQS / 64)
 /* map to ipnum per 32 irqs */
 #define EIOINTC_IRQS_NODETYPE_COUNT	16
 
@@ -64,54 +61,18 @@ struct loongarch_eiointc {
 	uint32_t status;
 
 	/* hardware state */
-	union nodetype {
-		u64 reg_u64[EIOINTC_IRQS_NODETYPE_COUNT / 4];
-		u32 reg_u32[EIOINTC_IRQS_NODETYPE_COUNT / 2];
-		u16 reg_u16[EIOINTC_IRQS_NODETYPE_COUNT];
-		u8 reg_u8[EIOINTC_IRQS_NODETYPE_COUNT * 2];
-	} nodetype;
+	u64 nodetype[EIOINTC_IRQS_NODETYPE_COUNT / 4];
 
 	/* one bit shows the state of one irq */
-	union bounce {
-		u64 reg_u64[EIOINTC_IRQS_U64_NUMS];
-		u32 reg_u32[EIOINTC_IRQS_U32_NUMS];
-		u16 reg_u16[EIOINTC_IRQS_U16_NUMS];
-		u8 reg_u8[EIOINTC_IRQS_U8_NUMS];
-	} bounce;
-
-	union isr {
-		u64 reg_u64[EIOINTC_IRQS_U64_NUMS];
-		u32 reg_u32[EIOINTC_IRQS_U32_NUMS];
-		u16 reg_u16[EIOINTC_IRQS_U16_NUMS];
-		u8 reg_u8[EIOINTC_IRQS_U8_NUMS];
-	} isr;
-	union coreisr {
-		u64 reg_u64[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U64_NUMS];
-		u32 reg_u32[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U32_NUMS];
-		u16 reg_u16[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U16_NUMS];
-		u8 reg_u8[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U8_NUMS];
-	} coreisr;
-	union enable {
-		u64 reg_u64[EIOINTC_IRQS_U64_NUMS];
-		u32 reg_u32[EIOINTC_IRQS_U32_NUMS];
-		u16 reg_u16[EIOINTC_IRQS_U16_NUMS];
-		u8 reg_u8[EIOINTC_IRQS_U8_NUMS];
-	} enable;
+	u64 bounce[EIOINTC_IRQS_U64_NUMS];
+	u64 isr[EIOINTC_IRQS_U64_NUMS];
+	u64 coreisr[EIOINTC_ROUTE_MAX_VCPUS][EIOINTC_IRQS_U64_NUMS];
+	u64 enable[EIOINTC_IRQS_U64_NUMS];
 
 	/* use one byte to config ipmap for 32 irqs at once */
-	union ipmap {
-		u64 reg_u64;
-		u32 reg_u32[EIOINTC_IRQS_U32_NUMS / 4];
-		u16 reg_u16[EIOINTC_IRQS_U16_NUMS / 4];
-		u8 reg_u8[EIOINTC_IRQS_U8_NUMS / 4];
-	} ipmap;
+	u64 ipmap;
 	/* use one byte to config coremap for one irq */
-	union coremap {
-		u64 reg_u64[EIOINTC_IRQS / 8];
-		u32 reg_u32[EIOINTC_IRQS / 4];
-		u16 reg_u16[EIOINTC_IRQS / 2];
-		u8 reg_u8[EIOINTC_IRQS];
-	} coremap;
+	u64 coremap[EIOINTC_IRQS / 8];
 
 	DECLARE_BITMAP(sw_coreisr[EIOINTC_ROUTE_MAX_VCPUS][LOONGSON_IP_NUM], EIOINTC_IRQS);
 	uint8_t  sw_coremap[EIOINTC_IRQS];
diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index c32333695381..eecdc8f4a565 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -11,21 +11,23 @@ static void eiointc_set_sw_coreisr(struct loongarch_eiointc *s)
 {
 	int ipnum, cpu, cpuid, irq;
 	struct kvm_vcpu *vcpu;
+	u8 *coremap;
 
+	coremap = (u8 *)s->coremap;
 	for (irq = 0; irq < EIOINTC_IRQS; irq++) {
-		ipnum = s->ipmap.reg_u8[irq / 32];
+		ipnum = (s->ipmap >> (irq / 32 * 8)) & 0xFF;
 		if (!(s->status & BIT(EIOINTC_ENABLE_INT_ENCODE))) {
 			ipnum = count_trailing_zeros(ipnum);
 			ipnum = (ipnum >= 0 && ipnum < 4) ? ipnum : 0;
 		}
 
-		cpuid = s->coremap.reg_u8[irq];
+		cpuid = coremap[irq];
 		vcpu = kvm_get_vcpu_by_cpuid(s->kvm, cpuid);
 		if (!vcpu)
 			continue;
 
 		cpu = vcpu->vcpu_id;
-		if (test_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]))
+		if (test_bit(irq, (unsigned long *)s->coreisr[cpu]))
 			__set_bit(irq, s->sw_coreisr[cpu][ipnum]);
 		else
 			__clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
@@ -38,7 +40,7 @@ static void eiointc_update_irq(struct loongarch_eiointc *s, int irq, int level)
 	struct kvm_vcpu *vcpu;
 	struct kvm_interrupt vcpu_irq;
 
-	ipnum = s->ipmap.reg_u8[irq / 32];
+	ipnum = (s->ipmap >> (irq / 32 * 8)) & 0xFF;
 	if (!(s->status & BIT(EIOINTC_ENABLE_INT_ENCODE))) {
 		ipnum = count_trailing_zeros(ipnum);
 		ipnum = (ipnum >= 0 && ipnum < 4) ? ipnum : 0;
@@ -53,13 +55,13 @@ static void eiointc_update_irq(struct loongarch_eiointc *s, int irq, int level)
 
 	if (level) {
 		/* if not enable return false */
-		if (!test_bit(irq, (unsigned long *)s->enable.reg_u32))
+		if (!test_bit(irq, (unsigned long *)s->enable))
 			return;
-		__set_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]);
+		__set_bit(irq, (unsigned long *)s->coreisr[cpu]);
 		found = find_first_bit(s->sw_coreisr[cpu][ipnum], EIOINTC_IRQS);
 		__set_bit(irq, s->sw_coreisr[cpu][ipnum]);
 	} else {
-		__clear_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]);
+		__clear_bit(irq, (unsigned long *)s->coreisr[cpu]);
 		__clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
 		found = find_first_bit(s->sw_coreisr[cpu][ipnum], EIOINTC_IRQS);
 	}
@@ -94,7 +96,7 @@ static inline void eiointc_update_sw_coremap(struct loongarch_eiointc *s,
 		if (s->sw_coremap[irq + i] == cpu)
 			continue;
 
-		if (notify && test_bit(irq + i, (unsigned long *)s->isr.reg_u8)) {
+		if (notify && test_bit(irq + i, (unsigned long *)s->isr)) {
 			/* lower irq at old cpu and raise irq at new cpu */
 			eiointc_update_irq(s, irq + i, 0);
 			s->sw_coremap[irq + i] = cpu;
@@ -108,7 +110,7 @@ static inline void eiointc_update_sw_coremap(struct loongarch_eiointc *s,
 void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level)
 {
 	unsigned long flags;
-	unsigned long *isr = (unsigned long *)s->isr.reg_u8;
+	unsigned long *isr = (unsigned long *)s->isr;
 
 	spin_lock_irqsave(&s->lock, flags);
 	level ? __set_bit(irq, isr) : __clear_bit(irq, isr);
@@ -127,27 +129,27 @@ static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarch_eioint
 	switch (offset) {
 	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
 		index = (offset - EIOINTC_NODETYPE_START) >> 3;
-		data = s->nodetype.reg_u64[index];
+		data = s->nodetype[index];
 		break;
 	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
 		index = (offset - EIOINTC_IPMAP_START) >> 3;
-		data = s->ipmap.reg_u64;
+		data = s->ipmap;
 		break;
 	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
 		index = (offset - EIOINTC_ENABLE_START) >> 3;
-		data = s->enable.reg_u64[index];
+		data = s->enable[index];
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
 		index = (offset - EIOINTC_BOUNCE_START) >> 3;
-		data = s->bounce.reg_u64[index];
+		data = s->bounce[index];
 		break;
 	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
 		index = (offset - EIOINTC_COREISR_START) >> 3;
-		data = s->coreisr.reg_u64[vcpu->vcpu_id][index];
+		data = s->coreisr[vcpu->vcpu_id][index];
 		break;
 	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
 		index = (offset - EIOINTC_COREMAP_START) >> 3;
-		data = s->coremap.reg_u64[index];
+		data = s->coremap[index];
 		break;
 	default:
 		ret = -EINVAL;
@@ -223,26 +225,26 @@ static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 	switch (offset) {
 	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
 		index = (offset - EIOINTC_NODETYPE_START) >> 3;
-		old = s->nodetype.reg_u64[index];
-		s->nodetype.reg_u64[index] = (old & ~mask) | data;
+		old = s->nodetype[index];
+		s->nodetype[index] = (old & ~mask) | data;
 		break;
 	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
 		/*
 		 * ipmap cannot be set at runtime, can be set only at the beginning
 		 * of irqchip driver, need not update upper irq level
 		 */
-		old = s->ipmap.reg_u64;
-		s->ipmap.reg_u64 = (old & ~mask) | data;
+		old = s->ipmap;
+		s->ipmap = (old & ~mask) | data;
 		break;
 	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
 		index = (offset - EIOINTC_ENABLE_START) >> 3;
-		old = s->enable.reg_u64[index];
-		s->enable.reg_u64[index] = (old & ~mask) | data;
+		old = s->enable[index];
+		s->enable[index] = (old & ~mask) | data;
 		/*
 		 * 1: enable irq.
 		 * update irq when isr is set.
 		 */
-		data = s->enable.reg_u64[index] & ~old & s->isr.reg_u64[index];
+		data = s->enable[index] & ~old & s->isr[index];
 		while (data) {
 			irq = __ffs(data);
 			eiointc_update_irq(s, irq + index * 64, 1);
@@ -252,7 +254,7 @@ static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 		 * 0: disable irq.
 		 * update irq when isr is set.
 		 */
-		data = ~s->enable.reg_u64[index] & old & s->isr.reg_u64[index];
+		data = ~s->enable[index] & old & s->isr[index];
 		while (data) {
 			irq = __ffs(data);
 			eiointc_update_irq(s, irq + index * 64, 0);
@@ -262,16 +264,16 @@ static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
 		/* do not emulate hw bounced irq routing */
 		index = (offset - EIOINTC_BOUNCE_START) >> 3;
-		old = s->bounce.reg_u64[index];
-		s->bounce.reg_u64[index] = (old & ~mask) | data;
+		old = s->bounce[index];
+		s->bounce[index] = (old & ~mask) | data;
 		break;
 	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
 		index = (offset - EIOINTC_COREISR_START) >> 3;
 		/* use attrs to get current cpu index */
 		cpu = vcpu->vcpu_id;
-		old = s->coreisr.reg_u64[cpu][index];
+		old = s->coreisr[cpu][index];
 		/* write 1 to clear interrupt */
-		s->coreisr.reg_u64[cpu][index] = old & ~data;
+		s->coreisr[cpu][index] = old & ~data;
 		data &= old;
 		while (data) {
 			irq = __ffs(data);
@@ -281,9 +283,9 @@ static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 		break;
 	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
 		index = (offset - EIOINTC_COREMAP_START) >> 3;
-		old = s->coremap.reg_u64[index];
-		s->coremap.reg_u64[index] = (old & ~mask) | data;
-		data = s->coremap.reg_u64[index];
+		old = s->coremap[index];
+		s->coremap[index] = (old & ~mask) | data;
+		data = s->coremap[index];
 		eiointc_update_sw_coremap(s, index * 8, data, sizeof(data), true);
 		break;
 	default:
@@ -451,10 +453,10 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
 		break;
 	case KVM_DEV_LOONGARCH_EXTIOI_CTRL_LOAD_FINISHED:
 		eiointc_set_sw_coreisr(s);
-		for (i = 0; i < (EIOINTC_IRQS / 4); i++) {
-			start_irq = i * 4;
+		for (i = 0; i < (EIOINTC_IRQS / 8); i++) {
+			start_irq = i * 8;
 			eiointc_update_sw_coremap(s, start_irq,
-					s->coremap.reg_u32[i], sizeof(u32), false);
+					s->coremap[i], sizeof(u64), false);
 		}
 		break;
 	default:
@@ -481,34 +483,41 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
 	switch (addr) {
 	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
 		offset = (addr - EIOINTC_NODETYPE_START) / 4;
-		p = &s->nodetype.reg_u32[offset];
+		p = s->nodetype;
+		p += offset * 4;
 		break;
 	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
 		offset = (addr - EIOINTC_IPMAP_START) / 4;
-		p = &s->ipmap.reg_u32[offset];
+		p = &s->ipmap;
+		p += offset * 4;
 		break;
 	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
 		offset = (addr - EIOINTC_ENABLE_START) / 4;
-		p = &s->enable.reg_u32[offset];
+		p = s->enable;
+		p += offset * 4;
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
 		offset = (addr - EIOINTC_BOUNCE_START) / 4;
-		p = &s->bounce.reg_u32[offset];
+		p = s->bounce;
+		p += offset * 4;
 		break;
 	case EIOINTC_ISR_START ... EIOINTC_ISR_END:
 		offset = (addr - EIOINTC_ISR_START) / 4;
-		p = &s->isr.reg_u32[offset];
+		p = s->isr;
+		p += offset * 4;
 		break;
 	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
 		if (cpu >= s->num_cpu)
 			return -EINVAL;
 
 		offset = (addr - EIOINTC_COREISR_START) / 4;
-		p = &s->coreisr.reg_u32[cpu][offset];
+		p = s->coreisr[cpu];
+		p += offset * 4;
 		break;
 	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
 		offset = (addr - EIOINTC_COREMAP_START) / 4;
-		p = &s->coremap.reg_u32[offset];
+		p = s->coremap;
+		p += offset * 4;
 		break;
 	default:
 		kvm_err("%s: unknown eiointc register, addr = %d\n", __func__, addr);

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.39.3


