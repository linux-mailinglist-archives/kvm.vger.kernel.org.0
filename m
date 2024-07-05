Return-Path: <kvm+bounces-21019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6550E9280A5
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D4B51C21494
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAA1B71750;
	Fri,  5 Jul 2024 02:56:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0EB1CA85;
	Fri,  5 Jul 2024 02:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148184; cv=none; b=ehb3Ind2Xeo/FJTRA+I7R75Fnj61+VQ0WwYKMTxqDJZO2N/sVxNko9UIWfQdL6IDjZ91NMWJTdoCYmrajeKeQWx0G8NXlRO0JCoBKrsclQWGWm6/D4tPETV+7P00pJwY8A3mUukSCh0Zxiegsfo4I3JyERFvBPbLz3YPC2cWjFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148184; c=relaxed/simple;
	bh=O4KKVghcv+cTrLdgP5UC2ArWzrQJL+9dZ0Oa8NnWZsg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LCTT4vusiyveTo+UVwmOW94Opu9JijIuc1uClb777Ytw1AN4UH1aMjuGVS45YF617XgqxUy6Uhbi4h3sN+X+v99MHK2MDRZq/om79pcKEjf/wW/HT2B5ls9d+o54YLGOyEsjYguVsMg3uQzUI6pvX6RzbLPRbWF0PJmZtqRi01U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Axz+vUYIdm6SQBAA--.3556S3;
	Fri, 05 Jul 2024 10:56:20 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWcbRYIdm3tE7AA--.7292S5;
	Fri, 05 Jul 2024 10:56:19 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Min Zhou <zhoumin@loongson.cn>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH 03/11] LoongArch: KVM: Add IPI read and write function
Date: Fri,  5 Jul 2024 10:38:46 +0800
Message-Id: <20240705023854.1005258-4-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20240705023854.1005258-1-lixianglai@loongson.cn>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxWcbRYIdm3tE7AA--.7292S5
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implementation of IPI interrupt controller address
space read and write function simulation.

Signed-off-by: Min Zhou <zhoumin@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Min Zhou <zhoumin@loongson.cn> 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/asm/kvm_host.h |   2 +
 arch/loongarch/include/asm/kvm_ipi.h  |  16 ++
 arch/loongarch/kvm/intc/ipi.c         | 287 +++++++++++++++++++++++++-
 3 files changed, 303 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 4f6ccc688c1b..b28487975336 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -41,6 +41,8 @@ struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 	u64 pages;
 	u64 hugepages;
