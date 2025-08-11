Return-Path: <kvm+bounces-54358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF57B1FDA2
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 04:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0917B3B8E5F
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 02:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D019C275B0A;
	Mon, 11 Aug 2025 02:13:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1203720C001;
	Mon, 11 Aug 2025 02:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754878439; cv=none; b=IBOZ2MfWIcRc7NhrYPj0lJHcpUpwL0zUrRiIY0I9IP1pz2sJIlZaugqi9pkoNq9A/eyI8poC1R4zaejsBuzHO9dG2utxE4wX44NnDG/axL7BG3zSKKadnEZjyrpSU4MNMtJDQn+V2w6H6EQtaPI0Bn9ailYAXpUwxMh/4y3/FKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754878439; c=relaxed/simple;
	bh=PoWL38fRU5C2OE+S08O2fNPsEzofkJYTBxIivUgIgWY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LzQ1ddTorSttQaSlTDt0herxw1NHxCbW4n/0PrccTYb2L9NWgRZPv2vGBujPGtJJnWs106lx7j0yWe4C4GrAF/RlWnmrjKl+tOLzUsalv9WwE02dtMQRzvlRVxr2PVVLkry3YsTzk2g4PzqauX21XpvXA2X4B/X5YfeVKpwxmG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxquDbUZlopxg+AQ--.12066S3;
	Mon, 11 Aug 2025 10:13:47 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxQ+TYUZloMZtBAA--.48509S6;
	Mon, 11 Aug 2025 10:13:47 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] LoongArch: KVM: Add different length support in loongarch_pch_pic_write()
Date: Mon, 11 Aug 2025 10:13:43 +0800
Message-Id: <20250811021344.3678306-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250811021344.3678306-1-maobibo@loongson.cn>
References: <20250811021344.3678306-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxQ+TYUZloMZtBAA--.48509S6
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With function loongarch_pch_pic_write(), currently there is only
four bytes register write support. In theory length 1/2/4/8 should be
supported for all the registers, here adding different length support
about register write emulation in function loongarch_pch_pic_write().

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/pch_pic.c | 153 ++++++++++--------------------
 1 file changed, 51 insertions(+), 102 deletions(-)

diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index 2e2613c436f6..0710b5ab286e 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -77,45 +77,6 @@ void pch_msi_set_irq(struct kvm *kvm, int irq, int level)
 	eiointc_set_irq(kvm->arch.eiointc, irq, level);
 }
 
