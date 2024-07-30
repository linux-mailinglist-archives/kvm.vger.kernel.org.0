Return-Path: <kvm+bounces-22609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B92A5940A82
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 630B01F24827
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 07:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9D2192B85;
	Tue, 30 Jul 2024 07:57:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3660191F95;
	Tue, 30 Jul 2024 07:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722326269; cv=none; b=cI/le6ZTaeh2vhVRErT5QMJh3eXNT0PaaXC9tPiGxyXYEx3T/8FqRRwKRMNH4v+iqalGonSWfsPGEdbHLfptNSqsYeZtO/S3l92WB5F/RV+F8i7c64jjfxK/ED/E1JPYr4ZNPXe9u4IWgQet69+bUIaGQJo1TlR0HnBfCdEusy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722326269; c=relaxed/simple;
	bh=Y8Zbq+NVJB0XeVZSVJnBz1SpwxlxQshPQaJ9DktkhIY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QCmzXGiJsWtaB1YdqEIH1hgSsW7QGpDloXVN29IlCVaw4MN4tp3zcvrU55mjzK4jJ7EMY27CNskE1locRrwdvFfqkpF0w1KH8qc1t/GL20fKhvUu7IFgh9JBfz7eSBZq5m23pYhBdkoyDzRp8a1T2gty32ngMbefUtjtwnDtzB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxGur5nKhm_FEEAA--.14949S3;
	Tue, 30 Jul 2024 15:57:45 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxX8f4nKhmrTUGAA--.30670S4;
	Tue, 30 Jul 2024 15:57:44 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v6 2/3] LoongArch: KVM: Add LBT feature detection function
Date: Tue, 30 Jul 2024 15:57:42 +0800
Message-Id: <20240730075744.1215856-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240730075744.1215856-1-maobibo@loongson.cn>
References: <20240730075744.1215856-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxX8f4nKhmrTUGAA--.30670S4
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

Also two extra sub-features is added for VM feature dectection,
previously features LSX/LASX are detected from vcpu context, now
it can be detected from VM context.
 KVM_LOONGARCH_VM_FEAT_LSX
 KVM_LOONGARCH_VM_FEAT_LASX

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/uapi/asm/kvm.h |  8 +++++
 arch/loongarch/kvm/vcpu.c             |  6 ++++
 arch/loongarch/kvm/vm.c               | 52 ++++++++++++++++++++++++++-
 3 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index ddc5cab0ffd0..49bafac8b22d 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -82,6 +82,14 @@ struct kvm_fpu {
 #define KVM_IOC_CSRID(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
 #define KVM_IOC_CPUCFG(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
 
+/* Device Control API on vm fd */
+#define KVM_LOONGARCH_VM_FEAT_CTRL	0
+#define  KVM_LOONGARCH_VM_FEAT_LSX	0
+#define  KVM_LOONGARCH_VM_FEAT_LASX	1
+#define  KVM_LOONGARCH_VM_FEAT_X86BT	2
+#define  KVM_LOONGARCH_VM_FEAT_ARMBT	3
+#define  KVM_LOONGARCH_VM_FEAT_MIPSBT	4
+
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
 #define KVM_LOONGARCH_VCPU_PVTIME_CTRL	1
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 36db2b257a95..b5324885a81a 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -498,6 +498,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
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
index 6b2e4f66ad26..f9604bc2b3ea 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -99,7 +99,57 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VM_FEAT_LSX:
+		if (cpu_has_lsx)
+			return 0;
+		return -ENXIO;
+	case KVM_LOONGARCH_VM_FEAT_LASX:
+		if (cpu_has_lasx)
+			return 0;
+		return -ENXIO;
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


