Return-Path: <kvm+bounces-51892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB48AFE1E5
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97DBA1C2718E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4949274FE3;
	Wed,  9 Jul 2025 08:04:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B5B22FDE8;
	Wed,  9 Jul 2025 08:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752048268; cv=none; b=IE47amA5ueoQ8+HH90vtsi1LauPfJSFXDqzeme9vUPSdoM7WuPyW+ixVuCS29X5q0dgYycrfu6Neoe3yvv8IkfzthFhIMML710mFE5fDZKvdPPwpC0tRFQxH6nq/lQOFo0n5LYP7QUMqqrmTNgAxCt7MwUBuLgVed4WwmF0nlcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752048268; c=relaxed/simple;
	bh=yZthooZwNqYlz9nExFCfhZkWUW2cCWFi8h7e4H9KpH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ks67VfxdB7idjmX/ZcfQzw39m7HYskdJrh0VlP4UHeyD6jrbSiMxRt1RnuOXZRDr0wBtbeOgwhhpvVni1OdGmEZvUN85jVy1GpTU3hsETq9bHQFIhtCIo+Kl/36PFqC6ZxVqJWAQR/XosGU4bXtcWUqwXL98+39fn6/mTGa9UeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxnmsdIm5oaSklAQ--.38658S3;
	Wed, 09 Jul 2025 16:02:37 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQZIm5oS6cPAA--.24964S10;
	Wed, 09 Jul 2025 16:02:37 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 8/8] LoongArch: KVM: Add generic function loongarch_eiointc_write()
Date: Wed,  9 Jul 2025 16:02:33 +0800
Message-Id: <20250709080233.3948503-9-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250709080233.3948503-1-maobibo@loongson.cn>
References: <20250709080233.3948503-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxpeQZIm5oS6cPAA--.24964S10
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With all eiointc iocsr register write operation with 1/2/4/8 bytes
size, generic function loongarch_eiointc_write() is used here. And
function loongarch_eiointc_writeb(), loongarch_eiointc_writew(),
loongarch_eiointc_writel() are removed.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 329 ++++--------------------------
 1 file changed, 35 insertions(+), 294 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index edcf87055b3c..cac59b10fa79 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -111,25 +111,6 @@ void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level)
 	spin_unlock_irqrestore(&s->lock, flags);
 }
 
