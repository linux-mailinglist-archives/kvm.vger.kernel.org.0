Return-Path: <kvm+bounces-7429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF638841C84
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C94B282C55
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 07:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2F724EB41;
	Tue, 30 Jan 2024 07:22:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00646524D1;
	Tue, 30 Jan 2024 07:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706599366; cv=none; b=uQX6L2jV5W41zSss8OKZVXPCkTi3wcUzyQjUhbEWz8VWUq1o2xxGJiQa5HQpEeG2D5Gkh2futFOdlM3d/Z21jbUdHp9g3R2Gcy1OaCY4fIHMYqm/pvuNdlnFUVMGiI4XDLMZOWM93nBY7zwn+Fv1pO83VWUExlnCF5zBBiPTnZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706599366; c=relaxed/simple;
	bh=5t/MLIYK4bbQZ2ZQSJsYvzr+aXUvmNa0VBuiVYLdr+A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fSmqJpPuC9NsmeAYY0kgNV5uML0cIz8k344iFNt1RRTz9dQawedjyQxZz7xBnoS4xA4TGqLmwsvmdLMvcdy1I/66sS1bckfHjZtvuNKQj2feyzmMUaPNECNEgOTOVg4VXlgJ9HOirCK/A6P/m+W9rC4YRaCk6STjzAXwmViqom8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx77vCo7hlpToIAA--.5797S3;
	Tue, 30 Jan 2024 15:22:42 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxXs2+o7hlPo4nAA--.20587S4;
	Tue, 30 Jan 2024 15:22:40 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] LoongArch: KVM: Do not restart SW timer when it is expired
Date: Tue, 30 Jan 2024 15:22:38 +0800
Message-Id: <20240130072238.2829831-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240130072238.2829831-1-maobibo@loongson.cn>
References: <20240130072238.2829831-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxXs2+o7hlPo4nAA--.20587S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJF1UZFyrAFykXFWkXF4rCrX_yoW8Cr47pr
	WSkwn7Jw1rury8Wa4DJan5urn8A347t3W7WFW7G3y0yFnFyw15JF48XFykJFWft3y8ZrWS
	vr1Fyry5Ca1DX3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2T5lUUUUU

LoongArch guest has separate hw timer, SW timer is to wake up
blocked vcpu thread, rather than HW timer emulation. When blocking
vcpu schedules out, SW timer is used to wakeup blocked vcpu thread
and injects timer interrupt. It does not care about whether guest
timer is in period mode or oneshot mode, and SW timer needs not be
restarted since vcpu has been woken.

This patch does not restart sw timer when it is expired.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/timer.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index a9125f0a12d1..d3282f01d4d9 100644
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -23,24 +23,6 @@ static inline u64 tick_to_ns(struct kvm_vcpu *vcpu, u64 tick)
 	return div_u64(tick * MNSEC_PER_SEC, vcpu->arch.timer_mhz);
 }
 
-/*
- * Push timer forward on timeout.
- * Handle an hrtimer event by push the hrtimer forward a period.
- */
-static enum hrtimer_restart kvm_count_timeout(struct kvm_vcpu *vcpu)
-{
-	unsigned long cfg, period;
-
-	/* Add periodic tick to current expire time */
-	cfg = kvm_read_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_TCFG);
-	if (cfg & CSR_TCFG_PERIOD) {
-		period = tick_to_ns(vcpu, cfg & CSR_TCFG_VAL);
-		hrtimer_add_expires_ns(&vcpu->arch.swtimer, period);
-		return HRTIMER_RESTART;
-	} else
-		return HRTIMER_NORESTART;
-}
-
 /* Low level hrtimer wake routine */
 enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer)
 {
@@ -50,7 +32,7 @@ enum hrtimer_restart kvm_swtimer_wakeup(struct hrtimer *timer)
 	kvm_queue_irq(vcpu, INT_TI);
 	rcuwait_wake_up(&vcpu->wait);
 
-	return kvm_count_timeout(vcpu);
+	return HRTIMER_NORESTART;
 }
 
 /*
-- 
2.39.3