+	u64 ipi_read_exits;
+	u64 ipi_write_exits;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/loongarch/include/asm/kvm_ipi.h b/arch/loongarch/include/asm/kvm_ipi.h
index 875a93008802..729dfc1e3f40 100644
--- a/arch/loongarch/include/asm/kvm_ipi.h
+++ b/arch/loongarch/include/asm/kvm_ipi.h
@@ -29,8 +29,24 @@ struct ipi_state {
 #define SMP_MAILBOX			0x1000
 #define KVM_IOCSR_IPI_ADDR_SIZE		0x48
 
+#define CORE_STATUS_OFF			0x000
+#define CORE_EN_OFF			0x004
+#define CORE_SET_OFF			0x008
+#define CORE_CLEAR_OFF			0x00c
+#define CORE_BUF_20			0x020
+#define CORE_BUF_28			0x028
+#define CORE_BUF_30			0x030
+#define CORE_BUF_38			0x038
+#define IOCSR_IPI_SEND			0x040
+
+#define IOCSR_MAIL_SEND			0x048
+#define IOCSR_ANY_SEND			0x158
+
 #define MAIL_SEND_ADDR			(SMP_MAILBOX + IOCSR_MAIL_SEND)
 #define KVM_IOCSR_MAIL_ADDR_SIZE	0x118
 
+#define MAIL_SEND_OFFSET		0
+#define ANY_SEND_OFFSET			(IOCSR_ANY_SEND - IOCSR_MAIL_SEND)
+
 int kvm_loongarch_register_ipi_device(void);
 #endif
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index a9dc0aaec502..815858671005 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -7,24 +7,307 @@
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
+	action = 1 << (data & 0x1f);
+
+	spin_lock(&vcpu->arch.ipi_state.lock);
+	status = vcpu->arch.ipi_state.status;
+	vcpu->arch.ipi_state.status |= action;
+	if (status == 0) {
+		irq.irq = LARCH_INT_IPI;
+		kvm_vcpu_ioctl_interrupt(vcpu, &irq);
+	}
+	spin_unlock(&vcpu->arch.ipi_state.lock);
+}
+
+static void ipi_clear(struct kvm_vcpu *vcpu, uint64_t data)
+{
+	struct kvm_interrupt irq;
+
+	spin_lock(&vcpu->arch.ipi_state.lock);
+	vcpu->arch.ipi_state.status &= ~data;
+	if (!vcpu->arch.ipi_state.status) {
+		irq.irq = -LARCH_INT_IPI;
+		kvm_vcpu_ioctl_interrupt(vcpu, &irq);
+	}
+	spin_unlock(&vcpu->arch.ipi_state.lock);
+}
+
+static uint64_t read_mailbox(struct kvm_vcpu *vcpu, int offset, int len)
+{
+	void *pbuf;
+	uint64_t ret = 0;
+
+	spin_lock(&vcpu->arch.ipi_state.lock);
+	pbuf = (void *)vcpu->arch.ipi_state.buf + (offset - 0x20);
+	if (len == 1)
+		ret = *(unsigned char *)pbuf;
+	else if (len == 2)
+		ret = *(unsigned short *)pbuf;
+	else if (len == 4)
+		ret = *(unsigned int *)pbuf;
+	else if (len == 8)
+		ret = *(unsigned long *)pbuf;
+	else
+		kvm_err("%s: unknown data len: %d\n", __func__, len);
+	spin_unlock(&vcpu->arch.ipi_state.lock);
+
+	return ret;
+}
+
+static void write_mailbox(struct kvm_vcpu *vcpu, int offset,
+			uint64_t data, int len)
+{
+	void *pbuf;
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
+		kvm_err("%s: unknown data len: %d\n", __func__, len);
+	spin_unlock(&vcpu->arch.ipi_state.lock);
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
+	case CORE_STATUS_OFF:
+		kvm_err("CORE_SET_OFF Can't be write\n");
+		ret = -EINVAL;
+		break;
+	case CORE_EN_OFF:
+		spin_lock(&vcpu->arch.ipi_state.lock);
+		vcpu->arch.ipi_state.en = data;
+		spin_unlock(&vcpu->arch.ipi_state.lock);
+		break;
+	case IOCSR_IPI_SEND:
+		ipi_send(vcpu->kvm, data);
+		break;
+	case CORE_SET_OFF:
+		kvm_info("CORE_SET_OFF simulation is required\n");
+		ret = -EINVAL;
+		break;
+	case CORE_CLEAR_OFF:
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
+	default:
+		kvm_err("%s: unknown addr: %llx\n", __func__, addr);
+		ret = -EINVAL;
+		break;
+	}
+
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
+	case CORE_STATUS_OFF:
+		spin_lock(&vcpu->arch.ipi_state.lock);
+		res = vcpu->arch.ipi_state.status;
+		spin_unlock(&vcpu->arch.ipi_state.lock);
+		break;
+	case CORE_EN_OFF:
+		spin_lock(&vcpu->arch.ipi_state.lock);
+		res = vcpu->arch.ipi_state.en;
+		spin_unlock(&vcpu->arch.ipi_state.lock);
+		break;
+	case CORE_SET_OFF:
+		res = 0;
+		break;
+	case CORE_CLEAR_OFF:
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
+
+	*(uint64_t *)val = res;
+
+	return ret;
+}
+
 static int kvm_loongarch_ipi_write(struct kvm_vcpu *vcpu,
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
+
+	ipi->kvm->stat.ipi_write_exits++;
+	ret = loongarch_ipi_writel(vcpu, addr, len, val);
+
+	return ret;
 }
 
 static int kvm_loongarch_ipi_read(struct kvm_vcpu *vcpu,
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
+
+	ipi->kvm->stat.ipi_read_exits++;
+	ret = loongarch_ipi_readl(vcpu, addr, len, val);
+
+	return ret;
+}
+
+static void send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
+{
+	int i;
+	uint32_t val = 0, mask = 0;
+	/*
+	 * Bit 27-30 is mask for byte writing.
+	 * If the mask is 0, we need not to do anything.
+	 */
+	if ((data >> 27) & 0xf) {
+		/* Read the old val */
+		kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+
+		/* Construct the mask by scanning the bit 27-30 */
+		for (i = 0; i < 4; i++) {
+			if (data & (0x1 << (27 + i)))
+				mask |= (0xff << (i * 8));
+		}
+	/* Save the old part of val */
+		val &= mask;
+	}
+
+	val |= ((uint32_t)(data >> 32) & ~mask);
+	kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+}
+
+static void mail_send(struct kvm *kvm, uint64_t data)
+{
+	struct kvm_vcpu *vcpu;
+	int cpu, mailbox;
+	int offset;
+
+	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
+	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
+	if (unlikely(vcpu == NULL)) {
+		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
+		return;
+	}
+
+	mailbox = ((data & 0xffffffff) >> 2) & 0x7;
+	offset = SMP_MAILBOX + CORE_BUF_20 + mailbox * 4;
+	send_ipi_data(vcpu, offset, data);
+}
+
+static void any_send(struct kvm *kvm, uint64_t data)
+{
+	struct kvm_vcpu *vcpu;
+	int cpu, offset;
+
+	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
+	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
+	if (unlikely(vcpu == NULL)) {
+		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
+		return;
+	}
+
+	offset = data & 0xffff;
+	send_ipi_data(vcpu, offset, data);
 }
 
 static int kvm_loongarch_mail_write(struct kvm_vcpu *vcpu,
 			struct kvm_io_device *dev,
 			gpa_t addr, int len, const void *val)
 {
+	struct loongarch_ipi *ipi;
+
+	ipi = vcpu->kvm->arch.ipi;
+	if (!ipi) {
+		kvm_err("%s: ipi irqchip not valid!\n", __func__);
+		return -EINVAL;
+	}
+
+	addr &= 0xfff;
+	addr -= IOCSR_MAIL_SEND;
+
+	switch (addr) {
+	case MAIL_SEND_OFFSET:
+		mail_send(vcpu->kvm, *(uint64_t *)val);
+		break;
+	case ANY_SEND_OFFSET:
+		any_send(vcpu->kvm, *(uint64_t *)val);
+		break;
+	default:
+		break;
+	}
+
 	return 0;
 }
 
-- 
2.39.1


