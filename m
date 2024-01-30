Return-Path: <kvm+bounces-7428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 57990841C81
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD84FB25184
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 07:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3D15475D;
	Tue, 30 Jan 2024 07:22:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D8951C38;
	Tue, 30 Jan 2024 07:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706599364; cv=none; b=CJv3DQmdJchOfoW3u7DBmj8CnLCYJ/bPaP0mGdj+SOu/D4NSFg9vDwjU8CjiJTpDyStocv937SeKqc2ifeIlCAnrOYSQvZ5XcgvAaT5jfJx7D0LlTo0mOc2U+dO1YUKcSxU6HSaWFbKM+Q184yW6Xv+j5tmFWrgZYSpZpHwvt50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706599364; c=relaxed/simple;
	bh=Yusrw8yR1q3K2wILNjHvC0KO/QfZjjXjrb6GyWBsDVI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BVBnY71kqcbw0WFIZXFRk1Dyg59JJQXeeC1dTKXjTQpOeW4R5dB2fVlrVBINuo3dJ+wZDWxHHeOiuIwphjdp3EH5JWhPHTXbh8zdp84seFIyC/oGSOWhievOMHPCCWztH2HVbiCEzLU3QLOviHeJaJ4nsOZ+ssLxHNXMMGtTo0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxeejAo7hlojoIAA--.5850S3;
	Tue, 30 Jan 2024 15:22:40 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxXs2+o7hlPo4nAA--.20587S3;
	Tue, 30 Jan 2024 15:22:39 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] LoongArch: KVM: Start SW timer only when vcpu is blocking
Date: Tue, 30 Jan 2024 15:22:37 +0800
Message-Id: <20240130072238.2829831-2-maobibo@loongson.cn>
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
X-CM-TRANSID:AQAAf8BxXs2+o7hlPo4nAA--.20587S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Aw1xCw4DGrWUZF1UuryUArc_yoW8tFyrpF
	Wxuwn2gr4rJ3yUX3WjqFs8urn8K3ykKrn7WFy7Ca4xAwnxXr15XFW0kayfXFW3Aaykur1S
	vr95tr13ZF48A3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r
	1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	W8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU
	2nYFDUUUU

SW timer is enabled when vcpu thread is scheduled out, and it is
to wake up vcpu from blocked queue. If vcpu thread is scheduled out
however is not blocked, such as it is preempted by other threads,
it is not necessary to enable SW timer. Since vcpu thread is still
on running queue if preempted and SW timer is only to wake up vcpu
on blocking queue, so SW timer is not useful in this situation.

This patch enables SW timer only when vcpu is scheduled out and
is blocking.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/timer.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index 111328f60872..a9125f0a12d1 100644
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -93,7 +93,8 @@ void kvm_restore_timer(struct kvm_vcpu *vcpu)
 	/*
 	 * Freeze the soft-timer and sync the guest stable timer with it.
 	 */
-	hrtimer_cancel(&vcpu->arch.swtimer);
+	if (kvm_vcpu_is_blocking(vcpu))
+		hrtimer_cancel(&vcpu->arch.swtimer);
 
 	/*
 	 * From LoongArch Reference Manual Volume 1 Chapter 7.6.2
@@ -168,26 +169,19 @@ static void _kvm_save_timer(struct kvm_vcpu *vcpu)
 	 * Here judge one-shot timer fired by checking whether TVAL is larger
 	 * than TCFG
 	 */
-	if (ticks < cfg) {
+	if (ticks < cfg)
 		delta = tick_to_ns(vcpu, ticks);
-		expire = ktime_add_ns(ktime_get(), delta);
-		vcpu->arch.expire = expire;
+	else
+		delta = 0;
+	expire = ktime_add_ns(ktime_get(), delta);
+	vcpu->arch.expire = expire;
+	if (kvm_vcpu_is_blocking(vcpu)) {
 
 		/*
 		 * HRTIMER_MODE_PINNED is suggested since vcpu may run in
 		 * the same physical cpu in next time
 		 */
 		hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED);
-	} else if (vcpu->stat.generic.blocking) {
-		/*
-		 * Inject timer interrupt so that halt polling can dectect and exit.
-		 * VCPU is scheduled out already and sleeps in rcuwait queue and
-		 * will not poll pending events again. kvm_queue_irq() is not enough,
-		 * hrtimer swtimer should be used here.
-		 */
-		expire = ktime_add_ns(ktime_get(), 10);
-		vcpu->arch.expire = expire;
-		hrtimer_start(&vcpu->arch.swtimer, expire, HRTIMER_MODE_ABS_PINNED);
 	}
 }
 
-- 
2.39.3


