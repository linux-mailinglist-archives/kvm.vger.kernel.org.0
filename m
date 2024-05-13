Return-Path: <kvm+bounces-17279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26FBA8C39C9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 03:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D894428121C
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 01:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB7E125A9;
	Mon, 13 May 2024 01:12:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29A1AD49;
	Mon, 13 May 2024 01:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715562767; cv=none; b=I1iRNgbSEdPc8BXDxP6g8D/mFDAGVIOAwgoYnrJZh6y94+wi08wZG+fkGXwk0WbEpBfW86/DV+SSGIbwNMjqMLV4JHmwQAKGxXlccxDJmEt2a6CDZAU/rW8yFaojxnIv3JCdBKaUw/EUFqRDD7QopPHXFsDuAN8u4hcSE6gdBjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715562767; c=relaxed/simple;
	bh=uYT0892VXNdGCG8AwERz9u6QC++GDGOxJxdVtu8qw2g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UclmkOBr5wwA+o+bqCJij5VQQ1tfpth4/KcAODslUfSClhRM9trHyIW+grDEVNMCyFrMe1xYvm9K2WCYUwpgf+EGjjfjn9pNp0z3XnxX7DFgynJLYlJNkYmqw485Mk5mGTXYLv86kkNAp0YTp1rZpYvWyPz+51MCnL4g4erpFmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx7+sFaUFmk_0LAA--.29422S3;
	Mon, 13 May 2024 09:12:37 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Ax690DaUFmV1gcAA--.51334S5;
	Mon, 13 May 2024 09:12:37 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] LoongArch: KVM: Add vm migration support for LBT feature
Date: Mon, 13 May 2024 09:12:35 +0800
Message-Id: <20240513011235.3233776-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240513011235.3233776-1-maobibo@loongson.cn>
References: <20240513011235.3233776-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Ax690DaUFmV1gcAA--.51334S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Every vcpu has separate LBT registers. And there are four scr registers,
one flags and ftop register for LBT extension. When VM migrates, VMM
needs to get LBT registers for every vcpu.

