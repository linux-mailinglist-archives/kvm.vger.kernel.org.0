Return-Path: <kvm+bounces-51148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A83AAAEECEB
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:16:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F28D7AC4D0
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:14:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74FA0221F37;
	Tue,  1 Jul 2025 03:15:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C491A3155;
	Tue,  1 Jul 2025 03:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751339711; cv=none; b=Y5MJqU4nUZ3u+eZc9YDw/fNtmfjdzyBp7C8YHD+z7HgCAN9bh7FhbrFU/fyUIu+9QIAaU/B8S8aHjqQlCKQmZoACJ/Wm9kL2UnlOyfvIWd5WJiRckv0Ti+XV/1dZEMu5VK2C3cWesP2wV3sYloFaEftEcGMl0+bIS1nMG3DTNF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751339711; c=relaxed/simple;
	bh=tndzeMyq5dz/RYZHGbtxODFdk4Tju5gEzo5gmm3ZCLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mid5dBM+P6j9R2mRSCK1YuMdCDABLcMdQ/7IqzP6AKs3wZQZWMgfQLBL/bJu0MZcvJkgqIyHCGH+oCAj1OtPqe9M+5p/PzlvgFHNagOeIh+4ORfV7a64L8ahQzH9HlUHbMYu/nY6RuUH1ACGNEfaJgkT9q63KdTv59qbaMWbd4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxLOK6UmNoN1AgAQ--.29535S3;
	Tue, 01 Jul 2025 11:15:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxocK4UmNo7GcEAA--.27349S6;
	Tue, 01 Jul 2025 11:15:06 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 13/13] LoongArch: KVM: Use generic interface loongarch_eiointc_write()
Date: Tue,  1 Jul 2025 11:15:04 +0800
Message-Id: <20250701031504.1233777-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250701031504.1233777-1-maobibo@loongson.cn>
References: <20250701030842.1136519-1-maobibo@loongson.cn>
 <20250701031504.1233777-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxocK4UmNo7GcEAA--.27349S6
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
 arch/loongarch/kvm/intc/eiointc.c | 277 +-----------------------------
 1 file changed, 6 insertions(+), 271 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 105764c1a735..3a059f10575b 100644
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
@@ -218,255 +199,6 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
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
 static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
 				gpa_t addr, u64 value, u64 field_mask)
@@ -577,13 +309,16 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
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
 		value = *(unsigned long *)val;
-- 
2.39.3


