Return-Path: <kvm+bounces-18010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 637CE8CCAF4
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 05:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 939861C215AA
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 03:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFEC413B2B8;
	Thu, 23 May 2024 03:10:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA74CA34;
	Thu, 23 May 2024 03:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716433834; cv=none; b=FoTTWCgRT9OQeqIBjXUlS29QObB6w/eiB/XOFHl/iGOZGTEUgEIRtpuvhJdhan3lupzxEBRsIDAoNuK6PrZdy8ihwF27M4D5swbMI5yViWXR2DlBIZzy0PT5GeC5zkgawEfsT2vX/BgxaFzyOxk6ZcMH88hu8aqVnCrWry4xlAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716433834; c=relaxed/simple;
	bh=lBV13ulQ/56Ti/yP9kvxk+BpnJZiDj0HResYl3GulRM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P9+bb9iDXDASjGhBoNm/kCbwYxA+x33qjkO9YuX/e9ltuJZxuYc2i0qgzesIRrmt2DJ73406z00Y+6W8uasLOQZLF24hDkigD7VUdaOHGCmxKzD+WwO8SxrEcHjXQ+Zl7KECYMsnaV7OBG4w1XAPxgCeUz3el2fFJ4tG9dzMerw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxFeigs05mYeQCAA--.2691S3;
	Thu, 23 May 2024 11:10:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxNMWfs05mCEQGAA--.6973S6;
	Thu, 23 May 2024 11:10:24 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] LoongArch: KVM: Add VM LBT feature detection support
Date: Thu, 23 May 2024 11:10:23 +0800
Message-Id: <20240523031023.709347-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240523031023.709347-1-maobibo@loongson.cn>
References: <20240523031023.709347-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxNMWfs05mCEQGAA--.6973S6
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Before virt machine or vcpu is created, vmm need check supported
features from KVM. Here ioctl command KVM_HAS_DEVICE_ATTR is added
for VM, and macro KVM_LOONGARCH_VM_FEAT_CTRL is added to check
supported feature.

Now only KVM_LOONGARCH_VM_FEAT_LBT feature is added, in later any new
feature can be added if it is used for vmm.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/uapi/asm/kvm.h |  4 ++++
 arch/loongarch/kvm/vm.c               | 34 ++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 656aa6a723a6..8605ecc27806 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -91,6 +91,10 @@ struct kvm_fpu {
 #define KVM_IOC_CSRID(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
 #define KVM_IOC_CPUCFG(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
 
+/* Device Control API on vm fd */
+#define KVM_LOONGARCH_VM_FEAT_CTRL	0
+#define  KVM_LOONGARCH_VM_FEAT_LBT	0
+
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
 #define KVM_LOONGARCH_VCPU_PVTIME_CTRL	1
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 6b2e4f66ad26..38452bc23f8c 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -99,7 +99,39 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VM_FEAT_LBT:
+		return 0;
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


