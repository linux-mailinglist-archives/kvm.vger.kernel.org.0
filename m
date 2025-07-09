Return-Path: <kvm+bounces-51888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA69BAFE1C7
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F008176E9B
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAFBD23B61B;
	Wed,  9 Jul 2025 08:02:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D2321ADAE;
	Wed,  9 Jul 2025 08:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752048162; cv=none; b=kxBEZSSylhjpT7il5joX7jCO9B99fbFHl9G88nj3tA1E7NvZE7ifSGw0IO2D65FdC9o7+d/y94ALL4lUHJkO4jrpaZ0VybB5U19BcDWF5zZsRFgltsXz2oKEi3aEgh/wWYvTXgv9wVOwbL+HwWJlJeh9fJHFdo5HVsOey8gjFE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752048162; c=relaxed/simple;
	bh=ZozhxM42GWK0QwVZ3q7SmgDYN6haL4E4J7xu4mbH4O4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oknVmOjRsGAKZlJ2hFEMQc4uXjnhBtjyOOHXXaElNwPZxQMl9N08779MiH0B6QbhPqUleO2utUmL6Rcc4x6CB/qHAk/pDiJZZoRGY4rKTWnJBpgmTqhGRnnwiLJva/do21gN3OtknJw69AkGSl1axylyND6fH6wtlcaYcn8P30I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxzOIcIm5oXyklAQ--.13338S3;
	Wed, 09 Jul 2025 16:02:36 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQZIm5oS6cPAA--.24964S7;
	Wed, 09 Jul 2025 16:02:36 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 5/8] LoongArch: KVM: Use generic function loongarch_eiointc_read()
Date: Wed,  9 Jul 2025 16:02:30 +0800
Message-Id: <20250709080233.3948503-6-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJBxpeQZIm5oS6cPAA--.24964S7
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Generic read function loongarch_eiointc_read() is used for 1/2/4/8
bytes read access. It reads 8 bytes from emulated software state
and shift right from address offset.

Also the similar with kvm_complete_iocsr_read(), destination register
of IOCSRRD.{B/H/W} is sign extension from byte/half word/word.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 153 ++++--------------------------
 1 file changed, 17 insertions(+), 136 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 137cd3adca80..3e8dc844be76 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -130,134 +130,8 @@ static inline void eiointc_enable_irq(struct kvm_vcpu *vcpu,
 	}
 }
 
