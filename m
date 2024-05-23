Return-Path: <kvm+bounces-18013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC8618CCAFA
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 05:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59015B21A75
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 03:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3173813B5AF;
	Thu, 23 May 2024 03:10:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82AA113AA36;
	Thu, 23 May 2024 03:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716433834; cv=none; b=TfBw1n+8S0kBoAJJEaQvVY9jjmp2V2Mwz9KLABt7RekLwKz0S9BxCXMXr3etqnHuUXj0MIWOwpPFYdQ/ckxChk2O7ST5pn1hRA74dm6G+1x8ClIf3hFApTleSV7pFXVHUALvtzcSC4jj1kf6CUZ3yFRjarq3CnAImLq1Wy7iQNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716433834; c=relaxed/simple;
	bh=yl0YeOCAMuOOnYJpsOb36BCTJQvxRUa3gHgD445SpJI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YEWnwM2P8Bhq7fPHE47+IfxsvES4Usr4UVJlfB5/6DKwNYdY41BYKCM0ka14e4zRG3WRP8U8XnTMaNIkVhmW8mwcoJgZ6U2XyJ1ARs4kkQVTNHO24K3fihGyzukK9tFp1uYDHwrjWSgyXvZKHgUBjlwRawUsXMZzIwMhpCg+p2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxGOqgs05mXOQCAA--.2554S3;
	Thu, 23 May 2024 11:10:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxNMWfs05mCEQGAA--.6973S5;
	Thu, 23 May 2024 11:10:24 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] LoongArch: KVM: Add vm migration support for LBT registers
Date: Thu, 23 May 2024 11:10:22 +0800
Message-Id: <20240523031023.709347-4-maobibo@loongson.cn>
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
X-CM-TRANSID:AQAAf8DxNMWfs05mCEQGAA--.6973S5
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
index ddc5cab0ffd0..656aa6a723a6 100644
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
index c32aff8e261e..3783151fde32 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -636,6 +636,34 @@ static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
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
@@ -702,6 +730,34 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
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


