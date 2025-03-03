Return-Path: <kvm+bounces-39865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB75BA4BA75
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 10:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 374A616AAEE
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 09:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AFE41F03F1;
	Mon,  3 Mar 2025 09:11:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A771F03E1;
	Mon,  3 Mar 2025 09:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740993085; cv=none; b=mfvKJpQkMKg6e+6c4C/yORgBGBzbS1mpDPCFFFN+gyJc6JuhwEebOut42xgJGCx3Zh9VTG4whQAL8awHChEkfXxqKBGnODTQBs64sPAjftcqYR+zlv+Oob6i35QLZZvB6TkOt+owDXJsK0E5g9uUTBCRxeusNsbGRM9uZZ2EpJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740993085; c=relaxed/simple;
	bh=3P7asazvVhA6Z+2Oqdc1BRq4108S/dF7oNeQJkxp/Z8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VylxTvPkKLRfaPY73wUDW2kCLHPQ3VvHCZ1tFCilMI6bARpXw/oojR61tOfj9uh4XNWPKKLw2Axl5u06fHuFChRoiGAQila46VDkRQsft6m0yyC/AopCQUi1i8ild3oLylftbh75R9hM7pk1zGIu02aIpti3f+VBxpQ9KC2/Ts0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxeXE2csVn7AiJAA--.37601S3;
	Mon, 03 Mar 2025 17:11:18 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxDcUycsVni4AzAA--.57137S2;
	Mon, 03 Mar 2025 17:11:15 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xianglai Li <lixianglai@loongson.cn>
Subject: [PATCH] LoongArch: KVM: Reload guest CSR registers after S4
Date: Mon,  3 Mar 2025 17:11:14 +0800
Message-Id: <20250303091114.1511496-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxDcUycsVni4AzAA--.57137S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

On host HW guest CSR registers are lost after suspend and resume
operation. Since last_vcpu of boot CPU still records latest vCPU pointer
so that guest CSR register skips to reload when boot CPU resumes and
vCPU is scheduled.

Here last_vcpu is cleared so that guest CSR register will reload from
scheduled vCPU context after suspend and resume.

Also there is another small fix for Loongson AVEC support, bit 14 is added
in CSR ESTAT register. Macro CSR_ESTAT_IS is replaced with hardcoded value
0x1fff and AVEC interrupt status bit 14 is supported with macro
CSR_ESTAT_IS.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/main.c | 8 ++++++++
 arch/loongarch/kvm/vcpu.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index f6d3242b9234..b177773f38f6 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -284,6 +284,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 int kvm_arch_enable_virtualization_cpu(void)
 {
 	unsigned long env, gcfg = 0;
+	struct kvm_context *context;
 
 	env = read_csr_gcfg();
 
@@ -317,6 +318,13 @@ int kvm_arch_enable_virtualization_cpu(void)
 	kvm_debug("GCFG:%lx GSTAT:%lx GINTC:%lx GTLBC:%lx",
 		  read_csr_gcfg(), read_csr_gstat(), read_csr_gintc(), read_csr_gtlbc());
 
+	/*
+	 * HW Guest CSR registers are lost after CPU suspend and resume
+	 * Clear last_vcpu so that Guest CSR register forced to reload
+	 * from vCPU SW state
+	 */
+	context = this_cpu_ptr(vmcs);
+	context->last_vcpu = NULL;
 	return 0;
 }
 
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 20f941af3e9e..9e1a9b4aa4c6 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -311,7 +311,7 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 {
 	int ret = RESUME_GUEST;
 	unsigned long estat = vcpu->arch.host_estat;
-	u32 intr = estat & 0x1fff; /* Ignore NMI */
+	u32 intr = estat & CSR_ESTAT_IS;
 	u32 ecode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
 
 	vcpu->mode = OUTSIDE_GUEST_MODE;

base-commit: 1e15510b71c99c6e49134d756df91069f7d18141
-- 
2.39.3


