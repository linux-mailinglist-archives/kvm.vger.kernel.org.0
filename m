Return-Path: <kvm+bounces-64928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D22C91797
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 10:37:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CEB90349D12
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 09:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECC6305970;
	Fri, 28 Nov 2025 09:36:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E04304985;
	Fri, 28 Nov 2025 09:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764322560; cv=none; b=YU2plvnrjCh1+WbM6popIUsuoji7ByHJBXYr1rfo8A33jJ7xF0szh+GRVmhPy/c/Q6XAcERlgoqpJ1mqvXsvJRMfxFyVoEtw49v0RsA36ih90hK9OToz1Y6dQ+3/iSvoxtJsHnUGWLnFRHp4cvjcSOEeUbbRjJSq9ojAj1uXIss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764322560; c=relaxed/simple;
	bh=tSpwMkmTh8XtXuyoBI95NlR+zzEGyXdon6CepKj6b7o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lxHaIoidI5bSgzpMI9vK+Ejffb57jTjUd/74N44clvYMJRbB74LvvWy8/CxuiP7lpy3qPgHxHnOQM6PYKiHjiZN4LGvRD9iNX4xAt2Y6IVj7oMNO8cpflwOmn0Xj1YVdq61T5jWLM0epPlvDHm8LgUIdFG9POeHMISdwRGaWKY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Dxb_DvbClpRA8pAA--.23864S3;
	Fri, 28 Nov 2025 17:35:43 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowJCx2sDtbClpo+xBAQ--.23356S4;
	Fri, 28 Nov 2025 17:35:42 +0800 (CST)
From: Song Gao <gaosong@loongson.cn>
To: maobibo@loongson.cn,
	chenhuacai@kernel.org
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	kernel@xen0n.name,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] LongArch: KVM: Add DINTC device support
Date: Fri, 28 Nov 2025 17:11:23 +0800
Message-Id: <20251128091125.2720148-3-gaosong@loongson.cn>
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
X-CM-TRANSID:qMiowJCx2sDtbClpo+xBAQ--.23356S4
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add device model for AVEC interrupt controller, implement basic
create/destroy/set_attr interfaces, and register device model to kvm
device table.

Signed-off-by: Song Gao <gaosong@loongson.cn>
---
 arch/loongarch/include/asm/kvm_dintc.h |  21 +++++
 arch/loongarch/include/asm/kvm_host.h  |   3 +
 arch/loongarch/include/uapi/asm/kvm.h  |   4 +
 arch/loongarch/kvm/Makefile            |   1 +
 arch/loongarch/kvm/intc/dintc.c        | 112 +++++++++++++++++++++++++
 arch/loongarch/kvm/main.c              |   5 ++
 include/uapi/linux/kvm.h               |   2 +
 7 files changed, 148 insertions(+)
 create mode 100644 arch/loongarch/include/asm/kvm_dintc.h
 create mode 100644 arch/loongarch/kvm/intc/dintc.c

diff --git a/arch/loongarch/include/asm/kvm_dintc.h b/arch/loongarch/include/asm/kvm_dintc.h
new file mode 100644
index 000000000000..d980d39c0344
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_dintc.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2025 Loongson Technology Corporation Limited
+ */
+
+#ifndef __ASM_KVM_DINTC_H
+#define __ASM_KVM_DINTC_H
+
+
+struct loongarch_dintc  {
+	struct kvm *kvm;
+	uint64_t msg_addr_base;
+	uint64_t msg_addr_size;
+};
+
+struct dintc_state {
+	atomic64_t  vector_map[4];
+};
+
+int kvm_loongarch_register_dintc_device(void);
+#endif
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 0cecbd038bb3..7f6c4e7d241e 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -22,6 +22,7 @@
 #include <asm/kvm_ipi.h>
 #include <asm/kvm_eiointc.h>
 #include <asm/kvm_pch_pic.h>
+#include <asm/kvm_dintc.h>
 #include <asm/loongarch.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -132,6 +133,7 @@ struct kvm_arch {
 	struct loongarch_ipi *ipi;
 	struct loongarch_eiointc *eiointc;
 	struct loongarch_pch_pic *pch_pic;
+	struct loongarch_dintc *dintc;
 };
 
 #define CSR_MAX_NUMS		0x800
@@ -242,6 +244,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mp_state mp_state;
 	/* ipi state */
 	struct ipi_state ipi_state;