Here macro KVM_LOONGARCH_VCPU_LBT is added for vcpu attr control info,
the following macro is added to get/put LBT registers.
  KVM_LOONGARCH_VCPU_LBT_SCR0
  KVM_LOONGARCH_VCPU_LBT_SCR1
  KVM_LOONGARCH_VCPU_LBT_SCR2
  KVM_LOONGARCH_VCPU_LBT_SCR3
  KVM_LOONGARCH_VCPU_LBT_FLAGS
  KVM_LOONGARCH_VCPU_LBT_FTOP

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/uapi/asm/kvm.h |   7 ++
 arch/loongarch/kvm/vcpu.c             | 103 ++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 286b5ce93a57..9c3de257fddf 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -85,6 +85,13 @@ struct kvm_fpu {
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
 #define KVM_LOONGARCH_VCPU_PVTIME_CTRL	1
 #define  KVM_LOONGARCH_VCPU_PVTIME_GPA	0
+#define KVM_LOONGARCH_VCPU_LBT		2
+#define  KVM_LOONGARCH_VCPU_LBT_SCR0	0
+#define  KVM_LOONGARCH_VCPU_LBT_SCR1	1
+#define  KVM_LOONGARCH_VCPU_LBT_SCR2	2
+#define  KVM_LOONGARCH_VCPU_LBT_SCR3	3
+#define  KVM_LOONGARCH_VCPU_LBT_FLAGS	4
+#define  KVM_LOONGARCH_VCPU_LBT_FTOP	5
 
 struct kvm_debug_exit_arch {
 };
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index b2856539368a..a84c9d527d9d 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -765,6 +765,100 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+static int kvm_loongarch_lbt_has_attr(struct kvm_vcpu *vcpu,
+					struct kvm_device_attr *attr)
+{
+	if (!kvm_guest_has_lbt(&vcpu->arch))
+		return -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VCPU_LBT_SCR0:
+	case KVM_LOONGARCH_VCPU_LBT_SCR1:
+	case KVM_LOONGARCH_VCPU_LBT_SCR2:
+	case KVM_LOONGARCH_VCPU_LBT_SCR3:
+	case KVM_LOONGARCH_VCPU_LBT_FLAGS:
+	case KVM_LOONGARCH_VCPU_LBT_FTOP:
+		return 0;
+	default:
+		return -ENXIO;
+	}
+
+	return -ENXIO;
+}
+
+static int kvm_loongarch_lbt_get_attr(struct kvm_vcpu *vcpu,
+					struct kvm_device_attr *attr)
+{
+	uint64_t val;
+
+	if (!kvm_guest_has_lbt(&vcpu->arch))
+		return -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VCPU_LBT_SCR0:
+		val = vcpu->arch.lbt.scr0;
+		break;
+	case KVM_LOONGARCH_VCPU_LBT_SCR1:
+		val = vcpu->arch.lbt.scr1;
+		break;
+	case KVM_LOONGARCH_VCPU_LBT_SCR2:
+		val = vcpu->arch.lbt.scr2;
+		break;
+	case KVM_LOONGARCH_VCPU_LBT_SCR3:
+		val = vcpu->arch.lbt.scr3;
+		break;
+	case KVM_LOONGARCH_VCPU_LBT_FLAGS:
+		val = vcpu->arch.lbt.eflags;
+		break;
+	case KVM_LOONGARCH_VCPU_LBT_FTOP:
+		val = vcpu->arch.fpu.ftop;
+		break;
+	default:
+		return -ENXIO;
+	}
+
+	if (put_user(val, (uint64_t __user *)attr->addr))
+		return -EFAULT;
+	return 0;
+}
+
+static int kvm_loongarch_lbt_set_attr(struct kvm_vcpu *vcpu,
+					struct kvm_device_attr *attr)
+{
+	u64 val;
+
+	if (!kvm_guest_has_lbt(&vcpu->arch))
+		return -ENXIO;
+
+	if (get_user(val, (u64 __user *)attr->addr))
+		return -EFAULT;
+
+	switch (attr->attr) {
+	case KVM_LOONGARCH_VCPU_LBT_SCR0:
+		vcpu->arch.lbt.scr0 = val;
+		break;
+	case KVM_LOONGARCH_VCPU_LBT_SCR1:
+		vcpu->arch.lbt.scr1 = val;
+		break;
+	case KVM_LOONGARCH_VCPU_LBT_SCR2:
+		vcpu->arch.lbt.scr2 = val;
+		break;
+	case KVM_LOONGARCH_VCPU_LBT_SCR3:
+		vcpu->arch.lbt.scr3 = val;
+		break;
+	case KVM_LOONGARCH_VCPU_LBT_FLAGS:
+		vcpu->arch.lbt.eflags = val;
+		break;
+	case KVM_LOONGARCH_VCPU_LBT_FTOP:
+		vcpu->arch.fpu.ftop = val;
+		break;
+	default:
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 static int kvm_loongarch_cpucfg_has_attr(struct kvm_vcpu *vcpu,
 					 struct kvm_device_attr *attr)
 {
@@ -790,6 +884,9 @@ static int kvm_loongarch_vcpu_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
 		ret = kvm_loongarch_pvtime_has_attr(vcpu, attr);
 		break;
+	case KVM_LOONGARCH_VCPU_LBT:
+		ret = kvm_loongarch_lbt_has_attr(vcpu, attr);
+		break;
 	default:
 		break;
 	}
@@ -825,6 +922,9 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
 		ret = kvm_loongarch_pvtime_get_attr(vcpu, attr);
 		break;
+	case KVM_LOONGARCH_VCPU_LBT:
+		ret = kvm_loongarch_lbt_get_attr(vcpu, attr);
+		break;
 	default:
 		break;
 	}
@@ -850,6 +950,9 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
 		ret = kvm_loongarch_pvtime_set_attr(vcpu, attr);
 		break;
+	case KVM_LOONGARCH_VCPU_LBT:
+		ret = kvm_loongarch_lbt_set_attr(vcpu, attr);
+		break;
 	default:
 		break;
 	}
-- 
2.39.3


