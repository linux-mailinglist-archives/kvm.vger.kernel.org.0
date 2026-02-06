Return-Path: <kvm+bounces-70398-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aMWTEQJIhWkN/QMAu9opvQ
	(envelope-from <kvm+bounces-70398-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:46:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D69F902A
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:46:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D5ED3037402
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 01:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25F1A1DDC1B;
	Fri,  6 Feb 2026 01:45:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C229F246766;
	Fri,  6 Feb 2026 01:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770342340; cv=none; b=Z3nblS+tN6q+zK1UEam/p2l2NK4NXNx3V/mjCe1ZaUXNKj8DJ5qn1JoAEm+/PSl5to1TKiQ+b87O7c1HVqqNL+kjHmuMCFZLu1ZmQIBXt9RQuBfzniZay9fKGySy3tJfJwM7ZJVBBhqVUlqD+AR9UwWwbXBCzCwVJ3XHf64QQ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770342340; c=relaxed/simple;
	bh=/zn0VUc7CK32VJF6ENXxdrAntiY9+gI+WJBCMwhT1Sc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dng+4isscTp68CmAHEz/+rVZhD+TFjfXvMOqvzZFJ4YjOdO51/3RARWplLDtvEQjeHTCM8QRvTKBn/8shJEy3eM0naAS1BeetlSFH55+B8I30t1N6BZui0jlmVxIFhF/EZ0mwWJFBHtpXYjDvqRufuFADUlrvZrxoUHLMzlaoG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8BxHMO8R4Vp2FYQAA--.52092S3;
	Fri, 06 Feb 2026 09:45:32 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx98C3R4VpgLZAAA--.40823S3;
	Fri, 06 Feb 2026 09:45:31 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/2] LongArch: KVM: Add DMSINTC device support
Date: Fri,  6 Feb 2026 09:20:27 +0800
Message-Id: <20260206012028.3318291-2-gaosong@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20260206012028.3318291-1-gaosong@loongson.cn>
References: <20260206012028.3318291-1-gaosong@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx98C3R4VpgLZAAA--.40823S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_FROM(0.00)[bounces-70398-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_RCPT(0.00)[kvm];
	R_DKIM_NA(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gaosong@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.974];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,loongson.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 98D69F902A
X-Rspamd-Action: no action

Add device model for DMSINTC interrupt controller, implement basic
create/destroy/set_attr interfaces, and register device model to kvm
device table.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/kvm_dmsintc.h |  21 +++++
 arch/loongarch/include/asm/kvm_host.h    |   3 +
 arch/loongarch/include/uapi/asm/kvm.h    |   4 +
 arch/loongarch/kvm/Makefile              |   1 +
 arch/loongarch/kvm/intc/dmsintc.c        | 111 +++++++++++++++++++++++
 arch/loongarch/kvm/main.c                |   6 ++
 include/uapi/linux/kvm.h                 |   2 +
 7 files changed, 148 insertions(+)
 create mode 100644 arch/loongarch/include/asm/kvm_dmsintc.h
 create mode 100644 arch/loongarch/kvm/intc/dmsintc.c

diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch/include/asm/kvm_dmsintc.h
new file mode 100644
index 000000000000..1d4f66996f3c
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_dmsintc.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2025 Loongson Technology Corporation Limited
+ */
+
+#ifndef __ASM_KVM_DMSINTC_H
+#define __ASM_KVM_DMSINTC_H
+
+
+struct loongarch_dmsintc  {
+	struct kvm *kvm;
+	uint64_t msg_addr_base;
+	uint64_t msg_addr_size;
+};
+
+struct dmsintc_state {
+	atomic64_t  vector_map[4];
+};
+
+int kvm_loongarch_register_dmsintc_device(void);
+#endif
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index e4fe5b8e8149..5e9e2af7312f 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -22,6 +22,7 @@
 #include <asm/kvm_ipi.h>
 #include <asm/kvm_eiointc.h>
 #include <asm/kvm_pch_pic.h>
+#include <asm/kvm_dmsintc.h>
 #include <asm/loongarch.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -134,6 +135,7 @@ struct kvm_arch {
 	struct loongarch_ipi *ipi;
 	struct loongarch_eiointc *eiointc;
 	struct loongarch_pch_pic *pch_pic;
+	struct loongarch_dmsintc *dmsintc;
 };
 
 #define CSR_MAX_NUMS		0x800
@@ -244,6 +246,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mp_state mp_state;
 	/* ipi state */
 	struct ipi_state ipi_state;