-static inline void eiointc_enable_irq(struct kvm_vcpu *vcpu,
-		struct loongarch_eiointc *s, int index, u8 mask, int level)
-{
-	u8 val;
-	int irq;
-
-	val = mask & s->isr.reg_u8[index];
-	irq = ffs(val);
-	while (irq != 0) {
-		/*
-		 * enable bit change from 0 to 1,
-		 * need to update irq by pending bits
-		 */
-		eiointc_update_irq(s, irq - 1 + index * 8, level);
-		val &= ~BIT(irq - 1);
-		irq = ffs(val);
-	}
-}
-
 static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
 				gpa_t addr, unsigned long *val)
 {
@@ -218,288 +199,42 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int loongarch_eiointc_writeb(struct kvm_vcpu *vcpu,
-				struct loongarch_eiointc *s,
-				gpa_t addr, const void *val)
-{
-	int index, irq, bits, ret = 0;
-	u8 cpu;
-	u8 data, old_data;
-	u8 coreisr, old_coreisr;
-	gpa_t offset;
-
-	data = *(u8 *)val;
-	offset = addr - EIOINTC_BASE;
-
-	switch (offset) {
-	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
-		index = (offset - EIOINTC_NODETYPE_START);
-		s->nodetype.reg_u8[index] = data;
-		break;
-	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
-		/*
-		 * ipmap cannot be set at runtime, can be set only at the beginning
-		 * of irqchip driver, need not update upper irq level
-		 */
-		index = (offset - EIOINTC_IPMAP_START);
-		s->ipmap.reg_u8[index] = data;
-		break;
-	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
-		index = (offset - EIOINTC_ENABLE_START);
-		old_data = s->enable.reg_u8[index];
-		s->enable.reg_u8[index] = data;
-		/*
-		 * 1: enable irq.
-		 * update irq when isr is set.
-		 */
-		data = s->enable.reg_u8[index] & ~old_data & s->isr.reg_u8[index];
-		eiointc_enable_irq(vcpu, s, index, data, 1);
-		/*
-		 * 0: disable irq.
-		 * update irq when isr is set.
-		 */
-		data = ~s->enable.reg_u8[index] & old_data & s->isr.reg_u8[index];
-		eiointc_enable_irq(vcpu, s, index, data, 0);
-		break;
-	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
-		/* do not emulate hw bounced irq routing */
-		index = offset - EIOINTC_BOUNCE_START;
-		s->bounce.reg_u8[index] = data;
-		break;
-	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
-		index = (offset - EIOINTC_COREISR_START);
-		/* use attrs to get current cpu index */
-		cpu = vcpu->vcpu_id;
-		coreisr = data;
-		old_coreisr = s->coreisr.reg_u8[cpu][index];
-		/* write 1 to clear interrupt */
-		s->coreisr.reg_u8[cpu][index] = old_coreisr & ~coreisr;
-		coreisr &= old_coreisr;
-		bits = sizeof(data) * 8;
-		irq = find_first_bit((void *)&coreisr, bits);
-		while (irq < bits) {
-			eiointc_update_irq(s, irq + index * bits, 0);
-			bitmap_clear((void *)&coreisr, irq, 1);
-			irq = find_first_bit((void *)&coreisr, bits);
-		}
-		break;
-	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-		irq = offset - EIOINTC_COREMAP_START;
-		index = irq;
-		s->coremap.reg_u8[index] = data;
-		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
-static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
-				struct loongarch_eiointc *s,
-				gpa_t addr, const void *val)
-{
-	int i, index, irq, bits, ret = 0;
-	u8 cpu;
-	u16 data, old_data;
-	u16 coreisr, old_coreisr;
-	gpa_t offset;
-
-	data = *(u16 *)val;
-	offset = addr - EIOINTC_BASE;
-
-	switch (offset) {
-	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
-		index = (offset - EIOINTC_NODETYPE_START) >> 1;
-		s->nodetype.reg_u16[index] = data;
-		break;
-	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
-		/*
-		 * ipmap cannot be set at runtime, can be set only at the beginning
-		 * of irqchip driver, need not update upper irq level
-		 */
-		index = (offset - EIOINTC_IPMAP_START) >> 1;
-		s->ipmap.reg_u16[index] = data;
-		break;
-	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
-		index = (offset - EIOINTC_ENABLE_START) >> 1;
-		old_data = s->enable.reg_u16[index];
-		s->enable.reg_u16[index] = data;
-		/*
-		 * 1: enable irq.
-		 * update irq when isr is set.
-		 */
-		data = s->enable.reg_u16[index] & ~old_data & s->isr.reg_u16[index];
-		for (i = 0; i < sizeof(data); i++) {
-			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index * 2 + i, mask, 1);
-		}
-		/*
-		 * 0: disable irq.
-		 * update irq when isr is set.
-		 */
-		data = ~s->enable.reg_u16[index] & old_data & s->isr.reg_u16[index];
-		for (i = 0; i < sizeof(data); i++) {
-			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index * 2 + i, mask, 0);
-		}
-		break;
-	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
-		/* do not emulate hw bounced irq routing */
-		index = (offset - EIOINTC_BOUNCE_START) >> 1;
-		s->bounce.reg_u16[index] = data;
-		break;
-	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
-		index = (offset - EIOINTC_COREISR_START) >> 1;
-		/* use attrs to get current cpu index */
-		cpu = vcpu->vcpu_id;
-		coreisr = data;
-		old_coreisr = s->coreisr.reg_u16[cpu][index];
-		/* write 1 to clear interrupt */
-		s->coreisr.reg_u16[cpu][index] = old_coreisr & ~coreisr;
-		coreisr &= old_coreisr;
-		bits = sizeof(data) * 8;
-		irq = find_first_bit((void *)&coreisr, bits);
-		while (irq < bits) {
-			eiointc_update_irq(s, irq + index * bits, 0);
-			bitmap_clear((void *)&coreisr, irq, 1);
-			irq = find_first_bit((void *)&coreisr, bits);
-		}
-		break;
-	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-		irq = offset - EIOINTC_COREMAP_START;
-		index = irq >> 1;
-		s->coremap.reg_u16[index] = data;
-		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
-static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
-				struct loongarch_eiointc *s,
-				gpa_t addr, const void *val)
-{
-	int i, index, irq, bits, ret = 0;
-	u8 cpu;
-	u32 data, old_data;
-	u32 coreisr, old_coreisr;
-	gpa_t offset;
-
-	data = *(u32 *)val;
-	offset = addr - EIOINTC_BASE;
-
-	switch (offset) {
-	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
-		index = (offset - EIOINTC_NODETYPE_START) >> 2;
-		s->nodetype.reg_u32[index] = data;
-		break;
-	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
-		/*
-		 * ipmap cannot be set at runtime, can be set only at the beginning
-		 * of irqchip driver, need not update upper irq level
-		 */
-		index = (offset - EIOINTC_IPMAP_START) >> 2;
-		s->ipmap.reg_u32[index] = data;
-		break;
-	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
-		index = (offset - EIOINTC_ENABLE_START) >> 2;
-		old_data = s->enable.reg_u32[index];
-		s->enable.reg_u32[index] = data;
-		/*
-		 * 1: enable irq.
-		 * update irq when isr is set.
-		 */
-		data = s->enable.reg_u32[index] & ~old_data & s->isr.reg_u32[index];
-		for (i = 0; i < sizeof(data); i++) {
-			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index * 4 + i, mask, 1);
-		}
-		/*
-		 * 0: disable irq.
-		 * update irq when isr is set.
-		 */
-		data = ~s->enable.reg_u32[index] & old_data & s->isr.reg_u32[index];
-		for (i = 0; i < sizeof(data); i++) {
-			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index * 4 + i, mask, 0);
-		}
-		break;
-	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
-		/* do not emulate hw bounced irq routing */
-		index = (offset - EIOINTC_BOUNCE_START) >> 2;
-		s->bounce.reg_u32[index] = data;
-		break;
-	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
-		index = (offset - EIOINTC_COREISR_START) >> 2;
-		/* use attrs to get current cpu index */
-		cpu = vcpu->vcpu_id;
-		coreisr = data;
-		old_coreisr = s->coreisr.reg_u32[cpu][index];
-		/* write 1 to clear interrupt */
-		s->coreisr.reg_u32[cpu][index] = old_coreisr & ~coreisr;
-		coreisr &= old_coreisr;
-		bits = sizeof(data) * 8;
-		irq = find_first_bit((void *)&coreisr, bits);
-		while (irq < bits) {
-			eiointc_update_irq(s, irq + index * bits, 0);
-			bitmap_clear((void *)&coreisr, irq, 1);
-			irq = find_first_bit((void *)&coreisr, bits);
-		}
-		break;
-	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-		irq = offset - EIOINTC_COREMAP_START;
-		index = irq >> 2;
-		s->coremap.reg_u32[index] = data;
-		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
-static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
+static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, const void *val)
+				gpa_t addr, u64 value, u64 field_mask)
 {
-	int index, irq, ret = 0;
+	int index, irq, offset, ret = 0;
 	u8 cpu;
-	u64 data, old_data;
+	u64 data, old, mask;
 
-	data = *(u64 *)val;
-	addr -= EIOINTC_BASE;
+	offset = addr & 7;
+	mask = field_mask << (offset * 8);
+	data = (value & field_mask) << (offset * 8);
+	addr -= EIOINTC_BASE + offset;
 
 	switch (addr) {
 	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
 		index = (addr - EIOINTC_NODETYPE_START) >> 3;
-		s->nodetype.reg_u64[index] = data;
+		old = s->nodetype.reg_u64[index];
+		s->nodetype.reg_u64[index] = (old & ~mask) | data;
 		break;
 	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
 		/*
 		 * ipmap cannot be set at runtime, can be set only at the beginning
 		 * of irqchip driver, need not update upper irq level
 		 */
-		index = (addr - EIOINTC_IPMAP_START) >> 3;
-		s->ipmap.reg_u64 = data;
+		old = s->ipmap.reg_u64;
+		s->ipmap.reg_u64 = (old & ~mask) | data;
 		break;
 	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
 		index = (addr - EIOINTC_ENABLE_START) >> 3;
-		old_data = s->enable.reg_u64[index];
-		s->enable.reg_u64[index] = data;
+		old = s->enable.reg_u64[index];
+		s->enable.reg_u64[index] = (old & ~mask) | data;
 		/*
 		 * 1: enable irq.
 		 * update irq when isr is set.
 		 */
-		data = s->enable.reg_u64[index] & ~old_data & s->isr.reg_u64[index];
+		data = s->enable.reg_u64[index] & ~old & s->isr.reg_u64[index];
 		while (data) {
 			irq = __ffs(data);
 			eiointc_update_irq(s, irq + index * 64, 1);
@@ -509,7 +244,7 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		 * 0: disable irq.
 		 * update irq when isr is set.
 		 */
-		data = ~s->enable.reg_u64[index] & old_data & s->isr.reg_u64[index];
+		data = ~s->enable.reg_u64[index] & old & s->isr.reg_u64[index];
 		while (data) {
 			irq = __ffs(data);
 			eiointc_update_irq(s, irq + index * 64, 0);
@@ -519,16 +254,17 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
 		/* do not emulate hw bounced irq routing */
 		index = (addr - EIOINTC_BOUNCE_START) >> 3;
-		s->bounce.reg_u64[index] = data;
+		old = s->bounce.reg_u64[index];
+		s->bounce.reg_u64[index] = (old & ~mask) | data;
 		break;
 	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
 		index = (addr - EIOINTC_COREISR_START) >> 3;
 		/* use attrs to get current cpu index */
 		cpu = vcpu->vcpu_id;
-		old_data = s->coreisr.reg_u64[cpu][index];
+		old = s->coreisr.reg_u64[cpu][index];
 		/* write 1 to clear interrupt */
-		s->coreisr.reg_u64[cpu][index] = old_data & ~data;
-		data &= old_data;
+		s->coreisr.reg_u64[cpu][index] = old & ~data;
+		data &= old;
 		while (data) {
 			irq = __ffs(data);
 			eiointc_update_irq(s, irq + index * 64, 0);
@@ -536,10 +272,11 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-		irq = addr - EIOINTC_COREMAP_START;
-		index = irq >> 3;
-		s->coremap.reg_u64[index] = data;
-		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
+		index = (addr - EIOINTC_COREMAP_START) >> 3;
+		old = s->coremap.reg_u64[index];
+		s->coremap.reg_u64[index] = (old & ~mask) | data;
+		data = s->coremap.reg_u64[index];
+		eiointc_update_sw_coremap(s, index * 8, data, sizeof(data), true);
 		break;
 	default:
 		ret = -EINVAL;
@@ -554,7 +291,7 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 			gpa_t addr, int len, const void *val)
 {
 	int ret = -EINVAL;
-	unsigned long flags;
+	unsigned long flags, value;
 	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
 
 	if (!eiointc) {
@@ -571,16 +308,20 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 	spin_lock_irqsave(&eiointc->lock, flags);
 	switch (len) {
 	case 1:
-		ret = loongarch_eiointc_writeb(vcpu, eiointc, addr, val);
+		value = *(unsigned char *)val;
+		ret = loongarch_eiointc_write(vcpu, eiointc, addr, value, 0xFF);
 		break;
 	case 2:
-		ret = loongarch_eiointc_writew(vcpu, eiointc, addr, val);
+		value = *(unsigned short *)val;
+		ret = loongarch_eiointc_write(vcpu, eiointc, addr, value, USHRT_MAX);
 		break;
 	case 4:
-		ret = loongarch_eiointc_writel(vcpu, eiointc, addr, val);
+		value = *(unsigned int *)val;
+		ret = loongarch_eiointc_write(vcpu, eiointc, addr, value, UINT_MAX);
 		break;
 	default:
-		ret = loongarch_eiointc_writeq(vcpu, eiointc, addr, val);
+		value = *(unsigned long *)val;
+		ret = loongarch_eiointc_write(vcpu, eiointc, addr, value, ULONG_MAX);
 		break;
 	}
 	spin_unlock_irqrestore(&eiointc->lock, flags);
-- 
2.39.3


