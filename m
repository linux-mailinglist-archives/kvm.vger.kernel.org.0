Return-Path: <kvm+bounces-51891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C93AFE1E6
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 10:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 408645453D6
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5872749E3;
	Wed,  9 Jul 2025 08:04:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1BCF22FDFA;
	Wed,  9 Jul 2025 08:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752048268; cv=none; b=Ak9yK2FgXL8g0u22Pf+ER89qHWLlCCmn5G3zbB0qxEVYTQ9HpSNTwKhI9BGmBqVoGJx0QEYpeaKeTHqDwc2DV46Lg3BbvZZEAUTEit95oqmchKCdRbwI8F3zdsrnMhtr4JsgQxqbiexhjVkrUb2Hi+FcAX8ozCY+axc1kQUd2SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752048268; c=relaxed/simple;
	bh=AZ9YbrbfLTIVuCpz3dYeCu2OiVygiGbtmFkeNcGzuIw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dlbNRq8rDoj0LjegZJ1oTSjRNRmIqg6FxUhrKRTBUJwy4AP77ITk1gGqlQ6frd5FfBDp/zOXYTSpxaMDRBbxFyB6WlUa3ZmNx5mH2HZ23lyKybNtrwssGdO88nFX4v1SJpYo+vaEoX1bCmkXwakmuDg3VVcuJvF4wxKUKuKV7IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxnOIdIm5oZiklAQ--.44014S3;
	Wed, 09 Jul 2025 16:02:37 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQZIm5oS6cPAA--.24964S9;
	Wed, 09 Jul 2025 16:02:37 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 7/8] LoongArch: KVM: Replace eiointc_enable_irq() with eiointc_update_irq()
Date: Wed,  9 Jul 2025 16:02:32 +0800
Message-Id: <20250709080233.3948503-8-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJBxpeQZIm5oS6cPAA--.24964S9
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function eiointc_enable_irq() checks mask value with char type, and
call eiointc_update_irq() eventually. Function eiointc_update_irq()
will update one single irq status directly.

Here it can check mask value with unsigned long type and call function
eiointc_update_irq(), that is simple and direct.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index bed5f7bdc8b4..edcf87055b3c 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -471,7 +471,7 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
 				gpa_t addr, const void *val)
 {
-	int i, index, irq, bits, ret = 0;
+	int index, irq, ret = 0;
 	u8 cpu;
 	u64 data, old_data;
 
@@ -500,18 +500,20 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		 * update irq when isr is set.
 		 */
 		data = s->enable.reg_u64[index] & ~old_data & s->isr.reg_u64[index];
-		for (i = 0; i < sizeof(data); i++) {
-			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index * 8 + i, mask, 1);
+		while (data) {
+			irq = __ffs(data);
+			eiointc_update_irq(s, irq + index * 64, 1);
+			data &= ~BIT_ULL(irq);
 		}
 		/*
 		 * 0: disable irq.
 		 * update irq when isr is set.
 		 */
 		data = ~s->enable.reg_u64[index] & old_data & s->isr.reg_u64[index];
-		for (i = 0; i < sizeof(data); i++) {
-			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index * 8 + i, mask, 0);
+		while (data) {
+			irq = __ffs(data);
+			eiointc_update_irq(s, irq + index * 64, 0);
+			data &= ~BIT_ULL(irq);
 		}
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
@@ -527,12 +529,10 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		/* write 1 to clear interrupt */
 		s->coreisr.reg_u64[cpu][index] = old_data & ~data;
 		data &= old_data;
-		bits = sizeof(data) * 8;
-		irq = find_first_bit((void *)&data, bits);
-		while (irq < bits) {
-			eiointc_update_irq(s, irq + index * bits, 0);
-			bitmap_clear((void *)&data, irq, 1);
-			irq = find_first_bit((void *)&data, bits);
+		while (data) {
+			irq = __ffs(data);
+			eiointc_update_irq(s, irq + index * 64, 0);
+			data &= ~BIT_ULL(irq);
 		}
 		break;
 	case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
-- 
2.39.3


