Return-Path: <kvm+bounces-9351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C803185EFD6
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 04:28:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 052911C2148B
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 03:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFEF1B27A;
	Thu, 22 Feb 2024 03:28:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5DB31428E;
	Thu, 22 Feb 2024 03:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708572490; cv=none; b=JWWIFQ/lWxpFe5tlcgVfv+ZW4LijNtvHUf3heD91DMmvfLU+1WFB89rYNO/TTr90NDBMZK4HVxUd+zMiytQSHPZJRZiICwLRMCJNtS/lGrqsYSoF6fNy3KQKTyVRCA6h0m5EdJ/fkjZ6U9+7pAbMnXi3XV+6QflX8vNaTVMo+v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708572490; c=relaxed/simple;
	bh=AIgU3C1lGFAHJETtO9EJyAbpUdgl6hQx0pIjXkFE8XY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SFQiL2VscqVR6cUrn4xpnBDLwAWkXOb1zDI3Mos+g53Sb7m+K5J1MmayQ6szOcu9UEBFDTMT4KzlPA2AOb5INeg9NLclbUrZV6xNGPW/s1sj6OTAHw0wrKmvxoelDxOMqPmX7L69hGX+lD06FUBvOM79rPKx+w2ce8CsVEvphko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxiehGv9ZlXgoQAA--.22382S3;
	Thu, 22 Feb 2024 11:28:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxrhNDv9Zl+nM+AA--.41033S4;
	Thu, 22 Feb 2024 11:28:05 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v5 2/6] LoongArch: KVM: Add hypercall instruction emulation support
Date: Thu, 22 Feb 2024 11:27:59 +0800
Message-Id: <20240222032803.2177856-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240222032803.2177856-1-maobibo@loongson.cn>
References: <20240222032803.2177856-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxrhNDv9Zl+nM+AA--.41033S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxWr1kWrWfuFyDGrW5tF1fGrX_yoW5tr47pF
	93Crn5GF48GryfCFy3K34qgr13ArZ7Kw12gFWak3y5AF12qF1Fyr4kKryDZFy5Ja1rZF1S
	gFs3tr1Y9F4UJ3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
	0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j2MKZUUUUU=

On LoongArch system, there is hypercall instruction special for
virtualization. When system executes this instruction on host side,
there is illegal instruction exception reported, however it will
trap into host when it is executed in VM mode.

When hypercall is emulated, A0 register is set with value
KVM_HCALL_INVALID_CODE, rather than inject EXCCODE_INE invalid
instruction exception. So VM can continue to executing the next code.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/Kbuild      |  1 -
 arch/loongarch/include/asm/kvm_para.h  | 26 ++++++++++++++++++++++++++
 arch/loongarch/include/uapi/asm/Kbuild |  2 --
 arch/loongarch/kvm/exit.c              | 10 ++++++++++
 4 files changed, 36 insertions(+), 3 deletions(-)
 create mode 100644 arch/loongarch/include/asm/kvm_para.h
 delete mode 100644 arch/loongarch/include/uapi/asm/Kbuild

diff --git a/arch/loongarch/include/asm/Kbuild b/arch/loongarch/include/asm/Kbuild
index 93783fa24f6e..22991a6f0e2b 100644
--- a/arch/loongarch/include/asm/Kbuild
+++ b/arch/loongarch/include/asm/Kbuild
@@ -23,4 +23,3 @@ generic-y += poll.h
 generic-y += param.h
 generic-y += posix_types.h
 generic-y += resource.h
-generic-y += kvm_para.h
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
new file mode 100644
index 000000000000..d48f993ae206
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_LOONGARCH_KVM_PARA_H
+#define _ASM_LOONGARCH_KVM_PARA_H
+
+/*
+ * LoongArch hypercall return code
+ */
+#define KVM_HCALL_STATUS_SUCCESS	0
+#define KVM_HCALL_INVALID_CODE		-1UL
+#define KVM_HCALL_INVALID_PARAMETER	-2UL
+
+static inline unsigned int kvm_arch_para_features(void)
+{
+	return 0;
+}
+
+static inline unsigned int kvm_arch_para_hints(void)
+{
+	return 0;
+}
+
+static inline bool kvm_check_and_clear_guest_paused(void)
+{
+	return false;
+}
+#endif /* _ASM_LOONGARCH_KVM_PARA_H */
diff --git a/arch/loongarch/include/uapi/asm/Kbuild b/arch/loongarch/include/uapi/asm/Kbuild
deleted file mode 100644
index 4aa680ca2e5f..000000000000
--- a/arch/loongarch/include/uapi/asm/Kbuild
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-generic-y += kvm_para.h
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ed1d89d53e2e..923bbca9bd22 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -685,6 +685,15 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
+{
+	update_pc(&vcpu->arch);
+
+	/* Treat it as noop intruction, only set return value */
+	vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HCALL_INVALID_CODE;
+	return RESUME_GUEST;
+}
+
 /*
  * LoongArch KVM callback handling for unimplemented guest exiting
  */
@@ -716,6 +725,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
 	[EXCCODE_LSXDIS]		= kvm_handle_lsx_disabled,
 	[EXCCODE_LASXDIS]		= kvm_handle_lasx_disabled,
 	[EXCCODE_GSPR]			= kvm_handle_gspr,
+	[EXCCODE_HVC]			= kvm_handle_hypercall,
 };
 
 int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
-- 
2.39.3


