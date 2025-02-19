Return-Path: <kvm+bounces-38548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C901FA3B013
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 04:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A52416B45F
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 03:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356481ACED2;
	Wed, 19 Feb 2025 03:38:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911F91A7264;
	Wed, 19 Feb 2025 03:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739936309; cv=none; b=uCS6PUonGcXaMD0oI7QfMbcyUQwBdggVVbgpgYsDCVnMA+lndSoVrCvbsPKLShyux4lOiby76Ws892TCGpwaoyh7+FlQtUpWjsvoQqoo10nyrQP1zuITjL4COwLLKPfgtQ3NU8uZtJALS2ckpMLVqq2+sWAfGu/kk49Go2HiVtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739936309; c=relaxed/simple;
	bh=BGbfX14IVK28Sant9U1lyIamcMNPnTcYHDtGRfbJwJU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mwlclgvFLxj7VZSqWtFJoOu2xpvz4f3h0PtNNrVkIPfRzcBwR7k0fDiZHr3RX+884f3V64xYSV1jZh4XgCNSSssdEW1w2aJQIVKYa9vPYvosVXDaJUrf/Lnlex1sVbUFIAjVhWir8seuiq3D1lWh/MUSabJMylPt1jisdnG4Evo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxQK0xUrVn8Ip6AA--.63580S3;
	Wed, 19 Feb 2025 11:38:26 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxj8UwUrVnRnAbAA--.39192S4;
	Wed, 19 Feb 2025 11:38:25 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] LoongArch: KVM: Fix GPA size issue about VM
Date: Wed, 19 Feb 2025 11:38:23 +0800
Message-Id: <20250219033823.215630-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250219033823.215630-1-maobibo@loongson.cn>
References: <20250219033823.215630-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxj8UwUrVnRnAbAA--.39192S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Physical address space is 48 bit on 3A5000 physical machine, however
it is 47 bit for VM on 3A5000 system. Size of physical address space
of VM is the same with size of virtual user space of physical machine.

Variable cpu_vabits represents user address space, kernel address space
is not include. Here cpu_vabits is to represent size of physical address
space, rather than cpu_vabits - 1.

Also there is strict checking about page fault GPA address, inject
error if it is larger than maximum GPA address of VM.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 6 ++++++
 arch/loongarch/kvm/vm.c   | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index c1e8ec5b941b..d6d09304c66e 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -669,6 +669,12 @@ static int kvm_handle_rdwr_fault(struct kvm_vcpu *vcpu, bool write)
 	struct kvm_run *run = vcpu->run;
 	unsigned long badv = vcpu->arch.badv;
 
+	/* Inject ADE exception if exceed max gpa size */
+	if (unlikely(badv >= vcpu->kvm->arch.gpa_size)) {
+		kvm_queue_exception(vcpu, EXCCODE_ADE, EXSUBCODE_ADEM);
+		return RESUME_GUEST;
+	}
+
 	ret = kvm_handle_mm_fault(vcpu, badv, write);
 	if (ret) {
 		/* Treat as MMIO */
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index b8b3e1972d6e..e2deec6def50 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -48,7 +48,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (kvm_pvtime_supported())
 		kvm->arch.pv_features |= BIT(KVM_FEATURE_STEAL_TIME);
 
-	kvm->arch.gpa_size = BIT(cpu_vabits - 1);
+	/*
+	 * cpu_vabits means user address space, kernel address space is
+	 * not included. GPA size of VM is the same with the size of user
+	 * address space
+	 */
+	kvm->arch.gpa_size = BIT(cpu_vabits);
 	kvm->arch.root_level = CONFIG_PGTABLE_LEVELS - 1;
 	kvm->arch.invalid_ptes[0] = 0;
 	kvm->arch.invalid_ptes[1] = (unsigned long)invalid_pte_table;
-- 
2.39.3


