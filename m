Return-Path: <kvm+bounces-38654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B466A3D38D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 09:46:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 699B63B6D59
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 08:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 104A01EBA0B;
	Thu, 20 Feb 2025 08:44:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A048A1E9B36;
	Thu, 20 Feb 2025 08:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740041076; cv=none; b=gmJYO/aNQTLs76rnMMGKZIVOlTh1ctDXJCAlgqvMCkC8m/rs3NnRCLq0vQsAfaxrbNTQ7D2YuEWOLBAczpKIEEhNe9RSuK720d+36ty8qkwSl1gmZlEh/Xm1okJs4qbg0FmvGdOj9Ro+3k4eMz5IvBnYQSE1Kwr3kf+8U53IIzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740041076; c=relaxed/simple;
	bh=6+WfYSvPN9wYhd23shFQB9I2w3/8Wmt3Of+LUyAJjXw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hTkHq1tV/Gi3v2eX908LUUfk1hbTKQ52DJqiAzOto236YsVY0Tb9KlRaZrcmdLCOWVle0C8T86FvCdymYl4sigcPreCI4+BWMRsNUjEhD+rD9hN1EshZnnXJ6VXhMBVrlaV/EB35k1u6KLdtqKEo3eVlqvjdskogu8vu5shfR28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxaWoc67ZnZxF8AA--.17651S3;
	Thu, 20 Feb 2025 16:43:08 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDx_MQa67ZntvQdAA--.44622S2;
	Thu, 20 Feb 2025 16:43:07 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC] LoongArch: KVM: Handle interrupt early before enabling irq
Date: Thu, 20 Feb 2025 16:43:06 +0800
Message-Id: <20250220084306.323967-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDx_MQa67ZntvQdAA--.44622S2
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
 arch/loongarch/kernel/traps.c |  1 +
 arch/loongarch/kvm/vcpu.c     | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

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
index 20f941af3e9e..775f7aa6d904 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -5,6 +5,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/entry-kvm.h>
+#include <asm/exception.h>
 #include <asm/fpu.h>
 #include <asm/lbt.h>
 #include <asm/loongarch.h>
@@ -304,6 +305,17 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static void kvm_handle_irq(struct kvm_vcpu *vcpu)
+{
+	struct pt_regs regs;
+
+	/* Construct pseudo pt_regs, only necessary registers is added */
+	regs.csr_prmd = CSR_PRMD_PIE;
+	regs.csr_era = vcpu->arch.pc;
+	regs.regs[3] = vcpu->arch.host_sp;
+	do_vint(&regs, (unsigned long)&regs);
+}
+
 /*
  * Return 1 for resume guest and "<= 0" for resume host.
  */
@@ -323,6 +335,12 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 
 	guest_timing_exit_irqoff();
 	guest_state_exit_irqoff();
+	/*
+	 * VM exit because of host interrupt
+	 * Handle irq directly before enabling irq
+	 */
+	if (!ecode && intr)
+		kvm_handle_irq(vcpu);
 	local_irq_enable();
 
 	trace_kvm_exit(vcpu, ecode);

base-commit: 2408a807bfc3f738850ef5ad5e3fd59d66168996
-- 
2.39.3


