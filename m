Return-Path: <kvm+bounces-20522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB19A917900
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 08:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31614285CC2
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 06:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F674155C91;
	Wed, 26 Jun 2024 06:32:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D456014D29B;
	Wed, 26 Jun 2024 06:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719383570; cv=none; b=B2shGSZ57CUY7o0xlWZ6e5An8/w+ghBZjd3y5kA8HCCgR9C5uuMvdU5hPLEPnPYAeE7XMVE8VH7ekeA85BGSZN510/iT1AlhxGXEtnoGd4W1z8nuc8CXBMbQO2ATROz0Mr+LZJc7UVWZz3DGR+cRdUgHnIu7H3pKdBi0oj/qn1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719383570; c=relaxed/simple;
	bh=q+xEY9r3hh33l7YN80rPV62Ty6v9u4tjymEDU1z6u+w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kviVPJ4x1FtdbvUJeeCzfDl5EIuCe79Fqkt6e2uIDqoItpxup0xaV4V1hTQl2yiwsQIizbJjlOp49KX+Ja+8Iuluofg8EP9rZStv6tUjxxog2cyEY3Ya59Y4c1dGpjnc9xTVds0JDCulpB4TuWl3MyZM9wlTKjE+rN7dZJhkveg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxrOoItntmACoKAA--.41199S3;
	Wed, 26 Jun 2024 14:32:40 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxHMcHtntmo5ExAA--.53222S4;
	Wed, 26 Jun 2024 14:32:40 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
Date: Wed, 26 Jun 2024 14:32:38 +0800
Message-Id: <20240626063239.3722175-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240626063239.3722175-1-maobibo@loongson.cn>
References: <20240626063239.3722175-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxHMcHtntmo5ExAA--.53222S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Two kinds of LBT feature detection are added here, one is VCPU
feature, the other is VM feature. VCPU feature dection can only
work with VCPU thread itself, and requires VCPU thread is created
already. So LBT feature detection for VM is added also, it can
be done even if VM is not created, and also can be done by any
thread besides VCPU threads.

Loongson Binary Translation (LBT) feature is defined in register
cpucfg2. Here LBT capability detection for VCPU is added.

Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and macro
KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported feature. And
three sub-features relative with LBT are added as following:
 KVM_LOONGARCH_VM_FEAT_X86BT
 KVM_LOONGARCH_VM_FEAT_ARMBT
 KVM_LOONGARCH_VM_FEAT_MIPSBT

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
 arch/loongarch/kvm/vcpu.c             |  6 ++++
 arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index ddc5cab0ffd0..c40f7d9ffe13 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -82,6 +82,12 @@ struct kvm_fpu {
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
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 233d28d0e928..9734b4d8db05 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 			*v |= CPUCFG2_LSX;
 		if (cpu_has_lasx)
 			*v |= CPUCFG2_LASX;
+		if (cpu_has_lbt_x86)
+			*v |= CPUCFG2_X86BT;
+		if (cpu_has_lbt_arm)
+			*v |= CPUCFG2_ARMBT;
+		if (cpu_has_lbt_mips)
+			*v |= CPUCFG2_MIPSBT;
 
 		return 0;
 	case LOONGARCH_CPUCFG3:
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


