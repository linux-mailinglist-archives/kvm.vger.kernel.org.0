Return-Path: <kvm+bounces-18996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7DE18FE024
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 09:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2905728416B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 07:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30AF613B28F;
	Thu,  6 Jun 2024 07:48:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885E131A89;
	Thu,  6 Jun 2024 07:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717660137; cv=none; b=pGAK5ZY4Mba0nw6TcbVdbIh06HGWFyr/LykcATK4wzbmOV7dEISzpM/6aommfxUM1o+pCEpGsX1+w6SzwGbUNs0YSn76sFItz5kTIcVKl+jJy+XsD8A2iZOY+C/PiLItcENM5N2KZqntfDbtULj3pXzMXVKblQE3SQ4PZ+n7Ws4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717660137; c=relaxed/simple;
	bh=vvKAQj9A9a25UiDJC3KL5MSzdfTdK8owek4RnM6UtrM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M7Y2vRKA1kg0khKERNqhkBQvjaDHPuxvyCqsY7LmLaznoY5dxPq9kZ0y7gmFMZCFdjqsmF+7QNt3SVuM18OjGS3JQU6VwezMDRVW30iMEH63yTZfWG1ECiBR4MdBndQ9uQ202wvGClVnyCF64mWH4jPHdjAdMth8YS7Y/GBvoDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxcPDkaWFmAyAEAA--.17638S3;
	Thu, 06 Jun 2024 15:48:52 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Axw8TjaWFmGaIWAA--.45782S2;
	Thu, 06 Jun 2024 15:48:51 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Add feature passing from user space
Date: Thu,  6 Jun 2024 15:48:50 +0800
Message-Id: <20240606074850.2651896-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Axw8TjaWFmGaIWAA--.45782S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Currently features defined in cpucfg CPUCFG_KVM_FEATURE comes from
kvm kernel mode only. Some features are defined in user space VMM,
however KVM module does not know. Here interface is added to update
register CPUCFG_KVM_FEATURE from user space, only bit 24 - 31 is valid.

Feature KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI is added from user mdoe.
FEAT_VIRT_EXTIOI is virt EXTIOI extension which can route interrupt
to 256 VCPUs rather than 4 CPUs like real hw.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h  |  4 +++
 arch/loongarch/include/asm/loongarch.h |  5 ++++
 arch/loongarch/include/uapi/asm/kvm.h  |  2 ++
 arch/loongarch/kvm/exit.c              |  1 +
 arch/loongarch/kvm/vcpu.c              | 36 +++++++++++++++++++++++---
 5 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 88023ab59486..8fa50d757247 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -135,6 +135,9 @@ enum emulation_result {
 #define KVM_LARCH_HWCSR_USABLE	(0x1 << 4)
 #define KVM_LARCH_LBT		(0x1 << 5)
 
+#define KVM_LOONGARCH_USR_FEAT_MASK			\
+	BIT(KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI)
+
 struct kvm_vcpu_arch {
 	/*
 	 * Switch pointer-to-function type to unsigned long
@@ -210,6 +213,7 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		struct gfn_to_hva_cache cache;
 	} st;
+	unsigned int usr_features;
 };
 
 static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 7a4633ef284b..4d9837512c19 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -167,9 +167,14 @@
 
 #define CPUCFG_KVM_SIG			(CPUCFG_KVM_BASE + 0)
 #define  KVM_SIGNATURE			"KVM\0"
+/*
+ * BIT 24 - 31 is features configurable by user space vmm
+ */
 #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
 #define  KVM_FEATURE_IPI		BIT(1)
 #define  KVM_FEATURE_STEAL_TIME		BIT(2)
+/* With VIRT_EXTIOI feature, interrupt can route to 256 VCPUs */
+#define  KVM_FEATURE_VIRT_EXTIOI	BIT(24)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index ed12e509815c..dd141259de48 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -99,6 +99,8 @@ struct kvm_fpu {
 
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
+/* For CPUCFG_KVM_FEATURE register */
+#define  KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI	24
 #define KVM_LOONGARCH_VCPU_PVTIME_CTRL	1
 #define  KVM_LOONGARCH_VCPU_PVTIME_GPA	0
 
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index e1bd81d27fd8..ab2dcc76784a 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -53,6 +53,7 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 		ret = KVM_FEATURE_IPI;
 		if (sched_info_on())
 			ret |= KVM_FEATURE_STEAL_TIME;
+		ret |= vcpu->arch.usr_features;
 		vcpu->arch.gprs[rd] = ret;
 		break;
 	default:
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 3783151fde32..26f2b22b6a62 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -832,6 +832,8 @@ static int kvm_loongarch_cpucfg_has_attr(struct kvm_vcpu *vcpu,
 	switch (attr->attr) {
 	case 2:
 		return 0;
+	case CPUCFG_KVM_FEATURE:
+		return 0;
 	default:
 		return -ENXIO;
 	}
@@ -865,9 +867,18 @@ static int kvm_loongarch_get_cpucfg_attr(struct kvm_vcpu *vcpu,
 	uint64_t val;
 	uint64_t __user *uaddr = (uint64_t __user *)attr->addr;
 
-	ret = _kvm_get_cpucfg_mask(attr->attr, &val);
-	if (ret)
-		return ret;
+	switch (attr->attr) {
+	case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
+		ret = _kvm_get_cpucfg_mask(attr->attr, &val);
+		if (ret)
+			return ret;
+		break;
+	case CPUCFG_KVM_FEATURE:
+		val = vcpu->arch.usr_features & KVM_LOONGARCH_USR_FEAT_MASK;
+		break;
+	default:
+		return -ENXIO;
+	}
 
 	put_user(val, uaddr);
 
@@ -896,7 +907,24 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
 static int kvm_loongarch_cpucfg_set_attr(struct kvm_vcpu *vcpu,
 					 struct kvm_device_attr *attr)
 {
-	return -ENXIO;
+	u64 __user *user = (u64 __user *)attr->addr;
+	u64 val, valid_flags;
+
+	switch (attr->attr) {
+	case CPUCFG_KVM_FEATURE:
+		if (get_user(val, user))
+			return -EFAULT;
+
+		valid_flags = KVM_LOONGARCH_USR_FEAT_MASK;
+		if (val & ~valid_flags)
+			return -EINVAL;
+
+		vcpu->arch.usr_features |= val;
+		return 0;
+
+	default:
+		return -ENXIO;
+	}
 }
 
 static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,

base-commit: 2df0193e62cf887f373995fb8a91068562784adc
-- 
2.39.3


