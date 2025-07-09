Return-Path: <kvm+bounces-51887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C34FAFE1C1
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7E597ADB09
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9613239E85;
	Wed,  9 Jul 2025 08:02:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17CA2223DD1;
	Wed,  9 Jul 2025 08:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752048162; cv=none; b=UpiLE93zYdzVZ05HEJbv1QW+LwFCZrpC7QSSJJQyieSjwl/z8VjEUSC8CK4XGNbIT6k8sUeH5VG4jsSujM+KtMA6DYk/hBiTWaMc7gd4Pd/LsIZArdTHgZF5JQdh7Mss+VYDw2tpKK6LAAHT1DMR91Hb9qAB59SIy2/eWsXW1MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752048162; c=relaxed/simple;
	bh=BD/U6Gb7mKOZ/jRgYkNjVnDyOwfa/V4wS7qRfOnb0cM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bKWqyH6DI82ibkuCUSZc1rCb8V6ce7h7zUrHSpvqrMAb9m499seZIe596R7Petxk3oB4SdB0NeNz0Ne1csfG+d14hxq0zTXcoligr1dghEVv6oPaAYFmH3oBeJ3+X3eR7peqNFItzCdN/fs2oTUx92E2iuTK22EAVyccsXV16II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxG6waIm5oUiklAQ--.38583S3;
	Wed, 09 Jul 2025 16:02:34 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQZIm5oS6cPAA--.24964S3;
	Wed, 09 Jul 2025 16:02:34 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/8] LoongArch: KVM: Use standard bitops API with eiointc
Date: Wed,  9 Jul 2025 16:02:26 +0800
Message-Id: <20250709080233.3948503-2-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJBxpeQZIm5oS6cPAA--.24964S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Standard bitops APIs such test_bit() is used here, rather than manually
calculate the offset and mask. Also use non-atomic API __set_bit()
and __clear_bit() rather than set_bit() and clear_bit(), since global
spinlock is held already.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index a75f865d6fb9..3cf9894999da 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -9,7 +9,7 @@
 
 static void eiointc_set_sw_coreisr(struct loongarch_eiointc *s)
 {
-	int ipnum, cpu, cpuid, irq_index, irq_mask, irq;
+	int ipnum, cpu, cpuid, irq;
 	struct kvm_vcpu *vcpu;
 
 	for (irq = 0; irq < EIOINTC_IRQS; irq++) {
@@ -18,8 +18,6 @@ static void eiointc_set_sw_coreisr(struct loongarch_eiointc *s)
 			ipnum = count_trailing_zeros(ipnum);
 			ipnum = (ipnum >= 0 && ipnum < 4) ? ipnum : 0;
 		}
-		irq_index = irq / 32;
-		irq_mask = BIT(irq & 0x1f);
 
 		cpuid = s->coremap.reg_u8[irq];
 		vcpu = kvm_get_vcpu_by_cpuid(s->kvm, cpuid);
@@ -27,16 +25,16 @@ static void eiointc_set_sw_coreisr(struct loongarch_eiointc *s)
 			continue;
 
 		cpu = vcpu->vcpu_id;
-		if (!!(s->coreisr.reg_u32[cpu][irq_index] & irq_mask))
-			set_bit(irq, s->sw_coreisr[cpu][ipnum]);
+		if (test_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]))
+			__set_bit(irq, s->sw_coreisr[cpu][ipnum]);
 		else
-			clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
+			__clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
 	}
 }
 
 static void eiointc_update_irq(struct loongarch_eiointc *s, int irq, int level)
 {
-	int ipnum, cpu, found, irq_index, irq_mask;
+	int ipnum, cpu, found;
 	struct kvm_vcpu *vcpu;
 	struct kvm_interrupt vcpu_irq;
 
@@ -48,19 +46,16 @@ static void eiointc_update_irq(struct loongarch_eiointc *s, int irq, int level)
 
 	cpu = s->sw_coremap[irq];
 	vcpu = kvm_get_vcpu(s->kvm, cpu);
-	irq_index = irq / 32;
-	irq_mask = BIT(irq & 0x1f);
-
 	if (level) {
 		/* if not enable return false */
-		if (((s->enable.reg_u32[irq_index]) & irq_mask) == 0)
+		if (!test_bit(irq, (unsigned long *)s->enable.reg_u32))
 			return;
-		s->coreisr.reg_u32[cpu][irq_index] |= irq_mask;
+		__set_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]);
 		found = find_first_bit(s->sw_coreisr[cpu][ipnum], EIOINTC_IRQS);
-		set_bit(irq, s->sw_coreisr[cpu][ipnum]);
+		__set_bit(irq, s->sw_coreisr[cpu][ipnum]);
 	} else {
-		s->coreisr.reg_u32[cpu][irq_index] &= ~irq_mask;
-		clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
+		__clear_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]);
+		__clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
 		found = find_first_bit(s->sw_coreisr[cpu][ipnum], EIOINTC_IRQS);
 	}
 
@@ -110,8 +105,8 @@ void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level)
 	unsigned long flags;
 	unsigned long *isr = (unsigned long *)s->isr.reg_u8;
 
-	level ? set_bit(irq, isr) : clear_bit(irq, isr);
 	spin_lock_irqsave(&s->lock, flags);
+	level ? __set_bit(irq, isr) : __clear_bit(irq, isr);
 	eiointc_update_irq(s, irq, level);
 	spin_unlock_irqrestore(&s->lock, flags);
 }
-- 
2.39.3


