Return-Path: <kvm+bounces-34334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6532B9FAB9C
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 09:42:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77E3F164B48
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 08:42:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB76D190052;
	Mon, 23 Dec 2024 08:42:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6183917E473;
	Mon, 23 Dec 2024 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734943343; cv=none; b=ba/Ow3Nonv5ONUUpZKDy6zBTXcjMczEJ2nxLwUSv1wrMcPBM4WPBzwdc0rbjEOtuqcKb1piEDm30m607wFwkcUyMQkVAHWfwEUe66RhPNkX8kdrUvmeHvQI3ydtwD5fMn+fa5lDiou9VxOmYvZnLXBEm1rz5A+7rvZ4/icg5crQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734943343; c=relaxed/simple;
	bh=5N+HOrsylq8j4X3NNIGdFjIhSuwouiXPXbk4Zgf2mJM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r/k+5DbnKFmJlw+ZKrQSyOko4Nu8qhFijJ0pFWIQE7hkn8mqdGFFJ4Ca4gIcQvRHpC6FkAHJcw3OvMgkwwofVzkEkIfuIqsvjGvrw5vSNA4KK6A7I203JwmYMcg1G6Tu1gAz5gWmdXYKd0x6s8rVcHji5I4Kpetk94GCTPOAzQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxieFnImlnlK9ZAA--.48474S3;
	Mon, 23 Dec 2024 16:42:15 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDx7sVkImlnn5kGAA--.27414S2;
	Mon, 23 Dec 2024 16:42:12 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Add hypercall service support for usermode VMM
Date: Mon, 23 Dec 2024 16:42:12 +0800
Message-Id: <20241223084212.34822-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDx7sVkImlnn5kGAA--.27414S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Some VMMs provides special hypercall service in usermode, KVM need
not handle the usermode hypercall service and pass it to VMM and
let VMM handle it.

Here new code KVM_HCALL_CODE_USER is added for user-mode hypercall
service, KVM loads all six registers to VMM.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h      |  1 +
 arch/loongarch/include/asm/kvm_para.h      |  2 ++
 arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
 arch/loongarch/kvm/exit.c                  | 22 ++++++++++++++++++++++
 arch/loongarch/kvm/vcpu.c                  |  3 +++
 5 files changed, 29 insertions(+)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 7b8367c39da8..590982cd986e 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -162,6 +162,7 @@ enum emulation_result {
 #define LOONGARCH_PV_FEAT_UPDATED	BIT_ULL(63)
 #define LOONGARCH_PV_FEAT_MASK		(BIT(KVM_FEATURE_IPI) |		\
 					 BIT(KVM_FEATURE_STEAL_TIME) |	\
+					 BIT(KVM_FEATURE_USER_HCALL) |	\
 					 BIT(KVM_FEATURE_VIRT_EXTIOI))
 
 struct kvm_vcpu_arch {
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index c4e84227280d..d3c00de484f6 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -13,12 +13,14 @@
 
 #define KVM_HCALL_CODE_SERVICE		0
 #define KVM_HCALL_CODE_SWDBG		1
+#define KVM_HCALL_CODE_USER		2
 
 #define KVM_HCALL_SERVICE		HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SERVICE)
 #define  KVM_HCALL_FUNC_IPI		1
 #define  KVM_HCALL_FUNC_NOTIFY		2
 
 #define KVM_HCALL_SWDBG			HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SWDBG)
+#define KVM_HCALL_USER_SERVICE		HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_USER)
 
 /*
  * LoongArch hypercall return code
diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/include/uapi/asm/kvm_para.h
index b0604aa9b4bb..76d802ef01ce 100644
--- a/arch/loongarch/include/uapi/asm/kvm_para.h
+++ b/arch/loongarch/include/uapi/asm/kvm_para.h
@@ -17,5 +17,6 @@
 #define  KVM_FEATURE_STEAL_TIME		2
 /* BIT 24 - 31 are features configurable by user space vmm */
 #define  KVM_FEATURE_VIRT_EXTIOI	24
+#define  KVM_FEATURE_USER_HCALL		25
 
 #endif /* _UAPI_ASM_KVM_PARA_H */
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index a7893bd01e73..1a85cd4fb6a5 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -873,6 +873,28 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->stat.hypercall_exits++;
 		kvm_handle_service(vcpu);
 		break;
+	case KVM_HCALL_USER_SERVICE:
+		if (!kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_USER_HCALL)) {
+			kvm_write_reg(vcpu, LOONGARCH_GPR_A0, KVM_HCALL_INVALID_CODE);
+			break;
+		}
+
+		vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
+		vcpu->run->hypercall.nr = KVM_HCALL_USER_SERVICE;
+		vcpu->run->hypercall.args[0] = kvm_read_reg(vcpu, LOONGARCH_GPR_A0);
+		vcpu->run->hypercall.args[1] = kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
+		vcpu->run->hypercall.args[2] = kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
+		vcpu->run->hypercall.args[3] = kvm_read_reg(vcpu, LOONGARCH_GPR_A3);
+		vcpu->run->hypercall.args[4] = kvm_read_reg(vcpu, LOONGARCH_GPR_A4);
+		vcpu->run->hypercall.args[5] = kvm_read_reg(vcpu, LOONGARCH_GPR_A5);
+		vcpu->run->hypercall.flags = 0;
+		/*
+		 * Set invalid return value by default
+		 * Need user-mode VMM modify it
+		 */
+		vcpu->run->hypercall.ret = KVM_HCALL_INVALID_CODE;
+		ret = RESUME_HOST;
+		break;
 	case KVM_HCALL_SWDBG:
 		/* KVM_HCALL_SWDBG only in effective when SW_BP is enabled */
 		if (vcpu->guest_debug & KVM_GUESTDBG_SW_BP_MASK) {
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index d18a4a270415..8c46ad1872ee 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1735,6 +1735,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (run->exit_reason == KVM_EXIT_LOONGARCH_IOCSR) {
 		if (!run->iocsr_io.is_write)
 			kvm_complete_iocsr_read(vcpu, run);
+	} else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
+		kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret);
+		update_pc(&vcpu->arch);
 	}
 
 	if (!vcpu->wants_to_run)

base-commit: 48f506ad0b683d3e7e794efa60c5785c4fdc86fa
-- 
2.39.3


