Return-Path: <kvm+bounces-66254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A64ECCCBA91
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 12:43:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 425BC3051D28
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 11:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D150E31AAA8;
	Thu, 18 Dec 2025 11:43:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F1430FC0E;
	Thu, 18 Dec 2025 11:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766058186; cv=none; b=K5ZrPV2Dl9Tz66txVbP5+qA7MxO8Pre4KvqIJ1nCpvqIIV7K3cFOctUc4iz1FLi3DgXtSMJpTiekv6Dy2DMIFwraBek1jvrChsW4r8z9zOd6u1ZL5FJ7s+7Ho+kjJhEQFzZS43dRE3vP/TLuX8hstikRRJwb460OxU9LoxDgn5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766058186; c=relaxed/simple;
	bh=9QyFcRZoxFWyf7EPiJgnXOZ1FZksLQqrTHbHvpRcKIY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RB7kKWstG1+iO/hCczfZP5FKTNuv3RcGF5X+AREMUgF19gzogVpSnI7iwpiO6FfPYsEM1wZRQob9iF5TvN0r9X157KL/gbVRCmgMvYhcS6chVLa+yTp/34mxsw96URrbzxMnYlzJASIqUHlfYslF+LKVa60IHiBsaMYrD+SRUKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxqsK96ENpa3QAAA--.1380S3;
	Thu, 18 Dec 2025 19:42:53 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx2+C56ENpqFABAA--.5610S5;
	Thu, 18 Dec 2025 19:42:52 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] LongArch: KVM: Add dmsintc inject msi to the dest vcpu
Date: Thu, 18 Dec 2025 19:18:22 +0800
Message-Id: <20251218111822.975455-4-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20251218111822.975455-1-gaosong@loongson.cn>
References: <20251218111822.975455-1-gaosong@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2+C56ENpqFABAA--.5610S5
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implement irqfd deliver msi to vcpu and
vcpu dmsintc inject irq.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  5 +++
 arch/loongarch/kvm/interrupt.c        |  1 +
 arch/loongarch/kvm/vcpu.c             | 58 +++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 5e9e2af7312f..91e0190aeaec 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -258,6 +258,11 @@ struct kvm_vcpu_arch {
 	} st;
 };
 
+void loongarch_dmsintc_inject_irq(struct kvm_vcpu *vcpu);
+int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
+				struct kvm_vcpu *vcpu,
+				u32 vector, int level);
+
 static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
 {
 	return csr->csrs[reg];
diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
index a6d42d399a59..893a81ca1079 100644
--- a/arch/loongarch/kvm/interrupt.c
+++ b/arch/loongarch/kvm/interrupt.c
@@ -33,6 +33,7 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 		irq = priority_to_irq[priority];
 
 	if (cpu_has_msgint && (priority == INT_AVEC)) {
+		loongarch_dmsintc_inject_irq(vcpu);
 		set_gcsr_estat(irq);
 		return 1;
 	}
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 656b954c1134..325bb084d704 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -14,6 +14,64 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+void loongarch_dmsintc_inject_irq(struct kvm_vcpu *vcpu)
+{
+	struct dmsintc_state *ds = &vcpu->arch.dmsintc_state;
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
+
+	if (temp[1]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR1);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR1, temp[1]|old);
+	}
+
+	if (temp[2]) {
+		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR2);
+		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR2, temp[2]|old);
+	}
+
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
+	struct dmsintc_state *ds;
+
+	if (!level)
+		return 0;
+	if (!vcpu || vector >= 256)
+		return -EINVAL;
+	ds = &vcpu->arch.dmsintc_state;
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


