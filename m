Return-Path: <kvm+bounces-48948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03489AD483F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 03:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78EA23A9FB8
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52EC1C5D53;
	Wed, 11 Jun 2025 01:47:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFA61B81DC;
	Wed, 11 Jun 2025 01:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749606435; cv=none; b=iaKMiZTYa9Sw0EnMVGqV4qTWprB0kH1npR6kBL4LuGyJint+BD+HeywDLUXYFLYHHInH9c/yQ/HsLRXlyJ4rzfO43u/NpPfvIsQzbw6azkFoc3sVexwcriRliRZzyGZOspPEZsjpoKxZoGDXS+G5Agl6TTtLfKBLo1B0LFqTlfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749606435; c=relaxed/simple;
	bh=HOHcURIPteDflYVHmtZS9DkZpLOo2uCpk98aZBpsWxk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JnGlU/o8fj7CutEYFQrGBv/L2a4ujt8BtruhswELmd2wZN0Q3U8IYzXAYEDkvz3gXG42pGYPjVXKzryHw387CFetzzlIcmaeOY+UI+tcSSzaMvk7pnvWea4t/o2KMU4x8MLyHNxHp4FRyl2gj3KDhj+31yYrJWOCKiPjgSSypDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxC3Ie4EhosEITAQ--.47015S3;
	Wed, 11 Jun 2025 09:47:10 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMCx7MQL4Eho0EoVAQ--.65102S7;
	Wed, 11 Jun 2025 09:47:10 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 5/9] LoongArch: KVM: INTC: Avoid overflow with array index
Date: Wed, 11 Jun 2025 09:46:47 +0800
Message-Id: <20250611014651.3042734-6-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250611014651.3042734-1-maobibo@loongson.cn>
References: <20250611014651.3042734-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCx7MQL4Eho0EoVAQ--.65102S7
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Variable index is modified and reused as array index when modify
register EIOINTC_ENABLE. There will be array index overflow problem.

Cc: stable@vger.kernel.org
Fixes: 3956a52bc05b ("LoongArch: KVM: Add EIOINTC read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index ed80bf290755..0bc870796f56 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -447,17 +447,16 @@ static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
 		break;
 	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
 		index = (offset - EIOINTC_ENABLE_START) >> 1;
-		old_data = s->enable.reg_u32[index];
+		old_data = s->enable.reg_u16[index];
 		s->enable.reg_u16[index] = data;
 		/*
 		 * 1: enable irq.
 		 * update irq when isr is set.
 		 */
 		data = s->enable.reg_u16[index] & ~old_data & s->isr.reg_u16[index];
-		index = index << 1;
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index + i, mask, 1);
+			eiointc_enable_irq(vcpu, s, index * 2 + i, mask, 1);
 		}
 		/*
 		 * 0: disable irq.
@@ -466,7 +465,7 @@ static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
 		data = ~s->enable.reg_u16[index] & old_data & s->isr.reg_u16[index];
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index, mask, 0);
+			eiointc_enable_irq(vcpu, s, index * 2 + i, mask, 0);
 		}
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
@@ -540,10 +539,9 @@ static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 		 * update irq when isr is set.
 		 */
 		data = s->enable.reg_u32[index] & ~old_data & s->isr.reg_u32[index];
-		index = index << 2;
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index + i, mask, 1);
+			eiointc_enable_irq(vcpu, s, index * 4 + i, mask, 1);
 		}
 		/*
 		 * 0: disable irq.
@@ -552,7 +550,7 @@ static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 		data = ~s->enable.reg_u32[index] & old_data & s->isr.reg_u32[index];
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index, mask, 0);
+			eiointc_enable_irq(vcpu, s, index * 4 + i, mask, 0);
 		}
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
@@ -626,10 +624,9 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		 * update irq when isr is set.
 		 */
 		data = s->enable.reg_u64[index] & ~old_data & s->isr.reg_u64[index];
-		index = index << 3;
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index + i, mask, 1);
+			eiointc_enable_irq(vcpu, s, index * 8 + i, mask, 1);
 		}
 		/*
 		 * 0: disable irq.
@@ -638,7 +635,7 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		data = ~s->enable.reg_u64[index] & old_data & s->isr.reg_u64[index];
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index, mask, 0);
+			eiointc_enable_irq(vcpu, s, index * 8 + i, mask, 0);
 		}
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
-- 
2.39.3