+	struct dmsintc_state dmsintc_state;
 	/* cpucfg */
 	u32 cpucfg[KVM_MAX_CPUCFG_REGS];
 
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index de6c3f18e40a..0a370d018b08 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -154,4 +154,8 @@ struct kvm_iocsr_entry {
 #define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL	        0x40000006
 #define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT	        0
 
+#define KVM_DEV_LOONGARCH_DMSINTC_CTRL			0x40000007
+#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE		0x0
+#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE		0x1
+
 #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index cb41d9265662..6e184e24443c 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -19,6 +19,7 @@ kvm-y += vm.o
 kvm-y += intc/ipi.o
 kvm-y += intc/eiointc.o
 kvm-y += intc/pch_pic.o
+kvm-y += intc/dmsintc.o
 kvm-y += irqfd.o
 
 CFLAGS_exit.o	+= $(call cc-disable-warning, override-init)
diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/dmsintc.c
new file mode 100644
index 000000000000..00e401de0464
--- /dev/null
+++ b/arch/loongarch/kvm/intc/dmsintc.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_dmsintc.h>
+#include <asm/kvm_vcpu.h>
+
+static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
+				struct kvm_device_attr *attr,
+				bool is_write)
+{
+	int addr = attr->attr;
+	void __user *data;
+	struct loongarch_dmsintc *s = dev->kvm->arch.dmsintc;
+	u64 tmp;
+
+	data = (void __user *)attr->addr;
+	switch (addr) {
+	case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE:
+		if (is_write) {
+			if (copy_from_user(&tmp, data, sizeof(s->msg_addr_base)))
+				return -EFAULT;
+			if (s->msg_addr_base) {
+				/* Duplicate setting are not allowed. */
+				return -EFAULT;
+			}
+			if ((tmp & (BIT(AVEC_CPU_SHIFT) - 1)) == 0)
+				s->msg_addr_base = tmp;
+			else
+				return  -EFAULT;
+		}
+		break;
+	case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
+		if (is_write) {
+			if (copy_from_user(&tmp, data, sizeof(s->msg_addr_size)))
+				return -EFAULT;
+			if (s->msg_addr_size) {
+				/*Duplicate setting are not allowed. */
+				return -EFAULT;
+			}
+			s->msg_addr_size = tmp;
+		}
+		break;
+	default:
+		kvm_err("%s: unknown dmsintc register, addr = %d\n", __func__, addr);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int kvm_dmsintc_set_attr(struct kvm_device *dev,
+			struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_LOONGARCH_DMSINTC_CTRL:
+		return kvm_dmsintc_ctrl_access(dev, attr, true);
+	default:
+		kvm_err("%s: unknown group (%d)\n", __func__, attr->group);
+		return -EINVAL;
+	}
+}
+
+static int kvm_dmsintc_create(struct kvm_device *dev, u32 type)
+{
+	struct kvm *kvm;
+	struct loongarch_dmsintc *s;
+
+	if (!dev) {
+		kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
+		return -EINVAL;
+	}
+
+	kvm = dev->kvm;
+	if (kvm->arch.dmsintc) {
+		kvm_err("%s: LoongArch DMSINTC has already been created!\n", __func__);
+		return -EINVAL;
+	}
+
+	s = kzalloc(sizeof(struct loongarch_dmsintc), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	s->kvm = kvm;
+	kvm->arch.dmsintc = s;
+	return 0;
+}
+
+static void kvm_dmsintc_destroy(struct kvm_device *dev)
+{
+
+	if (!dev || !dev->kvm || !dev->kvm->arch.dmsintc)
+		return;
+
+	kfree(dev->kvm->arch.dmsintc);
+	kfree(dev);
+}
+
+static struct kvm_device_ops kvm_dmsintc_dev_ops = {
+	.name = "kvm-loongarch-dmsintc",
+	.create = kvm_dmsintc_create,
+	.destroy = kvm_dmsintc_destroy,
+	.set_attr = kvm_dmsintc_set_attr,
+};
+
+int kvm_loongarch_register_dmsintc_device(void)
+{
+	return kvm_register_device_ops(&kvm_dmsintc_dev_ops, KVM_DEV_TYPE_LOONGARCH_DMSINTC);
+}
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 80ea63d465b8..f363a3b24903 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -408,6 +408,12 @@ static int kvm_loongarch_env_init(void)
 
 	/* Register LoongArch PCH-PIC interrupt controller interface. */
 	ret = kvm_loongarch_register_pch_pic_device();
+	if (ret)
+		return ret;
+
+	/* Register LoongArch DMSINTC interrupt contrroller interface */
+	if (cpu_has_msgint)
+		ret = kvm_loongarch_register_dmsintc_device();
 
 	return ret;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507..7c56e7e36265 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1209,6 +1209,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_LOONGARCH_DMSINTC,
+#define KVM_DEV_TYPE_LOONGARCH_DMSINTC   KVM_DEV_TYPE_LOONGARCH_DMSINTC
 
 	KVM_DEV_TYPE_MAX,
 
-- 
2.39.3


