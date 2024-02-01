Return-Path: <kvm+bounces-7654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C4A844F88
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 04:20:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B21F1C24259
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 03:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBB63BB36;
	Thu,  1 Feb 2024 03:19:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DEF3B296;
	Thu,  1 Feb 2024 03:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706757596; cv=none; b=XHw0t1YCefTTLAY0xG0GxuriUvl6VWlIkiIbp9BXbt0jP+4lCvCEyW/Z0GJhAGczotoWaONnOAQrkc+qoHV79NSx6f9vim1k6lFOjH7M/m8gWo4wKVYIdu68xAEsXQ2/5Xh4b2hTTr+127bgMJLJe098+TTvxEo/xLExgSCthtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706757596; c=relaxed/simple;
	bh=vYY75mEcrFqyUH03Iee6WBIiGl6hWzhBFEhyJ4/09n4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YMY7USjmOcOrZfANOXXyUku/EArHjbk07dgoBbG6FThfNPFZGGBjBYD9lZKsTkUdt7KOSrxpiUzKncg6GwWuaIBJfMnvfT49ys5NCUc79yffAggPMbUsdI96fZ1Vuv9ebbMJe4xjEOwTxlvlug8q62kojubIrIiHY1CMha/UbVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxmejYDbtlNlQJAA--.8022S3;
	Thu, 01 Feb 2024 11:19:52 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxfRPWDbtltkIrAA--.3273S4;
	Thu, 01 Feb 2024 11:19:51 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v4 2/6] LoongArch: KVM: Add hypercall instruction emulation support
Date: Thu,  1 Feb 2024 11:19:46 +0800
Message-Id: <20240201031950.3225626-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240201031950.3225626-1-maobibo@loongson.cn>
References: <20240201031950.3225626-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxfRPWDbtltkIrAA--.3273S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXr1DuFW7XF17Gw1DKF47ZFc_yoW5Zr45pF
	97Crn5GF48GryfCFy3K3s0gr13Ars7K342gFWak3yUAF12qw1Fyr4kKryDZFyUJa1rXF1S
	gFWftw1Y9F4UtabCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r126r13M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4ApnDUUUU

On LoongArch system, hypercall instruction is supported when system
runs on VM mode. This patch adds dummy function with hypercall
instruction emulation, rather than inject EXCCODE_INE invalid
instruction exception.

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
index 000000000000..9425d3b7e486
--- /dev/null
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_LOONGARCH_KVM_PARA_H
+#define _ASM_LOONGARCH_KVM_PARA_H
+
+/*
+ * LoongArch hypcall return code
+ */
+#define KVM_HC_STATUS_SUCCESS		0
+#define KVM_HC_INVALID_CODE		-1UL
+#define KVM_HC_INVALID_PARAMETER	-2UL
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
index ed1d89d53e2e..d15c71320a11 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -685,6 +685,15 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static int kvm_handle_hypcall(struct kvm_vcpu *vcpu)
+{
+	update_pc(&vcpu->arch);
+
+	/* Treat it as noop intruction, only set return value */
+	vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HC_INVALID_CODE;
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
+	[EXCCODE_HVC]			= kvm_handle_hypcall,
 };
 
 int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
-- 
2.39.3


