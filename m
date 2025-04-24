Return-Path: <kvm+bounces-44076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B00A9A289
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:47:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 724D83BFAA6
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E4F1DE2CC;
	Thu, 24 Apr 2025 06:46:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBF61CEE90;
	Thu, 24 Apr 2025 06:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745477197; cv=none; b=mfapRi7PujoQoHb/2MpYberHBHbBHevM3saoX/73KAWbDyXvLq7e3UIV7LhWzsrZo6omsyZhCUq3zrrLN53/KJcsV+JCcwJp0YVSyKestn198mPDXQMChgMk6CJrwJUcAgHmDTm1slTwsjTyJ9ZlxqYWwyxMQ+6ZA8cKMQBXwkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745477197; c=relaxed/simple;
	bh=7Gan8JsZYAiRm1KenBbeoVXccD4iViTclcEidxrBTQE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lJ3Zisov4MZGQVR1JCARne8ATGCHIKTYSlzAoZlZSpOZ98AftjLZEW9S+RypaoNHCaDJOd3NmFMJrNePQZlwIC5c6FYJd2wktkFJIrqKyfNjt9bwEVXdKtZYjrpxluuuawudDAnf2fWU6SBCqordUzh0DL5YlI50hA7T03LumUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxaWpI3glojx_FAA--.984S3;
	Thu, 24 Apr 2025 14:46:32 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxXsVB3gloABqTAA--.39186S3;
	Thu, 24 Apr 2025 14:46:26 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] LoongArch: KVM: Add parameter exception code with exception handler
Date: Thu, 24 Apr 2025 14:46:24 +0800
Message-Id: <20250424064625.3928278-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250424064625.3928278-1-maobibo@loongson.cn>
References: <20250424064625.3928278-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxXsVB3gloABqTAA--.39186S3
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
 arch/loongarch/kvm/exit.c             | 26 ++++++++++++--------------
 2 files changed, 13 insertions(+), 15 deletions(-)

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
index ea321403644a..31b9d5f67e8f 100644
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
@@ -730,7 +730,7 @@ int kvm_complete_user_service(struct kvm_vcpu *vcpu, struct kvm_run *run)
  * Handle when the guest attempts to use fpu which hasn't been allowed
  * by the root context.
  */
-static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
+static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	struct kvm_run *run = vcpu->run;
 
@@ -787,7 +787,7 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
  * Handle when the guest attempts to use LSX when it is disabled in the root
  * context.
  */
-static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu)
+static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	if (kvm_own_lsx(vcpu))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
@@ -802,7 +802,7 @@ static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu)
  * Handle when the guest attempts to use LASX when it is disabled in the root
  * context.
  */
-static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
+static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	if (kvm_own_lasx(vcpu))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
@@ -810,7 +810,7 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
-static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu)
+static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	if (kvm_own_lbt(vcpu))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
@@ -872,7 +872,7 @@ static void kvm_handle_service(struct kvm_vcpu *vcpu)
 	kvm_write_reg(vcpu, LOONGARCH_GPR_A0, ret);
 }
 
-static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
+static int kvm_handle_hypercall(struct kvm_vcpu *vcpu, int ecode)
 {
 	int ret;
 	larch_inst inst;
@@ -932,16 +932,14 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
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
@@ -966,5 +964,5 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
 
 int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
 {
-	return kvm_fault_tables[fault](vcpu);
+	return kvm_fault_tables[fault](vcpu, fault);
 }
-- 
2.39.3


