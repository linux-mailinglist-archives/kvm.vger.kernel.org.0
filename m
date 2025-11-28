Return-Path: <kvm+bounces-64930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ECDBCC91791
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 10:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EBB2D4E48B8
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 09:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F047F306D23;
	Fri, 28 Nov 2025 09:36:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F29306492;
	Fri, 28 Nov 2025 09:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764322567; cv=none; b=s/uWXsKT0HxIh/9gEFvJYrIxSWsIFu9M+BtR5l21y+4MCtinWjRo66NvBgrtEeNN5rk2hPGG5KpVyVUl6uZqT1X17sZTS+3bVcEfsemmUxFxMNkGWvMfT8kYcn3hsboXFnlDvsPwEKFSaYG6nvELluYAYYl2pxtI2aE5J4cnnXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764322567; c=relaxed/simple;
	bh=LmrQReRHSxozkSK9E2ysPud58TfdTnGKefR7tZggujU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q9HJGcAS+Irv7Rpnx2GSrsIgiLcC+9ow7d1r8RBDYQTNSr6xiAb82dXtenSexYqArJKIXPafuLLx+XhoohqpwMhE4zkhF4HklL6B3alFPqmgI6Et5ytfhugffTKByAJA/dgKBNGrkyd4qT/JkipoMWGijM9ZkTCz8yqu0FRHtAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxrtPwbClpTA8pAA--.18072S3;
	Fri, 28 Nov 2025 17:35:44 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx2sDtbClpo+xBAQ--.23356S6;
	Fri, 28 Nov 2025 17:35:43 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] LongArch: KVM: Add dintc inject msi to the dest vcpu
Date: Fri, 28 Nov 2025 17:11:25 +0800
Message-Id: <20251128091125.2720148-5-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20251128091125.2720148-1-gaosong@loongson.cn>
References: <20251128091125.2720148-1-gaosong@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2sDtbClpo+xBAQ--.23356S6
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implement irqfd deliver msi to vcpu and
vcpu dintc inject irq.

Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  5 +++
 arch/loongarch/kvm/interrupt.c        |  1 +
 arch/loongarch/kvm/vcpu.c             | 55 +++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 7f6c4e7d241e..298e4b7c3769 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -256,6 +256,11 @@ struct kvm_vcpu_arch {
 	} st;
 };
 
+void loongarch_dintc_inject_irq(struct kvm_vcpu *vcpu);
+int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
+				struct kvm_vcpu *vcpu,
+				u32 vector, int level);
+
 static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
 {
 	return csr->csrs[reg];
diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
index a6d42d399a59..c74e7af3e772 100644
--- a/arch/loongarch/kvm/interrupt.c
+++ b/arch/loongarch/kvm/interrupt.c
@@ -33,6 +33,7 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 		irq = priority_to_irq[priority];
 
 	if (cpu_has_msgint && (priority == INT_AVEC)) {
+		loongarch_dintc_inject_irq(vcpu);
 		set_gcsr_estat(irq);
 		return 1;
 	}
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 1e7590fc1b47..84cf8b7c67dd 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -13,6 +13,61 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+void loongarch_dintc_inject_irq(struct kvm_vcpu *vcpu)
+{
+	struct dintc_state *ds = &vcpu->arch.dintc_state;
+	unsigned int i;
+	unsigned long temp[4], old;
+
+	if (!ds)
+		return;
+
+	for (i = 0; i < 4; i++) {
+		old = atomic64_read(&(ds->vector_map[i]));
+		if (old)
+			temp[i] = atomic64_xchg(&(ds->vector_map[i]), 0);
+	}
+
+	if (temp[0]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR0);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR0, temp[0]|old);
+	}
+	if (temp[1]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR1);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR1, temp[1]|old);
+	}
+	if (temp[2]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR2);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR2, temp[2]|old);
+	}
+	if (temp[3]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR3);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR3, temp[3]|old);
+	}
+}
+
+int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
+				struct kvm_vcpu *vcpu,
+				u32 vector, int level)
+{
+	struct kvm_interrupt vcpu_irq;
+	struct dintc_state *ds;
+
+	if (!level)
+		return 0;
+	if (!vcpu || vector >= 256)
+		return -EINVAL;
+	ds = &vcpu->arch.dintc_state;
+	if (!ds)
+		return -ENODEV;
+	set_bit(vector, (unsigned long *)&ds->vector_map);
+	vcpu_irq.irq = INT_AVEC;
+	kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
+	kvm_vcpu_kick(vcpu);
+	return 0;
+}
+
+
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, int_exits),
-- 
2.39.3


