Return-Path: <kvm+bounces-31214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 763DE9C14E8
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 04:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC7ADB240AA
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 03:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063FB1CF7B1;
	Fri,  8 Nov 2024 03:54:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EAB1C4609;
	Fri,  8 Nov 2024 03:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731038071; cv=none; b=CvOHwO3E2P5e44c7f3bRnfgSsDCsQm7UrXka+2zWbfJ8Hfp0K+6tUrSb7fRs5+Br61uva0sCVHRztxW3YAMfBYNoNFaC3Fh7mVyM/SwA6S6dUpcC1UNcXo8TEcK0BUUQrm2RM7H6PfOqmYDdRCreQvtj8MSCHzC/SL1LQQHjJIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731038071; c=relaxed/simple;
	bh=BFIc/S8n6dRH2WleFwHMjsNWU8WwoqPyM4odbvSNhKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FYDTHeJwS3yITsUXordORQyaQ3UQDCjHgoj/jdZsVXydydXwxwvHEIgFpy7kRb7xuLYJEH7lcsTsWzgc9pIgN1C/7T1pQr/eTqDrptWM6oseX1+GLYI9hbqLuF0YcVlVkXJ5pPwDuRh7xTN2tkdCR3SVpRxlc8OYc8z7d+RJGUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8BxYa9wiy1nvNg4AA--.46953S3;
	Fri, 08 Nov 2024 11:54:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMBxrsJtiy1nITRMAA--.38809S4;
	Fri, 08 Nov 2024 11:54:23 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Min Zhou <zhoumin@loongson.cn>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH V4 03/11] LoongArch: KVM: Add IPI read and write function
Date: Fri,  8 Nov 2024 11:35:50 +0800
Message-Id: <20241108033558.2727612-3-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20241108033558.2727612-1-lixianglai@loongson.cn>
References: <20241108033437.2727574-1-lixianglai@loongson.cn>
 <20241108033558.2727612-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxrsJtiy1nITRMAA--.38809S4
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add implementation of IPI interrupt controller's address space read and
write function simulation.

Signed-off-by: Min Zhou <zhoumin@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/asm/kvm_host.h |   2 +
 arch/loongarch/include/asm/kvm_ipi.h  |  13 ++
 arch/loongarch/kvm/intc/ipi.c         | 272 +++++++++++++++++++++++++-
 3 files changed, 285 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 8e5393d21fcb..a1de884ebb44 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -45,6 +45,8 @@ struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 	u64 pages;
 	u64 hugepages;
