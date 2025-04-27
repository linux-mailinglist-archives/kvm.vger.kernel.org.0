Return-Path: <kvm+bounces-44475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FDFA9DEBB
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 04:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B54C1A80E1F
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 02:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB95C21480A;
	Sun, 27 Apr 2025 02:45:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7607A1F8ACA;
	Sun, 27 Apr 2025 02:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745721912; cv=none; b=mc7R5pHonJiUqAwchVHP5OLvNNaMW/BidACzTSZlQX9JMoaQcU+ZBIznm6DNaYgThdCTDm5nq66WIHIII/kemoUzT3oL1rWg4vLerGn2mqBV1UuNuPTfzLheK6GQcf2sGwIRVxAtW42KH/LSDCSzjSFIaZEUfqaqj0jTMcfrLqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745721912; c=relaxed/simple;
	bh=nAUe+zERY6Zmdrwik7Z/+270Qqo+XVLUqfdyxPHwud4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oSEPIcGNMVg5RyaYNSBrZJZUGpuMsH8+G12+Lf/yDHxBdBZEiSCDjE1WIQO/FxZN2gAGWqGAl6C5X9r+uacVHxdx0bQgiXJyRqzu2qO1gMtMGrOVdDuPRJP9kRjQWXSe296KkiiYWaz1u53TOhc7VoCdPdEFYg82s4RhQpcT/3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxyuAzmg1oygrHAA--.2613S3;
	Sun, 27 Apr 2025 10:45:07 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMCxLcUxmg1oz+WXAA--.49302S3;
	Sun, 27 Apr 2025 10:45:06 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] LoongArch: KVM: Add parameter exception code with exception handler
Date: Sun, 27 Apr 2025 10:45:04 +0800
Message-Id: <20250427024505.129383-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250427024505.129383-1-maobibo@loongson.cn>
References: <20250427024505.129383-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxLcUxmg1oz+WXAA--.49302S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With some KVM exception types, they share the same exception function
handler. To show the difference, exception code is added as new
parameter in exception handler.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_vcpu.h |  2 +-
 arch/loongarch/kvm/exit.c             | 29 ++++++++++++++-------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
index 2c349f961bfb..b0a6cac07ed8 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -37,7 +37,7 @@
 #define KVM_LOONGSON_IRQ_NUM_MASK	0xffff
 
 typedef union loongarch_instruction  larch_inst;
-typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+typedef int (*exit_handle_fn)(struct kvm_vcpu *, int ecode);
 
 int  kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst);
 int  kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst);
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ea321403644a..e143fa3d21d4 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -341,7 +341,7 @@ static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
  * 2) Execute CACOP/IDLE instructions;
  * 3) Access to unimplemented CSRs/IOCSRs.
  */
-static int kvm_handle_gspr(struct kvm_vcpu *vcpu)
+static int kvm_handle_gspr(struct kvm_vcpu *vcpu, int ecode)
 {
 	int ret = RESUME_GUEST;
 	enum emulation_result er = EMULATE_DONE;
@@ -705,12 +705,12 @@ static int kvm_handle_rdwr_fault(struct kvm_vcpu *vcpu, bool write)
 	return ret;
 }
 
-static int kvm_handle_read_fault(struct kvm_vcpu *vcpu)
+static int kvm_handle_read_fault(struct kvm_vcpu *vcpu, int ecode)
 {
 	return kvm_handle_rdwr_fault(vcpu, false);
 }
 
-static int kvm_handle_write_fault(struct kvm_vcpu *vcpu)
+static int kvm_handle_write_fault(struct kvm_vcpu *vcpu, int ecode)
 {
 	return kvm_handle_rdwr_fault(vcpu, true);
 }
@@ -726,11 +726,12 @@ int kvm_complete_user_service(struct kvm_vcpu *vcpu, struct kvm_run *run)
 /**
  * kvm_handle_fpu_disabled() - Guest used fpu however it is disabled at host
  * @vcpu:	Virtual CPU context.
+ * @ecode:	Exception code.
  *
  * Handle when the guest attempts to use fpu which hasn't been allowed
  * by the root context.
  */
-static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
+static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	struct kvm_run *run = vcpu->run;
 
@@ -783,11 +784,12 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
 /*
  * kvm_handle_lsx_disabled() - Guest used LSX while disabled in root.
  * @vcpu:      Virtual CPU context.
+ * @ecode:	Exception code.
  *
  * Handle when the guest attempts to use LSX when it is disabled in the root
  * context.
  */
-static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu)
+static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	if (kvm_own_lsx(vcpu))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
@@ -798,11 +800,12 @@ static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu)
 /*
  * kvm_handle_lasx_disabled() - Guest used LASX while disabled in root.
  * @vcpu:	Virtual CPU context.
+ * @ecode:	Exception code.
  *
  * Handle when the guest attempts to use LASX when it is disabled in the root
  * context.
  */
-static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
+static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	if (kvm_own_lasx(vcpu))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
@@ -810,7 +813,7 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
-static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu)
+static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	if (kvm_own_lbt(vcpu))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
@@ -872,7 +875,7 @@ static void kvm_handle_service(struct kvm_vcpu *vcpu)
 	kvm_write_reg(vcpu, LOONGARCH_GPR_A0, ret);
 }
 
-static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
+static int kvm_handle_hypercall(struct kvm_vcpu *vcpu, int ecode)
 {
 	int ret;
 	larch_inst inst;
@@ -932,16 +935,14 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
 /*
  * LoongArch KVM callback handling for unimplemented guest exiting
  */
-static int kvm_fault_ni(struct kvm_vcpu *vcpu)
+static int kvm_fault_ni(struct kvm_vcpu *vcpu, int ecode)
 {
-	unsigned int ecode, inst;
-	unsigned long estat, badv;
+	unsigned int inst;
+	unsigned long badv;
 
 	/* Fetch the instruction */
 	inst = vcpu->arch.badi;
 	badv = vcpu->arch.badv;
-	estat = vcpu->arch.host_estat;
-	ecode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
 	kvm_err("ECode: %d PC=%#lx Inst=0x%08x BadVaddr=%#lx ESTAT=%#lx\n",
 			ecode, vcpu->arch.pc, inst, badv, read_gcsr_estat());
 	kvm_arch_vcpu_dump_regs(vcpu);
@@ -966,5 +967,5 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
 
 int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
 {
-	return kvm_fault_tables[fault](vcpu);
+	return kvm_fault_tables[fault](vcpu, fault);
 }
-- 
2.39.3