-/*
- * pch pic register is 64-bit, but it is accessed by 32-bit,
- * so we use high to get whether low or high 32 bits we want
- * to read.
- */
-static u32 pch_pic_read_reg(u64 *s, int high)
-{
-	u64 val = *s;
-
-	/* read the high 32 bits when high is 1 */
-	return high ? (u32)(val >> 32) : (u32)val;
-}
-
-/*
- * pch pic register is 64-bit, but it is accessed by 32-bit,
- * so we use high to get whether low or high 32 bits we want
- * to write.
- */
-static u32 pch_pic_write_reg(u64 *s, int high, u32 v)
-{
-	u64 val = *s, data = v;
-
-	if (high) {
-		/*
-		 * Clear val high 32 bits
-		 * Write the high 32 bits when the high is 1
-		 */
-		*s = (val << 32 >> 32) | (data << 32);
-		val >>= 32;
-	} else
-		/*
-		 * Clear val low 32 bits
-		 * Write the low 32 bits when the high is 0
-		 */
-		*s = (val >> 32 << 32) | v;
-
-	return (u32)val;
-}
-
 static int loongarch_pch_pic_read(struct loongarch_pch_pic *s, gpa_t addr, int len, void *val)
 {
 	int offset, ret = 0;
@@ -201,80 +162,68 @@ static int loongarch_pch_pic_write(struct loongarch_pch_pic *s, gpa_t addr,
 					int len, const void *val)
 {
 	int ret;
-	u32 old, data, offset, index;
-	u64 irq;
+	u32 offset;
+	u64 old, data, mask;
+	void *ptemp;
 
-	ret = 0;
-	data = *(u32 *)val;
-	offset = addr - s->pch_pic_base;
+	switch (len) {
+	case 1:
+		data = *(u8 *)val;
+		mask = 0xFF;
+		break;
+	case 2:
+		data = *(u16 *)val;
+		mask = USHRT_MAX;
+		break;
+	case 4:
+		data = *(u32 *)val;
+		mask = UINT_MAX;
+		break;
+	default:
+		data = *(u64 *)val;
+		mask = ULONG_MAX;
+		break;
+	}
 
+	offset = (addr - s->pch_pic_base) & 7;
+	mask = mask << (offset * 8);
+	data = data << (offset * 8);
+	ret = 0;
+	offset = (addr - s->pch_pic_base) - offset;
 	spin_lock(&s->lock);
 	switch (offset) {
-	case PCH_PIC_MASK_START ... PCH_PIC_MASK_END:
-		offset -= PCH_PIC_MASK_START;
-		/* get whether high or low 32 bits we want to write */
-		index = offset >> 2;
-		old = pch_pic_write_reg(&s->mask, index, data);
-		/* enable irq when mask value change to 0 */
-		irq = (old & ~data) << (32 * index);
-		pch_pic_update_batch_irqs(s, irq, 1);
-		/* disable irq when mask value change to 1 */
-		irq = (~old & data) << (32 * index);
-		pch_pic_update_batch_irqs(s, irq, 0);
-		break;
-	case PCH_PIC_HTMSI_EN_START ... PCH_PIC_HTMSI_EN_END:
-		offset -= PCH_PIC_HTMSI_EN_START;
-		index = offset >> 2;
-		pch_pic_write_reg(&s->htmsi_en, index, data);
+	case PCH_PIC_MASK_START:
+		old = s->mask;
+		s->mask = (old & ~mask) | data;
+		if (old & ~data)
+			pch_pic_update_batch_irqs(s, old & ~data, 1);
+		if (~old & data)
+			pch_pic_update_batch_irqs(s, ~old & data, 0);
 		break;
-	case PCH_PIC_EDGE_START ... PCH_PIC_EDGE_END:
-		offset -= PCH_PIC_EDGE_START;
-		index = offset >> 2;
-		/* 1: edge triggered, 0: level triggered */
-		pch_pic_write_reg(&s->edge, index, data);
-		break;
-	case PCH_PIC_CLEAR_START ... PCH_PIC_CLEAR_END:
-		offset -= PCH_PIC_CLEAR_START;
-		index = offset >> 2;
-		/* write 1 to clear edge irq */
-		old = pch_pic_read_reg(&s->irr, index);
-		/*
-		 * get the irq bitmap which is edge triggered and
-		 * already set and to be cleared
-		 */
-		irq = old & pch_pic_read_reg(&s->edge, index) & data;
-		/* write irr to the new state where irqs have been cleared */
-		pch_pic_write_reg(&s->irr, index, old & ~irq);
-		/* update cleared irqs */
-		pch_pic_update_batch_irqs(s, irq, 0);
+	case PCH_PIC_HTMSI_EN_START:
+		s->htmsi_en = (s->htmsi_en & ~mask) | data;
 		break;
-	case PCH_PIC_AUTO_CTRL0_START ... PCH_PIC_AUTO_CTRL0_END:
-		offset -= PCH_PIC_AUTO_CTRL0_START;
-		index = offset >> 2;
-		/* we only use default mode: fixed interrupt distribution mode */
-		pch_pic_write_reg(&s->auto_ctrl0, index, 0);
+	case PCH_PIC_EDGE_START:
+		s->edge = (s->edge & ~mask) | data;
 		break;
-	case PCH_PIC_AUTO_CTRL1_START ... PCH_PIC_AUTO_CTRL1_END:
-		offset -= PCH_PIC_AUTO_CTRL1_START;
-		index = offset >> 2;
-		/* we only use default mode: fixed interrupt distribution mode */
-		pch_pic_write_reg(&s->auto_ctrl1, index, 0);
+	case PCH_PIC_POLARITY_START:
+		s->polarity = (s->polarity & ~mask) | data;
 		break;
-	case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
-		offset -= PCH_PIC_ROUTE_ENTRY_START;
-		/* only route to int0: eiointc */
-		s->route_entry[offset] = 1;
+	case PCH_PIC_CLEAR_START:
+		old = s->irr & s->edge & data;
+		if (old) {
+			s->irr &= ~old;
+			pch_pic_update_batch_irqs(s, old, 0);
+		}
 		break;
 	case PCH_PIC_HTMSI_VEC_START ... PCH_PIC_HTMSI_VEC_END:
-		/* route table to eiointc */
-		offset -= PCH_PIC_HTMSI_VEC_START;
-		s->htmsi_vector[offset] = (u8)data;
+		ptemp = s->htmsi_vector + (offset - PCH_PIC_HTMSI_VEC_START);
+		*(u64 *)ptemp = (*(u64 *)ptemp & ~mask) | data;
 		break;
-	case PCH_PIC_POLARITY_START ... PCH_PIC_POLARITY_END:
-		offset -= PCH_PIC_POLARITY_START;
-		index = offset >> 2;
-		/* we only use defalut value 0: high level triggered */
-		pch_pic_write_reg(&s->polarity, index, 0);
+	/* Not implemented */
+	case PCH_PIC_AUTO_CTRL0_START:
+	case PCH_PIC_AUTO_CTRL1_START:
+	case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.39.3


