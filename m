Return-Path: <kvm+bounces-51143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72715AEECC9
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47EB27AB932
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08589246762;
	Tue,  1 Jul 2025 03:08:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E10420E032;
	Tue,  1 Jul 2025 03:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751339338; cv=none; b=cI81RcetbyGmeSowb1Kk2/AYkZSERdZz6Qre+g8zkGyk+7YI4TMGWLU6ZMI9cVfdCsrFqjPnbjmWXBWp7UiAK1Xs+U0kdZh2XQXYWbgx/9B1TR0FeVhqAwmXvg9nuL7GUP01n2BlyweV2GVD8rFQXagNpY1AslRjAbzpL40IQYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751339338; c=relaxed/simple;
	bh=QRHedoFWWt2Ze94xW4kBsZTUPNwagDJhJw5uOqe2zfQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j9rBuwcaghmHiIrPTK4klTmT1sNHmk0bi1w1wz68PygHaD2butqOS3Q6y8Y8QlpDLtXO5f9tO8T5O2uLEInZsznesKI6FAT8ceV+zAs/9lxHYHLXBMHSUg/4uU18Jm9hCf++WbMFFAxB087CpCQlJiFoIyZjbWMneACjuhC0M9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxOGpGUWNotk4gAQ--.8741S3;
	Tue, 01 Jul 2025 11:08:54 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQ7UWNolGYEAA--.27732S8;
	Tue, 01 Jul 2025 11:08:53 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 06/13] LoongArch: KVM: Use generic read function loongarch_eiointc_read
Date: Tue,  1 Jul 2025 11:08:35 +0800
Message-Id: <20250701030842.1136519-7-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250701030842.1136519-1-maobibo@loongson.cn>
References: <20250701030842.1136519-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxpeQ7UWNolGYEAA--.27732S8
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Generic read function loongarch_eiointc_read() is used for 1/2/4/8
bytes read access. It reads 8 bytes from emulated software state
and shift left from address offset.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 146 +++---------------------------
 1 file changed, 13 insertions(+), 133 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index e169b96b7e5c..b49611c00b0e 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -130,132 +130,6 @@ static inline void eiointc_enable_irq(struct kvm_vcpu *vcpu,
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
 static int loongarch_eiointc_read(struct kvm_vcpu *vcpu, struct loongarch_eiointc *s,
 				gpa_t addr, unsigned long *val)
 {
@@ -303,7 +177,7 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 			gpa_t addr, int len, void *val)
 {
 	int ret = -EINVAL;
-	unsigned long flags, data;
+	unsigned long flags, data, offset;
 	struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
 
 	if (!eiointc) {
@@ -317,25 +191,31 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
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
+		*(u8 *)val = (u8)data;
 		break;
 	case 2:
-		ret = loongarch_eiointc_readw(vcpu, eiointc, addr, val);
+		*(u16 *)val = (u16)data;
 		break;
 	case 4:
-		ret = loongarch_eiointc_readl(vcpu, eiointc, addr, val);
+		*(u32 *)val = (u32)data;
 		break;
 	default:
-		ret = loongarch_eiointc_read(vcpu, eiointc, addr, &data);
 		*(u64 *)val = data;
 		break;
 	}
-	spin_unlock_irqrestore(&eiointc->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static int loongarch_eiointc_writeb(struct kvm_vcpu *vcpu,
-- 
2.39.3


