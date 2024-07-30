Return-Path: <kvm+bounces-22610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 574C2940A88
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:58:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1FA2285632
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 07:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1703819307B;
	Tue, 30 Jul 2024 07:57:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4E0191F9A;
	Tue, 30 Jul 2024 07:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722326269; cv=none; b=QumazfQWxCGR22xejIitSggYy8K8u5ecoXT9EYh85S7P7IrrYgw7ECtcRrdXNd6mmjGr8oZCyd8fRgy6/4pCzvcxf0K93yjbP6puHp5wkG1jj8ZCzpGl8jFsJXs0x8iKmojqd3tjdCgZk58dAdSYxpE/uqNQ0OOI8An5vRKFsWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722326269; c=relaxed/simple;
	bh=XIPefMNtYYJahTv+GhG0jhSwHAcnf/9zSrvytmzT32g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GvcsEi4ZOredgNj+n18xCw0Ve4XgmgmS6ysivswltTuPdbLQHc3U3kV5Jv58NzDnKpXfoJQMAgODwFAo+Cdi7JtAGdV1lkKaxYUfNLd+VwvqHwJH5FT+qC9dLo/iXiZiuCuXZtQCH4ajGXTxF0XqZ6Uw/hRfr0+CKJMzyDD7XFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Dxi+r6nKhmBFIEAA--.15246S3;
	Tue, 30 Jul 2024 15:57:46 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxX8f4nKhmrTUGAA--.30670S5;
	Tue, 30 Jul 2024 15:57:45 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v6 3/3] LoongArch: KVM: Add vm migration support for LBT registers
Date: Tue, 30 Jul 2024 15:57:43 +0800
Message-Id: <20240730075744.1215856-4-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowMAxX8f4nKhmrTUGAA--.30670S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Every vcpu has separate LBT registers. And there are four scr registers,
one flags and ftop register for LBT extension. When VM migrates, VMM
needs to get LBT registers for every vcpu.

Here macro KVM_REG_LOONGARCH_LBT is added for new vcpu lbt register type,
the following macro is added to get/put LBT registers.
  KVM_REG_LOONGARCH_LBT_SCR0
  KVM_REG_LOONGARCH_LBT_SCR1
  KVM_REG_LOONGARCH_LBT_SCR2
  KVM_REG_LOONGARCH_LBT_SCR3
  KVM_REG_LOONGARCH_LBT_EFLAGS
  KVM_REG_LOONGARCH_LBT_FTOP

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/uapi/asm/kvm.h |  9 +++++
 arch/loongarch/kvm/vcpu.c             | 56 +++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index 49bafac8b22d..003fb766c93f 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -64,6 +64,7 @@ struct kvm_fpu {
 #define KVM_REG_LOONGARCH_KVM		(KVM_REG_LOONGARCH | 0x20000ULL)
 #define KVM_REG_LOONGARCH_FPSIMD	(KVM_REG_LOONGARCH | 0x30000ULL)
 #define KVM_REG_LOONGARCH_CPUCFG	(KVM_REG_LOONGARCH | 0x40000ULL)
+#define KVM_REG_LOONGARCH_LBT		(KVM_REG_LOONGARCH | 0x50000ULL)
 #define KVM_REG_LOONGARCH_MASK		(KVM_REG_LOONGARCH | 0x70000ULL)
 #define KVM_CSR_IDX_MASK		0x7fff
 #define KVM_CPUCFG_IDX_MASK		0x7fff
@@ -77,6 +78,14 @@ struct kvm_fpu {
 /* Debugging: Special instruction for software breakpoint */
 #define KVM_REG_LOONGARCH_DEBUG_INST	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 3)
 
+/* LBT registers */
+#define KVM_REG_LOONGARCH_LBT_SCR0	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 1)
+#define KVM_REG_LOONGARCH_LBT_SCR1	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 2)
+#define KVM_REG_LOONGARCH_LBT_SCR2	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 3)
+#define KVM_REG_LOONGARCH_LBT_SCR3	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 4)
+#define KVM_REG_LOONGARCH_LBT_EFLAGS	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 5)
+#define KVM_REG_LOONGARCH_LBT_FTOP	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 6)
+
 #define LOONGARCH_REG_SHIFT		3
 #define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
 #define KVM_IOC_CSRID(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index b5324885a81a..b2500d4fa729 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -597,6 +597,34 @@ static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
 			break;
 		}
 		break;
+	case KVM_REG_LOONGARCH_LBT:
+		if (!kvm_guest_has_lbt(&vcpu->arch))
+			return -ENXIO;
+
+		switch (reg->id) {
+		case KVM_REG_LOONGARCH_LBT_SCR0:
+			*v = vcpu->arch.lbt.scr0;
+			break;
+		case KVM_REG_LOONGARCH_LBT_SCR1:
+			*v = vcpu->arch.lbt.scr1;
+			break;
+		case KVM_REG_LOONGARCH_LBT_SCR2:
+			*v = vcpu->arch.lbt.scr2;
+			break;
+		case KVM_REG_LOONGARCH_LBT_SCR3:
+			*v = vcpu->arch.lbt.scr3;
+			break;
+		case KVM_REG_LOONGARCH_LBT_EFLAGS:
+			*v = vcpu->arch.lbt.eflags;
+			break;
+		case KVM_REG_LOONGARCH_LBT_FTOP:
+			*v = vcpu->arch.fpu.ftop;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -663,6 +691,34 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
 			break;
 		}
 		break;
+	case KVM_REG_LOONGARCH_LBT:
+		if (!kvm_guest_has_lbt(&vcpu->arch))
+			return -ENXIO;
+
+		switch (reg->id) {
+		case KVM_REG_LOONGARCH_LBT_SCR0:
+			vcpu->arch.lbt.scr0 = v;
+			break;
+		case KVM_REG_LOONGARCH_LBT_SCR1:
+			vcpu->arch.lbt.scr1 = v;
+			break;
+		case KVM_REG_LOONGARCH_LBT_SCR2:
+			vcpu->arch.lbt.scr2 = v;
+			break;
+		case KVM_REG_LOONGARCH_LBT_SCR3:
+			vcpu->arch.lbt.scr3 = v;
+			break;
+		case KVM_REG_LOONGARCH_LBT_EFLAGS:
+			vcpu->arch.lbt.eflags = v;
+			break;
+		case KVM_REG_LOONGARCH_LBT_FTOP:
+			vcpu->arch.fpu.ftop = v;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.39.3


