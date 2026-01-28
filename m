Return-Path: <kvm+bounces-69313-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOxGEsZ8eWldxQEAu9opvQ
	(envelope-from <kvm+bounces-69313-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:04:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DF6699C79E
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:04:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 896923046F05
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 03:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A282D6E7C;
	Wed, 28 Jan 2026 03:03:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0ADE2C3757;
	Wed, 28 Jan 2026 03:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769569424; cv=none; b=eoIU+jGTCYJHLiO93kUuCNxlGpvGCbeq56HNdNW7pjbhppW6ayR/7KWlqyPc2Lo7sm0+59hpOGKQcJtX87PafiiQophhtErgA/jYQUzbZYvffUofJTk4e3zbs6CVHflBoC78sKLLzwCgGTGPtUc5DBeKYCXQHDqN5CqxtqFRKus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769569424; c=relaxed/simple;
	bh=3TEgnr20UfbqEXkJKlS4PbC4d+oiy/L7NR0S+I0EWEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oUGn77p5bKiHj7WgA6evlGpX3j8cXt2F0YRkhyczBi+qEe0yBbbSLKy4R3GFlASQ7z4PDv84k7AH3G7wx3byUD5ApgIqDPieMOHENfcXU07hvVtMfPSl5wo+1b07G95PBBeoSbG3zBLg1qSM/bP1sC+eGwGO6Yyv5y2CEy3VYLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Axz8OEfHlpAWMNAA--.44141S3;
	Wed, 28 Jan 2026 11:03:32 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxaeB_fHlpfUg2AA--.40601S5;
	Wed, 28 Jan 2026 11:03:32 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 3/4] LoongArch: KVM: Check VM msgint feature during interrupt handling
Date: Wed, 28 Jan 2026 11:03:25 +0800
Message-Id: <20260128030326.3377462-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260128030326.3377462-1-maobibo@loongson.cn>
References: <20260128030326.3377462-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxaeB_fHlpfUg2AA--.40601S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_FROM(0.00)[bounces-69313-lists,kvm=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Queue-Id: DF6699C79E
X-Rspamd-Action: no action

During message interrupt handling and relative CSR registers saving
and restore, it is better to check VM msgint feature rather than
host msgint feature, because VM may disable this feature even if
host supports this.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h | 5 +++++
 arch/loongarch/kvm/interrupt.c        | 4 ++--
 arch/loongarch/kvm/vcpu.c             | 4 ++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index e4fe5b8e8149..bced2d607849 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -265,6 +265,11 @@ static inline void writel_sw_gcsr(struct loongarch_csrs *csr, int reg, unsigned
 	csr->csrs[reg] = val;
 }
 
+static inline bool kvm_guest_has_msgint(struct kvm_vcpu_arch *arch)
+{
+	return arch->cpucfg[1] & CPUCFG1_MSGINT;
+}
+
 static inline bool kvm_guest_has_fpu(struct kvm_vcpu_arch *arch)
 {
 	return arch->cpucfg[2] & CPUCFG2_FP;
diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
index a6d42d399a59..fb704f4c8ac5 100644
--- a/arch/loongarch/kvm/interrupt.c
+++ b/arch/loongarch/kvm/interrupt.c
@@ -32,7 +32,7 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 	if (priority < EXCCODE_INT_NUM)
 		irq = priority_to_irq[priority];
 
-	if (cpu_has_msgint && (priority == INT_AVEC)) {
+	if (kvm_guest_has_msgint(&vcpu->arch) && (priority == INT_AVEC)) {
 		set_gcsr_estat(irq);
 		return 1;
 	}
@@ -64,7 +64,7 @@ static int kvm_irq_clear(struct kvm_vcpu *vcpu, unsigned int priority)
 	if (priority < EXCCODE_INT_NUM)
 		irq = priority_to_irq[priority];
 
-	if (cpu_has_msgint && (priority == INT_AVEC)) {
+	if (kvm_guest_has_msgint(&vcpu->arch) && (priority == INT_AVEC)) {
 		clear_gcsr_estat(irq);
 		return 1;
 	}
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 656b954c1134..6d9953d0b7be 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1661,7 +1661,7 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
 	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
 	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_LLBCTL);
-	if (cpu_has_msgint) {
+	if (kvm_guest_has_msgint(&vcpu->arch)) {
 		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR0);
 		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
 		kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
@@ -1756,7 +1756,7 @@ static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
 	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN1);
 	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
 	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
-	if (cpu_has_msgint) {
+	if (kvm_guest_has_msgint(&vcpu->arch)) {
 		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR0);
 		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
 		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
-- 
2.39.3


