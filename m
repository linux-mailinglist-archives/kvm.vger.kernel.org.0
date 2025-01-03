Return-Path: <kvm+bounces-34515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E737CA002C1
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 03:31:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00A481883E6C
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 02:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D749195B37;
	Fri,  3 Jan 2025 02:31:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02823535D8;
	Fri,  3 Jan 2025 02:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735871461; cv=none; b=SdX+hyz5vWGkCtuBVeKQkj96mDuZUxl78WppFp4i4BgYkRuEEkrTI8XTYZBZdKoPhwjFmYwKRSdaktREKm2bTTGN1IYHua+k/XAWLowibrHeBbTx6OUZcEbrR4XV9mQjz+oPqiSwJJzzAZGZgv/R6ONriDD/2cG4UWAOGKB3CsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735871461; c=relaxed/simple;
	bh=HCz1+DL0S31A6w3e9vlA6QPUfW8R3oHvcVzw+RH2Vbg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dh1Hmh6l38lkfX5ObYpQDNj1pTVOFwKRrjKQ3mWqWIquS1iKdyo7DCj/LTnMLIRVg2vGW0VNO7a1SQucVrAyBd7qbvkjl2uJs/mIMRNJciUpLnomhtwTG8gIlIdrxAUi/W6uzWHXUP/dvvAjXbgyHwmTovcK2gnJ0JeJDFquzSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxSOHfS3dnvnFdAA--.52273S3;
	Fri, 03 Jan 2025 10:30:55 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxQMbdS3dnBgUSAA--.17426S2;
	Fri, 03 Jan 2025 10:30:54 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] LoongArch: KVM: Add hypercall service support for usermode VMM
Date: Fri,  3 Jan 2025 10:30:53 +0800
Message-Id: <20250103023053.2625226-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxQMbdS3dnBgUSAA--.17426S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Some VMMs provides special hypercall service in usermode, KVM need
not handle the usermode hypercall service and pass it to VMM and
let VMM handle it.

Here new code KVM_HCALL_CODE_USER is added for user-mode hypercall
service, KVM lets all six registers visiable to VMM.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
  v1 ... v2:
  1. Add function kvm_complete_user_service() when finish hypercall
     in user-mode VMM and continue to run.
  2. Add hypercall_exits stat information.
---
 arch/loongarch/include/asm/kvm_host.h      |  1 +
 arch/loongarch/include/asm/kvm_para.h      |  2 ++
 arch/loongarch/include/asm/kvm_vcpu.h      |  1 +
 arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
 arch/loongarch/kvm/exit.c                  | 30 ++++++++++++++++++++++
 arch/loongarch/kvm/vcpu.c                  |  3 ++-
 6 files changed, 37 insertions(+), 1 deletion(-)

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
diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
index d7e8f7d50ee0..2c349f961bfb 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -43,6 +43,7 @@ int  kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst);
 int  kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst);
 int  kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int  kvm_complete_iocsr_read(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int  kvm_complete_user_service(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int  kvm_emu_idle(struct kvm_vcpu *vcpu);
 int  kvm_pending_timer(struct kvm_vcpu *vcpu);
 int  kvm_handle_fault(struct kvm_vcpu *vcpu, int fault);
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
index a7893bd01e73..70b5ed1241c4 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -538,6 +538,13 @@ int kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return er;
 }
 
+int kvm_complete_user_service(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	update_pc(&vcpu->arch);
+	kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret);
+	return 0;
+}
+
 int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
 {
 	int idx, ret;
@@ -873,6 +880,29 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->stat.hypercall_exits++;
 		kvm_handle_service(vcpu);
 		break;
+	case KVM_HCALL_USER_SERVICE:
+		if (!kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_USER_HCALL)) {
+			kvm_write_reg(vcpu, LOONGARCH_GPR_A0, KVM_HCALL_INVALID_CODE);
+			break;
+		}
+
+		vcpu->stat.hypercall_exits++;
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
index d18a4a270415..888480a5bc25 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1735,7 +1735,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (run->exit_reason == KVM_EXIT_LOONGARCH_IOCSR) {
 		if (!run->iocsr_io.is_write)
 			kvm_complete_iocsr_read(vcpu, run);
-	}
+	} else if (run->exit_reason == KVM_EXIT_HYPERCALL)
+		kvm_complete_user_service(vcpu, run);
 
 	if (!vcpu->wants_to_run)
 		return r;

base-commit: fc033cf25e612e840e545f8d5ad2edd6ba613ed5
-- 
2.39.3