-static int loongarch_eiointc_readb(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
-				gpa_t addr, void *val)
-{
-	int index, ret = 0;
-	u8 data = 0;
-	gpa_t offset;
-
-	offset = addr - EIOINTC_BASE;
-	switch (offset) {
-	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
-		index = offset - EIOINTC_NODETYPE_START;
-		data = s->nodetype.reg_u8[index];
-		break;
-	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
-		index = offset - EIOINTC_IPMAP_START;
-		data = s->ipmap.reg_u8[index];
-		break;
-	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
-		index = offset - EIOINTC_ENABLE_START;
-		data = s->enable.reg_u8[index];
-		break;
-	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
-		index = offset - EIOINTC_BOUNCE_START;
-		data = s->bounce.reg_u8[index];
-		break;
-	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
-		index = offset - EIOINTC_COREISR_START;
-		data = s->coreisr.reg_u8[vcpu->vcpu_id][index];
-		break;
-	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-		index = offset - EIOINTC_COREMAP_START;
-		data = s->coremap.reg_u8[index];
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	*(u8 *)val = data;
-
-	return ret;
-}
-
-static int loongarch_eiointc_readw(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
-				gpa_t addr, void *val)
-{
-	int index, ret = 0;
-	u16 data = 0;
-	gpa_t offset;
-
-	offset = addr - EIOINTC_BASE;
-	switch (offset) {
-	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
-		index = (offset - EIOINTC_NODETYPE_START) >> 1;
-		data = s->nodetype.reg_u16[index];
-		break;
-	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
-		index = (offset - EIOINTC_IPMAP_START) >> 1;
-		data = s->ipmap.reg_u16[index];
-		break;
-	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
-		index = (offset - EIOINTC_ENABLE_START) >> 1;
-		data = s->enable.reg_u16[index];
-		break;
-	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
-		index = (offset - EIOINTC_BOUNCE_START) >> 1;
-		data = s->bounce.reg_u16[index];
-		break;
-	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
-		index = (offset - EIOINTC_COREISR_START) >> 1;
-		data = s->coreisr.reg_u16[vcpu->vcpu_id][index];
-		break;
-	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-		index = (offset - EIOINTC_COREMAP_START) >> 1;
-		data = s->coremap.reg_u16[index];
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	*(u16 *)val = data;
-
-	return ret;
-}
-
-static int loongarch_eiointc_readl(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
-				gpa_t addr, void *val)
-{
-	int index, ret = 0;
-	u32 data = 0;
-	gpa_t offset;
-
-	offset = addr - EIOINTC_BASE;
-	switch (offset) {
-	case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
-		index = (offset - EIOINTC_NODETYPE_START) >> 2;
-		data = s->nodetype.reg_u32[index];
-		break;
-	case EIOINTC_IPMAP_START ... EIOINTC_IPMAP_END:
-		index = (offset - EIOINTC_IPMAP_START) >> 2;
-		data = s->ipmap.reg_u32[index];
-		break;
-	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
-		index = (offset - EIOINTC_ENABLE_START) >> 2;
-		data = s->enable.reg_u32[index];
-		break;
-	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
-		index = (offset - EIOINTC_BOUNCE_START) >> 2;
-		data = s->bounce.reg_u32[index];
-		break;
-	case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
-		index = (offset - EIOINTC_COREISR_START) >> 2;
-		data = s->coreisr.reg_u32[vcpu->vcpu_id][index];
-		break;
-	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-		index = (offset - EIOINTC_COREMAP_START) >> 2;
-		data = s->coremap.reg_u32[index];
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	*(u32 *)val = data;
-
-	return ret;
-}
-
-static int loongarch_eiointc_readq(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
-				gpa_t addr, void *val)
+static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
+				gpa_t addr, unsigned long *val)
 {
 	int index, ret = 0;
 	u64 data = 0;
@@ -293,7 +167,7 @@ static int loongarch_eiointc_readq(struct kvm_vcpu *vcpu, struct loongarch_eioin
 		ret = -EINVAL;
 		break;
 	}
-	*(u64 *)val = data;
+	*val = data;
 
 	return ret;
 }
@@ -303,7 +177,7 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 			gpa_t addr, int len, void *val)
 {
 	int ret = -EINVAL;
-	unsigned long flags;
+	unsigned long flags, data, offset;
 	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
 
 	if (!eiointc) {
@@ -317,24 +191,31 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu->stat.eiointc_read_exits++;
+	offset = addr & 0x7;
+	addr -= offset;
 	spin_lock_irqsave(&eiointc->lock, flags);
+	ret = loongarch_eiointc_read(vcpu, eiointc, addr, &data);
+	spin_unlock_irqrestore(&eiointc->lock, flags);
+	if (ret)
+		return ret;
+
+	data = data >> (offset * 8);
 	switch (len) {
 	case 1:
-		ret = loongarch_eiointc_readb(vcpu, eiointc, addr, val);
+		*(long *)val = (s8)data;
 		break;
 	case 2:
-		ret = loongarch_eiointc_readw(vcpu, eiointc, addr, val);
+		*(long *)val = (s16)data;
 		break;
 	case 4:
-		ret = loongarch_eiointc_readl(vcpu, eiointc, addr, val);
+		*(long *)val = (s32)data;
 		break;
 	default:
-		ret = loongarch_eiointc_readq(vcpu, eiointc, addr, val);
+		*(long *)val = (long)data;
 		break;
 	}
-	spin_unlock_irqrestore(&eiointc->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static int loongarch_eiointc_writeb(struct kvm_vcpu *vcpu,
-- 
2.39.3


