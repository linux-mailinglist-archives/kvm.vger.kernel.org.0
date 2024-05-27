Return-Path: <kvm+bounces-18171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0DD08CFA66
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 09:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94ACCB21A21
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 07:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C074D5A2;
	Mon, 27 May 2024 07:46:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31732836A;
	Mon, 27 May 2024 07:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716796016; cv=none; b=OVPv1AlCm/Wrc9fIZQ1Wta4UkdiDrDLVVWof+m76mkSQlUwm5ohDXawo6FfMFhTRa4uMfYkibK5xT+x9213RFEK05KECysYqKgIBCr9iisTrVrqsaEb9c91sKKZSElxWqS6iKsblhRIbwJu9HUzmq4/EfjWSSbGWBkVXL1CfazI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716796016; c=relaxed/simple;
	bh=4YyU3rtnfFX9YrhUnBGT37Ld3wJFK1+xQcIB/PpJnZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YQwQ5pM3+caCB5ohAOYswd7jIAXoAJf9JBTigJBYly8CkDiODaF48W/epjUAYmia9evPUqBnSZdSQBYoqtp4fSUJSfpB9HXF1G+IDGqHJ6DS/tmLBnJ2VdklGvStYBvaQqHX9WfUnUGYLR3o0AANsSq4TNBmgLaC5HERgaFm+Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxW+pmOlRmvB4AAA--.382S3;
	Mon, 27 May 2024 15:46:46 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxTcdlOlRmHuIKAA--.28594S6;
	Mon, 27 May 2024 15:46:46 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] LoongArch: KVM: Add VM LBT feature detection support
Date: Mon, 27 May 2024 15:46:44 +0800
Message-Id: <20240527074644.836699-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240527074644.836699-1-maobibo@loongson.cn>
References: <20240527074644.836699-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxTcdlOlRmHuIKAA--.28594S6
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Before virt machine or vcpu is created, vmm need check supported
features from KVM. Here ioctl command KVM_HAS_DEVICE_ATTR is added
for VM, and macro KVM_LOONGARCH_VM_FEAT_CTRL is added to check
supported feature.

Three sub-features relative with LBT are added, in later any new
feature can be added if it is used for vmm. The sub-features is
 KVM_LOONGARCH_VM_FEAT_X86BT
 KVM_LOONGARCH_VM_FEAT_ARMBT
 KVM_LOONGARCH_VM_FEAT_MIPSBT

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
 arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 656aa6a723a6..ed12e509815c 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -91,6 +91,12 @@ struct kvm_fpu {
 #define KVM_IOC_CSRID(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
 #define KVM_IOC_CPUCFG(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
 
+/* Device Control API on vm fd */
+#define KVM_LOONGARCH_VM_FEAT_CTRL	0
+#define  KVM_LOONGARCH_VM_FEAT_X86BT	0
+#define  KVM_LOONGARCH_VM_FEAT_ARMBT	1
+#define  KVM_LOONGARCH_VM_FEAT_MIPSBT	2
+
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
 #define KVM_LOONGARCH_VCPU_PVTIME_CTRL	1
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 6b2e4f66ad26..09e05108c68b 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VM_FEAT_X86BT:
+		if (cpu_has_lbt_x86)
+			return 0;
+		return -ENXIO;
+	case KVM_LOONGARCH_VM_FEAT_ARMBT:
+		if (cpu_has_lbt_arm)
+			return 0;
+		return -ENXIO;
+	case KVM_LOONGARCH_VM_FEAT_MIPSBT:
+		if (cpu_has_lbt_mips)
+			return 0;
+		return -ENXIO;
+	default:
+		return -ENXIO;
+	}
+}
+
+static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_LOONGARCH_VM_FEAT_CTRL:
+		return kvm_vm_feature_has_attr(kvm, attr);
+	default:
+		return -ENXIO;
+	}
+}
+
 int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
-	return -ENOIOCTLCMD;
+	struct kvm *kvm = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	struct kvm_device_attr attr;
+
+	switch (ioctl) {
+	case KVM_HAS_DEVICE_ATTR:
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+
+		return kvm_vm_has_attr(kvm, &attr);
+	default:
+		return -EINVAL;
+	}
 }
-- 
2.39.3


