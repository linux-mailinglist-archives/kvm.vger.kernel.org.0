Return-Path: <kvm+bounces-22209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D3593BB42
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 05:34:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C0881C2297F
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 03:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689441C286;
	Thu, 25 Jul 2024 03:34:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55A71C6A3;
	Thu, 25 Jul 2024 03:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721878458; cv=none; b=Ao2udfuivmqkxY30W1e9ZriSdqNHzHEpnUWZFosgVSJHyiP/zy7SWV4qoQ7sDojYNfUrjadvVH0nHoLmxskXXewCNjRbTfNAUHKyKe85TUkZvOt/I96GvMu9ddrE4Hzr6aJJ6q6Axzth8hU/4cMiRuqQvOc4DA+QHC1VklnRZBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721878458; c=relaxed/simple;
	bh=3JiK5bvfiVwsBCbg5kudqDXogJePvcqJ6U9YebVM7RU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h7QpWknUdMC+zmyfThLPbdnk6My4LDobso3d46coW4Y9Ab3qfqUawfjEZPHey33dHlmYHsNYrJqPbYdVX1fkrf10Z9qi+YcNg+sc4XaccLAnXzpPC9E2qHzS/17IJT/XTHyHlRIdAZtxEgMiMB9N81QV2ykGhisq4Zyfyrc6jEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.10.34])
	by gateway (Coremail) with SMTP id _____8Bx7eqxx6Fm81UBAA--.5278S3;
	Thu, 25 Jul 2024 11:34:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.10.34])
	by front1 (Coremail) with SMTP id qMiowMBxicWsx6FmppEAAA--.37S5;
	Thu, 25 Jul 2024 11:34:09 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v5 3/3] LoongArch: KVM: Add vm migration support for LBT registers
Date: Thu, 25 Jul 2024 11:34:04 +0800
Message-Id: <20240725033404.2675204-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240725033404.2675204-1-maobibo@loongson.cn>
References: <20240725033404.2675204-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxicWsx6FmppEAAA--.37S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXr1rAFW3uw1DZF1Dury5KFX_yoWrAr17pr
	1DArs3Gr18Krn3C3yxKF1q9r17Xr4IkrWkZFySqa18Kr90vryFyw4ktr9xGFy3Jr48u3yf
	C3Wvyw4jkF1xJ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_
	Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjxU4AhLUUUUU

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
index aeb5f76a86c1..76719bf522b7 100644
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
-- 
2.39.3


