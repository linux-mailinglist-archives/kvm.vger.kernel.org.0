Return-Path: <kvm+bounces-40749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B577A5BA23
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 08:48:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1357E1895DF4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 07:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD50222258F;
	Tue, 11 Mar 2025 07:47:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741A01EB18E;
	Tue, 11 Mar 2025 07:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741679274; cv=none; b=uwCg1sm0d/TBzDxyjR6t81fqcopGkVDaeeR5ME7bJAILPxbJQPyiPmarYyvr+9/ovjC5L2uqSVBqFryiLq4AOpjHQp9ioNDUvAX2YMp4YSVd3zTDnLHl/JRo/GPsCAlkCeA/xQvKfWBiwCah/FnQKRejRXBe4P7jpivaB58T7fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741679274; c=relaxed/simple;
	bh=+l3iPjheBoeLozTPt32yAmzmdqxEEahv2vrn37d3eo4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aD2PTi5Yq9AjMHcRQ19rpne94pZfWAa7qUTjqfNatduYXUS4M1ec0j9mjkPpj4XzTec2+3guBdkOx3crWmr9eo9uJzZuZcsfR4KlwxXBF7ByoKghdRahzunNpPd4CoG5bqJWIIbEy1seAn1OZ1rKO0PR9VCVkhe1eQn5XmpJ4Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxG6yb6s9noJCRAA--.19244S3;
	Tue, 11 Mar 2025 15:47:39 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMCx7MSa6s9nrV5DAA--.52282S2;
	Tue, 11 Mar 2025 15:47:38 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC V2] LoongArch: KVM: Handle interrupt early before enabling irq
Date: Tue, 11 Mar 2025 15:47:37 +0800
Message-Id: <20250311074737.3160546-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCx7MSa6s9nrV5DAA--.52282S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

If interrupt arrive when vCPU is running, vCPU will exit because of
interrupt exception. Currently interrupt exception is handled after
local_irq_enable() is called, and it is handled by host kernel rather
than KVM hypervisor. It will introduce extra another interrupt
exception and then host will handle irq.

If KVM hypervisor detect that it is interrupt exception, interrupt
can be handle early in KVM hypervisor before local_irq_enable() is
called.

On 3C5000 dual-way machine, there will be 10% -- 15% performance
improvement with netperf UDP_RR option with 10G ethernet card.
                   original     with patch    improvement
  netperf UDP_RR     7200          8100           +12%

The total performance is low because irqchip is emulated in qemu VMM,
however from the same testbed, there is performance improvement
actually.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
v1 ... v2:
  1. Move guest_timing_exit_irqoff() after host interrupt handling like
     other architectures.
  2. Construct interrupt context pt_regs from guest entering context
  3. Add cond_resched() after irq enabling
---
 arch/loongarch/kernel/traps.c |  1 +
 arch/loongarch/kvm/vcpu.c     | 36 ++++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/traps.c b/arch/loongarch/kernel/traps.c
index 2ec3106c0da3..eed0d8b02ee3 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -1114,6 +1114,7 @@ asmlinkage void noinstr do_vint(struct pt_regs *regs, unsigned long sp)
 
 	irqentry_exit(regs, state);
 }
+EXPORT_SYMBOL(do_vint);
 
 unsigned long eentry;
 unsigned long tlbrentry;
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 9e1a9b4aa4c6..bab7a71eb965 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -5,6 +5,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/entry-kvm.h>
+#include <asm/exception.h>
 #include <asm/fpu.h>
 #include <asm/lbt.h>
 #include <asm/loongarch.h>
@@ -304,6 +305,23 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static void kvm_handle_irq(struct kvm_vcpu *vcpu)
+{
+	struct pt_regs regs, *old;
+
+	/*
+	 * Construct pseudo pt_regs, only necessary registers is added
+	 * Interrupt context coming from guest enter context
+	 */
+	old = (struct pt_regs *)(vcpu->arch.host_sp - sizeof(struct pt_regs));
+	/* Disable preemption in irq exit function irqentry_exit() */
+	regs.csr_prmd = 0;
+	regs.regs[LOONGARCH_GPR_SP] = vcpu->arch.host_sp;
+	regs.regs[LOONGARCH_GPR_FP] = old->regs[LOONGARCH_GPR_FP];
+	regs.csr_era = old->regs[LOONGARCH_GPR_RA];
+	do_vint(&regs, (unsigned long)&regs);
+}
+
 /*
  * Return 1 for resume guest and "<= 0" for resume host.
  */
@@ -321,8 +339,23 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 
 	kvm_lose_pmu(vcpu);
 
-	guest_timing_exit_irqoff();
 	guest_state_exit_irqoff();
+
+	/*
+	 * VM exit because of host interrupts
+	 * Handle irq directly before enabling irq
+	 */
+	if (!ecode && intr)
+		kvm_handle_irq(vcpu);
+
+	/*
+	 * Wait until after servicing IRQs to account guest time so that any
+	 * ticks that occurred while running the guest are properly accounted
+	 * to the guest. Waiting until IRQs are enabled degrades the accuracy
+	 * of accounting via context tracking, but the loss of accuracy is
+	 * acceptable for all known use cases.
+	 */
+	guest_timing_exit_irqoff();
 	local_irq_enable();
 
 	trace_kvm_exit(vcpu, ecode);
@@ -331,6 +364,7 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	} else {
 		WARN(!intr, "vm exiting with suspicious irq\n");
 		++vcpu->stat.int_exits;
+		cond_resched();
 	}
 
 	if (ret == RESUME_GUEST)

base-commit: 80e54e84911a923c40d7bee33a34c1b4be148d7a
-- 
2.39.3


