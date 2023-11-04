Return-Path: <kvm+bounces-571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9559A7E0E6B
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 09:58:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AECC91C21128
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 08:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732FAF9FB;
	Sat,  4 Nov 2023 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE74C2C7
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 08:58:04 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4851F1BC;
	Sat,  4 Nov 2023 01:58:00 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxZ+iVB0Zl2+E2AA--.6405S3;
	Sat, 04 Nov 2023 16:57:57 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxbS+UB0ZlmGs5AA--.59322S4;
	Sat, 04 Nov 2023 16:57:57 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/3] LoongArch: KVM: Allow to access HW timer CSR registers always
Date: Sat,  4 Nov 2023 16:57:54 +0800
Message-Id: <20231104085755.930439-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231104085755.930439-1-maobibo@loongson.cn>
References: <20231104085755.930439-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxbS+UB0ZlmGs5AA--.59322S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7uFW7XFyDXw47WrW7CF13KFX_yoW5JrWDpr
	WakF9rtr48tryqqFyDJrs8uF15CrZ7K34xWF17AFW2yr12vr1rJF97Gr97XFWYqa4SqFWS
	vryrCwn0vF4DXwbCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1a6r1DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UgjjgUUUUU=

Currently HW timer CSR registers are allowed to access before entering to
vm and disabled if switch to SW timer in host mode, instead it is not
necessary to do so. HW timer CSR registers can be accessed always, it
is nothing to do with whether it is in vm mode or host mode. This patch
removes the limitation.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/main.c  |  1 -
 arch/loongarch/kvm/timer.c | 27 ++++++---------------------
 2 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 1c1d5199500e..86a2f2d0cb27 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -287,7 +287,6 @@ int kvm_arch_hardware_enable(void)
 	if (env & CSR_GCFG_MATC_ROOT)
 		gcfg |= CSR_GCFG_MATC_ROOT;
 
-	gcfg |= CSR_GCFG_TIT;
 	write_csr_gcfg(gcfg);
 
 	kvm_flush_tlb_all();
diff --git a/arch/loongarch/kvm/timer.c b/arch/loongarch/kvm/timer.c
index 284bf553fefe..1d29bd21a9da 100644
--- a/arch/loongarch/kvm/timer.c
+++ b/arch/loongarch/kvm/timer.c
@@ -70,15 +70,6 @@ void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long timer_hz)
  */
 void kvm_acquire_timer(struct kvm_vcpu *vcpu)
 {
-	unsigned long cfg;
-
-	cfg = read_csr_gcfg();
-	if (!(cfg & CSR_GCFG_TIT))
-		return;
-
-	/* Enable guest access to hard timer */
-	write_csr_gcfg(cfg & ~CSR_GCFG_TIT);
-
 	/*
 	 * Freeze the soft-timer and sync the guest stable timer with it. We do
 	 * this with interrupts disabled to avoid latency.
@@ -168,21 +159,15 @@ static void _kvm_save_timer(struct kvm_vcpu *vcpu)
  */
 void kvm_save_timer(struct kvm_vcpu *vcpu)
 {
-	unsigned long cfg;
 	struct loongarch_csrs *csr = vcpu->arch.csr;
 
 	preempt_disable();
-	cfg = read_csr_gcfg();
-	if (!(cfg & CSR_GCFG_TIT)) {
-		/* Disable guest use of hard timer */
-		write_csr_gcfg(cfg | CSR_GCFG_TIT);
-
-		/* Save hard timer state */
-		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TCFG);
-		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TVAL);
-		if (kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TCFG) & CSR_TCFG_EN)
-			_kvm_save_timer(vcpu);
-	}
+
+	/* Save hard timer state */
+	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TCFG);
+	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TVAL);
+	if (kvm_read_sw_gcsr(csr, LOONGARCH_CSR_TCFG) & CSR_TCFG_EN)
+		_kvm_save_timer(vcpu);
 
 	/* Save timer-related state to vCPU context */
 	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ESTAT);
-- 
2.39.3