+	u64 ipi_read_exits;
+	u64 ipi_write_exits;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/loongarch/include/asm/kvm_ipi.h b/arch/loongarch/include/asm/kvm_ipi.h
index 714c51626a19..830915e74c87 100644
--- a/arch/loongarch/include/asm/kvm_ipi.h
+++ b/arch/loongarch/include/asm/kvm_ipi.h
@@ -28,6 +28,19 @@ struct ipi_state {
 #define SMP_MAILBOX			0x1000
 #define KVM_IOCSR_IPI_ADDR_SIZE		0x160
 
+#define CORE_STATUS			0x000
+#define CORE_EN				0x004
+#define CORE_SET			0x008
+#define CORE_CLEAR			0x00c
+#define CORE_BUF_20			0x020
+#define CORE_BUF_28			0x028
+#define CORE_BUF_30			0x030
+#define CORE_BUF_38			0x038
+
+#define IOCSR_IPI_SEND			0x040
+#define IOCSR_MAIL_SEND			0x048
+#define IOCSR_ANY_SEND			0x158
+
 int kvm_loongarch_register_ipi_device(void);
 
 #endif
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index 541b54a558e6..b3ff83b1ac27 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -7,18 +7,286 @@
 #include <asm/kvm_ipi.h>
 #include <asm/kvm_vcpu.h>
 
+static void ipi_send(struct kvm *kvm, uint64_t data)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_interrupt irq;
+	int cpu, action, status;
+
+	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
+	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
+	if (unlikely(vcpu == NULL)) {
+		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
+		return;
+	}
+
+	action = BIT(data & 0x1f);
+	spin_lock(&vcpu->arch.ipi_state.lock);
+	status = vcpu->arch.ipi_state.status;
+	vcpu->arch.ipi_state.status |= action;
+	spin_unlock(&vcpu->arch.ipi_state.lock);
+	if (status == 0) {
+		irq.irq = LARCH_INT_IPI;
+		kvm_vcpu_ioctl_interrupt(vcpu, &irq);
+	}
+}
+
+static void ipi_clear(struct kvm_vcpu *vcpu, uint64_t data)
+{
+	struct kvm_interrupt irq;
+	uint32_t status;
+
+	spin_lock(&vcpu->arch.ipi_state.lock);
+	vcpu->arch.ipi_state.status &= ~data;
+	status = vcpu->arch.ipi_state.status;
+	spin_unlock(&vcpu->arch.ipi_state.lock);
+	if (!status) {
+		irq.irq = -LARCH_INT_IPI;
+		kvm_vcpu_ioctl_interrupt(vcpu, &irq);
+	}
+}
+
+static uint64_t read_mailbox(struct kvm_vcpu *vcpu, int offset, int len)
+{
+	uint64_t ret = 0;
+	uint64_t data = 0;
+
+	spin_lock(&vcpu->arch.ipi_state.lock);
+	data = *(ulong *)((void *)vcpu->arch.ipi_state.buf + (offset - 0x20));
+	spin_unlock(&vcpu->arch.ipi_state.lock);
+
+	if (len == 1)
+		ret = data & 0xff;
+	else if (len == 2)
+		ret = data & 0xffff;
+	else if (len == 4)
+		ret = data & 0xffffffff;
+	else if (len == 8)
+		ret = data;
+	else
+		kvm_err("%s: unknown data len: %d\n", __func__, len);
+	return ret;
+}
+
+static void write_mailbox(struct kvm_vcpu *vcpu, int offset,
+			uint64_t data, int len)
+{
+	void *pbuf;
+	bool bad_width = false;
+
+	spin_lock(&vcpu->arch.ipi_state.lock);
+	pbuf = (void *)vcpu->arch.ipi_state.buf + (offset - 0x20);
+	if (len == 1)
+		*(unsigned char *)pbuf = (unsigned char)data;
+	else if (len == 2)
+		*(unsigned short *)pbuf = (unsigned short)data;
+	else if (len == 4)
+		*(unsigned int *)pbuf = (unsigned int)data;
+	else if (len == 8)
+		*(unsigned long *)pbuf = (unsigned long)data;
+	else
+		bad_width = true;
+	spin_unlock(&vcpu->arch.ipi_state.lock);
+	if (bad_width)
+		kvm_err("%s: unknown data len: %d\n", __func__, len);
+}
+
+static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
+{
+	int i, ret;
+	uint32_t val = 0, mask = 0;
+	/*
+	 * Bit 27-30 is mask for byte writing.
+	 * If the mask is 0, we need not to do anything.
+	 */
+	if ((data >> 27) & 0xf) {
+		/* Read the old val */
+		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+		if (unlikely(ret)) {
+			kvm_err("%s: : read date from addr %llx failed\n", __func__, addr);
+			return ret;
+		}
+		/* Construct the mask by scanning the bit 27-30 */
+		for (i = 0; i < 4; i++) {
+			if (data & (BIT(27 + i)))
+				mask |= (0xff << (i * 8));
+		}
+	/* Save the old part of val */
+		val &= mask;
+	}
+	val |= ((uint32_t)(data >> 32) & ~mask);
+	ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+	if (unlikely(ret))
+		kvm_err("%s: : write date to addr %llx failed\n", __func__, addr);
+	return ret;
+}
+
+static int mail_send(struct kvm *kvm, uint64_t data)
+{
+	struct kvm_vcpu *vcpu;
+	int cpu, mailbox;
+	int offset, ret;
+
+	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
+	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
+	if (unlikely(vcpu == NULL)) {
+		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
+		return -EINVAL;
+	}
+	mailbox = ((data & 0xffffffff) >> 2) & 0x7;
+	offset = SMP_MAILBOX + CORE_BUF_20 + mailbox * 4;
+	ret = send_ipi_data(vcpu, offset, data);
+	return ret;
+}
+
+static int any_send(struct kvm *kvm, uint64_t data)
+{
+	struct kvm_vcpu *vcpu;
+	int cpu, offset, ret;
+
+	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
+	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
+	if (unlikely(vcpu == NULL)) {
+		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
+		return -EINVAL;
+	}
+	offset = data & 0xffff;
+	ret = send_ipi_data(vcpu, offset, data);
+	return ret;
+}
+
+static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr,
+				int len, const void *val)
+{
+	uint64_t data;
+	uint32_t offset;
+	int ret = 0;
+
+	data = *(uint64_t *)val;
+
+	offset = (uint32_t)(addr & 0xff);
+	WARN_ON_ONCE(offset & (len - 1));
+
+	switch (offset) {
+	case CORE_STATUS:
+		kvm_err("CORE_STATUS Can't be write\n");
+		ret = -EINVAL;
+		break;
+	case CORE_EN:
+		spin_lock(&vcpu->arch.ipi_state.lock);
+		vcpu->arch.ipi_state.en = data;
+		spin_unlock(&vcpu->arch.ipi_state.lock);
+		break;
+	case IOCSR_IPI_SEND:
+		ipi_send(vcpu->kvm, data);
+		break;
+	case CORE_SET:
+		ret = -EINVAL;
+		break;
+	case CORE_CLEAR:
+		/* Just clear the status of the current vcpu */
+		ipi_clear(vcpu, data);
+		break;
+	case CORE_BUF_20 ... CORE_BUF_38 + 7:
+		if (offset + len > CORE_BUF_38 + 8) {
+			kvm_err("%s: invalid offset or len: offset = %d, len = %d\n",
+				__func__, offset, len);
+			ret = -EINVAL;
+			break;
+		}
+		write_mailbox(vcpu, offset, data, len);
+		break;
+	case IOCSR_MAIL_SEND:
+		ret = mail_send(vcpu->kvm, *(uint64_t *)val);
+		break;
+	case IOCSR_ANY_SEND:
+		ret = any_send(vcpu->kvm, *(uint64_t *)val);
+		break;
+	default:
+		kvm_err("%s: unknown addr: %llx\n", __func__, addr);
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int loongarch_ipi_readl(struct kvm_vcpu *vcpu, gpa_t addr,
+				int len, void *val)
+{
+	uint32_t offset;
+	uint64_t res = 0;
+	int ret = 0;
+
+	offset = (uint32_t)(addr & 0xff);
+	WARN_ON_ONCE(offset & (len - 1));
+
+	switch (offset) {
+	case CORE_STATUS:
+		spin_lock(&vcpu->arch.ipi_state.lock);
+		res = vcpu->arch.ipi_state.status;
+		spin_unlock(&vcpu->arch.ipi_state.lock);
+		break;
+	case CORE_EN:
+		spin_lock(&vcpu->arch.ipi_state.lock);
+		res = vcpu->arch.ipi_state.en;
+		spin_unlock(&vcpu->arch.ipi_state.lock);
+		break;
+	case CORE_SET:
+		res = 0;
+		break;
+	case CORE_CLEAR:
+		res = 0;
+		break;
+	case CORE_BUF_20 ... CORE_BUF_38 + 7:
+		if (offset + len > CORE_BUF_38 + 8) {
+			kvm_err("%s: invalid offset or len: offset = %d, len = %d\n",
+				__func__, offset, len);
+			ret = -EINVAL;
+			break;
+		}
+		res = read_mailbox(vcpu, offset, len);
+		break;
+	default:
+		kvm_err("%s: unknown addr: %llx\n", __func__, addr);
+		ret = -EINVAL;
+		break;
+	}
+	*(uint64_t *)val = res;
+	return ret;
+}
+
 static int kvm_ipi_write(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, const void *val)
 {
-	return 0;
+	struct loongarch_ipi *ipi;
+	int ret;
+
+	ipi = vcpu->kvm->arch.ipi;
+	if (!ipi) {
+		kvm_err("%s: ipi irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+	ipi->kvm->stat.ipi_write_exits++;
+	ret = loongarch_ipi_writel(vcpu, addr, len, val);
+	return ret;
 }
 
 static int kvm_ipi_read(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, void *val)
 {
-	return 0;
+	struct loongarch_ipi *ipi;
+	int ret;
+
+	ipi = vcpu->kvm->arch.ipi;
+	if (!ipi) {
+		kvm_err("%s: ipi irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+	ipi->kvm->stat.ipi_read_exits++;
+	ret = loongarch_ipi_readl(vcpu, addr, len, val);
+	return ret;
 }
 
 static const struct kvm_io_device_ops kvm_ipi_ops = {
-- 
2.39.1


