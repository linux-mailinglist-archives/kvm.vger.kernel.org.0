Return-Path: <kvm+bounces-51886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F3BAFE1BF
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D519486705
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E50D235BE2;
	Wed,  9 Jul 2025 08:02:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1475E2222C3;
	Wed,  9 Jul 2025 08:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752048161; cv=none; b=Xzy+MbE5TBPb6cRC0h1S016tI+jhALky7SrLbXuN9rTSo1jFhnlNCuNP0V0EpTSypcydLsnPb9hJ/XmZjDf93HgrqGKVsNMh3/9UlAuj1DirikI/dRp6f47XWXL7o5LSqNdNx2CklUgOARmO0hBha2Mq5XqxFL6furNGs7t1n+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752048161; c=relaxed/simple;
	bh=x1bsEwS/nk/wakvnnYWRljMmzdrRQq5PzkcTVa0j/jo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FztlzhuaZOnXmAgoS/aEOyagt4TIeSE91sdrcRqsp8Hvn0661fPLfP/yQAEkO6HvfFYWzEBsXJhwFdEU1It26N9MmaU0OmsQVU2scFsBTditsw3nVmsuc9LzyJhsog6ZKALFUZGvf0G77Di6tfL25KJLymGwicZQ74zDA/CXNRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxG6wdIm5oYyklAQ--.38586S3;
	Wed, 09 Jul 2025 16:02:37 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQZIm5oS6cPAA--.24964S8;
	Wed, 09 Jul 2025 16:02:36 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 6/8] LoongArch: KVM: Remove some unnecessary local variables
Date: Wed,  9 Jul 2025 16:02:31 +0800
Message-Id: <20250709080233.3948503-7-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJBxpeQZIm5oS6cPAA--.24964S8
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Local variable coreisr and old_coreisr is replaced with data and
old_data, and the latter is widely used in other places.

Also local variable offset is removed and addr is used directly.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 3e8dc844be76..bed5f7bdc8b4 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -474,15 +474,13 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 	int i, index, irq, bits, ret = 0;
 	u8 cpu;
 	u64 data, old_data;
-	u64 coreisr, old_coreisr;
-	gpa_t offset;
 
 	data = *(u64 *)val;
-	offset = addr - EIOINTC_BASE;
+	addr -= EIOINTC_BASE;
 
-	switch (offset) {
+	switch (addr) {
 	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
-		index = (offset - EIOINTC_NODETYPE_START) >> 3;
+		index = (addr - EIOINTC_NODETYPE_START) >> 3;
 		s->nodetype.reg_u64[index] = data;
 		break;
 	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
@@ -490,11 +488,11 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		 * ipmap cannot be set at runtime, can be set only at the beginning
 		 * of irqchip driver, need not update upper irq level
 		 */
-		index = (offset - EIOINTC_IPMAP_START) >> 3;
+		index = (addr - EIOINTC_IPMAP_START) >> 3;
 		s->ipmap.reg_u64 = data;
 		break;
 	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
-		index = (offset - EIOINTC_ENABLE_START) >> 3;
+		index = (addr - EIOINTC_ENABLE_START) >> 3;
 		old_data = s->enable.reg_u64[index];
 		s->enable.reg_u64[index] = data;
 		/*
@@ -518,28 +516,27 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
 		/* do not emulate hw bounced irq routing */
-		index = (offset - EIOINTC_BOUNCE_START) >> 3;
+		index = (addr - EIOINTC_BOUNCE_START) >> 3;
 		s->bounce.reg_u64[index] = data;
 		break;
 	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
-		index = (offset - EIOINTC_COREISR_START) >> 3;
+		index = (addr - EIOINTC_COREISR_START) >> 3;
 		/* use attrs to get current cpu index */
 		cpu = vcpu->vcpu_id;
-		coreisr = data;
-		old_coreisr = s->coreisr.reg_u64[cpu][index];
+		old_data = s->coreisr.reg_u64[cpu][index];
 		/* write 1 to clear interrupt */
-		s->coreisr.reg_u64[cpu][index] = old_coreisr & ~coreisr;
-		coreisr &= old_coreisr;
+		s->coreisr.reg_u64[cpu][index] = old_data & ~data;
+		data &= old_data;
 		bits = sizeof(data) * 8;
-		irq = find_first_bit((void *)&coreisr, bits);
+		irq = find_first_bit((void *)&data, bits);
 		while (irq < bits) {
 			eiointc_update_irq(s, irq + index * bits, 0);
-			bitmap_clear((void *)&coreisr, irq, 1);
-			irq = find_first_bit((void *)&coreisr, bits);
+			bitmap_clear((void *)&data, irq, 1);
+			irq = find_first_bit((void *)&data, bits);
 		}
 		break;
 	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-		irq = offset - EIOINTC_COREMAP_START;
+		irq = addr - EIOINTC_COREMAP_START;
 		index = irq >> 3;
 		s->coremap.reg_u64[index] = data;
 		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
-- 
2.39.3


