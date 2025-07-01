Return-Path: <kvm+bounces-51147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3142CAEECE9
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 352FD7AA944
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A441F2BB5;
	Tue,  1 Jul 2025 03:15:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899F476034;
	Tue,  1 Jul 2025 03:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751339709; cv=none; b=kokvutIWm4Irl/NvA3C+5oXpZFvQ1zJYVt0c6CdRsqh7u+qNw7HnU5quFKHSyIdiigOxsXlIiNNsrbJJmMBr2moiu5WldXbPUN6G58StieYyx/5M+BzMcbKwRBy1OLt735IJolNwOw3k/hksEg4LG5ID4ppR513g5Bs+zttVVRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751339709; c=relaxed/simple;
	bh=8+bHZrBnLmNnbOr1zNgMt7Z2pvMZLi6MbG8V1ycgM38=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fff8R1598+ARTzXPfXRPCE9jVmWtK3ZLpdHm9mNn9ruQn6QGd26Q7pmEeuG7ost8CniZhAMdlhROn/dLBaFDtzxeSizRlDBMBwrT+xGxt7l0UxKYAOuFcrdUZ0WKNuxeUyAHqomyPuzdOJtPZxyAtcbqUQlfWdagdSDf6XGM9oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bxlmm6UmNoNFAgAQ--.4866S3;
	Tue, 01 Jul 2025 11:15:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxocK4UmNo7GcEAA--.27349S5;
	Tue, 01 Jul 2025 11:15:05 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 12/13] LoongArch: KVM: Add generic function loongarch_eiointc_write()
Date: Tue,  1 Jul 2025 11:15:03 +0800
Message-Id: <20250701031504.1233777-4-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJCxocK4UmNo7GcEAA--.27349S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function loongarch_eiointc_write() is added for 1/2/4/8 bytes eiointc
register write operation. Parameter field_mask is alternative meaning
of length.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 39 ++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 7844463ee2b9..105764c1a735 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -467,33 +467,37 @@ static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
+static int loongarch_eiointc_write(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
-				gpa_t addr, const void *val)
+				gpa_t addr, u64 value, u64 field_mask)
 {
-	int index, irq, ret = 0;
+	int index, irq, offset, ret = 0;
 	u8 cpu;
-	u64 data, old;
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
-		s->ipmap.reg_u64 = data;
+		old = s->ipmap.reg_u64;
+		s->ipmap.reg_u64 = (old & ~mask) | data;
 		break;
 	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
 		index = (addr - EIOINTC_ENABLE_START) >> 3;
 		old = s->enable.reg_u64[index];
-		s->enable.reg_u64[index] = data;
+		s->enable.reg_u64[index] = (old & ~mask) | data;
 		/*
 		 * 1: enable irq.
 		 * update irq when isr is set.
@@ -519,7 +523,8 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
 		/* do not emulate hw bounced irq routing */
 		index = (addr - EIOINTC_BOUNCE_START) >> 3;
-		s->bounce.reg_u64[index] = data;
+		old = s->bounce.reg_u64[index];
+		s->bounce.reg_u64[index] = (old & ~mask) | data;
 		break;
 	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
 		index = (addr - EIOINTC_COREISR_START) >> 3;
@@ -536,10 +541,11 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
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
@@ -554,7 +560,7 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 			gpa_t addr, int len, const void *val)
 {
 	int ret = -EINVAL;
-	unsigned long flags;
+	unsigned long flags, value;
 	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
 
 	if (!eiointc) {
@@ -580,7 +586,8 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 		ret = loongarch_eiointc_writel(vcpu, eiointc, addr, val);
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


