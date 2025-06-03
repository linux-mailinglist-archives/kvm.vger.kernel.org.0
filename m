Return-Path: <kvm+bounces-48284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D78ACC36B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 11:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5760A16DF6B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35392836B1;
	Tue,  3 Jun 2025 09:46:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D9B664C6;
	Tue,  3 Jun 2025 09:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748943985; cv=none; b=obPr0e1C7+U1oWIWElZBuwrd0JfHAcB0F07EKPDZWnAyctd0YKl71s38IxTBfVJyt7m1Wv2y47ykwPc4D4Z4hjyP661SesDMVIcwHpMjQzx1p8KlHsHJQ2SaQZvDyfc1+2vhEa2mlsVV3DWKzdz/0I4LT3TB4O+RYVunpVJz+2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748943985; c=relaxed/simple;
	bh=JYTWJ4bzufmG4/W3c+dyWMhzf9Zd60/BveoZVPfRXoo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gA2+8iIHakMLs9xInMN2FFMfmEmiQRbEUmZjB05v6yeyklTqSl0mcTeFmnWDTxK+vEHpgrNMfzc9PnLhxQYv7ACxU3zNWbC1wcmewJNkvHBItKBA0gMHPDjBkHDoqpadpakBlX/YdnE28/ERQQEnJx/uWxp/A5az9+REvj1GKMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxDeNnxD5oTAwKAQ--.63128S3;
	Tue, 03 Jun 2025 17:46:15 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxH+VfxD5ot8gGAQ--.23188S3;
	Tue, 03 Jun 2025 17:46:14 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/7] LoongArch: KVM: Fix interrupt route update with eiointc
Date: Tue,  3 Jun 2025 17:46:00 +0800
Message-Id: <20250603094606.1053622-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250603094606.1053622-1-maobibo@loongson.cn>
References: <20250603094606.1053622-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxH+VfxD5ot8gGAQ--.23188S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With function eiointc_update_sw_coremap(), there is forced assignment
like val = *(u64 *)pvalue. Parameter pvalue may be pointer to char type
or others, there is problem with forced assignment with u64 type.

Here the detailed value is passed rather address pointer.

Cc: stable@vger.kernel.org
Fixes: 3956a52bc05b ("LoongArch: KVM: Add EIOINTC read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index f39929d7bf8a..d2c521b0e923 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -66,10 +66,9 @@ static void eiointc_update_irq(struct loongarch_eiointc *s, int irq, int level)
 }
 
 static inline void eiointc_update_sw_coremap(struct loongarch_eiointc *s,
-					int irq, void *pvalue, u32 len, bool notify)
+					int irq, u64 val, u32 len, bool notify)
 {
 	int i, cpu;
-	u64 val = *(u64 *)pvalue;
 
 	for (i = 0; i < len; i++) {
 		cpu = val & 0xff;
@@ -398,7 +397,7 @@ static int loongarch_eiointc_writeb(struct kvm_vcpu *vcpu,
 		irq = offset - EIOINTC_COREMAP_START;
 		index = irq;
 		s->coremap.reg_u8[index] = data;
-		eiointc_update_sw_coremap(s, irq, (void *)&data, sizeof(data), true);
+		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
 		break;
 	default:
 		ret = -EINVAL;
@@ -484,7 +483,7 @@ static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
 		irq = offset - EIOINTC_COREMAP_START;
 		index = irq >> 1;
 		s->coremap.reg_u16[index] = data;
-		eiointc_update_sw_coremap(s, irq, (void *)&data, sizeof(data), true);
+		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
 		break;
 	default:
 		ret = -EINVAL;
@@ -570,7 +569,7 @@ static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 		irq = offset - EIOINTC_COREMAP_START;
 		index = irq >> 2;
 		s->coremap.reg_u32[index] = data;
-		eiointc_update_sw_coremap(s, irq, (void *)&data, sizeof(data), true);
+		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
 		break;
 	default:
 		ret = -EINVAL;
@@ -656,7 +655,7 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		irq = offset - EIOINTC_COREMAP_START;
 		index = irq >> 3;
 		s->coremap.reg_u64[index] = data;
-		eiointc_update_sw_coremap(s, irq, (void *)&data, sizeof(data), true);
+		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
 		break;
 	default:
 		ret = -EINVAL;
@@ -809,7 +808,7 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
 		for (i = 0; i < (EIOINTC_IRQS / 4); i++) {
 			start_irq = i * 4;
 			eiointc_update_sw_coremap(s, start_irq,
-					(void *)&s->coremap.reg_u32[i], sizeof(u32), false);
+					s->coremap.reg_u32[i], sizeof(u32), false);
 		}
 		break;
 	default:
-- 
2.39.3