+	struct dintc_state dintc_state;
 	/* cpucfg */
 	u32 cpucfg[KVM_MAX_CPUCFG_REGS];
 
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index de6c3f18e40a..07da84f7002c 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -154,4 +154,8 @@ struct kvm_iocsr_entry {
 #define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL	        0x40000006
 #define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT	        0
 
+#define KVM_DEV_LOONGARCH_DINTC_CTRL			0x40000007
+#define KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_BASE		0x0
+#define KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_SIZE		0x1
+
 #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
index cb41d9265662..fe984bf1cbdb 100644
--- a/arch/loongarch/kvm/Makefile
+++ b/arch/loongarch/kvm/Makefile
@@ -19,6 +19,7 @@ kvm-y += vm.o
 kvm-y += intc/ipi.o
 kvm-y += intc/eiointc.o
 kvm-y += intc/pch_pic.o
+kvm-y += intc/dintc.o
 kvm-y += irqfd.o
 
 CFLAGS_exit.o	+= $(call cc-disable-warning, override-init)
diff --git a/arch/loongarch/kvm/intc/dintc.c b/arch/loongarch/kvm/intc/dintc.c
new file mode 100644
index 000000000000..d30616ded1b1
--- /dev/null
+++ b/arch/loongarch/kvm/intc/dintc.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_dintc.h>
+#include <asm/kvm_vcpu.h>
+
+static int kvm_dintc_ctrl_access(struct kvm_device *dev,
+				struct kvm_device_attr *attr,
+				bool is_write)
+{
+	int addr = attr->attr;
+	void __user *data;
+	struct loongarch_dintc *s = dev->kvm->arch.dintc;
+	u64 tmp;
+
+	data = (void __user *)attr->addr;
+	switch (addr) {
+	case KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_BASE:
+		if (is_write) {
+			if (copy_from_user(&tmp, data, sizeof(s->msg_addr_base)))
+				return -EFAULT;
+			if (s->msg_addr_base) {
+				/* Duplicate setting are not allowed. */
+				return -EFAULT;
+			}
+			if (tmp > (1UL << AVEC_CPU_SHIFT))
+				s->msg_addr_base = tmp;
+			else
+				return  -EFAULT;
+		}
+		break;
+	case KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_SIZE:
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
+		kvm_err("%s: unknown dintc register, addr = %d\n", __func__, addr);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int kvm_dintc_set_attr(struct kvm_device *dev,
+			struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_LOONGARCH_DINTC_CTRL:
+		return kvm_dintc_ctrl_access(dev, attr, true);
+	default:
+		kvm_err("%s: unknown group (%d)\n", __func__, attr->group);
+		return -EINVAL;
+	}
+}
+
+static int kvm_dintc_create(struct kvm_device *dev, u32 type)
+{
+	struct kvm *kvm;
+	struct loongarch_dintc *s;
+
+	if (!dev) {
+		kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
+		return -EINVAL;
+	}
+
+	kvm = dev->kvm;
+	if (kvm->arch.dintc) {
+		kvm_err("%s: LoongArch DINTC has already been created!\n", __func__);
+		return -EINVAL;
+	}
+
+	s = kzalloc(sizeof(struct loongarch_dintc), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	s->kvm = kvm;
+	kvm->arch.dintc = s;
+	return 0;
+}
+
+static void kvm_dintc_destroy(struct kvm_device *dev)
+{
+	struct kvm *kvm;
+	struct loongarch_dintc *dintc;
+
+	if (!dev || !dev->kvm || !dev->kvm->arch.dintc)
+		return;
+
+	kfree(dev->kvm->arch.dintc);
+}
+
+static struct kvm_device_ops kvm_dintc_dev_ops = {
+	.name = "kvm-loongarch-dintc",
+	.create = kvm_dintc_create,
+	.destroy = kvm_dintc_destroy,
+	.set_attr = kvm_dintc_set_attr,
+};
+
+int kvm_loongarch_register_dintc_device(void)
+{
+	return kvm_register_device_ops(&kvm_dintc_dev_ops, KVM_DEV_TYPE_LOONGARCH_DINTC);
+}
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 80ea63d465b8..d18d9f4d485c 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -408,6 +408,11 @@ static int kvm_loongarch_env_init(void)
 
 	/* Register LoongArch PCH-PIC interrupt controller interface. */
 	ret = kvm_loongarch_register_pch_pic_device();
+	if (ret)
+		return ret;
+
+	/* Register LoongArch DINTC interrupt contrroller interface */
+	ret = kvm_loongarch_register_dintc_device();
 
 	return ret;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab020..497a48235bf8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1198,6 +1198,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_LOONGARCH_DINTC,
+#define KVM_DEV_TYPE_LOONGARCH_DINTC   KVM_DEV_TYPE_LOONGARCH_DINTC
 
 	KVM_DEV_TYPE_MAX,
 
-- 
2.39.3


