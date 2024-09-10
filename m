Return-Path: <kvm+bounces-26251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 081AD9736B8
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:03:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A73CD1F26D1E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E79119412D;
	Tue, 10 Sep 2024 12:01:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FA718DF67;
	Tue, 10 Sep 2024 12:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725969717; cv=none; b=d8lvNpKDpNm36aFl7x8NC4kkKxC4eLjdD/lyu2MrNgD5CgAOdpZ0UeVxnSvBMi6GtY2liIx1gpMF3upYe6BQsP+iCul2bNQO6ZhbE/F6h2QH65U85+1vTWFKSIHuRVeiem2J3vFa6cCIbxYwJRQ88qSMipveeiUgLggUNrmlWz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725969717; c=relaxed/simple;
	bh=gHhJj44TFnwnn3LKe2pgq/DGHUgtk0PS7iURQKWtR3I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SkwAKiW/0IpJc84nsUoK11IrtrQkrGwGzu9CmzQvLahx/ua/KZKZQntd36iElXoWy+mjhnmxnJfcAROwFPzqUdh3qWsBeMtwKyMpFem0ly7ocEqG/Xw0/rBpiaxHw5d0xXW+6hrhe9ZG0Aid1XyAmP2Kdqlk6wvX6xMEqBP3Chs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8BxdegvNeBmMa8DAA--.7389S3;
	Tue, 10 Sep 2024 20:01:51 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front2 (Coremail) with SMTP id qciowMCxrsceNeBmyGIDAA--.15904S6;
	Tue, 10 Sep 2024 20:01:50 +0800 (CST)
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
Subject: [PATCH V3 04/11] LoongArch: KVM: Add IPI user mode read and write function
Date: Tue, 10 Sep 2024 19:43:53 +0800
Message-Id: <20240910114400.4062433-5-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20240910114400.4062433-1-lixianglai@loongson.cn>
References: <20240910114400.4062433-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qciowMCxrsceNeBmyGIDAA--.15904S6
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implements the communication interface between the user mode
program and the kernel in IPI interrupt control simulation,
which is used to obtain or send the simulation data of the
interrupt controller in the user mode process, and is used
in VM migration or VM saving and restoration.

Signed-off-by: Min Zhou <zhoumin@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/include/uapi/asm/kvm.h |  2 +
 arch/loongarch/kvm/intc/ipi.c         | 90 ++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index ddc5cab0ffd0..ec9fe4cbf949 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -112,4 +112,6 @@ struct kvm_iocsr_entry {
 #define KVM_IRQCHIP_NUM_PINS	64
 #define KVM_MAX_CORES		256
 
+#define KVM_DEV_LOONGARCH_IPI_GRP_REGS			0x40000001
+
 #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index 2620c1500078..22f05fdbae84 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -323,16 +323,102 @@ static const struct kvm_io_device_ops kvm_loongarch_mail_ops = {
 	.write	= kvm_loongarch_mail_write,
 };
 
+static int kvm_ipi_regs_access(struct kvm_device *dev,
+				struct kvm_device_attr *attr,
+				bool is_write)
+{
+	uint64_t val;
+	int cpu, addr;
+	void *p = NULL;
+	int len = 4;
+	struct kvm_vcpu *vcpu;
+
+	cpu = (attr->attr >> 16) & 0x3ff;
+	addr = attr->attr & 0xff;
+
+	vcpu = kvm_get_vcpu(dev->kvm, cpu);
+	if (unlikely(vcpu == NULL)) {
+		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
+		return -EINVAL;
+	}
+	switch (addr) {
+	case CORE_STATUS_OFF:
+		p = &vcpu->arch.ipi_state.status;
+		break;
+	case CORE_EN_OFF:
+		p = &vcpu->arch.ipi_state.en;
+		break;
+	case CORE_SET_OFF:
+		p = &vcpu->arch.ipi_state.set;
+		break;
+	case CORE_CLEAR_OFF:
+		p = &vcpu->arch.ipi_state.clear;
+		break;
+	case CORE_BUF_20:
+		p = &vcpu->arch.ipi_state.buf[0];
+		len = 8;
+		break;
+	case CORE_BUF_28:
+		p = &vcpu->arch.ipi_state.buf[1];
+		len = 8;
+		break;
+	case CORE_BUF_30:
+		p = &vcpu->arch.ipi_state.buf[2];
+		len = 8;
+		break;
+	case CORE_BUF_38:
+		p = &vcpu->arch.ipi_state.buf[3];
+		len = 8;
+		break;
+	default:
+		kvm_err("%s: unknown ipi register, addr = %d\n", __func__, addr);
+		return -EINVAL;
+	}
+
+	if (is_write) {
+		if (len == 4) {
+			if (get_user(val, (uint32_t __user *)attr->addr))
+				return -EFAULT;
+			*(uint32_t *)p = (uint32_t)val;
+		} else if (len == 8) {
+			if (get_user(val, (uint64_t __user *)attr->addr))
+				return -EFAULT;
+			*(uint64_t *)p = val;
+		}
+	} else {
+		if (len == 4) {
+			val = *(uint32_t *)p;
+			return put_user(val, (uint32_t __user *)attr->addr);
+		} else if (len == 8) {
+			val = *(uint64_t *)p;
+			return put_user(val, (uint64_t __user *)attr->addr);
+		}
+	}
+	return 0;
+}
+
 static int kvm_ipi_get_attr(struct kvm_device *dev,
 			struct kvm_device_attr *attr)
 {
-	return 0;
+	switch (attr->group) {
+	case KVM_DEV_LOONGARCH_IPI_GRP_REGS:
+		return kvm_ipi_regs_access(dev, attr, false);
+	default:
+		kvm_err("%s: unknown group (%d)\n", __func__, attr->group);
+		return -EINVAL;
+	}
 }
 
 static int kvm_ipi_set_attr(struct kvm_device *dev,
 			struct kvm_device_attr *attr)
 {
-	return 0;
+	switch (attr->group) {
+	case KVM_DEV_LOONGARCH_IPI_GRP_REGS:
+		return kvm_ipi_regs_access(dev, attr, true);
+	default:
+		kvm_err("%s: unknown group (%d)\n", __func__, attr->group);
+		return -EINVAL;
+	}
 }
 
 static void kvm_ipi_destroy(struct kvm_device *dev)
-- 
2.39.1


