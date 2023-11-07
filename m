Return-Path: <kvm+bounces-870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D0887E3B6B
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 13:04:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52A391C20C56
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 12:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68002DF97;
	Tue,  7 Nov 2023 12:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA582D7B7
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:04:22 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7163F7;
	Tue,  7 Nov 2023 04:04:19 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxEvDAJ0pl3aw3AA--.43296S3;
	Tue, 07 Nov 2023 20:04:16 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Axji+_J0plPBo7AA--.63299S3;
	Tue, 07 Nov 2023 20:04:16 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
Date: Tue,  7 Nov 2023 20:04:12 +0800
Message-Id: <20231107120414.1927261-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107120414.1927261-1-maobibo@loongson.cn>
References: <20231107120414.1927261-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Axji+_J0plPBo7AA--.63299S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7ur45Ar18Wr1kJF4UAw48KrX_yoW8uF1DpF
	W7Crnaqw4rGrn7G3srtw4kWr47Xw4kKF1fZasrAFWrAr4qyF18tF4rKrWqqFy5Kw4rCa4f
	Zr1rK3W5uFn8A3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UUUUU==

When idle instruction is emulation, kvm will check whether there is
pending interrupts including timer interrupt. HW timer event checking is
used now, so it is not necessary to switch to sw timer during vcpu block
checking flow, since hw timer pending interrupt can be set directly with
CSR staus register. This patch adds preemption disabling during checking
hw CSR status register, and removes SW timer mode switching in idle
instruction emulation function.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 13 +------------
 arch/loongarch/kvm/vcpu.c |  9 ++++++++-
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ce8de3fa472c..87ffa5d5a8bf 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -200,18 +200,7 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
 	++vcpu->stat.idle_exits;
 	trace_kvm_exit_idle(vcpu, KVM_TRACE_EXIT_IDLE);
 
-	if (!kvm_arch_vcpu_runnable(vcpu)) {
-		/*
-		 * Switch to the software timer before halt-polling/blocking as
-		 * the guest's timer may be a break event for the vCPU, and the
-		 * hypervisor timer runs only when the CPU is in guest mode.
-		 * Switch before halt-polling so that KVM recognizes an expired
-		 * timer before blocking.
-		 */
-		kvm_save_timer(vcpu);
-		kvm_vcpu_block(vcpu);
-	}
-
+	kvm_vcpu_halt(vcpu);
 	return EMULATE_DONE;
 }
 
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 73d0c2b9c1a5..42663a345bd1 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -187,8 +187,15 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return kvm_pending_timer(vcpu) ||
+	int ret;
+
+	/* protect from TOD sync and vcpu_load/put */
+	preempt_disable();
+	ret = kvm_pending_timer(vcpu) ||
 		kvm_read_hw_gcsr(LOONGARCH_CSR_ESTAT) & (1 << INT_TI);
+	preempt_enable();
+
+	return ret;
 }
 
 int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
-- 
2.39.3


