Return-Path: <kvm+bounces-69315-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDqpLMp8eWldxQEAu9opvQ
	(envelope-from <kvm+bounces-69315-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:04:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DEA79C7B5
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B52AB300EBD0
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 03:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D2872DA75B;
	Wed, 28 Jan 2026 03:03:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD7D2C3248;
	Wed, 28 Jan 2026 03:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769569424; cv=none; b=TyAh472OcxPWSi1Fv2o8dBdmY6mEyfHMImYNdiEXN3DZIHcLbZKzqZKOZOvtAasVmTYrbNTJ3+Cb05Ba9TPN5cnbaKNL1DRFXBfiSVP65qBHbR5qOSq94lWSTzBgm4qm7KrCU8fFrRfc++vMhIAvlQmNORy25zermplMIanXVTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769569424; c=relaxed/simple;
	bh=esmrRAWV32wi8JXlteqNrYuH+IbazgNJ6/6QEtR9FaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PXt1xY8/2OLY/lUnOUCthGGTDG1lCSf/Zj+OCNGUD5BtmxEb4WW7vuonzqq9brlOeNEof5XTTO9F2M4EIhgBmQOwapQ0ILeVcaiWO71JaQya1uCKpn3VVFECb1j8AnZ4dNSkRRNL/YMh4HKRJFsVndlJhJERANSXU8ilV0SWnDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxusKDfHlp+2INAA--.43215S3;
	Wed, 28 Jan 2026 11:03:31 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxaeB_fHlpfUg2AA--.40601S3;
	Wed, 28 Jan 2026 11:03:31 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 1/4] LoongArch: KVM: Move feature detection in function kvm_vm_init_features
Date: Wed, 28 Jan 2026 11:03:23 +0800
Message-Id: <20260128030326.3377462-2-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJDxaeB_fHlpfUg2AA--.40601S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
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
	NEURAL_HAM(-0.00)[-0.993];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_FROM(0.00)[bounces-69315-lists,kvm=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,loongson.cn:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1DEA79C7B5
X-Rspamd-Action: no action

VM feature detection is sparsed in function kvm_vm_init_features()
and kvm_vm_feature_has_attr(). Here move all the feature detection
in function kvm_vm_init_features(), and there is only feature checking
in function kvm_vm_feature_has_attr().

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vm.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 194ccbcdc3b3..ae79c50db9e1 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -40,6 +40,21 @@ static void kvm_vm_init_features(struct kvm *kvm)
 		kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
 		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_PV_STEALTIME);
 	}
+
+	if (cpu_has_lsx)
+		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_LSX);
+	if (cpu_has_lasx)
+		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_LASX);
+	if (cpu_has_lbt_x86)
+		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_X86BT);
+	if (cpu_has_lbt_arm)
+		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_ARMBT);
+	if (cpu_has_lbt_mips)
+		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_MIPSBT);
+	if (cpu_has_ptw)
+		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_PTW);
+	if (cpu_has_msgint)
+		kvm->arch.kvm_features |= BIT(KVM_LOONGARCH_VM_FEAT_MSGINT);
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
@@ -131,33 +146,12 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
 {
 	switch (attr->attr) {
 	case KVM_LOONGARCH_VM_FEAT_LSX:
-		if (cpu_has_lsx)
-			return 0;
-		return -ENXIO;
 	case KVM_LOONGARCH_VM_FEAT_LASX:
-		if (cpu_has_lasx)
-			return 0;
-		return -ENXIO;
 	case KVM_LOONGARCH_VM_FEAT_X86BT:
-		if (cpu_has_lbt_x86)
-			return 0;
-		return -ENXIO;
 	case KVM_LOONGARCH_VM_FEAT_ARMBT:
-		if (cpu_has_lbt_arm)
-			return 0;
-		return -ENXIO;
 	case KVM_LOONGARCH_VM_FEAT_MIPSBT:
-		if (cpu_has_lbt_mips)
-			return 0;
-		return -ENXIO;
 	case KVM_LOONGARCH_VM_FEAT_PTW:
-		if (cpu_has_ptw)
-			return 0;
-		return -ENXIO;
 	case KVM_LOONGARCH_VM_FEAT_MSGINT:
-		if (cpu_has_msgint)
-			return 0;
-		return -ENXIO;
 	case KVM_LOONGARCH_VM_FEAT_PMU:
 	case KVM_LOONGARCH_VM_FEAT_PV_IPI:
 	case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
-- 
2.39.3


