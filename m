Return-Path: <kvm+bounces-51145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E481EAEECE5
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E63A9174568
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFB01E1308;
	Tue,  1 Jul 2025 03:15:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD271917ED;
	Tue,  1 Jul 2025 03:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751339708; cv=none; b=TeAJ4TYO00YWI78XZFkRBXKMUjz1GNg2KCixhfG8hLOhMPc0XhF71hA0rwDXSiUd1J80QaYcSyWR4LEKKEN4IppJarA6OJ19a5VnZoDoKoSqYpswotmCFTTczHJ3mbSLKMWOtvUIejmoEjFLiaBDHtkddvLPfGRp79Y3sN/LOTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751339708; c=relaxed/simple;
	bh=2wxlRWPiHsTaVt5zYkgULH82AhTGfKsEBem5i4BH374=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pFQl1zEyajJmtg9TCBnWXku1gGzE1FfaLhtlOkvqypAK4CQ3NYBkLf0yHvzi3+Ny8IVNhpFG6n3ckfSfxdcRGYGKQM1hkLM1PHOxd84+xP0KfnQ//9TSdy5tTVSUOEBEqvmz+T9PtsPrAs79e/Xr3ThJVT8A5m2Fb5uSivHSWLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxrnK5UmNoK1AgAQ--.5875S3;
	Tue, 01 Jul 2025 11:15:05 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxocK4UmNo7GcEAA--.27349S2;
	Tue, 01 Jul 2025 11:15:05 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/13] LoongArch: KVM: Replace eiointc_enable_irq() with eiointc_update_irq()
Date: Tue,  1 Jul 2025 11:15:00 +0800
Message-Id: <20250701031504.1233777-1-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJCxocK4UmNo7GcEAA--.27349S2
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
 arch/loongarch/kvm/intc/eiointc.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 5b5b3a73a4fb..5f2c291049b1 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -471,7 +471,7 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
 				gpa_t addr, const void *val)
 {
-	int i, index, irq, ret = 0;
+	int index, irq, ret = 0;
 	u8 cpu;
 	u64 data, old_data;
 	gpa_t offset;
@@ -501,18 +501,21 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
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
+
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
-- 
2.39.3


