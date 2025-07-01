Return-Path: <kvm+bounces-51144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB32AEECCB
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 05:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8316A442734
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 03:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5B41E5B7C;
	Tue,  1 Jul 2025 03:09:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FACC1E32D6;
	Tue,  1 Jul 2025 03:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751339347; cv=none; b=Lsnk9aMmhF8uASs5hpm6ouUN8aVz8rCPWj6XgMXOOdgwYo5By771VlcPfihDAzmPECpXPMkJYIog3Mi+aHxKrL3NHo92SNIW8/9AVky/M2j5LaRktM49SuYUNfjTQ0x3e5B0r0Ke+KLHFLpu3+OcjgDAkF7Ve3nMo/nW/K8HO3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751339347; c=relaxed/simple;
	bh=afqbiV2IJGeJIlyLZ8DsShl+0u4wGmjx3/Q6/Mi/jNw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CY59HV7GOufUoBIlAZhckIzsc7dtv4RLb+KP4JiDEy3vn9THDEFbTfC5d1WLKKpXUhjNTpA2LFH6I3RxCmT7eBKzWQlWrYBRIRLaNegNiwVuN7jjEpZ5EMjXd+RZsn97bBxMbZf7mlgz30QlivRFwr3ipCSPJ/xlWl4tkPaHTv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxQK1HUWNowU4gAQ--.53466S3;
	Tue, 01 Jul 2025 11:08:55 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxpeQ7UWNolGYEAA--.27732S10;
	Tue, 01 Jul 2025 11:08:55 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 08/13] LoongArch: KVM: Use concise api __ffs()
Date: Tue,  1 Jul 2025 11:08:37 +0800
Message-Id: <20250701030842.1136519-9-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJBxpeQ7UWNolGYEAA--.27732S10
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function __ffs() is simpler than API find_first_bit() since parameter
data is unsigned long type.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 31f2c7476d6f..5b5b3a73a4fb 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -471,7 +471,7 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 				struct loongarch_eiointc *s,
 				gpa_t addr, const void *val)
 {
-	int i, index, irq, bits, ret = 0;
+	int i, index, irq, ret = 0;
 	u8 cpu;
 	u64 data, old_data;
 	gpa_t offset;
@@ -528,12 +528,10 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
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


